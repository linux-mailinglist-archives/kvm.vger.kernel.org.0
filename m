Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A438C6E1461
	for <lists+kvm@lfdr.de>; Thu, 13 Apr 2023 20:43:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230115AbjDMSnQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Apr 2023 14:43:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230017AbjDMSnG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Apr 2023 14:43:06 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCE419029
        for <kvm@vger.kernel.org>; Thu, 13 Apr 2023 11:42:42 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id e7so5083644wrc.12
        for <kvm@vger.kernel.org>; Thu, 13 Apr 2023 11:42:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1681411361; x=1684003361;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WbrPT/N7Surh1jkNSimNnuJgTuWjitARPKRftYu1iuE=;
        b=VzaX3qjaz8tstpMvEBOWnMi9YMB8Ye413hyy1XgtsT/2md4d8Dlho4NnWjtJCdU+qa
         1yLb2N5bxVqlE45dInyGkui9toH9XjhbR3L+dXeP9CtoddJXHz8IJUjtcr/PKLcIXd4/
         YbamCWT9O3sbwzbjFPPEr9p0ZpupZbkslF069qek7pHuA2cmkkR5VcPoRiEZ7pvE3K1E
         T2Dc8jfe9UgOqm64H5wnzhTBijcSBfRetpzqzegoPB29YPy1pJtlQqCgCODQ3vTvYB5T
         x7NJTc4iINK1InhXbCPu8SPtO5JCOlcnOJCcKPglk1kant2ncs4V0VPSLg98i0YPJctx
         Ufcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681411361; x=1684003361;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WbrPT/N7Surh1jkNSimNnuJgTuWjitARPKRftYu1iuE=;
        b=FHizQWaZJRLu5P2H77g+92gyiBfMAY8ArrMDZXjguLcyumr/9wxdYShBgpQt2gc8MR
         l/sg/XsbYHbanYK5pyU9G3nHnrStuBAG5xEhQ7spBsSlR0vbpINGym5LHSo+fZCPkjfM
         1rs6KRmmz6rpeXFlaG697Pmp4dCp/OIvBF0sEhT7EJNiJT9lhwNbCYpLaOyyQ/DfeAIz
         +8zTjjoS2xF3ZwUQ0D1r1vNPexIkXx0NQmvErEGTAsGtP1XaoeVYEv9c8vhHKllEXCpf
         0rZVYiCyYMKd7rKY1Xu4Cszkk+4ef65cz/6yMG56l/XEG95Ua21UtdYTxZbJHogXEiq2
         vesA==
X-Gm-Message-State: AAQBX9fyTiIfygdQOMlcPIimeo4nFKDntlAwXUR9xGK1+JlD5Wb6vNZF
        VBEDzK2Do6fxkOxpyFSWNmUvsA==
X-Google-Smtp-Source: AKy350b8DGOwzexJ00EeAUX3M/0Yxv+Vz0gZth1tZmp7wUCvniQ/lLJRnxEEvIY1R+cqpw5d/NlMKg==
X-Received: by 2002:adf:ef05:0:b0:2c3:e7d8:245c with SMTP id e5-20020adfef05000000b002c3e7d8245cmr2605773wro.13.1681411361334;
        Thu, 13 Apr 2023 11:42:41 -0700 (PDT)
Received: from nuc.fritz.box (p200300f6af154800ce0bb7f104d5fcf7.dip0.t-ipconnect.de. [2003:f6:af15:4800:ce0b:b7f1:4d5:fcf7])
        by smtp.gmail.com with ESMTPSA id x15-20020a5d6b4f000000b002c8476dde7asm1812652wrw.114.2023.04.13.11.42.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Apr 2023 11:42:41 -0700 (PDT)
From:   Mathias Krause <minipli@grsecurity.net>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org
Cc:     Mathias Krause <minipli@grsecurity.net>
Subject: [kvm-unit-tests PATCH v2 07/16] x86/run_in_user: Preserve exception handler
Date:   Thu, 13 Apr 2023 20:42:10 +0200
Message-Id: <20230413184219.36404-8-minipli@grsecurity.net>
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

run_in_user() replaces the exception handler for the expected fault
vector to ensure the code can properly return back to kernel mode in
case of such exceptions. However, it leaves the exception handler in
place which may confuse later test code triggering the same exception
without installing a handler first.

Fix this be restoring the previous exception handler. Running the
longjmp() handler out of context will lead to no good.

We now also need to make 'rax' volatile to avoid a related compiler
warning.

Signed-off-by: Mathias Krause <minipli@grsecurity.net>
---
 lib/x86/usermode.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/lib/x86/usermode.c b/lib/x86/usermode.c
index b976123ca753..10fcea288a62 100644
--- a/lib/x86/usermode.c
+++ b/lib/x86/usermode.c
@@ -36,15 +36,17 @@ uint64_t run_in_user(usermode_func func, unsigned int fault_vector,
 		uint64_t arg4, bool *raised_vector)
 {
 	extern char ret_to_kernel[];
-	uint64_t rax = 0;
+	volatile uint64_t rax = 0;
 	static unsigned char user_stack[USERMODE_STACK_SIZE];
+	handler old_ex;
 
 	*raised_vector = 0;
 	set_idt_entry(RET_TO_KERNEL_IRQ, ret_to_kernel, 3);
-	handle_exception(fault_vector,
-			restore_exec_to_jmpbuf_exception_handler);
+	old_ex = handle_exception(fault_vector,
+				  restore_exec_to_jmpbuf_exception_handler);
 
 	if (setjmp(jmpbuf) != 0) {
+		handle_exception(fault_vector, old_ex);
 		*raised_vector = 1;
 		return 0;
 	}
@@ -114,5 +116,7 @@ uint64_t run_in_user(usermode_func func, unsigned int fault_vector,
 			:
 			"rsi", "rdi", "rcx", "rdx");
 
+	handle_exception(fault_vector, old_ex);
+
 	return rax;
 }
-- 
2.39.2

