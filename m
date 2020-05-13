Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9675B1D0B29
	for <lists+kvm@lfdr.de>; Wed, 13 May 2020 10:48:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732376AbgEMIsF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 May 2020 04:48:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732350AbgEMIsE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 May 2020 04:48:04 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C08C5C061A0C;
        Wed, 13 May 2020 01:48:04 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id t9so10827987pjw.0;
        Wed, 13 May 2020 01:48:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=UQMV7Y8RuDIauhbxX+xFMhZdiz+O0kx4lERg1mollAU=;
        b=ZgZ/hAYj7SnN9DeLsajlL+SbUUWJQR4xEqyj1BTQ2EoTf63EhYvXbUR0FfDBUAi9qJ
         fMWUIyMBlL/kyhDUZ1QSfrcuSm5ZsR6N8DkXY6THQJvAQ0MYWXVhDZwPJIwa5GEeWqDW
         U8f/nbHFCgZGgKmleegskxg+YcbIdIxaQS49kF9eMj19edSWuujjxmXntX/OJFFNZ8iQ
         pDk360zSM447Ai6ObrILF6//61H8+/WUxfOhaGdRPpWgvrdQ+Q2+uCFdsA1sH1RiMEvP
         //O3T95x+04BDX8Cha37+yVlaiepnFXqGkNVCRePgaH9gW4EZ0180OGDOsyfNIblhQvt
         LOtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=UQMV7Y8RuDIauhbxX+xFMhZdiz+O0kx4lERg1mollAU=;
        b=dtvnkgKkHkwgcx44OiAyI15c6rSYvKFoEpxW//6bnlS/OCNbfI7v13RIbXabQZvvxb
         EOyERUNzABXpsHGbLcxDeay2nmkNMyn567yn8gNwOWwlKz8axyu/IAN67xXeeJeTnF0+
         kCrzH2daCwBSRpOnIGa9Hq9wya55NsjG1ieBNiwcYV6IlYy/tq3/JpTJx+GO8FuYQHt/
         pMC0r8910oedlOi790BU4LM31kZ0eJGbi3/9OBBF2vgVaWykY9NVCqcd+GEf11ECMkDb
         xpLkBs0JOuTCfFaSQaf83jJKEAJ0SjeyACluX/MEX59RW+P/2XWDcMTwiZDmzqiPeM9l
         eSlg==
X-Gm-Message-State: AGi0PuaHOoF1IZP73tsO5VGMxO0y+9E5y+VROg63ELjfflyc4ha+2MtM
        TW5+Xx7/XAEg1oCB/BFayo0=
X-Google-Smtp-Source: APiQypI3tnyICG5+jY/p/IbtoysQFlTk3i33H7OcetPs/MmWBDOuFk9gWDDOcWNqdN8ry45XZz5NVw==
X-Received: by 2002:a17:90b:b08:: with SMTP id bf8mr33489206pjb.158.1589359684219;
        Wed, 13 May 2020 01:48:04 -0700 (PDT)
Received: from software.domain.org (28.144.92.34.bc.googleusercontent.com. [34.92.144.28])
        by smtp.gmail.com with ESMTPSA id o21sm14645570pjr.37.2020.05.13.01.48.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 13 May 2020 01:48:03 -0700 (PDT)
From:   Huacai Chen <chenhc@lemote.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
Cc:     kvm@vger.kernel.org, linux-mips@vger.kernel.org,
        Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhc@lemote.com>
Subject: [PATCH V5 13/15] KVM: MIPS: Add more MMIO load/store instructions emulation
Date:   Wed, 13 May 2020 16:42:44 +0800
Message-Id: <1589359366-1669-14-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1589359366-1669-1-git-send-email-chenhc@lemote.com>
References: <1589359366-1669-1-git-send-email-chenhc@lemote.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch add more MMIO load/store instructions emulation, which can
be observed in QXL and some other device drivers:

1, LWL, LWR, LDW, LDR, SWL, SWR, SDL and SDR for all MIPS;
2, GSLBX, GSLHX, GSLWX, GSLDX, GSSBX, GSSHX, GSSWX and GSSDX for
   Loongson-3.

Reviewed-by: Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
Signed-off-by: Huacai Chen <chenhc@lemote.com>
Co-developed-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
---
 arch/mips/kvm/emulate.c | 480 +++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 470 insertions(+), 10 deletions(-)

diff --git a/arch/mips/kvm/emulate.c b/arch/mips/kvm/emulate.c
index dfc92e5..07b123f 100644
--- a/arch/mips/kvm/emulate.c
+++ b/arch/mips/kvm/emulate.c
@@ -1604,6 +1604,7 @@ enum emulation_result kvm_mips_emulate_store(union mips_instruction inst,
 	enum emulation_result er;
 	u32 rt;
 	void *data = run->mmio.data;
+	unsigned int imme;
 	unsigned long curr_pc;
 
 	/*
@@ -1661,6 +1662,211 @@ enum emulation_result kvm_mips_emulate_store(union mips_instruction inst,
 			  vcpu->arch.gprs[rt], *(u8 *)data);
 		break;
 
+	case swl_op:
+		run->mmio.phys_addr = kvm_mips_callbacks->gva_to_gpa(
+					vcpu->arch.host_cp0_badvaddr) & (~0x3);
+		run->mmio.len = 4;
+		imme = vcpu->arch.host_cp0_badvaddr & 0x3;
+		switch (imme) {
+		case 0:
+			*(u32 *)data = ((*(u32 *)data) & 0xffffff00) |
+					(vcpu->arch.gprs[rt] >> 24);
+			break;
+		case 1:
+			*(u32 *)data = ((*(u32 *)data) & 0xffff0000) |
+					(vcpu->arch.gprs[rt] >> 16);
+			break;
+		case 2:
+			*(u32 *)data = ((*(u32 *)data) & 0xff000000) |
+					(vcpu->arch.gprs[rt] >> 8);
+			break;
+		case 3:
+			*(u32 *)data = vcpu->arch.gprs[rt];
+			break;
+		default:
+			break;
+		}
+
+		kvm_debug("[%#lx] OP_SWL: eaddr: %#lx, gpr: %#lx, data: %#x\n",
+			  vcpu->arch.pc, vcpu->arch.host_cp0_badvaddr,
+			  vcpu->arch.gprs[rt], *(u32 *)data);
+		break;
+
+	case swr_op:
+		run->mmio.phys_addr = kvm_mips_callbacks->gva_to_gpa(
+					vcpu->arch.host_cp0_badvaddr) & (~0x3);
+		run->mmio.len = 4;
+		imme = vcpu->arch.host_cp0_badvaddr & 0x3;
+		switch (imme) {
+		case 0:
+			*(u32 *)data = vcpu->arch.gprs[rt];
+			break;
+		case 1:
+			*(u32 *)data = ((*(u32 *)data) & 0xff) |
+					(vcpu->arch.gprs[rt] << 8);
+			break;
+		case 2:
+			*(u32 *)data = ((*(u32 *)data) & 0xffff) |
+					(vcpu->arch.gprs[rt] << 16);
+			break;
+		case 3:
+			*(u32 *)data = ((*(u32 *)data) & 0xffffff) |
+					(vcpu->arch.gprs[rt] << 24);
+			break;
+		default:
+			break;
+		}
+
+		kvm_debug("[%#lx] OP_SWR: eaddr: %#lx, gpr: %#lx, data: %#x\n",
+			  vcpu->arch.pc, vcpu->arch.host_cp0_badvaddr,
+			  vcpu->arch.gprs[rt], *(u32 *)data);
+		break;
+
+	case sdl_op:
+		run->mmio.phys_addr = kvm_mips_callbacks->gva_to_gpa(
+					vcpu->arch.host_cp0_badvaddr) & (~0x7);
+
+		run->mmio.len = 8;
+		imme = vcpu->arch.host_cp0_badvaddr & 0x7;
+		switch (imme) {
+		case 0:
+			*(u64 *)data = ((*(u64 *)data) & 0xffffffffffffff00) |
+					((vcpu->arch.gprs[rt] >> 56) & 0xff);
+			break;
+		case 1:
+			*(u64 *)data = ((*(u64 *)data) & 0xffffffffffff0000) |
+					((vcpu->arch.gprs[rt] >> 48) & 0xffff);
+			break;
+		case 2:
+			*(u64 *)data = ((*(u64 *)data) & 0xffffffffff000000) |
+					((vcpu->arch.gprs[rt] >> 40) & 0xffffff);
+			break;
+		case 3:
+			*(u64 *)data = ((*(u64 *)data) & 0xffffffff00000000) |
+					((vcpu->arch.gprs[rt] >> 32) & 0xffffffff);
+			break;
+		case 4:
+			*(u64 *)data = ((*(u64 *)data) & 0xffffff0000000000) |
+					((vcpu->arch.gprs[rt] >> 24) & 0xffffffffff);
+			break;
+		case 5:
+			*(u64 *)data = ((*(u64 *)data) & 0xffff000000000000) |
+					((vcpu->arch.gprs[rt] >> 16) & 0xffffffffffff);
+			break;
+		case 6:
+			*(u64 *)data = ((*(u64 *)data) & 0xff00000000000000) |
+					((vcpu->arch.gprs[rt] >> 8) & 0xffffffffffffff);
+			break;
+		case 7:
+			*(u64 *)data = vcpu->arch.gprs[rt];
+			break;
+		default:
+			break;
+		}
+
+		kvm_debug("[%#lx] OP_SDL: eaddr: %#lx, gpr: %#lx, data: %llx\n",
+			  vcpu->arch.pc, vcpu->arch.host_cp0_badvaddr,
+			  vcpu->arch.gprs[rt], *(u64 *)data);
+		break;
+
+	case sdr_op:
+		run->mmio.phys_addr = kvm_mips_callbacks->gva_to_gpa(
+					vcpu->arch.host_cp0_badvaddr) & (~0x7);
+
+		run->mmio.len = 8;
+		imme = vcpu->arch.host_cp0_badvaddr & 0x7;
+		switch (imme) {
+		case 0:
+			*(u64 *)data = vcpu->arch.gprs[rt];
+			break;
+		case 1:
+			*(u64 *)data = ((*(u64 *)data) & 0xff) |
+					(vcpu->arch.gprs[rt] << 8);
+			break;
+		case 2:
+			*(u64 *)data = ((*(u64 *)data) & 0xffff) |
+					(vcpu->arch.gprs[rt] << 16);
+			break;
+		case 3:
+			*(u64 *)data = ((*(u64 *)data) & 0xffffff) |
+					(vcpu->arch.gprs[rt] << 24);
+			break;
+		case 4:
+			*(u64 *)data = ((*(u64 *)data) & 0xffffffff) |
+					(vcpu->arch.gprs[rt] << 32);
+			break;
+		case 5:
+			*(u64 *)data = ((*(u64 *)data) & 0xffffffffff) |
+					(vcpu->arch.gprs[rt] << 40);
+			break;
+		case 6:
+			*(u64 *)data = ((*(u64 *)data) & 0xffffffffffff) |
+					(vcpu->arch.gprs[rt] << 48);
+			break;
+		case 7:
+			*(u64 *)data = ((*(u64 *)data) & 0xffffffffffffff) |
+					(vcpu->arch.gprs[rt] << 56);
+			break;
+		default:
+			break;
+		}
+
+		kvm_debug("[%#lx] OP_SDR: eaddr: %#lx, gpr: %#lx, data: %llx\n",
+			  vcpu->arch.pc, vcpu->arch.host_cp0_badvaddr,
+			  vcpu->arch.gprs[rt], *(u64 *)data);
+		break;
+
+#ifdef CONFIG_CPU_LOONGSON64
+	case sdc2_op:
+		rt = inst.loongson3_lsdc2_format.rt;
+		switch (inst.loongson3_lsdc2_format.opcode1) {
+		/*
+		 * Loongson-3 overridden sdc2 instructions.
+		 * opcode1              instruction
+		 *   0x0          gssbx: store 1 bytes from GPR
+		 *   0x1          gsshx: store 2 bytes from GPR
+		 *   0x2          gsswx: store 4 bytes from GPR
+		 *   0x3          gssdx: store 8 bytes from GPR
+		 */
+		case 0x0:
+			run->mmio.len = 1;
+			*(u8 *)data = vcpu->arch.gprs[rt];
+
+			kvm_debug("[%#lx] OP_GSSBX: eaddr: %#lx, gpr: %#lx, data: %#x\n",
+				  vcpu->arch.pc, vcpu->arch.host_cp0_badvaddr,
+				  vcpu->arch.gprs[rt], *(u8 *)data);
+			break;
+		case 0x1:
+			run->mmio.len = 2;
+			*(u16 *)data = vcpu->arch.gprs[rt];
+
+			kvm_debug("[%#lx] OP_GSSSHX: eaddr: %#lx, gpr: %#lx, data: %#x\n",
+				  vcpu->arch.pc, vcpu->arch.host_cp0_badvaddr,
+				  vcpu->arch.gprs[rt], *(u16 *)data);
+			break;
+		case 0x2:
+			run->mmio.len = 4;
+			*(u32 *)data = vcpu->arch.gprs[rt];
+
+			kvm_debug("[%#lx] OP_GSSWX: eaddr: %#lx, gpr: %#lx, data: %#x\n",
+				  vcpu->arch.pc, vcpu->arch.host_cp0_badvaddr,
+				  vcpu->arch.gprs[rt], *(u32 *)data);
+			break;
+		case 0x3:
+			run->mmio.len = 8;
+			*(u64 *)data = vcpu->arch.gprs[rt];
+
+			kvm_debug("[%#lx] OP_GSSDX: eaddr: %#lx, gpr: %#lx, data: %#llx\n",
+				  vcpu->arch.pc, vcpu->arch.host_cp0_badvaddr,
+				  vcpu->arch.gprs[rt], *(u64 *)data);
+			break;
+		default:
+			kvm_err("Godson Exteneded GS-Store not yet supported (inst=0x%08x)\n",
+				inst.word);
+			break;
+		}
+		break;
+#endif
 	default:
 		kvm_err("Store not yet supported (inst=0x%08x)\n",
 			inst.word);
@@ -1695,6 +1901,7 @@ enum emulation_result kvm_mips_emulate_load(union mips_instruction inst,
 	enum emulation_result er;
 	unsigned long curr_pc;
 	u32 op, rt;
+	unsigned int imme;
 
 	rt = inst.i_format.rt;
 	op = inst.i_format.opcode;
@@ -1747,6 +1954,162 @@ enum emulation_result kvm_mips_emulate_load(union mips_instruction inst,
 		run->mmio.len = 1;
 		break;
 
+	case lwl_op:
+		run->mmio.phys_addr = kvm_mips_callbacks->gva_to_gpa(
+					vcpu->arch.host_cp0_badvaddr) & (~0x3);
+
+		run->mmio.len = 4;
+		imme = vcpu->arch.host_cp0_badvaddr & 0x3;
+		switch (imme) {
+		case 0:
+			vcpu->mmio_needed = 3;	/* 1 byte */
+			break;
+		case 1:
+			vcpu->mmio_needed = 4;	/* 2 bytes */
+			break;
+		case 2:
+			vcpu->mmio_needed = 5;	/* 3 bytes */
+			break;
+		case 3:
+			vcpu->mmio_needed = 6;	/* 4 bytes */
+			break;
+		default:
+			break;
+		}
+		break;
+
+	case lwr_op:
+		run->mmio.phys_addr = kvm_mips_callbacks->gva_to_gpa(
+					vcpu->arch.host_cp0_badvaddr) & (~0x3);
+
+		run->mmio.len = 4;
+		imme = vcpu->arch.host_cp0_badvaddr & 0x3;
+		switch (imme) {
+		case 0:
+			vcpu->mmio_needed = 7;	/* 4 bytes */
+			break;
+		case 1:
+			vcpu->mmio_needed = 8;	/* 3 bytes */
+			break;
+		case 2:
+			vcpu->mmio_needed = 9;	/* 2 bytes */
+			break;
+		case 3:
+			vcpu->mmio_needed = 10;	/* 1 byte */
+			break;
+		default:
+			break;
+		}
+		break;
+
+	case ldl_op:
+		run->mmio.phys_addr = kvm_mips_callbacks->gva_to_gpa(
+					vcpu->arch.host_cp0_badvaddr) & (~0x7);
+
+		run->mmio.len = 8;
+		imme = vcpu->arch.host_cp0_badvaddr & 0x7;
+		switch (imme) {
+		case 0:
+			vcpu->mmio_needed = 11;	/* 1 byte */
+			break;
+		case 1:
+			vcpu->mmio_needed = 12;	/* 2 bytes */
+			break;
+		case 2:
+			vcpu->mmio_needed = 13;	/* 3 bytes */
+			break;
+		case 3:
+			vcpu->mmio_needed = 14;	/* 4 bytes */
+			break;
+		case 4:
+			vcpu->mmio_needed = 15;	/* 5 bytes */
+			break;
+		case 5:
+			vcpu->mmio_needed = 16;	/* 6 bytes */
+			break;
+		case 6:
+			vcpu->mmio_needed = 17;	/* 7 bytes */
+			break;
+		case 7:
+			vcpu->mmio_needed = 18;	/* 8 bytes */
+			break;
+		default:
+			break;
+		}
+		break;
+
+	case ldr_op:
+		run->mmio.phys_addr = kvm_mips_callbacks->gva_to_gpa(
+					vcpu->arch.host_cp0_badvaddr) & (~0x7);
+
+		run->mmio.len = 8;
+		imme = vcpu->arch.host_cp0_badvaddr & 0x7;
+		switch (imme) {
+		case 0:
+			vcpu->mmio_needed = 19;	/* 8 bytes */
+			break;
+		case 1:
+			vcpu->mmio_needed = 20;	/* 7 bytes */
+			break;
+		case 2:
+			vcpu->mmio_needed = 21;	/* 6 bytes */
+			break;
+		case 3:
+			vcpu->mmio_needed = 22;	/* 5 bytes */
+			break;
+		case 4:
+			vcpu->mmio_needed = 23;	/* 4 bytes */
+			break;
+		case 5:
+			vcpu->mmio_needed = 24;	/* 3 bytes */
+			break;
+		case 6:
+			vcpu->mmio_needed = 25;	/* 2 bytes */
+			break;
+		case 7:
+			vcpu->mmio_needed = 26;	/* 1 byte */
+			break;
+		default:
+			break;
+		}
+		break;
+
+#ifdef CONFIG_CPU_LOONGSON64
+	case ldc2_op:
+		rt = inst.loongson3_lsdc2_format.rt;
+		switch (inst.loongson3_lsdc2_format.opcode1) {
+		/*
+		 * Loongson-3 overridden ldc2 instructions.
+		 * opcode1              instruction
+		 *   0x0          gslbx: store 1 bytes from GPR
+		 *   0x1          gslhx: store 2 bytes from GPR
+		 *   0x2          gslwx: store 4 bytes from GPR
+		 *   0x3          gsldx: store 8 bytes from GPR
+		 */
+		case 0x0:
+			run->mmio.len = 1;
+			vcpu->mmio_needed = 27;	/* signed */
+			break;
+		case 0x1:
+			run->mmio.len = 2;
+			vcpu->mmio_needed = 28;	/* signed */
+			break;
+		case 0x2:
+			run->mmio.len = 4;
+			vcpu->mmio_needed = 29;	/* signed */
+			break;
+		case 0x3:
+			run->mmio.len = 8;
+			vcpu->mmio_needed = 30;	/* signed */
+			break;
+		default:
+			kvm_err("Godson Exteneded GS-Load for float not yet supported (inst=0x%08x)\n",
+				inst.word);
+			break;
+		}
+		break;
+#endif
+
 	default:
 		kvm_err("Load not yet supported (inst=0x%08x)\n",
 			inst.word);
@@ -2612,28 +2975,125 @@ enum emulation_result kvm_mips_complete_mmio_load(struct kvm_vcpu *vcpu,
 
 	switch (run->mmio.len) {
 	case 8:
-		*gpr = *(s64 *)run->mmio.data;
+		switch (vcpu->mmio_needed) {
+		case 11:
+			*gpr = (vcpu->arch.gprs[vcpu->arch.io_gpr] & 0xffffffffffffff) |
+				(((*(s64 *)run->mmio.data) & 0xff) << 56);
+			break;
+		case 12:
+			*gpr = (vcpu->arch.gprs[vcpu->arch.io_gpr] & 0xffffffffffff) |
+				(((*(s64 *)run->mmio.data) & 0xffff) << 48);
+			break;
+		case 13:
+			*gpr = (vcpu->arch.gprs[vcpu->arch.io_gpr] & 0xffffffffff) |
+				(((*(s64 *)run->mmio.data) & 0xffffff) << 40);
+			break;
+		case 14:
+			*gpr = (vcpu->arch.gprs[vcpu->arch.io_gpr] & 0xffffffff) |
+				(((*(s64 *)run->mmio.data) & 0xffffffff) << 32);
+			break;
+		case 15:
+			*gpr = (vcpu->arch.gprs[vcpu->arch.io_gpr] & 0xffffff) |
+				(((*(s64 *)run->mmio.data) & 0xffffffffff) << 24);
+			break;
+		case 16:
+			*gpr = (vcpu->arch.gprs[vcpu->arch.io_gpr] & 0xffff) |
+				(((*(s64 *)run->mmio.data) & 0xffffffffffff) << 16);
+			break;
+		case 17:
+			*gpr = (vcpu->arch.gprs[vcpu->arch.io_gpr] & 0xff) |
+				(((*(s64 *)run->mmio.data) & 0xffffffffffffff) << 8);
+			break;
+		case 18:
+		case 19:
+			*gpr = *(s64 *)run->mmio.data;
+			break;
+		case 20:
+			*gpr = (vcpu->arch.gprs[vcpu->arch.io_gpr] & 0xff00000000000000) |
+				((((*(s64 *)run->mmio.data)) >> 8) & 0xffffffffffffff);
+			break;
+		case 21:
+			*gpr = (vcpu->arch.gprs[vcpu->arch.io_gpr] & 0xffff000000000000) |
+				((((*(s64 *)run->mmio.data)) >> 16) & 0xffffffffffff);
+			break;
+		case 22:
+			*gpr = (vcpu->arch.gprs[vcpu->arch.io_gpr] & 0xffffff0000000000) |
+				((((*(s64 *)run->mmio.data)) >> 24) & 0xffffffffff);
+			break;
+		case 23:
+			*gpr = (vcpu->arch.gprs[vcpu->arch.io_gpr] & 0xffffffff00000000) |
+				((((*(s64 *)run->mmio.data)) >> 32) & 0xffffffff);
+			break;
+		case 24:
+			*gpr = (vcpu->arch.gprs[vcpu->arch.io_gpr] & 0xffffffffff000000) |
+				((((*(s64 *)run->mmio.data)) >> 40) & 0xffffff);
+			break;
+		case 25:
+			*gpr = (vcpu->arch.gprs[vcpu->arch.io_gpr] & 0xffffffffffff0000) |
+				((((*(s64 *)run->mmio.data)) >> 48) & 0xffff);
+			break;
+		case 26:
+			*gpr = (vcpu->arch.gprs[vcpu->arch.io_gpr] & 0xffffffffffffff00) |
+				((((*(s64 *)run->mmio.data)) >> 56) & 0xff);
+			break;
+		default:
+			*gpr = *(s64 *)run->mmio.data;
+		}
 		break;
 
 	case 4:
-		if (vcpu->mmio_needed == 2)
-			*gpr = *(s32 *)run->mmio.data;
-		else
+		switch (vcpu->mmio_needed) {
+		case 1:
 			*gpr = *(u32 *)run->mmio.data;
+			break;
+		case 2:
+			*gpr = *(s32 *)run->mmio.data;
+			break;
+		case 3:
+			*gpr = (vcpu->arch.gprs[vcpu->arch.io_gpr] & 0xffffff) |
+				(((*(s32 *)run->mmio.data) & 0xff) << 24);
+			break;
+		case 4:
+			*gpr = (vcpu->arch.gprs[vcpu->arch.io_gpr] & 0xffff) |
+				(((*(s32 *)run->mmio.data) & 0xffff) << 16);
+			break;
+		case 5:
+			*gpr = (vcpu->arch.gprs[vcpu->arch.io_gpr] & 0xff) |
+				(((*(s32 *)run->mmio.data) & 0xffffff) << 8);
+			break;
+		case 6:
+		case 7:
+			*gpr = *(s32 *)run->mmio.data;
+			break;
+		case 8:
+			*gpr = (vcpu->arch.gprs[vcpu->arch.io_gpr] & 0xff000000) |
+				((((*(s32 *)run->mmio.data)) >> 8) & 0xffffff);
+			break;
+		case 9:
+			*gpr = (vcpu->arch.gprs[vcpu->arch.io_gpr] & 0xffff0000) |
+				((((*(s32 *)run->mmio.data)) >> 16) & 0xffff);
+			break;
+		case 10:
+			*gpr = (vcpu->arch.gprs[vcpu->arch.io_gpr] & 0xffffff00) |
+				((((*(s32 *)run->mmio.data)) >> 24) & 0xff);
+			break;
+		default:
+			*gpr = *(s32 *)run->mmio.data;
+		}
 		break;
 
 	case 2:
-		if (vcpu->mmio_needed == 2)
-			*gpr = *(s16 *) run->mmio.data;
-		else
+		if (vcpu->mmio_needed == 1)
 			*gpr = *(u16 *)run->mmio.data;
+		else
+			*gpr = *(s16 *)run->mmio.data;
 
 		break;
 	case 1:
-		if (vcpu->mmio_needed == 2)
-			*gpr = *(s8 *) run->mmio.data;
+		if (vcpu->mmio_needed == 1)
+			*gpr = *(u8 *)run->mmio.data;
 		else
-			*gpr = *(u8 *) run->mmio.data;
+			*gpr = *(s8 *)run->mmio.data;
 		break;
 	}
 
-- 
2.7.0

