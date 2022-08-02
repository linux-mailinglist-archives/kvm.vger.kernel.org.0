Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16D5C587841
	for <lists+kvm@lfdr.de>; Tue,  2 Aug 2022 09:49:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236225AbiHBHtM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Aug 2022 03:49:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236221AbiHBHsw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Aug 2022 03:48:52 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA3264D16F
        for <kvm@vger.kernel.org>; Tue,  2 Aug 2022 00:48:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659426522; x=1690962522;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wIrbt0K0dZjL5+1k1Whs2xRyo3TLN6tC8REasyeLtk0=;
  b=mNdU4InOrlErVNl2NWPkOKEgFj7T6WdavpHpy0BNk9PE119ldxr3Fre9
   mWmsXMYQzQHFUEuIn2rVEpxXSIf9K8pxgmbJM3fi4Z+ljWeou/DIGuJsx
   7/w5+vfuWaD7SikR5BiTt37If9hK8hblxbPxuTLL/eMQ6j8+uIIFL4TCK
   z4z68vCq+3m/US2qI1s5PuAD50wCp/FgMMg/T6WzifgaI40vqxsoEhR8p
   CGlsgPLAySO5v8wjFDEY7MzgJmHvKgIWMV3O44BFSCieH+LJxNKJKlr2t
   +YrJvRZEKrZRHk2Ez8kE7hWRzvIvIakP6wqrKONQJ+ljaHYCwmzarBSBG
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10426"; a="286908532"
X-IronPort-AV: E=Sophos;i="5.93,210,1654585200"; 
   d="scan'208";a="286908532"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Aug 2022 00:48:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,210,1654585200"; 
   d="scan'208";a="630603942"
Received: from lxy-dell.sh.intel.com ([10.239.48.38])
  by orsmga008.jf.intel.com with ESMTP; 02 Aug 2022 00:48:38 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Laszlo Ersek <lersek@redhat.com>,
        Eric Blake <eblake@redhat.com>
Cc:     Connor Kuehl <ckuehl@redhat.com>, erdemaktas@google.com,
        kvm@vger.kernel.org, qemu-devel@nongnu.org, seanjc@google.com,
        xiaoyao.li@intel.com
Subject: [PATCH v1 11/40] i386/tdx: Integrate tdx_caps->attrs_fixed0/1 to tdx_cpuid_lookup
Date:   Tue,  2 Aug 2022 15:47:21 +0800
Message-Id: <20220802074750.2581308-12-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220802074750.2581308-1-xiaoyao.li@intel.com>
References: <20220802074750.2581308-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Some bits in TD attributes have corresponding CPUID feature bits. Reflect
the fixed0/1 restriction on TD attributes to their corresponding CPUID
bits in tdx_cpuid_lookup[] as well.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
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
index 45652bb2fd7c..e5c1ffcb138a 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -1289,15 +1289,6 @@ FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
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
index 90f403aecd8b..8f4de62b02e9 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -867,6 +867,8 @@ uint64_t x86_cpu_get_supported_feature_word(FeatureWord w,
 #define CPUID_7_0_ECX_MAWAU             (31U << 17)
 /* Read Processor ID */
 #define CPUID_7_0_ECX_RDPID             (1U << 22)
+/* KeyLocker */
+#define CPUID_7_0_ECX_KeyLocker         (1U << 23)
 /* Bus Lock Debug Exception */
 #define CPUID_7_0_ECX_BUS_LOCK_DETECT   (1U << 24)
 /* Cache Line Demote Instruction */
diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index dffaa533f899..6fe47cf4e29e 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -30,6 +30,13 @@
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
@@ -375,6 +382,8 @@ static void update_tdx_cpuid_lookup_by_tdx_caps(void)
     FeatureWordInfo *fi;
     uint32_t config;
     FeatureWord w;
+    FeatureMask *fm;
+    int i;
 
     /*
      * Patch tdx_fixed0/1 by tdx_caps that what TDX module reports as
@@ -396,6 +405,18 @@ static void update_tdx_cpuid_lookup_by_tdx_caps(void)
         entry->tdx_fixed1 &= ~config;
     }
 
+    for (i = 0; i < ARRAY_SIZE(tdx_attrs_ctrl_fields); i++) {
+        fm = &tdx_attrs_ctrl_fields[i];
+
+        if (tdx_caps->attrs_fixed0 & (1ULL << i)) {
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
2.27.0

