Return-Path: <kvm+bounces-3078-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D1651800668
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 09:59:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8808E281981
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 08:59:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 180861CAB7;
	Fri,  1 Dec 2023 08:59:29 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id CDF1512A;
	Fri,  1 Dec 2023 00:59:21 -0800 (PST)
Received: from loongson.cn (unknown [10.2.5.185])
	by gateway (Coremail) with SMTP id _____8CxtPBnoGllcSg+AA--.59284S3;
	Fri, 01 Dec 2023 16:59:19 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8AxG9xkoGll4ndRAA--.49050S4;
	Fri, 01 Dec 2023 16:59:17 +0800 (CST)
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
Subject: [PATCH v2 2/2] LoongArch: KVM: Add LASX support
Date: Fri,  1 Dec 2023 16:46:19 +0800
Message-Id: <20231201084619.2255983-3-zhaotianrui@loongson.cn>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20231201084619.2255983-1-zhaotianrui@loongson.cn>
References: <20231201084619.2255983-1-zhaotianrui@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8AxG9xkoGll4ndRAA--.49050S4
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

This patch adds LASX support for LoongArch KVM.
There will be LASX exception in KVM when guest use the LASX
instruction. KVM will enable LASX and restore the vector
registers for guest then return to guest to continue running.

Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
---
 arch/loongarch/include/asm/kvm_host.h |  6 ++++
 arch/loongarch/include/asm/kvm_vcpu.h | 10 ++++++
 arch/loongarch/kernel/fpu.S           |  2 ++
 arch/loongarch/kvm/exit.c             | 18 +++++++++++
 arch/loongarch/kvm/switch.S           | 15 +++++++++
 arch/loongarch/kvm/trace.h            |  4 ++-
 arch/loongarch/kvm/vcpu.c             | 46 ++++++++++++++++++++++++++-
 7 files changed, 99 insertions(+), 2 deletions(-)

diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/include/asm/kvm_host.h
index a53b47093f4..dc817481b30 100644
--- a/arch/loongarch/include/asm/kvm_host.h
+++ b/arch/loongarch/include/asm/kvm_host.h
@@ -97,6 +97,7 @@ enum emulation_result {
 #define KVM_LARCH_SWCSR_LATEST	(0x1 << 1)
 #define KVM_LARCH_HWCSR_USABLE	(0x1 << 2)
 #define KVM_LARCH_LSX		(0x1 << 3)
+#define KVM_LARCH_LASX		(0x1 << 4)
 
 struct kvm_vcpu_arch {
 	/*
@@ -183,6 +184,11 @@ static inline bool kvm_guest_has_lsx(struct kvm_vcpu_arch *arch)
 	return arch->cpucfg[2] & CPUCFG2_LSX;
 }
 
+static inline bool kvm_guest_has_lasx(struct kvm_vcpu_arch *arch)
+{
+	return arch->cpucfg[2] & CPUCFG2_LASX;
+}
+
 /* Debug: dump vcpu state */
 int kvm_arch_vcpu_dump_regs(struct kvm_vcpu *vcpu);
 
diff --git a/arch/loongarch/include/asm/kvm_vcpu.h b/arch/loongarch/include/asm/kvm_vcpu.h
index c629771e122..4f87f160185 100644
--- a/arch/loongarch/include/asm/kvm_vcpu.h
+++ b/arch/loongarch/include/asm/kvm_vcpu.h
@@ -67,6 +67,16 @@ static inline void kvm_restore_lsx(struct loongarch_fpu *fpu) { }
 static inline void kvm_restore_lsx_upper(struct loongarch_fpu *fpu) { }
 #endif
 
+#ifdef CONFIG_CPU_HAS_LASX
+void kvm_own_lasx(struct kvm_vcpu *vcpu);
+void kvm_save_lasx(struct loongarch_fpu *fpu);
+void kvm_restore_lasx(struct loongarch_fpu *fpu);
+#else
+static inline void kvm_own_lasx(struct kvm_vcpu *vcpu) { }
+static inline void kvm_save_lasx(struct loongarch_fpu *fpu) { }
+static inline void kvm_restore_lasx(struct loongarch_fpu *fpu) { }
+#endif
+
 void kvm_acquire_timer(struct kvm_vcpu *vcpu);
 void kvm_init_timer(struct kvm_vcpu *vcpu, unsigned long hz);
 void kvm_reset_timer(struct kvm_vcpu *vcpu);
diff --git a/arch/loongarch/kernel/fpu.S b/arch/loongarch/kernel/fpu.S
index d53ab10f464..4382e36ae3d 100644
--- a/arch/loongarch/kernel/fpu.S
+++ b/arch/loongarch/kernel/fpu.S
@@ -349,6 +349,7 @@ SYM_FUNC_START(_restore_lsx_upper)
 	lsx_restore_all_upper a0 t0 t1
 	jr	ra
 SYM_FUNC_END(_restore_lsx_upper)
+EXPORT_SYMBOL(_restore_lsx_upper)
 
 SYM_FUNC_START(_init_lsx_upper)
 	lsx_init_all_upper t1
@@ -384,6 +385,7 @@ SYM_FUNC_START(_restore_lasx_upper)
 	lasx_restore_all_upper a0 t0 t1
 	jr	ra
 SYM_FUNC_END(_restore_lasx_upper)
+EXPORT_SYMBOL(_restore_lasx_upper)
 
 SYM_FUNC_START(_init_lasx_upper)
 	lasx_init_all_upper t1
diff --git a/arch/loongarch/kvm/exit.c b/arch/loongarch/kvm/exit.c
index 1b1c58ccc83..57bd5bf562a 100644
--- a/arch/loongarch/kvm/exit.c
+++ b/arch/loongarch/kvm/exit.c
@@ -676,6 +676,23 @@ static int kvm_handle_lsx_disabled(struct kvm_vcpu *vcpu)
 	return RESUME_GUEST;
 }
 
+/*
+ * kvm_handle_lasx_disabled() - Guest used LASX while disabled in root.
+ * @vcpu:	Virtual CPU context.
+ *
+ * Handle when the guest attempts to use LASX when it is disabled in the root
+ * context.
+ */
+static int kvm_handle_lasx_disabled(struct kvm_vcpu *vcpu)
+{
+	if (!kvm_guest_has_lasx(&vcpu->arch))
+		kvm_queue_exception(vcpu, EXCCODE_INE, 0);
+	else
+		kvm_own_lasx(vcpu);
+
+	return RESUME_GUEST;
+}
+
 /*
  * LoongArch KVM callback handling for unimplemented guest exiting
  */
@@ -705,6 +722,7 @@ static exit_handle_fn kvm_fault_tables[EXCCODE_INT_START] = {
 	[EXCCODE_TLBM]			= kvm_handle_write_fault,
 	[EXCCODE_FPDIS]			= kvm_handle_fpu_disabled,
 	[EXCCODE_LSXDIS]                = kvm_handle_lsx_disabled,
+	[EXCCODE_LASXDIS]               = kvm_handle_lasx_disabled,
 	[EXCCODE_GSPR]			= kvm_handle_gspr,
 };
 
diff --git a/arch/loongarch/kvm/switch.S b/arch/loongarch/kvm/switch.S
index 6c48f7d1ca5..215c70b2de3 100644
--- a/arch/loongarch/kvm/switch.S
+++ b/arch/loongarch/kvm/switch.S
@@ -266,6 +266,21 @@ SYM_FUNC_START(kvm_restore_lsx_upper)
 SYM_FUNC_END(kvm_restore_lsx_upper)
 #endif
 
+#ifdef CONFIG_CPU_HAS_LASX
+SYM_FUNC_START(kvm_save_lasx)
+	fpu_save_csr    a0 t1
+	fpu_save_cc     a0 t1 t2
+	lasx_save_data  a0 t1
+	jr              ra
+SYM_FUNC_END(kvm_save_lasx)
+
+SYM_FUNC_START(kvm_restore_lasx)
+	lasx_restore_data a0 t1
+	fpu_restore_cc    a0 t1 t2
+	fpu_restore_csr   a0 t1 t2
+	jr                ra
+SYM_FUNC_END(kvm_restore_lasx)
+#endif
 	.section ".rodata"
 SYM_DATA(kvm_exception_size, .quad kvm_exc_entry_end - kvm_exc_entry)
 SYM_DATA(kvm_enter_guest_size, .quad kvm_enter_guest_end - kvm_enter_guest)
diff --git a/arch/loongarch/kvm/trace.h b/arch/loongarch/kvm/trace.h
index 7da4e230e89..c2484ad4cff 100644
--- a/arch/loongarch/kvm/trace.h
+++ b/arch/loongarch/kvm/trace.h
@@ -103,6 +103,7 @@ TRACE_EVENT(kvm_exit_gspr,
 
 #define KVM_TRACE_AUX_FPU		1
 #define KVM_TRACE_AUX_LSX		2
+#define KVM_TRACE_AUX_LASX		3
 
 #define kvm_trace_symbol_aux_op				\
 	{ KVM_TRACE_AUX_SAVE,		"save" },	\
@@ -113,7 +114,8 @@ TRACE_EVENT(kvm_exit_gspr,
 
 #define kvm_trace_symbol_aux_state			\
 	{ KVM_TRACE_AUX_FPU,     "FPU" },		\
-	{ KVM_TRACE_AUX_LSX,     "LSX" }
+	{ KVM_TRACE_AUX_LSX,     "LSX" },		\
+	{ KVM_TRACE_AUX_LASX,    "LASX" }
 
 TRACE_EVENT(kvm_aux,
 	    TP_PROTO(struct kvm_vcpu *vcpu, unsigned int op,
diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
index 4820c95091f..7802ae68197 100644
--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -329,6 +329,13 @@ static int kvm_get_cpucfg_supported(int id, u64 *v)
 		 */
 		if (cpu_has_lsx)
 			*v |= CPUCFG2_LSX;
+		/*
+		 * if LASX is supported by CPU, it is also supported by KVM,
+		 * as we implement it.
+		 */
+		if (cpu_has_lasx)
+			*v |= CPUCFG2_LASX;
+
 		break;
 	default:
 		ret = -EINVAL;
@@ -653,12 +660,49 @@ void kvm_own_lsx(struct kvm_vcpu *vcpu)
 }
 #endif
 
+#ifdef CONFIG_CPU_HAS_LASX
+/* Enable LASX for guest and restore context */
+void kvm_own_lasx(struct kvm_vcpu *vcpu)
+{
+	preempt_disable();
+
+	set_csr_euen(CSR_EUEN_FPEN | CSR_EUEN_LSXEN | CSR_EUEN_LASXEN);
+	switch (vcpu->arch.aux_inuse & (KVM_LARCH_FPU | KVM_LARCH_LSX)) {
+	case KVM_LARCH_LSX | KVM_LARCH_FPU:
+	case KVM_LARCH_LSX:
+		/* Guest LSX state already loaded, only restore upper LASX state */
+		_restore_lasx_upper(&vcpu->arch.fpu);
+		break;
+	case KVM_LARCH_FPU:
+		/* Guest FP state already loaded, only restore 64~256 LASX state */
+		kvm_restore_lsx_upper(&vcpu->arch.fpu);
+		_restore_lasx_upper(&vcpu->arch.fpu);
+		break;
+	default:
+		/* Neither FP or LSX already active, restore full LASX state */
+		kvm_restore_lasx(&vcpu->arch.fpu);
+		break;
+	}
+
+	trace_kvm_aux(vcpu, KVM_TRACE_AUX_RESTORE, KVM_TRACE_AUX_LASX);
+	vcpu->arch.aux_inuse |= KVM_LARCH_LASX | KVM_LARCH_LSX | KVM_LARCH_FPU;
+	preempt_enable();
+}
+#endif
+
 /* Save context and disable FPU */
 void kvm_lose_fpu(struct kvm_vcpu *vcpu)
 {
 	preempt_disable();
 
-	if (vcpu->arch.aux_inuse & KVM_LARCH_LSX) {
+	if (vcpu->arch.aux_inuse & KVM_LARCH_LASX) {
+		kvm_save_lasx(&vcpu->arch.fpu);
+		vcpu->arch.aux_inuse &= ~(KVM_LARCH_LSX | KVM_LARCH_FPU | KVM_LARCH_LASX);
+		trace_kvm_aux(vcpu, KVM_TRACE_AUX_SAVE, KVM_TRACE_AUX_LASX);
+
+		/* Disable LASX & LSX & FPU */
+		clear_csr_euen(CSR_EUEN_FPEN | CSR_EUEN_LSXEN | CSR_EUEN_LASXEN);
+	} else if (vcpu->arch.aux_inuse & KVM_LARCH_LSX) {
 		kvm_save_lsx(&vcpu->arch.fpu);
 		vcpu->arch.aux_inuse &= ~(KVM_LARCH_LSX | KVM_LARCH_FPU);
 		trace_kvm_aux(vcpu, KVM_TRACE_AUX_SAVE, KVM_TRACE_AUX_LSX);
-- 
2.39.3


