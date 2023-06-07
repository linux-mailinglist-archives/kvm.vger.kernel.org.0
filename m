Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D945472704E
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 23:10:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235812AbjFGVKR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 17:10:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236512AbjFGVKP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 17:10:15 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D79792
        for <kvm@vger.kernel.org>; Wed,  7 Jun 2023 14:10:14 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-543a89d0387so1671801a12.1
        for <kvm@vger.kernel.org>; Wed, 07 Jun 2023 14:10:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686172214; x=1688764214;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=K0EBREewKdQA83fTIgtscWJZU7jHti9JvtLcFzhTPBk=;
        b=t5LFzfhhwz7zTgkpe5d0DQDWoNole4wibhdEVOb+EdL4iBaGBD1xK9XqLPyTIx5PZa
         K6yRG4dMIXlSUKJW+WNswsF2tAy+ihTyV7dUcuZoKAYd+BTFmD4Ev/RzXEXCzN5IGrf9
         O8sotj0cGewMLeg9Y6iSxqzNtlufEKf415ywHaL3UBzNugMbWI9wwTwK7yl5v+/KYIB5
         TZM/hhZ+MqwwkPmbI8CDtYyg0mKqFRHFQF6GOyV7BfHVM8A1xB0FRaZXpXRuArJFajqn
         Y0neRmdhoz1f9qLbnMH+lDl/CxZi+aQx9hDM5SNtmfvrmX39MZOFtha93QJMkFciA9RJ
         HzTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686172214; x=1688764214;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=K0EBREewKdQA83fTIgtscWJZU7jHti9JvtLcFzhTPBk=;
        b=OAzespNq+xZuWcCahyEGS7KM5diwYy2vjqilGvNhcqeHVfKVeUDI//1nMepy+ZwR63
         s5xFREvXkFXfcCugedZmqKe94rrFmgbChGAEKz9vHg0SKuM9f5+JNP5cKRjbknCZWIoW
         gboa1QUTxQOIipNTJFwosbdyDzVCfsefQ8j5dggudcGBEMMyONMVkV8z66Aw82bk78Ef
         wB/tHdM4gHxCIR72Sn9PWgLMuaRtKe0cLRmtvI8EJObQZqWJz3aF03jj6ujzNO1Cexgi
         zDLit/Rsi8jPWqqZKNIakm5Wp9rxxaDmfS16auwNQRERXb7lAwo320P/Pb68scEwkhSH
         3MQA==
X-Gm-Message-State: AC+VfDxHak0Pil4gBijfpZNX+dcGKNQwQ+Sw5VfX6G7mMc8YjHIdJ84E
        cOsJtz5xR+OkGQLgs4GMuqjT1t0chOw=
X-Google-Smtp-Source: ACHHUZ6FvgAXD55EozJdX3Z5YKUpi8qaZp/4jqc3bP7bBu/56STZOvkW0bQj3dRluCaLXPu1Trivohe3tG8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:2a95:0:b0:507:8088:9e0d with SMTP id
 q143-20020a632a95000000b0050780889e0dmr1486265pgq.7.1686172214162; Wed, 07
 Jun 2023 14:10:14 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  7 Jun 2023 14:09:59 -0700
In-Reply-To: <20230607210959.1577847-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230607210959.1577847-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.162.gfafddb0af9-goog
Message-ID: <20230607210959.1577847-7-seanjc@google.com>
Subject: [kvm-unit-tests PATCH 6/6] x86: nSVM: Print out RIP and LBRs from
 VMCB if LBRV guest test fails
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
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

Print out the RIP and LBRs from the VMCB's save are if a LBRV guest test
fails, i.e. exits for a reason other than VMMCALL.  Debugging the guests
is still beyond painful, but with the guest RIP and LBRs, it's at least
possible to piece together things like shutdowns due to unexpected #PF
because the tests neglected to setup the guest stack.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/svm_tests.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index de2cedc8..e56501c1 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -2791,6 +2791,12 @@ do {										\
 		asm volatile("ud2");						\
 } while (0)
 
+#define REPORT_GUEST_LBR_ERROR(vmcb)						\
+	report(false, "LBR guest test failed.  Exit reason 0x%x, RIP = %lx, from = %lx, to = %lx, ex from = %lx, ex to = %lx", \
+		       vmcb->control.exit_code, vmcb->save.rip,			\
+		       vmcb->save.br_from, vmcb->save.br_to,			\
+		       vmcb->save.last_excp_from, vmcb->save.last_excp_to)
+
 #define DO_BRANCH(branch_name)				\
 	asm volatile (					\
 		      # branch_name "_from:"		\
@@ -2888,8 +2894,7 @@ static void svm_lbrv_test1(void)
 	dbgctl = rdmsr(MSR_IA32_DEBUGCTLMSR);
 
 	if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
-		report(false, "VMEXIT not due to vmmcall. Exit reason 0x%x",
-		       vmcb->control.exit_code);
+		REPORT_GUEST_LBR_ERROR(vmcb);
 		return;
 	}
 
@@ -2912,8 +2917,7 @@ static void svm_lbrv_test2(void)
 	wrmsr(MSR_IA32_DEBUGCTLMSR, 0);
 
 	if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
-		report(false, "VMEXIT not due to vmmcall. Exit reason 0x%x",
-		       vmcb->control.exit_code);
+		REPORT_GUEST_LBR_ERROR(vmcb);
 		return;
 	}
 
@@ -2940,8 +2944,7 @@ static void svm_lbrv_nested_test1(void)
 	wrmsr(MSR_IA32_DEBUGCTLMSR, 0);
 
 	if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
-		report(false, "VMEXIT not due to vmmcall. Exit reason 0x%x",
-		       vmcb->control.exit_code);
+		REPORT_GUEST_LBR_ERROR(vmcb);
 		return;
 	}
 
@@ -2976,8 +2979,7 @@ static void svm_lbrv_nested_test2(void)
 	wrmsr(MSR_IA32_DEBUGCTLMSR, 0);
 
 	if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
-		report(false, "VMEXIT not due to vmmcall. Exit reason 0x%x",
-		       vmcb->control.exit_code);
+		REPORT_GUEST_LBR_ERROR(vmcb);
 		return;
 	}
 
-- 
2.41.0.162.gfafddb0af9-goog

