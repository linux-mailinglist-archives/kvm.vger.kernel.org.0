Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 933B06F01B1
	for <lists+kvm@lfdr.de>; Thu, 27 Apr 2023 09:27:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243104AbjD0H1R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Apr 2023 03:27:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242999AbjD0H04 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Apr 2023 03:26:56 -0400
Received: from loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BB4E1E78
        for <kvm@vger.kernel.org>; Thu, 27 Apr 2023 00:26:54 -0700 (PDT)
Received: from loongson.cn (unknown [10.2.5.185])
        by gateway (Coremail) with SMTP id _____8DxyOm8I0pk9XcBAA--.2563S3;
        Thu, 27 Apr 2023 15:26:52 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8Axy7K1I0pk9Ec+AA--.18880S9;
        Thu, 27 Apr 2023 15:26:51 +0800 (CST)
From:   Tianrui Zhao <zhaotianrui@loongson.cn>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        gaosong@loongson.cn, "Michael S . Tsirkin" <mst@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, maobibo@loongson.cn,
        zhaotianrui@loongson.cn, philmd@linaro.org,
        richard.henderson@linaro.org, peter.maydell@linaro.org
Subject: [PATCH RFC v2 7/9] target/loongarch: Implement kvm_arch_handle_exit
Date:   Thu, 27 Apr 2023 15:26:43 +0800
Message-Id: <20230427072645.3368102-8-zhaotianrui@loongson.cn>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230427072645.3368102-1-zhaotianrui@loongson.cn>
References: <20230427072645.3368102-1-zhaotianrui@loongson.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8Axy7K1I0pk9Ec+AA--.18880S9
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBjvJXoW7Cw4UJF1rZry8CryfGr17Jrb_yoW8Zw18pa
        9Fvrn0kr48J39Fq3ZIg3Z8Xr1UXrWxWF42qay7t3yfZr43Xry3ZF4kK3sIvFW5G3y8XayF
        qF18Zr1q9F1jqw7anT9S1TB71UUUUUJqnTZGkaVYY2UrUUUUj1kv1TuYvTs0mT0YCTnIWj
        qI5I8CrVACY4xI64kE6c02F40Ex7xfYxn0WfASr-VFAUDa7-sFnT9fnUUIcSsGvfJTRUUU
        b4xFc2x0x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3wA2ocxC64kIII0Yj41l84x0c7CEw4
        AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF
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

Implement kvm_arch_handle_exit for loongarch. In this
function, the KVM_EXIT_LOONGARCH_IOCSR is handled,
we read or write the iocsr address space by the addr,
length and is_write argument in kvm_run.

Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
---
 target/loongarch/kvm.c        | 24 +++++++++++++++++++++++-
 target/loongarch/trace-events |  1 +
 2 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/target/loongarch/kvm.c b/target/loongarch/kvm.c
index 59d7e35490..bd994926d9 100644
--- a/target/loongarch/kvm.c
+++ b/target/loongarch/kvm.c
@@ -494,7 +494,29 @@ bool kvm_arch_cpu_check_are_resettable(void)
 
 int kvm_arch_handle_exit(CPUState *cs, struct kvm_run *run)
 {
-    return 0;
+    int ret = 0;
+    LoongArchCPU *cpu = LOONGARCH_CPU(cs);
+    CPULoongArchState *env = &cpu->env;
+    MemTxAttrs attrs = {};
+
+    attrs.requester_id = env_cpu(env)->cpu_index;
+
+    trace_kvm_arch_handle_exit(run->exit_reason);
+    switch (run->exit_reason) {
+    case KVM_EXIT_LOONGARCH_IOCSR:
+        address_space_rw(&env->address_space_iocsr,
+                         run->iocsr_io.phys_addr,
+                         attrs,
+                         run->iocsr_io.data,
+                         run->iocsr_io.len,
+                         run->iocsr_io.is_write);
+        break;
+    default:
+        ret = -1;
+        warn_report("KVM: unknown exit reason %d", run->exit_reason);
+        break;
+    }
+    return ret;
 }
 
 void kvm_arch_accel_class_init(ObjectClass *oc)
diff --git a/target/loongarch/trace-events b/target/loongarch/trace-events
index 6926bbe399..c79e01663a 100644
--- a/target/loongarch/trace-events
+++ b/target/loongarch/trace-events
@@ -11,3 +11,4 @@ kvm_failed_get_mpstate(const char *msg) "Failed to get mp_state from KVM: %s"
 kvm_failed_put_mpstate(const char *msg) "Failed to put mp_state into KVM: %s"
 kvm_failed_get_counter(const char *msg) "Failed to get counter from KVM: %s"
 kvm_failed_put_counter(const char *msg) "Failed to put counter into KVM: %s"
+kvm_arch_handle_exit(int num) "kvm arch handle exit, the reason number: %d"
-- 
2.31.1

