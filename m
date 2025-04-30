Return-Path: <kvm+bounces-44931-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9515EAA4F5A
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 17:00:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D5BD9175904
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 15:00:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A45F51BD035;
	Wed, 30 Apr 2025 14:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="fCNxEjRs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38C192609EF
	for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 14:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746025141; cv=none; b=FLuN6RaQVTiH4MxW1f9ftEsHFHhF031nKgqDo2v4X1k8jzWwUMeXR5048Z8yODDSeWDMIErZMxrtFehfYd8aDTN+8gtBdQZdB7g9vHC9USG+MjDeHakZsYCoiq/K8VYmjeF61Fw7Xqo0r2tzmgjJm34Q+6nyajKSzAmAhVhsQKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746025141; c=relaxed/simple;
	bh=MJGxmioMS1DxsqmE1srTSNd0gc38A9IawaLddhg86AQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NCqueyIgcG/0gpKvR3VENFggP9gyyw17TRXbuMOKclvtmdlMjvnflEP53QWLrdLh4121ttFRUUX5nZ9vC0QiiHaIFt8G64GqXWE3lpYjxG8R+B6cpvtOsb1SdvPcAMg0TraKQUbMqPFKWcjFUwIPHUfYuYGsDFIlSDI3ztboRXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=fCNxEjRs; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-3012a0c8496so5948463a91.2
        for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 07:58:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746025139; x=1746629939; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ijNdOguPfwk3cK3WhRDHWMHgdilsTL/0Rfwd87XXhiw=;
        b=fCNxEjRsPiiKrOCcBaeRbe0jIjmql0AN1Dykn8NEr0sBZcc7eBSw95MPAvOaJ0ZnLg
         9dwqPBmhdsVhoS2sduV8cPHxNn78Cyr/XfiO0SBzral2o3ff8ZVJ2jL6mDgj3IR4sQFe
         TVgn2mRZii1o5V8RGxa8EWjdgQK4GHjxK4kNlrzp1TuOxbr7zraDQpvrx+5f1yGWFUxb
         kYnNPYkkY/2nCKCxEmB+EVxfmzvFriOH5Vt5sb3mi6J6jwKR4DiK8j5ACY5U7GdEP2VM
         Rp8rzkuJ9RJLO6QW4CR2DkZYtpnI7UY7pmpRIU/2aqIS6KyOc86zY1NAsHXddJxfR3EX
         775A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746025139; x=1746629939;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ijNdOguPfwk3cK3WhRDHWMHgdilsTL/0Rfwd87XXhiw=;
        b=eN7zwt2UmmMxLMrgt5s/ZHuJRtsnZ2jOQVrZ4ay0kS6WF0dAV69ueI+toYxHIQjpof
         ksvS3ULr70impclZweLEMK9/1XaIjwC2XjywKdswqqnjPA5K0YAXhRvXKu9v8DqPVcKT
         rkCLEwWqv86ROi1HFi/NjMG2aPeyYjtlKC7BuYKHa9DRKcMgo4T3gKHOToof7ZUnP4zx
         76RVnxkbN8YPsiu03sOf4Unl3MUq6QVmO8aNrkTuesc9+qgniTbYqrghk8WbltFsreWn
         ycIP62jfhtnnPoYHBJg9os8xAdtRWVUhiVsuiNFckHRouT2MCjSeblKJi0pXMtvr3iLZ
         aURQ==
X-Forwarded-Encrypted: i=1; AJvYcCXzTbhr1ddvGKyWcqwAjhqEZKVYdxWi24yDKJl/HODhnjC5ekxUekabtzYuQQsejACaYlo=@vger.kernel.org
X-Gm-Message-State: AOJu0YxqzVjsWPfniFfXp/RsxPkGv0GsIZlQ1H2cZnZSiUbAQadBuJvr
	yqSBXINLr/bmFD/b7F1uAi1ra3E3Ryw3jNWUSKHlsikSkAtoEI8Ht3OZLaEmmX0=
X-Gm-Gg: ASbGncvWL9KazIrYrow/zu0IVCO5mQH9178V+GFo7nGc9b3/jGVCJ4TWVmJ404Zi36K
	JJ37pdfQ6kktm1E/6UFlP2HeVhysO4q5eZE1SwC3Ucn772FTAiTksr36X6aTcZHc8IhffSxPP+a
	CvY4qEJ7Kgp0pv5odArU02lTyR+OTb+uPBI1FPa9Q5DrIoALCXmmMeezEFALFVD1TjsEdtnanpJ
	6k18L/NQ3hVO5MAJbn5RXL57Nd8pPKsFdQcAaR94eXb0w6tu0tBI3L2ut85o6bUmw99GnGO3H8M
	nBtzUJ2Yc1WVTOV3uQrS+n9GHdOGc8UsCjj98Vjl
X-Google-Smtp-Source: AGHT+IEtWQgBR1dIPtKgtkqPJNvg9G3OixpeD/ih698aPZOgwyFwhJdy8XlkdVtT04JfqY+wRAy3tA==
X-Received: by 2002:a17:90b:4f47:b0:30a:255c:9d10 with SMTP id 98e67ed59e1d1-30a343e8b08mr4234791a91.8.1746025139383;
        Wed, 30 Apr 2025 07:58:59 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30a34a5bd78sm1705652a91.42.2025.04.30.07.58.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Apr 2025 07:58:58 -0700 (PDT)
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
Subject: [PATCH v2 10/12] target/arm/cpu: remove TARGET_AARCH64 in arm_cpu_finalize_features
Date: Wed, 30 Apr 2025 07:58:35 -0700
Message-ID: <20250430145838.1790471-11-pierrick.bouvier@linaro.org>
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

Need to stub cpu64 finalize functions.

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/cpu.c         |  2 --
 target/arm/cpu32-stubs.c | 24 ++++++++++++++++++++++++
 target/arm/meson.build   | 11 +++++++----
 3 files changed, 31 insertions(+), 6 deletions(-)
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


