Return-Path: <kvm+bounces-45358-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 50AE6AA8AB9
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 03:53:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ABE9617270A
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 01:53:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B0B51B042E;
	Mon,  5 May 2025 01:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="y3NZpRfQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEBB91AA1D5
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 01:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746409960; cv=none; b=PXO+zY0xbwBoVMC4WGVk5fF8wTgoduq4HLzqxqVZ2LSy+FMyzH4o9gryuWYq0SxnFYpSmUgUyMZlM5FxlEXhuMGxvXrQqK1kByedE/tF+aDygqL8qU6AofaSpKsUeo0jGKZtALlstNSXHJtC5/cImz/IqqtWEs+SZ9A60J/EaM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746409960; c=relaxed/simple;
	bh=b4RhuUTn7wbUWIpTpKBvX3wln3w0SUQUpRHTYtYOW9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mxjb1DHFv+Lf6HMDmrQFlWuQyqdIzPiVTCHPPvKfq0nvhzspnPA8cMRQtqbiEG5/5lOoxKPWgpGzE2t48/EB/A5XfFgYIARcHfy1ZnDQ2OytWBGL99e6AD2/ZbbJEfmHWxLx6erVSsZ3vnLluGUsgNL996zAjoMAet+bqHdJHts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=y3NZpRfQ; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-22e09f57ed4so34294675ad.0
        for <kvm@vger.kernel.org>; Sun, 04 May 2025 18:52:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746409958; x=1747014758; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xML4J0OK01b5ZM+8qKTIYRySQNd3gi0WVCRNgOjS4SA=;
        b=y3NZpRfQyKCZbsZlQR+YUnHKbYJaWV3eIfFzdfObD0sJGmeaYwjXkboPVLt0rjO+mk
         IQaSIVdKiyAOsgRCRDry94XUzuaScJLSZeDVDGazoCB3zyPCJ0Ve8oSU6x3fddnuFq7Q
         z0bimY+KwPNeZOqhBzGqccxupeo4dvYE1RnAm8HqwTUtJJBgMtZ6EySmzgsbIzfTBFob
         /a8oU3hpMTJVanxBvT+1JgPBKXhU2s/YRE1qjN2aOIhBdJ9/fEaj3+kSklZd3k66Btva
         6An2Zm90XQHWJZ2Dm1phBkNeWG81Cb7td2ihqBjoDMXMNyFbZyS3vNFvFWHZpGd1+Spg
         RUhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746409958; x=1747014758;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xML4J0OK01b5ZM+8qKTIYRySQNd3gi0WVCRNgOjS4SA=;
        b=E8dOSNwgzSvSBUVTX6sJWbphcm8u+fFpxY1I53OFMee1GeVAkXrbhXQxkf5u7QD7wE
         vE5BqeW3mpHmqhtvMq+duidHh8rVDwNl5HsaxDXAucKKyq3vec0ZW9Lb0A1/DzGZzIBq
         075g4u+Np9zzGqXKnOjuPKzlzfkOBx7VVBS7ZMP5m0jOkIidudlMB1bQ7O+I/G2wc30X
         V8Xa1kASmrOVMze96vtFH9UrYsGuNiAUIYqZwcQsLkRNbuDT1IiQloCHY3uI6f+MA7I/
         27+YM0alQO30IDMMwNxZ9qdV22/5EH5Ex1nHupFtZo6wT/zY1mEvwCpJ3WWzkwGWlcIt
         JkjA==
X-Forwarded-Encrypted: i=1; AJvYcCWp5yGiWK5AmNBpQiNL+B3Fipvgz+ecUMYAVNTaAGxeWngCZ7bH2K7M3+yYYQmlDMqFCMI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx1/otw1a8Nqer+lZPNMOeM6jdf+CKnuXPEnDjbwhBOn648J3pM
	qofTBNNn9hs0q5sL6zS3N7o1LE30fgrrfJJGTpJwsa92KI/xdkB2IlE8PkYx7Q3xFbdRGtdHDRk
	oW98=
X-Gm-Gg: ASbGncu4FJY73hNGN2PKtOly8kVYOFfbIjlos2KVpGZBXHnOYYbSDvwZbkb1UjUv3UI
	CLW+CgbLvdw3lbxR46NXqbJxUPnshyFJC7+sQrRb94Ji3j7eIs1/GVbn159nql1+ecPGoOY8hcm
	bfgPDGEKE3UPCJddY8X0TQTANKPlNE5QlIQz+hqdsx7xIXQBAIjiV8SUGvQ3vnqjZF6rgZJnFbL
	626p3gCVL/6by+liWTIHtR2C0fRtVQkt1Tfzo/ZBOMXNeHl1/O7s3ZrOEqbzyIRVM15oSIieRuj
	ApMC3SSUesDgKcCrKNJX4y4joJChqo5B9fv1bXU/
X-Google-Smtp-Source: AGHT+IEtIVHuMX4JePWDBmODChoDsS023u64Klr4UMTovaWNd58dYG/vCBHgFErrNE7uDGnIEc9MDA==
X-Received: by 2002:a17:902:e541:b0:21f:5063:d3ca with SMTP id d9443c01a7336-22e0863a1cbmr212774085ad.16.1746409958142;
        Sun, 04 May 2025 18:52:38 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b1fb3920074sm4462101a12.11.2025.05.04.18.52.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 May 2025 18:52:37 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	qemu-arm@nongnu.org,
	richard.henderson@linaro.org,
	alex.bennee@linaro.org,
	kvm@vger.kernel.org,
	Peter Maydell <peter.maydell@linaro.org>,
	anjo@rev.ng,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v5 11/48] target/arm/cpu: remove TARGET_AARCH64 in arm_cpu_finalize_features
Date: Sun,  4 May 2025 18:51:46 -0700
Message-ID: <20250505015223.3895275-12-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250505015223.3895275-1-pierrick.bouvier@linaro.org>
References: <20250505015223.3895275-1-pierrick.bouvier@linaro.org>
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


