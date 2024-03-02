Return-Path: <kvm+bounces-10705-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 710A786EF5B
	for <lists+kvm@lfdr.de>; Sat,  2 Mar 2024 08:52:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 27C96282273
	for <lists+kvm@lfdr.de>; Sat,  2 Mar 2024 07:52:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86C1C1799E;
	Sat,  2 Mar 2024 07:51:28 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3561125AC;
	Sat,  2 Mar 2024 07:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709365887; cv=none; b=OTtOiIXpyd6HIKMzrgjmLbpwdW+qRf0LSUEx/t2OwOAUTQMtAg2kiu7gE40QghRAYhk+jQLXycCKXNOmrBZUEnxdZnRyeeM2GB8X3jGJMOZC1rOqlyB8OjE70sHyXAt32Mrf9VwZJk+ThlM4hLksP+JAhSCXD52wlBlLB0g6DVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709365887; c=relaxed/simple;
	bh=jL1Y5Rf0DpIO2PgtH24jYFKN2AV9dJqQDRYDr/6rsUw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=am68t2KPoLsF2HrzuLWsbCL7cxJjzbmKtb+o3RVx7COzYWkdcIdj0ETthVFga6+ar7Mwaq40FGwolvuNNCTTvFMDjjwbD+Te5no1tOs2I4lhZZsrMGxDMCy2SddL09pGYdz82JjzTsjMfzgYXiKWCXppbd618Rsf4dF/CBlIcpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8AxDOt72uJlfoYTAA--.39525S3;
	Sat, 02 Mar 2024 15:51:23 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8CxrhN42uJlLU9MAA--.16478S5;
	Sat, 02 Mar 2024 15:51:22 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Huacai Chen <chenhuacai@kernel.org>,
	Tianrui Zhao <zhaotianrui@loongson.cn>,
	Juergen Gross <jgross@suse.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>
Cc: loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	virtualization@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-doc@vger.kernel.org
Subject: [PATCH v6 3/7] LoongArch: KVM: Add cpucfg area for kvm hypervisor
Date: Sat,  2 Mar 2024 15:51:16 +0800
Message-Id: <20240302075120.1414999-4-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20240302075120.1414999-1-maobibo@loongson.cn>
References: <20240302075120.1414999-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8CxrhN42uJlLU9MAA--.16478S5
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoWxGr13ZF15ZryftrW5WF48uFX_yoWrWF17pF
	Z3urykWr48GryfA39rtrZ8Ww15uF4kGr12qFW3J3yUCF4UXryrAr4vkrWDAFyDKws5C3WI
	qF15tr1aqF4DAabCm3ZEXasCq-sJn29KB7ZKAUJUUUU7529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUB2b4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1a6r1DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6r4UJVWxJr1ln4kS14v26r1Y6r17M2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12
	xvs2x26I8E6xACxx1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1q
	6rW5McIj6I8E87Iv67AKxVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64
	vIr41lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_
	Jr0_Gr1l4IxYO2xFxVAFwI0_Jrv_JF1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8Gjc
	xK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0
	cI8IcVAFwI0_Xr0_Ar1lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8V
	AvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWxJwCI42IY6I8E87Iv6xkF7I0E
	14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUwBMKDUUUU

Instruction cpucfg can be used to get processor features. And there
is trap exception when it is executed in VM mode, and also it is
to provide cpu features to VM. On real hardware cpucfg area 0 - 20
is used.  Here one specified area 0x40000000 -- 0x400000ff is used
for KVM hypervisor to privide PV features, and the area can be extended
for other hypervisors in future. This area will never be used for
real HW, it is only used by software.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/include/asm/inst.h      |  1 +
 arch/loongarch/include/asm/loongarch.h | 10 +++++
 arch/loongarch/kvm/exit.c              | 59 +++++++++++++++++++-------
 3 files changed, 54 insertions(+), 16 deletions(-)

diff --git a/arch/loongarch/include/asm/inst.h b/arch/loongarch/include/asm/inst.h
index d8f637f9e400..ad120f924905 100644
--- a/arch/loongarch/include/asm/inst.h
+++ b/arch/loongarch/include/asm/inst.h
@@ -67,6 +67,7 @@ enum reg2_op {
 	revhd_op	= 0x11,
 	extwh_op	= 0x16,
 	extwb_op	= 0x17,
+	cpucfg_op	= 0x1b,
 	iocsrrdb_op     = 0x19200,
 	iocsrrdh_op     = 0x19201,
 	iocsrrdw_op     = 0x19202,
diff --git a/arch/loongarch/include/asm/loongarch.h b/arch/loongarch/include/asm/loongarch.h
index 46366e783c84..a1d22e8b6f94 100644
--- a/arch/loongarch/include/asm/loongarch.h
+++ b/arch/loongarch/include/asm/loongarch.h
@@ -158,6 +158,16 @@
 #define  CPUCFG48_VFPU_CG		BIT(2)
 #define  CPUCFG48_RAM_CG		BIT(3)
 
+/*
+ * cpucfg index area: 0x40000000 -- 0x400000ff
+ * SW emulation for KVM hypervirsor
+ */
+#define CPUCFG_KVM_BASE			0x40000000UL
+#define CPUCFG_KVM_SIZE			0x100
+#define CPUCFG_KVM_SIG			CPUCFG_KVM_BASE
+#define  KVM_SIGNATURE			"KVM\0"
+#define CPUCFG_KVM_FEATURE		(CPUCFG_KVM_BASE + 4)
+
 #ifndef __ASSEMBLY__
 
 /* CSR */
diff --git a/arch/loongarch/kvm/exit.c b/arch/loongarch/kvm/exit.c
index 923bbca9bd22..a8d3b652d3ea 100644
--- a/arch/loongarch/kvm/exit.c
+++ b/arch/loongarch/kvm/exit.c
@@ -206,10 +206,50 @@ int kvm_emu_idle(struct kvm_vcpu *vcpu)
 	return EMULATE_DONE;
 }
 
-static int kvm_trap_handle_gspr(struct kvm_vcpu *vcpu)
+static int kvm_emu_cpucfg(struct kvm_vcpu *vcpu, larch_inst inst)
 {
 	int rd, rj;
 	unsigned int index;
+	unsigned long plv;
+
+	rd = inst.reg2_format.rd;
+	rj = inst.reg2_format.rj;
+	++vcpu->stat.cpucfg_exits;
+	index = vcpu->arch.gprs[rj];
+
+	/*
+	 * By LoongArch Reference Manual 2.2.10.5
+	 * Return value is 0 for undefined cpucfg index
+	 *
+	 * Disable preemption since hw gcsr is accessed
+	 */
+	preempt_disable();
+	plv = kvm_read_hw_gcsr(LOONGARCH_CSR_CRMD) >> CSR_CRMD_PLV_SHIFT;
+	switch (index) {
+	case 0 ... (KVM_MAX_CPUCFG_REGS - 1):
+		vcpu->arch.gprs[rd] = vcpu->arch.cpucfg[index];
+		break;
+	case CPUCFG_KVM_SIG:
+		/*
+		 * Cpucfg emulation between 0x40000000 -- 0x400000ff
+		 * Return value with 0 if executed in user mode
+		 */
+		if ((plv & CSR_CRMD_PLV) == PLV_KERN)
+			vcpu->arch.gprs[rd] = *(unsigned int *)KVM_SIGNATURE;
+		else
+			vcpu->arch.gprs[rd] = 0;
+		break;
+	default:
+		vcpu->arch.gprs[rd] = 0;
+		break;
+	}
+
+	preempt_enable();
+	return EMULATE_DONE;
+}
+
+static int kvm_trap_handle_gspr(struct kvm_vcpu *vcpu)
+{
 	unsigned long curr_pc;
 	larch_inst inst;
 	enum emulation_result er = EMULATE_DONE;
@@ -224,21 +264,8 @@ static int kvm_trap_handle_gspr(struct kvm_vcpu *vcpu)
 	er = EMULATE_FAIL;
 	switch (((inst.word >> 24) & 0xff)) {
 	case 0x0: /* CPUCFG GSPR */
-		if (inst.reg2_format.opcode == 0x1B) {
-			rd = inst.reg2_format.rd;
-			rj = inst.reg2_format.rj;
-			++vcpu->stat.cpucfg_exits;
-			index = vcpu->arch.gprs[rj];
-			er = EMULATE_DONE;
-			/*
-			 * By LoongArch Reference Manual 2.2.10.5
-			 * return value is 0 for undefined cpucfg index
-			 */
-			if (index < KVM_MAX_CPUCFG_REGS)
-				vcpu->arch.gprs[rd] = vcpu->arch.cpucfg[index];
-			else
-				vcpu->arch.gprs[rd] = 0;
-		}
+		if (inst.reg2_format.opcode == cpucfg_op)
+			er = kvm_emu_cpucfg(vcpu, inst);
 		break;
 	case 0x4: /* CSR{RD,WR,XCHG} GSPR */
 		er = kvm_handle_csr(vcpu, inst);
-- 
2.39.3


