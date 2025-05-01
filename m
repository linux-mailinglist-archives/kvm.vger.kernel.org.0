Return-Path: <kvm+bounces-45055-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 36C89AA5AE8
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 08:26:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A180B4A233B
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 06:26:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3128527D760;
	Thu,  1 May 2025 06:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="C/+1Dmmn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0591727CCCB
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 06:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746080657; cv=none; b=h/9KXsYhNBoD9PQ8cEcLPrmfXLjZI8vhnAGFsg8j96o9Jq2dlE5DXP1s4FiEOgj3VMyfx/fdPgnHqurxzil7jLtISkZLm3iFJ6UIkXBim06PwmOtQ8mVgk8iYuv12MIYSvoNO6/mrR29stt8MXCRUfhKnqOQs1MvaFJs9kanZJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746080657; c=relaxed/simple;
	bh=DHzqB/reVDfR4UVjlzgWGQv143ocFnLKz8Pq6iatUHs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oy0MrPmn1j7MZdLRMwUTUGNt6jZ5WOMO6qNGZsvIov1k6Ac5iVkR2SRHmdXNVIQTvoVQbvK7r7/yN/9LaDPoIUG1D1XZ04mbRCY52dpPrdELffCm0xDZ0psTWfXZpM2Jzzykh3Zrxd9qwSoGIuyXdtyMBHWK/fwsXyfuePGK9mY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=C/+1Dmmn; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-7376e311086so1001366b3a.3
        for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 23:24:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746080655; x=1746685455; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C6DezxTsq/qsXh84VFmp7K8Dht2SMC+Ysjj9VaUYBm4=;
        b=C/+1DmmnIM2xJPyVeaIgOqOjU/hBGa6J4DF6wl4Cl51VlVFJrOE6r7A5YV5Wod/TR8
         YFoRq0cKsEZhAHAj46m6isMq+PN9wn95WCd61QpZJNmpJtPJKYNrWQry2ybPej1clg89
         I4Lb2pa/cQAdT4GE11acJ9Ob2SB7aW3fwAcVfaQ8g51RhhmKna884/2AkNk3LYzgjoLh
         ltkTdhbKSyrJs6zhCFUdvDdtrNyGKUC/SxTDSWLbpGsBfoj2qvljZErlI28ZQbCQ3OGG
         6VZ4ms8MmF3w2mCUMCVoXhn+USF2BMXzB7/Vcblwo4tUmFyYPGHtnp9jlQPVtlfLTsQu
         niyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746080655; x=1746685455;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=C6DezxTsq/qsXh84VFmp7K8Dht2SMC+Ysjj9VaUYBm4=;
        b=AdenO2FXAuOcDga0vDaHt44ihR3BB3rO6KpZvTYV7vY1ArQC8C2Err6oJaao5EXCmQ
         8e1LJOAkm4wQndJzLLrAiQehNt/0s+d6yHp5k794g2RfJGGxKYtuAD30LHwMjpyuRTe6
         A10nBy2P/BTlpVLHUcSag5qRl42TxnZ3x7zKpBd5KvpUk4HDbftImGcIa8Qqk8a1loNl
         iRFRar9M0V3PA/fWH2ecfjrB0Q23aK8kP/SSY9bth8kr1betF9eurbo1TqZUaZ1SwBn/
         VnAac5hjGeU+swmZbJahwSf9AcMiSUTTvjj7TqxpYcsFksTkat+bQxgObwlIjzdXvU47
         sDfg==
X-Forwarded-Encrypted: i=1; AJvYcCV438UApRhJ/xsNcy5bPUS+CN/f0COSjp5aemfbMTzyteFkXYp9CDyt7DIY+fy9p81PNrA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxE6pBhCr1QKdmj9S1q0MgN5Dn1Xhcy9zC5WLXUoZk1gqjvLBja
	nVS1GmWr3Ljw8jq1TH8lneOMPH/JwV7ByqZgda2T/5U8dj674biibNvHUnhLSuU=
X-Gm-Gg: ASbGncu1zUu4v9egTc4yIAbRJkyWads6qdOOJOZUFWlAso7CyohO6xw66gwLBu2EmXQ
	i4oNKLTtHH5IxXp3QRHPCmxcYuk880jtKDIRvT7nUnwwZKo5AXvbmdDUtfhPhfhi0g+PGHS8tz0
	V5EZBSeSz/b2CPH+txUsl25LByX50glTqUvWkxr4m/mycIlLgxlH8XvfpzppCRWrxlq9iMqwcfp
	p4tppbdp3NgchBt8kXYNXmp84obUYShAJOUzHWq1Fb9TW5ATiJ2bcEX6Q9L7Z1IPWX3iOzCZiy2
	M7IOcp5HWQ6kDwtgzjKwhhcQ6xgV8lcoidoKlA0g
X-Google-Smtp-Source: AGHT+IEmLnzJSDHKNiPbTs6xdmLnJGuNIaAbjxHyHGNgoSlitEKO8yt6BGj1kETTeGFLW9EC424X6w==
X-Received: by 2002:a05:6a00:21c6:b0:73e:23bd:fb9c with SMTP id d2e1a72fcca58-7404926c836mr2286289b3a.23.1746080655598;
        Wed, 30 Apr 2025 23:24:15 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7404f9fed21sm108134b3a.93.2025.04.30.23.24.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Apr 2025 23:24:15 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	qemu-arm@nongnu.org,
	richard.henderson@linaro.org,
	alex.bennee@linaro.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	anjo@rev.ng,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	kvm@vger.kernel.org,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v3 27/33] target/arm/arm-powerctl: compile file once (system)
Date: Wed, 30 Apr 2025 23:23:38 -0700
Message-ID: <20250501062344.2526061-28-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250501062344.2526061-1-pierrick.bouvier@linaro.org>
References: <20250501062344.2526061-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/meson.build | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/target/arm/meson.build b/target/arm/meson.build
index 95a2b077dd6..7db573f4a97 100644
--- a/target/arm/meson.build
+++ b/target/arm/meson.build
@@ -15,7 +15,6 @@ arm_ss.add(when: 'TARGET_AARCH64', if_true: files(
 arm_system_ss = ss.source_set()
 arm_common_system_ss = ss.source_set()
 arm_system_ss.add(files(
-  'arm-powerctl.c',
   'arm-qmp-cmds.c',
   'cortex-regs.c',
   'machine.c',
@@ -38,6 +37,7 @@ arm_common_system_ss.add(when: 'TARGET_AARCH64', if_false: files(
   'cpu32-stubs.c'))
 arm_common_system_ss.add(files(
   'arch_dump.c',
+  'arm-powerctl.c',
   'debug_helper.c',
   'helper.c',
   'vfp_fpscr.c',
-- 
2.47.2


