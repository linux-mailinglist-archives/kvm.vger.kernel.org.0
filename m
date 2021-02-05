Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2A703106D0
	for <lists+kvm@lfdr.de>; Fri,  5 Feb 2021 09:35:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229790AbhBEIfQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Feb 2021 03:35:16 -0500
Received: from mga09.intel.com ([134.134.136.24]:19405 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229785AbhBEIfK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Feb 2021 03:35:10 -0500
IronPort-SDR: wV31C+F5KTLpN1KMbqaMbwu1INtzh9abtbcHh+SxPHe7OZY7MeHzC80u1ENAfznGkvFk6SoxIO
 +2JJlJt9XKsQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9885"; a="181550701"
X-IronPort-AV: E=Sophos;i="5.81,154,1610438400"; 
   d="scan'208";a="181550701"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2021 00:34:08 -0800
IronPort-SDR: +QlTUv1EBq/uWCE3PaVUJ89/K9tsnp5d4/ifptJ5ayNEZzSAX01dVbODi+7/zU4AJqVulqT9VU
 ADP+w8QoeSMQ==
X-IronPort-AV: E=Sophos;i="5.81,154,1610438400"; 
   d="scan'208";a="393761919"
Received: from chenyi-pc.sh.intel.com ([10.239.159.24])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2021 00:34:05 -0800
From:   Chenyi Qiang <chenyi.qiang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 3/5] KVM: MMU: Rename the pkru to pkr
Date:   Fri,  5 Feb 2021 16:37:04 +0800
Message-Id: <20210205083706.14146-4-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210205083706.14146-1-chenyi.qiang@intel.com>
References: <20210205083706.14146-1-chenyi.qiang@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PKRU represents the PKU register utilized in the protection key rights
check for user pages. Protection Keys for Superviosr Pages (PKS) extends
the protection key architecture to cover supervisor pages.

Rename the *pkru* related variables and functions to *pkr* which stands
for both of the PKRU and PKRS. It makes sense because both registers
have the same format. PKS and PKU can also share the same bitmap to
cache the conditions where protection key checks are needed.

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/mmu.h              | 12 ++++++------
 arch/x86/kvm/mmu/mmu.c          | 18 +++++++++---------
 3 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index c8b149d9775a..1909d34cbac8 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -383,7 +383,7 @@ struct kvm_mmu {
 	* with PFEC.RSVD replaced by ACC_USER_MASK from the page tables.
 	* Each domain has 2 bits which are ANDed with AD and WD from PKRU.
 	*/
-	u32 pkru_mask;
+	u32 pkr_mask;
 
 	u64 *pae_root;
 	u64 *lm_root;
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 9c4a9c8e43d9..a77bd20c83f9 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -190,8 +190,8 @@ static inline u8 permission_fault(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 	u32 errcode = PFERR_PRESENT_MASK;
 
 	WARN_ON(pfec & (PFERR_PK_MASK | PFERR_RSVD_MASK));
-	if (unlikely(mmu->pkru_mask)) {
-		u32 pkru_bits, offset;
+	if (unlikely(mmu->pkr_mask)) {
+		u32 pkr_bits, offset;
 
 		/*
 		* PKRU defines 32 bits, there are 16 domains and 2
@@ -199,15 +199,15 @@ static inline u8 permission_fault(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 		* index of the protection domain, so pte_pkey * 2 is
 		* is the index of the first bit for the domain.
 		*/
-		pkru_bits = (vcpu->arch.pkru >> (pte_pkey * 2)) & 3;
+		pkr_bits = (vcpu->arch.pkru >> (pte_pkey * 2)) & 3;
 
 		/* clear present bit, replace PFEC.RSVD with ACC_USER_MASK. */
 		offset = (pfec & ~1) +
 			((pte_access & PT_USER_MASK) << (PFERR_RSVD_BIT - PT_USER_SHIFT));
 
-		pkru_bits &= mmu->pkru_mask >> offset;
-		errcode |= -pkru_bits & PFERR_PK_MASK;
-		fault |= (pkru_bits != 0);
+		pkr_bits &= mmu->pkr_mask >> offset;
+		errcode |= -pkr_bits & PFERR_PK_MASK;
+		fault |= (pkr_bits != 0);
 	}
 
 	return -(u32)fault & errcode;
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 1f96adff8dc4..d22c0813e4b9 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4301,20 +4301,20 @@ static void update_permission_bitmask(struct kvm_vcpu *vcpu,
 * away both AD and WD.  For all reads or if the last condition holds, WD
 * only will be masked away.
 */
-static void update_pkru_bitmask(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
+static void update_pkr_bitmask(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 				bool ept)
 {
 	unsigned bit;
 	bool wp;
 
 	if (ept) {
-		mmu->pkru_mask = 0;
+		mmu->pkr_mask = 0;
 		return;
 	}
 
 	/* PKEY is enabled only if CR4.PKE and EFER.LMA are both set. */
 	if (!kvm_read_cr4_bits(vcpu, X86_CR4_PKE) || !is_long_mode(vcpu)) {
-		mmu->pkru_mask = 0;
+		mmu->pkr_mask = 0;
 		return;
 	}
 
@@ -4348,7 +4348,7 @@ static void update_pkru_bitmask(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 		/* PKRU.WD stops write access. */
 		pkey_bits |= (!!check_write) << 1;
 
-		mmu->pkru_mask |= (pkey_bits & 3) << pfec;
+		mmu->pkr_mask |= (pkey_bits & 3) << pfec;
 	}
 }
 
@@ -4370,7 +4370,7 @@ static void paging64_init_context_common(struct kvm_vcpu *vcpu,
 
 	reset_rsvds_bits_mask(vcpu, context);
 	update_permission_bitmask(vcpu, context, false);
-	update_pkru_bitmask(vcpu, context, false);
+	update_pkr_bitmask(vcpu, context, false);
 	update_last_nonleaf_level(vcpu, context);
 
 	MMU_WARN_ON(!is_pae(vcpu));
@@ -4400,7 +4400,7 @@ static void paging32_init_context(struct kvm_vcpu *vcpu,
 
 	reset_rsvds_bits_mask(vcpu, context);
 	update_permission_bitmask(vcpu, context, false);
-	update_pkru_bitmask(vcpu, context, false);
+	update_pkr_bitmask(vcpu, context, false);
 	update_last_nonleaf_level(vcpu, context);
 
 	context->page_fault = paging32_page_fault;
@@ -4519,7 +4519,7 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu)
 	}
 
 	update_permission_bitmask(vcpu, context, false);
-	update_pkru_bitmask(vcpu, context, false);
+	update_pkr_bitmask(vcpu, context, false);
 	update_last_nonleaf_level(vcpu, context);
 	reset_tdp_shadow_zero_bits_mask(vcpu, context);
 }
@@ -4667,7 +4667,7 @@ void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly,
 	context->mmu_role.as_u64 = new_role.as_u64;
 
 	update_permission_bitmask(vcpu, context, true);
-	update_pkru_bitmask(vcpu, context, true);
+	update_pkr_bitmask(vcpu, context, true);
 	update_last_nonleaf_level(vcpu, context);
 	reset_rsvds_bits_mask_ept(vcpu, context, execonly);
 	reset_ept_shadow_zero_bits_mask(vcpu, context, execonly);
@@ -4738,7 +4738,7 @@ static void init_kvm_nested_mmu(struct kvm_vcpu *vcpu)
 	}
 
 	update_permission_bitmask(vcpu, g_context, false);
-	update_pkru_bitmask(vcpu, g_context, false);
+	update_pkr_bitmask(vcpu, g_context, false);
 	update_last_nonleaf_level(vcpu, g_context);
 }
 
-- 
2.17.1

