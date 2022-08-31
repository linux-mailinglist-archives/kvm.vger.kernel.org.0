Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B5D55A72C1
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 02:38:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232185AbiHaAh6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 20:37:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232038AbiHaAhH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 20:37:07 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC43262F5
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 17:35:50 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id e16-20020a17090301d000b00172fbf52e7dso8951003plh.11
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 17:35:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc;
        bh=vs+/VgNPbXQDyp+lFpPyuzFJGuQv6/mfWtb6IRoNofc=;
        b=cvWzuF/pUn7dcLNtyrR5ZfO7DpFQ4TMlPUqGc3ivk0ghfq2DY3XadZH3z7R78K+3e0
         maM0SJLY6f2+4rvRYvaFogaghRu2HpktMrb8ohbADFAO0jaO5fy2+oZ9GaLpL48XPz6q
         uKjZu2+/RlKcBXZhvB+wbKcxzwHv1xJ29PKHH0E+GS/yJ8FzwYKDz9PHxbWVLlokwHJF
         Wp3CyTZqcZNxxeeD13DanuKngWPcc2ljnts6fPhOKvbEJxBt7Qtp13eNoezrBqjs+viX
         q1NeXWzk59DSQ5cLYreO3Qjm8NC/iylmjThcNHEvB5HkcO8VAggD/2ojYHMHfwZfNL+1
         zWfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=vs+/VgNPbXQDyp+lFpPyuzFJGuQv6/mfWtb6IRoNofc=;
        b=CNIkOeMb+p+aHjE0yfiNqWrWpRIjYKspgU299S266WcJK8k38yxq+1B9DSczgutTlg
         kyfjOADTuhwtHPD6WFPGNqoleKrCUb7kQbYvqxNV261pAHqmUddONb2qJDSKMccRlrNW
         qRVNAMEcdgGlB4j7J1Y/e/J1ja9dOrs+U6Ci6iwYJErf6rak3luyUNtC9imAFVMi7YOx
         Yw67jrcd5UIBwA5ZHCOHII0LM0zX5uXEkvnh77GArssdbOymKlpEWCx88ZCT+J5dyjA7
         sZ0m/hFWFz7m56E7O2sRAVfBhT+gVj2O16Bq+Nna3SGSAcer1xZWYorhxuhLrPtPbrwn
         8Zcw==
X-Gm-Message-State: ACgBeo3Bk1Gold33CZoJVp6Ubsai82qS4mVUpP19a4hwp+roP7h/AoZh
        VA2FNCMduHtcRSjxPdKftb64TqNYk3M=
X-Google-Smtp-Source: AA6agR5OjPqtHiqPZMJX6QZ8XK4pECvI+wrTckRQpR97VYnRYJQo0TfwPxQCWcEahmapGJAM35xUkVnM5bc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:cb87:b0:1fd:d261:f87c with SMTP id
 a7-20020a17090acb8700b001fdd261f87cmr628971pju.43.1661906123392; Tue, 30 Aug
 2022 17:35:23 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 31 Aug 2022 00:34:55 +0000
In-Reply-To: <20220831003506.4117148-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220831003506.4117148-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220831003506.4117148-9-seanjc@google.com>
Subject: [PATCH 08/19] KVM: SVM: Remove redundant cluster calculation that
 also creates a shadow
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Li RongQing <lirongqing@baidu.com>
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

Drop the redundant "cluster" calculation and its horrific shadowing in
the x2avic logical mode path.  The "cluster" that is declared at an outer
scope is derived using the exact same calculation and has performed the
left-shift.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 14f567550a1e..8c9cad96008e 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -410,10 +410,9 @@ static int avic_kick_target_vcpus_fast(struct kvm *kvm, struct kvm_lapic *source
 			 * For x2APIC logical mode, cannot leverage the index.
 			 * Instead, calculate physical ID from logical ID in ICRH.
 			 */
-			int cluster = (icrh & 0xffff0000) >> 16;
 			int apic = ffs(bitmap) - 1;
 
-			l1_physical_id = (cluster << 4) + apic;
+			l1_physical_id = cluster + apic;
 		}
 	}
 
-- 
2.37.2.672.g94769d06f0-goog

