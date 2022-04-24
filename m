Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FEFA50D10A
	for <lists+kvm@lfdr.de>; Sun, 24 Apr 2022 12:16:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239071AbiDXKTM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 24 Apr 2022 06:19:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239007AbiDXKTB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 24 Apr 2022 06:19:01 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58CA04ECE6;
        Sun, 24 Apr 2022 03:16:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650795361; x=1682331361;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=AG6I0vol4fbSkjehs1prqA3p+B+p4WZSw+ippY+gYLU=;
  b=gBIesfDM3iaYbl7kM0oLAsrPky4/cNUVpkBunSZ6AD+kvLwwZZ/JJNrb
   mHue4qXiuLivxkx0Axb1lIhMX7R90zGGEse9Kay7uUCD+gikvHXxx7Glx
   5a7ffAN9elL+5e7GCwbT3po7Brc5AWcnGvSLMg6AsaS/Y/CjKrLb3m1B7
   cKSOG6iAlBIZ5AwABGxIVT9trciZ/StebuCuIZJlZspt0/BfrQa2X5rFd
   dkmZOThmuRt5E0WdwQNBPTwnOje5Kj3hCV8vFtpJ2cGjwr7p0mmym9LHO
   Lt1UnnUkKEdqLqsyDL8HlHlmSaVdJ8o0BqjXv3g+hXgw/xy0Xlw+hbop4
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10326"; a="264813945"
X-IronPort-AV: E=Sophos;i="5.90,286,1643702400"; 
   d="scan'208";a="264813945"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2022 03:15:59 -0700
X-IronPort-AV: E=Sophos;i="5.90,286,1643702400"; 
   d="scan'208";a="616086716"
Received: from 984fee00be24.jf.intel.com ([10.165.54.246])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2022 03:15:59 -0700
From:   Lei Wang <lei4.wang@intel.com>
To:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org
Cc:     lei4.wang@intel.com, chenyi.qiang@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v7 4/8] KVM: MMU: Rename the pkru to pkr
Date:   Sun, 24 Apr 2022 03:15:53 -0700
Message-Id: <20220424101557.134102-5-lei4.wang@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220424101557.134102-1-lei4.wang@intel.com>
References: <20220424101557.134102-1-lei4.wang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Chenyi Qiang <chenyi.qiang@intel.com>

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
where protection key checks are needed, because they can share almost the
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
index f5455bada8cd..1014d6a2b069 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -459,7 +459,7 @@ struct kvm_mmu {
 	* with PFEC.RSVD replaced by ACC_USER_MASK from the page tables.
 	* Each domain has 2 bits which are ANDed with AD and WD from PKRU.
 	*/
-	u32 pkru_mask;
+	u32 pkr_mask;
 
 	u64 *pae_root;
 	u64 *pml4_root;
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index e6cae6f22683..cb3f07e63778 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -239,8 +239,8 @@ static inline u8 permission_fault(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 	u32 errcode = PFERR_PRESENT_MASK;
 
 	WARN_ON(pfec & (PFERR_PK_MASK | PFERR_RSVD_MASK));
-	if (unlikely(mmu->pkru_mask)) {
-		u32 pkru_bits, offset;
+	if (unlikely(mmu->pkr_mask)) {
+		u32 pkr_bits, offset;
 
 		/*
 		* PKRU defines 32 bits, there are 16 domains and 2
@@ -248,15 +248,15 @@ static inline u8 permission_fault(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
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
index f9080ee50ffa..de665361548d 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4631,12 +4631,12 @@ static void update_permission_bitmask(struct kvm_mmu *mmu, bool ept)
 * away both AD and WD.  For all reads or if the last condition holds, WD
 * only will be masked away.
 */
-static void update_pkru_bitmask(struct kvm_mmu *mmu)
+static void update_pkr_bitmask(struct kvm_mmu *mmu)
 {
 	unsigned bit;
 	bool wp;
 
-	mmu->pkru_mask = 0;
+	mmu->pkr_mask = 0;
 
 	if (!is_cr4_pke(mmu))
 		return;
@@ -4671,7 +4671,7 @@ static void update_pkru_bitmask(struct kvm_mmu *mmu)
 		/* PKRU.WD stops write access. */
 		pkey_bits |= (!!check_write) << 1;
 
-		mmu->pkru_mask |= (pkey_bits & 3) << pfec;
+		mmu->pkr_mask |= (pkey_bits & 3) << pfec;
 	}
 }
 
@@ -4683,7 +4683,7 @@ static void reset_guest_paging_metadata(struct kvm_vcpu *vcpu,
 
 	reset_rsvds_bits_mask(vcpu, mmu);
 	update_permission_bitmask(mmu, false);
-	update_pkru_bitmask(mmu);
+	update_pkr_bitmask(mmu);
 }
 
 static void paging64_init_context(struct kvm_mmu *context)
@@ -4951,7 +4951,7 @@ void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly,
 		context->root_level = level;
 		context->direct_map = false;
 		update_permission_bitmask(context, true);
-		context->pkru_mask = 0;
+		context->pkr_mask = 0;
 		reset_rsvds_bits_mask_ept(vcpu, context, execonly, huge_page_level);
 		reset_ept_shadow_zero_bits_mask(context, execonly);
 	}
-- 
2.25.1

