Return-Path: <kvm+bounces-58737-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D5FBBB9EAA6
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 12:31:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 182C17B7911
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 10:29:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED02C2EFDBB;
	Thu, 25 Sep 2025 10:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Nmjr/fmr"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E2842EFD9E
	for <kvm@vger.kernel.org>; Thu, 25 Sep 2025 10:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758796146; cv=none; b=CqbZ6oPp1v20If51Igvrd9WKjEN9tBAWI+VQLqB4SZVxhB/LeeXhSD1eib/jN233ly8ixJTwuYVoV8yJenGw6RMNTMYO8CxcSpo8Qaypa0wCxJY0XiGi9sE332RnoKsmhLy3q11Z32/QxDUI5onjBpr9honIwJDM+RoC4Yz2qDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758796146; c=relaxed/simple;
	bh=wJSo3WQzSH71VjjXufSwDyaPJVRkcT9QbNW+ZtCSfRU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uDNdoDVdZfuNMDlw5j3c8kA7t6ZbBjePWwgUoqRR7A5ApbDiXqwbwjDJ0xNpIuN3/Xs7eP2qJmNrIWCaOZu+pUq+/8eQ16sONV9bToefSTlOrGN4je+YYSZsEaFc7WTBfgbG93EpkhNfV09pZ9+XUBBpklYHBphwtr2Of6T3ImU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Nmjr/fmr; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D00DFC4CEF0;
	Thu, 25 Sep 2025 10:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758796145;
	bh=wJSo3WQzSH71VjjXufSwDyaPJVRkcT9QbNW+ZtCSfRU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nmjr/fmrX1SmcYzZFFXfUwm1twPQFmiJs8Dy94G1uTMg26WiE1GHfmg1rIA0ntjAc
	 Z+4y1sMn41qq5EJXSFRMn5cPJRUS4//evh2FpAtE02tPOKGlmPnunf/hzCyX/hJCYR
	 ULgVVRxn6vsLYXGOA6f2w/l9mxSBUSFLkHIqYUWxBm4AmNR0E74yeut+ahwd942PlO
	 tixTKdu/ljo/vzzjzJ7pTkN9HQYDTSHj4moN7s5zPFNVcaXtRvMWw+2bqB/xhBrfkv
	 k5Q/qAleWa16a41L65IgyWhHf+NS663fBtxwAtTf3HlQdJW/DRcZx/rm6N4Y995TMG
	 25qv7QlicoeVQ==
From: "Naveen N Rao (AMD)" <naveen@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel <qemu-devel@nongnu.org>,
	<kvm@vger.kernel.org>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Nikunj A Dadhania <nikunj@amd.com>,
	"Daniel P. Berrange" <berrange@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Zhao Liu <zhao1.liu@intel.com>,
	Michael Roth <michael.roth@amd.com>,
	Roy Hopkins <roy.hopkins@randomman.co.uk>
Subject: [PATCH v2 9/9] target/i386: SEV: Refactor check_sev_features()
Date: Thu, 25 Sep 2025 15:47:38 +0530
Message-ID: <f60170d4148c4da09e6e0ff4f6f0742106fd9eca.1758794556.git.naveen@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1758794556.git.naveen@kernel.org>
References: <cover.1758794556.git.naveen@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Refactor check_sev_features() to consolidate SEV-SNP checks to a single
if block. This is also helpful when adding checks for future SEV
features.  While at it, move the comment about the checks being done
outside of the function body and expand it to describe what this
function does. Update error_setg() invocations to use a consistent
format.

No functional change intended.

Suggested-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Naveen N Rao (AMD) <naveen@kernel.org>
---
 target/i386/sev.c | 55 ++++++++++++++++++++++++++---------------------
 1 file changed, 30 insertions(+), 25 deletions(-)

diff --git a/target/i386/sev.c b/target/i386/sev.c
index 8bb9faaa7779..138210e24124 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -502,34 +502,22 @@ static void sev_apply_cpu_context(CPUState *cpu)
     }
 }
 
+/*
+ * Ensure SEV_FEATURES is configured for correct SEV hardware and that
+ * the requested features are supported. In addition, ensure feature
+ * dependencies are satisfied (allow tsc-frequency only if secure-tsc
+ * is also enabled, as an example).
+ */
 static int check_sev_features(SevCommonState *sev_common, uint64_t sev_features,
                               Error **errp)
 {
-    /*
-     * Ensure SEV_FEATURES is configured for correct SEV hardware and that
-     * the requested features are supported. If SEV-SNP is enabled then
-     * that feature must be enabled, otherwise it must be cleared.
-     */
-    if (sev_snp_enabled() && !(sev_features & SVM_SEV_FEAT_SNP_ACTIVE)) {
-        error_setg(
-            errp,
-            "%s: SEV_SNP is enabled but is not enabled in VMSA sev_features",
-            __func__);
-        return -1;
-    } else if (!sev_snp_enabled() &&
-               (sev_features & SVM_SEV_FEAT_SNP_ACTIVE)) {
-        error_setg(
-            errp,
-            "%s: SEV_SNP is not enabled but is enabled in VMSA sev_features",
-            __func__);
-        return -1;
-    }
     if (sev_features && !sev_es_enabled()) {
         error_setg(errp,
                    "%s: SEV features require either SEV-ES or SEV-SNP to be enabled",
                    __func__);
         return -1;
     }
+
     if (sev_features & ~sev_common->supported_sev_features) {
         error_setg(errp,
                    "%s: VMSA contains unsupported sev_features: %lX, "
@@ -537,13 +525,30 @@ static int check_sev_features(SevCommonState *sev_common, uint64_t sev_features,
                    __func__, sev_features, sev_common->supported_sev_features);
         return -1;
     }
-    if (sev_snp_enabled() && SEV_SNP_GUEST(sev_common)->tsc_khz &&
-        !(sev_features & SVM_SEV_FEAT_SECURE_TSC)) {
-        error_setg(errp,
-                   "%s: TSC frequency can only be set if Secure TSC is enabled",
-                   __func__);
-        return -1;
+
+    if (sev_snp_enabled()) {
+        if (!(sev_features & SVM_SEV_FEAT_SNP_ACTIVE)) {
+            error_setg(errp,
+                       "%s: SEV_SNP is enabled but is not enabled in VMSA sev_features",
+                       __func__);
+            return -1;
+        }
+        if (SEV_SNP_GUEST(sev_common)->tsc_khz &&
+            !(sev_features & SVM_SEV_FEAT_SECURE_TSC)) {
+            error_setg(errp,
+                       "%s: TSC frequency can only be set if Secure TSC is enabled",
+                       __func__);
+            return -1;
+        }
+    } else {
+        if (sev_features & SVM_SEV_FEAT_SNP_ACTIVE) {
+            error_setg(errp,
+                       "%s: SEV_SNP is not enabled but is enabled in VMSA sev_features",
+                       __func__);
+            return -1;
+        }
     }
+
     return 0;
 }
 
-- 
2.51.0


