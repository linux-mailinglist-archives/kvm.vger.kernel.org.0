Return-Path: <kvm+bounces-70410-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YDnvJgtuhWnqBQQAu9opvQ
	(envelope-from <kvm+bounces-70410-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 05:28:59 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C2C1EFA119
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 05:28:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 9A332300BE92
	for <lists+kvm@lfdr.de>; Fri,  6 Feb 2026 04:24:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC0A3343D7D;
	Fri,  6 Feb 2026 04:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="B4HIcUK1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE07834251B
	for <kvm@vger.kernel.org>; Fri,  6 Feb 2026 04:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770351721; cv=none; b=RblUIkn3IJmtUI545mEwpzJX5q8t/w+5jEdK4h8MeHPeCPiZvVw6VOStDTYAb0J9Kqi11kPZodZeQqyfH1eldDyznTqeqQjVJ1U4HNe7rybp/1Rw5dlHFIG3jHStrywiXEKjOYjleBF3ClE1QB+8PTfYGsZx+z0BKl+obrTndQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770351721; c=relaxed/simple;
	bh=xFaly016xfHWaZVtKRZ8uacyS0acpUhc8X1EjRw8woQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QL2USwRQUmVM/2wiiy13CROiJJtFIw9n7tnjcPRACPHzy9EF+YWbLheEyQ1VYWyha1lSZYuaxApIaL/Z1BvI/zpvsKpsiv2RcImYsAWR6gEgct6jgNqEpJ12jt/JS22akT10mzDBVxvRcq5glpmxURIpT588SmrIZyEI60DGuA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=B4HIcUK1; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-c227206e6dcso975743a12.2
        for <kvm@vger.kernel.org>; Thu, 05 Feb 2026 20:22:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1770351721; x=1770956521; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=msDy34BXNBauha6BX6yiPrC2FkV4a2ByUqGrOK5VCFU=;
        b=B4HIcUK1cMf2wyto2SIx1dyYPBJBUrMWIki9vWer/PYqOEJCSDm5dZoiFsnEsLLfCx
         zk3fSTNDKzbmEQZApQ7bpIXBtw6tbRSHos4j1Msv2jt9Fz0HnSAvbXk55w3KL1Mt8Zqz
         uDPC85/3mJBU4m51Su8paa+iyWNv/TN35mJWhVzxXUIVKDkr4aWWpoF722I1p5xmI1I8
         CNH8sqmz6ymr3W0DZx0noZ4F7qPMZTgekC/nR67P1ZAn5OIAp4ORQuS9QLIXLk4hcLF6
         rMuMoGxvZR2T6U5G7aSi1FnsxPjqrdf+6VTI4ccyDlukvyhlsi3USGMbRS0e8G/TARm4
         rQFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770351721; x=1770956521;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=msDy34BXNBauha6BX6yiPrC2FkV4a2ByUqGrOK5VCFU=;
        b=FPznzA1ozh+jhgVsC7+pek+tZOaF1qvFxH54SVJ/sFM4HOyo0HQk8bndPM2xmcs/Vd
         cyYCZKTGOVgKi4iD2DwZAHHzkdgZB2BB9NA3xcP4ylBH4AAhYPW8A2hTSUXzHNyKAt+f
         RmDQ8c+pouBEsm3FHazJHyNlmYWDGFfsD10ypv/GHlp+18RZDbcGSwYp+zk+STlSEKve
         f9ygHUlfyiWKr5tMvfYyL2GaHhvvwEx7GJ66D9q41SGMhVvSkODs8RjwtX4rd/s7jg5a
         oGO4Fm+vhrH3h+dN278c1KILRexF5PCuZgfT/tA0UXTSf1r3N/KiwWAzPxD4//f7a4JW
         gYvQ==
X-Forwarded-Encrypted: i=1; AJvYcCUaEbF7PaoDMp/ANXrMe+XczmQio9eCykMm0NXxff/YCMaxi+hTXNeik4Y5mD3jpwBsRu0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwdpdU0o9M77AibbQ0aHQL69j2Jo/yr1cTL8vNbxxnBARJn+som
	zpduzi9YNb/I8cFVhVFuZc3/8uRBSKPuJ8mo/vFDWvBH2mbEDv5YGDNRAkY24iCZ71A=
X-Gm-Gg: AZuq6aIcNPjLblyDcJBCAGWLkG7puh6zKp0HWy5HkVC400I0b/M7JY8xrEsaWvpJnfc
	2Rfj22A5/R74ZLWWyrPX4yL2SEAXUiBon3wtX9n/6ybNlfmecUcmLOddIWiQo5bQ4PXW1tHpJLB
	eyGk/DxYaDWWkrv0t0oVCXS6cgiqPiCGKKVlbqHWBQ/QWLNXh99fFZlir0BSAWmS0XR8RkKHSlr
	oTREkSwelUt2k5AacliYKhXaa9ufryyPkiN3TZww5yzlxnfkwqPTxQz2azFi0zSTVINEC+cTgKy
	S/RPiGhwfGlxmunr4Om5m1quCpK+qx60a+OWvfochtOG9TQDIll+omg1AjSnUMLiUqDlEuombQD
	R9pZo2/+dgz4P4XZonMDMIvG6nrfL4tS7Fyambdr+tjbqC2goxzwkkGQGgTmdhdK9xzbS9mY/Ob
	fVkaAeBanHB3QupDJlp3clFLeRh36aKM2xz/rQqCrzIHeklKszfAJV5952+qhF5acI
X-Received: by 2002:a17:90b:1650:b0:339:ec9c:b275 with SMTP id 98e67ed59e1d1-354b3c41871mr1384005a91.6.1770351721024;
        Thu, 05 Feb 2026 20:22:01 -0800 (PST)
Received: from pc.taild8403c.ts.net (216-71-219-44.dyn.novuscom.net. [216.71.219.44])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8244168fdf5sm926914b3a.17.2026.02.05.20.22.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Feb 2026 20:22:00 -0800 (PST)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: anjo@rev.ng,
	Richard Henderson <richard.henderson@linaro.org>,
	Jim MacArthur <jim.macarthur@linaro.org>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	qemu-arm@nongnu.org,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v2 01/12] target/arm/arm-qmp-cmds.c: make compilation unit common
Date: Thu,  5 Feb 2026 20:21:39 -0800
Message-ID: <20260206042150.912578-2-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260206042150.912578-1-pierrick.bouvier@linaro.org>
References: <20260206042150.912578-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[linaro.org,none];
	R_DKIM_ALLOW(-0.20)[linaro.org:s=google];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[linaro.org:+];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70410-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pierrick.bouvier@linaro.org,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[11];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,linaro.org:email,linaro.org:dkim,linaro.org:mid]
X-Rspamd-Queue-Id: C2C1EFA119
X-Rspamd-Action: no action

Move gic_cap_kvm_probe to target/arm/kvm.c to remove #ifdef CONFIG_KVM.

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/kvm_arm.h      |  3 +++
 target/arm/arm-qmp-cmds.c | 27 +++------------------------
 target/arm/kvm-stub.c     |  5 +++++
 target/arm/kvm.c          | 21 +++++++++++++++++++++
 target/arm/meson.build    |  2 +-
 5 files changed, 33 insertions(+), 25 deletions(-)

diff --git a/target/arm/kvm_arm.h b/target/arm/kvm_arm.h
index 6a9b6374a6d..cc0b374254e 100644
--- a/target/arm/kvm_arm.h
+++ b/target/arm/kvm_arm.h
@@ -11,6 +11,7 @@
 #ifndef QEMU_KVM_ARM_H
 #define QEMU_KVM_ARM_H
 
+#include "qapi/qapi-types-misc-arm.h"
 #include "system/kvm.h"
 #include "target/arm/cpu-qom.h"
 
@@ -263,4 +264,6 @@ void kvm_arm_enable_mte(Object *cpuobj, Error **errp);
 
 void arm_cpu_kvm_set_irq(void *arm_cpu, int irq, int level);
 
+void arm_gic_cap_kvm_probe(GICCapability *v2, GICCapability *v3);
+
 #endif
diff --git a/target/arm/arm-qmp-cmds.c b/target/arm/arm-qmp-cmds.c
index 45df15de782..83ec95c290f 100644
--- a/target/arm/arm-qmp-cmds.c
+++ b/target/arm/arm-qmp-cmds.c
@@ -43,29 +43,6 @@ static GICCapability *gic_cap_new(int version)
     return cap;
 }
 
-static inline void gic_cap_kvm_probe(GICCapability *v2, GICCapability *v3)
-{
-#ifdef CONFIG_KVM
-    int fdarray[3];
-
-    if (!kvm_arm_create_scratch_host_vcpu(fdarray, NULL)) {
-        return;
-    }
-
-    /* Test KVM GICv2 */
-    if (kvm_device_supported(fdarray[1], KVM_DEV_TYPE_ARM_VGIC_V2)) {
-        v2->kernel = true;
-    }
-
-    /* Test KVM GICv3 */
-    if (kvm_device_supported(fdarray[1], KVM_DEV_TYPE_ARM_VGIC_V3)) {
-        v3->kernel = true;
-    }
-
-    kvm_arm_destroy_scratch_host_vcpu(fdarray);
-#endif
-}
-
 GICCapabilityList *qmp_query_gic_capabilities(Error **errp)
 {
     GICCapabilityList *head = NULL;
@@ -74,7 +51,9 @@ GICCapabilityList *qmp_query_gic_capabilities(Error **errp)
     v2->emulated = true;
     v3->emulated = true;
 
-    gic_cap_kvm_probe(v2, v3);
+    if (kvm_enabled()) {
+        arm_gic_cap_kvm_probe(v2, v3);
+    }
 
     QAPI_LIST_PREPEND(head, v2);
     QAPI_LIST_PREPEND(head, v3);
diff --git a/target/arm/kvm-stub.c b/target/arm/kvm-stub.c
index c93462c5b9b..ea67deea520 100644
--- a/target/arm/kvm-stub.c
+++ b/target/arm/kvm-stub.c
@@ -124,3 +124,8 @@ bool kvm_arm_cpu_post_load(ARMCPU *cpu)
 {
     g_assert_not_reached();
 }
+
+void arm_gic_cap_kvm_probe(GICCapability *v2, GICCapability *v3)
+{
+    g_assert_not_reached();
+}
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index 3e35570f15f..ded582e0da0 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -2580,3 +2580,24 @@ void arm_cpu_kvm_set_irq(void *arm_cpu, int irq, int level)
     }
     kvm_arm_set_irq(cs->cpu_index, KVM_ARM_IRQ_TYPE_CPU, irq_id, !!level);
 }
+
+void arm_gic_cap_kvm_probe(GICCapability *v2, GICCapability *v3)
+{
+    int fdarray[3];
+
+    if (!kvm_arm_create_scratch_host_vcpu(fdarray, NULL)) {
+        return;
+    }
+
+    /* Test KVM GICv2 */
+    if (kvm_device_supported(fdarray[1], KVM_DEV_TYPE_ARM_VGIC_V2)) {
+        v2->kernel = true;
+    }
+
+    /* Test KVM GICv3 */
+    if (kvm_device_supported(fdarray[1], KVM_DEV_TYPE_ARM_VGIC_V3)) {
+        v3->kernel = true;
+    }
+
+    kvm_arm_destroy_scratch_host_vcpu(fdarray);
+}
diff --git a/target/arm/meson.build b/target/arm/meson.build
index 462c71148d2..1a1bcde2601 100644
--- a/target/arm/meson.build
+++ b/target/arm/meson.build
@@ -16,7 +16,7 @@ arm_common_ss.add(files(
   'mmuidx.c',
 ))
 
-arm_system_ss.add(files(
+arm_common_system_ss.add(files(
   'arm-qmp-cmds.c',
 ))
 arm_system_ss.add(when: 'CONFIG_KVM', if_true: files('hyp_gdbstub.c', 'kvm.c'))
-- 
2.47.3


