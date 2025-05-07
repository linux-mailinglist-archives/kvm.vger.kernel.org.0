Return-Path: <kvm+bounces-45784-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DD18AAEF6C
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 01:44:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9E9BD1733AD
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 23:44:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CCAA292912;
	Wed,  7 May 2025 23:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="brCMZqIY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A54C72920B4
	for <kvm@vger.kernel.org>; Wed,  7 May 2025 23:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746661382; cv=none; b=WRY4Xa+2XKqbRITPDbso7fO4WzZoxzvKgflNz32PSQoiFUL/p1DMqdLZWI9Uh4zbl0zhZhAfg/cfOWy4JrbjvJsDbH6EKZzO16wYwuND0hVXQhjFjkTSfoR74a9zZukg/a+FjzWssBanZGUjVORjri4SquM9t2qwdqSMATe9NA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746661382; c=relaxed/simple;
	bh=nW7ac0NUfdnDJCcYnr3MXIbzudND0FOdxl26cRuKPK8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dk22AqroUs0w0ipEpYeFCDQeuMv0NGMlvRT21uB/qnr8uf8EQ+TQ0DfHGctb57A5rMAj+bLg+yZNAcOXf1qMxwQKaNVPumKEtdmDuOPf5Q1UVS5EJX4eZLPjTJGXv3f+xXqcjecmUQYtts+Ml6aOCFpTe2HwchQmecx9XAiJRSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=brCMZqIY; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-22e16234307so5430905ad.0
        for <kvm@vger.kernel.org>; Wed, 07 May 2025 16:43:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746661380; x=1747266180; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u/RowU+G9lDkd5OLEKmfnzuDeOXrVzkwWk098+SYGJQ=;
        b=brCMZqIYreLwSiT2lVwGtQzvn+OX3CNr5DwfgXI4bUfnv4HEVFSTbTNDwrNhnOCE9q
         C5+vxP8FEoonRO+1lsyiU7C0OnC4Y0ua6r3ZI2+4o4bZ0TfQ/EiFLj2hvr7iqJjvXVMW
         v/WBqkFiSciB7CFTjn6vqBhGxuUmEgfDP8txSEKMrjp3JwOOFBSKtGc/+6USEP1q1zlQ
         wHnP0EM7r4UgTOZ18qSkCXudL9Bu6Bcvemf/NpEy9qBbJtfLwuzz5Uhiv8XreYO5F9On
         OGg5yflX4Pq0D9qAQq0YlvTautSjRrOiuvSqeo27cPSFpFS4DhR8GbizxXNx/89gUv+X
         phbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746661380; x=1747266180;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=u/RowU+G9lDkd5OLEKmfnzuDeOXrVzkwWk098+SYGJQ=;
        b=v2CulAk7Wd1mxyF3ysQirgKxu83ZaSNqlfooQWXuYoQ67HnE7taC2H7h9+TOQKOZrX
         vwjfvz4aXb+JDDauB3yTS8Rd2JnhVw24/ZAzbtfn+wye8L8y5yhBsyxJAkJcZEX0UyyP
         mFC62gpsXOCVtXxOkV55mO7rHwilGec0TwW5uoWL9XxpXbfSD8pI1VETx+xWdSM086uN
         3nKILMwCUEKTDA0B/vXgvicb3EqAif3SbOqYEdxvUAzXK2sS9QXmeLft1Ta8iUwbhK00
         /aCY80jy/U+VTIqnYTja/1uUU66V3yqRpgIpPHN2Fe8cEzKQ8L1SrI19klXVsXAemFyW
         M3/g==
X-Forwarded-Encrypted: i=1; AJvYcCUJH+c2+GQ5RDpvsewq5WMjHwuE6jVfraLm8a8Mq8yp3qtt/+l4WkidS6nnZZL+jzp+Gds=@vger.kernel.org
X-Gm-Message-State: AOJu0YziKckt4eEnj152c4JdXQfgF7iLgQdR7glOO1h0uFEAT70z3phm
	VX1HKcun7xtTCPu+/J6/2hBB5dEHHHAWvclNphFs7Eu4vHqc0TmYkr8O75GxTBKB9bm+w+HBHPP
	ERiMmFQ==
X-Gm-Gg: ASbGncuIUzcD0aQOSFlSnq7ZfkMv5gb7guCZwP9kDGPzOTaIrM8gxsxXHBzuBqAc3vV
	BauA5VsJs75PtO8qegP4gcXpkHZrK7hZpZkgiH6pQ4X54DSmlYLhy5prNNq6fPV6XjZP5jdAy2c
	ojGwiwdIMkCp+bMRPcr5SUx9hLW/szkNqyQnj51iKgHJpAt9uP7Lp8ggDFBuPqYsn7iEEL3Swui
	zZTrcypahPBBcyOtZ3h8pjvZxXpjm3a6492HtASuukzFZ7zW8gYTwte6GlLMMXelVevAjIxhsXG
	ehH/p1F2xOmiNW4uxbFMcW7ePpoofhm7sr30kwFv
X-Google-Smtp-Source: AGHT+IFr6AonYuZbiOdyHtNzMRkQACG1nPGT85mHzH8LSDoJ9GfVu4Ipl9+GAoDhcc3RgvKKndBmow==
X-Received: by 2002:a17:902:e5c1:b0:215:58be:334e with SMTP id d9443c01a7336-22e846e735dmr20084035ad.10.1746661379975;
        Wed, 07 May 2025 16:42:59 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e815806fdsm6491325ad.17.2025.05.07.16.42.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 May 2025 16:42:59 -0700 (PDT)
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
Subject: [PATCH v7 19/49] target/arm/debug_helper: compile file twice (user, system)
Date: Wed,  7 May 2025 16:42:10 -0700
Message-ID: <20250507234241.957746-20-pierrick.bouvier@linaro.org>
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
 target/arm/meson.build | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/target/arm/meson.build b/target/arm/meson.build
index de214fe5d56..48a6bf59353 100644
--- a/target/arm/meson.build
+++ b/target/arm/meson.build
@@ -1,7 +1,6 @@
 arm_ss = ss.source_set()
 arm_common_ss = ss.source_set()
 arm_ss.add(files(
-  'debug_helper.c',
   'gdbstub.c',
   'helper.c',
   'vfp_fpscr.c',
@@ -29,11 +28,18 @@ arm_system_ss.add(files(
 arm_user_ss = ss.source_set()
 arm_user_ss.add(files('cpu.c'))
 arm_user_ss.add(when: 'TARGET_AARCH64', if_false: files(
-  'cpu32-stubs.c'))
+  'cpu32-stubs.c',
+))
+arm_user_ss.add(files(
+  'debug_helper.c',
+))
 
 arm_common_system_ss.add(files('cpu.c'), capstone)
 arm_common_system_ss.add(when: 'TARGET_AARCH64', if_false: files(
   'cpu32-stubs.c'))
+arm_common_system_ss.add(files(
+  'debug_helper.c',
+))
 
 subdir('hvf')
 
-- 
2.47.2


