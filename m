Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A207377E4
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2019 17:31:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729366AbfFFP3y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jun 2019 11:29:54 -0400
Received: from mga01.intel.com ([192.55.52.88]:53940 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729358AbfFFP3y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jun 2019 11:29:54 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Jun 2019 08:29:53 -0700
X-ExtLoop1: 1
Received: from unknown (HELO local-michael-cet-test.sh.intel.com) ([10.239.159.128])
  by fmsmga007.fm.intel.com with ESMTP; 06 Jun 2019 08:29:51 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, mst@redhat.com, rkrcmar@redhat.com,
        jmattson@google.com, yu.c.zhang@intel.com
Cc:     Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v3 0/9] Enable Sub-page Write Protection Support
Date:   Thu,  6 Jun 2019 23:28:03 +0800
Message-Id: <20190606152812.13141-1-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

EPT-Based Sub-Page write Protection(SPP)is a HW capability which
allows Virtual Machine Monitor(VMM) to specify write-permission for
guest physical memory at a sub-page(128 byte) granularity. When this
capability is enabled, the CPU enforces write-access check for
sub-pages within a 4KB page.

The feature is targeted to provide fine-grained memory protection
for usages such as device virtualization, memory check-point and
VM introspection etc.

SPP is active when the "sub-page write protection" (bit 23) is 1 in
Secondary VM-Execution Controls. The feature is backed with a Sub-Page
Permission Table(SPPT), SPPT is referenced via a 64-bit control field
called Sub-Page Permission Table Pointer (SPPTP) which contains a
4K-aligned physical address.

Right now, only 4KB physical pages are supported for SPP. To enable SPP
for certain physical page, we need to first make the physical page
write-protected, then set bit 61 of the corresponding EPT leaf entry. 
While HW walks EPT, if bit 61 is set, it traverses SPPT with the guset
physical address to find out the sub-page permissions at the leaf entry.
If the corresponding bit is set, write to sub-page is permitted,
otherwise, SPP induced EPT vilation is generated.

Please refer to the SPP introduction document in this patch set and Intel SDM
for details:

Intel SDM:
https://software.intel.com/sites/default/files/managed/39/c5/325462-sdm-vol-1-2abcd-3abcd.pdf

Previous patch:
https://lkml.org/lkml/2018/11/30/605

Patch 1: Introduction to SPP.
Patch 2: Add SPP related flags and control bits.
Patch 3: Functions for SPPT setup.
Patch 4: Add SPP access bitmaps for memslots.
Patch 5: Low level implementation of SPP operations.
Patch 6: Implement User space access IOCTLs.
Patch 7: Handle SPP induced VMExit and EPT violation.
Patch 8: Enable lazy mode SPPT setup.
Patch 9: Handle memory remapping and reclaim.


Change logs:

V2 - V3:                                                                
 1. Rebased patches to kernel 5.1 release                                
 2. Deferred SPPT setup to EPT fault handler if the page is not available
    while set_subpage() is being called.                                 
 3. Added init IOCTL to reduce extra cost if SPP is not used.            
 4. Refactored patch structure, cleaned up cross referenced functions.    
 5. Added code to deal with memory swapping/migration/shrinker cases.    
                                                                           
V2 - V1:                                                                
 1. Rebased to 4.20-rc1                                                  
 2. Move VMCS change to a separated patch.                               
 3. Code refine and Bug fix 


Yang Weijiang (9):
  Documentation: Introduce EPT based Subpage Protection
  KVM: VMX: Add control flags for SPP enabling
  KVM: VMX: Implement functions for SPPT paging setup
  KVM: VMX: Introduce SPP access bitmap and operation functions
  KVM: VMX: Add init/set/get functions for SPP
  KVM: VMX: Introduce SPP user-space IOCTLs
  KVM: VMX: Handle SPP induced vmexit and page fault
  KVM: MMU: Enable Lazy mode SPPT setup
  KVM: MMU: Handle host memory remapping and reclaim

 Documentation/virtual/kvm/spp_kvm.txt | 216 ++++++++++++
 arch/x86/include/asm/cpufeatures.h    |   1 +
 arch/x86/include/asm/kvm_host.h       |  26 +-
 arch/x86/include/asm/vmx.h            |  10 +
 arch/x86/include/uapi/asm/vmx.h       |   2 +
 arch/x86/kernel/cpu/intel.c           |   4 +
 arch/x86/kvm/mmu.c                    | 469 ++++++++++++++++++++++++++
 arch/x86/kvm/mmu.h                    |   1 +
 arch/x86/kvm/vmx/capabilities.h       |   5 +
 arch/x86/kvm/vmx/vmx.c                | 138 ++++++++
 arch/x86/kvm/x86.c                    | 141 ++++++++
 include/linux/kvm_host.h              |   9 +
 include/uapi/linux/kvm.h              |  17 +
 13 files changed, 1038 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/virtual/kvm/spp_kvm.txt

-- 
2.17.2

