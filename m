Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 342BD767A0F
	for <lists+kvm@lfdr.de>; Sat, 29 Jul 2023 02:49:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236791AbjG2AtT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 20:49:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236540AbjG2AtC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 20:49:02 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EED0226B2
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 17:48:28 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1bb982d2603so24352795ad.3
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 17:48:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690591653; x=1691196453;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=h4cdHm0BhlnhwQewWFd9AhJ9S+836DEvk/nuWuA0UMI=;
        b=t+btc92z8/DgzpdYkrs7sL1HZgj054O/l9y6BIeMTFTnjcyb2xDE7SFYpIeFpg+xlN
         C/3BOBrWT5egYwIZR9MXt8xNNFX7+v101a9eFqBI1WBjAUuML2fS6kB76znkNwLDcoIv
         ddQc5eUlZ4cL3Bdsi3q2vxX241inLoXN0JvkRCKhKb+OaSN1uEkQm6cAnXqBwsV4rnsd
         ZeBVeqftNSU+rx346x1Fo74hTJU6SM68raImqyNpTMu+g9ZHeczC3Fk73kh4nV1E9Y62
         Nl1gbd5iCoIUGOnZhJc3SChBuzlHu0VSY7s/BuenjEWokbMbwgUNSDzl9iKHGGNa1rDL
         Ew1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690591653; x=1691196453;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=h4cdHm0BhlnhwQewWFd9AhJ9S+836DEvk/nuWuA0UMI=;
        b=V+HmY7x0ThUzn9elrNfMX42PgpW3wRuZW/Hq2CSI7REKTUfd1Xa+dBWIxOG4IBHujn
         yRijA4ybcza8TeexVGwvHEYgN4xemElIORxx+hyGsU/qFo9VkhXIev/f+CVZgBHjef59
         ftUQip4bFA6wZpAfGgbi27FieygNs2qWlZWnSygMiRP7ct7Ybfh+4Wb/D515+97E/JXc
         g6aRDYlQMj+GvggbK76+SKJL7yDaSB7MAKAxmbyfqQCETK3eA/MmkDGYv1gb7Ul+Qv3W
         VKAo3I8+RSVus2FjaWnUxWk7fJ14hkiZpMoiJTdz77mJXiyzXSnkB5JT1fKzlrb503R3
         f7ZA==
X-Gm-Message-State: ABy/qLYXccD7s/WNEsuDiT7b2tTVYiBlkROprC7qt1RCKFQhMsbK5qO5
        6fT+22+HtRLkUoIN/MMWiqH56FDY7VQ=
X-Google-Smtp-Source: APBJJlFbNlhqr8YcGvPiMy1hZ/2yOMM7yWARMHWtT/boxQlwyhdvicCi7m1Hf/v+LDh5z/wz128n7nbywq0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:ce84:b0:1b8:2cee:946b with SMTP id
 f4-20020a170902ce8400b001b82cee946bmr14762plg.11.1690591653584; Fri, 28 Jul
 2023 17:47:33 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 28 Jul 2023 17:47:15 -0700
In-Reply-To: <20230729004722.1056172-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230729004722.1056172-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230729004722.1056172-6-seanjc@google.com>
Subject: [PATCH v3 05/12] KVM: x86/mmu: Cleanup sanity check of SPTEs at SP free
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mingwei Zhang <mizhang@google.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>
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

Massage the error message for the sanity check on SPTEs when freeing a
shadow page to be more verbose, and to print out all shadow-present SPTEs,
not just the first SPTE encountered.  Printing all SPTEs can be quite
valuable for debug, e.g. highlights whether the leak is a one-off or
widepsread, or possibly the result of memory corruption (something else
in the kernel stomping on KVM's SPTEs).

Opportunistically move the MMU_WARN_ON() into the helper itself, which
will allow a future cleanup to use BUILD_BUG_ON_INVALID() as the stub for
MMU_WARN_ON().  BUILD_BUG_ON_INVALID() works as intended and results in
the compiler complaining about is_empty_shadow_page() not being declared.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 08d08f34e6a3..8a21b06a9646 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1693,21 +1693,19 @@ bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 	return young;
 }
 
+static void kvm_mmu_check_sptes_at_free(struct kvm_mmu_page *sp)
+{
 #ifdef MMU_DEBUG
-static int is_empty_shadow_page(u64 *spt)
-{
 	int i;
 
 	for (i = 0; i < SPTE_ENT_PER_PAGE; i++) {
-		if (is_shadow_present_pte(spt[i])) {
-			printk(KERN_ERR "%s: %p %llx\n", __func__,
-			       &spt[i], spt[i]);
-			return 0;
-		}
+		if (MMU_WARN_ON(is_shadow_present_pte(sp->spt[i])))
+			pr_err_ratelimited("SPTE %llx (@ %p) for gfn %llx shadow-present at free",
+					   sp->spt[i], &sp->spt[i],
+					   kvm_mmu_page_get_gfn(sp, i));
 	}
-	return 1;
-}
 #endif
+}
 
 /*
  * This value is the sum of all of the kvm instances's
@@ -1735,7 +1733,8 @@ static void kvm_unaccount_mmu_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 
 static void kvm_mmu_free_shadow_page(struct kvm_mmu_page *sp)
 {
-	MMU_WARN_ON(!is_empty_shadow_page(sp->spt));
+	kvm_mmu_check_sptes_at_free(sp);
+
 	hlist_del(&sp->hash_link);
 	list_del(&sp->link);
 	free_page((unsigned long)sp->spt);
-- 
2.41.0.487.g6d72f3e995-goog

