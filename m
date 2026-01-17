Return-Path: <kvm+bounces-68426-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 37093D38B18
	for <lists+kvm@lfdr.de>; Sat, 17 Jan 2026 02:18:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 686A3301198B
	for <lists+kvm@lfdr.de>; Sat, 17 Jan 2026 01:18:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 922C822B5AD;
	Sat, 17 Jan 2026 01:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iTyHVFes"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 744FD21CC60
	for <kvm@vger.kernel.org>; Sat, 17 Jan 2026 01:18:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768612690; cv=none; b=kHUGE/pbMrq+m5qlEf03U90i3SCwsPDWiua1VMX/NPhI7SBA8RXtRklWTlPY6ZWtflK3QuZk0fBtiMijdLGeFeCw69P+DizcU6mrMSrhZpO5pt5BpENYaGjnA2YGIiDG00ey+Qd47DAYbEG790ork7ruJvO11eaHm51rfoo781I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768612690; c=relaxed/simple;
	bh=3LAfenVCwIiuUdSFycJUlecFg2V/epsiKiOvzm0Dv2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V7XcGZoapN+lqSyGzGhIUUY1saUzZ8bOB23/rsvUFTU+HujMo0jYyz5TIptK0X2NypEwJ91SafuZ3kSlEZ+8A/ODIDDJYHqnHrKTFdulHcPM4QNxgIs0mH+eQYljabx0NnptodIIVzzGvZ3vEFTIteif419NKm6r9VkaUUlZ/yY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iTyHVFes; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768612690; x=1800148690;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3LAfenVCwIiuUdSFycJUlecFg2V/epsiKiOvzm0Dv2A=;
  b=iTyHVFestYfd2Mgv60DQr1SI7igC+70tATlxWBvu6KXwayqFzUNmdc9A
   mIJ2gkAaLkBkuNQwVZRbKKEIO2csh9F7k3ZY158jodYOzFJtMRzRDAyN5
   LBX/WiyRPzdmsTEOw4S3xSwZAex7MNlAoRl9REu0JpaW3XN57rMAEdQjT
   Kij7lekc+8SVeJGd1wPAMkD9cpz7gAK9sgcboYb1eya/mtshkNmb2rgyS
   fQzlbkFPsJVmpzYsxN8gWYGmlp+T3N6PA8R6CzYIXHQoEaWo88p9XEJwG
   JJpo+Rt2hm0+x4vRM9+8KhWOD5+eZnnq2NQViRhbjYcK//nvpzEgxXZYq
   A==;
X-CSE-ConnectionGUID: WlZNbUgxTq2GZA2P0uZvvg==
X-CSE-MsgGUID: RJClkQb8RLGYRwuTES+NPg==
X-IronPort-AV: E=McAfee;i="6800,10657,11673"; a="69131156"
X-IronPort-AV: E=Sophos;i="6.21,232,1763452800"; 
   d="scan'208";a="69131156"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2026 17:18:08 -0800
X-CSE-ConnectionGUID: WaqVDCyhRT6p/C0Bu1/fMg==
X-CSE-MsgGUID: JwpHhkpKTA6xms5V78cFUA==
X-ExtLoop1: 1
Received: from 9cc2c43eec6b.jf.intel.com ([10.54.77.43])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2026 17:18:08 -0800
From: Zide Chen <zide.chen@intel.com>
To: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Zhao Liu <zhao1.liu@intel.com>,
	Peter Xu <peterx@redhat.com>,
	Fabiano Rosas <farosas@suse.de>
Cc: xiaoyao.li@intel.com,
	Dongli Zhang <dongli.zhang@oracle.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Zide Chen <zide.chen@intel.com>
Subject: [PATCH 3/7] target/i386: Gate enable_pmu on kvm_enabled()
Date: Fri, 16 Jan 2026 17:10:49 -0800
Message-ID: <20260117011053.80723-4-zide.chen@intel.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260117011053.80723-1-zide.chen@intel.com>
References: <20260117011053.80723-1-zide.chen@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Guest PMU support requires KVM.  Clear cpu->enable_pmu when KVM is not
enabled, so PMU-related code can rely solely on cpu->enable_pmu.

This reduces duplication and avoids bugs where one of the checks is
missed.  For example, cpu_x86_cpuid() enables CPUID.0AH when
cpu->enable_pmu is set but does not check kvm_enabled(). This is
implicitly fixed by this patch:

if (cpu->enable_pmu) {
	x86_cpu_get_supported_cpuid(0xA, count, eax, ebx, ecx, edx);
}

Also fix two places that check kvm_enabled() but not cpu->enable_pmu.

Signed-off-by: Zide Chen <zide.chen@intel.com>
---
 target/i386/cpu.c     | 9 ++++++---
 target/i386/kvm/kvm.c | 4 ++--
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 37803cd72490..f1ac98970d3e 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -8671,7 +8671,7 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
         *ecx = 0;
         *edx = 0;
         if (!(env->features[FEAT_7_0_EBX] & CPUID_7_0_EBX_INTEL_PT) ||
-            !kvm_enabled()) {
+            !cpu->enable_pmu) {
             break;
         }
 
@@ -9018,7 +9018,7 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
     case 0x80000022:
         *eax = *ebx = *ecx = *edx = 0;
         /* AMD Extended Performance Monitoring and Debug */
-        if (kvm_enabled() && cpu->enable_pmu &&
+        if (cpu->enable_pmu &&
             (env->features[FEAT_8000_0022_EAX] & CPUID_8000_0022_EAX_PERFMON_V2)) {
             *eax |= CPUID_8000_0022_EAX_PERFMON_V2;
             *ebx |= kvm_arch_get_supported_cpuid(cs->kvm_state, index, count,
@@ -9642,7 +9642,7 @@ static bool x86_cpu_filter_features(X86CPU *cpu, bool verbose)
      * are advertised by cpu_x86_cpuid().  Keep these two in sync.
      */
     if ((env->features[FEAT_7_0_EBX] & CPUID_7_0_EBX_INTEL_PT) &&
-        kvm_enabled()) {
+        cpu->enable_pmu) {
         x86_cpu_get_supported_cpuid(0x14, 0,
                                     &eax_0, &ebx_0, &ecx_0, &edx_0);
         x86_cpu_get_supported_cpuid(0x14, 1,
@@ -9790,6 +9790,9 @@ static void x86_cpu_realizefn(DeviceState *dev, Error **errp)
     Error *local_err = NULL;
     unsigned requested_lbr_fmt;
 
+    if (!kvm_enabled())
+	    cpu->enable_pmu = false;
+
 #if defined(CONFIG_TCG) && !defined(CONFIG_USER_ONLY)
     /* Use pc-relative instructions in system-mode */
     tcg_cflags_set(cs, CF_PCREL);
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index cffbc90d1c50..e81fa46ed66c 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -4222,7 +4222,7 @@ static int kvm_put_msrs(X86CPU *cpu, KvmPutState level)
                               env->msr_xfd_err);
         }
 
-        if (kvm_enabled() && cpu->enable_pmu &&
+        if (cpu->enable_pmu &&
             (env->features[FEAT_7_0_EDX] & CPUID_7_0_EDX_ARCH_LBR)) {
             uint64_t depth;
             int ret;
@@ -4698,7 +4698,7 @@ static int kvm_get_msrs(X86CPU *cpu)
         kvm_msr_entry_add(cpu, MSR_IA32_XFD_ERR, 0);
     }
 
-    if (kvm_enabled() && cpu->enable_pmu &&
+    if (cpu->enable_pmu &&
         (env->features[FEAT_7_0_EDX] & CPUID_7_0_EDX_ARCH_LBR)) {
         uint64_t depth;
 
-- 
2.52.0


