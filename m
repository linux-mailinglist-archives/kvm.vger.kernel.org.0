Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D90B1C2B3C
	for <lists+kvm@lfdr.de>; Sun,  3 May 2020 12:15:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728091AbgECKPU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 3 May 2020 06:15:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727892AbgECKPU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 3 May 2020 06:15:20 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 372B5C061A0C;
        Sun,  3 May 2020 03:15:20 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id p25so4042928pfn.11;
        Sun, 03 May 2020 03:15:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=irVmhvtEPr1kCt/3TMdgPsfS/t5ii77gdB+p7HRY6Cw=;
        b=TahyT0RJZ9eooeUVSavNED0naTITC852lMmSIMuXaULkAnV1Z2vFhqOvKRIftcYbwX
         q/W5mYIwu8VK4kyNhFd1i86ydce0kYCKKDR5uM6kwRITzVketp7yxcAiK6vYpI0Sxm/3
         HubRharQvgHDyEnHwTehUVf5xrKMDoItngANVD0hJkiqNK7r6oS2op0PvzMioZzpiEAQ
         AFGXxSex+JvKhL1AdnwPneKVPmcWVSBzkqTbgGX4GZhdS09JQ13kjjYHnqPjaO3Ado9X
         D1fUC36EM7A6yniZKMGHRXhHljYhfaXxXFFHjrrwcmYyM/p56s0ZaSg/RKiLay1D6pyS
         z+/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=irVmhvtEPr1kCt/3TMdgPsfS/t5ii77gdB+p7HRY6Cw=;
        b=gO1ShuGkd1WyDQv5YitTrPLvFfwN4me1zHSO94QValb2bGAvCBEXP6bPwDOUVMK3hu
         95HZefsi5a3O7u0pwzWfI2KQfirEDOhYRXB21cBx5+qadoCkJMIpB4tJ9wLqcJd0gXlP
         /Gykqn97q9ajTJeHuEH7AIKQOD68MOTD7cvlK6+TNM23haBjAlIhFxMruHxrx8oyHpOe
         FyZOFcBpFDZtfxXgHf8IPa1rnStZD5mpH/xn+3j924U3GXqvO+W6akjdIG9N5RbQTV2N
         cjsmRctjQDKireQvkHhcE+X8b7rnY1l41Uhi9ySs3pzIxixN/DQXTAqs3eii4OAbgLPw
         xZFQ==
X-Gm-Message-State: AGi0Pub8sNeot8OjhVC4dU6z8D8Dj9GhMZs/ybyE3+EtfyqAFVRoGave
        kk3CFtQLmhAPTwfO2u4+Irs=
X-Google-Smtp-Source: APiQypJS5n7Ty/4gS/PPY7UiwzoovPQDWcs5RMjKbJr67aHDFHzbfGgOP7rc5mYvwKg7F3M2fwzXiA==
X-Received: by 2002:aa7:9d90:: with SMTP id f16mr12993751pfq.48.1588500919442;
        Sun, 03 May 2020 03:15:19 -0700 (PDT)
Received: from software.domain.org (28.144.92.34.bc.googleusercontent.com. [34.92.144.28])
        by smtp.gmail.com with ESMTPSA id r26sm6329902pfq.75.2020.05.03.03.15.16
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 03 May 2020 03:15:18 -0700 (PDT)
From:   Huacai Chen <chenhc@lemote.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc:     kvm@vger.kernel.org, qemu-devel@nongnu.org,
        linux-mips@vger.kernel.org,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhc@lemote.com>
Subject: [PATCH V3 11/14] KVM: MIPS: Add CPUCFG emulation for Loongson-3
Date:   Sun,  3 May 2020 18:06:04 +0800
Message-Id: <1588500367-1056-12-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1588500367-1056-1-git-send-email-chenhc@lemote.com>
References: <1588500367-1056-1-git-send-email-chenhc@lemote.com>
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

Signed-off-by: Huacai Chen <chenhc@lemote.com>
Co-developed-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
---
 arch/mips/include/asm/kvm_host.h  |  3 ++
 arch/mips/include/uapi/asm/inst.h | 11 ++++++
 arch/mips/kvm/mips.c              |  3 ++
 arch/mips/kvm/vz.c                | 75 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 92 insertions(+)

diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm/kvm_host.h
index f165902..3fd2f1c 100644
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
index 98f97c8..43d1faa 100644
--- a/arch/mips/include/uapi/asm/inst.h
+++ b/arch/mips/include/uapi/asm/inst.h
@@ -1012,6 +1012,16 @@ struct loongson3_lsdc2_format {	/* Loongson-3 overridden ldc2/sdc2 Load/Store fo
 	;))))))
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
@@ -1114,6 +1124,7 @@ union mips_instruction {
 	struct mm16_r5_format mm16_r5_format;
 	struct loongson3_lswc2_format loongson3_lswc2_format;
 	struct loongson3_lsdc2_format loongson3_lsdc2_format;
+	struct loongson3_lscsr_format loongson3_lscsr_format;
 };
 
 union mips16e_instruction {
diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
index ed989ef..9362769 100644
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -68,6 +68,9 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
 	{ "vz_ghfc",	  VCPU_STAT(vz_ghfc_exits),	 KVM_STAT_VCPU },
 	{ "vz_gpa",	  VCPU_STAT(vz_gpa_exits),	 KVM_STAT_VCPU },
 	{ "vz_resvd",	  VCPU_STAT(vz_resvd_exits),	 KVM_STAT_VCPU },
+#ifdef CONFIG_CPU_LOONGSON64
+	{ "vz_cpucfg",	  VCPU_STAT(vz_cpucfg_exits),	 KVM_STAT_VCPU },
+#endif
 #endif
 	{ "halt_successful_poll", VCPU_STAT(halt_successful_poll), KVM_STAT_VCPU },
 	{ "halt_attempted_poll", VCPU_STAT(halt_attempted_poll), KVM_STAT_VCPU },
diff --git a/arch/mips/kvm/vz.c b/arch/mips/kvm/vz.c
index 63d5b35..e5c751b 100644
--- a/arch/mips/kvm/vz.c
+++ b/arch/mips/kvm/vz.c
@@ -29,6 +29,7 @@
 #include <linux/kvm_host.h>
 
 #include "interrupt.h"
+#include "loongson_regs.h"
 
 #include "trace.h"
 
@@ -1092,6 +1093,75 @@ static enum emulation_result kvm_vz_gpsi_cache(union mips_instruction inst,
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
+			hostcfg &= LOONGSON_CFG3_LCAMP;
+			vcpu->arch.gprs[rd] = hostcfg;
+			break;
+		default:
+			/* Don't export any other advanced features to guest */
+			vcpu->arch.gprs[rd] = 0;
+			break;
+		}
+
+		break;
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
@@ -1121,6 +1191,11 @@ static enum emulation_result kvm_trap_vz_handle_gpsi(u32 cause, u32 *opc,
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

