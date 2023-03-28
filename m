Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9C556CBF23
	for <lists+kvm@lfdr.de>; Tue, 28 Mar 2023 14:32:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232732AbjC1Mb4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 08:31:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232562AbjC1Mbr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 08:31:47 -0400
Received: from loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CCE809754;
        Tue, 28 Mar 2023 05:31:25 -0700 (PDT)
Received: from loongson.cn (unknown [10.2.5.185])
        by gateway (Coremail) with SMTP id _____8AxJDQb3iJkJBkTAA--.29844S3;
        Tue, 28 Mar 2023 20:31:23 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8CxPL4X3iJku2cPAA--.12046S15;
        Tue, 28 Mar 2023 20:31:22 +0800 (CST)
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
Subject: [PING PATCH v4 13/29] LoongArch: KVM: Implement misc vcpu related interfaces
Date:   Tue, 28 Mar 2023 20:31:03 +0800
Message-Id: <20230328123119.3649361-14-zhaotianrui@loongson.cn>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230328123119.3649361-1-zhaotianrui@loongson.cn>
References: <20230328123119.3649361-1-zhaotianrui@loongson.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8CxPL4X3iJku2cPAA--.12046S15
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBjvJXoWxJw4kXFW3JF4xtry7uF4fuFg_yoW5Cry5pr
        1xC3y5X3yrGr47Gw1ftrs09rsI9w4kKr17Zry7W3yavr4DKF15Jw48KrWDAFW5Jr1rZF1S
        vrn8Ja1Dua1Yya7anT9S1TB71UUUUjJqnTZGkaVYY2UrUUUUj1kv1TuYvTs0mT0YCTnIWj
        qI5I8CrVACY4xI64kE6c02F40Ex7xfYxn0WfASr-VFAUDa7-sFnT9fnUUIcSsGvfJTRUUU
        b4AFc2x0x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3wA2ocxC64kIII0Yj41l84x0c7CEw4
        AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF
        7I0E14v26r4UJVWxJr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6x
        kF7I0E14v26F4UJVW0owAaw2AFwI0_JF0_Jw1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAq
        jxCEc2xF0cIa020Ex4CE44I27wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E74AGY7Cv6c
        x26rWlOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JMxkF7I0En4kS14v26r12
        6r1DMxAIw28IcxkI7VAKI48JMxAIw28IcVCjz48v1sIEY20_WwCFx2IqxVCFs4IE7xkEbV
        WUJVW8JwCFI7km07C267AKxVWUAVWUtwC20s026c02F40E14v26r1j6r18MI8I3I0E7480
        Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7
        IYx2IY67AKxVWDJVCq3wCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJwCI42IY6xAI
        w20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr1j6F4UJwCI42IY6I8E87Iv6x
        kF7I0E14v26r4UJVWxJrUvcSsGvfC2KfnxnUUI43ZEXa7xRiTKZJUUUUU==
X-Spam-Status: No, score=-0.0 required=5.0 tests=SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Implement some misc vcpu relaterd interfaces, such as vcpu runnable,
vcpu should kick, vcpu dump regs, etc.

Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
---
 arch/loongarch/kvm/vcpu.c | 95 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 95 insertions(+)

diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
index 4c3b41fd1..131aa2240 100644
--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -13,6 +13,101 @@
 #define CREATE_TRACE_POINTS
 #include "trace.h"
 
+int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu)
+{
+	return !!(vcpu->arch.irq_pending);
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
+	return _kvm_pending_timer(vcpu) ||
+		kvm_read_hw_gcsr(LOONGARCH_CSR_ESTAT) &
+			(1 << (EXCCODE_TIMER - EXCCODE_INT_START));
+}
+
+int kvm_arch_vcpu_dump_regs(struct kvm_vcpu *vcpu)
+{
+	int i;
+
+	if (!vcpu)
+		return -1;
+
+	kvm_debug("VCPU Register Dump:\n");
+	kvm_debug("\tpc = 0x%08lx\n", vcpu->arch.pc);
+	kvm_debug("\texceptions: %08lx\n", vcpu->arch.irq_pending);
+
+	for (i = 0; i < 32; i += 4) {
+		kvm_debug("\tgpr%02d: %08lx %08lx %08lx %08lx\n", i,
+		       vcpu->arch.gprs[i],
+		       vcpu->arch.gprs[i + 1],
+		       vcpu->arch.gprs[i + 2], vcpu->arch.gprs[i + 3]);
+	}
+
+	kvm_debug("\tCRMOD: 0x%08llx, exst: 0x%08llx\n",
+		  kvm_read_hw_gcsr(LOONGARCH_CSR_CRMD),
+		  kvm_read_hw_gcsr(LOONGARCH_CSR_ESTAT));
+
+	kvm_debug("\tERA: 0x%08llx\n", kvm_read_hw_gcsr(LOONGARCH_CSR_ERA));
+
+	return 0;
+}
+
+int kvm_arch_vcpu_ioctl_get_mpstate(struct kvm_vcpu *vcpu,
+				    struct kvm_mp_state *mp_state)
+{
+	return -ENOIOCTLCMD;
+}
+
+int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
+				    struct kvm_mp_state *mp_state)
+{
+	return -ENOIOCTLCMD;
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
+ * if it was running prior to being cancelled.
+ *
+ * Must be called when the VCPU is migrated to a different CPU to ensure that
+ * timer expiry during guest execution interrupts the guest and causes the
+ * interrupt to be delivered in a timely manner.
+ */
+static void kvm_migrate_count(struct kvm_vcpu *vcpu)
+{
+	if (hrtimer_cancel(&vcpu->arch.swtimer))
+		hrtimer_restart(&vcpu->arch.swtimer);
+}
+
 int _kvm_getcsr(struct kvm_vcpu *vcpu, unsigned int id, u64 *v)
 {
 	unsigned long val;
-- 
2.31.1

