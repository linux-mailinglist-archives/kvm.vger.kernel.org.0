Return-Path: <kvm+bounces-45319-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C512CAA840C
	for <lists+kvm@lfdr.de>; Sun,  4 May 2025 07:32:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BEDA0188F564
	for <lists+kvm@lfdr.de>; Sun,  4 May 2025 05:32:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C40DE17A31D;
	Sun,  4 May 2025 05:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="EIjnAAl9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 874C71A5BAE
	for <kvm@vger.kernel.org>; Sun,  4 May 2025 05:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746336585; cv=none; b=H6Nmd0PEqeYbz3I3sTMC8/RyV/P9nT9Bwfx2Sevg/3EJUV7nSwLS8L5D8yOv2DCKG38dry95WEldUi2C8sjHBDR1bakt9CkFIJ3wFd8fc23JJbaKIXP9CoNmTffTqE32Mn6Tvws0aZBbDO1L6lDZoMLm5uBMYyx2y7K8jTL59+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746336585; c=relaxed/simple;
	bh=rVRDTbWWEqwgabZa5zWcVeyAjZSJEYR9LpoFB4OvRA8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XRuFRooDCrJxqkBVN1l1LU35klemCzu9yonFnC+kROiW7E5Rhu4X46+fBOihAEREpg8peG97UCwUySFeuAOcJHZD076BHtHU9O0Ev8N3y61fgJDsffBW9fQJ1o+Rz79est+/OaD0zYPSMkI1M8pHRGo2Y8Lm4/rVDt+7WavhVXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=EIjnAAl9; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-223fd89d036so38307755ad.1
        for <kvm@vger.kernel.org>; Sat, 03 May 2025 22:29:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746336583; x=1746941383; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d146Pj4KjTAmT+769pG7plO/J3O67dCMeGHKPEFKjBI=;
        b=EIjnAAl9CyR3I1Y1IFaexfLuqB7bitG7U5o/3K5U2Y/gbqTlYC89tw3BdwmhiX6IDF
         F4y4yNFb5R1HhdkDrMW4rD04orCvYY45LbOV7jMqU0H2Jfkvx+0Uhp0IoAWRzk5/h4m0
         XscU4685qUQmuWzAPAhjjCof3c/Rjv2taIGNImKsZhmDcGFSwov65G8YUPpUVssL5zj3
         azMCscr9DezEip5V2NF3UG/UHEtw42tLInjJ+Vxw02XwSqd45PeeHnzEgQI+/wiVBal9
         VG11T2X/efswlrE5FoXb/HRFtPUbcDeFTQRoL5g1bJVYQW6f1E6fKJBwFT58aDYiSlhI
         G+nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746336583; x=1746941383;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=d146Pj4KjTAmT+769pG7plO/J3O67dCMeGHKPEFKjBI=;
        b=TipxvIaDbAD3GW8Zf83ek3Vph0PwknD7hnJEnekIt30aSoG9tQwD5P7a53G3ullKdQ
         /jQGn8n0QC9afuRnKzuDXLcH0uqZXKy7RlxZtSJvDzcLlTCG79CLE6wGMhOwItBTLV7g
         fxdCC6Vvxi9I354tzUOLh6LnOwEPGLmgqzyPAL9U1jGyVgYMGlzv5uVnLeWHWtU5YzGH
         PWi4c/T0HE16EvHGaW3qE683GsIG958LrKFCzQvy2jMtZOiiWcLx6/DqZr8AUZtnL1xd
         JKme6zepk+TDh6yXm3ZD0ZbrAQPSnPsuoGcaNZN8cbbVO2ZShBHhLXhzobN4oSVUsTrX
         H4bA==
X-Forwarded-Encrypted: i=1; AJvYcCXwJWOOGsJxsh+oKnElctrRPV6GdtPWOjINOog+r9DBEmcq5RlYvG/E4FTahWjrIGSR2T0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxxpOWrBuPdS76H5yhN8vFvvIHg6w3iZAeluM14G7usnsqB18dG
	ECpYYh/gAceZOf/gLKtzpQvi4sj0toEebvqD/rYPXWjy0GCsjmLe4SOUTTfsBa4=
X-Gm-Gg: ASbGncseXwX3rVfWaUEp3efkIqDmVpQXYvFIraYnSjyBc6tYSADhNvQXu9O6zAlqycX
	Ih3MGqdffWnt9A1usrw0DVqmZLb4YumeUGdrZFAeVu0Q+qABhW0Yz7ObV3Mn0yOusZlE8dCA1da
	TCIX4VUeUS9Km4iPom15hX4TeqBNcG0KWOXYnHzSlKzMDke+HwXR4j2BVItLrZCDGuWiBxzeeVf
	itQv4hFz1W0BgkUnLQHpX1mrkhzQ9U4NYqV8+IY8X/9SVkLVLbT1QmbqhMhZotbXfS6/ldfn9IM
	oJ8ayqXxvi/poETmR8ZdxxTQA9uQLHtp0PmS7jzM
X-Google-Smtp-Source: AGHT+IHuftjvx8K+lKIONTdQb5rUxohknLqdDXqhEx93QHw1TFnNfxBlVnv/CW1cZSPZujSKICoonw==
X-Received: by 2002:a17:902:d2d2:b0:220:fe51:1aab with SMTP id d9443c01a7336-22e1ea4c3c3mr50378075ad.38.1746336582911;
        Sat, 03 May 2025 22:29:42 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-740590207e3sm4400511b3a.94.2025.05.03.22.29.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 May 2025 22:29:42 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	qemu-arm@nongnu.org,
	anjo@rev.ng,
	kvm@vger.kernel.org,
	richard.henderson@linaro.org,
	Peter Maydell <peter.maydell@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	alex.bennee@linaro.org,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v4 26/40] target/arm/vfp_fpscr: compile file twice (user, system)
Date: Sat,  3 May 2025 22:29:00 -0700
Message-ID: <20250504052914.3525365-27-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250504052914.3525365-1-pierrick.bouvier@linaro.org>
References: <20250504052914.3525365-1-pierrick.bouvier@linaro.org>
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
index c8c80c3f969..06d479570e2 100644
--- a/target/arm/meson.build
+++ b/target/arm/meson.build
@@ -2,7 +2,6 @@ arm_ss = ss.source_set()
 arm_common_ss = ss.source_set()
 arm_ss.add(files(
   'gdbstub.c',
-  'vfp_fpscr.c',
 ))
 arm_ss.add(zlib)
 
@@ -32,6 +31,7 @@ arm_user_ss.add(when: 'TARGET_AARCH64', if_false: files(
 arm_user_ss.add(files(
   'debug_helper.c',
   'helper.c',
+  'vfp_fpscr.c',
 ))
 
 arm_common_system_ss.add(files('cpu.c'), capstone)
@@ -40,6 +40,7 @@ arm_common_system_ss.add(when: 'TARGET_AARCH64', if_false: files(
 arm_common_system_ss.add(files(
   'debug_helper.c',
   'helper.c',
+  'vfp_fpscr.c',
 ))
 
 subdir('hvf')
-- 
2.47.2


