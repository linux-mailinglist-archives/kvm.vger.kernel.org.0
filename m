Return-Path: <kvm+bounces-57328-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 40961B53640
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 16:50:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2CA18B615CA
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 14:48:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09CFA342CB4;
	Thu, 11 Sep 2025 14:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HbsLiGSl"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D859343202
	for <kvm@vger.kernel.org>; Thu, 11 Sep 2025 14:49:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757602178; cv=none; b=Rbbx/bNCujPXfQu37LL09rT0T2KRPBJ6TRKj9vxgdI3JZoVC+Yb8kpjJQKUo/FQSZt6y63PuDPuhMr1mRinfEZ4BJe1A7Z7klV68rkLc+tGQ9ZxCVLgYyAWs5F/eYf2PlL3MBjDBpmW+MDVi+TuGKVBnvrRgEGaN+y2vQ/bPErk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757602178; c=relaxed/simple;
	bh=CJrAAvtbsK1Bq6qJ8m6Bdo0Sh+NC7OqSH7HcP/+aXxk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=md+RHLECKPJEw7mSKRD3UewH3frdUB50lZvFjdsZSGsjQx/Z2L8YRt/5uAcXApY+nbvg813Y4YjA/8xGirXEd44tiVKhJaYuwSDQD+4BzIipZb9YIX5B2E5cML2bGKs87UM7NLwXNb40Y0NDmnuURpj15lBTXw1jr+YgJt3foEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HbsLiGSl; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757602175;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qhARN+mNZ8/BVngVsPUupvVPf6ZiX6bQWjwA8ImXvMA=;
	b=HbsLiGSl595Aw8abyEeAExftgsyOxLkRf6nqytVX3sNzkULaZv/qwV0eMLzUYJfSug2QcN
	PF5qg8zxWf6J9Ck8J2cA8MpGiFaRFqJrkRemuiUnqPeaTeYyvMMEPRgDdeSf3I/u/ektq3
	eF6Ph39f6Ecz2Lt16AcBGwOzBF8a2Uo=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-223-Bx_NkW48PtCHUZy4ycgSgw-1; Thu, 11 Sep 2025 10:49:34 -0400
X-MC-Unique: Bx_NkW48PtCHUZy4ycgSgw-1
X-Mimecast-MFC-AGG-ID: Bx_NkW48PtCHUZy4ycgSgw_1757602173
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45df609b181so6530495e9.2
        for <kvm@vger.kernel.org>; Thu, 11 Sep 2025 07:49:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757602172; x=1758206972;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qhARN+mNZ8/BVngVsPUupvVPf6ZiX6bQWjwA8ImXvMA=;
        b=FMD3DNA3a90m/57I45u57qXwdRuUiwL5J0pjlDBrznE6pS40N+muOBjCUlnpL8oIw0
         9QF51kNCxUChED4F94WZpXkTCMBmDwJA4jAw68qWHawdZTUWUGpHlL6GeNmHI8S92bJF
         yh3wdkBRdjRt837SbmHFLVT237MZf5n3eim1m+V/3MvRNOSexHslZo04jrXwrscUD+c7
         wwNLlA2bv3wl1msV8zhqYNhPAQ3tdyUDnmRb2VaoZ3in7rV1Ixtkm6CCIcTIYquhZ7cy
         QuDfdXSjG2NA1SeEXhs46T3kv5Uckm+l44DVnPgbWok9nJRcs5uEzgbOY/JjrG+Kkqne
         arqA==
X-Forwarded-Encrypted: i=1; AJvYcCUaiVTafZEZJf0IX3NrcqZkLKQfLSzH1U8Tx/v53Bfk2e/udGd8uwae0ZG0Xc9DyFngbYs=@vger.kernel.org
X-Gm-Message-State: AOJu0YzisjfxdqSYQcd3QVpVsAH6Z7G5ZQLZnMM6iTdP+D2exCMKs+p9
	1tkesX1MH6M90lFG7gALdxSVHZXvSax6bbce8E5enGwA0qeYTbtnsWM0P5kgH80LG/t1UwHMo6n
	9NEkpaNX6xjQ6ObWTUZNuBne66Ga79vbdOVKmOYkl13AAXTdjJKNZSA==
X-Gm-Gg: ASbGncsrnGiwicMteCzrCkLAEXHwCdQ45AgQzYDpLB9hX0NSctKfDNPPEZ2xCbVOf/d
	rVPJ7a+Bdon0F2Z57Rnhf3OgVUWE6ELbEvwiQTc8WMkxeshpAWEa0zQbhbgvyooxluvR06pnDI3
	Q41P9eZPfsWIgWG8mxKcItL72JSdEHMvcvEEyi0ID7DjLO3mXT+56haDo9A8zPSYR8T/+Uew3dB
	qBtIAQrdEu5cRGD6RnJmAxboCiaM/dyK0zHQYyi4dbZppZwnZPrUg/RQz+gkOuQ8WU2uF1d2t9j
	4C2PY5tNKAYcfdBh3P0EDyuNs5vsyC29Et4x8aREvqCIJjylm+t3mu0hz8+eZVFpXWuQVMOH8kK
	rChCcnL7c+0UiA2tSbkQ6cHz2wA4e
X-Received: by 2002:a05:600c:458d:b0:45d:d50d:c0db with SMTP id 5b1f17b1804b1-45dddea5102mr187737235e9.15.1757602172217;
        Thu, 11 Sep 2025 07:49:32 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH+kA6YZTRhZd5X5QimgLs1ZYj0Z47mJrQEG6Ss0yU0cL2ujYrc0KdLoKgcnkha3tXuafRtVg==
X-Received: by 2002:a05:600c:458d:b0:45d:d50d:c0db with SMTP id 5b1f17b1804b1-45dddea5102mr187736895e9.15.1757602171717;
        Thu, 11 Sep 2025 07:49:31 -0700 (PDT)
Received: from rh.redhat.com (p200300f6af131a0027bd20bfc18c447d.dip0.t-ipconnect.de. [2003:f6:af13:1a00:27bd:20bf:c18c:447d])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45e0159c27csm14941575e9.8.2025.09.11.07.49.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Sep 2025 07:49:31 -0700 (PDT)
From: Sebastian Ott <sebott@redhat.com>
To: Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: qemu-arm@nongnu.org,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Sebastian Ott <sebott@redhat.com>
Subject: [PATCH 2/2] target/arm/kvm: add kvm-psci-version vcpu property
Date: Thu, 11 Sep 2025 16:49:23 +0200
Message-ID: <20250911144923.24259-3-sebott@redhat.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250911144923.24259-1-sebott@redhat.com>
References: <20250911144923.24259-1-sebott@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Provide a kvm specific vcpu property to override the default
(as of kernel v6.13 that would be PSCI v1.3) PSCI version emulated
by kvm. Current valid values are: 0.1, 0.2, 1.0, 1.1, 1.2, and 1.3

Signed-off-by: Sebastian Ott <sebott@redhat.com>
---
 docs/system/arm/cpu-features.rst |  5 +++
 target/arm/cpu.h                 |  6 +++
 target/arm/kvm.c                 | 70 +++++++++++++++++++++++++++++++-
 3 files changed, 80 insertions(+), 1 deletion(-)

diff --git a/docs/system/arm/cpu-features.rst b/docs/system/arm/cpu-features.rst
index 37d5dfd15b..1d32ce0fee 100644
--- a/docs/system/arm/cpu-features.rst
+++ b/docs/system/arm/cpu-features.rst
@@ -204,6 +204,11 @@ the list of KVM VCPU features and their descriptions.
   the guest scheduler behavior and/or be exposed to the guest
   userspace.
 
+``kvm-psci-version``
+  Override the default (as of kernel v6.13 that would be PSCI v1.3)
+  PSCI version emulated by the kernel. Current valid values are:
+  0.1, 0.2, 1.0, 1.1, 1.2, and 1.3
+
 TCG VCPU Features
 =================
 
diff --git a/target/arm/cpu.h b/target/arm/cpu.h
index c15d79a106..44292aab32 100644
--- a/target/arm/cpu.h
+++ b/target/arm/cpu.h
@@ -974,6 +974,12 @@ struct ArchCPU {
      */
     uint32_t psci_version;
 
+    /*
+     * Intermediate value used during property parsing.
+     * Once finalized, the value should be read from psci_version.
+     */
+    uint32_t prop_psci_version;
+
     /* Current power state, access guarded by BQL */
     ARMPSCIState power_state;
 
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index 6672344855..bc6073f395 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -483,6 +483,59 @@ static void kvm_steal_time_set(Object *obj, bool value, Error **errp)
     ARM_CPU(obj)->kvm_steal_time = value ? ON_OFF_AUTO_ON : ON_OFF_AUTO_OFF;
 }
 
+static char *kvm_get_psci_version(Object *obj, Error **errp)
+{
+    ARMCPU *cpu = ARM_CPU(obj);
+    const char *val;
+
+    switch (cpu->prop_psci_version) {
+    case QEMU_PSCI_VERSION_0_1:
+        val = "0.1";
+        break;
+    case QEMU_PSCI_VERSION_0_2:
+        val = "0.2";
+        break;
+    case QEMU_PSCI_VERSION_1_0:
+        val = "1.0";
+        break;
+    case QEMU_PSCI_VERSION_1_1:
+        val = "1.1";
+        break;
+    case QEMU_PSCI_VERSION_1_2:
+        val = "1.2";
+        break;
+    case QEMU_PSCI_VERSION_1_3:
+        val = "1.3";
+        break;
+    default:
+        val = "0.2";
+        break;
+    }
+    return g_strdup(val);
+}
+
+static void kvm_set_psci_version(Object *obj, const char *value, Error **errp)
+{
+    ARMCPU *cpu = ARM_CPU(obj);
+
+    if (!strcmp(value, "0.1")) {
+        cpu->prop_psci_version = QEMU_PSCI_VERSION_0_1;
+    } else if (!strcmp(value, "0.2")) {
+        cpu->prop_psci_version = QEMU_PSCI_VERSION_0_2;
+    } else if (!strcmp(value, "1.0")) {
+        cpu->prop_psci_version = QEMU_PSCI_VERSION_1_0;
+    } else if (!strcmp(value, "1.1")) {
+        cpu->prop_psci_version = QEMU_PSCI_VERSION_1_1;
+    } else if (!strcmp(value, "1.2")) {
+        cpu->prop_psci_version = QEMU_PSCI_VERSION_1_2;
+    } else if (!strcmp(value, "1.3")) {
+        cpu->prop_psci_version = QEMU_PSCI_VERSION_1_3;
+    } else {
+        error_setg(errp, "Invalid PSCI-version value");
+        error_append_hint(errp, "Valid values are 0.1, 0.2, 1.0, 1.1, 1.2, 1.3\n");
+    }
+}
+
 /* KVM VCPU properties should be prefixed with "kvm-". */
 void kvm_arm_add_vcpu_properties(ARMCPU *cpu)
 {
@@ -504,6 +557,12 @@ void kvm_arm_add_vcpu_properties(ARMCPU *cpu)
                              kvm_steal_time_set);
     object_property_set_description(obj, "kvm-steal-time",
                                     "Set off to disable KVM steal time.");
+
+    object_property_add_str(obj, "kvm-psci-version", kvm_get_psci_version,
+                            kvm_set_psci_version);
+    object_property_set_description(obj, "kvm-psci-version",
+                                    "Set PSCI version. "
+                                    "Valid values are 0.1, 0.2, 1.0, 1.1, 1.2, 1.3");
 }
 
 bool kvm_arm_pmu_supported(void)
@@ -1883,7 +1942,8 @@ int kvm_arch_init_vcpu(CPUState *cs)
     if (cs->start_powered_off) {
         cpu->kvm_init_features[0] |= 1 << KVM_ARM_VCPU_POWER_OFF;
     }
-    if (kvm_check_extension(cs->kvm_state, KVM_CAP_ARM_PSCI_0_2)) {
+    if (cpu->prop_psci_version != QEMU_PSCI_VERSION_0_1 &&
+        kvm_check_extension(cs->kvm_state, KVM_CAP_ARM_PSCI_0_2)) {
         cpu->psci_version = QEMU_PSCI_VERSION_0_2;
         cpu->kvm_init_features[0] |= 1 << KVM_ARM_VCPU_PSCI_0_2;
     }
@@ -1922,6 +1982,14 @@ int kvm_arch_init_vcpu(CPUState *cs)
         }
     }
 
+    if (cpu->prop_psci_version) {
+        psciver = cpu->prop_psci_version;
+        ret = kvm_set_one_reg(cs, KVM_REG_ARM_PSCI_VERSION, &psciver);
+        if (ret) {
+            error_report("PSCI version %lx is not supported by KVM", psciver);
+            return ret;
+        }
+    }
     /*
      * KVM reports the exact PSCI version it is implementing via a
      * special sysreg. If it is present, use its contents to determine
-- 
2.42.0


