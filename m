Return-Path: <kvm+bounces-1809-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 80DE77EBF87
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 10:32:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 957EF1C20A6E
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 09:32:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EA63BA39;
	Wed, 15 Nov 2023 09:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E78D66AD6
	for <kvm@vger.kernel.org>; Wed, 15 Nov 2023 09:32:25 +0000 (UTC)
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id 949839B;
	Wed, 15 Nov 2023 01:32:23 -0800 (PST)
Received: from loongson.cn (unknown [10.2.5.185])
	by gateway (Coremail) with SMTP id _____8Cx77skkFRlYzw6AA--.55441S3;
	Wed, 15 Nov 2023 17:32:20 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8Bx7twhkFRlq99CAA--.16093S3;
	Wed, 15 Nov 2023 17:32:18 +0800 (CST)
From: Tianrui Zhao <zhaotianrui@loongson.cn>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	loongarch@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Mark Brown <broonie@kernel.org>,
	Alex Deucher <alexander.deucher@amd.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	maobibo@loongson.cn,
	Xi Ruoyao <xry111@xry111.site>,
	zhaotianrui@loongson.cn
Subject: [PATCH v1 1/2] LoongArch: KVM: Add lsx support
Date: Wed, 15 Nov 2023 17:19:20 +0800
Message-Id: <20231115091921.85516-2-zhaotianrui@loongson.cn>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20231115091921.85516-1-zhaotianrui@loongson.cn>
References: <20231115091921.85516-1-zhaotianrui@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8Bx7twhkFRlq99CAA--.16093S3
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

This patch adds LSX support for LoongArch KVM. The LSX means
LoongArch 128-bits vector instruction.
There will be LSX exception in KVM when guest use the LSX
instruction. KVM will enable LSX and restore the vector
registers for guest then return to guest to continue running.


Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
---
 arch/loongarch/include/asm/kvm_host.h |  6 ++++
 arch/loongarch/include/asm/kvm_vcpu.h | 12 +++++++
 arch/loongarch/kvm/exit.c             | 18 ++++++++++
 arch/loongarch/kvm/switch.S           | 22 +++++++++++++
 arch/loongarch/kvm/trace.h            |  4 ++-
 arch/loongarch/kvm/vcpu.c             | 47 +++++++++++++++++++++++++--
 6 files changed, 105 insertions(+), 4 deletions(-)

diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/include/asm/kvm_host.h
index 11328700d4..6c65c25169 100644
--- a/arch/loongarch/include/asm/kvm_host.h
+++ b/arch/loongarch/include/asm/kvm_host.h
@@ -94,6 +94,7 @@ enum emulation_result {
 #define KVM_LARCH_FPU		(0x1 << 0)
 #define KVM_LARCH_SWCSR_LATEST	(0x1 << 1)
 #define KVM_LARCH_HWCSR_USABLE	(0x1 << 2)
+#define KVM_LARCH_LSX		(0x1 << 3)
 
 struct kvm_vcpu_arch {
 	/*
@@ -175,6 +176,11 @@ static inline void writel_sw_gcsr(struct loongarch_csrs *csr, int reg, unsigned
 	csr->csrs[reg] = val;
 }
 
+static inline bool kvm_guest_has_lsx(struct kvm_vcpu_arch *arch)
+{
+	return arch->cpucfg[2] & CPUCFG2_LSX;
+}
+
 /* Debug: dump vcpu state */
 int kvm_arch_vcpu_dump_regs(struct kvm_vcpu *vcpu);
 
diff --git a/arch/loongarch/include/asm/kvm_vcpu.h b/arch/loongarch/include/asm/kvm_vcpu.h
index 553cfa2b2b..c629771e12 100644
--- a/arch/loongarch/include/asm/kvm_vcpu.h
+++ b/arch/loongarch/include/asm/kvm_vcpu.h
@@ -55,6 +55,18 @@ void kvm_save_fpu(struct loongarch_fpu *fpu);
 void kvm_restore_fpu(struct loongarch_fpu *fpu);
 void kvm_restore_fcsr(struct loongarch_fpu *fpu);
 
+#ifdef CONFIG_CPU_HAS_LSX
+void kvm_own_lsx(struct kvm_vcpu *vcpu);
+void kvm_save_lsx(struct loongarch_fpu *fpu);
+void kvm_restore_lsx(struct loongarch_fpu *fpu);
+void kvm_restore_lsx_upper(struct loongarch_fpu *fpu);
+#else
+static inline void kvm_own_lsx(struct kvm_vcpu *vcpu) { }
+static inline void kvm_save_lsx(struct loongarch_fpu *fpu) { }
+static inline void kvm_restore_lsx(struct loongarch_fpu *fpu) { }
+static inline void kvm_restore_lsx_upper(struct loongarch_fpu *fpu) { }
+#endif
+
 void kvm_acquire_timer(struct kvm_vcpu *vcpu);
 void kvm_init_timer(struct kvm_vcpu *vcpu, unsigned long hz);
 void kvm_reset_timer(struct kvm_vcpu *vcpu);
diff --git a/arch/loongarch/kvm/exit.c b/arch/loongarch/kvm/exit.c
index ce8de3fa47..1b1c58ccc8 100644
--- a/arch/loongarch/kvm/exit.c
+++ b/arch/loongarch/kvm/exit.c
@@ -659,6 +659,23 @@ static int kvm_handle_fpu_disabled(struct kvm_vcpu *vcpu)
 	return RESUME_GUEST;
 }
 
+/*
+ * kvm_handle_lsx_disabled() - Guest used LSX while disabled in root.
+ * @vcpu:      Virtual CPU context.
+ *
+ * Handle when the guest attempts to use LSX when it is disabled in the root
+ * context.
+ */
+static int kvm_handle_lsx_disabled(struct kvm_vcpu *vcpu)
+{
+	if (!kvm_guest_has_lsx(&vcpu->arch))
+		kvm_queue_exception(vcpu, EXCCODE_INE, 0);
+	else
+		kvm_own_lsx(vcpu);
+
+	return RESUME_GUEST;
+}
+
 /*
  * LoongArch KVM callback handling for unimplemented guest exiting
  */
@@ -687,6 +704,7 @@ static exit_handle_fn kvm_fault_tables[EXCCODE_INT_START] = {
 	[EXCCODE_TLBS]			= kvm_handle_write_fault,
 	[EXCCODE_TLBM]			= kvm_handle_write_fault,
 	[EXCCODE_FPDIS]			= kvm_handle_fpu_disabled,
+	[EXCCODE_LSXDIS]                = kvm_handle_lsx_disabled,
 	[EXCCODE_GSPR]			= kvm_handle_gspr,
 };
 
diff --git a/arch/loongarch/kvm/switch.S b/arch/loongarch/kvm/switch.S
index 0ed9040307..32ba092a44 100644
--- a/arch/loongarch/kvm/switch.S
+++ b/arch/loongarch/kvm/switch.S
@@ -245,6 +245,28 @@ SYM_FUNC_START(kvm_restore_fpu)
 	jr                 ra
 SYM_FUNC_END(kvm_restore_fpu)
 
+#ifdef CONFIG_CPU_HAS_LSX
+SYM_FUNC_START(kvm_save_lsx)
+	fpu_save_csr    a0 t1
+	fpu_save_cc     a0 t1 t2
+	lsx_save_data   a0 t1
+	jirl            zero, ra, 0
+SYM_FUNC_END(kvm_save_lsx)
+
+SYM_FUNC_START(kvm_restore_lsx)
+	lsx_restore_data a0 t1
+	fpu_restore_cc   a0 t1 t2
+	fpu_restore_csr  a0 t1
+	jirl             zero, ra, 0
+SYM_FUNC_END(kvm_restore_lsx)
+
+SYM_FUNC_START(kvm_restore_lsx_upper)
+	lsx_restore_all_upper a0 t0 t1
+
+	jirl                  zero, ra, 0
+SYM_FUNC_END(kvm_restore_lsx_upper)
+#endif
+
 	.section ".rodata"
 SYM_DATA(kvm_exception_size, .quad kvm_exc_entry_end - kvm_exc_entry)
 SYM_DATA(kvm_enter_guest_size, .quad kvm_enter_guest_end - kvm_enter_guest)
diff --git a/arch/loongarch/kvm/trace.h b/arch/loongarch/kvm/trace.h
index a1e35d6554..7da4e230e8 100644
--- a/arch/loongarch/kvm/trace.h
+++ b/arch/loongarch/kvm/trace.h
@@ -102,6 +102,7 @@ TRACE_EVENT(kvm_exit_gspr,
 #define KVM_TRACE_AUX_DISCARD		4
 
 #define KVM_TRACE_AUX_FPU		1
+#define KVM_TRACE_AUX_LSX		2
 
 #define kvm_trace_symbol_aux_op				\
 	{ KVM_TRACE_AUX_SAVE,		"save" },	\
@@ -111,7 +112,8 @@ TRACE_EVENT(kvm_exit_gspr,
 	{ KVM_TRACE_AUX_DISCARD,	"discard" }
 
 #define kvm_trace_symbol_aux_state			\
-	{ KVM_TRACE_AUX_FPU,     "FPU" }
+	{ KVM_TRACE_AUX_FPU,     "FPU" },		\
+	{ KVM_TRACE_AUX_LSX,     "LSX" }
 
 TRACE_EVENT(kvm_aux,
 	    TP_PROTO(struct kvm_vcpu *vcpu, unsigned int op,
diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
index 73d0c2b9c1..f0bb583353 100644
--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -378,9 +378,13 @@ static int kvm_set_one_reg(struct kvm_vcpu *vcpu,
 		break;
 	case KVM_REG_LOONGARCH_CPUCFG:
 		id = KVM_GET_IOC_CPUCFG_IDX(reg->id);
-		if (id >= 0 && id < KVM_MAX_CPUCFG_REGS)
+		if (id >= 0 && id < KVM_MAX_CPUCFG_REGS) {
 			vcpu->arch.cpucfg[id] = (u32)v;
-		else
+			if (id == 2 && v & CPUCFG2_LSX && !cpu_has_lsx) {
+				vcpu->arch.cpucfg[id] &= ~CPUCFG2_LSX;
+				ret = -EINVAL;
+			}
+		} else
 			ret = -EINVAL;
 		break;
 	case KVM_REG_LOONGARCH_KVM:
@@ -561,12 +565,49 @@ void kvm_own_fpu(struct kvm_vcpu *vcpu)
 	preempt_enable();
 }
 
+#ifdef CONFIG_CPU_HAS_LSX
+/* Enable LSX for guest and restore context */
+void kvm_own_lsx(struct kvm_vcpu *vcpu)
+{
+	preempt_disable();
+
+	/* Enable LSX for guest */
+	set_csr_euen(CSR_EUEN_LSXEN | CSR_EUEN_FPEN);
+	switch (vcpu->arch.aux_inuse & KVM_LARCH_FPU) {
+	case KVM_LARCH_FPU:
+		/*
+		 * Guest FPU state already loaded,
+		 * only restore upper LSX state
+		 */
+		kvm_restore_lsx_upper(&vcpu->arch.fpu);
+		break;
+	default:
+		/* Neither FP or LSX already active,
+		 * restore full LSX state
+		 */
+		kvm_restore_lsx(&vcpu->arch.fpu);
+	break;
+	}
+
+	trace_kvm_aux(vcpu, KVM_TRACE_AUX_RESTORE, KVM_TRACE_AUX_LSX);
+	vcpu->arch.aux_inuse |= KVM_LARCH_LSX | KVM_LARCH_FPU;
+	preempt_enable();
+}
+#endif
+
 /* Save context and disable FPU */
 void kvm_lose_fpu(struct kvm_vcpu *vcpu)
 {
 	preempt_disable();
 
-	if (vcpu->arch.aux_inuse & KVM_LARCH_FPU) {
+	if (vcpu->arch.aux_inuse & KVM_LARCH_LSX) {
+		kvm_save_lsx(&vcpu->arch.fpu);
+		vcpu->arch.aux_inuse &= ~(KVM_LARCH_LSX | KVM_LARCH_FPU);
+		trace_kvm_aux(vcpu, KVM_TRACE_AUX_SAVE, KVM_TRACE_AUX_LSX);
+
+		/* Disable LSX & FPU */
+		clear_csr_euen(CSR_EUEN_FPEN | CSR_EUEN_LSXEN);
+	} else if (vcpu->arch.aux_inuse & KVM_LARCH_FPU) {
 		kvm_save_fpu(&vcpu->arch.fpu);
 		vcpu->arch.aux_inuse &= ~KVM_LARCH_FPU;
 		trace_kvm_aux(vcpu, KVM_TRACE_AUX_SAVE, KVM_TRACE_AUX_FPU);
-- 
2.39.1


