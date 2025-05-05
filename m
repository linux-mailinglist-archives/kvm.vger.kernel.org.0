Return-Path: <kvm+bounces-45495-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FD5EAAAD48
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 04:32:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6673216F0DA
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 02:29:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BEB5A3E9866;
	Mon,  5 May 2025 23:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="gDr+6ZzR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EECDF3B11C1
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 23:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746487233; cv=none; b=P5D+VWReMZ+MrfdZjLItJmt4sd/V4zIr3k5kD4yMRl4elTeCdTIiVkcKmdiNG3JStz1oizACZ0j6bM1L+RZte0cNC1FTqezxVRu0U3hLFDQdIPTmTmtX3JRawg0QOzbCxlnc7JsEMBCCq2JdwUPEcpFPrLsvs233Ukjyx0uuH74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746487233; c=relaxed/simple;
	bh=b4RhuUTn7wbUWIpTpKBvX3wln3w0SUQUpRHTYtYOW9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=b31KqLLn7Bvegpg1oN2c444mq2jnD6YRObyImKndRai5nY91KZprfyJPzQHk4YvxJQ0yRQuUMmZaDE8GfLndDxI4w5K6egYy4vIocNb1Swd4iZdgWLDsL+HhdVqBNAMDS5iTFLUVzUjAn0pvUTun5ZUOMecIWGjhujpyG+7jiqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=gDr+6ZzR; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-227a8cdd241so62168185ad.3
        for <kvm@vger.kernel.org>; Mon, 05 May 2025 16:20:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746487230; x=1747092030; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xML4J0OK01b5ZM+8qKTIYRySQNd3gi0WVCRNgOjS4SA=;
        b=gDr+6ZzRO1UxLUKR0nkrOXrms/qJPat2vszQP5sR73iONNfLFf/RCbiG97zdoLLj/o
         6PXzB4mtqtZYLZxn2RlaBOgpzeq4ZEWNSh0Fw0JkvgrkKb2b4Gw9e+HxktZyY4xxtzxi
         rN/0ULe7w48EBB1xF8OBBVISlpB268Cg485Jf2A6ii/o/GabLUhsXjRVxCcYRI1p64xY
         WQBgbBLSlPAQbhyqPyMJdMVAl3EY49czfA38wJi8IuOh2U/9vGbfoLGBSiYSz8f7t3UU
         wq+1z8Sqj2bdSKeFFadu8ldOPhkJ+E0Odxtjs7dm5znGLGnCF7kiykEvEstqjy8eCePq
         0B+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746487230; x=1747092030;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xML4J0OK01b5ZM+8qKTIYRySQNd3gi0WVCRNgOjS4SA=;
        b=F706dhIISQC+5egEwtTA2woYQRPBEcb8sFEe5g+Hg07kDwED1v0RwQG4xFFmilFWWv
         Oozxn9LG3CmYypIFAswgOkrr3m/QdljDhCDzOFMMogWXV/2qnkmZyHnHXfD6YO/LBz+s
         7hjIKlIs0+C9OqsP6X3v5rXW9RgAMgX3q84zEdHZBHVUj5VnY6yTQgdpD6TgfvJHsygI
         9L9Q9YRDZYuGu2C6/u5s8BC9S0LsNTeC8ScClZCrZe8yNim67ZCluaWP8PTsKLz/jgCl
         cKqcJDuL3BdhNZ9PzxG8MAszT2RezWRyVCIQN9C/Q/hI4Rihe5dc+wCfwid/vd5xzDjK
         n83A==
X-Forwarded-Encrypted: i=1; AJvYcCWzdIG9amB27HgK2O9uT1rP0bbc+Uvawi6B+xdEB20L8MJ2BcR2KSl0k+dPvUOXp1RaFyE=@vger.kernel.org
X-Gm-Message-State: AOJu0YznjVxWfPOCAPBxBJoZt0TL35hVTyWVK9A8lc7e70y0Rjj62B9u
	Uq5xDyVIGV1g3KZAoU9RZlbqglRPQqEo9ILTu6SMB8Rr9okGNSxv2iT5hp31YJs=
X-Gm-Gg: ASbGncs57XsHPUej+tFXCiTg3Fvk62LqardzaN4ePbtJkj5WxTOWQ2pvn/XNWp26Zgj
	wkP83aH9ZSUrUyYJI/6Ps/jP3zjGg3JO5KzO7pgsGsThHy4zwcuGOgxRmw8lgsX6nIchyHkpCMX
	guQUlTQQY2mpIGDivEZIvHOECS1Iv9V8vGgpq2E+fmUBPtTx/Ob+yKz5zXLilZgqRf94feCE7pr
	zyLnrxKQZ+awhVO0SLCQT+8BA5+PBOr9xa25wxNCuSe/XwEfHkBYcJe3lrcNjJ1R0zBZ5y4RxMX
	g5ayx7JEpv3rN2ty4ISm0bIhvOnUqlKppgJuiDu+ivEltdeDOQ4=
X-Google-Smtp-Source: AGHT+IHC2Jo05pn952wK+Shdz+FACMdNmO9OlVTSCdZkPIpQy/IzGCCRrr1li/1SwgK+QzI+o9r6dw==
X-Received: by 2002:a17:903:1ce:b0:220:faa2:c911 with SMTP id d9443c01a7336-22e35fdf665mr13164945ad.14.1746487230235;
        Mon, 05 May 2025 16:20:30 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e1522917asm60981715ad.201.2025.05.05.16.20.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 May 2025 16:20:29 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: richard.henderson@linaro.org,
	anjo@rev.ng,
	Peter Maydell <peter.maydell@linaro.org>,
	alex.bennee@linaro.org,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	qemu-arm@nongnu.org,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v6 11/50] target/arm/cpu: remove TARGET_AARCH64 in arm_cpu_finalize_features
Date: Mon,  5 May 2025 16:19:36 -0700
Message-ID: <20250505232015.130990-12-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250505232015.130990-1-pierrick.bouvier@linaro.org>
References: <20250505232015.130990-1-pierrick.bouvier@linaro.org>
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


