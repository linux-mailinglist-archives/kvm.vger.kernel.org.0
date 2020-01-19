Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20012141BD1
	for <lists+kvm@lfdr.de>; Sun, 19 Jan 2020 05:01:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726396AbgASEAY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 18 Jan 2020 23:00:24 -0500
Received: from mga14.intel.com ([192.55.52.115]:62796 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725980AbgASEAX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 18 Jan 2020 23:00:23 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Jan 2020 20:00:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,336,1574150400"; 
   d="scan'208";a="214910453"
Received: from local-michael-cet-test.sh.intel.com ([10.239.159.128])
  by orsmga007.jf.intel.com with ESMTP; 18 Jan 2020 20:00:20 -0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, jmattson@google.com,
        sean.j.christopherson@intel.com
Cc:     yu.c.zhang@linux.intel.com, alazar@bitdefender.com,
        edwin.zhai@intel.com, Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v11 00/10] Enable Sub-Page Write Protection Support
Date:   Sun, 19 Jan 2020 12:04:57 +0800
Message-Id: <20200119040507.23113-1-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

EPT-Based Sub-Page write Protection(SPP) allows Virtual Machine Monitor(VMM)
specify write-permission for guest physical memory at a sub-page(128 byte)
granularity. When SPP works, HW enforces write-access check for sub-pages
within a protected 4KB page.

The feature targets to provide fine-grained memory protection for
usages such as memory guard and VM introspection etc.

SPP is active when the "sub-page write protection" (bit 23) is 1 in
Secondary VM-Execution Controls. The feature is backed with a Sub-Page
Permission Table(SPPT), and subpage permission vector is stored in the
leaf entry of SPPT. The root page is referenced via a Sub-Page Permission
Table Pointer (SPPTP) in VMCS.

To enable SPP for guest memory, the guest page should be first mapped
to a 4KB EPT entry, then set SPP bit 61 of the corresponding entry. 
While HW walks EPT, it traverses SPPT with the gpa to look up the sub-page
permission vector within SPPT leaf entry. If the corresponding bit is set,
write to sub-page is permitted, otherwise, SPP induced EPT violation is generated.

This patch serial passed SPP function test and selftest on Ice-Lake platform.

Please refer to the SPP introduction document in this patch set and
Intel SDM for details:

Intel SDM:
https://software.intel.com/sites/default/files/managed/39/c5/325462-sdm-vol-1-2abcd-3abcd.pdf

Patch 1: Documentation for SPP and related API.
Patch 2: Add control flags for Sub-Page Protection(SPP).
Patch 3: Add SPP Table setup functions.
Patch 4: Add functions to create/destroy SPP bitmap block.
Patch 5: Introduce user-space SPP IOCTLs.
Patch 6: Set up SPP paging table at vmentry/vmexit.
Patch 7: Enable Lazy mode SPP protection.
Patch 8: Handle SPP protected pages when VM memory changes.
Patch 9: Add SPP protection check in emulation case.
Patch 10: SPP selftest.

Change logs:
v10 -> v11
  1. Refactored patches Per Sean's review feedback.
  2. Added HW/KVM capabilities check before initializes SPP.
  3. Combined a few functions having similar usages.
  4. Removed unecessary functions in kvm_x86_ops.
  5. Other code fix according to testing.

v9 ->v10
  1. Cleared SPP active flag on VM resetting.
  2. Added trancepoints on subpage setup and SPP induced vmexits.
  3. Fixed a few code issues reported by Intel test robot.

v8 ->v9:
  1. Added SPP protection check in pte prefetch case.
  2. Flushed EPT rmap to remove existing mappings of the target gfns.
  3. Modified documentation to reflect recent changes.
  4. Other minor code refactor.

v7 -> v8:
  1. Changed ioctl interface definition per Paolo's comments.
  2. Replaced SPP_INIT ioctl funciton with KVM_ENABLE_CAP.
  3. Removed SPP bit from X86 feature word.
  4. Returned instruction length to user-space when SPP induced EPT
     violation happens, this is to provide flexibility to use SPP,
     revert write or track write.
  5. Modified selftest application and added into this serial.
  6. Simplified SPP permission vector check.
  7. Moved spp.c and spp.h to kvm/mmu folder.
  8. Other code fix according to Paolo's feedback and testing.

v6 -> v7:
  1. Configured all available protected pages once SPP induced vmexit
     happens since there's no PRESENT bit in SPPT leaf entry.
  2. Changed SPP protection check flow in tdp_page_fault().
  3. Code refactor and minior fixes.

v5 -> v6:
  1. Added SPP protection patch for emulation cases per Jim's review.
  2. Modified documentation and added API description per Jim's review.
  3. Other minior changes suggested by Jim.

v4 -> v5:
  1. Enable SPP support for Hugepage(1GB/2MB) to extend application.
  2. Make SPP miss vm-exit handler as the unified place to set up SPPT.
  3. If SPP protected pages are access-tracked or dirty-page-tracked,
     store SPP flag in reserved address bit, restore it in
     fast_page_fault() handler.
  4. Move SPP specific functions to vmx/spp.c and vmx/spp.h
  5. Rebased code to kernel v5.3
  6. Other change suggested by KVM community.
  
v3 -> v4:
  1. Modified documentation to make it consistent with patches.
  2. Allocated SPPT root page in init_spp() instead of vmx_set_cr3() to
     avoid SPPT miss error.
  3. Added back co-developers and sign-offs.

v2 -> v3:                                                                
  1. Rebased patches to kernel 5.1 release                                
  2. Deferred SPPT setup to EPT fault handler if the page is not
     available while set_subpage() is being called.
  3. Added init IOCTL to reduce extra cost if SPP is not used.
  4. Refactored patch structure, cleaned up cross referenced functions.
  5. Added code to deal with memory swapping/migration/shrinker cases.

v2 -> v1:
  1. Rebased to 4.20-rc1
  2. Move VMCS change to a separated patch.
  3. Code refine and Bug fix 




Yang Weijiang (10):
  Documentation: Add EPT based Subpage Protection and related APIs
  mmu: spp: Implement SPPT setup functions
  mmu: spp: Implement functions to {get|set}_subpage permission
  x86: spp: Introduce user-space SPP IOCTLs
  vmx: spp: Handle SPP induced vmexit and EPT violation
  mmu: spp: Enable Lazy mode SPP protection
  mmu: spp: Re-enable SPP protection when EPT mapping changes
  x86: spp: Add SPP protection check in instruction emulation
  vmx: spp: Initialize SPP bitmap and SPP protection
  kvm: selftests: selftest for Sub-Page protection

 Documentation/virt/kvm/api.txt                |  39 ++
 Documentation/virtual/kvm/spp_kvm.txt         | 179 +++++
 arch/x86/include/asm/kvm_host.h               |  11 +-
 arch/x86/include/asm/vmx.h                    |  10 +
 arch/x86/include/uapi/asm/vmx.h               |   2 +
 arch/x86/kvm/mmu.h                            |   2 +
 arch/x86/kvm/mmu/mmu.c                        | 117 +++-
 arch/x86/kvm/mmu/spp.c                        | 614 ++++++++++++++++++
 arch/x86/kvm/mmu/spp.h                        |  38 ++
 arch/x86/kvm/trace.h                          |  66 ++
 arch/x86/kvm/vmx/capabilities.h               |   5 +
 arch/x86/kvm/vmx/vmx.c                        | 108 +++
 arch/x86/kvm/x86.c                            | 135 ++++
 include/uapi/linux/kvm.h                      |  17 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 tools/testing/selftests/kvm/lib/kvm_util.c    |   1 +
 tools/testing/selftests/kvm/x86_64/spp_test.c | 235 +++++++
 17 files changed, 1573 insertions(+), 7 deletions(-)
 create mode 100644 Documentation/virtual/kvm/spp_kvm.txt
 create mode 100644 arch/x86/kvm/mmu/spp.c
 create mode 100644 arch/x86/kvm/mmu/spp.h
 create mode 100644 tools/testing/selftests/kvm/x86_64/spp_test.c

-- 
2.17.2

