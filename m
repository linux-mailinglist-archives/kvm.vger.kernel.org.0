Return-Path: <kvm+bounces-50068-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 90510AE1B6F
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 15:07:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 310A34A556F
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 13:07:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FE8F28C2D3;
	Fri, 20 Jun 2025 13:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="QUPK6Azp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB5FE28BA91
	for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 13:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750424841; cv=none; b=CSaWh0ipkDl3M3mUBNtlUCDjyr+UTwII+ityOkPNm5xzHuJ0nwEPciT/kZo1EQ8hBdfNsJjv1W8wNJ4X1HG8izJ/rnzK1WdWjAttDD0fFnEtaUFUkXqRVVO4RM3YO8rmHwJCBhE4mjvlkMQXvifGVFkcchvfZ0PXVpwcupSktcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750424841; c=relaxed/simple;
	bh=FTwSWjOPlPh4iaJMiPsYNpGtLFmbjl7PADR7lJI3274=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VcHy9G8YT/cXDscRbdYANqIIjjvsQQ/XnNDOow8CZUkdB7YiQhP78dHhCXyjIRrGJ3zrT2yfc2M37XCytBmtXwxvtf2hBJb6NUUkEIH6WzOpTTGG6aJ5F9GhzMd/0Z7ZBmBi5PLy1oU3TluvhVi6a2qDnFkTl4xUqXExFQKkH8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=QUPK6Azp; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-451d54214adso13796235e9.3
        for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 06:07:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1750424838; x=1751029638; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tBZvBlUJJ4ZZzRhwp1RRYC3txHSba+iTcUIOSqbdq4E=;
        b=QUPK6AzpBIZRFsRozqU0JFIKDtA7rlgzIQF0VzAvNLv1LoHLSio/1JnHO+tw6dr49Y
         qsWBeNgcZYDKGdaRlRMaA9GQ5g8IfzBezq1tXasA6nls/EhdNfcTQQrUvuFhJ9+GCMtU
         cyrH9Zz0jlX1rljOIJNhIqJH5zFX/LbUzEpCb8ng+MGz3/MOLc0mlT25dL+hD3ijMnrS
         qVcn09pkP014tahFvtRtzCDjV+qMqJ3SNwZII2vEnvBmEIJX/TekFDVAP3zAI+bEwcSK
         rBS75/NrHI4k+IvKCA1T4YwEFjA6ziNT1tu5N5hb3UHczbmJ48xLMu+BHKROk+nIolca
         JtEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750424838; x=1751029638;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tBZvBlUJJ4ZZzRhwp1RRYC3txHSba+iTcUIOSqbdq4E=;
        b=dDq9ZjeYmboCj7B5Aa1PKVMvQCTSqEJ3wtv7q4qmhAEsiTT4o/9+tWn+yO0TRuKQwQ
         XnLrFjj8LoLjWeiHtreNQmKJCpV1tS4A2uvbKcEj/U8Dw5lQKfUJzXoT/V2AiYiaBYoc
         SDjUJAwLQwo4vITJ0kmLHf0bF13O8QfytQzgwdky2b33AYPso4sP7a941O4OB6/a1t7E
         7kTudchXcAnK+xY9jHnEbuEfS28hNeZdwDbjrVnEuixcqMKtv0QRNSws/FIreeNDnMXO
         qg4H8H9RSAKV1qSKQs3QzDleDsxQw2EDUVA4CQvO/EYP8GGkfnd0JNVctI7J3j08o/LL
         Bf1g==
X-Forwarded-Encrypted: i=1; AJvYcCXAVFIx/1ihjwxWJUKHlt/Z7Ckp9NHYvyeD2jSMizDVDqXPP0ALNhkQcqLxP6NKhntMsGk=@vger.kernel.org
X-Gm-Message-State: AOJu0YzMi6E/u7cXJM/6FLkfHp25BEEZnMTjqRB48DGXV8qM7y5cAFGO
	62MTNdQQpBgMXdJwz9yl7c0TUdVGP56AtJXb/UUugvR905mCZXQi/bogjb2UtKs/CU8=
X-Gm-Gg: ASbGnctwnp0R1t64LJi7X7Iwhsuf+IxjwLoQ7D02K41EIbTJg+B7y+nntjpWkxWWcfZ
	3ao3KaCmpOnVu47+cguFY7s0H2MruIfdJ8EndSrA6Z2E86NCG1h0UpiPmdop1iCg+71rjAHO3cR
	QQdpJPYg/EoeSpuQzfwjQyaETeP7XRSmG246hGyjGGtLRutvgWEXKgjwdJ7F7FSBMYlg4QGkzBF
	1fSohyeTR1ASYfp2yV9mLWbUx1VqkU2YNFXDXjSy4aIiosrCzosG5cwt8pbK8d+2vSUzCdx8XZU
	mjGFu9XXFM8osbyaAleMqrVO624N0cfJ9+n1UKQxaTtx8d1QrEY5m6A3forO3CMZHMDLpVTPtYo
	8WZjbvWko4SsCltVB7gDVpGID3haZ78Objwcv
X-Google-Smtp-Source: AGHT+IHkCPt6KL3uT84KaXQEf8w6Zl9aLccw1KatAjKZiNkbl+svh0rrY7kI5cIzTp13dZSGCGViFw==
X-Received: by 2002:a5d:5e09:0:b0:3a5:39a8:6615 with SMTP id ffacd0b85a97d-3a6d12fb239mr2292246f8f.11.1750424838047;
        Fri, 20 Jun 2025 06:07:18 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-453646cb692sm25426765e9.2.2025.06.20.06.07.16
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 20 Jun 2025 06:07:17 -0700 (PDT)
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
Subject: [PATCH v2 01/26] target/arm: Remove arm_handle_psci_call() stub
Date: Fri, 20 Jun 2025 15:06:44 +0200
Message-ID: <20250620130709.31073-2-philmd@linaro.org>
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

Since commit 0c1aaa66c24 ("target/arm: wrap psci call with
tcg_enabled") the arm_handle_psci_call() call is elided
when TCG is disabled.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 target/arm/internals.h | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/target/arm/internals.h b/target/arm/internals.h
index 3360de9150f..5ed25d33208 100644
--- a/target/arm/internals.h
+++ b/target/arm/internals.h
@@ -650,16 +650,12 @@ static inline bool arm_is_psci_call(ARMCPU *cpu, int excp_type)
 {
     return false;
 }
-static inline void arm_handle_psci_call(ARMCPU *cpu)
-{
-    g_assert_not_reached();
-}
 #else
 /* Return true if the r0/x0 value indicates that this SMC/HVC is a PSCI call. */
 bool arm_is_psci_call(ARMCPU *cpu, int excp_type);
+#endif
 /* Actually handle a PSCI call */
 void arm_handle_psci_call(ARMCPU *cpu);
-#endif
 
 /**
  * arm_clear_exclusive: clear the exclusive monitor
-- 
2.49.0


