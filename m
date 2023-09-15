Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58C1F7A132A
	for <lists+kvm@lfdr.de>; Fri, 15 Sep 2023 03:50:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231539AbjIOBuc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 21:50:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231523AbjIOBu2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 21:50:28 -0400
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8E1542713;
        Thu, 14 Sep 2023 18:50:05 -0700 (PDT)
Received: from loongson.cn (unknown [10.2.5.185])
        by gateway (Coremail) with SMTP id _____8DxBfFHuANl_f4nAA--.11615S3;
        Fri, 15 Sep 2023 09:49:59 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8Axndw9uANl+ioGAA--.11927S16;
        Fri, 15 Sep 2023 09:49:58 +0800 (CST)
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
Subject: [PATCH v21 14/29] LoongArch: KVM: Implement vcpu load and vcpu put operations
Date:   Fri, 15 Sep 2023 09:49:34 +0800
Message-Id: <20230915014949.1222777-15-zhaotianrui@loongson.cn>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230915014949.1222777-1-zhaotianrui@loongson.cn>
References: <20230915014949.1222777-1-zhaotianrui@loongson.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8Axndw9uANl+ioGAA--.11927S16
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
        ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
        nUUI43ZEXa7xR_UUUUUUUUU==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Implement LoongArch vcpu load and vcpu put operations, including
load csr value into hardware and save csr value into vcpu structure.

Reviewed-by: Bibo Mao <maobibo@loongson.cn>
Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
---
 arch/loongarch/kvm/vcpu.c | 199 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 199 insertions(+)

diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
index 42383f8648..7162e6ddb7 100644
--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -678,6 +678,205 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 	}
 }
 
+static int kvm_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
+{
+	struct kvm_context *context;
+	struct loongarch_csrs *csr = vcpu->arch.csr;
+	bool migrated;
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
+	if (migrated || (context->last_vcpu != vcpu))
+		vcpu->arch.aux_inuse &= ~KVM_LARCH_HWCSR_USABLE;
+	context->last_vcpu = vcpu;
+
+	/*
+	 * Restore timer state regardless
+	 */
+	kvm_restore_timer(vcpu);
+
+	/* Control guest page CCA attribute */
+	change_csr_gcfg(CSR_GCFG_MATC_MASK, CSR_GCFG_MATC_ROOT);
+
+	/* Don't bother restoring registers multiple times unless necessary */
+	if (vcpu->arch.aux_inuse & KVM_LARCH_HWCSR_USABLE)
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
+	vcpu->arch.aux_inuse |= KVM_LARCH_HWCSR_USABLE;
+	return 0;
+}
+
+void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
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
+	kvm_vcpu_load(vcpu, cpu);
+	local_irq_restore(flags);
+}
+
+static int kvm_vcpu_put(struct kvm_vcpu *vcpu, int cpu)
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
+
+	/* save guest state in registers */
+	kvm_vcpu_put(vcpu, cpu);
+	local_irq_restore(flags);
+}
+
 int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 {
 	int r = -EINTR;
-- 
2.39.1

