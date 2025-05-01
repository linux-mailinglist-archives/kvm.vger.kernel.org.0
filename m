Return-Path: <kvm+bounces-45035-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D117AA5ACB
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 08:24:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 35D6B9A301E
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 06:24:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB90B26C38A;
	Thu,  1 May 2025 06:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="yCI3Xz/U"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9372B26F45D
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 06:23:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746080639; cv=none; b=TPLHeutdhxgwCZpBO8rSUsG13k7H2Q/QEeZe8nUQmsKixcYXyicXHAYP7vOVwL6Z4VARlEPbBkOys1QggFeI4F6nmgYWvqLwNIGKNS/VsFCYEsnRyjCLQ/ipAb12H0vhp/UJMGw7YXgAWzARdGNIBjwW3fC6pH0n3KRXnvdagUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746080639; c=relaxed/simple;
	bh=IcLF6TM0vEGGA2b8vuH6/fsSOQuc3KQg0/QvgJJAP+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jqU/i9EQxxV1QCwS2TrJgNYc6globZ1pSW7SdJIeLtuKoZTs94EUBH+ejb9Kep/LFHUXAk7JBpPuCG1kCxJZ35VYWu1/A9q3gbs5lTV9n2hVDtBMCDF6aKUi7VCus/NF4CKqkrT2xoHX+ckiAxZ44xVm9+R1RUzn9YmUNqHDR18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=yCI3Xz/U; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-736b0c68092so650003b3a.0
        for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 23:23:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746080637; x=1746685437; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kOxKXFGwCu039etMQxzOSUx9I5tz+a2xiou6nYotXOs=;
        b=yCI3Xz/Uwztpy0MZxgOqC+2mtkkQ/E+qHxnKWHzpd+DxegxZJdhyzTest0xbl4SKKO
         CjLbn/UH/m/pj19jkkbyXQfZSBzbuv9OA6gDpYudRGFCnSCe5YQLQgjOsvqGh2N/RsT9
         xTNkX8nUHPRvN1eTAnnsuaiRpD/Gy/aE6FzJpbTeqB9MXoUzUNDAkNZGPAcPmBuLQZXb
         K3essRQ9rtW2XgFo63QuDdH+bnxyShVYpsALLCX5QSYz/FeWRCy06LMPGsS+cI31hfWV
         ABsykvuG+zjYI0jL30uspt7BPBYa/jef2ZJWVuyUqRVW4JukMPhNp4Q8PP6qeakNj+L+
         o1iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746080637; x=1746685437;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kOxKXFGwCu039etMQxzOSUx9I5tz+a2xiou6nYotXOs=;
        b=e2nvyM+YC7ODPKFahcIALKv4leMy14z7z4703DL2L3FHQ8QUO9UXgENwSH4YGlvEqZ
         ykbtr9ZTSJb9yILUQPWZ/aOhyu16EN/vS9EtfBWLyC8fr5VF2JsdB5MTPRTvNQbDZR3k
         yvhyj056+D20PgBYSce7MUVj4hP7KD1ZlWB0jFLoDINNNI7nYvwe+om4JIRx6SqXCt2W
         eDJYnesjHEl+XCnXmhNvKSGOWMwctydTXxLBuLMazwRkuF5/8lnzjJlGMgZuL7/pDfAh
         PLUPeXq5cMoC+aEODdHWgKCaksIs0fKyIy1AyGOQXUzzat8m5Tjo1x7/jO2j19urF/Lu
         Nz8A==
X-Forwarded-Encrypted: i=1; AJvYcCXszpMCoIs6tc4gaS99rqvYXctDPcNF/rg0XSotnKfi2xaj5BUq3BQsFGOxkOUsR41L088=@vger.kernel.org
X-Gm-Message-State: AOJu0YzBoNp9008Lr9agSv3gvd9N74Lqz6nV/lNzxF/XzWVJHLTh8/fz
	xR13VzpBTKsaL2zcU7GGc4fTr8kL/vtAZUgLCQaC4LfzHtkDVI375IMgux5FL8o=
X-Gm-Gg: ASbGnctPFfYdWpMuGdYLF32t7293J6qzmI7duz5Srvt3yVgfq1e6VvhgjCoepgLq/t7
	vX+ppmCYhQ8oALmNOX2zHaBGO5selH5opZ0xqKZYWyPc1P8eLA9N9uhsRjN7Fs2Sd6q18UmEQRz
	prUVtwZODsDqa8xLvqoq+j8G8WF+ZhVr14M/dbbNPGX5YHMrEFDX4+f21zMsz4CI8SSLNGXYHaM
	XvSYr/F8Le3x546pVDJugEoqLsaI3J4eFNGDTPfvJLWug873EpcwYBOJxJ5iLl4ztFN7UpNkYbK
	w6ZjKrExVhwsEBF71h6Y0IAAiTqoP03Eimndlynv
X-Google-Smtp-Source: AGHT+IHRnR+IPmf7SIZRqz2UrjJSmL/cOAzb0b8262p6NW8Ku0JmPcQONHO4WRpvOKQAo1aOXHsskA==
X-Received: by 2002:a05:6a00:a96:b0:736:33fd:f57d with SMTP id d2e1a72fcca58-74049239b22mr1705425b3a.17.1746080636763;
        Wed, 30 Apr 2025 23:23:56 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7404f9fed21sm108134b3a.93.2025.04.30.23.23.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Apr 2025 23:23:56 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	qemu-arm@nongnu.org,
	richard.henderson@linaro.org,
	alex.bennee@linaro.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	anjo@rev.ng,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	kvm@vger.kernel.org,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v3 06/33] target/arm/cpu: move arm_cpu_kvm_set_irq to kvm.c
Date: Wed, 30 Apr 2025 23:23:17 -0700
Message-ID: <20250501062344.2526061-7-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250501062344.2526061-1-pierrick.bouvier@linaro.org>
References: <20250501062344.2526061-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
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


