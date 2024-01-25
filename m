Return-Path: <kvm+bounces-6922-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DD1483B7E7
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 04:30:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F22561F24E21
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 03:30:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B158012B8B;
	Thu, 25 Jan 2024 03:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FCgS4iMf"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45062125CE
	for <kvm@vger.kernel.org>; Thu, 25 Jan 2024 03:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706153312; cv=none; b=tSWuZwTWhkH+5jTSZiBcwJASv/Hu3QVsWddto+ufJeTl2C637W57tNlA0S3AJXSeoJWSm5l37Eau7E0Ma93pQBcpG6Cy0yfJ1c4iDLXnAWDA8OElpXvzBqo+xDa/GeSrqHUKTHf9akC6+NIe5b+aCwkSrhAczgiBpZ7t+AbupQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706153312; c=relaxed/simple;
	bh=JfGUcuOqvX1gvpeBZDSWHAWcHnEaLXwhlY5j9qFdGlg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Vx4ceq/5Sz2KNFIefOaZdm4sSgHmBqpF4swufQvbEGGUddVSbiGiRqAye6cbrBXXummRGlKsiyCb1LYJ2kII+8YIvX9WWz5X0NYxot3tq0ihoeCLSi0IlTUdMyicDpwozYNOepY4QYhp56pXiFbEgrKOlQ1XIY5gDBuGp5ZbRqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FCgS4iMf; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706153311; x=1737689311;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JfGUcuOqvX1gvpeBZDSWHAWcHnEaLXwhlY5j9qFdGlg=;
  b=FCgS4iMfP1pAq+UH7E0LIB7PmbUHiecgJnEJ26tWAM3WRLcbv5/zRtgU
   QmrFuu/ObpALN5ONFV7hN4YrRHmVbq++WgmhZ7K2IARyxwfAv8fHUfjd+
   nnuCK1iEYf3CM1JJ6GKf+5ggbhNLibS4CjslaTV8JnISjU49wCUNMWNfD
   RQHCu6lTAZ+AkFYBA56zltQtrKu93/wVderp/1zWu5N6e5dAtb/GERyGd
   1KO3W/zZJZSDc25QKbBkty0GoFBkqQ5TOPYXG8RFjHUMkX2EfZAKdX3op
   N5qKd5Eqsgi217trsG1/Wh85eRcY81agEsimEjKjUk2UeVI3ckJCImyGM
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10962"; a="9428611"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="9428611"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2024 19:25:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="2085502"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa005.jf.intel.com with ESMTP; 24 Jan 2024 19:25:28 -0800
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Peter Xu <peterx@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Cornelia Huck <cohuck@redhat.com>,
	=?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	xiaoyao.li@intel.com,
	Michael Roth <michael.roth@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Claudio Fontana <cfontana@suse.de>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Isaku Yamahata <isaku.yamahata@gmail.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>
Subject: [PATCH v4 21/66] i386/tdx: Integrate tdx_caps->attrs_fixed0/1 to tdx_cpuid_lookup
Date: Wed, 24 Jan 2024 22:22:43 -0500
Message-Id: <20240125032328.2522472-22-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240125032328.2522472-1-xiaoyao.li@intel.com>
References: <20240125032328.2522472-1-xiaoyao.li@intel.com>
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
index 160ba8c940a2..39b07f8e1204 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -1442,15 +1442,6 @@ FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
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
index 23d187d7cc5f..2091451a140e 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -876,6 +876,8 @@ uint64_t x86_cpu_get_supported_feature_word(FeatureWord w,
 #define CPUID_7_0_ECX_MAWAU             (31U << 17)
 /* Read Processor ID */
 #define CPUID_7_0_ECX_RDPID             (1U << 22)
+/* KeyLocker */
+#define CPUID_7_0_ECX_KeyLocker         (1U << 23)
 /* Bus Lock Debug Exception */
 #define CPUID_7_0_ECX_BUS_LOCK_DETECT   (1U << 24)
 /* Cache Line Demote Instruction */
diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 4c8455783e36..6caefb27d90a 100644
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


