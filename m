Return-Path: <kvm+bounces-45389-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AD19CAA8AEB
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 03:56:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 279D41671AB
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 01:56:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19A8519CD0B;
	Mon,  5 May 2025 01:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="pUL3O0rH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0312191F98
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 01:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746410188; cv=none; b=Tv3/29wPK1sxTD5q0eBI9H9xoqbdA/kTu+iYEf4SfdOKZHBoM3ILsUy9GqSJfBvU1H4kNUHnfyWnLrGMLZYB739CI7f4O7OQfBvcP9qqwlLlxWOpDvknvPWMKu+TVBL5nh55eecTV/f+jWtx6mP0CQjGkzqGqLCfLpa2lpYytuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746410188; c=relaxed/simple;
	bh=Mir97e/6JX5vi+xya+rUZkM+xoWJX7+LGvuh4imK73o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gvbizAnkVDSxfsDUVi9XDD9iZsQy1Er0ntYGBiH+uvj5bNHT0pLy2vDPGd70oFJi6Xde8ohM3pn9SjjG9hqyLrrJts9R+23dUOHGadw7pAv4wB9ZXRLx5wz3b9zSVT4OYfcYnuZPRlUPJ5xZ13vmhZD/g3RB+t+7Okt5YMdpJSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=pUL3O0rH; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-30572effb26so3610117a91.0
        for <kvm@vger.kernel.org>; Sun, 04 May 2025 18:56:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746410186; x=1747014986; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nwtW3h2lhmGSEKiIMjkXffP91aavJQ5GIexA+kWESbY=;
        b=pUL3O0rH7ro+JEtXqp5bmRDptgMYtug5qb8moOsVuRMWL+4GeZ4DZti3xOQc4V9huH
         0YVMIvhC/T/a8NyGPa4x7LQ5PRhBxnIEVoSFKTSe0FyNjg+iFV4ldJT1WIVhyawDWRvu
         kXwhAvr95Dw3GvoEkO/8IpFd06emt8BELFr4MUBeoopl2b8OL1bPFHNtWZzdCsOVvdFk
         aDvxMoitvY49k4yCD7mSTmsL8fMoNLIZPhObsj/2dz5BlLY/f31veD5XsI97RbH0ICLB
         9zZ9RvQE4CVwS1FCj1AgC+xzLpp7rpnBK4ryR64TfPCG4xxuLY08Dzz4+HhKiwrQnpny
         ecvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746410186; x=1747014986;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nwtW3h2lhmGSEKiIMjkXffP91aavJQ5GIexA+kWESbY=;
        b=Nu/ecLuB+cItfB0cfAkBw430JQsjYols/I4UjrUDWNyyRgSwA0j9JkFL9K5ab5epak
         M0oLOXFiMkEKvMPF7SUdG8U/TTjvRjESUdoRoRivppzPAAVJZ3v8Fj68/QFLpcJ0Iw5w
         4lp8rnvzBs72Txbvg157vA6OviGn1NKnfxR7bKUWhHVykMHnmJ7pUVOJaLQzhVrYtvtO
         +AGe/1JpSRoBU3hmKJ9FcXJWhaCOl1YQuHvURYKi34mWB/lyPtn6vgdPkJ/py3OGll60
         T0cjm59KWtPZUDT/Y/NppRo0nA+BgC3pD6dk/ur2dfw7bLyHto9o1cXitb0h95JAPdpM
         gpyw==
X-Forwarded-Encrypted: i=1; AJvYcCW+snVlUQYag0h9T9AvMpDshNBb2pZq6d4UHzB+Te/9XFyg7dxfdVjaB9X/I+tjHinJSUc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yypw9hOhCOTv1n+xmWrMPWDTgCicAYRWewi2cBkvAFR3Do1eMxD
	kNLbRK8C7tplb1bgLKDaJkrNf4hoHw2ElocYgpvNRzGt0NUaJkpykZ0O9C9dHg4=
X-Gm-Gg: ASbGncue9cJqvoTo7n4IwpvP7wESLJ0uWDiVmDBTYAilFfRKgQ72Z0Zl1pq45ZaHkM+
	aOnDB8TRbx2a7HGHyJO/QTZi70NPd4zf+nPUep67EoWznctcz56vsczQUYM3+q28DsnmUDyOhTZ
	SGDHg24tUqm0Iv2anDZn3Fx+Xbgth2mjDk4K5xUsatfgtHPiLR3w5wampYZVsE1AtApvKHYNF7M
	2FY1y6QhGIr5PNqPk5PnYaf4DmqfdGuj6r3Z3XX7TEN+z5HWfz+I71uEaJ5jVTca2j9GCabei1A
	0ygNu11hirwmZjBDuygZ7KZs9D8DsRBNaIgnKGFd
X-Google-Smtp-Source: AGHT+IHKR+PswofdfKp0nxf06Jv71gPjzeL8y5qHvCFV+VW1IoKs729cDWlWpUQeBdcpCI9oplKMUw==
X-Received: by 2002:a17:90b:270b:b0:2fe:8a84:e033 with SMTP id 98e67ed59e1d1-30a4e5626f4mr18713516a91.2.1746410186079;
        Sun, 04 May 2025 18:56:26 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30a47640279sm7516495a91.44.2025.05.04.18.56.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 May 2025 18:56:25 -0700 (PDT)
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
Subject: [PATCH v5 42/48] target/arm/tcg/hflags: compile file twice (system, user)
Date: Sun,  4 May 2025 18:52:17 -0700
Message-ID: <20250505015223.3895275-43-pierrick.bouvier@linaro.org>
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

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/tcg/hflags.c    | 4 +++-
 target/arm/tcg/meson.build | 3 ++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/target/arm/tcg/hflags.c b/target/arm/tcg/hflags.c
index e51d9f7b159..9fdc18d5ccb 100644
--- a/target/arm/tcg/hflags.c
+++ b/target/arm/tcg/hflags.c
@@ -9,9 +9,11 @@
 #include "cpu.h"
 #include "internals.h"
 #include "cpu-features.h"
-#include "exec/helper-proto.h"
 #include "cpregs.h"
 
+#define HELPER_H "tcg/helper.h"
+#include "exec/helper-proto.h.inc"
+
 static inline bool fgt_svc(CPUARMState *env, int el)
 {
     /*
diff --git a/target/arm/tcg/meson.build b/target/arm/tcg/meson.build
index e3be0eb22b2..8623152a645 100644
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
@@ -65,7 +64,9 @@ arm_user_ss.add(when: 'TARGET_AARCH64', if_false: files('cpu-v7m.c'))
 
 arm_common_system_ss.add(files(
   'crypto_helper.c',
+  'hflags.c',
 ))
 arm_user_ss.add(files(
   'crypto_helper.c',
+  'hflags.c',
 ))
-- 
2.47.2


