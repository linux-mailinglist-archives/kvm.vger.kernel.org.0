Return-Path: <kvm+bounces-35944-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D5361A16692
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 07:13:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7CFA7188774D
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 06:13:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 276E0187FFA;
	Mon, 20 Jan 2025 06:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="FKkMdwRI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91108183CA6
	for <kvm@vger.kernel.org>; Mon, 20 Jan 2025 06:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737353616; cv=none; b=F+q20egkQEu/JmuLMOPsg5jSSRI/IhhO9LP25B3f86LqRKjpO8XK+5WYR5klRtDV9+iPlIoJSeeCYTubggkRJuOlODfZ0/TgUmHfFx/BrenCi+gik46lZwmUTvlw3r83nGRXOHHR48efsXo3jro2/JeOVWKz7QIGQzgMJ+LnMwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737353616; c=relaxed/simple;
	bh=CYhXwgGa4X22iwL0OCe5p6nuIsa6FmpfTmFp/kvJIGE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sT4Ip5KrFwdzjn/00mKxN6qjoed3WJAKEvhTwhXvR3N3FDbUQIrnVrNbzITnPtLX6AzHRt1V67sSoKwRo3kzznD5Tks38QPy7xn57SxOXznxNmnLqIr6TWEJVetOxo0TYaFhJ6Diyez6zgJ481lq2FcsTyR2wvNrvRxlDR8Nzj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=FKkMdwRI; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-435f8f29f8aso28153805e9.2
        for <kvm@vger.kernel.org>; Sun, 19 Jan 2025 22:13:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1737353613; x=1737958413; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Xht6F+Bfddgo3PrucGv//ZpFrfS6UZc2/xGuv7FMfr4=;
        b=FKkMdwRIdOAOpGUtBvzcKiJoW4dVunxyKsLOoWzIfe9ERx9XxBgdcavBEWC4nrQnKk
         XjZbWjp3VZQFtN8m+NVfeiCQ/lspBjvyLQXRV15yfLuDBP4sRf/WKH93hfOa2NyKb0/F
         +Wzbo0yfpVmmD6ed1oHMxXolVsu1GsEmi0Es4w3MYGrgYIzmxY2/Q0pHUz6n+eyr1Aug
         km7zn1H7WrTwc023iLJxMbiFdmqZljlUxYfDVOjAJycUvp60vicVRHURhslomOwRMy1S
         RTQONX5B0LBdhrDMrFq6RfDRtyhYs/ZWGA0YT9neN6HcbKv76IxMoBoT2gychEzQ4mWs
         /TPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737353613; x=1737958413;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Xht6F+Bfddgo3PrucGv//ZpFrfS6UZc2/xGuv7FMfr4=;
        b=pblteaaEw0n5GX1IXkFGjSaugHZO/0URCTHYmfVljbGb+elp/0tff4b0sab+HkZC+o
         r/uUZfnmU+oMYLtCb30iJXRe7skwCXFcYH7BWPG0oZ08fHy4QBhvQTFSIphStqmKfooW
         iIUArbGSaDLZ8TEgIpyn5RwzCw8q4e+5gwZgEPYejU4OCloit7SpnHTTHr758njMLHFZ
         qsLI0NCwgMm184gxpoABklBnb3L7Jd+lkTWc67X4d7MTfxojAW18ide5apMcPwX6o2Mx
         qWGndL/0amsuMYR3owqTrwMC/wkizxvP0o7RVN9RDGAE7VyaXAYLNbKrqTNEPq3aV/nM
         slxA==
X-Forwarded-Encrypted: i=1; AJvYcCW9x/w+/qRSzT6mm0AaiqSY4bGVpaauI3UWkHyCVdaUExMcoHmexY2y90filEIL9NqrPxQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwPd7nEu/lsUdPPS4LWcv0qlmPpQTQi4el4YNTsMVwbX3tTCpdb
	N0Abu7n8iQP2Tofr86XJsp8RFPTculxUYgaQDhLUhLrT5TUN7vs4US9dMMIRLEc=
X-Gm-Gg: ASbGncvO0SqkUJ2AaSArE/Dt5BPgxPCjU1b8Q//g1XoPXvY5N2FGXu4jZGLJJbGWMUk
	+4m8C96O75UUSxsNK7aCl99/Sudkl2SBDpp06Ye0OneO2AWt9GetiEmbJ0EZWUQEFwZIAD4FPUs
	xZP0wgQZx46v1XdE7TefSp6SJinSo1J/wXuiNcMj9Sbul7MeH1keYPPXTpw0ZNTRqjAj74h7lCt
	7KACqWbZUbdZXtpssX+V4L/VIfDquwI9yreeGXAvwc/6IehFNXRrHqunluBKuvrt3FWoFROvv/u
	XJY7kiBcKsaF13j88lyXv0F1c407f225/HyReSzPGNIC
X-Google-Smtp-Source: AGHT+IF+TJkrPn7eE3Okqh3EvtF88mvEqTvQGYIM33ZG3vLFVo2jCll9ng09trmhL1noLdq3Lbecvg==
X-Received: by 2002:a05:600c:138a:b0:435:194:3cdf with SMTP id 5b1f17b1804b1-438914292demr100258335e9.19.1737353612858;
        Sun, 19 Jan 2025 22:13:32 -0800 (PST)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-437c7499821sm186147275e9.2.2025.01.19.22.13.31
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 19 Jan 2025 22:13:32 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Richard Henderson <richard.henderson@linaro.org>,
	Kyle Evans <kevans@freebsd.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Warner Losh <imp@bsdimp.com>,
	kvm@vger.kernel.org,
	Laurent Vivier <laurent@vivier.eu>
Subject: [PATCH 4/7] cpus: Constify cpu_get_address_space() 'cpu' argument
Date: Mon, 20 Jan 2025 07:13:07 +0100
Message-ID: <20250120061310.81368-5-philmd@linaro.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250120061310.81368-1-philmd@linaro.org>
References: <20250120061310.81368-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

CPUState structure is not modified, make it const.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/hw/core/cpu.h | 2 +-
 system/physmem.c      | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/hw/core/cpu.h b/include/hw/core/cpu.h
index 782c43ac8b3..04fede0e69a 100644
--- a/include/hw/core/cpu.h
+++ b/include/hw/core/cpu.h
@@ -1155,7 +1155,7 @@ void cpu_watchpoint_remove_all(CPUState *cpu, int mask);
  * Return the requested address space of this CPU. @asidx
  * specifies which address space to read.
  */
-AddressSpace *cpu_get_address_space(CPUState *cpu, int asidx);
+AddressSpace *cpu_get_address_space(const CPUState *cpu, int asidx);
 
 G_NORETURN void cpu_abort(CPUState *cpu, const char *fmt, ...)
     G_GNUC_PRINTF(2, 3);
diff --git a/system/physmem.c b/system/physmem.c
index c76503aea82..0ac6acb9764 100644
--- a/system/physmem.c
+++ b/system/physmem.c
@@ -805,7 +805,7 @@ void cpu_address_space_destroy(CPUState *cpu, int asidx)
     }
 }
 
-AddressSpace *cpu_get_address_space(CPUState *cpu, int asidx)
+AddressSpace *cpu_get_address_space(const CPUState *cpu, int asidx)
 {
     /* Return the AddressSpace corresponding to the specified index */
     return cpu->cpu_ases[asidx].as;
-- 
2.47.1


