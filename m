Return-Path: <kvm+bounces-7226-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 831BB83E48F
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 23:06:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0C414B250B5
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 22:06:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52E823EA86;
	Fri, 26 Jan 2024 22:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="FHJ22g+x"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF21D35280
	for <kvm@vger.kernel.org>; Fri, 26 Jan 2024 22:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706306726; cv=none; b=DwqIYfJxqPOm9ZbyV9mfVrL9UHWe72wuSRmmzRszQca2MM6hGfXiGvHH4vr/h+rvQjxeNDqeaz3E8JF6tGDmgIXq0c6LXRZZ5vRzohqiYhRUJ4PKuTqhO4O1BuO9rjIrP7nT7QBNarzpmF+95qYd9ytEVNZsOlUExsLJhXuZw8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706306726; c=relaxed/simple;
	bh=c9vP0Bq3ENDVnXG6tjoAi56Y96BxR0eK2WAllUJ/deM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BL1RPB2zguClh4IDoIq17lrn7Gba4yWrcZYI1Pb03M4XGllUbbYKKjqga5qxcVxo5so/oEpBgtMRRzMpYWfAsJBCx01F1nlE11YGt9n3RV/n0hQ9Pjxw9Yy4gORg9mQSCxuQYbu7R9RkjHujiSdQhzVO4TVgA3+xHxT7vE5e99M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=FHJ22g+x; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-a2a17f3217aso126018166b.2
        for <kvm@vger.kernel.org>; Fri, 26 Jan 2024 14:05:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1706306723; x=1706911523; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FLJcVa0Wo/+9a3++1/N2vAccbtpACcy2YfF/nJ2X7yI=;
        b=FHJ22g+xJRU7GW/9XsIt2tFjDiXRvn/J/dnMG/pYUvtlHKC4rCKLM+lx5HCOSdfpa6
         5z69GyGBMlhYGtQtRjr7cTy/xMXx2UoRz2pngIjKIzUJIhQ8BTgYtiWpzM7gdZefDPrY
         V6MN6Ztv4/cXiuSvpsJ89wS04cCjQhkn1J9ibzvMiZ0TAqj3+e52HuZFHm9Lw3MEuUIv
         OPJf6JM++O/sNS5c+I0M9dWyOGPrJGGIAOKmWYezbMzWTStSmnhxXv7OyLh33zUiSu/W
         IhdbrARsMS3g5XvdpggZUuXfo7n931NFeYC7TgjI6Dw1XrhzbJ9fUZjg/cQrpEJqlgE4
         U3lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706306723; x=1706911523;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FLJcVa0Wo/+9a3++1/N2vAccbtpACcy2YfF/nJ2X7yI=;
        b=pH/6V7QKi8ujKTh3FYBMNP8eLhNjWHbDQUkkPMAivrcyAk2TS04dupfALeLfV5zSKb
         D8DstIhR246SIHMfovEqlGwuyXgxq9atGcSuPGTPMGUIiY+sTqZ/SoyX2/Xn/yDeQ2Si
         dekFE9WPvbdQJRzZ65cSWPEgIQeYCSbrgiudTHk/cnv6ob3e31ao9Op9ttoAADrjUG8F
         DShoaUBDIjHJQF50/lUY/yEONRrh7EacTSQ7jfMKGuZzhuxFQKfypLpcZgI/K7uokunt
         zhG0bdaz73SNhG733XGt+RtjsqH27qVi1tWhpjtun8AMnU7kyDjt0aGSXP+/q/WQNBT6
         v+dw==
X-Gm-Message-State: AOJu0YwfFNX6i9DMDbnXf7HNWlciX3yAal35Ni6NoN5FvQJ9Ij4+R0aK
	ijlRBsMt4u3NGtllvlNSjlS6NsSWPPxBn6xUmNG158twLQmiXJmFazeT+Mho0dI=
X-Google-Smtp-Source: AGHT+IHJ5scN1N+LgHfCxF25aRO27r0CuYmRbnWRaojOW0krzmjgy0JozVqr5YlJ8Os1eVjZ42JmZA==
X-Received: by 2002:a17:907:170e:b0:a30:86ec:44dd with SMTP id le14-20020a170907170e00b00a3086ec44ddmr379991ejc.67.1706306723230;
        Fri, 26 Jan 2024 14:05:23 -0800 (PST)
Received: from m1x-phil.lan ([176.176.142.39])
        by smtp.gmail.com with ESMTPSA id w15-20020a17090652cf00b00a2e81e4876dsm1047463ejn.44.2024.01.26.14.05.21
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 26 Jan 2024 14:05:22 -0800 (PST)
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
Subject: [PATCH v2 12/23] target/microblaze: Prefer fast cpu_env() over slower CPU QOM cast macro
Date: Fri, 26 Jan 2024 23:03:54 +0100
Message-ID: <20240126220407.95022-13-philmd@linaro.org>
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
 target/microblaze/helper.c    | 3 +--
 target/microblaze/translate.c | 3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

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
index 49bfb4a0ea..1c6e4fcfe4 100644
--- a/target/microblaze/translate.c
+++ b/target/microblaze/translate.c
@@ -1800,8 +1800,7 @@ void gen_intermediate_code(CPUState *cpu, TranslationBlock *tb, int *max_insns,
 
 void mb_cpu_dump_state(CPUState *cs, FILE *f, int flags)
 {
-    MicroBlazeCPU *cpu = MICROBLAZE_CPU(cs);
-    CPUMBState *env = &cpu->env;
+    CPUMBState *env = cpu_env(cs);
     uint32_t iflags;
     int i;
 
-- 
2.41.0


