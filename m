Return-Path: <kvm+bounces-45354-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5050CAA8AB5
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 03:53:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B115617256C
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 01:53:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F84E1A841B;
	Mon,  5 May 2025 01:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="trOjuAPr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26AC41A2557
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 01:52:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746409956; cv=none; b=gAs+Xvs2JYVVUiwHkNwHamXlblKPAoqqykMZko66YqMFWcwEU4W+Ty80pZ/x0eMsbSHmGVvzFCt8C3FK0wKaWGRTL5C1+965K8jCVyfU5I/jpsbJ1akD89HNsDilxovzvIMcVfH/YXHiSfAK5inJB0V7zuRNZh6vEEKCl5Eo0zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746409956; c=relaxed/simple;
	bh=pLhVywQOsnQQXulAr9P+c2k7oCnBigTaDPegpWLj1Gk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RIr1TCTtrfGgcieGrrhOLcve7g6n1Z5tWjNx83UlgX4YKUCX8Jw2hgGtsxD1a6J4jpO1jLQmBO6O3hm231EJpEOdfnRUyv8vD5klW2JYYpw/OqpGSiQq+1lXQBxJ7hk+1s31E9LKobYPnOjbdHoYJTp23q/u8YYlxxGF396ZhoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=trOjuAPr; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-b041afe0ee1so3719843a12.1
        for <kvm@vger.kernel.org>; Sun, 04 May 2025 18:52:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746409954; x=1747014754; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=48VeJmtQLPOhxBVuGtRwfY5ps2vP+Hg73z2yA0rcj8A=;
        b=trOjuAPrXvmuKqdAl4ZYYQ3FvhXMt2y3QSAS3/kiV2Cn3c2rsDXGoSH4/X3Ks/nz6m
         NMH0I5OzHP9lB7ZYDhYc9zvT/HulmvA9TJW51os59oLhYZEmhz1JxNy2CuNfizsAbCzb
         mlz/zd8C8ZSrn6EF3cVNHSfHarORGbotTGibqTHP6C9shCAFIxhEcaABMY6Fhp6vtnG6
         IJFowtRAXtccAtnQdyyi8fdVEzeINMp6zVylCBOAcAImMhXr09f/WxiuZM4OnArFUr56
         u2wfucPOMVef81XLE1Msgd54STcVxoU41r9KLUcowH+0ZUj1jNU12yb7gkvKCF6jRp0D
         +CKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746409954; x=1747014754;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=48VeJmtQLPOhxBVuGtRwfY5ps2vP+Hg73z2yA0rcj8A=;
        b=tNr1LygncpYlHYf82pXPIEi9re+qcZkD+z3686zxqOjIWeUpi09wbauXKaWSucxhFV
         35VnTGAjUD3SDkMEJ73wzkLsGAbVaM4e3ZF+lbQcMhgM8vhquB6HlSd8eTQ0HntXOAu9
         xtzVzK6w/iwRhG3fTMDYTpVhHQPCsSReuDRmgWvWb6I8GT/rNyoLTPFeBKwlYbi+YqR1
         EqkDCX4Dhe9jYaICmsZ55kuFsmREZPDpbwFFE3adGTumzs8TxnGvil9otfTRiY5VIGMd
         jZPVjpDSCAQU4F004O8NL9Ylzyam4v1yJXzb7GWDG//lapfUBeVuB0u2Eb6sFprzSUSx
         S1uw==
X-Forwarded-Encrypted: i=1; AJvYcCXuVmhNadngKNTSdgkvd5ejX7Z5bTzjYzjhhTw+UT73icOY2PqzLyD7aR/7wNNEA1IQsXI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxpFEimcCyFURDw1oiJ8T2OUS/MVOQrprl7csKv8D2rDMNy9eA9
	VnZHvTn7aK5C13RpBmb2iudh+NXAWzqLOu7S1m137UEsNnIyZnEoNe9qnxMgCDw=
X-Gm-Gg: ASbGnct4EUQucLaKkEW1rZWpeuVZBO7znTYtATGKemkoEjJzrPDB90txqHPuLZ9keeB
	G0FgWX6Ah+o8PBeR8hGxRs43hclov16G0WCJfPtOwg4ij5YRnEBoROIqywraixpLreFWMuenxaC
	RwWVTaXywHlPDYoys6S3CqA/tVz8NiDyWH3fHsX+uhxiAhukrIblpo1hKZzNROP0istsr1NPBaK
	dm274cCSDyfjxPsPH6yF6jG2C8iLGncX8+TG+HHX5UCXrWNQGkbLQCIfDxWM+rtoRQWq0d1N9fg
	YrWw7tKXr6P+5T+rlY9BaDIB61P0q4TFzrwKEbh3
X-Google-Smtp-Source: AGHT+IHVsm+2T98RMan+aqKpvWrHPBx/684xgAQ6PVkROPORQuD2CG4DFxexJTT4HWRoWnoTr19PIQ==
X-Received: by 2002:a05:6a20:9d91:b0:1f5:6680:82b6 with SMTP id adf61e73a8af0-20e079f2659mr10290006637.38.1746409954391;
        Sun, 04 May 2025 18:52:34 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b1fb3920074sm4462101a12.11.2025.05.04.18.52.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 May 2025 18:52:34 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	qemu-arm@nongnu.org,
	richard.henderson@linaro.org,
	alex.bennee@linaro.org,
	kvm@vger.kernel.org,
	Peter Maydell <peter.maydell@linaro.org>,
	anjo@rev.ng,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v5 07/48] target/arm/cpu: move arm_cpu_kvm_set_irq to kvm.c
Date: Sun,  4 May 2025 18:51:42 -0700
Message-ID: <20250505015223.3895275-8-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250505015223.3895275-1-pierrick.bouvier@linaro.org>
References: <20250505015223.3895275-1-pierrick.bouvier@linaro.org>
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


