Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8B9F4FAA60
	for <lists+kvm@lfdr.de>; Sat,  9 Apr 2022 20:46:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242780AbiDISsL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 9 Apr 2022 14:48:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239655AbiDISsJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 9 Apr 2022 14:48:09 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4352024959
        for <kvm@vger.kernel.org>; Sat,  9 Apr 2022 11:46:01 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-2ebfdbe01f6so11794177b3.10
        for <kvm@vger.kernel.org>; Sat, 09 Apr 2022 11:46:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=DMzmQt8j2gXQ34IYdSrbWnWZ1QMlmXcDpNCPmrEOebY=;
        b=NG4TL6XT7gnV8l/zru+9eN9qrrveBeZGlb+4CWYOSECMBCtX7Hh1T+caa19frZuH1p
         +EA32ATnD+LOjuqKUOrMj5mole9xDSK7al5vTLca3jkuvUixfPgRmo4zu387CynwlrM0
         F0aiMvjaakbeWQJoqYsS+ah6NDOlz4UQmiNXUo5rhvPbIf50TR8UcyGVaTTl/MJyA5EW
         O5SxEhj/ROxyychujtu+2H6CL78ZN6uaJsp7y0QTMLk1lCV7AZr8XZhQwDntBC31x2+X
         fKYZneniAdLL0ybiDSFJxy86ObDJB9vAmGWp/0FgXANDHeZH1cPkBoEoMfhjuqNJ/pNM
         GWEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=DMzmQt8j2gXQ34IYdSrbWnWZ1QMlmXcDpNCPmrEOebY=;
        b=6v/z1HJt7I4TClZlYUUJYZM49eMBKvkpLBefmbLI8UlERYIWJPiJCWo+TW3VTUDjrm
         7qbbxfy6MbMfcYX1df5gMaF6fnI5lHBDaw8KRib7zH9SYICl3D+fgqNpkOQTjkGaeJrL
         4Q+u9CAC+C9UtF4ikThsxz+jVZFdBjwYGOVG8M2L4ZVeeK+J9Z5RYY2jEwFVFrSs4h80
         0R6/cHOmiy6P9TjFXGEjHpoDtkek65Yy9nhyRUkH7LBeV4rvj1FOPN3kahwSMf9w6cFG
         Zxp5oFle785YxCQBqxdpRwYj0TBQid/GYT86GaHePoUsxbapuiwsge7NvhTZ5srJCrFx
         jE8Q==
X-Gm-Message-State: AOAM532LQP8p3pY11tFAuPMrEEeTrRKqCqaqGLR65XgsRGvgjGLmWym2
        Wm5u90uYbaLIBIcfF8P0XZ1nHITm3Aw=
X-Google-Smtp-Source: ABdhPJwb/utx76+XP84h3iTnGw5IeZy4uquOiqucLInRckn7SQuOn6r08CCG2JkrbHBFJs03Kgcgly9FTkM=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a25:59c3:0:b0:63d:8ccc:37b0 with SMTP id
 n186-20020a2559c3000000b0063d8ccc37b0mr17865179ybb.612.1649529960409; Sat, 09
 Apr 2022 11:46:00 -0700 (PDT)
Date:   Sat,  9 Apr 2022 18:45:37 +0000
In-Reply-To: <20220409184549.1681189-1-oupton@google.com>
Message-Id: <20220409184549.1681189-2-oupton@google.com>
Mime-Version: 1.0
References: <20220409184549.1681189-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.1178.g4f1659d476-goog
Subject: [PATCH v5 01/13] KVM: arm64: Don't depend on fallthrough to hide SYSTEM_RESET2
From:   Oliver Upton <oupton@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     alexandru.elisei@arm.com, anup@brainfault.org,
        atishp@atishpatra.org, james.morse@arm.com, jingzhangos@google.com,
        jmattson@google.com, joro@8bytes.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, maz@kernel.org,
        pbonzini@redhat.com, pshier@google.com, rananta@google.com,
        reijiw@google.com, ricarkol@google.com, seanjc@google.com,
        suzuki.poulose@arm.com, vkuznets@redhat.com, wanpengli@tencent.com,
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
---
 arch/arm64/kvm/psci.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
index baac2b405f23..3d43350ffb07 100644
--- a/arch/arm64/kvm/psci.c
+++ b/arch/arm64/kvm/psci.c
@@ -304,9 +304,9 @@ static int kvm_psci_0_2_call(struct kvm_vcpu *vcpu)
 
 static int kvm_psci_1_x_call(struct kvm_vcpu *vcpu, u32 minor)
 {
+	unsigned long val = PSCI_RET_NOT_SUPPORTED;
 	u32 psci_fn = smccc_get_function(vcpu);
 	u32 arg;
-	unsigned long val;
 	int ret = 1;
 
 	switch(psci_fn) {
@@ -319,6 +319,8 @@ static int kvm_psci_1_x_call(struct kvm_vcpu *vcpu, u32 minor)
 		if (val)
 			break;
 
+		val = PSCI_RET_NOT_SUPPORTED;
+
 		switch(arg) {
 		case PSCI_0_2_FN_PSCI_VERSION:
 		case PSCI_0_2_FN_CPU_SUSPEND:
@@ -337,13 +339,8 @@ static int kvm_psci_1_x_call(struct kvm_vcpu *vcpu, u32 minor)
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
@@ -364,7 +361,7 @@ static int kvm_psci_1_x_call(struct kvm_vcpu *vcpu, u32 minor)
 			val = PSCI_RET_INVALID_PARAMS;
 			break;
 		}
-		fallthrough;
+		break;
 	default:
 		return kvm_psci_0_2_call(vcpu);
 	}
-- 
2.35.1.1178.g4f1659d476-goog

