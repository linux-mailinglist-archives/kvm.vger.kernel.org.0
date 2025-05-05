Return-Path: <kvm+bounces-45359-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A30C3AA8ABA
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 03:53:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 882D53A840A
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 01:53:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11637199FAB;
	Mon,  5 May 2025 01:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="n4cmesMZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C25A91ACEAC
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 01:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746409961; cv=none; b=Pm8LNQY8es+yiimmFFBcOqUchyGAjYGqC4TpH+g4bGHQIW0KRbq4PKk4WqDy8MLQzAftAmNrlMdKAs0Yd1YYW3UMKqwpQH1cpIh48zY7nBqfvyd4up1tdavxBHnMBZ2CTehn3l/4nxPdjtWTDyvg98vm63lo1ydWECmXbvChsDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746409961; c=relaxed/simple;
	bh=30HYw1I8aFdjg6SHuQTxQCRNvR/7AoVCDPUJgGhi7zc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TRO59rfECMfeU5OOG6v9TbwA1fmT73kmx8Jm83ptZWB+00W4lAJ7UKcgcjyjCcN7Ycla74rrPDqevbXVrHn3nJnfcTe5RU3PYUnTdkZHCJRAlwaFYYPoEygSFWQWmr5kZSUMpl1264XrtioiFQujwPKgFNDkuUQIMyuBvqP2KcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=n4cmesMZ; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-22423adf751so44547035ad.2
        for <kvm@vger.kernel.org>; Sun, 04 May 2025 18:52:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746409959; x=1747014759; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mduWzGcqrbCCMCYuVdtTD2ZBid0+LWN3eUl0cLQ5HO8=;
        b=n4cmesMZ1bTkPzXPgbABGie4npi9fTuEH8iqIN+OGljYQnnVz8+wsbg+wpaORz2mmV
         9hy1YfbeqkMGQ79Kg/yHb+7XgVs2oMWwcUkkOcbuuw39zjN8WwvQPxLD3BSHjr5b/s7F
         LUFz3/02k3y+VS3MdLtV6tBbMiX/hbV0f2X9saotwzHAlXNmc5c3sprsNbdRlZZTocgE
         t5svDtsY7SUsG5Ztm/uqdHKRCzyCvovAW5g+E47sIGRwWAB00k9oQRG3TGbkyc6Dx0EN
         HwlwHWhrV921sxNJxDk4JJNzoNmd6vXWjWYUdJlcMOMdEuaLWzChSn5tdzY7DTFyg7//
         6yIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746409959; x=1747014759;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mduWzGcqrbCCMCYuVdtTD2ZBid0+LWN3eUl0cLQ5HO8=;
        b=R4/7aSHSe2aWPp/w7yiTTiYIXa5/rMt0+fvQoD9TaVX8XR2Ci+WSkUdVlZSZDE/vWy
         mRfMhEYmc9eS0eFK8IcprNq+w08B5zdUkKIA0AGbjdwZtpzWkuS9wHZ5UFMVlgzoNPBX
         EEGrf6f8mpBlOhTwlq6aD793+rE/qpzT5FDMA9WjMkrhZiJBzB4nzYoU2nh070HRhTa8
         N0K6zOOXoX9cvHU2SZgiXzYY8qpXYs7vv8HUSq8SG/lG++mqSMPI3m0AAGFg75iC2aSm
         6D2Pz0GIOcRW64LS0u8jHMXfLkRKO8pzG4qndcbj1gnc+jootaG/9Ly5aiV6A0N1qPh9
         uHyw==
X-Forwarded-Encrypted: i=1; AJvYcCVJSwpIVR0MdjeHHj6VXm2fjPiO/u/uTjcj66L2TC2vD3phG7znJRIFU43vTi4EWEFeyjw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw1pxTPzViO9zuvkqjqP1iP5kN3niJlPJOmNLI4GC0PSgmDfqPz
	RCtQe2lhl+otVlnvH6qWXf74u8bfDRKzAHiI7BHHo2Th2xqxoOd5Fz2JTIn4ntk=
X-Gm-Gg: ASbGncsd2tFFK7HQ3JVQz8ioUs8u6f86EClweR+v9CMIBJDtiHIlRBwMAdORJuuPNN5
	gLoVYagqD5kUIJ7zvTmogVVJXSCTbeTHdCFZKVGlL2bQZEZmochuwWq3IyADj2ZhZMBh2rurbmg
	qIwbqyqWcvq+k5Ci9ZQcyPlrveeAor058gRuBjph0tmHk0mXOmQ59KLrTD1lM/Ar655epQkLMP6
	lBeS2+bRa/Eu5lyVJUGkeEAoGCHRavfCFW+Jz9YTIOqKYruJ+YRYKphm7vpBNaTIWQMnUHw2rht
	XwsDhLtjO6PBOsPZNA/q50Fxf2CF25wXj3RJdkFm
X-Google-Smtp-Source: AGHT+IH2XYPu0agU5NsK+ys/z2YA1Zwc0j1DLfKUy1KfhckHrNgq8q2AagzIWxHqSSDuA5GNwLG8hg==
X-Received: by 2002:a17:903:2283:b0:224:910:23f6 with SMTP id d9443c01a7336-22e1037eb17mr163332895ad.45.1746409959031;
        Sun, 04 May 2025 18:52:39 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b1fb3920074sm4462101a12.11.2025.05.04.18.52.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 May 2025 18:52:38 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	qemu-arm@nongnu.org,
	richard.henderson@linaro.org,
	alex.bennee@linaro.org,
	kvm@vger.kernel.org,
	Peter Maydell <peter.maydell@linaro.org>,
	anjo@rev.ng,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v5 12/48] target/arm/cpu: compile file twice (user, system) only
Date: Sun,  4 May 2025 18:51:47 -0700
Message-ID: <20250505015223.3895275-13-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250505015223.3895275-1-pierrick.bouvier@linaro.org>
References: <20250505015223.3895275-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/meson.build | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/target/arm/meson.build b/target/arm/meson.build
index c39ddc4427b..89e305eb56a 100644
--- a/target/arm/meson.build
+++ b/target/arm/meson.build
@@ -1,6 +1,6 @@
 arm_ss = ss.source_set()
+arm_common_ss = ss.source_set()
 arm_ss.add(files(
-  'cpu.c',
   'debug_helper.c',
   'gdbstub.c',
   'helper.c',
@@ -20,6 +20,7 @@ arm_ss.add(when: 'TARGET_AARCH64',
 )
 
 arm_system_ss = ss.source_set()
+arm_common_system_ss = ss.source_set()
 arm_system_ss.add(files(
   'arch_dump.c',
   'arm-powerctl.c',
@@ -30,6 +31,9 @@ arm_system_ss.add(files(
 ))
 
 arm_user_ss = ss.source_set()
+arm_user_ss.add(files('cpu.c'))
+
+arm_common_system_ss.add(files('cpu.c'), capstone)
 
 subdir('hvf')
 
@@ -42,3 +46,5 @@ endif
 target_arch += {'arm': arm_ss}
 target_system_arch += {'arm': arm_system_ss}
 target_user_arch += {'arm': arm_user_ss}
+target_common_arch += {'arm': arm_common_ss}
+target_common_system_arch += {'arm': arm_common_system_ss}
-- 
2.47.2


