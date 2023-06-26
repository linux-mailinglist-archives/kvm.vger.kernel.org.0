Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1041873DA47
	for <lists+kvm@lfdr.de>; Mon, 26 Jun 2023 10:49:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230372AbjFZIsR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jun 2023 04:48:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230310AbjFZIsD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jun 2023 04:48:03 -0400
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9E7911AA;
        Mon, 26 Jun 2023 01:48:01 -0700 (PDT)
Received: from loongson.cn (unknown [10.2.5.185])
        by gateway (Coremail) with SMTP id _____8Bx38e+UJlkejQCAA--.3367S3;
        Mon, 26 Jun 2023 16:47:58 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8Bxxsy5UJlk4hQJAA--.19269S9;
        Mon, 26 Jun 2023 16:47:57 +0800 (CST)
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
        tangyouling@loongson.cn
Subject: [PATCH v15 07/30] LoongArch: KVM: Implement vcpu run interface
Date:   Mon, 26 Jun 2023 16:47:29 +0800
Message-Id: <20230626084752.1138621-8-zhaotianrui@loongson.cn>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230626084752.1138621-1-zhaotianrui@loongson.cn>
References: <20230626084752.1138621-1-zhaotianrui@loongson.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8Bxxsy5UJlk4hQJAA--.19269S9
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
        ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
        nUUI43ZEXa7xR_UUUUUUUUU==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
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
 arch/loongarch/kvm/vcpu.c | 83 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 83 insertions(+)

diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
index 24b5b00266a1..eba5c07b8be3 100644
--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -17,6 +17,41 @@ int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
 	return 0;
 }
 
+/* Returns 1 if the guest TLB may be clobbered */
+static int _kvm_check_requests(struct kvm_vcpu *vcpu)
+{
+	int ret = 0;
+
+	if (!kvm_request_pending(vcpu))
+		return 0;
+
+	if (kvm_check_request(KVM_REQ_TLB_FLUSH, vcpu)) {
+		/* Drop vpid for this vCPU */
+		vcpu->arch.vpid = 0;
+		/* This will clobber guest TLB contents too */
+		ret = 1;
+	}
+
+	return ret;
+}
+
+static void kvm_pre_enter_guest(struct kvm_vcpu *vcpu)
+{
+	/*
+	 * handle vcpu timer, interrupts, check requests and
+	 * check vmid before vcpu enter guest
+	 */
+	kvm_acquire_timer(vcpu);
+	_kvm_deliver_intr(vcpu);
+	/* make sure the vcpu mode has been written */
+	smp_store_mb(vcpu->mode, IN_GUEST_MODE);
+	_kvm_check_requests(vcpu);
+	_kvm_check_vmid(vcpu);
+	vcpu->arch.host_eentry = csr_read64(LOONGARCH_CSR_EENTRY);
+	/* clear KVM_LARCH_CSR as csr will change when enter guest */
+	vcpu->arch.aux_inuse &= ~KVM_LARCH_CSR;
+}
+
 int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 {
 	unsigned long timer_hz;
@@ -86,3 +121,51 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 			context->last_vcpu = NULL;
 	}
 }
+
+int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
+{
+	int r = -EINTR;
+	struct kvm_run *run = vcpu->run;
+
+	vcpu_load(vcpu);
+
+	kvm_sigset_activate(vcpu);
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
+		goto out;
+
+	lose_fpu(1);
+
+	local_irq_disable();
+	guest_timing_enter_irqoff();
+
+	kvm_pre_enter_guest(vcpu);
+	trace_kvm_enter(vcpu);
+
+	guest_state_enter_irqoff();
+	r = kvm_loongarch_ops->enter_guest(run, vcpu);
+
+	/* guest_state_exit_irqoff() already done.  */
+	trace_kvm_out(vcpu);
+	guest_timing_exit_irqoff();
+	local_irq_enable();
+
+out:
+	kvm_sigset_deactivate(vcpu);
+
+	vcpu_put(vcpu);
+	return r;
+}
-- 
2.39.1

