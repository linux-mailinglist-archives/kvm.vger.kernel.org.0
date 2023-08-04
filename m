Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E2EE76F7A1
	for <lists+kvm@lfdr.de>; Fri,  4 Aug 2023 04:12:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233358AbjHDCMj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 22:12:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233046AbjHDCL4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 22:11:56 -0400
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3BF34C06
        for <kvm@vger.kernel.org>; Thu,  3 Aug 2023 19:11:24 -0700 (PDT)
Received: by mail-oi1-x230.google.com with SMTP id 5614622812f47-3a74d759be4so1222788b6e.2
        for <kvm@vger.kernel.org>; Thu, 03 Aug 2023 19:11:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20221208.gappssmtp.com; s=20221208; t=1691115065; x=1691719865;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=utAxHXGCk0s0MGtyBcy0wGG+fjIXniu7w9sbMi99EII=;
        b=2Ud2NQBS5pxrNSE/4sEBtKmvdzrwzD0DNrpLL4Jpk5IVgAuLYD2Qb8lIcXGXHdFUTe
         ZJ5/RbdpTyO/DoseixXdyQrCuicaGE/ufBY7isL11QxvVjoBeWOZiHDWBWVuR4ouKOGn
         gUFR73gMIiTAl7wiGpoRbNR9dUWiqqOhSYcd3PCGvQ1l7lgEmnj5w+t8/UYSppIgAbMo
         UH70h/K6ah65vf1uxfdcVIVuqUk85on5nuOySotYUzjJXZVhrhxSMhaf5NIu+DaExiZq
         sFqLrbkcQa8vTgo7sT3BKgF2nfPSjv/bK3cG/KPYis6OCn9KWjbKKf8/JMfLbyaLOh4Y
         28SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691115065; x=1691719865;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=utAxHXGCk0s0MGtyBcy0wGG+fjIXniu7w9sbMi99EII=;
        b=azYUnE+VtPynSnPgLG+icDkVVeyWiY/NS0BQGrCrszRWyiq9/yF8mdcnhJHhE7e3q4
         AV6IOAOS13p23P2oVu8D1yslCJZ8IQ2ezzBr+V0KEuxsw1cKhjBkkgLAKHkpKw6oavIQ
         v8gPkJ0Yba64MlLKJy6zRji42Sla2tSD0LPu1mcg2MEdbqxYcmsQZXmQdUH+swlrOy3U
         csBTAIO3nAjbRu1+Zg5ohO+jU01X5Tc2GCX58mF+fc0oA5CbzHe28fNDe+M1TrJzOxXl
         w/fVZD52hxyPCodSqTPv9qSyAKML04M6HE9HUvlCh90G5LF/RR98KXH/e/+knTzJvBvu
         rLiA==
X-Gm-Message-State: AOJu0Yywa9tDN4B4wPKHpK1boJVdjK1nlc1XlRmUwcGVWuiT5CTRwKrU
        bJxA1aXZhQV+I4VAnrLKmfK5bw==
X-Google-Smtp-Source: AGHT+IG9sCpMJtqiJ9jvb2wzQ5yReUA9iACju+gpqXRvIhk4weyUg+HwEHIbnyozun5cFHPRNV7nfw==
X-Received: by 2002:a05:6358:7213:b0:134:ec26:b53 with SMTP id h19-20020a056358721300b00134ec260b53mr710567rwa.16.1691115065043;
        Thu, 03 Aug 2023 19:11:05 -0700 (PDT)
Received: from charlie.ba.rivosinc.com ([66.220.2.162])
        by smtp.gmail.com with ESMTPSA id g6-20020a655806000000b0055c558ac4edsm369499pgr.46.2023.08.03.19.11.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Aug 2023 19:11:04 -0700 (PDT)
From:   Charlie Jenkins <charlie@rivosinc.com>
Date:   Thu, 03 Aug 2023 19:10:32 -0700
Subject: [PATCH 07/10] RISC-V: nommu: Refactor instructions
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230803-master-refactor-instructions-v4-v1-7-2128e61fa4ff@rivosinc.com>
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
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use shared instruction definitions in insn.h instead of manually
constructing them.

Signed-off-by: Charlie Jenkins <charlie@rivosinc.com>
---
 arch/riscv/kernel/traps_misaligned.c | 218 ++++++++---------------------------
 1 file changed, 45 insertions(+), 173 deletions(-)

diff --git a/arch/riscv/kernel/traps_misaligned.c b/arch/riscv/kernel/traps_misaligned.c
index 378f5b151443..b72045ce432a 100644
--- a/arch/riscv/kernel/traps_misaligned.c
+++ b/arch/riscv/kernel/traps_misaligned.c
@@ -12,144 +12,10 @@
 #include <asm/processor.h>
 #include <asm/ptrace.h>
 #include <asm/csr.h>
+#include <asm/insn.h>
+#include <asm/reg.h>
 
-#define INSN_MATCH_LB			0x3
-#define INSN_MASK_LB			0x707f
-#define INSN_MATCH_LH			0x1003
-#define INSN_MASK_LH			0x707f
-#define INSN_MATCH_LW			0x2003
-#define INSN_MASK_LW			0x707f
-#define INSN_MATCH_LD			0x3003
-#define INSN_MASK_LD			0x707f
-#define INSN_MATCH_LBU			0x4003
-#define INSN_MASK_LBU			0x707f
-#define INSN_MATCH_LHU			0x5003
-#define INSN_MASK_LHU			0x707f
-#define INSN_MATCH_LWU			0x6003
-#define INSN_MASK_LWU			0x707f
-#define INSN_MATCH_SB			0x23
-#define INSN_MASK_SB			0x707f
-#define INSN_MATCH_SH			0x1023
-#define INSN_MASK_SH			0x707f
-#define INSN_MATCH_SW			0x2023
-#define INSN_MASK_SW			0x707f
-#define INSN_MATCH_SD			0x3023
-#define INSN_MASK_SD			0x707f
-
-#define INSN_MATCH_FLW			0x2007
-#define INSN_MASK_FLW			0x707f
-#define INSN_MATCH_FLD			0x3007
-#define INSN_MASK_FLD			0x707f
-#define INSN_MATCH_FLQ			0x4007
-#define INSN_MASK_FLQ			0x707f
-#define INSN_MATCH_FSW			0x2027
-#define INSN_MASK_FSW			0x707f
-#define INSN_MATCH_FSD			0x3027
-#define INSN_MASK_FSD			0x707f
-#define INSN_MATCH_FSQ			0x4027
-#define INSN_MASK_FSQ			0x707f
-
-#define INSN_MATCH_C_LD			0x6000
-#define INSN_MASK_C_LD			0xe003
-#define INSN_MATCH_C_SD			0xe000
-#define INSN_MASK_C_SD			0xe003
-#define INSN_MATCH_C_LW			0x4000
-#define INSN_MASK_C_LW			0xe003
-#define INSN_MATCH_C_SW			0xc000
-#define INSN_MASK_C_SW			0xe003
-#define INSN_MATCH_C_LDSP		0x6002
-#define INSN_MASK_C_LDSP		0xe003
-#define INSN_MATCH_C_SDSP		0xe002
-#define INSN_MASK_C_SDSP		0xe003
-#define INSN_MATCH_C_LWSP		0x4002
-#define INSN_MASK_C_LWSP		0xe003
-#define INSN_MATCH_C_SWSP		0xc002
-#define INSN_MASK_C_SWSP		0xe003
-
-#define INSN_MATCH_C_FLD		0x2000
-#define INSN_MASK_C_FLD			0xe003
-#define INSN_MATCH_C_FLW		0x6000
-#define INSN_MASK_C_FLW			0xe003
-#define INSN_MATCH_C_FSD		0xa000
-#define INSN_MASK_C_FSD			0xe003
-#define INSN_MATCH_C_FSW		0xe000
-#define INSN_MASK_C_FSW			0xe003
-#define INSN_MATCH_C_FLDSP		0x2002
-#define INSN_MASK_C_FLDSP		0xe003
-#define INSN_MATCH_C_FSDSP		0xa002
-#define INSN_MASK_C_FSDSP		0xe003
-#define INSN_MATCH_C_FLWSP		0x6002
-#define INSN_MASK_C_FLWSP		0xe003
-#define INSN_MATCH_C_FSWSP		0xe002
-#define INSN_MASK_C_FSWSP		0xe003
-
-#define INSN_LEN(insn)			((((insn) & 0x3) < 0x3) ? 2 : 4)
-
-#if defined(CONFIG_64BIT)
-#define LOG_REGBYTES			3
-#define XLEN				64
-#else
-#define LOG_REGBYTES			2
-#define XLEN				32
-#endif
-#define REGBYTES			(1 << LOG_REGBYTES)
-#define XLEN_MINUS_16			((XLEN) - 16)
-
-#define SH_RD				7
-#define SH_RS1				15
-#define SH_RS2				20
-#define SH_RS2C				2
-
-#define RV_X(x, s, n)			(((x) >> (s)) & ((1 << (n)) - 1))
-#define RVC_LW_IMM(x)			((RV_X(x, 6, 1) << 2) | \
-					 (RV_X(x, 10, 3) << 3) | \
-					 (RV_X(x, 5, 1) << 6))
-#define RVC_LD_IMM(x)			((RV_X(x, 10, 3) << 3) | \
-					 (RV_X(x, 5, 2) << 6))
-#define RVC_LWSP_IMM(x)			((RV_X(x, 4, 3) << 2) | \
-					 (RV_X(x, 12, 1) << 5) | \
-					 (RV_X(x, 2, 2) << 6))
-#define RVC_LDSP_IMM(x)			((RV_X(x, 5, 2) << 3) | \
-					 (RV_X(x, 12, 1) << 5) | \
-					 (RV_X(x, 2, 3) << 6))
-#define RVC_SWSP_IMM(x)			((RV_X(x, 9, 4) << 2) | \
-					 (RV_X(x, 7, 2) << 6))
-#define RVC_SDSP_IMM(x)			((RV_X(x, 10, 3) << 3) | \
-					 (RV_X(x, 7, 3) << 6))
-#define RVC_RS1S(insn)			(8 + RV_X(insn, SH_RD, 3))
-#define RVC_RS2S(insn)			(8 + RV_X(insn, SH_RS2C, 3))
-#define RVC_RS2(insn)			RV_X(insn, SH_RS2C, 5)
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
-	(ulong *)((ulong)(regs) + REG_OFFSET(insn, pos))
-
-#define GET_RM(insn)			(((insn) >> 12) & 7)
-
-#define GET_RS1(insn, regs)		(*REG_PTR(insn, SH_RS1, regs))
-#define GET_RS2(insn, regs)		(*REG_PTR(insn, SH_RS2, regs))
-#define GET_RS1S(insn, regs)		(*REG_PTR(RVC_RS1S(insn), 0, regs))
-#define GET_RS2S(insn, regs)		(*REG_PTR(RVC_RS2S(insn), 0, regs))
-#define GET_RS2C(insn, regs)		(*REG_PTR(insn, SH_RS2C, regs))
-#define GET_SP(regs)			(*REG_PTR(2, 0, regs))
-#define SET_RD(insn, regs, val)		(*REG_PTR(insn, SH_RD, regs) = (val))
-#define IMM_I(insn)			((s32)(insn) >> 20)
-#define IMM_S(insn)			(((s32)(insn) >> 25 << 5) | \
-					 (s32)(((insn) >> 7) & 0x1f))
-#define MASK_FUNCT3			0x7000
-
-#define GET_PRECISION(insn) (((insn) >> 25) & 3)
-#define GET_RM(insn) (((insn) >> 12) & 7)
-#define PRECISION_S 0
-#define PRECISION_D 1
+#define XLEN_MINUS_16			((__riscv_xlen) - 16)
 
 #define DECLARE_UNPRIVILEGED_LOAD_FUNCTION(type, insn)			\
 static inline type load_##type(const type *addr)			\
@@ -245,58 +111,56 @@ int handle_misaligned_load(struct pt_regs *regs)
 
 	regs->epc = 0;
 
-	if ((insn & INSN_MASK_LW) == INSN_MATCH_LW) {
+	if (riscv_insn_is_lw(insn)) {
 		len = 4;
 		shift = 8 * (sizeof(unsigned long) - len);
 #if defined(CONFIG_64BIT)
-	} else if ((insn & INSN_MASK_LD) == INSN_MATCH_LD) {
+	} else if (riscv_insn_is_ld(insn)) {
 		len = 8;
 		shift = 8 * (sizeof(unsigned long) - len);
-	} else if ((insn & INSN_MASK_LWU) == INSN_MATCH_LWU) {
+	} else if (riscv_insn_is_lwu(insn)) {
 		len = 4;
 #endif
-	} else if ((insn & INSN_MASK_FLD) == INSN_MATCH_FLD) {
+	} else if (riscv_insn_is_fld(insn)) {
 		fp = 1;
 		len = 8;
-	} else if ((insn & INSN_MASK_FLW) == INSN_MATCH_FLW) {
+	} else if (riscv_insn_is_flw(insn)) {
 		fp = 1;
 		len = 4;
-	} else if ((insn & INSN_MASK_LH) == INSN_MATCH_LH) {
+	} else if (riscv_insn_is_lh(insn)) {
 		len = 2;
 		shift = 8 * (sizeof(unsigned long) - len);
-	} else if ((insn & INSN_MASK_LHU) == INSN_MATCH_LHU) {
+	} else if (riscv_insn_is_lhu(insn)) {
 		len = 2;
 #if defined(CONFIG_64BIT)
-	} else if ((insn & INSN_MASK_C_LD) == INSN_MATCH_C_LD) {
+	} else if (riscv_insn_is_c_ld(insn)) {
 		len = 8;
 		shift = 8 * (sizeof(unsigned long) - len);
-		insn = RVC_RS2S(insn) << SH_RD;
-	} else if ((insn & INSN_MASK_C_LDSP) == INSN_MATCH_C_LDSP &&
-		   ((insn >> SH_RD) & 0x1f)) {
+		insn = riscv_insn_extract_csca_rs2(insn);
+	} else if (riscv_insn_is_c_ldsp(insn) && (RVC_RD_CI(insn))) {
 		len = 8;
 		shift = 8 * (sizeof(unsigned long) - len);
 #endif
-	} else if ((insn & INSN_MASK_C_LW) == INSN_MATCH_C_LW) {
+	} else if (riscv_insn_is_c_lw(insn)) {
 		len = 4;
 		shift = 8 * (sizeof(unsigned long) - len);
-		insn = RVC_RS2S(insn) << SH_RD;
-	} else if ((insn & INSN_MASK_C_LWSP) == INSN_MATCH_C_LWSP &&
-		   ((insn >> SH_RD) & 0x1f)) {
+		insn = riscv_insn_extract_csca_rs2(insn);
+	} else if (riscv_insn_is_c_lwsp(insn) && (RVC_RD_CI(insn))) {
 		len = 4;
 		shift = 8 * (sizeof(unsigned long) - len);
-	} else if ((insn & INSN_MASK_C_FLD) == INSN_MATCH_C_FLD) {
+	} else if (riscv_insn_is_c_fld(insn)) {
 		fp = 1;
 		len = 8;
-		insn = RVC_RS2S(insn) << SH_RD;
-	} else if ((insn & INSN_MASK_C_FLDSP) == INSN_MATCH_C_FLDSP) {
+		insn = riscv_insn_extract_csca_rs2(insn);
+	} else if (riscv_insn_is_c_fldsp(insn)) {
 		fp = 1;
 		len = 8;
 #if defined(CONFIG_32BIT)
-	} else if ((insn & INSN_MASK_C_FLW) == INSN_MATCH_C_FLW) {
+	} else if (riscv_insn_is_c_flw(insn)) {
 		fp = 1;
 		len = 4;
-		insn = RVC_RS2S(insn) << SH_RD;
-	} else if ((insn & INSN_MASK_C_FLWSP) == INSN_MATCH_C_FLWSP) {
+		insn = riscv_insn_extract_csca_rs2(insn);
+	} else if (riscv_insn_is_c_flwsp(insn)) {
 		fp = 1;
 		len = 4;
 #endif
@@ -311,7 +175,8 @@ int handle_misaligned_load(struct pt_regs *regs)
 
 	if (fp)
 		return -1;
-	SET_RD(insn, regs, val.data_ulong << shift >> shift);
+	rv_insn_reg_set_val((unsigned long *)regs, RV_EXTRACT_RD_REG(insn),
+			    val.data_ulong << shift >> shift);
 
 	regs->epc = epc + INSN_LEN(insn);
 
@@ -328,32 +193,39 @@ int handle_misaligned_store(struct pt_regs *regs)
 
 	regs->epc = 0;
 
-	val.data_ulong = GET_RS2(insn, regs);
+	rv_insn_reg_get_val((unsigned long *)regs, riscv_insn_extract_rs2(insn),
+			    &val.data_ulong);
 
-	if ((insn & INSN_MASK_SW) == INSN_MATCH_SW) {
+	if (riscv_insn_is_sw(insn)) {
 		len = 4;
 #if defined(CONFIG_64BIT)
-	} else if ((insn & INSN_MASK_SD) == INSN_MATCH_SD) {
+	} else if (riscv_insn_is_sd(insn)) {
 		len = 8;
 #endif
-	} else if ((insn & INSN_MASK_SH) == INSN_MATCH_SH) {
+	} else if (riscv_insn_is_sh(insn)) {
 		len = 2;
 #if defined(CONFIG_64BIT)
-	} else if ((insn & INSN_MASK_C_SD) == INSN_MATCH_C_SD) {
+	} else if (riscv_insn_is_c_sd(insn)) {
 		len = 8;
-		val.data_ulong = GET_RS2S(insn, regs);
-	} else if ((insn & INSN_MASK_C_SDSP) == INSN_MATCH_C_SDSP &&
-		   ((insn >> SH_RD) & 0x1f)) {
+		rv_insn_reg_get_val((unsigned long *)regs,
+				    riscv_insn_extract_cr_rs2(insn),
+				    &val.data_ulong);
+	} else if (riscv_insn_is_c_sdsp(insn)) {
 		len = 8;
-		val.data_ulong = GET_RS2C(insn, regs);
+		rv_insn_reg_get_val((unsigned long *)regs,
+				    riscv_insn_extract_csca_rs2(insn),
+				    &val.data_ulong);
 #endif
-	} else if ((insn & INSN_MASK_C_SW) == INSN_MATCH_C_SW) {
+	} else if (riscv_insn_is_c_sw(insn)) {
 		len = 4;
-		val.data_ulong = GET_RS2S(insn, regs);
-	} else if ((insn & INSN_MASK_C_SWSP) == INSN_MATCH_C_SWSP &&
-		   ((insn >> SH_RD) & 0x1f)) {
+		rv_insn_reg_get_val((unsigned long *)regs,
+				    riscv_insn_extract_cr_rs2(insn),
+				    &val.data_ulong);
+	} else if (riscv_insn_is_c_swsp(insn)) {
 		len = 4;
-		val.data_ulong = GET_RS2C(insn, regs);
+		rv_insn_reg_get_val((unsigned long *)regs,
+				    riscv_insn_extract_csca_rs2(insn),
+				    &val.data_ulong);
 	} else {
 		regs->epc = epc;
 		return -1;

-- 
2.34.1

