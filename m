Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50E5E7AF948
	for <lists+kvm@lfdr.de>; Wed, 27 Sep 2023 06:24:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229815AbjI0EYS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Sep 2023 00:24:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbjI0EXP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Sep 2023 00:23:15 -0400
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 921EC19A;
        Tue, 26 Sep 2023 20:10:07 -0700 (PDT)
Received: from loongson.cn (unknown [10.2.5.185])
        by gateway (Coremail) with SMTP id _____8CxtPAMnRNlARctAA--.21676S3;
        Wed, 27 Sep 2023 11:10:04 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8Cxjd4InRNlhZETAA--.42466S8;
        Wed, 27 Sep 2023 11:10:03 +0800 (CST)
From:   Tianrui Zhao <zhaotianrui@loongson.cn>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        WANG Xuerui <kernel@xen0n.name>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>, maobibo@loongson.cn,
        Xi Ruoyao <xry111@xry111.site>, zhaotianrui@loongson.cn,
        Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH v22 06/25] LoongArch: KVM: Implement basic vcpu interfaces
Date:   Wed, 27 Sep 2023 11:09:40 +0800
Message-Id: <20230927030959.3629941-7-zhaotianrui@loongson.cn>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230927030959.3629941-1-zhaotianrui@loongson.cn>
References: <20230927030959.3629941-1-zhaotianrui@loongson.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8Cxjd4InRNlhZETAA--.42466S8
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
        ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
        nUUI43ZEXa7xR_UUUUUUUUU==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Implement basic vcpu interfaces, including:

1, vcpu create and destroy interface, saving info into vcpu arch
structure such as vcpu exception entrance, vcpu enter guest pointer,
etc. Init vcpu timer and set address translation mode when vcpu create.

2, vcpu run interface, handling mmio, iocsr reading fault and deliver
interrupt, lose fpu before vcpu enter guest.

3, vcpu handle exit interface, getting the exit code by ESTAT register
and using kvm exception vector to handle it.

Reviewed-by: Bibo Mao <maobibo@loongson.cn>
Tested-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
---
 arch/loongarch/kvm/vcpu.c | 261 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 261 insertions(+)
 create mode 100644 arch/loongarch/kvm/vcpu.c

diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
new file mode 100644
index 0000000000..349cecca1e
--- /dev/null
+++ b/arch/loongarch/kvm/vcpu.c
@@ -0,0 +1,261 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2020-2023 Loongson Technology Corporation Limited
+ */
+
+#include <linux/kvm_host.h>
+#include <linux/entry-kvm.h>
+#include <asm/fpu.h>
+#include <asm/loongarch.h>
+#include <asm/setup.h>
+#include <asm/time.h>
+
+#define CREATE_TRACE_POINTS
+#include "trace.h"
+
+/*
+ * kvm_check_requests - check and handle pending vCPU requests
+ *
+ * Return: RESUME_GUEST if we should enter the guest
+ *         RESUME_HOST  if we should exit to userspace
+ */
+static int kvm_check_requests(struct kvm_vcpu *vcpu)
+{
+	if (!kvm_request_pending(vcpu))
+		return RESUME_GUEST;
+
+	if (kvm_check_request(KVM_REQ_TLB_FLUSH, vcpu))
+		vcpu->arch.vpid = 0;  /* Drop vpid for this vCPU */
+
+	if (kvm_dirty_ring_check_request(vcpu))
+		return RESUME_HOST;
+
+	return RESUME_GUEST;
+}
+
+/*
+ * Check and handle pending signal and vCPU requests etc
+ * Run with irq enabled and preempt enabled
+ *
+ * Return: RESUME_GUEST if we should enter the guest
+ *         RESUME_HOST  if we should exit to userspace
+ *         < 0 if we should exit to userspace, where the return value
+ *         indicates an error
+ */
+static int kvm_enter_guest_check(struct kvm_vcpu *vcpu)
+{
+	int ret;
+
+	/*
+	 * Check conditions before entering the guest
+	 */
+	ret = xfer_to_guest_mode_handle_work(vcpu);
+	if (ret < 0)
+		return ret;
+
+	ret = kvm_check_requests(vcpu);
+
+	return ret;
+}
+
+/*
+ * Called with irq enabled
+ *
+ * Return: RESUME_GUEST if we should enter the guest, and irq disabled
+ *         Others if we should exit to userspace
+ */
+static int kvm_pre_enter_guest(struct kvm_vcpu *vcpu)
+{
+	int ret;
+
+	do {
+		ret = kvm_enter_guest_check(vcpu);
+		if (ret != RESUME_GUEST)
+			break;
+
+		/*
+		 * Handle vcpu timer, interrupts, check requests and
+		 * check vmid before vcpu enter guest
+		 */
+		local_irq_disable();
+		kvm_acquire_timer(vcpu);
+		kvm_deliver_intr(vcpu);
+		kvm_deliver_exception(vcpu);
+		/* Make sure the vcpu mode has been written */
+		smp_store_mb(vcpu->mode, IN_GUEST_MODE);
+		kvm_check_vpid(vcpu);
+		vcpu->arch.host_eentry = csr_read64(LOONGARCH_CSR_EENTRY);
+		/* Clear KVM_LARCH_SWCSR_LATEST as CSR will change when enter guest */
+		vcpu->arch.aux_inuse &= ~KVM_LARCH_SWCSR_LATEST;
+
+		if (kvm_request_pending(vcpu) || xfer_to_guest_mode_work_pending()) {
+			/* make sure the vcpu mode has been written */
+			smp_store_mb(vcpu->mode, OUTSIDE_GUEST_MODE);
+			local_irq_enable();
+			ret = -EAGAIN;
+		}
+	} while (ret != RESUME_GUEST);
+
+	return ret;
+}
+
+/*
+ * Return 1 for resume guest and "<= 0" for resume host.
+ */
+static int kvm_handle_exit(struct kvm_run *run, struct kvm_vcpu *vcpu)
+{
+	int ret = RESUME_GUEST;
+	unsigned long estat = vcpu->arch.host_estat;
+	u32 intr = estat & 0x1fff; /* Ignore NMI */
+	u32 ecode = (estat & CSR_ESTAT_EXC) >> CSR_ESTAT_EXC_SHIFT;
+
+	vcpu->mode = OUTSIDE_GUEST_MODE;
+
+	/* Set a default exit reason */
+	run->exit_reason = KVM_EXIT_UNKNOWN;
+
+	guest_timing_exit_irqoff();
+	guest_state_exit_irqoff();
+	local_irq_enable();
+
+	trace_kvm_exit(vcpu, ecode);
+	if (ecode) {
+		ret = kvm_handle_fault(vcpu, ecode);
+	} else {
+		WARN(!intr, "vm exiting with suspicious irq\n");
+		++vcpu->stat.int_exits;
+	}
+
+	if (ret == RESUME_GUEST)
+		ret = kvm_pre_enter_guest(vcpu);
+
+	if (ret != RESUME_GUEST) {
+		local_irq_disable();
+		return ret;
+	}
+
+	guest_timing_enter_irqoff();
+	guest_state_enter_irqoff();
+	trace_kvm_reenter(vcpu);
+
+	return RESUME_GUEST;
+}
+
+int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
+{
+	return 0;
+}
+
+int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
+{
+	unsigned long timer_hz;
+	struct loongarch_csrs *csr;
+
+	vcpu->arch.vpid = 0;
+
+	hrtimer_init(&vcpu->arch.swtimer, CLOCK_MONOTONIC, HRTIMER_MODE_ABS_PINNED);
+	vcpu->arch.swtimer.function = kvm_swtimer_wakeup;
+
+	vcpu->arch.handle_exit = kvm_handle_exit;
+	vcpu->arch.guest_eentry = (unsigned long)kvm_loongarch_ops->exc_entry;
+	vcpu->arch.csr = kzalloc(sizeof(struct loongarch_csrs), GFP_KERNEL);
+	if (!vcpu->arch.csr)
+		return -ENOMEM;
+
+	/*
+	 * All kvm exceptions share one exception entry, and host <-> guest
+	 * switch also switch ECFG.VS field, keep host ECFG.VS info here.
+	 */
+	vcpu->arch.host_ecfg = (read_csr_ecfg() & CSR_ECFG_VS);
+
+	/* Init */
+	vcpu->arch.last_sched_cpu = -1;
+
+	/*
+	 * Initialize guest register state to valid architectural reset state.
+	 */
+	timer_hz = calc_const_freq();
+	kvm_init_timer(vcpu, timer_hz);
+
+	/* Set Initialize mode for guest */
+	csr = vcpu->arch.csr;
+	kvm_write_sw_gcsr(csr, LOONGARCH_CSR_CRMD, CSR_CRMD_DA);
+
+	/* Set cpuid */
+	kvm_write_sw_gcsr(csr, LOONGARCH_CSR_TMID, vcpu->vcpu_id);
+
+	/* Start with no pending virtual guest interrupts */
+	csr->csrs[LOONGARCH_CSR_GINTC] = 0;
+
+	return 0;
+}
+
+void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
+{
+}
+
+void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
+{
+	int cpu;
+	struct kvm_context *context;
+
+	hrtimer_cancel(&vcpu->arch.swtimer);
+	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_cache);
+	kfree(vcpu->arch.csr);
+
+	/*
+	 * If the vCPU is freed and reused as another vCPU, we don't want the
+	 * matching pointer wrongly hanging around in last_vcpu.
+	 */
+	for_each_possible_cpu(cpu) {
+		context = per_cpu_ptr(vcpu->kvm->arch.vmcs, cpu);
+		if (context->last_vcpu == vcpu)
+			context->last_vcpu = NULL;
+	}
+}
+
+int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
+{
+	int r = -EINTR;
+	struct kvm_run *run = vcpu->run;
+
+	if (vcpu->mmio_needed) {
+		if (!vcpu->mmio_is_write)
+			kvm_complete_mmio_read(vcpu, run);
+		vcpu->mmio_needed = 0;
+	}
+
+	if (run->exit_reason == KVM_EXIT_LOONGARCH_IOCSR) {
+		if (!run->iocsr_io.is_write)
+			kvm_complete_iocsr_read(vcpu, run);
+	}
+
+	if (run->immediate_exit)
+		return r;
+
+	/* Clear exit_reason */
+	run->exit_reason = KVM_EXIT_UNKNOWN;
+	lose_fpu(1);
+	vcpu_load(vcpu);
+	kvm_sigset_activate(vcpu);
+	r = kvm_pre_enter_guest(vcpu);
+	if (r != RESUME_GUEST)
+		goto out;
+
+	guest_timing_enter_irqoff();
+	guest_state_enter_irqoff();
+	trace_kvm_enter(vcpu);
+	r = kvm_loongarch_ops->enter_guest(run, vcpu);
+
+	trace_kvm_out(vcpu);
+	/*
+	 * Guest exit is already recorded at kvm_handle_exit()
+	 * return value must not be RESUME_GUEST
+	 */
+	local_irq_enable();
+out:
+	kvm_sigset_deactivate(vcpu);
+	vcpu_put(vcpu);
+
+	return r;
+}
-- 
2.39.3

