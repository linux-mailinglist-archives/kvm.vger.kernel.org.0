Return-Path: <kvm+bounces-46225-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 915C9AB4250
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 20:21:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D2AEA3B47B2
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 18:19:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 322322BF987;
	Mon, 12 May 2025 18:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="G0mAoAYK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6A282BF3E9
	for <kvm@vger.kernel.org>; Mon, 12 May 2025 18:05:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073135; cv=none; b=IZWBUfjrbs4j3dGT7HSqyOWu9DY1lICOXQwy4ZZY2pzim0eVik14SIQ3ZHV4RzXZL96KUU0m+p6hdL/dj+i/rmZee9bGpBeN8vOAvS4QdxBBspEoxaKCNK8LmpE19ijXRo8YqQhif9PMPqTz/oz1bO0eGS6Cm95A20M9jgB0uy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073135; c=relaxed/simple;
	bh=rVRDTbWWEqwgabZa5zWcVeyAjZSJEYR9LpoFB4OvRA8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bLfxKBVOC7VCB2ATRSZEALJge2Zy/5p+U7p3EZgcgOshK5WkHE6j63jtranj9CU8V1AeRFFtb8JkK4LZFAjHOGuZiaDeCII+M7iutkMmcwobBy5JRGCIe5uRkMtbCGyGvjOJOQPWHDiq/Z5sBBJZprR9Scc3M3j+6YhbP95j7Oc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=G0mAoAYK; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-af5085f7861so3343742a12.3
        for <kvm@vger.kernel.org>; Mon, 12 May 2025 11:05:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1747073133; x=1747677933; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d146Pj4KjTAmT+769pG7plO/J3O67dCMeGHKPEFKjBI=;
        b=G0mAoAYKczigX9EStHjHe2JbHkwcvZddwqDCxDN4smwYKBaZyLfqWX2kmNpN3cqqt1
         FZnawi0EkEWYjoaRGgTUDMYgJpQUwyi4E/p3iEMJxcbt+2y0U0yCMhNpiEjKXl7Vjfa0
         qTnA/eB/xRh3BQzlNn3TING8vLm+B8ASvD+9i/frJu0JdbHoAIySjqoUM7E01oU0W7lk
         JDosrwEdsfM+2zcgj8I45jDcoYR0BmXYHr9Gj7mzw5tB9F8xRRRWVoMnoX6wIR87R8Y7
         qkhyqVuPkqNXfoksLSMf0oNw6H61u671zYL5AS3SXThyYY1AC7edjiJeOO2DU86soLfi
         vz7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747073133; x=1747677933;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=d146Pj4KjTAmT+769pG7plO/J3O67dCMeGHKPEFKjBI=;
        b=FOhN+FjJDbfD1vNbqXd96sjKIWPKuzI+kn4VCC4HPNNPWOrZCTBXiIPcHp6tLtf98X
         xksni9VHUg2J7liYMEVgvkXwLC2Vs+kadLTSiLiRNd3VGUfeddpWENAvEvICnvMMNcL8
         +I+fGyzwEs3B9qpzJhEPnYTZiQRGLYULI6QaYPGBxvEvn8BBkc3bwGEjLJbXxvE1+pJQ
         D/4QQUuT5AhZh1Wl+c+MWxeZ/FmJd3ZJQYvAaztsxjoU5WeUJm7oC0mq5uhe9wzbNVq6
         kDZBDHIWsFT/he3eXzDP4gI6SWmb7OxwEU7GL04hXBCRDhxuB1zPQjkWCYSF08UUv9cC
         TPOg==
X-Forwarded-Encrypted: i=1; AJvYcCVrNAUrJJntUMmtYWy4YSTeprfXD/WEQ3iY91qfTqTAYeLaqSs63BSgBdhMYkdKTQIFX10=@vger.kernel.org
X-Gm-Message-State: AOJu0YzT2cEsJ/RyNHVHB7SNNRE9mR25EVPIZMr83Sk07fyLdTK/DHAl
	w4jFNTEVe6LHWIk57MmBmax5/HDVhUpoGd+8AHKBFrrOGvrZe9ezgBYoO2e/XNg=
X-Gm-Gg: ASbGncuIL+N72yUZCUy9U7ESr8MDLXKWyPgx5n/RxPDKdncydbEfbWz9WEWBXO9S+YF
	qNscdnPRO0nDVhSXz78uJpewWioFa0qmBVE7CmmkMy4Al96hdJnodCY2p4QDv4y4k3a6XSdhXZ6
	cSNTmebBdvhT1PeYxbko1Equq6lnId974ROp/2MeqxNMl0vhqyNfsGiNNlxzA4tzckLSOs4El24
	Haa2oLL6I+upjQezV+BqyuZJfzeMNUnU/9/ZLGbV/b0dMbSkkTMBAFMVNnsXDMFhNADQe6W3eVE
	/brn9+4hXoiCx+SP+YQik4onGxUqwEsuIqX0Hg1KQSa88QaRI64=
X-Google-Smtp-Source: AGHT+IFCFhLetEwRoDr4iaBj8Wtr+2CIPtGJqZ3yk+dZbV8iR0p9eNz87XZ1bPZBW22ghrz1B8yiDg==
X-Received: by 2002:a17:903:1a10:b0:22e:61b2:5eb6 with SMTP id d9443c01a7336-22fc8b3ed12mr214319545ad.15.1747073133322;
        Mon, 12 May 2025 11:05:33 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22fc82a2e4fsm65792005ad.232.2025.05.12.11.05.32
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
Subject: [PATCH v8 24/48] target/arm/vfp_fpscr: compile file twice (user, system)
Date: Mon, 12 May 2025 11:04:38 -0700
Message-ID: <20250512180502.2395029-25-pierrick.bouvier@linaro.org>
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


