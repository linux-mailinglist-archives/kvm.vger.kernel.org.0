Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF30E5A7209
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 01:55:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230270AbiH3Xzn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 19:55:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230062AbiH3Xzm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 19:55:42 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CC3A2F00F
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 16:55:41 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id e187-20020a6369c4000000b0041c8dfb8447so6244344pgc.23
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 16:55:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc;
        bh=KwSYCZerlx8jq2QaoSW9rJT1jqCtPnDeeiOJE8jfST4=;
        b=BPH+iO6gDGCsp2Wcx1LYWuE/INfoeSg5h3VFyT2+38gryYDiRQNbYYVwlMT78ungxP
         uhH+zRrer8VCaDfUCOCZIBNmaRpGl8JFqhjto1VWg3595CY+538Oa5oLaTTGSZUOcTrx
         QmvyynMrgDUdcIUJAcBzCpeO9UY3gTlHOAfaFOQD9qfZr2BxPj/X7k0u36MGUUwFLb/D
         3WJmTeRSqrkAK7oOeT0dGuQWP8LbfSWn8mXsflZgNJzq3/hGQ3Bx7/Qh90pQ0vUwCZt7
         pl0QmujrSQkoPGrx/eThrTz9cTK3ObEIsit1R1QXl2WXj2YSj+wze22tC2CAXttiyjYT
         XjoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=KwSYCZerlx8jq2QaoSW9rJT1jqCtPnDeeiOJE8jfST4=;
        b=ACfACPruq6QXaxkIq4cGB7CI1wjgrlQCTaGJpEpvjuGQuGVbT37tzV4Ral9aIpaMRd
         HF3mQZY2YomoQVSA2jTTjfrSBJAye5Y7aY/1rQLbH77UF/+TUqW0IHZSEXRMi77Jfhp8
         UfOemJnM2QbyJxk5KnAGqfsdva67xz9egWjR3YW6j7gx71gxAZbp+bTUDI2qXnMuC9F9
         g6yyZs7ffKjJL8wUWaPBwLu1ObKqQzu2QKVvt0y4WxpicQ57SA4fzFDzYM99SaGEVInX
         7vgofFZaPIa2fSebSB0YjxabNQCZ36TCeghAe8dmbwL43c8Z+ShLJjoPTQXyeGbTZijY
         /jvg==
X-Gm-Message-State: ACgBeo3pVLzrFIG6z3JSiDx3e+qAgvvpRT6oYpSFJSP7ByWCiKJmGPk+
        NjLzs78N96Ci09apudaMfZZ+bCzWIbc=
X-Google-Smtp-Source: AA6agR6Gceek7om6pgblzSZOyMYq2EfiLWTCKia41sXQbONpjnXz30oLCnehC/Cob4rJMGMpKrHB2I3lntA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a62:5ec6:0:b0:538:3aa:7fe5 with SMTP id
 s189-20020a625ec6000000b0053803aa7fe5mr16255558pfb.73.1661903741190; Tue, 30
 Aug 2022 16:55:41 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 30 Aug 2022 23:55:29 +0000
In-Reply-To: <20220830235537.4004585-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220830235537.4004585-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220830235537.4004585-2-seanjc@google.com>
Subject: [PATCH v4 1/9] KVM: x86/mmu: Bug the VM if KVM attempts to double
 count an NX huge page
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Matlack <dmatlack@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Yan Zhao <yan.y.zhao@intel.com>,
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

WARN and kill the VM if KVM attempts to double count an NX huge page,
i.e. attempts to re-tag a shadow page with "NX huge page disallowed".
KVM does NX huge page accounting only when linking a new shadow page, and
it should be impossible for a new shadow page to be already accounted.
E.g. even in the TDP MMU case, where vCPUs can race to install a new
shadow page, only the "winner" will account the installed page.

Kill the VM instead of continuing on as either KVM has an egregious bug,
e.g. didn't zero-initialize the data, or there's host data corruption, in
which carrying on is dangerous, e.g. could cause silent data corruption
in the guest.

Reported-by: David Matlack <dmatlack@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Mingwei Zhang <mizhang@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 32b60a6b83bd..74afee3f2476 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -804,7 +804,7 @@ static void account_shadowed(struct kvm *kvm, struct kvm_mmu_page *sp)
 
 void account_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
-	if (sp->lpage_disallowed)
+	if (KVM_BUG_ON(sp->lpage_disallowed, kvm))
 		return;
 
 	++kvm->stat.nx_lpage_splits;
-- 
2.37.2.672.g94769d06f0-goog

