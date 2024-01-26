Return-Path: <kvm+bounces-7235-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E298E83E4AF
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 23:09:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D69C91C23358
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 22:09:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3B5C2E3E4;
	Fri, 26 Jan 2024 22:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ECh2SKRc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48FF32555E
	for <kvm@vger.kernel.org>; Fri, 26 Jan 2024 22:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706306785; cv=none; b=P8KGN/EFiHGpxVhTgCgGxbrvgUDwVju8mf3O3fsajvGW06OHP8EVBCtLmV45wGKHF0jewuG3pIiItxHWhWOP0aDVaHADwUP/1aSEcE2UDDGzpiU7+TosgrpDIp95DKoyPiBVEdVUAu48ZlaNLOaz/U5pmNabOm/h+yHgxNY+7NE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706306785; c=relaxed/simple;
	bh=kQIj/Okg5eAzamYjUoUwfm59wqdNrYwL8c1qYbBzRQ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EQL94WQcOStHyu8xDGtpyz/93sUugCVru1XpMur07YLV3zwwyvK7cJlH7anj2dPNrgr42b+Y3bxwCst1/yrWS19dAxGOl61Jy/wNWjzPpqQdliEJZ9B3XLelrPU2xxAIeyb4OX0/lysS1MhGH5MWtWZ7TpLMNEwllJrMbbw1jc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ECh2SKRc; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-3394dc75eadso908727f8f.2
        for <kvm@vger.kernel.org>; Fri, 26 Jan 2024 14:06:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1706306781; x=1706911581; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vV6dlj18pAtxWLV4KcwUuJD4lVU4OiaIF5yNARG5Efc=;
        b=ECh2SKRc5a18tNq6uDXQQudlGUb9ir6NxuINAgjSVFge4skCPSDAC61d7yDEivsb4+
         xEG6Iwllzm517Dws/zIZQaRW1QCHuV20lHUnMFn0OcHsDpY/1jKr6/VWFB2JC3D4mUR3
         /HRzmyZ3Zr3SwhtoSkUMZgJOhiBduzKQjqbsllTZ9Mp/sl819xGJttPYlBAxDxhXdoUY
         4hnIH01kIYYxX0YLNzvPWwsSL8txtkShHuobGHiptdaikfnh5C5qe78CN9MBjoNYTwT3
         H02aa6o3/esxjqV2V4OjyiBc53G3OQq7EkqmEc0IoshXUSdvYSlOM1ORLEv9nAnRTl4S
         9lVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706306781; x=1706911581;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vV6dlj18pAtxWLV4KcwUuJD4lVU4OiaIF5yNARG5Efc=;
        b=Ftux8GLSNDaDdLzV2JOsSze5nD+QTM0bnYatax6/a7pjKh2HEmr3BpIfbi5wD04BLo
         jhGdk9Q0Z/oJNUHGUgBfhsNtmZRz6jN6IHgiev7FZzeV1fsYGHAGE1YqzTvlf1+xmrW8
         jIV+J9nJ0PHoPfxhlUxayytLRnnGv1eUjZ6jVXnR9RkIqBnY4dOYNYJkJfgp9XPXx+Pv
         naVau2ub/W7mOnkG+t05UKFVwVgeb6QQZMlgQDGsxpM5x5h7s34Y4+uNUjzU5/tOEhTf
         IVFHrokLjXt1yoAnFRvgzX6SSniB878ils2zhnEjpsyhiutkg1yhppyoQqEK0xnkiMYl
         //ZQ==
X-Gm-Message-State: AOJu0YyPOaTOCkLZrG9wQMDPs8uWQQ7jIzN4qYn65vPl/OL2a9fOxwgH
	yfDF+RK9YWnKAk67dODlubjMOIRzsDRQBpGTb9sxpuKVn/NhSCTkQGD21r+T6ps=
X-Google-Smtp-Source: AGHT+IEILfBTjrvb6AYehjpbj/erQivk6DH/567rWQm8N/mmRzPIMyAQrBr8ZvoYrwb5nMIDLR/v/w==
X-Received: by 2002:adf:f48d:0:b0:337:bfdb:5b8d with SMTP id l13-20020adff48d000000b00337bfdb5b8dmr216861wro.115.1706306781480;
        Fri, 26 Jan 2024 14:06:21 -0800 (PST)
Received: from m1x-phil.lan ([176.176.142.39])
        by smtp.gmail.com with ESMTPSA id n14-20020a5d6b8e000000b0033ade016ba5sm1380477wrx.4.2024.01.26.14.06.19
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 26 Jan 2024 14:06:21 -0800 (PST)
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
	Bastian Koppelmann <kbastian@mail.uni-paderborn.de>
Subject: [PATCH v2 21/23] target/tricore: Prefer fast cpu_env() over slower CPU QOM cast macro
Date: Fri, 26 Jan 2024 23:04:03 +0100
Message-ID: <20240126220407.95022-22-philmd@linaro.org>
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
 target/tricore/cpu.c       | 20 ++++----------------
 target/tricore/gdbstub.c   |  6 ++----
 target/tricore/helper.c    |  3 +--
 target/tricore/translate.c |  3 +--
 4 files changed, 8 insertions(+), 24 deletions(-)

diff --git a/target/tricore/cpu.c b/target/tricore/cpu.c
index 8acacdf0c0..7f0609090c 100644
--- a/target/tricore/cpu.c
+++ b/target/tricore/cpu.c
@@ -36,38 +36,26 @@ static const gchar *tricore_gdb_arch_name(CPUState *cs)
 
 static void tricore_cpu_set_pc(CPUState *cs, vaddr value)
 {
-    TriCoreCPU *cpu = TRICORE_CPU(cs);
-    CPUTriCoreState *env = &cpu->env;
-
-    env->PC = value & ~(target_ulong)1;
+    cpu_env(cs)->PC = value & ~(target_ulong)1;
 }
 
 static vaddr tricore_cpu_get_pc(CPUState *cs)
 {
-    TriCoreCPU *cpu = TRICORE_CPU(cs);
-    CPUTriCoreState *env = &cpu->env;
-
-    return env->PC;
+    return cpu_env(cs)->PC;
 }
 
 static void tricore_cpu_synchronize_from_tb(CPUState *cs,
                                             const TranslationBlock *tb)
 {
-    TriCoreCPU *cpu = TRICORE_CPU(cs);
-    CPUTriCoreState *env = &cpu->env;
-
     tcg_debug_assert(!(cs->tcg_cflags & CF_PCREL));
-    env->PC = tb->pc;
+    cpu_env(cs)->PC = tb->pc;
 }
 
 static void tricore_restore_state_to_opc(CPUState *cs,
                                          const TranslationBlock *tb,
                                          const uint64_t *data)
 {
-    TriCoreCPU *cpu = TRICORE_CPU(cs);
-    CPUTriCoreState *env = &cpu->env;
-
-    env->PC = data[0];
+    cpu_env(cs)->PC = data[0];
 }
 
 static void tricore_cpu_reset_hold(Object *obj)
diff --git a/target/tricore/gdbstub.c b/target/tricore/gdbstub.c
index e8f8e5e6ea..f9309c5e27 100644
--- a/target/tricore/gdbstub.c
+++ b/target/tricore/gdbstub.c
@@ -106,8 +106,7 @@ static void tricore_cpu_gdb_write_csfr(CPUTriCoreState *env, int n,
 
 int tricore_cpu_gdb_read_register(CPUState *cs, GByteArray *mem_buf, int n)
 {
-    TriCoreCPU *cpu = TRICORE_CPU(cs);
-    CPUTriCoreState *env = &cpu->env;
+    CPUTriCoreState *env = cpu_env(cs);
 
     if (n < 16) { /* data registers */
         return gdb_get_reg32(mem_buf, env->gpr_d[n]);
@@ -121,8 +120,7 @@ int tricore_cpu_gdb_read_register(CPUState *cs, GByteArray *mem_buf, int n)
 
 int tricore_cpu_gdb_write_register(CPUState *cs, uint8_t *mem_buf, int n)
 {
-    TriCoreCPU *cpu = TRICORE_CPU(cs);
-    CPUTriCoreState *env = &cpu->env;
+    CPUTriCoreState *env = cpu_env(cs);
     uint32_t tmp;
 
     tmp = ldl_p(mem_buf);
diff --git a/target/tricore/helper.c b/target/tricore/helper.c
index 174f666e1e..d328414c99 100644
--- a/target/tricore/helper.c
+++ b/target/tricore/helper.c
@@ -67,8 +67,7 @@ bool tricore_cpu_tlb_fill(CPUState *cs, vaddr address, int size,
                           MMUAccessType rw, int mmu_idx,
                           bool probe, uintptr_t retaddr)
 {
-    TriCoreCPU *cpu = TRICORE_CPU(cs);
-    CPUTriCoreState *env = &cpu->env;
+    CPUTriCoreState *env = cpu_env(cs);
     hwaddr physical;
     int prot;
     int ret = 0;
diff --git a/target/tricore/translate.c b/target/tricore/translate.c
index 66553d1be0..ad314bdf3c 100644
--- a/target/tricore/translate.c
+++ b/target/tricore/translate.c
@@ -95,8 +95,7 @@ enum {
 
 void tricore_cpu_dump_state(CPUState *cs, FILE *f, int flags)
 {
-    TriCoreCPU *cpu = TRICORE_CPU(cs);
-    CPUTriCoreState *env = &cpu->env;
+    CPUTriCoreState *env = cpu_env(cs);
     uint32_t psw;
     int i;
 
-- 
2.41.0


