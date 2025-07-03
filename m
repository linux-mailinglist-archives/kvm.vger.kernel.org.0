Return-Path: <kvm+bounces-51447-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C82E2AF7148
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 13:00:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C720C4E50A5
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 10:59:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CD432E3B1A;
	Thu,  3 Jul 2025 10:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="tGZwqBEJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD7892E2F01
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 10:59:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751540378; cv=none; b=B0/FeR3cZwAT3hDRkupwGChUEKNK2ZrAZJsNMejFtLXPYSguIufXy9xElpQqgBGbtBfr7HIRFDoh6Hs3vZSgFV3axGOQGNbyRHmAb6b2yHY3mWaAzBFVqmar4PK+W8BEc8DmMfXlUB3tQGaQqZm0OChXYnvoKz4BWfGAPQW244w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751540378; c=relaxed/simple;
	bh=zn8zbxIpfcBmpKkbHgJfZQIfuEHR/H/E+Ykl/6Q5G20=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tUTU+x1Fyje4zRGrPDfUSkB87ej4tZN5LU4ELSDQLK6zX8YAH7J6v8BgXDOByY1TXC5aZ3mWazd2Z0gYCNsZY96ZvJXjiDfydydRF6m/2d/ipWwiVdxQlxus9Yk4OSMPjP1dtM8D5dkB/ZNm1MSTEoTSB3SPHvk8dHywUvS54So=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=tGZwqBEJ; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-3a52874d593so4573185f8f.0
        for <kvm@vger.kernel.org>; Thu, 03 Jul 2025 03:59:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751540375; x=1752145175; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Mdy11kA+VsWt7cboODkHkD4f2jxHCHYlzGKA8G7vb4M=;
        b=tGZwqBEJ1et0ZD8jUgLfAODzHiVHQSk+ygRUIzZAbKDRoALvQEmwiNgilHUblEyBVo
         ebBMmABHgt9EK6KWQ3CTAzsWWyFgPnjBcUsMxtzGkL9IQPvW5bEzSG0a/ByxT6F0kUmL
         aTkPiwWzRFIVtfMNskJBoU0LqKc3YOILbqyIwECtU+a1Gn6gnPnWTbTLVJ3P+XHtND+V
         y+xumycycb63t8NW6TqBFNqMecCSdr6hthArpad6pV9Iuh/NDhvAWK+Q00MJWu7QbSFC
         NqeP9iQezXYfCErx0vH6CNPA+FO3nFp8PhtBqCBp/MIjtYbUQUqmXGTjuJTDog67F9wb
         hTDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751540375; x=1752145175;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Mdy11kA+VsWt7cboODkHkD4f2jxHCHYlzGKA8G7vb4M=;
        b=BJ3lzNAU2DQAOYQOkBqv4IUaB77ueCENB4bijegEwJXdlxnEmZq4ONVtoO0v4b/T+N
         cF75kGyBQKcFFO/DbZHoGcfwX8UAK1uHUDIYCFeDKryKGZ6Z6+14nJAEt0i6IlBVtESN
         wimsFUd9YeFOzyyUOWGvlq27bM28tfJMa8iu09Acg20sVxN45sJNwUtxGM4qhzco41BG
         cM5sN4AURQM6O80ViVNUjX1PaModVBZ2BZFAPzM+y1SYkNl4vT2sPcvOe9uPkzH1uy8W
         T4+PFXeuvrRrJY5enenVShOHA6HeiI4PBvPg6dN8WayEwkO46jBlZYcvwYOeHEgYpTUq
         OT5w==
X-Forwarded-Encrypted: i=1; AJvYcCVXKeKWOWV4WY9VZvbJHkhqJfTWx7+t17+PH9c+wOJh1WbvE9dagsOaDkkLnzHZpwz9I4E=@vger.kernel.org
X-Gm-Message-State: AOJu0YyEf/ZzzN9sWskVextcNllgHO/5UN38pkg8yKbxhiG0TZ3iPZ5Q
	lc4uIUHtNgMZTKgZGxbFKcYIZP1MzAiZM/NwMIEcxHGZd/w3cq9qVHcTEsejqqujpyc=
X-Gm-Gg: ASbGncvTQqPxoiuqWJfAqBVkNer0JSBf18ytxUaRB6Yp5okcLMj0Td1VaQD3vPkm5/V
	3zYAq41l0HFBx6YuJ+cxNo6wt1JMTsTA+Dr1SNj7jLr0wVXhpopT9HTm00s1av99R5DEayqH7fT
	1hBimWhx07k41jIU+zoKkhwBSkg5M/R9+CDe4xjvc9VlFAO4OUMVeUmCMYI+8BkAQutUdF6dvK3
	YgK7spP/vOZKYPuJxPsP7Jtq086O3+s9rbcSFF926+ctKsK9j8lmvbzVFZXGFt7VwUbDjKwESNi
	9Ts0uJFPMYzJ3VJ+w9Dqimw9yRF+mTf0gsNEDOskRvUyQuQoS4Vkt/Bh3r209nhKKA3jX9tG9sV
	UQXssc0JF7ICqXg3ZkzCA7w==
X-Google-Smtp-Source: AGHT+IFTTmpYPe4IjWoZiJ9ZpcABpmp4ffx2q20Rr1xysL8BJLKOX6y9UzICtQUNCx6z/t7QN6DGdg==
X-Received: by 2002:a05:6000:410a:b0:3a5:2875:f985 with SMTP id ffacd0b85a97d-3b32ebd79d1mr2147393f8f.59.1751540375102;
        Thu, 03 Jul 2025 03:59:35 -0700 (PDT)
Received: from localhost.localdomain ([83.247.137.20])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a88c80b516sm17928800f8f.41.2025.07.03.03.59.34
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Jul 2025 03:59:34 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	kvm@vger.kernel.org,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Reinoud Zandijk <reinoud@netbsd.org>
Subject: [PATCH v5 44/69] accel/nvmm: Expose nvmm_enabled() to common code
Date: Thu,  3 Jul 2025 12:55:10 +0200
Message-ID: <20250703105540.67664-45-philmd@linaro.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250703105540.67664-1-philmd@linaro.org>
References: <20250703105540.67664-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Currently nvmm_enabled() is restricted to target-specific code.
By defining CONFIG_NVMM_IS_POSSIBLE we allow its use anywhere.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 include/system/nvmm.h       | 23 ++++++++++++-----------
 accel/stubs/nvmm-stub.c     | 12 ++++++++++++
 target/i386/nvmm/nvmm-all.c |  6 ------
 accel/stubs/meson.build     |  1 +
 4 files changed, 25 insertions(+), 17 deletions(-)
 create mode 100644 accel/stubs/nvmm-stub.c

diff --git a/include/system/nvmm.h b/include/system/nvmm.h
index 6971ddb3a5a..7390def9adb 100644
--- a/include/system/nvmm.h
+++ b/include/system/nvmm.h
@@ -13,17 +13,18 @@
 #define QEMU_NVMM_H
 
 #ifdef COMPILING_PER_TARGET
-
-#ifdef CONFIG_NVMM
-
-int nvmm_enabled(void);
-
-#else /* CONFIG_NVMM */
-
-#define nvmm_enabled() (0)
-
-#endif /* CONFIG_NVMM */
-
+# ifdef CONFIG_NVMM
+#  define CONFIG_NVMM_IS_POSSIBLE
+# endif /* !CONFIG_NVMM */
+#else
+# define CONFIG_NVMM_IS_POSSIBLE
 #endif /* COMPILING_PER_TARGET */
 
+#ifdef CONFIG_NVMM_IS_POSSIBLE
+extern bool nvmm_allowed;
+#define nvmm_enabled() (nvmm_allowed)
+#else /* !CONFIG_NVMM_IS_POSSIBLE */
+#define nvmm_enabled() 0
+#endif /* !CONFIG_NVMM_IS_POSSIBLE */
+
 #endif /* QEMU_NVMM_H */
diff --git a/accel/stubs/nvmm-stub.c b/accel/stubs/nvmm-stub.c
new file mode 100644
index 00000000000..cc58114ceb3
--- /dev/null
+++ b/accel/stubs/nvmm-stub.c
@@ -0,0 +1,12 @@
+/*
+ * NVMM stubs for QEMU
+ *
+ *  Copyright (c) Linaro
+ *
+ * SPDX-License-Identifier: GPL-2.0-or-later
+ */
+
+#include "qemu/osdep.h"
+#include "system/hvf.h"
+
+bool nvmm_allowed;
diff --git a/target/i386/nvmm/nvmm-all.c b/target/i386/nvmm/nvmm-all.c
index f521c36dc53..a392d3fc232 100644
--- a/target/i386/nvmm/nvmm-all.c
+++ b/target/i386/nvmm/nvmm-all.c
@@ -1192,12 +1192,6 @@ nvmm_accel_init(AccelState *as, MachineState *ms)
     return 0;
 }
 
-int
-nvmm_enabled(void)
-{
-    return nvmm_allowed;
-}
-
 static void
 nvmm_accel_class_init(ObjectClass *oc, const void *data)
 {
diff --git a/accel/stubs/meson.build b/accel/stubs/meson.build
index 8ca1a4529e2..4c34287215f 100644
--- a/accel/stubs/meson.build
+++ b/accel/stubs/meson.build
@@ -3,5 +3,6 @@ system_stubs_ss.add(when: 'CONFIG_XEN', if_false: files('xen-stub.c'))
 system_stubs_ss.add(when: 'CONFIG_KVM', if_false: files('kvm-stub.c'))
 system_stubs_ss.add(when: 'CONFIG_TCG', if_false: files('tcg-stub.c'))
 system_stubs_ss.add(when: 'CONFIG_HVF', if_false: files('hvf-stub.c'))
+system_stubs_ss.add(when: 'CONFIG_NVMM', if_false: files('nvmm-stub.c'))
 
 specific_ss.add_all(when: ['CONFIG_SYSTEM_ONLY'], if_true: system_stubs_ss)
-- 
2.49.0


