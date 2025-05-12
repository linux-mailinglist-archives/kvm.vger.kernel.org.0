Return-Path: <kvm+bounces-46210-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 21644AB4214
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 20:17:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B02F116C360
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 18:17:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B4012BDC1B;
	Mon, 12 May 2025 18:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="zEp2jYnC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7D36297A6F
	for <kvm@vger.kernel.org>; Mon, 12 May 2025 18:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073122; cv=none; b=MMNmt9AcnzKH/BFrpK0YkYSilfJPjU5QowmhIymgzhCrryqczaaOk4200n6A8z1ijwM9Lj/gTYL/qcWS3Knd7JkKWDWItVr84nZ7AgeJPTgiwegOnYI7HBC3OIefAjMQCeJJ2D4KQ/YIk7sIAj57s6b1dSE9H661O/gNLIc9KG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073122; c=relaxed/simple;
	bh=npeFhVcp7bJYDWuK4iWg3Ep4yDBvni0WSG+H1SY0QvI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bXRhc7pRTC8Nodf0LdT/lDTgLn+/vPi0Kw7B0OI1Vru67nIRkl/YVQKf1tn5veryEAHEVOoR0ru8i3wTYPaty7rFLEWmQbD+mZMRRgadz3FvH4oDAcEgmkV4wPuEk0ziz4miChMvuPHOA6avHAbGsQqnqDD3zuvHSsHenBOiQd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=zEp2jYnC; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-22d95f0dda4so55840015ad.2
        for <kvm@vger.kernel.org>; Mon, 12 May 2025 11:05:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1747073120; x=1747677920; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PtoWRnhexqhEbtmi9AyX1L5MqLgfQdzBe/SXZsSvaEY=;
        b=zEp2jYnCHAONlpUlj1IvC0GwF52OwRr0MnCJ9aSd3hY46CyLczrXChFWH6k51P5TWr
         uhGoDoI3kQ+mQv1DCd0YjxJ8Efrk0hmgQz7nSzJXjS5E3gyexCZn4SGoBrdtOFIVYQ6i
         sp6fJ6GYU72FVUa7CyRghIxTa7VjwBWBNC1TyX1ecsGyd2K5X2lhljisxS9pJw56Kr97
         QdEDXf2KZt5g+JBxGHuWABRSyupqFtkkvHqDQ7bNmanYCh5GfLWiDer9PXI3Hv67miM2
         tyGHdOzBn5DIDOWZdT2TRtZmXtiXcAzBiYGdERUIuiiVNPDQfjf1w1t3yyv1oIcpnoQE
         UTDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747073120; x=1747677920;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PtoWRnhexqhEbtmi9AyX1L5MqLgfQdzBe/SXZsSvaEY=;
        b=k2SbMpfffAXwkSI+iYKRzr6T+CCusfozOukyWOHiGuDckoWA/0+22DxwKWttAa3vka
         icP41/q1eGG94sIU5vGfriTtwOKUpDmmdehb/rhkoGopeBrJb04RejtHLblFMKbFsR8R
         8vq8Z7v3/DfroVhWDKE8Y87QwZ7YYxftxbtW/lXzZKFKrcEnZnuufv2Cc4DhHRcwTUtw
         ufGkq/Z3Ndb/9hdWeFHFx3NArrWVTfJR7HVpq7ELpwlZ54fhblHV7DEQqTxS3BWixhsa
         oAUp8kvGDU3CVnD2H9g4fvJ38Ba897a7clJ2FeWUV5PLkSXDs0jM1d/yDaQCB3Md/dxY
         LTXg==
X-Forwarded-Encrypted: i=1; AJvYcCXRnx4jaEbiqBFCMy/r+tXtE6lRjXTdwuLioellswD0Ei7C1AsBNRy3uWuEPjxg5NVkKKo=@vger.kernel.org
X-Gm-Message-State: AOJu0YyQf0U7Qqo6GHt8QzACMSRhbCTdwbkjziQYhVrjPZrxdJ/f9fNb
	IT5DUCupe2YJ3mjWdAFD/sFj3bovYuPcWyvuX0v7fDKM601J7CI7oE8t0V7gHNU=
X-Gm-Gg: ASbGncueYBYGq6Yrt+r38UE1G6oicRdOahKY5cX8Ij5eBxRIb0jMnDsg7YZ9YHu0lHg
	xhIxQg0a9poLUPJ2lOu02AcmoalBbKs886ellnwBVNCj5xPkwpvmeraMfqKsDhZTD3TD6r2MEws
	no5i7LB8l8gBCktIih0O19G8B2wVAbdjh2cXk+23eBeDh1zpeIm71lxS/vxrS41J+iC/Z7kruTj
	abicEeMdjrYdTz0SJRhtd4qsrXR4w/txlNHIr88aZNHJtLW3l8ZsWTdKX2E2/i7XBA7A6fKYv2C
	f0ICz5i56WGr3i1Zohb/rVyWLbA8Jcgaz4TyAckG4vrZmyZR2U8=
X-Google-Smtp-Source: AGHT+IG//ZC2tU4+ufVtxaRs88BbVlF8JqsECFJysIZkUPjN2rUU+hJ5AjlLR0rJIxAeA0859MMfvg==
X-Received: by 2002:a17:902:e747:b0:22e:5e70:b2d3 with SMTP id d9443c01a7336-22fc8afeec8mr204881035ad.1.1747073119969;
        Mon, 12 May 2025 11:05:19 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22fc82a2e4fsm65792005ad.232.2025.05.12.11.05.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 May 2025 11:05:19 -0700 (PDT)
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
Subject: [PATCH v8 09/48] target/arm/cpu: remove TARGET_AARCH64 in arm_cpu_finalize_features
Date: Mon, 12 May 2025 11:04:23 -0700
Message-ID: <20250512180502.2395029-10-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250512180502.2395029-1-pierrick.bouvier@linaro.org>
References: <20250512180502.2395029-1-pierrick.bouvier@linaro.org>
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


