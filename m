Return-Path: <kvm+bounces-2377-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F30C7F664E
	for <lists+kvm@lfdr.de>; Thu, 23 Nov 2023 19:36:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D2C51B210BD
	for <lists+kvm@lfdr.de>; Thu, 23 Nov 2023 18:36:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCDBB4C628;
	Thu, 23 Nov 2023 18:36:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ac8Lp4ik"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAD9310C2
	for <kvm@vger.kernel.org>; Thu, 23 Nov 2023 10:36:06 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id 5b1f17b1804b1-40790b0a224so7659915e9.0
        for <kvm@vger.kernel.org>; Thu, 23 Nov 2023 10:36:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1700764565; x=1701369365; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sJjfIOalwsvZmq2fy7v7JKs3hNC/WaTRJ81yhz4vDXw=;
        b=ac8Lp4ikWZipDOzTWtJLNlV/ZwuUjhpZVf61In80JWbLRpsUz9wLLDl1ep6f58ECn2
         NgfDjJdeb4ru59to/CX8XbMRyLmhLJhuXNsvGX8e1cT+mjtXK+YCO5WWo+p0ueDe09DP
         ypNwyb6ILqW73xpkYino8nC+2136n5+HfIrGcmH4bX/ckCIaDmKyz5yE+v6efjlomjVf
         wHQc8RnFUXp40liNbpF3lmKZJxEu6ZGbXhmTOT3MVTKZ4twCznBLlXeQ4S0DIduDCCKY
         lAiOUkeSEqIZvfFz/G4cn0hkoxxxWARcJjcY80th1/io2CepXscAHbDXF8IW8Mj/znNp
         ITBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700764565; x=1701369365;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sJjfIOalwsvZmq2fy7v7JKs3hNC/WaTRJ81yhz4vDXw=;
        b=HTiyUqa7L3KbxS7qp507bYWM3MxlG43B2lKNZv0Vor/XpR+/KOfRfd9bMZf4o6q76z
         XQp9GjYCfhVvfiGp2NgESa7C7qhraPgyz+tfKO07gGahU/TDOK98HL4DqmFXXl6NGJz7
         OpwwgflDiIvVgVYrk29gNmcvAkTaDgObq+QlB2UZXR3mi+i6UogddC+gIIodowfQYOeR
         f35vtC80MGCBxle9RQluJG2snoYCDtvkCQlr/Go+tCJW5X7aX45725tc+Lzfs1jsvlMv
         dFPKM/N0y8UptFyn4VBoSD4s7H5NK+b3ViGijiDej98oa+DRwwDx98XF2d+Tyf6sMyIe
         myGQ==
X-Gm-Message-State: AOJu0YzISmjR9alMaKDJTLjveEiGxT0CDRjtfXhhdihrf2DzxLVvb/fS
	puW0jTLNCxF6h1vm7YMe4p8hoQ==
X-Google-Smtp-Source: AGHT+IELE79MyLBbOsT4/Sz7U570tGHdhzEvWk2p61WIGplYDA6HA/ukUNXBzijqXiExJ/9+xOAMnQ==
X-Received: by 2002:a05:600c:1c12:b0:407:612b:91fb with SMTP id j18-20020a05600c1c1200b00407612b91fbmr290352wms.30.1700764565221;
        Thu, 23 Nov 2023 10:36:05 -0800 (PST)
Received: from m1x-phil.lan ([176.176.165.237])
        by smtp.gmail.com with ESMTPSA id u11-20020a05600c19cb00b0040a507f546fsm3526409wmq.8.2023.11.23.10.36.04
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 23 Nov 2023 10:36:04 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	qemu-arm@nongnu.org,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH-for-9.0 08/16] target/arm/kvm: Have kvm_arm_pmu_init take a ARMCPU argument
Date: Thu, 23 Nov 2023 19:35:09 +0100
Message-ID: <20231123183518.64569-9-philmd@linaro.org>
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
 target/arm/kvm_arm.h | 4 ++--
 hw/arm/virt.c        | 2 +-
 target/arm/kvm.c     | 6 +++---
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/target/arm/kvm_arm.h b/target/arm/kvm_arm.h
index 0e12a008ab..fde1c45609 100644
--- a/target/arm/kvm_arm.h
+++ b/target/arm/kvm_arm.h
@@ -200,8 +200,8 @@ int kvm_arm_get_max_vm_ipa_size(MachineState *ms, bool *fixed_ipa);
 
 int kvm_arm_vgic_probe(void);
 
+void kvm_arm_pmu_init(ARMCPU *cpu);
 void kvm_arm_pmu_set_irq(CPUState *cs, int irq);
-void kvm_arm_pmu_init(CPUState *cs);
 
 /**
  * kvm_arm_pvtime_init:
@@ -263,7 +263,7 @@ static inline void kvm_arm_pmu_set_irq(CPUState *cs, int irq)
     g_assert_not_reached();
 }
 
-static inline void kvm_arm_pmu_init(CPUState *cs)
+static inline void kvm_arm_pmu_init(ARMCPU *cpu)
 {
     g_assert_not_reached();
 }
diff --git a/hw/arm/virt.c b/hw/arm/virt.c
index b6efe9da4d..63f3c0b750 100644
--- a/hw/arm/virt.c
+++ b/hw/arm/virt.c
@@ -2000,7 +2000,7 @@ static void virt_cpu_post_init(VirtMachineState *vms, MemoryRegion *sysmem)
                 if (kvm_irqchip_in_kernel()) {
                     kvm_arm_pmu_set_irq(cpu, VIRTUAL_PMU_IRQ);
                 }
-                kvm_arm_pmu_init(cpu);
+                kvm_arm_pmu_init(ARM_CPU(cpu));
             }
             if (steal_time) {
                 kvm_arm_pvtime_init(ARM_CPU(cpu), pvtime_reg_base
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index 82c5924ab5..e7cbe1ff05 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -1711,17 +1711,17 @@ static bool kvm_arm_set_device_attr(ARMCPU *cpu, struct kvm_device_attr *attr,
     return true;
 }
 
-void kvm_arm_pmu_init(CPUState *cs)
+void kvm_arm_pmu_init(ARMCPU *cpu)
 {
     struct kvm_device_attr attr = {
         .group = KVM_ARM_VCPU_PMU_V3_CTRL,
         .attr = KVM_ARM_VCPU_PMU_V3_INIT,
     };
 
-    if (!ARM_CPU(cs)->has_pmu) {
+    if (!cpu->has_pmu) {
         return;
     }
-    if (!kvm_arm_set_device_attr(ARM_CPU(cs), &attr, "PMU")) {
+    if (!kvm_arm_set_device_attr(cpu, &attr, "PMU")) {
         error_report("failed to init PMU");
         abort();
     }
-- 
2.41.0


