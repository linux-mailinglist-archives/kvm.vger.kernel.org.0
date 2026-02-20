Return-Path: <kvm+bounces-71406-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AI03JytMmGmaFgMAu9opvQ
	(envelope-from <kvm+bounces-71406-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 12:57:31 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 33B1F167615
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 12:57:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B0425304E0C1
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 11:57:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8108C34029E;
	Fri, 20 Feb 2026 11:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QLygrL0T";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="ls/en7Qw"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AAA0330B01
	for <kvm@vger.kernel.org>; Fri, 20 Feb 2026 11:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771588627; cv=none; b=gUixlAgkHmfFUH5fejz4TTc1cf8Ov4pSBrIGH7B3BI7SdFZj2zYxkY034flLJXbH4cGelcxaS7E3uHzV3+1diJQYkP6YaTTuWSSzY3VuScaX6ZgiuD9H+6ERjpHipdI6SuIV9ogY7gjbRbRaHbTVeMi85nuwNvAwdRMlTKsACIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771588627; c=relaxed/simple;
	bh=wPn94aNFuQtf5GjTIoanu6qrzEgiYA0QRcQ0gBQnMbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J62GuYKng1HkV3XWgcddwoeJkSnZnOwGhbmqlVLdE3FaJ6UNSJ/GCq0DqDioIDP3UlsKfD/WJQYf3Y8yju+b9pGVb3BHNATBvGlsQ4/Hs11/Uwz+FRxxNdEhoXFzvg4m+/JCmRwNBinhkEe9CM3QoBchyBmeG3Rw74ZTVIP8ug8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QLygrL0T; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=ls/en7Qw; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771588625;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pemrUBU8/rbjL9/zoZ7MkscMiByl7zJxATlK5nEq+x0=;
	b=QLygrL0TLerEzkxui2QbWtXytAqrfG5undZnHEoD1njQdRnrmwPB1/wEmQRFpdglcG7XnZ
	FSbxdJ4gycRf3m5ufDu4rMN8q1GV16WFUSgMU1dnhbr5s/++tnY2BZ56hgWXatF/a8S7GI
	5Iw5XFVnWs+W9BYQMpw6N6wFMadzbgQ=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-120-f9re8nKYPWW5L3uWHG-gFg-1; Fri, 20 Feb 2026 06:57:04 -0500
X-MC-Unique: f9re8nKYPWW5L3uWHG-gFg-1
X-Mimecast-MFC-AGG-ID: f9re8nKYPWW5L3uWHG-gFg_1771588623
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-48379489438so22734595e9.2
        for <kvm@vger.kernel.org>; Fri, 20 Feb 2026 03:57:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1771588623; x=1772193423; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pemrUBU8/rbjL9/zoZ7MkscMiByl7zJxATlK5nEq+x0=;
        b=ls/en7QwWN2aHNTQnNKLvdzfEXzLd1+XOvz6Sj6gem8f7uc32jjDD5kH0hZsRvxouE
         Fr/POMVTluTR2tlmTJcc1bvOP8ufEsCmpaVssQSHjnaLpXWk/S3zEsE4toGeIVVo8RlO
         Ipij84QUA5nkUI0KUdDbxEisFtGSRjuK+O5BqaVcLw5ZpzaeVjTghLzzoqb7KbajEuBL
         MY9VegrhI5uKvNXVTZ/Eb4rtLJ4GFm2NjVWglC12T3IpVuKpFMy9J8SFlasZRA84cm5R
         H1JaCFjcBUj2eB2lQvZTR/bjCs9WUuaTaqUOC8stu5lcZ/fcEYuIbrDy8SjrLS0MC/1I
         gdaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771588623; x=1772193423;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pemrUBU8/rbjL9/zoZ7MkscMiByl7zJxATlK5nEq+x0=;
        b=pAT6if4ThhpDdEA+mFXofgyYimkG06DqFfAxH/S2sbOASQ4RFjmTKeQZLDdEAb0rRf
         JJFvShtWuitVBLE1DFKT7grX6JKCPHjxEIeOFntwxsrtugzIE1cACpnLLdUsOyU1oVOD
         gYSvtYW6Rppk20xS856uef9pr8QorKZ43TXlr8odCmMxG1hN75tM/5lWkxpuwb9+yub2
         BYR0cjbEO/gBkMbxsa5U2miy8RFTM5rAjki7ln9vsdaAX/j1iH5pvyMzgbVFu5D9n8Td
         rspHnlN/3USELMn6xBI1aK76ypDyWYmiAPdKNIDw5vExH0ZzVI8eW4Myf3p11ERBc2iv
         hk2g==
X-Forwarded-Encrypted: i=1; AJvYcCW6TLx7iUVJCREv1IbYVzU6dyyoSsnpK5Amql0OYxjtW0D++mHMU3xgrDAlOP1gb1TMU5E=@vger.kernel.org
X-Gm-Message-State: AOJu0YyaeATuddn5/CYX+dNni2BYSCU8jZCbw9iXAMkqUNgET41Qosqv
	CUpRbPyZeD8xEwcetK0mrQ2HEE5EGag8aQT9/VGlYwqffmxSbDJGUpvLPn++DtGAIV6D6t04D1a
	vyef4AIs0DMux8yk0N71ZBqVpsTkF3+KorX5J4x9XJEglIYHVpxi/UCIr7Yy8Rg==
X-Gm-Gg: AZuq6aKhsixoGDsCiykO8nUq4YE6P+z1ONqp1BGmeIt5bhIV15XgUJW6x++hu+iCgmq
	PMpKkAWUS+AbayGlHvBQ/8QJIGfXswaRTetLHrjrHo2ss5H5OvgibV2bOufbNzLiGquWO0XRz5p
	tODCePtHCi3JQDeMLWACM6VV2aaiXdQDub26XSKPuro4CvsgLn5tf7EEENIM7UZTrFOR0W/FCbv
	AD6rdBX/na4IWvUi0noQ6+Nhai+9e5bijkCHvpNzHB++9xMUMS7obStt48b7g1Y56RQIaXH1Mj2
	8nrkwfZznVK+sqjugnhzaB+nylBbo0L18XrJ63CUahd2l/iM6RBTakcbXoaDE2O/pLLhpo5oW/S
	15fxCsit245rW/Uxe0hxQWwSG9/Y3W56yX3vQ8NzXkmQcpNSQ6137T6gOLqo0ipM1GBnU3Zv/zG
	yI5MYDNkIG
X-Received: by 2002:a05:600c:a087:b0:483:71f7:2794 with SMTP id 5b1f17b1804b1-48398a54b94mr145228635e9.15.1771588622594;
        Fri, 20 Feb 2026 03:57:02 -0800 (PST)
X-Received: by 2002:a05:600c:a087:b0:483:71f7:2794 with SMTP id 5b1f17b1804b1-48398a54b94mr145228175e9.15.1771588622099;
        Fri, 20 Feb 2026 03:57:02 -0800 (PST)
Received: from rh.fritz.box (p200300f6af2d8700b4c2d356c3fafe63.dip0.t-ipconnect.de. [2003:f6:af2d:8700:b4c2:d356:c3fa:fe63])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483a316c2aasm66102295e9.0.2026.02.20.03.57.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Feb 2026 03:57:01 -0800 (PST)
From: Sebastian Ott <sebott@redhat.com>
To: peter.maydell@linaro.org,
	qemu-devel@nongnu.org
Cc: eric.auger@redhat.com,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	pbonzini@redhat.com,
	qemu-arm@nongnu.org,
	Sebastian Ott <sebott@redhat.com>
Subject: [PATCH v6 1/1] target/arm/kvm: add kvm-psci-version vcpu property
Date: Fri, 20 Feb 2026 12:56:56 +0100
Message-ID: <20260220115656.4831-2-sebott@redhat.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260220115656.4831-1-sebott@redhat.com>
References: <20260220115656.4831-1-sebott@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[redhat.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71406-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[sebott@redhat.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_COUNT_FIVE(0.00)[6];
	RCPT_COUNT_SEVEN(0.00)[8];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 33B1F167615
X-Rspamd-Action: no action

Provide a kvm specific vcpu property to override the default
(as of kernel v6.13 that would be PSCI v1.3) PSCI version emulated
by kvm. Current valid values are: 0.1, 0.2, 1.0, 1.1, 1.2, and 1.3

Note: in order to support PSCI v0.1 we need to drop vcpu
initialization with KVM_CAP_ARM_PSCI_0_2 in that case.

Reviewed-by: Eric Auger <eric.auger@redhat.com>
Tested-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Sebastian Ott <sebott@redhat.com>
---
 docs/system/arm/cpu-features.rst | 11 ++++++++
 target/arm/cpu.c                 |  8 +++++-
 target/arm/kvm.c                 | 48 ++++++++++++++++++++++++++++++--
 3 files changed, 64 insertions(+), 3 deletions(-)

diff --git a/docs/system/arm/cpu-features.rst b/docs/system/arm/cpu-features.rst
index 3db1f19401..ce19ae6a04 100644
--- a/docs/system/arm/cpu-features.rst
+++ b/docs/system/arm/cpu-features.rst
@@ -204,6 +204,17 @@ the list of KVM VCPU features and their descriptions.
   the guest scheduler behavior and/or be exposed to the guest
   userspace.
 
+``kvm-psci-version``
+  Set the Power State Coordination Interface (PSCI) firmware ABI version
+  that KVM provides to the guest. By default KVM will use the newest
+  version that it knows about (which is PSCI v1.3 in Linux v6.13).
+
+  You only need to set this if you want to be able to migrate this
+  VM to a host machine running an older kernel that does not
+  recognize the PSCI version that this host's kernel defaults to.
+
+  Current valid values are: 0.1, 0.2, 1.0, 1.1, 1.2, and 1.3.
+
 TCG VCPU Features
 =================
 
diff --git a/target/arm/cpu.c b/target/arm/cpu.c
index 10f8280eef..60f391651d 100644
--- a/target/arm/cpu.c
+++ b/target/arm/cpu.c
@@ -1144,7 +1144,13 @@ static void arm_cpu_initfn(Object *obj)
      * picky DTB consumer will also provide a helpful error message.
      */
     cpu->dtb_compatible = "qemu,unknown";
-    cpu->psci_version = QEMU_PSCI_VERSION_0_1; /* By default assume PSCI v0.1 */
+    if (!kvm_enabled()) {
+        /* By default KVM will use the newest PSCI version that it knows about.
+         * This can be changed using the kvm-psci-version property.
+         * For others assume PSCI v0.1 by default.
+         */
+        cpu->psci_version = QEMU_PSCI_VERSION_0_1;
+    }
     cpu->kvm_target = QEMU_KVM_ARM_TARGET_NONE;
 
     if (tcg_enabled() || hvf_enabled()) {
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index ded582e0da..5453460965 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -485,6 +485,28 @@ static void kvm_steal_time_set(Object *obj, bool value, Error **errp)
     ARM_CPU(obj)->kvm_steal_time = value ? ON_OFF_AUTO_ON : ON_OFF_AUTO_OFF;
 }
 
+static char *kvm_get_psci_version(Object *obj, Error **errp)
+{
+    ARMCPU *cpu = ARM_CPU(obj);
+
+    return g_strdup_printf("%d.%d",
+                           (int) PSCI_VERSION_MAJOR(cpu->psci_version),
+                           (int) PSCI_VERSION_MINOR(cpu->psci_version));
+}
+
+static void kvm_set_psci_version(Object *obj, const char *value, Error **errp)
+{
+    ARMCPU *cpu = ARM_CPU(obj);
+    uint16_t maj, min;
+
+    if (sscanf(value, "%hd.%hd", &maj, &min) != 2) {
+        error_setg(errp, "Invalid PSCI version.");
+        return;
+    }
+
+    cpu->psci_version = PSCI_VERSION(maj, min);
+}
+
 /* KVM VCPU properties should be prefixed with "kvm-". */
 void kvm_arm_add_vcpu_properties(ARMCPU *cpu)
 {
@@ -506,6 +528,12 @@ void kvm_arm_add_vcpu_properties(ARMCPU *cpu)
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
@@ -1976,8 +2004,12 @@ int kvm_arch_init_vcpu(CPUState *cs)
     if (cs->start_powered_off) {
         cpu->kvm_init_features[0] |= 1 << KVM_ARM_VCPU_POWER_OFF;
     }
-    if (kvm_check_extension(cs->kvm_state, KVM_CAP_ARM_PSCI_0_2)) {
-        cpu->psci_version = QEMU_PSCI_VERSION_0_2;
+    if (cpu->psci_version != QEMU_PSCI_VERSION_0_1 &&
+        kvm_check_extension(cs->kvm_state, KVM_CAP_ARM_PSCI_0_2)) {
+        /*
+         * Versions >= v0.2 are backward compatible with v0.2
+         * omit the feature flag for v0.1 .
+         */
         cpu->kvm_init_features[0] |= 1 << KVM_ARM_VCPU_PSCI_0_2;
     }
     if (!arm_feature(env, ARM_FEATURE_AARCH64)) {
@@ -2015,6 +2047,18 @@ int kvm_arch_init_vcpu(CPUState *cs)
         }
     }
 
+    if (cpu->psci_version) {
+        psciver = cpu->psci_version;
+        ret = kvm_set_one_reg(cs, KVM_REG_ARM_PSCI_VERSION, &psciver);
+        if (ret) {
+            error_report("KVM in this kernel does not support PSCI version %d.%d",
+                         (int) PSCI_VERSION_MAJOR(psciver),
+                         (int) PSCI_VERSION_MINOR(psciver));
+            error_printf("Consider setting the kvm-psci-version property on the "
+                         "migration source.\n");
+            return ret;
+        }
+    }
     /*
      * KVM reports the exact PSCI version it is implementing via a
      * special sysreg. If it is present, use its contents to determine
-- 
2.52.0


