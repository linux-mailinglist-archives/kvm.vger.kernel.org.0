Return-Path: <kvm+bounces-7356-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 83F79840C06
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 17:46:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A95431C2158C
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 16:46:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06883153BCE;
	Mon, 29 Jan 2024 16:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="qQFKPulG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57E0C156970
	for <kvm@vger.kernel.org>; Mon, 29 Jan 2024 16:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706546785; cv=none; b=bDeww/oXEHRJ5rZ07EtjjLIPEmAOTFOg8Q/LBFg3BOqRPQVJvD+P3wN6IKLAgqbf3rrzQU7hcdYYHHtJo5LTTPqmp1Td4DWbIdNnhHj2jKBbcnin+bGd6pf9nsRIvysA6jlNNLBO3kVG7JUqLb0YZwZab5VzFmA/Vx18qLuwxCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706546785; c=relaxed/simple;
	bh=WQdcgXZXFPDVxFFne9SgVYtInJL2FCmyUtPTFJK3D5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ggVyb97eI+1PrIk0O9mKh34t0QoucGVZ6I4SctBwRo0nAL7wMk1Mz18l1xylQWSyXLTeA5sGzDjZYTIlA0oryt9zv1ofKk5XxpPdaI+iFWspEPW9ExwvLwWpZn682K2Pd9fN0y7gNt/jRaKtaSXKfzBAiq+WIQlIIBbwcySMrKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=qQFKPulG; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-33ae7ae1c32so1167908f8f.3
        for <kvm@vger.kernel.org>; Mon, 29 Jan 2024 08:46:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1706546781; x=1707151581; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qs1q2hIX1TKLXUzvNhNiLBWs7dxyWeQLrsbzeUj/euM=;
        b=qQFKPulGZO9TLXpkAHH/xG9RKyGTKJ1meI9HMF8INLVQsjXF9yK6B6ibW+QNDxzwfj
         e2e1Oa0CMcUbVzEOBVfK29EuN4DuteIVWRV2yxEQQE1/ESQ5dAprNHiFDsPhgnJBsKSq
         OB7PMTkh0Hwupsbj5tTCIiAKTIUfJ4S+nkKBxx8m1g16WVc8qLNlMay4eFslGXBKM0lz
         WTvJ2zVUixA6eOLFZ8r7qwHYzhy7D5FZVxoRTVnWX2Iet1h/lqnE6HDNxmhGGG1lHITB
         H93oJ5ZI3OjR9uaf0gjIy//gs3aCuMbxTMNIF/z0Z9VNqCKLhMJT32GyAftNYXa61w/u
         Qb/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706546781; x=1707151581;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qs1q2hIX1TKLXUzvNhNiLBWs7dxyWeQLrsbzeUj/euM=;
        b=gHLZgrmorMCRLt68eEDzHk0G9EEY3sAmrwNOOkDno2jTKCzLh67zCnzsJLRN85IFFg
         koWBR1QQ8PMKdm2WqUI9O/0TuJuRxdDxPd6cY64xGNK37ybJlu/Nw5fygGXH4lyRmmUY
         xoobE0nkBLqLgWarJDlBjnTLoqD2nnXed1JRSkqdK6/n/YafMxdTCeELDPx8Lv4ljcoi
         jMsGwc82eQiwVn9VaIFp75AY3p+BOl/8aOcUPsC9aYjyO2DsfGxDyIm55q9/LCudzUPS
         7sd4Zv6g/jtTk5l3eARlilCffi3GihluY0NlcpLoJkGLX/hrJ+mE8LNhH5ZaxWmmNmUL
         hRzw==
X-Gm-Message-State: AOJu0YxSvKN9UAc+o9Tv+kStSOxiHw9m4MmtEXFzYTkweR/jsLEiwGRK
	gQBif0ZW+A1HVUh1nCxsGpRLdoneDosufyHrgsYODVevxeU8N1SpKEITNtLoteo=
X-Google-Smtp-Source: AGHT+IFCSjt586qMBuxNZypsApcZ+VC1FCZxUMqaBfFfPBMsHNMjn2msv5U3H1M4DbXITkHOuF5KTQ==
X-Received: by 2002:a05:6000:402a:b0:33a:e525:b15 with SMTP id cp42-20020a056000402a00b0033ae5250b15mr4721457wrb.19.1706546781551;
        Mon, 29 Jan 2024 08:46:21 -0800 (PST)
Received: from m1x-phil.lan ([176.187.219.39])
        by smtp.gmail.com with ESMTPSA id bh5-20020a05600005c500b0033aed46956csm3386579wrb.80.2024.01.29.08.46.20
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 29 Jan 2024 08:46:21 -0800 (PST)
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
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>
Subject: [PATCH v3 10/29] target/cris: Prefer fast cpu_env() over slower CPU QOM cast macro
Date: Mon, 29 Jan 2024 17:44:52 +0100
Message-ID: <20240129164514.73104-11-philmd@linaro.org>
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
 target/cris/cpu.c       | 10 +++-------
 target/cris/gdbstub.c   |  9 +++------
 target/cris/helper.c    | 12 ++++--------
 target/cris/translate.c |  6 ++----
 4 files changed, 12 insertions(+), 25 deletions(-)

diff --git a/target/cris/cpu.c b/target/cris/cpu.c
index 4187e0ef3c..122071f142 100644
--- a/target/cris/cpu.c
+++ b/target/cris/cpu.c
@@ -58,10 +58,9 @@ static bool cris_cpu_has_work(CPUState *cs)
 
 static void cris_cpu_reset_hold(Object *obj)
 {
-    CPUState *s = CPU(obj);
-    CRISCPU *cpu = CRIS_CPU(s);
+    CPUState *cs = CPU(obj);
     CRISCPUClass *ccc = CRIS_CPU_GET_CLASS(obj);
-    CPUCRISState *env = &cpu->env;
+    CPUCRISState *env = cpu_env(cs);
     uint32_t vr;
 
     if (ccc->parent_phases.hold) {
@@ -142,10 +141,7 @@ static void cris_cpu_set_irq(void *opaque, int irq, int level)
 
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
index b3974ba0bb..5213db820b 100644
--- a/target/cris/translate.c
+++ b/target/cris/translate.c
@@ -3006,7 +3006,6 @@ static void cris_tr_insn_start(DisasContextBase *dcbase, CPUState *cpu)
 static void cris_tr_translate_insn(DisasContextBase *dcbase, CPUState *cs)
 {
     DisasContext *dc = container_of(dcbase, DisasContext, base);
-    CPUCRISState *env = cpu_env(cs);
     unsigned int insn_len;
 
     /* Pretty disas.  */
@@ -3014,7 +3013,7 @@ static void cris_tr_translate_insn(DisasContextBase *dcbase, CPUState *cs)
 
     dc->clear_x = 1;
 
-    insn_len = dc->decoder(env, dc);
+    insn_len = dc->decoder(cpu_env(cs), dc);
     dc->ppc = dc->pc;
     dc->pc += insn_len;
     dc->base.pc_next += insn_len;
@@ -3180,8 +3179,7 @@ void gen_intermediate_code(CPUState *cs, TranslationBlock *tb, int *max_insns,
 
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


