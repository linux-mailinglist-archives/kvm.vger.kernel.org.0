Return-Path: <kvm+bounces-51448-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 49CC5AF714B
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 13:00:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CCD454E669D
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 10:59:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F8CE2E498B;
	Thu,  3 Jul 2025 10:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="OYI47rxZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D48B72E2F04
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 10:59:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751540383; cv=none; b=s+3xJcFKETgXBhS5uHfTPA9T3UmPtkSvlirRoMXbWSixqzGiiQWYOG5wWcui16hiin6YaGgHLSLfnbOOvP+n3CoPNcUC4mXK5y5/l+8rr78B1W7OBR2TIS4hiZh3U3ZQxGm5f8saACh9ypwXs0zLuO+O6yjQes2KYaW8GdF7nxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751540383; c=relaxed/simple;
	bh=TgkORgUorzGoBP4cxMPkFru/NQV91RISc5F5zQF2IsE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bEB+dHqclE+GnHBtstMZyAgaCZpuCyLCkbyYH4ygy74tgazmH8M61CxgMNkSoAB22CYGbUdILF1dYHwywV2VhPUmvqfbofirs95E59wKig5bJPK5lvPuVY6zwEFT6D0C528A67GB+h3/nm1o1/HYIB3c9OW3Cdh/1sPXOEr5CLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=OYI47rxZ; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-3a365a6804eso4217607f8f.3
        for <kvm@vger.kernel.org>; Thu, 03 Jul 2025 03:59:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751540380; x=1752145180; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0UiewseZoW7++jqLIzKMJ/OYq1tgfsCyntten+qzSRY=;
        b=OYI47rxZ3pyYr87JVuFTvZrl5ACXlVf1Cg8byPUUbb9+5odoaP+K1zdKoG/v5l9lgQ
         vQGL/PPpwMW2hXYrixeiYusAEJq94YnNV7JB+OcaPMEkNuI8kGCVQWOH3yrXuhLYLrMy
         f6eMYYZtzybxf8C130qL6l6150UPBw/GJ/thUY0FEDmnC3RC+89wpfelOXIM/zYyV2Me
         5JrpgFeGNJNNiEFfdN5XmT3igO2IywdNpSZkKf9pKFq18f5TndHR/i77v2BXDClUby5/
         o3F+HDH/r6l6uAjYqmWVCkXnqPxU1AroDovSdKcz9ZAwMFsC6zo+H+jHPRFKEL63MpcH
         w4Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751540380; x=1752145180;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0UiewseZoW7++jqLIzKMJ/OYq1tgfsCyntten+qzSRY=;
        b=MxLys/W0H5bio/9/VHgY6pSpB9uhNSXdXFXzt3fCZ4yyMZq+9rNElFQnsDFg3ZfPr6
         f0JE6cxO3jpTF96+CjCttHyIXZ6n26AQcb0D87ggXtPAfk52HDz/pykiBUUV2wCckR4O
         tehamMutLZAOJ2aixyhesaxF/5oKJL0YXmSEf5l2vLeN3LIlnGsWN/ImpV3dvGYG6EL6
         r/hAbIw2ZEAAbyygpc61imkvAS6YXskZGq28QA9z8dW8DZ8wWizCMiVPl3+eXmE1u9uu
         /NRADkalbc2/A5okXeGBGShz9Seh4h37bayg0D4qhoSQcOf+htZMENSkd4GQLhqpoIeW
         ZmfQ==
X-Forwarded-Encrypted: i=1; AJvYcCVWyKezpwCfdbHB5BpsaD33au10Vl33viIz78+fI2892fyC8DOiQj9XY6sEprtlUUHJnLs=@vger.kernel.org
X-Gm-Message-State: AOJu0YzT1MsFifAe8G6QhlzyZa2sx5sM34H5MKksa7/15pYLxIQitFQl
	eSLCL6z20y3+st7ntdTjXuUAXmwUhZwD7Y9JZV44sSJOXZQ3mHewMHu2GpoVt5kg+p4=
X-Gm-Gg: ASbGnctj1vNzQLB4P0AwIy5oi75qatVqTxeOLV8SM7wyA7JIJs/SuaEVVULWOipwmkW
	BctPrcR7B8I/HRYToY9XGGdcKPXCIytOcleY1nEjkudb0PizvZvp9VIt3BQohIMcc95EoiItPvv
	GuKP6OZs0KRnZ7VyizwMjCkvA+nwdM+g7th/A6PvpZy/LCESssxM3XfmW5HOWq0x39WaGRRGTLc
	5JLjRgH06c/mzNxorATy3XWueTZu7maQ722zqSZ/uwIebJJkU6kr6z8bm1i+GX4+zSF5z1wxRbx
	RIRxFVPA1H17KmyOvcALBV+FToUgutPB+S76jnoMvPSJow6vAgMsfXKuOr6gNrn20KUDYBp+IrB
	bgXb6fP/k2+4=
X-Google-Smtp-Source: AGHT+IEglrs09yE017jiPqaImjRQF60pKbLzM7xZkDB3/SBr13de9FGL9F2tO1sQQvTsqyjGi5baPQ==
X-Received: by 2002:a05:6000:21ca:b0:3a4:fc52:f5d4 with SMTP id ffacd0b85a97d-3b2005840cdmr3299331f8f.47.1751540380213;
        Thu, 03 Jul 2025 03:59:40 -0700 (PDT)
Received: from localhost.localdomain ([83.247.137.20])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-454a9bde35dsm23115255e9.30.2025.07.03.03.59.39
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Jul 2025 03:59:39 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	kvm@vger.kernel.org,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Sunil Muthuswamy <sunilmut@microsoft.com>
Subject: [PATCH v5 45/69] accel/whpx: Expose whpx_enabled() to common code
Date: Thu,  3 Jul 2025 12:55:11 +0200
Message-ID: <20250703105540.67664-46-philmd@linaro.org>
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

Currently whpx_enabled() is restricted to target-specific code.
By defining CONFIG_WHPX_IS_POSSIBLE we allow its use anywhere.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 include/system/whpx.h       | 27 ++++++++++++++-------------
 accel/stubs/whpx-stub.c     | 12 ++++++++++++
 target/i386/whpx/whpx-all.c |  5 -----
 accel/stubs/meson.build     |  1 +
 4 files changed, 27 insertions(+), 18 deletions(-)
 create mode 100644 accel/stubs/whpx-stub.c

diff --git a/include/system/whpx.h b/include/system/whpx.h
index 00ff409b682..00f6a3e5236 100644
--- a/include/system/whpx.h
+++ b/include/system/whpx.h
@@ -16,19 +16,20 @@
 #define QEMU_WHPX_H
 
 #ifdef COMPILING_PER_TARGET
-
-#ifdef CONFIG_WHPX
-
-int whpx_enabled(void);
-bool whpx_apic_in_platform(void);
-
-#else /* CONFIG_WHPX */
-
-#define whpx_enabled() (0)
-#define whpx_apic_in_platform() (0)
-
-#endif /* CONFIG_WHPX */
-
+# ifdef CONFIG_WHPX
+#  define CONFIG_WHPX_IS_POSSIBLE
+# endif /* !CONFIG_WHPX */
+#else
+# define CONFIG_WHPX_IS_POSSIBLE
 #endif /* COMPILING_PER_TARGET */
 
+#ifdef CONFIG_WHPX_IS_POSSIBLE
+extern bool whpx_allowed;
+#define whpx_enabled() (whpx_allowed)
+bool whpx_apic_in_platform(void);
+#else /* !CONFIG_WHPX_IS_POSSIBLE */
+#define whpx_enabled() 0
+#define whpx_apic_in_platform() (0)
+#endif /* !CONFIG_WHPX_IS_POSSIBLE */
+
 #endif /* QEMU_WHPX_H */
diff --git a/accel/stubs/whpx-stub.c b/accel/stubs/whpx-stub.c
new file mode 100644
index 00000000000..c564c89fd0b
--- /dev/null
+++ b/accel/stubs/whpx-stub.c
@@ -0,0 +1,12 @@
+/*
+ * WHPX stubs for QEMU
+ *
+ *  Copyright (c) Linaro
+ *
+ * SPDX-License-Identifier: GPL-2.0-or-later
+ */
+
+#include "qemu/osdep.h"
+#include "system/whpx.h"
+
+bool whpx_allowed;
diff --git a/target/i386/whpx/whpx-all.c b/target/i386/whpx/whpx-all.c
index 525d6a9567b..1732d108105 100644
--- a/target/i386/whpx/whpx-all.c
+++ b/target/i386/whpx/whpx-all.c
@@ -2688,11 +2688,6 @@ error:
     return ret;
 }
 
-int whpx_enabled(void)
-{
-    return whpx_allowed;
-}
-
 bool whpx_apic_in_platform(void) {
     return whpx_global.apic_in_platform;
 }
diff --git a/accel/stubs/meson.build b/accel/stubs/meson.build
index 4c34287215f..9dfc4f9ddaf 100644
--- a/accel/stubs/meson.build
+++ b/accel/stubs/meson.build
@@ -4,5 +4,6 @@ system_stubs_ss.add(when: 'CONFIG_KVM', if_false: files('kvm-stub.c'))
 system_stubs_ss.add(when: 'CONFIG_TCG', if_false: files('tcg-stub.c'))
 system_stubs_ss.add(when: 'CONFIG_HVF', if_false: files('hvf-stub.c'))
 system_stubs_ss.add(when: 'CONFIG_NVMM', if_false: files('nvmm-stub.c'))
+system_stubs_ss.add(when: 'CONFIG_WHPX', if_false: files('whpx-stub.c'))
 
 specific_ss.add_all(when: ['CONFIG_SYSTEM_ONLY'], if_true: system_stubs_ss)
-- 
2.49.0


