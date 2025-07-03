Return-Path: <kvm+bounces-51407-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B450AF710D
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 12:56:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9530D52705C
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 10:56:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A5752E2F03;
	Thu,  3 Jul 2025 10:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="A/1zBi9X"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E88A29C335
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 10:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751540166; cv=none; b=MY62bGAOG4C1ivbJzA9PUO4dy9f6IICiSOMMMoEZvBnEXxDFwdT8zKpi0wXdfp9LfRxs9v8ZBdGmglAbzA84qjo1Qoe5X7eIZ/l1oZalyF+4/ppBlMkLwN81KrwgDIkkcUCdyMgi8UPeryu+Sd1ErahkfBhi+jwbcV3A/mFZDKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751540166; c=relaxed/simple;
	bh=Se2xZbbHQJr4ZT0ANpCXsvH/8k6G4pZeseFATc+7K1k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ILa0HRjbSImQ8IidIUnK2Ov2fskMCDdPodvlV2dq/D2l0ACIqoYtdUpObRlj8u/qZ5USyy1K5O7lGPx5H+CqbMkoqeV9Bg3ltNKss9Oj8RZFdF7cu3WGzAXOpFg2ZLchqSu5R6Dhw/Xygk2ni0WzpzsTDDITFwLeF+ZFL+6dTQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=A/1zBi9X; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4531e146a24so46592125e9.0
        for <kvm@vger.kernel.org>; Thu, 03 Jul 2025 03:56:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751540163; x=1752144963; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eMVCQTvVGe/Hz2DEmM07zNOYeNDGY8/7Dwwnom0rM8Q=;
        b=A/1zBi9XijJAyTFiEa8t97XdnxyBwbJXbqdL/e9XXoiSyqWxNpg8o59s6jAe9UUfDp
         NlZNFas3eiV5QlpUKT9WP5Rxk22T4xn0h6LisUUrxUZr3W/Bon0XEcFIKkPejn0wFjbz
         u7QV8C5BH6Z+DvhJynsAkBcR53TD7L6y/TzyBKaOd7OXF0WSVwXgoUuUAiRqdyu/GrQe
         wKTnCCx9d0aDPZm16cjaSeNK6GXJVmW0A3IlQFgULh/uTRgx4GHZI4tdLK6qO1WGP3yS
         24Bwu4qmNFyykZg/ipP6ty88vP+/IW/TvaMFM886hzBaOD/FEOgn+HST/2XRhWZcEb6w
         d1iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751540163; x=1752144963;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eMVCQTvVGe/Hz2DEmM07zNOYeNDGY8/7Dwwnom0rM8Q=;
        b=InpfdPsn8ZIm3CHi0BoDj/mW5mz90ZTeeXecC/rFg7QXa+JIHZk+ze0vQnMSa96MjK
         hTUtzPWuL6SgodZyFEMfzMZBPyvTkdAXnoKd0SUO6AdQl5ajRZPFrRFWDXSq44L8MGTu
         FQ4XTaFyIQ3RfshSPlciAjKJg99cH1r+djYL30SR/pc6fW8aK/Z9I3ZZJT0fckl6yyPM
         +8ug35FlQCLgYhIbPuNWqBhnaxVFEODAi+Hq3KoUw5v37+ttN+b/NtgiK/VhVhnuXGmk
         uqkHG/fTgcz+sKYoUjrEkkm9No+hVlEGTMc/ttrKVUUV9Rti1zmC7CrUxRA88Z+okvD/
         N/gQ==
X-Forwarded-Encrypted: i=1; AJvYcCXGznLy4yYMw8YamL4DL/P9tSQ7cixjbHRX5FtrD5tql7B0vXkz5pJ6kaObOamu6gJVA7E=@vger.kernel.org
X-Gm-Message-State: AOJu0YzwR695KGo7/Sun7NbsEJ4R30uDN8EE27tXEml3JDhsgZYOKgfg
	XBa/wZWZ0LiTrXdpuojFskTh3PHeloEBZNhhRYsGJX7WVpxH3V1oT06PZJrFmHleJ9o=
X-Gm-Gg: ASbGncs3YAdO4wPM6ahu+l7ImhniYCEy+6wHQ2BKoJdLKLNuZ2ksyf5kOy20c6EFrqu
	Oqe+jkRTOWsDIWwMcfQEUoDTN7Bspdoc7rdjqwtrlkVt6G8SGTMOPZmxXSg2t3RdRZ+7DxAx0Sf
	Bs0IHsfiOR9hLBfQn899vYhfzJpsjzpPq87au0Z/kqf7yq4gu11RnuR3JjbapUHfuUdlchXe/TE
	M2VTj9onKRYXcxy2Jil1/ZQqgoMwUkJn8rhzncLK0LsU5tnoJGHMufdEWdm0qq177o2UpNhHuow
	SiJCVlj8XGoDU5svuAL9h449pOqiKH+NWe/GgMkgjtIz/1V9WqBuwvENJQdbh/RwgoueO3sJDP6
	v/nidQNepHs+wsxofZAge8g==
X-Google-Smtp-Source: AGHT+IHRXWokL5MOT0i7s0s1AgeUsTebRY+EJxnCZglAAZYqkG9epS9CkFuuRnILEdA3VJz5woDksg==
X-Received: by 2002:a05:600c:3f05:b0:451:e394:8920 with SMTP id 5b1f17b1804b1-454a372e226mr57162345e9.27.1751540163340;
        Thu, 03 Jul 2025 03:56:03 -0700 (PDT)
Received: from localhost.localdomain ([83.247.137.20])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-454a9969a8bsm23455185e9.2.2025.07.03.03.56.02
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Jul 2025 03:56:02 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	kvm@vger.kernel.org,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH v5 04/69] system/cpus: Assert interrupt handling is done with BQL locked
Date: Thu,  3 Jul 2025 12:54:30 +0200
Message-ID: <20250703105540.67664-5-philmd@linaro.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250703105540.67664-1-philmd@linaro.org>
References: <20250703105540.67664-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 accel/tcg/tcg-accel-ops.c | 2 --
 system/cpus.c             | 2 ++
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/accel/tcg/tcg-accel-ops.c b/accel/tcg/tcg-accel-ops.c
index b24d6a75625..6116644d1c0 100644
--- a/accel/tcg/tcg-accel-ops.c
+++ b/accel/tcg/tcg-accel-ops.c
@@ -93,8 +93,6 @@ static void tcg_cpu_reset_hold(CPUState *cpu)
 /* mask must never be zero, except for A20 change call */
 void tcg_handle_interrupt(CPUState *cpu, int mask)
 {
-    g_assert(bql_locked());
-
     cpu->interrupt_request |= mask;
 
     /*
diff --git a/system/cpus.c b/system/cpus.c
index d16b0dff989..a43e0e4e796 100644
--- a/system/cpus.c
+++ b/system/cpus.c
@@ -265,6 +265,8 @@ static void generic_handle_interrupt(CPUState *cpu, int mask)
 
 void cpu_interrupt(CPUState *cpu, int mask)
 {
+    g_assert(bql_locked());
+
     if (cpus_accel->handle_interrupt) {
         cpus_accel->handle_interrupt(cpu, mask);
     } else {
-- 
2.49.0


