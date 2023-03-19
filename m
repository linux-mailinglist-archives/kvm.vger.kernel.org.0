Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 868986C0026
	for <lists+kvm@lfdr.de>; Sun, 19 Mar 2023 09:49:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbjCSIti (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 19 Mar 2023 04:49:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbjCSItg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 19 Mar 2023 04:49:36 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8158618158
        for <kvm@vger.kernel.org>; Sun, 19 Mar 2023 01:49:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679215774; x=1710751774;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=VFDmbK9/7FZW1DiqgNgKk59ETMGb+K3bGMW9iKSmsIU=;
  b=Ncz3JUnhaR/P6/aU77ZShEFoVX1D9Ja2YgIUi3OazqOqgpEbOXAFPNW5
   u4DSLt4wk6uJFq67wtz1KJHvO9ZjsOkuu3woP43R89eFrWj1bxw1JJzVl
   MZ/Rde6y/DvuTyvaWJigNeLy5mkYLw0ZR0at5Dy7PMv5Q2kfZZprZwD6Z
   kFxoZlW2U3I/Qx6JUeuPMRNGalK338Xwz0rElk3VaZ11G8OafMb5rL7/z
   yxZZS0uEihlCUY9K1lMHXWDeJXzHbcZN4a4VIdnQMUKWYFvTiAs4ljqlt
   BQqxG1AjZAHPvHysQfC/4nqKWveDzRdloDAXWwHs53xnSbglQg/qENsRx
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10653"; a="424767828"
X-IronPort-AV: E=Sophos;i="5.98,273,1673942400"; 
   d="scan'208";a="424767828"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2023 01:49:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10653"; a="683146191"
X-IronPort-AV: E=Sophos;i="5.98,273,1673942400"; 
   d="scan'208";a="683146191"
Received: from binbinwu-mobl.ccr.corp.intel.com ([10.254.209.111])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2023 01:49:32 -0700
From:   Binbin Wu <binbin.wu@linux.intel.com>
To:     kvm@vger.kernel.org, seanjc@google.com, pbonzini@redhat.com
Cc:     chao.gao@intel.com, robert.hu@linux.intel.com,
        binbin.wu@linux.intel.com
Subject: [PATCH v6 0/7] Linear Address Masking (LAM) KVM Enabling
Date:   Sun, 19 Mar 2023 16:49:20 +0800
Message-Id: <20230319084927.29607-1-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

===Feature Introduction===

Linear-address masking (LAM) [1], modifies the checking that is applied to
*64-bit* linear addresses, allowing software to use of the untranslated address
bits for metadata. 

When the feature is virtualized and exposed to guest, it can be used for efficient
address sanitizers (ASAN) implementation and for optimizations in JITs and virtual
machines.

Regarding which pointer bits are masked and can be used for metadata, LAM has 2
modes:
- LAM_48: metadata bits 62:48, i.e. LAM width of 15.
- LAM_57: metadata bits 62:57, i.e. LAM width of 6.

* For user pointers:
  CR3.LAM_U57 = CR3.LAM_U48 = 0, LAM is off;
  CR3.LAM_U57 = 1, LAM57 is active;
  CR3.LAM_U57 = 0 and CR3.LAM_U48 = 1, LAM48 is active.
* For supervisor pointers: 
  CR4.LAM_SUP =0, LAM is off;
  CR4.LAM_SUP =1 with 5-level paging mode, LAM57 is active;
  CR4.LAM_SUP =1 with 4-level paging mode, LAM48 is active.

The modified LAM canonicality check:
* LAM_S48                : [ 1 ][ metadata ][ 1 ]
                             63               47
* LAM_U48                : [ 0 ][ metadata ][ 0 ]
                             63               47
* LAM_S57                : [ 1 ][ metadata ][ 1 ]
                             63               56
* LAM_U57 + 5-lvl paging : [ 0 ][ metadata ][ 0 ]
                             63               56
* LAM_U57 + 4-lvl paging : [ 0 ][ metadata ][ 0...0 ]
                             63               56..47

Note:
1. LAM applies to only data address, not to instructions.
2. LAM identification of an address as user or supervisor is based solely on the
   value of pointer bit 63 and does not, for the purposes of LAM, depend on the CPL.
3. For user mode address, it is possible that 5-level paging and LAM_U48 are both
   set, in this case, the effective usable linear address width is 48. [2]
4. When VM exit, the page faulting linear address saved in VMCS field is clean,
   i.e. metadata cleared with canonical form.

===LAM KVM Design===
LAM KVM enabling includes the following parts:
- Feature Enumeration
  LAM feature is enumerated by CPUID.7.1:EAX.LAM[bit 26].
  If hardware supports LAM and host doesn't disable it explicitly (e.g. via 
  clearcpuid), LAM feature will be exposed to user VMM.

- CR4 Virtualization
  LAM uses CR4.LAM_SUP (bit 28) to configure LAM masking on supervisor pointers.
  CR4[28] is allowed to be set if vCPU supports LAM, including in nested guest.
  CR4.LAM_SUP is allowed to be set even not in 64-bit mode, but it will not take
  effect since LAM only applies to 64-bit linear address.
  Change of CR4.LAM_SUP bit is intercepted to avoid vmread every time when KVM
  fetches its value, with the expectation that guest won't toggle the bit frequently.
  Hardware is not required to do TLB flush when CR4.LAM_SUP toggled, so KVM doesn't
  need to emulate TLB flush based on it. 

- CR3 Virtualization
  LAM uses CR3.LAM_U48 (bit 62) and CR3.LAM_U57 (bit 61) to configure LAM masking
  for user mode pointers.

  When EPT is on:
  CR3 is fully under control of guest, guest LAM is thus transparent to KVM.

  When EPT is off (shadow paging):
  KVM needs to handle guest CR3.LAM_U48 and CR3.LAM_U57 toggles.
  The two bits don't participate in page table walking. They should be masked to
  get the base address of page table. When shadow paging is used, the two bits 
  should be kept as they are in the shadow CR3.
  To be generic, introduce a field 'cr3_ctrl_bits' in kvm_vcpu_arch to record
  the bits used to control supported features related to CR3 (e.g. LAM).
  - Supported control bits are set to cr3_ctrl_bits.
  - Add kvm_vcpu_is_legal_cr3() to validate CR3, allow setting of the
    control bits for the supported features.
  - cr3_ctrl_bits is used to mask the control bits when calculate the base
    address of page table from mmu::get_guest_pgd().
  - Add kvm_get_active_cr3_ctrl_bits() to get the active control bits to
    form a new guest CR3 (in vmx_load_mmu_pgd()).
  For only control bits toggle cases, it is unnecessary to make new pgd, but just
  make request of load pgd.
  Especially, for ONLY-LAM-bits toggle cases, skip TLB flush since hardware
  is not required to flush TLB when CR3 LAM bits toggled.

- Modified Canonicality Check and Metadata Mask
  When LAM is enabled, 64-bit linear address may be tagged with metadata. Linear
  address should be checked for modified canonicality and untagged (i.e. metadata
  bits should be masked by sign-extending the bit 47 or bit 56) in instruction
  emulations and vmexit handlings when LAM is applicable.

  Introduce untag_addr() to kvm_x86_ops to hide the code, which is vendor specific.
  The interface will be called in x86 instruction emulation path.
  For VMX, LAM version is implemented.
  For SVM, add a dummy version to do nothing, but return the original address.

  Also, vmexit handler changes needed are done inside vmx, including VMX instruction
  and SGX ENCLS.

LAM inside nested guest is supported. 
LAM inside SGX enclave mode is NOT supported by this patch series.

The patch series is based on misc branch of kvm-x86 and one patch from Kiril. [3]
The patch series organized as following:
Patch 1/2: Code Clean up.
Patch 3/4: CR4/CR3 virtualization
Patch 5: Implementation of untag_addr
Patch 6: Untag address when LAM applicable
Patch 7: Expose LAM feature to userspace VMM

===Unit Test===
1. Add a kvm-unit-test [4] for LAM, including LAM_SUP and LAM_{U57,U48}.
   For supervisor mode, this test covers CR4 LAM_SUP bits toggle, Memory/MMIO
   access with tagged pointer, and some special instructions (INVLPG, INVPCID,
   INVVPID), INVVIID cases also used to cover VMX instruction vmexit path.
   For uer mode, this test covers CR3 LAM bits toggle, Memory/MMIO access with
   tagged pointer.
   MMIO cases are used to trigger instruction emulation path.
   Run the unit test with both LAM feature on/off (i.e. including negative cases).
2. Run Kernel LAM kselftests in guest, with both EPT=Y/N.
3. Launch a nested guest.

All tests have passed in Simics environment.

[1] Intel ISE https://cdrdv2.intel.com/v1/dl/getContent/671368
    Chapter Linear Address Masking (LAM)
[2] Thus currently, LAM kernel enabling patch only enables LAM_U57. 
    https://lore.kernel.org/lkml/20230123220500.21077-1-kirill.shutemov@linux.intel.com/ 
[3] https://lore.kernel.org/lkml/20230123220500.21077-4-kirill.shutemov@linux.intel.com/
[4] https://lore.kernel.org/kvm/20230319083732.29458-1-binbin.wu@linux.intel.com/

---
Changelog
v5 --> v6:
Add Patch 2 to fix the check of 64-bit mode.
Add untag_addr() to kvm_x86_ops to hide vendor specific code.
Simplify the LAM canonicality check per Chao's suggestion.
Add cr3_ctrl_bits to kvm_vcpu_arch to simplify cr3 invalidation/extract/mask (Chao Gao)
Extend the patchset scope to include nested virtualization and SGX ENCLS handling.
- Add X86_CR4_LAM_SUP in cr4_fixed1_update for nested vmx. (Chao Gao)
- Add SGX ENCLS vmexit handling
- Add VMX insturction vmexit handling
More descriptions in cover letter.
Add Chao's reviwed-by on Patch 4.
Add more test cases in kvm-unit-test.

v4 --> v5:
Reorder and melt patches surround CR3.LAM bits into Patch 3 of this
version.
Revise Patch 1's subject and description
Drop Patch 3
Use kvm_read_cr4_bits() instead of kvm_read_cr4()
Fix: No need to untag addr when write to msr, it should be legacy canonical check
Rename kvm_is_valid_cr3() --> kvm_vcpu_is_valid_cr3(), and update some call
sites of kvm_vcpu_is_valid_cr3() to use kvm_is_valid_cr3().
Other refactors and Miscs.

v3 --> v4:
Drop unrelated Patch 1 in v3 (Binbin, Sean, Xiaoyao)
Intercept CR4.LAM_SUP instead of pass through to guest (Sean)
Just filter out CR3.LAM_{U48, U57}, instead of all reserved high bits
(Sean, Yuan)
Use existing __canonical_address() helper instead write a new one (Weijiang)
Add LAM handling in KVM emulation (Yu, Yuan)
Add Jingqi's reviwed-by on Patch 7
Rebased to Kirill's latest code, which is 6.2-rc1 base.

v2 --> v3:
As LAM Kernel patches are in tip tree now, rebase to it.
https://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git/

v1 --> v2:
1. Fixes i386-allyesconfig build error on get_pgd(), where
   CR3_HIGH_RSVD_MASK isn't applicable.
   (Reported-by: kernel test robot <lkp@intel.com>)
2. In kvm_set_cr3(), be conservative on skip tlb flush when only LAM bits
   toggles. (Kirill)

Binbin Wu (3):
  KVM: VMX: Use is_64_bit_mode() to check 64-bit mode
  KVM: x86: Introduce untag_addr() in kvm_x86_ops
  KVM: x86: Untag address when LAM applicable

Robert Hoo (4):
  KVM: x86: Explicitly cast ulong to bool in kvm_set_cr3()
  KVM: x86: Virtualize CR4.LAM_SUP
  KVM: x86: Virtualize CR3.LAM_{U48,U57}
  KVM: x86: Expose LAM feature to userspace VMM

 arch/x86/include/asm/kvm-x86-ops.h |  1 +
 arch/x86/include/asm/kvm_host.h    | 15 ++++++-
 arch/x86/kvm/cpuid.c               |  2 +-
 arch/x86/kvm/cpuid.h               |  5 +++
 arch/x86/kvm/emulate.c             | 25 +++++++----
 arch/x86/kvm/mmu.h                 |  5 +++
 arch/x86/kvm/mmu/mmu.c             |  2 +-
 arch/x86/kvm/mmu/paging_tmpl.h     |  2 +-
 arch/x86/kvm/svm/svm.c             |  7 +++
 arch/x86/kvm/vmx/nested.c          | 10 +++--
 arch/x86/kvm/vmx/sgx.c             |  5 ++-
 arch/x86/kvm/vmx/vmx.c             | 69 +++++++++++++++++++++++++++++-
 arch/x86/kvm/vmx/vmx.h             |  2 +
 arch/x86/kvm/x86.c                 | 35 ++++++++++++---
 arch/x86/kvm/x86.h                 |  2 +
 15 files changed, 161 insertions(+), 26 deletions(-)


base-commit: e73ba25fdc241c06ab48a1f708a30305d6036e66
prerequisite-patch-id: cc6bd2338cdf17334431476fbb88f930adeb28ab
-- 
2.25.1

