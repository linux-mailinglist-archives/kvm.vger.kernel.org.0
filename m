Return-Path: <kvm+bounces-7221-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C487883E484
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 23:05:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 303F2B24628
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 22:05:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC84D45C0F;
	Fri, 26 Jan 2024 22:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="wrq4+HyM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EFBE4596A
	for <kvm@vger.kernel.org>; Fri, 26 Jan 2024 22:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706306696; cv=none; b=r4c4NAUOcBugJSFZEih1UxUwBYr42BZMs2HHVygoSKcUaLRauhSSbiGdko8plKuLtlFjl6JhfwbMdcPJxU91x+RPDyiYAjyPwlUEiNGKY8KPHihcQzSyISpCowMesULvbvZ08qlIXN5GBVLONqnIWl9ky98ZsDJ2MD2CDwsqKjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706306696; c=relaxed/simple;
	bh=ANcf8VYZVB/WKBLG1VHS32hlTiQ71QDJIq3jBz3Mr+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=F1/HZh5MHAKnND8Asn7KXpGIIwOl2MGiUcg4wLDj6cmkfJrS2gkyu+Ox7sfO0+plDozrd0N6xFugu34ZXSMRS6/zeWjCmF78eAX4cMmNetujSaNaH+TrnfldA+JuVjvp7I7qWd4BIKFIVagd0HAy0UFGOD/CpGL9h0Kh0rMBV7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=wrq4+HyM; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-55c33773c0aso569002a12.1
        for <kvm@vger.kernel.org>; Fri, 26 Jan 2024 14:04:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1706306692; x=1706911492; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Geu08y2HUryuTkvO9FvgDhonl3J2Z6omRaCFm/Ev3sk=;
        b=wrq4+HyMvkzrSF6SSUrB06OyLeSXYxbu0QopETrzlXhNHGt3MmHB55MuuwmFYCDbG4
         VwnNxJpVjdBErAhym35i6xAFy1pXrDXMFLEOr1t7Pgt09PuSNziOO4YqBqOuQXLgJMP3
         UCS+3W8M7ajfW1/jRL3ULl4gkOSrAs5GnZDzDgb5egBKHBVjPnYNTstFwaP1kiafrLhJ
         SOSTOkmT1I9YtVQLot1RyuWfxA8OMAFBXIIS3bvGLxJI0UZ5quaojLDrKT9XCPR28nt8
         n49njOvcvYJGg4XPJ6krCanFx6HNpT6N9hKzUzAgWhVV7SUe0xFsdLLakbl+yI74dgFD
         1miQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706306692; x=1706911492;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Geu08y2HUryuTkvO9FvgDhonl3J2Z6omRaCFm/Ev3sk=;
        b=ou89lvyEPfPBANV8ye5tAfqG8FujNrfWqu/0AwSTf+RyLHRr+C7f/n/zxDtE6wiTbn
         YWvd1APKxTMlcN24C39B2OmSjz0ZHuhRx913fnVwc5DekXRnXig+UiCXjtEnIh8QvpCo
         JZoakpoFHQz4djX+PQb09vkg9HWz9u8uAVSmPXXZFnMEUba+dGZTUsAlSAFzd6DOsgkl
         9bk7YVdjTAZpRgm9GoDQNOdvaRflWO3ZowfukGsImumPKlk/1Ug68vtWDwX+ode3gACL
         p7tWKGZat1JnNEKaRpbNRpE1kOuhNOlPm0pczIID5ODup8bBFWIE8snpXXlrIWlc+DFI
         5tSA==
X-Gm-Message-State: AOJu0YyNcqgRBIC+8G/iPBJzAi25kl1ZbFFEpLhEVQNnTakrTOUzXWrJ
	/TVpEtyBlKKDABp6euQDa9HxglepzjAIgPxMpd4OfTQFyilhG5r9VbIdn3hSDX0=
X-Google-Smtp-Source: AGHT+IGSE90pXEWL7Cb+erfNLqyRjCQmI09xpCoNPYbEE91v5O4UfayumX9ZrTPlrejsKPpURCnYzg==
X-Received: by 2002:a05:6402:5243:b0:55d:164d:6f57 with SMTP id t3-20020a056402524300b0055d164d6f57mr246874edd.9.1706306692566;
        Fri, 26 Jan 2024 14:04:52 -0800 (PST)
Received: from m1x-phil.lan ([176.176.142.39])
        by smtp.gmail.com with ESMTPSA id ig9-20020a056402458900b00559bb146ecbsm1011608edb.6.2024.01.26.14.04.51
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 26 Jan 2024 14:04:52 -0800 (PST)
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
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>
Subject: [PATCH v2 07/23] target/cris: Prefer fast cpu_env() over slower CPU QOM cast macro
Date: Fri, 26 Jan 2024 23:03:49 +0100
Message-ID: <20240126220407.95022-8-philmd@linaro.org>
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
 target/cris/cpu.c       |  5 +----
 target/cris/gdbstub.c   |  9 +++------
 target/cris/helper.c    | 12 ++++--------
 target/cris/translate.c |  3 +--
 4 files changed, 9 insertions(+), 20 deletions(-)

diff --git a/target/cris/cpu.c b/target/cris/cpu.c
index 9ba08e8b0c..8ec32fade8 100644
--- a/target/cris/cpu.c
+++ b/target/cris/cpu.c
@@ -142,10 +142,7 @@ static void cris_cpu_set_irq(void *opaque, int irq, int level)
 
 static void cris_disas_set_info(CPUState *cpu, disassemble_info *info)
 {
-    CRISCPU *cc = CRIS_CPU(cpu);
-    CPUCRISState *env = &cc->env;
-
-    if (env->pregs[PR_VR] != 32) {
+    if (cpu_env(cpu)->pregs[PR_VR] != 32) {
         info->mach = bfd_mach_cris_v0_v10;
         info->print_insn = print_insn_crisv10;
     } else {
diff --git a/target/cris/gdbstub.c b/target/cris/gdbstub.c
index 25c0ca33a5..9e87069da8 100644
--- a/target/cris/gdbstub.c
+++ b/target/cris/gdbstub.c
@@ -23,8 +23,7 @@
 
 int crisv10_cpu_gdb_read_register(CPUState *cs, GByteArray *mem_buf, int n)
 {
-    CRISCPU *cpu = CRIS_CPU(cs);
-    CPUCRISState *env = &cpu->env;
+    CPUCRISState *env = cpu_env(cs);
 
     if (n < 15) {
         return gdb_get_reg32(mem_buf, env->regs[n]);
@@ -55,8 +54,7 @@ int crisv10_cpu_gdb_read_register(CPUState *cs, GByteArray *mem_buf, int n)
 
 int cris_cpu_gdb_read_register(CPUState *cs, GByteArray *mem_buf, int n)
 {
-    CRISCPU *cpu = CRIS_CPU(cs);
-    CPUCRISState *env = &cpu->env;
+    CPUCRISState *env = cpu_env(cs);
     uint8_t srs;
 
     srs = env->pregs[PR_SRS];
@@ -90,8 +88,7 @@ int cris_cpu_gdb_read_register(CPUState *cs, GByteArray *mem_buf, int n)
 
 int cris_cpu_gdb_write_register(CPUState *cs, uint8_t *mem_buf, int n)
 {
-    CRISCPU *cpu = CRIS_CPU(cs);
-    CPUCRISState *env = &cpu->env;
+    CPUCRISState *env = cpu_env(cs);
     uint32_t tmp;
 
     if (n > 49) {
diff --git a/target/cris/helper.c b/target/cris/helper.c
index c0bf987e3e..1c3f86876f 100644
--- a/target/cris/helper.c
+++ b/target/cris/helper.c
@@ -53,8 +53,7 @@ bool cris_cpu_tlb_fill(CPUState *cs, vaddr address, int size,
                        MMUAccessType access_type, int mmu_idx,
                        bool probe, uintptr_t retaddr)
 {
-    CRISCPU *cpu = CRIS_CPU(cs);
-    CPUCRISState *env = &cpu->env;
+    CPUCRISState *env = cpu_env(cs);
     struct cris_mmu_result res;
     int prot, miss;
     target_ulong phy;
@@ -97,8 +96,7 @@ bool cris_cpu_tlb_fill(CPUState *cs, vaddr address, int size,
 
 void crisv10_cpu_do_interrupt(CPUState *cs)
 {
-    CRISCPU *cpu = CRIS_CPU(cs);
-    CPUCRISState *env = &cpu->env;
+    CPUCRISState *env = cpu_env(cs);
     int ex_vec = -1;
 
     D_LOG("exception index=%d interrupt_req=%d\n",
@@ -159,8 +157,7 @@ void crisv10_cpu_do_interrupt(CPUState *cs)
 
 void cris_cpu_do_interrupt(CPUState *cs)
 {
-    CRISCPU *cpu = CRIS_CPU(cs);
-    CPUCRISState *env = &cpu->env;
+    CPUCRISState *env = cpu_env(cs);
     int ex_vec = -1;
 
     D_LOG("exception index=%d interrupt_req=%d\n",
@@ -262,8 +259,7 @@ hwaddr cris_cpu_get_phys_page_debug(CPUState *cs, vaddr addr)
 bool cris_cpu_exec_interrupt(CPUState *cs, int interrupt_request)
 {
     CPUClass *cc = CPU_GET_CLASS(cs);
-    CRISCPU *cpu = CRIS_CPU(cs);
-    CPUCRISState *env = &cpu->env;
+    CPUCRISState *env = cpu_env(cs);
     bool ret = false;
 
     if (interrupt_request & CPU_INTERRUPT_HARD
diff --git a/target/cris/translate.c b/target/cris/translate.c
index b3974ba0bb..a935167f00 100644
--- a/target/cris/translate.c
+++ b/target/cris/translate.c
@@ -3180,8 +3180,7 @@ void gen_intermediate_code(CPUState *cs, TranslationBlock *tb, int *max_insns,
 
 void cris_cpu_dump_state(CPUState *cs, FILE *f, int flags)
 {
-    CRISCPU *cpu = CRIS_CPU(cs);
-    CPUCRISState *env = &cpu->env;
+    CPUCRISState *env = cpu_env(cs);
     const char * const *regnames;
     const char * const *pregnames;
     int i;
-- 
2.41.0


