Return-Path: <kvm+bounces-7655-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7195F844F8A
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 04:20:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A42EA1C221D7
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 03:20:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 814463C6BC;
	Thu,  1 Feb 2024 03:19:57 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 456493A8C2;
	Thu,  1 Feb 2024 03:19:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706757596; cv=none; b=Hyw71VgrB/9qBinOHGOVoN/1p79BknHp++TVgMnNwTGHkC3zm407mANSqBhNbjAfFQAVQsBdNsVjeZs/BgMlDYIppV8hgwJgirfrcMaCV0/PiQxpNa2zHngmw4PP3D/qu9TAjR18ZQFHej6sS/MC46snjW8yJcFJXW2MB20Zpuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706757596; c=relaxed/simple;
	bh=PR16WBwRzEEhK27HnAdP8Fg/tYlVVaH3zxKK/KTXb1c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RSag2xbLHWpUo8iGwnLtMjnKDz8GX/uqCYn09i2SYwRu4J0+kuqgol3X6AIMOey00SEz1w7tfiEuMnCGYT0Odzb7kJfiYTUiEnxfhDT0lfGqoaI3nY3KfoSMEru8l2VAn0myYDd+6DuFccDReKMzHDyrLD0Gbv/W6fqolRA7Ty4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8CxLOvYDbtlO1QJAA--.17443S3;
	Thu, 01 Feb 2024 11:19:52 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8DxfRPWDbtltkIrAA--.3273S5;
	Thu, 01 Feb 2024 11:19:52 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Huacai Chen <chenhuacai@kernel.org>,
	Tianrui Zhao <zhaotianrui@loongson.cn>,
	Juergen Gross <jgross@suse.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	virtualization@lists.linux.dev,
	kvm@vger.kernel.org
Subject: [PATCH v4 3/6] LoongArch: KVM: Add cpucfg area for kvm hypervisor
Date: Thu,  1 Feb 2024 11:19:47 +0800
Message-Id: <20240201031950.3225626-4-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20240201031950.3225626-1-maobibo@loongson.cn>
References: <20240201031950.3225626-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8DxfRPWDbtltkIrAA--.3273S5
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoWxGF17Zr4xtw4rtw4DKFWDWrX_yoW5Kr18pF
	ZrZrn5Wr48GryfA39rt3yUWrs8uF4kGr12qFW3t3y8CF47XryUXr4vkrZFyFyDKws5C3WI
	qF15tr1aqF4DAabCm3ZEXasCq-sJn29KB7ZKAUJUUUU7529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUBIb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVCY1x0267AK
	xVW8Jr0_Cr1UM2kKe7AKxVWUXVWUAwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07
	AIYIkI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWU
	tVWrXwAv7VC2z280aVAFwI0_Gr0_Cr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7V
	AKI48JMxkF7I0En4kS14v26r126r1DMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY
	6r1j6r4UMxCIbckI1I0E14v26r1Y6r17MI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7
	xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xII
	jxv20xvE14v26r4j6ryUMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw2
	0EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x02
	67AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU0epB3UUUUU==

VM will trap into hypervisor when executing cpucfg instruction. And
hardware only uses the area 0 - 20 for actual usage now, here one
specified area 0x40000000 -- 0x400000ff is used for KVM hypervisor,
and the area can be extended to use for other hypervisors in future.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/include/asm/inst.h      |  1 +
 arch/loongarch/include/asm/loongarch.h | 10 ++++++
 arch/loongarch/kvm/exit.c              | 46 +++++++++++++++++---------
 3 files changed, 41 insertions(+), 16 deletions(-)

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
index d15c71320a11..f4e4df05f578 100644
--- a/arch/loongarch/kvm/exit.c
+++ b/arch/loongarch/kvm/exit.c
@@ -206,10 +206,37 @@ int kvm_emu_idle(struct kvm_vcpu *vcpu)
 	return EMULATE_DONE;
 }
 
-static int kvm_trap_handle_gspr(struct kvm_vcpu *vcpu)
+static int kvm_emu_cpucfg(struct kvm_vcpu *vcpu, larch_inst inst)
 {
 	int rd, rj;
 	unsigned int index;
+
+	rd = inst.reg2_format.rd;
+	rj = inst.reg2_format.rj;
+	++vcpu->stat.cpucfg_exits;
+	index = vcpu->arch.gprs[rj];
+
+	/*
+	 * By LoongArch Reference Manual 2.2.10.5
+	 * Return value is 0 for undefined cpucfg index
+	 */
+	switch (index) {
+	case 0 ... (KVM_MAX_CPUCFG_REGS - 1):
+		vcpu->arch.gprs[rd] = vcpu->arch.cpucfg[index];
+		break;
+	case CPUCFG_KVM_SIG:
+		vcpu->arch.gprs[rd] = *(unsigned int *)KVM_SIGNATURE;
+		break;
+	default:
+		vcpu->arch.gprs[rd] = 0;
+		break;
+	}
+
+	return EMULATE_DONE;
+}
+
+static int kvm_trap_handle_gspr(struct kvm_vcpu *vcpu)
+{
 	unsigned long curr_pc;
 	larch_inst inst;
 	enum emulation_result er = EMULATE_DONE;
@@ -224,21 +251,8 @@ static int kvm_trap_handle_gspr(struct kvm_vcpu *vcpu)
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


