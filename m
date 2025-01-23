Return-Path: <kvm+bounces-36445-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 82E18A1AD6C
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 00:45:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C27EB1667E7
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 23:45:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 206391D63F8;
	Thu, 23 Jan 2025 23:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="oAo3pyP6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CC741D54FA
	for <kvm@vger.kernel.org>; Thu, 23 Jan 2025 23:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737675899; cv=none; b=thstzfDVd/qPnB0iNBTwoLyQRxUAE8WpOSS/Rd1W6fUyR66Coup8X4EoiarfjFeWOn4EtiDN6kLeJgtuGUyyKsf+YHnHPCyqR+fz0pfBMAmkkQreGxCJafZiJJBwEMqn3m8SdChxCJA+MABfoODe6PYLsv1y2s6XMFs6Eo4SDD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737675899; c=relaxed/simple;
	bh=OjuBiXcltQCC4UOcRjFrzfcpX0XT12BM8UEVdW6DJfw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RPANekj/LpGl0cA/DJwC8ENK5u+wOO6zKjd+X014UDaYLLgFmVVSoqYjwZIbkigkXkS5Lzu4iXEKu0G9T7n/LAoQdYJqCHX8/8MWoVLpzOTGOgkVRL0oSlX+sSojonm8ZycPVlSffFl5j/sVdl7NM7B2vXAeG2Vqgz2F5pmYArc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=oAo3pyP6; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-43621d27adeso10192155e9.2
        for <kvm@vger.kernel.org>; Thu, 23 Jan 2025 15:44:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1737675895; x=1738280695; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zgM0qO1a7TmnAaVr92PdlZQNV8dbDE9Lo8CXyhKvg/4=;
        b=oAo3pyP6IrJYhI4s7pMbGHX6iMegLiElESYNYsxmqb03G8zGRwJxoXVm3lr7tMwA1Y
         DgsgHVkkhtwUl+7hbSoBzzOKhMjTqF9CJz4DKh3pdmgw7mlxQXR+nWD4AbQX9oiM2bye
         wXzxyShVXIw/VEtcWFNduoRP6S1p2122utf22qYn4kSTxThkNrKGwHF6WN70KKMvRNfX
         M/d+DZ6HVg/JWH4XzYXd6N3z4T7vUkuJNczEW3vZ3yaozhRTtfpVK/12JsdMkex2N49l
         XDCCSsUKng82mJ4Ztt3olXjqLaWCHaF3zD3SELoGcvW3CK3N1p4KUHLsHRlbP9bv325Y
         9d5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737675895; x=1738280695;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zgM0qO1a7TmnAaVr92PdlZQNV8dbDE9Lo8CXyhKvg/4=;
        b=IWquMvOOTszn5E5orBtL5iiGQ5b4xglfoSO4QwqvjPro+m9SQRZB47nk4PYKeTSVAX
         vXFgBhL7Ih8J9YZxpuqev0gYu1kmj5dxo/AxGEvXnifrmt8GwawO6464rhYi/jUh9d03
         OKQcWkJDYZ5b0NzLYRclitojd1AUUFmh0mtShircZG2A8Ju3zu3L/JtVNJhjUK0R0kB1
         L3wupNjYB54pWqGdRrT4dHrLBgJlSE/bjNP/ZqWpjRIh6SvYoYqLmGEF4B6RPWRNXWHR
         foruSZSoR/2tI5ACLCfCf7QXqoQK7TwMIxoCh9xz4I7nOGhrM2B4oakt5mgCNfyzu1J9
         LuUw==
X-Forwarded-Encrypted: i=1; AJvYcCV2yFzkVUBOrUf7xAu3fuNlCdTRPdiVr/SM2DKUItHMScK3B621pOlACyavupZqA0bCQj4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxjux38Oy6ljnm9WZkUVHXOA/GUYZ8PB4ikKTu8vtS4y2YoKBYM
	BZOMlVboytHwt3zBLK51vaE+4MLWWZ6yhyTNUQZCj0q7SY/OnLPrxTQAlPRK20Y=
X-Gm-Gg: ASbGncsdVRr7UvWNO3OyBFDxrrj/sc4K64Qa7YdVKAQBpHTkO20LCKAi0MQZrGCA89X
	XLppZLT4x63NUxX6RiLz7fiebNxyUk1MaHVGAnnsCa1WkM0Rzq0TRJ10LV2rEXyhAvgRmvPIPqQ
	fJv7Y2777FNo9VmfB2zE+Lean8BJZuqVfNbjJ1ZZHx+2D6vDsKCAkvA6vIlRZw1RXRwU/uDWw+c
	OtHMbWBFIE4qJ1FQ7aR9nScCPQuWXfrabs4b4JE1KrEl/48rAoNWtpbyZx7wu7Esq2q1g00BMni
	2TsA3INA9fJWy1QZXPkFsiHFQ2D743XZaAeY9ML1xOFtOURnbuTuZl0=
X-Google-Smtp-Source: AGHT+IFu3bGh+dR4gXvA0Xd23GoBCnM+yfw+G3EPNj4Vc2jg+fj1VnlHOFgKCDXygKj5XAozIyeBjA==
X-Received: by 2002:a05:600c:a09:b0:435:9ed3:5688 with SMTP id 5b1f17b1804b1-438913f86dcmr267603485e9.18.1737675895459;
        Thu, 23 Jan 2025 15:44:55 -0800 (PST)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-438bd48a94asm7141855e9.23.2025.01.23.15.44.53
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 23 Jan 2025 15:44:54 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	qemu-arm@nongnu.org,
	Igor Mammedov <imammedo@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	kvm@vger.kernel.org,
	qemu-ppc@nongnu.org,
	qemu-riscv@nongnu.org,
	David Hildenbrand <david@redhat.com>,
	qemu-s390x@nongnu.org,
	xen-devel@lists.xenproject.org,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH 07/20] accel/tcg: Build tcg_flags helpers as common code
Date: Fri, 24 Jan 2025 00:44:01 +0100
Message-ID: <20250123234415.59850-8-philmd@linaro.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250123234415.59850-1-philmd@linaro.org>
References: <20250123234415.59850-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

While cpu-exec.c is build for each target,tcg_flags helpers
aren't target specific. Move them to cpu-exec-common.c to
build them once.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 accel/tcg/cpu-exec-common.c | 33 +++++++++++++++++++++++++++++++++
 accel/tcg/cpu-exec.c        | 32 --------------------------------
 2 files changed, 33 insertions(+), 32 deletions(-)

diff --git a/accel/tcg/cpu-exec-common.c b/accel/tcg/cpu-exec-common.c
index 6ecfc4e7c21..100746d555a 100644
--- a/accel/tcg/cpu-exec-common.c
+++ b/accel/tcg/cpu-exec-common.c
@@ -18,6 +18,7 @@
  */
 
 #include "qemu/osdep.h"
+#include "exec/log.h"
 #include "system/cpus.h"
 #include "system/tcg.h"
 #include "qemu/plugin.h"
@@ -25,6 +26,38 @@
 
 bool tcg_allowed;
 
+bool tcg_cflags_has(CPUState *cpu, uint32_t flags)
+{
+    return cpu->tcg_cflags & flags;
+}
+
+void tcg_cflags_set(CPUState *cpu, uint32_t flags)
+{
+    cpu->tcg_cflags |= flags;
+}
+
+uint32_t curr_cflags(CPUState *cpu)
+{
+    uint32_t cflags = cpu->tcg_cflags;
+
+    /*
+     * Record gdb single-step.  We should be exiting the TB by raising
+     * EXCP_DEBUG, but to simplify other tests, disable chaining too.
+     *
+     * For singlestep and -d nochain, suppress goto_tb so that
+     * we can log -d cpu,exec after every TB.
+     */
+    if (unlikely(cpu->singlestep_enabled)) {
+        cflags |= CF_NO_GOTO_TB | CF_NO_GOTO_PTR | CF_SINGLE_STEP | 1;
+    } else if (qatomic_read(&one_insn_per_tb)) {
+        cflags |= CF_NO_GOTO_TB | 1;
+    } else if (qemu_loglevel_mask(CPU_LOG_TB_NOCHAIN)) {
+        cflags |= CF_NO_GOTO_TB;
+    }
+
+    return cflags;
+}
+
 /* exit the current TB, but without causing any exception to be raised */
 void cpu_loop_exit_noexc(CPUState *cpu)
 {
diff --git a/accel/tcg/cpu-exec.c b/accel/tcg/cpu-exec.c
index 8b773d88478..be2ba199d3d 100644
--- a/accel/tcg/cpu-exec.c
+++ b/accel/tcg/cpu-exec.c
@@ -148,38 +148,6 @@ static void init_delay_params(SyncClocks *sc, const CPUState *cpu)
 }
 #endif /* CONFIG USER ONLY */
 
-bool tcg_cflags_has(CPUState *cpu, uint32_t flags)
-{
-    return cpu->tcg_cflags & flags;
-}
-
-void tcg_cflags_set(CPUState *cpu, uint32_t flags)
-{
-    cpu->tcg_cflags |= flags;
-}
-
-uint32_t curr_cflags(CPUState *cpu)
-{
-    uint32_t cflags = cpu->tcg_cflags;
-
-    /*
-     * Record gdb single-step.  We should be exiting the TB by raising
-     * EXCP_DEBUG, but to simplify other tests, disable chaining too.
-     *
-     * For singlestep and -d nochain, suppress goto_tb so that
-     * we can log -d cpu,exec after every TB.
-     */
-    if (unlikely(cpu->singlestep_enabled)) {
-        cflags |= CF_NO_GOTO_TB | CF_NO_GOTO_PTR | CF_SINGLE_STEP | 1;
-    } else if (qatomic_read(&one_insn_per_tb)) {
-        cflags |= CF_NO_GOTO_TB | 1;
-    } else if (qemu_loglevel_mask(CPU_LOG_TB_NOCHAIN)) {
-        cflags |= CF_NO_GOTO_TB;
-    }
-
-    return cflags;
-}
-
 struct tb_desc {
     vaddr pc;
     uint64_t cs_base;
-- 
2.47.1


