Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88420767A99
	for <lists+kvm@lfdr.de>; Sat, 29 Jul 2023 03:16:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237390AbjG2BQu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 21:16:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237379AbjG2BQi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 21:16:38 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 435713C34
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 18:16:26 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d27ac992539so1151075276.3
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 18:16:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690593384; x=1691198184;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=9PS6/kdsyjCNOIgCqCLtomsQfkSrRepMjSfHvyibg7s=;
        b=c9HO1UvEnLy9K57Umvf7Flw62OFFzkuP2T0gD0+H/F2Wrc2Z02KCFwh2+D53HbJtWH
         KhfBsskIdUPOI8Jkc4V34fiYowP+Rd6ZB5OzGU3ekI1UFMwHI77pr/q39J9d6KxXiq4B
         SlMKcGMdqFy2Co+J4cJU0bs8yXrxu/HsSZUSCMZV1tCItPwiplohOl3FrDi3Ln4VrLut
         nYtgYf4DMLSxjERbAjwrhlbXHShhmsuCE0McWqHXd0oKqVCy3cepOSYM8dgVtihTDp2V
         sgE0WaY+/6SsQrBYtbDGicJ/SThQ1OI7S5i//Zgy+AymK2OaCkbKQP2sR87WUwc9EGK6
         7fzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690593384; x=1691198184;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9PS6/kdsyjCNOIgCqCLtomsQfkSrRepMjSfHvyibg7s=;
        b=Ztf4HG6PixQRyl86PzvE522OkfLwpBf9z4cWrDsUeMse+j+siOgC+yy7aNOws9KWYv
         ZzJtYgKhJLAbl0PQbUXeySKYARWbCLYagk8+jFZmW4iIxhEw5Pf1bFhG1HJt+S23f/6/
         kchFlmAIft9tj2EeRdFH6MQTDqlsxwsQqTDNxgegiIXDFQUhI78yjhxYWRjBCWwCt2L0
         q6m3LWCAoAwBE4Srt/iaFbPgypEf0R5L07gU4g8rEgSHlRQP7gZkYoCx1x3JRJvYaNix
         NVdXdu1KUm8dB1c4/sZtOut610fzXEiqh+paL+nBJnMBBUmhR5HcMtB8sMSe3EJO8A8O
         inRQ==
X-Gm-Message-State: ABy/qLaW5peWgHtBtLRmHrG/3LC+FtcvxOG0WScJUYcUlj/dtcPv2D7L
        IMzAqMaaIAFvGrFDg9hwrqYX0lkse2g=
X-Google-Smtp-Source: APBJJlEOipUZszKQaAABUUJZrcFo61YSL85CyZnPKsfsLjKRZbFTJHR65zsbVaSreP/dlB4CN3av+CE42iU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:2311:0:b0:d0c:e71d:fab with SMTP id
 j17-20020a252311000000b00d0ce71d0fabmr19536ybj.0.1690593384631; Fri, 28 Jul
 2023 18:16:24 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 28 Jul 2023 18:15:53 -0700
In-Reply-To: <20230729011608.1065019-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230729011608.1065019-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230729011608.1065019-7-seanjc@google.com>
Subject: [PATCH v2 06/21] KVM: nSVM: Skip writes to MSR_AMD64_TSC_RATIO if
 guest state isn't loaded
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Maxim Levitsky <mlevitsk@redhat.com>
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

Skip writes to MSR_AMD64_TSC_RATIO that are done in the context of a vCPU
if guest state isn't loaded, i.e. if KVM will update MSR_AMD64_TSC_RATIO
during svm_prepare_switch_to_guest() before entering the guest.  Checking
guest_state_loaded may or may not be a net positive for performance as
the current_tsc_ratio cache will optimize away duplicate WRMSRs in the
vast majority of scenarios.  However, the cost of the check is negligible,
and the real motivation is to document that KVM needs to load the vCPU's
value only when running the vCPU.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index c786c8e9108f..64092df06f94 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1109,7 +1109,8 @@ static void svm_write_tsc_offset(struct kvm_vcpu *vcpu)
 void svm_write_tsc_multiplier(struct kvm_vcpu *vcpu)
 {
 	preempt_disable();
-	__svm_write_tsc_multiplier(vcpu->arch.tsc_scaling_ratio);
+	if (to_svm(vcpu)->guest_state_loaded)
+		__svm_write_tsc_multiplier(vcpu->arch.tsc_scaling_ratio);
 	preempt_enable();
 }
 
-- 
2.41.0.487.g6d72f3e995-goog

