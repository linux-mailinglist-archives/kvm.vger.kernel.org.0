Return-Path: <kvm+bounces-10377-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A61CE86C0EF
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 07:41:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 02383B265EF
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 06:41:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECCC0481A6;
	Thu, 29 Feb 2024 06:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lM7yOHIX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 890AE47794
	for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 06:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709188794; cv=none; b=adFFW6EqPJZ63gsb9ArHZ0C7XR+/w3u+CvVTE+TvSmbzUuaXz6G2wTah3nrOu6ykPO6iPqs6p7DmeVKpN/QGOYD/gJvUa2ddfdJOuVo5tzPF445uwXHtq4mo4lBtRRaf2GG/04vf1g7SdJI2hzAz1VOctQb0Wz6yCLj1QXAa+LY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709188794; c=relaxed/simple;
	bh=+2F7PMaCKwouGjmd/8igs1t8zsy94ivwrfJ9vmQH7+Y=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YxYMK+/K4cxA+1hhRSW4n58xxOOK0ZXSBarvAjEh0WmywOAdKAB02yXfhfinXRGpvwekdTE9qPJQL+HHxyXnv8D/Czh9BLgGYBCRr2Vr+ZeBB+gNWbUOsBQMjwzxzeqWTqCAe2goOETZ2feNtYydANzVL5fvF0nxVP4jDyHGDwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lM7yOHIX; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709188792; x=1740724792;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+2F7PMaCKwouGjmd/8igs1t8zsy94ivwrfJ9vmQH7+Y=;
  b=lM7yOHIXsxSuRZjvIO6BETMeQGAlz8Zy+gx640gjbd//NoWAHj1k2UpK
   RcV5C3wIxDaI0/PZEZMMIL0xHlfWb8ivpgIZqK14uxhpVY7QDWLfv/hmT
   OS08Bls9FGo3CtsUpD9XvIbcxgtUaapiJ5GzeJDypY5ysxg0qadO7pA+m
   Jum1Fq7zKZeE1KKX6XLIwn5qVDekThZMSsutTi+WN36uarx9OoV/nQoGw
   Z9rsHYrTss+jeFMICYKwRrCwnzXw0T82uEY5ExZgdeQjU+nXLfzPqZmQa
   GkSXdujVLDbC3UBLKXhwxj+wUvp2kWW59DG6GLfCYByOr0OXP4GJ/8Nvk
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10998"; a="3802678"
X-IronPort-AV: E=Sophos;i="6.06,192,1705392000"; 
   d="scan'208";a="3802678"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2024 22:39:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,192,1705392000"; 
   d="scan'208";a="8075403"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa007.jf.intel.com with ESMTP; 28 Feb 2024 22:39:46 -0800
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Ani Sinha <anisinha@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Cornelia Huck <cohuck@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: kvm@vger.kernel.org,
	qemu-devel@nongnu.org,
	Michael Roth <michael.roth@amd.com>,
	Claudio Fontana <cfontana@suse.de>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Isaku Yamahata <isaku.yamahata@gmail.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>,
	xiaoyao.li@intel.com
Subject: [PATCH v5 21/65] i386/tdx: Integrate tdx_caps->attrs_fixed0/1 to tdx_cpuid_lookup
Date: Thu, 29 Feb 2024 01:36:42 -0500
Message-Id: <20240229063726.610065-22-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240229063726.610065-1-xiaoyao.li@intel.com>
References: <20240229063726.610065-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Some bits in TD attributes have corresponding CPUID feature bits. Reflect
the fixed0/1 restriction on TD attributes to their corresponding CPUID
bits in tdx_cpuid_lookup[] as well.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
Changes in v4:
 - reverse the meaning of tdx_caps->attr_fixed0, because value 0 of bit
   means the bit must be fixed 0.
---
 target/i386/cpu-internal.h |  9 +++++++++
 target/i386/cpu.c          |  9 ---------
 target/i386/cpu.h          |  2 ++
 target/i386/kvm/tdx.c      | 21 +++++++++++++++++++++
 4 files changed, 32 insertions(+), 9 deletions(-)

diff --git a/target/i386/cpu-internal.h b/target/i386/cpu-internal.h
index 9baac5c0b450..e980f6e3147f 100644
--- a/target/i386/cpu-internal.h
+++ b/target/i386/cpu-internal.h
@@ -20,6 +20,15 @@
 #ifndef I386_CPU_INTERNAL_H
 #define I386_CPU_INTERNAL_H
 
+typedef struct FeatureMask {
+    FeatureWord index;
+    uint64_t mask;
+} FeatureMask;
+
+typedef struct FeatureDep {
+    FeatureMask from, to;
+} FeatureDep;
+
 typedef enum FeatureWordType {
    CPUID_FEATURE_WORD,
    MSR_FEATURE_WORD,
diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index b5f0c1080c34..78a3f55a856f 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -1443,15 +1443,6 @@ FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
     },
 };
 
-typedef struct FeatureMask {
-    FeatureWord index;
-    uint64_t mask;
-} FeatureMask;
-
-typedef struct FeatureDep {
-    FeatureMask from, to;
-} FeatureDep;
-
 static FeatureDep feature_dependencies[] = {
     {
         .from = { FEAT_7_0_EDX,             CPUID_7_0_EDX_ARCH_CAPABILITIES },
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 782aba921bd5..f86afbdfca96 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -883,6 +883,8 @@ uint64_t x86_cpu_get_supported_feature_word(FeatureWord w,
 #define CPUID_7_0_ECX_MAWAU             (31U << 17)
 /* Read Processor ID */
 #define CPUID_7_0_ECX_RDPID             (1U << 22)
+/* KeyLocker */
+#define CPUID_7_0_ECX_KeyLocker         (1U << 23)
 /* Bus Lock Debug Exception */
 #define CPUID_7_0_ECX_BUS_LOCK_DETECT   (1U << 24)
 /* Cache Line Demote Instruction */
diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 24475e6b312e..144acd8c9912 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -32,6 +32,13 @@
                                      (1U << KVM_FEATURE_PV_SCHED_YIELD) | \
                                      (1U << KVM_FEATURE_MSI_EXT_DEST_ID))
 
+#define TDX_ATTRIBUTES_MAX_BITS      64
+
+static FeatureMask tdx_attrs_ctrl_fields[TDX_ATTRIBUTES_MAX_BITS] = {
+    [30] = { .index = FEAT_7_0_ECX, .mask = CPUID_7_0_ECX_PKS },
+    [31] = { .index = FEAT_7_0_ECX, .mask = CPUID_7_0_ECX_KeyLocker},
+};
+
 typedef struct KvmTdxCpuidLookup {
     uint32_t tdx_fixed0;
     uint32_t tdx_fixed1;
@@ -383,6 +390,8 @@ static void update_tdx_cpuid_lookup_by_tdx_caps(void)
     FeatureWordInfo *fi;
     uint32_t config;
     FeatureWord w;
+    FeatureMask *fm;
+    int i;
 
     for (w = 0; w < FEATURE_WORDS; w++) {
         fi = &feature_word_info[w];
@@ -408,6 +417,18 @@ static void update_tdx_cpuid_lookup_by_tdx_caps(void)
         entry->tdx_fixed1 &= ~config;
     }
 
+    for (i = 0; i < ARRAY_SIZE(tdx_attrs_ctrl_fields); i++) {
+        fm = &tdx_attrs_ctrl_fields[i];
+
+        if (~(tdx_caps->attrs_fixed0 & (1ULL << i))) {
+            tdx_cpuid_lookup[fm->index].tdx_fixed0 |= fm->mask;
+        }
+
+        if (tdx_caps->attrs_fixed1 & (1ULL << i)) {
+            tdx_cpuid_lookup[fm->index].tdx_fixed1 |= fm->mask;
+        }
+    }
+
     /*
      * Because KVM gets XFAM settings via CPUID leaves 0xD,  map
      * tdx_caps->xfam_fixed{0, 1} into tdx_cpuid_lookup[].tdx_fixed{0, 1}.
-- 
2.34.1


