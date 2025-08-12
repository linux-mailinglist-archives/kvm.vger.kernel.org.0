Return-Path: <kvm+bounces-54531-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7031DB22F0C
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 19:28:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7D1CC5605C2
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 17:28:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62F292FD1DA;
	Tue, 12 Aug 2025 17:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="rjJpgln2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 980762ED17F
	for <kvm@vger.kernel.org>; Tue, 12 Aug 2025 17:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755019721; cv=none; b=ZvpdFL99+/phrWCYJQEPIjNT0Mk7yQ0msqHsJ1lEreVwN0lj7bhoRI3dtMdlSM3MC5k9uv5ERu8RKRmGqTsyfhfmOfvQl8nMnh+H4zSWpsqDv7jmMN7RVD4HwxwB2Oh1oLgooAVs34AqJEWOPAs5LpPoZPrQ3h2bDwvekZkioZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755019721; c=relaxed/simple;
	bh=NpKHPSsui6tuzZn0IDxBur/Y8ImyoyuAjEoduFlKSWI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mi6ygat1Xc9ypB4ZRm2CM2l/JneySVScQue60XeeXbP8JlXnVbi8rbbDZSfXPuCiV1Cqk6yr0TLYGpk8Ttz3kBtKBGGoYxbGLAalO6D9ghx4j9b2TZGyHYx8eypHOktJsePi0kvTQSahT0LaatHyWGxz4wkFsEnXlb/0fpt+xjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=rjJpgln2; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-459e3926cbbso24870025e9.1
        for <kvm@vger.kernel.org>; Tue, 12 Aug 2025 10:28:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1755019716; x=1755624516; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sTgiDxRSLxB+/Dn7RyfAMOT6DRpkQW6SJaCX0ndx+MI=;
        b=rjJpgln2Y7eeir3HPCwywWmN7VdaX+mxM6UHsQ4sjvHE113+YgYyM/ASqqwfoxPyQZ
         AUAutkCJkEE5XdF/hEBklpwK/ya/KLNRKZcWuet6CWWZR/OpgYNax8rot/O0/AjY675K
         w7BfKLqZispV20vbcdaW4RmM1bCWXnYl4cFPkdr2cgnYjwv8TMRmls3z7kBUf5rbHwz+
         Scx7huaFi89DPQaR3rsWldKuCsOq6cbys2u03k+/j935xyF3N8ZIeyE+xz50yU/FKay5
         tZ1XVZxXIcoWajp9wM6Vd5ROTzpBJ9WIObKoUy8A5Y74VgivDz40+A7b2TsiVkRv4ZFD
         FOyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755019716; x=1755624516;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sTgiDxRSLxB+/Dn7RyfAMOT6DRpkQW6SJaCX0ndx+MI=;
        b=cFbeU93EyiCcDUKikpku6G+90W+5vUv/92HtL1TcSO4p+6+KlOuWcuPGqfTQQEbPZx
         Ds5IrwDhKu+po2VGDgrJAoloadjG6kWQxIv8fLL6gZjJniHWQq8k8NZSz2PL67EtWxuK
         tqMeOfDXgci+nm5bxAVVQuUIVVbxqnjnP8sYkhueBe5Rsw+73jfPfl1aapCJQtLYGyMj
         XTXyEvfvcsAHHJAv+lFZt+WBKyescTGHybYnL8QK5ALi/a68hbBnnrr5szS1I3b4y46M
         NcG7w9nr/9l9IA2vWp+aWalcOeJbzNqGYcaNnYzmP7bTuHgVrov+yiltLgbFvb8h5nnC
         NfAg==
X-Forwarded-Encrypted: i=1; AJvYcCWXg9MZn2+W1H9BlpWvtSOC9uEtIvitWM2PArPZXWt0aaZ+8dkmcgwcpYS086jCPSXco3U=@vger.kernel.org
X-Gm-Message-State: AOJu0YxhQYW5f8PWJFTUXrlzahzANZimVWLeTuCCQYubzgSQIAkN+qA4
	FiIXYqLgH2s9P7mnAKONcm7IC8IK7C2hTcZsF+5HQrNVjZ1TzRbWJOPGaO6h9+AcZCc=
X-Gm-Gg: ASbGncvsb57d4z8gCFwNXDoUpmEMbE9MRqp+my/kWDPiA6ahtmxrkRXxuqgb8i7a2QD
	QpuRcZeU7PnUBpMHNMZaaznY9ZiMOeYDi73/cbAw4x9Z3Xk5QzMEFDSp7hnZtNeuUwhsM9QavX8
	hQY+el3p79S+qefjY73K3xisubhvyR8jFD12f+CDYZg3w+ySKXjDGIDyvGsjLQVvilECbsVPGdG
	bmCOxkfMfVD3aQeQebsQjsSfPDZOd8BDRR9sS3TdefTx4otVtrC1hmx4Ydivs8/H/H7NTge+KRz
	R2F7Ay5LSMwaQeknqMByLYw5vAaKkCSSoFG2Cbttn5rGBs2F54f2WNW1mngP2+FDe51KQZuY2AL
	pHoeQq62dnffEz/bg+79Fo345ge7i5y22Hs7hhYTrjntLQ+b5vCXTi7q8E3ImAgB33bCr0GFg
X-Google-Smtp-Source: AGHT+IHCNB9liwRrzN1UA12Au2HxJQE1KeT6nD/BnW4UnE7bWMjAbGsN0eox/z70JQCzOYHqa8vdNQ==
X-Received: by 2002:a05:600c:35cb:b0:456:25e7:bed with SMTP id 5b1f17b1804b1-45a165adbadmr219075e9.14.1755019715766;
        Tue, 12 Aug 2025 10:28:35 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-458953eb7acsm545345755e9.28.2025.08.12.10.28.34
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 12 Aug 2025 10:28:35 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Claudio Fontana <cfontana@suse.de>,
	Cameron Esfahani <dirty@apple.com>,
	Mohamed Mediouni <mohamed@unpredictable.fr>,
	Alexander Graf <agraf@csgraf.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	Eric Auger <eric.auger@redhat.com>,
	qemu-arm@nongnu.org,
	Mads Ynddal <mads@ynddal.dk>,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Miguel Luis <miguel.luis@oracle.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v2 02/10] target/arm: Use generic hwaccel_enabled() to check 'host' cpu type
Date: Tue, 12 Aug 2025 19:28:14 +0200
Message-ID: <20250812172823.86329-3-philmd@linaro.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250812172823.86329-1-philmd@linaro.org>
References: <20250812172823.86329-1-philmd@linaro.org>
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


