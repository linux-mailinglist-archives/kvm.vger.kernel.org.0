Return-Path: <kvm+bounces-45304-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 02230AA83F8
	for <lists+kvm@lfdr.de>; Sun,  4 May 2025 07:30:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5DD563B4D2A
	for <lists+kvm@lfdr.de>; Sun,  4 May 2025 05:30:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E850619539F;
	Sun,  4 May 2025 05:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="B7itvSOn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D2141684AE
	for <kvm@vger.kernel.org>; Sun,  4 May 2025 05:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746336572; cv=none; b=BLafQoHc8/va3P8VrtABbSWF+2CdHDNC6m6cjw1l5N3qT7Se6K8Fow5ZgjF450Lu8j80BmLbBrTU+MhEl+yVb0RUnYX6q8GHb9IbAe8Yvpb4fhsRFtHUm+L8ena4L0Gds6W0wQy51rb5YURMoKyZyBGDf4pDTtl4DkdhuFFEGnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746336572; c=relaxed/simple;
	bh=b4RhuUTn7wbUWIpTpKBvX3wln3w0SUQUpRHTYtYOW9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kQZcjXlJWxdKhuCaQXGNj9lijUQ2N5aF/q/vNgIhb63WBan+d6wUaarCVgF9uD7xY1ckMnBcSGsGKXkjsyYB7oSYEfobauQCTnuTdYOh3sWksMV5nEIF+oOM4t0SbFIZ6uHJ4Zncwd8MQqualX0cupbvzWh5lNYmUipYiOyow2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=B7itvSOn; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-227b828de00so36463405ad.1
        for <kvm@vger.kernel.org>; Sat, 03 May 2025 22:29:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746336570; x=1746941370; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xML4J0OK01b5ZM+8qKTIYRySQNd3gi0WVCRNgOjS4SA=;
        b=B7itvSOn/mlLiiLdDm4nxEMrgZSHHBovMUc2MofeQFWbGUwwRsgddd20m90ZwSrgQE
         bDXPa8IunUCfidQi1IXeQvXk70GC0In5qz941FWwyeDD0kNly7R37ocryK35xCiksQsx
         jbxNMktYTemXTXvFkwlDIWmKA3Tr0GXnniAf+frlyNQzyRnfB8di8a//hlpbsZfeGqBs
         TfsGcGAItQ83BNywpeRHKKrCwuFiUSGYFbdC7cTwU5AaiTwNhNjPqjAX8q1yebivpE29
         917PnuU4tscyIbO16B04Kj89mkwIgwyFkKiZasmepKEy8WsvoFmLXpw9IvmT2dT8eN7m
         21ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746336570; x=1746941370;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xML4J0OK01b5ZM+8qKTIYRySQNd3gi0WVCRNgOjS4SA=;
        b=mHUAEQJhrMN61rfrRJxAVHok7kypKO85HqmzGHk8ik5Y9F4G4Wae/9RcWs+sRVCUYH
         5vIokI9m9UBmsQNPyFGYcwOR0e32LzTAoyKMv61x5j7ipT6Rz9vVhLhI1nLOyMc7QO06
         Y8r9t2dz4OYyBhdhv1CYzZyVVg3ldCO1VAptt6JF4MCsC3Ye1ZqJKTnFJwRbv4F2uMoS
         5dI7du1fd5D1TkHde2o1+qoTomLtVIIhro0Wq+wk2a+CXxv9ScaJMZmbUAD5K3VM2aN2
         n1Qc/kdWEfSopBYCDEbxD89AumSl8JjugHLc4kcjcur1DKuIz1s9Df62KYKQFUWjfKWl
         e9/A==
X-Forwarded-Encrypted: i=1; AJvYcCVNiBCHl2zX6eZLE5t4qM96bEoodxNp+k4EpwSx52AtMSR+mfAsIVjRST1GSDE/J+yqTkk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz2ogbrmxVyHR9OcGvbvjscNBNevbZ3klfG3JYVfH0y31XvIWE1
	2pQDdFlZyIXHBfaNWRj7X3ogns5usGJw9HiUAfMViuvVyyNpTC//uqw0ut9AS48=
X-Gm-Gg: ASbGncuqULR2MwQprM7IrE53wxGodsoKEwE7XRFCxgnzEbdl7nTPx9N56aA0chDPKtt
	rQ3Y8cxHsT4Z1bdE/5RoWpEabviJ7GO5C84yIN9ZAp5gpXPiSpNtwIbrNeMu0m3aQIacx4wwsEk
	Zj6INQj7ZGx4qYuCpGNpu/vqPAZ3Rv8maunAAByMQAdU1M6ZC7fQu1w7PHXzeTLSKsmyMm9L1r0
	qwpyuT8LM8wmmBtqfIztxS0Ys2uVN66EocAvwXq6aFY8oNTS+TkrnptSb64f98DJMondJ/5ju1N
	GwyZuPCc36Pn67W8nRSBNbvd55rSSfuDhzg/9jzW
X-Google-Smtp-Source: AGHT+IGNaTTaB8sCjmP0kKNqXdhjM/rwql0XWgva5vnqXht3KrNf9a4sAy7Da4m17fBBAvj9OgJobQ==
X-Received: by 2002:a17:903:2452:b0:225:abd2:5e39 with SMTP id d9443c01a7336-22e18bfb5e1mr69676795ad.30.1746336569982;
        Sat, 03 May 2025 22:29:29 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-740590207e3sm4400511b3a.94.2025.05.03.22.29.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 May 2025 22:29:29 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	qemu-arm@nongnu.org,
	anjo@rev.ng,
	kvm@vger.kernel.org,
	richard.henderson@linaro.org,
	Peter Maydell <peter.maydell@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	alex.bennee@linaro.org,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v4 11/40] target/arm/cpu: remove TARGET_AARCH64 in arm_cpu_finalize_features
Date: Sat,  3 May 2025 22:28:45 -0700
Message-ID: <20250504052914.3525365-12-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250504052914.3525365-1-pierrick.bouvier@linaro.org>
References: <20250504052914.3525365-1-pierrick.bouvier@linaro.org>
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
index 00ae2778058..c3a1e8e284d 100644
--- a/target/arm/cpu.c
+++ b/target/arm/cpu.c
@@ -1878,7 +1878,6 @@ void arm_cpu_finalize_features(ARMCPU *cpu, Error **errp)
 {
     Error *local_err = NULL;
 
-#ifdef TARGET_AARCH64
     if (arm_feature(&cpu->env, ARM_FEATURE_AARCH64)) {
         arm_cpu_sve_finalize(cpu, &local_err);
         if (local_err != NULL) {
@@ -1914,7 +1913,6 @@ void arm_cpu_finalize_features(ARMCPU *cpu, Error **errp)
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


