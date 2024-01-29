Return-Path: <kvm+bounces-7355-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 37ECF840C05
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 17:46:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A63951F25A32
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 16:46:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E63715699A;
	Mon, 29 Jan 2024 16:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="zVKdNBS6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B0CB156994
	for <kvm@vger.kernel.org>; Mon, 29 Jan 2024 16:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706546779; cv=none; b=LFJrxNpQR1sGlw/7pRD+EMO6s5bLS/s9bL7SIY45DlQZhiWY67a1iwAAnik79tGNdQ2Ea+VrNi0ZK/KbWDFkQQSxP+aaDPGVvFP2NQzrmbIAw6T5KH/oXrfu/4WXApqWYwk2xcEkRH5+747G5j//voqxyi5DUk3I/F73egJ8XG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706546779; c=relaxed/simple;
	bh=NazPBoG4idGkPrQ0qwibwDT624h1U2xsSOeI8rVS6F0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hzeZP0z1rKGk5gK1ElDpJEHCOQFoJD21RcrjRMwBKc+SfzdDBeJj1CIyDalrp78wk2XTAQikTvoPPWhAuj3LTveEgtcnFyN5bfwW9vlFPZQ7jxaRM5rb0ZZwrMozBIVQaDwdIaNqSoER2d3n+9/Xra0TEZQ/OhnylHtn3FuuL+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=zVKdNBS6; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-40ef6454277so10536275e9.2
        for <kvm@vger.kernel.org>; Mon, 29 Jan 2024 08:46:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1706546776; x=1707151576; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pPVrCbRU1M9we1PYSP3dETCN8UlJAlkr84+2F+spRWs=;
        b=zVKdNBS6jaGAh7z4fpppqnyJfwh/OBLVy3uvh5s37FBJanueKCeJ/wJtJNr0s8+Chq
         Qk9WACfsVLSasd3ePG8i96xFP4CmVRf2rjnyDFpFmM5385yCH/AZ54cXEXgB6C136qA/
         c1sgs5r4N9hg8KOq/5yfZ2Yj2yGh3iOdd6/+Iwvnp3t7DLxU3OvWmU9JtIEibHgl4mV4
         MAaKoOVb3shuEUhebGBOn7kbRN48w+K55BNmBeXetlpLoZ4oPFvDPqhPJYa083uLrqjR
         tbTirVEcZLufZXQyylL/wMLfDAKS5/kbuf0K9kQNYVxXLmLj+Z0hvUuSo2iYSmgERk+t
         B14Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706546776; x=1707151576;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pPVrCbRU1M9we1PYSP3dETCN8UlJAlkr84+2F+spRWs=;
        b=IZ8AxQo9Dn4ojH12r/byZdH2sgksQGUi9G9ewUyXJDwM1SkuRzD9q2K7BVEjkYxpfM
         wU2zxSVTVohVVNqeyIOPn8z5Z8FpJfeASbYWDvDLrI9jkkUqnYlIFlm9pVXxkMkdtO29
         ylQkc/f3ix4V1zi++0Dtg7TctMkXFgXGU1Ho30gHqrleWJtGHYlkhX44l83RH0XR1/Bs
         pxKC9AuKn86SVPWVQrUKr2rIcTwjyoelfQK2wh41DMBCxRzLYF57JA7KKtKcx+eZbFz/
         hhO4+8kaA+1Kenj6D2BgxMX6m4oVlQzLAtBv4x/5BJlBOr3LcSbV7tgFnnrzIVQBXo9t
         chEA==
X-Gm-Message-State: AOJu0YwiKthOCwLhhPTuv/pdha5EC9PbR3F1txaKJEfT2+w1VgNtLNSz
	2J5LMXnTHU8amY+pJ6sAXVt+pppTA+B2/9Y3da/37j8A1YZwNqGB9Jd/knvAkDs=
X-Google-Smtp-Source: AGHT+IGoyi1GJloWLT4o+Y6UqAMpV8DbzJbKaJW69srVFEf22YWTwUw/j8yDRVynsB1cqMzyP4ftLg==
X-Received: by 2002:a05:600c:35d5:b0:40e:af40:b4da with SMTP id r21-20020a05600c35d500b0040eaf40b4damr6044761wmq.26.1706546775871;
        Mon, 29 Jan 2024 08:46:15 -0800 (PST)
Received: from m1x-phil.lan ([176.187.219.39])
        by smtp.gmail.com with ESMTPSA id t18-20020a05600c451200b0040e880ac6ecsm14562416wmo.35.2024.01.29.08.46.14
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 29 Jan 2024 08:46:15 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: qemu-riscv@nongnu.org,
	qemu-s390x@nongnu.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	qemu-ppc@nongnu.org,
	qemu-arm@nongnu.org,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Michael Rolnik <mrolnik@gmail.com>
Subject: [PATCH v3 09/29] target/avr: Prefer fast cpu_env() over slower CPU QOM cast macro
Date: Mon, 29 Jan 2024 17:44:51 +0100
Message-ID: <20240129164514.73104-10-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20240129164514.73104-1-philmd@linaro.org>
References: <20240129164514.73104-1-philmd@linaro.org>
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

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/avr/cpu.c       | 27 +++++++--------------------
 target/avr/gdbstub.c   |  6 ++----
 target/avr/helper.c    | 10 +++-------
 target/avr/translate.c |  3 +--
 4 files changed, 13 insertions(+), 33 deletions(-)

diff --git a/target/avr/cpu.c b/target/avr/cpu.c
index 0f191a4c9d..50ded8538b 100644
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
diff --git a/target/avr/translate.c b/target/avr/translate.c
index cdffa04519..682a44139e 100644
--- a/target/avr/translate.c
+++ b/target/avr/translate.c
@@ -2657,11 +2657,10 @@ static bool canonicalize_skip(DisasContext *ctx)
 static void avr_tr_init_disas_context(DisasContextBase *dcbase, CPUState *cs)
 {
     DisasContext *ctx = container_of(dcbase, DisasContext, base);
-    CPUAVRState *env = cpu_env(cs);
     uint32_t tb_flags = ctx->base.tb->flags;
 
     ctx->cs = cs;
-    ctx->env = env;
+    ctx->env = cpu_env(cs);
     ctx->npc = ctx->base.pc_first / 2;
 
     ctx->skip_cond = TCG_COND_NEVER;
-- 
2.41.0


