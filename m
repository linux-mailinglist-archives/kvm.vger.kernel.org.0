Return-Path: <kvm+bounces-7229-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D549083E49F
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 23:08:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 65EF2B2281C
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 22:08:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9879259B48;
	Fri, 26 Jan 2024 22:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="uG/vXafn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 209CF59154
	for <kvm@vger.kernel.org>; Fri, 26 Jan 2024 22:05:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706306744; cv=none; b=sxHGN6CbbihkSeT6nwj69cukylIbDaJ9PvuKge1fVjjru2ONomwSr8dpoxq4zE+ie96QNnPMnBHiCTh3CAZk/NGQZsiJvV2Wd1+IMOkv3PAkavUIO927OPdHZ/j3pHXotmV5DEBTxf4i9PSbBo0gIZ5uVhMsgo00Yd9N8Th7ZMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706306744; c=relaxed/simple;
	bh=KfZxTbq4TUsVnwFfX7vBpS9SP3pA4dvm2TFzNy4wksE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YKEqtErTc+RKzxrlp0TOo9pkDkKTcp5IE7QEww9pq0IzQtQidpvm6PUlyia33QigUQtPdI6hOs2a6slJGIshJm8EXLylPAs5xs9pKBU7X52Ctp/yDEYOrUL0ICgLIpoVaxDPmPC+0ImXXP2sZrPJMIJ76HGJEVBk0o5zwwxg0z4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=uG/vXafn; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-a2a17f3217aso126039766b.2
        for <kvm@vger.kernel.org>; Fri, 26 Jan 2024 14:05:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1706306741; x=1706911541; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wkOEO96VeYz15t7MFpkcGQawVspurMDTqf/y8c7vhEo=;
        b=uG/vXafnT7D3RE2eo7nC6p2C9/oVB+hMO0/fWtmwn8ydQpwsovi7Tg+tw/S/iQ/Y3B
         RSW+2S4KfajTBlJKfikJa2fJe42R3gCL0tDsvfJru06yPcKFioKMlax5J/cjORIraKoc
         wCpgRdUREs9cqXjaV9sfIUUJ9oZN592BpbCLOWmEK3pcy8W/e8hkD0ac3UuzURLPSl41
         6tFEtyI+0aIkItBZvQcwpbPGm9u4o53vsgTrgQ921cPL0OAPLhc0htjX0QmoGCjDvqj5
         4wgkRHNImk2P4JIjXwNMhZ+uy+KU/SWSYaZfGMk9QHxnOmsLpqG3oFGz6f1S11GF05OW
         47Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706306741; x=1706911541;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wkOEO96VeYz15t7MFpkcGQawVspurMDTqf/y8c7vhEo=;
        b=MPE0mqExEiEqnDBTVfh4LFTFJlpawkueaRrZ6ufYyDH6CnA//xR8iXWuyhsTSZZ27s
         nxKfXYb7qGqyQyDTGrcPk2l8Sh8zfCD4MH0ecionEmUXYEYD2j/v81kufwdn0LUanF5l
         khIIE+xBFt4+aq/5UvZKqKqBCPEiE/FgUtDoPfRM32UlGlliXd2oOxByj53Tx5HdTzCU
         KaB694o8LqmoGBpLtiZWCuSoLBNGOu+0PdF6sa6PtbOJiSMRnRAF2wlDmmm1Ad591ie8
         ful2wA/dPhBarJvyQ+S3ChaLcJBFIhRRc7BjEh2dfRO68Gp+8i37HknbvIgfTsSFtD5Z
         N9qA==
X-Gm-Message-State: AOJu0Yw23cRHMW6fnPSZDqj5NKWZUSbDT9S4FOD0sp8keNCLMuBbb/3o
	b/6VeDcnxebZ3DoNXAee3izxcy+Y+SHUEdCaorcejRho54OJ+VgqvUkdKx154uw=
X-Google-Smtp-Source: AGHT+IFULGfyWx+16roF4bjomerz5x/6lnX7Q84paIKcDaIdxN0Nl5Y6z6BBmJj/+hQmNl+T2yoBcA==
X-Received: by 2002:a17:906:fc09:b0:a34:d426:1beb with SMTP id ov9-20020a170906fc0900b00a34d4261bebmr335803ejb.54.1706306741394;
        Fri, 26 Jan 2024 14:05:41 -0800 (PST)
Received: from m1x-phil.lan ([176.176.142.39])
        by smtp.gmail.com with ESMTPSA id u12-20020a170906408c00b00a3185d260e5sm1039705ejj.151.2024.01.26.14.05.39
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 26 Jan 2024 14:05:41 -0800 (PST)
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
	Stafford Horne <shorne@gmail.com>
Subject: [PATCH v2 15/23] target/openrisc: Prefer fast cpu_env() over slower CPU QOM cast macro
Date: Fri, 26 Jan 2024 23:03:57 +0100
Message-ID: <20240126220407.95022-16-philmd@linaro.org>
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
 target/openrisc/gdbstub.c   | 3 +--
 target/openrisc/interrupt.c | 6 ++----
 target/openrisc/translate.c | 3 +--
 3 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/target/openrisc/gdbstub.c b/target/openrisc/gdbstub.c
index d1074a0581..0cce8d4f92 100644
--- a/target/openrisc/gdbstub.c
+++ b/target/openrisc/gdbstub.c
@@ -23,8 +23,7 @@
 
 int openrisc_cpu_gdb_read_register(CPUState *cs, GByteArray *mem_buf, int n)
 {
-    OpenRISCCPU *cpu = OPENRISC_CPU(cs);
-    CPUOpenRISCState *env = &cpu->env;
+    CPUOpenRISCState *env = cpu_env(cs);
 
     if (n < 32) {
         return gdb_get_reg32(mem_buf, cpu_get_gpr(env, n));
diff --git a/target/openrisc/interrupt.c b/target/openrisc/interrupt.c
index d4fdb8ce8e..b3b5b40577 100644
--- a/target/openrisc/interrupt.c
+++ b/target/openrisc/interrupt.c
@@ -29,8 +29,7 @@
 
 void openrisc_cpu_do_interrupt(CPUState *cs)
 {
-    OpenRISCCPU *cpu = OPENRISC_CPU(cs);
-    CPUOpenRISCState *env = &cpu->env;
+    CPUOpenRISCState *env = cpu_env(cs);
     int exception = cs->exception_index;
 
     env->epcr = env->pc;
@@ -105,8 +104,7 @@ void openrisc_cpu_do_interrupt(CPUState *cs)
 
 bool openrisc_cpu_exec_interrupt(CPUState *cs, int interrupt_request)
 {
-    OpenRISCCPU *cpu = OPENRISC_CPU(cs);
-    CPUOpenRISCState *env = &cpu->env;
+    CPUOpenRISCState *env = cpu_env(cs);
     int idx = -1;
 
     if ((interrupt_request & CPU_INTERRUPT_HARD) && (env->sr & SR_IEE)) {
diff --git a/target/openrisc/translate.c b/target/openrisc/translate.c
index ecff4412b7..aff53c0065 100644
--- a/target/openrisc/translate.c
+++ b/target/openrisc/translate.c
@@ -1668,8 +1668,7 @@ void gen_intermediate_code(CPUState *cs, TranslationBlock *tb, int *max_insns,
 
 void openrisc_cpu_dump_state(CPUState *cs, FILE *f, int flags)
 {
-    OpenRISCCPU *cpu = OPENRISC_CPU(cs);
-    CPUOpenRISCState *env = &cpu->env;
+    CPUOpenRISCState *env = cpu_env(cs);
     int i;
 
     qemu_fprintf(f, "PC=%08x\n", env->pc);
-- 
2.41.0


