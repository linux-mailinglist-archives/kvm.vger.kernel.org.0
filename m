Return-Path: <kvm+bounces-7220-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F43383E482
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 23:05:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 750F71C21206
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 22:05:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D9364595F;
	Fri, 26 Jan 2024 22:04:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="fwB1mHsj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BD9443AC4
	for <kvm@vger.kernel.org>; Fri, 26 Jan 2024 22:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706306690; cv=none; b=gGjY2uTEZwkEFkgz75nKHXKyGPUAkKo5KL37cbIOLs3G0O75fsTi6/7aGxazPYiy3jKTevsrxE9Eo4qlD8V7BcwaFEoWdmhtfitB4dy8jY4IWPXfb1PYtYWLjp+bX5pEfUg6zLfI/JDS1aztvdwPMHQvQvu96P9Tof0f0iz89G8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706306690; c=relaxed/simple;
	bh=7LZsh/ftUO/+WptUJpQnSY+dGSISrzOGS6CV50LmCNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=k8UHud2ItAriv/Jm4zC5KOCOFzLbZG/vcrIUZN1DWmKZ7T4o1ohavoUkd1pscgymJO+Nn6f1BHwtxiiwms6rh8y4NTqzx/SpaiDctJ/wiwKnudzJsHueqV5iZGdsy5UKj+jYqZIQrLER14DSnkuIE8CjA5yc1ACgXkT7aUfGy4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=fwB1mHsj; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-55a539d205aso979641a12.3
        for <kvm@vger.kernel.org>; Fri, 26 Jan 2024 14:04:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1706306686; x=1706911486; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VRDZsAVCeKNjeYo+uMKOWsXHzCtDJO1BqKvym46fO1w=;
        b=fwB1mHsjhJL3Ptx9uEke9oErxBkbypIYlls6vAStT9DwCcUPNURMGJD1b+2+23kJjC
         LQROo7RG9QsTbercKGicqCPVGnrcQthwdikJhMTzWpcAodWPvLXVsBRaNfms557r530w
         dL86xjbPUNIqqckqpkz0SrLidFVmeo115Jed5IQRhCkElCco4UNTnQgudfD+KeNi/jQ2
         wRz9JXHkEzWRvtKcNAdKm6CZT6rVH0g7ztiZbsmDdpFtkihnyB9zd2q1ktlqi4RC6FvN
         rpQGk+379HjWNWcMl/Q9KzBaVMbHvTBwTGWuDRp7H4Hv3ie7ST+UtES8X01lRSZLKnyb
         YfZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706306686; x=1706911486;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VRDZsAVCeKNjeYo+uMKOWsXHzCtDJO1BqKvym46fO1w=;
        b=Qn2PeDSLEo162Iu20I/TfwVCmEtAOcMckyPyFS2qG9BxM5NfBHheFrBn5Re3Fy0iRa
         rly4Urqmez7JuSU0mo2/iKdFpeGWEkF4rEdPPNyoO4JAh/hMBiShXQaE4chmkN3TSy0i
         5fW0Iww8og1gG36ekPiUUbGzKT37X0No89wcM/3kb31z4U6LgfsveL3w1pg0dhCkzlCJ
         Axrg2g/GBabLzgUOTAXkfiqKM48ex7D830cz3yVbs8V1gs5jskOF2O3i94DRR8BTldmb
         g74n/bGrmYVhpQEgZh2+IU59VA5XDBn0uMczDkoeSutmeVney09nvAKPcqAg+VpCJmHw
         11bg==
X-Gm-Message-State: AOJu0Yzxt0O5KCZ4OGR/g0Mrw7HB0EsmMXuhU8qFCNIGhn20G8x8HDOE
	ZUciPWtm/s7uPH/6e0Eb9DHJXjeBzFzxPvLmlnG8BIKU80YJnpcGYHa43n+nN4c=
X-Google-Smtp-Source: AGHT+IHTfEcgSksuOIIKpp6/FxDzCiCmGegHFfvtO9Oagqe7Xe64Ye3dgCpZ2GcKkkqpkEKaxO5XfA==
X-Received: by 2002:a05:6402:22cb:b0:55e:b1c2:3939 with SMTP id dm11-20020a05640222cb00b0055eb1c23939mr48980edb.37.1706306686644;
        Fri, 26 Jan 2024 14:04:46 -0800 (PST)
Received: from m1x-phil.lan ([176.176.142.39])
        by smtp.gmail.com with ESMTPSA id er24-20020a056402449800b0055a82fe01cdsm1008665edb.67.2024.01.26.14.04.45
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 26 Jan 2024 14:04:46 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: qemu-arm@nongnu.org,
	Thomas Huth <thuth@redhat.com>,
	qemu-s390x@nongnu.org,
	qemu-riscv@nongnu.org,
	Eduardo Habkost <eduardo@habkost.net>,
	kvm@vger.kernel.org,
	qemu-ppc@nongnu.org,
	Richard Henderson <richard.henderson@linaro.org>,
	Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Michael Rolnik <mrolnik@gmail.com>
Subject: [PATCH v2 06/23] target/avr: Prefer fast cpu_env() over slower CPU QOM cast macro
Date: Fri, 26 Jan 2024 23:03:48 +0100
Message-ID: <20240126220407.95022-7-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20240126220407.95022-1-philmd@linaro.org>
References: <20240126220407.95022-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Mechanical patch produced running the command documented
in scripts/coccinelle/cpu_env.cocci_template header.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/avr/cpu.c     | 27 +++++++--------------------
 target/avr/gdbstub.c |  6 ++----
 target/avr/helper.c  | 10 +++-------
 3 files changed, 12 insertions(+), 31 deletions(-)

diff --git a/target/avr/cpu.c b/target/avr/cpu.c
index f5cbdc4a8c..2ad24373a8 100644
--- a/target/avr/cpu.c
+++ b/target/avr/cpu.c
@@ -43,31 +43,22 @@ static vaddr avr_cpu_get_pc(CPUState *cs)
 
 static bool avr_cpu_has_work(CPUState *cs)
 {
-    AVRCPU *cpu = AVR_CPU(cs);
-    CPUAVRState *env = &cpu->env;
-
     return (cs->interrupt_request & (CPU_INTERRUPT_HARD | CPU_INTERRUPT_RESET))
-            && cpu_interrupts_enabled(env);
+            && cpu_interrupts_enabled(cpu_env(cs));
 }
 
 static void avr_cpu_synchronize_from_tb(CPUState *cs,
                                         const TranslationBlock *tb)
 {
-    AVRCPU *cpu = AVR_CPU(cs);
-    CPUAVRState *env = &cpu->env;
-
     tcg_debug_assert(!(cs->tcg_cflags & CF_PCREL));
-    env->pc_w = tb->pc / 2; /* internally PC points to words */
+    cpu_env(cs)->pc_w = tb->pc / 2; /* internally PC points to words */
 }
 
 static void avr_restore_state_to_opc(CPUState *cs,
                                      const TranslationBlock *tb,
                                      const uint64_t *data)
 {
-    AVRCPU *cpu = AVR_CPU(cs);
-    CPUAVRState *env = &cpu->env;
-
-    env->pc_w = data[0];
+    cpu_env(cs)->pc_w = data[0];
 }
 
 static void avr_cpu_reset_hold(Object *obj)
@@ -165,8 +156,7 @@ static ObjectClass *avr_cpu_class_by_name(const char *cpu_model)
 
 static void avr_cpu_dump_state(CPUState *cs, FILE *f, int flags)
 {
-    AVRCPU *cpu = AVR_CPU(cs);
-    CPUAVRState *env = &cpu->env;
+    CPUAVRState *env = cpu_env(cs);
     int i;
 
     qemu_fprintf(f, "\n");
@@ -276,8 +266,7 @@ static void avr_cpu_class_init(ObjectClass *oc, void *data)
  */
 static void avr_avr5_initfn(Object *obj)
 {
-    AVRCPU *cpu = AVR_CPU(obj);
-    CPUAVRState *env = &cpu->env;
+    CPUAVRState *env = cpu_env(CPU(obj));
 
     set_avr_feature(env, AVR_FEATURE_LPM);
     set_avr_feature(env, AVR_FEATURE_IJMP_ICALL);
@@ -305,8 +294,7 @@ static void avr_avr5_initfn(Object *obj)
  */
 static void avr_avr51_initfn(Object *obj)
 {
-    AVRCPU *cpu = AVR_CPU(obj);
-    CPUAVRState *env = &cpu->env;
+    CPUAVRState *env = cpu_env(CPU(obj));
 
     set_avr_feature(env, AVR_FEATURE_LPM);
     set_avr_feature(env, AVR_FEATURE_IJMP_ICALL);
@@ -335,8 +323,7 @@ static void avr_avr51_initfn(Object *obj)
  */
 static void avr_avr6_initfn(Object *obj)
 {
-    AVRCPU *cpu = AVR_CPU(obj);
-    CPUAVRState *env = &cpu->env;
+    CPUAVRState *env = cpu_env(CPU(obj));
 
     set_avr_feature(env, AVR_FEATURE_LPM);
     set_avr_feature(env, AVR_FEATURE_IJMP_ICALL);
diff --git a/target/avr/gdbstub.c b/target/avr/gdbstub.c
index 150344d8b9..2eeee2bf4e 100644
--- a/target/avr/gdbstub.c
+++ b/target/avr/gdbstub.c
@@ -23,8 +23,7 @@
 
 int avr_cpu_gdb_read_register(CPUState *cs, GByteArray *mem_buf, int n)
 {
-    AVRCPU *cpu = AVR_CPU(cs);
-    CPUAVRState *env = &cpu->env;
+    CPUAVRState *env = cpu_env(cs);
 
     /*  R */
     if (n < 32) {
@@ -53,8 +52,7 @@ int avr_cpu_gdb_read_register(CPUState *cs, GByteArray *mem_buf, int n)
 
 int avr_cpu_gdb_write_register(CPUState *cs, uint8_t *mem_buf, int n)
 {
-    AVRCPU *cpu = AVR_CPU(cs);
-    CPUAVRState *env = &cpu->env;
+    CPUAVRState *env = cpu_env(cs);
 
     /*  R */
     if (n < 32) {
diff --git a/target/avr/helper.c b/target/avr/helper.c
index fdc9884ea0..eeca415c43 100644
--- a/target/avr/helper.c
+++ b/target/avr/helper.c
@@ -30,8 +30,7 @@
 
 bool avr_cpu_exec_interrupt(CPUState *cs, int interrupt_request)
 {
-    AVRCPU *cpu = AVR_CPU(cs);
-    CPUAVRState *env = &cpu->env;
+    CPUAVRState *env = cpu_env(cs);
 
     /*
      * We cannot separate a skip from the next instruction,
@@ -69,8 +68,7 @@ bool avr_cpu_exec_interrupt(CPUState *cs, int interrupt_request)
 
 void avr_cpu_do_interrupt(CPUState *cs)
 {
-    AVRCPU *cpu = AVR_CPU(cs);
-    CPUAVRState *env = &cpu->env;
+    CPUAVRState *env = cpu_env(cs);
 
     uint32_t ret = env->pc_w;
     int vector = 0;
@@ -144,9 +142,7 @@ bool avr_cpu_tlb_fill(CPUState *cs, vaddr address, int size,
             if (probe) {
                 page_size = 1;
             } else {
-                AVRCPU *cpu = AVR_CPU(cs);
-                CPUAVRState *env = &cpu->env;
-                env->fullacc = 1;
+                cpu_env(cs)->fullacc = 1;
                 cpu_loop_exit_restore(cs, retaddr);
             }
         }
-- 
2.41.0


