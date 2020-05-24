Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B59941DFE98
	for <lists+kvm@lfdr.de>; Sun, 24 May 2020 13:24:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728069AbgEXLYd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 24 May 2020 07:24:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725873AbgEXLYd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 24 May 2020 07:24:33 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3EAEC061A0E;
        Sun, 24 May 2020 04:24:32 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id b190so7551873pfg.6;
        Sun, 24 May 2020 04:24:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=iuQxxqmRKyOom6IabbOhQe0aLzhwSs4qPfpuGUNi33w=;
        b=ZHD+X+QAM7Gp6JHRSmK5HJL/y53+NEO1KQqXUFDwiXFexmpqG77vqc6S/y3cD7AIUT
         t0YBjzzG4UbLstnj64ynujSeVAC/o+WTSZoxQ5bJ6LSMlfqY18NmXYhQilGYPXkflw6W
         z6SxgwQPFkncCuk47S1KzNLAxN7io5fqe77ypuXPk/z1TffTJOnNYaXgnGTMuc2Px/CC
         q11a6NH8rxttCTzvbORiuqEkkHrgx0EhYMprFuvF6LVy4vGgJmLZ8fHUEEL31QGrK1ZK
         BxZWLBvXZ2uPChLmTNXgoTgEcjpyyxJJPe6IYJgGLo5pJhBlcU4NzUSjTV8Hybcy+GXT
         hBjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=iuQxxqmRKyOom6IabbOhQe0aLzhwSs4qPfpuGUNi33w=;
        b=nV4jjSAyDDvDBk7fwfzfanj2D8kbLp3a2qIAOvrvW7aSJ0MrXDyJAZSKy3N91/3BNo
         cx8r7cD+WhRdkcx2AIkaz5gzU3jhrgKXxIqEamoRca9xMELiAzWyrl2srJCCVA6f+SWM
         10DO14TvqxuqJr68luSmY9aIozeidMhA2YSixy60zQ1S0ikWuV49QhIvV1D0HLSw2yZz
         FYgTb5qUs84/e6GTr+W2Q/BQUE6beggNm9Pc5v3UfmeU5mZYxG0Q/r8LU0z0kJ69Rw1j
         3jTsD9Ksww52TXwF9AIfiAZfMKwCWsVHEsTydqvIdn1kItDvF7eGQBzY4+qUFN9tBnmf
         ubIA==
X-Gm-Message-State: AOAM5308vMdQtAqG4zz03klAl9sd5yGXRteIsTDPb//Ed6ezgYsn1gOX
        APWZsqAyPFHnQDIRLPR05UI=
X-Google-Smtp-Source: ABdhPJz4F8MiF/TTQQrxEyfIJ2eYB6CjEDLdVxeW48RShPK8bN0tY3Qjf9LRmXT50dyWgqe3SqjJkw==
X-Received: by 2002:a63:3384:: with SMTP id z126mr18241574pgz.7.1590319472582;
        Sun, 24 May 2020 04:24:32 -0700 (PDT)
Received: from software.domain.org (28.144.92.34.bc.googleusercontent.com. [34.92.144.28])
        by smtp.gmail.com with ESMTPSA id 192sm1971719pfu.202.2020.05.24.04.24.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 24 May 2020 04:24:32 -0700 (PDT)
From:   Huacai Chen <chenhc@lemote.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
Cc:     kvm@vger.kernel.org, linux-mips@vger.kernel.org,
        Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhc@lemote.com>
Subject: [PATCH V8 11/15] KVM: MIPS: Add CPUCFG emulation for Loongson-3
Date:   Sun, 24 May 2020 19:13:35 +0800
Message-Id: <1590318819-24520-12-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1590318819-24520-1-git-send-email-chenhc@lemote.com>
References: <1590318819-24520-1-git-send-email-chenhc@lemote.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Loongson-3 overrides lwc2 instructions to implement CPUCFG and CSR
read/write functions. These instructions all cause guest exit so CSR
doesn't benifit KVM guest (and there are always legacy methods to
provide the same functions as CSR). So, we only emulate CPUCFG and let
it return a reduced feature list (which means the virtual CPU doesn't
have any other advanced features, including CSR) in KVM.

Reviewed-by: Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
Signed-off-by: Huacai Chen <chenhc@lemote.com>
Co-developed-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
---
 arch/mips/include/asm/kvm_host.h  |  3 ++
 arch/mips/include/uapi/asm/inst.h | 11 ++++++
 arch/mips/kvm/mips.c              |  3 ++
 arch/mips/kvm/vz.c                | 77 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 94 insertions(+)

diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm/kvm_host.h
index c4e6b1e..9f3bfc8 100644
--- a/arch/mips/include/asm/kvm_host.h
+++ b/arch/mips/include/asm/kvm_host.h
@@ -173,6 +173,9 @@ struct kvm_vcpu_stat {
 	u64 vz_ghfc_exits;
 	u64 vz_gpa_exits;
 	u64 vz_resvd_exits;
+#ifdef CONFIG_CPU_LOONGSON64
+	u64 vz_cpucfg_exits;
+#endif
 #endif
 	u64 halt_successful_poll;
 	u64 halt_attempted_poll;
diff --git a/arch/mips/include/uapi/asm/inst.h b/arch/mips/include/uapi/asm/inst.h
index eaa3a80..9b70391 100644
--- a/arch/mips/include/uapi/asm/inst.h
+++ b/arch/mips/include/uapi/asm/inst.h
@@ -988,6 +988,16 @@ struct mm16_r5_format {		/* Load/store from stack pointer format */
 	;))))
 };
 
+struct loongson3_lscsr_format {	/* Loongson-3 CPUCFG&CSR read/write format */
+	__BITFIELD_FIELD(unsigned int opcode : 6,
+	__BITFIELD_FIELD(unsigned int rs : 5,
+	__BITFIELD_FIELD(unsigned int fr : 5,
+	__BITFIELD_FIELD(unsigned int rd : 5,
+	__BITFIELD_FIELD(unsigned int fd : 5,
+	__BITFIELD_FIELD(unsigned int func : 6,
+	;))))))
+};
+
 /*
  * MIPS16e instruction formats (16-bit length)
  */
@@ -1088,6 +1098,7 @@ union mips_instruction {
 	struct mm16_rb_format mm16_rb_format;
 	struct mm16_r3_format mm16_r3_format;
 	struct mm16_r5_format mm16_r5_format;
+	struct loongson3_lscsr_format loongson3_lscsr_format;
 };
 
 union mips16e_instruction {
diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
index 140cafa..36eb6b6 100644
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -67,6 +67,9 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
 	VCPU_STAT("vz_ghfc", vz_ghfc_exits),
 	VCPU_STAT("vz_gpa", vz_gpa_exits),
 	VCPU_STAT("vz_resvd", vz_resvd_exits),
+#ifdef CONFIG_CPU_LOONGSON64
+	VCPU_STAT("vz_cpucfg", vz_cpucfg_exits),
+#endif
 #endif
 	VCPU_STAT("halt_successful_poll", halt_successful_poll),
 	VCPU_STAT("halt_attempted_poll", halt_attempted_poll),
diff --git a/arch/mips/kvm/vz.c b/arch/mips/kvm/vz.c
index 63d5b35..72a62f1 100644
--- a/arch/mips/kvm/vz.c
+++ b/arch/mips/kvm/vz.c
@@ -29,6 +29,7 @@
 #include <linux/kvm_host.h>
 
 #include "interrupt.h"
+#include "loongson_regs.h"
 
 #include "trace.h"
 
@@ -1092,6 +1093,77 @@ static enum emulation_result kvm_vz_gpsi_cache(union mips_instruction inst,
 	return EMULATE_FAIL;
 }
 
+#ifdef CONFIG_CPU_LOONGSON64
+static enum emulation_result kvm_vz_gpsi_lwc2(union mips_instruction inst,
+					      u32 *opc, u32 cause,
+					      struct kvm_run *run,
+					      struct kvm_vcpu *vcpu)
+{
+	unsigned int rs, rd;
+	unsigned int hostcfg;
+	unsigned long curr_pc;
+	enum emulation_result er = EMULATE_DONE;
+
+	/*
+	 * Update PC and hold onto current PC in case there is
+	 * an error and we want to rollback the PC
+	 */
+	curr_pc = vcpu->arch.pc;
+	er = update_pc(vcpu, cause);
+	if (er == EMULATE_FAIL)
+		return er;
+
+	rs = inst.loongson3_lscsr_format.rs;
+	rd = inst.loongson3_lscsr_format.rd;
+	switch (inst.loongson3_lscsr_format.fr) {
+	case 0x8:  /* Read CPUCFG */
+		++vcpu->stat.vz_cpucfg_exits;
+		hostcfg = read_cpucfg(vcpu->arch.gprs[rs]);
+
+		switch (vcpu->arch.gprs[rs]) {
+		case LOONGSON_CFG0:
+			vcpu->arch.gprs[rd] = 0x14c000;
+			break;
+		case LOONGSON_CFG1:
+			hostcfg &= (LOONGSON_CFG1_FP | LOONGSON_CFG1_MMI |
+				    LOONGSON_CFG1_MSA1 | LOONGSON_CFG1_MSA2 |
+				    LOONGSON_CFG1_SFBP);
+			vcpu->arch.gprs[rd] = hostcfg;
+			break;
+		case LOONGSON_CFG2:
+			hostcfg &= (LOONGSON_CFG2_LEXT1 | LOONGSON_CFG2_LEXT2 |
+				    LOONGSON_CFG2_LEXT3 | LOONGSON_CFG2_LSPW);
+			vcpu->arch.gprs[rd] = hostcfg;
+			break;
+		case LOONGSON_CFG3:
+			vcpu->arch.gprs[rd] = hostcfg;
+			break;
+		default:
+			/* Don't export any other advanced features to guest */
+			vcpu->arch.gprs[rd] = 0;
+			break;
+		}
+		break;
+
+	default:
+		kvm_err("lwc2 emulate not impl %d rs %lx @%lx\n",
+			inst.loongson3_lscsr_format.fr, vcpu->arch.gprs[rs], curr_pc);
+		er = EMULATE_FAIL;
+		break;
+	}
+
+	/* Rollback PC only if emulation was unsuccessful */
+	if (er == EMULATE_FAIL) {
+		kvm_err("[%#lx]%s: unsupported lwc2 instruction 0x%08x 0x%08x\n",
+			curr_pc, __func__, inst.word, inst.loongson3_lscsr_format.fr);
+
+		vcpu->arch.pc = curr_pc;
+	}
+
+	return er;
+}
+#endif
+
 static enum emulation_result kvm_trap_vz_handle_gpsi(u32 cause, u32 *opc,
 						     struct kvm_vcpu *vcpu)
 {
@@ -1121,6 +1193,11 @@ static enum emulation_result kvm_trap_vz_handle_gpsi(u32 cause, u32 *opc,
 		er = kvm_vz_gpsi_cache(inst, opc, cause, run, vcpu);
 		break;
 #endif
+#ifdef CONFIG_CPU_LOONGSON64
+	case lwc2_op:
+		er = kvm_vz_gpsi_lwc2(inst, opc, cause, run, vcpu);
+		break;
+#endif
 	case spec3_op:
 		switch (inst.spec3_format.func) {
 #ifdef CONFIG_CPU_MIPSR6
-- 
2.7.0

