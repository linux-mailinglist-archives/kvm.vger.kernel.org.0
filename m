Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6985D58CC59
	for <lists+kvm@lfdr.de>; Mon,  8 Aug 2022 18:47:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242930AbiHHQrW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Aug 2022 12:47:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243542AbiHHQrT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Aug 2022 12:47:19 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C63EC167DA
        for <kvm@vger.kernel.org>; Mon,  8 Aug 2022 09:47:18 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id f16-20020a17090a4a9000b001f234757bbbso4604746pjh.6
        for <kvm@vger.kernel.org>; Mon, 08 Aug 2022 09:47:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:from:to:cc;
        bh=TkHCpN+3ZqwwnZpNWTP8hpxuKAU6AeHDLT5N18TkTYw=;
        b=PtTXd8v0hH6GUh27qb78/G0RWnK2wcrWQ499GZF52Uuh6/3bW+tbnE24p42xxDx0pS
         OxpzbzRxlKl5hxPbUg+ncJdCn8A4uKm3qAZW2TH3D5YqH8yj8+Ky3Hl2nUXRDOPozP/H
         xrgMZo2YedQSXnbPDn6adC/E9ZeA9C6vD6ypMwsP8rLYxM569wTXshtwyVd2tvUXFlJn
         IavkIBuET26n8XAgfIDPJo1K5HBW7f/38vu0bRva/VvduhYVFC4YqKj/mEwqB2xnrega
         oQ1DPgH8kfHFqAmd/mObihAIC4VlZ9lhZfbyRYuq3ptg88oZn6DG1rHZ+BFS56XgGUJL
         Zhug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=TkHCpN+3ZqwwnZpNWTP8hpxuKAU6AeHDLT5N18TkTYw=;
        b=3tPf3fcWCdCIG1bVNADcAfftJCaCY2mXkeBJqPE1ktkAPXtEvUKEaqRDUt06qWG7uz
         9UVBhx9JLi/cPtpIqfiGI52scTs/G3/HbqIU9Yr4ZfC0JbE4X+wvJn8OLxZSFNInmmmS
         j/ewF+jYXjjqIyra0uwuPCUDJSQBhQhVnL+xh+CQcUF1TKqMcY5eaBMthtJ5km8KITGw
         VfdpXhb9ymhyfLJveexzHgrrxxt174bMM2+c5HEnEqw7NPEaFOtuvmE+Jlu1MVJkARqO
         S+krqiogXtnfzLAQKG4oO8DpS+vudzuFT1ZIWHsdQDy6AqWs5mgyIpcpgypk8db2ZG+B
         dRFw==
X-Gm-Message-State: ACgBeo2IGfiAiYJVc8wnPa/VTxMIUw1Ikzt7Br6xukd4WCPUBsWAcePc
        Jb6FsnCV8GUI2Sah0eUIcAD+C5aeV2c=
X-Google-Smtp-Source: AA6agR5Nr+KaKm4O/LZGHmuZxyJt3XhsLg1VRipSEN7myQuM5SFYC/0fK32tL7gYM7ApJPahVrXJz89kqPw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:228f:b0:16f:1b48:230c with SMTP id
 b15-20020a170903228f00b0016f1b48230cmr18998667plh.78.1659977238298; Mon, 08
 Aug 2022 09:47:18 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon,  8 Aug 2022 16:47:05 +0000
In-Reply-To: <20220808164707.537067-1-seanjc@google.com>
Message-Id: <20220808164707.537067-6-seanjc@google.com>
Mime-Version: 1.0
References: <20220808164707.537067-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.1.559.g78731f0fdb-goog
Subject: [kvm-unit-tests PATCH v3 5/7] x86: emulator.c: Use ASM_TRY() for the
 UD_VECTOR cases
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Michal Luczaj <mhal@rbox.co>
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

From: Michal Luczaj <mhal@rbox.co>

For #UD handling use ASM_TRY() instead of handle_exception().

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Michal Luczaj <mhal@rbox.co>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/emulator.c | 26 +++++++++++---------------
 1 file changed, 11 insertions(+), 15 deletions(-)

diff --git a/x86/emulator.c b/x86/emulator.c
index e1272a6..cc20440 100644
--- a/x86/emulator.c
+++ b/x86/emulator.c
@@ -1094,27 +1094,23 @@ static void test_simplealu(u32 *mem)
     report(*mem == 0x8400, "test");
 }
 
-static void illegal_movbe_handler(struct ex_regs *regs)
-{
-	extern char bad_movbe_cont;
-
-	++exceptions;
-	regs->rip = (ulong)&bad_movbe_cont;
-}
-
 static void test_illegal_movbe(void)
 {
+	unsigned int vector;
+
 	if (!this_cpu_has(X86_FEATURE_MOVBE)) {
-		report_skip("illegal movbe");
+		report_skip("MOVBE unsupported by CPU");
 		return;
 	}
 
-	exceptions = 0;
-	handle_exception(UD_VECTOR, illegal_movbe_handler);
-	asm volatile(".byte 0x0f; .byte 0x38; .byte 0xf0; .byte 0xc0;\n\t"
-		     " bad_movbe_cont:" : : : "rax");
-	report(exceptions == 1, "illegal movbe");
-	handle_exception(UD_VECTOR, 0);
+	asm volatile(ASM_TRY("1f")
+		     ".byte 0x0f; .byte 0x38; .byte 0xf0; .byte 0xc0;\n\t"
+		     "1:"
+		     : : : "memory", "rax");
+
+	vector = exception_vector();
+	report(vector == UD_VECTOR,
+	       "Wanted #UD on MOVBE with /reg, got vector = %u", vector);
 }
 
 int main(void)
-- 
2.37.1.559.g78731f0fdb-goog

