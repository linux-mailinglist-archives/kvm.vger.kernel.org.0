Return-Path: <kvm+bounces-45947-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D66E8AAFEB8
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 17:14:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B1981A0179A
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 15:12:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BF8627B4FD;
	Thu,  8 May 2025 15:07:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jZM2enBv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21D71276054
	for <kvm@vger.kernel.org>; Thu,  8 May 2025 15:07:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746716832; cv=none; b=BQQbcNOPhi/YPEYej3WlbWz/RdinmQ0wb4VTZVb0KZ7+wPMgXdBb8bo9Ho1KOdYcHMq2tQBW4U2tjKhEHgCogJguplg370GzRpZ11eQ7YGRbmiMbG9CtTtmhE15zXf+l1xtsDQFjqvj3dsh54JdsDbUArQyUg8UD1X+F9gpObkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746716832; c=relaxed/simple;
	bh=ZIFglDB4yB53JZP871G7sJZRYLRIpiHXXyf1wDSdrU0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s7j9Mh0bZUJ0+jwYQC07cKrUMkQIItJXjwmLoFUSrsMlrHlBNTLzGZu4rQO7EAsCqqplsjucBONdJLGtAEyb+KNncKrCrkfrvlUL96kZNMRFs0hnq2RNAQZWwUp07KGagyxV1lVxs7W/TX7P9gx5ziH03yOvA4PLwJ18NWjlNAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jZM2enBv; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746716831; x=1778252831;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZIFglDB4yB53JZP871G7sJZRYLRIpiHXXyf1wDSdrU0=;
  b=jZM2enBv+/39zzyaT4j36feEkgKUtXdann867mcReVYJn7XoGhHPB6RM
   t+BoipD7jdbIQvUDw0X011kulUs9eQg/jFHGhJ6Ww2TZvLaGGsOCE/7GG
   Oh+xGYaV9f/wqjiGCGOrLSUQ4zshlDPce+4p0hn4KayDijG0d1uW5RqIh
   G/v+EY12C9PrW9dws0gntFy9c8fOKsOI6dXaaF4mxoupEAN3XQoKQRsRy
   0v8or9U+Ri+5CyHNT6L4yjMoW9pTyTZ5HAVFtvYsAfBGZfQkiRqeSpAns
   bowakGmZCsNrtCvd86HUw+0dQD1hO+kVtNyxMPBAjAjAG2utLkacbQIyJ
   Q==;
X-CSE-ConnectionGUID: YIDGwBa+SXKNKURAV2+FJw==
X-CSE-MsgGUID: w6ScLg7mQ82p/2v8GwlhlQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="73888458"
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="73888458"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 08:07:11 -0700
X-CSE-ConnectionGUID: yeLjuSc8RMOoyMbW0m5y/w==
X-CSE-MsgGUID: k3g2HRJ0TgG9xbEkWwublQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="141440401"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa005.jf.intel.com with ESMTP; 08 May 2025 08:07:08 -0700
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Francesco Lavra <francescolavra.fl@gmail.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v9 44/55] i386/tdx: Implement adjust_cpuid_features() for TDX
Date: Thu,  8 May 2025 10:59:50 -0400
Message-ID: <20250508150002.689633-45-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250508150002.689633-1-xiaoyao.li@intel.com>
References: <20250508150002.689633-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Maintain a TDX specific supported CPUID set, and use it to mask the
common supported CPUID value of KVM. It can avoid newly added supported
features (reported via KVM_GET_SUPPORTED_CPUID) for common VMs being
falsely reported as supported for TDX.

As the first step, initialize the TDX supported CPUID set with all the
configurable CPUID bits. It's not complete because there are other CPUID
bits are supported for TDX but not reported as directly configurable.
E.g. the XFAM related bits, attribute related bits and fixed-1 bits.
They will be handled in the future.

Also, what matters are the CPUID bits related to QEMU's feature word.
Only mask the CPUID leafs which are feature word leaf.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
---
 target/i386/cpu.c          | 16 ++++++++++++++++
 target/i386/cpu.h          |  1 +
 target/i386/kvm/kvm.c      |  2 +-
 target/i386/kvm/kvm_i386.h |  1 +
 target/i386/kvm/tdx.c      | 34 ++++++++++++++++++++++++++++++++++
 5 files changed, 53 insertions(+), 1 deletion(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index a255f4d1b81f..f91502838023 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -1655,6 +1655,22 @@ FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
     },
 };
 
+bool is_feature_word_cpuid(uint32_t feature, uint32_t index, int reg)
+{
+    FeatureWordInfo *wi;
+    FeatureWord w;
+
+    for (w = 0; w < FEATURE_WORDS; w++) {
+        wi = &feature_word_info[w];
+        if (wi->type == CPUID_FEATURE_WORD && wi->cpuid.eax == feature &&
+            (!wi->cpuid.needs_ecx || wi->cpuid.ecx == index) &&
+            wi->cpuid.reg == reg) {
+            return true;
+        }
+    }
+    return false;
+}
+
 typedef struct FeatureMask {
     FeatureWord index;
     uint64_t mask;
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 3910b488f775..42ef77789ded 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -2515,6 +2515,7 @@ void cpu_set_apic_feature(CPUX86State *env);
 void host_cpuid(uint32_t function, uint32_t count,
                 uint32_t *eax, uint32_t *ebx, uint32_t *ecx, uint32_t *edx);
 bool cpu_has_x2apic_feature(CPUX86State *env);
+bool is_feature_word_cpuid(uint32_t feature, uint32_t index, int reg);
 
 static inline bool x86_has_cpuid_0x1f(X86CPU *cpu)
 {
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index fa46edaeac8d..17d7bf6ae9aa 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -393,7 +393,7 @@ static bool host_tsx_broken(void)
 
 /* Returns the value for a specific register on the cpuid entry
  */
-static uint32_t cpuid_entry_get_reg(struct kvm_cpuid_entry2 *entry, int reg)
+uint32_t cpuid_entry_get_reg(struct kvm_cpuid_entry2 *entry, int reg)
 {
     uint32_t ret = 0;
     switch (reg) {
diff --git a/target/i386/kvm/kvm_i386.h b/target/i386/kvm/kvm_i386.h
index dc696cb7238a..484a1de84d51 100644
--- a/target/i386/kvm/kvm_i386.h
+++ b/target/i386/kvm/kvm_i386.h
@@ -62,6 +62,7 @@ void kvm_update_msi_routes_all(void *private, bool global,
 struct kvm_cpuid_entry2 *cpuid_find_entry(struct kvm_cpuid2 *cpuid,
                                           uint32_t function,
                                           uint32_t index);
+uint32_t cpuid_entry_get_reg(struct kvm_cpuid_entry2 *entry, int reg);
 uint32_t kvm_x86_build_cpuid(CPUX86State *env, struct kvm_cpuid_entry2 *entries,
                              uint32_t cpuid_i);
 #endif /* CONFIG_KVM */
diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 0e1fd3e3ffa1..91c6295ddd17 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -45,6 +45,7 @@
 static TdxGuest *tdx_guest;
 
 static struct kvm_tdx_capabilities *tdx_caps;
+static struct kvm_cpuid2 *tdx_supported_cpuid;
 
 /* Valid after kvm_arch_init()->confidential_guest_kvm_init()->tdx_kvm_init() */
 bool is_tdx_vm(void)
@@ -373,6 +374,20 @@ static Notifier tdx_machine_done_notify = {
     .notify = tdx_finalize_vm,
 };
 
+static void tdx_setup_supported_cpuid(void)
+{
+    if (tdx_supported_cpuid) {
+        return;
+    }
+
+    tdx_supported_cpuid = g_malloc0(sizeof(*tdx_supported_cpuid) +
+                    KVM_MAX_CPUID_ENTRIES * sizeof(struct kvm_cpuid_entry2));
+
+    memcpy(tdx_supported_cpuid->entries, tdx_caps->cpuid.entries,
+           tdx_caps->cpuid.nent * sizeof(struct kvm_cpuid_entry2));
+    tdx_supported_cpuid->nent = tdx_caps->cpuid.nent;
+}
+
 static int tdx_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
 {
     MachineState *ms = MACHINE(qdev_get_machine());
@@ -410,6 +425,8 @@ static int tdx_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
         }
     }
 
+    tdx_setup_supported_cpuid();
+
     /* TDX relies on KVM_HC_MAP_GPA_RANGE to handle TDG.VP.VMCALL<MapGPA> */
     if (!kvm_enable_hypercall(BIT_ULL(KVM_HC_MAP_GPA_RANGE))) {
         return -EOPNOTSUPP;
@@ -447,6 +464,22 @@ static void tdx_cpu_instance_init(X86ConfidentialGuest *cg, CPUState *cpu)
     x86cpu->enable_cpuid_0x1f = true;
 }
 
+static uint32_t tdx_adjust_cpuid_features(X86ConfidentialGuest *cg,
+                                          uint32_t feature, uint32_t index,
+                                          int reg, uint32_t value)
+{
+    struct kvm_cpuid_entry2 *e;
+
+    if (is_feature_word_cpuid(feature, index, reg)) {
+        e = cpuid_find_entry(tdx_supported_cpuid, feature, index);
+        if (e) {
+            value &= cpuid_entry_get_reg(e, reg);
+        }
+    }
+
+    return value;
+}
+
 static int tdx_validate_attributes(TdxGuest *tdx, Error **errp)
 {
     if ((tdx->attributes & ~tdx_caps->supported_attrs)) {
@@ -841,4 +874,5 @@ static void tdx_guest_class_init(ObjectClass *oc, void *data)
     klass->kvm_init = tdx_kvm_init;
     x86_klass->kvm_type = tdx_kvm_type;
     x86_klass->cpu_instance_init = tdx_cpu_instance_init;
+    x86_klass->adjust_cpuid_features = tdx_adjust_cpuid_features;
 }
-- 
2.43.0


