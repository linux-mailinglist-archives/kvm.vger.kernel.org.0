Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 016A869C5D5
	for <lists+kvm@lfdr.de>; Mon, 20 Feb 2023 08:12:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231282AbjBTHLo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Feb 2023 02:11:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231243AbjBTHLm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Feb 2023 02:11:42 -0500
Received: from loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A402A659B;
        Sun, 19 Feb 2023 23:11:31 -0800 (PST)
Received: from loongson.cn (unknown [10.2.5.185])
        by gateway (Coremail) with SMTP id _____8DxEwzjGfNjUrQCAA--.45S3;
        Mon, 20 Feb 2023 14:57:39 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8Ax+73fGfNjFvk2AA--.34690S10;
        Mon, 20 Feb 2023 14:57:38 +0800 (CST)
From:   Tianrui Zhao <zhaotianrui@loongson.cn>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Huacai Chen <chenhuacai@kernel.org>,
        WANG Xuerui <kernel@xen0n.name>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>, maobibo@loongson.cn
Subject: [PATCH v2 08/29] LoongArch: KVM: Implement vcpu handle exit interface
Date:   Mon, 20 Feb 2023 14:57:14 +0800
Message-Id: <20230220065735.1282809-9-zhaotianrui@loongson.cn>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230220065735.1282809-1-zhaotianrui@loongson.cn>
References: <20230220065735.1282809-1-zhaotianrui@loongson.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8Ax+73fGfNjFvk2AA--.34690S10
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBjvJXoWxGw47Zr4UXFWDGFWrWw43Awb_yoW5Ww47pa
        y8CryY9w48G34xAanayr1qqr4YvrZ3Kr1xZrZrW3yayrsrtas8Jr4kKrZxtFy8W34FvF1f
        ZF1rt3Z0kr4qyw7anT9S1TB71UUUUjJqnTZGkaVYY2UrUUUUj1kv1TuYvTs0mT0YCTnIWj
        qI5I8CrVACY4xI64kE6c02F40Ex7xfYxn0WfASr-VFAUDa7-sFnT9fnUUIcSsGvfJTRUUU
        b4xFc2x0x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3wA2ocxC64kIII0Yj41l84x0c7CEw4
        AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF
        7I0E14v26r4UJVWxJr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aV
        CY1x0267AKxVWxJr0_GcWln4kS14v26r126r1DM2AIxVAIcxkEcVAq07x20xvEncxIr21l
        57IF6xkI12xvs2x26I8E6xACxx1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6x8ErcxFaV
        Av8VWrMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwCY1x0262kKe7AKxVWU
        AVWUtwCF04k20xvY0x0EwIxGrwCF04k20xvE74AGY7Cv6cx26rWl4I8I3I0E4IkC6x0Yz7
        v_Jr0_Gr1l4IxYO2xFxVAFwI0_JF0_Jw1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8G
        jcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2I
        x0cI8IcVAFwI0_tr0E3s1lIxAIcVC0I7IYx2IY6xkF7I0E14v26F4j6r4UJwCI42IY6xAI
        w20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Cr0_Gr1UMIIF0xvEx4A2jsIEc7
        CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0zR9iSdUUUUU=
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Implement vcpu handle exit interface, getting the exit code by ESTAT
register and using kvm exception vector to handle it.

Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
---
 arch/loongarch/kvm/vcpu.c | 86 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 86 insertions(+)

diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
index 571ac8b9d..e08a4faa0 100644
--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -38,6 +38,92 @@ static int _kvm_check_requests(struct kvm_vcpu *vcpu, int cpu)
 	return ret;
 }
 
+/*
+ * Return value is in the form (errcode<<2 | RESUME_FLAG_HOST | RESUME_FLAG_NV)
+ */
+static int _kvm_handle_exit(struct kvm_run *run, struct kvm_vcpu *vcpu)
+{
+	unsigned long exst = vcpu->arch.host_estat;
+	u32 intr = exst & 0x1fff; /* ignore NMI */
+	u32 exccode = (exst & CSR_ESTAT_EXC) >> CSR_ESTAT_EXC_SHIFT;
+	u32 __user *opc = (u32 __user *) vcpu->arch.pc;
+	int ret = RESUME_GUEST, cpu;
+
+	vcpu->mode = OUTSIDE_GUEST_MODE;
+
+	/* Set a default exit reason */
+	run->exit_reason = KVM_EXIT_UNKNOWN;
+	run->ready_for_interrupt_injection = 1;
+
+	/*
+	 * Set the appropriate status bits based on host CPU features,
+	 * before we hit the scheduler
+	 */
+
+	local_irq_enable();
+
+	kvm_debug("%s: exst: %lx, PC: %p, kvm_run: %p, kvm_vcpu: %p\n",
+			__func__, exst, opc, run, vcpu);
+	trace_kvm_exit(vcpu, exccode);
+	if (exccode) {
+		ret = _kvm_handle_fault(vcpu, exccode);
+	} else {
+		WARN(!intr, "suspicious vm exiting");
+		++vcpu->stat.int_exits;
+
+		if (need_resched())
+			cond_resched();
+
+		ret = RESUME_GUEST;
+	}
+
+	cond_resched();
+
+	local_irq_disable();
+
+	if (ret == RESUME_GUEST)
+		kvm_acquire_timer(vcpu);
+
+	if (!(ret & RESUME_HOST)) {
+		_kvm_deliver_intr(vcpu);
+		/* Only check for signals if not already exiting to userspace */
+		if (signal_pending(current)) {
+			run->exit_reason = KVM_EXIT_INTR;
+			ret = (-EINTR << 2) | RESUME_HOST;
+			++vcpu->stat.signal_exits;
+			trace_kvm_exit(vcpu, KVM_TRACE_EXIT_SIGNAL);
+		}
+	}
+
+	if (ret == RESUME_GUEST) {
+		trace_kvm_reenter(vcpu);
+
+		/*
+		 * Make sure the read of VCPU requests in vcpu_reenter()
+		 * callback is not reordered ahead of the write to vcpu->mode,
+		 * or we could miss a TLB flush request while the requester sees
+		 * the VCPU as outside of guest mode and not needing an IPI.
+		 */
+		smp_store_mb(vcpu->mode, IN_GUEST_MODE);
+
+		cpu = smp_processor_id();
+		_kvm_check_requests(vcpu, cpu);
+		_kvm_check_vmid(vcpu, cpu);
+		vcpu->arch.host_eentry = csr_read64(LOONGARCH_CSR_EENTRY);
+
+		/*
+		 * If FPU are enabled (i.e. the guest's FPU context
+		 * is live), restore FCSR0.
+		 */
+		if (_kvm_guest_has_fpu(&vcpu->arch) &&
+			read_csr_euen() & (CSR_EUEN_FPEN)) {
+			kvm_restore_fcsr(&vcpu->arch.fpu);
+		}
+	}
+
+	return ret;
+}
+
 int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 {
 	int i;
-- 
2.31.1

