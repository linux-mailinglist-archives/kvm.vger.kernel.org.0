Return-Path: <kvm+bounces-51424-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 30399AF7126
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 12:58:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 23BC34E4A29
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 10:57:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40E172E2F12;
	Thu,  3 Jul 2025 10:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="qgKdWqi7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B00E2DE70E
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 10:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751540258; cv=none; b=rhXEQA8dRW109q9RygUFdpY/+EkpTyaEnZsQ0yDMSN+b3J8IIyN+hRvi/UHG6YnAMIZ89uS36cWqFALQPLvDYRY9pR/zgOGP4GaOYiixuC97L3IMT/ybx9UvCn5wXuKrUN2Cnes2WtS64S/s7FFhp3xRyyND2UnR5wT/O9VfomY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751540258; c=relaxed/simple;
	bh=SHEZEz4ml43ipmFVX+eo4CpYziNlBEyqk0PZONaHDvY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OBhYtPpUlFd7JwqILUFE2mJ8IuU+e8JEEeMk8Ong2Hsu8bh2N64TagLaGPl31ZbTXC3LoJDTnnb9IEucuHe9+kqRgBdFxl9zhj97W/5u1u+9XGJkJVYmBdglwpkLCWfvhhrWoqN8so8/6yhzpvlXlkSAbKDVjjybSEBxQsodavU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=qgKdWqi7; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4535fbe0299so32538645e9.3
        for <kvm@vger.kernel.org>; Thu, 03 Jul 2025 03:57:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751540254; x=1752145054; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MzsXmG16DASHWsIXbw9ajDisw+zUQq9t5Ugm0qpyfec=;
        b=qgKdWqi7vSAcNmU60WcNUfKyYL543tiwskJsR0kQdj0Rur3IQucp/DJPBy8qpEEe5n
         gs/aSQ7oyDra3DpiBlzWh/4urpL70+Tuu4PIKQXSxMvrTU4mT8/dVUO7L5g6093flLDL
         Rg7rHVZugd9R5QOIejoD2goJecGVpyqj2gRsr1KJyxdCB9TdpokwdZImYpNEeIS0GGcT
         fF5LMtABoRymYD+XEo4yoJnYpugfBuhJl1+OqjqF23rcI7VdL5TMBjk82rFP8GGRL/Tm
         eLjfh0If4phdy++bsaCp76e/6gCXCD4wAmQ8lWXq4n/KkFkofnX5xV4sGpvzYlChFcKk
         SwAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751540254; x=1752145054;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MzsXmG16DASHWsIXbw9ajDisw+zUQq9t5Ugm0qpyfec=;
        b=wzSy7UUJFXuPB/Q1QQm+htwWpuT9nijKgSeP8r+D299pAzwoyh+MrUKZgFav4Gxs33
         qJ7PCml0Eznh0tttYXmsO5QgBboJcjyEZ73EtORzNex5XiSknuHgs7fP2U1ODj6ZioSC
         D1wrfX+HLgrWnwd2ZSQ3ReoiqJAGCBSYGsyotOKnORcQu9EHDEeLjdi/MynpjrIuigcT
         gEorHW/95T1EaVP8KPg0Q1gPma8SmXMSIwfsVCYB1xv1ZMjbcKu9iDesWANrGc+RkLWR
         f+Xf9qkt+8BxJSaXs/lhWNSO4CTXw/tqlclzM5jXDTe7f57NVVAKEMRrjkxX+a0cQ3Kz
         WoWA==
X-Forwarded-Encrypted: i=1; AJvYcCW1aDKMHUjzW14oAoI08X/ZcdBAKH0jUw425DZKV32ZAS/4euuE75ZYkBVo71XpgyuoDoY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzd/ABm0U38P0/fyBNtiZrPmnyXFBTCshB24lwVwq33ww+wMp2W
	miHIhiSEAXZrHX/XutRQs3zc8uIHB3gS1XWm2t/I3YQqQ2723UsEH+hDnWZmaHLEuYU=
X-Gm-Gg: ASbGnct4gVyOtQeFLtPIWq5mXTYlDoK9CimuYyyhkW9sjMtKy8tbEXFGfdqPSs8mpPR
	GhZGlK3da6ndMeyB42/lz16vx78rYJaS+eps2zJ6D5+vHx78zSU+/+aKePW84HH7PGr3UeSN+cj
	lDucswjzoASCMVg1Mqs2McB6bmWa0AYOBz0DEeQb169D3CHWaveDOpZ4wOX/FowyRP9jp00J6BP
	DziTML0iENDj566MKk3tGLVNxP4rcFTqvXJGtnG5ZpZBaal3heLl67QRHAmCHBGFACqn5I2RRfv
	jVMeO2dtwpeAf1YI+6AXcBjuGk/st0EMw9lJN4yMdPX9tbZYQsuMQP+XxZuDweJZbqBeL+fd3W3
	z+MzQWl0JvD4=
X-Google-Smtp-Source: AGHT+IH/6u+aXxLt7sGZ69z19XQupL3QFWV9ITJcqOhSUMtGX9QWGmsqODskJ2yOy8OR7GzwbiBLiw==
X-Received: by 2002:a05:6000:42c9:b0:3a4:ef30:a4c8 with SMTP id ffacd0b85a97d-3b32bae096bmr1447841f8f.10.1751540253936;
        Thu, 03 Jul 2025 03:57:33 -0700 (PDT)
Received: from localhost.localdomain ([83.247.137.20])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a892e5f8b6sm18666357f8f.91.2025.07.03.03.57.32
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Jul 2025 03:57:33 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	kvm@vger.kernel.org,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Sunil Muthuswamy <sunilmut@microsoft.com>
Subject: [PATCH v5 21/69] accel/system: Convert pre_resume() from AccelOpsClass to AccelClass
Date: Thu,  3 Jul 2025 12:54:47 +0200
Message-ID: <20250703105540.67664-22-philmd@linaro.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250703105540.67664-1-philmd@linaro.org>
References: <20250703105540.67664-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Accelerators call pre_resume() once. Since it isn't a method to
call for each vCPU, move it from AccelOpsClass to AccelClass.
Adapt WHPX.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 include/qemu/accel.h              | 3 +++
 include/system/accel-ops.h        | 1 -
 target/i386/whpx/whpx-accel-ops.h | 1 -
 accel/accel-system.c              | 9 +++++++++
 system/cpus.c                     | 4 +---
 target/i386/whpx/whpx-accel-ops.c | 1 -
 target/i386/whpx/whpx-all.c       | 3 ++-
 7 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/include/qemu/accel.h b/include/qemu/accel.h
index 518c99ab643..065de80a87b 100644
--- a/include/qemu/accel.h
+++ b/include/qemu/accel.h
@@ -47,6 +47,7 @@ typedef struct AccelClass {
     bool (*has_memory)(AccelState *accel, AddressSpace *as,
                        hwaddr start_addr, hwaddr size);
     bool (*cpus_are_resettable)(AccelState *as);
+    void (*pre_resume_vm)(AccelState *as, bool step_pending);
 
     /* gdbstub related hooks */
     bool (*supports_guest_debug)(AccelState *as);
@@ -86,6 +87,8 @@ int accel_init_machine(AccelState *accel, MachineState *ms);
 /* Called just before os_setup_post (ie just before drop OS privs) */
 void accel_setup_post(MachineState *ms);
 
+void accel_pre_resume(MachineState *ms, bool step_pending);
+
 /**
  * accel_cpu_instance_init:
  * @cpu: The CPU that needs to do accel-specific object initializations.
diff --git a/include/system/accel-ops.h b/include/system/accel-ops.h
index fb199dc78f0..af54302409c 100644
--- a/include/system/accel-ops.h
+++ b/include/system/accel-ops.h
@@ -47,7 +47,6 @@ struct AccelOpsClass {
     void (*synchronize_post_init)(CPUState *cpu);
     void (*synchronize_state)(CPUState *cpu);
     void (*synchronize_pre_loadvm)(CPUState *cpu);
-    void (*synchronize_pre_resume)(bool step_pending);
 
     void (*handle_interrupt)(CPUState *cpu, int mask);
 
diff --git a/target/i386/whpx/whpx-accel-ops.h b/target/i386/whpx/whpx-accel-ops.h
index e6cf15511d4..54cfc25a147 100644
--- a/target/i386/whpx/whpx-accel-ops.h
+++ b/target/i386/whpx/whpx-accel-ops.h
@@ -21,7 +21,6 @@ void whpx_cpu_synchronize_state(CPUState *cpu);
 void whpx_cpu_synchronize_post_reset(CPUState *cpu);
 void whpx_cpu_synchronize_post_init(CPUState *cpu);
 void whpx_cpu_synchronize_pre_loadvm(CPUState *cpu);
-void whpx_cpu_synchronize_pre_resume(bool step_pending);
 
 /* state subset only touched by the VCPU itself during runtime */
 #define WHPX_SET_RUNTIME_STATE   1
diff --git a/accel/accel-system.c b/accel/accel-system.c
index 637e2390f35..11ba8e24d60 100644
--- a/accel/accel-system.c
+++ b/accel/accel-system.c
@@ -62,6 +62,15 @@ void accel_setup_post(MachineState *ms)
     }
 }
 
+void accel_pre_resume(MachineState *ms, bool step_pending)
+{
+    AccelState *accel = ms->accelerator;
+    AccelClass *acc = ACCEL_GET_CLASS(accel);
+    if (acc->pre_resume_vm) {
+        acc->pre_resume_vm(accel, step_pending);
+    }
+}
+
 bool cpus_are_resettable(void)
 {
     AccelState *accel = current_accel();
diff --git a/system/cpus.c b/system/cpus.c
index 4fb764ac880..2c3759ea9be 100644
--- a/system/cpus.c
+++ b/system/cpus.c
@@ -762,9 +762,7 @@ int vm_prepare_start(bool step_pending)
      * WHPX accelerator needs to know whether we are going to step
      * any CPUs, before starting the first one.
      */
-    if (cpus_accel->synchronize_pre_resume) {
-        cpus_accel->synchronize_pre_resume(step_pending);
-    }
+    accel_pre_resume(MACHINE(qdev_get_machine()), step_pending);
 
     /* We are sending this now, but the CPUs will be resumed shortly later */
     qapi_event_send_resume();
diff --git a/target/i386/whpx/whpx-accel-ops.c b/target/i386/whpx/whpx-accel-ops.c
index b8bebe403c9..011810b5e50 100644
--- a/target/i386/whpx/whpx-accel-ops.c
+++ b/target/i386/whpx/whpx-accel-ops.c
@@ -95,7 +95,6 @@ static void whpx_accel_ops_class_init(ObjectClass *oc, const void *data)
     ops->synchronize_post_init = whpx_cpu_synchronize_post_init;
     ops->synchronize_state = whpx_cpu_synchronize_state;
     ops->synchronize_pre_loadvm = whpx_cpu_synchronize_pre_loadvm;
-    ops->synchronize_pre_resume = whpx_cpu_synchronize_pre_resume;
 }
 
 static const TypeInfo whpx_accel_ops_type = {
diff --git a/target/i386/whpx/whpx-all.c b/target/i386/whpx/whpx-all.c
index f0be840b7db..821167a2a77 100644
--- a/target/i386/whpx/whpx-all.c
+++ b/target/i386/whpx/whpx-all.c
@@ -2106,7 +2106,7 @@ void whpx_cpu_synchronize_pre_loadvm(CPUState *cpu)
     run_on_cpu(cpu, do_whpx_cpu_synchronize_pre_loadvm, RUN_ON_CPU_NULL);
 }
 
-void whpx_cpu_synchronize_pre_resume(bool step_pending)
+static void whpx_pre_resume_vm(AccelState *as, bool step_pending)
 {
     whpx_global.step_pending = step_pending;
 }
@@ -2703,6 +2703,7 @@ static void whpx_accel_class_init(ObjectClass *oc, const void *data)
     AccelClass *ac = ACCEL_CLASS(oc);
     ac->name = "WHPX";
     ac->init_machine = whpx_accel_init;
+    ac->pre_resume_vm = whpx_pre_resume_vm;
     ac->allowed = &whpx_allowed;
 
     object_class_property_add(oc, "kernel-irqchip", "on|off|split",
-- 
2.49.0


