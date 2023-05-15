Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E2B270217E
	for <lists+kvm@lfdr.de>; Mon, 15 May 2023 04:16:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238338AbjEOCQN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 14 May 2023 22:16:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235533AbjEOCPg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 14 May 2023 22:15:36 -0400
Received: from loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5772E1736;
        Sun, 14 May 2023 19:15:34 -0700 (PDT)
Received: from loongson.cn (unknown [10.2.5.185])
        by gateway (Coremail) with SMTP id _____8AxmOnElWFkva8IAA--.14828S3;
        Mon, 15 May 2023 10:15:32 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8Dxn7O6lWFk0KJeAA--.33838S16;
        Mon, 15 May 2023 10:15:30 +0800 (CST)
From:   Tianrui Zhao <zhaotianrui@loongson.cn>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Huacai Chen <chenhuacai@kernel.org>
Cc:     WANG Xuerui <kernel@xen0n.name>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>, maobibo@loongson.cn,
        Xi Ruoyao <xry111@xry111.site>, zhaotianrui@loongson.cn
Subject: [PATCH v10 14/30] LoongArch: KVM: Implement vcpu load and vcpu put operations
Date:   Mon, 15 May 2023 10:15:06 +0800
Message-Id: <20230515021522.2445551-15-zhaotianrui@loongson.cn>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230515021522.2445551-1-zhaotianrui@loongson.cn>
References: <20230515021522.2445551-1-zhaotianrui@loongson.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8Dxn7O6lWFk0KJeAA--.33838S16
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBjvJXoWxKF4xGw43Xw1xZw4xXw4DCFg_yoWfJr1kpr
        1qgFW09rW7KF9rtF15ArsFvr13WF4Sy34rJr17K3y2qrn8Z3s5ZFs2yFy3JFyFq3WxXF1I
        y3s8C39a9r4ktw7anT9S1TB71UUUUjJqnTZGkaVYY2UrUUUUj1kv1TuYvTs0mT0YCTnIWj
        qI5I8CrVACY4xI64kE6c02F40Ex7xfYxn0WfASr-VFAUDa7-sFnT9fnUUIcSsGvfJTRUUU
        bxxFc2x0x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3wA2ocxC64kIII0Yj41l84x0c7CEw4
        AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF
        7I0E14v26r4UJVWxJr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aV
        CY1x0267AKxVW8Jr0_Cr1UM2kKe7AKxVWUAVWUtwAS0I0E0xvYzxvE52x082IY62kv0487
        Mc804VCY07AIYIkI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VCjz48v1s
        IEY20_WwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lc7CjxVAaw2AFwI0_
        JF0_Jw1l42xK82IYc2Ij64vIr41l42xK82IY6x8ErcxFaVAv8VWrMxC20s026xCaFVCjc4
        AY6r1j6r4UMxCIbckI1I0E14v26r126r1DMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCj
        r7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6x
        IIjxv20xvE14v26w1j6s0DMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr1UMIIF0xvE
        42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8Jr0_Cr1UMIIF0xvEx4A2js
        IEc7CjxVAFwI0_Gr1j6F4UJbIYCTnIWIevJa73UjIFyTuYvj4RKpBTUUUUU
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Implement LoongArch vcpu load and vcpu put operations, including
load csr value into hardware and save csr value into vcpu structure.

Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
---
 arch/loongarch/kvm/vcpu.c | 198 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 198 insertions(+)

diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
index a314fb441962..a48f4b17ddc5 100644
--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -616,6 +616,204 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 	}
 }
 
+static int _kvm_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
+{
+	struct kvm_context *context;
+	struct loongarch_csrs *csr = vcpu->arch.csr;
+	bool migrated, all;
+
+	/*
+	 * Have we migrated to a different CPU?
+	 * If so, any old guest TLB state may be stale.
+	 */
+	migrated = (vcpu->arch.last_sched_cpu != cpu);
+
+	/*
+	 * Was this the last vCPU to run on this CPU?
+	 * If not, any old guest state from this vCPU will have been clobbered.
+	 */
+	context = per_cpu_ptr(vcpu->kvm->arch.vmcs, cpu);
+	all = migrated || (context->last_vcpu != vcpu);
+	context->last_vcpu = vcpu;
+
+	/*
+	 * Restore timer state regardless
+	 */
+	kvm_restore_timer(vcpu);
+
+	/* Control guest page CCA attribute */
+	change_csr_gcfg(CSR_GCFG_MATC_MASK, CSR_GCFG_MATC_ROOT);
+	/* Don't bother restoring registers multiple times unless necessary */
+	if (!all)
+		return 0;
+
+	write_csr_gcntc((ulong)vcpu->kvm->arch.time_offset);
+	/*
+	 * Restore guest CSR registers
+	 */
+	kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_CRMD);
+	kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_PRMD);
+	kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_EUEN);
+	kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_MISC);
+	kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_ECFG);
+	kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_ERA);
+	kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_BADV);
+	kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_BADI);
+	kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_EENTRY);
+	kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_TLBIDX);
+	kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_TLBEHI);
+	kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_TLBELO0);
+	kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_TLBELO1);
+	kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_ASID);
+	kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_PGDL);
+	kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_PGDH);
+	kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_PWCTL0);
+	kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_PWCTL1);
+	kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_STLBPGSIZE);
+	kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_RVACFG);
+	kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_CPUID);
+	kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_KS0);
+	kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_KS1);
+	kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_KS2);
+	kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_KS3);
+	kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_KS4);
+	kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_KS5);
+	kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_KS6);
+	kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_KS7);
+	kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_TMID);
+	kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_CNTC);
+	kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_TLBRENTRY);
+	kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_TLBRBADV);
+	kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_TLBRERA);
+	kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_TLBRSAVE);
+	kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_TLBRELO0);
+	kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_TLBRELO1);
+	kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_TLBREHI);
+	kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_TLBRPRMD);
+	kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_DMWIN0);
+	kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_DMWIN1);
+	kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_DMWIN2);
+	kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_DMWIN3);
+	kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_LLBCTL);
+
+	/* restore Root.Guestexcept from unused Guest guestexcept register */
+	write_csr_gintc(csr->csrs[LOONGARCH_CSR_GINTC]);
+
+	/*
+	 * We should clear linked load bit to break interrupted atomics. This
+	 * prevents a SC on the next vCPU from succeeding by matching a LL on
+	 * the previous vCPU.
+	 */
+	if (vcpu->kvm->created_vcpus > 1)
+		set_gcsr_llbctl(CSR_LLBCTL_WCLLB);
+
+	return 0;
+}
+
+void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+	vcpu->cpu = cpu;
+	if (vcpu->arch.last_sched_cpu != cpu) {
+		kvm_debug("[%d->%d]KVM vCPU[%d] switch\n",
+				vcpu->arch.last_sched_cpu, cpu, vcpu->vcpu_id);
+		/*
+		 * Migrate the timer interrupt to the current CPU so that it
+		 * always interrupts the guest and synchronously triggers a
+		 * guest timer interrupt.
+		 */
+		kvm_migrate_count(vcpu);
+	}
+
+	/* restore guest state to registers */
+	_kvm_vcpu_load(vcpu, cpu);
+	local_irq_restore(flags);
+}
+
+static int _kvm_vcpu_put(struct kvm_vcpu *vcpu, int cpu)
+{
+	struct loongarch_csrs *csr = vcpu->arch.csr;
+
+	kvm_lose_fpu(vcpu);
+	/*
+	 * update csr state from hardware if software csr state is stale,
+	 * most csr registers are kept unchanged during process context
+	 * switch except csr registers like remaining timer tick value and
+	 * injected interrupt state.
+	 */
+	if (!(vcpu->arch.aux_inuse & KVM_LARCH_CSR)) {
+		kvm_save_hw_gcsr(csr, LOONGARCH_CSR_CRMD);
+		kvm_save_hw_gcsr(csr, LOONGARCH_CSR_PRMD);
+		kvm_save_hw_gcsr(csr, LOONGARCH_CSR_EUEN);
+		kvm_save_hw_gcsr(csr, LOONGARCH_CSR_MISC);
+		kvm_save_hw_gcsr(csr, LOONGARCH_CSR_ECFG);
+		kvm_save_hw_gcsr(csr, LOONGARCH_CSR_ERA);
+		kvm_save_hw_gcsr(csr, LOONGARCH_CSR_BADV);
+		kvm_save_hw_gcsr(csr, LOONGARCH_CSR_BADI);
+		kvm_save_hw_gcsr(csr, LOONGARCH_CSR_EENTRY);
+		kvm_save_hw_gcsr(csr, LOONGARCH_CSR_TLBIDX);
+		kvm_save_hw_gcsr(csr, LOONGARCH_CSR_TLBEHI);
+		kvm_save_hw_gcsr(csr, LOONGARCH_CSR_TLBELO0);
+		kvm_save_hw_gcsr(csr, LOONGARCH_CSR_TLBELO1);
+		kvm_save_hw_gcsr(csr, LOONGARCH_CSR_ASID);
+		kvm_save_hw_gcsr(csr, LOONGARCH_CSR_PGDL);
+		kvm_save_hw_gcsr(csr, LOONGARCH_CSR_PGDH);
+		kvm_save_hw_gcsr(csr, LOONGARCH_CSR_PWCTL0);
+		kvm_save_hw_gcsr(csr, LOONGARCH_CSR_PWCTL1);
+		kvm_save_hw_gcsr(csr, LOONGARCH_CSR_STLBPGSIZE);
+		kvm_save_hw_gcsr(csr, LOONGARCH_CSR_RVACFG);
+		kvm_save_hw_gcsr(csr, LOONGARCH_CSR_CPUID);
+		kvm_save_hw_gcsr(csr, LOONGARCH_CSR_PRCFG1);
+		kvm_save_hw_gcsr(csr, LOONGARCH_CSR_PRCFG2);
+		kvm_save_hw_gcsr(csr, LOONGARCH_CSR_PRCFG3);
+		kvm_save_hw_gcsr(csr, LOONGARCH_CSR_KS0);
+		kvm_save_hw_gcsr(csr, LOONGARCH_CSR_KS1);
+		kvm_save_hw_gcsr(csr, LOONGARCH_CSR_KS2);
+		kvm_save_hw_gcsr(csr, LOONGARCH_CSR_KS3);
+		kvm_save_hw_gcsr(csr, LOONGARCH_CSR_KS4);
+		kvm_save_hw_gcsr(csr, LOONGARCH_CSR_KS5);
+		kvm_save_hw_gcsr(csr, LOONGARCH_CSR_KS6);
+		kvm_save_hw_gcsr(csr, LOONGARCH_CSR_KS7);
+		kvm_save_hw_gcsr(csr, LOONGARCH_CSR_TMID);
+		kvm_save_hw_gcsr(csr, LOONGARCH_CSR_CNTC);
+		kvm_save_hw_gcsr(csr, LOONGARCH_CSR_LLBCTL);
+		kvm_save_hw_gcsr(csr, LOONGARCH_CSR_TLBRENTRY);
+		kvm_save_hw_gcsr(csr, LOONGARCH_CSR_TLBRBADV);
+		kvm_save_hw_gcsr(csr, LOONGARCH_CSR_TLBRERA);
+		kvm_save_hw_gcsr(csr, LOONGARCH_CSR_TLBRSAVE);
+		kvm_save_hw_gcsr(csr, LOONGARCH_CSR_TLBRELO0);
+		kvm_save_hw_gcsr(csr, LOONGARCH_CSR_TLBRELO1);
+		kvm_save_hw_gcsr(csr, LOONGARCH_CSR_TLBREHI);
+		kvm_save_hw_gcsr(csr, LOONGARCH_CSR_TLBRPRMD);
+		kvm_save_hw_gcsr(csr, LOONGARCH_CSR_DMWIN0);
+		kvm_save_hw_gcsr(csr, LOONGARCH_CSR_DMWIN1);
+		kvm_save_hw_gcsr(csr, LOONGARCH_CSR_DMWIN2);
+		kvm_save_hw_gcsr(csr, LOONGARCH_CSR_DMWIN3);
+		vcpu->arch.aux_inuse |= KVM_LARCH_CSR;
+	}
+	/* save Root.Guestexcept in unused Guest guestexcept register */
+	kvm_save_timer(vcpu);
+	csr->csrs[LOONGARCH_CSR_GINTC] = read_csr_gintc();
+	return 0;
+}
+
+void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
+{
+	unsigned long flags;
+	int cpu;
+
+	local_irq_save(flags);
+	cpu = smp_processor_id();
+	vcpu->arch.last_sched_cpu = cpu;
+	vcpu->cpu = -1;
+
+	/* save guest state in registers */
+	_kvm_vcpu_put(vcpu, cpu);
+	local_irq_restore(flags);
+}
+
 int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 {
 	int r = -EINTR;
-- 
2.31.1

