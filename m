Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66CCF1B72DC
	for <lists+kvm@lfdr.de>; Fri, 24 Apr 2020 13:14:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726813AbgDXLOn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Apr 2020 07:14:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726707AbgDXLOn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Apr 2020 07:14:43 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 402FBC09B045;
        Fri, 24 Apr 2020 04:14:43 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id ay1so3632941plb.0;
        Fri, 24 Apr 2020 04:14:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=vLDwqLMkMRXLNDnJEq3UM+dnmKiLAIo4o9nCN4c5EOc=;
        b=RKE89YemHcnujQ8gBZOFrgOgWFn0gCYoWmQKqujWvIydCGD+6ss5PTwqLOGHn9mdVh
         XxjjY7jv/t44XoVT3es3LY44e8cN2OwOvO/1RA9afPqurS6zawCKTGSf6KrY5hrR8aZo
         9nJHxdyqJlIUppFLPQM2bs5iarHRKQ+N6t3SvSEb5wNZlAll04vWtKu1kNw0odvw5fRZ
         14Opkax/4W0fXbpLAJHiE1HbqO5uKZNgw1SD+usJMmbiH54KOFQdEemUWW2f9XO0uDDF
         /EH97xUtQghG1BldEJrrP6UJXM/e3A9vskSra++aHDuV3fRI2aEJfE7zVxn/+MpNFy15
         YTlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=vLDwqLMkMRXLNDnJEq3UM+dnmKiLAIo4o9nCN4c5EOc=;
        b=eGpHh7IVZLuV+UO9Mt4dUgvWYWxiwpL4oSlzc76aiFqKWCOFjYHhr8sT3FgJK7rEji
         BuBmzjZXB9dsFGQayJBxn/kfEPN6E2G7GrtAzHBmZQGOYJ19kaVnnx6u8+s71hJY9wG9
         m9kwUFiTuUGinJnjMNJFrQvoAWT1qL7GiJgcP6MLKcjv67/oNU+pQuHQc1ojksvGOPO3
         Pav4N2an+lYj4A3x8kAy9Qh4ibQ0U+wKiMoxzQaJGaAc/65YYhdBgQvvsRbNZyomkO6c
         kqkobCM7c6me4R2ll8w2aX5srDn6/GxPdiXuks30ieNbCXw8oO5plgaUbVHHn6nc1qTD
         mQRg==
X-Gm-Message-State: AGi0PuZrdRyL0Oc+0x6uZ/DhQqMb+MsdffXSK6I+qixQq+1yRyIUVoU2
        yC4Pq/seNurqk1FGhCZkaPg=
X-Google-Smtp-Source: APiQypISdmq9e2Pec+2PKxWCwerij25WzbDsoV3K8UTE0K7stdDyGkLO7nZ6DmVkcAc80kxQAlU5QA==
X-Received: by 2002:a17:90a:2ac2:: with SMTP id i2mr5590760pjg.91.1587726882746;
        Fri, 24 Apr 2020 04:14:42 -0700 (PDT)
Received: from software.domain.org (28.144.92.34.bc.googleusercontent.com. [34.92.144.28])
        by smtp.gmail.com with ESMTPSA id y10sm5470110pfb.53.2020.04.24.04.14.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 Apr 2020 04:14:41 -0700 (PDT)
From:   Huacai Chen <chenhc@lemote.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc:     kvm@vger.kernel.org, linux-mips@vger.kernel.org,
        Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhc@lemote.com>
Subject: [PATCH V2 11/14] KVM: MIPS: Add CPUCFG emulation for Loongson-3
Date:   Fri, 24 Apr 2020 19:15:30 +0800
Message-Id: <1587726933-31757-12-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1587726933-31757-1-git-send-email-chenhc@lemote.com>
References: <1587726933-31757-1-git-send-email-chenhc@lemote.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Loongson-3 overrides lwc2 instructions to implement CPUCFG and CSR
read/write functions. These instructions all cause guest exit so CSR
doesn't benifit KVM guest (and there are always legacy methods to
provide the same functions as CSR). So, we only emulate CPUCFG and let
it return 0 (which means the virtual CPU doesn't have any advanced
features, including CSR) in KVM.

Signed-off-by: Huacai Chen <chenhc@lemote.com>
Co-developed-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
---
 arch/mips/include/asm/kvm_host.h  |  3 +++
 arch/mips/include/uapi/asm/inst.h | 11 +++++++++
 arch/mips/kvm/mips.c              |  3 +++
 arch/mips/kvm/vz.c                | 50 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 67 insertions(+)

diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm/kvm_host.h
index c98eb42..fa5fc86 100644
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
index 63d5b35..cea1ce4 100644
--- a/arch/mips/kvm/vz.c
+++ b/arch/mips/kvm/vz.c
@@ -29,6 +29,7 @@
 #include <linux/kvm_host.h>
 
 #include "interrupt.h"
+#include "loongson_regs.h"
 
 #include "trace.h"
 
@@ -1092,6 +1093,50 @@ static enum emulation_result kvm_vz_gpsi_cache(union mips_instruction inst,
 	return EMULATE_FAIL;
 }
 
+#ifdef CONFIG_CPU_LOONGSON64
+static enum emulation_result kvm_vz_gpsi_lwc2(union mips_instruction inst,
+					      u32 *opc, u32 cause,
+					      struct kvm_run *run,
+					      struct kvm_vcpu *vcpu)
+{
+	unsigned int rs, rd;
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
+		case 0x8:  /* Read CPUCFG */
+			++vcpu->stat.vz_cpucfg_exits;
+			vcpu->arch.gprs[rd] = 0; /* Don't export any advanced features to guest */
+			break;
+		default:
+			kvm_err("lwc2 emulate not impl %d rs %lx @%lx\n",
+					inst.loongson3_lscsr_format.fr, vcpu->arch.gprs[rs], curr_pc);
+			er = EMULATE_FAIL;
+			break;
+	}
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
@@ -1121,6 +1166,11 @@ static enum emulation_result kvm_trap_vz_handle_gpsi(u32 cause, u32 *opc,
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

