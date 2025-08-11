Return-Path: <kvm+bounces-54420-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 59BC0B212CD
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 19:06:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 58813190805D
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 17:07:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F4DE2D47F3;
	Mon, 11 Aug 2025 17:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="q5w8c9Om"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC2132C21D0
	for <kvm@vger.kernel.org>; Mon, 11 Aug 2025 17:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754931988; cv=none; b=Y3dyK0qeY8HCEcNMQUjP7CAlp80AkssoKr+6q3zTbPZpo/Vcw4x+jJf+C+qSYdp32lTcf1Ii9bgvfgywYTxQ6o/vq7t+k0aZ4z97bDCESzM54tE/X02MDV2TRacRW26pSQZ2SDboXxNJnuXXO/I6MbCdXRMREp8FcoYnx7GT+OU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754931988; c=relaxed/simple;
	bh=NpKHPSsui6tuzZn0IDxBur/Y8ImyoyuAjEoduFlKSWI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eMDbPR95p+MYPVsXOJAw79bEWtBFqZk82IpHnNoSK++XL/qqcFJOklmgX9tZ1520+KRAwc3WGgBPuFE/6UUuqMZ7r9VSuTVJpt5wmZUyKZj4/LDMEw6wi1juS+rNCmeMayxXnbDPScewVdLBmncShJ17b2el+6zuJr7EYBvKUO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=q5w8c9Om; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-458aee6e86aso30616565e9.3
        for <kvm@vger.kernel.org>; Mon, 11 Aug 2025 10:06:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1754931985; x=1755536785; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sTgiDxRSLxB+/Dn7RyfAMOT6DRpkQW6SJaCX0ndx+MI=;
        b=q5w8c9OmKXIb7B9COY2fl1JDZ8Ro1uH/c8tzCD8llaprJazYMPSbRx980DRcQ311fz
         ObP5ZIF0+2Qy3Ca14JMcYhu7EHtGxujXYDBoao6z4hskpOAHAk4o1mhZHxIKWGt7sVkf
         MRIcdbNW9cj8DjmzWRU3gc7qI1k67cpOfvXMu0Qvwgt0pjZLwWKr+m/45/Cmnuv7srem
         niChmanbpfED13vPWIe9gHN8vw0BOsCIAauNBHZ6PtvV+8wBLcSjPR5cnwJPEM2t3UIq
         f3OFHCHJhqZtuTZUzemgjwsgef0xQ+fke/ZW8e+CzKiZR287AxHLpLafcRPm00iXQmH8
         2oyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754931985; x=1755536785;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sTgiDxRSLxB+/Dn7RyfAMOT6DRpkQW6SJaCX0ndx+MI=;
        b=EKfrIDhYyfvxs0AIdz+mj22SAqyYw8SCXWEuajW/lwtECISJMfHs3jJPb9E+9x1Hm9
         1R2Q3O+PjoDAIL/HagWsbZqQJjy1nNv6Q8ZFReeCeFDK8YdDE+bBc9eqMDgGRzLFWBIs
         w4TdDVAk8gbXSMCxZbC1ZniM7brWk8rSwtsmdw7ueHCvmTgRqrci6GxtLqRdbwUktVkp
         xuEkSI3TdQxdYyXq5JXgKJddiZIRC2xQ4/LqEu/ZqABnVQ+V22VZHdEMmCZeevDJufF3
         N+b8Smz/WWezA1P6Y5Sjlv4UmF5maA6rBtnpJknGkhVOhCbCqKF8d6Gs+AIPvYx9CxlW
         U3/Q==
X-Forwarded-Encrypted: i=1; AJvYcCVIynlsZktPajISWxwuSYbz4gwaK3PZ3rq12HZYSbanA1095Piau5oXpG5yez8l9wmLzNk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yys4zjuiZpgOUy34U7Dh8UPHebMGBezEgdBGDv7HuFLCEPdgK6F
	cww3cTCw3vUb7MS28jsPrL+BrTL7TjDSoNfZgM7PMuwQbq9PRGf9Gg+sMFVKy6gVtLE=
X-Gm-Gg: ASbGnctnXp5QGv6sXWb0vrLYWoGUNZ4gLFIYCwkygybfwePXWUnySnFo4rvMoFeDqoA
	0XnGaDaCgki5OLyzpdRhAfGYJFyGWuxxcPJ2CT4LJgMN9oUpNzQLZVGkX8WLUJ3SMbA4LEipAZQ
	R+34b7sS4rvhg6SbhUavoxMgW2t2Gj/oqBXvCoah8Ygmao+qRfedj2k6WgFZ1q9PkXvw256rFnq
	WcDBTerYV75RT4zwzWKuWPG/qR/v6ug/sdoGErZQ1qkWk1tqkZTtc7yGpdCQDJ7M1ML95T4GnKs
	2kytvJwjNz/uFlNPMGdLrslfAVnZ1maAnbOQaviysPJN4UeH07jx3J4y7sKPC3lAXFEppZN8pU9
	rGCTbCoSHWj2vIUA0H6MiDnisMdyPYF8qoSl0lfArLx+HsB9qJycSBqjVLmK/EaE0EWaj0OEU
X-Google-Smtp-Source: AGHT+IHmKFWh0EX5W4UrlAuaShc8z5HGaqyl6BzhAlbha6mdD4im91lzcojjBo1X/5DvQMYjrTsAeg==
X-Received: by 2002:a05:600c:3b89:b0:459:ea5d:418b with SMTP id 5b1f17b1804b1-45a10f58f2amr1775565e9.9.1754931985104;
        Mon, 11 Aug 2025 10:06:25 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b8e0683045sm32464335f8f.41.2025.08.11.10.06.23
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 11 Aug 2025 10:06:24 -0700 (PDT)
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
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [RFC PATCH 02/11] target/arm: Use generic hwaccel_enabled() to check 'host' cpu type
Date: Mon, 11 Aug 2025 19:06:02 +0200
Message-ID: <20250811170611.37482-3-philmd@linaro.org>
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

We should be able to use the 'host' CPU with any hardware accelerator.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Mohamed Mediouni <mohamed@unpredictable.fr>
Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/arm-qmp-cmds.c |  5 +++--
 target/arm/cpu.c          |  5 +++--
 target/arm/cpu64.c        | 11 ++++++-----
 3 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/target/arm/arm-qmp-cmds.c b/target/arm/arm-qmp-cmds.c
index d292c974c44..1142e28cb76 100644
--- a/target/arm/arm-qmp-cmds.c
+++ b/target/arm/arm-qmp-cmds.c
@@ -31,6 +31,7 @@
 #include "qapi/qapi-commands-misc-arm.h"
 #include "qobject/qdict.h"
 #include "qom/qom-qobject.h"
+#include "system/hw_accel.h"
 #include "cpu.h"
 
 static GICCapability *gic_cap_new(int version)
@@ -117,8 +118,8 @@ CpuModelExpansionInfo *qmp_query_cpu_model_expansion(CpuModelExpansionType type,
         return NULL;
     }
 
-    if (!kvm_enabled() && !strcmp(model->name, "host")) {
-        error_setg(errp, "The CPU type '%s' requires KVM", model->name);
+    if (!hwaccel_enabled() && !strcmp(model->name, "host")) {
+        error_setg(errp, "The CPU type 'host' requires hardware accelerator");
         return NULL;
     }
 
diff --git a/target/arm/cpu.c b/target/arm/cpu.c
index e2b2337399c..d9a8f62934d 100644
--- a/target/arm/cpu.c
+++ b/target/arm/cpu.c
@@ -1984,8 +1984,9 @@ static void arm_cpu_realizefn(DeviceState *dev, Error **errp)
      * this is the first point where we can report it.
      */
     if (cpu->host_cpu_probe_failed) {
-        if (!kvm_enabled() && !hvf_enabled()) {
-            error_setg(errp, "The 'host' CPU type can only be used with KVM or HVF");
+        if (!hwaccel_enabled()) {
+            error_setg(errp, "The 'host' CPU type can only be used with "
+                             "hardware accelator such KVM/HVF");
         } else {
             error_setg(errp, "Failed to retrieve host CPU features");
         }
diff --git a/target/arm/cpu64.c b/target/arm/cpu64.c
index 26cf7e6dfa2..034bbc504cd 100644
--- a/target/arm/cpu64.c
+++ b/target/arm/cpu64.c
@@ -26,6 +26,7 @@
 #include "qemu/units.h"
 #include "system/kvm.h"
 #include "system/hvf.h"
+#include "system/hw_accel.h"
 #include "system/qtest.h"
 #include "system/tcg.h"
 #include "kvm_arm.h"
@@ -522,7 +523,7 @@ void arm_cpu_pauth_finalize(ARMCPU *cpu, Error **errp)
     isar2 = FIELD_DP64(isar2, ID_AA64ISAR2, APA3, 0);
     isar2 = FIELD_DP64(isar2, ID_AA64ISAR2, GPA3, 0);
 
-    if (kvm_enabled() || hvf_enabled()) {
+    if (hwaccel_enabled()) {
         /*
          * Exit early if PAuth is enabled and fall through to disable it.
          * The algorithm selection properties are not present.
@@ -599,10 +600,10 @@ void aarch64_add_pauth_properties(Object *obj)
 
     /* Default to PAUTH on, with the architected algorithm on TCG. */
     qdev_property_add_static(DEVICE(obj), &arm_cpu_pauth_property);
-    if (kvm_enabled() || hvf_enabled()) {
+    if (hwaccel_enabled()) {
         /*
          * Mirror PAuth support from the probed sysregs back into the
-         * property for KVM or hvf. Is it just a bit backward? Yes it is!
+         * property for HW accel. Is it just a bit backward? Yes it is!
          * Note that prop_pauth is true whether the host CPU supports the
          * architected QARMA5 algorithm or the IMPDEF one. We don't
          * provide the separate pauth-impdef property for KVM or hvf,
@@ -780,8 +781,8 @@ static void aarch64_host_initfn(Object *obj)
 
 static void aarch64_max_initfn(Object *obj)
 {
-    if (kvm_enabled() || hvf_enabled()) {
-        /* With KVM or HVF, '-cpu max' is identical to '-cpu host' */
+    if (hwaccel_enabled()) {
+        /* When hardware acceleration enabled, '-cpu max' is identical to '-cpu host' */
         aarch64_host_initfn(obj);
         return;
     }
-- 
2.49.0


