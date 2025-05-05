Return-Path: <kvm+bounces-45532-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5511BAAB7B1
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 08:16:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5234D5043FA
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 06:14:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30328296D0B;
	Tue,  6 May 2025 00:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="X94NpKGq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 956793B0A23
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 23:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746487229; cv=none; b=VsQlFp74n49B4y/uUaec6WXy/hk5WwkSysGwJuB9xGaPquaSB8RxO8Zzvm5MoXloekLS+6m6cWdxIL+0wZVBe7/4c8ds6XWdbUksI5hrQoXGExTpwtOnn9kf8XIeSOnGJBygZnRSATMAYAj6qlgQa0npL8o3eAuM6JmrhKZnooI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746487229; c=relaxed/simple;
	bh=pLhVywQOsnQQXulAr9P+c2k7oCnBigTaDPegpWLj1Gk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gAHZqnOcL6qB7rEgeYhRekmggRFhu398tXqCYl+vB7hReNaQtdAT+cWocSg926K5LAz6/OuOBuJMG9q4/fDYcolDFKbPQI3SkBlltTueRfBKL3gacddZ/cViRD4rlQQe0xJAHjezs3b6g2HcFShzGG8R26uuphfE/JR3IVaVZiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=X94NpKGq; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-22e09f57ed4so46777345ad.0
        for <kvm@vger.kernel.org>; Mon, 05 May 2025 16:20:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746487227; x=1747092027; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=48VeJmtQLPOhxBVuGtRwfY5ps2vP+Hg73z2yA0rcj8A=;
        b=X94NpKGqbMgbUz3+1oCVRNbtvlnAuq0qxO/z9HkVJZcIlS7OafK9qQkBwdWFR4Waut
         nyJHs2L8FONEfuMiusP4AD33HCof2iMQuGNJy/hi0S+NdYT4AAAgz6CAbJqTVyJPDltG
         8OgQk29tp9NxNR7UqzzKFhDeZ5OzUN6g/4htKecsqayjSIK1kvvOin9bEgjXLc5MM4qM
         qC2zW7SDPN1W4rXbSqOEmG9L2CI67lfcVENMKtM3TmSBrNiOiHnaF/Xthf4zpgo25Z4j
         g8ViA18izNH4TKFAkgDgiN7uezp8uiie3YoZCzrVR9WsjgR1eOaEAW6HMlnUG/mMOw0s
         cahA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746487227; x=1747092027;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=48VeJmtQLPOhxBVuGtRwfY5ps2vP+Hg73z2yA0rcj8A=;
        b=c/2H1oXkQ1/5GpE8w53OpskPKNHOYDU27b9urLZ7aOgpdNDJGBtHsP1aBTJJRgExCm
         qI+OCJfPC+r4JukxEdc7QnPbmNPsAQkW8wM+2Z9XrbOznk4Cgrj7GDvGX+uzV1AePa3M
         Zkg4TLLfRGk+NaC8+V7bTzSLtfHfudjfhOAPVyUB+VTpXq1BTezawz9CrkRs0n6eMAwf
         NgEwAYzSfZ6YwSVx1Z4No7C42okNO/Qz1OtNmrtOrN5ua1XDLR/AhmL/KTRLA6LpU0eK
         eA4y+QmleRjqBw5auTGxX/023g8Owic6gAKKliO9MBHdn+tGIWxli0UfH9RirMI7rbvV
         iiCQ==
X-Forwarded-Encrypted: i=1; AJvYcCVUcmkJHYS7R4PlSkDFLWhy2wo8gRTKHa/WV+8HNOFE0cTmoO+Yd9S51yxN09LkhnBjqlw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxchqXQeUud/6fkyB57t+0nPHyic8rdZABJM+avmzEycSRHvIf3
	lVz5Cjj9ZfgBj/Y56meFwvqZwcHdJyMmvZF4EnsB0k6CsDkv4Ij0p1Q5wmvni6w=
X-Gm-Gg: ASbGncsaSe7Mp7eqB+yACxyo5MR5Zck3RGBZWvOD4Ad8UtA8PnDuyBhB2SI1HhnVC67
	KPzXlhvl3aQoFXwfcBo+CGdqfURDNcWcYJYmp2Q6nYgm2DQs9Fw1sdCLvTO7Al+LGl7kur0a596
	iNwhECAkaVX048gjS2X6CxB3mH42ETgqoA1JIShvj7rMD2tHnBfaSO73ERdr7Yubz5RAgaXYjBm
	G+0aOF4G0v/0OVhwEm/O6hWlLhN8ObW72YKHb40w+sOXkbpo8MvrbDYkJL9cLPFqCRoD7jtMyyh
	xggO7esCHZ0w2Hxmysz7GvZ6pwUJj8FCEoBJbx4T
X-Google-Smtp-Source: AGHT+IG7ArAq090ldoo+ZdQVBej7m6q6ZuRLjsuSHiLmFUTOGIKSXlNLu8HuIseupKBtlS+wsj+7ew==
X-Received: by 2002:a17:902:d486:b0:215:58be:334e with SMTP id d9443c01a7336-22e32776bf1mr17875875ad.10.1746487226858;
        Mon, 05 May 2025 16:20:26 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e1522917asm60981715ad.201.2025.05.05.16.20.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 May 2025 16:20:26 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: richard.henderson@linaro.org,
	anjo@rev.ng,
	Peter Maydell <peter.maydell@linaro.org>,
	alex.bennee@linaro.org,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	qemu-arm@nongnu.org,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v6 07/50] target/arm/cpu: move arm_cpu_kvm_set_irq to kvm.c
Date: Mon,  5 May 2025 16:19:32 -0700
Message-ID: <20250505232015.130990-8-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250505232015.130990-1-pierrick.bouvier@linaro.org>
References: <20250505232015.130990-1-pierrick.bouvier@linaro.org>
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
index 7b9c7c4a148..d156c790b66 100644
--- a/target/arm/kvm_arm.h
+++ b/target/arm/kvm_arm.h
@@ -221,4 +221,6 @@ int kvm_arm_set_irq(int cpu, int irqtype, int irq, int level);
 
 void kvm_arm_enable_mte(Object *cpuobj, Error **errp);
 
+void arm_cpu_kvm_set_irq(void *arm_cpu, int irq, int level);
+
 #endif
diff --git a/target/arm/cpu.c b/target/arm/cpu.c
index 5e951675c60..07f279fec8c 100644
--- a/target/arm/cpu.c
+++ b/target/arm/cpu.c
@@ -1099,37 +1099,6 @@ static void arm_cpu_set_irq(void *opaque, int irq, int level)
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
index 97de8c7e939..8f68aa10298 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -2468,3 +2468,32 @@ void kvm_arm_enable_mte(Object *cpuobj, Error **errp)
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


