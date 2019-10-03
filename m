Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33777CB160
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2019 23:40:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389351AbfJCVkL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Oct 2019 17:40:11 -0400
Received: from mga09.intel.com ([134.134.136.24]:52651 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731058AbfJCVi6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Oct 2019 17:38:58 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Oct 2019 14:38:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,253,1566889200"; 
   d="scan'208";a="186051612"
Received: from linksys13920.jf.intel.com (HELO rpedgeco-DESK5.jf.intel.com) ([10.54.75.11])
  by orsmga008.jf.intel.com with ESMTP; 03 Oct 2019 14:38:57 -0700
From:   Rick Edgecombe <rick.p.edgecombe@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-mm@kvack.org, luto@kernel.org, peterz@infradead.org,
        dave.hansen@intel.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, keescook@chromium.org
Cc:     kristen@linux.intel.com, deneen.t.dock@intel.com,
        Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: [RFC PATCH 00/13] XOM for KVM guest userspace
Date:   Thu,  3 Oct 2019 14:23:47 -0700
Message-Id: <20191003212400.31130-1-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.17.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patchset enables the ability for KVM guests to create execute-only (XO)
memory by utilizing EPT based XO permissions. XO memory is currently supported
on Intel hardware natively for CPU's with PKU, but this enables it on older
platforms, and can support XO for kernel memory as well.

In the guest, this patchset enables XO memory for userspace, using the existing
interface (mprotect PROT_EXEC && !PROT_READ) used for arm64 and x86 PKU HW. A
larger follow on to this enables setting the kernel text as XO, but this is just
the KVM pieces and guest userspace. The yet un-posted QEMU patches to work with
these changes are here:
https://github.com/redgecombe/qemu/

Guest Interface
===============
The way XO is exposed to the guest is by creating a virtual XO permission bit in
the guest page tables.

There are normally four kinds of page table bits:
1. Bits ignored by the hardware
2. Bits that must be 0 or else the hardware throws a RSVD page fault
3. Bits used by the hardware for addresses
4. Bits used by the hardware for permissions and other features

We want to find a bit in the guest page tables to use to mean execute-only
memory so that guest can map the same physical memory with different permissions
simultaneously like other permission bits. We also want the translations to be
done by the hardware, which means we can't use ignored or reserved bits. We also
can't easily re-purpose a feature bit. This leaves address bits. The idea here
is we will take an address bit and re-purpose it as a feature bit.

The first thing we have to do is tell the guest that it can't use the address
bit we are stealing. Luckily there is an existing CPUID leaf that conveys the
number of physical address bits which is already intercepted by KVM, and so we
can reduce it as needed. This puts what was previously the top physical address
bit into what is defined as the "reserved area" of the PTE.

Here is how the PTE would be transformed, where M is the number of physical bits
exposed by the CPUID leaf.

Normal:
|--------------------------------------------------------|
| .. |     RSVD (51 to M)     |   PFN (M-1 to 12)   | .. |
|--------------------------------------------------------|

KVM XO (with M reduced by 1):
|--------------------------------------------------------|
| .. |  RSVD (51 to M+1) | XO |   PFN (M-1 to 12)   | .. |
|--------------------------------------------------------|

So the way XOM is exposed to the guest is by having the VMM provide two aliases
in the guest physical address space for the same memory. The first half has
normal EPT permissions, and the second half has XO permissions. This way the
high PFN bit in the guest page tables acts like an XO permission bit. The VMM
reports to the guest a number of physical address bits that exclude the XO bit,
so from the guest perspective the XO bit is in the region that would be
"reserved", and from the CPU's perspective the bit is still a normal PFN bit.

Backwards Compatibility
-----------------------
Since software would have previously received a #PF with the RSVD error code
set, when the HW encountered any set bits in the region 51 to M, there was some
internal discussion on whether this should have a virtual MSR for the OS to turn
it on only if the OS knows it isn't relying on this behavior for bit M. The
argument against needing an MSR is this blurb from the Intel SDM about reserved
bits:
"Bits reserved in the paging-structure entries are reserved for future
functionality. Software developers should be aware that such bits may be used in
the future and that a paging-structure entry that causes a page-fault exception
on one processor might not do so in the future."

So in the current patchset there is no MSR write required for the guest to turn
on this feature. It will have this behavior whenever qemu is run with
"-cpu +xo".

KVM XO CPUID Feature Bit
------------------------
Althrough this patchset targets KVM, the idea is that this interface might be
implemented by other hypervisors. Especially since as it appears especially like
a normal CPU feature it would be nice if there was a single CPUID bit to check
for different implementations like there often is for real CPU features. In the
past there was a proposal for "generic leaves" [1], where regions are assigned
for VMMs to define, but where the behavior will not change across VMMs. This
patchset follows this proposal and defines a bit in a new leaf to expose the
presense of the above described behavior. I'm hoping to get some suggestions on
the right way to expose it by this RFC.

Injecting Page Faults
---------------------
When there is an attempt to read memory from an XO address range, a #PF is
injected into the guest with P=1, W/R=0, RSVD=0, I/D=0. When there is an attempt
to write, it is P=1, W/R=1, RSVD=0, I/D=0.

Implementation
==============
In KVM this patchset adds a new memslot, KVM_MEM_EXECONLY, which maps memory as
execute-only via EPT permissions, and will inject a PF to the guest if there is
a violation. The x86 emulator is also made aware of XO memory perissions, and
virtualized features that act on PFN's are made aware that VTs view of the GFN
includes the permission bit (and so needs to be masked to get the guests view of
the PFN).

QEMU manipulates the physical address bits exposed to the guest and adds an
extra KVM_MEM_EXECONLY memslot that points to the same userspace memory in the
XO range for every memslot added in the normal range.

The violating linear address is determined from the EPT feature that provides
the linear address of the violation if availible, and if not availible emulates
the violating instruction to determine which linear address to use in the
injected fault.

Performance
===========
The performance impact is not fully characterized yet. In the larger patchset
that sets kernel text to be XO, there wasn't any measurable impact compiling
the kernel. The hope is that there will not be a large impact, but more testing
is needed.

Status
======
Regression testing is still needed including the nested virtualization case and
impact of XO in the other memslot address spaces. This is based on 5.3.

[1] https://lwn.net/Articles/301888/


Rick Edgecombe (13):
  kvm: Enable MTRR to work with GFNs with perm bits
  kvm: Add support for X86_FEATURE_KVM_XO
  kvm: Add XO memslot type
  kvm, vmx: Add support for gva exit qualification
  kvm: Add #PF injection for KVM XO
  kvm: Add KVM_CAP_EXECONLY_MEM
  kvm: Add docs for KVM_CAP_EXECONLY_MEM
  x86/boot: Rename USE_EARLY_PGTABLE_L5
  x86/cpufeature: Add detection of KVM XO
  x86/mm: Add NR page bit for KVM XO
  x86, ptdump: Add NR bit to page table dump
  mmap: Add XO support for KVM XO
  x86/Kconfig: Add Kconfig for KVM based XO

 Documentation/virt/kvm/api.txt                | 16 ++--
 arch/x86/Kconfig                              | 13 +++
 arch/x86/boot/compressed/misc.h               |  2 +-
 arch/x86/include/asm/cpufeature.h             |  7 +-
 arch/x86/include/asm/cpufeatures.h            |  5 +-
 arch/x86/include/asm/disabled-features.h      |  3 +-
 arch/x86/include/asm/kvm_host.h               |  7 ++
 arch/x86/include/asm/pgtable_32_types.h       |  1 +
 arch/x86/include/asm/pgtable_64_types.h       | 30 ++++++-
 arch/x86/include/asm/pgtable_types.h          | 13 +++
 arch/x86/include/asm/required-features.h      |  3 +-
 arch/x86/include/asm/sparsemem.h              |  4 +-
 arch/x86/include/asm/vmx.h                    |  1 +
 arch/x86/include/uapi/asm/kvm_para.h          |  3 +
 arch/x86/kernel/cpu/common.c                  |  7 +-
 arch/x86/kernel/head64.c                      | 43 +++++++++-
 arch/x86/kvm/cpuid.c                          |  7 ++
 arch/x86/kvm/cpuid.h                          |  1 +
 arch/x86/kvm/mmu.c                            | 79 +++++++++++++++++--
 arch/x86/kvm/mtrr.c                           |  8 ++
 arch/x86/kvm/paging_tmpl.h                    | 29 +++++--
 arch/x86/kvm/svm.c                            |  6 ++
 arch/x86/kvm/vmx/vmx.c                        |  6 ++
 arch/x86/kvm/x86.c                            |  9 ++-
 arch/x86/mm/dump_pagetables.c                 |  6 +-
 arch/x86/mm/init.c                            |  3 +
 arch/x86/mm/kasan_init_64.c                   |  2 +-
 include/uapi/linux/kvm.h                      |  2 +
 mm/mmap.c                                     | 30 +++++--
 .../arch/x86/include/asm/disabled-features.h  |  3 +-
 tools/include/uapi/linux/kvm.h                |  1 +
 virt/kvm/kvm_main.c                           | 15 +++-
 32 files changed, 322 insertions(+), 43 deletions(-)

-- 
2.17.1

