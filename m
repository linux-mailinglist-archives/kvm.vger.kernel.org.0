Return-Path: <kvm+bounces-62916-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id CE792C53DEA
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 19:14:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 2BC3234354F
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 18:14:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2067134A3BF;
	Wed, 12 Nov 2025 18:14:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="G8EBYSWn";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="of7yRQn+"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B2A634887B
	for <kvm@vger.kernel.org>; Wed, 12 Nov 2025 18:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762971254; cv=none; b=nuC83mbV+jLqZX11iBHkYQsuGNEwIzF0H4GK+h0gXK38sg6gQdxyah7FcoNsKDSQFkHImjSpRwkzo9lqFzbd08LuSKVDf8oL5CWz+rJ5o90QgmNhqjZwejp0L+MB4hH77kOJBv6WXgKwPOu0hydTXcyYIQ2C+Le4rVaa6CyWhYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762971254; c=relaxed/simple;
	bh=E/lPvDFxtdKz/fvz2i0BZfz6Y2YfQQrewCfi1yv0nLw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EH88lrtP/cnle6/RQneZjPA4SfsXnUtKGIcRKMUlB7j6ijqjW9kLXhLNBBSV4+jzAixdZctovfsg3ln+nhXRSW1YSWLpKOa+Nopqum2aeeri6pZ5y1wxpeu9+9IquJcuBN17fE1vpv/74oS6aDjQarhsQpa0TFO8Q0iX9FM7JUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=G8EBYSWn; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=of7yRQn+; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762971251;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tvPCq7VyEuzcNyp7CnFoOXZYmZVPIQ6yNur1I1qze6g=;
	b=G8EBYSWny7SrnRKq17R5Cwkvly/oXS3NnvHnRfg6vwnc2oEKKGKaty/FWc0GZDEjnbKD+/
	PgR/qVgsdn4YgLV4mRC3CHvLJulZXcBX4c7YP31Tq9WoexkHF3R935Bi0VRqAS0toEkKQh
	LFD0JTH/T/1OPG4v/CDhxMOc+TktDuM=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-490-Lm1jeDwpMo21aq7dbZYvGQ-1; Wed, 12 Nov 2025 13:14:10 -0500
X-MC-Unique: Lm1jeDwpMo21aq7dbZYvGQ-1
X-Mimecast-MFC-AGG-ID: Lm1jeDwpMo21aq7dbZYvGQ_1762971249
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-475dabb63f2so5431055e9.3
        for <kvm@vger.kernel.org>; Wed, 12 Nov 2025 10:14:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1762971249; x=1763576049; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tvPCq7VyEuzcNyp7CnFoOXZYmZVPIQ6yNur1I1qze6g=;
        b=of7yRQn+KPjh+eGG0I0LMwjUW9l19XK6XITJE2fYtya81lhmG4pFqQEScqiYefe1HU
         YbfyU7XMmqXPbDj1Lbd9q0VSifHqbM31xw32JeYciFbXF562jydeRjLyN/lDHS6LEvi6
         SOUmu80OjJO2wPdMASJmQ3AVmGbaA4LWBkni6vmNVZxCwM7ZvlOjRKwJ1/gJdJQMymxk
         2wjdQ9AbsRwORflXc0515Eb9xuPpeBr+NJtxgchjkOLzSpB2oC1bng8ock74J6jm/cnW
         5eZeaLMgR7F5C2Az+NVtVebq2eVbS+bXSrcquaALUaErmBnDNb50IIYJ4H5JkONQEicX
         Oe9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762971249; x=1763576049;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tvPCq7VyEuzcNyp7CnFoOXZYmZVPIQ6yNur1I1qze6g=;
        b=fsi8jv4qleohKFQS1VfcZVsAaq/UOLHxvxPDZiJMx/d6Qm4CaM2rRXM3XPxNGlgicd
         HSTqejO31Y7xZD1h70QR+dOf7NCkvtHcKHSErIdwtuKo+63XZk19hjXY9FRjPCS/Gjdb
         3K6Ffsv2DZpKdQA4qPSLhigT+YmSUFLkaNW0AUYZts8xqbe6mm/Hqji2tYziBmK7kZzx
         HlklVmRDl1KPkOnkNv2G46GEQrN7PS1x7KZ81BztiKwT1rnAQp8/aJvg+6S/GDvzIn+5
         FqouFC0wPNnXc3noeqTz2I4v8TS3mjEHIxBAHSJgB5HxgpEU6ednLeH5YsM1viascpmo
         ofEQ==
X-Forwarded-Encrypted: i=1; AJvYcCVA8CPB+3k4OIazpKYO9IIoKB5oGXr9Mx3EJ/3r+KEfvkGfDyezEmXDN+PaFdR9FJkqsUY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzO/ds3LmC3FmLaFyp9rOjqguIIeUvvxuWlXCOpW4JMpIXqtCNB
	J0ERdVBwicsNCuWmdx9GTRoYVH/COGEBoAoGtmw+Z0anReUnrTajiv9vYnnH1d116poRfXpCSCO
	YFqkjEgHYYMWngVrDjTsLQs27eRQ/kO691ydslirVcpvEV+ohqKA6bg==
X-Gm-Gg: ASbGncu7YaVq9AQJ9NaElkxsX2YiLpPxFuIMLKCskWeDibUG+04gP5yfmr/9Nh8t/Sd
	W7uiqACr+V1ZrlfwNCc+7mU16AEpbgrBpKfd6f6fwWKFzLSdfcAENCQb5ONt4dFlFYQk0hWHBN/
	r1I+GsNGk+uK1Jo/v5y1ezezWrLLPODWp536NAu40mN0XBdZeh8xRJdKYWt9KSIvaTWZeT7Ke4D
	hyFsR5JWCTw+0A88tZhL9HLPK2Qp27qAUYCzQCeGXMnQQoDni1O4OMyKNeafiIxNqhdJyOSpYKU
	BT5aIZ9Qngy260zNwqk31Cl7k67YWEdKnvMkC7ShdxNP6hOvUw4KKDdUPQ9O97dnkjc9igodmYV
	4grWnKpNfXp7MpoRtlOcctRoIprrK8dkBI9ptkPbeMozm7euA/yEm/RLOaQPUQw==
X-Received: by 2002:a05:600c:6305:b0:45d:dc85:c009 with SMTP id 5b1f17b1804b1-4778704c87amr36369965e9.10.1762971248742;
        Wed, 12 Nov 2025 10:14:08 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGOtRuApVaSJzjluxq/syrI6PaRRaNwBA+5BiNbfifiB+oERbEdmvKrC/cBX/JWi/+NkctM3Q==
X-Received: by 2002:a05:600c:6305:b0:45d:dc85:c009 with SMTP id 5b1f17b1804b1-4778704c87amr36369595e9.10.1762971248323;
        Wed, 12 Nov 2025 10:14:08 -0800 (PST)
Received: from rh.fritz.box (p200300f6af131a0027bd20bfc18c447d.dip0.t-ipconnect.de. [2003:f6:af13:1a00:27bd:20bf:c18c:447d])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47787e51e49sm46851355e9.7.2025.11.12.10.14.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Nov 2025 10:14:07 -0800 (PST)
From: Sebastian Ott <sebott@redhat.com>
To: Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Eric Auger <eric.auger@redhat.com>
Cc: qemu-arm@nongnu.org,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Sebastian Ott <sebott@redhat.com>
Subject: [PATCH v3 2/2] target/arm/kvm: add kvm-psci-version vcpu property
Date: Wed, 12 Nov 2025 19:13:57 +0100
Message-ID: <20251112181357.38999-3-sebott@redhat.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251112181357.38999-1-sebott@redhat.com>
References: <20251112181357.38999-1-sebott@redhat.com>
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

Note: in order to support PSCI v0.1 we need to drop vcpu
initialization with KVM_CAP_ARM_PSCI_0_2 in that case.

Signed-off-by: Sebastian Ott <sebott@redhat.com>
---
 docs/system/arm/cpu-features.rst |  5 +++
 target/arm/cpu.h                 |  6 +++
 target/arm/kvm.c                 | 64 +++++++++++++++++++++++++++++++-
 3 files changed, 74 insertions(+), 1 deletion(-)

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
index 0d57081e69..e91b1abfb8 100644
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
+        if (ver->number == cpu->psci_version)
+            return g_strdup(ver->str);
+    }
+
+    return g_strdup_printf("Unknown PSCI-version: %x", cpu->psci_version);
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
@@ -1959,7 +2008,12 @@ int kvm_arch_init_vcpu(CPUState *cs)
     if (cs->start_powered_off) {
         cpu->kvm_init_features[0] |= 1 << KVM_ARM_VCPU_POWER_OFF;
     }
-    if (kvm_check_extension(cs->kvm_state, KVM_CAP_ARM_PSCI_0_2)) {
+    if (cpu->prop_psci_version != QEMU_PSCI_VERSION_0_1 &&
+        kvm_check_extension(cs->kvm_state, KVM_CAP_ARM_PSCI_0_2)) {
+        /*
+         * Versions >= v0.2 are backward compatible with v0.2
+         * omit the feature flag for v0.1 .
+         */
         cpu->psci_version = QEMU_PSCI_VERSION_0_2;
         cpu->kvm_init_features[0] |= 1 << KVM_ARM_VCPU_PSCI_0_2;
     }
@@ -1998,6 +2052,14 @@ int kvm_arch_init_vcpu(CPUState *cs)
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


