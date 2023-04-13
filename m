Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7FE26E146C
	for <lists+kvm@lfdr.de>; Thu, 13 Apr 2023 20:43:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230147AbjDMSnb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Apr 2023 14:43:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229999AbjDMSnK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Apr 2023 14:43:10 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99F8C61A9
        for <kvm@vger.kernel.org>; Thu, 13 Apr 2023 11:42:49 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id v6so15149312wrv.8
        for <kvm@vger.kernel.org>; Thu, 13 Apr 2023 11:42:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1681411368; x=1684003368;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4R4jaYe2ibW2haL/9vyM0m/t0V1yg/Lyd4jH33J0aRM=;
        b=XdixZa9ZhVXD5PDTwOvteFmmV7AIiww6tiS6EjHJcicaDHlrNx2UqZsQ7Hdh1S5FHi
         d5dVNJa4uxMSxFMOcFEm75/DkCEgQRbu6OpWTk/XA3TCmAJYuSOoBc57FLradFnezKV9
         3LHMKI8eFvLuIQGJG6PyvH1Gk03jZF723Q5f8xdtaTsTrEaWx4UDmNyYnMZK0A9k9UjL
         9DANy1ZIPXaJYSaanp82/3ojxaznroZTNv3LbzHJZAoeex6dROteItwnRH+V63UZooH4
         wp+Nxpxg0Y/fVmYmXjmM5IvjDfjFPM1hkfWEzVmZH4zJeYmVRk0aTRlJHuOR4TBy5QRO
         Zo3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681411368; x=1684003368;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4R4jaYe2ibW2haL/9vyM0m/t0V1yg/Lyd4jH33J0aRM=;
        b=Aygy8xQ1QIxLgra38ePW4wkoH6QSrA0vBc1OWvkCg3NUIdss1k53Kwgau6ZCsMQ/kn
         vRZkZ7vBcSNrx+xxVJgLvTYg03PlkUUKi0ZBkjMZPUpMNgg0kiiTkUa57KezYOKGhCp4
         hMACRZOwi8eSWTqaoZocYabtBLbt/jgUCxAUmUD9ICsfMgOEzfVkVFd9GCGKpN1JYrR3
         qxp40QBbs2Z1v6yd6zEYeN/3DjmutfcFnMbuI6B++6nEfOIiDnujq2Itcb4HuL6FuLgQ
         2zjJv9JWQP0RDcrcyf4lnSkyPynL/xhh7N6MNYPJmT0JeuFDbVkjo3Fmh3OaxnGTzNPT
         eOng==
X-Gm-Message-State: AAQBX9eE5DeNoOfwfywZ8kBu7SFjgcddP2Ny4N9Js+p2GAkdvb0U/t+O
        OdkiHR/AhtVohSNKYC6z8qDfVw==
X-Google-Smtp-Source: AKy350aWjT02JBCmjIpEh+gJaFp0RTV5RYknYa4bx71zNFTkn770OSv+kmI7ksZhp5vjsb8hE/BVWg==
X-Received: by 2002:adf:ef52:0:b0:2cf:3a99:9c1e with SMTP id c18-20020adfef52000000b002cf3a999c1emr2242247wrp.49.1681411368201;
        Thu, 13 Apr 2023 11:42:48 -0700 (PDT)
Received: from nuc.fritz.box (p200300f6af154800ce0bb7f104d5fcf7.dip0.t-ipconnect.de. [2003:f6:af15:4800:ce0b:b7f1:4d5:fcf7])
        by smtp.gmail.com with ESMTPSA id x15-20020a5d6b4f000000b002c8476dde7asm1812652wrw.114.2023.04.13.11.42.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Apr 2023 11:42:47 -0700 (PDT)
From:   Mathias Krause <minipli@grsecurity.net>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org
Cc:     Mathias Krause <minipli@grsecurity.net>
Subject: [kvm-unit-tests PATCH v2 16/16] x86/emulator64: Test non-canonical memory access exceptions
Date:   Thu, 13 Apr 2023 20:42:19 +0200
Message-Id: <20230413184219.36404-17-minipli@grsecurity.net>
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

A stack based memory access should generate a #SS(0) exception but
QEMU/TCG as of now (7.2) makes all exceptions based on a non-canonical
address generate a #GP(0) instead (issue linked below).

Add a test that will succeed when run under KVM but fail when using TCG.

Link: https://gitlab.com/qemu-project/qemu/-/issues/928
Signed-off-by: Mathias Krause <minipli@grsecurity.net>
---
v2: use ASM_TRY() as suggested by Sean

The non-canonical jump test is, apparently, broken under TCG as well.
It "succeeds," as in changing RIP and thereby creating a #GP loop.
I therefore put the new test in front of it to allow it to run.

 x86/emulator64.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/x86/emulator64.c b/x86/emulator64.c
index f8ff99fc39cc..e1a0968f5236 100644
--- a/x86/emulator64.c
+++ b/x86/emulator64.c
@@ -333,6 +333,33 @@ static void test_jmp_noncanonical(uint64_t *mem)
 	       "jump to non-canonical address");
 }
 
+static void test_reg_noncanonical(void)
+{
+	/* RAX based, should #GP(0) */
+	asm volatile(ASM_TRY("1f") "orq $0, (%[noncanonical]); 1:"
+		     : : [noncanonical]"a"(NONCANONICAL));
+	report(exception_vector() == GP_VECTOR && exception_error_code() == 0,
+	       "non-canonical memory access, should %s(0), got %s(%u)",
+	       exception_mnemonic(GP_VECTOR),
+	       exception_mnemonic(exception_vector()), exception_error_code());
+
+	/* RSP based, should #SS(0) */
+	asm volatile(ASM_TRY("1f") "orq $0, (%%rsp,%[noncanonical],1); 1:"
+		     : : [noncanonical]"r"(NONCANONICAL));
+	report(exception_vector() == SS_VECTOR && exception_error_code() == 0,
+	       "non-canonical rsp-based access, should %s(0), got %s(%u)",
+	       exception_mnemonic(SS_VECTOR),
+	       exception_mnemonic(exception_vector()), exception_error_code());
+
+	/* RBP based, should #SS(0) */
+	asm volatile(ASM_TRY("1f") "orq $0, (%%rbp,%[noncanonical],1); 1:"
+		     : : [noncanonical]"r"(NONCANONICAL));
+	report(exception_vector() == SS_VECTOR && exception_error_code() == 0,
+	       "non-canonical rbp-based access, should %s(0), got %s(%u)",
+	       exception_mnemonic(SS_VECTOR),
+	       exception_mnemonic(exception_vector()), exception_error_code());
+}
+
 static void test_movabs(uint64_t *mem)
 {
 	/* mov $0x9090909090909090, %rcx */
@@ -459,5 +486,6 @@ static void test_emulator_64(void *mem)
 
 	test_push16(mem);
 
+	test_reg_noncanonical();
 	test_jmp_noncanonical(mem);
 }
-- 
2.39.2

