Return-Path: <kvm+bounces-45040-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 71813AA5AD0
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 08:25:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 629A84A7165
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 06:24:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28509275861;
	Thu,  1 May 2025 06:24:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="IY9choX/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6FC427700B
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 06:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746080643; cv=none; b=fuXs9+ZUBv9a9yKwdHcpV3NAaqLnIMDvE4miTBO2bxXlI7hmn//8u4+22iqtvkrb2owfP5ESsbozauuy29x0/GpB/3KTNRCLDEFIoZouWxZkPXPDSXGTHDPpVBWlO1rScm+gQjuRzlJEgjFHcBcuDSdl0g00r2jIiEu7kjvIjcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746080643; c=relaxed/simple;
	bh=L3RK6cazlD+4isklQrUjoRwmR2X9C06dPPYneBTr45Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cENq/GyzYJAIphMnHLt/jPbOnWlzllPOhkPjvyzqIoGpMu2DR8kZ8fIhO0zU+7e3kOto0zXZb3DXiez+w8H/QtMD1jaOM1/d40v4o11njZvIx0L1zObYKJuXyS2dkZ2iF0QweasLGfHmB3e94wylhSayshpPGcEfBMui21+W2lE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=IY9choX/; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-7376dd56f8fso874708b3a.2
        for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 23:24:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746080641; x=1746685441; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k54PyA3qe+UbX4AzHMockqDzIGWdHV1GUXIbKPo2M9I=;
        b=IY9choX/tpsqw/zXw4/KeYeeCWxHivElED3gqxBP6y2TFvPcMA+5O+hVsQ8qCJVtDd
         Ogq7Vy9xBAspD6lpw15PhYNqf4YaWv1VVl52EDBe+b7gN6QEBFTKBqr9/H/5qtCu8ipJ
         5noWGJXHn+p2G+z3tM6s2jjSrwqfXubKKhbExO+Jf/D9hSIfEcxXOgkCg7//3Mk4itoL
         lEwjg4aZfxFhB+DPqqgZu/+gjl6zuYymlYD7Ab/Ry3UNmFacG/GtzNsJKiFQe7V8eiM2
         cKZhEw0Jq9SqwYr2PI7WmeNeP2y+TyyIIUaPbdr0UdP5HMv2rNqzK403FDCIaUJtdsFH
         nF7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746080641; x=1746685441;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k54PyA3qe+UbX4AzHMockqDzIGWdHV1GUXIbKPo2M9I=;
        b=XgUH9V0H4XDwv4ASBUGsSlMfr11+FQhYiBWKqzjBBTaApLiekq4djcaEP+lPRzZ8W7
         R+MuTZ30B9Mi7KI98cka+ykSqJPc9ariRWs9KLbXsyU0Ko48o62sarmeXxyEWmIvO5yR
         J8Us4/fBS9Jr9sCbaQ3hwxd5Ipe8dWYOmFABpys/UfurLrS1XgPuDDekOGeIyoQbZ+3i
         2L69B8hhvDvRXdPLZmdrK1E61Oi6ZNsogwGe0vQBlhJkbpkjigpzabifUzIxn933lIJY
         w03SrlkBXkAKa+ADinwXzBS7rvA4wsemxk4dO7g4wM2jE/s9L00Bt+ZxgJDoVEKvO4Wp
         m8HA==
X-Forwarded-Encrypted: i=1; AJvYcCWcPHAGFtVi4Xw3uHwye3KCX5r4hDsDKQUpEr8jON81bTyMVnLAInVfSDiDHWIn/i5IWa4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyjbb8EPAKKFIY5XK9Tp7vcVaQc9P2xf+5HC2d3/q8fBWQ6WCbU
	1Ua+mZoik4frNNWA43rgFFSuTNx8lOVQ8S1mPLNsrej/hANVuBZ5RszIrBG7zu0=
X-Gm-Gg: ASbGncvCEP9SE9KwYeLdIie1BUiSVuKkor57Nv4on5aGRST6w/fV2fLWXJmMR12qpVS
	MPEmjCWg5xmdKi24lBtG6LdnfGk1RcSmCteTUQKSClrQdno4tlEjHy2IBnpR7r1Zo+xXZ8eqPtn
	VcVwpw1bD2gMWSIwzCI1IWYpmbNnG6Vs/XryUeQep8ckntCbqLOnkjr+rolvWTOTRCrSWLsW7uD
	C4CPCaBpOVTBESH0mf94KIkkuyZ4qxCaJJO3Qhdn9yAZHME3NaPcOMZb5E+ZadTCsVHIkSuA1k7
	aWstrx4aU0aik9v3eJWO619OGXWS+7YjodZSVCFWmgDxSFsfxtI=
X-Google-Smtp-Source: AGHT+IGGqIMGeAE500q1l86u/9Td5IJIvn3/wPWzMJrXJrwn66g+j5DSrcvsYCEO1nuQYpFIbL1HYQ==
X-Received: by 2002:a05:6a00:6113:b0:73e:30dc:bb9b with SMTP id d2e1a72fcca58-7404775ccaemr2024449b3a.2.1746080641210;
        Wed, 30 Apr 2025 23:24:01 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7404f9fed21sm108134b3a.93.2025.04.30.23.24.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Apr 2025 23:24:00 -0700 (PDT)
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
Subject: [PATCH v3 11/33] target/arm/cpu: compile file twice (user, system) only
Date: Wed, 30 Apr 2025 23:23:22 -0700
Message-ID: <20250501062344.2526061-12-pierrick.bouvier@linaro.org>
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


