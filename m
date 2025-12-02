Return-Path: <kvm+bounces-65155-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BAADC9C295
	for <lists+kvm@lfdr.de>; Tue, 02 Dec 2025 17:15:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1964C3AEC2C
	for <lists+kvm@lfdr.de>; Tue,  2 Dec 2025 16:09:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B88B29AB07;
	Tue,  2 Dec 2025 16:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="idnEYckd";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="DY27DDZz"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 602EC2857CF
	for <kvm@vger.kernel.org>; Tue,  2 Dec 2025 16:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764691747; cv=none; b=ja9nt5RlI41o1X+rAi7KJLqGWAIzGkAImcF4Nu3UsBBFE+ETZa8yoepKkZ70I3z6jRGSeAnTibQ0V4jIAnGaiDU/w1zBCfje5g+NgiX3qvuCwmXsMo4nuuv1NRPxB2qMEApFnnoal7tuu37TquteI41qNdCgK4qj0x4GX5woMUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764691747; c=relaxed/simple;
	bh=SAC5PVF/M2K/FzmI2laJU5uE1ZFP3skk03G1HqtqQRE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KbqsebqNJy79zwhnsaCXAcKO4/C4zYQA30BdNyFA8ExO2n981XKxCoC0z9zp0BbuwI38PbOgI3iM/5ZUcO6VhMj+TlOR3ZLpqlFWdvGvA9LSEj+zp/HfiWcYdNl8FKWUzUooqHNKER+tSevsGJ7s4a2C6bwXHkkEShHmbA1qth4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=idnEYckd; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=DY27DDZz; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764691743;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1r6iwMV7OOxfpGBTEnAoro8MxvDg/dbyx+KBPvZFR2o=;
	b=idnEYckdC3HQqhJ0nNg7XZRDT5A8v8FaHHI4Y5JQPN0Tkq5gf3dG3asRAEaU8lIsRCtUut
	UtNfMtTDTuhdp2P601WmFGHi2EX+aC+23RyylV7lq58eJ7xZOlwOJvegZMawbtOIILU4zl
	HX9RTO87/B4ubJKuWwVQ0KTIHZE4m18=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-255-WcYCLZFoNzeqKEVf9zioOQ-1; Tue, 02 Dec 2025 11:09:02 -0500
X-MC-Unique: WcYCLZFoNzeqKEVf9zioOQ-1
X-Mimecast-MFC-AGG-ID: WcYCLZFoNzeqKEVf9zioOQ_1764691741
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-47106720618so72831775e9.1
        for <kvm@vger.kernel.org>; Tue, 02 Dec 2025 08:09:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764691741; x=1765296541; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1r6iwMV7OOxfpGBTEnAoro8MxvDg/dbyx+KBPvZFR2o=;
        b=DY27DDZz70CTNjtps52MrAwKfVXoYA8VQFi3/G9tD42RpbDgEdamtqaPWv5sR0O5W8
         2hri9OpKoKIMNJridLoaFaG6NtoUiA1G9PlsK1KNG2EIawmYPvSPnFOnwY/OrLVi8UVw
         HsF1D1zgEQGVNIpuae7sI/U7hyTEWSwwsQRA2vYumFUVAA8kGVBBO6QGHAmNCFfmtS4R
         7I0vgNnzZaJVQTQZa7Y5DNTKY/IH3yWNaeaCXNwiLCY/LGTlgCFYlKFbtIQ2x7swBsdS
         sN0DmCy6JOIQeT4WS6XCHqQ63ukpb0woR2XxeBcvC9d/cPsPzziUZdvWbR/3APCEj4zG
         aAsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764691741; x=1765296541;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1r6iwMV7OOxfpGBTEnAoro8MxvDg/dbyx+KBPvZFR2o=;
        b=lqSYxj1r9fekZcCDNcC1c8bOnIeIm62rG3BtJWLneKAMhVxsRXYKGAcZJtWTJQULw1
         H2VmgV8PzyzR54mmBZfzjTnx8XQ5844cjqAEOww3WZFiC37j60zUdXvT0DzU3BC+l5DO
         ltQ2pxOQoS/IEtWut9LMzFgQoZUYt7NwmtwHIwBq4TiiMZDvPqhnpHbFrmLIgtxjgsn+
         EbJXzLWSEFNz2qNMLehUs7fzQm4+dNBB9s4oXG/aanwea4sY6FAkiVWlFdF5wqaD3tqh
         ib+CpMsj43YbDWGPGMsCRMN0riENjbvdzt/tQ9hIMpgDP37nKszxnF3rcSE3kxa/t7lw
         qAWA==
X-Forwarded-Encrypted: i=1; AJvYcCW2Bb1p8RIMkRTMbqwPerZkBbienaG1ZmIvp9kdk7HubQYGoJJ4G+d1r7H+dwIwfAlPyBo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy34kT65Ep3SqZy1RuQmFKGAc+QuAbpoeo4P5/M9T0X7ojbvGsz
	j5ges88u6avudypO43tpATYsnExwVt4PC8Ud3Vima7gZs87PSIkg839HC62JpK3Urke1fmirFIt
	MPo98144iI8drpkiJoPizQRmd6wDhZJQHb0g/ww81I+TsO+ZY+a3Mnw==
X-Gm-Gg: ASbGncsGSdLJZUPdd1UE8ooFqtkW4Qe+yof+MMG4aQHeKY1AtBNUa/mGVaXc/rUlk4a
	SGUWrND3jZ6nweM1dgfEN7p88GiP6ktKXDstNog+mrEamavn6XQAMDHFbziv4WJ6PW+nX4tfRqt
	m6+5O4LRm1FkY/HLcbHk9TzdK3Pp5O/MA6OCjQlPfgdSKn8vn5KRk8QfKvRxTeSNA81yK+nnKsn
	99SAuIlBXMF5dPiHQrtUP9gZncU6f30NIvAWF3cBzqIQZV8gOUJGfK/GGdN4uE0IYiJMSkbtv0J
	qg9oBIAXBmuQ3sxjawpcKO7vSEiZHhcYbUfXPSmZonRtnGb7989Bw8AOy6KmfgpJLSc29elcWbN
	MsPYEG7VYIR6TZ8Pe/zyduBiOFI0/sc/6tUzHolOY8xrgespSjoJlnDtbT37s4Bk06oXmfLSz
X-Received: by 2002:a5d:584d:0:b0:42b:3592:1b82 with SMTP id ffacd0b85a97d-42cc1ac9c76mr46078126f8f.1.1764691740753;
        Tue, 02 Dec 2025 08:09:00 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG5eHkIz8G/4NXCExVWJEsXbaVN2WN77R5ZJZIrxOxxmaTtp/wopCTKYSwO8GkK2AKblszQOg==
X-Received: by 2002:a5d:584d:0:b0:42b:3592:1b82 with SMTP id ffacd0b85a97d-42cc1ac9c76mr46078089f8f.1.1764691740199;
        Tue, 02 Dec 2025 08:09:00 -0800 (PST)
Received: from rh.redhat.com (p200300f6af35a800883b071bf1f3e4b6.dip0.t-ipconnect.de. [2003:f6:af35:a800:883b:71b:f1f3:e4b6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42e1caa767dsm34300899f8f.38.2025.12.02.08.08.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Dec 2025 08:08:59 -0800 (PST)
From: Sebastian Ott <sebott@redhat.com>
To: Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Eric Auger <eric.auger@redhat.com>
Cc: qemu-arm@nongnu.org,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Sebastian Ott <sebott@redhat.com>
Subject: [PATCH v4 2/2] target/arm/kvm: add kvm-psci-version vcpu property
Date: Tue,  2 Dec 2025 17:08:53 +0100
Message-ID: <20251202160853.22560-3-sebott@redhat.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251202160853.22560-1-sebott@redhat.com>
References: <20251202160853.22560-1-sebott@redhat.com>
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
Reviewed-by: Eric Auger <eric.auger@redhat.com>
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
index 39f2b2e54d..e2b6b587ea 100644
--- a/target/arm/cpu.h
+++ b/target/arm/cpu.h
@@ -1035,6 +1035,12 @@ struct ArchCPU {
     bool kvm_vtime_dirty;
     uint64_t kvm_vtime;
 
+    /*
+     * Intermediate value used during property parsing.
+     * Once finalized, the value should be read from psci_version.
+     */
+    uint32_t kvm_prop_psci_version;
+
     /* KVM steal time */
     OnOffAuto kvm_steal_time;
 
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index 0d57081e69..cf2de87287 100644
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
+            cpu->kvm_prop_psci_version = ver->number;
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
+    if (cpu->kvm_prop_psci_version != QEMU_PSCI_VERSION_0_1 &&
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
 
+    if (cpu->kvm_prop_psci_version) {
+        psciver = cpu->kvm_prop_psci_version;
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


