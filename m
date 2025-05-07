Return-Path: <kvm+bounces-45790-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FE40AAEF75
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 01:45:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8AB1C987066
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 23:45:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31DEE291866;
	Wed,  7 May 2025 23:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="PDpBIbMe"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02464292932
	for <kvm@vger.kernel.org>; Wed,  7 May 2025 23:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746661386; cv=none; b=Y9D3EV/v2/zGdaiqic/dZL7Zs6JiMe+2bodB9EgZIqpourVjUjPN+NKL5ScyoIqvUYjTcFFA5nE4hsV1Gh0UA9fufi9N9Oc1blEOQxHnrxCMTUNcvL/jmzUOqOCo3IcG93n25sel3AQfthmIVs70feAz5xN1+VpVJ1sp8R+aCf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746661386; c=relaxed/simple;
	bh=0ND4mB9JS7urQpEVchws9S6EzmrvFhsdvB7VUnUD0HI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mnA0sBV7vhgMQMW3TvTUD2hgTckvL3Q6btZVPw/qdxlfthbjTbknwq9AS68UQ2E/xe5ezC0yl1H1Blq7MDVdPW1Vot7YaJ4JHXqCXEbzD5YWqLrhtLp6YUw8UILSmMhmpKze0ZmxjbGEBUXMfKGrwwI7u/w625afTeXG8Fn3D+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=PDpBIbMe; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-22e45088d6eso6689885ad.0
        for <kvm@vger.kernel.org>; Wed, 07 May 2025 16:43:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746661384; x=1747266184; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4DYtSZEbP1atLGb677pRK4UuiMz1CYlbqC5aWBJkLTc=;
        b=PDpBIbMecY7uygdmB1R9NrrVpIblT+sBOgcszswW8q9FkI9jxW3fDKqTyeI/1VY4xf
         NkLQmewJU4ZHXfp/wL02L6R/nD/NkTRhooVkhhyTHiEFwGNOqHSHsCM0P4pVsJ/qH+Qw
         AtSXfA9DrNvBZaq5OqJEwV8WfjXK5GxCqmo7SZaFcZGMTwUn5V/aTPay10HsgYHeiyGM
         40eNuXKTrgUXAnOowavs7g+BudUtD2vhDqXxwiWnyww2esLOPFMogTRj1ig8D0xs67Pu
         WO/Q1RxDC6cSkuuT6xdq9lmOqlDNevY6RwdoLM3VsLRR5IB305nwZM0ZZUPuTI6fELH3
         1ung==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746661384; x=1747266184;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4DYtSZEbP1atLGb677pRK4UuiMz1CYlbqC5aWBJkLTc=;
        b=SYf0Br9+mLn6LAIJVFQPC455WkkP+/k7akkzMIuP4hpl1fV1npUibd6Qiec49wi44q
         50kAVyVoVLpNLwNUaXGHeSFnQERjUDj8R51OsC/H712/pDyX5EwUuzHdELMVVXpQx9aQ
         pE1bcn0dm1VxgL0utPMP8JP6fdX3XfdJTMltvlS9Z9EOF0i0Q0TADoIXuvT+UeZsEbun
         ICshR89yc8MQwpJnwdRhViw/up0aeACsJCFmeO1KsQP+dXQFRUnoMW6AeG3Obr/RyHSf
         aZJgT6UXZ8vbNWpPS8CzyN8EInkIw5Jz4v3XDjysf8cvYkflJHvxqb1nMuyyScCUfe/S
         Q6tQ==
X-Forwarded-Encrypted: i=1; AJvYcCWW2j6I6HHf3bquM4QJmsItNF8B78yfDaNuVluYCV7UD6Waih8R1gRe7wdsIiKiOZlcwug=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy5a9TtkN8MLYm28bvVqrKezBI9E6UHcO+KxGIJyGk8Qv3DRlhU
	MX+N70sQpl1dZ/i3PTQ6SqGtJubBbD5bvmfM4R1QhDEip/w5v7ZGOJVMyF/7fu0=
X-Gm-Gg: ASbGncvnhkr609efJLLvFbz0MVBYzx1I3wbzac/hlZ0RtOHNG+0h4mfykRfSBxiZJ29
	d1Zi97LUUGbIEkwR1yVa/unnvofjb5bzyUc2KG8Xnp+oxH4hm8uLuoG86xo8tLFQixQuHwzXku6
	Pxr/dBKqb4lQ/SUiL8UjKLuuzoNR2hWerNJ7Iwgez/l+Cs8DbqbxOkNaC0RpTzx2dMef1Ey9Vdh
	S7y3aK5cHfOU4+hzWMtv/YsM9Z8Wxy24geRJIPY5nygKD+UFSo77KwoOCLTN8X7NxlllveZpC70
	ZtRPQglbpLSsQhqh60mM3GztjZdY/UF1wAnvqUf2
X-Google-Smtp-Source: AGHT+IHBsVE+hlS2uD6FYqTOaq37pTfP8GERyb8nhVUO8aPu33fEdCr6kj7WpBfV+u7FbuN+nl8ukA==
X-Received: by 2002:a17:902:e88e:b0:21f:dbb:20a6 with SMTP id d9443c01a7336-22e5eccc4e5mr70654935ad.33.1746661384268;
        Wed, 07 May 2025 16:43:04 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e815806fdsm6491325ad.17.2025.05.07.16.43.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 May 2025 16:43:03 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: qemu-arm@nongnu.org,
	anjo@rev.ng,
	Peter Maydell <peter.maydell@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	alex.bennee@linaro.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v7 24/49] target/arm/helper: compile file twice (user, system)
Date: Wed,  7 May 2025 16:42:15 -0700
Message-ID: <20250507234241.957746-25-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250507234241.957746-1-pierrick.bouvier@linaro.org>
References: <20250507234241.957746-1-pierrick.bouvier@linaro.org>
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
 target/arm/meson.build | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/target/arm/meson.build b/target/arm/meson.build
index 48a6bf59353..c8c80c3f969 100644
--- a/target/arm/meson.build
+++ b/target/arm/meson.build
@@ -2,7 +2,6 @@ arm_ss = ss.source_set()
 arm_common_ss = ss.source_set()
 arm_ss.add(files(
   'gdbstub.c',
-  'helper.c',
   'vfp_fpscr.c',
 ))
 arm_ss.add(zlib)
@@ -32,6 +31,7 @@ arm_user_ss.add(when: 'TARGET_AARCH64', if_false: files(
 ))
 arm_user_ss.add(files(
   'debug_helper.c',
+  'helper.c',
 ))
 
 arm_common_system_ss.add(files('cpu.c'), capstone)
@@ -39,6 +39,7 @@ arm_common_system_ss.add(when: 'TARGET_AARCH64', if_false: files(
   'cpu32-stubs.c'))
 arm_common_system_ss.add(files(
   'debug_helper.c',
+  'helper.c',
 ))
 
 subdir('hvf')
-- 
2.47.2


