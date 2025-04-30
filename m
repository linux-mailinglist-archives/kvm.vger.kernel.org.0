Return-Path: <kvm+bounces-44927-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E7D3AA4F47
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 16:59:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 61AB41C00259
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 14:59:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CBB41E501C;
	Wed, 30 Apr 2025 14:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="vMmB8ukh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92F7925B1D9
	for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 14:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746025138; cv=none; b=LHyppj4NNyWWsX20fvNHkOibv44szYzaAJW/ixPEyoEGMo5zLC3fon2iEIRibcmiPe6KITXFJ31luP+HsYHHmdE7CnFauVYzh4N9CG2yPa5l/0xCAw+2IFkqCznnPaciBYhbU7frfOuIbQxeFyj4oT8sTv1SM79G+Jmvw53R4Vo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746025138; c=relaxed/simple;
	bh=xEbQ96lfj/SCU8D3ei0gP3NCuOuGt/57epS14AQeCxw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pamGIRBLfbkN3rKmIXMAwBMTAstlKYSKrrOwhbn1FVbzu90NVxVWt/n0THPW4B/BvMvxELSvBFwgrGgAs6BpV66A+j7QwHjXX5GRNxDSAB3HTu0wxlDGtzCVWt31/kmAsF4Dih+kzYjH1dmy771Gu3BmeqjNv6NcAWSiNqVuwDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=vMmB8ukh; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-af548cb1f83so7466139a12.3
        for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 07:58:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746025136; x=1746629936; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hX/hJH1gLLVfS0bwh/LZYqdKvfx19Rxb8RxfxI3LnbE=;
        b=vMmB8ukhPLqFuqFSgijadurbKLNj1QWyJEeFz50JIU3QIzKMs9uPkKSsuko0IyiL5o
         0ZEQtAM60gwy0GVQS919AFOTww28Ep97Pcwcd0JomzFi1KMZI4+75CQ5qqsJQ9O6qRol
         pOA93sOyC0U02emAooW3CveoGPISjHl6G97uuQ/8/yjqD/FFSJRtImCUbu3h76L6Wayf
         Ltk1b8rttEmqMiCMjvsjixWLp2O1xukJ60V6qEx7hiNHV0perIhijVFi/Liaq6E8YJoW
         dblQAf/DsfayP5g5r3/SSqisKy5e1Uh4P39U1ZO/dIyTo1qawKRgHSeGn49qjx3N8RK+
         4MyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746025136; x=1746629936;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hX/hJH1gLLVfS0bwh/LZYqdKvfx19Rxb8RxfxI3LnbE=;
        b=QhAXZaia4Vmhp3v61qZZvp4dBRrQE3BwwFY/knFSVO6aeHKcPpZOmMk9IOrlNVT/r4
         2o0k9k6AEZuQAn010nkBwWg+V7E6HIfKh2li0B2Cq9ejfe3Ty+U726+mQFvr2MWEEchx
         x37u2txfozlY6CWymPvgXYAJtwPVhXE65XRxmefLbzylw+cPmvqW/ZQZlmSiOSKxvo9q
         WR/TIU6FLKd/zVF7gJSIUrkDOGmI6KVSMVS3reQDKL5DYgHA+WLK8/aORsMsLa0d4UTe
         9ecIgBKa+DY7pjsUMP8KXKzTkN/U5mVJRh8yUQCrDCdLf0WL7E2heYbYo/osQQs6cV5L
         1WJw==
X-Forwarded-Encrypted: i=1; AJvYcCVypqC2K+ZHrHLf/k/SS7om3gm51vUgkEuBO3WLwnbBwJbB8O4y1XfGEEs8OCt1MtjvXhM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy049x5YrBWpySvSaS7CXPoLkuiuMnSR+7XmDRPGh7H3fzqcBo7
	EzBG7shYdfe6fSadyo6bR+1lfOUXXmRybh3IJXWRQJMW0H0mVo5Tqe6Pvk93zx0=
X-Gm-Gg: ASbGncu7zVn1L/p4UL2o15iq6DgreobH8IpFHeh/5sLXuNeJA1Dce5sB5Kq66wCrJem
	uhzcvuN2FobtrGRe5f8gSt8gDKnSr0cZVF0KKJe00xcRc4Y85nxfiUv71Eb3U0Ru2JDqP5p6g+g
	vgv8Ncz47jnzddMbUyHXLA5p+IER3GfQ6jwgs1g6CB+2XtfG2vNFTH2CAY1oatD/XUdDhHadJEl
	+ViGy+C/YwILPpi+/3j+Kx0PYDb1qGrS8WsUPb5TKR6n+wibzoJwioNpSJ+g6RL57wQG/2VLfMT
	3Z38ye9RzbKYKELugZZiwoENVu6QSWXozYU4xxpk
X-Google-Smtp-Source: AGHT+IGRjjiEH+IBiShXoujq9YBdCredlo8Tlf7FnR1GflfbdHF/SogYBgWNL1xlnSq0hXKTupdl1A==
X-Received: by 2002:a17:90b:3806:b0:2f2:a664:df20 with SMTP id 98e67ed59e1d1-30a343e80afmr5103795a91.7.1746025135869;
        Wed, 30 Apr 2025 07:58:55 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30a34a5bd78sm1705652a91.42.2025.04.30.07.58.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Apr 2025 07:58:55 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: qemu-arm@nongnu.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	Peter Maydell <peter.maydell@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	alex.bennee@linaro.org,
	richard.henderson@linaro.org,
	anjo@rev.ng,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v2 06/12] target/arm/cpu: move arm_cpu_kvm_set_irq to kvm.c
Date: Wed, 30 Apr 2025 07:58:31 -0700
Message-ID: <20250430145838.1790471-7-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250430145838.1790471-1-pierrick.bouvier@linaro.org>
References: <20250430145838.1790471-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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


