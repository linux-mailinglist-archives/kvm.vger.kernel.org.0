Return-Path: <kvm+bounces-45492-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 64674AAAD47
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 04:32:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B544F189340A
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 02:29:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1064328DB6C;
	Mon,  5 May 2025 23:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="QY/v7JPJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74C1028B3F8
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 23:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746487231; cv=none; b=X00wuEFddmeWohCiUbzukNOzB/o/qiAeyZLN2cpGlzeuxWsjAy+J0BKfSkbTZk03uirx56Cqc8x4OJozp2ldhPpihkGHjQZGg1kjd8q9qgU6VmTvwh3AjVqQS/fBgqGKELiOmCo7thLp55ijJ//WWchh7/hVKgusU6xD5WkU7Lc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746487231; c=relaxed/simple;
	bh=m1DRJ3QbS/3fqgC3jyFLitIJTXEb4Mtan93MiLUIBuw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aTcGgYNwTzoLZfGtD7mfv9kbh/kP8fSzjExDls/E9HJO6HcmwcfgTUBzXhbXF6AVfWK6gntc9nj1jCl2JUSlvZqwUgnh9FiF5zT0jXCJJ23sPfwXpAU7GD1BCoK2n3+4GkVgYdhNWdLy+vSIBsEdSEpIgREG9V1zRMr2lcksX5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=QY/v7JPJ; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-b0b2ce7cc81so4502361a12.3
        for <kvm@vger.kernel.org>; Mon, 05 May 2025 16:20:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746487227; x=1747092027; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Gch+3DQ1xFSIgoe8nsFHA95PeotLzKWriKqshNx+4Kc=;
        b=QY/v7JPJ9zpNd/wSJ50xu36VP8QoIe0n3IAp8WGVBHXpec0+slUROEiOHKA0cy/WwK
         Fe7ov0vF/3dVPiAgU+dJYkYBPkO/+7fp4FG9o61KsSDUJU+f+uWGT6vReSuEQOWX7k8p
         IcujpBz349DT/KiYoQ/OS0QfRNIebDvkHtXWI4Ooa+aDoXScjFvTV7YBKeG1A7LYOlzK
         mv0tMfnXidyEbZcnAo5QC43BKx56B5WtpLX/l4Ex5lWC43FrN0W1OYbBx4is7iuPQAE9
         MIcQ7nkuK0opDiv+XrbX5+8W8xYa8mT2I4WnaIpS9Wuu+qyTGKIMe0gVPyh415w9IMxX
         y6PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746487227; x=1747092027;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Gch+3DQ1xFSIgoe8nsFHA95PeotLzKWriKqshNx+4Kc=;
        b=pKWKxXxeB2l7s7ad2YYbwNe1XOI78hvdy1jUvS+lLql81cKuvvzVF3Oh9ARNTGMXav
         lWBBn7UZ7usoctVzf0f/WbAQWuCcsGdaEeDcgz5K6rnPLn5jzfagEW/I9yK9Q1uwMJOJ
         fMLVmQh9kh0fck0y6JbUE1n8RBVpZr/Ot9lnBe+v1AnmHc55rJZ/Sll04cMeXQC2mehS
         ZDgE/g86dOgyqj+WphMolhRMSXgL3n4oJwUmbF4uwhIs5mD/DQfHLhjwwm1KUq93plc1
         figfKbvINehJ5Zqp6A9UD/mQO49g4Lq/AlKtIv+Laqy/2PbNtiH2rmepBNfC0UZQiof7
         qWnw==
X-Forwarded-Encrypted: i=1; AJvYcCXGc85gKS/hA8c3A919lM9qCkdkMMoWxoqu17LWELqehdd3jG//gOloPuy8P5ROcXwk4oQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyvIuMQY8ZibvFz/S4HOM6I7KWejuVXPtK3DxfnpGmrAExePtP/
	LxpeUNZ9TiMcS+b9iehiIU5RePOegGwPt5UhdpA2CxWeHwbHLqJ9REwsYTqnRC0=
X-Gm-Gg: ASbGncvaewh+V8V6+pGZOm3O9XOWkDI8G4KFSXHAEUZAZUObWrGYeqJbTau6/nC6HBD
	cQ2YqwxPzcfA53svWXi+lEd7zgaCJ4HXrfqW8zavKVyGDr3rAzA6vfi1IxuNo5zL6KiosUoXtpf
	xJxr1VxUWG49Rjj4b6pDihBSlEGTcNqalJIYW3frUm0JzC2XinoBjECmA2/H328mCfziqk7sdYj
	cFmDVjzZd7bJZBfnOpj4J9S5DPnN8gQaSOta8zQF1xGBqlYcN7jqEgGuh1j+5Kz3tTcU0tUvR2M
	9erWmILl6o2l9hEB+EwMXPg03kOE8guX0WJ7xxtY
X-Google-Smtp-Source: AGHT+IGzyc/8Sb9h770V9rBwJkj1A3Giv8Wxa9MDiPTqoA6+WmVYt/2QSnM+Kx0pqTa/ImdxPtTbSQ==
X-Received: by 2002:a17:902:cf42:b0:227:e709:f71 with SMTP id d9443c01a7336-22e1ea822aemr155051315ad.29.1746487227703;
        Mon, 05 May 2025 16:20:27 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e1522917asm60981715ad.201.2025.05.05.16.20.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 May 2025 16:20:27 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: richard.henderson@linaro.org,
	anjo@rev.ng,
	Peter Maydell <peter.maydell@linaro.org>,
	alex.bennee@linaro.org,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	qemu-arm@nongnu.org,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v6 08/50] accel/hvf: add hvf_enabled() for common code
Date: Mon,  5 May 2025 16:19:33 -0700
Message-ID: <20250505232015.130990-9-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250505232015.130990-1-pierrick.bouvier@linaro.org>
References: <20250505232015.130990-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Other accelerators define a CONFIG_{accel}_IS_POSSIBLE when
COMPILING_PER_TARGET is not defined, except hvf.

Without this change, target/arm/cpu.c can't find hvf_enabled.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 include/system/hvf.h  | 14 +++++++++-----
 accel/hvf/hvf-stub.c  |  5 +++++
 accel/hvf/meson.build |  1 +
 3 files changed, 15 insertions(+), 5 deletions(-)
 create mode 100644 accel/hvf/hvf-stub.c

diff --git a/include/system/hvf.h b/include/system/hvf.h
index 356fced63e3..1ee2a4177d9 100644
--- a/include/system/hvf.h
+++ b/include/system/hvf.h
@@ -19,15 +19,19 @@
 
 #ifdef COMPILING_PER_TARGET
 #include "cpu.h"
+# ifdef CONFIG_HVF
+#  define CONFIG_HVF_IS_POSSIBLE
+# endif
+#else
+# define CONFIG_HVF_IS_POSSIBLE
+#endif
 
-#ifdef CONFIG_HVF
+#ifdef CONFIG_HVF_IS_POSSIBLE
 extern bool hvf_allowed;
 #define hvf_enabled() (hvf_allowed)
-#else /* !CONFIG_HVF */
+#else
 #define hvf_enabled() 0
-#endif /* !CONFIG_HVF */
-
-#endif /* COMPILING_PER_TARGET */
+#endif /* CONFIG_HVF_IS_POSSIBLE */
 
 #define TYPE_HVF_ACCEL ACCEL_CLASS_NAME("hvf")
 
diff --git a/accel/hvf/hvf-stub.c b/accel/hvf/hvf-stub.c
new file mode 100644
index 00000000000..7f8eaa59099
--- /dev/null
+++ b/accel/hvf/hvf-stub.c
@@ -0,0 +1,5 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+
+#include "qemu/osdep.h"
+
+bool hvf_allowed;
diff --git a/accel/hvf/meson.build b/accel/hvf/meson.build
index fc52cb78433..7745b94e50f 100644
--- a/accel/hvf/meson.build
+++ b/accel/hvf/meson.build
@@ -5,3 +5,4 @@ hvf_ss.add(files(
 ))
 
 specific_ss.add_all(when: 'CONFIG_HVF', if_true: hvf_ss)
+common_ss.add(when: 'CONFIG_HVF', if_false: files('hvf-stub.c'))
-- 
2.47.2


