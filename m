Return-Path: <kvm+bounces-46224-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 51303AB434D
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 20:32:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 038DD7B8C2C
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 18:18:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58C22297B6D;
	Mon, 12 May 2025 18:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="wlfw4hv+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 153B02BF3CE
	for <kvm@vger.kernel.org>; Mon, 12 May 2025 18:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073134; cv=none; b=O7t9CSOfGM1501bk4wMWi6PYqWU4bdrYwJbrVg5QGDX/LcMZY7r/PUZdmnx50/wAUn6yUG+zekMZ/29QuEUGwJ1HoUetguxPfpDt4YZgtrlJA0Dizjz0rltWzKI12HzL6fAMET/UWyRouSm0JcoSLx8NDH3uIIkOUt4E+RxUJdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073134; c=relaxed/simple;
	bh=0ND4mB9JS7urQpEVchws9S6EzmrvFhsdvB7VUnUD0HI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LXkoCHMEZQN5jPFufJcx9HJr806mx0HEZOB3bCMT6XzWF8kS75KHVF4YIiILORlsxLGk2HaVl5iyRsp53mRZYS34ipOwfVXIDQ01KGyM2G9fSsWRabj1m3utuxyzwf76NI68JLyjBobFfJP6ku+ooX3pIUi7uypYA9aUZ4+vO0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=wlfw4hv+; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-22e7eff58a0so47382255ad.3
        for <kvm@vger.kernel.org>; Mon, 12 May 2025 11:05:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1747073132; x=1747677932; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4DYtSZEbP1atLGb677pRK4UuiMz1CYlbqC5aWBJkLTc=;
        b=wlfw4hv+2euvLIOuP4D/BF3cZlDITxtnGNbr6v+E2xdwJB0sCOIJvt5tu/fRM3DskI
         GXFP+31ntEetm99IVDGoaBhfCyKkg7VeXI9aqCn9QL1VTQNquu4pvAwgLDEZabkTZL4b
         6mDjNCL2344XhguQb7+C9d5GYZ6RNugdzacJ3ImAeFfxjbdy5BvWqUMlktCaeI8MnH/x
         U7PVnibPOXZxdFfLEOM7d9pUxca/67r9tk7wyMlia903xmEl7XU2TGTd1qJ0+XmVB080
         KMYJ61whzdXALwyVC63gq4BXFTSdTYrIEA3ks6do/GmdPYoZ3C7tfwmxtya/Ew8gp2j4
         8uzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747073132; x=1747677932;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4DYtSZEbP1atLGb677pRK4UuiMz1CYlbqC5aWBJkLTc=;
        b=iFpgpDT0pN3wNZ4yp1Vv/yAoX9NnWL51pG3Ux9GhPtBnkxpZZpFf3dGL+3btCNSG01
         m12Jyod5iwyQoIFkARyPovd3agrw626cudsRAmCNF/ZCO3/ssgnCRN78ir9lE/9ckFcP
         kBscxk8P9PPk/iWkhYi8fpnCk4fvl9y92YnxQEEGQ+jMWjfubHbIjWLwWHh+HTand1b6
         bX93rliTlCKgpZJHArKYBv+BmsFsTpx9D5eInTdOdB3W3I0oLLUNoKrPr1EwxCP4xWrR
         bCBYXeuwksyUM/4qGmHqBI8lwWKlA0gr3N+gOKRWuUGadw27moq2ad2uuNiDRATKyP/m
         DZ5A==
X-Forwarded-Encrypted: i=1; AJvYcCVk606gjmRgfYKg5bWlNhk7G13/9GE3rMtOPSODoc6HPMSUrKhNWpRY1U269udAGiIn7xk=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywc6pQGggeRH6jrWTCXY9U3oWZICnr+G4tduOztZ9bCaBWLcXcZ
	1eeuKSifHSa2IxMCGLbhKLdlourKxQuAIPsSLOqQEAsakfC5PGAMUhoINH50OW0=
X-Gm-Gg: ASbGncsgeh9dThnjDyoqsCWOJH/bhPrxHdVX4Iovx2t3VqNWJyi1K2O3SuR97/9t0E9
	ye9UPQ0w1hwu0NLVHk+9vuyZhcIdcuL5+/736jmNWwonbIc+kzk2oohShYOhPPWoLG9B12Prrbk
	V96TIIh/PvwUbJk4lHSL3V6kedguBBMvN6H3EX9DKEV2VhfjE9E7GDCC0X9+/a1bjyQJ/Njps1W
	2ElURRwf/pTULxGPUF88KUXKXc2u01Xabv2lqhXkkOQpGA3700dGBx+BQ08eOOkB+soFHseLS2B
	+01GpeN7x3QHJZfQGzhgXnC37/f87DRTX8TrFRYxT93CYeiH+6g=
X-Google-Smtp-Source: AGHT+IEUchA3BCwBh+OJ1cNAY6I61vJmEW2d9AGpseNu/E7o6pb1DxCo2KJeldjr8AJ2t8R3hCpqEA==
X-Received: by 2002:a17:903:40ce:b0:22e:4a24:5781 with SMTP id d9443c01a7336-22fc8b79590mr203976175ad.30.1747073132481;
        Mon, 12 May 2025 11:05:32 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22fc82a2e4fsm65792005ad.232.2025.05.12.11.05.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 May 2025 11:05:32 -0700 (PDT)
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
Subject: [PATCH v8 23/48] target/arm/helper: compile file twice (user, system)
Date: Mon, 12 May 2025 11:04:37 -0700
Message-ID: <20250512180502.2395029-24-pierrick.bouvier@linaro.org>
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


