Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 274C676F799
	for <lists+kvm@lfdr.de>; Fri,  4 Aug 2023 04:12:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233688AbjHDCMP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 22:12:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232908AbjHDCLk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 22:11:40 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F46C49F2
        for <kvm@vger.kernel.org>; Thu,  3 Aug 2023 19:11:11 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id d2e1a72fcca58-686b91c2744so1180312b3a.0
        for <kvm@vger.kernel.org>; Thu, 03 Aug 2023 19:11:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20221208.gappssmtp.com; s=20221208; t=1691115061; x=1691719861;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TvocQ3kzvUtZx7OcqBm6IQToMDU6XVm4cjeyn7D1owI=;
        b=189wskav2mNhYG4PGFGcjURhFsVNfX4Y2mmf3tyouPd0xHiF8Zy1G9prJ2A1rZSVQs
         VEDyD9B+biyNNSs1RMPW9xFW/EekJBfiPkqkJGTZCaMQXa2mxF70yjBFQ6hp+sHQPsJO
         gjYTifDvOG3vFwqrZFXWH0OiKV0FxYXC7tFoj3Iq+aJETZTq8d2IZaCZD0spwPY1qGZF
         AGFXjHOArK3zFuEfsGU9hw1SWkPcZca9aRY/xDyWw0f0Ibn0agLtGVG59zM2XT16YGp/
         6g7WmhnPKQk5sYktnoKZE4HXqdRLhMXm22Kkgch4Sh4doYU0Hm2+wcvwdq0TP6tUIr5G
         tUHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691115061; x=1691719861;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TvocQ3kzvUtZx7OcqBm6IQToMDU6XVm4cjeyn7D1owI=;
        b=XhxMpn17b0L8s5CUsEE9eWNtLJ71pxKIukO0oatSTEoObjGWA5g23eZbo0kPRj1tow
         MqzspghICqCWkwE3etjHp/HrPCrCx2EsjZ7F8/ZTo67/FyahnPYGqXGqTCcqgmqjBTIO
         eTsHOdTzH+hsYY2V7yPKkME3RhyC2mD+hQTYr8PDyvT2QEFj7LVaIflUKQiUr3XSkmuJ
         A2EhxLaSHWVDIHeUwARIEjEAK1ClPnHgxAYKiE2Yz1mBPVu36/PQC6y9rnPzGm7QG8lE
         3s00uBRnv6yux9/kpWnYkxwd7doktvDA0OQKvwFWLSBXlsowtF+ah3pVoFLCEXRA4zsF
         HX4g==
X-Gm-Message-State: AOJu0YwlpLXw6B3CAcVWzxUXRzDp27xbITT1+Rm4+QiHUZnC3kBbkWv2
        YnROQX2OPreVFpmumSj+bciCWg==
X-Google-Smtp-Source: AGHT+IGW5fUbLeHB1q3HXvX2gzuNau1K9/d2OOrCFZdKIeflYlEuvm3pmsHong703HZymw3Xc9M04Q==
X-Received: by 2002:a05:6a20:8f13:b0:13a:52ce:13cc with SMTP id b19-20020a056a208f1300b0013a52ce13ccmr380626pzk.51.1691115061016;
        Thu, 03 Aug 2023 19:11:01 -0700 (PDT)
Received: from charlie.ba.rivosinc.com ([66.220.2.162])
        by smtp.gmail.com with ESMTPSA id g6-20020a655806000000b0055c558ac4edsm369499pgr.46.2023.08.03.19.10.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Aug 2023 19:11:00 -0700 (PDT)
From:   Charlie Jenkins <charlie@rivosinc.com>
Date:   Thu, 03 Aug 2023 19:10:30 -0700
Subject: [PATCH 05/10] RISC-V: module: Refactor instructions
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230803-master-refactor-instructions-v4-v1-5-2128e61fa4ff@rivosinc.com>
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
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use shared instruction definitions in insn.h instead of manually
constructing them.

Additionally, extra work was being done in apply_r_riscv_lo12_s_rela
to ensure that the bits were set up properly for the lo12, but because
-(a-b)=b-a it wasn't actually doing anything.

Signed-off-by: Charlie Jenkins <charlie@rivosinc.com>
---
 arch/riscv/kernel/module.c | 80 +++++++++++-----------------------------------
 1 file changed, 18 insertions(+), 62 deletions(-)

diff --git a/arch/riscv/kernel/module.c b/arch/riscv/kernel/module.c
index 7c651d55fcbd..950783e5b5ae 100644
--- a/arch/riscv/kernel/module.c
+++ b/arch/riscv/kernel/module.c
@@ -12,8 +12,11 @@
 #include <linux/sizes.h>
 #include <linux/pgtable.h>
 #include <asm/alternative.h>
+#include <asm/insn.h>
 #include <asm/sections.h>
 
+#define HI20_OFFSET 0x800
+
 /*
  * The auipc+jalr instruction pair can reach any PC-relative offset
  * in the range [-2^31 - 2^11, 2^31 - 2^11)
@@ -48,12 +51,8 @@ static int apply_r_riscv_branch_rela(struct module *me, u32 *location,
 				     Elf_Addr v)
 {
 	ptrdiff_t offset = (void *)v - (void *)location;
-	u32 imm12 = (offset & 0x1000) << (31 - 12);
-	u32 imm11 = (offset & 0x800) >> (11 - 7);
-	u32 imm10_5 = (offset & 0x7e0) << (30 - 10);
-	u32 imm4_1 = (offset & 0x1e) << (11 - 4);
 
-	*location = (*location & 0x1fff07f) | imm12 | imm11 | imm10_5 | imm4_1;
+	riscv_insn_insert_btype_imm(location, ((s32)offset));
 	return 0;
 }
 
@@ -61,12 +60,8 @@ static int apply_r_riscv_jal_rela(struct module *me, u32 *location,
 				  Elf_Addr v)
 {
 	ptrdiff_t offset = (void *)v - (void *)location;
-	u32 imm20 = (offset & 0x100000) << (31 - 20);
-	u32 imm19_12 = (offset & 0xff000);
-	u32 imm11 = (offset & 0x800) << (20 - 11);
-	u32 imm10_1 = (offset & 0x7fe) << (30 - 10);
 
-	*location = (*location & 0xfff) | imm20 | imm19_12 | imm11 | imm10_1;
+	riscv_insn_insert_jtype_imm(location, ((s32)offset));
 	return 0;
 }
 
@@ -74,14 +69,8 @@ static int apply_r_riscv_rvc_branch_rela(struct module *me, u32 *location,
 					 Elf_Addr v)
 {
 	ptrdiff_t offset = (void *)v - (void *)location;
-	u16 imm8 = (offset & 0x100) << (12 - 8);
-	u16 imm7_6 = (offset & 0xc0) >> (6 - 5);
-	u16 imm5 = (offset & 0x20) >> (5 - 2);
-	u16 imm4_3 = (offset & 0x18) << (12 - 5);
-	u16 imm2_1 = (offset & 0x6) << (12 - 10);
-
-	*(u16 *)location = (*(u16 *)location & 0xe383) |
-		    imm8 | imm7_6 | imm5 | imm4_3 | imm2_1;
+
+	riscv_insn_insert_cbztype_imm(location, (s32)offset);
 	return 0;
 }
 
@@ -89,17 +78,8 @@ static int apply_r_riscv_rvc_jump_rela(struct module *me, u32 *location,
 				       Elf_Addr v)
 {
 	ptrdiff_t offset = (void *)v - (void *)location;
-	u16 imm11 = (offset & 0x800) << (12 - 11);
-	u16 imm10 = (offset & 0x400) >> (10 - 8);
-	u16 imm9_8 = (offset & 0x300) << (12 - 11);
-	u16 imm7 = (offset & 0x80) >> (7 - 6);
-	u16 imm6 = (offset & 0x40) << (12 - 11);
-	u16 imm5 = (offset & 0x20) >> (5 - 2);
-	u16 imm4 = (offset & 0x10) << (12 - 5);
-	u16 imm3_1 = (offset & 0xe) << (12 - 10);
-
-	*(u16 *)location = (*(u16 *)location & 0xe003) |
-		    imm11 | imm10 | imm9_8 | imm7 | imm6 | imm5 | imm4 | imm3_1;
+
+	riscv_insn_insert_cjtype_imm(location, (s32)offset);
 	return 0;
 }
 
@@ -107,7 +87,6 @@ static int apply_r_riscv_pcrel_hi20_rela(struct module *me, u32 *location,
 					 Elf_Addr v)
 {
 	ptrdiff_t offset = (void *)v - (void *)location;
-	s32 hi20;
 
 	if (!riscv_insn_valid_32bit_offset(offset)) {
 		pr_err(
@@ -116,8 +95,7 @@ static int apply_r_riscv_pcrel_hi20_rela(struct module *me, u32 *location,
 		return -EINVAL;
 	}
 
-	hi20 = (offset + 0x800) & 0xfffff000;
-	*location = (*location & 0xfff) | hi20;
+	riscv_insn_insert_utype_imm(location, (offset + HI20_OFFSET));
 	return 0;
 }
 
@@ -128,7 +106,7 @@ static int apply_r_riscv_pcrel_lo12_i_rela(struct module *me, u32 *location,
 	 * v is the lo12 value to fill. It is calculated before calling this
 	 * handler.
 	 */
-	*location = (*location & 0xfffff) | ((v & 0xfff) << 20);
+	riscv_insn_insert_itype_imm(location, ((s32)v));
 	return 0;
 }
 
@@ -139,18 +117,13 @@ static int apply_r_riscv_pcrel_lo12_s_rela(struct module *me, u32 *location,
 	 * v is the lo12 value to fill. It is calculated before calling this
 	 * handler.
 	 */
-	u32 imm11_5 = (v & 0xfe0) << (31 - 11);
-	u32 imm4_0 = (v & 0x1f) << (11 - 4);
-
-	*location = (*location & 0x1fff07f) | imm11_5 | imm4_0;
+	riscv_insn_insert_stype_imm(location, ((s32)v));
 	return 0;
 }
 
 static int apply_r_riscv_hi20_rela(struct module *me, u32 *location,
 				   Elf_Addr v)
 {
-	s32 hi20;
-
 	if (IS_ENABLED(CONFIG_CMODEL_MEDLOW)) {
 		pr_err(
 		  "%s: target %016llx can not be addressed by the 32-bit offset from PC = %p\n",
@@ -158,8 +131,7 @@ static int apply_r_riscv_hi20_rela(struct module *me, u32 *location,
 		return -EINVAL;
 	}
 
-	hi20 = ((s32)v + 0x800) & 0xfffff000;
-	*location = (*location & 0xfff) | hi20;
+	riscv_insn_insert_utype_imm(location, ((s32)v + HI20_OFFSET));
 	return 0;
 }
 
@@ -167,9 +139,7 @@ static int apply_r_riscv_lo12_i_rela(struct module *me, u32 *location,
 				     Elf_Addr v)
 {
 	/* Skip medlow checking because of filtering by HI20 already */
-	s32 hi20 = ((s32)v + 0x800) & 0xfffff000;
-	s32 lo12 = ((s32)v - hi20);
-	*location = (*location & 0xfffff) | ((lo12 & 0xfff) << 20);
+	riscv_insn_insert_itype_imm(location, (s32)v);
 	return 0;
 }
 
@@ -177,11 +147,7 @@ static int apply_r_riscv_lo12_s_rela(struct module *me, u32 *location,
 				     Elf_Addr v)
 {
 	/* Skip medlow checking because of filtering by HI20 already */
-	s32 hi20 = ((s32)v + 0x800) & 0xfffff000;
-	s32 lo12 = ((s32)v - hi20);
-	u32 imm11_5 = (lo12 & 0xfe0) << (31 - 11);
-	u32 imm4_0 = (lo12 & 0x1f) << (11 - 4);
-	*location = (*location & 0x1fff07f) | imm11_5 | imm4_0;
+	riscv_insn_insert_stype_imm(location, (s32)v);
 	return 0;
 }
 
@@ -189,7 +155,6 @@ static int apply_r_riscv_got_hi20_rela(struct module *me, u32 *location,
 				       Elf_Addr v)
 {
 	ptrdiff_t offset = (void *)v - (void *)location;
-	s32 hi20;
 
 	/* Always emit the got entry */
 	if (IS_ENABLED(CONFIG_MODULE_SECTIONS)) {
@@ -202,8 +167,7 @@ static int apply_r_riscv_got_hi20_rela(struct module *me, u32 *location,
 		return -EINVAL;
 	}
 
-	hi20 = (offset + 0x800) & 0xfffff000;
-	*location = (*location & 0xfff) | hi20;
+	riscv_insn_insert_utype_imm(location, (s32)(offset + HI20_OFFSET));
 	return 0;
 }
 
@@ -211,7 +175,6 @@ static int apply_r_riscv_call_plt_rela(struct module *me, u32 *location,
 				       Elf_Addr v)
 {
 	ptrdiff_t offset = (void *)v - (void *)location;
-	u32 hi20, lo12;
 
 	if (!riscv_insn_valid_32bit_offset(offset)) {
 		/* Only emit the plt entry if offset over 32-bit range */
@@ -226,10 +189,7 @@ static int apply_r_riscv_call_plt_rela(struct module *me, u32 *location,
 		}
 	}
 
-	hi20 = (offset + 0x800) & 0xfffff000;
-	lo12 = (offset - hi20) & 0xfff;
-	*location = (*location & 0xfff) | hi20;
-	*(location + 1) = (*(location + 1) & 0xfffff) | (lo12 << 20);
+	riscv_insn_insert_utype_itype_imm(location, location + 1, (s32)offset);
 	return 0;
 }
 
@@ -237,7 +197,6 @@ static int apply_r_riscv_call_rela(struct module *me, u32 *location,
 				   Elf_Addr v)
 {
 	ptrdiff_t offset = (void *)v - (void *)location;
-	u32 hi20, lo12;
 
 	if (!riscv_insn_valid_32bit_offset(offset)) {
 		pr_err(
@@ -246,10 +205,7 @@ static int apply_r_riscv_call_rela(struct module *me, u32 *location,
 		return -EINVAL;
 	}
 
-	hi20 = (offset + 0x800) & 0xfffff000;
-	lo12 = (offset - hi20) & 0xfff;
-	*location = (*location & 0xfff) | hi20;
-	*(location + 1) = (*(location + 1) & 0xfffff) | (lo12 << 20);
+	riscv_insn_insert_utype_itype_imm(location, location + 1, (s32)offset);
 	return 0;
 }
 

-- 
2.34.1

