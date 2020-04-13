Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (unknown [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3CC61A63AF
	for <lists+kvm@lfdr.de>; Mon, 13 Apr 2020 09:28:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729309AbgDMH2e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Apr 2020 03:28:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.18]:60740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727612AbgDMH2d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Apr 2020 03:28:33 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A0A6C008651;
        Mon, 13 Apr 2020 00:28:32 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id w11so4102571pga.12;
        Mon, 13 Apr 2020 00:28:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=S3hrCRfxrjHE0eXCcEPzbUk7x0CckK6gtsl1aNOJN6A=;
        b=L4mPHI1YNO11GHCIk/q49dUVSuiSd1ntFPAWEiFZ8cQK/c9UA/VR6BrT3X8EF614+S
         hbA+ZetQzHcW6kqmCNZL+vWe2swQePf50Hq5L6zOfGEEe7QzgXNIiePHBk3aXaIHq51/
         oGuiCZcQsDRdGN6Eno2le70i1U0kdY2JEZrx1zRvC0jupB0K1ZBCETo0Nibe5EeY/tRR
         xn24u92AsQLXWVqDM8h7WMtKWT4mFjANIyAEZzAFXSEVesHAAFHOcdr+Fxe6p/NrAxhD
         tWTAxSS0CkL9Hoc2rs8GmfXg8wno7IVU7f8TORZeexi/UVovbH8yFNrj1FL6Flv9ZG/1
         Vduw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=S3hrCRfxrjHE0eXCcEPzbUk7x0CckK6gtsl1aNOJN6A=;
        b=cT6Gs6yyhx/42jktSXa+ammnQ2ZOauhJe6TlHbotBFdWGczgZ84OIWwhncNK/i0uQD
         2W9D/X+JgNmw432kUVxPovATXHNn6hvvBTuOt1Oxaq/kBx7+7AhmELkuxjt8PExqkwF7
         6o3RSXh29HiSaJiSUESnKl92HGvpGOgm3G3eNEnhxlaWMYI64eavpI6DG9wvWRfTNIGV
         KpIn7w7MYkzmyblDH1kg6kkI7ByH5ncCvYoN+G837P4t4e+mTOxeRa58XuqLe3yxVlE3
         Q9IcoySdI3siK7BWOEM/YBO5vH8lkwI5y9KwjL6sXZkatBaLR11LwIE55xgYydBSp5Xx
         t22A==
X-Gm-Message-State: AGi0PubPlxYq4G7qU7C9OBxuqx/2b0DPSgXl6xtppirrohz6Gtw3gD0N
        jqoz778kTwB7E3MramZOO2I=
X-Google-Smtp-Source: APiQypLSUUUMvMBfYp4+yShQ1DEsf6XH5JRKGMUPdRFbylQv6kvnJmdBqMrN0RxDJqyxYpMzd4B2uw==
X-Received: by 2002:a62:5e86:: with SMTP id s128mr17390854pfb.157.1586762911480;
        Mon, 13 Apr 2020 00:28:31 -0700 (PDT)
Received: from software.domain.org (28.144.92.34.bc.googleusercontent.com. [34.92.144.28])
        by smtp.gmail.com with ESMTPSA id u8sm7241341pgl.19.2020.04.13.00.28.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 13 Apr 2020 00:28:31 -0700 (PDT)
From:   Huacai Chen <chenhc@lemote.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc:     kvm@vger.kernel.org, qemu-devel@nongnu.org,
        linux-mips@vger.kernel.org, Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhc@lemote.com>
Subject: [PATCH 12/15] KVM: MIPS: Add CPUCFG emulation for Loongson-3
Date:   Mon, 13 Apr 2020 15:30:21 +0800
Message-Id: <1586763024-12197-13-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1586763024-12197-1-git-send-email-chenhc@lemote.com>
References: <1586763024-12197-1-git-send-email-chenhc@lemote.com>
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
index 4022712..c291767 100644
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
index 20acd50..2d9ce8d 100644
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
index db9b0f5..0772565 100644
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

