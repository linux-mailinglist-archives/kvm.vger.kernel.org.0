Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 769662D1F18
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 01:38:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728760AbgLHAie (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 19:38:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728671AbgLHAie (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Dec 2020 19:38:34 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34885C06179C
        for <kvm@vger.kernel.org>; Mon,  7 Dec 2020 16:37:48 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id m19so22126102ejj.11
        for <kvm@vger.kernel.org>; Mon, 07 Dec 2020 16:37:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Qd6K0Wd+z678hfI8BXLvKrmGtYY8ZhUxppJGd/aqyEo=;
        b=EziROr0WsPcECccUciQUEj3/sGGfm+OD5Gnhq9S6EYdrKfF12dFNq54OMDETSanf9C
         QxL4xA3hHT7KNsAp9BzSNv61IRfc0HtldtvwpmPTPY1Yl5BxbvPSb3MAo8kwusG4XdeP
         jmmA2Q6fS5UDuoyZkPwj0psPD06hcTf5DKJnOHnq1init8WKkWyNOA7PVp4dtiHBNmrq
         /ueODkMruZMt7JNF/anbZvBsfk/PCNUw2aGK5sKTSIl2cQu2hytMGxJMK8EQwy15y9GV
         YZ4vACJYLdnQ9Ev8gI7YsT12V0T6v9eN9Aq1Ap1SvEQZqt44vx2+c/m2YfYZW2f+FthQ
         VgiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=Qd6K0Wd+z678hfI8BXLvKrmGtYY8ZhUxppJGd/aqyEo=;
        b=kFWyhdjiTkMHCO31KBTP2hjic62wLN9Sl5XRexowIvwBrksGEmCUTa0DcAY1qDnD8/
         p70ehvGSDi496FPbTY9Xq6rfRtp9RoMEAjVw1b/TWeri03LLgVBMNtU1PvbN5kLhsSlk
         sPaRU4+qBto80vTFG9FOXp51SQb57vFQ5Cu+1nY/wpymniDP48lxgQAVDJEocUvgLQI5
         wMQBjcAxrnKYB4LuZ1xQEwNJIANCMPiw9sRrxlU4gBuGKv9ANhjLCmfpNkH1j0tGXRD1
         mFSRYrrE9ijJ/ZAZH3zb9Pf50SK3Du9y2XgWHLXRcvTElgEiicW5lScQQi2Tql+GNxTp
         0X+Q==
X-Gm-Message-State: AOAM532Oo2KE9+Eytj4iXU34dMlNqCXjAwkUEnLGjqKmf4AK1rOAmUip
        KQidZpX9yXeMBFCSg1fk+TY=
X-Google-Smtp-Source: ABdhPJzKqTZOshd61xQ5Ok/G0rnv4/qMJ+lnXdinCo/Oh8sJDBQNkp7xV28DXIBG+Y3weAzJvgvcdg==
X-Received: by 2002:a17:906:4994:: with SMTP id p20mr21073788eju.391.1607387866919;
        Mon, 07 Dec 2020 16:37:46 -0800 (PST)
Received: from x1w.redhat.com (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id a13sm15142917edb.76.2020.12.07.16.37.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 16:37:46 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
To:     qemu-devel@nongnu.org
Cc:     Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        kvm@vger.kernel.org,
        Richard Henderson <richard.henderson@linaro.org>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Huacai Chen <chenhuacai@kernel.org>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>
Subject: [PATCH 08/17] target/mips: Remove CPUMIPSState* argument from gen_msa*() methods
Date:   Tue,  8 Dec 2020 01:36:53 +0100
Message-Id: <20201208003702.4088927-9-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201208003702.4088927-1-f4bug@amsat.org>
References: <20201208003702.4088927-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The gen_msa*() methods don't use the "CPUMIPSState *env"
argument. Remove it to simplify.

Reviewed-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
---
 target/mips/translate.c | 57 ++++++++++++++++++++---------------------
 1 file changed, 28 insertions(+), 29 deletions(-)

diff --git a/target/mips/translate.c b/target/mips/translate.c
index bbe06240510..5ed7072f275 100644
--- a/target/mips/translate.c
+++ b/target/mips/translate.c
@@ -28623,7 +28623,7 @@ static void gen_check_zero_element(TCGv tresult, uint8_t df, uint8_t wt)
     tcg_temp_free_i64(t1);
 }
 
-static void gen_msa_branch(CPUMIPSState *env, DisasContext *ctx, uint32_t op1)
+static void gen_msa_branch(DisasContext *ctx, uint32_t op1)
 {
     uint8_t df = (ctx->opcode >> 21) & 0x3;
     uint8_t wt = (ctx->opcode >> 16) & 0x1f;
@@ -28668,7 +28668,7 @@ static void gen_msa_branch(CPUMIPSState *env, DisasContext *ctx, uint32_t op1)
     ctx->hflags |= MIPS_HFLAG_BDS32;
 }
 
-static void gen_msa_i8(CPUMIPSState *env, DisasContext *ctx)
+static void gen_msa_i8(DisasContext *ctx)
 {
 #define MASK_MSA_I8(op)    (MASK_MSA_MINOR(op) | (op & (0x03 << 24)))
     uint8_t i8 = (ctx->opcode >> 16) & 0xff;
@@ -28726,7 +28726,7 @@ static void gen_msa_i8(CPUMIPSState *env, DisasContext *ctx)
     tcg_temp_free_i32(ti8);
 }
 
-static void gen_msa_i5(CPUMIPSState *env, DisasContext *ctx)
+static void gen_msa_i5(DisasContext *ctx)
 {
 #define MASK_MSA_I5(op)    (MASK_MSA_MINOR(op) | (op & (0x7 << 23)))
     uint8_t df = (ctx->opcode >> 21) & 0x3;
@@ -28799,7 +28799,7 @@ static void gen_msa_i5(CPUMIPSState *env, DisasContext *ctx)
     tcg_temp_free_i32(timm);
 }
 
-static void gen_msa_bit(CPUMIPSState *env, DisasContext *ctx)
+static void gen_msa_bit(DisasContext *ctx)
 {
 #define MASK_MSA_BIT(op)    (MASK_MSA_MINOR(op) | (op & (0x7 << 23)))
     uint8_t dfm = (ctx->opcode >> 16) & 0x7f;
@@ -28883,7 +28883,7 @@ static void gen_msa_bit(CPUMIPSState *env, DisasContext *ctx)
     tcg_temp_free_i32(tws);
 }
 
-static void gen_msa_3r(CPUMIPSState *env, DisasContext *ctx)
+static void gen_msa_3r(DisasContext *ctx)
 {
 #define MASK_MSA_3R(op)    (MASK_MSA_MINOR(op) | (op & (0x7 << 23)))
     uint8_t df = (ctx->opcode >> 21) & 0x3;
@@ -29865,7 +29865,7 @@ static void gen_msa_3r(CPUMIPSState *env, DisasContext *ctx)
     tcg_temp_free_i32(tdf);
 }
 
-static void gen_msa_elm_3e(CPUMIPSState *env, DisasContext *ctx)
+static void gen_msa_elm_3e(DisasContext *ctx)
 {
 #define MASK_MSA_ELM_DF3E(op)   (MASK_MSA_MINOR(op) | (op & (0x3FF << 16)))
     uint8_t source = (ctx->opcode >> 11) & 0x1f;
@@ -29897,8 +29897,7 @@ static void gen_msa_elm_3e(CPUMIPSState *env, DisasContext *ctx)
     tcg_temp_free_i32(tsr);
 }
 
-static void gen_msa_elm_df(CPUMIPSState *env, DisasContext *ctx, uint32_t df,
-        uint32_t n)
+static void gen_msa_elm_df(DisasContext *ctx, uint32_t df, uint32_t n)
 {
 #define MASK_MSA_ELM(op)    (MASK_MSA_MINOR(op) | (op & (0xf << 22)))
     uint8_t ws = (ctx->opcode >> 11) & 0x1f;
@@ -30008,7 +30007,7 @@ static void gen_msa_elm_df(CPUMIPSState *env, DisasContext *ctx, uint32_t df,
     tcg_temp_free_i32(tdf);
 }
 
-static void gen_msa_elm(CPUMIPSState *env, DisasContext *ctx)
+static void gen_msa_elm(DisasContext *ctx)
 {
     uint8_t dfn = (ctx->opcode >> 16) & 0x3f;
     uint32_t df = 0, n = 0;
@@ -30027,17 +30026,17 @@ static void gen_msa_elm(CPUMIPSState *env, DisasContext *ctx)
         df = DF_DOUBLE;
     } else if (dfn == 0x3E) {
         /* CTCMSA, CFCMSA, MOVE.V */
-        gen_msa_elm_3e(env, ctx);
+        gen_msa_elm_3e(ctx);
         return;
     } else {
         generate_exception_end(ctx, EXCP_RI);
         return;
     }
 
-    gen_msa_elm_df(env, ctx, df, n);
+    gen_msa_elm_df(ctx, df, n);
 }
 
-static void gen_msa_3rf(CPUMIPSState *env, DisasContext *ctx)
+static void gen_msa_3rf(DisasContext *ctx)
 {
 #define MASK_MSA_3RF(op)    (MASK_MSA_MINOR(op) | (op & (0xf << 22)))
     uint8_t df = (ctx->opcode >> 21) & 0x1;
@@ -30195,7 +30194,7 @@ static void gen_msa_3rf(CPUMIPSState *env, DisasContext *ctx)
     tcg_temp_free_i32(tdf);
 }
 
-static void gen_msa_2r(CPUMIPSState *env, DisasContext *ctx)
+static void gen_msa_2r(DisasContext *ctx)
 {
 #define MASK_MSA_2R(op)     (MASK_MSA_MINOR(op) | (op & (0x1f << 21)) | \
                             (op & (0x7 << 18)))
@@ -30279,7 +30278,7 @@ static void gen_msa_2r(CPUMIPSState *env, DisasContext *ctx)
     tcg_temp_free_i32(tdf);
 }
 
-static void gen_msa_2rf(CPUMIPSState *env, DisasContext *ctx)
+static void gen_msa_2rf(DisasContext *ctx)
 {
 #define MASK_MSA_2RF(op)    (MASK_MSA_MINOR(op) | (op & (0x1f << 21)) | \
                             (op & (0xf << 17)))
@@ -30350,7 +30349,7 @@ static void gen_msa_2rf(CPUMIPSState *env, DisasContext *ctx)
     tcg_temp_free_i32(tdf);
 }
 
-static void gen_msa_vec_v(CPUMIPSState *env, DisasContext *ctx)
+static void gen_msa_vec_v(DisasContext *ctx)
 {
 #define MASK_MSA_VEC(op)    (MASK_MSA_MINOR(op) | (op & (0x1f << 21)))
     uint8_t wt = (ctx->opcode >> 16) & 0x1f;
@@ -30393,7 +30392,7 @@ static void gen_msa_vec_v(CPUMIPSState *env, DisasContext *ctx)
     tcg_temp_free_i32(twt);
 }
 
-static void gen_msa_vec(CPUMIPSState *env, DisasContext *ctx)
+static void gen_msa_vec(DisasContext *ctx)
 {
     switch (MASK_MSA_VEC(ctx->opcode)) {
     case OPC_AND_V:
@@ -30403,13 +30402,13 @@ static void gen_msa_vec(CPUMIPSState *env, DisasContext *ctx)
     case OPC_BMNZ_V:
     case OPC_BMZ_V:
     case OPC_BSEL_V:
-        gen_msa_vec_v(env, ctx);
+        gen_msa_vec_v(ctx);
         break;
     case OPC_MSA_2R:
-        gen_msa_2r(env, ctx);
+        gen_msa_2r(ctx);
         break;
     case OPC_MSA_2RF:
-        gen_msa_2rf(env, ctx);
+        gen_msa_2rf(ctx);
         break;
     default:
         MIPS_INVAL("MSA instruction");
@@ -30418,7 +30417,7 @@ static void gen_msa_vec(CPUMIPSState *env, DisasContext *ctx)
     }
 }
 
-static void gen_msa(CPUMIPSState *env, DisasContext *ctx)
+static void gen_msa(DisasContext *ctx)
 {
     uint32_t opcode = ctx->opcode;
 
@@ -30428,15 +30427,15 @@ static void gen_msa(CPUMIPSState *env, DisasContext *ctx)
     case OPC_MSA_I8_00:
     case OPC_MSA_I8_01:
     case OPC_MSA_I8_02:
-        gen_msa_i8(env, ctx);
+        gen_msa_i8(ctx);
         break;
     case OPC_MSA_I5_06:
     case OPC_MSA_I5_07:
-        gen_msa_i5(env, ctx);
+        gen_msa_i5(ctx);
         break;
     case OPC_MSA_BIT_09:
     case OPC_MSA_BIT_0A:
-        gen_msa_bit(env, ctx);
+        gen_msa_bit(ctx);
         break;
     case OPC_MSA_3R_0D:
     case OPC_MSA_3R_0E:
@@ -30447,18 +30446,18 @@ static void gen_msa(CPUMIPSState *env, DisasContext *ctx)
     case OPC_MSA_3R_13:
     case OPC_MSA_3R_14:
     case OPC_MSA_3R_15:
-        gen_msa_3r(env, ctx);
+        gen_msa_3r(ctx);
         break;
     case OPC_MSA_ELM:
-        gen_msa_elm(env, ctx);
+        gen_msa_elm(ctx);
         break;
     case OPC_MSA_3RF_1A:
     case OPC_MSA_3RF_1B:
     case OPC_MSA_3RF_1C:
-        gen_msa_3rf(env, ctx);
+        gen_msa_3rf(ctx);
         break;
     case OPC_MSA_VEC:
-        gen_msa_vec(env, ctx);
+        gen_msa_vec(ctx);
         break;
     case OPC_LD_B:
     case OPC_LD_H:
@@ -31069,7 +31068,7 @@ static void decode_opc(CPUMIPSState *env, DisasContext *ctx)
         case OPC_BNZ_W:
         case OPC_BNZ_D:
             if (ase_msa_available(env)) {
-                gen_msa_branch(env, ctx, op1);
+                gen_msa_branch(ctx, op1);
                 break;
             }
         default:
@@ -31261,7 +31260,7 @@ static void decode_opc(CPUMIPSState *env, DisasContext *ctx)
         } else {
             /* MDMX: Not implemented. */
             if (ase_msa_available(env)) {
-                gen_msa(env, ctx);
+                gen_msa(ctx);
             }
         }
         break;
-- 
2.26.2

