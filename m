Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0E2A6E1460
	for <lists+kvm@lfdr.de>; Thu, 13 Apr 2023 20:43:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230085AbjDMSnO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Apr 2023 14:43:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230011AbjDMSnF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Apr 2023 14:43:05 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07FDC8A42
        for <kvm@vger.kernel.org>; Thu, 13 Apr 2023 11:42:41 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id j15so1423521wrb.11
        for <kvm@vger.kernel.org>; Thu, 13 Apr 2023 11:42:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1681411360; x=1684003360;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J3elqJXS+bFQRPcED8Mmzb52OGHkprqFCPRDONeOQX8=;
        b=iFWy001yG7k9NEXUCsSndo8Nhwvgc0bmmCTHHxkF22Kg2s51TGmPLA9kQH1AAHfalI
         l1UIiv9FMYGKYyDcL45ofyLTMuO2ICrk23p5HbsEaKSDfHNhFSFJ793fsO3cuvVzOmG/
         Fs6MpUklJZLgJvuilvjnLXVd/7JuTpTd0I0Jt9REFp2dvk0SqUv1Lk6MJ7O2mU1D1JRZ
         qZ9WYi8AqrGXd+dnM3iW7wKiCWe74h4l1STaoW0hHkCfQ92XecZY7PF879dJBXtv9mDP
         GenYZjQfnPs2h7cnObjoMov9bNt/BnpV3WBDGejhtXfIdhivi5DirtSLJIiQoQPMgbXd
         /dPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681411360; x=1684003360;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=J3elqJXS+bFQRPcED8Mmzb52OGHkprqFCPRDONeOQX8=;
        b=FDzTPnzxOUouUHzoFjTG881tCWmENdYku36e+AsiRhtIHfqAg5IDhaw5sLmEKBRULb
         AaCPea0KhV6qKrZx2xCsN7Wz8U23tQdTmw/e56wygzgIyWzaPqP8rTuhmRU1dDaNyq1Y
         tXGdvmrStm72DPX7GYIwjbId/Ga+iJBw2cmGvIcHYsUZL2NOyj4kixyrwqGcF7/ye5+C
         CaXsY9ozsAKETdSyQVf6RDvn7Iy10AtYsuRVyhniQkHGfrsY7i+gjvqTT5fYh4uwOcmp
         Z50IcgOKZOWTz7mGrtf137CsHOQxsu0FAaAyDppEvnop8Sp8sCGxwKLnYrJsXAHzWEsz
         m2Iw==
X-Gm-Message-State: AAQBX9e8KKS/Wswa1Yoe33G/4d7T4Lf+AsvX7hX6HlCt8/l2s8Lh3gOW
        YTHZk2Fo3holL9j2Ipbj0sGMkdVzfxPOdhL7C3k=
X-Google-Smtp-Source: AKy350a6ISM9678Na2Gp3sMzcSy58f8GR2ePSp9gLnvjqU2GpoaNp77Br209RB/wJnRDUuTz3fRQiQ==
X-Received: by 2002:a5d:5943:0:b0:2ef:b525:bdf9 with SMTP id e3-20020a5d5943000000b002efb525bdf9mr2306149wri.48.1681411360585;
        Thu, 13 Apr 2023 11:42:40 -0700 (PDT)
Received: from nuc.fritz.box (p200300f6af154800ce0bb7f104d5fcf7.dip0.t-ipconnect.de. [2003:f6:af15:4800:ce0b:b7f1:4d5:fcf7])
        by smtp.gmail.com with ESMTPSA id x15-20020a5d6b4f000000b002c8476dde7asm1812652wrw.114.2023.04.13.11.42.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Apr 2023 11:42:40 -0700 (PDT)
From:   Mathias Krause <minipli@grsecurity.net>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org
Cc:     Mathias Krause <minipli@grsecurity.net>
Subject: [kvm-unit-tests PATCH v2 06/16] x86/run_in_user: Change type of code label
Date:   Thu, 13 Apr 2023 20:42:09 +0200
Message-Id: <20230413184219.36404-7-minipli@grsecurity.net>
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

Use an array type to refer to the code label 'ret_to_kernel'.

No functional change.

Signed-off-by: Mathias Krause <minipli@grsecurity.net>
---
 lib/x86/usermode.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/x86/usermode.c b/lib/x86/usermode.c
index e22fb8f0132b..b976123ca753 100644
--- a/lib/x86/usermode.c
+++ b/lib/x86/usermode.c
@@ -35,12 +35,12 @@ uint64_t run_in_user(usermode_func func, unsigned int fault_vector,
 		uint64_t arg1, uint64_t arg2, uint64_t arg3,
 		uint64_t arg4, bool *raised_vector)
 {
-	extern char ret_to_kernel;
+	extern char ret_to_kernel[];
 	uint64_t rax = 0;
 	static unsigned char user_stack[USERMODE_STACK_SIZE];
 
 	*raised_vector = 0;
-	set_idt_entry(RET_TO_KERNEL_IRQ, &ret_to_kernel, 3);
+	set_idt_entry(RET_TO_KERNEL_IRQ, ret_to_kernel, 3);
 	handle_exception(fault_vector,
 			restore_exec_to_jmpbuf_exception_handler);
 
-- 
2.39.2

