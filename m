Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6E2050D10E
	for <lists+kvm@lfdr.de>; Sun, 24 Apr 2022 12:16:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239049AbiDXKTL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 24 Apr 2022 06:19:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239011AbiDXKTB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 24 Apr 2022 06:19:01 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D4B54ECDE;
        Sun, 24 Apr 2022 03:16:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650795361; x=1682331361;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qz/GE1fawZvUOeTVkWMItT1dq54iN+MwN7o2/FhMXlA=;
  b=Sy+X/Iy9JpUaylKCSrQ884Vr+vfmIvLy48Ex9JN2BBIjaWxxJR+VVHw8
   qq9pcTJOMKv9n5pZSk+WMQ+BRrhIXfSQDirMAUn48+hO5bEVDf9ieL6iU
   bUr9u+KbC+9NcOwajModtGE+jM7bya4iRRwVnkcfBv1wPiKELkm2qFA6E
   7W4UXdk0mBaO5Vi2xv5YFZqc3OGuXoW0r6/T5TvK5gxBdBLDrjsWg+Ovs
   nOLeHlOr4+6VB9CUGH3O3HIU69NzCt3mhHMhNGhKmxCMs3cyY1Rrnm50O
   3h+xR8HJJLZoFXs1JVfWeCADk+KM3M5jzHOEs08ymIf6zlO4hqyH6IEVn
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10326"; a="264813946"
X-IronPort-AV: E=Sophos;i="5.90,286,1643702400"; 
   d="scan'208";a="264813946"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2022 03:16:00 -0700
X-IronPort-AV: E=Sophos;i="5.90,286,1643702400"; 
   d="scan'208";a="616086719"
Received: from 984fee00be24.jf.intel.com ([10.165.54.246])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2022 03:15:59 -0700
From:   Lei Wang <lei4.wang@intel.com>
To:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org
Cc:     lei4.wang@intel.com, chenyi.qiang@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v7 5/8] KVM: MMU: Add helper function to get pkr bits
Date:   Sun, 24 Apr 2022 03:15:54 -0700
Message-Id: <20220424101557.134102-6-lei4.wang@intel.com>
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

Extra the PKR stuff to a separate, non-inline helper, which is a
preparation to introduce pks support.

Signed-off-by: Lei Wang <lei4.wang@intel.com>
---
 arch/x86/kvm/mmu.h     | 20 +++++---------------
 arch/x86/kvm/mmu/mmu.c | 21 +++++++++++++++++++++
 2 files changed, 26 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index cb3f07e63778..cea03053a153 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -204,6 +204,9 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	return vcpu->arch.mmu->page_fault(vcpu, &fault);
 }
 
+u32 kvm_mmu_pkr_bits(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
+		     unsigned pte_access, unsigned pte_pkey, unsigned int pfec);
+
 /*
  * Check if a given access (described through the I/D, W/R and U/S bits of a
  * page fault error code pfec) causes a permission fault with the given PTE
@@ -240,21 +243,8 @@ static inline u8 permission_fault(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 
 	WARN_ON(pfec & (PFERR_PK_MASK | PFERR_RSVD_MASK));
 	if (unlikely(mmu->pkr_mask)) {
-		u32 pkr_bits, offset;
-
-		/*
-		* PKRU defines 32 bits, there are 16 domains and 2
-		* attribute bits per domain in pkru.  pte_pkey is the
-		* index of the protection domain, so pte_pkey * 2 is
-		* is the index of the first bit for the domain.
-		*/
-		pkr_bits = (vcpu->arch.pkru >> (pte_pkey * 2)) & 3;
-
-		/* clear present bit, replace PFEC.RSVD with ACC_USER_MASK. */
-		offset = (pfec & ~1) +
-			((pte_access & PT_USER_MASK) << (PFERR_RSVD_BIT - PT_USER_SHIFT));
-
-		pkr_bits &= mmu->pkr_mask >> offset;
+		u32 pkr_bits =
+			kvm_mmu_pkr_bits(vcpu, mmu, pte_access, pte_pkey, pfec);
 		errcode |= -pkr_bits & PFERR_PK_MASK;
 		fault |= (pkr_bits != 0);
 	}
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index de665361548d..6d3276986102 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6477,3 +6477,24 @@ void kvm_mmu_pre_destroy_vm(struct kvm *kvm)
 	if (kvm->arch.nx_lpage_recovery_thread)
 		kthread_stop(kvm->arch.nx_lpage_recovery_thread);
 }
+
+u32 kvm_mmu_pkr_bits(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
+		     unsigned pte_access, unsigned pte_pkey, unsigned int pfec)
+{
+	u32 pkr_bits, offset;
+
+	/*
+	* PKRU defines 32 bits, there are 16 domains and 2
+	* attribute bits per domain in pkru.  pte_pkey is the
+	* index of the protection domain, so pte_pkey * 2 is
+	* is the index of the first bit for the domain.
+	*/
+	pkr_bits = (vcpu->arch.pkru >> (pte_pkey * 2)) & 3;
+
+	/* clear present bit, replace PFEC.RSVD with ACC_USER_MASK. */
+	offset = (pfec & ~1) + ((pte_access & PT_USER_MASK)
+				<< (PFERR_RSVD_BIT - PT_USER_SHIFT));
+
+	pkr_bits &= mmu->pkr_mask >> offset;
+	return pkr_bits;
+}
-- 
2.25.1

