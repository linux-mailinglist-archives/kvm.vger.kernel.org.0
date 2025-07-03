Return-Path: <kvm+bounces-51442-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DBF93AF7140
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 13:00:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2B5794E1471
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 10:59:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C0C32E426C;
	Thu,  3 Jul 2025 10:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Mo3b5jpa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 864C82E2EFE
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 10:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751540353; cv=none; b=OarGO4giP1FF7W7SpN5diYsRpDvMOHkBgOGk79cMz0jr1NlwomRqShlPjjMOzeDTR7eIIK3naAz3vsWRKPosTGQvTldLkKI7F5f/JsccOjWWzeAhH/l8BtB+B0bxs5hlHYIVM6glgupnB1kfFGLxL+pidrI1GBXa1BGChuZrNrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751540353; c=relaxed/simple;
	bh=cM1jNKIynr/XnMr+YQEhbbrtr3fhckcfsXwPCGsXvvQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a4mpUi/z/VjIH0znC2WC+I71Q8Ru8ytGu+Xtixn87+CN8h+fC2RvHypUrmODSXBx75yEnr+IPqSg60r4cjspfXZ4nYspTnS/dQGtfeGFKYkaEzSLp2sNLcjtg8kf/29gQh5veR8LOT4w7SBGoWR/qCymkibSzJdH5pCH9VT1DX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Mo3b5jpa; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-454ac069223so2984475e9.1
        for <kvm@vger.kernel.org>; Thu, 03 Jul 2025 03:59:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751540350; x=1752145150; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vFAqYWkOt5rZ34pscE5bkNOMRRS/BXy8okDEtUQzC0Y=;
        b=Mo3b5jpaWYRcwcuKpvX6BKAi3y8WEg9IDxhrbuipQ6V3JjceXU7J2ryXqbA6ePHJaK
         FYKHKkJ1IVJhCDuW2IniSmWgU4K6kba86QnlFXOGbSlCoW90bpcfMci65PgWznzzQhpo
         OmwaA1W0i266Uorb7JButSDF2J57J77nxr3mQ1xE86IDqirtz5ZnTi3bTcBXammn4WmL
         GVx4AW3Cfg7Ql9+pZVtcWsEhVA08Rjd1rjAIhFoxPEEyOWfzRrkVO30RCB1keerxGZZJ
         zQLKSJii2uni44GYY697Jx8+MJ8ig3kRgE0cgHra42hAtNyZU4R6TAKbRYdzSoJTfZn9
         g+HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751540350; x=1752145150;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vFAqYWkOt5rZ34pscE5bkNOMRRS/BXy8okDEtUQzC0Y=;
        b=eulxkhA+xgJ4fyVtog7296Hsnv91oyB/NezVI3TRl/8yufPDiUGXD1mS2fTibIDLj0
         uDmH5fpp/NcxI4xtH2fiFPPzOKP0gNOHefBcEI9+ejlCkFaU4pq1oXgQ0Mqb4s1R7yBe
         sJ9YCFj2MEkZdAL+A1dKFs2ZusMtb1a3o14CbZIp5TTVO62JmAPkBHper/ClWzL9BL5l
         WjnBOCSIIfnQVgGfj4FRpuoMvLL9RIcggfOFZHlMcg5wfBem/fMZ4104wXgixAe/RV4W
         oZ1zjqBmJTltf/XMc+wRXxWIdAgDtUwI2E9KawX0EPzR+riVx0k4mhHHBQA2TuFLhvoK
         w8vg==
X-Forwarded-Encrypted: i=1; AJvYcCXMVxzZGpOGrwsdAk6yxTwTcTbsE7vbkieE5/Jgq+LP/7GP9vU1ckLRMW1AwFLAlQfK6dE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyvJWRmSZ5MQKIVYtQtl68SzDCM5xxZMKKMhQtSD+7Vvj2c1/X+
	Sf0P36frAycWKfzekrITa1Xa33RpufctVIT7h6oAL/GG7VESOubWUVk1Bmm2btBEy4s=
X-Gm-Gg: ASbGnctFBgNN0+esNCpxbpgGr6cJGpIPlokpZesmypnIaNbZ1r8+JOo23rjo46lkh6j
	AVLXqZmml76qNANsy8RSgmtzaimTPwzzqBoN4OCFrQWzoHZ6IDvNYaZlwbD5lDRWEPzN3kY+Nxe
	lQZrHcdvMR3gvwBct1sZxFX/j9fxmUyP5vB1G6sbGYcWTb9zxA6riSWvYupdNpUuN1US8sZ8EUJ
	VEANteAyR2QIlLXpHUB3ZvJsmUDgjXOm7Ge+bkER75mDHYw42ykjFknQft9P4PvtSDWouQlTe47
	DgX2U2KzeLJSK9Y39Foz9v/z3EjIztrff8O3FvoJ+c+uISLfYUezyh/KNpfOm6gKYLCN+Pql88B
	R8TgWrxr/DDCJT0hvQATqZA==
X-Google-Smtp-Source: AGHT+IEpLtcQemMkcwNXCmGS2HYXOrXVSmrpZfH3haYqqpBfUcpznPUG0hMZrhqDiS/8G+BDKrWdvQ==
X-Received: by 2002:a05:6000:4026:b0:3a5:6860:f47f with SMTP id ffacd0b85a97d-3b34281c3efmr1987415f8f.6.1751540349695;
        Thu, 03 Jul 2025 03:59:09 -0700 (PDT)
Received: from localhost.localdomain ([83.247.137.20])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a892e52bb3sm18654339f8f.56.2025.07.03.03.59.08
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Jul 2025 03:59:09 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	kvm@vger.kernel.org,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Reinoud Zandijk <reinoud@netbsd.org>
Subject: [PATCH v5 39/69] accel/nvmm: Replace @dirty field by generic CPUState::vcpu_dirty field
Date: Thu,  3 Jul 2025 12:55:05 +0200
Message-ID: <20250703105540.67664-40-philmd@linaro.org>
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
 target/i386/nvmm/nvmm-all.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/target/i386/nvmm/nvmm-all.c b/target/i386/nvmm/nvmm-all.c
index eaae175aa5d..f521c36dc53 100644
--- a/target/i386/nvmm/nvmm-all.c
+++ b/target/i386/nvmm/nvmm-all.c
@@ -30,7 +30,6 @@ struct AccelCPUState {
     struct nvmm_vcpu vcpu;
     uint8_t tpr;
     bool stop;
-    bool dirty;
 
     /* Window-exiting for INTs/NMIs. */
     bool int_window_exit;
@@ -508,7 +507,7 @@ nvmm_io_callback(struct nvmm_io *io)
     }
 
     /* Needed, otherwise infinite loop. */
-    current_cpu->accel->dirty = false;
+    current_cpu->vcpu_dirty = false;
 }
 
 static void
@@ -517,7 +516,7 @@ nvmm_mem_callback(struct nvmm_mem *mem)
     cpu_physical_memory_rw(mem->gpa, mem->data, mem->size, mem->write);
 
     /* Needed, otherwise infinite loop. */
-    current_cpu->accel->dirty = false;
+    current_cpu->vcpu_dirty = false;
 }
 
 static struct nvmm_assist_callbacks nvmm_callbacks = {
@@ -727,9 +726,9 @@ nvmm_vcpu_loop(CPUState *cpu)
      * Inner VCPU loop.
      */
     do {
-        if (cpu->accel->dirty) {
+        if (cpu->vcpu_dirty) {
             nvmm_set_registers(cpu);
-            cpu->accel->dirty = false;
+            cpu->vcpu_dirty = false;
         }
 
         if (qcpu->stop) {
@@ -827,32 +826,32 @@ static void
 do_nvmm_cpu_synchronize_state(CPUState *cpu, run_on_cpu_data arg)
 {
     nvmm_get_registers(cpu);
-    cpu->accel->dirty = true;
+    cpu->vcpu_dirty = true;
 }
 
 static void
 do_nvmm_cpu_synchronize_post_reset(CPUState *cpu, run_on_cpu_data arg)
 {
     nvmm_set_registers(cpu);
-    cpu->accel->dirty = false;
+    cpu->vcpu_dirty = false;
 }
 
 static void
 do_nvmm_cpu_synchronize_post_init(CPUState *cpu, run_on_cpu_data arg)
 {
     nvmm_set_registers(cpu);
-    cpu->accel->dirty = false;
+    cpu->vcpu_dirty = false;
 }
 
 static void
 do_nvmm_cpu_synchronize_pre_loadvm(CPUState *cpu, run_on_cpu_data arg)
 {
-    cpu->accel->dirty = true;
+    cpu->vcpu_dirty = true;
 }
 
 void nvmm_cpu_synchronize_state(CPUState *cpu)
 {
-    if (!cpu->accel->dirty) {
+    if (!cpu->vcpu_dirty) {
         run_on_cpu(cpu, do_nvmm_cpu_synchronize_state, RUN_ON_CPU_NULL);
     }
 }
@@ -982,7 +981,7 @@ nvmm_init_vcpu(CPUState *cpu)
         }
     }
 
-    qcpu->dirty = true;
+    qcpu->vcpu_dirty = true;
     cpu->accel = qcpu;
 
     return 0;
-- 
2.49.0


