Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBAAB6F01A9
	for <lists+kvm@lfdr.de>; Thu, 27 Apr 2023 09:27:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243027AbjD0H1I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Apr 2023 03:27:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242844AbjD0H0z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Apr 2023 03:26:55 -0400
Received: from loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EDBB330EE
        for <kvm@vger.kernel.org>; Thu, 27 Apr 2023 00:26:53 -0700 (PDT)
Received: from loongson.cn (unknown [10.2.5.185])
        by gateway (Coremail) with SMTP id _____8AxGuq7I0pk8XcBAA--.2654S3;
        Thu, 27 Apr 2023 15:26:51 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8Axy7K1I0pk9Ec+AA--.18880S8;
        Thu, 27 Apr 2023 15:26:51 +0800 (CST)
From:   Tianrui Zhao <zhaotianrui@loongson.cn>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        gaosong@loongson.cn, "Michael S . Tsirkin" <mst@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, maobibo@loongson.cn,
        zhaotianrui@loongson.cn, philmd@linaro.org,
        richard.henderson@linaro.org, peter.maydell@linaro.org
Subject: [PATCH RFC v2 6/9] target/loongarch: Implement kvm_arch_init_vcpu
Date:   Thu, 27 Apr 2023 15:26:42 +0800
Message-Id: <20230427072645.3368102-7-zhaotianrui@loongson.cn>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230427072645.3368102-1-zhaotianrui@loongson.cn>
References: <20230427072645.3368102-1-zhaotianrui@loongson.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8Axy7K1I0pk9Ec+AA--.18880S8
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBjvJXoWxGw47Zw18CFykAFWDtw4kXrb_yoW5Jw4xpr
        Zru345Kr40qrZxt3Z3X3Z8Xr1DWr1xGr429ayxK34xZF43J343Xw4kt3s8AF45Aay8XFyv
        vF1F9w4j9FW8Xw7anT9S1TB71UUUUUJqnTZGkaVYY2UrUUUUj1kv1TuYvTs0mT0YCTnIWj
        qI5I8CrVACY4xI64kE6c02F40Ex7xfYxn0WfASr-VFAUDa7-sFnT9fnUUIcSsGvfJTRUUU
        b4xFc2x0x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3wA2ocxC64kIII0Yj41l84x0c7CEw4
        AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF
        7I0E14v26F4j6r4UJwA2z4x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4vEx4A2jsIEc7
        CjxVAFwI0_Cr1j6rxdM2kKe7AKxVWUXVWUAwAS0I0E0xvYzxvE52x082IY62kv0487Mc80
        4VCY07AIYIkI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VCjz48v1sIEY2
        0_WwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lc7CjxVAaw2AFwI0_JF0_
        Jw1l42xK82IYc2Ij64vIr41l42xK82IY6x8ErcxFaVAv8VWrMxC20s026xCaFVCjc4AY6r
        1j6r4UMxCIbckI1I0E14v26r1Y6r17MI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xv
        wVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjx
        v20xvE14v26ryj6F1UMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWxJVW8Jr1lIxAIcVCF04k2
        6cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r4UJVWxJr1lIxAIcVC2z280aVCY1x
        0267AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x0zRXo7NUUUUU=
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
 target/loongarch/cpu.h        |  1 +
 target/loongarch/kvm.c        | 23 +++++++++++++++++++++++
 target/loongarch/trace-events |  2 ++
 3 files changed, 26 insertions(+)

diff --git a/target/loongarch/cpu.h b/target/loongarch/cpu.h
index 86b9f26d60..473d9986f3 100644
--- a/target/loongarch/cpu.h
+++ b/target/loongarch/cpu.h
@@ -350,6 +350,7 @@ struct ArchCPU {
 
     /* 'compatible' string for this CPU for Linux device trees */
     const char *dtb_compatible;
+    uint64_t counter_value;
 };
 
 #define TYPE_LOONGARCH_CPU "loongarch-cpu"
diff --git a/target/loongarch/kvm.c b/target/loongarch/kvm.c
index 8dea294930..59d7e35490 100644
--- a/target/loongarch/kvm.c
+++ b/target/loongarch/kvm.c
@@ -393,8 +393,31 @@ int kvm_arch_put_registers(CPUState *cs, int level)
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
+                             &cpu->counter_value);
+        if (ret < 0) {
+            trace_kvm_failed_put_counter(strerror(errno));
+        }
+    } else {
+        ret = kvm_larch_getq(cs, KVM_REG_LOONGARCH_COUNTER,
+                             &cpu->counter_value);
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

