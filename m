Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E97BE714EFD
	for <lists+kvm@lfdr.de>; Mon, 29 May 2023 19:42:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbjE2RmD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 May 2023 13:42:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjE2RmB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 May 2023 13:42:01 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B990AB
        for <kvm@vger.kernel.org>; Mon, 29 May 2023 10:41:59 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id 5b1f17b1804b1-3f6dfc4dffaso23691845e9.0
        for <kvm@vger.kernel.org>; Mon, 29 May 2023 10:41:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685382117; x=1687974117;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iZQlGiVGWJns6xIKo5kUFuRC4G2tOGEFDHeEM7zw45Y=;
        b=ESrCFXKXZDEfqNTj434g1TITpIPYQKRzyijIvjTchBz9geXqKdiAJQ5eY9HC17Zef2
         3t/yYsITnTVZAdyYG2M9Z4b55WOMw8JRPw40oL7sfgDmHHeU6H9j9a0xsxdNIKagWYD6
         6zVY7hJOXinS9VKqEQpfGFgx6woZBZBlDE9+q4cZhBm8XmgVJqvpgfR4XWAOkRWrKdut
         uf84aEL1m19uhO3wFOQf+WvaUQj+KsJSYMpXOo1zXO1EnTcEPuZTr2vLp9OSjc0II9H+
         1KWTPYN6lShCjza28mZapgTSzsQtyq1sHsx8kiVbiEYCqU5KK8a9Raf38mSSa2un3l9b
         rGPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685382117; x=1687974117;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iZQlGiVGWJns6xIKo5kUFuRC4G2tOGEFDHeEM7zw45Y=;
        b=jFgVx5p0DDAg962qpMNzsJagfwargel7tkB3GMys70ze+ddfVdEqbUZifvwjhyI2MU
         dUJ44M1WkP9X4qtQTiStcFp/t4uSmgHWne2Xtn7a5IxtJhhKfemy91yMSDyYhPK1LOEM
         xR//xK67V5uqYIIm4nvU20KoiTyoshyeVE1OP6pBvGxQmZue4dY4+BDsxcyuxrsYAISm
         CGc70hlnZ0otN365X1gGl6LanIGuHa4UEydrGv1KBAJNdZdViFxX9lTpxGJHtJPHYpck
         HhQIlpgv2hjjOqLklHxJMptccEJR5PzOhZevTpzMxkheZIGHotTzKXTjsDv5mEj4cxwk
         Sj3w==
X-Gm-Message-State: AC+VfDxvVLcfx8QuKkXCzyi54cOMenhp+JTbIdp+k4NIBSZbjzHoZFlW
        g5E8BX6Ag8C1ktWIIEXnhs8vywrTCg==
X-Google-Smtp-Source: ACHHUZ7aBSDD3bl5M4lAZv3O7V6JWIAI7qPmG461p2qQ+3fO9E2F1McpYuTBLLqmRKaOTXNezXuoWw==
X-Received: by 2002:a1c:6a03:0:b0:3f4:2cb2:a6cf with SMTP id f3-20020a1c6a03000000b003f42cb2a6cfmr9864194wmc.10.1685382117276;
        Mon, 29 May 2023 10:41:57 -0700 (PDT)
Received: from p183 ([46.53.248.48])
        by smtp.gmail.com with ESMTPSA id q13-20020a7bce8d000000b003f43f82001asm18538763wmj.31.2023.05.29.10.41.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 May 2023 10:41:56 -0700 (PDT)
Date:   Mon, 29 May 2023 20:41:54 +0300
From:   Alexey Dobriyan <adobriyan@gmail.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org
Subject: [PATCH] kvm: fix multiple SIMD prefixes decoding
Message-ID: <4d583cfe-eb6a-4433-8ab1-367f1e25263b@p183>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

x86_decode_insn() can decode SSE instructions with multiple mandatory
prefixes incorrectly. Apparently, f2/f3 overturns 66 regardless of
relative position. Current code does the opposite: 66 wins and refuses
to emulate instruction with both 66 and f2/f3 for no reason.

This is easy to see switching between movdqa/movdqu with unaligned loads.

.intel_syntax noprefix
.global f
f:
	push	rbp
	mov	rbp, rsp
	and	rsp, ~15
	add	rsp, 1

	#.byte 0x66, 0x0f, 0x6f, 0x04, 0x24		# SIGSEGV movdqa xmm0, [rsp]
	.byte 0xf3, 0x0f, 0x6f, 0x04, 0x24		# OK movdqu xmm0, [rsp]

	#.byte 0x66, 0x66, 0x0f, 0x6f, 0x04, 0x24	# SIGSEGV movdqa xmm0, [rsp]
	.byte 0x66, 0xf3, 0x0f, 0x6f, 0x04, 0x24	# OK movdqu xmm0, [rsp]
	.byte 0xf3, 0x66, 0x0f, 0x6f, 0x04, 0x24	# OK movdqu xmm0, [rsp]
	.byte 0xf3, 0xf3, 0x0f, 0x6f, 0x04, 0x24	# OK movdqu xmm0, [rsp]

	#.byte 0x66, 0x66, 0x66, 0x0f, 0x6f, 0x04, 0x24	# SIGSEGV movdqa xmm0, [rsp]
	.byte 0x66, 0x66, 0xf3, 0x0f, 0x6f, 0x04, 0x24	# OK movdqu xmm0, [rsp]
	.byte 0x66, 0xf3, 0x66, 0x0f, 0x6f, 0x04, 0x24	# OK movdqu xmm0, [rsp]
	.byte 0x66, 0xf3, 0xf3, 0x0f, 0x6f, 0x04, 0x24	# OK movdqu xmm0, [rsp]
	.byte 0xf3, 0x66, 0x66, 0x0f, 0x6f, 0x04, 0x24	# OK movdqu xmm0, [rsp]
	.byte 0xf3, 0x66, 0xf3, 0x0f, 0x6f, 0x04, 0x24	# OK movdqu xmm0, [rsp]
	.byte 0xf3, 0xf3, 0x66, 0x0f, 0x6f, 0x04, 0x24	# OK movdqu xmm0, [rsp]
	.byte 0xf3, 0xf3, 0xf3, 0x0f, 0x6f, 0x04, 0x24	# OK movdqu xmm0, [rsp]

	mov	rsp, rbp
	pop	rbp
	ret

Tentative patch below (how do you even test it?).

References:

objdump: opcodes/i386-dis.c get_valid_dis386()
bochs: bochs/cpu/decoder/fetchdecode64.cc fetchDecode64()

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

	Do we even care given that compiler won't emit such instruction?

 arch/x86/kvm/emulate.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -4763,8 +4763,8 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len, int
 {
 	int rc = X86EMUL_CONTINUE;
 	int mode = ctxt->mode;
-	int def_op_bytes, def_ad_bytes, goffset, simd_prefix;
-	bool op_prefix = false;
+	int def_op_bytes, def_ad_bytes, goffset;
+	u8 simd_prefix = 0;
 	bool has_seg_override = false;
 	struct opcode opcode;
 	u16 dummy;
@@ -4816,7 +4816,13 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len, int
 	for (;;) {
 		switch (ctxt->b = insn_fetch(u8, ctxt)) {
 		case 0x66:	/* operand-size override */
-			op_prefix = true;
+			/*
+			 * Believe it or not, f2/f3 are more equal than 66.
+			 * Homework:
+			 * 1. [M21] Write a program to show this effect.
+			 * 2. [M49] Find corresponding clause in SDM.
+			 */
+			simd_prefix = simd_prefix ?: 0x66;
 			/* switch between 2/4 bytes */
 			ctxt->op_bytes = def_op_bytes ^ 6;
 			break;
@@ -4862,7 +4868,7 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len, int
 			break;
 		case 0xf2:	/* REPNE/REPNZ */
 		case 0xf3:	/* REP/REPE/REPZ */
-			ctxt->rep_prefix = ctxt->b;
+			ctxt->rep_prefix = simd_prefix = ctxt->b;
 			break;
 		default:
 			goto done_prefixes;
@@ -4923,9 +4929,6 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len, int
 			opcode = opcode.u.group[goffset];
 			break;
 		case Prefix:
-			if (ctxt->rep_prefix && op_prefix)
-				return EMULATION_FAILED;
-			simd_prefix = op_prefix ? 0x66 : ctxt->rep_prefix;
 			switch (simd_prefix) {
 			case 0x00: opcode = opcode.u.gprefix->pfx_no; break;
 			case 0x66: opcode = opcode.u.gprefix->pfx_66; break;
