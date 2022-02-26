Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F08A54C5283
	for <lists+kvm@lfdr.de>; Sat, 26 Feb 2022 01:16:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240368AbiBZARR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 19:17:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240662AbiBZARC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 19:17:02 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5676225597
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 16:16:21 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id f4-20020a17090ac28400b001bc40aa09fbso6462187pjt.6
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 16:16:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=ENO0x4uKs4rqsjN1xB0qFJMoRAxQ1GMRSi+kdo7qAvw=;
        b=lhfMZMr/HcUZRGRAalYnJGHqVZsOjXMz94FZ2392zvT3nXG8ZEgYlnAfpVuqMVoG4s
         vQnfMTJMlL4JHX/+6hN/2my3McSMWbIfCGT6gZ8CcdMU2jt55aPfoOq+mJ537gXev2b/
         VzD9jYFmAZzINuPpAeNPRZTzzRu2CyVxgpdgd29mOXSqrGSYjtxI21NR5V1R1UsOcg++
         L8W60IWSB0jZ/uevf/LPKOAKmxPlXBOWyTJ8JdcedPlKLPqlnjMs3IXhYm/wKnASI0P0
         ML2/OiOmwfAyxlR4JPds616MmFjqFn7uhffuWzWSo0pMZRWbtdME4x5w/8KPEc16P4vE
         hNdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=ENO0x4uKs4rqsjN1xB0qFJMoRAxQ1GMRSi+kdo7qAvw=;
        b=JQTTmjPKpM9u7Bof9NihZ/jGBZgh2QnD6VjjIqeyc7A7Js5IWpTKA/aKyUfS4QAfQU
         eo+a10r02GqRejvpJHaDKCh3q+68wxi3E+OMfQqScB6Le+Q38LVRGXbZhZlPrUJ3Lsiq
         n3zPOE+e8Y3YCztLNxDtrKVdm6kdFTMkfjkrFACVYkSuWGKrXxEYTv9WmEBJ6sQlxSk6
         UlqJxmwLqJmhObQXxuj4ee1LFO98qwDUCcTjqVSA7cXX7QAFQbTjl4DRNLdP4/VtEmae
         Eh7VDnYA6IOctGIQB8FSa4cZycAhZfRoHGkVNtIu9I4AAXh4sgTauYyERKeurivoA0No
         RRbg==
X-Gm-Message-State: AOAM530bAqMZGP95Fj+LURRzXKlrj+MSaVSrIurKZATACwTyPMSNORyK
        hx6XpNJX2sFrCU4xquL86aj1Hb++Y10=
X-Google-Smtp-Source: ABdhPJzrbxQn7NgpNV/g9aLZwydofMo3rhOO2xpfsf/UPmMpU4CrBDA6znpW6k2RNcYcQVgoM9BmqlkXkHA=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:f02:b0:1bd:ab6:42ec with SMTP id
 2-20020a17090a0f0200b001bd0ab642ecmr2190693pjy.18.1645834581467; Fri, 25 Feb
 2022 16:16:21 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 26 Feb 2022 00:15:30 +0000
In-Reply-To: <20220226001546.360188-1-seanjc@google.com>
Message-Id: <20220226001546.360188-13-seanjc@google.com>
Mime-Version: 1.0
References: <20220226001546.360188-1-seanjc@google.com>
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
Subject: [PATCH v3 12/28] KVM: x86/mmu: Refactor low-level TDP MMU set SPTE
 helper to take raw vals
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Mingwei Zhang <mizhang@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Refactor __tdp_mmu_set_spte() to work with raw values instead of a
tdp_iter objects so that a future patch can modify SPTEs without doing a
walk, and without having to synthesize a tdp_iter.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 51 +++++++++++++++++++++++---------------
 1 file changed, 31 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 1dcdf1a4fcc1..9e8ba6f12ebf 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -617,9 +617,13 @@ static inline int tdp_mmu_zap_spte_atomic(struct kvm *kvm,
 
 /*
  * __tdp_mmu_set_spte - Set a TDP MMU SPTE and handle the associated bookkeeping
- * @kvm: kvm instance
- * @iter: a tdp_iter instance currently on the SPTE that should be set
- * @new_spte: The value the SPTE should be set to
+ * @kvm:	      KVM instance
+ * @as_id:	      Address space ID, i.e. regular vs. SMM
+ * @sptep:	      Pointer to the SPTE
+ * @old_spte:	      The current value of the SPTE
+ * @new_spte:	      The new value that will be set for the SPTE
+ * @gfn:	      The base GFN that was (or will be) mapped by the SPTE
+ * @level:	      The level _containing_ the SPTE (its parent PT's level)
  * @record_acc_track: Notify the MM subsystem of changes to the accessed state
  *		      of the page. Should be set unless handling an MMU
  *		      notifier for access tracking. Leaving record_acc_track
@@ -631,12 +635,10 @@ static inline int tdp_mmu_zap_spte_atomic(struct kvm *kvm,
  *		      Leaving record_dirty_log unset in that case prevents page
  *		      writes from being double counted.
  */
-static inline void __tdp_mmu_set_spte(struct kvm *kvm, struct tdp_iter *iter,
-				      u64 new_spte, bool record_acc_track,
-				      bool record_dirty_log)
+static void __tdp_mmu_set_spte(struct kvm *kvm, int as_id, tdp_ptep_t sptep,
+			       u64 old_spte, u64 new_spte, gfn_t gfn, int level,
+			       bool record_acc_track, bool record_dirty_log)
 {
-	WARN_ON_ONCE(iter->yielded);
-
 	lockdep_assert_held_write(&kvm->mmu_lock);
 
 	/*
@@ -646,39 +648,48 @@ static inline void __tdp_mmu_set_spte(struct kvm *kvm, struct tdp_iter *iter,
 	 * should be used. If operating under the MMU lock in write mode, the
 	 * use of the removed SPTE should not be necessary.
 	 */
-	WARN_ON(is_removed_spte(iter->old_spte) || is_removed_spte(new_spte));
+	WARN_ON(is_removed_spte(old_spte) || is_removed_spte(new_spte));
 
-	kvm_tdp_mmu_write_spte(iter->sptep, new_spte);
+	kvm_tdp_mmu_write_spte(sptep, new_spte);
+
+	__handle_changed_spte(kvm, as_id, gfn, old_spte, new_spte, level, false);
 
-	__handle_changed_spte(kvm, iter->as_id, iter->gfn, iter->old_spte,
-			      new_spte, iter->level, false);
 	if (record_acc_track)
-		handle_changed_spte_acc_track(iter->old_spte, new_spte,
-					      iter->level);
+		handle_changed_spte_acc_track(old_spte, new_spte, level);
 	if (record_dirty_log)
-		handle_changed_spte_dirty_log(kvm, iter->as_id, iter->gfn,
-					      iter->old_spte, new_spte,
-					      iter->level);
+		handle_changed_spte_dirty_log(kvm, as_id, gfn, old_spte,
+					      new_spte, level);
+}
+
+static inline void _tdp_mmu_set_spte(struct kvm *kvm, struct tdp_iter *iter,
+				     u64 new_spte, bool record_acc_track,
+				     bool record_dirty_log)
+{
+	WARN_ON_ONCE(iter->yielded);
+
+	__tdp_mmu_set_spte(kvm, iter->as_id, iter->sptep, iter->old_spte,
+			   new_spte, iter->gfn, iter->level,
+			   record_acc_track, record_dirty_log);
 }
 
 static inline void tdp_mmu_set_spte(struct kvm *kvm, struct tdp_iter *iter,
 				    u64 new_spte)
 {
-	__tdp_mmu_set_spte(kvm, iter, new_spte, true, true);
+	_tdp_mmu_set_spte(kvm, iter, new_spte, true, true);
 }
 
 static inline void tdp_mmu_set_spte_no_acc_track(struct kvm *kvm,
 						 struct tdp_iter *iter,
 						 u64 new_spte)
 {
-	__tdp_mmu_set_spte(kvm, iter, new_spte, false, true);
+	_tdp_mmu_set_spte(kvm, iter, new_spte, false, true);
 }
 
 static inline void tdp_mmu_set_spte_no_dirty_log(struct kvm *kvm,
 						 struct tdp_iter *iter,
 						 u64 new_spte)
 {
-	__tdp_mmu_set_spte(kvm, iter, new_spte, true, false);
+	_tdp_mmu_set_spte(kvm, iter, new_spte, true, false);
 }
 
 #define tdp_root_for_each_pte(_iter, _root, _start, _end) \
-- 
2.35.1.574.g5d30c73bfb-goog

