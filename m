Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B1887AF906
	for <lists+kvm@lfdr.de>; Wed, 27 Sep 2023 06:08:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229581AbjI0EIP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Sep 2023 00:08:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbjI0EH1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Sep 2023 00:07:27 -0400
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4ACB31AC;
        Tue, 26 Sep 2023 20:10:10 -0700 (PDT)
Received: from loongson.cn (unknown [10.2.5.185])
        by gateway (Coremail) with SMTP id _____8Dxg_AOnRNlMBctAA--.21234S3;
        Wed, 27 Sep 2023 11:10:06 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8Cxjd4InRNlhZETAA--.42466S13;
        Wed, 27 Sep 2023 11:10:05 +0800 (CST)
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
Subject: [PATCH v22 11/25] LoongArch: KVM: Implement misc vcpu related interfaces
Date:   Wed, 27 Sep 2023 11:09:45 +0800
Message-Id: <20230927030959.3629941-12-zhaotianrui@loongson.cn>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230927030959.3629941-1-zhaotianrui@loongson.cn>
References: <20230927030959.3629941-1-zhaotianrui@loongson.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8Cxjd4InRNlhZETAA--.42466S13
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

1, Implement LoongArch vcpu status description such as idle exits
counter, signal exits counter, cpucfg exits counter, etc.

2, Implement some misc vcpu relaterd interfaces, such as vcpu runnable,
vcpu should kick, vcpu dump regs, etc.

Reviewed-by: Bibo Mao <maobibo@loongson.cn>
Tested-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
---
 arch/loongarch/kvm/vcpu.c | 120 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 120 insertions(+)

diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
index b16fe2913e..73d0c2b9c1 100644
--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -13,6 +13,23 @@
 #define CREATE_TRACE_POINTS
 #include "trace.h"
 
+const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
+	KVM_GENERIC_VCPU_STATS(),
+	STATS_DESC_COUNTER(VCPU, int_exits),
+	STATS_DESC_COUNTER(VCPU, idle_exits),
+	STATS_DESC_COUNTER(VCPU, cpucfg_exits),
+	STATS_DESC_COUNTER(VCPU, signal_exits),
+};
+
+const struct kvm_stats_header kvm_vcpu_stats_header = {
+	.name_size = KVM_STATS_NAME_SIZE,
+	.num_desc = ARRAY_SIZE(kvm_vcpu_stats_desc),
+	.id_offset = sizeof(struct kvm_stats_header),
+	.desc_offset = sizeof(struct kvm_stats_header) + KVM_STATS_NAME_SIZE,
+	.data_offset = sizeof(struct kvm_stats_header) + KVM_STATS_NAME_SIZE +
+		       sizeof(kvm_vcpu_stats_desc),
+};
+
 /*
  * kvm_check_requests - check and handle pending vCPU requests
  *
@@ -141,6 +158,109 @@ static int kvm_handle_exit(struct kvm_run *run, struct kvm_vcpu *vcpu)
 	return RESUME_GUEST;
 }
 
+int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu)
+{
+	return !!(vcpu->arch.irq_pending) &&
+		vcpu->arch.mp_state.mp_state == KVM_MP_STATE_RUNNABLE;
+}
+
+int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu)
+{
+	return kvm_vcpu_exiting_guest_mode(vcpu) == IN_GUEST_MODE;
+}
+
+bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcpu)
+{
+	return false;
+}
+
+vm_fault_t kvm_arch_vcpu_fault(struct kvm_vcpu *vcpu, struct vm_fault *vmf)
+{
+	return VM_FAULT_SIGBUS;
+}
+
+int kvm_arch_vcpu_ioctl_translate(struct kvm_vcpu *vcpu,
+				  struct kvm_translation *tr)
+{
+	return -EINVAL;
+}
+
+int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu)
+{
+	return kvm_pending_timer(vcpu) ||
+		kvm_read_hw_gcsr(LOONGARCH_CSR_ESTAT) & (1 << INT_TI);
+}
+
+int kvm_arch_vcpu_dump_regs(struct kvm_vcpu *vcpu)
+{
+	int i;
+
+	kvm_debug("vCPU Register Dump:\n");
+	kvm_debug("\tPC = 0x%08lx\n", vcpu->arch.pc);
+	kvm_debug("\tExceptions: %08lx\n", vcpu->arch.irq_pending);
+
+	for (i = 0; i < 32; i += 4) {
+		kvm_debug("\tGPR%02d: %08lx %08lx %08lx %08lx\n", i,
+		       vcpu->arch.gprs[i], vcpu->arch.gprs[i + 1],
+		       vcpu->arch.gprs[i + 2], vcpu->arch.gprs[i + 3]);
+	}
+
+	kvm_debug("\tCRMD: 0x%08lx, ESTAT: 0x%08lx\n",
+		  kvm_read_hw_gcsr(LOONGARCH_CSR_CRMD),
+		  kvm_read_hw_gcsr(LOONGARCH_CSR_ESTAT));
+
+	kvm_debug("\tERA: 0x%08lx\n", kvm_read_hw_gcsr(LOONGARCH_CSR_ERA));
+
+	return 0;
+}
+
+int kvm_arch_vcpu_ioctl_get_mpstate(struct kvm_vcpu *vcpu,
+				struct kvm_mp_state *mp_state)
+{
+	*mp_state = vcpu->arch.mp_state;
+
+	return 0;
+}
+
+int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
+				struct kvm_mp_state *mp_state)
+{
+	int ret = 0;
+
+	switch (mp_state->mp_state) {
+	case KVM_MP_STATE_RUNNABLE:
+		vcpu->arch.mp_state = *mp_state;
+		break;
+	default:
+		ret = -EINVAL;
+	}
+
+	return ret;
+}
+
+int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
+					struct kvm_guest_debug *dbg)
+{
+	return -EINVAL;
+}
+
+/**
+ * kvm_migrate_count() - Migrate timer.
+ * @vcpu:       Virtual CPU.
+ *
+ * Migrate hrtimer to the current CPU by cancelling and restarting it
+ * if the hrtimer is active.
+ *
+ * Must be called when the vCPU is migrated to a different CPU, so that
+ * the timer can interrupt the guest at the new CPU, and the timer irq can
+ * be delivered to the vCPU.
+ */
+static void kvm_migrate_count(struct kvm_vcpu *vcpu)
+{
+	if (hrtimer_cancel(&vcpu->arch.swtimer))
+		hrtimer_restart(&vcpu->arch.swtimer);
+}
+
 static int _kvm_getcsr(struct kvm_vcpu *vcpu, unsigned int id, u64 *val)
 {
 	unsigned long gintc;
-- 
2.39.3

