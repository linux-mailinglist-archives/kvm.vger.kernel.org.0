Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B062C6E146D
	for <lists+kvm@lfdr.de>; Thu, 13 Apr 2023 20:43:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230200AbjDMSnc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Apr 2023 14:43:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230122AbjDMSnK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Apr 2023 14:43:10 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A57A6599
        for <kvm@vger.kernel.org>; Thu, 13 Apr 2023 11:42:48 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id s2so11890370wra.7
        for <kvm@vger.kernel.org>; Thu, 13 Apr 2023 11:42:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1681411367; x=1684003367;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8q4B7NHV5vUbSHi1BOdJtLcPDnE9hcKZRDS4ZiVIfns=;
        b=SyCk5+Wsdsot2eGeT4bto9YyaUneNTOHgIBhVphr/M2SCZpZUY0i3P5g23XLHATCjX
         yQCwuxCjwpexBDy5kOPui2aK1aXk6+SlyMxco5vGiTpglgEhocp3rrlhEtoHOPGbES1N
         yTm9Ia3z0YpEmyQxg0dLtI7RQMxEnCqaorY6zxx7j6Kf4lMJkQYSCoo2GEHADBuXAhnH
         eYgl0W7nHZwsKbsHM+Cd27oSwmJZMr7vBq//kes9INsks8RmfG7/6fuG14xKraAd9jM1
         ZWHSvRTGnEZ8vhz53Lhjgo++4rKDAltzhI8y58GQrnVEEO6Kobe29cc8IdYV7jkXS7/U
         z9Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681411367; x=1684003367;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8q4B7NHV5vUbSHi1BOdJtLcPDnE9hcKZRDS4ZiVIfns=;
        b=PVm+p4/YnlgptiiupCi/hbnf4hV6V/xf2198yzhA/td8LPGEFAdHBGQwnVkqRLLaa8
         Rm8wmdlWG+DNsF/8QU/zvvujzhHVkIcEajKRGm+ZTdoETLGDEHT9cfxcrlUKK5Z89eXO
         eN96Pi3kyT9WPaY97mYOCpxIujzIUQryMzSTVyWJ1KfaCvbSYS3xNDEf6u4xcgfAndxc
         U88rdgtmBfvb2WJinHPdBfcpjc7bo7XaS9EVaEjFtp0b5CXyXQsLvpLUtd1OWSKOh+6K
         e63GswV9yJ5JPz/6K9gQzKQAZk2UiB0w+Rw9OVLzUpuBk4diftRBVYIUozMLJHdKiZDz
         yCoQ==
X-Gm-Message-State: AAQBX9d1RYBCHyfIGMT1vE7S6/o1UIZXblOIXJ89QJKAL4CGSvyvSZ0l
        kjoCk4bOI3jg+eNh7j7goYQwcw==
X-Google-Smtp-Source: AKy350YEsATKQdlYb17FtW+4wsyCMUW4im6xGKm/z4+cXeZG7uhtSv/rLiaXdTHb/j+kyuwOBeUhfA==
X-Received: by 2002:a5d:44c7:0:b0:2f5:fb37:c54b with SMTP id z7-20020a5d44c7000000b002f5fb37c54bmr2278843wrr.60.1681411367490;
        Thu, 13 Apr 2023 11:42:47 -0700 (PDT)
Received: from nuc.fritz.box (p200300f6af154800ce0bb7f104d5fcf7.dip0.t-ipconnect.de. [2003:f6:af15:4800:ce0b:b7f1:4d5:fcf7])
        by smtp.gmail.com with ESMTPSA id x15-20020a5d6b4f000000b002c8476dde7asm1812652wrw.114.2023.04.13.11.42.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Apr 2023 11:42:47 -0700 (PDT)
From:   Mathias Krause <minipli@grsecurity.net>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org
Cc:     Mathias Krause <minipli@grsecurity.net>
Subject: [kvm-unit-tests PATCH v2 15/16] x86/emulator64: Switch test_mmx_movq_mf() to ASM_TRY()
Date:   Thu, 13 Apr 2023 20:42:18 +0200
Message-Id: <20230413184219.36404-16-minipli@grsecurity.net>
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

Drop the last user of the one-off exception handler by making use of
ASM_TRY() for the #MF test.

Also streamline the multiple scattered asm() statements into a single
one making use of a real output value instead of hard-coding rax and
relying on the instruction to generate an exception (instead of
clobbering rax and not making gcc aware of it).

As this removes the last user of advance_rip_and_note_exception() we can
remove it for good!

Signed-off-by: Mathias Krause <minipli@grsecurity.net>
---
 x86/emulator64.c | 39 ++++++++++++++++-----------------------
 1 file changed, 16 insertions(+), 23 deletions(-)

diff --git a/x86/emulator64.c b/x86/emulator64.c
index 50a02bca6ac8..f8ff99fc39cc 100644
--- a/x86/emulator64.c
+++ b/x86/emulator64.c
@@ -1,14 +1,6 @@
 #define MAGIC_NUM 0xdeadbeefdeadbeefUL
 #define GS_BASE 0x400000
 
-static unsigned long rip_advance;
-
-static void advance_rip_and_note_exception(struct ex_regs *regs)
-{
-	++exceptions;
-	regs->rip += rip_advance;
-}
-
 static void test_cr8(void)
 {
 	unsigned long src, dst;
@@ -313,23 +305,24 @@ static void test_cmov(u32 *mem)
 
 static void test_mmx_movq_mf(uint64_t *mem)
 {
-	/* movq %mm0, (%rax) */
-	extern char movq_start, movq_end;
-	handler old;
-
 	uint16_t fcw = 0;  /* all exceptions unmasked */
-	write_cr0(read_cr0() & ~6);  /* TS, EM */
-	exceptions = 0;
-	old = handle_exception(MF_VECTOR, advance_rip_and_note_exception);
-	asm volatile("fninit; fldcw %0" : : "m"(fcw));
-	asm volatile("fldz; fldz; fdivp"); /* generate exception */
+	uint64_t val;
 
-	rip_advance = &movq_end - &movq_start;
-	asm(KVM_FEP "movq_start: movq %mm0, (%rax); movq_end:");
-	/* exit MMX mode */
-	asm volatile("fnclex; emms");
-	report(exceptions == 1, "movq mmx generates #MF");
-	handle_exception(MF_VECTOR, old);
+	write_cr0(read_cr0() & ~(X86_CR0_TS | X86_CR0_EM));
+	asm volatile("fninit\n\t"
+		     "fldcw %[fcw]\n\t"
+		     "fldz\n\t"
+		     "fldz\n\t"
+		     /* generate exception (0.0 / 0.0) */
+		     "fdivp\n\t"
+		     /* trigger #MF */
+		     ASM_TRY_FEP("1f") "movq %%mm0, %[val]\n\t"
+		     /* exit MMX mode */
+		     "1: fnclex\n\t"
+		     "emms\n\t"
+		     : [val]"=m"(val)
+		     : [fcw]"m"(fcw));
+	report(exception_vector() == MF_VECTOR, "movq mmx generates #MF");
 }
 
 static void test_jmp_noncanonical(uint64_t *mem)
-- 
2.39.2

