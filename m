Return-Path: <kvm+bounces-45050-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 70A05AA5AE0
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 08:25:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CD7364A5359
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 06:25:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D745827CB00;
	Thu,  1 May 2025 06:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="UH1c/7eg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A3CD27C14B
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 06:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746080653; cv=none; b=e8hS8jJYNS0QBRD4JZl5b/CfC22YQpz0N3P+6qncLIfjIy/C/0CRIbf2GtpxvEiTDWF7Uxm4dIdE5o/vg3qEh5ig//80blPTlhQcbA1zOOLQCxcnUQegM4HPvJL86kM5CjJUsKS67WiP+j1u+3Rc/lW7VtDPD7rkVIeYkpQaHMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746080653; c=relaxed/simple;
	bh=odY75C+3O9zNiwt1b8z8ReQnO57IeT/mAkaghG8I7+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nN3UIJcoPZ5Ag+arJ9uL/fM7ZtgYpL3TEPf12rHpOc9sIvv/HwOLi0AckW+Hbc6dzb3dK0943zEAGreG2ELKkkYN9LfsICAjQS2MWyIttG3zD5HoPV98k7AV52bFH6R2KYdAZF/sPbFjd7LfQHPeNGZvGgEAHqHQDIN0vybqkQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=UH1c/7eg; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-736aa9d0f2aso992759b3a.0
        for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 23:24:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746080651; x=1746685451; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mpKaNGqfmwNtM4gHQeVcm0rmbF9SUIpTKwfANCDu8Fc=;
        b=UH1c/7egQ+pkt+Af3EkwQhwpzytlNEvRmmntz7ijA2myqbrrEsqeOy0V/IMEO7QsuR
         na07sEKPphnZ6Q7kD6PZ4yBmdNI95T04GwDjzXsWBvaV2BJ4czBwgNZ4O1rRzFeMwU8L
         pZ2k2A1nQ+hYpWKS0HaZJSEBfSjeEGhr4D/+U5VOJd7Y6IWA2VHzF4zumUWGqtAjDjPB
         XBx/nbGaeabGaL6ZcIsQ6gW3cRFIb+F6QW3bJmts6b+YF4pZokFdQXj8SWbJG/59kSDn
         sNRJaj0XsXql2aApjWZjbA3jokuFizWHNE8+6Osj51IAE/TkASO2B+OjpSjvcK20eysq
         3KcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746080651; x=1746685451;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mpKaNGqfmwNtM4gHQeVcm0rmbF9SUIpTKwfANCDu8Fc=;
        b=ZX+gZnv78tp1srEFWGINmEC4KiAidgZSXBQpFGi2/8dYQrachzFF/XZODW0f+6COF4
         qGTeB3RmykEs493ZPEQqQ3uUNTVuZUkrias1K6SMDrDRrEZ3cJ/wuZVlockNgN7raIcV
         6uOSPdwrt8rU2sRyYbLZfzVqPdXXU6VVitPB7O62z5ub6aGYnbU+xS4tBqRiqoXI/+xp
         onMcwMUjChHIl53Dp2Ks/mx7r0pY8mSC4qLCY26zf3nPQ4PHBfQeLv+c2c3D/rHC1Tp4
         Bf5gYmO4nB14Ax9tfeINPY6mxHenBMyUVlmX4G0eBWa1hKJLmKzJ+1orLkNe/1rqxdXW
         jtTQ==
X-Forwarded-Encrypted: i=1; AJvYcCWXPVBGNgmQsZguiC3kafL7zp/jaMlmL0PH908X5BgkC2+6KAl21Dhiha2cLahN7UFPUh0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwXe8T+YQhEawawRdrT2U20WJR+Yt5UYlVqlIRKWbW+XoQ0iq/x
	wc2TgA4HTuP5F8ffw9a4ED8anC3CV/KaGc1pUphBjSoTyDvC1NHSJRNqjGc5VHY=
X-Gm-Gg: ASbGnctgVoYFHSiAq/jwL128cz9jKiI4xBfqMXDFp0yJRhzVJUhJj30Y67e6CP7v5/m
	nmutZFffC9Rzy71w51sHEgH6zwupIe86+VjWXBrAThuFENemHPrfQDzKIAyNRqvMTvVcenUqayP
	vyZpPnj8kDfyRHu9gxfKo21ksL00a7LUv+Ruiv3LZWyBUEs+qHOMuoZpd8vatBInX9KER5O9Pg1
	x08oKLxtLr0M8i7EVJf7q0J6qZH6GsP0EaKXh9kIV8k4h23b6FCNWy0QbZWPhkX/2p2H5uYj1m9
	A9h6KCGwU16Frl2OPaAC111M1n2R2P5M1gmYndad
X-Google-Smtp-Source: AGHT+IHWmZFe0mwWyFeKYCiS49H1f5jxhNRdExacq+/xBeP9espa19f6AzO9WL3BuOcAYk+W5kolRA==
X-Received: by 2002:a05:6a00:84e:b0:736:43d6:f008 with SMTP id d2e1a72fcca58-740477a3268mr2817241b3a.12.1746080651095;
        Wed, 30 Apr 2025 23:24:11 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7404f9fed21sm108134b3a.93.2025.04.30.23.24.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Apr 2025 23:24:10 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	qemu-arm@nongnu.org,
	richard.henderson@linaro.org,
	alex.bennee@linaro.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	anjo@rev.ng,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	kvm@vger.kernel.org,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v3 22/33] target/arm/helper: remove remaining TARGET_AARCH64
Date: Wed, 30 Apr 2025 23:23:33 -0700
Message-ID: <20250501062344.2526061-23-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250501062344.2526061-1-pierrick.bouvier@linaro.org>
References: <20250501062344.2526061-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

They were hiding aarch64_sve_narrow_vq and aarch64_sve_change_el, which
we can expose safely.

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/helper.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/target/arm/helper.c b/target/arm/helper.c
index 1db40caec38..1dd9035f47e 100644
--- a/target/arm/helper.c
+++ b/target/arm/helper.c
@@ -6566,9 +6566,7 @@ static void zcr_write(CPUARMState *env, const ARMCPRegInfo *ri,
      */
     new_len = sve_vqm1_for_el(env, cur_el);
     if (new_len < old_len) {
-#ifdef TARGET_AARCH64
         aarch64_sve_narrow_vq(env, new_len + 1);
-#endif
     }
 }
 
@@ -10645,9 +10643,7 @@ static void arm_cpu_do_interrupt_aarch64(CPUState *cs)
          * Note that new_el can never be 0.  If cur_el is 0, then
          * el0_a64 is is_a64(), else el0_a64 is ignored.
          */
-#ifdef TARGET_AARCH64
         aarch64_sve_change_el(env, cur_el, new_el, is_a64(env));
-#endif
     }
 
     if (cur_el < new_el) {
@@ -11552,7 +11548,6 @@ void cpu_get_tb_cpu_state(CPUARMState *env, vaddr *pc,
     *cs_base = flags.flags2;
 }
 
-#ifdef TARGET_AARCH64
 /*
  * The manual says that when SVE is enabled and VQ is widened the
  * implementation is allowed to zero the previously inaccessible
@@ -11664,12 +11659,9 @@ void aarch64_sve_change_el(CPUARMState *env, int old_el,
 
     /* When changing vector length, clear inaccessible state.  */
     if (new_len < old_len) {
-#ifdef TARGET_AARCH64
         aarch64_sve_narrow_vq(env, new_len + 1);
-#endif
     }
 }
-#endif
 
 #ifndef CONFIG_USER_ONLY
 ARMSecuritySpace arm_security_space(CPUARMState *env)
-- 
2.47.2


