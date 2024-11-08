Return-Path: <kvm+bounces-31211-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EB9E09C14E3
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 04:54:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 46A32B22943
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 03:54:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2874F1C3F0D;
	Fri,  8 Nov 2024 03:54:28 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C9553209;
	Fri,  8 Nov 2024 03:54:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731038067; cv=none; b=CmlxubTcG7bhOje8o7pLlS5DK2qBFAABOwBmL5w3qThlR1oNtIThZpYC8Ja+vgp+bPijmym2j875jAXknhMrueoZNRD7P00jEzb6QrCbgKCLJOSCsN55xH6JTXASSR05vGQVdN8FwbAak1PA4PzMiv4x7MiTRKBebXZOuYsWyNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731038067; c=relaxed/simple;
	bh=s9I/+L8Y04hbbgNEJ3W59+QiGyR1JXDUDFnOLKznL0g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fCSL41T3nn5j8rhE8aDceZ15TqfpaCcXC9QdUFCsilzXd2Oj4ez+PSCaSmEkhScD1rsHeDzggNu/xkkZQXTuq5+H7cUZz78AXv17U6IPk6AxstI6974MClB+UXJpof5yxWac6U+K5YoGWEuH/gNcN/wXSt/m+cCbU6aCQN9g/vc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.185])
	by gateway (Coremail) with SMTP id _____8CxSOFuiy1nq9g4AA--.46160S3;
	Fri, 08 Nov 2024 11:54:22 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
	by front1 (Coremail) with SMTP id qMiowMBxrsJtiy1nITRMAA--.38809S2;
	Fri, 08 Nov 2024 11:54:22 +0800 (CST)
From: Xianglai Li <lixianglai@loongson.cn>
To: linux-kernel@vger.kernel.org
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Bibo Mao <maobibo@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	Paolo Bonzini <pbonzini@redhat.com>,
	WANG Xuerui <kernel@xen0n.name>,
	Xianglai li <lixianglai@loongson.cn>
Subject: [PATCH V4 01/11] LoongArch: KVM: Add iocsr and mmio bus simulation in kernel
Date: Fri,  8 Nov 2024 11:35:48 +0800
Message-Id: <20241108033558.2727612-1-lixianglai@loongson.cn>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20241108033437.2727574-1-lixianglai@loongson.cn>
References: <20241108033437.2727574-1-lixianglai@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMBxrsJtiy1nITRMAA--.38809S2
X-CM-SenderInfo: 5ol0xt5qjotxo6or00hjvr0hdfq/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Add iocsr and mmio memory read and write simulation to the kernel. When
the VM accesses the device address space through iocsr instructions or
mmio, it does not need to return to the qemu user mode but can directly
completes the access in the kernel mode.

Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
Signed-off-by: Xianglai Li <lixianglai@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
---
Cc: Bibo Mao <maobibo@loongson.cn> 
Cc: Huacai Chen <chenhuacai@kernel.org> 
Cc: kvm@vger.kernel.org 
Cc: loongarch@lists.linux.dev 
Cc: Paolo Bonzini <pbonzini@redhat.com> 
Cc: Tianrui Zhao <zhaotianrui@loongson.cn> 
Cc: WANG Xuerui <kernel@xen0n.name> 
Cc: Xianglai li <lixianglai@loongson.cn> 

 arch/loongarch/kvm/exit.c | 80 +++++++++++++++++++++++++++------------
 include/linux/kvm_host.h  |  1 +
 2 files changed, 56 insertions(+), 25 deletions(-)

diff --git a/arch/loongarch/kvm/exit.c b/arch/loongarch/kvm/exit.c
index 90894f70ff4a..24755e256537 100644
--- a/arch/loongarch/kvm/exit.c
+++ b/arch/loongarch/kvm/exit.c
@@ -157,7 +157,7 @@ static int kvm_handle_csr(struct kvm_vcpu *vcpu, larch_inst inst)
 int kvm_emu_iocsr(larch_inst inst, struct kvm_run *run, struct kvm_vcpu *vcpu)
 {
 	int ret;
-	unsigned long val;
+	unsigned long *val;
 	u32 addr, rd, rj, opcode;
 
 	/*
@@ -170,6 +170,7 @@ int kvm_emu_iocsr(larch_inst inst, struct kvm_run *run, struct kvm_vcpu *vcpu)
 	ret = EMULATE_DO_IOCSR;
 	run->iocsr_io.phys_addr = addr;
 	run->iocsr_io.is_write = 0;
+	val = &vcpu->arch.gprs[rd];
 
 	/* LoongArch is Little endian */
 	switch (opcode) {
@@ -202,18 +203,24 @@ int kvm_emu_iocsr(larch_inst inst, struct kvm_run *run, struct kvm_vcpu *vcpu)
 		run->iocsr_io.is_write = 1;
 		break;
 	default:
-		ret = EMULATE_FAIL;
-		break;
+		return EMULATE_FAIL;
 	}
 
-	if (ret == EMULATE_DO_IOCSR) {
-		if (run->iocsr_io.is_write) {
-			val = vcpu->arch.gprs[rd];
-			memcpy(run->iocsr_io.data, &val, run->iocsr_io.len);
-		}
-		vcpu->arch.io_gpr = rd;
+	if (run->iocsr_io.is_write) {
+		if (!kvm_io_bus_write(vcpu,
+				KVM_IOCSR_BUS, addr, run->iocsr_io.len, val))
+			ret = EMULATE_DONE;
+		else
+			/* Save data and let user space to write it */
+			memcpy(run->iocsr_io.data, val, run->iocsr_io.len);
+	} else {
+		if (!kvm_io_bus_read(vcpu,
+				KVM_IOCSR_BUS, addr, run->iocsr_io.len, val))
+			ret = EMULATE_DONE;
+		else
+			/* Save register id for iocsr read completion */
+			vcpu->arch.io_gpr = rd;
 	}
-
 	return ret;
 }
 
@@ -447,19 +454,32 @@ int kvm_emu_mmio_read(struct kvm_vcpu *vcpu, larch_inst inst)
 	}
 
 	if (ret == EMULATE_DO_MMIO) {
+		trace_kvm_mmio(KVM_TRACE_MMIO_READ, run->mmio.len,
+				run->mmio.phys_addr, NULL);
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
-		trace_kvm_mmio(KVM_TRACE_MMIO_READ_UNSATISFIED, run->mmio.len,
-				run->mmio.phys_addr, NULL);
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
 	return ret;
 }
 
@@ -600,19 +620,29 @@ int kvm_emu_mmio_write(struct kvm_vcpu *vcpu, larch_inst inst)
 	}
 
 	if (ret == EMULATE_DO_MMIO) {
+		trace_kvm_mmio(KVM_TRACE_MMIO_WRITE, run->mmio.len,
+				run->mmio.phys_addr, data);
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
-		trace_kvm_mmio(KVM_TRACE_MMIO_WRITE, run->mmio.len,
-				run->mmio.phys_addr, data);
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
index 45be36e5285f..164d9725cb08 100644
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


