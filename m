Return-Path: <kvm+bounces-50086-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E035AAE1B9D
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 15:11:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F34507B0CD0
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 13:09:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E4A4299AA4;
	Fri, 20 Jun 2025 13:09:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="d5o5hp6Q"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8639728DB67
	for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 13:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750424942; cv=none; b=VvqAU8rXA/1U47DYfGPMx8/k/bE/UtrxlUuXAoeRna68oMfBK2nDrabg8VvuSsJtPVPTLZDDI4y84Yiuz6z18dthd2/t8mvJW7syUbliXFRoV2hMBUfincuTl0WQ9pztXaN1eUKTO/Njm3YiBGP2a5tUgz6ifYYnLOIZqaaYkQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750424942; c=relaxed/simple;
	bh=doxYbh0zt2vAz9zNhMC8uVEWe9GJwNB87TM7zeshE1U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=f7Joz9RVyPARcMtvRDjT8X3bklGtb/9bE+uOXExuQqUmP8+CjM941E41ozJ8Rgmz0YmWNvAw0I1SbWkdD54pFsAnh+JXBhaj/F5nLiwdM0/U66itbwhd3Ji/CMOJn5jwiSrZnc7uCPdGAAZetxHvdHpEsVDR4GZl3SZIJjC73KQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=d5o5hp6Q; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-453643020bdso7371965e9.1
        for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 06:09:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1750424939; x=1751029739; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CoTleeCUcvYndolgWSxVbjuEBw5fGt+mb1nmRFlbWPU=;
        b=d5o5hp6QH8WdvpkKr+8iZh0AM6lfclIRxMzz8di/5VIok5aYXoxpS5nmNRmUP4Kgot
         UOBHkTZ7qYaRMsX7BFi29UaYmKQC+ccMa99UOj28ALeHUK3DWzEM34JPmnzgBNjPIbiN
         ZH0tMcVv6gWMXumZp1Ry8wKcevhjsrHybGFfaqKVNrOwQhoUtzlsrIUyYJUt1LbJtAp8
         pZw/160flZlmxapeLNg+2DGfADr8vUCjLEvxwqoM1kbAN3eMTph8xsEJxwUcrRK4KsWQ
         a+q0SOvZxpvESFZW4IxgafpfYmZaAYiHvMiVbhWU66XNCIGhVcvMXsmP1+e8dXi5sVyL
         nlrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750424939; x=1751029739;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CoTleeCUcvYndolgWSxVbjuEBw5fGt+mb1nmRFlbWPU=;
        b=JZIjhkY3s1PthhO/71ovZI9lKGyDlTGa/AWC8Q4amDwA/uNxN2X9Gyo+yWBQPM7YwB
         QsdbSNZYF8pHKq4lHVxnjT8HbOP2aqMmcvCxpeafNXfEbKv2mSR14sOEuvXqAWcPWOYR
         hpFx9a0VzxJaB0PqHwffz7QoVtLpaSgXovclKAR+dby6m4CG1eQ/OP67oc8kBCBKWNZu
         yQnHD1itEaDYprZMLSin7oYfIbRUqGmqoM2tD7c0pO5xxTDGdCO5+LMwGfc1BXYsXN5Q
         mC8HQentioYHySdZSN9oxYkRDdoRgMC5s2gUQaOtvP3zQUnd9Kn03DFgP8Qx5m9DQFFL
         RgjA==
X-Forwarded-Encrypted: i=1; AJvYcCU8Gzoi5/f03u56mPCLsKFIEysjZj050k1dcjjpyE6r1SuE4mDDL3IM3ZZszfv595ozZaE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxEylQaJ/qPPr62IOZDGfXcIJdTxoNlwPuV2CpEpdSr3TxN3h9b
	NXOlVv78lsC3oKdoHbQRrVbOSqh0hlrZRGHGzUzNOZmp0UUVKm7y0PttOdXEVta/dRc=
X-Gm-Gg: ASbGncvaEk4ChinO7tQMS0N+2pLmdrmynMctitlbB62/xkoF4Alrk3/yaYi1kTN3pgV
	5dqCSccSdHdySz+jGr8rCsGG4dHq7rXZDoIFi3RG3ZTxQXOynHpo+mb2G1kGvMLaKxikAMkuplZ
	bI1bdBZVBbfqR1ttkU3qPorRELCr1CgLhvDosk23jSdUPB994hM5f+WPlzw2h+hSx97D8iT5Gi2
	dl/yfp0q7XyS1P3udokxYR8AJI9BEZAMLry+r6wKSRaLCaun618CAo8DkkEOkHGjZwZiy3+duRa
	VTcA1ptMrBx/XyMiuXHJ6vLQwYNImAv0tAyA06/XPdIdepe+oOxL/SB3113qbx0qxjyAB/uz39w
	nXX7Q5wKmH2H0VhrAsV0Q29uR1n8XNCFOZlF6mKJDPcVgQTw=
X-Google-Smtp-Source: AGHT+IGuIbYoqiAUyyTvRzRx4XiSdr/lFqQmEELQqzVAO0UNUSoo47/0fUF0+MkjrXr0XzUJRZQK0w==
X-Received: by 2002:a05:6000:3103:b0:3a5:58a5:6a83 with SMTP id ffacd0b85a97d-3a6d13013eemr2649039f8f.13.1750424938708;
        Fri, 20 Jun 2025 06:08:58 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a6d1192680sm2076203f8f.95.2025.06.20.06.08.57
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 20 Jun 2025 06:08:58 -0700 (PDT)
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
Subject: [PATCH v2 19/26] hw/arm/virt: Only require TCG || QTest to use TrustZone
Date: Fri, 20 Jun 2025 15:07:02 +0200
Message-ID: <20250620130709.31073-20-philmd@linaro.org>
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

We only need TCG (or QTest) to use TrustZone, whether
KVM or HVF are used is not relevant.

Reported-by: Alex Bennée <alex.bennee@linaro.org>
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 hw/arm/virt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/hw/arm/virt.c b/hw/arm/virt.c
index 99fde5836c9..b49d8579161 100644
--- a/hw/arm/virt.c
+++ b/hw/arm/virt.c
@@ -2203,7 +2203,7 @@ static void machvirt_init(MachineState *machine)
         exit(1);
     }
 
-    if (vms->secure && (kvm_enabled() || hvf_enabled())) {
+    if (vms->secure && !tcg_enabled() && !qtest_enabled()) {
         error_report("mach-virt: %s does not support providing "
                      "Security extensions (TrustZone) to the guest CPU",
                      current_accel_name());
-- 
2.49.0


