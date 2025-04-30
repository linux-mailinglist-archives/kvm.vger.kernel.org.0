Return-Path: <kvm+bounces-44928-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D692EAA4F4D
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 17:00:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EFFC73A6EA8
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 14:59:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7FFC25B1D9;
	Wed, 30 Apr 2025 14:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="E0RlR93z"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67D1225E444
	for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 14:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746025139; cv=none; b=LKHlQtPxjFhsMSaQygflZhy2TEM5cUvQmRqflcEa65pAxwoafp0695kXKqn12MzHakscjL9sZ4OKN4Ip5NVuzGGFBQaZzNbvksr4oiZ1+9Um+EIvc2TEYaSKRkn0W7g9YG3HYe2OHHCCtbb2CgAKy2WKMQmc8o+PsJDaX44CNRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746025139; c=relaxed/simple;
	bh=bBx3RVCAvu/zswHe4Bte7YzW7LyWednFjmKafsS3qjA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YeJENulY1WdwU76bM7i9VMNknCny0m+zA12Uoqc3F6+uWhunNs3rc8czfRHJRnRVMzhELR8ssckCYN3j+4Qz5Cye31zi8sUqHFytNS0JZ0lbjihezILIOIWpV5JTS604s65OI3BUxl2UHZiI2K/kxwA6uMWVkbzxLHzY4j+w+nE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=E0RlR93z; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-2ff6cf448b8so9539150a91.3
        for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 07:58:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746025137; x=1746629937; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gyyYrSBpMjZGqDtX9J3tyJffb7EP1/gzXVNNR0hz1h4=;
        b=E0RlR93zdmcV0PA4wzcJDE8jgvK8zg60bZouK/6/TsycFQrZWAkPN1CYG80LyvZNmB
         HzUDjujBpQVtMD95YOC8PcbWgGwBO+bhucAl8mSsWmI2JuO8jucvVCRC8ZnV5FAij6e0
         cPpD9VgO2Kat2MgVxxQ+56Yrh6KOU2iIbGOQrwcF/jueIqVy2WOY6F0mRGf+EE59RrEX
         8bp+Y3U4uFbp76f0aPEGssDcNdKUOeHFHEHsFXQ9tpPIKOuH957+8tt8fSpyUuQeAhp7
         7c0qpPjPwAmZF2WtoR1lfsQwd3H+c/rWcTjLg987m1/Cd4TsyTC9awmWzYwbM5KMTbIO
         dcIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746025137; x=1746629937;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gyyYrSBpMjZGqDtX9J3tyJffb7EP1/gzXVNNR0hz1h4=;
        b=E3EMDLWjRR4DZ36TPhJSk2zdhhU/PGQ5eOd+RKEuByvJFjUo5MlP+LCjRmmrF3PWJx
         yMxU4f3Vloij62EQfQsFJ3nUA5E3lUYU/U5O0Y6nXSN/vx0usKkZDy6j/tsMKjipIKps
         ZO9CTaaAPOAgQ1wRXhT9ZE2+SSgfTKiZG2jJDwcWUFO+1N5U4d07Oi2LCjHO9l1TbzDP
         uNGWNWjE3G4jwKALxEsY2LuKLyH360gBsqO9JoGlBgD9tMPM0S8uU4WrBzTNZf6a1PF7
         28a0wUZuHKyncuwXcu30nxZ+Jq8om/QW5mZhpYGy6Vo5n0vBQ9Qw94Irij2vW7Eq2iyW
         GYYQ==
X-Forwarded-Encrypted: i=1; AJvYcCUIS4yAnwVTyKIyq/VSSc7pIB/kz7R8If0dVGEGiEfhsaGfCYarE3IPvlgGQgyECeBtwQI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9sgRGk+U+cN2KMkc4tCSYMu7jFdpt4MwD9K34NNNLF0V1QdOF
	W2i5Zm7flKcsrqCG9PPB69h1AsSfzoxvBQxcPAwtnouuneYutGUmYlFKU2/7Cfw=
X-Gm-Gg: ASbGncs4EoD2YXpbR/aoj6dPvYFImrHi97LfGs5KoIYRFcCAMZ3JBXts76hMiZOJ0J4
	Cg72fEHSsWpZxej2LlKbD1I6gSE5zGbU1P+ZMCAU/ZyTZSjV1rmEuluv2GsBT3ytpxL6UDD/MOv
	UTQW4LtYXSjGRF2gkvpb3htPGp378BUSA6AOQr02MVJacaHhaSzRhtm2gIz3aqW7dNkvvjWz5l5
	Re5kv1qR7z9vKwLFjyarkSXprtWaJpxcQWgLW9V7wJQPRWSG1imXKh5fwDtmnsSUUGqvBLtv6S5
	cEsAOOwRZXRF3WmJ17f2EiL4vCfT+AExQNCPB8FS
X-Google-Smtp-Source: AGHT+IEvk2/k61FiGJWqrBdSZmySJhG8AGUsfK2QYU6mePeCcDxMGSFr3zXKpTA2K1BLZ1Ge2SZ7Yg==
X-Received: by 2002:a17:90b:1346:b0:301:1c11:aa74 with SMTP id 98e67ed59e1d1-30a333530c8mr5040805a91.28.1746025136746;
        Wed, 30 Apr 2025 07:58:56 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30a34a5bd78sm1705652a91.42.2025.04.30.07.58.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Apr 2025 07:58:56 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: qemu-arm@nongnu.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	Peter Maydell <peter.maydell@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	alex.bennee@linaro.org,
	richard.henderson@linaro.org,
	anjo@rev.ng,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v2 07/12] accel/hvf: add hvf_enabled() for common code
Date: Wed, 30 Apr 2025 07:58:32 -0700
Message-ID: <20250430145838.1790471-8-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250430145838.1790471-1-pierrick.bouvier@linaro.org>
References: <20250430145838.1790471-1-pierrick.bouvier@linaro.org>
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

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 include/system/hvf.h  | 14 +++++++++-----
 accel/hvf/hvf-stub.c  |  3 +++
 accel/hvf/meson.build |  1 +
 3 files changed, 13 insertions(+), 5 deletions(-)
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
index 00000000000..22e2f50c01d
--- /dev/null
+++ b/accel/hvf/hvf-stub.c
@@ -0,0 +1,3 @@
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


