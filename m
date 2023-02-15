Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85FD0697E42
	for <lists+kvm@lfdr.de>; Wed, 15 Feb 2023 15:21:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbjBOOVX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Feb 2023 09:21:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbjBOOVW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Feb 2023 09:21:22 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D2BE38B56
        for <kvm@vger.kernel.org>; Wed, 15 Feb 2023 06:21:20 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id hx15so48503851ejc.11
        for <kvm@vger.kernel.org>; Wed, 15 Feb 2023 06:21:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=cARja9lxwBvixdTFiwpqYAd+ioWiC3TZCNv5OeWUSmA=;
        b=CLgKOBgGAfFprr0rSBt4pLBTOPC9J6gvGirkGrUtFd2c9p0lX+473SNG8t59Wo6qyF
         2eCphq9yowBkB2TEEy022XcXZ7iIJ8i3Q6EwJpX1e3/1T2T2cJehBPJbDg+hkBMm4XkS
         eTKCuBH8furmW34WDrNXxje/FfnZGZp3Xl7BErYpF40DUNQdKB6Y9kCwtPZ6cY8fYgdR
         efe2ZGG2I9OdibGfAND/otngjL0RApnJCINj19XIMu2EX6a7VzZp+cHmxJHAi84ALVd1
         boOD28piwBlvt+o4JSwPHJLToHtKIT0g5sDjvn301ISPnslyxwXJqs2vAAQ9rSfkTb1T
         9gNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cARja9lxwBvixdTFiwpqYAd+ioWiC3TZCNv5OeWUSmA=;
        b=sRc1wz/nTEc1mx/cDOPLy3NbGxQW/hwX93DZquGDS8oDtl7IZoCbCNaXTikU7nWSF+
         rh51u1nb4iJRr1B1kOuThUAXEw8M5g/e1bfsFUMwua/yhdMNQR53tz1Uf3lYTrZfc4U4
         6xCXsrrr7GzQKkQ7guleSlD/1kajaw8xvK/Dc5+CIR4eCwWjpVSXF/pWAEhcAYpQTGlv
         z9/dqzcJyITduvsEbWnk/7wD0OzeTiaT6AeXvF18OJLl5k4EJURLKmwmHvnwHhNBBwtQ
         uV83eV8qe3aVX5a88YMk+BsJEjzsjCrlo9gg4nSiHwiNmyJWWZwZwx/apkeXkeHGWTjW
         qMmg==
X-Gm-Message-State: AO0yUKXnqifAJkyHCtKQGXyJ0zmstD4+b9eNvCJl9Wr59G/N9jWkeLhP
        19en7ttppYnHA54MYxtL+cKIz1nwjdOnFhi6
X-Google-Smtp-Source: AK7set+TVbwa6jguNqJi1VpCRumRGM1hVEW3Gl1bgEMZRQXeSq01oT1gYLFV4lRis8dXbcIMYGgfEQ==
X-Received: by 2002:a17:906:b297:b0:8b1:4b6d:c57a with SMTP id q23-20020a170906b29700b008b14b6dc57amr977913ejz.21.1676470878967;
        Wed, 15 Feb 2023 06:21:18 -0800 (PST)
Received: from nuc.fritz.box (p200300f6af0f8e00a24b5c73d1c44ce0.dip0.t-ipconnect.de. [2003:f6:af0f:8e00:a24b:5c73:d1c4:4ce0])
        by smtp.gmail.com with ESMTPSA id b4-20020a17090630c400b008af3930c394sm9611577ejb.60.2023.02.15.06.21.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Feb 2023 06:21:18 -0800 (PST)
From:   Mathias Krause <minipli@grsecurity.net>
To:     kvm@vger.kernel.org
Cc:     Mathias Krause <minipli@grsecurity.net>
Subject: [kvm-unit-tests PATCH] x86/emulator: Test non-canonical memory access exceptions
Date:   Wed, 15 Feb 2023 15:23:44 +0100
Message-Id: <20230215142344.20200-1-minipli@grsecurity.net>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A stack based memory access should generate a #SS(0) exception but
QEMU/TCG as of now (7.2) makes all exceptions based on a non-canonical
address generate a #GP(0) instead (issue linked below).

Add a test that will succeed when run under KVM but fail when using TCG.

Link: https://gitlab.com/qemu-project/qemu/-/issues/928
Signed-off-by: Mathias Krause <minipli@grsecurity.net>
---
The non-canonical jump test is, apparently, broken under TCG as well.
It "succeeds," as in changing RIP and thereby creating a #GP loop.
I therefore put the new test in front of it to allow it to run.

 x86/emulator64.c | 52 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 52 insertions(+)

diff --git a/x86/emulator64.c b/x86/emulator64.c
index 7f55d388c597..df2cd2c85308 100644
--- a/x86/emulator64.c
+++ b/x86/emulator64.c
@@ -2,10 +2,12 @@
 #define GS_BASE 0x400000
 
 static unsigned long rip_advance;
+static struct ex_regs last_ex_regs;
 
 static void advance_rip_and_note_exception(struct ex_regs *regs)
 {
 	++exceptions;
+	last_ex_regs = *regs;
 	regs->rip += rip_advance;
 }
 
@@ -347,6 +349,55 @@ static void test_jmp_noncanonical(uint64_t *mem)
 	handle_exception(GP_VECTOR, old);
 }
 
+static void test_reg_noncanonical(void)
+{
+	extern char nc_rsp_start, nc_rsp_end, nc_rbp_start, nc_rbp_end;
+	extern char nc_rax_start, nc_rax_end;
+	handler old_ss, old_gp;
+
+	old_ss = handle_exception(SS_VECTOR, advance_rip_and_note_exception);
+	old_gp = handle_exception(GP_VECTOR, advance_rip_and_note_exception);
+
+	/* RAX based, should #GP(0) */
+	exceptions = 0;
+	rip_advance = &nc_rax_end - &nc_rax_start;
+	asm volatile("nc_rax_start: orq $0, (%[msb]); nc_rax_end:\n\t"
+		     : : [msb]"a"(1ul << 63));
+	report(exceptions == 1
+	       && last_ex_regs.vector == GP_VECTOR
+	       && last_ex_regs.error_code == 0,
+	       "non-canonical memory access, should %s(0), got %s(%lu)",
+	       exception_mnemonic(GP_VECTOR),
+	       exception_mnemonic(last_ex_regs.vector), last_ex_regs.error_code);
+
+	/* RSP based, should #SS(0) */
+	exceptions = 0;
+	rip_advance = &nc_rsp_end - &nc_rsp_start;
+	asm volatile("nc_rsp_start: orq $0, (%%rsp,%[msb],1); nc_rsp_end:\n\t"
+		     : : [msb]"r"(1ul << 63));
+	report(exceptions == 1
+	       && last_ex_regs.vector == SS_VECTOR
+	       && last_ex_regs.error_code == 0,
+	       "non-canonical rsp-based access, should %s(0), got %s(%lu)",
+	       exception_mnemonic(SS_VECTOR),
+	       exception_mnemonic(last_ex_regs.vector), last_ex_regs.error_code);
+
+	/* RBP based, should #SS(0) */
+	exceptions = 0;
+	rip_advance = &nc_rbp_end - &nc_rbp_start;
+	asm volatile("nc_rbp_start: orq $0, (%%rbp,%[msb],1); nc_rbp_end:\n\t"
+		     : : [msb]"r"(1ul << 63));
+	report(exceptions == 1
+	       && last_ex_regs.vector == SS_VECTOR
+	       && last_ex_regs.error_code == 0,
+	       "non-canonical rbp-based access, should %s(0), got %s(%lu)",
+	       exception_mnemonic(SS_VECTOR),
+	       exception_mnemonic(last_ex_regs.vector), last_ex_regs.error_code);
+
+	handle_exception(SS_VECTOR, old_ss);
+	handle_exception(GP_VECTOR, old_gp);
+}
+
 static void test_movabs(uint64_t *mem)
 {
 	/* mov $0x9090909090909090, %rcx */
@@ -460,5 +511,6 @@ static void test_emulator_64(void *mem)
 
 	test_push16(mem);
 
+	test_reg_noncanonical();
 	test_jmp_noncanonical(mem);
 }
-- 
2.39.1

