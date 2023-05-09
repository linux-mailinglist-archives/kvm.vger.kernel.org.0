Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F28E16FC0D3
	for <lists+kvm@lfdr.de>; Tue,  9 May 2023 09:54:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234620AbjEIHyF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 May 2023 03:54:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234552AbjEIHxy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 May 2023 03:53:54 -0400
Received: from loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BA0DF3C32;
        Tue,  9 May 2023 00:53:52 -0700 (PDT)
Received: from loongson.cn (unknown [10.2.5.185])
        by gateway (Coremail) with SMTP id _____8DxzOoP_FlkyuIGAA--.11417S3;
        Tue, 09 May 2023 15:53:51 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8BxFLUK_FlkIEhSAA--.16908S9;
        Tue, 09 May 2023 15:53:50 +0800 (CST)
From:   Tianrui Zhao <zhaotianrui@loongson.cn>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        WANG Xuerui <kernel@xen0n.name>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>, maobibo@loongson.cn,
        Xi Ruoyao <xry111@xry111.site>, zhaotianrui@loongson.cn
Subject: [PATCH v9 07/30] LoongArch: KVM: Implement vcpu run interface
Date:   Tue,  9 May 2023 15:53:23 +0800
Message-Id: <20230509075346.1023386-8-zhaotianrui@loongson.cn>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230509075346.1023386-1-zhaotianrui@loongson.cn>
References: <20230509075346.1023386-1-zhaotianrui@loongson.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8BxFLUK_FlkIEhSAA--.16908S9
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBjvJXoWxAryruFWxJryUXw43KFWxWFg_yoW5XFW3pF
        4xCwn09w4rJ34xG3yfJrs0vrs0qrZ5Kr17XryxtrW3tr1Ut34DursakrWUAFWfA34fZF1S
        vFn5tF4UCF1jy37anT9S1TB71UUUUjJqnTZGkaVYY2UrUUUUj1kv1TuYvTs0mT0YCTnIWj
        qI5I8CrVACY4xI64kE6c02F40Ex7xfYxn0WfASr-VFAUDa7-sFnT9fnUUIcSsGvfJTRUUU
        b48Fc2x0x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3wA2ocxC64kIII0Yj41l84x0c7CEw4
        AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF
        7I0E14v26r4UJVWxJr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6x
        kF7I0E14v26F4UJVW0owAaw2AFwI0_JF0_Jw1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAq
        jxCEc2xF0cIa020Ex4CE44I27wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E74AGY7Cv6c
        x26rWlOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JMxkF7I0En4kS14v26r12
        6r1DMxAIw28IcxkI7VAKI48JMxAIw28IcVCjz48v1sIEY20_WwCFx2IqxVCFs4IE7xkEbV
        WUJVW8JwCFI7km07C267AKxVWUAVWUtwC20s026c02F40E14v26r1j6r18MI8I3I0E7480
        Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7
        IYx2IY67AKxVW7JVWDJwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UMIIF0xvE42xK
        8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWxJVW8Jr1lIxAIcVC2z280aVCY1x
        0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7xRiTKZJUUUUU==
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,RCVD_IN_SBL_CSS,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Implement vcpu run interface, handling mmio, iocsr reading fault
and deliver interrupt, lose fpu before vcpu enter guest.

Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
---
 arch/loongarch/kvm/vcpu.c | 86 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 86 insertions(+)

diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
index 24b5b00266a1..eca8b96a3e6e 100644
--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -17,6 +17,44 @@ int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
 	return 0;
 }
 
+/* Returns 1 if the guest TLB may be clobbered */
+static int _kvm_check_requests(struct kvm_vcpu *vcpu, int cpu)
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
+	int cpu;
+
+	/*
+	 * handle vcpu timer, interrupts, check requests and
+	 * check vmid before vcpu enter guest
+	 */
+	kvm_acquire_timer(vcpu);
+	_kvm_deliver_intr(vcpu);
+	/* make sure the vcpu mode has been written */
+	smp_store_mb(vcpu->mode, IN_GUEST_MODE);
+	cpu = smp_processor_id();
+	_kvm_check_requests(vcpu, cpu);
+	_kvm_check_vmid(vcpu, cpu);
+	vcpu->arch.host_eentry = csr_read64(LOONGARCH_CSR_EENTRY);
+	/* clear KVM_LARCH_CSR as csr will change when enter guest */
+	vcpu->arch.aux_inuse &= ~KVM_LARCH_CSR;
+}
+
 int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 {
 	unsigned long timer_hz;
@@ -86,3 +124,51 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
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
2.31.1

