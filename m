Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BDC364A42A
	for <lists+kvm@lfdr.de>; Mon, 12 Dec 2022 16:31:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232477AbiLLPbO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Dec 2022 10:31:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232503AbiLLPbL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Dec 2022 10:31:11 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 462E3120AE;
        Mon, 12 Dec 2022 07:31:09 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id n65-20020a17090a2cc700b0021bc5ef7a14so222871pjd.0;
        Mon, 12 Dec 2022 07:31:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+/jm7VnVwXNJnon7L3mSgLc+ja6eHEtRF1Bkw57lTnY=;
        b=Bfu11zCOiH870ikkLoaQUU7lLREucd4917jtlNMwjuWbwgQlaRhajLIdsCshY8607X
         j/FThxRyzTRhXxEDWh8moFbWnPWu9AGPEtvMxeutv0ls+ZVtN9wfuBwvMpHdB+HFmiwG
         rbp67n8/EDDYnrFDzrp6JEB4ms4n3Ld3v8yXQuMJj39hTmxT6LAhB7s9Dpgz6E7osYWY
         856WC39jWG4e4v8NUfLjwSzDpBBKGCn68IeVa2Vzb3lziqdBEoA+vbvK0Yvq+Y/6bHu9
         mDSSQt1uWmG0mOfSlv1JFnkq2FXF2TOQvmd2vJ89o9sMN5uzZ5z8RcIk7pSLrIE05dZ5
         oEXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+/jm7VnVwXNJnon7L3mSgLc+ja6eHEtRF1Bkw57lTnY=;
        b=BBnqRw7yArkVG62RZ5AWaM0n3GGqf6cIhibbT6Xl1I0xHCd/ZEX6k4BSXMxxt4Hvmy
         FkUZDlJYucCbKEgqI/18/VOcnaV91bbrfmoSgHT2tN+4MrrrDj3o7nJY94ksYekLppeM
         TIUcsVFIbx1OSTnNDDXVnRdH38tF56SlfWp+INeIC2PDBhwMDeRPEaO9iW6SQIzOMhrN
         yeg7AZHlZ+ihgZuQH56ZBuNvOfVJz3ykVhssi7Sa0OvhGUFrRTxscXZF1TqyKzx0aiVJ
         VT7WsLgSjJJ9IehDJTGpbiJFtBJPvHH30Qec4nLwAqZ2hndMINnxRsDr3QUPbCUwfrhJ
         bZFg==
X-Gm-Message-State: ANoB5plXkCTufdqKEIWFBP3B9pixG6GL9ONyYICdijFohYngrh7Kdi6w
        MkahbO2kwvkc9zujW3bm+Lv6+9aMcXA=
X-Google-Smtp-Source: AA0mqf78/wgOPeOP++jrViqFADCctTIl0zDYTk5dO53Un5WCmuBMifD+vviBMYCPin0vcR+PgfwHqA==
X-Received: by 2002:a17:902:cec1:b0:189:cef2:88e3 with SMTP id d1-20020a170902cec100b00189cef288e3mr23097800plg.57.1670859068450;
        Mon, 12 Dec 2022 07:31:08 -0800 (PST)
Received: from localhost ([198.11.178.15])
        by smtp.gmail.com with ESMTPSA id l15-20020a170903244f00b001894198d0ebsm6549695pls.24.2022.12.12.07.31.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Dec 2022 07:31:08 -0800 (PST)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org
Subject: [PATCH 2/2] kvm: x86/mmu: Remove useless shadow_host_writable_mask
Date:   Mon, 12 Dec 2022 23:32:05 +0800
Message-Id: <20221212153205.3360-3-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20221212153205.3360-1-jiangshanlai@gmail.com>
References: <20221212153205.3360-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <jiangshan.ljs@antgroup.com>

shadow_host_writable_mask is only used in FNAME(sync_page) which
doesn't actually need it.

Remove it and release a bit from spte.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 arch/x86/kvm/mmu/paging_tmpl.h |  7 ++++++-
 arch/x86/kvm/mmu/spte.c        |  8 +------
 arch/x86/kvm/mmu/spte.h        | 38 +++++++++++-----------------------
 3 files changed, 19 insertions(+), 34 deletions(-)

diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 613f043a3e9e..8b83abf1d8bc 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -1084,9 +1084,14 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 		/* Update the shadowed access bits in case they changed. */
 		kvm_mmu_page_set_access(sp, i, pte_access);
 
+		/*
+		 * It doesn't matter whether it is host_writable or not since
+		 * write-access is being removed.
+		 */
+		host_writable = false;
+
 		sptep = &sp->spt[i];
 		spte = *sptep;
-		host_writable = spte & shadow_host_writable_mask;
 		slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
 		make_spte(vcpu, sp, slot, pte_access, gfn,
 			  spte_to_pfn(spte), spte, true, false,
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index c0fd7e049b4e..00c88b1dca0a 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -24,7 +24,6 @@ static bool __ro_after_init allow_mmio_caching;
 module_param_named(mmio_caching, enable_mmio_caching, bool, 0444);
 EXPORT_SYMBOL_GPL(enable_mmio_caching);
 
-u64 __read_mostly shadow_host_writable_mask;
 u64 __read_mostly shadow_mmu_writable_mask;
 u64 __read_mostly shadow_nx_mask;
 u64 __read_mostly shadow_x_mask; /* mutual exclusive with nx_mask */
@@ -192,9 +191,7 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	if (shadow_memtype_mask)
 		spte |= static_call(kvm_x86_get_mt_mask)(vcpu, gfn,
 							 kvm_is_mmio_pfn(pfn));
-	if (host_writable)
-		spte |= shadow_host_writable_mask;
-	else
+	if (!host_writable)
 		pte_access &= ~ACC_WRITE_MASK;
 
 	if (shadow_me_value && !kvm_is_mmio_pfn(pfn))
@@ -332,7 +329,6 @@ u64 kvm_mmu_changed_pte_notifier_make_spte(u64 old_spte, kvm_pfn_t new_pfn)
 	new_spte |= (u64)new_pfn << PAGE_SHIFT;
 
 	new_spte &= ~PT_WRITABLE_MASK;
-	new_spte &= ~shadow_host_writable_mask;
 	new_spte &= ~shadow_mmu_writable_mask;
 
 	new_spte = mark_spte_for_access_track(new_spte);
@@ -440,7 +436,6 @@ void kvm_mmu_set_ept_masks(bool has_ad_bits, bool has_exec_only)
 	 */
 	shadow_memtype_mask	= VMX_EPT_MT_MASK | VMX_EPT_IPAT_BIT;
 	shadow_acc_track_mask	= VMX_EPT_RWX_MASK;
-	shadow_host_writable_mask = EPT_SPTE_HOST_WRITABLE;
 	shadow_mmu_writable_mask  = EPT_SPTE_MMU_WRITABLE;
 
 	/*
@@ -500,7 +495,6 @@ void kvm_mmu_reset_all_pte_masks(void)
 	shadow_me_mask		= 0;
 	shadow_me_value		= 0;
 
-	shadow_host_writable_mask = DEFAULT_SPTE_HOST_WRITABLE;
 	shadow_mmu_writable_mask  = DEFAULT_SPTE_MMU_WRITABLE;
 
 	/*
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index 1f03701b943a..9824b33539c9 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -75,8 +75,7 @@ static_assert(!(SPTE_TDP_AD_MASK & SHADOW_ACC_TRACK_SAVED_MASK));
  * SPTE is write-protected. See is_writable_pte() for details.
  */
 
-/* Bits 9 and 10 are ignored by all non-EPT PTEs. */
-#define DEFAULT_SPTE_HOST_WRITABLE	BIT_ULL(9)
+/* Bit 10 are ignored by all non-EPT PTEs. */
 #define DEFAULT_SPTE_MMU_WRITABLE	BIT_ULL(10)
 
 /*
@@ -84,12 +83,9 @@ static_assert(!(SPTE_TDP_AD_MASK & SHADOW_ACC_TRACK_SAVED_MASK));
  * to not overlap the A/D type mask or the saved access bits of access-tracked
  * SPTEs when A/D bits are disabled.
  */
-#define EPT_SPTE_HOST_WRITABLE		BIT_ULL(57)
 #define EPT_SPTE_MMU_WRITABLE		BIT_ULL(58)
 
-static_assert(!(EPT_SPTE_HOST_WRITABLE & SPTE_TDP_AD_MASK));
 static_assert(!(EPT_SPTE_MMU_WRITABLE & SPTE_TDP_AD_MASK));
-static_assert(!(EPT_SPTE_HOST_WRITABLE & SHADOW_ACC_TRACK_SAVED_MASK));
 static_assert(!(EPT_SPTE_MMU_WRITABLE & SHADOW_ACC_TRACK_SAVED_MASK));
 
 /* Defined only to keep the above static asserts readable. */
@@ -148,7 +144,6 @@ static_assert(MMIO_SPTE_GEN_LOW_BITS == 8 && MMIO_SPTE_GEN_HIGH_BITS == 11);
 
 #define MMIO_SPTE_GEN_MASK		GENMASK_ULL(MMIO_SPTE_GEN_LOW_BITS + MMIO_SPTE_GEN_HIGH_BITS - 1, 0)
 
-extern u64 __read_mostly shadow_host_writable_mask;
 extern u64 __read_mostly shadow_mmu_writable_mask;
 extern u64 __read_mostly shadow_nx_mask;
 extern u64 __read_mostly shadow_x_mask; /* mutual exclusive with nx_mask */
@@ -383,27 +378,23 @@ static __always_inline bool is_rsvd_spte(struct rsvd_bits_validate *rsvd_check,
  *
  * For cases #1 and #4, KVM can safely make such SPTEs writable without taking
  * mmu_lock as capturing the Accessed/Dirty state doesn't require taking it.
- * To differentiate #1 and #4 from #2 and #3, KVM uses two software-only bits
+ * To differentiate #1 and #4 from #2 and #3, KVM uses a software-only bit
  * in the SPTE:
  *
  *  shadow_mmu_writable_mask, aka MMU-writable -
  *    Cleared on SPTEs that KVM is currently write-protecting for shadow paging
  *    purposes (case 2 above).
- *
- *  shadow_host_writable_mask, aka Host-writable -
  *    Cleared on SPTEs that are not host-writable (case 3 above)
  *
- * Note, not all possible combinations of PT_WRITABLE_MASK,
- * shadow_mmu_writable_mask, and shadow_host_writable_mask are valid. A given
- * SPTE can be in only one of the following states, which map to the
- * aforementioned 3 cases:
+ * Note, not all possible combinations of PT_WRITABLE_MASK and
+ * shadow_mmu_writable_mask are valid. A given SPTE can be in only one of the
+ * following states, which map to the aforementioned 3 cases:
  *
- *   shadow_host_writable_mask | shadow_mmu_writable_mask | PT_WRITABLE_MASK
- *   ------------------------- | ------------------------ | ----------------
- *   1                         | 1                        | 1       (writable)
- *   1                         | 1                        | 0       (case 1)
- *   1                         | 0                        | 0       (case 2)
- *   0                         | 0                        | 0       (case 3)
+ *   shadow_mmu_writable_mask | PT_WRITABLE_MASK
+ *   ------------------------ | ----------------
+ *   1                        | 1       (writable)
+ *   1                        | 0       (case 1)
+ *   0                        | 0       (case 2,3)
  *
  * The valid combinations of these bits are checked by
  * check_spte_writable_invariants() whenever an SPTE is modified.
@@ -433,13 +424,8 @@ static inline bool is_writable_pte(unsigned long pte)
 /* Note: spte must be a shadow-present leaf SPTE. */
 static inline void check_spte_writable_invariants(u64 spte)
 {
-	if (spte & shadow_mmu_writable_mask)
-		WARN_ONCE(!(spte & shadow_host_writable_mask),
-			  "kvm: MMU-writable SPTE is not Host-writable: %llx",
-			  spte);
-	else
-		WARN_ONCE(is_writable_pte(spte),
-			  "kvm: Writable SPTE is not MMU-writable: %llx", spte);
+	WARN_ONCE(!(spte & shadow_mmu_writable_mask) && is_writable_pte(spte),
+		  "kvm: Writable SPTE is not MMU-writable: %llx", spte);
 }
 
 static inline bool is_mmu_writable_spte(u64 spte)
-- 
2.19.1.6.gb485710b

