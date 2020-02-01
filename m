Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C584114FA0B
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2020 19:58:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726670AbgBASw0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 1 Feb 2020 13:52:26 -0500
Received: from mga05.intel.com ([192.55.52.43]:37509 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726354AbgBASw0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 1 Feb 2020 13:52:26 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Feb 2020 10:52:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,390,1574150400"; 
   d="scan'208";a="248075430"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga002.jf.intel.com with ESMTP; 01 Feb 2020 10:52:25 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 00/61] KVM: x86: Introduce KVM cpu caps
Date:   Sat,  1 Feb 2020 10:51:17 -0800
Message-Id: <20200201185218.24473-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce what is effectively a KVM-specific copy of the x86_capabilities
array in boot_cpu_data, kvm_cpu_caps.  kvm_cpu_caps is initialized by
copying boot_cpu_data.x86_capabilities before ->hardware_setup().  It is
then updated by KVM's CPUID logic (both common x86 and VMX/SVM specific)
to adjust the caps to reflect the CPU that KVM will expose to the guest.

Super cool things:
  - Kills off 8 kvm_x86_ops hooks.
  - Eliminates a retpoline from pretty much every page fault, and more
    retpolines throughout KVM.
  - Automagically handles selecting the appropriate eax/ebx/ecx/edx
    registers when updating CPUID feature bits.
  - Adds an auditing capability to double check that the function and
    index of a CPUID entry are correct during reverse CPUID lookup.

This is sort of a v2 of "KVM: x86: Purge kvm_x86_ops->*_supported()"[*],
but only a handful of the 26 patches from that series are carried forward
as is, and this series is obviously much more ambitiuous in scope.  And
unlike that series, there isn't a single patch in here that makes me go
"eww", and the end result is pretty awesome :-)

Quick synopsis:
  1. Refactor the KVM_GET_SUPPORTED_CPUID stack to consolidate code,
     remove crustiness, and set the stage for introducing kvm_cpu_caps.

  2. Introduce cpuid_entry_*() accessors/mutators to automatically
     handle retrieving the correct reg from a CPUID entry, and to audit
     that the entry matches the reserve CPUID lookup entry.  The
     cpuid_entry_*() helpers make moving the code from common x86 to
     vendor code much less risky.

  3. Move CPUID adjustments to vendor code in preparation for kvm_cpu_caps,
     which will be initialized at load time before the kvm_x86_ops hooks
     are ready to be used, i.e. before ->hardware_setup().

  4. Introduce kvm_cpu_caps and move all the CPUID code over to kvm_cpu_caps.

  5. Use kvm_cpu_cap_has() to kill off a bunch of ->*_supported() hooks.

  6. Additional cleanup in tangentially related areas to kill off even more
     ->*_supported() hooks.

  7. Profit!

Some of (6) could maybe be moved to a different series, but there would
likely be a number of minor conflicts.  I dropped as many arbitrary cleanup
patches as I could without letting any of the ->*_supported() hooks live,
and without losing confidence in the correctness of the refactoring.

Tested by verifying the output of KVM_GET_SUPPORTED_CPUID is identical
before and after on every patch on a Haswell and Coffee Lake.  Verified
correctness when hiding features via Qemu (running this version of KVM
in L1), e.g. that UMIP is correctly emulated for L2 when it's hidden from
L1, on relevant patches.

Boot tested and ran kvm-unit-tests at key points, e.g. large page handling.

The big untested pieces are PKU, XSAVES and PT on Intel, and everything AMD.

[*] https://lkml.kernel.org/r/20200129234640.8147-1-sean.j.christopherson@intel.com

Sean Christopherson (61):
  KVM: x86: Return -E2BIG when KVM_GET_SUPPORTED_CPUID hits max entries
  KVM: x86: Refactor loop around do_cpuid_func() to separate helper
  KVM: x86: Simplify handling of Centaur CPUID leafs
  KVM: x86: Clean up error handling in kvm_dev_ioctl_get_cpuid()
  KVM: x86: Check userapce CPUID array size after validating sub-leaf
  KVM: x86: Move CPUID 0xD.1 handling out of the index>0 loop
  KVM: x86: Check for CPUID 0xD.N support before validating array size
  KVM: x86: Warn on zero-size save state for valid CPUID 0xD.N sub-leaf
  KVM: x86: Refactor CPUID 0xD.N sub-leaf entry creation
  KVM: x86: Clean up CPUID 0x7 sub-leaf loop
  KVM: x86: Drop the explicit @index from do_cpuid_7_mask()
  KVM: x86: Drop redundant boot cpu checks on SSBD feature bits
  KVM: x86: Consolidate CPUID array max num entries checking
  KVM: x86: Hoist loop counter and terminator to top of
    __do_cpuid_func()
  KVM: x86: Refactor CPUID 0x4 and 0x8000001d handling
  KVM: x86: Encapsulate CPUID entries and metadata in struct
  KVM: x86: Drop redundant array size check
  KVM: x86: Use common loop iterator when handling CPUID 0xD.N
  KVM: VMX: Add helpers to query Intel PT mode
  KVM: x86: Calculate the supported xcr0 mask at load time
  KVM: x86: Use supported_xcr0 to detect MPX support
  KVM: x86: Make kvm_mpx_supported() an inline function
  KVM: x86: Clear output regs for CPUID 0x14 if PT isn't exposed to
    guest
  KVM: x86: Drop explicit @func param from ->set_supported_cpuid()
  KVM: x86: Use u32 for holding CPUID register value in helpers
  KVM: x86: Introduce cpuid_entry_{get,has}() accessors
  KVM: x86: Introduce cpuid_entry_{change,set,clear}() mutators
  KVM: x86: Refactor cpuid_mask() to auto-retrieve the register
  KVM: x86: Add Kconfig-controlled auditing of reverse CPUID lookups
  KVM: x86: Handle MPX CPUID adjustment in VMX code
  KVM: x86: Handle INVPCID CPUID adjustment in VMX code
  KVM: x86: Handle UMIP emulation CPUID adjustment in VMX code
  KVM: x86: Handle PKU CPUID adjustment in VMX code
  KVM: x86: Handle RDTSCP CPUID adjustment in VMX code
  KVM: x86: Handle Intel PT CPUID adjustment in VMX code
  KVM: x86: Handle GBPAGE CPUID adjustment for EPT in VMX code
  KVM: x86: Refactor handling of XSAVES CPUID adjustment
  KVM: x86: Introduce kvm_cpu_caps to replace runtime CPUID masking
  KVM: SVM: Convert feature updates from CPUID to KVM cpu caps
  KVM: VMX: Convert feature updates from CPUID to KVM cpu caps
  KVM: x86: Move XSAVES CPUID adjust to VMX's KVM cpu cap update
  KVM: x86: Add a helper to check kernel support when setting cpu cap
  KVM: x86: Use KVM cpu caps to mark CR4.LA57 as not-reserved
  KVM: x86: Use KVM cpu caps to track UMIP emulation
  KVM: x86: Fold CPUID 0x7 masking back into __do_cpuid_func()
  KVM: x86: Remove the unnecessary loop on CPUID 0x7 sub-leafs
  KVM: x86: Squash CPUID 0x2.0 insanity for modern CPUs
  KVM: x86: Do host CPUID at load time to mask KVM cpu caps
  KVM: x86: Override host CPUID results with kvm_cpu_caps
  KVM: x86: Set emulated/transmuted feature bits via kvm_cpu_caps
  KVM: x86: Use kvm_cpu_caps to detect Intel PT support
  KVM: x86: Use KVM cpu caps to detect MSR_TSC_AUX virt support
  KVM: VMX: Directly use VMX capabilities helper to detect RDTSCP
    support
  KVM: x86: Check for Intel PT MSR virtualization using KVM cpu caps
  KVM: VMX: Directly query Intel PT mode when refreshing PMUs
  KVM: SVM: Refactor logging of NPT enabled/disabled
  KVM: x86/mmu: Merge kvm_{enable,disable}_tdp() into a common function
  KVM: x86/mmu: Configure max page level during hardware setup
  KVM: x86: Don't propagate MMU lpage support to memslot.disallow_lpage
  KVM: Drop largepages_enabled and its accessor/mutator
  KVM: x86: Move VMX's host_efer to common x86 code

 arch/x86/include/asm/kvm_host.h |  15 +-
 arch/x86/kvm/Kconfig            |  10 +
 arch/x86/kvm/cpuid.c            | 771 +++++++++++++++-----------------
 arch/x86/kvm/cpuid.h            | 123 ++++-
 arch/x86/kvm/mmu/mmu.c          |  22 +-
 arch/x86/kvm/svm.c              | 117 ++---
 arch/x86/kvm/vmx/capabilities.h |  25 +-
 arch/x86/kvm/vmx/nested.c       |   2 +-
 arch/x86/kvm/vmx/pmu_intel.c    |   2 +-
 arch/x86/kvm/vmx/vmx.c          | 125 +++---
 arch/x86/kvm/vmx/vmx.h          |   5 +-
 arch/x86/kvm/x86.c              |  48 +-
 arch/x86/kvm/x86.h              |  10 +-
 include/linux/kvm_host.h        |   2 -
 virt/kvm/kvm_main.c             |  13 -
 15 files changed, 662 insertions(+), 628 deletions(-)

-- 
2.24.1

