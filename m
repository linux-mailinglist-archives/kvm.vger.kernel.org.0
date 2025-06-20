Return-Path: <kvm+bounces-50077-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A640AE1B84
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 15:09:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6BFE416EE70
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 13:08:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2D3728C871;
	Fri, 20 Jun 2025 13:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="KqyDRgVJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AF1B28AB11
	for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 13:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750424891; cv=none; b=M8+RrScNnDqvzmc2kmMqjIv6BdhnRKfSgt1fUzUEi0x44vt98ICbDLkURFqL0slVQ4q9AkIzIb79y3ETEP8VfHgVXF1zYt0CfHXHiNNygxr3xh0hGkPSCYG2HGg8ALX0od8NDcYMJDkHOKtQNY4sr5aesAQEIBnoIZQEYxkqpGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750424891; c=relaxed/simple;
	bh=MgtT3nc26yrS5j4ngRrZve14xqddwW8qQRyx4Kkbe7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p7SHyeGDg38IWVqtxDTi6Hb2OgvC8KT8BQqjJIy7llmbgJb6rBuBe+RKkBE83AcKpvfp7P7y3YXsXaXYHnXWaarXjukB6JYUi3GuE3UkDFQm0ECtsAJWk5YdqF1FlJChGJkx9GCtdPnp3EzCEYCUWA8co5rxu7EiROPVg6H6Bjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=KqyDRgVJ; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-3a51481a598so1024477f8f.3
        for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 06:08:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1750424889; x=1751029689; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gcjg3QhSmhnYtUxzgWM8ifLgGs9HqCTQt/fl8y8J7b4=;
        b=KqyDRgVJnZU8/d1DY97FVCwPFlpwQ5bpmvkktT5aHrGgMCQ0dxoD5E+EpUDz/sZ1tF
         U2kAxryyjZGgYRpJZS7bcCV1K/EgtGAQYHNBI5LW3os9DcB11bZwcC4smvMuCObKY60n
         roFL+dDMRNix0xzHx45+bOns/aD9VoYrKNfhjPO6lMVmzNJO/YRv3WTXfVWbrYoQH4HL
         RXsYryonHqTp4irsvxZx0FW97ZlUKJNVckuza7wD8qG1rU5BXcSRtlO0IpFbT6Z9HQy2
         5ijo5GjRFAsGPFs6rjwhEm5bLeRpDGOsNroMzT61l2aPPuKDSMRJuU+8f/EQkQEB9qcM
         i9Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750424889; x=1751029689;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gcjg3QhSmhnYtUxzgWM8ifLgGs9HqCTQt/fl8y8J7b4=;
        b=vWusFhTIx6ql/oyWeEZCaK3S/1X68J2ip1ZSQcxXw8dPI9TFAD5bWbuPAHyX3mmAzB
         Aud1byzoTR4EIbbE0TUKIfkW5OcxzPS11HCp4bdNTY5S/PZW7VDxYWqoNBH0Q9PBWYqv
         Nc76+pDO6boSkwZ42RP2qWNeatj/Xg1j007n/gfHNeOLY/7j8rKMzs+ro4kGiVGXMfZS
         L9VvBWSkeQHPh8tqAFNJSJP/PANCNZxz2op87vAFpakD+umpgtRpntqww2NfvNL614zJ
         UgPi+4Pe2X2b8iqvNcHfDiCs3GF87AY2kLYBG+D4S2bQXKec4J/6WKtRwPdiiXt4f+MZ
         PohA==
X-Forwarded-Encrypted: i=1; AJvYcCU0HwRWSjEUioMOkcSmd7ocMIh7egk+aH7MHiC8dXId9Shg5Twcb6p8QadH0/BcBP7VFXo=@vger.kernel.org
X-Gm-Message-State: AOJu0YybpFgeqK8rZk39CNZkxy7bpl9nlPho4zmdPBaFKmRNfrsMn9Nm
	zFyu11lcOc/yjEoRYIUrvLvgMDTFS8UFR2NeqbCAEGyKv+lqNgx+K4yGDI9pEVi3AsE=
X-Gm-Gg: ASbGncvpN3FX7ml8q5zZ1TyF7+JHdRQGtWygOCw5kEgm+8DBEjv6+W9BKOqmZCpYNTc
	g0VJpkRE4WPyRjetPd+Mvx4AukOUtf4EiYolKFudSy2B5P9bbXp+i3Fo7FTVeFUd+AgUX435NnL
	bCoqIfsoILx7KIZnuFnCsgFt34xF35rtkFQtFBwPo9Jgv1ji80jZHkN8SWSltEwd/w9nTXFJ1nF
	ox7uAdKN9he6AQUXGXfqEZ1cFfc6+YpTRyYBijSldV5r8v3kzSPsYOxI6GQ19Rw6IZPr0zAd7sJ
	7x6+30u4J4VnAitbSNlT1lKLKiUpE2SUo3LdahI/2q44WfO7E0nj/vi4Fd5KK1Lbu4x5Fc56TZs
	jaADS+ZaqT1FWOAgYWZVfwr9R7qTMqoXM1p5M
X-Google-Smtp-Source: AGHT+IGlMawwPYBTI6F+HQ5fZwO6wtFZQ3ofGqTbh9NR6Oep2MJV2fe7y9qs/PunxZNaedQy8sLILg==
X-Received: by 2002:a05:6000:1a8e:b0:3a4:f6ba:51da with SMTP id ffacd0b85a97d-3a6d12db6d0mr2328685f8f.15.1750424888138;
        Fri, 20 Jun 2025 06:08:08 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a6d1190d13sm2038186f8f.90.2025.06.20.06.08.06
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 20 Jun 2025 06:08:07 -0700 (PDT)
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
Subject: [PATCH v2 10/26] accel/hvf: Model PhysTimer register
Date: Fri, 20 Jun 2025 15:06:53 +0200
Message-ID: <20250620130709.31073-11-philmd@linaro.org>
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

Emulate PhysTimer dispatching to TCG, like we do with GIC registers.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/arm/hvf/hvf.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/target/arm/hvf/hvf.c b/target/arm/hvf/hvf.c
index bf59b17dcb9..5169bf6e23c 100644
--- a/target/arm/hvf/hvf.c
+++ b/target/arm/hvf/hvf.c
@@ -187,6 +187,7 @@ void hvf_arm_init_debug(void)
 #define SYSREG_OSDLR_EL1      SYSREG(2, 0, 1, 3, 4)
 #define SYSREG_CNTPCT_EL0     SYSREG(3, 3, 14, 0, 1)
 #define SYSREG_CNTP_CTL_EL0   SYSREG(3, 3, 14, 2, 1)
+#define SYSREG_CNTP_CVAL_EL0  SYSREG(3, 3, 14, 2, 2)
 #define SYSREG_PMCR_EL0       SYSREG(3, 3, 9, 12, 0)
 #define SYSREG_PMUSERENR_EL0  SYSREG(3, 3, 9, 14, 0)
 #define SYSREG_PMCNTENSET_EL0 SYSREG(3, 3, 9, 12, 1)
@@ -198,6 +199,7 @@ void hvf_arm_init_debug(void)
 #define SYSREG_PMCEID0_EL0    SYSREG(3, 3, 9, 12, 6)
 #define SYSREG_PMCEID1_EL0    SYSREG(3, 3, 9, 12, 7)
 #define SYSREG_PMCCNTR_EL0    SYSREG(3, 3, 9, 13, 0)
+#define SYSREG_CNTP_TVAL_EL0  SYSREG(3, 3, 14, 2, 0)
 #define SYSREG_PMCCFILTR_EL0  SYSREG(3, 3, 14, 15, 7)
 
 #define SYSREG_ICC_AP0R0_EL1     SYSREG(3, 0, 12, 8, 4)
@@ -1326,16 +1328,15 @@ static int hvf_sysreg_read(CPUState *cpu, uint32_t reg, uint64_t *val)
     }
 
     switch (reg) {
-    case SYSREG_CNTPCT_EL0:
-        *val = qemu_clock_get_ns(QEMU_CLOCK_VIRTUAL) /
-              gt_cntfrq_period_ns(arm_cpu);
-        return 0;
     case SYSREG_OSLSR_EL1:
         *val = env->cp15.oslsr_el1;
         return 0;
     case SYSREG_OSDLR_EL1:
         /* Dummy register */
         return 0;
+    case SYSREG_CNTP_CTL_EL0:
+    case SYSREG_CNTP_TVAL_EL0:
+    case SYSREG_CNTPCT_EL0:
     case SYSREG_ICC_AP0R0_EL1:
     case SYSREG_ICC_AP0R1_EL1:
     case SYSREG_ICC_AP0R2_EL1:
@@ -1639,16 +1640,12 @@ static int hvf_sysreg_write(CPUState *cpu, uint32_t reg, uint64_t val)
     case SYSREG_OSLAR_EL1:
         env->cp15.oslsr_el1 = val & 1;
         return 0;
-    case SYSREG_CNTP_CTL_EL0:
-        /*
-         * Guests should not rely on the physical counter, but macOS emits
-         * disable writes to it. Let it do so, but ignore the requests.
-         */
-        qemu_log_mask(LOG_UNIMP, "Unsupported write to CNTP_CTL_EL0\n");
-        return 0;
     case SYSREG_OSDLR_EL1:
         /* Dummy register */
         return 0;
+    case SYSREG_CNTP_CTL_EL0:
+    case SYSREG_CNTP_CVAL_EL0:
+    case SYSREG_CNTP_TVAL_EL0:
     case SYSREG_ICC_AP0R0_EL1:
     case SYSREG_ICC_AP0R1_EL1:
     case SYSREG_ICC_AP0R2_EL1:
-- 
2.49.0


