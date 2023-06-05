Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FA39721B49
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 02:43:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232127AbjFEAnk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 4 Jun 2023 20:43:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230218AbjFEAnj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 4 Jun 2023 20:43:39 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03552D3
        for <kvm@vger.kernel.org>; Sun,  4 Jun 2023 17:43:37 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id d2e1a72fcca58-64f74f4578aso4119956b3a.3
        for <kvm@vger.kernel.org>; Sun, 04 Jun 2023 17:43:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685925817; x=1688517817;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BYxU3tDQaD0OtzoBTGZivwsSzNx0WWibXW+uDpPnJvU=;
        b=oAgqtfKXKNUrueRjish0M8AHkqAawHUKAJ+c4CZWvHBzzQrhldagmTBUj+xNuhrnIh
         6dewdVNCfLHvWt8cNP67wp5N3KZEkztShDNowKlbfWluw0icCU5hpvk7BSOsBEbavKo3
         gHWEvALztvaN3xUitH4aSGZ7pmlJRqE9uGY0ZrTkHmK4w7M9RqNQTJvx0+4HbrJaSXkq
         9fTHEyzXXQOisQvJJ+aPNza0nHJmbDZpRJR1KHw+cZka55S1aTQf7yJ1GghVcmnzj9sC
         m1tre3ObKgwLQKwqGu2MrneFQHDw1nIjdcL1hrp0uThybKKCk2629Uqw3HcJ1FgB+4ma
         eP9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685925817; x=1688517817;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BYxU3tDQaD0OtzoBTGZivwsSzNx0WWibXW+uDpPnJvU=;
        b=Exi/Gcu6ugrOHa2rQGxYWYveDQWDPygtnmtO9GbDxCepeeW7/t7M7teUvE2k48qj3r
         D6AdWHr+FTADoxWfrFIz+UC0zF2R6xfs4Wwj7V869kfLgmiuSXBGt06IY1acwWJSb40b
         Qc5Se/v7DlQNP0MihLzs3DZ2Xkf7W4Zz3kF/oZSW8JwriHAWW0JAcCbV67xbarsntLnM
         TeS0+4qver1W5MBdM5C738qZnJeqkM+KWue0zjdz/MIC/yV8HvB7RKRF6BDH5AyUGudA
         uL1fPOCMfkSFXcZ4jJOxOvebMcfWVYDld7q3UjKpL1VDlM3QjvdHaXQJoKj/ejA09sTr
         di4Q==
X-Gm-Message-State: AC+VfDyvsiDzFaEUh5Kimz2z6DKa2rgQjXSWHO5R77zlznN+kAI5FZhj
        fSKDA58NnQqOkaBf+yqB49/spjmy89oI
X-Google-Smtp-Source: ACHHUZ6Pp77PwRvD+ww5r5W4ydPS6arG1XU7Ru5u/11ZqhIE/dTdcJwxMCXjGAFXiW8Swi71BSHsK13pK08o
X-Received: from mizhang-super.c.googlers.com ([34.105.13.176]) (user=mizhang
 job=sendgmr) by 2002:a05:6a00:2d24:b0:63d:2cff:bfbc with SMTP id
 fa36-20020a056a002d2400b0063d2cffbfbcmr6805016pfb.3.1685925817423; Sun, 04
 Jun 2023 17:43:37 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date:   Mon,  5 Jun 2023 00:43:34 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230605004334.1930091-1-mizhang@google.com>
Subject: [PATCH] KVM: x86/mmu: Remove KVM MMU write lock when accessing indirect_shadow_pages
From:   Mingwei Zhang <mizhang@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Ben Gardon <bgardon@google.com>
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

Remove KVM MMU write lock when accessing indirect_shadow_pages counter when
page role is direct because this counter value is used as a coarse-grained
heuristics to check if there is nested guest active. Racing with this
heuristics without mmu lock will be harmless because the corresponding
indirect shadow sptes for the GPA will either be zapped by this thread or
some other thread who has previously zapped all indirect shadow pages and
makes the value to 0.

Because of that, remove the KVM MMU write lock pair to potentially reduce
the lock contension and improve the performance of nested VM. In addition
opportunistically change the comment of 'direct mmu' to make the
description consistent with other places.

Reported-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 arch/x86/kvm/x86.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5ad55ef71433..97cfa5a00ff2 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8585,15 +8585,9 @@ static bool reexecute_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 
 	kvm_release_pfn_clean(pfn);
 
-	/* The instructions are well-emulated on direct mmu. */
+	/* The instructions are well-emulated on Direct MMUs. */
 	if (vcpu->arch.mmu->root_role.direct) {
-		unsigned int indirect_shadow_pages;
-
-		write_lock(&vcpu->kvm->mmu_lock);
-		indirect_shadow_pages = vcpu->kvm->arch.indirect_shadow_pages;
-		write_unlock(&vcpu->kvm->mmu_lock);
-
-		if (indirect_shadow_pages)
+		if (READ_ONCE(vcpu->kvm->arch.indirect_shadow_pages))
 			kvm_mmu_unprotect_page(vcpu->kvm, gpa_to_gfn(gpa));
 
 		return true;

base-commit: 31b4fc3bc64aadd660c5bfa5178c86a7ba61e0f7
-- 
2.41.0.rc0.172.g3f132b7071-goog

