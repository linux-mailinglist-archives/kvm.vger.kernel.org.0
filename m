Return-Path: <kvm+bounces-7363-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BCBD0840C1B
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 17:47:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E0E7E1C22B8A
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 16:47:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5374B157049;
	Mon, 29 Jan 2024 16:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="LkTxLDuU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D236915703F
	for <kvm@vger.kernel.org>; Mon, 29 Jan 2024 16:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706546827; cv=none; b=ZB+Hjk/n5NfNP/vZlVVKO/c34qdNoXDEuluA8miZbAKHLX/tylNVu7gKHb+yeBH+SI0B0lqnPdQCEGU+p9AflS6f1gWJzKq3wnByETUZYR4/+Ll8C0C8Ey8oosZQBuNVRdu+7RNLlripKOTBnJnLEJdySDkNa746KwHRiPH2gYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706546827; c=relaxed/simple;
	bh=jL7lBd6T1l69LSUD4xZ/qwK14PuM0TsEi8D+MrmhFko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rF7FDvt3WAi6wXNQfXZZg61rVs8LxBjX1JfN9+jtkqeNIHgkjTd5dIoe5qpA8LNnvOtzdQLEP4t/Cf/DeeVv+lAfQGFHpghQqKb3HTyAU6Gn7Hk5M3zhghWb3wnm8eR3Z7lryDwfCP4vQeXg4DBp4YYD2v2D4wb86g4wpVNoSzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=LkTxLDuU; arc=none smtp.client-ip=209.85.208.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-2cf595d5b4aso20167851fa.0
        for <kvm@vger.kernel.org>; Mon, 29 Jan 2024 08:47:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1706546824; x=1707151624; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ijxQ2ToounQ2YPXKuEdEzzYCdzKOr5SyszX4l6rPtX0=;
        b=LkTxLDuUbBVLiCRIUNLC5t8UiIEEZsv+yXR9ndhKEu8fWDOQsC0lcO0aGaSwQ0s3rl
         BqbAtccVFp0sNQJ1LkH4M8aM16vTgtrMjbmu2k+dEV8XIHjfqWYc5bPyhf2wv/R3B8nf
         K8ap5iM5Nz2GiSgQeLDRKHVv3/SE9Mkyqq9PYha+FCV352EEJ41MTj2KLFU4//nWLyzn
         EEP43ZkekibW0R7l8+P0RmcW860iyKTgjjB7cplzlo1hrhKY6jW45BCRTUYhREfFpaJs
         yTkuvOh9nkCTtHQYJMJQixEYrn5K4O9dQaheW/dGX+UI1j4neZE0aHTcZv3ycYOYoAgM
         IvxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706546824; x=1707151624;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ijxQ2ToounQ2YPXKuEdEzzYCdzKOr5SyszX4l6rPtX0=;
        b=b0POXAR1f1YjM5QaWAhdVhRHxjamCnE01bBbetBeYNinA1i7MnzSK3MWIFv1u2REjY
         FplBSRCCHWQtZgmalwgPATGnA1/8sbsnb/DHN/qRJuGYI2l9fwKPPmzhPI74iHJSXLX8
         iVAOOJe9AE9AFsCkqXUystsPQZbALdZ0Y7R5Yp+Clm9OTpAmqP0mfoGMm6hU6UVJXLGc
         IbutY7RHP3UjTrEalGp9l0IJ86pSfQfTM7idrNhgP2VaAU4aBA6Hvys7mV6g94aDI+P8
         vkExXbDv/+MRxw6xzxxjCY5v18CzeQZxxHPZrKUDd9YYTvt16B1y7xIJXFIChRpZR0X2
         y5Nw==
X-Gm-Message-State: AOJu0Yy/NAapMaoYaJttfxiMvaKcCSeSMoWgpPAci+eRIUOlQUzso+9h
	ueNmXX8dN1c56XXfUKkbvUw03DKiOLzD4MrwZU6lNz2A2azTZP9dlLM76mLa5R4=
X-Google-Smtp-Source: AGHT+IGXacHRaZvQM48taNZT74NjPJR9kzPP7y3LZ/4p0pddoEr1gt2fuS3L5Ce3XavmaRSix5iy+w==
X-Received: by 2002:a05:651c:151:b0:2cf:2a82:7871 with SMTP id c17-20020a05651c015100b002cf2a827871mr4062986ljd.26.1706546823949;
        Mon, 29 Jan 2024 08:47:03 -0800 (PST)
Received: from m1x-phil.lan ([176.187.219.39])
        by smtp.gmail.com with ESMTPSA id l6-20020a5d4806000000b003392ae3aee8sm8502273wrq.97.2024.01.29.08.47.02
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 29 Jan 2024 08:47:03 -0800 (PST)
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
Subject: [PATCH v3 17/29] target/microblaze: Prefer fast cpu_env() over slower CPU QOM cast macro
Date: Mon, 29 Jan 2024 17:44:59 +0100
Message-ID: <20240129164514.73104-18-philmd@linaro.org>
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
 target/microblaze/gdbstub.c   | 3 +--
 target/microblaze/helper.c    | 3 +--
 target/microblaze/translate.c | 6 ++----
 3 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/target/microblaze/gdbstub.c b/target/microblaze/gdbstub.c
index 29ac6e9c0f..98660ed950 100644
--- a/target/microblaze/gdbstub.c
+++ b/target/microblaze/gdbstub.c
@@ -113,9 +113,8 @@ int mb_cpu_gdb_read_stack_protect(CPUMBState *env, GByteArray *mem_buf, int n)
 
 int mb_cpu_gdb_write_register(CPUState *cs, uint8_t *mem_buf, int n)
 {
-    MicroBlazeCPU *cpu = MICROBLAZE_CPU(cs);
     CPUClass *cc = CPU_GET_CLASS(cs);
-    CPUMBState *env = &cpu->env;
+    CPUMBState *env = cpu_env(cs);
     uint32_t tmp;
 
     if (n > cc->gdb_num_core_regs) {
diff --git a/target/microblaze/helper.c b/target/microblaze/helper.c
index 98bdb82de8..bf955dd425 100644
--- a/target/microblaze/helper.c
+++ b/target/microblaze/helper.c
@@ -253,8 +253,7 @@ hwaddr mb_cpu_get_phys_page_attrs_debug(CPUState *cs, vaddr addr,
 
 bool mb_cpu_exec_interrupt(CPUState *cs, int interrupt_request)
 {
-    MicroBlazeCPU *cpu = MICROBLAZE_CPU(cs);
-    CPUMBState *env = &cpu->env;
+    CPUMBState *env = cpu_env(cs);
 
     if ((interrupt_request & CPU_INTERRUPT_HARD)
         && (env->msr & MSR_IE)
diff --git a/target/microblaze/translate.c b/target/microblaze/translate.c
index 49bfb4a0ea..354897c4a2 100644
--- a/target/microblaze/translate.c
+++ b/target/microblaze/translate.c
@@ -1630,7 +1630,6 @@ static void mb_tr_insn_start(DisasContextBase *dcb, CPUState *cs)
 static void mb_tr_translate_insn(DisasContextBase *dcb, CPUState *cs)
 {
     DisasContext *dc = container_of(dcb, DisasContext, base);
-    CPUMBState *env = cpu_env(cs);
     uint32_t ir;
 
     /* TODO: This should raise an exception, not terminate qemu. */
@@ -1641,7 +1640,7 @@ static void mb_tr_translate_insn(DisasContextBase *dcb, CPUState *cs)
 
     dc->tb_flags_to_set = 0;
 
-    ir = cpu_ldl_code(env, dc->base.pc_next);
+    ir = cpu_ldl_code(cpu_env(cs), dc->base.pc_next);
     if (!decode(dc, ir)) {
         trap_illegal(dc, true);
     }
@@ -1800,8 +1799,7 @@ void gen_intermediate_code(CPUState *cpu, TranslationBlock *tb, int *max_insns,
 
 void mb_cpu_dump_state(CPUState *cs, FILE *f, int flags)
 {
-    MicroBlazeCPU *cpu = MICROBLAZE_CPU(cs);
-    CPUMBState *env = &cpu->env;
+    CPUMBState *env = cpu_env(cs);
     uint32_t iflags;
     int i;
 
-- 
2.41.0


