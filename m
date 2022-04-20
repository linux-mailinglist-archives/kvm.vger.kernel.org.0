Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43DF3507DC8
	for <lists+kvm@lfdr.de>; Wed, 20 Apr 2022 02:49:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241534AbiDTAv7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Apr 2022 20:51:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353098AbiDTAvt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Apr 2022 20:51:49 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13C4437A1B
        for <kvm@vger.kernel.org>; Tue, 19 Apr 2022 17:49:05 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id x187-20020a6286c4000000b0050a98a708d1so237767pfd.15
        for <kvm@vger.kernel.org>; Tue, 19 Apr 2022 17:49:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=yHc4G/3kYUFvIv/wUWSokoXc81j23NvIKlslmOJqwiU=;
        b=JYhsOdKYTodR+S96nF2AE4ysIXQYIETL93+HdtxJplNaIfSiLhCtBr0fr29v7YV3Pf
         6IzEq3TUvO11lgQRqnQdW2i1M1VxRZt+Xnj9am790n3gVUD9krYLXcoNlayfnnRw0y+4
         WPkRNRguneJ3QsVJiog1hhFAvh4VGG/sJIS0iCIt6CsgrtYsFMMbdDfa8I+MP65G098d
         hbP7dJPs5c6riSAGdWqKe5mYfPOVBGWu1Q7LQqqfChVtMS+Gz2NHwNqc8Cl8uUKIg3Lb
         7BUmxmF34kQPrIaBnUO386FW0ZeURN8fdtYcIcugbpHnyDWI7kMC6OddSQG2JwBUCU89
         tJZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=yHc4G/3kYUFvIv/wUWSokoXc81j23NvIKlslmOJqwiU=;
        b=yJwHnzCVcaVKgdhRklieGJPOCml1j3qPg0ektlxedM5RN6wuc0vC2bye10RrpuiGZy
         dJywqmovM50qr1OKeN30tMGFEygY3oHFoAXArtrlTInG/nhCZjgSNjSvbMAOPluDplws
         ZCKzv+hC0330PDqk132h0qp5PIkwBRy2hkL5aKdMisJUGaK6z7wDDHp9LRbkqmH6k9i0
         dME+ghshlhdTII5CfiDaZIj+g5Rhec5IcLd6aMgdZMrOIN9q0P/CSeKD3NpjcmdENgNM
         TFBsBnATV+Kf1LAHIJuiHndC4jenVKtsPCKLUzZ6avWNWzL6cK8iNDm6Pv5VK+AFhPdI
         k+og==
X-Gm-Message-State: AOAM5318oIeWLxbDNbIC/UcjQS5DfSRCEUDdKdTkwusnACCnr80DISeD
        /0A9dF8zopgiu/IjrzS6fusb796DNEQ=
X-Google-Smtp-Source: ABdhPJxQOCTMF9ilxtpV2ee6jzHOaqFLVWh20t5MAUUHAvmGti92v49KQz1kmDZn2to/aMwI7YfxHo8J/9U=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:903:110c:b0:153:1293:5624 with SMTP id
 n12-20020a170903110c00b0015312935624mr18197021plh.149.1650415744597; Tue, 19
 Apr 2022 17:49:04 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 20 Apr 2022 00:48:59 +0000
In-Reply-To: <20220420004859.3298837-1-seanjc@google.com>
Message-Id: <20220420004859.3298837-3-seanjc@google.com>
Mime-Version: 1.0
References: <20220420004859.3298837-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [PATCH 2/2] KVM: Do not speculatively mark pfn cache valid to "fix" race
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Woodhouse <dwmw@amazon.co.uk>,
        Mingwei Zhang <mizhang@google.com>,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When refreshing a stale pfn cache, mark it valid only after the new pfn
(and maybe kernel mapping) has been acquired.  Speculatively marking the
cache as valid with garbage pfn/khva values can lead to other tasks using
the garbage values.  Presumably, the cache was previously marked valid
before dropping gpc->lock to address a race where an mmu_notifier event
could invalidate the cache between retrieving the pfn via hva_to_pfn()
and re-acquiring gpc->lock.  That race has been plugged by waiting for
mn_active_invalidate_count to reach zero before returning from
hva_to_pfn_retry(), i.e. waiting for any notifiers to fully complete
before returning.

Note, this could also be "fixed" by having kvm_gfn_to_pfn_cache_check()
also verify gpc->hkva, but that's unnecessary now that the aforementioned
race between refresh and mmu_notifier invalidation has been eliminated.

  CPU0                                    CPU1
  ----                                    ----

                                          gpc->valid == false

                                          kvm_gfn_to_pfn_cache_refresh()
                                          |
                                          |-> gpc->valid = true;

                                          hva_to_pfn_retry()
                                          |
                                          -> drop gpc->lock

  acquire gpc->lock for read
  kvm_gfn_to_pfn_cache_check()
  |
  |-> gpc->valid == true
      gpc->khva  == NULL

  caller dereferences NULL khva

Opportunistically add a lockdep to the check() helper to make it slightly
more obvious that there is no memory ordering issue when setting "valid"
versus "pfn" and/or "khva".

Fixes: 982ed0de4753 ("KVM: Reinstate gfn_to_pfn_cache with invalidation support")
Cc: stable@vger.kernel.org
Cc: David Woodhouse <dwmw@amazon.co.uk>
Cc: Mingwei Zhang <mizhang@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/pfncache.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
index 71c84a43024c..72eee096a7cd 100644
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -81,6 +81,8 @@ bool kvm_gfn_to_pfn_cache_check(struct kvm *kvm, struct gfn_to_pfn_cache *gpc,
 {
 	struct kvm_memslots *slots = kvm_memslots(kvm);
 
+	lockdep_assert_held_read(&gpc->lock);
+
 	if ((gpa & ~PAGE_MASK) + len > PAGE_SIZE)
 		return false;
 
@@ -226,11 +228,6 @@ int kvm_gfn_to_pfn_cache_refresh(struct kvm *kvm, struct gfn_to_pfn_cache *gpc,
 	if (!old_valid || old_uhva != gpc->uhva) {
 		void *new_khva = NULL;
 
-		/* Placeholders for "hva is valid but not yet mapped" */
-		gpc->pfn = KVM_PFN_ERR_FAULT;
-		gpc->khva = NULL;
-		gpc->valid = true;
-
 		new_pfn = hva_to_pfn_retry(kvm, gpc);
 		if (is_error_noslot_pfn(new_pfn)) {
 			ret = -EFAULT;
@@ -259,7 +256,7 @@ int kvm_gfn_to_pfn_cache_refresh(struct kvm *kvm, struct gfn_to_pfn_cache *gpc,
 			gpc->pfn = KVM_PFN_ERR_FAULT;
 			gpc->khva = NULL;
 		} else {
-			/* At this point, gpc->valid may already have been cleared */
+			gpc->valid = true;
 			gpc->pfn = new_pfn;
 			gpc->khva = new_khva;
 		}
-- 
2.36.0.rc0.470.gd361397f0d-goog

