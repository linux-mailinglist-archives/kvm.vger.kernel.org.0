Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B21185195D6
	for <lists+kvm@lfdr.de>; Wed,  4 May 2022 05:25:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344219AbiEDD2c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 May 2022 23:28:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344202AbiEDD2a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 May 2022 23:28:30 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23A562717D
        for <kvm@vger.kernel.org>; Tue,  3 May 2022 20:24:56 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id d64-20020a17090a6f4600b001da3937032fso2265202pjk.5
        for <kvm@vger.kernel.org>; Tue, 03 May 2022 20:24:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=UE0HcXTxgX958/wjfkT/IQbNNoXqwMiaNuwDtFEI/7w=;
        b=KIkwxXGDCX2GNwXt49UEWppqkI7IuskxNWAKGQOf+GUm67FzQ0X1o25H3Jno+gfiQ6
         CX+0aLwHtRTaNLQs29WkmCJMoWyaOkjQqIWLpSwPP7wG0/CdKC1mqFIHVqsIJk4Y2Yfc
         KnziFWF/93i9FsyNJbcWs8Pf8x+QTHGpT4DXq1tcxC4vMfc7g347aVmL63yjmqaZNb+h
         lDhMlK7TwEMCTXURJiwbX2D8ZDAMyFwyWizp6BtKadlBYfWFMqjwV34OBer2HNf+ygVM
         m9DJ4/oVnjPeZVtsTl6/6i7FQ5jr1pUrX9agQOX1Y0A/XyVBjSCVeyph5Hfw3piovqnt
         LbnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=UE0HcXTxgX958/wjfkT/IQbNNoXqwMiaNuwDtFEI/7w=;
        b=57lSMju2j8tdkwtJNPIdEzd/MW1T4qWsPVzvD/6MrEaNgxwhoWnn2Or9OhuKZt9fuS
         zakcZRJnDjYahnZnUVKJeCRGK2VNfrRMOS69BTEYbsbeAe+s/aKoK+G3muICDWz+Yqn3
         /UuVuN4U404Ty6Nl0pm8zuCNzVkHWI6EAzgtH2UsCPpAKYhnLkv7Pr1187mDS/d4Kvuh
         EzKoIFArZ4hFgzUmCxOW3SlkEd/HhGQfRDQeytto5sFWG/f/etU9UvWNxSoPT6f60tF3
         Q3HfPdQnP7v0B7oBkVxEPcLEOqLNmGbqlsPt5P71MYaQIm3WPSemQHMtPicaMttP6azh
         WPfg==
X-Gm-Message-State: AOAM530zktIK4BkSroRYKtcO07lFAJ9AF11qQZiMbtbm+X4yYVCYSlh7
        VFr4G7ksJ7NnlUmfMIA/Z3vmY73RjMQ=
X-Google-Smtp-Source: ABdhPJyd1Jxi1pP3kjM7I5iyXKCDdQGPA7cTg9gLCDVjhwSerOtbMrOWP35WmZ55PAcThzOFr0nC8wgJPwQ=
X-Received: from oupton3.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:21eb])
 (user=oupton job=sendgmr) by 2002:a17:902:db05:b0:15e:b542:3f23 with SMTP id
 m5-20020a170902db0500b0015eb5423f23mr7097374plx.143.1651634695538; Tue, 03
 May 2022 20:24:55 -0700 (PDT)
Date:   Wed,  4 May 2022 03:24:35 +0000
In-Reply-To: <20220504032446.4133305-1-oupton@google.com>
Message-Id: <20220504032446.4133305-2-oupton@google.com>
Mime-Version: 1.0
References: <20220504032446.4133305-1-oupton@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH v6 01/12] KVM: arm64: Don't depend on fallthrough to hide SYSTEM_RESET2
From:   Oliver Upton <oupton@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, maz@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        reijiw@google.com, ricarkol@google.com,
        Oliver Upton <oupton@google.com>
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

Depending on a fallthrough to the default case for hiding SYSTEM_RESET2
requires that any new case statements clean up the failure path for this
PSCI call.

Unhitch SYSTEM_RESET2 from the default case by setting val to
PSCI_RET_NOT_SUPPORTED outside of the switch statement. Apply the
cleanup to both the PSCI_1_1_FN_SYSTEM_RESET2 and
PSCI_1_0_FN_PSCI_FEATURES handlers.

No functional change intended.

Signed-off-by: Oliver Upton <oupton@google.com>
Reviewed-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/psci.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
index 708d80e8e60d..67fbd6ef022c 100644
--- a/arch/arm64/kvm/psci.c
+++ b/arch/arm64/kvm/psci.c
@@ -305,9 +305,9 @@ static int kvm_psci_0_2_call(struct kvm_vcpu *vcpu)
 
 static int kvm_psci_1_x_call(struct kvm_vcpu *vcpu, u32 minor)
 {
+	unsigned long val = PSCI_RET_NOT_SUPPORTED;
 	u32 psci_fn = smccc_get_function(vcpu);
 	u32 arg;
-	unsigned long val;
 	int ret = 1;
 
 	switch(psci_fn) {
@@ -320,6 +320,8 @@ static int kvm_psci_1_x_call(struct kvm_vcpu *vcpu, u32 minor)
 		if (val)
 			break;
 
+		val = PSCI_RET_NOT_SUPPORTED;
+
 		switch(arg) {
 		case PSCI_0_2_FN_PSCI_VERSION:
 		case PSCI_0_2_FN_CPU_SUSPEND:
@@ -338,13 +340,8 @@ static int kvm_psci_1_x_call(struct kvm_vcpu *vcpu, u32 minor)
 			break;
 		case PSCI_1_1_FN_SYSTEM_RESET2:
 		case PSCI_1_1_FN64_SYSTEM_RESET2:
-			if (minor >= 1) {
+			if (minor >= 1)
 				val = 0;
-				break;
-			}
-			fallthrough;
-		default:
-			val = PSCI_RET_NOT_SUPPORTED;
 			break;
 		}
 		break;
@@ -365,7 +362,7 @@ static int kvm_psci_1_x_call(struct kvm_vcpu *vcpu, u32 minor)
 			val = PSCI_RET_INVALID_PARAMS;
 			break;
 		}
-		fallthrough;
+		break;
 	default:
 		return kvm_psci_0_2_call(vcpu);
 	}
-- 
2.36.0.464.gb9c8b46e94-goog

