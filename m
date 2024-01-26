Return-Path: <kvm+bounces-7228-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7826E83E49D
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 23:07:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9D7E21C2253D
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 22:07:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE4255821E;
	Fri, 26 Jan 2024 22:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Gq/oVmcO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5817B58202
	for <kvm@vger.kernel.org>; Fri, 26 Jan 2024 22:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706306739; cv=none; b=oybMQa2PPy9ppJNFMtvU5HZHCEeTzDsoPj4JcGjZlFKJtFBRiSsslZEIHXaddXuftnOxnn8Fq3h4EeIAOG5pJFR5HkiB0QEFJ4WNCn+xIRWJ2kPY67c7kurR2i1h6BgkkNqPUPLvCoh+FxM8UH2LD6IQLxeciqwjBTbJQ8NKA4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706306739; c=relaxed/simple;
	bh=zsxm6D08RzFi/sNRJRtqTBn22ydSm4KztL/MqeFv7Ng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XxXyKeY3Cfw7hDMmK77KUzYibw2OFgou6pW086VJ5mSlrxwa2l/0PPTVuz6t4Xaq4rXisAHbGA9x+EbIFbP/wjHqIhMWZQ8+ZGRaPjw83IdsvlhHF6hWqtILV9wVIa9hUMW89Tm6nN+RyFoOIR8tda5veS9OsmK2t9SJiF42zI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Gq/oVmcO; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-40ee6ff0c7dso14514285e9.2
        for <kvm@vger.kernel.org>; Fri, 26 Jan 2024 14:05:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1706306735; x=1706911535; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FFJLEX8dK90+jos80xXDDodOgI2wmwmhf0FUxCQuinw=;
        b=Gq/oVmcOuHNz+bwKGlLH+ZdvhoBkbi/UQWogQ5JUEvHLNhN0VBKrFNhjXr8ElG7+j0
         N6W+t8b80fzuDlHc/57hdpIaauHLJNHzIDqYmz3T3s1mjeo7vrYVCXQyu1oXSvCBoxm+
         YqqxGdnextPnPTUlSuhTRZrdYXi2Jk34UQVRq6iDWje7AWtmohAdtg5jz2D/MHP6InIZ
         fnl5VExbBpdUCVIZnXr3J1x/ePCg+3Vwl8Gzw+ECNrmbgLycf+YcFCr4rsFN34sCQdog
         TlOraQbQGTCy/Ow24lAaFmDlCzoOskuZVdZSCGCO5KmKat1YrIDh3XgHZhxM7ujA3BBB
         6HMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706306735; x=1706911535;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FFJLEX8dK90+jos80xXDDodOgI2wmwmhf0FUxCQuinw=;
        b=AzgxtoyilT1gFD+nnaUyCPmR1MNdXUQGncYI5o3EPLDR8p7ky+ru5ix2MqvN2KAMPY
         9CSU86VTeNwLUPzfO3TLsAXhwxGci+qst+6eC7M0yO9tqu0T1HvNtTHmJYzTBNTjRVU2
         oS4IWpkj8TCo8PHDIXjhUKTGMB0CBXaIrxLquG/CBf6rBPowwm8jiKYB3Hn1x4xTisoa
         8q75FgO7YlNO2akFKfSwA1HofTLyFKZ6tuncEg6/3gjFPoo23zVF9aZMxnopHjE2mjez
         9arLfBWpHcAJRi3E2NIzoWBTOJwvfd7y8VagyvbVL81QIBN7149BWOqLhmKyPqq9Dcoa
         T0Qw==
X-Gm-Message-State: AOJu0YzvPBJYpUmViYrUd9cVQnQF/4U63WgJ8WQ50L6W9fYd9bRL1TSz
	CQa3opgk1OiqTovkgkDkQdWU4AKSYRq8oXWjM76SFmiYvQuRBmuhGWCXpm49srEizsIBPrCwtpY
	z
X-Google-Smtp-Source: AGHT+IERKWPKqMlUDr8TgLLCEk48utrgqZ8fZ+srVdZ0DPEqZSZhTX1J0vsKsxaQU/Y2UaXBmJlN2g==
X-Received: by 2002:a05:600c:2246:b0:40e:e944:154a with SMTP id a6-20020a05600c224600b0040ee944154amr243867wmm.198.1706306735629;
        Fri, 26 Jan 2024 14:05:35 -0800 (PST)
Received: from m1x-phil.lan ([176.176.142.39])
        by smtp.gmail.com with ESMTPSA id s6-20020a1709060c0600b00a2a37f63216sm1056778ejf.171.2024.01.26.14.05.33
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 26 Jan 2024 14:05:35 -0800 (PST)
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
	Chris Wulff <crwulff@gmail.com>,
	Marek Vasut <marex@denx.de>
Subject: [PATCH v2 14/23] target/nios2: Prefer fast cpu_env() over slower CPU QOM cast macro
Date: Fri, 26 Jan 2024 23:03:56 +0100
Message-ID: <20240126220407.95022-15-philmd@linaro.org>
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
 target/nios2/cpu.c        | 15 +++------------
 target/nios2/helper.c     |  3 +--
 target/nios2/nios2-semi.c |  6 ++----
 3 files changed, 6 insertions(+), 18 deletions(-)

diff --git a/target/nios2/cpu.c b/target/nios2/cpu.c
index a27732bf2b..a2eaf35c1a 100644
--- a/target/nios2/cpu.c
+++ b/target/nios2/cpu.c
@@ -28,28 +28,19 @@
 
 static void nios2_cpu_set_pc(CPUState *cs, vaddr value)
 {
-    Nios2CPU *cpu = NIOS2_CPU(cs);
-    CPUNios2State *env = &cpu->env;
-
-    env->pc = value;
+    cpu_env(cs)->pc = value;
 }
 
 static vaddr nios2_cpu_get_pc(CPUState *cs)
 {
-    Nios2CPU *cpu = NIOS2_CPU(cs);
-    CPUNios2State *env = &cpu->env;
-
-    return env->pc;
+    return cpu_env(cs)->pc;
 }
 
 static void nios2_restore_state_to_opc(CPUState *cs,
                                        const TranslationBlock *tb,
                                        const uint64_t *data)
 {
-    Nios2CPU *cpu = NIOS2_CPU(cs);
-    CPUNios2State *env = &cpu->env;
-
-    env->pc = data[0];
+    cpu_env(cs)->pc = data[0];
 }
 
 static bool nios2_cpu_has_work(CPUState *cs)
diff --git a/target/nios2/helper.c b/target/nios2/helper.c
index bb3b09e5a7..ac57121afc 100644
--- a/target/nios2/helper.c
+++ b/target/nios2/helper.c
@@ -287,8 +287,7 @@ void nios2_cpu_do_unaligned_access(CPUState *cs, vaddr addr,
                                    MMUAccessType access_type,
                                    int mmu_idx, uintptr_t retaddr)
 {
-    Nios2CPU *cpu = NIOS2_CPU(cs);
-    CPUNios2State *env = &cpu->env;
+    CPUNios2State *env = cpu_env(cs);
 
     env->ctrl[CR_BADADDR] = addr;
     cs->exception_index = EXCP_UNALIGN;
diff --git a/target/nios2/nios2-semi.c b/target/nios2/nios2-semi.c
index 0b84fcb6b6..420702e293 100644
--- a/target/nios2/nios2-semi.c
+++ b/target/nios2/nios2-semi.c
@@ -75,8 +75,7 @@ static int host_to_gdb_errno(int err)
 
 static void nios2_semi_u32_cb(CPUState *cs, uint64_t ret, int err)
 {
-    Nios2CPU *cpu = NIOS2_CPU(cs);
-    CPUNios2State *env = &cpu->env;
+    CPUNios2State *env = cpu_env(cs);
     target_ulong args = env->regs[R_ARG1];
 
     if (put_user_u32(ret, args) ||
@@ -93,8 +92,7 @@ static void nios2_semi_u32_cb(CPUState *cs, uint64_t ret, int err)
 
 static void nios2_semi_u64_cb(CPUState *cs, uint64_t ret, int err)
 {
-    Nios2CPU *cpu = NIOS2_CPU(cs);
-    CPUNios2State *env = &cpu->env;
+    CPUNios2State *env = cpu_env(cs);
     target_ulong args = env->regs[R_ARG1];
 
     if (put_user_u32(ret >> 32, args) ||
-- 
2.41.0


