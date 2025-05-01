Return-Path: <kvm+bounces-45041-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 63CEAAA5AD1
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 08:25:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5C54F4A7A06
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 06:25:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDB7727700B;
	Thu,  1 May 2025 06:24:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="eXbMcUom"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA1AD277028
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 06:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746080644; cv=none; b=RKn18f0Au8yIPmQpgcuAM6qraoVUm9j3BBIWM6uFeF55Fk5laEnWcABc48ex+L19n75PNlfuxcMYeY3Wpr6SqGWcrUvV27ONbyrDgvl5N4qMVSAyVTkH9s9Y05kU9zcepTcfSKo9bsuRYe/xQ1AYB/n42MCAkcJ4VjB1KQWJH4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746080644; c=relaxed/simple;
	bh=AEdec6YxwqEM2SMva6W9gXoK89VbojQSf/TWlriKM5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fHq3+ao4i0QLo97lYCGKLmZR4kiXAUVHEXKHBdGNpWbuf+zMKKED67GCxHKl4mCoBb8HY28u0nXYa4uF0Xh3H/RZB+iU4RW1QyPJbz9L32d8oc3I8bXaG82ZyiQUzBbInxe0et6z8BwzE4FiLpbJWylJosyrLdZ4ew2ED7VKh8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=eXbMcUom; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-7399838db7fso756324b3a.0
        for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 23:24:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746080642; x=1746685442; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Emf7r2NlJCGBegzvSaP4+YNHnVcvC5KK1KGZi+oKRes=;
        b=eXbMcUomXjWqwzuPQY8yb6IbpURAtrgrVAZm3rz+QyY0GM7K1KkUZ0e7DXEdRGuBUE
         AG3sIGk/pUdsyUsjhv2xww1sF7gZYBkErp/q7jLes6h5cz2IdJI6qv7GjQUVOTfSonLJ
         7Q74QaYNpDsAHA2XYHdBeZ1MKpVqMLmZ/yQ3O2kUgpWkluwUCu5Mo9DPeayfxaL+b5Sq
         xXfYAU8eprwo+V5DsMFjEOgLkBx84GUVZRWzf3EgMwUzlLnDjzOtcU83O4XfolpILLiI
         IfgpKuPN4YDsfn072A80oDilyQhUEUWuw5TYeROGyPr47bJGr+yn00I4Cev2Bx9eCcXh
         F4YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746080642; x=1746685442;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Emf7r2NlJCGBegzvSaP4+YNHnVcvC5KK1KGZi+oKRes=;
        b=pQjBgMpi2cdXTM+TLzv5E0VouFiwkwl0lhrjLD7dakiAV+LqTQf6j1GuxEc6G06DX3
         po7zDMYO0zH7v8v3X2U6ry89tLmGvDzGBgbLDyXmsWe07mTu/HI/SUA32ZPgTU6aCLox
         Steq/vk9N4IYeR2yPW7mmxPfnBtLIHnKUcCVCWQDjGZ0Oen9IMc/gC/OErwq+nFFPzTl
         igO3hKyzcUC5WY2LrDPRjE8MpZqfRPmE6hRDjVtDVhRPav9FXpSgSaBGU9tQbxUNaisZ
         1xfRudWi7m9wrRzSKg7doqoBAANKB+h/Fv+cS1w0DRW1laWWnscC5Jhj3irE96p5xHmV
         DM9w==
X-Forwarded-Encrypted: i=1; AJvYcCWJZQ+odiVULVIHLdWs4YvFTIuJ5u/WMyJWh9/KaBjxyoA2jtBd3UmA27oXPDIn4oWrV+I=@vger.kernel.org
X-Gm-Message-State: AOJu0YxIr1sJRAUW8MoyMJpslcHfETWOTp5yI8TTS4DYPQaAHeHS1sCV
	brY7cjBosqbxKrpnskbUZ/aDLUTaZz2zuuN9/rGtRmrxKBJJPANWFytdDIL9VYwavomcgJFRVuZ
	j
X-Gm-Gg: ASbGncvqq6zup+1I849GqEHmibltPG3oGUstciTembcW5rfU1RLamgE37uCKabcZ6Kq
	7wlEEQcVTGA/nnXWGLTHFWWlGznns0n2A9lgONPJ1vMPRWSZ3WBgytl2zPj4GcUrcz89dmYyWN2
	Ffqc3rKpEM+jjZJwDIwNwPixKZqW9flvOE1c1zLNykX3yI9cqtXoqsV7AKdDK7KA8fst4yLOrZ8
	gLfGYNyo63HPazt3cc3L2bgoY7sSkscIVwirmv1W9ZxV2aH7m8jZMqc5DkoCXFEW2NQnavuAaDJ
	h9/BQyE1UeLWHzbN+ElteTMFcoFalm5vwS2u6ifL
X-Google-Smtp-Source: AGHT+IE22a31367JIZHwwKpXwGfowHm8X6Fj6YHyiKmD1fh8ib1PzRjpm73hHdINL6KudHQM2Ftrww==
X-Received: by 2002:a05:6a00:2e84:b0:73d:f9d2:9c64 with SMTP id d2e1a72fcca58-7404946fbd5mr1830280b3a.10.1746080642040;
        Wed, 30 Apr 2025 23:24:02 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7404f9fed21sm108134b3a.93.2025.04.30.23.24.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Apr 2025 23:24:01 -0700 (PDT)
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
Subject: [PATCH v3 12/33] target/arm/cpu32-stubs.c: compile file twice (user, system)
Date: Wed, 30 Apr 2025 23:23:23 -0700
Message-ID: <20250501062344.2526061-13-pierrick.bouvier@linaro.org>
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

It could be squashed with commit introducing it, but I would prefer to
introduce target/arm/cpu.c first.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/meson.build | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/target/arm/meson.build b/target/arm/meson.build
index 89e305eb56a..de214fe5d56 100644
--- a/target/arm/meson.build
+++ b/target/arm/meson.build
@@ -11,13 +11,9 @@ arm_ss.add(zlib)
 arm_ss.add(when: 'CONFIG_KVM', if_true: files('hyp_gdbstub.c', 'kvm.c'), if_false: files('kvm-stub.c'))
 arm_ss.add(when: 'CONFIG_HVF', if_true: files('hyp_gdbstub.c'))
 
-arm_ss.add(when: 'TARGET_AARCH64',
-  if_true: files(
-    'cpu64.c',
-    'gdbstub64.c'),
-  if_false: files(
-    'cpu32-stubs.c'),
-)
+arm_ss.add(when: 'TARGET_AARCH64', if_true: files(
+  'cpu64.c',
+  'gdbstub64.c'))
 
 arm_system_ss = ss.source_set()
 arm_common_system_ss = ss.source_set()
@@ -32,8 +28,12 @@ arm_system_ss.add(files(
 
 arm_user_ss = ss.source_set()
 arm_user_ss.add(files('cpu.c'))
+arm_user_ss.add(when: 'TARGET_AARCH64', if_false: files(
+  'cpu32-stubs.c'))
 
 arm_common_system_ss.add(files('cpu.c'), capstone)
+arm_common_system_ss.add(when: 'TARGET_AARCH64', if_false: files(
+  'cpu32-stubs.c'))
 
 subdir('hvf')
 
-- 
2.47.2


