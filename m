Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FBF83E8E17
	for <lists+kvm@lfdr.de>; Wed, 11 Aug 2021 12:07:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237069AbhHKKHz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Aug 2021 06:07:55 -0400
Received: from mga09.intel.com ([134.134.136.24]:49605 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236961AbhHKKHo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Aug 2021 06:07:44 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10072"; a="215083933"
X-IronPort-AV: E=Sophos;i="5.84,311,1620716400"; 
   d="scan'208";a="215083933"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2021 03:07:21 -0700
X-IronPort-AV: E=Sophos;i="5.84,311,1620716400"; 
   d="scan'208";a="484785720"
Received: from chenyi-pc.sh.intel.com ([10.239.159.88])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2021 03:07:18 -0700
From:   Chenyi Qiang <chenyi.qiang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Chenyi Qiang <chenyi.qiang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v5 4/7] KVM: MMU: Rename the pkru to pkr
Date:   Wed, 11 Aug 2021 18:11:23 +0800
Message-Id: <20210811101126.8973-5-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210811101126.8973-1-chenyi.qiang@intel.com>
References: <20210811101126.8973-1-chenyi.qiang@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PKRU represents the PKU register utilized in the protection key rights
check for user pages. Protection Keys for Superviosr Pages (PKS) extends
the protection key architecture to cover supervisor pages.

Rename the *pkru* related variables and functions to *pkr* which stands
for both of the PKRU and PKRS. It makes sense because PKS and PKU each
have:
 - a single control register (PKRU and PKRS)
 - the same number of keys (16 in total)
 - the same format in control registers (Access and Write disable bits)

PKS and PKU can also share the same bitmap pkr_mask cache conditions
where protection key checks are neede, because they can share almost the
same requirements for PK restrictions to cause a fault, except they
focus on different pages (supervisor and user pages).

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/mmu.h              | 12 ++++++------
 arch/x86/kvm/mmu/mmu.c          | 10 +++++-----
 3 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index c2bcb88781b3..3d55aca9167b 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -444,7 +444,7 @@ struct kvm_mmu {
 	* with PFEC.RSVD replaced by ACC_USER_MASK from the page tables.
 	* Each domain has 2 bits which are ANDed with AD and WD from PKRU.
 	*/
-	u32 pkru_mask;
+	u32 pkr_mask;
 
 	u64 *pae_root;
 	u64 *pml4_root;
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 83e6c6965f1e..5e94f6a90e80 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -200,8 +200,8 @@ static inline u8 permission_fault(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 	u32 errcode = PFERR_PRESENT_MASK;
 
 	WARN_ON(pfec & (PFERR_PK_MASK | PFERR_RSVD_MASK));
-	if (unlikely(mmu->pkru_mask)) {
-		u32 pkru_bits, offset;
+	if (unlikely(mmu->pkr_mask)) {
+		u32 pkr_bits, offset;
 
 		/*
 		* PKRU defines 32 bits, there are 16 domains and 2
@@ -209,15 +209,15 @@ static inline u8 permission_fault(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
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
index 66f7f5bc3482..49fd2dc98cc6 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4443,13 +4443,13 @@ static void update_permission_bitmask(struct kvm_mmu *mmu, bool ept)
 * away both AD and WD.  For all reads or if the last condition holds, WD
 * only will be masked away.
 */
-static void update_pkru_bitmask(struct kvm_mmu *mmu)
+static void update_pkr_bitmask(struct kvm_mmu *mmu)
 {
 	unsigned bit;
 	bool wp;
 
 	if (!is_cr4_pke(mmu)) {
-		mmu->pkru_mask = 0;
+		mmu->pkr_mask = 0;
 		return;
 	}
 
@@ -4483,7 +4483,7 @@ static void update_pkru_bitmask(struct kvm_mmu *mmu)
 		/* PKRU.WD stops write access. */
 		pkey_bits |= (!!check_write) << 1;
 
-		mmu->pkru_mask |= (pkey_bits & 3) << pfec;
+		mmu->pkr_mask |= (pkey_bits & 3) << pfec;
 	}
 }
 
@@ -4495,7 +4495,7 @@ static void reset_guest_paging_metadata(struct kvm_vcpu *vcpu,
 
 	reset_rsvds_bits_mask(vcpu, mmu);
 	update_permission_bitmask(mmu, false);
-	update_pkru_bitmask(mmu);
+	update_pkr_bitmask(mmu);
 }
 
 static void paging64_init_context(struct kvm_mmu *context)
@@ -4763,7 +4763,7 @@ void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly,
 	context->direct_map = false;
 
 	update_permission_bitmask(context, true);
-	update_pkru_bitmask(context);
+	update_pkr_bitmask(context);
 	reset_rsvds_bits_mask_ept(vcpu, context, execonly);
 	reset_ept_shadow_zero_bits_mask(vcpu, context, execonly);
 }
-- 
2.17.1

