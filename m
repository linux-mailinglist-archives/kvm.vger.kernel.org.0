Return-Path: <kvm+bounces-7357-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E8D2840C07
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 17:46:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 160B22860FC
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 16:46:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F2DE15699C;
	Mon, 29 Jan 2024 16:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="tVx4Fyg3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 154C1155A5F
	for <kvm@vger.kernel.org>; Mon, 29 Jan 2024 16:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706546790; cv=none; b=c3ASeyc8R/1as97kNT40i3nq4b3M8TsXrSbIXDn0pL1EbirC+nRBGnOQBoS75w1xnpLngtvj4H936irSRkms/sweTDnwLHtJpgLSZNaoBE9mQXz9q/SOWFNY04MZyy7Xe+Mj421frDtjTyMuOZEi9vlCnuoxI8b8sezjXCaQ1U8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706546790; c=relaxed/simple;
	bh=lb+gNLT4xcsAnzEzsOBc13grxVpyoH885cq29VL196k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VyjhGYbtODG+Gkrjl2Ucjrx6yEAsE2quC93lLBpQMqCt1f/8bXe7ZlUc9GidCqr9O7yKyqwGiJ/17YnGdDuOW6VLiXPg0olP5+UQiqBewqEw717DVHb00FhmvuARv4j2P/5WzJx5oU+Ju00B2aGODulFN3mrEYZ850kewcFXnKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=tVx4Fyg3; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-40ef6bbb61fso10150485e9.1
        for <kvm@vger.kernel.org>; Mon, 29 Jan 2024 08:46:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1706546787; x=1707151587; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wpEyww5ql+HDyU+E74XNxXzD2LWLWxnIJJxDrC1dnKo=;
        b=tVx4Fyg3tMqr4ihE/rzD2iGCZR+9pG8T18nw/e8EHOZPg/ZSeXDz2b0FPNaEX5JjB0
         Et9RlZ/64KemdoFSHfMa9s6kxo/omFGKluHFj34Y84U2hhFD7Rl4uY7r1pvavyInFpWt
         lmvC21uSSCCEAbMQoFO0OeMu7aPct6Iny5FKM35e1g1fA88o+T6hC8JT6tuk16et+f3f
         PJIn5zoEsPphyvzSpXKILPaEzPRVrQnkNdf/Oybg2b4w9GyQuxqvi/qplqDPpMFm+ZCE
         GfJfLbl5njiiamXBAxgEdjPor2fVZjUgdOBvJZlLtKPfUUn6o7zoSEGmp6O88p7pve8r
         vtYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706546787; x=1707151587;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wpEyww5ql+HDyU+E74XNxXzD2LWLWxnIJJxDrC1dnKo=;
        b=q/aFMmt+SyGsPWQ5BuaZg+fFJYXAuijJyFDhj7HdMMN2H94Kou2xOW9trC2h5nkcC7
         FqKTNu206FBjqFvprw2hd2BxJws0cziil0D7S0eUvGewhKHNC9CmbDTdUYHeQTY7vMXm
         YK8ivrFQxjmT9lmfX7hJB9DECeKhp78mNX1bwjX/LdegFls/j3Re3ZVR1lQre5x+fN27
         xQWDE6ajXMo+nnwsTbJhjhuKiA40TX/UhblgU0lm8r4biRQ4kKyY3cKRmE8bxpGEmYCX
         lDUO3r89+5YI58EV7ctHtrTob8RJ97Vl4I+ZGCo+xG6bhjbzDonx02MdJpHZBlNriGn7
         HmOQ==
X-Gm-Message-State: AOJu0Yz++bXlVwe8he5rP4e7DfkslQMDqQbJ7vU9MGPVW9s8hNsiFTV2
	4lGioENDDpCfCqsuVt7kSCX4xQIcbJddK/0KeSZ/w4ygtDtsLYDIBbkYIeYhsAU=
X-Google-Smtp-Source: AGHT+IE/pmLN7aJB50sjYT7HNVrs0xGJu0OS4F2RLGx8AfT4RgKOArlTbN0yv5fwQwzrh+8k2SbzhQ==
X-Received: by 2002:adf:fa51:0:b0:33a:eae2:11a4 with SMTP id y17-20020adffa51000000b0033aeae211a4mr2806032wrr.26.1706546787414;
        Mon, 29 Jan 2024 08:46:27 -0800 (PST)
Received: from m1x-phil.lan ([176.187.219.39])
        by smtp.gmail.com with ESMTPSA id p7-20020a5d4587000000b0033af670213dsm258204wrq.110.2024.01.29.08.46.25
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 29 Jan 2024 08:46:27 -0800 (PST)
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
	Brian Cain <bcain@quicinc.com>
Subject: [PATCH v3 11/29] target/hexagon: Prefer fast cpu_env() over slower CPU QOM cast macro
Date: Mon, 29 Jan 2024 17:44:53 +0100
Message-ID: <20240129164514.73104-12-philmd@linaro.org>
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

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/hexagon/cpu.c     | 25 ++++++-------------------
 target/hexagon/gdbstub.c |  6 ++----
 2 files changed, 8 insertions(+), 23 deletions(-)

diff --git a/target/hexagon/cpu.c b/target/hexagon/cpu.c
index 085d6c0115..17a22aa7a5 100644
--- a/target/hexagon/cpu.c
+++ b/target/hexagon/cpu.c
@@ -236,10 +236,7 @@ static void hexagon_dump(CPUHexagonState *env, FILE *f, int flags)
 
 static void hexagon_dump_state(CPUState *cs, FILE *f, int flags)
 {
-    HexagonCPU *cpu = HEXAGON_CPU(cs);
-    CPUHexagonState *env = &cpu->env;
-
-    hexagon_dump(env, f, flags);
+    hexagon_dump(cpu_env(cs), f, flags);
 }
 
 void hexagon_debug(CPUHexagonState *env)
@@ -249,25 +246,19 @@ void hexagon_debug(CPUHexagonState *env)
 
 static void hexagon_cpu_set_pc(CPUState *cs, vaddr value)
 {
-    HexagonCPU *cpu = HEXAGON_CPU(cs);
-    CPUHexagonState *env = &cpu->env;
-    env->gpr[HEX_REG_PC] = value;
+    cpu_env(cs)->gpr[HEX_REG_PC] = value;
 }
 
 static vaddr hexagon_cpu_get_pc(CPUState *cs)
 {
-    HexagonCPU *cpu = HEXAGON_CPU(cs);
-    CPUHexagonState *env = &cpu->env;
-    return env->gpr[HEX_REG_PC];
+    return cpu_env(cs)->gpr[HEX_REG_PC];
 }
 
 static void hexagon_cpu_synchronize_from_tb(CPUState *cs,
                                             const TranslationBlock *tb)
 {
-    HexagonCPU *cpu = HEXAGON_CPU(cs);
-    CPUHexagonState *env = &cpu->env;
     tcg_debug_assert(!(cs->tcg_cflags & CF_PCREL));
-    env->gpr[HEX_REG_PC] = tb->pc;
+    cpu_env(cs)->gpr[HEX_REG_PC] = tb->pc;
 }
 
 static bool hexagon_cpu_has_work(CPUState *cs)
@@ -279,18 +270,14 @@ static void hexagon_restore_state_to_opc(CPUState *cs,
                                          const TranslationBlock *tb,
                                          const uint64_t *data)
 {
-    HexagonCPU *cpu = HEXAGON_CPU(cs);
-    CPUHexagonState *env = &cpu->env;
-
-    env->gpr[HEX_REG_PC] = data[0];
+    cpu_env(cs)->gpr[HEX_REG_PC] = data[0];
 }
 
 static void hexagon_cpu_reset_hold(Object *obj)
 {
     CPUState *cs = CPU(obj);
-    HexagonCPU *cpu = HEXAGON_CPU(cs);
     HexagonCPUClass *mcc = HEXAGON_CPU_GET_CLASS(obj);
-    CPUHexagonState *env = &cpu->env;
+    CPUHexagonState *env = cpu_env(cs);
 
     if (mcc->parent_phases.hold) {
         mcc->parent_phases.hold(obj);
diff --git a/target/hexagon/gdbstub.c b/target/hexagon/gdbstub.c
index 54d37e006e..f773f8ea4f 100644
--- a/target/hexagon/gdbstub.c
+++ b/target/hexagon/gdbstub.c
@@ -22,8 +22,7 @@
 
 int hexagon_gdb_read_register(CPUState *cs, GByteArray *mem_buf, int n)
 {
-    HexagonCPU *cpu = HEXAGON_CPU(cs);
-    CPUHexagonState *env = &cpu->env;
+    CPUHexagonState *env = cpu_env(cs);
 
     if (n == HEX_REG_P3_0_ALIASED) {
         uint32_t p3_0 = 0;
@@ -42,8 +41,7 @@ int hexagon_gdb_read_register(CPUState *cs, GByteArray *mem_buf, int n)
 
 int hexagon_gdb_write_register(CPUState *cs, uint8_t *mem_buf, int n)
 {
-    HexagonCPU *cpu = HEXAGON_CPU(cs);
-    CPUHexagonState *env = &cpu->env;
+    CPUHexagonState *env = cpu_env(cs);
 
     if (n == HEX_REG_P3_0_ALIASED) {
         uint32_t p3_0 = ldtul_p(mem_buf);
-- 
2.41.0


