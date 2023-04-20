Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EB446E8E39
	for <lists+kvm@lfdr.de>; Thu, 20 Apr 2023 11:37:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234457AbjDTJgz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Apr 2023 05:36:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234362AbjDTJga (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Apr 2023 05:36:30 -0400
Received: from loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5120C40CD
        for <kvm@vger.kernel.org>; Thu, 20 Apr 2023 02:36:10 -0700 (PDT)
Received: from loongson.cn (unknown [10.2.5.185])
        by gateway (Coremail) with SMTP id _____8Ax69mJB0Fku3EfAA--.48920S3;
        Thu, 20 Apr 2023 17:36:09 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8DxwOSGB0FkUfEwAA--.29752S5;
        Thu, 20 Apr 2023 17:36:08 +0800 (CST)
From:   Tianrui Zhao <zhaotianrui@loongson.cn>
To:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>, gaosong@loongson.cn
Cc:     "Michael S . Tsirkin" <mst@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, maobibo@loongson.cn,
        zhaotianrui@loongson.cn
Subject: [PATCH RFC v1 03/10] target/loongarch: Supplement vcpu env initial when vcpu reset
Date:   Thu, 20 Apr 2023 17:35:59 +0800
Message-Id: <20230420093606.3366969-4-zhaotianrui@loongson.cn>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230420093606.3366969-1-zhaotianrui@loongson.cn>
References: <20230420093606.3366969-1-zhaotianrui@loongson.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8DxwOSGB0FkUfEwAA--.29752S5
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBjvJXoW7ur4fGr1fJFyDGrWUur48JFb_yoW8uryUpr
        9I9rZFy3yrtFZ7A3Z3G3s8Kw1DXr4xKw1Iva9akas2kF4jqr1rZFWvg3sFyFW7AayrAr4x
        ZF15Jr15XF47XF7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUj1kv1TuYvTs0mT0YCTnIWj
        qI5I8CrVACY4xI64kE6c02F40Ex7xfYxn0WfASr-VFAUDa7-sFnT9fnUUIcSsGvfJTRUUU
        b0xFc2x0x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3wA2ocxC64kIII0Yj41l84x0c7CEw4
        AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF
        7I0E14v26r4j6F4UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
        0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2x26I8E6xAC
        xx1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6x8ErcxFaVAv8VWrMcvjeVCFs4IE7xkEbV
        WUJVW8JwACjcxG0xvY0x0EwIxGrwCF04k20xvY0x0EwIxGrwCF04k20xvE74AGY7Cv6cx2
        6rWl4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8Gjc
        xK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0
        cI8IcVAFwI0_JFI_Gr1lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8V
        AvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWxJwCI42IY6I8E87Iv6xkF7I0E
        14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvj4RC_MaUUUUU
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Supplement vcpu env initial when vcpu reset, including
init vcpu mp_state value to KVM_MP_STATE_RUNNABLE and
init vcpu CSR_CPUID,CSR_TID to cpu->cpu_index.

Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
---
 target/loongarch/cpu.c | 3 +++
 target/loongarch/cpu.h | 2 ++
 2 files changed, 5 insertions(+)

diff --git a/target/loongarch/cpu.c b/target/loongarch/cpu.c
index 97e6579f6a..600c00bbf2 100644
--- a/target/loongarch/cpu.c
+++ b/target/loongarch/cpu.c
@@ -486,10 +486,12 @@ static void loongarch_cpu_reset_hold(Object *obj)
 
     env->CSR_ESTAT = env->CSR_ESTAT & (~MAKE_64BIT_MASK(0, 2));
     env->CSR_RVACFG = FIELD_DP64(env->CSR_RVACFG, CSR_RVACFG, RBITS, 0);
+    env->CSR_CPUID = cs->cpu_index;
     env->CSR_TCFG = FIELD_DP64(env->CSR_TCFG, CSR_TCFG, EN, 0);
     env->CSR_LLBCTL = FIELD_DP64(env->CSR_LLBCTL, CSR_LLBCTL, KLO, 0);
     env->CSR_TLBRERA = FIELD_DP64(env->CSR_TLBRERA, CSR_TLBRERA, ISTLBR, 0);
     env->CSR_MERRCTL = FIELD_DP64(env->CSR_MERRCTL, CSR_MERRCTL, ISMERR, 0);
+    env->CSR_TID = cs->cpu_index;
 
     env->CSR_PRCFG3 = FIELD_DP64(env->CSR_PRCFG3, CSR_PRCFG3, TLB_TYPE, 2);
     env->CSR_PRCFG3 = FIELD_DP64(env->CSR_PRCFG3, CSR_PRCFG3, MTLB_ENTRY, 63);
@@ -510,6 +512,7 @@ static void loongarch_cpu_reset_hold(Object *obj)
 
     restore_fp_status(env);
     cs->exception_index = -1;
+    env->mp_state = KVM_MP_STATE_RUNNABLE;
 }
 
 static void loongarch_cpu_disas_set_info(CPUState *s, disassemble_info *info)
diff --git a/target/loongarch/cpu.h b/target/loongarch/cpu.h
index e11c875188..86b9f26d60 100644
--- a/target/loongarch/cpu.h
+++ b/target/loongarch/cpu.h
@@ -288,6 +288,7 @@ typedef struct CPUArchState {
     uint64_t CSR_PWCH;
     uint64_t CSR_STLBPS;
     uint64_t CSR_RVACFG;
+    uint64_t CSR_CPUID;
     uint64_t CSR_PRCFG1;
     uint64_t CSR_PRCFG2;
     uint64_t CSR_PRCFG3;
@@ -328,6 +329,7 @@ typedef struct CPUArchState {
     MemoryRegion iocsr_mem;
     bool load_elf;
     uint64_t elf_address;
+    uint32_t mp_state;
 #endif
 } CPULoongArchState;
 
-- 
2.31.1

