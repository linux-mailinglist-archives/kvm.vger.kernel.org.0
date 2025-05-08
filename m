Return-Path: <kvm+bounces-45954-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B40FAAFEC4
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 17:15:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 10DDA3A3F76
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 15:13:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CF4527F754;
	Thu,  8 May 2025 15:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EJqzuAcL"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C52D32797B1
	for <kvm@vger.kernel.org>; Thu,  8 May 2025 15:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746716854; cv=none; b=GGxOOAmn149BpfBw5y0IaCa8YLMwUS1EJ//ofnExPpaS4nH5+MpDJSuZLhWqBInmxdyiBI5zrWkBtce5rw3JHJ5LzSmzGb9Do1aTvTHYzgkCu300ZrPYzudEmNuTSgTCWU4qwlG9UdHzZwXE+amghF6aYk5BWaZhqFqalO/SAH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746716854; c=relaxed/simple;
	bh=ir5H03V4cxOARYbMZeC3gFBbH6ndnw/S7CDzSKHoWHM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nSX5EQXObdYlvHtam3r/txXStDlaRlFKjF73YRtkAi6b5MFXmnKg6dAOON0FhQkq2dImUWFviRY/XKzEpD3n42Q/5u/LI3UX9cKHCEKg+GpTq2xR/qxZpOb+gXMQhBQegyBj9PK54iV6JCenVMSxtRnK/CCNh8k6fX+wtpZv9rI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EJqzuAcL; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746716853; x=1778252853;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ir5H03V4cxOARYbMZeC3gFBbH6ndnw/S7CDzSKHoWHM=;
  b=EJqzuAcLjuqKdgPRJG5TfBj5b35rL8gr8fDjB/T7Z0fIdNsMjz7rXaUU
   hSAua8o5iUaPNM1N+dylOlmFE6MSS0/gHPp2/iqEZx1ACoy9+WxYmBSWP
   7FH1OcrPcWNQ3Cbs52KBOVgXZF2Hw9tZJCCVETRsSdnTurZXsZRBU/Igm
   CkftVHe8vT0Wx0qBnNKdUigEStF9/HOQ3rbuIt1NT1iGG/deZP5tYTef5
   Nc0VgecHdqatz+PVcy1i5QDVZmTivkCTGXy8D/ktywtEvRE0rI6BnWgTF
   jGBzKuG5xk1PWG6JYWqTQbnBUXjc+zeOJ2TdBx1K1PRvgYj9qk+SBuL01
   g==;
X-CSE-ConnectionGUID: WSlMBjchQjWlv/48HzxWUg==
X-CSE-MsgGUID: NwSaRSS4QjiFBMZ99iFPPw==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="58716542"
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="58716542"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 08:07:33 -0700
X-CSE-ConnectionGUID: rNbrGbhgSwa8hZsbbVh8YQ==
X-CSE-MsgGUID: KOxx+QnQRSKfDVcBji637Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="141440549"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa005.jf.intel.com with ESMTP; 08 May 2025 08:07:29 -0700
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
Subject: [PATCH v9 51/55] i386/tdx: Fetch and validate CPUID of TD guest
Date: Thu,  8 May 2025 10:59:57 -0400
Message-ID: <20250508150002.689633-52-xiaoyao.li@intel.com>
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

Use KVM_TDX_GET_CPUID to get the CPUIDs that are managed and enfored
by TDX module for TD guest. Check QEMU's configuration against the
fetched data.

Print wanring  message when 1. a feature is not supported but requested
by QEMU or 2. QEMU doesn't want to expose a feature while it is enforced
enabled.

- If cpu->enforced_cpuid is not set, prints the warning message of both
1) and 2) and tweak QEMU's configuration.

- If cpu->enforced_cpuid is set, quit if any case of 1) or 2).

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 target/i386/cpu.c     |  33 +++++++++++++-
 target/i386/cpu.h     |   7 +++
 target/i386/kvm/tdx.c | 101 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 139 insertions(+), 2 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 071669c2d908..4530fe887d82 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -5770,8 +5770,8 @@ static bool x86_cpu_have_filtered_features(X86CPU *cpu)
     return false;
 }
 
-static void mark_unavailable_features(X86CPU *cpu, FeatureWord w, uint64_t mask,
-                                      const char *verbose_prefix)
+void mark_unavailable_features(X86CPU *cpu, FeatureWord w, uint64_t mask,
+                               const char *verbose_prefix)
 {
     CPUX86State *env = &cpu->env;
     FeatureWordInfo *f = &feature_word_info[w];
@@ -5798,6 +5798,35 @@ static void mark_unavailable_features(X86CPU *cpu, FeatureWord w, uint64_t mask,
     }
 }
 
+void mark_forced_on_features(X86CPU *cpu, FeatureWord w, uint64_t mask,
+                             const char *verbose_prefix)
+{
+    CPUX86State *env = &cpu->env;
+    FeatureWordInfo *f = &feature_word_info[w];
+    int i;
+
+    if (!cpu->force_features) {
+        env->features[w] |= mask;
+    }
+
+    cpu->forced_on_features[w] |= mask;
+
+    if (!verbose_prefix) {
+        return;
+    }
+
+    for (i = 0; i < 64; ++i) {
+        if ((1ULL << i) & mask) {
+            g_autofree char *feat_word_str = feature_word_description(f);
+            warn_report("%s: %s%s%s [bit %d]",
+                        verbose_prefix,
+                        feat_word_str,
+                        f->feat_names[i] ? "." : "",
+                        f->feat_names[i] ? f->feat_names[i] : "", i);
+        }
+    }
+}
+
 static void x86_cpuid_version_get_family(Object *obj, Visitor *v,
                                          const char *name, void *opaque,
                                          Error **errp)
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index a223e09a25c4..1600e826f372 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -2227,6 +2227,9 @@ struct ArchCPU {
     /* Features that were filtered out because of missing host capabilities */
     FeatureWordArray filtered_features;
 
+    /* Features that are forced enabled by underlying hypervisor, e.g., TDX */
+    FeatureWordArray forced_on_features;
+
     /* Enable PMU CPUID bits. This can't be enabled by default yet because
      * it doesn't have ABI stability guarantees, as it passes all PMU CPUID
      * bits returned by GET_SUPPORTED_CPUID (that depend on host CPU and kernel
@@ -2539,6 +2542,10 @@ void host_cpuid(uint32_t function, uint32_t count,
                 uint32_t *eax, uint32_t *ebx, uint32_t *ecx, uint32_t *edx);
 bool cpu_has_x2apic_feature(CPUX86State *env);
 bool is_feature_word_cpuid(uint32_t feature, uint32_t index, int reg);
+void mark_unavailable_features(X86CPU *cpu, FeatureWord w, uint64_t mask,
+                               const char *verbose_prefix);
+void mark_forced_on_features(X86CPU *cpu, FeatureWord w, uint64_t mask,
+                             const char *verbose_prefix);
 
 static inline bool x86_has_cpuid_0x1f(X86CPU *cpu)
 {
diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 16d55613c683..aa1bab644352 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -773,6 +773,106 @@ static uint32_t tdx_adjust_cpuid_features(X86ConfidentialGuest *cg,
     return value;
 }
 
+static struct kvm_cpuid2 *tdx_fetch_cpuid(CPUState *cpu, int *ret)
+{
+    struct kvm_cpuid2 *fetch_cpuid;
+    int size = KVM_MAX_CPUID_ENTRIES;
+    Error *local_err = NULL;
+    int r;
+
+    do {
+        error_free(local_err);
+        local_err = NULL;
+
+        fetch_cpuid = g_malloc0(sizeof(*fetch_cpuid) +
+                                sizeof(struct kvm_cpuid_entry2) * size);
+        fetch_cpuid->nent = size;
+        r = tdx_vcpu_ioctl(cpu, KVM_TDX_GET_CPUID, 0, fetch_cpuid, &local_err);
+        if (r == -E2BIG) {
+            g_free(fetch_cpuid);
+            size = fetch_cpuid->nent;
+        }
+    } while (r == -E2BIG);
+
+    if (r < 0) {
+        error_report_err(local_err);
+        *ret = r;
+        return NULL;
+    }
+
+    return fetch_cpuid;
+}
+
+static int tdx_check_features(X86ConfidentialGuest *cg, CPUState *cs)
+{
+    uint64_t actual, requested, unavailable, forced_on;
+    g_autofree struct kvm_cpuid2 *fetch_cpuid;
+    const char *forced_on_prefix = NULL;
+    const char *unav_prefix = NULL;
+    struct kvm_cpuid_entry2 *entry;
+    X86CPU *cpu = X86_CPU(cs);
+    CPUX86State *env = &cpu->env;
+    FeatureWordInfo *wi;
+    FeatureWord w;
+    bool mismatch = false;
+    int r;
+
+    fetch_cpuid = tdx_fetch_cpuid(cs, &r);
+    if (!fetch_cpuid) {
+        return r;
+    }
+
+    if (cpu->check_cpuid || cpu->enforce_cpuid) {
+        unav_prefix = "TDX doesn't support requested feature";
+        forced_on_prefix = "TDX forcibly sets the feature";
+    }
+
+    for (w = 0; w < FEATURE_WORDS; w++) {
+        wi = &feature_word_info[w];
+        actual = 0;
+
+        switch (wi->type) {
+        case CPUID_FEATURE_WORD:
+            entry = cpuid_find_entry(fetch_cpuid, wi->cpuid.eax, wi->cpuid.ecx);
+            if (!entry) {
+                /*
+                 * If KVM doesn't report it means it's totally configurable
+                 * by QEMU
+                 */
+                continue;
+            }
+
+            actual = cpuid_entry_get_reg(entry, wi->cpuid.reg);
+            break;
+        case MSR_FEATURE_WORD:
+            /*
+             * TODO:
+             * validate MSR features when KVM has interface report them.
+             */
+            continue;
+        }
+
+        requested = env->features[w];
+        unavailable = requested & ~actual;
+        mark_unavailable_features(cpu, w, unavailable, unav_prefix);
+        if (unavailable) {
+            mismatch = true;
+        }
+
+        forced_on = actual & ~requested;
+        mark_forced_on_features(cpu, w, forced_on, forced_on_prefix);
+        if (forced_on) {
+            mismatch = true;
+        }
+    }
+
+    if (cpu->enforce_cpuid && mismatch) {
+        return -EINVAL;
+    }
+
+    return 0;
+}
+
 static int tdx_validate_attributes(TdxGuest *tdx, Error **errp)
 {
     if ((tdx->attributes & ~tdx_caps->supported_attrs)) {
@@ -1168,4 +1268,5 @@ static void tdx_guest_class_init(ObjectClass *oc, void *data)
     x86_klass->kvm_type = tdx_kvm_type;
     x86_klass->cpu_instance_init = tdx_cpu_instance_init;
     x86_klass->adjust_cpuid_features = tdx_adjust_cpuid_features;
+    x86_klass->check_features = tdx_check_features;
 }
-- 
2.43.0


