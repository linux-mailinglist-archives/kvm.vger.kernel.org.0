Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B030677F70B
	for <lists+kvm@lfdr.de>; Thu, 17 Aug 2023 15:00:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351113AbjHQNAV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Aug 2023 09:00:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351097AbjHQNAH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Aug 2023 09:00:07 -0400
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CB34130D5;
        Thu, 17 Aug 2023 05:59:59 -0700 (PDT)
Received: from loongson.cn (unknown [10.2.5.185])
        by gateway (Coremail) with SMTP id _____8BxnuvMGd5k9IUZAA--.50199S3;
        Thu, 17 Aug 2023 20:59:56 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8BxniPIGd5kmchcAA--.55665S9;
        Thu, 17 Aug 2023 20:59:55 +0800 (CST)
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
        Xi Ruoyao <xry111@xry111.site>, zhaotianrui@loongson.cn
Subject: [PATCH v19 07/30] LoongArch: KVM: Implement vcpu run interface
Date:   Thu, 17 Aug 2023 20:59:28 +0800
Message-Id: <20230817125951.1126909-8-zhaotianrui@loongson.cn>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230817125951.1126909-1-zhaotianrui@loongson.cn>
References: <20230817125951.1126909-1-zhaotianrui@loongson.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8BxniPIGd5kmchcAA--.55665S9
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

Implement vcpu run interface, handling mmio, iocsr reading fault
and deliver interrupt, lose fpu before vcpu enter guest.

Reviewed-by: Bibo Mao <maobibo@loongson.cn>
Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
---
 arch/loongarch/kvm/vcpu.c | 130 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 130 insertions(+)

diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
index 545b18cd1ca2..83f2988ea67b 100644
--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -18,6 +18,91 @@ int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
 	return 0;
 }
 
+/*
+ * _kvm_check_requests - check and handle pending vCPU requests
+ *
+ * Return: RESUME_GUEST if we should enter the guest
+ *         RESUME_HOST  if we should exit to userspace
+ */
+static int _kvm_check_requests(struct kvm_vcpu *vcpu)
+{
+	if (!kvm_request_pending(vcpu))
+		return RESUME_GUEST;
+
+	if (kvm_check_request(KVM_REQ_TLB_FLUSH, vcpu))
+		/* Drop vpid for this vCPU */
+		vcpu->arch.vpid = 0;
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
+	ret = _kvm_check_requests(vcpu);
+	return ret;
+}
+
+/*
+ * called with irq enabled
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
+		 * handle vcpu timer, interrupts, check requests and
+		 * check vmid before vcpu enter guest
+		 */
+		local_irq_disable();
+		kvm_acquire_timer(vcpu);
+		_kvm_deliver_intr(vcpu);
+		/* make sure the vcpu mode has been written */
+		smp_store_mb(vcpu->mode, IN_GUEST_MODE);
+		_kvm_check_vmid(vcpu);
+		vcpu->arch.host_eentry = csr_read64(LOONGARCH_CSR_EENTRY);
+		/* clear KVM_LARCH_CSR as csr will change when enter guest */
+		vcpu->arch.aux_inuse &= ~KVM_LARCH_CSR;
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
 int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 {
 	unsigned long timer_hz;
@@ -85,3 +170,48 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 			context->last_vcpu = NULL;
 	}
 }
+
+int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
+{
+	int r = -EINTR;
+	struct kvm_run *run = vcpu->run;
+
+	if (vcpu->mmio_needed) {
+		if (!vcpu->mmio_is_write)
+			_kvm_complete_mmio_read(vcpu, run);
+		vcpu->mmio_needed = 0;
+	}
+
+	if (run->exit_reason == KVM_EXIT_LOONGARCH_IOCSR) {
+		if (!run->iocsr_io.is_write)
+			_kvm_complete_iocsr_read(vcpu, run);
+	}
+
+	/* clear exit_reason */
+	run->exit_reason = KVM_EXIT_UNKNOWN;
+	if (run->immediate_exit)
+		return r;
+
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
+	 * guest exit is already recorded at _kvm_handle_exit
+	 * return val must not be RESUME_GUEST
+	 */
+	local_irq_enable();
+out:
+	kvm_sigset_deactivate(vcpu);
+	vcpu_put(vcpu);
+	return r;
+}
-- 
2.39.1

