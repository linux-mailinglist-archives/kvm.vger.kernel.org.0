Return-Path: <kvm+bounces-11893-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D00BB87C9A8
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 09:09:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 460E1B225E8
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 08:09:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6573218EA2;
	Fri, 15 Mar 2024 08:07:29 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BCB817C71;
	Fri, 15 Mar 2024 08:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710490048; cv=none; b=rVj56ZE7U4PqlH/Vix30Pzb62SpLq1ul9ZPVdmnngqMNzyq/FwFMG/23gdcz0fBRv/IhxUSx1Mr+P66iqdqyR+rztX+Lq9UNuMsQN9WcBUeFZRoVXjYgPjfZFa2vhT259DxnJyomg8AokZ2h76E//EnKCmXYZHgAyXQFXn94oWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710490048; c=relaxed/simple;
	bh=27mrN+5DEdRbNJ5DNBL13ncY+78DLKg90nW/FD1NnZQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JUFw9RBg0PwvlAoeb/tj1/CHHX55eQOxz8ZSQFuj/OyyUwm55SeMsp9uIwS4qbDX8va2C9YvFCT8mq4jylxksU+Rx+3SIIqGGYsUSaZW0UgB4Nj8KOXpFAfYxUnn0E3N42mPeYVkczCpOT7WK7pg3JGzUsQUvhy7AMVdDv5qHQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8Bxiei1AfRlSmUZAA--.42198S3;
	Fri, 15 Mar 2024 16:07:17 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8Cx_c6uAfRl4MZaAA--.41676S7;
	Fri, 15 Mar 2024 16:07:15 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Huacai Chen <chenhuacai@kernel.org>,
	Tianrui Zhao <zhaotianrui@loongson.cn>,
	WANG Xuerui <kernel@xen0n.name>,
	Juergen Gross <jgross@suse.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>
Cc: loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	virtualization@lists.linux.dev,
	kvm@vger.kernel.org
Subject: [PATCH v7 5/7] LoongArch: KVM: Add pv ipi support on kvm side
Date: Fri, 15 Mar 2024 16:07:08 +0800
Message-Id: <20240315080710.2812974-6-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20240315080710.2812974-1-maobibo@loongson.cn>
References: <20240315080710.2812974-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8Cx_c6uAfRl4MZaAA--.41676S7
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoW3Gw17ZF1DJry5Kr1kZryfKrX_yoWDJFykpF
	ykCwn5KFWYgrWfC3srJrnIgry5Wrn3GrySvFZIy395AF4jv3WrXrW8KFWDAF15J34kX3WS
	qFWYqwsruFZrJ3cCm3ZEXasCq-sJn29KB7ZKAUJUUUUx529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUBSb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAF
	wI0_Gr1j6F4UJwAaw2AFwI0_JF0_Jw1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2
	xF0cIa020Ex4CE44I27wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_
	Wrv_ZF1lYx0Ex4A2jsIE14v26r4j6F4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x
	0EwIxGrwCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkE
	bVWUJVW8JwCFI7km07C267AKxVWUAVWUtwC20s026c02F40E14v26r1j6r18MI8I3I0E74
	80Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0
	I7IYx2IY67AKxVW5JVW7JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UMIIF0xvE42
	xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWxJwCI42IY6I8E87Iv6xkF
	7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUVWrXDUUUU

On LoongArch system, ipi hw uses iocsr registers, there is one iocsr
register access on ipi sending, and two iocsr access on ipi receiving
which is ipi interrupt handler. On VM mode all iocsr accessing will
cause VM to trap into hypervisor. So with one ipi hw notification
there will be three times of trap.

PV ipi is added for VM, hypercall instruction is used for ipi sender,
and hypervisor will inject SWI to destination vcpu. During SWI
interrupt handler, only estat CSR register is written to clear irq.
Estat CSR register access will not trap into hypervisor. So with pv
ipi supported, there is one trap with pv ipi sender, and no trap with
ipi receiver, there is only one trap with ipi notification.

Also this patch adds ipi multicast support, the method is similar with
x86. With ipi multicast support, ipi notification can be sent to at
most 128 vcpus at one time. It reduces trap times into hypervisor
greatly.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/include/asm/kvm_host.h  |   1 +
 arch/loongarch/include/asm/kvm_para.h  | 129 +++++++++++++++++++++++++
 arch/loongarch/include/asm/kvm_vcpu.h  |  10 ++
 arch/loongarch/include/asm/loongarch.h |   1 +
 arch/loongarch/kvm/exit.c              |  76 ++++++++++++++-
 arch/loongarch/kvm/vcpu.c              |   1 +
 6 files changed, 216 insertions(+), 2 deletions(-)

diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/include/asm/kvm_host.h
index 3ba16ef1fe69..0b96c6303cf7 100644
--- a/arch/loongarch/include/asm/kvm_host.h
+++ b/arch/loongarch/include/asm/kvm_host.h
@@ -43,6 +43,7 @@ struct kvm_vcpu_stat {
 	u64 idle_exits;
 	u64 cpucfg_exits;
 	u64 signal_exits;
+	u64 hypercall_exits;
 };
 
 #define KVM_MEM_HUGEPAGE_CAPABLE	(1UL << 0)
diff --git a/arch/loongarch/include/asm/kvm_para.h b/arch/loongarch/include/asm/kvm_para.h
index d48f993ae206..a5809a854bae 100644
--- a/arch/loongarch/include/asm/kvm_para.h
+++ b/arch/loongarch/include/asm/kvm_para.h
@@ -2,6 +2,16 @@
 #ifndef _ASM_LOONGARCH_KVM_PARA_H
 #define _ASM_LOONGARCH_KVM_PARA_H
 
+/*
+ * Hypercall code field
+ */
+#define HYPERVISOR_KVM			1
+#define HYPERVISOR_VENDOR_SHIFT		8
+#define HYPERCALL_CODE(vendor, code)	((vendor << HYPERVISOR_VENDOR_SHIFT) + code)
+#define KVM_HCALL_CODE_PV_SERVICE	0
+#define KVM_HCALL_PV_SERVICE		HYPERCALL_CODE(HYPERVISOR_KVM, KVM_HCALL_CODE_PV_SERVICE)
+#define  KVM_HCALL_FUNC_PV_IPI		1
+
 /*
  * LoongArch hypercall return code
  */
@@ -9,6 +19,125 @@
 #define KVM_HCALL_INVALID_CODE		-1UL
 #define KVM_HCALL_INVALID_PARAMETER	-2UL
 
+/*
+ * Hypercall interface for KVM hypervisor
+ *
+ * a0: function identifier
+ * a1-a6: args
+ * Return value will be placed in a0.
+ * Up to 6 arguments are passed in a1, a2, a3, a4, a5, a6.
+ */
+static __always_inline long kvm_hypercall(u64 fid)
+{
+	register long ret asm("a0");
+	register unsigned long fun asm("a0") = fid;
+
+	__asm__ __volatile__(
+		"hvcl "__stringify(KVM_HCALL_PV_SERVICE)
+		: "=r" (ret)
+		: "r" (fun)
+		: "memory"
+		);
+
+	return ret;
+}
+
+static __always_inline long kvm_hypercall1(u64 fid, unsigned long arg0)
+{
+	register long ret asm("a0");
+	register unsigned long fun asm("a0") = fid;
+	register unsigned long a1  asm("a1") = arg0;
+
+	__asm__ __volatile__(
+		"hvcl "__stringify(KVM_HCALL_PV_SERVICE)
+		: "=r" (ret)
+		: "r" (fun), "r" (a1)
+		: "memory"
+		);
+
+	return ret;
+}
+
+static __always_inline long kvm_hypercall2(u64 fid,
+		unsigned long arg0, unsigned long arg1)
+{
+	register long ret asm("a0");
+	register unsigned long fun asm("a0") = fid;
+	register unsigned long a1  asm("a1") = arg0;
+	register unsigned long a2  asm("a2") = arg1;
+
+	__asm__ __volatile__(
+			"hvcl "__stringify(KVM_HCALL_PV_SERVICE)
+			: "=r" (ret)
+			: "r" (fun), "r" (a1), "r" (a2)
+			: "memory"
+			);
+
+	return ret;
+}
+
+static __always_inline long kvm_hypercall3(u64 fid,
+	unsigned long arg0, unsigned long arg1, unsigned long arg2)
+{
+	register long ret asm("a0");
+	register unsigned long fun asm("a0") = fid;
+	register unsigned long a1  asm("a1") = arg0;
+	register unsigned long a2  asm("a2") = arg1;
+	register unsigned long a3  asm("a3") = arg2;
+
+	__asm__ __volatile__(
+		"hvcl "__stringify(KVM_HCALL_PV_SERVICE)
+		: "=r" (ret)
+		: "r" (fun), "r" (a1), "r" (a2), "r" (a3)
+		: "memory"
+		);
+
+	return ret;
+}
+
+static __always_inline long kvm_hypercall4(u64 fid,
+		unsigned long arg0, unsigned long arg1, unsigned long arg2,
+		unsigned long arg3)
+{
+	register long ret asm("a0");
+	register unsigned long fun asm("a0") = fid;
+	register unsigned long a1  asm("a1") = arg0;
+	register unsigned long a2  asm("a2") = arg1;
+	register unsigned long a3  asm("a3") = arg2;
+	register unsigned long a4  asm("a4") = arg3;
+
+	__asm__ __volatile__(
+		"hvcl "__stringify(KVM_HCALL_PV_SERVICE)
+		: "=r" (ret)
+		: "r"(fun), "r" (a1), "r" (a2), "r" (a3), "r" (a4)
+		: "memory"
+		);
+
+	return ret;
+}
+
+static __always_inline long kvm_hypercall5(u64 fid,
+		unsigned long arg0, unsigned long arg1, unsigned long arg2,
+		unsigned long arg3, unsigned long arg4)
+{
+	register long ret asm("a0");
+	register unsigned long fun asm("a0") = fid;
+	register unsigned long a1  asm("a1") = arg0;
+	register unsigned long a2  asm("a2") = arg1;
+	register unsigned long a3  asm("a3") = arg2;
+	register unsigned long a4  asm("a4") = arg3;
+	register unsigned long a5  asm("a5") = arg4;
+
+	__asm__ __volatile__(
+		"hvcl "__stringify(KVM_HCALL_PV_SERVICE)
+		: "=r" (ret)
+		: "r"(fun), "r" (a1), "r" (a2), "r" (a3), "r" (a4), "r" (a5)
+		: "memory"
+		);
+
+	return ret;
+}
+
 static inline unsigned int kvm_arch_para_features(void)
 {
 	return 0;
diff --git a/arch/loongarch/include/asm/kvm_vcpu.h b/arch/loongarch/include/asm/kvm_vcpu.h
index 9f53950959da..de6b17262d8e 100644
--- a/arch/loongarch/include/asm/kvm_vcpu.h
+++ b/arch/loongarch/include/asm/kvm_vcpu.h
@@ -110,4 +110,14 @@ static inline int kvm_queue_exception(struct kvm_vcpu *vcpu,
 		return -1;
 }
 
+static inline unsigned long kvm_read_reg(struct kvm_vcpu *vcpu, int num)
+{
+	return vcpu->arch.gprs[num];
+}
+
+static inline void kvm_write_reg(struct kvm_vcpu *vcpu, int num,
+				unsigned long val)
+{
+	vcpu->arch.gprs[num] = val;
+}
 #endif /* __ASM_LOONGARCH_KVM_VCPU_H__ */
diff --git a/arch/loongarch/include/asm/loongarch.h b/arch/loongarch/include/asm/loongarch.h
index a1d22e8b6f94..0ad36704cb4b 100644
--- a/arch/loongarch/include/asm/loongarch.h
+++ b/arch/loongarch/include/asm/loongarch.h
@@ -167,6 +167,7 @@
 #define CPUCFG_KVM_SIG			CPUCFG_KVM_BASE
 #define  KVM_SIGNATURE			"KVM\0"
 #define CPUCFG_KVM_FEATURE		(CPUCFG_KVM_BASE + 4)
+#define  KVM_FEATURE_PV_IPI		BIT(1)
 
 #ifndef __ASSEMBLY__
 
diff --git a/arch/loongarch/kvm/exit.c b/arch/loongarch/kvm/exit.c
index a8d3b652d3ea..78857147bc14 100644
--- a/arch/loongarch/kvm/exit.c
+++ b/arch/loongarch/kvm/exit.c
@@ -239,6 +239,12 @@ static int kvm_emu_cpucfg(struct kvm_vcpu *vcpu, larch_inst inst)
 		else
 			vcpu->arch.gprs[rd] = 0;
 		break;
+	case CPUCFG_KVM_FEATURE:
+		if ((plv & CSR_CRMD_PLV) == PLV_KERN)
+			vcpu->arch.gprs[rd] = KVM_FEATURE_PV_IPI;
+		else
+			vcpu->arch.gprs[rd] = 0;
+		break;
 	default:
 		vcpu->arch.gprs[rd] = 0;
 		break;
@@ -712,12 +718,78 @@ static int kvm_handle_lasx_disabled(struct kvm_vcpu *vcpu)
 	return RESUME_GUEST;
 }
 
+static int kvm_pv_send_ipi(struct kvm_vcpu *vcpu)
+{
+	unsigned long ipi_bitmap;
+	unsigned int min, cpu, i;
+	struct kvm_vcpu *dest;
+
+	min = kvm_read_reg(vcpu, LOONGARCH_GPR_A3);
+	for (i = 0; i < 2; i++, min += BITS_PER_LONG) {
+		min = kvm_read_reg(vcpu, LOONGARCH_GPR_A1 + i);
+		if (!ipi_bitmap)
+			continue;
+
+		cpu = find_first_bit((void *)&ipi_bitmap, BITS_PER_LONG);
+		while (cpu < BITS_PER_LONG) {
+			dest = kvm_get_vcpu_by_cpuid(vcpu->kvm, cpu + min);
+			cpu = find_next_bit((void *)&ipi_bitmap, BITS_PER_LONG,
+					cpu + 1);
+			if (!dest)
+				continue;
+
+			/*
+			 * Send SWI0 to dest vcpu to emulate IPI interrupt
+			 */
+			kvm_queue_irq(dest, INT_SWI0);
+			kvm_vcpu_kick(dest);
+		}
+	}
+
+	return 0;
+}
+
+/*
+ * hypercall emulation always return to guest, Caller should check retval.
+ */
+static void kvm_handle_pv_service(struct kvm_vcpu *vcpu)
+{
+	unsigned long func = kvm_read_reg(vcpu, LOONGARCH_GPR_A0);
+	long ret;
+
+	switch (func) {
+	case KVM_HCALL_FUNC_PV_IPI:
+		kvm_pv_send_ipi(vcpu);
+		ret = KVM_HCALL_STATUS_SUCCESS;
+		break;
+	default:
+		ret = KVM_HCALL_INVALID_CODE;
+		break;
+	};
+
+	kvm_write_reg(vcpu, LOONGARCH_GPR_A0, ret);
+}
+
 static int kvm_handle_hypercall(struct kvm_vcpu *vcpu)
 {
+	larch_inst inst;
+	unsigned int code;
+
+	inst.word = vcpu->arch.badi;
+	code = inst.reg0i15_format.immediate;
 	update_pc(&vcpu->arch);
 
-	/* Treat it as noop intruction, only set return value */
-	vcpu->arch.gprs[LOONGARCH_GPR_A0] = KVM_HCALL_INVALID_CODE;
+	switch (code) {
+	case KVM_HCALL_PV_SERVICE:
+		vcpu->stat.hypercall_exits++;
+		kvm_handle_pv_service(vcpu);
+		break;
+	default:
+		/* Treat it as noop intruction, only set return value */
+		kvm_write_reg(vcpu, LOONGARCH_GPR_A0, KVM_HCALL_INVALID_CODE);
+		break;
+	}
+
 	return RESUME_GUEST;
 }
 
diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
index a1a1dc4a3cf2..5a4b0db9c36f 100644
--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -19,6 +19,7 @@ const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
 	STATS_DESC_COUNTER(VCPU, idle_exits),
 	STATS_DESC_COUNTER(VCPU, cpucfg_exits),
 	STATS_DESC_COUNTER(VCPU, signal_exits),
+	STATS_DESC_COUNTER(VCPU, hypercall_exits)
 };
 
 const struct kvm_stats_header kvm_vcpu_stats_header = {
-- 
2.39.3


