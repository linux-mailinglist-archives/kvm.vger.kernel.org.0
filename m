Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B42576F7A3
	for <lists+kvm@lfdr.de>; Fri,  4 Aug 2023 04:12:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233212AbjHDCMo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 22:12:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231797AbjHDCMJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 22:12:09 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 940E14C1F
        for <kvm@vger.kernel.org>; Thu,  3 Aug 2023 19:11:29 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id d2e1a72fcca58-686e0213c0bso1201557b3a.1
        for <kvm@vger.kernel.org>; Thu, 03 Aug 2023 19:11:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20221208.gappssmtp.com; s=20221208; t=1691115067; x=1691719867;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BPKfiGgHhMfFwAhfWVPwqE1z0LYuKsCQFhQ5Mh2pvvg=;
        b=ta12HpfnDKw4trrgJe1kDu+nj00f+KtjOCKksu/MbokQkDICvsHjetWJjnnUAQ9mKA
         WxcGuGzIACqWL4C7F0cNuUurtmsjAqQtku6EGVRRAIRX6czrur7a1fkoTwQb67I8psns
         qiw1jr3pgIU6q5lKcqF2K0YyV/Q9izdftRMTHTrdstDWvQdYLXBYAs9POUL60yw9Qx6o
         NxmgZnNssWnJqQ8eqgXh5ytWv/DME6JtSdllQIrmeVjOnn+1OhwqPUSJ71/U9z5WHACg
         tIgJe92B0DResa1Wi2A+yRPOYTSNhVYGYoNJY+JGdxcqvoQH4MrlPXgKUvzgvd61u6zx
         6NWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691115067; x=1691719867;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BPKfiGgHhMfFwAhfWVPwqE1z0LYuKsCQFhQ5Mh2pvvg=;
        b=jKv2qJzHQMx/6/N5SLDxb8bucrONCe3XcxRn5u6TZsVs5cgZ8Gu//le1K5q+xVqV8d
         GvIQevq61R2YnsXRhcjZp0uCZ4Zuw9nc5Xhw+Z6Dmdcxq47RzYfM5XweXMTe35lcOhAo
         GZwyhhgPHJ+PHdhQJfMHKgBq6tOfVcT9APa2l+e9u5fYIYRQNPqCcinkyWJXuffBImnP
         NsRtMk/KEvE6w3NNWjaIq8HqyeF47zzWrswdUjUiiVciwl+A0Cy5XPqxtZC8JbHrzyJ2
         mng9QZ2bBVKtAislF9XFEUaa3pGoayJw3JLxrym3Utmiuwqx8KzGdh1DCSZLyI0EdBXT
         fuOQ==
X-Gm-Message-State: AOJu0Yz4aN5HZLwYIb1ZBC1SAAuVjzzvWs8BninkBr5AstG7IUD8k0Qq
        mJwKYr4Ha/jxie1wsYGWu2SWHA==
X-Google-Smtp-Source: AGHT+IFN09ZI6JBftIb4c4o1ythrdzlTD6KiUWhToEJZR6WsVai+ZUmWDZsVnZ7Njw6c/iZ527XncQ==
X-Received: by 2002:a05:6a00:2301:b0:686:efda:76a2 with SMTP id h1-20020a056a00230100b00686efda76a2mr405546pfh.29.1691115067089;
        Thu, 03 Aug 2023 19:11:07 -0700 (PDT)
Received: from charlie.ba.rivosinc.com ([66.220.2.162])
        by smtp.gmail.com with ESMTPSA id g6-20020a655806000000b0055c558ac4edsm369499pgr.46.2023.08.03.19.11.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Aug 2023 19:11:06 -0700 (PDT)
From:   Charlie Jenkins <charlie@rivosinc.com>
Date:   Thu, 03 Aug 2023 19:10:33 -0700
Subject: [PATCH 08/10] RISC-V: kvm: Refactor instructions
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230803-master-refactor-instructions-v4-v1-8-2128e61fa4ff@rivosinc.com>
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
 arch/riscv/kvm/vcpu_insn.c | 281 ++++++++++++++-------------------------------
 1 file changed, 86 insertions(+), 195 deletions(-)

diff --git a/arch/riscv/kvm/vcpu_insn.c b/arch/riscv/kvm/vcpu_insn.c
index 7a6abed41bc1..73c7d21b496e 100644
--- a/arch/riscv/kvm/vcpu_insn.c
+++ b/arch/riscv/kvm/vcpu_insn.c
@@ -6,130 +6,7 @@
 
 #include <linux/bitops.h>
 #include <linux/kvm_host.h>
-
-#define INSN_OPCODE_MASK	0x007c
-#define INSN_OPCODE_SHIFT	2
-#define INSN_OPCODE_SYSTEM	28
-
-#define INSN_MASK_WFI		0xffffffff
-#define INSN_MATCH_WFI		0x10500073
-
-#define INSN_MATCH_CSRRW	0x1073
-#define INSN_MASK_CSRRW		0x707f
-#define INSN_MATCH_CSRRS	0x2073
-#define INSN_MASK_CSRRS		0x707f
-#define INSN_MATCH_CSRRC	0x3073
-#define INSN_MASK_CSRRC		0x707f
-#define INSN_MATCH_CSRRWI	0x5073
-#define INSN_MASK_CSRRWI	0x707f
-#define INSN_MATCH_CSRRSI	0x6073
-#define INSN_MASK_CSRRSI	0x707f
-#define INSN_MATCH_CSRRCI	0x7073
-#define INSN_MASK_CSRRCI	0x707f
-
-#define INSN_MATCH_LB		0x3
-#define INSN_MASK_LB		0x707f
-#define INSN_MATCH_LH		0x1003
-#define INSN_MASK_LH		0x707f
-#define INSN_MATCH_LW		0x2003
-#define INSN_MASK_LW		0x707f
-#define INSN_MATCH_LD		0x3003
-#define INSN_MASK_LD		0x707f
-#define INSN_MATCH_LBU		0x4003
-#define INSN_MASK_LBU		0x707f
-#define INSN_MATCH_LHU		0x5003
-#define INSN_MASK_LHU		0x707f
-#define INSN_MATCH_LWU		0x6003
-#define INSN_MASK_LWU		0x707f
-#define INSN_MATCH_SB		0x23
-#define INSN_MASK_SB		0x707f
-#define INSN_MATCH_SH		0x1023
-#define INSN_MASK_SH		0x707f
-#define INSN_MATCH_SW		0x2023
-#define INSN_MASK_SW		0x707f
-#define INSN_MATCH_SD		0x3023
-#define INSN_MASK_SD		0x707f
-
-#define INSN_MATCH_C_LD		0x6000
-#define INSN_MASK_C_LD		0xe003
-#define INSN_MATCH_C_SD		0xe000
-#define INSN_MASK_C_SD		0xe003
-#define INSN_MATCH_C_LW		0x4000
-#define INSN_MASK_C_LW		0xe003
-#define INSN_MATCH_C_SW		0xc000
-#define INSN_MASK_C_SW		0xe003
-#define INSN_MATCH_C_LDSP	0x6002
-#define INSN_MASK_C_LDSP	0xe003
-#define INSN_MATCH_C_SDSP	0xe002
-#define INSN_MASK_C_SDSP	0xe003
-#define INSN_MATCH_C_LWSP	0x4002
-#define INSN_MASK_C_LWSP	0xe003
-#define INSN_MATCH_C_SWSP	0xc002
-#define INSN_MASK_C_SWSP	0xe003
-
-#define INSN_16BIT_MASK		0x3
-
-#define INSN_IS_16BIT(insn)	(((insn) & INSN_16BIT_MASK) != INSN_16BIT_MASK)
-
-#define INSN_LEN(insn)		(INSN_IS_16BIT(insn) ? 2 : 4)
-
-#ifdef CONFIG_64BIT
-#define LOG_REGBYTES		3
-#else
-#define LOG_REGBYTES		2
-#endif
-#define REGBYTES		(1 << LOG_REGBYTES)
-
-#define SH_RD			7
-#define SH_RS1			15
-#define SH_RS2			20
-#define SH_RS2C			2
-#define MASK_RX			0x1f
-
-#define RV_X(x, s, n)		(((x) >> (s)) & ((1 << (n)) - 1))
-#define RVC_LW_IMM(x)		((RV_X(x, 6, 1) << 2) | \
-				 (RV_X(x, 10, 3) << 3) | \
-				 (RV_X(x, 5, 1) << 6))
-#define RVC_LD_IMM(x)		((RV_X(x, 10, 3) << 3) | \
-				 (RV_X(x, 5, 2) << 6))
-#define RVC_LWSP_IMM(x)		((RV_X(x, 4, 3) << 2) | \
-				 (RV_X(x, 12, 1) << 5) | \
-				 (RV_X(x, 2, 2) << 6))
-#define RVC_LDSP_IMM(x)		((RV_X(x, 5, 2) << 3) | \
-				 (RV_X(x, 12, 1) << 5) | \
-				 (RV_X(x, 2, 3) << 6))
-#define RVC_SWSP_IMM(x)		((RV_X(x, 9, 4) << 2) | \
-				 (RV_X(x, 7, 2) << 6))
-#define RVC_SDSP_IMM(x)		((RV_X(x, 10, 3) << 3) | \
-				 (RV_X(x, 7, 3) << 6))
-#define RVC_RS1S(insn)		(8 + RV_X(insn, SH_RD, 3))
-#define RVC_RS2S(insn)		(8 + RV_X(insn, SH_RS2C, 3))
-#define RVC_RS2(insn)		RV_X(insn, SH_RS2C, 5)
-
-#define SHIFT_RIGHT(x, y)		\
-	((y) < 0 ? ((x) << -(y)) : ((x) >> (y)))
-
-#define REG_MASK			\
-	((1 << (5 + LOG_REGBYTES)) - (1 << LOG_REGBYTES))
-
-#define REG_OFFSET(insn, pos)		\
-	(SHIFT_RIGHT((insn), (pos) - LOG_REGBYTES) & REG_MASK)
-
-#define REG_PTR(insn, pos, regs)	\
-	((ulong *)((ulong)(regs) + REG_OFFSET(insn, pos)))
-
-#define GET_FUNCT3(insn)	(((insn) >> 12) & 7)
-
-#define GET_RS1(insn, regs)	(*REG_PTR(insn, SH_RS1, regs))
-#define GET_RS2(insn, regs)	(*REG_PTR(insn, SH_RS2, regs))
-#define GET_RS1S(insn, regs)	(*REG_PTR(RVC_RS1S(insn), 0, regs))
-#define GET_RS2S(insn, regs)	(*REG_PTR(RVC_RS2S(insn), 0, regs))
-#define GET_RS2C(insn, regs)	(*REG_PTR(insn, SH_RS2C, regs))
-#define GET_SP(regs)		(*REG_PTR(2, 0, regs))
-#define SET_RD(insn, regs, val)	(*REG_PTR(insn, SH_RD, regs) = (val))
-#define IMM_I(insn)		((s32)(insn) >> 20)
-#define IMM_S(insn)		(((s32)(insn) >> 25 << 5) | \
-				 (s32)(((insn) >> 7) & 0x1f))
+#include <asm/insn.h>
 
 struct insn_func {
 	unsigned long mask;
@@ -230,6 +107,7 @@ static const struct csr_func csr_funcs[] = {
 int kvm_riscv_vcpu_csr_return(struct kvm_vcpu *vcpu, struct kvm_run *run)
 {
 	ulong insn;
+	u32 index;
 
 	if (vcpu->arch.csr_decode.return_handled)
 		return 0;
@@ -237,9 +115,10 @@ int kvm_riscv_vcpu_csr_return(struct kvm_vcpu *vcpu, struct kvm_run *run)
 
 	/* Update destination register for CSR reads */
 	insn = vcpu->arch.csr_decode.insn;
-	if ((insn >> SH_RD) & MASK_RX)
-		SET_RD(insn, &vcpu->arch.guest_context,
-		       run->riscv_csr.ret_value);
+	riscv_insn_extract_rd(insn);
+	if (index)
+		rv_insn_reg_set_val((unsigned long *)&vcpu->arch.guest_context,
+				    index, run->riscv_csr.ret_value);
 
 	/* Move to next instruction */
 	vcpu->arch.guest_context.sepc += INSN_LEN(insn);
@@ -249,36 +128,39 @@ int kvm_riscv_vcpu_csr_return(struct kvm_vcpu *vcpu, struct kvm_run *run)
 
 static int csr_insn(struct kvm_vcpu *vcpu, struct kvm_run *run, ulong insn)
 {
+	ulong rs1_val;
 	int i, rc = KVM_INSN_ILLEGAL_TRAP;
-	unsigned int csr_num = insn >> SH_RS2;
-	unsigned int rs1_num = (insn >> SH_RS1) & MASK_RX;
-	ulong rs1_val = GET_RS1(insn, &vcpu->arch.guest_context);
+	unsigned int csr_num = insn >> RV_I_IMM_11_0_OPOFF;
+	unsigned int rs1_num = riscv_insn_extract_rs1(insn);
 	const struct csr_func *tcfn, *cfn = NULL;
 	ulong val = 0, wr_mask = 0, new_val = 0;
 
+	rv_insn_reg_get_val((unsigned long *)&vcpu->arch.guest_context,
+			    riscv_insn_extract_rs1(insn), &rs1_val);
+
 	/* Decode the CSR instruction */
-	switch (GET_FUNCT3(insn)) {
-	case GET_FUNCT3(INSN_MATCH_CSRRW):
+	switch (riscv_insn_extract_funct3(insn)) {
+	case RVG_FUNCT3_CSRRW:
 		wr_mask = -1UL;
 		new_val = rs1_val;
 		break;
-	case GET_FUNCT3(INSN_MATCH_CSRRS):
+	case RVG_FUNCT3_CSRRS:
 		wr_mask = rs1_val;
 		new_val = -1UL;
 		break;
-	case GET_FUNCT3(INSN_MATCH_CSRRC):
+	case RVG_FUNCT3_CSRRC:
 		wr_mask = rs1_val;
 		new_val = 0;
 		break;
-	case GET_FUNCT3(INSN_MATCH_CSRRWI):
+	case RVG_FUNCT3_CSRRWI:
 		wr_mask = -1UL;
 		new_val = rs1_num;
 		break;
-	case GET_FUNCT3(INSN_MATCH_CSRRSI):
+	case RVG_FUNCT3_CSRRSI:
 		wr_mask = rs1_num;
 		new_val = -1UL;
 		break;
-	case GET_FUNCT3(INSN_MATCH_CSRRCI):
+	case RVG_FUNCT3_CSRRCI:
 		wr_mask = rs1_num;
 		new_val = 0;
 		break;
@@ -331,38 +213,38 @@ static int csr_insn(struct kvm_vcpu *vcpu, struct kvm_run *run, ulong insn)
 
 static const struct insn_func system_opcode_funcs[] = {
 	{
-		.mask  = INSN_MASK_CSRRW,
-		.match = INSN_MATCH_CSRRW,
+		.mask  = RVG_MASK_CSRRW,
+		.match = RVG_MATCH_CSRRW,
 		.func  = csr_insn,
 	},
 	{
-		.mask  = INSN_MASK_CSRRS,
-		.match = INSN_MATCH_CSRRS,
+		.mask  = RVG_MASK_CSRRS,
+		.match = RVG_MATCH_CSRRS,
 		.func  = csr_insn,
 	},
 	{
-		.mask  = INSN_MASK_CSRRC,
-		.match = INSN_MATCH_CSRRC,
+		.mask  = RVG_MASK_CSRRC,
+		.match = RVG_MATCH_CSRRC,
 		.func  = csr_insn,
 	},
 	{
-		.mask  = INSN_MASK_CSRRWI,
-		.match = INSN_MATCH_CSRRWI,
+		.mask  = RVG_MASK_CSRRWI,
+		.match = RVG_MATCH_CSRRWI,
 		.func  = csr_insn,
 	},
 	{
-		.mask  = INSN_MASK_CSRRSI,
-		.match = INSN_MATCH_CSRRSI,
+		.mask  = RVG_MASK_CSRRSI,
+		.match = RVG_MATCH_CSRRSI,
 		.func  = csr_insn,
 	},
 	{
-		.mask  = INSN_MASK_CSRRCI,
-		.match = INSN_MATCH_CSRRCI,
+		.mask  = RVG_MASK_CSRRCI,
+		.match = RVG_MATCH_CSRRCI,
 		.func  = csr_insn,
 	},
 	{
-		.mask  = INSN_MASK_WFI,
-		.match = INSN_MATCH_WFI,
+		.mask  = RV_MASK_WFI,
+		.match = RV_MATCH_WFI,
 		.func  = wfi_insn,
 	},
 };
@@ -414,7 +296,7 @@ int kvm_riscv_vcpu_virtual_insn(struct kvm_vcpu *vcpu, struct kvm_run *run,
 	struct kvm_cpu_trap utrap = { 0 };
 	struct kvm_cpu_context *ct;
 
-	if (unlikely(INSN_IS_16BIT(insn))) {
+	if (unlikely(INSN_IS_C(insn))) {
 		if (insn == 0) {
 			ct = &vcpu->arch.guest_context;
 			insn = kvm_riscv_vcpu_unpriv_read(vcpu, true,
@@ -426,12 +308,12 @@ int kvm_riscv_vcpu_virtual_insn(struct kvm_vcpu *vcpu, struct kvm_run *run,
 				return 1;
 			}
 		}
-		if (INSN_IS_16BIT(insn))
+		if (INSN_IS_C(insn))
 			return truly_illegal_insn(vcpu, run, insn);
 	}
 
-	switch ((insn & INSN_OPCODE_MASK) >> INSN_OPCODE_SHIFT) {
-	case INSN_OPCODE_SYSTEM:
+	switch (insn) {
+	case RVG_OPCODE_SYSTEM:
 		return system_opcode_insn(vcpu, run, insn);
 	default:
 		return truly_illegal_insn(vcpu, run, insn);
@@ -466,7 +348,7 @@ int kvm_riscv_vcpu_mmio_load(struct kvm_vcpu *vcpu, struct kvm_run *run,
 		 * Bit[0] == 1 implies trapped instruction value is
 		 * transformed instruction or custom instruction.
 		 */
-		insn = htinst | INSN_16BIT_MASK;
+		insn = htinst | INSN_C_MASK;
 		insn_len = (htinst & BIT(1)) ? INSN_LEN(insn) : 2;
 	} else {
 		/*
@@ -485,43 +367,43 @@ int kvm_riscv_vcpu_mmio_load(struct kvm_vcpu *vcpu, struct kvm_run *run,
 	}
 
 	/* Decode length of MMIO and shift */
-	if ((insn & INSN_MASK_LW) == INSN_MATCH_LW) {
+	if (riscv_insn_is_lw(insn)) {
 		len = 4;
 		shift = 8 * (sizeof(ulong) - len);
-	} else if ((insn & INSN_MASK_LB) == INSN_MATCH_LB) {
+	} else if (riscv_insn_is_lb(insn)) {
 		len = 1;
 		shift = 8 * (sizeof(ulong) - len);
-	} else if ((insn & INSN_MASK_LBU) == INSN_MATCH_LBU) {
+	} else if (riscv_insn_is_lbu(insn)) {
 		len = 1;
 		shift = 8 * (sizeof(ulong) - len);
 #ifdef CONFIG_64BIT
-	} else if ((insn & INSN_MASK_LD) == INSN_MATCH_LD) {
+	} else if (riscv_insn_is_ld(insn)) {
 		len = 8;
 		shift = 8 * (sizeof(ulong) - len);
-	} else if ((insn & INSN_MASK_LWU) == INSN_MATCH_LWU) {
+	} else if (riscv_insn_is_lwu(insn)) {
 		len = 4;
 #endif
-	} else if ((insn & INSN_MASK_LH) == INSN_MATCH_LH) {
+	} else if (riscv_insn_is_lh(insn)) {
 		len = 2;
 		shift = 8 * (sizeof(ulong) - len);
-	} else if ((insn & INSN_MASK_LHU) == INSN_MATCH_LHU) {
+	} else if (riscv_insn_is_lhu(insn)) {
 		len = 2;
 #ifdef CONFIG_64BIT
-	} else if ((insn & INSN_MASK_C_LD) == INSN_MATCH_C_LD) {
+	} else if (riscv_insn_is_c_ld(insn)) {
 		len = 8;
 		shift = 8 * (sizeof(ulong) - len);
-		insn = RVC_RS2S(insn) << SH_RD;
-	} else if ((insn & INSN_MASK_C_LDSP) == INSN_MATCH_C_LDSP &&
-		   ((insn >> SH_RD) & 0x1f)) {
+		insn = riscv_insn_extract_csca_rs2(insn) << RVG_RD_OPOFF;
+	} else if (riscv_insn_is_c_ldsp(insn) &&
+		   riscv_insn_extract_rd(insn)) {
 		len = 8;
 		shift = 8 * (sizeof(ulong) - len);
 #endif
-	} else if ((insn & INSN_MASK_C_LW) == INSN_MATCH_C_LW) {
+	} else if (riscv_insn_is_c_lw(insn)) {
 		len = 4;
 		shift = 8 * (sizeof(ulong) - len);
-		insn = RVC_RS2S(insn) << SH_RD;
-	} else if ((insn & INSN_MASK_C_LWSP) == INSN_MATCH_C_LWSP &&
-		   ((insn >> SH_RD) & 0x1f)) {
+		insn = riscv_insn_extract_csca_rs2(insn) << RVG_RD_OPOFF;
+	} else if (riscv_insn_is_c_lwsp(insn) &&
+		   riscv_insn_extract_rd(insn)) {
 		len = 4;
 		shift = 8 * (sizeof(ulong) - len);
 	} else {
@@ -592,7 +474,7 @@ int kvm_riscv_vcpu_mmio_store(struct kvm_vcpu *vcpu, struct kvm_run *run,
 		 * Bit[0] == 1 implies trapped instruction value is
 		 * transformed instruction or custom instruction.
 		 */
-		insn = htinst | INSN_16BIT_MASK;
+		insn = htinst | INSN_C_MASK;
 		insn_len = (htinst & BIT(1)) ? INSN_LEN(insn) : 2;
 	} else {
 		/*
@@ -610,35 +492,42 @@ int kvm_riscv_vcpu_mmio_store(struct kvm_vcpu *vcpu, struct kvm_run *run,
 		insn_len = INSN_LEN(insn);
 	}
 
-	data = GET_RS2(insn, &vcpu->arch.guest_context);
+	rv_insn_reg_get_val((unsigned long *)&vcpu->arch.guest_context,
+			    riscv_insn_extract_rs1(insn), &data);
 	data8 = data16 = data32 = data64 = data;
 
-	if ((insn & INSN_MASK_SW) == INSN_MATCH_SW) {
+	if (riscv_insn_is_sw(insn)) {
 		len = 4;
-	} else if ((insn & INSN_MASK_SB) == INSN_MATCH_SB) {
+	} else if (riscv_insn_is_sb(insn)) {
 		len = 1;
 #ifdef CONFIG_64BIT
-	} else if ((insn & INSN_MASK_SD) == INSN_MATCH_SD) {
+	} else if (riscv_insn_is_sd(insn)) {
 		len = 8;
 #endif
-	} else if ((insn & INSN_MASK_SH) == INSN_MATCH_SH) {
+	} else if (riscv_insn_is_sh(insn)) {
 		len = 2;
 #ifdef CONFIG_64BIT
-	} else if ((insn & INSN_MASK_C_SD) == INSN_MATCH_C_SD) {
+	} else if (riscv_insn_is_c_sd(insn)) {
 		len = 8;
-		data64 = GET_RS2S(insn, &vcpu->arch.guest_context);
-	} else if ((insn & INSN_MASK_C_SDSP) == INSN_MATCH_C_SDSP &&
-		   ((insn >> SH_RD) & 0x1f)) {
+		rv_insn_reg_get_val((unsigned long *)&vcpu->arch.guest_context,
+				    riscv_insn_extract_rs2(insn),
+				    (unsigned long *)&data64);
+	} else if (riscv_insn_is_c_sdsp(insn) && riscv_insn_extract_rd(insn)) {
 		len = 8;
-		data64 = GET_RS2C(insn, &vcpu->arch.guest_context);
+		rv_insn_reg_get_val((unsigned long *)&vcpu->arch.guest_context,
+				    riscv_insn_extract_csca_rs2(insn),
+				    (unsigned long *)&data64);
 #endif
-	} else if ((insn & INSN_MASK_C_SW) == INSN_MATCH_C_SW) {
+	} else if (riscv_insn_is_c_sw(insn)) {
 		len = 4;
-		data32 = GET_RS2S(insn, &vcpu->arch.guest_context);
-	} else if ((insn & INSN_MASK_C_SWSP) == INSN_MATCH_C_SWSP &&
-		   ((insn >> SH_RD) & 0x1f)) {
+		rv_insn_reg_get_val((unsigned long *)&vcpu->arch.guest_context,
+				    riscv_insn_extract_rs2(insn),
+				    (unsigned long *)&data32);
+	} else if (riscv_insn_is_c_swsp(insn) && riscv_insn_extract_rd(insn)) {
 		len = 4;
-		data32 = GET_RS2C(insn, &vcpu->arch.guest_context);
+		rv_insn_reg_get_val((unsigned long *)&vcpu->arch.guest_context,
+				    riscv_insn_extract_csca_rs2(insn),
+				    (unsigned long *)&data32);
 	} else {
 		return -EOPNOTSUPP;
 	}
@@ -707,6 +596,7 @@ int kvm_riscv_vcpu_mmio_return(struct kvm_vcpu *vcpu, struct kvm_run *run)
 	u32 data32;
 	u64 data64;
 	ulong insn;
+	u32 index;
 	int len, shift;
 
 	if (vcpu->arch.mmio_decode.return_handled)
@@ -720,27 +610,28 @@ int kvm_riscv_vcpu_mmio_return(struct kvm_vcpu *vcpu, struct kvm_run *run)
 
 	len = vcpu->arch.mmio_decode.len;
 	shift = vcpu->arch.mmio_decode.shift;
+	index = riscv_insn_extract_rd(insn);
 
 	switch (len) {
 	case 1:
 		data8 = *((u8 *)run->mmio.data);
-		SET_RD(insn, &vcpu->arch.guest_context,
-			(ulong)data8 << shift >> shift);
+		rv_insn_reg_set_val((unsigned long *)&vcpu->arch.guest_context,
+				    index, (ulong)data8 << shift >> shift);
 		break;
 	case 2:
 		data16 = *((u16 *)run->mmio.data);
-		SET_RD(insn, &vcpu->arch.guest_context,
-			(ulong)data16 << shift >> shift);
+		rv_insn_reg_set_val((unsigned long *)&vcpu->arch.guest_context,
+				    index, (ulong)data16 << shift >> shift);
 		break;
 	case 4:
 		data32 = *((u32 *)run->mmio.data);
-		SET_RD(insn, &vcpu->arch.guest_context,
-			(ulong)data32 << shift >> shift);
+		rv_insn_reg_set_val((unsigned long *)&vcpu->arch.guest_context,
+				    index, (ulong)data32 << shift >> shift);
 		break;
 	case 8:
 		data64 = *((u64 *)run->mmio.data);
-		SET_RD(insn, &vcpu->arch.guest_context,
-			(ulong)data64 << shift >> shift);
+		rv_insn_reg_set_val((unsigned long *)&vcpu->arch.guest_context,
+				    index, (ulong)data64 << shift >> shift);
 		break;
 	default:
 		return -EOPNOTSUPP;

-- 
2.34.1

