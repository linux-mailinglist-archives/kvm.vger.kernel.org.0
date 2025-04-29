Return-Path: <kvm+bounces-44676-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FC60AA018D
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 07:01:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DE6AE3AFE61
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 05:00:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42060274FE4;
	Tue, 29 Apr 2025 05:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="iRdR/RzB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F29502749FF
	for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 05:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745902828; cv=none; b=Q6Knel4h2PAm/CHS5mCEKGB7QrwbcVqpnTm0JJh6ztLTraQwjStqcz5JUKSDTWYrHXhGWnmiesveaNs3iyQFg8fPY5brnB3WqSGvqesItCUODaCHWkGHui9DuY58IQs6u64LeWQBHkwNH2VPqxxNScg3hKRj3w84c6Dxf7KksWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745902828; c=relaxed/simple;
	bh=f9oTCM9lm3aA6YIY+JuoGe1YZtLgUOI9eyLXnd6bx8g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FOv5M5hSnCdterITrvQvztQigtYiHWYjbJkdjJt82ApiAgmmPtDY2ay0OJIV4QYQbua1MCy/oeTvUAZdPgOgxQm9Bg7zFGAAXQZOfQ5IAQvk6H2CZOP3PfDLYIEnmwROV/tm/kz1ZxSOmGXY5VcAlN/+WezU89uYNUvQzdseJV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=iRdR/RzB; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2241053582dso83687335ad.1
        for <kvm@vger.kernel.org>; Mon, 28 Apr 2025 22:00:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1745902826; x=1746507626; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T48CGR80HJJotOhNXvyZIfy4YYqwAzwBstE/RhDVQ28=;
        b=iRdR/RzB8/5S8031iSXX/0brQ8o5TRGi1RHVfB2KkwVULQUvhN2SmS5/t0YSVtD20N
         HLIwvGU/nXJlZnkVl8NxkO7wPvGf0ZUGEmVX3H1oI19uF14jIANPlWjjXivfQGfYA4kd
         ponMGd5fNFed1U409b93QiiKERsddDnKy29PuG2qFZ2Lwt0E/PhSWOoOkyxy0q5SXUHZ
         2DczkxtUarza+ETt6JrwXAmD/rT0wQxQNaGTOMw8zKwQ2PooNdyCqsZbeQMG7GASwWh4
         prt+M015CFlPfloCfdCNZpoLZLu41XxxxhS6OKvn7AOTisFSKGUR1o71evM6n0PavhDR
         SFgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745902826; x=1746507626;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=T48CGR80HJJotOhNXvyZIfy4YYqwAzwBstE/RhDVQ28=;
        b=k8Gp0RAxtNDL91vTlcAaT9Q9rS0w8bKMei9V3uTyGBR8RgnknOs3FjXIONQ7Yi4vC3
         kpHctVvkKpn5/v0DyNlZ6uN9LDHUcDPFm2m+ob9JdQjlVo7qAgJfP5v3adJ/4HVPu1q7
         1s4xpYrbvusBLX9JJ0kkiwcAKF1lCyJd+DeN41S85iYqf9rzlc84wkMatPIC74aAbOBg
         BLepM0GSFkbH24aX1AtTeZmBX2HO2+6ezR2aFc+Q2pDx+xN4cRFOQFSMmUbsMHLqTU8w
         YXdMA4sn49VOBjNcPsODiFpnVbxIRrG6kSk4a7j51IzN5UYGUeNoDLY/7rvCwksAvvC+
         Dvvg==
X-Forwarded-Encrypted: i=1; AJvYcCVlR1iJR9jZvfP8JRJhudZEb+ievo6RljDb7N0GgQhOnbT7Ntq8zDPHJJCEZjBiupM2xUg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzFEKvl+pFiXF7bYxP949xwx9GQ2P5bh+bTMJYnEPvdnoD0JM7a
	yBe1FlQ/Jn5VvVS/AxFLqVG/MRJv7nyG/mnzMSNhZfOkfJaExJdemy+dOKQHQoM=
X-Gm-Gg: ASbGncuYW4UIrzX5YOC4KNKnmA/fP84K4A4K3QZ5ymCSuvuMyQttnEn03gi+JVAt5bA
	m3QpJ+C+CELoCHrXaXzfiBTZKjK5qjw0u7HF3I3ZAEmQMWCs0qRJemYVM17VyXDSLXlGEP842ZM
	9i4xMHo80b0Wd2PYzp1OcBjWDHNrtrphN4hHZ3xY7idycVO1zY1ZbU0nNhlLVRz08gGqnbHywiB
	nsgjozzuQ3lUSkSdGRBBSMSZcHz9j4ke6LMdS6t3lEpZA5fikoJqbQJ7OzYHRi4AJ2kpr1/0MFG
	F5Zgdqt8PNZDWyf8Z8taZvThgY+hfl4vtcjTtlXo
X-Google-Smtp-Source: AGHT+IG/bsI8Plp6wLuUi6N8xxtzsYztKsAI19kdOE80Gua3/ANpLwzdO+O+AKBzWj5n2J/cQnM0Ug==
X-Received: by 2002:a17:902:ea01:b0:224:1ce1:a3f4 with SMTP id d9443c01a7336-22dc69f83eamr176304425ad.1.1745902826200;
        Mon, 28 Apr 2025 22:00:26 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22db4dbd6f7sm93004015ad.76.2025.04.28.22.00.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Apr 2025 22:00:25 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	kvm@vger.kernel.org,
	alex.bennee@linaro.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	qemu-arm@nongnu.org,
	anjo@rev.ng,
	richard.henderson@linaro.org,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH 11/13] target/arm/cpu: remove TARGET_AARCH64 in arm_cpu_finalize_features
Date: Mon, 28 Apr 2025 22:00:08 -0700
Message-ID: <20250429050010.971128-12-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250429050010.971128-1-pierrick.bouvier@linaro.org>
References: <20250429050010.971128-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Need to stub cpu64 finalize functions.

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/cpu.c         |  2 --
 target/arm/cpu32-stubs.c | 24 ++++++++++++++++++++++++
 target/arm/meson.build   | 11 +++++++----
 3 files changed, 31 insertions(+), 6 deletions(-)
 create mode 100644 target/arm/cpu32-stubs.c

diff --git a/target/arm/cpu.c b/target/arm/cpu.c
index 48ebaf614ee..79a853609dd 100644
--- a/target/arm/cpu.c
+++ b/target/arm/cpu.c
@@ -1908,7 +1908,6 @@ void arm_cpu_finalize_features(ARMCPU *cpu, Error **errp)
 {
     Error *local_err = NULL;
 
-#ifdef TARGET_AARCH64
     if (arm_feature(&cpu->env, ARM_FEATURE_AARCH64)) {
         arm_cpu_sve_finalize(cpu, &local_err);
         if (local_err != NULL) {
@@ -1944,7 +1943,6 @@ void arm_cpu_finalize_features(ARMCPU *cpu, Error **errp)
             return;
         }
     }
-#endif
 
     if (kvm_enabled()) {
         kvm_arm_steal_time_finalize(cpu, &local_err);
diff --git a/target/arm/cpu32-stubs.c b/target/arm/cpu32-stubs.c
new file mode 100644
index 00000000000..fda7ccee4b5
--- /dev/null
+++ b/target/arm/cpu32-stubs.c
@@ -0,0 +1,24 @@
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


