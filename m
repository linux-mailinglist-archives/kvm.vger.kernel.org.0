Return-Path: <kvm+bounces-52125-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id ED56AB0191D
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 12:01:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1AF801C21DC1
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 10:01:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4835927F01C;
	Fri, 11 Jul 2025 10:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RBFs4Bpi"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C037127EFED
	for <kvm@vger.kernel.org>; Fri, 11 Jul 2025 10:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752228059; cv=none; b=Tc27DvtCsEN6tu6Wq7EVgp2qdgZhbvBPx8wbea0zYN0jyaucZz0abv1IqpzONC+quic9bywWcYdFH67ufyeWj45kucjRWjuO6xRXMzX4FBMEGo+PM7xU1oMhGqMq4QBWgeRLAEtptqWCgS91W9JxHS9olCG5cbrIYxbmco141bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752228059; c=relaxed/simple;
	bh=whdrh4f2CvSh7ztiRXZ9xAUTYQf/ppVVjSzuT5hVdFw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=cY33J+zoGr847lLC+V7zC4YNmyJ7R8PK/QSa+ejUmDScBxDaI6S2Kl6I/5S3zBGDf1QQkedJH+PL4qJ7G8YlfyJ8YsjewlIykOaBH/BMgwf+zrg/ezu64zI2+qangNdC9AzBQKeGobHG4s9gBUDIx0cv/vOQTtB40dkzYiCSo+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RBFs4Bpi; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752228057; x=1783764057;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=whdrh4f2CvSh7ztiRXZ9xAUTYQf/ppVVjSzuT5hVdFw=;
  b=RBFs4BpiSrIH1G15zZ3VPDaI1IxL68kqRuRk3ylQWZhvN5U6NvbtLKrB
   KQire3gSvG1oFVyVO83KpjkwiqXtrSHZr9pknR5agpOV0M1JVXnX88++V
   Gw1A4EDAII501xL4Z3n8rp5qAViQbFTV0MVAE/v3tWjhRJvo9Kv6KNzt1
   PpliBHQyP/UK1WKkUxKxVjQsxWf5yXDynKeP9Kq0ByEjdpcmoZtZlreKN
   N73s71IB3SCdkdi1TXfuou1yWCdo84gxW1Vg8BLT0TCA8q4beTnbp9mAv
   tIWY29YWqXV65VjQMO9ZY+4ni0BvM/qwjkE8kR6/NxDF0HCmN1G0VJigm
   w==;
X-CSE-ConnectionGUID: XM1cqsuUQteoSBLbmLiNmQ==
X-CSE-MsgGUID: uA4GvAV+Q9aZIw4iAwvE1g==
X-IronPort-AV: E=McAfee;i="6800,10657,11490"; a="54496283"
X-IronPort-AV: E=Sophos;i="6.16,303,1744095600"; 
   d="scan'208";a="54496283"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2025 03:00:56 -0700
X-CSE-ConnectionGUID: QSkNiVqjRvm2Mkffpmntrg==
X-CSE-MsgGUID: aHq+KBnZS3yXnjLhhjM1EA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,303,1744095600"; 
   d="scan'208";a="160662056"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by orviesa003.jf.intel.com with ESMTP; 11 Jul 2025 03:00:51 -0700
From: Zhao Liu <zhao1.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	=?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eduardo Habkost <eduardo@habkost.net>
Cc: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Babu Moger <babu.moger@amd.com>,
	Ewan Hai <ewanhai-oc@zhaoxin.com>,
	Pu Wen <puwen@hygon.cn>,
	Tao Su <tao1.su@intel.com>,
	Yi Lai <yi1.lai@intel.com>,
	Dapeng Mi <dapeng1.mi@intel.com>,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH v2 07/18] i386/cpu: Add x-vendor-cpuid-only-v2 option for compatibility
Date: Fri, 11 Jul 2025 18:21:32 +0800
Message-Id: <20250711102143.1622339-8-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250711102143.1622339-1-zhao1.liu@intel.com>
References: <20250711102143.1622339-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a compat property "x-vendor-cpuid-only-v2" (for PC machine v10.0
and older) to keep the original behavior. This property will be used
to adjust vendor specific CPUID fields.

Make x-vendor-cpuid-only-v2 depend on x-vendor-cpuid-only. Although
x-vendor-cpuid-only and v2 should be initernal only, QEMU doesn't
support "internal" property. To avoid any other unexpected issues, check
the dependency.

Tested-by: Yi Lai <yi1.lai@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
Changes Since v1:
 * Split the x-vendor-cpuid-only-v2 support into a seperate pacth
   and make sure it depends on x-vendor-cpuid-only.
---
 hw/i386/pc.c      |  1 +
 target/i386/cpu.c | 10 ++++++++++
 target/i386/cpu.h | 11 ++++++++++-
 3 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/hw/i386/pc.c b/hw/i386/pc.c
index ad2d6495ebde..9ec3f4db31f3 100644
--- a/hw/i386/pc.c
+++ b/hw/i386/pc.c
@@ -83,6 +83,7 @@
 
 GlobalProperty pc_compat_10_0[] = {
     { TYPE_X86_CPU, "x-consistent-cache", "false" },
+    { TYPE_X86_CPU, "x-vendor-cpuid-only-v2", "false" },
 };
 const size_t pc_compat_10_0_len = G_N_ELEMENTS(pc_compat_10_0);
 
diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index af67f12e939d..b6d41aa110a2 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -8749,6 +8749,16 @@ static void x86_cpu_realizefn(DeviceState *dev, Error **errp)
     tcg_cflags_set(cs, CF_PCREL);
 #endif
 
+    /*
+     * x-vendor-cpuid-only and v2 should be initernal only. But
+     * QEMU doesn't support "internal" property.
+     */
+    if (!cpu->vendor_cpuid_only && cpu->vendor_cpuid_only_v2) {
+        error_setg(errp, "x-vendor-cpuid-only-v2 property "
+                   "depends on x-vendor-cpuid-only");
+        return;
+    }
+
     if (cpu->apic_id == UNASSIGNED_APIC_ID) {
         error_setg(errp, "apic-id property was not initialized properly");
         return;
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 9adba8fdf773..03a7b735d090 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -2282,9 +2282,18 @@ struct ArchCPU {
     /* Enable auto level-increase for all CPUID leaves */
     bool full_cpuid_auto_level;
 
-    /* Only advertise CPUID leaves defined by the vendor */
+    /*
+     * Compatibility bits for old machine types (PC machine v6.0 and older).
+     * Only advertise CPUID leaves defined by the vendor.
+     */
     bool vendor_cpuid_only;
 
+    /*
+     * Compatibility bits for old machine types (PC machine v10.0 and older).
+     * Only advertise CPUID leaves defined by the vendor.
+     */
+    bool vendor_cpuid_only_v2;
+
     /* Only advertise TOPOEXT features that AMD defines */
     bool amd_topoext_features_only;
 
-- 
2.34.1


