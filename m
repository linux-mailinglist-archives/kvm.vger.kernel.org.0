Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E35F04D67CC
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 18:41:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350839AbiCKRmN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Mar 2022 12:42:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350824AbiCKRmK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Mar 2022 12:42:10 -0500
Received: from mail-io1-xd4a.google.com (mail-io1-xd4a.google.com [IPv6:2607:f8b0:4864:20::d4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFFDC1C57F7
        for <kvm@vger.kernel.org>; Fri, 11 Mar 2022 09:41:04 -0800 (PST)
Received: by mail-io1-xd4a.google.com with SMTP id f7-20020a056602088700b00645ebbe277cso6711535ioz.22
        for <kvm@vger.kernel.org>; Fri, 11 Mar 2022 09:41:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=/OTsX1zNy9viFOplBNYstPkRDHNcJFJG5fv5Uk1YQKg=;
        b=KhxDlCEP7i5pg+TPes7A4wiJybDXQnCja8W3xvkSNQF7H3DtgDmlWLCoPooaX4bWcG
         jNjBUpUgA/81YMzi2tT8kBAhg20V3w9qA9irPbwHGRIXeiq9EJ+WSw5f9HuvIqUXXN9i
         Q+H4xiqVVwfMuHybjREevMIZdBqDFKe2FTk7Pp5DEGVxYYxe14uDne8K+0kcHNNhWp8V
         7qNrsuG+AJ3rzAuEf2KGaUWJQa0yZiIkpi1Ho3pU7bMqDx2LXIRKFsK5fYO7KJROHDME
         SH3KK9Zmp7xrdleqoXvSOFBiVC9i9SvtKoEtKPIhJMGe6wzm3Tx2epfNkQolsZ+pWKyY
         0Diw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=/OTsX1zNy9viFOplBNYstPkRDHNcJFJG5fv5Uk1YQKg=;
        b=AyRZxkewALpi9M3DuealpyxylvWyAOKEqjc/EoeM9SxgG7LOOEd3kgOjgg81SLQ2Tq
         xOpeDtuU3c/KoTW56uJKuEZ776ODHBTQSkPH9NHwGoX6bPOzOfHsJgdkTtPM+RDuwiit
         n1OIBGQoPOuaZBGiOfgIJPVZvDnsgnmaHpZ5o68oK7EHHOEN6bxeCWkmWjCKo5nipVEV
         Ky6zTTVgpMAL+Mzj2bgRSxOuFgpHKyoIvpi7L99e3Kn3YnkXBZAr4JN3QkSxeXvI2bpL
         tMq8yvaoA5DMARpt2UxieKQyD9uWPUZLUWJ+UhIe523b+yrmfqvG9vmtJcIri18RTM+/
         pEWA==
X-Gm-Message-State: AOAM533V2osB1oK/4EPNXZJ0SsC/8z+dDIqE+CBhSdupb4QKjBKaFDdB
        4Jpac6PlbKslOUrWmhA6KI6ZlDSv3Ig=
X-Google-Smtp-Source: ABdhPJwKry5EljdgitptBSCjxFA/9c5/1sGuFjMs3bGcqzT+eXHRrSrwo4UcxHiZrrN7ePcMplZ7dnDcXOQ=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a6b:750c:0:b0:641:3b39:7b24 with SMTP id
 l12-20020a6b750c000000b006413b397b24mr8761326ioh.139.1647020464165; Fri, 11
 Mar 2022 09:41:04 -0800 (PST)
Date:   Fri, 11 Mar 2022 17:39:49 +0000
In-Reply-To: <20220311174001.605719-1-oupton@google.com>
Message-Id: <20220311174001.605719-4-oupton@google.com>
Mime-Version: 1.0
References: <20220311174001.605719-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH v4 03/15] KVM: arm64: Don't depend on fallthrough to hide SYSTEM_RESET2
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
index cd3ee947485f..2a228744d0c4 100644
--- a/arch/arm64/kvm/psci.c
+++ b/arch/arm64/kvm/psci.c
@@ -310,9 +310,9 @@ static int kvm_psci_0_2_call(struct kvm_vcpu *vcpu)
 
 static int kvm_psci_1_x_call(struct kvm_vcpu *vcpu, u32 minor)
 {
+	unsigned long val = PSCI_RET_NOT_SUPPORTED;
 	u32 psci_fn = smccc_get_function(vcpu);
 	u32 arg;
-	unsigned long val;
 	int ret = 1;
 
 	if (minor > 1)
@@ -328,6 +328,8 @@ static int kvm_psci_1_x_call(struct kvm_vcpu *vcpu, u32 minor)
 		if (val)
 			break;
 
+		val = PSCI_RET_NOT_SUPPORTED;
+
 		switch(arg) {
 		case PSCI_0_2_FN_PSCI_VERSION:
 		case PSCI_0_2_FN_CPU_SUSPEND:
@@ -346,13 +348,8 @@ static int kvm_psci_1_x_call(struct kvm_vcpu *vcpu, u32 minor)
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
@@ -373,7 +370,7 @@ static int kvm_psci_1_x_call(struct kvm_vcpu *vcpu, u32 minor)
 			val = PSCI_RET_INVALID_PARAMS;
 			break;
 		}
-		fallthrough;
+		break;
 	default:
 		return kvm_psci_0_2_call(vcpu);
 	}
-- 
2.35.1.723.g4982287a31-goog

