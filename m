Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C1F75A19EA
	for <lists+kvm@lfdr.de>; Thu, 25 Aug 2022 22:00:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242861AbiHYT7v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Aug 2022 15:59:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243133AbiHYT7s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Aug 2022 15:59:48 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEE262AE2
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 12:59:46 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-33931a5c133so273208897b3.17
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 12:59:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc;
        bh=yfDxhI5ova7o4/xdlPAdlKktr1BlXQnFI7iSPEA2zh8=;
        b=Rqk19HVItDIVFY3SLJLNI0H4gElzA+YHaZqJLfmaPkz2mrsUeEGuKdWGPsJQ8gU+mS
         m37v1Px5ZILLydCV7N8ZWocHodSltbFAx1wcCUJeH9WICEQu+Loek6bH/Mw7RTt5iuhG
         FTCx3wmVXQgEOPLz/yWhEJZ4bY2yhmyclFMSMxf6ilVZdWkTeE7F2bbH5Y2IC17+dojs
         rGm7lfHd42ZRe4ZJ7F0Q+/ycO4g8fCBU9OXAz7nBUk64sXfBuF0yE1311DDCwTzrmRLx
         6sSM4ckA6xXBapJivuiggeMYcjEkf2bc8RhHficjthmmP8aFuUoFud9aNcpEvAo0amFD
         WWNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=yfDxhI5ova7o4/xdlPAdlKktr1BlXQnFI7iSPEA2zh8=;
        b=l0b5uEmlPKWLt0KJoBpgDoz4vQlk1lohrbbWNYsC+f5Dc9efehuO3GYsTPJNr7J04n
         8fG6WgkDvEGI4Bu9junDok86LUBNdWGvB97CdF5DCsb/F1qwpHCyAIOkRpS7zac5TGrc
         vyw8KWNc0Gs8Hvw5kFUjvENy9W9QeJb1636bNUgkREpsVqXRbiVwpVoksXIBeLjLixhj
         DToMV2VnM1yR3G4+nxxA2MFghlNJokG3UpvtHnmqkfkk122hjuRjaM4sZYc1d6hNxoVs
         WX+UMw/ieAzo7ED9YXqbamkZnmWzc1biZUy5XU5D31VNaSM/lcAwJ+SL1FR0Zbd9q7N3
         yNTQ==
X-Gm-Message-State: ACgBeo2sFPXOmGd8/Tfzo+D9+QWilRM8qSPr3bZ865RvHwS0HlLWY3Mx
        Xk2l5MsPQKKTKOu0pF4h7JEUQwC1GIs=
X-Google-Smtp-Source: AA6agR7wgQ2jd7AkQl5nRS+Dg4cVkdUU2ANkLtHPGf1pT5X/TENRiJisEW0E65PfQKnR5gO4iEzeM8oc+2M=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:83c5:0:b0:334:a89b:1e5d with SMTP id
 t188-20020a8183c5000000b00334a89b1e5dmr5170556ywf.178.1661457586174; Thu, 25
 Aug 2022 12:59:46 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 25 Aug 2022 19:59:36 +0000
In-Reply-To: <20220825195939.3959292-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220825195939.3959292-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220825195939.3959292-3-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v2 2/5] x86/emulator: Move basic "MOV" test to
 its own helper function
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

Move the basic "MOV reg, mod/rm" test to its own helper function, there's
no reason to give it special status.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/emulator.c | 25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/x86/emulator.c b/x86/emulator.c
index 322c466..fe29540 100644
--- a/x86/emulator.c
+++ b/x86/emulator.c
@@ -1069,6 +1069,20 @@ static void test_ltr(volatile uint16_t *mem)
     report(str() == tr && (*trp & busy_mask), "ltr");
 }
 
+static void test_mov(void *mem)
+{
+	unsigned long t1, t2;
+
+	// test mov reg, r/m and mov r/m, reg
+	t1 = 0x123456789abcdef;
+	asm volatile("mov %[t1], (%[mem]) \n\t"
+		     "mov (%[mem]), %[t2]"
+		     : [t2]"=r"(t2)
+		     : [t1]"r"(t1), [mem]"r"(mem)
+		     : "memory");
+	report(t2 == 0x123456789abcdef, "mov reg, r/m (1)");
+}
+
 static void test_simplealu(u32 *mem)
 {
     *mem = 0x1234;
@@ -1119,7 +1133,6 @@ int main(void)
 	void *insn_page;
 	void *insn_ram;
 	void *cross_mem;
-	unsigned long t1, t2;
 
 	setup_vm();
 
@@ -1131,15 +1144,7 @@ int main(void)
 	insn_ram = vmap(virt_to_phys(insn_page), 4096);
 	cross_mem = vmap(virt_to_phys(alloc_pages(2)), 2 * PAGE_SIZE);
 
-	// test mov reg, r/m and mov r/m, reg
-	t1 = 0x123456789abcdef;
-	asm volatile("mov %[t1], (%[mem]) \n\t"
-		     "mov (%[mem]), %[t2]"
-		     : [t2]"=r"(t2)
-		     : [t1]"r"(t1), [mem]"r"(mem)
-		     : "memory");
-	report(t2 == 0x123456789abcdef, "mov reg, r/m (1)");
-
+	test_mov(mem);
 	test_simplealu(mem);
 	test_cmps(mem);
 	test_scas(mem);
-- 
2.37.2.672.g94769d06f0-goog

