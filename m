Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D25FF23E97D
	for <lists+kvm@lfdr.de>; Fri,  7 Aug 2020 10:46:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727969AbgHGIqx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Aug 2020 04:46:53 -0400
Received: from mga06.intel.com ([134.134.136.31]:65145 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727942AbgHGIqw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Aug 2020 04:46:52 -0400
IronPort-SDR: Ho8c5/inTtiglyfFSms6YuQHKBnVrqPkBYlY2xhraCxBH8xqztePaP+et7e+CWCT2C/C8NnYF9
 ucZpBWn/aPrA==
X-IronPort-AV: E=McAfee;i="6000,8403,9705"; a="214565728"
X-IronPort-AV: E=Sophos;i="5.75,445,1589266800"; 
   d="scan'208";a="214565728"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2020 01:46:51 -0700
IronPort-SDR: /TZ5g8CQaDHr4HC4/eVJkBX63K2XceJxFpluqUucB6QUnqIuouIxsd+GP+UxTTrO5zq9FF3i4A
 f3TRswJ5WfLQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,445,1589266800"; 
   d="scan'208";a="307317163"
Received: from chenyi-pc.sh.intel.com ([10.239.159.72])
  by orsmga002.jf.intel.com with ESMTP; 07 Aug 2020 01:46:49 -0700
From:   Chenyi Qiang <chenyi.qiang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC 3/7] KVM: MMU: Rename the pkru to pkr
Date:   Fri,  7 Aug 2020 16:48:37 +0800
Message-Id: <20200807084841.7112-4-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200807084841.7112-1-chenyi.qiang@intel.com>
References: <20200807084841.7112-1-chenyi.qiang@intel.com>
Sender: kvm-owner@vger.kernel.org
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

Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/mmu.h              | 12 ++++++------
 arch/x86/kvm/mmu/mmu.c          | 18 +++++++++---------
 3 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index be5363b21540..6b739d0d1c97 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -427,7 +427,7 @@ struct kvm_mmu {
 	* with PFEC.RSVD replaced by ACC_USER_MASK from the page tables.
 	* Each domain has 2 bits which are ANDed with AD and WD from PKRU.
 	*/
-	u32 pkru_mask;
+	u32 pkr_mask;
 
 	u64 *pae_root;
 	u64 *lm_root;
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 444bb9c54548..0c2fdf0abf22 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -193,8 +193,8 @@ static inline u8 permission_fault(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 	u32 errcode = PFERR_PRESENT_MASK;
 
 	WARN_ON(pfec & (PFERR_PK_MASK | PFERR_RSVD_MASK));
-	if (unlikely(mmu->pkru_mask)) {
-		u32 pkru_bits, offset;
+	if (unlikely(mmu->pkr_mask)) {
+		u32 pkr_bits, offset;
 
 		/*
 		* PKRU defines 32 bits, there are 16 domains and 2
@@ -202,15 +202,15 @@ static inline u8 permission_fault(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
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
index 6d6a0ae7800c..481442f5e27a 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4716,20 +4716,20 @@ static void update_permission_bitmask(struct kvm_vcpu *vcpu,
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
 
@@ -4763,7 +4763,7 @@ static void update_pkru_bitmask(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 		/* PKRU.WD stops write access. */
 		pkey_bits |= (!!check_write) << 1;
 
-		mmu->pkru_mask |= (pkey_bits & 3) << pfec;
+		mmu->pkr_mask |= (pkey_bits & 3) << pfec;
 	}
 }
 
@@ -4785,7 +4785,7 @@ static void paging64_init_context_common(struct kvm_vcpu *vcpu,
 
 	reset_rsvds_bits_mask(vcpu, context);
 	update_permission_bitmask(vcpu, context, false);
-	update_pkru_bitmask(vcpu, context, false);
+	update_pkr_bitmask(vcpu, context, false);
 	update_last_nonleaf_level(vcpu, context);
 
 	MMU_WARN_ON(!is_pae(vcpu));
@@ -4815,7 +4815,7 @@ static void paging32_init_context(struct kvm_vcpu *vcpu,
 
 	reset_rsvds_bits_mask(vcpu, context);
 	update_permission_bitmask(vcpu, context, false);
-	update_pkru_bitmask(vcpu, context, false);
+	update_pkr_bitmask(vcpu, context, false);
 	update_last_nonleaf_level(vcpu, context);
 
 	context->page_fault = paging32_page_fault;
@@ -4925,7 +4925,7 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu)
 	}
 
 	update_permission_bitmask(vcpu, context, false);
-	update_pkru_bitmask(vcpu, context, false);
+	update_pkr_bitmask(vcpu, context, false);
 	update_last_nonleaf_level(vcpu, context);
 	reset_tdp_shadow_zero_bits_mask(vcpu, context);
 }
@@ -5032,7 +5032,7 @@ void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly,
 	context->mmu_role.as_u64 = new_role.as_u64;
 
 	update_permission_bitmask(vcpu, context, true);
-	update_pkru_bitmask(vcpu, context, true);
+	update_pkr_bitmask(vcpu, context, true);
 	update_last_nonleaf_level(vcpu, context);
 	reset_rsvds_bits_mask_ept(vcpu, context, execonly);
 	reset_ept_shadow_zero_bits_mask(vcpu, context, execonly);
@@ -5103,7 +5103,7 @@ static void init_kvm_nested_mmu(struct kvm_vcpu *vcpu)
 	}
 
 	update_permission_bitmask(vcpu, g_context, false);
-	update_pkru_bitmask(vcpu, g_context, false);
+	update_pkr_bitmask(vcpu, g_context, false);
 	update_last_nonleaf_level(vcpu, g_context);
 }
 
-- 
2.17.1

