Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27E546E1468
	for <lists+kvm@lfdr.de>; Thu, 13 Apr 2023 20:43:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230206AbjDMSnX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Apr 2023 14:43:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230046AbjDMSnJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Apr 2023 14:43:09 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 445BD6E86
        for <kvm@vger.kernel.org>; Thu, 13 Apr 2023 11:42:45 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id v27so5949348wra.13
        for <kvm@vger.kernel.org>; Thu, 13 Apr 2023 11:42:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1681411364; x=1684003364;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CqfqWd6G1AH8YUNbkpR+KkIq4eBkb+8HCcDjE871iFM=;
        b=HJOatyWJ7QKwqsXWe0WpNl/vKg3NtVbEKXy5yfbzjgTg1sz5ly+uivqQexNLzoQmBa
         McHEyxeXx0iPQ0RzPcaGRl+sWlKs7fXw/yCiQHs/Fd9aYpF8l3vC5fBhnxyvqtPC9T8S
         qDkCkqNu18525qzP9URa+pAWK1JFoJoDbAO7SJp44BL2MZRQAyfd4kARtuk6J8/+3PGK
         RyEmmBSO3vVK5Tf600npFpgQ44i0RsaBS8zEK1939zJBQgZJ2c7GDI0oMcxNFvbKnYm3
         q6REAR+/pdeW5FF6u7Jb1g5ImUe8ats+qVCgLKJGKmMPidlKlEem4miEk80yDVzVdhAG
         jCyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681411364; x=1684003364;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CqfqWd6G1AH8YUNbkpR+KkIq4eBkb+8HCcDjE871iFM=;
        b=VxGkK+PQ19icl4MTAi8e6p4Jnc7EhWVbghkyGAulBy5dP2fhqfnNDBCyhzy28gHaph
         UA1Qjsb85X6vZLPR8E7H3BPY+Q0Ma25h4vEouJFCUu1zMaxC5qCE7I4EKJ44j8pzNBoD
         WzqsAdJwIpjOMCm1VB8aZ7Z3XsW2qtZocl6HsFRicY8P+O8LfPe4FDgrxdbXiJYNKyv/
         owEJkqbAZ9G+4lR5wpROGpqs5EuropQEmFnApj0gBYfCEazjiDfkTLAyZMi/adifRCfB
         0N65R1/9VAv4RQVgxtL3wUnzKAL5iQnv7J6gtSaaxMHb5Z6MzRl1tcm0FAF5sAi8i5nO
         rbBw==
X-Gm-Message-State: AAQBX9eZ3chr3taNmaBe7wLbfC054CGUmokqPjMGxTgiLWmh8CoTOR4W
        K0P3wAGjMX4uLPDIR73mJxk7XA==
X-Google-Smtp-Source: AKy350YNl/iuOqIgTG81r5IinDQI119x9whoEo8B7Q9rKrYwrsU0pdg6QtRBbkoNkwajLs//ofkgGA==
X-Received: by 2002:a5d:6a4a:0:b0:2d7:998c:5ad9 with SMTP id t10-20020a5d6a4a000000b002d7998c5ad9mr2332358wrw.8.1681411363908;
        Thu, 13 Apr 2023 11:42:43 -0700 (PDT)
Received: from nuc.fritz.box (p200300f6af154800ce0bb7f104d5fcf7.dip0.t-ipconnect.de. [2003:f6:af15:4800:ce0b:b7f1:4d5:fcf7])
        by smtp.gmail.com with ESMTPSA id x15-20020a5d6b4f000000b002c8476dde7asm1812652wrw.114.2023.04.13.11.42.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Apr 2023 11:42:43 -0700 (PDT)
From:   Mathias Krause <minipli@grsecurity.net>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org
Cc:     Mathias Krause <minipli@grsecurity.net>
Subject: [kvm-unit-tests PATCH v2 10/16] x86/fault_test: Preserve exception handler
Date:   Thu, 13 Apr 2023 20:42:13 +0200
Message-Id: <20230413184219.36404-11-minipli@grsecurity.net>
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

fault_test() replaces the exception handler for in-kernel tests with a
longjmp() based exception handling. However, it leaves the exception
handler in place which may confuse later test code triggering the same
exception without installing a handler first.

Fix this be restoring the previous exception handler, as running the
longjmp() handler out of context will lead to no good.

Signed-off-by: Mathias Krause <minipli@grsecurity.net>
---
 lib/x86/fault_test.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/lib/x86/fault_test.c b/lib/x86/fault_test.c
index e15a21864562..614bdcb42535 100644
--- a/lib/x86/fault_test.c
+++ b/lib/x86/fault_test.c
@@ -19,18 +19,20 @@ static bool fault_test(struct fault_test_arg *arg)
 	test_fault_func func = (test_fault_func) arg->func;
 	/* Init as success in case there isn't callback */
 	bool callback_success = true;
+	handler old;
 
 	if (arg->usermode) {
 		val = run_in_user((usermode_func) func, arg->fault_vector,
 				arg->arg[0], arg->arg[1], arg->arg[2],
 				arg->arg[3], &raised_vector);
 	} else {
-		handle_exception(arg->fault_vector, fault_test_fault);
+		old = handle_exception(arg->fault_vector, fault_test_fault);
 		if (setjmp(jmpbuf) == 0)
 			val = func(arg->arg[0], arg->arg[1], arg->arg[2],
 					arg->arg[3]);
 		else
 			raised_vector = true;
+		handle_exception(arg->fault_vector, old);
 	}
 
 	if (!raised_vector) {
-- 
2.39.2

