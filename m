Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C794A6DA735
	for <lists+kvm@lfdr.de>; Fri,  7 Apr 2023 04:00:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233203AbjDGCAb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Apr 2023 22:00:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231720AbjDGCAU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Apr 2023 22:00:20 -0400
Received: from loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3AC86A245;
        Thu,  6 Apr 2023 19:00:10 -0700 (PDT)
Received: from loongson.cn (unknown [10.2.5.185])
        by gateway (Coremail) with SMTP id _____8BxMMwpeS9ks6YXAA--.36738S3;
        Fri, 07 Apr 2023 10:00:09 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8BxLL4jeS9k17sXAA--.23369S9;
        Fri, 07 Apr 2023 10:00:08 +0800 (CST)
From:   Tianrui Zhao <zhaotianrui@loongson.cn>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Huacai Chen <chenhuacai@kernel.org>,
        WANG Xuerui <kernel@xen0n.name>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>, maobibo@loongson.cn,
        Xi Ruoyao <xry111@xry111.site>, zhaotianrui@loongson.cn
Subject: [PATCH v5 07/30] LoongArch: KVM: Implement vcpu run interface
Date:   Fri,  7 Apr 2023 09:59:40 +0800
Message-Id: <20230407020003.3651096-8-zhaotianrui@loongson.cn>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230407020003.3651096-1-zhaotianrui@loongson.cn>
References: <20230407020003.3651096-1-zhaotianrui@loongson.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8BxLL4jeS9k17sXAA--.23369S9
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBjvJXoWxAryruFWxJryUXw43KFWxWFg_yoW5XFWUpF
        W8Cwn09w4rJ34xG393Jrs0vrs0qrZ5Kr17XryxtrWaqr4jy34DursakrWDAFWfA34fZF1S
        vFn5tF4UCF1jy37anT9S1TB71UUUUjJqnTZGkaVYY2UrUUUUj1kv1TuYvTs0mT0YCTnIWj
        qI5I8CrVACY4xI64kE6c02F40Ex7xfYxn0WfASr-VFAUDa7-sFnT9fnUUIcSsGvfJTRUUU
        b4kFc2x0x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3wA2ocxC64kIII0Yj41l84x0c7CEw4
        AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF
        7I0E14v26r4UJVWxJr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aV
        CY1x0267AKxVW8Jr0_Cr1UM2kKe7AKxVWUAVWUtwAS0I0E0xvYzxvE52x082IY62kv0487
        Mc804VCY07AIYIkI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VCjz48v1s
        IEY20_WwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lc7CjxVAaw2AFwI0_
        JF0_Jw1l42xK82IYc2Ij64vIr41l42xK82IY6x8ErcxFaVAv8VWrMxC20s026xCaFVCjc4
        AY6r1j6r4UMxCIbckI1I0E14v26r126r1DMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCj
        r7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6x
        IIjxv20xvE14v26F1j6w1UMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWxJVW8Jr1lIxAIcVCF
        04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26F4j6r4UJwCI42IY6I8E87Iv6x
        kF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvj4RKpBTUUUUU
X-Spam-Status: No, score=-0.0 required=5.0 tests=SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
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
index 7af2ff64b..bc9e3889f 100644
--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -18,6 +18,44 @@ int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
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
+		/* Drop vpid for this VCPU */
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
@@ -87,3 +125,51 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
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

