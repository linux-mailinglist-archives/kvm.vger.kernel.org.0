Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 798E76E1469
	for <lists+kvm@lfdr.de>; Thu, 13 Apr 2023 20:43:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230170AbjDMSnY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Apr 2023 14:43:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230056AbjDMSnJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Apr 2023 14:43:09 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B19E793F6
        for <kvm@vger.kernel.org>; Thu, 13 Apr 2023 11:42:46 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id n19-20020a05600c501300b003f064936c3eso13713643wmr.0
        for <kvm@vger.kernel.org>; Thu, 13 Apr 2023 11:42:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1681411365; x=1684003365;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ESQ+BfeZUo7v07/2Wqyt37Bb9GRSnMpcy+kHTBycy9Y=;
        b=uK5+hAMaF8H4NLLmqjUFeYI51VTtAb60r5CSkUPRv+Abj7OuN27oAupo95iWpiLNgp
         pmbQgF/CP9UjxGtXDA3/yCxyUqQ6iGkz7Uci9KuMpagrTlJtD0Foyo8vAuhdKxVsurqz
         9Flj8LlqIc9BbWyAEZwQ/bpOA2+sod63ljSO3kRDWzUk/rsxkFZ+7uwezttQPRoaPRVS
         jvktwyU/Apm3BLZI7nDvakFx7XJMFIBlhJQ4RFlYgFyaT4RwFonwhrJ5DNfzzyhweRT/
         CvxPxfNhbiXXWqCwv4Z69UOxthOU9o0rro1RDe9Zh9Xj8r/4c8AruoQWNUh6zhuXKsBw
         0QLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681411365; x=1684003365;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ESQ+BfeZUo7v07/2Wqyt37Bb9GRSnMpcy+kHTBycy9Y=;
        b=Azb2Z8Wbk5x8+zTsFpEqEbapTaspR4MdObJHfewuJXXC54AQv2CIMyLIzueRjMkQTl
         6oArJ80FGV02BtVPYK5FUq3y3vipoVYzRUmhbklbmy137+buPpmCa11ZsmNESX9vDlbX
         NyCbbVjeIRqEUJJYkgc/QaqM54YQuo9cAQ8nk6vWHrVMIhxuetldtrZ4OOaox4qeykRi
         aVC3o3lYE0FS0yGUNNlKzK28uNsXubDDVQ/n3l4mBO6D3d2CF0qnFbTFgj6h3MamC+4F
         E4fboadMqViwM79lsWfW6Gs2prFd3vv6gOrVZiC72dJZ9oXXnFn/wv1mlNhHm3lu7YpJ
         qcVA==
X-Gm-Message-State: AAQBX9fa9ufmY03S5r8dVHlzhTdVlOirpuWq+Yqf65bFQDokQVwTTQq3
        yJtt7ZnMVTyGFrfDerxP2xmp1APlfczEXXpfhng=
X-Google-Smtp-Source: AKy350Z8vmxwbQY0yue92CnvUxb+wDcBy6J/DqJzY3VUhgPTSJEttcckhnk1+DH747Yc6dhYb7R0/w==
X-Received: by 2002:a05:600c:1e11:b0:3f0:4275:395f with SMTP id ay17-20020a05600c1e1100b003f04275395fmr2110437wmb.13.1681411365358;
        Thu, 13 Apr 2023 11:42:45 -0700 (PDT)
Received: from nuc.fritz.box (p200300f6af154800ce0bb7f104d5fcf7.dip0.t-ipconnect.de. [2003:f6:af15:4800:ce0b:b7f1:4d5:fcf7])
        by smtp.gmail.com with ESMTPSA id x15-20020a5d6b4f000000b002c8476dde7asm1812652wrw.114.2023.04.13.11.42.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Apr 2023 11:42:45 -0700 (PDT)
From:   Mathias Krause <minipli@grsecurity.net>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org
Cc:     Mathias Krause <minipli@grsecurity.net>
Subject: [kvm-unit-tests PATCH v2 12/16] x86/emulator64: Switch test_sreg() to ASM_TRY()
Date:   Thu, 13 Apr 2023 20:42:15 +0200
Message-Id: <20230413184219.36404-13-minipli@grsecurity.net>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230413184219.36404-1-minipli@grsecurity.net>
References: <20230413184219.36404-1-minipli@grsecurity.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Instead of registering a one-off exception handler, make use of
ASM_TRY() to catch the exception. Also test the error code to match the
failing segment selector (NULL) as the code now easily can access it.

Signed-off-by: Mathias Krause <minipli@grsecurity.net>
---
 x86/emulator64.c | 18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

diff --git a/x86/emulator64.c b/x86/emulator64.c
index 4138eaae00c9..a98c66c2b44f 100644
--- a/x86/emulator64.c
+++ b/x86/emulator64.c
@@ -385,18 +385,9 @@ static void test_push16(uint64_t *mem)
 	report(rsp1 == rsp2, "push16");
 }
 
-static void ss_bad_rpl(struct ex_regs *regs)
-{
-	extern char ss_bad_rpl_cont;
-
-	++exceptions;
-	regs->rip = (ulong)&ss_bad_rpl_cont;
-}
-
 static void test_sreg(volatile uint16_t *mem)
 {
 	u16 ss = read_ss();
-	handler old;
 
 	// check for null segment load
 	*mem = 0;
@@ -404,13 +395,12 @@ static void test_sreg(volatile uint16_t *mem)
 	report(read_ss() == 0, "mov null, %%ss");
 
 	// check for exception when ss.rpl != cpl on null segment load
-	exceptions = 0;
-	old = handle_exception(GP_VECTOR, ss_bad_rpl);
 	*mem = 3;
-	asm volatile("mov %0, %%ss; ss_bad_rpl_cont:" : : "m"(*mem));
-	report(exceptions == 1 && read_ss() == 0,
+	asm volatile(ASM_TRY("1f") "mov %0, %%ss; 1:" : : "m"(*mem));
+	report(exception_vector() == GP_VECTOR &&
+	       exception_error_code() == 0 && read_ss() == 0,
 	       "mov null, %%ss (with ss.rpl != cpl)");
-	handle_exception(GP_VECTOR, old);
+
 	write_ss(ss);
 }
 
-- 
2.39.2

