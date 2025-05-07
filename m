Return-Path: <kvm+bounces-45776-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FFB4AAEF61
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 01:43:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B38B41BA7A5F
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 23:44:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BB802918C4;
	Wed,  7 May 2025 23:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="lCFUjcCY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC1F62918CF
	for <kvm@vger.kernel.org>; Wed,  7 May 2025 23:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746661374; cv=none; b=Gd4PIj5RRgsmiw6nQjlp/BsIr6SCC1o6lwytTKXUIzwd211tJdKKXgECVu6kSwV+sfQ7CI63Ao0llvOplzUxuRrYEZ8ZIv53JnJoRxUiG57Ld2kHWIb//2ULtaXKB+zjbf8nwZ5f5jeNxidiBT3tBLw8HvmdCu0eWW6tIHGx7gg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746661374; c=relaxed/simple;
	bh=npeFhVcp7bJYDWuK4iWg3Ep4yDBvni0WSG+H1SY0QvI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=u//+ej3Ct5/0SYxF4o1kTYvdToWyUu1wxW+XbJ00b9xVZABnnz8a1jR4h14dhu3ZDg0ugMv3dXypARrgMYe7ix6X1POjjr2vDNaup6NdkW2uw/FvM7Q1lb1+QaOqJVL0XZr6Q2M3A3y7ILdK30kYYvhSGSvqCo7gHe/31xRz3ag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=lCFUjcCY; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-22e5df32197so5420635ad.0
        for <kvm@vger.kernel.org>; Wed, 07 May 2025 16:42:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746661372; x=1747266172; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PtoWRnhexqhEbtmi9AyX1L5MqLgfQdzBe/SXZsSvaEY=;
        b=lCFUjcCYeQN4WWhHSiEm1SDa/5322tlxn2EEOQLCa01u+8Xgq/hO+DuSlma/3RJ3bC
         HApVC654s7SrcyKbBLrDkMPU/xfJxK6DRMwxDVbgcmRGj2TGT31qKCJKJ3X3fAfV8zJQ
         exHAdNWp73mycSYQIxMyBPaxOivIpDcqF470YRDmeM+aThVJ54DiJ4auRUuQelBGdXv9
         hd6QRYs/rIaLufyfJACTVExLQ5D7yH34qA59/yjm/TJwxnbLqiwxeFbmJWIme9bdtcDE
         +5cfB2erX2rrCnJ8CPm+MAbPXpo7qbNakVT6RCtRZmv6bYzgQMq/7Chew7X6RAxEg/dM
         o2ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746661372; x=1747266172;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PtoWRnhexqhEbtmi9AyX1L5MqLgfQdzBe/SXZsSvaEY=;
        b=SA/Xj8AopL2vVjNbbKykZj5BJQj5sXYqgm2Fnu5qhG82q+yOA8xVHAWvGvUbDNAF4X
         yLy9Ko2ZzOv796ImIkdlPrywURGr/6nmissXfYdJWeBHc96WO/hj1Rlfwn/dl+LrJP6/
         iBmYCVzdTzl5Pd6KEtlvwmllB9fCu73ZXROk4/CACUXlDIcbIpH6Seuun/BFgIy5IRPV
         IM/u6JM1Wc3mkhlkiNmJRr4VyyiYEujLuihM+Wh9ivFwXMQiMKs++6ftfNI7F6VrJx+f
         Bp9AIm7seNs2Rmnr71wQbPl5BcQHimPLmj1YrnuyEpPWaJJfBi/FNI7q+t+VcgaKCntS
         /PRQ==
X-Forwarded-Encrypted: i=1; AJvYcCWNCbyubwH0t1UizCBSdCLlhuSkYOq+04eLMs3AXffsSQEG5q6H/66/ArMlAwsd5EUy0Io=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxmk7hSSlaO5+YQPTfJAy/puqrpt8ffGj/lDsWZ/7+RpZJG1XSq
	b4TUiYmz0HHtC+XNU7LxcWl92HPHhGTzeDOODfZd3+7Ww0BkuAtIqgW6Qwlym0Q=
X-Gm-Gg: ASbGncsZkZaExXmazEOX8ISeMO1g0MkAMU9xiF6NXUljx6ULhpHC8jX5stgMDRWfQ2l
	qXZzKJ7jrG+oweGF+DZhh7hYXWJCmJjdobTONA8lpI4uqk/lHwkmr2qo7AdzuUp+VV+UH5HgoL/
	x8wrbtfjLBAMxZS9MhgAI1jjwjh5Zb8YhTvE6WeyqjONuW8Z7O/9aYkMhVO7luaoyJuLU5pqjIk
	OiiVDhcnbN+aAsc4bXRVEavfJkegAxygFt8fvUNyPLTgETYv6oOEDHYe+Ffi+UBuRLweaxzYDMO
	MHx4UkdjkhdS+c4DRiXRufbUpe/nlSixqz14Do/c3RBKn7eBduM=
X-Google-Smtp-Source: AGHT+IGz/1Yr+OHRltxAQC9cICgktOobj+PQsbldqBW/j2h25G+9WHd6ECUvH2fDziFXcVGW5vntTQ==
X-Received: by 2002:a17:902:ca95:b0:22e:7971:4d48 with SMTP id d9443c01a7336-22e79714f3bmr29689785ad.45.1746661372116;
        Wed, 07 May 2025 16:42:52 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e815806fdsm6491325ad.17.2025.05.07.16.42.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 May 2025 16:42:51 -0700 (PDT)
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
Subject: [PATCH v7 10/49] target/arm/cpu: remove TARGET_AARCH64 in arm_cpu_finalize_features
Date: Wed,  7 May 2025 16:42:01 -0700
Message-ID: <20250507234241.957746-11-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250507234241.957746-1-pierrick.bouvier@linaro.org>
References: <20250507234241.957746-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Need to stub cpu64 finalize functions.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/cpu.c         |  2 --
 target/arm/cpu32-stubs.c | 26 ++++++++++++++++++++++++++
 target/arm/meson.build   | 11 +++++++----
 3 files changed, 33 insertions(+), 6 deletions(-)
 create mode 100644 target/arm/cpu32-stubs.c

diff --git a/target/arm/cpu.c b/target/arm/cpu.c
index b97746faa87..a604e4ccac8 100644
--- a/target/arm/cpu.c
+++ b/target/arm/cpu.c
@@ -1877,7 +1877,6 @@ void arm_cpu_finalize_features(ARMCPU *cpu, Error **errp)
 {
     Error *local_err = NULL;
 
-#ifdef TARGET_AARCH64
     if (arm_feature(&cpu->env, ARM_FEATURE_AARCH64)) {
         arm_cpu_sve_finalize(cpu, &local_err);
         if (local_err != NULL) {
@@ -1913,7 +1912,6 @@ void arm_cpu_finalize_features(ARMCPU *cpu, Error **errp)
             return;
         }
     }
-#endif
 
     if (kvm_enabled()) {
         kvm_arm_steal_time_finalize(cpu, &local_err);
diff --git a/target/arm/cpu32-stubs.c b/target/arm/cpu32-stubs.c
new file mode 100644
index 00000000000..81be44d8462
--- /dev/null
+++ b/target/arm/cpu32-stubs.c
@@ -0,0 +1,26 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+
+#include "qemu/osdep.h"
+#include "target/arm/cpu.h"
+#include "target/arm/internals.h"
+#include <glib.h>
+
+void arm_cpu_sme_finalize(ARMCPU *cpu, Error **errp)
+{
+    g_assert_not_reached();
+}
+
+void arm_cpu_sve_finalize(ARMCPU *cpu, Error **errp)
+{
+    g_assert_not_reached();
+}
+
+void arm_cpu_pauth_finalize(ARMCPU *cpu, Error **errp)
+{
+    g_assert_not_reached();
+}
+
+void arm_cpu_lpa2_finalize(ARMCPU *cpu, Error **errp)
+{
+    g_assert_not_reached();
+}
diff --git a/target/arm/meson.build b/target/arm/meson.build
index 3065081d241..c39ddc4427b 100644
--- a/target/arm/meson.build
+++ b/target/arm/meson.build
@@ -11,10 +11,13 @@ arm_ss.add(zlib)
 arm_ss.add(when: 'CONFIG_KVM', if_true: files('hyp_gdbstub.c', 'kvm.c'), if_false: files('kvm-stub.c'))
 arm_ss.add(when: 'CONFIG_HVF', if_true: files('hyp_gdbstub.c'))
 
-arm_ss.add(when: 'TARGET_AARCH64', if_true: files(
-  'cpu64.c',
-  'gdbstub64.c',
-))
+arm_ss.add(when: 'TARGET_AARCH64',
+  if_true: files(
+    'cpu64.c',
+    'gdbstub64.c'),
+  if_false: files(
+    'cpu32-stubs.c'),
+)
 
 arm_system_ss = ss.source_set()
 arm_system_ss.add(files(
-- 
2.47.2


