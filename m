Return-Path: <kvm+bounces-46207-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F2E1AB4229
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 20:18:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 336283AF1E9
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 18:16:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B89F2BD926;
	Mon, 12 May 2025 18:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="PESat1fQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE38E297A65
	for <kvm@vger.kernel.org>; Mon, 12 May 2025 18:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073119; cv=none; b=DkMcM0p1fDHmn91DhYyIx9BCc9lCw55GxEenIxsJ8BmpUJGJYPRPIcGlOouGB8wlwqQuZLLbRIlJKTMgeVQBlYMWly0zbZUNH8DR5Lp6jlxMXgBo5iBjxtaQ8r8NISS/3f2uHUsYe6mSvJAmg1XAFvkNxM7S2Qt0nDGjZbzD9+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073119; c=relaxed/simple;
	bh=N3k9mOO4kZXYEsvhczqhrT1Vg1W1TaSoZ5LvUQqhxdI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JgmUz8Eup1qZqZ9iyG0//hwXqjTJfiaeukbZUNN8DV8E5KfkzJqS4rHwUeQA/Kpyywn9OLvuhAPtOUMkY52hbpX5pcPpDqt0OnGaHbai1rfVKvYmMIlTJEEZDw2s/2n1JqqAzpb9pYxOWhi4Cpc1I0dXBNb6m0WEPwwPFJTpBpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=PESat1fQ; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-b0b2d0b2843so3614087a12.2
        for <kvm@vger.kernel.org>; Mon, 12 May 2025 11:05:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1747073117; x=1747677917; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cH5ZtRCeVBPeaEwJ188gDPaPfkE7sAMWROIwRI8/rfo=;
        b=PESat1fQ54NI3Go8ecr/5rj4YqD4OeoNgaqeL+md84SzTXkQWoDJOZoHkBw6OIeG1m
         Os9eJQifScPAUm0LFwHEIWOBYAR4ByNPIVD1jZe7Zn9d7FwiIwYFpA5vF0GKbEnXh8ic
         +scpAS2cj5d9xl/q7jzjisdFM9rI48CVRxEEMiblc5xKZee2mVNT/PCReXPi18VnSCAM
         +zo7pYAj3Scb5pIqV/U6WZ9OaKXcgC4vr98J8AvKAC2aghsmr+GetV/naX1tJ4fg/Br4
         7ijFi8TRcx1stvJulra+CPVGI9yiewmbpk+tkKWYSmJOesT0Rd/t7gXDZY9ZvpRajgGb
         kv6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747073117; x=1747677917;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cH5ZtRCeVBPeaEwJ188gDPaPfkE7sAMWROIwRI8/rfo=;
        b=ocAnahuDV3n6VpAVbS8Gj+HWJ1y1EkERnEirl2iI+C8h2TaGyMmNUdvRm0IxUnESs2
         Kq8rQ7xfdrJyQ5ELpT0di5MnOg8wSyf3OQpYtE0itPzTHPR+opkkzy6XURQREfD8F4lb
         fSkmTdpPr3NWWpeTICzd5jcPKycXotIFA66znbx56v2w0+B8wPugnl4lwfkW+gZkhUkZ
         X2ygjO+u/JN5vg6VEh9RK+X/U1wpoXoTC3PbuUsx3zDB5tGMFMKcjqUJUi+G/jZrFurJ
         Z1mQ9dJ4lXW7CuJCceXbBum2vSvqYO3czRnP+YDmTtcjJJuckMAos+dug2HbukfikdiU
         +8EQ==
X-Forwarded-Encrypted: i=1; AJvYcCVfj/znbXbETwEUL07t6HW89+lTR9W30G//uDnvFZnbbvCLUUn6EPoAdrnfT8kt8fMfShg=@vger.kernel.org
X-Gm-Message-State: AOJu0YwMDpcUorMkE3mzQijEGvnMBQ/R1FOrZs3U5wOVu9Vmbktrzcnc
	rBRWqnCcDfuK8E4W8tgL4JjamGGR5h0AHAzvuA4nre4Si+XwzApJqW7myd8AhbU=
X-Gm-Gg: ASbGncu/GW9jwQ2QXhe2iKuMEcskB+IGsl5XF1RpVGXS333sZF4E5OhG2V40ArBkTNm
	1ss4rRCdkOSozWZveelgflwlKv2BMUQNM13HL1CvfAI4O6Zejgg1mGxJ11rx1xi9nR9m0x94W/7
	hgo+iOUkWbsXHs3lBZtch/HIfx7B6t1+qY2VniyG3tstXb+NU5F0ol+qxqLByf4ZC/kbxS/eDvY
	DfQVuGWCWoHN1G4ZajpbKYTGzXgsKmSA70ZE970cCwMoxk2TpHS/FnbREDfWhjs9avywyWEhaAh
	p95nXRE4VR09ZMuBigKwkXaK9NHljDxUQHSAduLXAkbm+ugNOVs=
X-Google-Smtp-Source: AGHT+IETvanw0ckOxauhRh53BeO6QFOIvdwuGiTFcETu9+U7/rtOOWaOMqjOOmK8LiKZT11pMAkQYg==
X-Received: by 2002:a17:903:3d07:b0:223:65dc:4580 with SMTP id d9443c01a7336-22fc91cafbemr189319255ad.52.1747073117126;
        Mon, 12 May 2025 11:05:17 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22fc82a2e4fsm65792005ad.232.2025.05.12.11.05.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 May 2025 11:05:16 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	kvm@vger.kernel.org,
	alex.bennee@linaro.org,
	anjo@rev.ng,
	qemu-arm@nongnu.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v8 06/48] target/arm/cpu: move arm_cpu_kvm_set_irq to kvm.c
Date: Mon, 12 May 2025 11:04:20 -0700
Message-ID: <20250512180502.2395029-7-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250512180502.2395029-1-pierrick.bouvier@linaro.org>
References: <20250512180502.2395029-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Allow to get rid of CONFIG_KVM in target/arm/cpu.c

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/kvm_arm.h  |  2 ++
 target/arm/cpu.c      | 31 -------------------------------
 target/arm/kvm-stub.c |  5 +++++
 target/arm/kvm.c      | 29 +++++++++++++++++++++++++++++
 4 files changed, 36 insertions(+), 31 deletions(-)

diff --git a/target/arm/kvm_arm.h b/target/arm/kvm_arm.h
index 5bf5d56648f..b638e09a687 100644
--- a/target/arm/kvm_arm.h
+++ b/target/arm/kvm_arm.h
@@ -216,4 +216,6 @@ int kvm_arm_set_irq(int cpu, int irqtype, int irq, int level);
 
 void kvm_arm_enable_mte(Object *cpuobj, Error **errp);
 
+void arm_cpu_kvm_set_irq(void *arm_cpu, int irq, int level);
+
 #endif
diff --git a/target/arm/cpu.c b/target/arm/cpu.c
index 45cb6fd7eed..d062829ec14 100644
--- a/target/arm/cpu.c
+++ b/target/arm/cpu.c
@@ -1098,37 +1098,6 @@ static void arm_cpu_set_irq(void *opaque, int irq, int level)
     }
 }
 
-static void arm_cpu_kvm_set_irq(void *opaque, int irq, int level)
-{
-#ifdef CONFIG_KVM
-    ARMCPU *cpu = opaque;
-    CPUARMState *env = &cpu->env;
-    CPUState *cs = CPU(cpu);
-    uint32_t linestate_bit;
-    int irq_id;
-
-    switch (irq) {
-    case ARM_CPU_IRQ:
-        irq_id = KVM_ARM_IRQ_CPU_IRQ;
-        linestate_bit = CPU_INTERRUPT_HARD;
-        break;
-    case ARM_CPU_FIQ:
-        irq_id = KVM_ARM_IRQ_CPU_FIQ;
-        linestate_bit = CPU_INTERRUPT_FIQ;
-        break;
-    default:
-        g_assert_not_reached();
-    }
-
-    if (level) {
-        env->irq_line_state |= linestate_bit;
-    } else {
-        env->irq_line_state &= ~linestate_bit;
-    }
-    kvm_arm_set_irq(cs->cpu_index, KVM_ARM_IRQ_TYPE_CPU, irq_id, !!level);
-#endif
-}
-
 static bool arm_cpu_virtio_is_big_endian(CPUState *cs)
 {
     ARMCPU *cpu = ARM_CPU(cs);
diff --git a/target/arm/kvm-stub.c b/target/arm/kvm-stub.c
index e34d3f5e6b4..4806365cdc5 100644
--- a/target/arm/kvm-stub.c
+++ b/target/arm/kvm-stub.c
@@ -104,3 +104,8 @@ void kvm_arm_reset_vcpu(ARMCPU *cpu)
 {
     g_assert_not_reached();
 }
+
+void arm_cpu_kvm_set_irq(void *arm_cpu, int irq, int level)
+{
+    g_assert_not_reached();
+}
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index 9c62d12b233..b6c39ca61fa 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -2429,3 +2429,32 @@ void kvm_arm_enable_mte(Object *cpuobj, Error **errp)
         cpu->kvm_mte = true;
     }
 }
+
+void arm_cpu_kvm_set_irq(void *arm_cpu, int irq, int level)
+{
+    ARMCPU *cpu = arm_cpu;
+    CPUARMState *env = &cpu->env;
+    CPUState *cs = CPU(cpu);
+    uint32_t linestate_bit;
+    int irq_id;
+
+    switch (irq) {
+    case ARM_CPU_IRQ:
+        irq_id = KVM_ARM_IRQ_CPU_IRQ;
+        linestate_bit = CPU_INTERRUPT_HARD;
+        break;
+    case ARM_CPU_FIQ:
+        irq_id = KVM_ARM_IRQ_CPU_FIQ;
+        linestate_bit = CPU_INTERRUPT_FIQ;
+        break;
+    default:
+        g_assert_not_reached();
+    }
+
+    if (level) {
+        env->irq_line_state |= linestate_bit;
+    } else {
+        env->irq_line_state &= ~linestate_bit;
+    }
+    kvm_arm_set_irq(cs->cpu_index, KVM_ARM_IRQ_TYPE_CPU, irq_id, !!level);
+}
-- 
2.47.2


