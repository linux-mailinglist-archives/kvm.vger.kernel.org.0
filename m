Return-Path: <kvm+bounces-30680-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C5429BC5B2
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 07:40:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A0D6E1C20FC5
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 06:40:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 198B21FDF85;
	Tue,  5 Nov 2024 06:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QmeqQ16D"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B09D41FE0FF
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 06:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730788781; cv=none; b=GaWrqkdX0BE3BTuJHrWLh3f6xQccSjjkHkWDw1kcXWh+B7qqBkOD8gnaiQw0r6HCYOrxO9OvfGbRMUZ0AWFf5aX97lwwDtEyZQ1Q/XGQjXH73Bk+DivogEXRwhF5zD0uLwlWh5uvYsj6TQMBGaMDC5XiIe4NYUmggmpbEn60ZoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730788781; c=relaxed/simple;
	bh=8SBCXjeKuMoMULo/dUKnjmMZB22IpUgmloGXn6p/MT4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=f8/QRpRkStDDtv/LLM3vjbpL2N7Y5ssVErryjBAPrSfGACDfkfGbWgA+O6ZL8PCHCsfjAvZA/UXUF4LrnQ1YISEHTwNnYWRmJotaTP7IwCxZ+K/NPVye8Ns3uVkWq8UZf6UL8QuHvMXFxQIe3LoUlN1L025T+UwWClAjH1t76Kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QmeqQ16D; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730788780; x=1762324780;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8SBCXjeKuMoMULo/dUKnjmMZB22IpUgmloGXn6p/MT4=;
  b=QmeqQ16D98QuB6m+bSJbDiLkFGdm9br9UPGseGxd1rkYmp9WXYEpqZPD
   SvCWG3WF/Yz1lrtkaA1ptV/Y8YDbk0udvleEe86ESLF2wWcxgtrFZZs0U
   ovD5NAxnu9dmd3fDcvwNJl96HHsmSF5ACpzCps+YfeYSZvL80ZCAYVnJu
   I/gS8Y4CncD9ReTKaRx87P4UlhoDBsPTWm+5f/9MYWdh8rP5xLvRZovkG
   8RxZ3YbAM9uMZAGtGogzAClLJXxqK95QnQGNdWQ7wuh7Hrin3zKvWVAzc
   5RDL4PX6MhqCORYU3rYXpwARO5Z6zh6sWThH/+y2O2Vpe0sdrP37CnACo
   g==;
X-CSE-ConnectionGUID: Mx+h9YCxRQyubkqe1Xs9+Q==
X-CSE-MsgGUID: sjl1WRpwTiO1Kg+hDAU4CQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="30689823"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="30689823"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 22:39:40 -0800
X-CSE-ConnectionGUID: 02jwTyEjT4W7WgQAzjU8Tg==
X-CSE-MsgGUID: bd629gL+QAag3jRWFrdaqw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,259,1725346800"; 
   d="scan'208";a="83989718"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmviesa009.fm.intel.com with ESMTP; 04 Nov 2024 22:39:35 -0800
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Riku Voipio <riku.voipio@iki.fi>,
	Richard Henderson <richard.henderson@linaro.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Ani Sinha <anisinha@redhat.com>
Cc: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	Cornelia Huck <cohuck@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	rick.p.edgecombe@intel.com,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org,
	xiaoyao.li@intel.com
Subject: [PATCH v6 46/60] i386/cgs: Rename *mask_cpuid_features() to *adjust_cpuid_features()
Date: Tue,  5 Nov 2024 01:23:54 -0500
Message-Id: <20241105062408.3533704-47-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241105062408.3533704-1-xiaoyao.li@intel.com>
References: <20241105062408.3533704-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Because for TDX case, there are also fixed-1 bits that enfored by TDX
module.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 target/i386/confidential-guest.h | 20 ++++++++++----------
 target/i386/kvm/kvm.c            |  2 +-
 target/i386/sev.c                |  4 ++--
 3 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/target/i386/confidential-guest.h b/target/i386/confidential-guest.h
index 4b7ea91023dc..2dde29889c23 100644
--- a/target/i386/confidential-guest.h
+++ b/target/i386/confidential-guest.h
@@ -41,8 +41,8 @@ struct X86ConfidentialGuestClass {
     int (*kvm_type)(X86ConfidentialGuest *cg);
     void (*cpu_instance_init)(X86ConfidentialGuest *cg, CPUState *cpu);
     void (*cpu_realizefn)(X86ConfidentialGuest *cg, CPUState *cpu, Error **errp);
-    uint32_t (*mask_cpuid_features)(X86ConfidentialGuest *cg, uint32_t feature, uint32_t index,
-                                    int reg, uint32_t value);
+    uint32_t (*adjust_cpuid_features)(X86ConfidentialGuest *cg, uint32_t feature,
+                                      uint32_t index, int reg, uint32_t value);
 };
 
 /**
@@ -83,21 +83,21 @@ static inline void x86_confidenetial_guest_cpu_realizefn(X86ConfidentialGuest *c
 }
 
 /**
- * x86_confidential_guest_mask_cpuid_features:
+ * x86_confidential_guest_adjust_cpuid_features:
  *
- * Removes unsupported features from a confidential guest's CPUID values, returns
- * the value with the bits removed.  The bits removed should be those that KVM
- * provides independent of host-supported CPUID features, but are not supported by
- * the confidential computing firmware.
+ * Adjust the supported features from a confidential guest's CPUID values,
+ * returns the adjusted value.  There are bits being removed that are not
+ * supported by the confidential computing firmware or bits being added that
+ * are forcibly exposed to guest by the confidential computing firmware.
  */
-static inline int x86_confidential_guest_mask_cpuid_features(X86ConfidentialGuest *cg,
+static inline int x86_confidential_guest_adjust_cpuid_features(X86ConfidentialGuest *cg,
                                                              uint32_t feature, uint32_t index,
                                                              int reg, uint32_t value)
 {
     X86ConfidentialGuestClass *klass = X86_CONFIDENTIAL_GUEST_GET_CLASS(cg);
 
-    if (klass->mask_cpuid_features) {
-        return klass->mask_cpuid_features(cg, feature, index, reg, value);
+    if (klass->adjust_cpuid_features) {
+        return klass->adjust_cpuid_features(cg, feature, index, reg, value);
     } else {
         return value;
     }
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index e47aa32233e6..f067961fba43 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -576,7 +576,7 @@ uint32_t kvm_arch_get_supported_cpuid(KVMState *s, uint32_t function,
     }
 
     if (current_machine->cgs) {
-        ret = x86_confidential_guest_mask_cpuid_features(
+        ret = x86_confidential_guest_adjust_cpuid_features(
             X86_CONFIDENTIAL_GUEST(current_machine->cgs),
             function, index, reg, ret);
     }
diff --git a/target/i386/sev.c b/target/i386/sev.c
index 1a4eb1ada624..4e6582c6a666 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -946,7 +946,7 @@ out:
 }
 
 static uint32_t
-sev_snp_mask_cpuid_features(X86ConfidentialGuest *cg, uint32_t feature, uint32_t index,
+sev_snp_adjust_cpuid_features(X86ConfidentialGuest *cg, uint32_t feature, uint32_t index,
                             int reg, uint32_t value)
 {
     switch (feature) {
@@ -2404,7 +2404,7 @@ sev_snp_guest_class_init(ObjectClass *oc, void *data)
     klass->launch_finish = sev_snp_launch_finish;
     klass->launch_update_data = sev_snp_launch_update_data;
     klass->kvm_init = sev_snp_kvm_init;
-    x86_klass->mask_cpuid_features = sev_snp_mask_cpuid_features;
+    x86_klass->adjust_cpuid_features = sev_snp_adjust_cpuid_features;
     x86_klass->kvm_type = sev_snp_kvm_type;
 
     object_class_property_add(oc, "policy", "uint64",
-- 
2.34.1


