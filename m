Return-Path: <kvm+bounces-7233-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B702F83E4AC
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 23:08:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F2FA7B24674
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 22:08:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B05025547;
	Fri, 26 Jan 2024 22:06:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="rjXig8FS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00E4B25543
	for <kvm@vger.kernel.org>; Fri, 26 Jan 2024 22:06:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706306771; cv=none; b=NeFh7m1NXbZz767T4abZtte3ZV0OOltOTgkpRuPWPuhPOUu23wr9p+EJoGu/X+kro54089Myi0xBfZkgKubThMldOi1RPM60XvRG8pHHUga0wgY5trxMP7uZ6f0VL/ocJsbizKaaxsINnHW6e/Y5e0AQS6AFpTOPpH6JSrv4tCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706306771; c=relaxed/simple;
	bh=r5VmSsD6rSN9lqHC417uI7sWZ3DrW38k+nh0OZTqcJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=omswMh9Y8A7h2HlGjqxK+oFrtvm6zEZAoFmlLQHB+DQmUDreSFnWSkxtyUbV4oa4MEgD1zjShLTTzeCy9eIqq24nRDA8LrlfZEzy+cQ253r6On4nU+5FdCuU6zPnNqjxX6uKG9xz3kx83O3G4sMtnbzxQYeJ1bRpGoJA7uBuin0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=rjXig8FS; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-40e8fec0968so15518635e9.1
        for <kvm@vger.kernel.org>; Fri, 26 Jan 2024 14:06:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1706306768; x=1706911568; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zizmHElFAIvWicITNbOdvMqLrgaV6VK2Xkw5hMOGCk4=;
        b=rjXig8FSgG3bIEqu0nmmWa5LK3tX7HLjkn/iZJx/MShUlCfgDEHRJjbZYHovNWQG3R
         SsD8A3+NEDSK4RIXmE+8LyJiJiYnSuJU++oHrxMXIDz6gOfQMUoXnWofR977WrD8KX88
         uTG08ypCkeHGEtNH5Ww57zLrH3Iw0S3AveJk9bVbk2tY8UZ/f4azplyut48qPVrYECcn
         DFWiSdZsZyTiPRsnHzIuPBkfLR+QPRGpLdGY2AiK9qMGr9eRXv90IYtSOlMf0bfgg57N
         czkzjth4ByS72EwB9c7GVf6QOc4ylUFz1b3UI2EGDmjs19YQsS40mgd3Ds0BG0fI78SO
         YdRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706306768; x=1706911568;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zizmHElFAIvWicITNbOdvMqLrgaV6VK2Xkw5hMOGCk4=;
        b=D7Idxw/MwK8bc5kXb9PncbgVkVrW4w+UR+pJQVs9LOGc5Fe7mwVHjngleThaM8lUD2
         7sWSQ19UQrBtlE0wVsyZIPy1RWyGJV2ISg1jpOHSg9OmENfmt1g2Hk1hAgXRuGbXuHdq
         7psfJsHelMKdSGGFwUrdbSTn4WjINlf4hZot4xryw13PD8e0Tiv2tvR2NIu+t4aeqN8P
         29Nn2slI2uX1YjrUTROaH/AkB2BkmyaE/h1EoEu9Ej28zBMCFTApVma672wv/oNta3Te
         1sijbTQGP7cdPq7rs8QSq4qV8jc8oyuwtRomp0ff1J6ImGhxhor8pUcb4bM8OgyOgVGv
         BalQ==
X-Gm-Message-State: AOJu0YxrkXHqT/b73dpnkkxtqujd0hU35KQYPzV3t2tzME7FP+gWCaag
	zr/3BK2QTXnxhAoorayXCHEUNxe6bL10uLE7D7DQPe3TOr2uJwPCSM0WzEWMGPE=
X-Google-Smtp-Source: AGHT+IENT++zTxGze1ZxY54yZNYP0exfgleA9HYNxNr2GozYuCeOr5aCqtrcjo6kkJDEzytT4sLd9g==
X-Received: by 2002:a05:600c:a082:b0:40e:e703:b1ec with SMTP id jh2-20020a05600ca08200b0040ee703b1ecmr307070wmb.24.1706306768281;
        Fri, 26 Jan 2024 14:06:08 -0800 (PST)
Received: from m1x-phil.lan ([176.176.142.39])
        by smtp.gmail.com with ESMTPSA id u16-20020a05600c19d000b0040e4733aecbsm2912892wmq.15.2024.01.26.14.06.06
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 26 Jan 2024 14:06:07 -0800 (PST)
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
	David Hildenbrand <david@redhat.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: [PATCH v2 19/23] target/s390x: Prefer fast cpu_env() over slower CPU QOM cast macro
Date: Fri, 26 Jan 2024 23:04:01 +0100
Message-ID: <20240126220407.95022-20-philmd@linaro.org>
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
 target/s390x/cpu-dump.c        |  3 +--
 target/s390x/gdbstub.c         |  6 ++----
 target/s390x/helper.c          |  3 +--
 target/s390x/kvm/kvm.c         |  6 ++----
 target/s390x/tcg/excp_helper.c | 11 +++--------
 target/s390x/tcg/translate.c   |  3 +--
 6 files changed, 10 insertions(+), 22 deletions(-)

diff --git a/target/s390x/cpu-dump.c b/target/s390x/cpu-dump.c
index ffa9e94d84..69cc9f7746 100644
--- a/target/s390x/cpu-dump.c
+++ b/target/s390x/cpu-dump.c
@@ -27,8 +27,7 @@
 
 void s390_cpu_dump_state(CPUState *cs, FILE *f, int flags)
 {
-    S390CPU *cpu = S390_CPU(cs);
-    CPUS390XState *env = &cpu->env;
+    CPUS390XState *env = cpu_env(cs);
     int i;
 
     qemu_fprintf(f, "PSW=mask %016" PRIx64 " addr %016" PRIx64,
diff --git a/target/s390x/gdbstub.c b/target/s390x/gdbstub.c
index 6fbfd41bc8..f02fa316e5 100644
--- a/target/s390x/gdbstub.c
+++ b/target/s390x/gdbstub.c
@@ -30,8 +30,7 @@
 
 int s390_cpu_gdb_read_register(CPUState *cs, GByteArray *mem_buf, int n)
 {
-    S390CPU *cpu = S390_CPU(cs);
-    CPUS390XState *env = &cpu->env;
+    CPUS390XState *env = cpu_env(cs);
 
     switch (n) {
     case S390_PSWM_REGNUM:
@@ -46,8 +45,7 @@ int s390_cpu_gdb_read_register(CPUState *cs, GByteArray *mem_buf, int n)
 
 int s390_cpu_gdb_write_register(CPUState *cs, uint8_t *mem_buf, int n)
 {
-    S390CPU *cpu = S390_CPU(cs);
-    CPUS390XState *env = &cpu->env;
+    CPUS390XState *env = cpu_env(cs);
     target_ulong tmpl = ldtul_p(mem_buf);
 
     switch (n) {
diff --git a/target/s390x/helper.c b/target/s390x/helper.c
index d76c06381b..00d5d403f3 100644
--- a/target/s390x/helper.c
+++ b/target/s390x/helper.c
@@ -139,8 +139,7 @@ void do_restart_interrupt(CPUS390XState *env)
 void s390_cpu_recompute_watchpoints(CPUState *cs)
 {
     const int wp_flags = BP_CPU | BP_MEM_WRITE | BP_STOP_BEFORE_ACCESS;
-    S390CPU *cpu = S390_CPU(cs);
-    CPUS390XState *env = &cpu->env;
+    CPUS390XState *env = cpu_env(cs);
 
     /* We are called when the watchpoints have changed. First
        remove them all.  */
diff --git a/target/s390x/kvm/kvm.c b/target/s390x/kvm/kvm.c
index 888d6c1a1c..4ce809c5d4 100644
--- a/target/s390x/kvm/kvm.c
+++ b/target/s390x/kvm/kvm.c
@@ -474,8 +474,7 @@ static int can_sync_regs(CPUState *cs, int regs)
 
 int kvm_arch_put_registers(CPUState *cs, int level)
 {
-    S390CPU *cpu = S390_CPU(cs);
-    CPUS390XState *env = &cpu->env;
+    CPUS390XState *env = cpu_env(cs);
     struct kvm_fpu fpu = {};
     int r;
     int i;
@@ -601,8 +600,7 @@ int kvm_arch_put_registers(CPUState *cs, int level)
 
 int kvm_arch_get_registers(CPUState *cs)
 {
-    S390CPU *cpu = S390_CPU(cs);
-    CPUS390XState *env = &cpu->env;
+    CPUS390XState *env = cpu_env(cs);
     struct kvm_fpu fpu;
     int i, r;
 
diff --git a/target/s390x/tcg/excp_helper.c b/target/s390x/tcg/excp_helper.c
index b875bf14e5..f1c33f7967 100644
--- a/target/s390x/tcg/excp_helper.c
+++ b/target/s390x/tcg/excp_helper.c
@@ -90,10 +90,7 @@ void HELPER(data_exception)(CPUS390XState *env, uint32_t dxc)
 static G_NORETURN
 void do_unaligned_access(CPUState *cs, uintptr_t retaddr)
 {
-    S390CPU *cpu = S390_CPU(cs);
-    CPUS390XState *env = &cpu->env;
-
-    tcg_s390_program_interrupt(env, PGM_SPECIFICATION, retaddr);
+    tcg_s390_program_interrupt(cpu_env(cs), PGM_SPECIFICATION, retaddr);
 }
 
 #if defined(CONFIG_USER_ONLY)
@@ -146,8 +143,7 @@ bool s390_cpu_tlb_fill(CPUState *cs, vaddr address, int size,
                        MMUAccessType access_type, int mmu_idx,
                        bool probe, uintptr_t retaddr)
 {
-    S390CPU *cpu = S390_CPU(cs);
-    CPUS390XState *env = &cpu->env;
+    CPUS390XState *env = cpu_env(cs);
     target_ulong vaddr, raddr;
     uint64_t asc, tec;
     int prot, excp;
@@ -600,8 +596,7 @@ bool s390_cpu_exec_interrupt(CPUState *cs, int interrupt_request)
 
 void s390x_cpu_debug_excp_handler(CPUState *cs)
 {
-    S390CPU *cpu = S390_CPU(cs);
-    CPUS390XState *env = &cpu->env;
+    CPUS390XState *env = cpu_env(cs);
     CPUWatchpoint *wp_hit = cs->watchpoint_hit;
 
     if (wp_hit && wp_hit->flags & BP_CPU) {
diff --git a/target/s390x/tcg/translate.c b/target/s390x/tcg/translate.c
index 8df00b7df9..9995689bc8 100644
--- a/target/s390x/tcg/translate.c
+++ b/target/s390x/tcg/translate.c
@@ -6558,8 +6558,7 @@ void s390x_restore_state_to_opc(CPUState *cs,
                                 const TranslationBlock *tb,
                                 const uint64_t *data)
 {
-    S390CPU *cpu = S390_CPU(cs);
-    CPUS390XState *env = &cpu->env;
+    CPUS390XState *env = cpu_env(cs);
     int cc_op = data[1];
 
     env->psw.addr = data[0];
-- 
2.41.0


