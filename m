Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07350692CA0
	for <lists+kvm@lfdr.de>; Sat, 11 Feb 2023 02:47:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229984AbjBKBql (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Feb 2023 20:46:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229969AbjBKBqj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Feb 2023 20:46:39 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B05B84B93
        for <kvm@vger.kernel.org>; Fri, 10 Feb 2023 17:46:38 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id bs128-20020a632886000000b004fb3816e89eso3223885pgb.13
        for <kvm@vger.kernel.org>; Fri, 10 Feb 2023 17:46:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qvyXszpTjt01Q056Izvp9tkChdBBaJSX/3iFEV2GgtY=;
        b=pXbFYzGjBuwJfNS6gYgtZkM+mMuYItL/rPu/0kjg9o1lSwd6WeiH3PKpTXldxh71c6
         RThUEh1i98Z9k2lbyktBMh4JMSqtNTpqq9xRTAVGI+c7urYxueHJva9EwOqDS/PcJuh4
         yLqteVd2RHO54sWBM1gpvQQV9oNYp6gcv9EupI+qdSMLaivRobnO+c05PKqDPWPImyjq
         On6g2elHTKbcTVgvPnv01ouk5fStSdgun/QMR8uVb4RTQ6EWCaASFeMVu/mkxpow4ac3
         leyLD8IJ9xI2tGRZ/jSI7/vyhL04+iGYD0l1qFD9CKfwbjarb6laL+4AT08Q9b/GT/ay
         PGmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qvyXszpTjt01Q056Izvp9tkChdBBaJSX/3iFEV2GgtY=;
        b=ZQVtsStLxIPY9JEYAcRwfgYCfcM2w41Oj2kTzVAAcz2vn4yFIIGTYHtdXPch8XRbji
         3meo7vjQJ+JgowfX8wRvP1CHKR+8Cwx5bKDJUWWUTu1/y3O0RZV4ChWi2Y79P4AAvo5e
         /zlZcNc5B66TXBcjYIrbqwt8HXdYwrVdeL2+2B+hG4aq6/FtyopzuIx3YRTRwoUNbeEu
         cJ+BUhswTyYoTvdg4EyKNj5gf/+aJFXNz/LMf5WXKlLNrZI5WqoOyeU1ePtI+X2xKFAS
         vEFpqwgNSsPdFci80zHRn5oTp+894vkoWYvKHxeHaK0qRYSafHhVgk+p2ODqgvavAl6Z
         MGAA==
X-Gm-Message-State: AO0yUKXp9c6Jw3OHDJEMcV+qONr6YjFKCbjq94jH4xc9VQ1CenuNsy7M
        RHkwXTq8vXsvnR0ZM59VxlhL53BNhFTQ
X-Google-Smtp-Source: AK7set88Pn+HoZLc3TBke6+sHNxlhxbdjSn/64zcLE8iYOBdZHck60mTQXFtdxLlJC3hr723/QgnYUHhyoB1
X-Received: from vipin.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:479f])
 (user=vipinsh job=sendgmr) by 2002:aa7:9a0e:0:b0:56b:b520:3751 with SMTP id
 w14-20020aa79a0e000000b0056bb5203751mr3710282pfj.29.1676079997607; Fri, 10
 Feb 2023 17:46:37 -0800 (PST)
Date:   Fri, 10 Feb 2023 17:46:22 -0800
In-Reply-To: <20230211014626.3659152-1-vipinsh@google.com>
Mime-Version: 1.0
References: <20230211014626.3659152-1-vipinsh@google.com>
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
Message-ID: <20230211014626.3659152-4-vipinsh@google.com>
Subject: [Patch v3 3/7] KVM: x86/mmu: Remove "record_dirty_log" in __tdp_mmu_set_spte()
From:   Vipin Sharma <vipinsh@google.com>
To:     seanjc@google.com, pbonzini@redhat.com, bgardon@google.com,
        dmatlack@google.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove bool parameter "record_dirty_log" from __tdp_mmu_set_spte() and
refactor the code as this variable is always set to true by its caller.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 24 +++++++++---------------
 1 file changed, 9 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 66ccbeb9d845..c895560244de 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -710,18 +710,13 @@ static inline int tdp_mmu_zap_spte_atomic(struct kvm *kvm,
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
 
@@ -740,35 +735,34 @@ static u64 __tdp_mmu_set_spte(struct kvm *kvm, int as_id, tdp_ptep_t sptep,
 
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
@@ -918,7 +912,7 @@ bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
 		return false;
 
 	__tdp_mmu_set_spte(kvm, kvm_mmu_page_as_id(sp), sp->ptep, old_spte, 0,
-			   sp->gfn, sp->role.level + 1, true, true);
+			   sp->gfn, sp->role.level + 1, true);
 
 	return true;
 }
-- 
2.39.1.581.gbfd45094c4-goog

