Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1D1B7BFF27
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 16:25:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233057AbjJJOZ4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 10:25:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232288AbjJJOZw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 10:25:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4572A7
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 07:25:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696947905;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2rhL/1dKBJ7I7XG88xbTal3/xTAn672281HftEnuaUA=;
        b=E1cXy6MH2NiOuJBB14Rmxuq1FPjKBB9MOBYoMwvAO8YT1K6vVnsE6RrYom9JwY/c1wYknp
        O/ZEJaNKb7cvghsKA1e7wSd5rWZyTPKAc6DRUkuSQRFxN7dkZB0DmDp86vHVKqqoQGBxmi
        5VHPgC753DS+fe+giyqZDtSrjayMzZg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-675-BdP-E0pTPfuoW1UX2CxwUA-1; Tue, 10 Oct 2023 10:25:00 -0400
X-MC-Unique: BdP-E0pTPfuoW1UX2CxwUA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A215F185A7B3;
        Tue, 10 Oct 2023 14:24:59 +0000 (UTC)
Received: from gondolin.str.redhat.com (dhcp-192-239.str.redhat.com [10.33.192.239])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B778521CAC6B;
        Tue, 10 Oct 2023 14:24:58 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Peter Maydell <peter.maydell@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Gavin Shan <gshan@redhat.com>, qemu-arm@nongnu.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Cornelia Huck <cohuck@redhat.com>
Subject: [PATCH v2 2/3] arm/kvm: convert to kvm_get_one_reg
Date:   Tue, 10 Oct 2023 16:24:52 +0200
Message-ID: <20231010142453.224369-3-cohuck@redhat.com>
In-Reply-To: <20231010142453.224369-1-cohuck@redhat.com>
References: <20231010142453.224369-1-cohuck@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We can neaten the code by switching the callers that work on a
CPUstate to the kvm_get_one_reg function.

Reviewed-by: Gavin Shan <gshan@redhat.com>
Signed-off-by: Cornelia Huck <cohuck@redhat.com>
---
 target/arm/kvm.c   | 15 +++---------
 target/arm/kvm64.c | 57 ++++++++++++----------------------------------
 2 files changed, 18 insertions(+), 54 deletions(-)

diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index 1a8084c4601c..7903e2ddde1b 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -553,24 +553,19 @@ bool write_kvmstate_to_list(ARMCPU *cpu)
     bool ok = true;
 
     for (i = 0; i < cpu->cpreg_array_len; i++) {
-        struct kvm_one_reg r;
         uint64_t regidx = cpu->cpreg_indexes[i];
         uint32_t v32;
         int ret;
 
-        r.id = regidx;
-
         switch (regidx & KVM_REG_SIZE_MASK) {
         case KVM_REG_SIZE_U32:
-            r.addr = (uintptr_t)&v32;
-            ret = kvm_vcpu_ioctl(cs, KVM_GET_ONE_REG, &r);
+            ret = kvm_get_one_reg(cs, regidx, &v32);
             if (!ret) {
                 cpu->cpreg_values[i] = v32;
             }
             break;
         case KVM_REG_SIZE_U64:
-            r.addr = (uintptr_t)(cpu->cpreg_values + i);
-            ret = kvm_vcpu_ioctl(cs, KVM_GET_ONE_REG, &r);
+            ret = kvm_get_one_reg(cs, regidx, cpu->cpreg_values + i);
             break;
         default:
             g_assert_not_reached();
@@ -706,17 +701,13 @@ int kvm_arm_sync_mpstate_to_qemu(ARMCPU *cpu)
 void kvm_arm_get_virtual_time(CPUState *cs)
 {
     ARMCPU *cpu = ARM_CPU(cs);
-    struct kvm_one_reg reg = {
-        .id = KVM_REG_ARM_TIMER_CNT,
-        .addr = (uintptr_t)&cpu->kvm_vtime,
-    };
     int ret;
 
     if (cpu->kvm_vtime_dirty) {
         return;
     }
 
-    ret = kvm_vcpu_ioctl(cs, KVM_GET_ONE_REG, &reg);
+    ret = kvm_get_one_reg(cs, KVM_REG_ARM_TIMER_CNT, &cpu->kvm_vtime);
     if (ret) {
         error_report("Failed to get KVM_REG_ARM_TIMER_CNT");
         abort();
diff --git a/target/arm/kvm64.c b/target/arm/kvm64.c
index 047b269a7918..558c0b88dd69 100644
--- a/target/arm/kvm64.c
+++ b/target/arm/kvm64.c
@@ -909,14 +909,11 @@ int kvm_arch_put_registers(CPUState *cs, int level)
 static int kvm_arch_get_fpsimd(CPUState *cs)
 {
     CPUARMState *env = &ARM_CPU(cs)->env;
-    struct kvm_one_reg reg;
     int i, ret;
 
     for (i = 0; i < 32; i++) {
         uint64_t *q = aa64_vfp_qreg(env, i);
-        reg.id = AARCH64_SIMD_CORE_REG(fp_regs.vregs[i]);
-        reg.addr = (uintptr_t)q;
-        ret = kvm_vcpu_ioctl(cs, KVM_GET_ONE_REG, &reg);
+        ret = kvm_get_one_reg(cs, AARCH64_SIMD_CORE_REG(fp_regs.vregs[i]), q);
         if (ret) {
             return ret;
         } else {
@@ -940,15 +937,12 @@ static int kvm_arch_get_sve(CPUState *cs)
 {
     ARMCPU *cpu = ARM_CPU(cs);
     CPUARMState *env = &cpu->env;
-    struct kvm_one_reg reg;
     uint64_t *r;
     int n, ret;
 
     for (n = 0; n < KVM_ARM64_SVE_NUM_ZREGS; ++n) {
         r = &env->vfp.zregs[n].d[0];
-        reg.addr = (uintptr_t)r;
-        reg.id = KVM_REG_ARM64_SVE_ZREG(n, 0);
-        ret = kvm_vcpu_ioctl(cs, KVM_GET_ONE_REG, &reg);
+        ret = kvm_get_one_reg(cs, KVM_REG_ARM64_SVE_ZREG(n, 0), r);
         if (ret) {
             return ret;
         }
@@ -957,9 +951,7 @@ static int kvm_arch_get_sve(CPUState *cs)
 
     for (n = 0; n < KVM_ARM64_SVE_NUM_PREGS; ++n) {
         r = &env->vfp.pregs[n].p[0];
-        reg.addr = (uintptr_t)r;
-        reg.id = KVM_REG_ARM64_SVE_PREG(n, 0);
-        ret = kvm_vcpu_ioctl(cs, KVM_GET_ONE_REG, &reg);
+        ret = kvm_get_one_reg(cs, KVM_REG_ARM64_SVE_PREG(n, 0), r);
         if (ret) {
             return ret;
         }
@@ -967,9 +959,7 @@ static int kvm_arch_get_sve(CPUState *cs)
     }
 
     r = &env->vfp.pregs[FFR_PRED_NUM].p[0];
-    reg.addr = (uintptr_t)r;
-    reg.id = KVM_REG_ARM64_SVE_FFR(0);
-    ret = kvm_vcpu_ioctl(cs, KVM_GET_ONE_REG, &reg);
+    ret = kvm_get_one_reg(cs, KVM_REG_ARM64_SVE_FFR(0), r);
     if (ret) {
         return ret;
     }
@@ -980,7 +970,6 @@ static int kvm_arch_get_sve(CPUState *cs)
 
 int kvm_arch_get_registers(CPUState *cs)
 {
-    struct kvm_one_reg reg;
     uint64_t val;
     unsigned int el;
     uint32_t fpr;
@@ -990,31 +979,24 @@ int kvm_arch_get_registers(CPUState *cs)
     CPUARMState *env = &cpu->env;
 
     for (i = 0; i < 31; i++) {
-        reg.id = AARCH64_CORE_REG(regs.regs[i]);
-        reg.addr = (uintptr_t) &env->xregs[i];
-        ret = kvm_vcpu_ioctl(cs, KVM_GET_ONE_REG, &reg);
+        ret = kvm_get_one_reg(cs, AARCH64_CORE_REG(regs.regs[i]),
+                              &env->xregs[i]);
         if (ret) {
             return ret;
         }
     }
 
-    reg.id = AARCH64_CORE_REG(regs.sp);
-    reg.addr = (uintptr_t) &env->sp_el[0];
-    ret = kvm_vcpu_ioctl(cs, KVM_GET_ONE_REG, &reg);
+    ret = kvm_get_one_reg(cs, AARCH64_CORE_REG(regs.sp), &env->sp_el[0]);
     if (ret) {
         return ret;
     }
 
-    reg.id = AARCH64_CORE_REG(sp_el1);
-    reg.addr = (uintptr_t) &env->sp_el[1];
-    ret = kvm_vcpu_ioctl(cs, KVM_GET_ONE_REG, &reg);
+    ret = kvm_get_one_reg(cs, AARCH64_CORE_REG(sp_el1), &env->sp_el[1]);
     if (ret) {
         return ret;
     }
 
-    reg.id = AARCH64_CORE_REG(regs.pstate);
-    reg.addr = (uintptr_t) &val;
-    ret = kvm_vcpu_ioctl(cs, KVM_GET_ONE_REG, &reg);
+    ret = kvm_get_one_reg(cs, AARCH64_CORE_REG(regs.pstate), &val);
     if (ret) {
         return ret;
     }
@@ -1031,9 +1013,7 @@ int kvm_arch_get_registers(CPUState *cs)
      */
     aarch64_restore_sp(env, 1);
 
-    reg.id = AARCH64_CORE_REG(regs.pc);
-    reg.addr = (uintptr_t) &env->pc;
-    ret = kvm_vcpu_ioctl(cs, KVM_GET_ONE_REG, &reg);
+    ret = kvm_get_one_reg(cs, AARCH64_CORE_REG(regs.pc), &env->pc);
     if (ret) {
         return ret;
     }
@@ -1047,9 +1027,7 @@ int kvm_arch_get_registers(CPUState *cs)
         aarch64_sync_64_to_32(env);
     }
 
-    reg.id = AARCH64_CORE_REG(elr_el1);
-    reg.addr = (uintptr_t) &env->elr_el[1];
-    ret = kvm_vcpu_ioctl(cs, KVM_GET_ONE_REG, &reg);
+    ret = kvm_get_one_reg(cs, AARCH64_CORE_REG(elr_el1), &env->elr_el[1]);
     if (ret) {
         return ret;
     }
@@ -1059,9 +1037,8 @@ int kvm_arch_get_registers(CPUState *cs)
      * KVM SPSRs 0-4 map to QEMU banks 1-5
      */
     for (i = 0; i < KVM_NR_SPSR; i++) {
-        reg.id = AARCH64_CORE_REG(spsr[i]);
-        reg.addr = (uintptr_t) &env->banked_spsr[i + 1];
-        ret = kvm_vcpu_ioctl(cs, KVM_GET_ONE_REG, &reg);
+        ret = kvm_get_one_reg(cs, AARCH64_CORE_REG(spsr[i]),
+                              &env->banked_spsr[i + 1]);
         if (ret) {
             return ret;
         }
@@ -1082,17 +1059,13 @@ int kvm_arch_get_registers(CPUState *cs)
         return ret;
     }
 
-    reg.addr = (uintptr_t)(&fpr);
-    reg.id = AARCH64_SIMD_CTRL_REG(fp_regs.fpsr);
-    ret = kvm_vcpu_ioctl(cs, KVM_GET_ONE_REG, &reg);
+    ret = kvm_get_one_reg(cs, AARCH64_SIMD_CTRL_REG(fp_regs.fpsr), &fpr);
     if (ret) {
         return ret;
     }
     vfp_set_fpsr(env, fpr);
 
-    reg.addr = (uintptr_t)(&fpr);
-    reg.id = AARCH64_SIMD_CTRL_REG(fp_regs.fpcr);
-    ret = kvm_vcpu_ioctl(cs, KVM_GET_ONE_REG, &reg);
+    ret = kvm_get_one_reg(cs, AARCH64_SIMD_CTRL_REG(fp_regs.fpcr), &fpr);
     if (ret) {
         return ret;
     }
-- 
2.41.0

