Return-Path: <kvm+bounces-45300-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6688BAA83F0
	for <lists+kvm@lfdr.de>; Sun,  4 May 2025 07:30:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 27BC2189A5C9
	for <lists+kvm@lfdr.de>; Sun,  4 May 2025 05:30:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC0FC18DB26;
	Sun,  4 May 2025 05:29:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="mrh6PkSC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D79A1684AE
	for <kvm@vger.kernel.org>; Sun,  4 May 2025 05:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746336569; cv=none; b=VoA49dagc1DIwPIYJm7wZDHD9AeXCcxJTFc1bbMQDhoVYqqNPGqdabhggukdimsE8xA+6WDANlbU/OMDKkatxYP0am+QC8TBNly7kmyykUB0ogyDIE4TFsUEeb/KbowwyHEfq5AzKw+nge4848u5tNnpTmY4VPa/cKmEYSvxspE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746336569; c=relaxed/simple;
	bh=pLhVywQOsnQQXulAr9P+c2k7oCnBigTaDPegpWLj1Gk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rs1OD3YgLm/t1XRIk4uqCxIOJ/29Ubb+AUNh/z8ouzpgm9jA8OWDlzRoifertscR8Z1WikKxoDhy6Sbe2Syum1GqB8QIf1bvOUtiFxqfR3lJwAHWZTPpUVASmZGmsHlr7cWsXIQ7v0Sh7mWEtsoZbSwRj/AFYrFQHqbQX3AR7uU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=mrh6PkSC; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-7376dd56f8fso4680996b3a.2
        for <kvm@vger.kernel.org>; Sat, 03 May 2025 22:29:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746336566; x=1746941366; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=48VeJmtQLPOhxBVuGtRwfY5ps2vP+Hg73z2yA0rcj8A=;
        b=mrh6PkSCvo9yTbCp6qNlYsOSYI6SgQNsJaJkolGASS31C2bY948Iv/fIBHd6MaYwvA
         E1iWWVIT/oKKeK+Rg59p2WS3rG9ADMQC+kofBPgkRs3WV9VfVSbr482Us58Qg3/xFG8V
         PlxU0+kstiuFRLBlUqq3u/dbDOLJRxOfrNyluI4K8zzyUdt1Z1gUNe2pqoJk/jDDqBwx
         U0Y73YVXOmxA7C5WLBbkdYX+fjXbwkXxIHjeHLvmPVwMLsNJ4uYbOKhm8EHKoU7X99Mt
         SGgWznU0QJw5Z86Wsi+U6wrTBtfAg+wdBE755fELj8EpiZ7mOkBKt9opIAlHKIomg1zo
         tpUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746336566; x=1746941366;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=48VeJmtQLPOhxBVuGtRwfY5ps2vP+Hg73z2yA0rcj8A=;
        b=RHhE+UHvc4tYKRk51s+7urE9/CUnXDYbtiBlEfP4LtVJFJJ1rrKkbLN4bn2TpSCpWc
         RHr3B0UPykQ05vrcvaK9vY0vMKQqgudhSguOf71/qRUEufz9yvJWO/Z2Widc32NnvnTb
         v+6fWmRg8pzctvAIBr4OVye9yFIB+BC7Ogd7OuBpgl/i8O8+kb9AReJBJP5vOYij20F2
         Mohx/PL7U3VInaDohxUCsg8T2/RFSBvM4r4CT9L6lnopmm/4Osiu8VzP2WLY0T7lqFJ/
         IB57+jOgkZNC4CgjofzuZW7C8FlNZZaqduJvNl/SKgAjkKjQxkNl8Ow93WHFvU3nBxVF
         w/Og==
X-Forwarded-Encrypted: i=1; AJvYcCUL1UbKtYGuSgYOL9Z8x3QfZQ2fBmlRsqh1DGGqz2jgRfIAbcAVn479uivy+huLUtNSi/4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwlL2RIGEcV9anIGbnj8nKiD6fySEoGB6/JxbdirgRQQZiLeXAI
	WUnqhF0DzXhfbczxaDQBPocBY3bsZwQKMyYE1VXEcQdPAzqJfvjGJ4ZljlLcE/b47LXnxiUx3Nx
	JPxE=
X-Gm-Gg: ASbGncstMqHQKHxgoHnoesyRIm28HJkETU72WqCN+b+TDle4mR1TxsPsHiCZ9qmOGjr
	DZGVp6wlcDncaS2EJBCbUqRWoDq5ER5xICXMr9YKgGTev63ns3FFLvWyEIzjpjK4oZnA69BhMt3
	HurZOnXOOVYl2rYDnqgFpQSKJiidTkT7dXLuC59Ci5zZAivPvQLj5Janf+JKxlusgHOC/plY8LL
	WNorzvRs9fBk2NCafBkVP6LK/tUXXCYqTgbyRtuykHDDnCjO0V71U+nzniH4cJ/CROnuIhC/OxI
	WAt7X3N/JUjtwFGCLcMfvazN+IAaAGYOlP99OkJS
X-Google-Smtp-Source: AGHT+IEGCJ8bOHzgy9WrMpyjAziCFb1lEAaArfWX0xV8zNipX1Q0lcIdis5LRQByYZG4ALdALvRpJg==
X-Received: by 2002:aa7:9306:0:b0:73e:1e21:b653 with SMTP id d2e1a72fcca58-740672b165dmr5420738b3a.5.1746336566670;
        Sat, 03 May 2025 22:29:26 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-740590207e3sm4400511b3a.94.2025.05.03.22.29.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 May 2025 22:29:26 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	qemu-arm@nongnu.org,
	anjo@rev.ng,
	kvm@vger.kernel.org,
	richard.henderson@linaro.org,
	Peter Maydell <peter.maydell@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	alex.bennee@linaro.org,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v4 07/40] target/arm/cpu: move arm_cpu_kvm_set_irq to kvm.c
Date: Sat,  3 May 2025 22:28:41 -0700
Message-ID: <20250504052914.3525365-8-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250504052914.3525365-1-pierrick.bouvier@linaro.org>
References: <20250504052914.3525365-1-pierrick.bouvier@linaro.org>
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


