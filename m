Return-Path: <kvm+bounces-2376-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 09A607F664D
	for <lists+kvm@lfdr.de>; Thu, 23 Nov 2023 19:36:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6A261B21510
	for <lists+kvm@lfdr.de>; Thu, 23 Nov 2023 18:36:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 163814B5B2;
	Thu, 23 Nov 2023 18:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="C0q+YThR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86DE810C6
	for <kvm@vger.kernel.org>; Thu, 23 Nov 2023 10:36:01 -0800 (PST)
Received: by mail-lf1-x12c.google.com with SMTP id 2adb3069b0e04-507c5249d55so1658072e87.3
        for <kvm@vger.kernel.org>; Thu, 23 Nov 2023 10:36:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1700764560; x=1701369360; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=znNmY7edfJI2fYiqN/HJeKsLDF9NhHOuefv0PghAu5M=;
        b=C0q+YThRk8Jj049ZITDnrVzHv0D18jT5lJbkRoXeB3mbE5JWhVz1LZ1KB82KjAIE3S
         HxnVnnJBRa/Xz9KiqaN3tNAEFODXErwd81kTlj81il5WDwOmjwzla2YnAxSodikND3/u
         iRLfD8VbTxsHbfp+V/Emk1g0XNKyERfmn69DAKNvtCiIAda+EBjmAmYWXwXhZdiEuHUc
         dOZuNxWgmagIHAlHU2wZE5PkSj3Yb5eZJfFkScxM3lU4oGI2MUuf/r5HWTGHSlTuN0B1
         dfxc5HQjhM0Zp/NWlNg/YIo7HMF2RJ5uSZORBv1bucLbdDe1CIp9syB4zQWhNnFNX6OP
         OTtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700764560; x=1701369360;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=znNmY7edfJI2fYiqN/HJeKsLDF9NhHOuefv0PghAu5M=;
        b=CGJK1VsyIUVGmlP4fNhqaO/c2ThMA5cC7GIJGGua+MNhuSlHpffXCqGJLnqxfqJfir
         cNC9vzxmJGwr9f26HRIxq5Xim3hwLtflC0eW5TwLzgU0LXikIlnYNbnOVzKld9Kn5hC3
         eSldHRbw5Luw2dl1EiGss1oB4LSHgW+aGK6jCWM+zO5pLGpJU17Yy1ovtBrIJuRyk8uo
         V2CI7QDIkUaJ72Bq6nyzvAD9NuggEw9KcV//0fY3kNXWtoJzfYSg2bxuA+LSCQCixvKB
         V52zosacvC+xAcpYV2TjqR1mQ/xygJyQxgXmbeQY+x/F11qU2efmphdrUeLhRRjMTdOU
         rOpA==
X-Gm-Message-State: AOJu0Yzr5B3p56Rgll6FS23QE4LqRi6jyNOBrCTWnvpjaMfh/bbeNeio
	RURouUVuzY1Q/n0WQhNjfVpH5w==
X-Google-Smtp-Source: AGHT+IHwNsCUBI8C+HAtmr6ne5j7ja7Y9f5/nmCmQj8iQdnpHgN1KUrN2rXfn6mGSeu6MN85RsnNzQ==
X-Received: by 2002:a05:6512:39c4:b0:509:4655:d8d5 with SMTP id k4-20020a05651239c400b005094655d8d5mr92555lfu.11.1700764559795;
        Thu, 23 Nov 2023 10:35:59 -0800 (PST)
Received: from m1x-phil.lan ([176.176.165.237])
        by smtp.gmail.com with ESMTPSA id f9-20020a0560001b0900b0032196c508e3sm2352293wrz.53.2023.11.23.10.35.58
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 23 Nov 2023 10:35:59 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	qemu-arm@nongnu.org,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH-for-9.0 07/16] target/arm/kvm: Have kvm_arm_pvtime_init take a ARMCPU argument
Date: Thu, 23 Nov 2023 19:35:08 +0100
Message-ID: <20231123183518.64569-8-philmd@linaro.org>
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
 target/arm/kvm_arm.h | 6 +++---
 hw/arm/virt.c        | 5 +++--
 target/arm/kvm.c     | 6 +++---
 3 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/target/arm/kvm_arm.h b/target/arm/kvm_arm.h
index 84f87f5ed7..0e12a008ab 100644
--- a/target/arm/kvm_arm.h
+++ b/target/arm/kvm_arm.h
@@ -205,12 +205,12 @@ void kvm_arm_pmu_init(CPUState *cs);
 
 /**
  * kvm_arm_pvtime_init:
- * @cs: CPUState
+ * @cpu: ARMCPU
  * @ipa: Per-vcpu guest physical base address of the pvtime structures
  *
  * Initializes PVTIME for the VCPU, setting the PVTIME IPA to @ipa.
  */
-void kvm_arm_pvtime_init(CPUState *cs, uint64_t ipa);
+void kvm_arm_pvtime_init(ARMCPU *cpu, uint64_t ipa);
 
 int kvm_arm_set_irq(int cpu, int irqtype, int irq, int level);
 
@@ -268,7 +268,7 @@ static inline void kvm_arm_pmu_init(CPUState *cs)
     g_assert_not_reached();
 }
 
-static inline void kvm_arm_pvtime_init(CPUState *cs, uint64_t ipa)
+static inline void kvm_arm_pvtime_init(ARMCPU *cpu, uint64_t ipa)
 {
     g_assert_not_reached();
 }
diff --git a/hw/arm/virt.c b/hw/arm/virt.c
index be2856c018..b6efe9da4d 100644
--- a/hw/arm/virt.c
+++ b/hw/arm/virt.c
@@ -2003,8 +2003,9 @@ static void virt_cpu_post_init(VirtMachineState *vms, MemoryRegion *sysmem)
                 kvm_arm_pmu_init(cpu);
             }
             if (steal_time) {
-                kvm_arm_pvtime_init(cpu, pvtime_reg_base +
-                                         cpu->cpu_index * PVTIME_SIZE_PER_CPU);
+                kvm_arm_pvtime_init(ARM_CPU(cpu), pvtime_reg_base
+                                                  + cpu->cpu_index
+                                                    * PVTIME_SIZE_PER_CPU);
             }
         }
     } else {
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index 73f4e5a0fa..82c5924ab5 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -1744,7 +1744,7 @@ void kvm_arm_pmu_set_irq(CPUState *cs, int irq)
     }
 }
 
-void kvm_arm_pvtime_init(CPUState *cs, uint64_t ipa)
+void kvm_arm_pvtime_init(ARMCPU *cpu, uint64_t ipa)
 {
     struct kvm_device_attr attr = {
         .group = KVM_ARM_VCPU_PVTIME_CTRL,
@@ -1752,10 +1752,10 @@ void kvm_arm_pvtime_init(CPUState *cs, uint64_t ipa)
         .addr = (uint64_t)&ipa,
     };
 
-    if (ARM_CPU(cs)->kvm_steal_time == ON_OFF_AUTO_OFF) {
+    if (cpu->kvm_steal_time == ON_OFF_AUTO_OFF) {
         return;
     }
-    if (!kvm_arm_set_device_attr(ARM_CPU(cs), &attr, "PVTIME IPA")) {
+    if (!kvm_arm_set_device_attr(cpu, &attr, "PVTIME IPA")) {
         error_report("failed to init PVTIME IPA");
         abort();
     }
-- 
2.41.0


