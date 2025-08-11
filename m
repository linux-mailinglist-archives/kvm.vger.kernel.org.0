Return-Path: <kvm+bounces-54424-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 572C8B212D0
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 19:07:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 12C893AFFA0
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 17:07:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BCC42C21C2;
	Mon, 11 Aug 2025 17:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="IYnZB5xY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C9924315A
	for <kvm@vger.kernel.org>; Mon, 11 Aug 2025 17:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754932009; cv=none; b=IVyWy+esW2kpJvWLQ/z5GwKW0tGM9li40lPzG4raqpt11EZv8Q9WQZr/D93KehlPROOZlCVv2wLpCJYLRtEH9zLOCmozDQe7XNythn0DFJGd5YnJZOAf+8+qosQRah/poyPS5Ea3lfkH14+5kFImDYB7t6LV8+rI5OmVRh0o9aU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754932009; c=relaxed/simple;
	bh=XgNpQqPLm2Mgof8VqzT7sK/E2A/0TxSzSG8c6ByDAVo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JkdmiWZJI+vHetCGGZewea/skCmsUTyFk7i+tnsGxkjEAlMyPR0LKpVdRwRsp7VigIxZBJrXSNqHzeQrHYj1NKiIumdqe8fr7dsBbUxE1JkuJAnJdr1j8daq2wep1YjCPa5jOpOEdZx6oJakSbkfBQSJ0Q8MT9de6lElM4IMg+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=IYnZB5xY; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-3b78d337dd9so2863798f8f.3
        for <kvm@vger.kernel.org>; Mon, 11 Aug 2025 10:06:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1754932006; x=1755536806; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+MJUQ+OQJ9HkeNlMQlODjCm+Oh2wh/gShIDZyY6yH20=;
        b=IYnZB5xYPu3vKHHY1k2wIu/8jYYBeTIWU2nvLayXkNmYC7DBNyNtX6bwGEa+3tKH9M
         XbHpOfP9rCVKX+jOhDMuz152LFFeHIXicT9bMBz7b78mAy+FCHC6MOvRJ2P431Ga7Spa
         uFkGqSaQ018RMMFM+A+1CDeA4uGZXb+g7Tza8nn9on7nNqCnApxkqsFykDyUvEYpBxnf
         VA2qMoEH9QQQZdAvSQRRggNxbHS06p4rqfhY/XTV2/K5qCX8KTlQhnG0uXZ3J67J08pv
         dlm7hGJaTuFJC3VPqSsge2b4spMtHIbSRxEg7DI3zbNtK+EJvP44trxXPBdbECqFW5SO
         yc9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754932006; x=1755536806;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+MJUQ+OQJ9HkeNlMQlODjCm+Oh2wh/gShIDZyY6yH20=;
        b=lQ/tfPVQprmR53dBQcbI4yv42fWxhvs9IRTCFhGBT+9n43LRoSoP7Y1e19W7niPUJi
         Kv0O1B+mNydBj+36bYs7KqnXc0HZgfO3PLgfXrDhoYVeNfU5wuxFAOh1N0KOsjef0wuS
         21ppWvYM+WF3C1fqzzD4V+GRUs/Q9ezPh+vW5c9sjXab1xpLLJi0nI5JbYlHUAO5oqvs
         dhFK5jl1JyDSsCsb7ES5s0pkzAfpb6J0OCH9TzAczYRrIKJiTlrHVo19uUx1BwF4+QrH
         2aRzJA/fWg6ngWePyeGNBB9r9th7SvvAoWfyvPYu/0+eugyMQs3kQzuL0aoWfqAlpvA3
         qkfg==
X-Forwarded-Encrypted: i=1; AJvYcCWza2k0hSoF2meM6S5ZhYC/Q79eoc7q8ney6OKqDzcCHnp+89DAJ/btsKt1fyiEy0CU19c=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz6m/P9isYgAqJggS2mseN+kvXBGwV3QpsUvLjRhq1+pWq/zLeS
	YbQt/bfsxrsvE1UfZPY5TjB8GaLq3hVh8w2HNRWJHlQI+xqbd0tn4Ot2f3TsGawLhQU=
X-Gm-Gg: ASbGnctLG0y8jcU+1BrPktxGjTjXtYtK2UnNFYub+Ddkmcts544M55+G9GjaT6T5alL
	K7Zw0hnein53eHu753/UnFV+LV9ia24IuCVFphadhKBwJD4DpF4tP9gnU2vjK4hqdnHwofp0Acv
	OYEPEwts1eiWZfm9UZJ8DStcVtuNuQoHtUFJH+Tyk9gZ/6JVr1cbvIVkv1bXAEmjtVwRtK08Ktd
	38NS1qb+pkMzRHy3rF/tcx1dzSEM4fhr63NIrwdfIUf2CKZvTKofJT6ENQrVOT4JUQJADR8AuCq
	Nk7hOzGZUV8X042Q0SYb+KqePbBNcyDWMr4/lkHNZwgvKIld+gNVo28ome7DgTK5jST8CR/0xmT
	FPCbCE5AnJNXdhPHDGdSrSiekRhL/5TKRb2P39cs8QQBpoaUAf7iyK6jKuuGssZq1VqhEbC9m
X-Google-Smtp-Source: AGHT+IHQU/+29t09xJxuB50pqa5k+Bpb42xmnALPPoJ7HYs9t6XhwQxWVIBqxqWkJr4ZvR5q0iDpcA==
X-Received: by 2002:a5d:64ef:0:b0:3b6:12d9:9f1b with SMTP id ffacd0b85a97d-3b900b2de3amr11005330f8f.22.1754932006474;
        Mon, 11 Aug 2025 10:06:46 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-459eff7918csm196801235e9.25.2025.08.11.10.06.45
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 11 Aug 2025 10:06:45 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Miguel Luis <miguel.luis@oracle.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	kvm@vger.kernel.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Haibo Xu <haibo.xu@linaro.org>,
	Mohamed Mediouni <mohamed@unpredictable.fr>,
	Mark Burton <mburton@qti.qualcomm.com>,
	Alexander Graf <agraf@csgraf.de>,
	Claudio Fontana <cfontana@suse.de>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Mads Ynddal <mads@ynddal.dk>,
	Eric Auger <eric.auger@redhat.com>,
	qemu-arm@nongnu.org,
	Cameron Esfahani <dirty@apple.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [RFC PATCH 06/11] target/arm: Introduce host_cpu_feature_supported()
Date: Mon, 11 Aug 2025 19:06:06 +0200
Message-ID: <20250811170611.37482-7-philmd@linaro.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250811170611.37482-1-philmd@linaro.org>
References: <20250811170611.37482-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

host_cpu_feature_supported() is the generic method which
dispatch to the host accelerator implementation, taking
care to cache supported features.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/arm/cpu.h          | 11 +++++++++++
 target/arm/arm_hw_accel.c | 27 +++++++++++++++++++++++++++
 target/arm/meson.build    |  2 +-
 3 files changed, 39 insertions(+), 1 deletion(-)
 create mode 100644 target/arm/arm_hw_accel.c

diff --git a/target/arm/cpu.h b/target/arm/cpu.h
index 5136c4caabf..aff60cef6da 100644
--- a/target/arm/cpu.h
+++ b/target/arm/cpu.h
@@ -2508,6 +2508,16 @@ static inline ARMSecuritySpace arm_secure_to_space(bool secure)
 
 #if !defined(CONFIG_USER_ONLY)
 
+/**
+ * host_cpu_feature_supported:
+ * @feat: Feature to test for support
+ * @can_emulate: Whether Allow to fall back to emulation if @feat is not
+ *               supported by hardware accelerator
+ *
+ * Hardware accelerator implementation of cpu_feature_supported().
+ */
+bool host_cpu_feature_supported(enum arm_features feature, bool can_emulate);
+
 /**
  * arm_hw_accel_cpu_feature_supported:
  * @feat: Feature to test for support
@@ -2515,6 +2525,7 @@ static inline ARMSecuritySpace arm_secure_to_space(bool secure)
  *               supported by hardware accelerator
  *
  * Hardware accelerator implementation of cpu_feature_supported().
+ * Common code should use the generic host_cpu_feature_supported() equivalent.
  */
 bool arm_hw_accel_cpu_feature_supported(enum arm_features feat,
                                         bool can_emulate);
diff --git a/target/arm/arm_hw_accel.c b/target/arm/arm_hw_accel.c
new file mode 100644
index 00000000000..3a8ff007599
--- /dev/null
+++ b/target/arm/arm_hw_accel.c
@@ -0,0 +1,27 @@
+/*
+ * QEMU helpers for ARM hardware accelerators
+ *
+ *  Copyright (c) Linaro
+ *
+ * SPDX-License-Identifier: GPL-2.0-or-later
+ */
+
+#include "qemu/osdep.h"
+#include "cpu.h"
+
+bool host_cpu_feature_supported(enum arm_features feat, bool can_emulate)
+{
+#if defined(CONFIG_KVM) || defined(CONFIG_HVF)
+    static enum { F_UNKN, F_SUPP, F_UNSUPP } supported[64] = { };
+
+    assert(feat < ARRAY_SIZE(supported));
+    if (supported[feat] == F_UNKN) {
+        supported[feat] = arm_hw_accel_cpu_feature_supported(feat, can_emulate);
+    }
+    return supported[feat] == F_SUPP;
+#elif defined(CONFIG_TCG)
+    return can_emulate;
+#else
+#error
+#endif
+}
diff --git a/target/arm/meson.build b/target/arm/meson.build
index 07d9271aa4d..37718c85666 100644
--- a/target/arm/meson.build
+++ b/target/arm/meson.build
@@ -11,7 +11,7 @@ arm_ss.add(when: 'TARGET_AARCH64', if_true: files(
 arm_system_ss = ss.source_set()
 arm_common_system_ss = ss.source_set()
 arm_system_ss.add(files(
-  'arm-qmp-cmds.c',
+  'arm-qmp-cmds.c', 'arm_hw_accel.c',
 ))
 arm_system_ss.add(when: 'CONFIG_KVM', if_true: files('hyp_gdbstub.c', 'kvm.c'))
 arm_system_ss.add(when: 'CONFIG_HVF', if_true: files('hyp_gdbstub.c'))
-- 
2.49.0


