Return-Path: <kvm+bounces-50071-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DBA5AE1B71
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 15:08:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 513637ADA70
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 13:06:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C32A228C2DE;
	Fri, 20 Jun 2025 13:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="HyI+z0DE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30CDB28BA9B
	for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 13:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750424860; cv=none; b=oJpadqJA+5s9vhTHZ9gGSPljSN3i7AAltWy2eKFhrXXrl43rPgGtk+j++15mf2nwUSw3oehnpxFEv7vj14viAr+yOcBHgcIfcSqZvKGT9IHxBV1hhVUBiWZKOGt5N6aq75edTemkYyH/7fxth5uPSRvL3sF3k4/5BA1PlAdGpFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750424860; c=relaxed/simple;
	bh=qmkEE/P1MRtY9fRUShXplI4bvffjLYW5Q5GOXihouNA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZKTq6IyHApNsOY0wbbgxZ4oP4X8hf+LdTAoIXGnKk0IYSRgxdYt1Gp9tzIn860lcpU4ucWPrEwmYxSFbNsjxabXf51DZW/Qy7ObnPmHoHksLDb9quOsZHfFGH/jqNW1rwDxrhJPG5aKTmwvpWNokzCIN4eRQMLi26G3eGQsRFms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=HyI+z0DE; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-3a375e72473so862887f8f.0
        for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 06:07:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1750424854; x=1751029654; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i7X9qE0A0zkH5gg9YDfRhHn13dFLj9D3tYtyAnJR94U=;
        b=HyI+z0DEZrDjo54IS1cN5aKjwXfm/R/FtHrChtR7XB4YWXd1PB6GTQdQfDt6Z5xekq
         e8+OC4Po7nUuV89j3EZ6WUzDTOHcrYn3+jO9QMpNsU3OsWRDk2ssaCKRT9DD/7F8ZZ/z
         d9+NsA1+ciZtSaRr+G7z/cEtaNOYBWvAcu88l025VMYorCazwvHPY5St0/uloN7rOZaX
         u/OnFiy5wITTzQI+v63VNZRTxNca+U5iPVtLsnphA2j/qvthljFfPu/e0ARwRqaIZXhw
         xfGEex+l4a36hObi4oHorp5O/Ffwm/rFIk3HkprhyADjbjP4u/V0luyhar7iGmaSh8Mf
         ycVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750424854; x=1751029654;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=i7X9qE0A0zkH5gg9YDfRhHn13dFLj9D3tYtyAnJR94U=;
        b=d0hR6MyaeSGmyHxMjNvLH7uXOMlIClVEAZEIaIzBptz621DA1ijNWJkGDPRAMZ55qs
         /XpDmf2Ido444tJg7ANhzQvpjgmE5q+gpqbqfDlZVhWyf4Tfl59+LRHKg0h94psFArKj
         /D6gAxFaELJpHYkFjY4TWKcFUMS8Lt2yX2JK4YMP2RbCT+a5Yml3BPPnhFLmK+0wDi3O
         QBx/rgYbECePC0qKF0sdlY8YWsokpXnfX7kHWqrrYQiAoGeFgAPtYM0hfWxpNRxFho9P
         gi9SIgOIyoxWtsVgURz7wEMj5n5xzkz2+A11ZPZf+k7iAIKAnW83J++dgOSNw7zU5ebe
         p7aA==
X-Forwarded-Encrypted: i=1; AJvYcCXgEbd2MEIerFYN4a5I8rIov8bSU2L/X5S5Bb82gNfcJHaueOU3OQuT15rIDduQ1q7FDKI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxn+D9phP2YHI3Lc5hT0MkYVQJYeeOWTNcf8hLdVgNikFjOyT9Z
	bHDnbBsuVu8Pix1/yB14fLeBchkOVMyyj4E+/iYt6eWaBgpwzFmIBuTA7Ob/Biww238=
X-Gm-Gg: ASbGncvJXK8xs4pD57dDwNpdJw7AOmwyBcvDEJatxIHh8hb/OHYFfNx75BcvEXR3yZU
	hwhvsTlso79oZY3l/BcHKy/4LHB1nytkA1l1S177QZT5AY03c4vZfHlRzA7Wr3BSneQ/+/eRPHj
	pAL91XDfKLHyq/Yvl14dt3xryuMvo6AbQ2+WieHgi4gwpsEB8xoZWG8SfWratvOYpK2q95R/HtV
	5pM2IwpC035bFm4Ia2xPWaauhen1yvWzJL62+B+dXm8U7A+XomW7m7H79WR8YR1L+XXwq9ZRUJk
	50KTgEXcBKSeb2AbfcpZGMm1lD08FmsjjsWgyuPYvaInbYp4sQcX/TMnUIw0EqNrGgB6UVd8vp+
	LPNv7YJRc8e+J4JTTfrNm8hHpMdrJIf7dWqnPJGKVVxR95Y0=
X-Google-Smtp-Source: AGHT+IG8MOa1mgx5GRJT2pi7G8sTIbJ7uQF1KFg+Pl8xxcjdSw3j34E0kQi1ej0Od+hgqLrB/UqKrg==
X-Received: by 2002:a05:6000:4715:b0:3a5:2923:7ffa with SMTP id ffacd0b85a97d-3a6d1193fd2mr2532616f8f.7.1750424854370;
        Fri, 20 Jun 2025 06:07:34 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45364703f1esm25142395e9.32.2025.06.20.06.07.32
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 20 Jun 2025 06:07:33 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Leif Lindholm <leif.lindholm@oss.qualcomm.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Radoslaw Biernacki <rad@semihalf.com>,
	Alexander Graf <agraf@csgraf.de>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Phil Dennis-Jordan <phil@philjordan.eu>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Bernhard Beschow <shentey@gmail.com>,
	Cleber Rosa <crosa@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Cameron Esfahani <dirty@apple.com>,
	kvm@vger.kernel.org,
	qemu-arm@nongnu.org,
	Eric Auger <eric.auger@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	Roman Bolshakov <rbolshakov@ddn.com>,
	John Snow <jsnow@redhat.com>
Subject: [PATCH v2 04/26] target/arm/hvf: Simplify GIC hvf_arch_init_vcpu()
Date: Fri, 20 Jun 2025 15:06:47 +0200
Message-ID: <20250620130709.31073-5-philmd@linaro.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250620130709.31073-1-philmd@linaro.org>
References: <20250620130709.31073-1-philmd@linaro.org>
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


