Return-Path: <kvm+bounces-26248-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A6529736B2
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 14:02:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CD6B828BEE0
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 12:02:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81E0519259E;
	Tue, 10 Sep 2024 12:01:45 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CC5418FDA5;
	Tue, 10 Sep 2024 12:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725969704; cv=none; b=NHOFV2ubaXF6IhU5WX+KeSW3nrkpBMfsOU8MB5F4ZwrWDSaO6RAJf8xMOW9kXqEUvXZVLpWihTv6jJrFBmGtNfv2aPTQgOv48HTJToxFDBRpdIZTw/A5q4/VoNBLd6oAsjXIj5SUHuo1sCDET8ROPHrGzzgT+YuFVic9ZPoSvl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725969704; c=relaxed/simple;
	bh=7Z6oj8tec7G+l6Fi7f4VQ2bYnwgurw5JBRAmZfQoYHI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=IRMw34ovDdzqsXH/Mj9pcFZ+ztgaEVS3SFbI9q+PohFRjCGsb4zLIi39/aZ4DgjP9xAynz47FnT1lv2ScobtVQu5PLaGA8gXXUa5xV2coZn11rcW0YRhwCyyLV0k3cWaT12giYXyCE1vJcDcyqgSEamH6e5PxsHt7P9SVCgW3S4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.185])
	by gateway (Coremail) with SMTP id _____8CxxuglNeBmEa8DAA--.7542S3;
	Tue, 10 Sep 2024 20:01:41 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
	by front2 (Coremail) with SMTP id qciowMCxrsceNeBmyGIDAA--.15904S3;
	Tue, 10 Sep 2024 20:01:40 +0800 (CST)
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
Subject: [PATCH V3 01/11] LoongArch: KVM: Add iocsr and mmio bus simulation in kernel
Date: Tue, 10 Sep 2024 19:43:50 +0800
Message-Id: <20240910114400.4062433-2-lixianglai@loongson.cn>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20240910114400.4062433-1-lixianglai@loongson.cn>
References: <20240910114400.4062433-1-lixianglai@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qciowMCxrsceNeBmyGIDAA--.15904S3
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
index 0d5125a3e31a..1149cc6a9dde 100644
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


