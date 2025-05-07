Return-Path: <kvm+bounces-45808-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 23DABAAEF8F
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 01:47:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 918DB1C02E51
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 23:47:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F1CB291871;
	Wed,  7 May 2025 23:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="x6VaE4vi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48D0E20ADE6
	for <kvm@vger.kernel.org>; Wed,  7 May 2025 23:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746661615; cv=none; b=G9EXzZaKSR65hYJUvOFuAE1DfWDj8UJXys5s0csYRq59kySwa8uwuSIdZ1qfjxbxPLQJdH5ZCPqfLmUxPqnhjS5uuHPM2Z4BZST9FB/7wvutp5Y8bLda+MubQqzj70PYCwn88MWRnjDJaYwTaiSEw2ojW/y3zm4mrDGUL9yIl/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746661615; c=relaxed/simple;
	bh=uXaB3hwAbzfSC1HxfR56hDPJjV76w4U3vHxihmJ2trg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sNbEKNCReot1atkaDxg8zXjstC29Fr6F/NXq76WV8m/WIHA2Yqxv0QbhfnfXgOFm2CTTsdQpc43nkLUR1wjaQ/DMAENXE3+oSGbOE0UdYSjT1hJwSn5SXWkzfMLP6iNF5iPxCe3mo0wHeU0N1jO6nG1ON7BjqsleC/ui5Dsd8sE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=x6VaE4vi; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-22fa414c497so1235755ad.0
        for <kvm@vger.kernel.org>; Wed, 07 May 2025 16:46:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746661613; x=1747266413; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jg06Y7bf5KiymTc5nVCG7BgUS7AMOOtDTvF6y7Zvpa0=;
        b=x6VaE4vid5UMCRYqPHsPkan8KM9FuA+Fa3R7NScvipcF4LM3VCx07c8C4Dqe7tNtI0
         UCb4NUVGOeUeUJwAiwD2aRdRJMIRPQPiA/Lvts2GF3YkFoNt01MvWXt/C6gVGIVcSrMD
         G5cYj/rFg2xiG6Rxo3Ny8h1E/41sHJa2HF1DmgNVlaYcfSeHEF7YPIHyQGoYAnxFBaW7
         hQbDUq7SFG+Z9KleJm0t+QiMzorq+NmJ96icU444jJDHFQpQYnCiUh+QHfLug49C/5A0
         x77eXsNufWl9Pf4oZ79hlmsQD6P4vII8pgXs1q+JKufbNzjWrhLtA7dT8WOGJxqII9s8
         GbHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746661613; x=1747266413;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jg06Y7bf5KiymTc5nVCG7BgUS7AMOOtDTvF6y7Zvpa0=;
        b=d3QvhBY1Rr9Glw/ZrZFbx8AqExNOx02BoptipC6J8Ts9W1L9nWCb8LWBjsWpOaPuoD
         evSZXZkVZaLWzDaOSJoWLWvwt63GvPSNHzNq1eYOIvMIDb+orq+w8LZIdrOjVWb5gDrp
         /TwnACQ4iMPHsmfcaPfkPHovmggXvs+fogM6AXvGWHy596w5WIHBogEaUvv2K6Wkb2TE
         Q1mK2Gb5Sf+EOYTNGWqqkLS2dgY4sjSCN4s8Ez5SqF3aZfU5MK8HwMf61pzi4pjfr9bi
         WvyhbFOnq7/3ZwsQX4TFdN2d3hRLCjIU6cRtKAHuDLyauy6OPd2Hou2u52cTCBNsOU+v
         fa0A==
X-Forwarded-Encrypted: i=1; AJvYcCWynTfAL6HQu3uMt4rMfed6TX3Yn6osmuWHqhR3AxjjFTgQ7X6p68zHOdoJ5t0ouGMYlbg=@vger.kernel.org
X-Gm-Message-State: AOJu0YxvTBKCGB+mw7ebuudnUlUGbAXx9QMUMh9/DISZtQu4SYrIMlXN
	SMWiGSaaAPEYaQhsPnBMjdSIW24QcbCBaG7FgYbqeFDLsvUvigQPKASSF7jd4xQ=
X-Gm-Gg: ASbGncu2iEV3tmAZYiKBRNr/Hl9MKNutnlZJI7QCoCm04RBtNwBkRM9djuUHYCZzClm
	oAwMB5WvzebOKc7lnHywBQPCpSg1Q9eQtxjtMMz0Aqu4+oIL7nmd0O3ksLNUPsBtLD2SP4c1HMP
	ap5cN7R0GqTFbadfjjDH+cnTtHl+s1qNEmBPoQB5Pji822YY3QIzjTcIuaNMyi1AETn9t/0A2HQ
	VIWsaZmJU+468ken6YC8bVDnlwJ0VcdASWoWvlctNgvf+a51BaqyirHj0O7Jxeh+de3kTy37Jcu
	P4UhI3bu0jgi9bLAqalJxEcaMTfOPtz8F/aFqpfa
X-Google-Smtp-Source: AGHT+IFx3IqBq3BMdslXcG7H1lDPhBPcNhNXcmyld4UJ174Kiz0M4FVxecE3zmVfYGRR5gVd3aFm3Q==
X-Received: by 2002:a17:902:e38a:b0:22e:634b:14cd with SMTP id d9443c01a7336-22e634b171emr48243855ad.39.1746661613583;
        Wed, 07 May 2025 16:46:53 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e151e97absm100792435ad.62.2025.05.07.16.46.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 May 2025 16:46:53 -0700 (PDT)
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
Subject: [PATCH v7 42/49] target/arm/tcg/hflags: compile file twice (system, user)
Date: Wed,  7 May 2025 16:42:33 -0700
Message-ID: <20250507234241.957746-43-pierrick.bouvier@linaro.org>
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
 target/arm/tcg/hflags.c    | 4 +++-
 target/arm/tcg/meson.build | 8 +++++++-
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/target/arm/tcg/hflags.c b/target/arm/tcg/hflags.c
index fd407a7b28e..1ccec63bbd4 100644
--- a/target/arm/tcg/hflags.c
+++ b/target/arm/tcg/hflags.c
@@ -9,11 +9,13 @@
 #include "cpu.h"
 #include "internals.h"
 #include "cpu-features.h"
-#include "exec/helper-proto.h"
 #include "exec/translation-block.h"
 #include "accel/tcg/cpu-ops.h"
 #include "cpregs.h"
 
+#define HELPER_H "tcg/helper.h"
+#include "exec/helper-proto.h.inc"
+
 static inline bool fgt_svc(CPUARMState *env, int el)
 {
     /*
diff --git a/target/arm/tcg/meson.build b/target/arm/tcg/meson.build
index 2f73eefe383..cee00b24cda 100644
--- a/target/arm/tcg/meson.build
+++ b/target/arm/tcg/meson.build
@@ -30,7 +30,6 @@ arm_ss.add(files(
   'translate-mve.c',
   'translate-neon.c',
   'translate-vfp.c',
-  'hflags.c',
   'iwmmxt_helper.c',
   'm_helper.c',
   'mve_helper.c',
@@ -66,3 +65,10 @@ arm_user_ss.add(when: 'TARGET_AARCH64', if_false: files('cpu-v7m.c'))
 arm_common_ss.add(files(
   'crypto_helper.c',
 ))
+
+arm_common_system_ss.add(files(
+  'hflags.c',
+))
+arm_user_ss.add(files(
+  'hflags.c',
+))
-- 
2.47.2


