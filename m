Return-Path: <kvm+bounces-46234-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 05C29AB4255
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 20:21:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 295A31B60FED
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 18:21:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 732E52C087E;
	Mon, 12 May 2025 18:05:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="un0cyi5D"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0836C2C0841
	for <kvm@vger.kernel.org>; Mon, 12 May 2025 18:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073143; cv=none; b=dDh8PykFU/CgGzkXyDNk7/ftB8o2Dgzju6JglWLDyfeblfQfGmIg4Sx/PSC1p1eNPLWl7Pdm75e+EVRtYnLRUugpnH8xKbcQGlL9HlRgXJis16fhsuA8l2QuG8R8UJd9oZEl/MZsFwPxxgILXUYBmuAzB8yuv2mOCBkYClrNLsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073143; c=relaxed/simple;
	bh=3RsKZ1Pgza19E1HBaBnLbv5wQ1rc1mFEhHbZHJJ5Hmc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qJu7t6mBcuL5BCiJbpWFRbXfLhySyBMAobNnb0SZUgGXTra+35Sj3oCpKSbGs0rxDHCFPZkU7Hfmi2TFYoK3iBebP4V+ZWCGymP2thEXZJbfHyzei3dMv+neXd7ADQH7mzXCUrrZcoHkWI0w+51ASegcIXHtJDueIbWaSI5Bsqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=un0cyi5D; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-22fa48f7cb2so44930235ad.1
        for <kvm@vger.kernel.org>; Mon, 12 May 2025 11:05:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1747073140; x=1747677940; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vzXXutq4wGalZELe39I44dxOL/4dV/vBf09UEOe1qt8=;
        b=un0cyi5DOjMseiK9IcEufVk+ozfWt3TJ14rNB82P695MYEh9Ni3jYYWZvZBXLfJ/sU
         eFTQsCpfKgmwEPcBVnTcaXypH2EWASZUh5qwt5O66UB/G5ccFOWyakM5dHg9vnVjC3X7
         /G+gxVq9W3HLTzjjuyLI4DHCrJ8eXoiTiJHcaCz9KlAMHUeKvUC4ahmK/3u4nbS4lkGM
         E16RnyW5+PZUt1Oa1UOOSPsBvmSqlHBmgIeObwVJIyWG6/rnBby+ob766inkAxQBX4dn
         z1NUBu52hganM/+uCrcD/kfRNgPlMcWUJJodYxDdRwaxdruN5ZQVRufsq5pKlK81nY3+
         lkLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747073140; x=1747677940;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vzXXutq4wGalZELe39I44dxOL/4dV/vBf09UEOe1qt8=;
        b=pX1gG+f+nyz+oPu8vMTEfSuaqc1b53+IjP7e10ke9eHgUdkDFsbxS82V2NJA2X0CgS
         CQ09RQBZiO3Ujdo+gCmDYba6X8x49v2tAt/XR6yJEcJteoJYD8WsfRcJAwJkI0cCCR3I
         u/n1qSL2K8z07g5cyhpSLJiuCqNxsJ8OMG9XtRD3EOmhIeYi6s8IZpRmPNr4yb3QxWVy
         oOqN0Dttg/Qq1z7iNrcQ1stu/VF3eLx52K9k7mH8VZI6m04xG65tWmHZlov4S/3Yd7Is
         7JA/LDKvcNZbPAW0QfRM7A7hPQsMmj12WflL25+6tpYlQpZooPDW6jjBOHRrJRa92xds
         g1xg==
X-Forwarded-Encrypted: i=1; AJvYcCXpV13tn3GCIsH+7tOVfwSybFKiR+0UoIg46YC+nzR2MbjY7gCuKhuFuwaEmFmySY7VdGw=@vger.kernel.org
X-Gm-Message-State: AOJu0YyUFzRLT2EjhYfR4HcyJOsNSvvnijZsz/AhLcRPlYuNzzoSbUz2
	+ka2AAsxmxSOg0kp5ltwKnaYMwXR31XRsiX5gb0c369NUV13n7bBBJ2LfWGFQuI=
X-Gm-Gg: ASbGncvy2fqHUpaVnhXz0R31zdZ4FidyUbjnlVGurU8uH4SR1eKMUCATou4KEmBjGPk
	WELfcZaV/hVLjq6zcib/n3G7NzwudQemRVPV3sPeGI/6BUTcz3Xus06ArtDAD+TynTfIQkvWEYx
	MHZGsq3Sse9h7lHCANh5dZ37jIR/ucSSaZ8Z1vQSE+2VPkhDOkMg4ij+iNikGx10QiFb/wnsHEk
	I6GtRhhAu7tovRMZDv5/E3zB3kkVyP1vsiXzTaUfzoLmf3IMQaRDS/JqsoFFNsg7dg4/Rdh/FdR
	ArgqvkLKqVgoM3FfsUVOGxFuZUOspwur/cTiUgmwFd5PssK8ss8=
X-Google-Smtp-Source: AGHT+IG0CawLMJdn+wU+zZfg2tvV/EMa4PCPpMg3XKBwK3dfhIPYvIf0gA0Oo+3QqdpakH4hlP6iRg==
X-Received: by 2002:a17:903:2351:b0:21f:136a:a374 with SMTP id d9443c01a7336-22fc91a84b6mr225854375ad.43.1747073140323;
        Mon, 12 May 2025 11:05:40 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22fc82a2e4fsm65792005ad.232.2025.05.12.11.05.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 May 2025 11:05:39 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	kvm@vger.kernel.org,
	alex.bennee@linaro.org,
	anjo@rev.ng,
	qemu-arm@nongnu.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v8 32/48] target/arm/meson: accelerator files are not needed in user mode
Date: Mon, 12 May 2025 11:04:46 -0700
Message-ID: <20250512180502.2395029-33-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250512180502.2395029-1-pierrick.bouvier@linaro.org>
References: <20250512180502.2395029-1-pierrick.bouvier@linaro.org>
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
 target/arm/meson.build | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/target/arm/meson.build b/target/arm/meson.build
index 151184da71c..29a36fb3c5e 100644
--- a/target/arm/meson.build
+++ b/target/arm/meson.build
@@ -5,9 +5,6 @@ arm_ss.add(files(
 ))
 arm_ss.add(zlib)
 
-arm_ss.add(when: 'CONFIG_KVM', if_true: files('hyp_gdbstub.c', 'kvm.c'), if_false: files('kvm-stub.c'))
-arm_ss.add(when: 'CONFIG_HVF', if_true: files('hyp_gdbstub.c'))
-
 arm_ss.add(when: 'TARGET_AARCH64', if_true: files(
   'cpu64.c',
   'gdbstub64.c'))
@@ -18,6 +15,8 @@ arm_system_ss.add(files(
   'arm-qmp-cmds.c',
   'machine.c',
 ))
+arm_system_ss.add(when: 'CONFIG_KVM', if_true: files('hyp_gdbstub.c', 'kvm.c'), if_false: files('kvm-stub.c'))
+arm_system_ss.add(when: 'CONFIG_HVF', if_true: files('hyp_gdbstub.c'))
 
 arm_user_ss = ss.source_set()
 arm_user_ss.add(files('cpu.c'))
-- 
2.47.2


