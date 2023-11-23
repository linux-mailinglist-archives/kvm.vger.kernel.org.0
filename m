Return-Path: <kvm+bounces-2381-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 620487F6658
	for <lists+kvm@lfdr.de>; Thu, 23 Nov 2023 19:36:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DAD40B21AB8
	for <lists+kvm@lfdr.de>; Thu, 23 Nov 2023 18:36:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB3684D10C;
	Thu, 23 Nov 2023 18:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="bqYlY8re"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C35CCD7F
	for <kvm@vger.kernel.org>; Thu, 23 Nov 2023 10:36:28 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id 5b1f17b1804b1-4083f61312eso8915275e9.3
        for <kvm@vger.kernel.org>; Thu, 23 Nov 2023 10:36:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1700764587; x=1701369387; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wFeYHB+Hwgz28c/uPKH/ogtnPZczZab/kLjBCnJSUvs=;
        b=bqYlY8reVeYil46OJM6uDATdE/T/zlyvRotneINQVgATLSsynfJCcKdoxleNoLrSkx
         jujpLPUFykYL6lqOjIZnYgOd8XXoyvrFhbbJXvKAo/cGy7SBUZYudUreOosuf0HzYsXH
         vyi/oA1Q7LGKSqhQ7S40Mp8pSyzK3p3L2gpLgZEp1ApWIgHmedu7BznxyAdSVD1gAQ6h
         Y/GGOEVD5Wv7nGfLV/504LYlK0p8vzxAUJsWP1SPVayBvOTZ7HiTeL7n74SXMqz9w4Jm
         QTr7I465vUSmVfNcqKLkJfcflzbggIXFpoLGVfidsVdFKmwyvVHWasMEPYchc9FOr0xF
         qgAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700764587; x=1701369387;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wFeYHB+Hwgz28c/uPKH/ogtnPZczZab/kLjBCnJSUvs=;
        b=SK31ockZ3esoCF/cAoOCcjcWgeTN17EIZcrIDMBOg+HJKA0Z2Julc0XJd+qgRptBDp
         U7nhnm0MulqM3zTIz2hKiS8NVdYlp4BHR05hJydOJkBwEEmB0KTDLc3i6UPrCZTebvVS
         u510SnuQ35aaG+0Ov3D/zvkpN0AMLewmun/OTeC5zfuHztEzQ0/onm6KHySmn1BKL9Q9
         ljf6yKS9GiAL5xiJXRmpqXC87vJm211QwoJ/J4G8xwbOvN1Y9Q7WDu0gH/GnCouwY024
         UuuP+2bNWm+mjZ6URBXmMginpiQnzIlS2CDzqhrU6cJX0E4xEQ/FnCx/nNHGF6bU+Of5
         lIog==
X-Gm-Message-State: AOJu0YyRwfpA5gRAtTebmQM1p7LL0NP6i2Oaqz4qieNitVj2n/bP6s1Q
	muzSki07i6+7WEaI5d/y4yyTZD1+ymTRWMTcNBE=
X-Google-Smtp-Source: AGHT+IELxbckK8uZXazOGgHv1fiTUgL1Ik/QjVMUZesvDWJ1t4LowVH54N1HBPUHto+6Kfzb13zJ1g==
X-Received: by 2002:a5d:5690:0:b0:332:e65a:4a07 with SMTP id f16-20020a5d5690000000b00332e65a4a07mr231040wrv.32.1700764587343;
        Thu, 23 Nov 2023 10:36:27 -0800 (PST)
Received: from m1x-phil.lan ([176.176.165.237])
        by smtp.gmail.com with ESMTPSA id s11-20020adfeccb000000b00332c6c5ce82sm2325696wro.94.2023.11.23.10.36.26
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 23 Nov 2023 10:36:26 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	qemu-arm@nongnu.org,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH-for-9.0 12/16] target/arm/kvm: Have kvm_arm_[get|put]_virtual_time take ARMCPU argument
Date: Thu, 23 Nov 2023 19:35:13 +0100
Message-ID: <20231123183518.64569-13-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231123183518.64569-1-philmd@linaro.org>
References: <20231123183518.64569-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Unify the "kvm_arm.h" API: All functions related to ARM vCPUs
take a ARMCPU* argument. Use the CPU() QOM cast macro When
calling the generic vCPU API from "sysemu/kvm.h".

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/arm/kvm.c | 23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index dba2c9c6a9..57615ef4d1 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -1036,20 +1036,19 @@ static int kvm_arm_sync_mpstate_to_qemu(ARMCPU *cpu)
 
 /**
  * kvm_arm_get_virtual_time:
- * @cs: CPUState
+ * @cpu: ARMCPU
  *
  * Gets the VCPU's virtual counter and stores it in the KVM CPU state.
  */
-static void kvm_arm_get_virtual_time(CPUState *cs)
+static void kvm_arm_get_virtual_time(ARMCPU *cpu)
 {
-    ARMCPU *cpu = ARM_CPU(cs);
     int ret;
 
     if (cpu->kvm_vtime_dirty) {
         return;
     }
 
-    ret = kvm_get_one_reg(cs, KVM_REG_ARM_TIMER_CNT, &cpu->kvm_vtime);
+    ret = kvm_get_one_reg(CPU(cpu), KVM_REG_ARM_TIMER_CNT, &cpu->kvm_vtime);
     if (ret) {
         error_report("Failed to get KVM_REG_ARM_TIMER_CNT");
         abort();
@@ -1060,20 +1059,19 @@ static void kvm_arm_get_virtual_time(CPUState *cs)
 
 /**
  * kvm_arm_put_virtual_time:
- * @cs: CPUState
+ * @cpu: ARMCPU
  *
  * Sets the VCPU's virtual counter to the value stored in the KVM CPU state.
  */
-static void kvm_arm_put_virtual_time(CPUState *cs)
+static void kvm_arm_put_virtual_time(ARMCPU *cpu)
 {
-    ARMCPU *cpu = ARM_CPU(cs);
     int ret;
 
     if (!cpu->kvm_vtime_dirty) {
         return;
     }
 
-    ret = kvm_set_one_reg(cs, KVM_REG_ARM_TIMER_CNT, &cpu->kvm_vtime);
+    ret = kvm_set_one_reg(CPU(cpu), KVM_REG_ARM_TIMER_CNT, &cpu->kvm_vtime);
     if (ret) {
         error_report("Failed to set KVM_REG_ARM_TIMER_CNT");
         abort();
@@ -1291,16 +1289,15 @@ MemTxAttrs kvm_arch_post_run(CPUState *cs, struct kvm_run *run)
 
 static void kvm_arm_vm_state_change(void *opaque, bool running, RunState state)
 {
-    CPUState *cs = opaque;
-    ARMCPU *cpu = ARM_CPU(cs);
+    ARMCPU *cpu = opaque;
 
     if (running) {
         if (cpu->kvm_adjvtime) {
-            kvm_arm_put_virtual_time(cs);
+            kvm_arm_put_virtual_time(cpu);
         }
     } else {
         if (cpu->kvm_adjvtime) {
-            kvm_arm_get_virtual_time(cs);
+            kvm_arm_get_virtual_time(cpu);
         }
     }
 }
@@ -1881,7 +1878,7 @@ int kvm_arch_init_vcpu(CPUState *cs)
         return -EINVAL;
     }
 
-    qemu_add_vm_change_state_handler(kvm_arm_vm_state_change, cs);
+    qemu_add_vm_change_state_handler(kvm_arm_vm_state_change, cpu);
 
     /* Determine init features for this CPU */
     memset(cpu->kvm_init_features, 0, sizeof(cpu->kvm_init_features));
-- 
2.41.0


