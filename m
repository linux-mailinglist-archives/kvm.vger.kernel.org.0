Return-Path: <kvm+bounces-21020-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id ED7489280A6
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 04:57:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7A6531F21952
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 02:57:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C30F84A56;
	Fri,  5 Jul 2024 02:56:25 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 118E61C290;
	Fri,  5 Jul 2024 02:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720148184; cv=none; b=lxA9W2C8h9Wy1C1lZ+csu59Ks6VQTBHSXssS4acej+augpTLJGq7dqBtDpLComAevsHCwWBdZCksg7vto1qdhfxl1BmM/kCnkVN9GV2V/yOZzLuPLCTWA7lyXdZBzflwbHSVaO2RkCMoVbRc5MJUm/VIZOw5exzRTpwiaTRT6gs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720148184; c=relaxed/simple;
	bh=pzYx1l2fw/nfwezt22rT0BqBTFp8qwcKpxQvF7yjRqw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=eG802Lv98lQg9O+DtxMluieKPpixRfHbiMxm1MuajEAcjsGrCncL5RzC3sQqBbWTOnQNbU/WAspA2BtarPVN99vnnaqzoI9Li/kJxeuQZNROOYy1SEIDCEmhu5/SBTZlLPLeD4SpVt30eX6mI5iEcLXp+qO72Py6XOXLOOi/NJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.185])
	by gateway (Coremail) with SMTP id _____8Ax0PHSYIdm3CQBAA--.3863S3;
	Fri, 05 Jul 2024 10:56:18 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8BxWcbRYIdm3tE7AA--.7292S3;
	Fri, 05 Jul 2024 10:56:17 +0800 (CST)
From: Xianglai Li <lixianglai@loongson.cn>
To: linux-kernel@vger.kernel.org
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Bibo Mao <maobibo@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	Min Zhou <zhoumin@loongson.cn>,
	Paolo Bonzini <pbonzini@redhat.com>,
	WANG Xuerui <kernel@xen0n.name>,
	Xianglai li <lixianglai@loongson.cn>
Subject: [PATCH 01/11] LoongArch: KVM: Add iocsr and mmio bus simulation in kernel
Date: Fri,  5 Jul 2024 10:38:44 +0800
Message-Id: <20240705023854.1005258-2-lixianglai@loongson.cn>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20240705023854.1005258-1-lixianglai@loongson.cn>
References: <20240705023854.1005258-1-lixianglai@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8BxWcbRYIdm3tE7AA--.7292S3
X-CM-SenderInfo: 5ol0xt5qjotxo6or00hjvr0hdfq/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Add iocsr and mmio memory read and write simulation to the kernel.
When the VM accesses the device address space through iocsr
instructions or mmio, it does not need to return to the qemu
user mode but directly completes the access in the kernel mode.

Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
Signed-off-by: Xianglai Li <lixianglai@loongson.cn>
---
Cc: Bibo Mao <maobibo@loongson.cn> 
Cc: Huacai Chen <chenhuacai@kernel.org> 
Cc: kvm@vger.kernel.org 
Cc: loongarch@lists.linux.dev 
Cc: Min Zhou <zhoumin@loongson.cn> 
Cc: Paolo Bonzini <pbonzini@redhat.com> 
Cc: Tianrui Zhao <zhaotianrui@loongson.cn> 
Cc: WANG Xuerui <kernel@xen0n.name> 
Cc: Xianglai li <lixianglai@loongson.cn> 

 arch/loongarch/kvm/exit.c | 69 ++++++++++++++++++++++++++++-----------
 include/linux/kvm_host.h  |  1 +
 2 files changed, 51 insertions(+), 19 deletions(-)

diff --git a/arch/loongarch/kvm/exit.c b/arch/loongarch/kvm/exit.c
index a68573e091c0..e8e37e135dd1 100644
--- a/arch/loongarch/kvm/exit.c
+++ b/arch/loongarch/kvm/exit.c
@@ -148,7 +148,7 @@ static int kvm_handle_csr(struct kvm_vcpu *vcpu, larch_inst inst)
 int kvm_emu_iocsr(larch_inst inst, struct kvm_run *run, struct kvm_vcpu *vcpu)
 {
 	int ret;
-	unsigned long val;
+	unsigned long *val;
 	u32 addr, rd, rj, opcode;
 
 	/*
@@ -161,6 +161,7 @@ int kvm_emu_iocsr(larch_inst inst, struct kvm_run *run, struct kvm_vcpu *vcpu)
 	ret = EMULATE_DO_IOCSR;
 	run->iocsr_io.phys_addr = addr;
 	run->iocsr_io.is_write = 0;
+	val = &vcpu->arch.gprs[rd];
 
 	/* LoongArch is Little endian */
 	switch (opcode) {
@@ -194,15 +195,21 @@ int kvm_emu_iocsr(larch_inst inst, struct kvm_run *run, struct kvm_vcpu *vcpu)
 		break;
 	default:
 		ret = EMULATE_FAIL;
-		break;
+		return ret;
 	}
 
-	if (ret == EMULATE_DO_IOCSR) {
-		if (run->iocsr_io.is_write) {
-			val = vcpu->arch.gprs[rd];
-			memcpy(run->iocsr_io.data, &val, run->iocsr_io.len);
-		}
-		vcpu->arch.io_gpr = rd;
+	if (run->iocsr_io.is_write) {
+		if (!kvm_io_bus_write(vcpu, KVM_IOCSR_BUS, addr, run->iocsr_io.len, val))
+			ret = EMULATE_DONE;
+		else
+			/* Save data and let user space to write it */
+			memcpy(run->iocsr_io.data, val, run->iocsr_io.len);
+	} else {
+		if (!kvm_io_bus_read(vcpu, KVM_IOCSR_BUS, addr, run->iocsr_io.len, val))
+			ret = EMULATE_DONE;
+		else
+			/* Save register id for iocsr read completion */
+			vcpu->arch.io_gpr = rd;
 	}
 
 	return ret;
@@ -438,19 +445,33 @@ int kvm_emu_mmio_read(struct kvm_vcpu *vcpu, larch_inst inst)
 	}
 
 	if (ret == EMULATE_DO_MMIO) {
+		/*
+		 * if mmio device such as pch pic is emulated in KVM,
+		 * it need not return to user space to handle the mmio
+		 * exception.
+		 */
+		ret = kvm_io_bus_read(vcpu, KVM_MMIO_BUS, vcpu->arch.badv,
+				run->mmio.len, &vcpu->arch.gprs[rd]);
+		if (!ret) {
+			update_pc(&vcpu->arch);
+			vcpu->mmio_needed = 0;
+			return EMULATE_DONE;
+		}
+
 		/* Set for kvm_complete_mmio_read() use */
 		vcpu->arch.io_gpr = rd;
 		run->mmio.is_write = 0;
 		vcpu->mmio_is_write = 0;
 		trace_kvm_mmio(KVM_TRACE_MMIO_READ_UNSATISFIED, run->mmio.len,
 				run->mmio.phys_addr, NULL);
-	} else {
-		kvm_err("Read not supported Inst=0x%08x @%lx BadVaddr:%#lx\n",
-			inst.word, vcpu->arch.pc, vcpu->arch.badv);
-		kvm_arch_vcpu_dump_regs(vcpu);
-		vcpu->mmio_needed = 0;
+		return EMULATE_DO_MMIO;
 	}
 
+	kvm_err("Read not supported Inst=0x%08x @%lx BadVaddr:%#lx\n",
+			inst.word, vcpu->arch.pc, vcpu->arch.badv);
+	kvm_arch_vcpu_dump_regs(vcpu);
+	vcpu->mmio_needed = 0;
+
 	return ret;
 }
 
@@ -591,19 +612,29 @@ int kvm_emu_mmio_write(struct kvm_vcpu *vcpu, larch_inst inst)
 	}
 
 	if (ret == EMULATE_DO_MMIO) {
+		/*
+		 * if mmio device such as pch pic is emulated in KVM,
+		 * it need not return to user space to handle the mmio
+		 * exception.
+		 */
+		ret = kvm_io_bus_write(vcpu, KVM_MMIO_BUS, vcpu->arch.badv,
+				run->mmio.len, data);
+		if (!ret)
+			return EMULATE_DONE;
+
 		run->mmio.is_write = 1;
 		vcpu->mmio_needed = 1;
 		vcpu->mmio_is_write = 1;
 		trace_kvm_mmio(KVM_TRACE_MMIO_WRITE, run->mmio.len,
 				run->mmio.phys_addr, data);
-	} else {
-		vcpu->arch.pc = curr_pc;
-		kvm_err("Write not supported Inst=0x%08x @%lx BadVaddr:%#lx\n",
-			inst.word, vcpu->arch.pc, vcpu->arch.badv);
-		kvm_arch_vcpu_dump_regs(vcpu);
-		/* Rollback PC if emulation was unsuccessful */
+		return EMULATE_DO_MMIO;
 	}
 
+	vcpu->arch.pc = curr_pc;
+	kvm_err("Write not supported Inst=0x%08x @%lx BadVaddr:%#lx\n",
+			inst.word, vcpu->arch.pc, vcpu->arch.badv);
+	kvm_arch_vcpu_dump_regs(vcpu);
+	/* Rollback PC if emulation was unsuccessful */
 	return ret;
 }
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 692c01e41a18..f51b2e53d81c 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -219,6 +219,7 @@ enum kvm_bus {
 	KVM_PIO_BUS,
 	KVM_VIRTIO_CCW_NOTIFY_BUS,
 	KVM_FAST_MMIO_BUS,
+	KVM_IOCSR_BUS,
 	KVM_NR_BUSES
 };
 
-- 
2.39.1


