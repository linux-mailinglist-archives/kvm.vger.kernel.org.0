Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95C236B696C
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 19:02:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231548AbjCLSCh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 14:02:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231552AbjCLSBu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 14:01:50 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBEED4B838;
        Sun, 12 Mar 2023 10:59:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678643949; x=1710179949;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4mB5ntsDAmUDrbd0mlM/U/Hx+OpBXGOhOZaeA1N8YKk=;
  b=cvrY9os2W3pjttqIspX9VvxC+Aw8EqYOL30xCcsxaLmJmaeXpMPxnY9Z
   L3MlKb0AX1fJJXRR7txmbcq+PrUvgu71HR48ZxaiY3qifz+VBzPr3g/jE
   7ETps0Jb7kxSWnnxVxufB4kyA0HQIzSJu2DYlJGBNbp6d/N6YVwrBDSgm
   BU6X4cuhnrQRoPfpMIAz1v3oWj8McaFlcUVSgOSTFMj9XqsHHVGsutZGX
   2b8VxslqHwwHJYM6N71tiItiGxdYH7ek/0xPX2bUD34v2iI7wswcZGkwl
   HpZYIiF6pR9bbrxd5v20UW7xezJhohIr9X6cX3Uop4dxMOWtoLm4gwwKK
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10647"; a="316659924"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="316659924"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 10:58:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10647"; a="742596675"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="742596675"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 10:58:07 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>
Subject: [PATCH v13 057/113] KVM: TDX: MTRR: implement get_mt_mask() for TDX
Date:   Sun, 12 Mar 2023 10:56:21 -0700
Message-Id: <cbfaedb652dad85f4020a2dcd74ac4abb5c14ac5.1678643052.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1678643051.git.isaku.yamahata@intel.com>
References: <cover.1678643051.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

Because TDX virtualize cpuid[0x1].EDX[MTRR: bit 12] to fixed 1, guest TD
thinks MTRR is supported.  Although TDX supports only WB for private GPA,
it's desirable to support MTRR for shared GPA.  As guest access to MTRR
MSRs causes #VE and KVM/x86 tracks the values of MTRR MSRs, the remining
part is to implement get_mt_mask method for TDX for shared GPA.

Pass around shared bit from kvm fault handler to get_mt_mask method so that
it can determine if the gfn is shared or private.  Implement get_mt_mask()
following vmx case for shared GPA and return WB for private GPA.
the existing vmx_get_mt_mask() can't be directly used as CPU state(CR0.CD)
is protected.  GFN passed to kvm_mtrr_check_gfn_range_consistency() should
include shared bit.

Suggested-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
Changes from v11 to V12
- Make common function for VMX and TDX
- pass around shared bit from KVM fault handler to get_mt_mask method
- updated commit message
---
 arch/x86/kvm/mmu/mmu.c     |  7 ++++++-
 arch/x86/kvm/mmu/spte.c    |  5 +++--
 arch/x86/kvm/mmu/spte.h    |  2 +-
 arch/x86/kvm/vmx/common.h  |  2 ++
 arch/x86/kvm/vmx/main.c    | 11 ++++++++++-
 arch/x86/kvm/vmx/tdx.c     | 17 +++++++++++++++++
 arch/x86/kvm/vmx/vmx.c     |  5 +++--
 arch/x86/kvm/vmx/x86_ops.h |  2 ++
 8 files changed, 44 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 6074aa09cd87..fb858594cfec 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4569,7 +4569,12 @@ int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	if (shadow_memtype_mask && kvm_arch_has_noncoherent_dma(vcpu->kvm)) {
 		for ( ; fault->max_level > PG_LEVEL_4K; --fault->max_level) {
 			int page_num = KVM_PAGES_PER_HPAGE(fault->max_level);
-			gfn_t base = gfn_round_for_level(fault->gfn,
+			/*
+			 * kvm_mtrr_check_gfn_range_consistency() requires gfn
+			 * including shared bit.  fault->gfn is masked out with
+			 * shared bit.  So fault->gfn can't be used.
+			 */
+			gfn_t base = gfn_round_for_level(gpa_to_gfn(fault->addr),
 							 fault->max_level);
 
 			if (kvm_mtrr_check_gfn_range_consistency(vcpu, base, page_num))
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index 180907ef26c7..7adb0d00ec4b 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -137,13 +137,14 @@ bool spte_has_volatile_bits(u64 spte)
 
 bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	       const struct kvm_memory_slot *slot,
-	       unsigned int pte_access, gfn_t gfn, kvm_pfn_t pfn,
+	       unsigned int pte_access, gfn_t gfn_including_shared, kvm_pfn_t pfn,
 	       u64 old_spte, bool prefetch, bool can_unsync,
 	       bool host_writable, u64 *new_spte)
 {
 	int level = sp->role.level;
 	u64 spte = SPTE_MMU_PRESENT_MASK;
 	bool wrprot = false;
+	gfn_t gfn = gfn_including_shared & ~kvm_gfn_shared_mask(vcpu->kvm);
 
 	WARN_ON_ONCE(!pte_access && !shadow_present_mask);
 
@@ -191,7 +192,7 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 		spte |= PT_PAGE_SIZE_MASK;
 
 	if (shadow_memtype_mask)
-		spte |= static_call(kvm_x86_get_mt_mask)(vcpu, gfn,
+		spte |= static_call(kvm_x86_get_mt_mask)(vcpu, gfn_including_shared,
 							 kvm_is_mmio_pfn(pfn));
 	if (host_writable)
 		spte |= shadow_host_writable_mask;
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index 41973fe6bc22..62280c4b8c81 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -481,7 +481,7 @@ bool spte_has_volatile_bits(u64 spte);
 
 bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	       const struct kvm_memory_slot *slot,
-	       unsigned int pte_access, gfn_t gfn, kvm_pfn_t pfn,
+	       unsigned int pte_access, gfn_t gfn_including_shared, kvm_pfn_t pfn,
 	       u64 old_spte, bool prefetch, bool can_unsync,
 	       bool host_writable, u64 *new_spte);
 u64 make_huge_page_split_spte(struct kvm *kvm, u64 huge_spte,
diff --git a/arch/x86/kvm/vmx/common.h b/arch/x86/kvm/vmx/common.h
index 235908f3e044..422b24af7fc1 100644
--- a/arch/x86/kvm/vmx/common.h
+++ b/arch/x86/kvm/vmx/common.h
@@ -6,6 +6,8 @@
 
 #include "mmu.h"
 
+u8 __vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio, bool check_cr0_cd);
+
 static inline int __vmx_handle_ept_violation(struct kvm_vcpu *vcpu, gpa_t gpa,
 					     unsigned long exit_qualification)
 {
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 902b57506291..55001b34e1f0 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -3,6 +3,7 @@
 
 #include "x86_ops.h"
 #include "mmu.h"
+#include "common.h"
 #include "vmx.h"
 #include "nested.h"
 #include "mmu.h"
@@ -228,6 +229,14 @@ static void vt_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa,
 	vmx_load_mmu_pgd(vcpu, root_hpa, pgd_level);
 }
 
+static u8 vt_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
+{
+	if (is_td_vcpu(vcpu))
+		return tdx_get_mt_mask(vcpu, gfn, is_mmio);
+
+	return __vmx_get_mt_mask(vcpu, gfn, is_mmio, true);
+}
+
 static int vt_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
 {
 	if (!is_td(kvm))
@@ -348,7 +357,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 
 	.set_tss_addr = vmx_set_tss_addr,
 	.set_identity_map_addr = vmx_set_identity_map_addr,
-	.get_mt_mask = vmx_get_mt_mask,
+	.get_mt_mask = vt_get_mt_mask,
 
 	.get_exit_info = vmx_get_exit_info,
 
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 6ab7580de69c..b7b4ab60f96d 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -5,6 +5,7 @@
 
 #include "capabilities.h"
 #include "x86_ops.h"
+#include "common.h"
 #include "tdx.h"
 #include "vmx.h"
 #include "x86.h"
@@ -350,6 +351,22 @@ int tdx_vm_init(struct kvm *kvm)
 	return 0;
 }
 
+u8 tdx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
+{
+	/* TDX private GPA is always WB. */
+	if (!(gfn & kvm_gfn_shared_mask(vcpu->kvm))) {
+		/* MMIO is only for shared GPA. */
+		WARN_ON_ONCE(is_mmio);
+		return  MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT;
+	}
+
+	/* Drop shared bit as MTRR doesn't know about shared bit. */
+	gfn = kvm_gfn_to_private(vcpu->kvm, gfn);
+
+	/* As TDX enforces CR0.CD to 0, pass check_cr0_cd = false. */
+	return __vmx_get_mt_mask(vcpu, gfn, is_mmio, false);
+}
+
 int tdx_vcpu_create(struct kvm_vcpu *vcpu)
 {
 	/*
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 23321b2208ae..b8d8f7fbeb69 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7568,7 +7568,8 @@ int vmx_vm_init(struct kvm *kvm)
 	return 0;
 }
 
-u8 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
+u8 __vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio,
+		     bool check_cr0_cd)
 {
 	u8 cache;
 
@@ -7596,7 +7597,7 @@ u8 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
 	if (!kvm_arch_has_noncoherent_dma(vcpu->kvm))
 		return (MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT) | VMX_EPT_IPAT_BIT;
 
-	if (kvm_read_cr0(vcpu) & X86_CR0_CD) {
+	if (check_cr0_cd && kvm_read_cr0(vcpu) & X86_CR0_CD) {
 		if (kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_CD_NW_CLEARED))
 			cache = MTRR_TYPE_WRBACK;
 		else
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index b73007586d8b..eba10dabc45f 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -155,6 +155,7 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user *argp);
 int tdx_vcpu_create(struct kvm_vcpu *vcpu);
 void tdx_vcpu_free(struct kvm_vcpu *vcpu);
 void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event);
+u8 tdx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio);
 
 int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
 
@@ -180,6 +181,7 @@ static inline int tdx_vm_ioctl(struct kvm *kvm, void __user *argp) { return -EOP
 static inline int tdx_vcpu_create(struct kvm_vcpu *vcpu) { return -EOPNOTSUPP; }
 static inline void tdx_vcpu_free(struct kvm_vcpu *vcpu) {}
 static inline void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event) {}
+static inline u8 tdx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio) { return 0; }
 
 static inline int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp) { return -EOPNOTSUPP; }
 
-- 
2.25.1

