Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5F5058B298
	for <lists+kvm@lfdr.de>; Sat,  6 Aug 2022 01:05:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241475AbiHEXF0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Aug 2022 19:05:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238675AbiHEXFX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Aug 2022 19:05:23 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7643412ABA
        for <kvm@vger.kernel.org>; Fri,  5 Aug 2022 16:05:22 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id i2-20020a17090a650200b001f4f79056a6so5034927pjj.9
        for <kvm@vger.kernel.org>; Fri, 05 Aug 2022 16:05:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:from:to:cc;
        bh=cVyg5lVhUGta27OyTveQuZSdsBeAtej8VaD6SjStUhY=;
        b=OBrKgXyIpckqO9CrRKQ6JD4KRVGxW16h0LR+qvoW/sZRw5MpW/Z9S0i8q2GProLabD
         U11zjkDbuoq485Mk9Gd/+WBd0Y7EDcsnfKEGq88nBSWANQXbpWNkzagKz8yzPTvahbgr
         Tx+W5fNIO9/woKPBCVsAR1d+3ya8ZuMcfUgqPC5wcdVXVlcbDMH07bemHy8Uc3zWnN88
         yep++LgjoXTqfsrDX/l1pXFO0TlR2UuqX1RCPnZCmLK6gik8SrDD6XuOceyCetZ/Ec+S
         jHqPwi4f3xEfzKsUsShxmzbZT0pkQ9aGQ3hAMH6YuWAVcs2kQoxnYtEDMGqPPww34yeU
         wQVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=cVyg5lVhUGta27OyTveQuZSdsBeAtej8VaD6SjStUhY=;
        b=h3mLY+5zZYcdhHSQ3HAoJi2aIBbIZ5/J4X9CsEmjeEq9KHUyQVxBpymw2ud6jGJbR8
         9QusEMwndPsxFPHUhWk86q78kQ5R2nUN0wdXUpqpx8NmAiFqanzURsrq+2LM+27PjxwF
         MPZNUV/L5RN/BQicuoURr/SHMG07fOxDsV7BCIQPISle2fd273peLUPSiJLsnFZLjjXZ
         yreYZTp5cZg8hIHeg3/hutCH0JIg8WTRUHCe97m04ETXWetYOhAKUeXMce0kB9mMGA2n
         3CUvQTgmQ/VI25jfsOR1APvhMnTnP5mrCnGhcOCfNg0xfeOprZCt8tlX84G8P51azhed
         Rndg==
X-Gm-Message-State: ACgBeo3NAtOZbyi1tTfPrz915ZGq4RxneWqZ8bT3Ma1iDUW+oqrIBXhM
        YZA/owAULJPRDSf+n0blG3UwBvOOd8k=
X-Google-Smtp-Source: AA6agR6n7rwy6mGJvNzb2TddHLX9FDpvrM4ae0/FLkoU/yQ2ZlFbW1POomBPv4xPpQsAGD08UagtVoVsl78=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:27a0:b0:52e:316c:851e with SMTP id
 bd32-20020a056a0027a000b0052e316c851emr9010748pfb.68.1659740722006; Fri, 05
 Aug 2022 16:05:22 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  5 Aug 2022 23:05:06 +0000
In-Reply-To: <20220805230513.148869-1-seanjc@google.com>
Message-Id: <20220805230513.148869-2-seanjc@google.com>
Mime-Version: 1.0
References: <20220805230513.148869-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.1.559.g78731f0fdb-goog
Subject: [PATCH v3 1/8] KVM: x86/mmu: Bug the VM if KVM attempts to double
 count an NX huge page
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Matlack <dmatlack@google.com>,
        Yan Zhao <yan.y.zhao@intel.com>,
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
---
 arch/x86/kvm/mmu/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 3e1317325e1f..36b898dbde91 100644
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
2.37.1.559.g78731f0fdb-goog

