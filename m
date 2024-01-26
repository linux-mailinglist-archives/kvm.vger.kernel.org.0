Return-Path: <kvm+bounces-7234-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 23AA883E4AE
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 23:09:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A6BA21F21AD2
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 22:09:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 661F8286BD;
	Fri, 26 Jan 2024 22:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="PF4/Hlib"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 995602556C
	for <kvm@vger.kernel.org>; Fri, 26 Jan 2024 22:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706306778; cv=none; b=jsC/gv1NfIdulNrc0JHIJPMrQTYFhU5mPbu53ifGhgBn6QcbZb5N1cxHBNcUY6JwYgdITqPgHsgGYsov/nqpFGS/SaChWMKyuw1MiqRDfS7qs1AssBimaPwgG+cVHZroVNjxTPvCX6b4RqaUvL2Y9NEEcfu/e1XGFhC50H9rJ5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706306778; c=relaxed/simple;
	bh=8LmqU9yjgNdQvLQyecghfn9zAsXYBZZP2oV+iI7FEjk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nUTWn3Ie0O8DGS7CqouxYbPDXe2DEojeuNBUEc2XP/TIeaQyf7NPJEdSDIhgaI2PeaOvDwUTRzb7IwklEWxkMC2TdBZwPCZr1qAjNTMZfIV6v8aaio4VwrA5Y7ECIsSfNdjSmFq+0J2FVAlretrF98zoTWLTqN9O6JitEUNyHVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=PF4/Hlib; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-40e775695c6so6715935e9.3
        for <kvm@vger.kernel.org>; Fri, 26 Jan 2024 14:06:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1706306775; x=1706911575; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YtuQrPEiaOdoOF8LUQEAgkD/kFrAu5dyJpYlVEeXrYA=;
        b=PF4/HlibH4+G6+oM47qYE+zvLHHsdRfi4ZEx8/Q1eaNOpSYXJna+/wevSwqfbPipgz
         rfDbiQZp4fPmG2h7HcQySR+T43JEWq+Td3xOIFkMXFAeIZi0/Mx/aloBhZroeoH10ixi
         WGchu50j26tqziZSVT+ux3AWXcE/lRvIZcft1LPAwGFMHW4WjTAq9bec1E55vXb7WIKS
         FOZUYRoxzTQuKKRlCMnxS0kBbuttrgr2h6EVWuyWIUddSmCho6q7Xq1wSyjHX++l9gzb
         xJ6YJ59WWM5dUrsKV9TCiibjab9h1YU+jyi/fH1AfsKbJ91ZnhtxYUaeCDIHLibdR3hX
         RbtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706306775; x=1706911575;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YtuQrPEiaOdoOF8LUQEAgkD/kFrAu5dyJpYlVEeXrYA=;
        b=DNMhfOLWut6K5jrfX0M89JpcS/m0tiRx7EUT71yK4M+c3u5kGq+qUgLpeeLLlXAJeH
         nH1bRBspjIfAP0/npUFGowpk9KgWMgRGxz8YiC3GcosvdzKcsI2qsnlJwX05WcZoyc6N
         8b40TZ/ZWgPFo1fbjdlJ4I77nf+mu/qb6htrLCgTBA1wp8Z82jj9/On6sAK9wt/eR7LC
         NYXBCGBlyeRCkl6UsHI+PONaBGm+kJHCW1PMzG4ZIJLZhrqDpJ7c4/adFjHxDx9Q85vy
         VT2agDd9jcRHxGv7lrz9etcotWJ2XX5tz2xc1Z/qD5QDCR3ZoIi5pmasuEzfITBzwJ5F
         dgFQ==
X-Gm-Message-State: AOJu0YwkU5PPZbMqrey5JzBsJh3eNXM17NIpXOSRP1vjOwAGtwQe8c8f
	IzLhQYD/DAYOTRPJUryM5+5hnxb6v0uhoYRtE5om9bUBzukhQFBSPXzISGr9VWM=
X-Google-Smtp-Source: AGHT+IGAJd1+nxpnhxNSxbbDkweDQV7fyyewwmnnG2Uh8Gfd0V5Pa5JSlH8Cjw1RHP8jg3sEePPxpg==
X-Received: by 2002:a05:600c:b8a:b0:40e:5947:bcf9 with SMTP id fl10-20020a05600c0b8a00b0040e5947bcf9mr535667wmb.18.1706306774930;
        Fri, 26 Jan 2024 14:06:14 -0800 (PST)
Received: from m1x-phil.lan ([176.176.142.39])
        by smtp.gmail.com with ESMTPSA id bu25-20020a056000079900b0033921b2a5d4sm2097084wrb.75.2024.01.26.14.06.13
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 26 Jan 2024 14:06:14 -0800 (PST)
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
	Yoshinori Sato <ysato@users.sourceforge.jp>
Subject: [PATCH v2 20/23] target/sh4: Prefer fast cpu_env() over slower CPU QOM cast macro
Date: Fri, 26 Jan 2024 23:04:02 +0100
Message-ID: <20240126220407.95022-21-philmd@linaro.org>
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
 target/sh4/cpu.c       | 15 +++++----------
 target/sh4/gdbstub.c   |  6 ++----
 target/sh4/helper.c    | 11 +++--------
 target/sh4/translate.c |  3 +--
 4 files changed, 11 insertions(+), 24 deletions(-)

diff --git a/target/sh4/cpu.c b/target/sh4/cpu.c
index 806a0ef875..786c77615e 100644
--- a/target/sh4/cpu.c
+++ b/target/sh4/cpu.c
@@ -71,8 +71,7 @@ static void superh_restore_state_to_opc(CPUState *cs,
 static bool superh_io_recompile_replay_branch(CPUState *cs,
                                               const TranslationBlock *tb)
 {
-    SuperHCPU *cpu = SUPERH_CPU(cs);
-    CPUSH4State *env = &cpu->env;
+    CPUSH4State *env = cpu_env(cs);
 
     if ((env->flags & (TB_FLAG_DELAY_SLOT | TB_FLAG_DELAY_SLOT_COND))
         && !(cs->tcg_cflags & CF_PCREL) && env->pc != tb->pc) {
@@ -144,8 +143,7 @@ out:
 
 static void sh7750r_cpu_initfn(Object *obj)
 {
-    SuperHCPU *cpu = SUPERH_CPU(obj);
-    CPUSH4State *env = &cpu->env;
+    CPUSH4State *env = cpu_env(CPU(obj));
 
     env->id = SH_CPU_SH7750R;
     env->features = SH_FEATURE_BCR3_AND_BCR4;
@@ -162,8 +160,7 @@ static void sh7750r_class_init(ObjectClass *oc, void *data)
 
 static void sh7751r_cpu_initfn(Object *obj)
 {
-    SuperHCPU *cpu = SUPERH_CPU(obj);
-    CPUSH4State *env = &cpu->env;
+    CPUSH4State *env = cpu_env(CPU(obj));
 
     env->id = SH_CPU_SH7751R;
     env->features = SH_FEATURE_BCR3_AND_BCR4;
@@ -180,8 +177,7 @@ static void sh7751r_class_init(ObjectClass *oc, void *data)
 
 static void sh7785_cpu_initfn(Object *obj)
 {
-    SuperHCPU *cpu = SUPERH_CPU(obj);
-    CPUSH4State *env = &cpu->env;
+    CPUSH4State *env = cpu_env(CPU(obj));
 
     env->id = SH_CPU_SH7785;
     env->features = SH_FEATURE_SH4A;
@@ -216,8 +212,7 @@ static void superh_cpu_realizefn(DeviceState *dev, Error **errp)
 
 static void superh_cpu_initfn(Object *obj)
 {
-    SuperHCPU *cpu = SUPERH_CPU(obj);
-    CPUSH4State *env = &cpu->env;
+    CPUSH4State *env = cpu_env(CPU(obj));
 
     env->movcal_backup_tail = &(env->movcal_backup);
 }
diff --git a/target/sh4/gdbstub.c b/target/sh4/gdbstub.c
index d8e199fc06..75926d4e04 100644
--- a/target/sh4/gdbstub.c
+++ b/target/sh4/gdbstub.c
@@ -26,8 +26,7 @@
 
 int superh_cpu_gdb_read_register(CPUState *cs, GByteArray *mem_buf, int n)
 {
-    SuperHCPU *cpu = SUPERH_CPU(cs);
-    CPUSH4State *env = &cpu->env;
+    CPUSH4State *env = cpu_env(cs);
 
     switch (n) {
     case 0 ... 7:
@@ -76,8 +75,7 @@ int superh_cpu_gdb_read_register(CPUState *cs, GByteArray *mem_buf, int n)
 
 int superh_cpu_gdb_write_register(CPUState *cs, uint8_t *mem_buf, int n)
 {
-    SuperHCPU *cpu = SUPERH_CPU(cs);
-    CPUSH4State *env = &cpu->env;
+    CPUSH4State *env = cpu_env(cs);
 
     switch (n) {
     case 0 ... 7:
diff --git a/target/sh4/helper.c b/target/sh4/helper.c
index 5a6f653c12..28b81a5c54 100644
--- a/target/sh4/helper.c
+++ b/target/sh4/helper.c
@@ -55,8 +55,7 @@ int cpu_sh4_is_cached(CPUSH4State *env, target_ulong addr)
 
 void superh_cpu_do_interrupt(CPUState *cs)
 {
-    SuperHCPU *cpu = SUPERH_CPU(cs);
-    CPUSH4State *env = &cpu->env;
+    CPUSH4State *env = cpu_env(cs);
     int do_irq = cs->interrupt_request & CPU_INTERRUPT_HARD;
     int do_exp, irq_vector = cs->exception_index;
 
@@ -782,11 +781,8 @@ int cpu_sh4_is_cached(CPUSH4State * env, target_ulong addr)
 bool superh_cpu_exec_interrupt(CPUState *cs, int interrupt_request)
 {
     if (interrupt_request & CPU_INTERRUPT_HARD) {
-        SuperHCPU *cpu = SUPERH_CPU(cs);
-        CPUSH4State *env = &cpu->env;
-
         /* Delay slots are indivisible, ignore interrupts */
-        if (env->flags & TB_FLAG_DELAY_SLOT_MASK) {
+        if (cpu_env(cs)->flags & TB_FLAG_DELAY_SLOT_MASK) {
             return false;
         } else {
             superh_cpu_do_interrupt(cs);
@@ -800,8 +796,7 @@ bool superh_cpu_tlb_fill(CPUState *cs, vaddr address, int size,
                          MMUAccessType access_type, int mmu_idx,
                          bool probe, uintptr_t retaddr)
 {
-    SuperHCPU *cpu = SUPERH_CPU(cs);
-    CPUSH4State *env = &cpu->env;
+    CPUSH4State *env = cpu_env(cs);
     int ret;
 
     target_ulong physical;
diff --git a/target/sh4/translate.c b/target/sh4/translate.c
index 81f825f125..4a933adad8 100644
--- a/target/sh4/translate.c
+++ b/target/sh4/translate.c
@@ -159,8 +159,7 @@ void sh4_translate_init(void)
 
 void superh_cpu_dump_state(CPUState *cs, FILE *f, int flags)
 {
-    SuperHCPU *cpu = SUPERH_CPU(cs);
-    CPUSH4State *env = &cpu->env;
+    CPUSH4State *env = cpu_env(cs);
     int i;
 
     qemu_fprintf(f, "pc=0x%08x sr=0x%08x pr=0x%08x fpscr=0x%08x\n",
-- 
2.41.0


