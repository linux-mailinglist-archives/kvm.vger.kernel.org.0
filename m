Return-Path: <kvm+bounces-50315-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C5862AE3FF4
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 14:26:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EA58C4400D0
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 12:19:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44BA21CAA96;
	Mon, 23 Jun 2025 12:19:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="s6sN23iu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCEC5246BCD
	for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 12:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750681151; cv=none; b=SWf2HuYoOdWYly5woDyFF/Zlwlk8Xtj6DEiiFhJnrZ2a3D00mvc2C4DpHpVyou8Gs3A8rotnEH5QQMRSt5iQexBdfeaUYqzxZf4VI2Qc0RYpvWKkPxHMGsNRptW4Kg5Z7pa4l3b6DTDHqA+NFiAytgNYzgk3AFMh5AZxDCSjSXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750681151; c=relaxed/simple;
	bh=k0ppZS2y2qO0/d9LvAiK9e+/Ogl+f/5cwWLT5lnhTy0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sto6oTkPPvbBvz9y1FTTU1wI20J06NuLYS2DMW+TIGX8HYCRodyhPJeXtVc4t4T9cKpsQen+2fODrM13Tikj7GhehMoCp0ySRJA1rEpWmw2QgClFFX4sSHVGKFbCtxhp9xXdupiZU4h30tchOdHgW/pphFqhu152y56dsBL2xZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=s6sN23iu; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-45377776935so6590605e9.3
        for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 05:19:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1750681148; x=1751285948; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LDQM9sk8xLoIDxyTCgc//1G3alM8o04T+fdq/t3mMdE=;
        b=s6sN23iuLsGWswy9YyCuZwEBSYXxBGtZEyDJeAv/FeHO2w3REuENZopdcRCVIs4frz
         gQq/rQ91Ane0s7EHphXJuWGpRegxcah/EI0j1aBw0aeX6MboqkZqbyANXvOjmRzCJ2Re
         DY/HPs+8cxbCKASjo5gLbmX9PONPA9sxDV/au7fTqhT4bfWkwyQXkLE8OWHkq0tOqjAJ
         8EvBAI6YDaNDgUQuXzaREChaj8rISm9z/8IsbFiyF/7hLlNznbLKih7lIecXlvAULw0L
         zg8wdJIa+QPgfhWyY9GOD/1qFcnDLPNctkEQAY/k/fcMniP3gf24WbOTnwmAJ0r6+SLH
         2kwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750681148; x=1751285948;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LDQM9sk8xLoIDxyTCgc//1G3alM8o04T+fdq/t3mMdE=;
        b=e/bhHU7EITF4luqTw3Soq+fZV8M7cNOkt16zHRbadpKX+Weh5FmuUrapQOSCVR8RRu
         yrRRpMuFZsQAEyYizQ9zVHhtts9KSW6qWChlEEi29E3IE2WyV4Q0jZTCdJ4FfUvhxMFV
         aAtj7ZSU59NfrG2jW/6nK4VNPGa8erN+josqBbBOVy5UdQ4UlyhcDoYeeZ+oKmth0LFQ
         y5VQbHzlH9xihNML+R0XH1T+A3N1tq1lWCKZjx9QarSxW6l+NlhC+n61AfNsCjrxrKS+
         fR6TVgrKv0R33TQwup/bU/f+6uA8U21NG+lEmWP7OAM2VHv9AVPiuHoywn5luUndcTe4
         cgfw==
X-Forwarded-Encrypted: i=1; AJvYcCWgNjvMaA5/vRSu6tmdqwr/3KSrPMl7z6DKKL8UzQAe64/iA3R9YhO+0v2bc14peZwPlVQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyKKId2/ylAvVWevGxUQ6uHZkYoNRXc031RhfortN8NYA6yaMWB
	CmkvYS2ZKr4L3uQwAuRIBAEZdHKMmMl/4N10Bbt78C+nUapZREwjXGhBzjwzoDYFl08=
X-Gm-Gg: ASbGncuiwSU5yhL3QpJvTpqsGswFrEMjIXz/a6GWLuOPsX5xdAFCq2a5An3ZfL5vdno
	Uc/gCTJL80MkDFSFQlFAs/udwgbUMMD9qLaU3Chpn2kTkxZKW+UllT/y97qY1g41OV+vHMH9+0l
	OiaOLtcdg/F3lIDpORogyf3iFb2hvEJqFglE35QIAiBfNI8u92g+LpU6WPLN+v3OZI6NoANwIad
	phsEHtfQEY3XrNy0oVErurMOyhJpsLRoYzEYItS0GbI6bwwXQxWjnEA1gPBkcZSV5yiGjxsyBGy
	Ut0Cttti1VktMhhQpA/Ghy14nQKIoKThTW4QjiCHI5GTG6EVyd1S36vi1DGQpdUDpEmo9z7gH9c
	wYY9mp9mpY717pPG3WDEZpbhJu7ai2uENR1oi
X-Google-Smtp-Source: AGHT+IEEGQ2yizNQOBV9T6BfrGjeWcpsEH+4yJg0Dp41EHihRocLWjYUthkP7XbX59/zuaabZ4ahQw==
X-Received: by 2002:a05:600c:c172:b0:442:f4d4:522 with SMTP id 5b1f17b1804b1-453660d7e3fmr109375695e9.5.1750681148220;
        Mon, 23 Jun 2025 05:19:08 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-453646fd7aasm108543505e9.20.2025.06.23.05.19.06
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 23 Jun 2025 05:19:07 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Leif Lindholm <leif.lindholm@oss.qualcomm.com>,
	qemu-arm@nongnu.org,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Roman Bolshakov <rbolshakov@ddn.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Alexander Graf <agraf@csgraf.de>,
	Bernhard Beschow <shentey@gmail.com>,
	John Snow <jsnow@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	kvm@vger.kernel.org,
	Eric Auger <eric.auger@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Cameron Esfahani <dirty@apple.com>,
	Cleber Rosa <crosa@redhat.com>,
	Radoslaw Biernacki <rad@semihalf.com>,
	Phil Dennis-Jordan <phil@philjordan.eu>,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [PATCH v3 04/26] target/arm/hvf: Simplify GIC hvf_arch_init_vcpu()
Date: Mon, 23 Jun 2025 14:18:23 +0200
Message-ID: <20250623121845.7214-5-philmd@linaro.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250623121845.7214-1-philmd@linaro.org>
References: <20250623121845.7214-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Only update the ID_AA64PFR0_EL1 register when a GIC is provided.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 target/arm/hvf/hvf.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/target/arm/hvf/hvf.c b/target/arm/hvf/hvf.c
index 42258cc2d88..c1ed8b510db 100644
--- a/target/arm/hvf/hvf.c
+++ b/target/arm/hvf/hvf.c
@@ -1057,11 +1057,15 @@ int hvf_arch_init_vcpu(CPUState *cpu)
                               arm_cpu->mp_affinity);
     assert_hvf_ok(ret);
 
-    ret = hv_vcpu_get_sys_reg(cpu->accel->fd, HV_SYS_REG_ID_AA64PFR0_EL1, &pfr);
-    assert_hvf_ok(ret);
-    pfr |= env->gicv3state ? (1 << 24) : 0;
-    ret = hv_vcpu_set_sys_reg(cpu->accel->fd, HV_SYS_REG_ID_AA64PFR0_EL1, pfr);
-    assert_hvf_ok(ret);
+    if (env->gicv3state) {
+        ret = hv_vcpu_get_sys_reg(cpu->accel->fd,
+                                  HV_SYS_REG_ID_AA64PFR0_EL1, &pfr);
+        assert_hvf_ok(ret);
+        pfr = FIELD_DP64(pfr, ID_AA64PFR0, GIC, 1);
+        ret = hv_vcpu_set_sys_reg(cpu->accel->fd,
+                                  HV_SYS_REG_ID_AA64PFR0_EL1, pfr);
+        assert_hvf_ok(ret);
+    }
 
     /* We're limited to underlying hardware caps, override internal versions */
     ret = hv_vcpu_get_sys_reg(cpu->accel->fd, HV_SYS_REG_ID_AA64MMFR0_EL1,
-- 
2.49.0


