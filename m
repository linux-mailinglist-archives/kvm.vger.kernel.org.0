Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59F7F723CFB
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 11:18:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233658AbjFFJSx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 05:18:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231607AbjFFJSw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 05:18:52 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC0F4100;
        Tue,  6 Jun 2023 02:18:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686043130; x=1717579130;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=oCyzogUQkZ9Hsw1ydaA++S/3Q0klQzQu5TB41trYUzw=;
  b=keODg+XNVGjLHFeQNxYxQNREseYFvNbj1iWq+nAJiOZgrkGEnbq5QOnQ
   zlDmbiPowwKE53bEhyEFN8rMDr77yw+K0zwifWRknmhPlSEnCM7sFF6+t
   pLreTGHYsfXrWaVAXI4g8BLZwsJOiAShA9jTWwPersyZTyDgHsJJoCBsc
   IA3M2vM/sa19unKHhP9tfbAhoM2mJ9yqDCRjRHpnwErN5mf91v7oVsfWz
   2fA3FpsxaKJwqo6r7QiTe/C1vdidU8Nu24YBhdx4gIOclF5nM4E3TgrVL
   DBPFhh0BNmF1kdB7L4I2A8zwvk5UuXU5ZbY7tyKRNMHJPX+aE+TOkRuZr
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="341252796"
X-IronPort-AV: E=Sophos;i="6.00,219,1681196400"; 
   d="scan'208";a="341252796"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2023 02:18:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="883263605"
X-IronPort-AV: E=Sophos;i="6.00,219,1681196400"; 
   d="scan'208";a="883263605"
Received: from binbinwu-mobl.ccr.corp.intel.com ([10.249.170.159])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2023 02:18:45 -0700
From:   Binbin Wu <binbin.wu@linux.intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, chao.gao@intel.com,
        kai.huang@intel.com, David.Laight@ACULAB.COM,
        robert.hu@linux.intel.com, binbin.wu@linux.intel.com
Subject: [PATCH v9 0/6] Linear Address Masking (LAM) KVM Enabling
Date:   Tue,  6 Jun 2023 17:18:36 +0800
Message-Id: <20230606091842.13123-1-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

===Feature Introduction===

Linear-address masking (LAM) [1], modifies the checking that is applied to
*64-bit* linear addresses, allowing software to use of the untranslated address
bits for metadata and masks the metadata bits before using them as linear 
addresses to access memory.

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
   value of pointer bit 63 and does not depend on the CPL.
3. LAM doesn't apply to the writes to control registers or MSRs.
4. LAM masking applies before paging, so the faulting linear address in CR2
   doesn't contain the metadata.
5  The guest linear address saved in VMCS doesn't contain metadata.
6. For user mode address, it is possible that 5-level paging and LAM_U48 are both
   set, in this case, the effective usable linear address width is 48.
   (Currently, only LAM_U57 is enabled in Linux kernel. [2])

===LAM KVM Design===
LAM KVM enabling includes the following parts:
- Feature Enumeration
  LAM feature is enumerated by CPUID.7.1:EAX.LAM[bit 26].
  If hardware supports LAM and host doesn't disable it explicitly (e.g. via 
  clearcpuid), LAM feature will be exposed to user VMM.

- CR4 Virtualization
  LAM uses CR4.LAM_SUP (bit 28) to configure LAM on supervisor pointers.
  Add support to allow guests to set the new CR4 control bit for guests to enable
  LAM on supervisor pointers.

- CR3 Virtualization
  LAM uses CR3.LAM_U48 (bit 62) and CR3.LAM_U57 (bit 61) to configure LAM on user
  pointers.
  Add support to allow guests to set two new CR3 non-address control bits for
  guests to enable LAM on user pointers.

- Modified Canonicality Check and Metadata Mask
  When LAM is enabled, 64-bit linear address may be tagged with metadata. Linear
  address should be checked for modified canonicality and untagged in instruction
  emulations and VMExit handlers when LAM is applicable.

LAM support in SGX enclave mode needs additional enabling and is not
included in this patch series.

LAM QEMU patch:
https://lists.nongnu.org/archive/html/qemu-devel/2023-05/msg07843.html

LAM kvm-unit-tests patch:
https://lore.kernel.org/kvm/20230530024356.24870-1-binbin.wu@linux.intel.com/

===Test===
1. Add test cases in kvm-unit-test [3] for LAM, including LAM_SUP and LAM_{U57,U48}.
   For supervisor pointers, the test covers CR4 LAM_SUP bits toggle, Memory/MMIO
   access with tagged pointer, and some special instructions (INVLPG, INVPCID,
   INVVPID), INVVPID cases also used to cover VMX instruction VMExit path.
   For uer pointers, the test covers CR3 LAM bits toggle, Memory/MMIO access with
   tagged pointer.
   MMIO cases are used to trigger instruction emulation path.
   Run the unit test with both LAM feature on/off (i.e. including negative cases).
   Run the unit test in L1 guest with both LAM feature on/off.
2. Run Kernel LAM kselftests [2] in guest, with both EPT=Y/N.
3. Launch a nested guest.

All tests have passed in Simics environment.

[1] Intel ISE https://cdrdv2.intel.com/v1/dl/getContent/671368
    Chapter Linear Address Masking (LAM)
[2] https://lore.kernel.org/all/20230312112612.31869-9-kirill.shutemov@linux.intel.com/
[3] https://lore.kernel.org/kvm/20230530024356.24870-1-binbin.wu@linux.intel.com/

---
Changelog
v8 --> v9:
- Remove unnecessary local variables and some modification of commit message of patch 1. [Chao, David, Kai]
- Add back description about CR4.LAM_SUP setting outside of 64-bit mode in commit message of patch 2. [Kai]
- Clear LAM bits from cr3_ctrl_bits if LAM isn't exposed to the guest in patch 3. [Chao]
- Some comments and commit message changes in patch 4. [Chao]
- Use 'gva_t *' instead of 'u64 *' to avoid explicit type casts in patch 5. [Chao]

v7 --> v8:
- Rebase the patch series on Linux kernel v6.4-rc1, which has all dependencies
  of this patch series.
- Add a cleanup patch to consolidate flags for __linearize().
- Some changes in commit message of patch 2.
- Rewrite the commit message of patch 3 (Thanks Kai Huang for the suggestion).
  Opportunistically use GENMASK_ULL() to define __PT_BASE_ADDR_MASK.
  Opportunistically use kvm_vcpu_is_legal_cr3() to check CR3 in SVM nested code,
  to provide a clear distinction b/t CR3 and GPA checks.
- Change interface untag_addr() to optional version to avoid adding a dummy
  version in SVM in patch 4.
- Verified and confirmed that LAM doesn't apply to the address in descriptor of
  invvpid, drop the untag action for it in patch 5.

v6 --> v7:
- Changes to CR3 virtualization when EPT off
  * Leave LAM bits in root.pgd to force a new root for a CR3+LAM combination. (Sean)
  * Perform GFN calculation from guest CR3/PGD generically by extracting the maximal 
    base address mask. (Sean)
- Remove de-reference of ctxt->vcpu in the emulator. (Sean)
- Fix a bug in v6, which hardcoded "write" to "false" by mistake in linearize(). (Chao Gao)
- Add Chao Gao's reviewed-by in Patch 5.
- Add Xuelian Guo's tested-by in the patch set.
- Separate cleanup patches from the patch set.

v5 --> v6:
Add Patch 2 to fix the check of 64-bit mode.
Add untag_addr() to kvm_x86_ops to hide vendor specific code.
Simplify the LAM canonicality check per Chao's suggestion.
Add cr3_ctrl_bits to kvm_vcpu_arch to simplify cr3 invalidation/extract/mask (Chao Gao)
Extend the patchset scope to include nested virtualization and SGX ENCLS handling.
- Add X86_CR4_LAM_SUP in cr4_fixed1_update for nested vmx. (Chao Gao)
- Add SGX ENCLS VMExit handling
- Add VMX instruction VMExit handling
More descriptions in cover letter.
Add Chao's reviewed-by on Patch 4.
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
  KVM: x86: Consolidate flags for __linearize()
  KVM: x86: Introduce untag_addr() in kvm_x86_ops
  KVM: x86: Untag address when LAM applicable

Robert Hoo (3):
  KVM: x86: Virtualize CR4.LAM_SUP
  KVM: x86: Virtualize CR3.LAM_{U48,U57}
  KVM: x86: Expose LAM feature to userspace VMM

 arch/x86/include/asm/kvm-x86-ops.h |  1 +
 arch/x86/include/asm/kvm_host.h    | 10 +++-
 arch/x86/kvm/cpuid.c               |  2 +-
 arch/x86/kvm/cpuid.h               |  5 ++
 arch/x86/kvm/emulate.c             | 31 +++++++----
 arch/x86/kvm/kvm_emulate.h         |  7 +++
 arch/x86/kvm/mmu.h                 |  5 ++
 arch/x86/kvm/mmu/mmu.c             |  8 ++-
 arch/x86/kvm/mmu/mmu_internal.h    |  1 +
 arch/x86/kvm/mmu/paging_tmpl.h     |  3 +-
 arch/x86/kvm/mmu/spte.h            |  2 +-
 arch/x86/kvm/svm/nested.c          |  4 +-
 arch/x86/kvm/vmx/nested.c          |  6 ++-
 arch/x86/kvm/vmx/sgx.c             |  1 +
 arch/x86/kvm/vmx/vmx.c             | 84 +++++++++++++++++++++++++++++-
 arch/x86/kvm/vmx/vmx.h             |  2 +
 arch/x86/kvm/x86.c                 | 11 +++-
 arch/x86/kvm/x86.h                 |  2 +
 18 files changed, 163 insertions(+), 22 deletions(-)


base-commit: 06b66e050095db599f4f598ee627d1dc9c933018
-- 
2.25.1

