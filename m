Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46C8A6C3D4F
	for <lists+kvm@lfdr.de>; Tue, 21 Mar 2023 23:01:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230172AbjCUWBG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Mar 2023 18:01:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229913AbjCUWAq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Mar 2023 18:00:46 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C79559411
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 15:00:36 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id d12-20020a056a0024cc00b006256990dddeso8129702pfv.9
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 15:00:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679436036;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=KjKcmvesKMOfQvirTv9DqxPBipEMdr9d2inmQgOn+s4=;
        b=tkoda7txDF5YFbkW+Mt/PmeisXwqsGdCNNiWC7XyWUmM7WlTyiGAQ+S0jYuSJFqxiW
         IN80Zrw3U1974nErB9TjPhl2gbNt8n9+swhU4bOZXbscFco6IfgyR4ha0MKsSgz/i/N+
         TpETbLNOuDVTJAckCx4h1rgt1YE8iIf5jE4YamaAqUI7E+yIOVDuF9pOx8zrCZQUMkOC
         ejW7z5CjNoBXnvAgk6JOZ4B6F1EhCvQrRo/l/fEhAuFe8Oer/pRFIGob2XKRh39WdxAY
         OF40O8sbgZWSYr5TJCTsIwmlRdRVVg1NABFchyyXQ6dV3s53u4zcsVsqeYF/l3pVnu+Y
         bDeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679436036;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KjKcmvesKMOfQvirTv9DqxPBipEMdr9d2inmQgOn+s4=;
        b=o4PrxVod05YfO/uPGxytEFnXCZpHSrtUxm4IFwQC9FHZjoKAoBvuOhNRK8AqcKWHt4
         rTEOW504nuJXXZR1VXRqzy19UoUY6Tr9LFCGHHgimLcYXrOog6OmREo12EPpwilAF+O4
         ErVZF89HEM69+Vspj8TZF0z2i7RbRUc6zZGlar7ySe97I7c3R9sFUUlwkRurf/vRYWC7
         piAaGddzLTCU3Pz3V8TvhRPo7ShrTu5uTSzOyBQpJxpZGNP91/R39TWurXrLE4r9GMW1
         A+GMf9d9rpArTD+6/igwdJ4i+GPeIXZDR9zPq3DKGe1hkrXe+IHib0wNLaHCFtLm0X2A
         Wj+Q==
X-Gm-Message-State: AO0yUKWYLiKpu+NgGfdWXh5ozi32KiZfrH6ySq0nNIlgFDG0j5GDPpcE
        t6W3LQvdgAZwOr30lBZP5io2AHZS2l4=
X-Google-Smtp-Source: AK7set8hFJFKyUzPqhFofQ4pnN9+yx4h3CVcQkvdECtsqsnFR2WhZTuhAjlo7ykamjm+qJyMrwUxziV18pk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a65:43c6:0:b0:503:2663:5c9f with SMTP id
 n6-20020a6543c6000000b0050326635c9fmr142889pgp.8.1679436035808; Tue, 21 Mar
 2023 15:00:35 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 21 Mar 2023 15:00:15 -0700
In-Reply-To: <20230321220021.2119033-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230321220021.2119033-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.0.rc2.332.ga46443480c-goog
Message-ID: <20230321220021.2119033-8-seanjc@google.com>
Subject: [PATCH v4 07/13] KVM: x86/mmu: Remove "record_dirty_log" in __tdp_mmu_set_spte()
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vipin Sharma <vipinsh@google.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Vipin Sharma <vipinsh@google.com>

Remove bool parameter "record_dirty_log" from __tdp_mmu_set_spte() and
refactor the code as this variable is always set to true by its caller.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
Reviewed-by: David Matlack <dmatlack@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 24 +++++++++---------------
 1 file changed, 9 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 467931c43968..3cc81fa22b7f 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -708,18 +708,13 @@ static inline int tdp_mmu_zap_spte_atomic(struct kvm *kvm,
  *		      notifier for access tracking. Leaving record_acc_track
  *		      unset in that case prevents page accesses from being
  *		      double counted.
- * @record_dirty_log: Record the page as dirty in the dirty bitmap if
- *		      appropriate for the change being made. Should be set
- *		      unless performing certain dirty logging operations.
- *		      Leaving record_dirty_log unset in that case prevents page
- *		      writes from being double counted.
  *
  * Returns the old SPTE value, which _may_ be different than @old_spte if the
  * SPTE had voldatile bits.
  */
 static u64 __tdp_mmu_set_spte(struct kvm *kvm, int as_id, tdp_ptep_t sptep,
 			      u64 old_spte, u64 new_spte, gfn_t gfn, int level,
-			      bool record_acc_track, bool record_dirty_log)
+			      bool record_acc_track)
 {
 	lockdep_assert_held_write(&kvm->mmu_lock);
 
@@ -738,35 +733,34 @@ static u64 __tdp_mmu_set_spte(struct kvm *kvm, int as_id, tdp_ptep_t sptep,
 
 	if (record_acc_track)
 		handle_changed_spte_acc_track(old_spte, new_spte, level);
-	if (record_dirty_log)
-		handle_changed_spte_dirty_log(kvm, as_id, gfn, old_spte,
-					      new_spte, level);
+
+	handle_changed_spte_dirty_log(kvm, as_id, gfn, old_spte, new_spte,
+				      level);
 	return old_spte;
 }
 
 static inline void _tdp_mmu_set_spte(struct kvm *kvm, struct tdp_iter *iter,
-				     u64 new_spte, bool record_acc_track,
-				     bool record_dirty_log)
+				     u64 new_spte, bool record_acc_track)
 {
 	WARN_ON_ONCE(iter->yielded);
 
 	iter->old_spte = __tdp_mmu_set_spte(kvm, iter->as_id, iter->sptep,
 					    iter->old_spte, new_spte,
 					    iter->gfn, iter->level,
-					    record_acc_track, record_dirty_log);
+					    record_acc_track);
 }
 
 static inline void tdp_mmu_set_spte(struct kvm *kvm, struct tdp_iter *iter,
 				    u64 new_spte)
 {
-	_tdp_mmu_set_spte(kvm, iter, new_spte, true, true);
+	_tdp_mmu_set_spte(kvm, iter, new_spte, true);
 }
 
 static inline void tdp_mmu_set_spte_no_acc_track(struct kvm *kvm,
 						 struct tdp_iter *iter,
 						 u64 new_spte)
 {
-	_tdp_mmu_set_spte(kvm, iter, new_spte, false, true);
+	_tdp_mmu_set_spte(kvm, iter, new_spte, false);
 }
 
 #define tdp_root_for_each_pte(_iter, _root, _start, _end) \
@@ -916,7 +910,7 @@ bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
 		return false;
 
 	__tdp_mmu_set_spte(kvm, kvm_mmu_page_as_id(sp), sp->ptep, old_spte, 0,
-			   sp->gfn, sp->role.level + 1, true, true);
+			   sp->gfn, sp->role.level + 1, true);
 
 	return true;
 }
-- 
2.40.0.rc2.332.ga46443480c-goog

