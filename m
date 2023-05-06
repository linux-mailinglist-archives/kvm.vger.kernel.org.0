Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4B3B6F8DF9
	for <lists+kvm@lfdr.de>; Sat,  6 May 2023 04:24:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231536AbjEFCYs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 May 2023 22:24:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231278AbjEFCYg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 May 2023 22:24:36 -0400
Received: from loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 578B97A83
        for <kvm@vger.kernel.org>; Fri,  5 May 2023 19:24:35 -0700 (PDT)
Received: from loongson.cn (unknown [10.2.5.185])
        by gateway (Coremail) with SMTP id _____8AxHutgulVkCooFAA--.9098S3;
        Sat, 06 May 2023 10:24:32 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8DxOLZXulVkj9RMAA--.9112S8;
        Sat, 06 May 2023 10:24:31 +0800 (CST)
From:   Tianrui Zhao <zhaotianrui@loongson.cn>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        gaosong@loongson.cn, "Michael S . Tsirkin" <mst@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, maobibo@loongson.cn,
        zhaotianrui@loongson.cn, philmd@linaro.org,
        richard.henderson@linaro.org, peter.maydell@linaro.org
Subject: [PATCH RFC v3 6/9] target/loongarch: Implement kvm_arch_init_vcpu
Date:   Sat,  6 May 2023 10:24:19 +0800
Message-Id: <20230506022422.59442-7-zhaotianrui@loongson.cn>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230506022422.59442-1-zhaotianrui@loongson.cn>
References: <20230506022422.59442-1-zhaotianrui@loongson.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8DxOLZXulVkj9RMAA--.9112S8
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBjvJXoWxGw47uryrWw1DGr47AF4xJFb_yoW5GFW7pr
        Zrurn8Kr48JrZxt3Z3X3Z8Xr1DWr4xGF42vayxK34fAF43J34fZw4kt3s8AF45Jay8XFyv
        q3WY9w4q9ay8Xw7anT9S1TB71UUUUUJqnTZGkaVYY2UrUUUUj1kv1TuYvTs0mT0YCTnIWj
        qI5I8CrVACY4xI64kE6c02F40Ex7xfYxn0WfASr-VFAUDa7-sFnT9fnUUIcSsGvfJTRUUU
        b48Fc2x0x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3wA2ocxC64kIII0Yj41l84x0c7CEw4
        AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF
        7I0E14v26F4j6r4UJwA2z4x0Y4vEx4A2jsIE14v26r4UJVWxJr1l84ACjcxK6I8E87Iv6x
        kF7I0E14v26r4UJVWxJr1ln4kS14v26r1Y6r17M2AIxVAIcxkEcVAq07x20xvEncxIr21l
        57IF6xkI12xvs2x26I8E6xACxx1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6x8ErcxFaV
        Av8VWrMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwCY1x0262kKe7AKxVWU
        AVWUtwCF04k20xvY0x0EwIxGrwCF04k20xvE74AGY7Cv6cx26rWl4I8I3I0E4IkC6x0Yz7
        v_Jr0_Gr1l4IxYO2xFxVAFwI0_Jrv_JF1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8G
        jcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2I
        x0cI8IcVAFwI0_Xr0_Ar1lIxAIcVC0I7IYx2IY6xkF7I0E14v26F4j6r4UJwCI42IY6xAI
        w20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x
        0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7xRR5l1PUUUUU==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Implement kvm_arch_init_vcpu interface for loongarch,
in this function, we register VM change state handler.
And when VM state changes to running, the counter value
should be put into kvm to keep consistent with kvm,
and when state change to stop, counter value should be
refreshed from kvm.

Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
---
 target/loongarch/cpu.h        |  2 ++
 target/loongarch/kvm.c        | 23 +++++++++++++++++++++++
 target/loongarch/trace-events |  2 ++
 3 files changed, 27 insertions(+)

diff --git a/target/loongarch/cpu.h b/target/loongarch/cpu.h
index cf3fce4577..beb070de25 100644
--- a/target/loongarch/cpu.h
+++ b/target/loongarch/cpu.h
@@ -350,6 +350,8 @@ struct ArchCPU {
 
     /* 'compatible' string for this CPU for Linux device trees */
     const char *dtb_compatible;
+    /* used by KVM_REG_LOONGARCH_COUNTER ioctl to access guest time counters */
+    uint64_t kvm_state_counter;
 };
 
 #define TYPE_LOONGARCH_CPU "loongarch-cpu"
diff --git a/target/loongarch/kvm.c b/target/loongarch/kvm.c
index dac65f546e..5a07cc58c8 100644
--- a/target/loongarch/kvm.c
+++ b/target/loongarch/kvm.c
@@ -399,8 +399,31 @@ int kvm_arch_put_registers(CPUState *cs, int level)
     return ret;
 }
 
+static void kvm_loongarch_vm_stage_change(void *opaque, bool running,
+                                          RunState state)
+{
+    int ret;
+    CPUState *cs = opaque;
+    LoongArchCPU *cpu = LOONGARCH_CPU(cs);
+
+    if (running) {
+        ret = kvm_larch_putq(cs, KVM_REG_LOONGARCH_COUNTER,
+                             &cpu->kvm_state_counter);
+        if (ret < 0) {
+            trace_kvm_failed_put_counter(strerror(errno));
+        }
+    } else {
+        ret = kvm_larch_getq(cs, KVM_REG_LOONGARCH_COUNTER,
+                             &cpu->kvm_state_counter);
+        if (ret < 0) {
+            trace_kvm_failed_get_counter(strerror(errno));
+        }
+    }
+}
+
 int kvm_arch_init_vcpu(CPUState *cs)
 {
+    qemu_add_vm_change_state_handler(kvm_loongarch_vm_stage_change, cs);
     return 0;
 }
 
diff --git a/target/loongarch/trace-events b/target/loongarch/trace-events
index 67817fee67..6926bbe399 100644
--- a/target/loongarch/trace-events
+++ b/target/loongarch/trace-events
@@ -9,3 +9,5 @@ kvm_failed_get_fpu(const char *msg) "Failed to get fpu from KVM: %s"
 kvm_failed_put_fpu(const char *msg) "Failed to put fpu into KVM: %s"
 kvm_failed_get_mpstate(const char *msg) "Failed to get mp_state from KVM: %s"
 kvm_failed_put_mpstate(const char *msg) "Failed to put mp_state into KVM: %s"
+kvm_failed_get_counter(const char *msg) "Failed to get counter from KVM: %s"
+kvm_failed_put_counter(const char *msg) "Failed to put counter into KVM: %s"
-- 
2.31.1

