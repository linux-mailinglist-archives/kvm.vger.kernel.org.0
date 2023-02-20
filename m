Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 463AF69C597
	for <lists+kvm@lfdr.de>; Mon, 20 Feb 2023 07:58:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230454AbjBTG54 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Feb 2023 01:57:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230312AbjBTG5o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Feb 2023 01:57:44 -0500
Received: from loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B13EAD536;
        Sun, 19 Feb 2023 22:57:39 -0800 (PST)
Received: from loongson.cn (unknown [10.2.5.185])
        by gateway (Coremail) with SMTP id _____8Cxf83iGfNjPbQCAA--.76S3;
        Mon, 20 Feb 2023 14:57:38 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8Ax+73fGfNjFvk2AA--.34690S8;
        Mon, 20 Feb 2023 14:57:37 +0800 (CST)
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
Subject: [PATCH v2 06/29] LoongArch: KVM: Implement vcpu create and destroy interface
Date:   Mon, 20 Feb 2023 14:57:12 +0800
Message-Id: <20230220065735.1282809-7-zhaotianrui@loongson.cn>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230220065735.1282809-1-zhaotianrui@loongson.cn>
References: <20230220065735.1282809-1-zhaotianrui@loongson.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8Ax+73fGfNjFvk2AA--.34690S8
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBjvJXoWxur1fAw1xCFy8ZF43ur17Jrb_yoW5ur1xpF
        WIkw15Ww48Jry3Jw1fWrn0vrn0qrW8uF17Wa47X3ySyr1DtryFvF4vkrWDAFZxXayfZF1I
        vF1rtF1Uuw4UAw7anT9S1TB71UUUUjJqnTZGkaVYY2UrUUUUj1kv1TuYvTs0mT0YCTnIWj
        qI5I8CrVACY4xI64kE6c02F40Ex7xfYxn0WfASr-VFAUDa7-sFnT9fnUUIcSsGvfJTRUUU
        b48Fc2x0x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3wA2ocxC64kIII0Yj41l84x0c7CEw4
        AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF
        7I0E14v26F4j6r4UJwA2z4x0Y4vEx4A2jsIE14v26r4UJVWxJr1l84ACjcxK6I8E87Iv6x
        kF7I0E14v26F4UJVW0owAaw2AFwI0_JF0_Jw1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAq
        jxCEc2xF0cIa020Ex4CE44I27wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E74AGY7Cv6c
        x26rWlOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JMxkF7I0En4kS14v26r12
        6r1DMxAIw28IcxkI7VAKI48JMxAIw28IcVCjz48v1sIEY20_WwCFx2IqxVCFs4IE7xkEbV
        WUJVW8JwCFI7km07C267AKxVWUAVWUtwC20s026c02F40E14v26r1j6r18MI8I3I0E7480
        Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7
        IYx2IY67AKxVW7JVWDJwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UMIIF0xvE42xK
        8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWxJVW8Jr1lIxAIcVC2z280aVCY1x
        0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7xRiTKZJUUUUU==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
 arch/loongarch/kvm/vcpu.c | 94 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 94 insertions(+)
 create mode 100644 arch/loongarch/kvm/vcpu.c

diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
new file mode 100644
index 000000000..4d355bcff
--- /dev/null
+++ b/arch/loongarch/kvm/vcpu.c
@@ -0,0 +1,94 @@
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
+	int i;
+	unsigned long timer_hz;
+	struct loongarch_csrs *csr;
+	struct kvm_context *kvm_context = per_cpu_ptr(vcpu->kvm->arch.vmcs, 0);
+
+	for_each_possible_cpu(i)
+		vcpu->arch.vpid[i] = 0;
+
+	hrtimer_init(&vcpu->arch.swtimer, CLOCK_MONOTONIC, HRTIMER_MODE_ABS_PINNED);
+	vcpu->arch.swtimer.function = kvm_swtimer_wakeup;
+	vcpu->arch.fpu_enabled = true;
+	vcpu->kvm->arch.online_vcpus = vcpu->vcpu_id + 1;
+
+	vcpu->arch.guest_eentry = (unsigned long)kvm_context->kvm_eentry;
+	vcpu->arch.vcpu_run = kvm_context->kvm_enter_guest;
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

