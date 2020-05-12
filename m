Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4AA01CF29F
	for <lists+kvm@lfdr.de>; Tue, 12 May 2020 12:35:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729505AbgELKfZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 May 2020 06:35:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729436AbgELKfZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 12 May 2020 06:35:25 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C1D2C061A0C;
        Tue, 12 May 2020 03:35:25 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id x2so6167497pfx.7;
        Tue, 12 May 2020 03:35:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=HjD3k8mpcSLCDKuz+YE4mXs+5+Bcc7Oe/yzZDiJx1vM=;
        b=iNN1uKHoW55cr2mxmQq3t0YDkDklBOJJ47STuWIbD9V3hEqpX5gof+Cyep+WMeaj42
         X5q2q+i2SAn6N7Qe7fHYn88p3qgzCck1Va8450llrP4a56j6engwp2TrK3oEaxEkpf9/
         UU7+AF/l085atkUAdo5pVOfAC+Q+FTSHpKidC6fWGlOuT1VO/bdR9AbGXDsqnZ2txwrp
         ej5KpAgsfjtqh5ZLYPk3TZb9rybQsFvR/WRSeDvf/ghWgm9BONLz2UJacsUXEVk5lei6
         jKgu8ZRB2fRD5W7WLxQT1yKKmW7BGka5XOQcx/TwdfudU6nsl/6OTnbRoc1C4Lvds4in
         9QbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=HjD3k8mpcSLCDKuz+YE4mXs+5+Bcc7Oe/yzZDiJx1vM=;
        b=f0QNJioOib6mo+xqn/UZPy8ARY9DPE2CjzZWil0OiT4rcUaLTvLrbn/lrALTcw+ga+
         Rjg9ZLN2/FvYIpIJVsJnGecyX9+BbW3fiN+MrZDqqVMhKmQnfkGUTmmblz+sPsUUcMfr
         NVxVlJt/v7e2x1vcVqm73huMqn4yv07FJKm4sNSm6fg3j4aQkt45AjYlPFAXNnBQmvrT
         6QYNu2O469r3059oOdhrbBUCb4ZqgXpYGDxbP8FKtq4Xo3O5O/5Na9UxbdKynR3WHTKC
         dYa7yglOUX61Cy2IK6ugLnqMhYhdJZAOz/Cp4GzBXCO6aY8IQ9S7sUq1LuJxG9QmDZ1w
         D6vg==
X-Gm-Message-State: AGi0PuZRNT2ohqVeytWLWeZPknPNLsl7a3HB2XnMfNGt4aikY8hQiKd7
        YhCNdoF/euWtLWZmMpe3lhI=
X-Google-Smtp-Source: APiQypL5TrZeCgDTGMhS4zVDLKRzr6iS20Nlcix01PoessCY0Gokt86IimC6MKqifrhSWgsoY0DQZg==
X-Received: by 2002:aa7:8dd2:: with SMTP id j18mr19950308pfr.74.1589279724495;
        Tue, 12 May 2020 03:35:24 -0700 (PDT)
Received: from software.domain.org (28.144.92.34.bc.googleusercontent.com. [34.92.144.28])
        by smtp.gmail.com with ESMTPSA id q11sm11617094pfl.97.2020.05.12.03.35.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 12 May 2020 03:35:23 -0700 (PDT)
From:   Huacai Chen <chenhc@lemote.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
Cc:     kvm@vger.kernel.org, linux-mips@vger.kernel.org,
        Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhc@lemote.com>
Subject: [PATCH V4 11/14] KVM: MIPS: Add CPUCFG emulation for Loongson-3
Date:   Tue, 12 May 2020 18:31:17 +0800
Message-Id: <1589279480-27722-12-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1589279480-27722-1-git-send-email-chenhc@lemote.com>
References: <1589279480-27722-1-git-send-email-chenhc@lemote.com>
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

diff --git a/arch/mips/kvm/vz.c b/arch/mips/kvm/vz.c
index ac46840..dc753d0 100644
--- a/arch/mips/kvm/vz.c
+++ b/arch/mips/kvm/vz.c
@@ -1169,6 +1169,9 @@ static enum emulation_result kvm_vz_gpsi_lwc2(union mips_instruction inst,
 		hostcfg = read_cpucfg(vcpu->arch.gprs[rs]);
 
 		switch (vcpu->arch.gprs[rs]) {
+		case LOONGSON_CFG0:
+			vcpu->arch.gprs[rd] = 0x14c000;
+			break;
 		case LOONGSON_CFG1:
 			hostcfg &= (LOONGSON_CFG1_FP | LOONGSON_CFG1_MMI |
 				    LOONGSON_CFG1_MSA1 | LOONGSON_CFG1_MSA2 |
@@ -1181,7 +1184,6 @@ static enum emulation_result kvm_vz_gpsi_lwc2(union mips_instruction inst,
 			vcpu->arch.gprs[rd] = hostcfg;
 			break;
 		case LOONGSON_CFG3:
-			hostcfg &= LOONGSON_CFG3_LCAMP;
 			vcpu->arch.gprs[rd] = hostcfg;
 			break;
 		default:
