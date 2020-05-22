Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41F7A1DE730
	for <lists+kvm@lfdr.de>; Fri, 22 May 2020 14:52:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729906AbgEVMwZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 May 2020 08:52:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729828AbgEVMwW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 May 2020 08:52:22 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DCB2C08C5C4
        for <kvm@vger.kernel.org>; Fri, 22 May 2020 05:52:21 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id m18so12478303ljo.5
        for <kvm@vger.kernel.org>; Fri, 22 May 2020 05:52:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IOgcgqCC9vufVEgLRTCCT+A1CAPen8qYhFRvNF11ibo=;
        b=vMXewvZJmoyM5SCaX0XPqphO76VM6cnHn4hgVTCNei/lbdbji5H020LlhgziS01FVk
         ui5fyTE3DN5SOMpjPlwpWJF4T1T3myaBBhvJeF6BRkO3VJUQ5ttcYVF95alvXnzFByf7
         rDpU+4IPZBJctELqc8dGxXmK/qF+NC5YUkBb5cMJNI6M3M5hixgVKzguPSNqk3VuZqhb
         6VrNy2Zoq11WU8ahhL9La7ztP+rWpfG+9/L7y9GQ+cSMnhN2HPU/3hJ1fP/S7+BYJQbv
         /+M8HSXsrs6hXmUlvEfejiIAM68rokLuTLh5Uef098bQbtCAN45TllRqnvi7HHdCIe/a
         cyig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IOgcgqCC9vufVEgLRTCCT+A1CAPen8qYhFRvNF11ibo=;
        b=LLRUwhEiAbw5+Cgp121Z7e+XA2PKO6p6Yy+yYHmzy6V98EopenlOBm9dqx0JMw08au
         4YRyz0ttpVku3sjALCO3TRKGSjZoSbjUmWeK6Lr6wnCv896+0dVzZ32Wib2SfSnL6qi1
         Cwzo1yZnlcWTzR0s51IZOscHfGnvGM9S+B95BPBWFqL4mLfthjGRsP69m+nrsgLHMeN8
         B4S7d6oF0DfeMP0PJA2fZ8qzjimZ4KzJ8blbxoY3gdJMESC0TH5DdVPnAJISuHyMLrYq
         Vcd6H2gJVwpKqY400GT7iIZ3jpcm2GFp7A8lQsrfG6n9p7lZO3MF5LWmbK1eUxbQLtHA
         5dXw==
X-Gm-Message-State: AOAM533TIsXJix6l/KSGArW+fk9QX5KKGfI6q7TBAtTumJj/xv1/5sWf
        E4WhOET2wVLp9mxhn3+q/qZDsg==
X-Google-Smtp-Source: ABdhPJzNiybuIasKohIXnOzjLVrsbYy2l+tBimVTV+0SYU6i5hzbDixvDlvvzsJNADlHrv/M1vY0gg==
X-Received: by 2002:a05:651c:2046:: with SMTP id t6mr7212112ljo.227.1590151939895;
        Fri, 22 May 2020 05:52:19 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id t22sm2303742ljk.11.2020.05.22.05.52.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 May 2020 05:52:17 -0700 (PDT)
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
X-Google-Original-From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Received: by box.localdomain (Postfix, from userid 1000)
        id 9C992102046; Fri, 22 May 2020 15:52:19 +0300 (+03)
To:     Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     David Rientjes <rientjes@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Will Drewry <wad@chromium.org>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [RFC 00/16] KVM protected memory extension
Date:   Fri, 22 May 2020 15:51:58 +0300
Message-Id: <20200522125214.31348-1-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

== Background / Problem ==

There are a number of hardware features (MKTME, SEV) which protect guest
memory from some unauthorized host access. The patchset proposes a purely
software feature that mitigates some of the same host-side read-only
attacks.


== What does this set mitigate? ==

 - Host kernel ”accidental” access to guest data (think speculation)

 - Host kernel induced access to guest data (write(fd, &guest_data_ptr, len))

 - Host userspace access to guest data (compromised qemu)

== What does this set NOT mitigate? ==

 - Full host kernel compromise.  Kernel will just map the pages again.

 - Hardware attacks


The patchset is RFC-quality: it works but has known issues that must be
addressed before it can be considered for applying.

We are looking for high-level feedback on the concept.  Some open
questions:

 - This protects from some kernel and host userspace read-only attacks,
   but does not place the host kernel outside the trust boundary. Is it
   still valuable?

 - Can this approach be used to avoid cache-coherency problems with
   hardware encryption schemes that repurpose physical bits?

 - The guest kernel must be modified for this to work.  Is that a deal
   breaker, especially for public clouds?

 - Are the costs of removing pages from the direct map too high to be
   feasible?

== Series Overview ==

The hardware features protect guest data by encrypting it and then
ensuring that only the right guest can decrypt it.  This has the
side-effect of making the kernel direct map and userspace mapping
(QEMU et al) useless.  But, this teaches us something very useful:
neither the kernel or userspace mappings are really necessary for normal
guest operations.

Instead of using encryption, this series simply unmaps the memory. One
advantage compared to allowing access to ciphertext is that it allows bad
accesses to be caught instead of simply reading garbage.

Protection from physical attacks needs to be provided by some other means.
On Intel platforms, (single-key) Total Memory Encryption (TME) provides
mitigation against physical attacks, such as DIMM interposers sniffing
memory bus traffic.

The patchset modifies both host and guest kernel. The guest OS must enable
the feature via hypercall and mark any memory range that has to be shared
with the host: DMA regions, bounce buffers, etc. SEV does this marking via a
bit in the guest’s page table while this approach uses a hypercall.

For removing the userspace mapping, use a trick similar to what NUMA
balancing does: convert memory that belongs to KVM memory slots to
PROT_NONE: all existing entries converted to PROT_NONE with mprotect() and
the newly faulted in pages get PROT_NONE from the updated vm_page_prot.
The new VMA flag -- VM_KVM_PROTECTED -- indicates that the pages in the
VMA must be treated in a special way in the GUP and fault paths. The flag
allows GUP to return the page even though it is mapped with PROT_NONE, but
only if the new GUP flag -- FOLL_KVM -- is specified. Any userspace access
to the memory would result in SIGBUS. Any GUP access without FOLL_KVM
would result in -EFAULT.

Any anonymous page faulted into the VM_KVM_PROTECTED VMA gets removed from
the direct mapping with kernel_map_pages(). Note that kernel_map_pages() only
flushes local TLB. I think it's a reasonable compromise between security and
perfromance.

Zapping the PTE would bring the page back to the direct mapping after clearing.
At least for now, we don't remove file-backed pages from the direct mapping.
File-backed pages could be accessed via read/write syscalls. It adds
complexity.

Occasionally, host kernel has to access guest memory that was not made
shared by the guest. For instance, it happens for instruction emulation.
Normally, it's done via copy_to/from_user() which would fail with -EFAULT
now. We introduced a new pair of helpers: copy_to/from_guest(). The new
helpers acquire the page via GUP, map it into kernel address space with
kmap_atomic()-style mechanism and only then copy the data.

For some instruction emulation copying is not good enough: cmpxchg
emulation has to have direct access to the guest memory. __kvm_map_gfn()
is modified to accommodate the case.

The patchset is on top of v5.7-rc6 plus this patch:

https://lkml.kernel.org/r/20200402172507.2786-1-jimmyassarsson@gmail.com

== Open Issues ==

Unmapping the pages from direct mapping bring a few of issues that have
not rectified yet:

 - Touching direct mapping leads to fragmentation. We need to be able to
   recover from it. I have a buggy patch that aims at recovering 2M/1G page.
   It has to be fixed and tested properly

 - Page migration and KSM is not supported yet.

 - Live migration of a guest would require a new flow. Not sure yet how it
   would look like.

 - The feature interfere with NUMA balancing. Not sure yet if it's
   possible to make them work together.

 - Guests have no mechanism to ensure that even a well-behaving host has
   unmapped its private data.  With SEV, for instance, the guest only has
   to trust the hardware to encrypt a page after the C bit is set in a
   guest PTE.  A mechanism for a guest to query the host mapping state, or
   to constantly assert the intent for a page to be Private would be
   valuable.
Kirill A. Shutemov (16):
  x86/mm: Move force_dma_unencrypted() to common code
  x86/kvm: Introduce KVM memory protection feature
  x86/kvm: Make DMA pages shared
  x86/kvm: Use bounce buffers for KVM memory protection
  x86/kvm: Make VirtIO use DMA API in KVM guest
  KVM: Use GUP instead of copy_from/to_user() to access guest memory
  KVM: mm: Introduce VM_KVM_PROTECTED
  KVM: x86: Use GUP for page walk instead of __get_user()
  KVM: Protected memory extension
  KVM: x86: Enabled protected memory extension
  KVM: Rework copy_to/from_guest() to avoid direct mapping
  x86/kvm: Share steal time page with host
  x86/kvmclock: Share hvclock memory with the host
  KVM: Introduce gfn_to_pfn_memslot_protected()
  KVM: Handle protected memory in __kvm_map_gfn()/__kvm_unmap_gfn()
  KVM: Unmap protected pages from direct mapping

 arch/powerpc/kvm/book3s_64_mmu_hv.c    |   2 +-
 arch/powerpc/kvm/book3s_64_mmu_radix.c |   2 +-
 arch/x86/Kconfig                       |  11 +-
 arch/x86/include/asm/io.h              |   6 +-
 arch/x86/include/asm/kvm_para.h        |   5 +
 arch/x86/include/asm/pgtable_types.h   |   1 +
 arch/x86/include/uapi/asm/kvm_para.h   |   3 +-
 arch/x86/kernel/kvm.c                  |  24 +-
 arch/x86/kernel/kvmclock.c             |   2 +-
 arch/x86/kernel/pci-swiotlb.c          |   3 +-
 arch/x86/kvm/cpuid.c                   |   3 +
 arch/x86/kvm/mmu/mmu.c                 |   6 +-
 arch/x86/kvm/mmu/paging_tmpl.h         |  10 +-
 arch/x86/kvm/x86.c                     |   9 +
 arch/x86/mm/Makefile                   |   2 +
 arch/x86/mm/ioremap.c                  |  16 +-
 arch/x86/mm/mem_encrypt.c              |  50 ----
 arch/x86/mm/mem_encrypt_common.c       |  62 ++++
 arch/x86/mm/pat/set_memory.c           |   8 +
 drivers/virtio/virtio_ring.c           |   4 +
 include/linux/kvm_host.h               |  14 +-
 include/linux/mm.h                     |  12 +
 include/uapi/linux/kvm_para.h          |   5 +-
 mm/gup.c                               |  20 +-
 mm/huge_memory.c                       |  29 +-
 mm/ksm.c                               |   3 +
 mm/memory.c                            |  16 +
 mm/mmap.c                              |   3 +
 mm/mprotect.c                          |   1 +
 mm/rmap.c                              |   4 +
 virt/kvm/async_pf.c                    |   4 +-
 virt/kvm/kvm_main.c                    | 390 +++++++++++++++++++++++--
 32 files changed, 627 insertions(+), 103 deletions(-)
 create mode 100644 arch/x86/mm/mem_encrypt_common.c

-- 
2.26.2

