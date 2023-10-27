Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F7B37D9ED8
	for <lists+kvm@lfdr.de>; Fri, 27 Oct 2023 19:26:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232508AbjJ0R0u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Oct 2023 13:26:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230101AbjJ0R0s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Oct 2023 13:26:48 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F802AB
        for <kvm@vger.kernel.org>; Fri, 27 Oct 2023 10:26:46 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d9a45e7e0f9so1786815276.0
        for <kvm@vger.kernel.org>; Fri, 27 Oct 2023 10:26:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698427605; x=1699032405; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=23oksESXE6CLybVIwMDavuBp7d3ignkf+nBV+kQspaA=;
        b=Z1bCAfsIrthT9BjnoroVa6RMPZtxp4m+XVrslQXS5CKkM5SGwZjTEyxDPtYnpuQFgs
         aziJzvxP+ik765s/YnBReR/OmbPUBLATiBhFGhj/+rkWD55T5opgYN18CkIsAdcBypCm
         Yq5BVffORJSp+yG39vM5cBxAOq1vwqva+74WZCu/sd96jkzAhBW47+4yqDL02fENk9Lk
         eXXMsqOtIH4Roritgt+LDTvstRCbUqp4OqTXJaOK5DiFlZ1E7pmq+PRC/M6cGsqIrSYN
         LZU4Zsmdc1syS5toLBn3aqItXD68/ZFd1A7LOyJD5pPsfdYtnZZe1oEbQW78HjRvfAx9
         KQbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698427605; x=1699032405;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=23oksESXE6CLybVIwMDavuBp7d3ignkf+nBV+kQspaA=;
        b=qagvYsDjIzhXdUSUCJV/RKvi4O2iw40+zWL65rLJ66vrANQV6HyIZm50t5ld+gkJ6/
         NrDYaYAaM6/Tu1XbDDDaua6NWKk4iHPcVK5MXIWGdJO59rGOaZiLy3XE1f7sjtSdOQbh
         CLho+1rQmNsmKKRh/wKm5Zbtjy8YB6c+EhOgxOvHVYPoqgEIytqyY0b/U9i5dSSnpOpU
         wk3CQkm9FqPNozENd+3J7IxSjQix5YNtYDCYLpFZ8yfQjfauBsxy+xv98wSnhYYcUP2J
         8JuYEhAnQGYCvKW8rJVUVbut+vS0/hCCG5qDThDH8tppUO1AQyz00a1BBLtBx43UpYZ5
         uhZw==
X-Gm-Message-State: AOJu0YxYrGkVjjw7G8TO38F3WQP6kal9+pWjdxcgoa93BKGUqZ25UBcG
        ynnqyCebBdehhDahORPCahrXHyeF9ofvrw==
X-Google-Smtp-Source: AGHT+IGoOoQny9CTB63MwmsS371460fPBiJ+myX0+fj3J70djk8pu8/6Oz2WWNq4jDbDb5ngGisOZ22wqVnigw==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a25:8689:0:b0:d9a:3bee:255c with SMTP id
 z9-20020a258689000000b00d9a3bee255cmr62066ybk.7.1698427605367; Fri, 27 Oct
 2023 10:26:45 -0700 (PDT)
Date:   Fri, 27 Oct 2023 10:26:39 -0700
In-Reply-To: <20231027172640.2335197-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20231027172640.2335197-1-dmatlack@google.com>
X-Mailer: git-send-email 2.42.0.820.g83a721a137-goog
Message-ID: <20231027172640.2335197-3-dmatlack@google.com>
Subject: [PATCH 2/3] KVM: x86/mmu: Check for leaf SPTE when clearing dirty bit
 in the TDP MMU
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>, kvm@vger.kernel.org,
        Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Re-check that the given SPTE is still a leaf and present SPTE after a
failed cmpxchg in clear_dirty_gfn_range(). clear_dirty_gfn_range()
intends to only operate on present leaf SPTEs, but that could change
after a failed cmpxchg.

A check for present was added in commit 3354ef5a592d ("KVM: x86/mmu:
Check for present SPTE when clearing dirty bit in TDP MMU") but the
check for leaf is still buried in tdp_root_for_each_leaf_pte() and does
not get rechecked on retry.

Fixes: a6a0b05da9f3 ("kvm: x86/mmu: Support dirty logging for the TDP MMU")
Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 6cd4dd631a2f..038983b13574 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1522,12 +1522,13 @@ static bool clear_dirty_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 
 	rcu_read_lock();
 
-	tdp_root_for_each_leaf_pte(iter, root, start, end) {
+	tdp_root_for_each_pte(iter, root, start, end) {
 retry:
-		if (tdp_mmu_iter_cond_resched(kvm, &iter, false, true))
+		if (!is_shadow_present_pte(iter.old_spte) ||
+		    !is_last_spte(iter.old_spte, iter.level))
 			continue;
 
-		if (!is_shadow_present_pte(iter.old_spte))
+		if (tdp_mmu_iter_cond_resched(kvm, &iter, false, true))
 			continue;
 
 		KVM_MMU_WARN_ON(kvm_ad_enabled() &&
-- 
2.42.0.820.g83a721a137-goog

