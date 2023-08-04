Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8B8976F7A8
	for <lists+kvm@lfdr.de>; Fri,  4 Aug 2023 04:13:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232749AbjHDCNK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 22:13:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233660AbjHDCMO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 22:12:14 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1C6E4682
        for <kvm@vger.kernel.org>; Thu,  3 Aug 2023 19:11:33 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id d2e1a72fcca58-686c06b806cso1153616b3a.2
        for <kvm@vger.kernel.org>; Thu, 03 Aug 2023 19:11:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20221208.gappssmtp.com; s=20221208; t=1691115069; x=1691719869;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/9x+TFVnCGe2WU5RlGvKxqVtj4tmROvC82ze+5KJL3U=;
        b=IkJmUMf16prXQkjP4lj5rTDJLv7FD4/XceOUaKRy9nwYg1AbjR/4hACj7L4bdWnNht
         i/68KOTrShtWhocen7puRJ0ZaDPHRmsWFaBrqaPGdFnd0H1vvz0dIffzYNiC4Sgx5nZl
         sOvmRmlJ+e0a66iwtno4OqFeMbZ6mHXcj5Xi/jbqbEpgrG75Gt1Mz8kXrKk4nIcFtlVh
         bLy9PqCz8rm0g2iU/gPweYHr5CSnbe/J5MA5IoTzLIHYkq3S4sx80FZgJyF51i4nK1wG
         JSKBN38+oh9vdwZG72hCVhOSiz6e7xSAoKkN3cE2pEDlaVUDrUaQBnQXT2hZ1YjnL+3c
         44Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691115069; x=1691719869;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/9x+TFVnCGe2WU5RlGvKxqVtj4tmROvC82ze+5KJL3U=;
        b=QgGEnhxey6P6NEqzoxU1XfbnI3kCjMJPoYs/Q6gwJzAAndn6eu4McrOlrC/P5r/lyJ
         SCHw2s9dYENskD10GipZv8Bn/vml5mOFLCPnq34tJtMzbaAaL8a58VAg0g1ckvHhFMap
         D2HXoKWQtJhJsy3M5ZGHoRMUkVyxiRoAjoFEednKll2Yhhg2tHYVGCkrFc/sBx+asaxW
         EiJUY6mijifQgrtZQJ/xLyv0DdbcnRBkxKaQTDoRffRtQzt8ztmA6CjgmfmyDQ/E/wr7
         1j74aYM5q8gb5hK1uKRQbYHxPfPeu/AB+BV5T99l+8S1O47Qt8bIZyNh+MkJ8FQBYZVv
         K28w==
X-Gm-Message-State: AOJu0YwLrcjurrxQ2fUUWlhQmsDxN5CFKHjDhA/wGM5iv4Njn2Ob2why
        GyUbitXCqNiWFBkxgHAb+XxV7g==
X-Google-Smtp-Source: AGHT+IFkJti/J73gi8xVh6nlOFT/LodI5/N609ojJyoF75AUYfW9T3mL2OZpJIfMNG8tpG29DJWNVA==
X-Received: by 2002:a05:6a00:228f:b0:666:ecf4:ed6d with SMTP id f15-20020a056a00228f00b00666ecf4ed6dmr469564pfe.18.1691115069170;
        Thu, 03 Aug 2023 19:11:09 -0700 (PDT)
Received: from charlie.ba.rivosinc.com ([66.220.2.162])
        by smtp.gmail.com with ESMTPSA id g6-20020a655806000000b0055c558ac4edsm369499pgr.46.2023.08.03.19.11.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Aug 2023 19:11:08 -0700 (PDT)
From:   Charlie Jenkins <charlie@rivosinc.com>
Date:   Thu, 03 Aug 2023 19:10:34 -0700
Subject: [PATCH 09/10] RISC-V: bpf: Refactor instructions
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230803-master-refactor-instructions-v4-v1-9-2128e61fa4ff@rivosinc.com>
References: <20230803-master-refactor-instructions-v4-v1-0-2128e61fa4ff@rivosinc.com>
In-Reply-To: <20230803-master-refactor-instructions-v4-v1-0-2128e61fa4ff@rivosinc.com>
To:     linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
        bpf@vger.kernel.org
Cc:     Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Jason Baron <jbaron@akamai.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        =?utf-8?q?Bj=C3=B6rn_T=C3=B6pel?= <bjorn@kernel.org>,
        Luke Nelson <luke.r.nels@gmail.com>,
        Xi Wang <xi.wang@gmail.com>, Nam Cao <namcaov@gmail.com>,
        Charlie Jenkins <charlie@rivosinc.com>
X-Mailer: b4 0.12.3
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use shared instruction definitions in insn.h instead of manually
constructing them.

Signed-off-by: Charlie Jenkins <charlie@rivosinc.com>
---
 arch/riscv/net/bpf_jit.h | 707 +----------------------------------------------
 1 file changed, 2 insertions(+), 705 deletions(-)

diff --git a/arch/riscv/net/bpf_jit.h b/arch/riscv/net/bpf_jit.h
index 2717f5490428..3f79c938166d 100644
--- a/arch/riscv/net/bpf_jit.h
+++ b/arch/riscv/net/bpf_jit.h
@@ -12,58 +12,8 @@
 #include <linux/bpf.h>
 #include <linux/filter.h>
 #include <asm/cacheflush.h>
-
-static inline bool rvc_enabled(void)
-{
-	return IS_ENABLED(CONFIG_RISCV_ISA_C);
-}
-
-enum {
-	RV_REG_ZERO =	0,	/* The constant value 0 */
-	RV_REG_RA =	1,	/* Return address */
-	RV_REG_SP =	2,	/* Stack pointer */
-	RV_REG_GP =	3,	/* Global pointer */
-	RV_REG_TP =	4,	/* Thread pointer */
-	RV_REG_T0 =	5,	/* Temporaries */
-	RV_REG_T1 =	6,
-	RV_REG_T2 =	7,
-	RV_REG_FP =	8,	/* Saved register/frame pointer */
-	RV_REG_S1 =	9,	/* Saved register */
-	RV_REG_A0 =	10,	/* Function argument/return values */
-	RV_REG_A1 =	11,	/* Function arguments */
-	RV_REG_A2 =	12,
-	RV_REG_A3 =	13,
-	RV_REG_A4 =	14,
-	RV_REG_A5 =	15,
-	RV_REG_A6 =	16,
-	RV_REG_A7 =	17,
-	RV_REG_S2 =	18,	/* Saved registers */
-	RV_REG_S3 =	19,
-	RV_REG_S4 =	20,
-	RV_REG_S5 =	21,
-	RV_REG_S6 =	22,
-	RV_REG_S7 =	23,
-	RV_REG_S8 =	24,
-	RV_REG_S9 =	25,
-	RV_REG_S10 =	26,
-	RV_REG_S11 =	27,
-	RV_REG_T3 =	28,	/* Temporaries */
-	RV_REG_T4 =	29,
-	RV_REG_T5 =	30,
-	RV_REG_T6 =	31,
-};
-
-static inline bool is_creg(u8 reg)
-{
-	return (1 << reg) & (BIT(RV_REG_FP) |
-			     BIT(RV_REG_S1) |
-			     BIT(RV_REG_A0) |
-			     BIT(RV_REG_A1) |
-			     BIT(RV_REG_A2) |
-			     BIT(RV_REG_A3) |
-			     BIT(RV_REG_A4) |
-			     BIT(RV_REG_A5));
-}
+#include <asm/reg.h>
+#include <asm/insn.h>
 
 struct rv_jit_context {
 	struct bpf_prog *prog;
@@ -221,659 +171,6 @@ static inline int rv_offset(int insn, int off, struct rv_jit_context *ctx)
 	return ninsns_rvoff(to - from);
 }
 
-/* Instruction formats. */
-
-static inline u32 rv_r_insn(u8 funct7, u8 rs2, u8 rs1, u8 funct3, u8 rd,
-			    u8 opcode)
-{
-	return (funct7 << 25) | (rs2 << 20) | (rs1 << 15) | (funct3 << 12) |
-		(rd << 7) | opcode;
-}
-
-static inline u32 rv_i_insn(u16 imm11_0, u8 rs1, u8 funct3, u8 rd, u8 opcode)
-{
-	return (imm11_0 << 20) | (rs1 << 15) | (funct3 << 12) | (rd << 7) |
-		opcode;
-}
-
-static inline u32 rv_s_insn(u16 imm11_0, u8 rs2, u8 rs1, u8 funct3, u8 opcode)
-{
-	u8 imm11_5 = imm11_0 >> 5, imm4_0 = imm11_0 & 0x1f;
-
-	return (imm11_5 << 25) | (rs2 << 20) | (rs1 << 15) | (funct3 << 12) |
-		(imm4_0 << 7) | opcode;
-}
-
-static inline u32 rv_b_insn(u16 imm12_1, u8 rs2, u8 rs1, u8 funct3, u8 opcode)
-{
-	u8 imm12 = ((imm12_1 & 0x800) >> 5) | ((imm12_1 & 0x3f0) >> 4);
-	u8 imm4_1 = ((imm12_1 & 0xf) << 1) | ((imm12_1 & 0x400) >> 10);
-
-	return (imm12 << 25) | (rs2 << 20) | (rs1 << 15) | (funct3 << 12) |
-		(imm4_1 << 7) | opcode;
-}
-
-static inline u32 rv_u_insn(u32 imm31_12, u8 rd, u8 opcode)
-{
-	return (imm31_12 << 12) | (rd << 7) | opcode;
-}
-
-static inline u32 rv_j_insn(u32 imm20_1, u8 rd, u8 opcode)
-{
-	u32 imm;
-
-	imm = (imm20_1 & 0x80000) | ((imm20_1 & 0x3ff) << 9) |
-		((imm20_1 & 0x400) >> 2) | ((imm20_1 & 0x7f800) >> 11);
-
-	return (imm << 12) | (rd << 7) | opcode;
-}
-
-static inline u32 rv_amo_insn(u8 funct5, u8 aq, u8 rl, u8 rs2, u8 rs1,
-			      u8 funct3, u8 rd, u8 opcode)
-{
-	u8 funct7 = (funct5 << 2) | (aq << 1) | rl;
-
-	return rv_r_insn(funct7, rs2, rs1, funct3, rd, opcode);
-}
-
-/* RISC-V compressed instruction formats. */
-
-static inline u16 rv_cr_insn(u8 funct4, u8 rd, u8 rs2, u8 op)
-{
-	return (funct4 << 12) | (rd << 7) | (rs2 << 2) | op;
-}
-
-static inline u16 rv_ci_insn(u8 funct3, u32 imm6, u8 rd, u8 op)
-{
-	u32 imm;
-
-	imm = ((imm6 & 0x20) << 7) | ((imm6 & 0x1f) << 2);
-	return (funct3 << 13) | (rd << 7) | op | imm;
-}
-
-static inline u16 rv_css_insn(u8 funct3, u32 uimm, u8 rs2, u8 op)
-{
-	return (funct3 << 13) | (uimm << 7) | (rs2 << 2) | op;
-}
-
-static inline u16 rv_ciw_insn(u8 funct3, u32 uimm, u8 rd, u8 op)
-{
-	return (funct3 << 13) | (uimm << 5) | ((rd & 0x7) << 2) | op;
-}
-
-static inline u16 rv_cl_insn(u8 funct3, u32 imm_hi, u8 rs1, u32 imm_lo, u8 rd,
-			     u8 op)
-{
-	return (funct3 << 13) | (imm_hi << 10) | ((rs1 & 0x7) << 7) |
-		(imm_lo << 5) | ((rd & 0x7) << 2) | op;
-}
-
-static inline u16 rv_cs_insn(u8 funct3, u32 imm_hi, u8 rs1, u32 imm_lo, u8 rs2,
-			     u8 op)
-{
-	return (funct3 << 13) | (imm_hi << 10) | ((rs1 & 0x7) << 7) |
-		(imm_lo << 5) | ((rs2 & 0x7) << 2) | op;
-}
-
-static inline u16 rv_ca_insn(u8 funct6, u8 rd, u8 funct2, u8 rs2, u8 op)
-{
-	return (funct6 << 10) | ((rd & 0x7) << 7) | (funct2 << 5) |
-		((rs2 & 0x7) << 2) | op;
-}
-
-static inline u16 rv_cb_insn(u8 funct3, u32 imm6, u8 funct2, u8 rd, u8 op)
-{
-	u32 imm;
-
-	imm = ((imm6 & 0x20) << 7) | ((imm6 & 0x1f) << 2);
-	return (funct3 << 13) | (funct2 << 10) | ((rd & 0x7) << 7) | op | imm;
-}
-
-/* Instructions shared by both RV32 and RV64. */
-
-static inline u32 rv_addi(u8 rd, u8 rs1, u16 imm11_0)
-{
-	return rv_i_insn(imm11_0, rs1, 0, rd, 0x13);
-}
-
-static inline u32 rv_andi(u8 rd, u8 rs1, u16 imm11_0)
-{
-	return rv_i_insn(imm11_0, rs1, 7, rd, 0x13);
-}
-
-static inline u32 rv_ori(u8 rd, u8 rs1, u16 imm11_0)
-{
-	return rv_i_insn(imm11_0, rs1, 6, rd, 0x13);
-}
-
-static inline u32 rv_xori(u8 rd, u8 rs1, u16 imm11_0)
-{
-	return rv_i_insn(imm11_0, rs1, 4, rd, 0x13);
-}
-
-static inline u32 rv_slli(u8 rd, u8 rs1, u16 imm11_0)
-{
-	return rv_i_insn(imm11_0, rs1, 1, rd, 0x13);
-}
-
-static inline u32 rv_srli(u8 rd, u8 rs1, u16 imm11_0)
-{
-	return rv_i_insn(imm11_0, rs1, 5, rd, 0x13);
-}
-
-static inline u32 rv_srai(u8 rd, u8 rs1, u16 imm11_0)
-{
-	return rv_i_insn(0x400 | imm11_0, rs1, 5, rd, 0x13);
-}
-
-static inline u32 rv_lui(u8 rd, u32 imm31_12)
-{
-	return rv_u_insn(imm31_12, rd, 0x37);
-}
-
-static inline u32 rv_auipc(u8 rd, u32 imm31_12)
-{
-	return rv_u_insn(imm31_12, rd, 0x17);
-}
-
-static inline u32 rv_add(u8 rd, u8 rs1, u8 rs2)
-{
-	return rv_r_insn(0, rs2, rs1, 0, rd, 0x33);
-}
-
-static inline u32 rv_sub(u8 rd, u8 rs1, u8 rs2)
-{
-	return rv_r_insn(0x20, rs2, rs1, 0, rd, 0x33);
-}
-
-static inline u32 rv_sltu(u8 rd, u8 rs1, u8 rs2)
-{
-	return rv_r_insn(0, rs2, rs1, 3, rd, 0x33);
-}
-
-static inline u32 rv_and(u8 rd, u8 rs1, u8 rs2)
-{
-	return rv_r_insn(0, rs2, rs1, 7, rd, 0x33);
-}
-
-static inline u32 rv_or(u8 rd, u8 rs1, u8 rs2)
-{
-	return rv_r_insn(0, rs2, rs1, 6, rd, 0x33);
-}
-
-static inline u32 rv_xor(u8 rd, u8 rs1, u8 rs2)
-{
-	return rv_r_insn(0, rs2, rs1, 4, rd, 0x33);
-}
-
-static inline u32 rv_sll(u8 rd, u8 rs1, u8 rs2)
-{
-	return rv_r_insn(0, rs2, rs1, 1, rd, 0x33);
-}
-
-static inline u32 rv_srl(u8 rd, u8 rs1, u8 rs2)
-{
-	return rv_r_insn(0, rs2, rs1, 5, rd, 0x33);
-}
-
-static inline u32 rv_sra(u8 rd, u8 rs1, u8 rs2)
-{
-	return rv_r_insn(0x20, rs2, rs1, 5, rd, 0x33);
-}
-
-static inline u32 rv_mul(u8 rd, u8 rs1, u8 rs2)
-{
-	return rv_r_insn(1, rs2, rs1, 0, rd, 0x33);
-}
-
-static inline u32 rv_mulhu(u8 rd, u8 rs1, u8 rs2)
-{
-	return rv_r_insn(1, rs2, rs1, 3, rd, 0x33);
-}
-
-static inline u32 rv_divu(u8 rd, u8 rs1, u8 rs2)
-{
-	return rv_r_insn(1, rs2, rs1, 5, rd, 0x33);
-}
-
-static inline u32 rv_remu(u8 rd, u8 rs1, u8 rs2)
-{
-	return rv_r_insn(1, rs2, rs1, 7, rd, 0x33);
-}
-
-static inline u32 rv_jal(u8 rd, u32 imm20_1)
-{
-	return rv_j_insn(imm20_1, rd, 0x6f);
-}
-
-static inline u32 rv_jalr(u8 rd, u8 rs1, u16 imm11_0)
-{
-	return rv_i_insn(imm11_0, rs1, 0, rd, 0x67);
-}
-
-static inline u32 rv_beq(u8 rs1, u8 rs2, u16 imm12_1)
-{
-	return rv_b_insn(imm12_1, rs2, rs1, 0, 0x63);
-}
-
-static inline u32 rv_bne(u8 rs1, u8 rs2, u16 imm12_1)
-{
-	return rv_b_insn(imm12_1, rs2, rs1, 1, 0x63);
-}
-
-static inline u32 rv_bltu(u8 rs1, u8 rs2, u16 imm12_1)
-{
-	return rv_b_insn(imm12_1, rs2, rs1, 6, 0x63);
-}
-
-static inline u32 rv_bgtu(u8 rs1, u8 rs2, u16 imm12_1)
-{
-	return rv_bltu(rs2, rs1, imm12_1);
-}
-
-static inline u32 rv_bgeu(u8 rs1, u8 rs2, u16 imm12_1)
-{
-	return rv_b_insn(imm12_1, rs2, rs1, 7, 0x63);
-}
-
-static inline u32 rv_bleu(u8 rs1, u8 rs2, u16 imm12_1)
-{
-	return rv_bgeu(rs2, rs1, imm12_1);
-}
-
-static inline u32 rv_blt(u8 rs1, u8 rs2, u16 imm12_1)
-{
-	return rv_b_insn(imm12_1, rs2, rs1, 4, 0x63);
-}
-
-static inline u32 rv_bgt(u8 rs1, u8 rs2, u16 imm12_1)
-{
-	return rv_blt(rs2, rs1, imm12_1);
-}
-
-static inline u32 rv_bge(u8 rs1, u8 rs2, u16 imm12_1)
-{
-	return rv_b_insn(imm12_1, rs2, rs1, 5, 0x63);
-}
-
-static inline u32 rv_ble(u8 rs1, u8 rs2, u16 imm12_1)
-{
-	return rv_bge(rs2, rs1, imm12_1);
-}
-
-static inline u32 rv_lw(u8 rd, u16 imm11_0, u8 rs1)
-{
-	return rv_i_insn(imm11_0, rs1, 2, rd, 0x03);
-}
-
-static inline u32 rv_lbu(u8 rd, u16 imm11_0, u8 rs1)
-{
-	return rv_i_insn(imm11_0, rs1, 4, rd, 0x03);
-}
-
-static inline u32 rv_lhu(u8 rd, u16 imm11_0, u8 rs1)
-{
-	return rv_i_insn(imm11_0, rs1, 5, rd, 0x03);
-}
-
-static inline u32 rv_sb(u8 rs1, u16 imm11_0, u8 rs2)
-{
-	return rv_s_insn(imm11_0, rs2, rs1, 0, 0x23);
-}
-
-static inline u32 rv_sh(u8 rs1, u16 imm11_0, u8 rs2)
-{
-	return rv_s_insn(imm11_0, rs2, rs1, 1, 0x23);
-}
-
-static inline u32 rv_sw(u8 rs1, u16 imm11_0, u8 rs2)
-{
-	return rv_s_insn(imm11_0, rs2, rs1, 2, 0x23);
-}
-
-static inline u32 rv_amoadd_w(u8 rd, u8 rs2, u8 rs1, u8 aq, u8 rl)
-{
-	return rv_amo_insn(0, aq, rl, rs2, rs1, 2, rd, 0x2f);
-}
-
-static inline u32 rv_amoand_w(u8 rd, u8 rs2, u8 rs1, u8 aq, u8 rl)
-{
-	return rv_amo_insn(0xc, aq, rl, rs2, rs1, 2, rd, 0x2f);
-}
-
-static inline u32 rv_amoor_w(u8 rd, u8 rs2, u8 rs1, u8 aq, u8 rl)
-{
-	return rv_amo_insn(0x8, aq, rl, rs2, rs1, 2, rd, 0x2f);
-}
-
-static inline u32 rv_amoxor_w(u8 rd, u8 rs2, u8 rs1, u8 aq, u8 rl)
-{
-	return rv_amo_insn(0x4, aq, rl, rs2, rs1, 2, rd, 0x2f);
-}
-
-static inline u32 rv_amoswap_w(u8 rd, u8 rs2, u8 rs1, u8 aq, u8 rl)
-{
-	return rv_amo_insn(0x1, aq, rl, rs2, rs1, 2, rd, 0x2f);
-}
-
-static inline u32 rv_lr_w(u8 rd, u8 rs2, u8 rs1, u8 aq, u8 rl)
-{
-	return rv_amo_insn(0x2, aq, rl, rs2, rs1, 2, rd, 0x2f);
-}
-
-static inline u32 rv_sc_w(u8 rd, u8 rs2, u8 rs1, u8 aq, u8 rl)
-{
-	return rv_amo_insn(0x3, aq, rl, rs2, rs1, 2, rd, 0x2f);
-}
-
-static inline u32 rv_fence(u8 pred, u8 succ)
-{
-	u16 imm11_0 = pred << 4 | succ;
-
-	return rv_i_insn(imm11_0, 0, 0, 0, 0xf);
-}
-
-static inline u32 rv_nop(void)
-{
-	return rv_i_insn(0, 0, 0, 0, 0x13);
-}
-
-/* RVC instrutions. */
-
-static inline u16 rvc_addi4spn(u8 rd, u32 imm10)
-{
-	u32 imm;
-
-	imm = ((imm10 & 0x30) << 2) | ((imm10 & 0x3c0) >> 4) |
-		((imm10 & 0x4) >> 1) | ((imm10 & 0x8) >> 3);
-	return rv_ciw_insn(0x0, imm, rd, 0x0);
-}
-
-static inline u16 rvc_lw(u8 rd, u32 imm7, u8 rs1)
-{
-	u32 imm_hi, imm_lo;
-
-	imm_hi = (imm7 & 0x38) >> 3;
-	imm_lo = ((imm7 & 0x4) >> 1) | ((imm7 & 0x40) >> 6);
-	return rv_cl_insn(0x2, imm_hi, rs1, imm_lo, rd, 0x0);
-}
-
-static inline u16 rvc_sw(u8 rs1, u32 imm7, u8 rs2)
-{
-	u32 imm_hi, imm_lo;
-
-	imm_hi = (imm7 & 0x38) >> 3;
-	imm_lo = ((imm7 & 0x4) >> 1) | ((imm7 & 0x40) >> 6);
-	return rv_cs_insn(0x6, imm_hi, rs1, imm_lo, rs2, 0x0);
-}
-
-static inline u16 rvc_addi(u8 rd, u32 imm6)
-{
-	return rv_ci_insn(0, imm6, rd, 0x1);
-}
-
-static inline u16 rvc_li(u8 rd, u32 imm6)
-{
-	return rv_ci_insn(0x2, imm6, rd, 0x1);
-}
-
-static inline u16 rvc_addi16sp(u32 imm10)
-{
-	u32 imm;
-
-	imm = ((imm10 & 0x200) >> 4) | (imm10 & 0x10) | ((imm10 & 0x40) >> 3) |
-		((imm10 & 0x180) >> 6) | ((imm10 & 0x20) >> 5);
-	return rv_ci_insn(0x3, imm, RV_REG_SP, 0x1);
-}
-
-static inline u16 rvc_lui(u8 rd, u32 imm6)
-{
-	return rv_ci_insn(0x3, imm6, rd, 0x1);
-}
-
-static inline u16 rvc_srli(u8 rd, u32 imm6)
-{
-	return rv_cb_insn(0x4, imm6, 0, rd, 0x1);
-}
-
-static inline u16 rvc_srai(u8 rd, u32 imm6)
-{
-	return rv_cb_insn(0x4, imm6, 0x1, rd, 0x1);
-}
-
-static inline u16 rvc_andi(u8 rd, u32 imm6)
-{
-	return rv_cb_insn(0x4, imm6, 0x2, rd, 0x1);
-}
-
-static inline u16 rvc_sub(u8 rd, u8 rs)
-{
-	return rv_ca_insn(0x23, rd, 0, rs, 0x1);
-}
-
-static inline u16 rvc_xor(u8 rd, u8 rs)
-{
-	return rv_ca_insn(0x23, rd, 0x1, rs, 0x1);
-}
-
-static inline u16 rvc_or(u8 rd, u8 rs)
-{
-	return rv_ca_insn(0x23, rd, 0x2, rs, 0x1);
-}
-
-static inline u16 rvc_and(u8 rd, u8 rs)
-{
-	return rv_ca_insn(0x23, rd, 0x3, rs, 0x1);
-}
-
-static inline u16 rvc_slli(u8 rd, u32 imm6)
-{
-	return rv_ci_insn(0, imm6, rd, 0x2);
-}
-
-static inline u16 rvc_lwsp(u8 rd, u32 imm8)
-{
-	u32 imm;
-
-	imm = ((imm8 & 0xc0) >> 6) | (imm8 & 0x3c);
-	return rv_ci_insn(0x2, imm, rd, 0x2);
-}
-
-static inline u16 rvc_jr(u8 rs1)
-{
-	return rv_cr_insn(0x8, rs1, RV_REG_ZERO, 0x2);
-}
-
-static inline u16 rvc_mv(u8 rd, u8 rs)
-{
-	return rv_cr_insn(0x8, rd, rs, 0x2);
-}
-
-static inline u16 rvc_jalr(u8 rs1)
-{
-	return rv_cr_insn(0x9, rs1, RV_REG_ZERO, 0x2);
-}
-
-static inline u16 rvc_add(u8 rd, u8 rs)
-{
-	return rv_cr_insn(0x9, rd, rs, 0x2);
-}
-
-static inline u16 rvc_swsp(u32 imm8, u8 rs2)
-{
-	u32 imm;
-
-	imm = (imm8 & 0x3c) | ((imm8 & 0xc0) >> 6);
-	return rv_css_insn(0x6, imm, rs2, 0x2);
-}
-
-/*
- * RV64-only instructions.
- *
- * These instructions are not available on RV32.  Wrap them below a #if to
- * ensure that the RV32 JIT doesn't emit any of these instructions.
- */
-
-#if __riscv_xlen == 64
-
-static inline u32 rv_addiw(u8 rd, u8 rs1, u16 imm11_0)
-{
-	return rv_i_insn(imm11_0, rs1, 0, rd, 0x1b);
-}
-
-static inline u32 rv_slliw(u8 rd, u8 rs1, u16 imm11_0)
-{
-	return rv_i_insn(imm11_0, rs1, 1, rd, 0x1b);
-}
-
-static inline u32 rv_srliw(u8 rd, u8 rs1, u16 imm11_0)
-{
-	return rv_i_insn(imm11_0, rs1, 5, rd, 0x1b);
-}
-
-static inline u32 rv_sraiw(u8 rd, u8 rs1, u16 imm11_0)
-{
-	return rv_i_insn(0x400 | imm11_0, rs1, 5, rd, 0x1b);
-}
-
-static inline u32 rv_addw(u8 rd, u8 rs1, u8 rs2)
-{
-	return rv_r_insn(0, rs2, rs1, 0, rd, 0x3b);
-}
-
-static inline u32 rv_subw(u8 rd, u8 rs1, u8 rs2)
-{
-	return rv_r_insn(0x20, rs2, rs1, 0, rd, 0x3b);
-}
-
-static inline u32 rv_sllw(u8 rd, u8 rs1, u8 rs2)
-{
-	return rv_r_insn(0, rs2, rs1, 1, rd, 0x3b);
-}
-
-static inline u32 rv_srlw(u8 rd, u8 rs1, u8 rs2)
-{
-	return rv_r_insn(0, rs2, rs1, 5, rd, 0x3b);
-}
-
-static inline u32 rv_sraw(u8 rd, u8 rs1, u8 rs2)
-{
-	return rv_r_insn(0x20, rs2, rs1, 5, rd, 0x3b);
-}
-
-static inline u32 rv_mulw(u8 rd, u8 rs1, u8 rs2)
-{
-	return rv_r_insn(1, rs2, rs1, 0, rd, 0x3b);
-}
-
-static inline u32 rv_divuw(u8 rd, u8 rs1, u8 rs2)
-{
-	return rv_r_insn(1, rs2, rs1, 5, rd, 0x3b);
-}
-
-static inline u32 rv_remuw(u8 rd, u8 rs1, u8 rs2)
-{
-	return rv_r_insn(1, rs2, rs1, 7, rd, 0x3b);
-}
-
-static inline u32 rv_ld(u8 rd, u16 imm11_0, u8 rs1)
-{
-	return rv_i_insn(imm11_0, rs1, 3, rd, 0x03);
-}
-
-static inline u32 rv_lwu(u8 rd, u16 imm11_0, u8 rs1)
-{
-	return rv_i_insn(imm11_0, rs1, 6, rd, 0x03);
-}
-
-static inline u32 rv_sd(u8 rs1, u16 imm11_0, u8 rs2)
-{
-	return rv_s_insn(imm11_0, rs2, rs1, 3, 0x23);
-}
-
-static inline u32 rv_amoadd_d(u8 rd, u8 rs2, u8 rs1, u8 aq, u8 rl)
-{
-	return rv_amo_insn(0, aq, rl, rs2, rs1, 3, rd, 0x2f);
-}
-
-static inline u32 rv_amoand_d(u8 rd, u8 rs2, u8 rs1, u8 aq, u8 rl)
-{
-	return rv_amo_insn(0xc, aq, rl, rs2, rs1, 3, rd, 0x2f);
-}
-
-static inline u32 rv_amoor_d(u8 rd, u8 rs2, u8 rs1, u8 aq, u8 rl)
-{
-	return rv_amo_insn(0x8, aq, rl, rs2, rs1, 3, rd, 0x2f);
-}
-
-static inline u32 rv_amoxor_d(u8 rd, u8 rs2, u8 rs1, u8 aq, u8 rl)
-{
-	return rv_amo_insn(0x4, aq, rl, rs2, rs1, 3, rd, 0x2f);
-}
-
-static inline u32 rv_amoswap_d(u8 rd, u8 rs2, u8 rs1, u8 aq, u8 rl)
-{
-	return rv_amo_insn(0x1, aq, rl, rs2, rs1, 3, rd, 0x2f);
-}
-
-static inline u32 rv_lr_d(u8 rd, u8 rs2, u8 rs1, u8 aq, u8 rl)
-{
-	return rv_amo_insn(0x2, aq, rl, rs2, rs1, 3, rd, 0x2f);
-}
-
-static inline u32 rv_sc_d(u8 rd, u8 rs2, u8 rs1, u8 aq, u8 rl)
-{
-	return rv_amo_insn(0x3, aq, rl, rs2, rs1, 3, rd, 0x2f);
-}
-
-/* RV64-only RVC instructions. */
-
-static inline u16 rvc_ld(u8 rd, u32 imm8, u8 rs1)
-{
-	u32 imm_hi, imm_lo;
-
-	imm_hi = (imm8 & 0x38) >> 3;
-	imm_lo = (imm8 & 0xc0) >> 6;
-	return rv_cl_insn(0x3, imm_hi, rs1, imm_lo, rd, 0x0);
-}
-
-static inline u16 rvc_sd(u8 rs1, u32 imm8, u8 rs2)
-{
-	u32 imm_hi, imm_lo;
-
-	imm_hi = (imm8 & 0x38) >> 3;
-	imm_lo = (imm8 & 0xc0) >> 6;
-	return rv_cs_insn(0x7, imm_hi, rs1, imm_lo, rs2, 0x0);
-}
-
-static inline u16 rvc_subw(u8 rd, u8 rs)
-{
-	return rv_ca_insn(0x27, rd, 0, rs, 0x1);
-}
-
-static inline u16 rvc_addiw(u8 rd, u32 imm6)
-{
-	return rv_ci_insn(0x1, imm6, rd, 0x1);
-}
-
-static inline u16 rvc_ldsp(u8 rd, u32 imm9)
-{
-	u32 imm;
-
-	imm = ((imm9 & 0x1c0) >> 6) | (imm9 & 0x38);
-	return rv_ci_insn(0x3, imm, rd, 0x2);
-}
-
-static inline u16 rvc_sdsp(u32 imm9, u8 rs2)
-{
-	u32 imm;
-
-	imm = (imm9 & 0x38) | ((imm9 & 0x1c0) >> 6);
-	return rv_css_insn(0x7, imm, rs2, 0x2);
-}
-
-#endif /* __riscv_xlen == 64 */
-
 /* Helper functions that emit RVC instructions when possible. */
 
 static inline void emit_jalr(u8 rd, u8 rs, s32 imm, struct rv_jit_context *ctx)

-- 
2.34.1

