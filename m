Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2302076F79D
	for <lists+kvm@lfdr.de>; Fri,  4 Aug 2023 04:12:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233480AbjHDCM2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 22:12:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233416AbjHDCLp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 22:11:45 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD66949D4
        for <kvm@vger.kernel.org>; Thu,  3 Aug 2023 19:11:16 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id d2e1a72fcca58-686c06b806cso1153562b3a.2
        for <kvm@vger.kernel.org>; Thu, 03 Aug 2023 19:11:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20221208.gappssmtp.com; s=20221208; t=1691115063; x=1691719863;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xL4SUrFC0SEjwT2Aq0+zll5WmXviuZuzcvI35+EgLbI=;
        b=pl/wAP3GSnmzUj0rIIA7pNZsP1pu/x7DAz3UUDociqK/9ym2Q/7lCLccZpyr/oGnOq
         mazjRlgtR9P6+ZibckgI161WdRt3n/X0e4AyL3oo6I9i3eGF0JfSd+Qu5lrFriErxi4u
         eA09Q6fGr4ajJpvqenrJ8LYLM17C9sM55cijEYZBSFpwzQik+AqRUbz4uGL2W5TiYd3E
         s5XjBCiBrptpAxA12KHT+YPsl/nKK/hqYXObmPljinTzetAoAON5K7krRBGRTUXKcpan
         x4ezXngz/kpvx3dDGBgRcigjlgo9pkBfD4Yz7/V9NdppOdCEcN6rRhHL+ZmGvt1yYP8R
         LssA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691115063; x=1691719863;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xL4SUrFC0SEjwT2Aq0+zll5WmXviuZuzcvI35+EgLbI=;
        b=MsxAxwQC3NNAfEwhC7hLsSJ3nnJJ5+ErB1fJ/6O5lM54nsdEBf9ORt/qBAfa8oUi6J
         0Fs3YSLctEeC4R3nM8qvvDfclEBhrV2saW52R/RsNeFCTSIA0FEXI++W80XGVrtbBHpT
         P7o/xSSagJ2VpeaFfFNrQhIVIga1x5vl+MOdYjQ76HRWDXn4wf5RbU8pvkLm6TrIpvTz
         jEK5brYjh1MgHpz0NaEvQbzXNtyTWhiXrMlGU9QMVH0PSjPfyosUxQgS4s8L/5xqcm2K
         GliiP+xR+Xo5pzisCZmzq+FGAnxV215PAQPQoJSMt6ofJRhZVPu0FhydYQef/Musm2tu
         W9SA==
X-Gm-Message-State: AOJu0YxWSuGA336U19NPRxNoBmwzuBPGv94lgSWU1+AfU6YkvLSn6+la
        r/QzTxuy9O/UfmtNQ7Cj/gkYKA==
X-Google-Smtp-Source: AGHT+IEWMGG8I7Bx8vxPRq5vbS6bzyhi8Am9MK0LkQRTff8vwoXnpjEoBIXTfO5sLYuNOOcKckXAfw==
X-Received: by 2002:a05:6a00:18a2:b0:666:81ae:fec0 with SMTP id x34-20020a056a0018a200b0066681aefec0mr463394pfh.25.1691115062994;
        Thu, 03 Aug 2023 19:11:02 -0700 (PDT)
Received: from charlie.ba.rivosinc.com ([66.220.2.162])
        by smtp.gmail.com with ESMTPSA id g6-20020a655806000000b0055c558ac4edsm369499pgr.46.2023.08.03.19.11.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Aug 2023 19:11:02 -0700 (PDT)
From:   Charlie Jenkins <charlie@rivosinc.com>
Date:   Thu, 03 Aug 2023 19:10:31 -0700
Subject: [PATCH 06/10] RISC-V: Refactor patch instructions
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230803-master-refactor-instructions-v4-v1-6-2128e61fa4ff@rivosinc.com>
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
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use shared instruction definitions in insn.h.

Signed-off-by: Charlie Jenkins <charlie@rivosinc.com>
---
 arch/riscv/kernel/patch.c                |  3 +-
 arch/riscv/kernel/probes/kprobes.c       | 13 +++----
 arch/riscv/kernel/probes/simulate-insn.c | 61 +++++++-------------------------
 arch/riscv/kernel/probes/uprobes.c       |  5 +--
 4 files changed, 25 insertions(+), 57 deletions(-)

diff --git a/arch/riscv/kernel/patch.c b/arch/riscv/kernel/patch.c
index 575e71d6c8ae..df51f5155673 100644
--- a/arch/riscv/kernel/patch.c
+++ b/arch/riscv/kernel/patch.c
@@ -12,6 +12,7 @@
 #include <asm/cacheflush.h>
 #include <asm/fixmap.h>
 #include <asm/ftrace.h>
+#include <asm/insn.h>
 #include <asm/patch.h>
 
 struct patch_insn {
@@ -118,7 +119,7 @@ static int patch_text_cb(void *data)
 
 	if (atomic_inc_return(&patch->cpu_count) == num_online_cpus()) {
 		for (i = 0; ret == 0 && i < patch->ninsns; i++) {
-			len = GET_INSN_LENGTH(patch->insns[i]);
+			len = INSN_LEN(patch->insns[i]);
 			ret = patch_text_nosync(patch->addr + i * len,
 						&patch->insns[i], len);
 		}
diff --git a/arch/riscv/kernel/probes/kprobes.c b/arch/riscv/kernel/probes/kprobes.c
index 2f08c14a933d..501c6ae4d803 100644
--- a/arch/riscv/kernel/probes/kprobes.c
+++ b/arch/riscv/kernel/probes/kprobes.c
@@ -12,6 +12,7 @@
 #include <asm/cacheflush.h>
 #include <asm/bug.h>
 #include <asm/patch.h>
+#include <asm/insn.h>
 
 #include "decode-insn.h"
 
@@ -24,7 +25,7 @@ post_kprobe_handler(struct kprobe *, struct kprobe_ctlblk *, struct pt_regs *);
 static void __kprobes arch_prepare_ss_slot(struct kprobe *p)
 {
 	u32 insn = __BUG_INSN_32;
-	unsigned long offset = GET_INSN_LENGTH(p->opcode);
+	unsigned long offset = INSN_LEN(p->opcode);
 
 	p->ainsn.api.restore = (unsigned long)p->addr + offset;
 
@@ -58,7 +59,7 @@ static bool __kprobes arch_check_kprobe(struct kprobe *p)
 		if (tmp == addr)
 			return true;
 
-		tmp += GET_INSN_LENGTH(*(u16 *)tmp);
+		tmp += INSN_LEN(*(u16 *)tmp);
 	}
 
 	return false;
@@ -76,7 +77,7 @@ int __kprobes arch_prepare_kprobe(struct kprobe *p)
 
 	/* copy instruction */
 	p->opcode = (kprobe_opcode_t)(*insn++);
-	if (GET_INSN_LENGTH(p->opcode) == 4)
+	if (INSN_LEN(p->opcode) == 4)
 		p->opcode |= (kprobe_opcode_t)(*insn) << 16;
 
 	/* decode instruction */
@@ -117,8 +118,8 @@ void *alloc_insn_page(void)
 /* install breakpoint in text */
 void __kprobes arch_arm_kprobe(struct kprobe *p)
 {
-	u32 insn = (p->opcode & __INSN_LENGTH_MASK) == __INSN_LENGTH_32 ?
-		   __BUG_INSN_32 : __BUG_INSN_16;
+	u32 insn = INSN_IS_C(p->opcode) ?
+		   __BUG_INSN_16 : __BUG_INSN_32;
 
 	patch_text(p->addr, &insn, 1);
 }
@@ -344,7 +345,7 @@ kprobe_single_step_handler(struct pt_regs *regs)
 	struct kprobe *cur = kprobe_running();
 
 	if (cur && (kcb->kprobe_status & (KPROBE_HIT_SS | KPROBE_REENTER)) &&
-	    ((unsigned long)&cur->ainsn.api.insn[0] + GET_INSN_LENGTH(cur->opcode) == addr)) {
+	    ((unsigned long)&cur->ainsn.api.insn[0] + INSN_LEN(cur->opcode) == addr)) {
 		kprobes_restore_local_irqflag(kcb, regs);
 		post_kprobe_handler(cur, kcb, regs);
 		return true;
diff --git a/arch/riscv/kernel/probes/simulate-insn.c b/arch/riscv/kernel/probes/simulate-insn.c
index 994edb4bd16a..f9671bb864a3 100644
--- a/arch/riscv/kernel/probes/simulate-insn.c
+++ b/arch/riscv/kernel/probes/simulate-insn.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0+
 
+#include <asm/insn.h>
 #include <asm/reg.h>
 #include <linux/bitops.h>
 #include <linux/kernel.h>
@@ -16,19 +17,16 @@ bool __kprobes simulate_jal(u32 opcode, unsigned long addr, struct pt_regs *regs
 	 *     1         10          1           8       5    JAL/J
 	 */
 	bool ret;
-	u32 imm;
-	u32 index = (opcode >> 7) & 0x1f;
+	s32 imm;
+	u32 index = riscv_insn_extract_rd(opcode);
 
 	ret = rv_insn_reg_set_val((unsigned long *)regs, index, addr + 4);
 	if (!ret)
 		return ret;
 
-	imm  = ((opcode >> 21) & 0x3ff) << 1;
-	imm |= ((opcode >> 20) & 0x1)   << 11;
-	imm |= ((opcode >> 12) & 0xff)  << 12;
-	imm |= ((opcode >> 31) & 0x1)   << 20;
+	imm = riscv_insn_extract_jtype_imm(opcode);
 
-	instruction_pointer_set(regs, addr + sign_extend32((imm), 20));
+	instruction_pointer_set(regs, addr + imm);
 
 	return ret;
 }
@@ -42,9 +40,9 @@ bool __kprobes simulate_jalr(u32 opcode, unsigned long addr, struct pt_regs *reg
 	 */
 	bool ret;
 	unsigned long base_addr;
-	u32 imm = (opcode >> 20) & 0xfff;
-	u32 rd_index = (opcode >> 7) & 0x1f;
-	u32 rs1_index = (opcode >> 15) & 0x1f;
+	s32 imm = riscv_insn_extract_itype_imm(opcode);
+	u32 rd_index = riscv_insn_extract_rd(opcode);
+	u32 rs1_index = riscv_insn_extract_rs1(opcode);
 
 	ret = rv_insn_reg_get_val((unsigned long *)regs, rs1_index, &base_addr);
 	if (!ret)
@@ -54,25 +52,11 @@ bool __kprobes simulate_jalr(u32 opcode, unsigned long addr, struct pt_regs *reg
 	if (!ret)
 		return ret;
 
-	instruction_pointer_set(regs, (base_addr + sign_extend32((imm), 11))&~1);
+	instruction_pointer_set(regs, (base_addr + imm) & ~1);
 
 	return ret;
 }
 
-#define auipc_rd_idx(opcode) \
-	((opcode >> 7) & 0x1f)
-
-#define auipc_imm(opcode) \
-	((((opcode) >> 12) & 0xfffff) << 12)
-
-#if __riscv_xlen == 64
-#define auipc_offset(opcode)	sign_extend64(auipc_imm(opcode), 31)
-#elif __riscv_xlen == 32
-#define auipc_offset(opcode)	auipc_imm(opcode)
-#else
-#error "Unexpected __riscv_xlen"
-#endif
-
 bool __kprobes simulate_auipc(u32 opcode, unsigned long addr, struct pt_regs *regs)
 {
 	/*
@@ -82,35 +66,16 @@ bool __kprobes simulate_auipc(u32 opcode, unsigned long addr, struct pt_regs *re
 	 *        20       5     7
 	 */
 
-	u32 rd_idx = auipc_rd_idx(opcode);
-	unsigned long rd_val = addr + auipc_offset(opcode);
+	u32 rd_idx = riscv_insn_extract_rd(opcode);
+	unsigned long rd_val = addr + riscv_insn_extract_utype_imm(opcode);
 
 	if (!rv_insn_reg_set_val((unsigned long *)regs, rd_idx, rd_val))
 		return false;
 
 	instruction_pointer_set(regs, addr + 4);
-
 	return true;
 }
 
-#define branch_rs1_idx(opcode) \
-	(((opcode) >> 15) & 0x1f)
-
-#define branch_rs2_idx(opcode) \
-	(((opcode) >> 20) & 0x1f)
-
-#define branch_funct3(opcode) \
-	(((opcode) >> 12) & 0x7)
-
-#define branch_imm(opcode) \
-	(((((opcode) >>  8) & 0xf ) <<  1) | \
-	 ((((opcode) >> 25) & 0x3f) <<  5) | \
-	 ((((opcode) >>  7) & 0x1 ) << 11) | \
-	 ((((opcode) >> 31) & 0x1 ) << 12))
-
-#define branch_offset(opcode) \
-	sign_extend32((branch_imm(opcode)), 12)
-
 bool __kprobes simulate_branch(u32 opcode, unsigned long addr, struct pt_regs *regs)
 {
 	/*
@@ -135,8 +100,8 @@ bool __kprobes simulate_branch(u32 opcode, unsigned long addr, struct pt_regs *r
 	    !rv_insn_reg_get_val((unsigned long *)regs, riscv_insn_extract_rs2(opcode), &rs2_val))
 		return false;
 
-	offset_tmp = branch_offset(opcode);
-	switch (branch_funct3(opcode)) {
+	offset_tmp = riscv_insn_extract_btype_imm(opcode);
+	switch (riscv_insn_extract_funct3(opcode)) {
 	case RVG_FUNCT3_BEQ:
 		offset = (rs1_val == rs2_val) ? offset_tmp : 4;
 		break;
diff --git a/arch/riscv/kernel/probes/uprobes.c b/arch/riscv/kernel/probes/uprobes.c
index 194f166b2cc4..f2511cbaf931 100644
--- a/arch/riscv/kernel/probes/uprobes.c
+++ b/arch/riscv/kernel/probes/uprobes.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-only
 
+#include <asm/insn.h>
 #include <linux/highmem.h>
 #include <linux/ptrace.h>
 #include <linux/uprobes.h>
@@ -29,7 +30,7 @@ int arch_uprobe_analyze_insn(struct arch_uprobe *auprobe, struct mm_struct *mm,
 
 	opcode = *(probe_opcode_t *)(&auprobe->insn[0]);
 
-	auprobe->insn_size = GET_INSN_LENGTH(opcode);
+	auprobe->insn_size = INSN_LEN(opcode);
 
 	switch (riscv_probe_decode_insn(&opcode, &auprobe->api)) {
 	case INSN_REJECTED:
@@ -166,7 +167,7 @@ void arch_uprobe_copy_ixol(struct page *page, unsigned long vaddr,
 
 	/* Add ebreak behind opcode to simulate singlestep */
 	if (vaddr) {
-		dst += GET_INSN_LENGTH(*(probe_opcode_t *)src);
+		dst += INSN_LEN(*(probe_opcode_t *)src);
 		*(uprobe_opcode_t *)dst = __BUG_INSN_32;
 	}
 

-- 
2.34.1

