Return-Path: <kvm+bounces-3888-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 71EC38098BA
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 02:45:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E358FB20E93
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 01:45:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16BA71FB3;
	Fri,  8 Dec 2023 01:44:59 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id A31141720;
	Thu,  7 Dec 2023 17:44:50 -0800 (PST)
Received: from loongson.cn (unknown [10.2.5.185])
	by gateway (Coremail) with SMTP id _____8Bxd+gQdXJlSNg_AA--.26032S3;
	Fri, 08 Dec 2023 09:44:48 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8Ax3twNdXJlUvVXAA--.62660S3;
	Fri, 08 Dec 2023 09:44:46 +0800 (CST)
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
	zhaotianrui@loongson.cn
Subject: [PATCH v3 1/2] LoongArch: KVM: Add LSX support
Date: Fri,  8 Dec 2023 09:31:50 +0800
Message-Id: <20231208013151.2668156-2-zhaotianrui@loongson.cn>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20231208013151.2668156-1-zhaotianrui@loongson.cn>
References: <20231208013151.2668156-1-zhaotianrui@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8Ax3twNdXJlUvVXAA--.62660S3
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

This patch adds LSX support for LoongArch KVM.
There will be LSX exception in KVM when guest use the LSX
instruction. KVM will enable LSX and restore the vector
registers for guest then return to guest to continue running.

Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
---
 arch/loongarch/include/asm/kvm_host.h |  11 ++
 arch/loongarch/include/asm/kvm_vcpu.h |  12 ++
 arch/loongarch/include/uapi/asm/kvm.h |   1 +
 arch/loongarch/kvm/exit.c             |  23 +++
 arch/loongarch/kvm/switch.S           |  21 +++
 arch/loongarch/kvm/trace.h            |   4 +-
 arch/loongarch/kvm/vcpu.c             | 201 +++++++++++++++++++++++++-
 7 files changed, 267 insertions(+), 6 deletions(-)

diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/include/asm/kvm_host.h
index 11328700d4..b5fd55f6d0 100644
--- a/arch/loongarch/include/asm/kvm_host.h
+++ b/arch/loongarch/include/asm/kvm_host.h
@@ -94,6 +94,7 @@ enum emulation_result {
 #define KVM_LARCH_FPU		(0x1 << 0)
 #define KVM_LARCH_SWCSR_LATEST	(0x1 << 1)
 #define KVM_LARCH_HWCSR_USABLE	(0x1 << 2)
+#define KVM_LARCH_LSX		(0x1 << 3)
 
 struct kvm_vcpu_arch {
 	/*
@@ -175,6 +176,16 @@ static inline void writel_sw_gcsr(struct loongarch_csrs *csr, int reg, unsigned
 	csr->csrs[reg] = val;
 }
 
+static inline bool kvm_guest_has_lsx(struct kvm_vcpu_arch *arch)
+{
+	return arch->cpucfg[2] & CPUCFG2_LSX;
+}
+
+static inline bool kvm_guest_has_fpu(struct kvm_vcpu_arch *arch)
+{
+	return arch->cpucfg[2] & CPUCFG2_FP;
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
diff --git a/arch/loongarch/include/uapi/asm/kvm.h b/arch/loongarch/include/uapi/asm/kvm.h
index c6ad2ee610..923d0bd382 100644
--- a/arch/loongarch/include/uapi/asm/kvm.h
+++ b/arch/loongarch/include/uapi/asm/kvm.h
@@ -79,6 +79,7 @@ struct kvm_fpu {
 #define LOONGARCH_REG_64(TYPE, REG)	(TYPE | KVM_REG_SIZE_U64 | (REG << LOONGARCH_REG_SHIFT))
 #define KVM_IOC_CSRID(REG)		LOONGARCH_REG_64(KVM_REG_LOONGARCH_CSR, REG)
 #define KVM_IOC_CPUCFG(REG)		LOONGARCH_REG_64(KVM_REG_LOONGARCH_CPUCFG, REG)
+#define KVM_LOONGARCH_VCPU_CPUCFG	0
 
 struct kvm_debug_exit_arch {
 };
diff --git a/arch/loongarch/kvm/exit.c b/arch/loongarch/kvm/exit.c
index ce8de3fa47..e40409ba76 100644
--- a/arch/loongarch/kvm/exit.c
+++ b/arch/loongarch/kvm/exit.c
@@ -643,6 +643,11 @@ static int kvm_handle_fpu_disabled(struct kvm_vcpu *vcpu)
 {
 	struct kvm_run *run = vcpu->run;
 
+	if (!kvm_guest_has_fpu(&vcpu->arch)) {
+		kvm_queue_exception(vcpu, EXCCODE_INE, 0);
+		return RESUME_GUEST;
+	}
+
 	/*
 	 * If guest FPU not present, the FPU operation should have been
 	 * treated as a reserved instruction!
@@ -659,6 +664,23 @@ static int kvm_handle_fpu_disabled(struct kvm_vcpu *vcpu)
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
@@ -687,6 +709,7 @@ static exit_handle_fn kvm_fault_tables[EXCCODE_INT_START] = {
 	[EXCCODE_TLBS]			= kvm_handle_write_fault,
 	[EXCCODE_TLBM]			= kvm_handle_write_fault,
 	[EXCCODE_FPDIS]			= kvm_handle_fpu_disabled,
+	[EXCCODE_LSXDIS]                = kvm_handle_lsx_disabled,
 	[EXCCODE_GSPR]			= kvm_handle_gspr,
 };
 
diff --git a/arch/loongarch/kvm/switch.S b/arch/loongarch/kvm/switch.S
index 0ed9040307..6c48f7d1ca 100644
--- a/arch/loongarch/kvm/switch.S
+++ b/arch/loongarch/kvm/switch.S
@@ -245,6 +245,27 @@ SYM_FUNC_START(kvm_restore_fpu)
 	jr                 ra
 SYM_FUNC_END(kvm_restore_fpu)
 
+#ifdef CONFIG_CPU_HAS_LSX
+SYM_FUNC_START(kvm_save_lsx)
+	fpu_save_csr    a0 t1
+	fpu_save_cc     a0 t1 t2
+	lsx_save_data   a0 t1
+	jr              ra
+SYM_FUNC_END(kvm_save_lsx)
+
+SYM_FUNC_START(kvm_restore_lsx)
+	lsx_restore_data a0 t1
+	fpu_restore_cc   a0 t1 t2
+	fpu_restore_csr  a0 t1 t2
+	jr               ra
+SYM_FUNC_END(kvm_restore_lsx)
+
+SYM_FUNC_START(kvm_restore_lsx_upper)
+	lsx_restore_all_upper a0 t0 t1
+	jr                    ra
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
index 73d0c2b9c1..3c2ee202d2 100644
--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -309,6 +309,33 @@ static int _kvm_setcsr(struct kvm_vcpu *vcpu, unsigned int id, u64 val)
 	return ret;
 }
 
+static int _kvm_loongarch_get_cpucfg_attr(int id, u64 *v)
+{
+	int ret = 0;
+
+	if (id < 0 && id >= KVM_MAX_CPUCFG_REGS)
+		return -EINVAL;
+
+	switch (id) {
+	case 2:
+		/* return CPUCFG2 features which have been supported by KVM */
+		*v = CPUCFG2_FP     | CPUCFG2_FPSP  | CPUCFG2_FPDP     |
+		     CPUCFG2_FPVERS | CPUCFG2_LLFTP | CPUCFG2_LLFTPREV |
+		     CPUCFG2_LAM;
+		/*
+		 * if LSX is supported by CPU, it is also supported by KVM,
+		 * as we implement it.
+		 */
+		if (cpu_has_lsx)
+			*v |= CPUCFG2_LSX;
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+	return ret;
+}
+
 static int kvm_get_one_reg(struct kvm_vcpu *vcpu,
 		const struct kvm_one_reg *reg, u64 *v)
 {
@@ -365,6 +392,29 @@ static int kvm_get_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	return ret;
 }
 
+static int kvm_check_cpucfg(int id, u64 val)
+{
+	u64 mask;
+	int ret = 0;
+
+	if (id < 0 && id >= KVM_MAX_CPUCFG_REGS)
+		return -EINVAL;
+
+	if (_kvm_loongarch_get_cpucfg_attr(id, &mask))
+		return ret;
+
+	switch (id) {
+	case 2:
+		/* CPUCFG2 features checking, if features are not supported, return false. */
+		if (val & ~mask)
+			ret = -EINVAL;
+		break;
+	default:
+		break;
+	}
+	return ret;
+}
+
 static int kvm_set_one_reg(struct kvm_vcpu *vcpu,
 			const struct kvm_one_reg *reg, u64 v)
 {
@@ -378,10 +428,10 @@ static int kvm_set_one_reg(struct kvm_vcpu *vcpu,
 		break;
 	case KVM_REG_LOONGARCH_CPUCFG:
 		id = KVM_GET_IOC_CPUCFG_IDX(reg->id);
-		if (id >= 0 && id < KVM_MAX_CPUCFG_REGS)
-			vcpu->arch.cpucfg[id] = (u32)v;
-		else
-			ret = -EINVAL;
+		ret = kvm_check_cpucfg(id, v);
+		if (ret)
+			break;
+		vcpu->arch.cpucfg[id] = (u32)v;
 		break;
 	case KVM_REG_LOONGARCH_KVM:
 		switch (reg->id) {
@@ -471,10 +521,93 @@ static int kvm_vcpu_ioctl_enable_cap(struct kvm_vcpu *vcpu,
 	return -EINVAL;
 }
 
+static int kvm_loongarch_cpucfg_has_attr(struct kvm_vcpu *vcpu,
+					 struct kvm_device_attr *attr)
+{
+	int ret = -ENXIO;
+
+	switch (attr->attr) {
+	case 2:
+		ret = 0;
+		break;
+	default:
+		break;
+	}
+
+	return ret;
+}
+
+static int kvm_loongarch_vcpu_has_attr(struct kvm_vcpu *vcpu,
+				       struct kvm_device_attr *attr)
+{
+	int ret = -ENXIO;
+
+	switch (attr->group) {
+	case KVM_LOONGARCH_VCPU_CPUCFG:
+		ret = kvm_loongarch_cpucfg_has_attr(vcpu, attr);
+		break;
+	default:
+	}
+
+	return ret;
+}
+
+static int kvm_loongarch_cpucfg_set_attr(struct kvm_vcpu *vcpu,
+					 struct kvm_device_attr *attr)
+{
+	return -ENXIO;
+}
+
+static int kvm_loongarch_vcpu_set_attr(struct kvm_vcpu *vcpu,
+				       struct kvm_device_attr *attr)
+{
+	int ret = -ENXIO;
+
+	switch (attr->group) {
+	case KVM_LOONGARCH_VCPU_CPUCFG:
+		ret = kvm_loongarch_cpucfg_set_attr(vcpu, attr);
+		break;
+	default:
+		break;
+	}
+
+	return ret;
+}
+
+static int kvm_loongarch_get_cpucfg_attr(struct kvm_vcpu *vcpu,
+					 struct kvm_device_attr *attr)
+{
+	int ret = 0;
+	uint64_t val;
+	uint64_t __user *uaddr = (uint64_t __user *)(unsigned long long)attr->addr;
+
+	ret = _kvm_loongarch_get_cpucfg_attr(attr->attr, &val);
+	if (ret)
+		return ret;
+	put_user(val, uaddr);
+	return ret;
+}
+
+static int kvm_loongarch_vcpu_get_attr(struct kvm_vcpu *vcpu,
+				       struct kvm_device_attr *attr)
+{
+	int ret = -ENXIO;
+
+	switch (attr->group) {
+	case KVM_LOONGARCH_VCPU_CPUCFG:
+		ret = kvm_loongarch_get_cpucfg_attr(vcpu, attr);
+	default:
+		break;
+	}
+
+	return ret;
+}
+
 long kvm_arch_vcpu_ioctl(struct file *filp,
 			 unsigned int ioctl, unsigned long arg)
 {
 	long r;
+	struct kvm_device_attr attr;
 	void __user *argp = (void __user *)arg;
 	struct kvm_vcpu *vcpu = filp->private_data;
 
@@ -514,6 +647,27 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 		r = kvm_vcpu_ioctl_enable_cap(vcpu, &cap);
 		break;
 	}
+	case KVM_SET_DEVICE_ATTR: {
+		r = -EFAULT;
+		if (copy_from_user(&attr, argp, sizeof(attr)))
+			break;
+		r = kvm_loongarch_vcpu_set_attr(vcpu, &attr);
+		break;
+	}
+	case KVM_GET_DEVICE_ATTR: {
+		r = -EFAULT;
+		if (copy_from_user(&attr, argp, sizeof(attr)))
+			break;
+		r = kvm_loongarch_vcpu_get_attr(vcpu, &attr);
+		break;
+	}
+	case KVM_HAS_DEVICE_ATTR: {
+		r = -EFAULT;
+		if (copy_from_user(&attr, argp, sizeof(attr)))
+			break;
+		r = kvm_loongarch_vcpu_has_attr(vcpu, &attr);
+		break;
+	}
 	default:
 		r = -ENOIOCTLCMD;
 		break;
@@ -561,12 +715,49 @@ void kvm_own_fpu(struct kvm_vcpu *vcpu)
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


