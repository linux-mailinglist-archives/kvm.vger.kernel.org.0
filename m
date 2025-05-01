Return-Path: <kvm+bounces-45039-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F9EFAA5ACF
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 08:24:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DB2B31BA7327
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 06:25:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5EF952777E5;
	Thu,  1 May 2025 06:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="QxpZQoFk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A23B275861
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 06:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746080642; cv=none; b=DccIJ730X3zaDc1kK0PKUZHJuw0ILmZeIC7Q5kYg8Yi6tv9wnUH28GfiCSE+SKnNME6wlOHcYR/Ho41nbZAdYOKyGfKNpgDr+aut7PJVPxCL9/NFUwdIQZlnr3RAo/HWhJMPRJylrmuVrEooIjevDNSjvKYjt4kONC+cv7KPKk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746080642; c=relaxed/simple;
	bh=cCQpOqYW1KzzxPOAPGmDHONjn5jZ3VUxRbb2xzOre3w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PeUsK7NP6lzmxSpcGS3RRIt6hD5MuFqwX6vdeqXfchrqp5oQmUW3hlI/LX713dg6gHjBOFAVLtTpUZvNPlPsGXvJAqu6sXOfbD5lPEyM9Lkl5pCoRLqzDrSmzaEZhkFo6szPFkHVQeyO43RFqWL23G7yFhu7iBVDT/83Il2FsHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=QxpZQoFk; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-736aaeed234so664448b3a.0
        for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 23:24:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746080640; x=1746685440; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iUi/Pm8PBuXUf0tGsedeIwPfTJbQS6s9US0oEnWDi/c=;
        b=QxpZQoFkpxNxkdYcumDHRBzPCP9c30pF7uawcFA9//x4AZr6/L03PQVlVGvqlKdzjC
         4Mn+VgifXkpgoUl6Ppa0iEDDydMgR/g8pizS4XrG3p1cG5CQEriRqjx2xSrkLSIOeZRR
         dlxtZZw1Y92mgH6qa9iflHDjrpaVVFwxsIHgDLalbSrXPDzEbIPyJwOdOR9JAoSbqBUv
         NBhIwtlY/khASJRq+VlLSmZvv9IsZ+E1T6n14yhUNAvP7spxsHO4Ilpyt5la+jwJ36Aa
         Tk9HVuMnfzIi7rPXVrp6Z7mUyVEz3ig0DRcWDC14Loh/lUoi2qfivLRaHD5IlJx743Ty
         X7TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746080640; x=1746685440;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iUi/Pm8PBuXUf0tGsedeIwPfTJbQS6s9US0oEnWDi/c=;
        b=lzcUq6M8AhZ/wmUeMTqf/z9LArsU+MXcKcbBK0w6m7+IC4httHoG1jwRDEFkgGEGcL
         qVXBMS7G/hImF9bdi4s9ngDICX1j8UXRK6GVhBxoLP1XK0Dcn++CpHWOVCZpMYagwl3z
         J5njtWjlExhnhsx/DIoVcSM32X4DGFzORXgOrpSAXa5gk3xMOntfGMNYRnk2MnHon0+R
         CHCBUEipKgCEGg3gg9NXxH5E8+vbN5+ZDlF8orP4zpSSf85PoPM2aG7m9tRug09t5uVa
         p7rKhB2OKV49aIO8XPJ80Og9jlYa6AYfceFd2OhK3NpUTTo+UMVHtu5G6mqqsUWet3eJ
         JwGA==
X-Forwarded-Encrypted: i=1; AJvYcCVLn9aKawEdci3YS5AKIFkyIrI1BDHnZPJED9d/82cWqKrfBEJDdp+NBq3qsZVCT4/0Uiw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxEYhM2XP5oOGwFeaRFiVawmII+lyV9+jcs6ZZwxvEBUw26VvKH
	YKkvPH6H/0oYIOkvrKCwy1u7ALwtuwBGuZaewGYNBpe9UiYPszDa/O712XUbZFbT2C18DmpYEND
	M
X-Gm-Gg: ASbGncvToCaGYTs629Yd2pj3+D705Feu5hoNtk/RNYelyvHWAds1YHROcBzOnpGQTQ/
	Hq260DBxDGoXopDgbcfq9xqunHJdh5g/FXuRXb8PzHO11JEJ4fckl18qROkMP6eULjm6+9iQASg
	Tgb1kyV6Dl6QfDroV4Xg2vgD6BEX3xl9L8+tCO96zIf2TqAy3EaoC5mtQqOoEXxnlIqHHUUt75t
	YFDZm2D0JHoEajDGjpi3vt494jxy/xAAIhgPbuA1UuQ1LFcJLqc7mKwPgVloLD7zncwezJyESvG
	JgdSlik3tY8z2R5aaraYfUHWYM1XN7xH5eoJL8xC
X-Google-Smtp-Source: AGHT+IEKCWILcumjzPYh4K88LZx1Ow96si8ow9v9pGjanxvrTsUmYYaf0THPQ+j/vY9E0cJ9TrpOqw==
X-Received: by 2002:a05:6a20:3942:b0:1f5:7007:9eb8 with SMTP id adf61e73a8af0-20bd6a55a1fmr1761624637.16.1746080640303;
        Wed, 30 Apr 2025 23:24:00 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7404f9fed21sm108134b3a.93.2025.04.30.23.23.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Apr 2025 23:23:59 -0700 (PDT)
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
Subject: [PATCH v3 10/33] target/arm/cpu: remove TARGET_AARCH64 in arm_cpu_finalize_features
Date: Wed, 30 Apr 2025 23:23:21 -0700
Message-ID: <20250501062344.2526061-11-pierrick.bouvier@linaro.org>
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

Need to stub cpu64 finalize functions.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
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


