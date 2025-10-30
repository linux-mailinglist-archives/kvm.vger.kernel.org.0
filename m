Return-Path: <kvm+bounces-61507-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 8CE92C215BD
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 18:04:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id B4D234F3DBF
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 16:59:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E7753655F2;
	Thu, 30 Oct 2025 16:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iMLm+RIv"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFEA733F8BC
	for <kvm@vger.kernel.org>; Thu, 30 Oct 2025 16:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761843558; cv=none; b=KSuwek6O8xc8I6DZlWHUhKd6L19zRsgDRDgnRVbVgFtkO/bR29ZuBCoVrBGu2fRcvIMHJ3ZimG2bOtdvvtOVZvDXKqS6yvZpnGN6YNLmNikVqfSZrrUCxzqcjiaiI+SRxtILKeZtGjH1puCdsNziKs6R3nNbnc2ZpOJfUKS/vlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761843558; c=relaxed/simple;
	bh=yxg5JtWcJU3AQI+LcX9lc7Atq1+nQtMZD0d/LAMglMA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gZeEUw1SkhrltXjA7kU6AsVB0ArtgGC+pmiQgbeeXRwHWRkATd5w1i47RJkSUQgyCf0woIojwbz/vP4JEV7OhD3ak9DLJVKNFLKshmONebE4J/6i8ghoWcm5oFr0pA93UnP+EEg0/N2TN445JgQo0iUggebmZUn8HJ0HcHqW6Pg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iMLm+RIv; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761843555;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=y4ko4KBU7aEgwSx+DTL8x/7Jpcfxyw8R2e/RIc9ttX4=;
	b=iMLm+RIvZND1niHoDxYlYtDce9selnItfYBSIGmu94d3kB7XGgdt8blwL7PJXYjuDL4oEr
	8moRFqZo/3XwpfgPQLNyDZAd/gz/ZDck5gaw2CdQ3hdE2e5AklgGOwB5ZSfX1jSw45I4/r
	AfbjGB4hGrWYHNw2dH296AlhtlMkPyg=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-615-yoBfvY55Pcm1Dg5CCw45KQ-1; Thu, 30 Oct 2025 12:59:14 -0400
X-MC-Unique: yoBfvY55Pcm1Dg5CCw45KQ-1
X-Mimecast-MFC-AGG-ID: yoBfvY55Pcm1Dg5CCw45KQ_1761843553
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-429af6b48a8so1537003f8f.1
        for <kvm@vger.kernel.org>; Thu, 30 Oct 2025 09:59:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761843553; x=1762448353;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=y4ko4KBU7aEgwSx+DTL8x/7Jpcfxyw8R2e/RIc9ttX4=;
        b=FgyI3HOYg/PhaKCKlbVXQzKCYJuCY/mNmn16spm2E4V6amQuVPXXFHSm/Xud/UaDFs
         KHGlLqx0rUgsCQEjBdyQpNAL33tFIEf5aiJRfTKNW2Sif81fdVHQJjCxWwG8PPm46S+q
         Ls6jun4AH5cgByrwugUCLH1u4yBwhl/px58pfNMmZa/1lUZvwTF7e4kskUv2hAkHHrj7
         HcKfTsg3x8VICe6OqOaMNDftXdcF03Cf6JJVVgtQ1LhYXwFs3k4P/Tpy1mLYps/psqwr
         BtqLv2weaSqNSmYoG7MOAgKQXWEOKeEaFC4wvnyu6UATY6PSpH/Apx0Yk2Eaz4PC8A4Z
         9eCw==
X-Forwarded-Encrypted: i=1; AJvYcCUa2SsqryniB/fDgoYPHY3avYMIwZKZDQUEGTvFFyq3tJF3l2A0/q/EPKtM7buinHysBsg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy+tp9wBpn3IAgvb3G6mr4DKXtc9ArcT1LDXLd5toRHvYoik52H
	coPU8UuRtiIjW5O6DCG0BIFMVk4uFiHvkBJMJUwcTdSvl/NUvau/KafDNeHGe2LBBx75R2UHuud
	RkAef2DEyiuJBGMC2SI2NEGXrimfusGeFIfMp4Ecji32lwfVQ0rj0Mw==
X-Gm-Gg: ASbGncuwv/jvYsjm8OCpOaG98ssxxuxTS9pkC0aR5k7SGu/7hYyTL3yna/YI79XTfYo
	131X9nYYYSVFxqoom0GTQZCjMHqzmSzdT/aNcgI8I+DrL8o+beI5rR+rLOaNykUljHqITKRhl26
	AKGFBz+lj6J+yLzhUAQ+WRhXhw+SodfFxw0lRTUKfVyZ7Cw5zMx41XB+fgOjDP0iz1n00TbAOO1
	FgNDyfvIQXoswj95ouyaStIhpoADG3NKBsgPI0+rUkZn5LxBVO23rlBeUCnKv92j6WxEkM1j3a2
	cftugm78AirJUYu+8+0+hhudYgZQiU01NdKPbVBfnKodBlEJxO8wvTUFZDIQaHJ0c6/sHhCTul2
	qX6A4KKnCZQgHfWc3ES2+Hw7xrb2VBmc7D4EodnFK98PVYSdWNpHwmHIFuScrDGo=
X-Received: by 2002:a05:600c:871a:b0:476:a25f:6a4d with SMTP id 5b1f17b1804b1-477305a6daamr3525405e9.1.1761843552948;
        Thu, 30 Oct 2025 09:59:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGtxStmlfeeaS5Y8HP2+7UT81SENobqh4RvvVYY+Oiqs7Zmi4aE+qYv9gWYq8tm8LCZq3ZUGA==
X-Received: by 2002:a05:600c:871a:b0:476:a25f:6a4d with SMTP id 5b1f17b1804b1-477305a6daamr3525165e9.1.1761843552439;
        Thu, 30 Oct 2025 09:59:12 -0700 (PDT)
Received: from rh.redhat.com (p200300f6af131a0027bd20bfc18c447d.dip0.t-ipconnect.de. [2003:f6:af13:1a00:27bd:20bf:c18c:447d])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-477289e7cf5sm51104085e9.14.2025.10.30.09.59.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Oct 2025 09:59:12 -0700 (PDT)
From: Sebastian Ott <sebott@redhat.com>
To: Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Eric Auger <eric.auger@redhat.com>
Cc: qemu-arm@nongnu.org,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Sebastian Ott <sebott@redhat.com>
Subject: [PATCH v2 2/2] target/arm/kvm: add kvm-psci-version vcpu property
Date: Thu, 30 Oct 2025 17:59:05 +0100
Message-ID: <20251030165905.73295-3-sebott@redhat.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251030165905.73295-1-sebott@redhat.com>
References: <20251030165905.73295-1-sebott@redhat.com>
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
 target/arm/cpu.h                 |  6 ++++
 target/arm/kvm.c                 | 60 +++++++++++++++++++++++++++++++-
 3 files changed, 70 insertions(+), 1 deletion(-)

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
index 39f2b2e54d..c2032070b7 100644
--- a/target/arm/cpu.h
+++ b/target/arm/cpu.h
@@ -981,6 +981,12 @@ struct ArchCPU {
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
index 0d57081e69..c53b307b76 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -484,6 +484,49 @@ static void kvm_steal_time_set(Object *obj, bool value, Error **errp)
     ARM_CPU(obj)->kvm_steal_time = value ? ON_OFF_AUTO_ON : ON_OFF_AUTO_OFF;
 }
 
+struct psci_version {
+    uint32_t number;
+    const char *str;
+};
+
+static const struct psci_version psci_versions[] = {
+    { QEMU_PSCI_VERSION_0_1, "0.1" },
+    { QEMU_PSCI_VERSION_0_2, "0.2" },
+    { QEMU_PSCI_VERSION_1_0, "1.0" },
+    { QEMU_PSCI_VERSION_1_1, "1.1" },
+    { QEMU_PSCI_VERSION_1_2, "1.2" },
+    { QEMU_PSCI_VERSION_1_3, "1.3" },
+    { -1, NULL },
+};
+
+static char *kvm_get_psci_version(Object *obj, Error **errp)
+{
+    ARMCPU *cpu = ARM_CPU(obj);
+    const struct psci_version *ver;
+
+    for (ver = psci_versions; ver->number != -1; ver++) {
+        if (ver->number == cpu->prop_psci_version)
+            return g_strdup(ver->str);
+    }
+
+    g_assert_not_reached();
+}
+
+static void kvm_set_psci_version(Object *obj, const char *value, Error **errp)
+{
+    ARMCPU *cpu = ARM_CPU(obj);
+    const struct psci_version *ver;
+
+    for (ver = psci_versions; ver->number != -1; ver++) {
+        if (!strcmp(value, ver->str)) {
+            cpu->prop_psci_version = ver->number;
+            return;
+        }
+    }
+
+    error_setg(errp, "Invalid PSCI-version value");
+}
+
 /* KVM VCPU properties should be prefixed with "kvm-". */
 void kvm_arm_add_vcpu_properties(ARMCPU *cpu)
 {
@@ -505,6 +548,12 @@ void kvm_arm_add_vcpu_properties(ARMCPU *cpu)
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
@@ -1959,7 +2008,8 @@ int kvm_arch_init_vcpu(CPUState *cs)
     if (cs->start_powered_off) {
         cpu->kvm_init_features[0] |= 1 << KVM_ARM_VCPU_POWER_OFF;
     }
-    if (kvm_check_extension(cs->kvm_state, KVM_CAP_ARM_PSCI_0_2)) {
+    if (cpu->prop_psci_version != QEMU_PSCI_VERSION_0_1 &&
+        kvm_check_extension(cs->kvm_state, KVM_CAP_ARM_PSCI_0_2)) {
         cpu->psci_version = QEMU_PSCI_VERSION_0_2;
         cpu->kvm_init_features[0] |= 1 << KVM_ARM_VCPU_PSCI_0_2;
     }
@@ -1998,6 +2048,14 @@ int kvm_arch_init_vcpu(CPUState *cs)
         }
     }
 
+    if (cpu->prop_psci_version) {
+        psciver = cpu->prop_psci_version;
+        ret = kvm_set_one_reg(cs, KVM_REG_ARM_PSCI_VERSION, &psciver);
+        if (ret) {
+            error_report("PSCI version %"PRIx64" is not supported by KVM", psciver);
+            return ret;
+        }
+    }
     /*
      * KVM reports the exact PSCI version it is implementing via a
      * special sysreg. If it is present, use its contents to determine
-- 
2.42.0


