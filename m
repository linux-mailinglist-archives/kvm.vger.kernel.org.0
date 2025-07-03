Return-Path: <kvm+bounces-51443-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 64FB0AF7142
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 13:00:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A72F64825CE
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 10:59:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1457F2E4249;
	Thu,  3 Jul 2025 10:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="aa86waQJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AC032E2F1F
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 10:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751540358; cv=none; b=PTsTGDCvkbf33PqlkJNMZHeMdBcpCTNGaZOtKnDK/W5GQpU1ZpVbxC1QzGvSOt0ZQZcEFXIyBsUMk5mP56f+HRs1rs3CWfMgD5HZJ17sFhKX5aVfS+gfkqHT7QU+b5SEGgJ0S2CQj+jq8gzmPtyT97mc2mS0wcnzOEZqNoZMuHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751540358; c=relaxed/simple;
	bh=1x8PxDl0vCFSTthVc1lBCD4l8Z1HbMrQYC3HKK0aDf4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ndNodSq10GhYVwKk57hzX+2bGq7yieRa0Hl5T8O9rVcwmy4NnLhAb/2LlXh9g4efThhEfFllPCmY16uRJFvqESqqPwmk9tAFPM9XL8Yiv/HQNnQViR11JUmTtqhVf/YNttD/KNQSWzFQ3Xq6qsch4qsfD33Us5adZzHGYpwLNs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=aa86waQJ; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-451dbe494d6so58595515e9.1
        for <kvm@vger.kernel.org>; Thu, 03 Jul 2025 03:59:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751540355; x=1752145155; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l2PGC0Y3eaTf7CcEogf+cHF/JmHLi48aNNQRIJR2xDQ=;
        b=aa86waQJ+5J9JquhwJ9MxVj8mP5AtShkWk8DAL3jrENxY9QssKbM+SUQClLQRqZzvR
         kLBD6edU+Lz3WvY6F3cH8hVyKOspqfvmVuPls0EDdhJ2n0KiWd1L3Qfry7Jxxzcl9hoH
         4mIrNifW1qUS+mEdBm+TNPF4Zpiu/0lqbM2qCctaQN7HmhHGWNqfZ3wp3Cc3NoQ+6wWW
         CM8RtSwZ+ITYL3iMJadnUtal10TFay9iptqRT6gqTfWqLyHg+8wE3Xu2Ef63rOI8u4xI
         z1FrT5126rVBGK8KgLLc2AgoM8indY9/Oka1ZZlNeCZF+OwufqWs3cM10k9bgBIUlZvA
         UW5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751540355; x=1752145155;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l2PGC0Y3eaTf7CcEogf+cHF/JmHLi48aNNQRIJR2xDQ=;
        b=XwAroWtqJBlW1yh4NZwS0LFTOsWE3qblOcL1r95XZ0NAgolNo6IqO9n18edPJVoybR
         Nv6ese+TCnmRIBADZjtEHisvx2fIR+MnJghZWkZDMM96C/dTGFEv4/SP3MhFCt5uD33i
         OR51QQ+2XZCnF0aZF+zRA/VRuhDTZFQim2xq2S1Hri73YLeOtIXIGZ+r4YlOcn2GOgll
         1UaU641ZwB5UUiqR4xnp+Jj3LyFb6e1szre0CjUeU1Oxqm310BTF3Poj58x30kHgGjze
         ok5sDxQuRB/S9RTZEQRjqhER0Ufi7A0Hu2D18aGTQ3qeP5KcKtXqvMoNv+XXGWKzLJ/y
         7Ytw==
X-Forwarded-Encrypted: i=1; AJvYcCUcHtpYKx5ZAJiGP8UbF71uV0D7yaqV9DS34KKd7NblY0QyoEMHNF5fRx21Q5U3o1vsiGs=@vger.kernel.org
X-Gm-Message-State: AOJu0YynLYW9ii2DWJR2jJYQm3PX00Ik5u3nnken/xTpB0vZIWI5FbeM
	ry3LS0S8SOmgsaodMdNGcqsl0NrRHyp1YQMS9MNBuUSpr8EVfDsY07KelMAUxvgmH+A=
X-Gm-Gg: ASbGncurLaJHWqVZHtpS1Ot5bhOH9TnjhdL3BJlFxN1sJp/l3Zo87+p93GwEAORgdiy
	dBvfU3CsQXSnxrszOVoPuL5FA2r0MDvK6VU/fSOZ60du6tGjioVqbU9MAPxXBy5WIzBvvuvTu/u
	Yrq92t9ZjRUBFs0IV08qjPRO3sViX3l0UrRwu7OXrIuDBRTNsokAr7nI6SlZUSj3WPeXyIBfxus
	jIbibONyXOKi1jwWMpP/mtsY6k31e+iHHDQ/9/6v7F4nsuSKtDwtby7Nv3m538bWJ12ljucL1/m
	slloN4BQ+YCC6gjf/ppGs3/omLBIU3YIu98tfWJiZrBK2iWb9ad2sRDDTI0yhErTm+i3akj+fla
	daMoqL8K2uqs=
X-Google-Smtp-Source: AGHT+IEH6o23glPnSWgzT4Tyu2nuEfx1ONAPjD27xNsoZIhGywDOzMfGFQguEoku/1mG8S0e1h6Vxw==
X-Received: by 2002:a05:6000:2a88:b0:3a4:fcc3:4a14 with SMTP id ffacd0b85a97d-3b200865a3bmr4148920f8f.34.1751540354778;
        Thu, 03 Jul 2025 03:59:14 -0700 (PDT)
Received: from localhost.localdomain ([83.247.137.20])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a88c7e7524sm18507619f8f.12.2025.07.03.03.59.13
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Jul 2025 03:59:14 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	kvm@vger.kernel.org,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Sunil Muthuswamy <sunilmut@microsoft.com>
Subject: [PATCH v5 40/69] accel/whpx: Replace @dirty field by generic CPUState::vcpu_dirty field
Date: Thu,  3 Jul 2025 12:55:06 +0200
Message-ID: <20250703105540.67664-41-philmd@linaro.org>
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

No need for accel-specific @dirty field when we have
a generic one in CPUState.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 target/i386/whpx/whpx-all.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/target/i386/whpx/whpx-all.c b/target/i386/whpx/whpx-all.c
index 821167a2a77..525d6a9567b 100644
--- a/target/i386/whpx/whpx-all.c
+++ b/target/i386/whpx/whpx-all.c
@@ -237,7 +237,6 @@ struct AccelCPUState {
     uint64_t tpr;
     uint64_t apic_base;
     bool interruption_pending;
-    bool dirty;
 
     /* Must be the last field as it may have a tail */
     WHV_RUN_VP_EXIT_CONTEXT exit_ctx;
@@ -836,7 +835,7 @@ static HRESULT CALLBACK whpx_emu_setreg_callback(
      * The emulator just successfully wrote the register state. We clear the
      * dirty state so we avoid the double write on resume of the VP.
      */
-    cpu->accel->dirty = false;
+    cpu->vcpu_dirty = false;
 
     return hr;
 }
@@ -1391,7 +1390,7 @@ static int whpx_last_vcpu_stopping(CPUState *cpu)
 /* Returns the address of the next instruction that is about to be executed. */
 static vaddr whpx_vcpu_get_pc(CPUState *cpu, bool exit_context_valid)
 {
-    if (cpu->accel->dirty) {
+    if (cpu->vcpu_dirty) {
         /* The CPU registers have been modified by other parts of QEMU. */
         return cpu_env(cpu)->eip;
     } else if (exit_context_valid) {
@@ -1704,9 +1703,9 @@ static int whpx_vcpu_run(CPUState *cpu)
     }
 
     do {
-        if (cpu->accel->dirty) {
+        if (cpu->vcpu_dirty) {
             whpx_set_registers(cpu, WHPX_SET_RUNTIME_STATE);
-            cpu->accel->dirty = false;
+            cpu->vcpu_dirty = false;
         }
 
         if (exclusive_step_mode == WHPX_STEP_NONE) {
@@ -2054,9 +2053,9 @@ static int whpx_vcpu_run(CPUState *cpu)
 
 static void do_whpx_cpu_synchronize_state(CPUState *cpu, run_on_cpu_data arg)
 {
-    if (!cpu->accel->dirty) {
+    if (!cpu->vcpu_dirty) {
         whpx_get_registers(cpu);
-        cpu->accel->dirty = true;
+        cpu->vcpu_dirty = true;
     }
 }
 
@@ -2064,20 +2063,20 @@ static void do_whpx_cpu_synchronize_post_reset(CPUState *cpu,
                                                run_on_cpu_data arg)
 {
     whpx_set_registers(cpu, WHPX_SET_RESET_STATE);
-    cpu->accel->dirty = false;
+    cpu->vcpu_dirty = false;
 }
 
 static void do_whpx_cpu_synchronize_post_init(CPUState *cpu,
                                               run_on_cpu_data arg)
 {
     whpx_set_registers(cpu, WHPX_SET_FULL_STATE);
-    cpu->accel->dirty = false;
+    cpu->vcpu_dirty = false;
 }
 
 static void do_whpx_cpu_synchronize_pre_loadvm(CPUState *cpu,
                                                run_on_cpu_data arg)
 {
-    cpu->accel->dirty = true;
+    cpu->vcpu_dirty = true;
 }
 
 /*
@@ -2086,7 +2085,7 @@ static void do_whpx_cpu_synchronize_pre_loadvm(CPUState *cpu,
 
 void whpx_cpu_synchronize_state(CPUState *cpu)
 {
-    if (!cpu->accel->dirty) {
+    if (!cpu->vcpu_dirty) {
         run_on_cpu(cpu, do_whpx_cpu_synchronize_state, RUN_ON_CPU_NULL);
     }
 }
@@ -2226,7 +2225,7 @@ int whpx_init_vcpu(CPUState *cpu)
     }
 
     vcpu->interruptable = true;
-    vcpu->dirty = true;
+    cpu->vcpu_dirty = true;
     cpu->accel = vcpu;
     max_vcpu_index = max(max_vcpu_index, cpu->cpu_index);
     qemu_add_vm_change_state_handler(whpx_cpu_update_state, env);
-- 
2.49.0


