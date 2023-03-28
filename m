Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6147A6CBF1A
	for <lists+kvm@lfdr.de>; Tue, 28 Mar 2023 14:31:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232546AbjC1Mbq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 08:31:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231819AbjC1Mbh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 08:31:37 -0400
Received: from loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0119A9771;
        Tue, 28 Mar 2023 05:31:22 -0700 (PDT)
Received: from loongson.cn (unknown [10.2.5.185])
        by gateway (Coremail) with SMTP id _____8Dx_5cZ3iJk2BgTAA--.29615S3;
        Tue, 28 Mar 2023 20:31:21 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8CxPL4X3iJku2cPAA--.12046S8;
        Tue, 28 Mar 2023 20:31:21 +0800 (CST)
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
Subject: [PING PATCH v4 06/29] LoongArch: KVM: Implement vcpu create and destroy interface
Date:   Tue, 28 Mar 2023 20:30:56 +0800
Message-Id: <20230328123119.3649361-7-zhaotianrui@loongson.cn>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230328123119.3649361-1-zhaotianrui@loongson.cn>
References: <20230328123119.3649361-1-zhaotianrui@loongson.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8CxPL4X3iJku2cPAA--.12046S8
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBjvJXoWxur1fAw1xCF1xCFyrAw17GFg_yoW5CrWrpF
        WxCw15Ww48J347Jw1fXrn0vrn0qrW8ur12ga47X3ySyr1DtryFvF4vkrWDAFZxXayfZF1I
        qF1rJF1Uuw4UAw7anT9S1TB71UUUUjJqnTZGkaVYY2UrUUUUj1kv1TuYvTs0mT0YCTnIWj
        qI5I8CrVACY4xI64kE6c02F40Ex7xfYxn0WfASr-VFAUDa7-sFnT9fnUUIcSsGvfJTRUUU
        bcAFc2x0x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3wA2ocxC64kIII0Yj41l84x0c7CEw4
        AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF
        7I0E14v26F4j6r4UJwA2z4x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4vEx4A2jsIEc7
        CjxVAFwI0_Cr1j6rxdM2kKe7AKxVWUAVWUtwAS0I0E0xvYzxvE52x082IY62kv0487Mc80
        4VCY07AIYIkI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VCjz48v1sIEY2
        0_WwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lc7CjxVAaw2AFwI0_JF0_
        Jw1l42xK82IYc2Ij64vIr41l42xK82IY6x8ErcxFaVAv8VWrMxC20s026xCaFVCjc4AY6r
        1j6r4UMxCIbckI1I0E14v26r126r1DMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xv
        wVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjx
        v20xvE14v26F1j6w1UMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWxJVW8Jr1lIxAIcVCF04k2
        6cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26F4j6r4UJwCI42IY6I8E87Iv6xkF7I
        0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvj4RKpBTUUUUU
X-Spam-Status: No, score=-0.0 required=5.0 tests=SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Implement vcpu create and destroy interface, saving some info
into vcpu arch structure such as vcpu exception entrance, vcpu
enter guest pointer, etc. Init vcpu timer and set address
translation mode when vcpu create.

Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
---
 arch/loongarch/kvm/vcpu.c | 89 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 89 insertions(+)
 create mode 100644 arch/loongarch/kvm/vcpu.c

diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
new file mode 100644
index 000000000..7af2ff64b
--- /dev/null
+++ b/arch/loongarch/kvm/vcpu.c
@@ -0,0 +1,89 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2020-2023 Loongson Technology Corporation Limited
+ */
+
+#include <linux/kvm_host.h>
+#include <asm/fpu.h>
+#include <asm/loongarch.h>
+#include <asm/setup.h>
+#include <asm/time.h>
+#include <asm/kvm_host.h>
+
+#define CREATE_TRACE_POINTS
+#include "trace.h"
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
+	vcpu->kvm->arch.online_vcpus = vcpu->vcpu_id + 1;
+
+	vcpu->arch.guest_eentry = (unsigned long)kvm_loongarch_ops->guest_eentry;
+	vcpu->arch.handle_exit = _kvm_handle_exit;
+	vcpu->arch.csr = kzalloc(sizeof(struct loongarch_csrs), GFP_KERNEL);
+	if (!vcpu->arch.csr)
+		return -ENOMEM;
+
+	/*
+	 * kvm all exceptions share one exception entry, and host <-> guest switch
+	 * also switch excfg.VS field, keep host excfg.VS info here
+	 */
+	vcpu->arch.host_ecfg = (read_csr_ecfg() & CSR_ECFG_VS);
+
+	/* Init */
+	vcpu->arch.last_sched_cpu = -1;
+	vcpu->arch.last_exec_cpu = -1;
+
+	/*
+	 * Initialize guest register state to valid architectural reset state.
+	 */
+	timer_hz = calc_const_freq();
+	kvm_init_timer(vcpu, timer_hz);
+
+	/* Set Initialize mode for GUEST */
+	csr = vcpu->arch.csr;
+	kvm_write_sw_gcsr(csr, LOONGARCH_CSR_CRMD, CSR_CRMD_DA);
+
+	/* Set cpuid */
+	kvm_write_sw_gcsr(csr, LOONGARCH_CSR_TMID, vcpu->vcpu_id);
+
+	/* start with no pending virtual guest interrupts */
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
+	 * If the VCPU is freed and reused as another VCPU, we don't want the
+	 * matching pointer wrongly hanging around in last_vcpu.
+	 */
+	for_each_possible_cpu(cpu) {
+		context = per_cpu_ptr(vcpu->kvm->arch.vmcs, cpu);
+		if (context->last_vcpu == vcpu)
+			context->last_vcpu = NULL;
+	}
+}
-- 
2.31.1

