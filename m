Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB6686D42B4
	for <lists+kvm@lfdr.de>; Mon,  3 Apr 2023 12:56:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231891AbjDCK4r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Apr 2023 06:56:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231644AbjDCK4k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Apr 2023 06:56:40 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 030F47294
        for <kvm@vger.kernel.org>; Mon,  3 Apr 2023 03:56:37 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id l12so28857929wrm.10
        for <kvm@vger.kernel.org>; Mon, 03 Apr 2023 03:56:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1680519394;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sPexPN8ih5rH0+fxHo4fd3sBIHWUHnjnfW2LV8nEB4Q=;
        b=KtAh2nx6LK/+MAymSXgHcdjNAaCAIwX6eqa0J2sQXzj8fcAOqPC0z9dqtBtGRlCgfR
         H/mzGZ3/8jTZrba2h77N4n1un5gKV22uNyPN/JdQaI2+4okfBgloltXPfJfCztiS6pWa
         /tYvW/9Zg4jachJPqDASiIyz0pcKIFbFX9kRMYvqf+PFYHg3Q/efkSGpdm6agJPgcGGE
         ELFCX850dV9y8iwN8g16TQ1kyS5pgSpe8sDtuhp935Mq4gC57pGo06RSiZ86SfAFDhCt
         eLYoehBV2PvFd1NfuoCIyc7qXqy/9nblQ5A+4bvN0Q8vO2c0r+xX5ElCVopKXA380bk7
         7+vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680519394;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sPexPN8ih5rH0+fxHo4fd3sBIHWUHnjnfW2LV8nEB4Q=;
        b=7TA7+UDI4KnsiIOU/d7SooScFUrVkI1J1n6NDJEKldLYo/olH4o9msazbLQnq4oCGi
         Zu3a62s66TL4gaYNKMmH6ocz3K5PqtCqqO3lwKNIgR+EtAZb32Vu2DpQ96XXyop/XvPU
         c6KkFf4oSbsWDuS5mRfp9TbbTTCYSDVoSpoiVWClnSwtI6A+mDLmHECfd59J/ew+qIaR
         6anm4P3XO0t2G12nNqopivfVP52OXCVprw3wTBze7m9g8szolacZGh5G96OI/ujXgZ99
         RNR9KMpnUrf3phOddKpsnQr2pPJxfrI/keb1f9USvjneinsKIc9m6eJm6iFkY8+aPckW
         o3gA==
X-Gm-Message-State: AAQBX9fIPfg7TTjRD4tjdkNFDKu1vcnJupqBIzjFxvcK9gW2OqagTRfg
        WvIIIq9sHryRn3EGH93/JR4Imk03iLVtQjiahJtmEA==
X-Google-Smtp-Source: AKy350bJGuWN4pk2OaBg0oPLi65JLM+nlNx1oFErHwf84duizutiMtZKI6AdBIzfdC2dPFuR/EGciQ==
X-Received: by 2002:a05:6000:118f:b0:2e7:29f:b4 with SMTP id g15-20020a056000118f00b002e7029f00b4mr4653008wrx.67.1680519394755;
        Mon, 03 Apr 2023 03:56:34 -0700 (PDT)
Received: from nuc.fritz.box (p200300f6af22160069a3c79c8928b176.dip0.t-ipconnect.de. [2003:f6:af22:1600:69a3:c79c:8928:b176])
        by smtp.gmail.com with ESMTPSA id x6-20020a5d60c6000000b002dfca33ba36sm9483671wrt.8.2023.04.03.03.56.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 03:56:34 -0700 (PDT)
From:   Mathias Krause <minipli@grsecurity.net>
To:     kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Mathias Krause <minipli@grsecurity.net>
Subject: [kvm-unit-tests PATCH v3 3/4] x86/access: Forced emulation support
Date:   Mon,  3 Apr 2023 12:56:17 +0200
Message-Id: <20230403105618.41118-4-minipli@grsecurity.net>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230403105618.41118-1-minipli@grsecurity.net>
References: <20230403105618.41118-1-minipli@grsecurity.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add support to enforce access tests to be handled by the emulator, if
supported by KVM. Exclude it from the ac_test_exec() test, though, to
not slow it down too much.

Signed-off-by: Mathias Krause <minipli@grsecurity.net>
---
 x86/access.c | 35 ++++++++++++++++++++++++++++++-----
 1 file changed, 30 insertions(+), 5 deletions(-)

diff --git a/x86/access.c b/x86/access.c
index a01278451b96..674077297978 100644
--- a/x86/access.c
+++ b/x86/access.c
@@ -82,6 +82,13 @@ enum {
 	AC_CPU_CR4_SMEP_BIT,
 	AC_CPU_CR4_PKE_BIT,
 
+	NR_AC_TEST_FLAGS,
+
+	/*
+	 *  synthetic flags follow, won't be exercised by ac_test_exec().
+	 */
+	AC_FEP_BIT,
+
 	NR_AC_FLAGS
 };
 
@@ -121,6 +128,8 @@ enum {
 #define AC_CPU_CR4_SMEP_MASK  (1 << AC_CPU_CR4_SMEP_BIT)
 #define AC_CPU_CR4_PKE_MASK   (1 << AC_CPU_CR4_PKE_BIT)
 
+#define AC_FEP_MASK           (1 << AC_FEP_BIT)
+
 const char *ac_names[] = {
 	[AC_PTE_PRESENT_BIT] = "pte.p",
 	[AC_PTE_ACCESSED_BIT] = "pte.a",
@@ -152,6 +161,7 @@ const char *ac_names[] = {
 	[AC_CPU_CR0_WP_BIT] = "cr0.wp",
 	[AC_CPU_CR4_SMEP_BIT] = "cr4.smep",
 	[AC_CPU_CR4_PKE_BIT] = "cr4.pke",
+	[AC_FEP_BIT] = "fep",
 };
 
 static inline void *va(pt_element_t phys)
@@ -396,7 +406,7 @@ static void ac_test_init(ac_test_t *at, unsigned long virt, ac_pt_env_t *pt_env)
 static int ac_test_bump_one(ac_test_t *at)
 {
 	at->flags = ((at->flags | invalid_mask) + 1) & ~invalid_mask;
-	return at->flags < (1 << NR_AC_FLAGS);
+	return at->flags < (1 << NR_AC_TEST_FLAGS);
 }
 
 #define F(x)  ((flags & x##_MASK) != 0)
@@ -799,10 +809,13 @@ static int ac_test_do_access(ac_test_t *at)
 
 	if (F(AC_ACCESS_TWICE)) {
 		asm volatile ("mov $fixed2, %%rsi \n\t"
-			      "mov (%[addr]), %[reg] \n\t"
+			      "cmp $0, %[fep] \n\t"
+			      "jz 1f \n\t"
+			      KVM_FEP
+			      "1: mov (%[addr]), %[reg] \n\t"
 			      "fixed2:"
 			      : [reg]"=r"(r), [fault]"=a"(fault), "=b"(e)
-			      : [addr]"r"(at->virt)
+			      : [addr]"r"(at->virt), [fep]"r"(F(AC_FEP))
 			      : "rsi");
 		fault = 0;
 	}
@@ -823,9 +836,15 @@ static int ac_test_do_access(ac_test_t *at)
 		      "jnz 2f \n\t"
 		      "cmp $0, %[write] \n\t"
 		      "jnz 1f \n\t"
-		      "mov (%[addr]), %[reg] \n\t"
+		      "cmp $0, %[fep] \n\t"
+		      "jz 0f \n\t"
+		      KVM_FEP
+		      "0: mov (%[addr]), %[reg] \n\t"
 		      "jmp done \n\t"
-		      "1: mov %[reg], (%[addr]) \n\t"
+		      "1: cmp $0, %[fep] \n\t"
+		      "jz 0f \n\t"
+		      KVM_FEP
+		      "0: mov %[reg], (%[addr]) \n\t"
 		      "jmp done \n\t"
 		      "2: call *%[addr] \n\t"
 		      "done: \n"
@@ -843,6 +862,7 @@ static int ac_test_do_access(ac_test_t *at)
 			[write]"r"(F(AC_ACCESS_WRITE)),
 			[user]"r"(F(AC_ACCESS_USER)),
 			[fetch]"r"(F(AC_ACCESS_FETCH)),
+			[fep]"r"(F(AC_FEP)),
 			[user_ds]"i"(USER_DS),
 			[user_cs]"i"(USER_CS),
 			[user_stack_top]"r"(user_stack + sizeof user_stack),
@@ -1233,6 +1253,11 @@ int ac_test_run(int pt_levels)
 		invalid_mask |= AC_PTE_BIT36_MASK;
 	}
 
+	if (!is_fep_available()) {
+		printf("FEP not available, skipping emulation tests\n");
+		invalid_mask |= AC_FEP_MASK;
+	}
+
 	ac_env_int(&pt_env, pt_levels);
 	ac_test_init(&at, 0xffff923400000000ul, &pt_env);
 
-- 
2.39.2

