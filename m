Return-Path: <kvm+bounces-5506-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C89C8228DD
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 08:18:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 30C921F238CC
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 07:18:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B95118C15;
	Wed,  3 Jan 2024 07:16:28 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B83291805E;
	Wed,  3 Jan 2024 07:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8DxzvDACZVlwXIBAA--.5764S3;
	Wed, 03 Jan 2024 15:16:16 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8Dxqb2_CZVlm1EYAA--.43800S4;
	Wed, 03 Jan 2024 15:16:16 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Huacai Chen <chenhuacai@kernel.org>,
	Tianrui Zhao <zhaotianrui@loongson.cn>,
	Juergen Gross <jgross@suse.com>
Cc: loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	virtualization@lists.linux.dev,
	kvm@vger.kernel.org
Subject: [PATCH 2/5] LoongArch: KVM: Add cpucfg area for kvm hypervisor
Date: Wed,  3 Jan 2024 15:16:12 +0800
Message-Id: <20240103071615.3422264-3-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20240103071615.3422264-1-maobibo@loongson.cn>
References: <20240103071615.3422264-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8Dxqb2_CZVlm1EYAA--.43800S4
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoWxCw4rCw47Cr1kWw1rKFy5ZFc_yoW5tw4fpF
	ZrZrn5Wr48GryfA3y7t3yUWrs8ZF4kGr12qFW3t3y8CF47XryUJr4vkrZFyFyDKws5Ca4I
	qF15tr13XF4jyabCm3ZEXasCq-sJn29KB7ZKAUJUUUUr529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUU9Fb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1q6r4UM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
	xVW8Jr0_Cr1UM2kKe7AKxVWUXVWUAwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07
	AIYIkI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWU
	tVWrXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7V
	AKI48JMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMxCIbckI1I0E14v2
	6r1Y6r17MI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17
	CEb7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1I6r4UMIIF
	0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIx
	AIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2
	KfnxnUUI43ZEXa7IUbByIUUUUUU==

System will trap into hypervisor when executing cpucfg instruction.
And now hardware only uses the area 0 - 20 for actual usage, here
one specified area 0x10000000 -- 0x100000ff is used for KVM hypervisor,
and the area can be extended for other hypervisors in future.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/include/asm/inst.h      |  1 +
 arch/loongarch/include/asm/loongarch.h |  9 +++++
 arch/loongarch/kvm/exit.c              | 46 +++++++++++++++++---------
 3 files changed, 40 insertions(+), 16 deletions(-)

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
index 46366e783c84..a03b466555a1 100644
--- a/arch/loongarch/include/asm/loongarch.h
+++ b/arch/loongarch/include/asm/loongarch.h
@@ -158,6 +158,15 @@
 #define  CPUCFG48_VFPU_CG		BIT(2)
 #define  CPUCFG48_RAM_CG		BIT(3)
 
+/*
+ * cpucfg index area: 0x10000000 -- 0x100000ff
+ * SW emulation for KVM hypervirsor
+ */
+#define CPUCFG_KVM_BASE			0x10000000UL
+#define CPUCFG_KVM_SIZE			0x100
+#define CPUCFG_KVM_SIG			CPUCFG_KVM_BASE
+#define  KVM_SIGNATURE			"KVM\0"
+#define CPUCFG_KVM_FEATURE		(CPUCFG_KVM_BASE + 4)
 #ifndef __ASSEMBLY__
 
 /* CSR */
diff --git a/arch/loongarch/kvm/exit.c b/arch/loongarch/kvm/exit.c
index 59e5fe221982..e233d7b3b76d 100644
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


