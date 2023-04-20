Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B62116E8E3C
	for <lists+kvm@lfdr.de>; Thu, 20 Apr 2023 11:37:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234516AbjDTJhA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Apr 2023 05:37:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234089AbjDTJgj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Apr 2023 05:36:39 -0400
Received: from loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 64F6630F9
        for <kvm@vger.kernel.org>; Thu, 20 Apr 2023 02:36:11 -0700 (PDT)
Received: from loongson.cn (unknown [10.2.5.185])
        by gateway (Coremail) with SMTP id _____8BxMI+KB0FkxXEfAA--.49374S3;
        Thu, 20 Apr 2023 17:36:10 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8DxwOSGB0FkUfEwAA--.29752S8;
        Thu, 20 Apr 2023 17:36:10 +0800 (CST)
From:   Tianrui Zhao <zhaotianrui@loongson.cn>
To:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>, gaosong@loongson.cn
Cc:     "Michael S . Tsirkin" <mst@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, maobibo@loongson.cn,
        zhaotianrui@loongson.cn
Subject: [PATCH RFC v1 06/10] target/loongarch: Implement kvm_arch_init_vcpu
Date:   Thu, 20 Apr 2023 17:36:02 +0800
Message-Id: <20230420093606.3366969-7-zhaotianrui@loongson.cn>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230420093606.3366969-1-zhaotianrui@loongson.cn>
References: <20230420093606.3366969-1-zhaotianrui@loongson.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8DxwOSGB0FkUfEwAA--.29752S8
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBjvJXoWxJry3Cw13Kr17Ary5Gw15Arb_yoW8Cr4Upr
        ZrAry5Kr40qrZ7X3WfJ3Z8Xrn8Wr1xGr429ayxt34rZrs8J348Xw1kt3srAF15Aa4Fgry0
        vF1Fvw1j9a18XwUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUj1kv1TuYvTs0mT0YCTnIWj
        qI5I8CrVACY4xI64kE6c02F40Ex7xfYxn0WfASr-VFAUDa7-sFnT9fnUUIcSsGvfJTRUUU
        b0kFc2x0x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3wA2ocxC64kIII0Yj41l84x0c7CEw4
        AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF
        7I0E14v26F4j6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
        0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07AIYIkI8VC2zVCF
        FI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VCjz48v1sIEY20_WwAm72CE4IkC6x0Yz7
        v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41l42xK82IYc2Ij64vIr41l42xK82IY6x8ErcxFaVAv
        8VWrMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7
        xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xII
        jxv20xvE14v26r4j6ryUMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw2
        0EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x02
        67AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7xRE6wZ7UUUUU==
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
 target/loongarch/cpu.h |  1 +
 target/loongarch/kvm.c | 23 +++++++++++++++++++++++
 2 files changed, 24 insertions(+)

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
index 53f495a588..f8772bbb27 100644
--- a/target/loongarch/kvm.c
+++ b/target/loongarch/kvm.c
@@ -397,8 +397,31 @@ int kvm_arch_put_registers(CPUState *cs, int level)
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
+            printf("%s: Failed to put counter_value (%d)\n", __func__, ret);
+        }
+    } else {
+        ret = kvm_larch_getq(cs, KVM_REG_LOONGARCH_COUNTER,
+                             &cpu->counter_value);
+        if (ret < 0) {
+            printf("%s: Failed to get counter_value (%d)\n", __func__, ret);
+        }
+    }
+}
+
 int kvm_arch_init_vcpu(CPUState *cs)
 {
+    qemu_add_vm_change_state_handler(kvm_loongarch_vm_stage_change, cs);
     return 0;
 }
 
-- 
2.31.1

