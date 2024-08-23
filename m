Return-Path: <kvm+bounces-24876-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 534A795C9AC
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 11:52:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7063B1C227F2
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 09:52:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0917E185B7B;
	Fri, 23 Aug 2024 09:51:41 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2E3B16BE2A;
	Fri, 23 Aug 2024 09:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724406700; cv=none; b=Ai4mTn3rucUrzryBhJFjXAJt2K3HjD9lsKkX9exw4vW7l4b0KnPS8K8cyteJhT++ySnbqJQk7r/oya+mm6HmnVIwJCvOF0nJu4x7Wpzo9OpWnpXBkLJpC5LOWsdhN0rEHGTq73YEQSbfFTmZCkyGpt3lLnRZU1HmdcbPIGAKX4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724406700; c=relaxed/simple;
	bh=v70zuNzGBttIfFDwYn5lcqv9DRRc2UPTs30KdJtLfHE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FypzQu2hoyulrq7zURSkyDc3whvI8+jTMUUd6A/Q+MKi8AAH9V8mQ5itVogceik2cFWRLu8yxFDyQJwIRz5x0cmbbcVlHXBaR8JEWW8UwbEwkfXWNthka37qy6x35oXylJ+P83JrJd05+10xgcLWmzChZRcH78FGxxgAMYa2oyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.185])
	by gateway (Coremail) with SMTP id _____8CxaZqnW8hmDkodAA--.25078S3;
	Fri, 23 Aug 2024 17:51:35 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
	by front1 (Coremail) with SMTP id qMiowMCxC2ekW8hm2SsfAA--.39816S3;
	Fri, 23 Aug 2024 17:51:34 +0800 (CST)
From: Xianglai Li <lixianglai@loongson.cn>
To: linux-kernel@vger.kernel.org
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Bibo Mao <maobibo@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	Paolo Bonzini <pbonzini@redhat.com>,
	WANG Xuerui <kernel@xen0n.name>,
	Xianglai li <lixianglai@loongson.cn>
Subject: [[PATCH V2 01/10] LoongArch: KVM: Add iocsr and mmio bus simulation in kernel
Date: Fri, 23 Aug 2024 17:33:55 +0800
Message-Id: <20240823093404.204450-2-lixianglai@loongson.cn>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20240823093404.204450-1-lixianglai@loongson.cn>
References: <20240823093404.204450-1-lixianglai@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMCxC2ekW8hm2SsfAA--.39816S3
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
Cc: Paolo Bonzini <pbonzini@redhat.com> 
Cc: Tianrui Zhao <zhaotianrui@loongson.cn> 
Cc: WANG Xuerui <kernel@xen0n.name> 
Cc: Xianglai li <lixianglai@loongson.cn> 

 arch/loongarch/kvm/exit.c  | 86 +++++++++++++++++++++++++++-----------
 include/linux/kvm_host.h   |  1 +
 include/trace/events/kvm.h | 35 ++++++++++++++++
 3 files changed, 97 insertions(+), 25 deletions(-)

diff --git a/arch/loongarch/kvm/exit.c b/arch/loongarch/kvm/exit.c
index ea73f9dc2cc6..6b15117106f9 100644
--- a/arch/loongarch/kvm/exit.c
+++ b/arch/loongarch/kvm/exit.c
@@ -151,7 +151,7 @@ static int kvm_handle_csr(struct kvm_vcpu *vcpu, larch_inst inst)
 int kvm_emu_iocsr(larch_inst inst, struct kvm_run *run, struct kvm_vcpu *vcpu)
 {
 	int ret;
-	unsigned long val;
+	unsigned long *val;
 	u32 addr, rd, rj, opcode;
 
 	/*
@@ -164,6 +164,7 @@ int kvm_emu_iocsr(larch_inst inst, struct kvm_run *run, struct kvm_vcpu *vcpu)
 	ret = EMULATE_DO_IOCSR;
 	run->iocsr_io.phys_addr = addr;
 	run->iocsr_io.is_write = 0;
+	val = &vcpu->arch.gprs[rd];
 
 	/* LoongArch is Little endian */
 	switch (opcode) {
@@ -196,18 +197,30 @@ int kvm_emu_iocsr(larch_inst inst, struct kvm_run *run, struct kvm_vcpu *vcpu)
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
+		trace_kvm_iocsr(KVM_TRACE_IOCSR_WRITE,
+				run->iocsr_io.len,
+				addr, val);
+	} else {
+		if (!kvm_io_bus_read(vcpu,
+				KVM_IOCSR_BUS, addr, run->iocsr_io.len, val))
+			ret = EMULATE_DONE;
+		else
+			/* Save register id for iocsr read completion */
+			vcpu->arch.io_gpr = rd;
+		trace_kvm_iocsr(KVM_TRACE_IOCSR_READ,
+				run->iocsr_io.len,
+				addr, NULL);
 	}
-
 	return ret;
 }
 
@@ -441,19 +454,32 @@ int kvm_emu_mmio_read(struct kvm_vcpu *vcpu, larch_inst inst)
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
 
@@ -594,19 +620,29 @@ int kvm_emu_mmio_write(struct kvm_vcpu *vcpu, larch_inst inst)
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
index b23c6d48392f..d06c9a53d397 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -219,6 +219,7 @@ enum kvm_bus {
 	KVM_PIO_BUS,
 	KVM_VIRTIO_CCW_NOTIFY_BUS,
 	KVM_FAST_MMIO_BUS,
+	KVM_IOCSR_BUS,
 	KVM_NR_BUSES
 };
 
diff --git a/include/trace/events/kvm.h b/include/trace/events/kvm.h
index 74e40d5d4af4..2391cb257636 100644
--- a/include/trace/events/kvm.h
+++ b/include/trace/events/kvm.h
@@ -236,6 +236,41 @@ TRACE_EVENT(kvm_mmio,
 		  __entry->len, __entry->gpa, __entry->val)
 );
 
+#define KVM_TRACE_IOCSR_READ_UNSATISFIED 0
+#define KVM_TRACE_IOCSR_READ 1
+#define KVM_TRACE_IOCSR_WRITE 2
+
+#define kvm_trace_symbol_iocsr \
+	({ KVM_TRACE_IOCSR_READ_UNSATISFIED, "unsatisfied-read" }, \
+	{ KVM_TRACE_IOCSR_READ, "read" }, \
+	{ KVM_TRACE_IOCSR_WRITE, "write" })
+
+TRACE_EVENT(kvm_iocsr,
+	TP_PROTO(int type, int len, u64 gpa, void *val),
+	TP_ARGS(type, len, gpa, val),
+
+	TP_STRUCT__entry(
+		__field(u32,	type)
+		__field(u32,	len)
+		__field(u64,	gpa)
+		__field(u64,	val)
+	),
+
+	TP_fast_assign(
+		__entry->type		= type;
+		__entry->len		= len;
+		__entry->gpa		= gpa;
+		__entry->val		= 0;
+		if (val)
+			memcpy(&__entry->val, val,
+			       min_t(u32, sizeof(__entry->val), len));
+	),
+
+	TP_printk("iocsr %s len %u gpa 0x%llx val 0x%llx",
+		  __print_symbolic(__entry->type, kvm_trace_symbol_iocsr),
+		  __entry->len, __entry->gpa, __entry->val)
+);
+
 #define kvm_fpu_load_symbol	\
 	{0, "unload"},		\
 	{1, "load"}
-- 
2.39.1


