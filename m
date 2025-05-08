Return-Path: <kvm+bounces-45936-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 35680AAFE8C
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 17:11:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DD8373AEA82
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 15:10:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED2D2286438;
	Thu,  8 May 2025 15:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="g3ybMeIZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7989326F478
	for <kvm@vger.kernel.org>; Thu,  8 May 2025 15:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746716802; cv=none; b=bVy7jlsYX+3rQijdk4lcSuI1hs+4CpHlaD084OwQKn+0rFchbgH7SHUr3zPdLPCJwny9Ex7QMoOjZgizEi4IFaGaAE6xKcJqNhLDCgO1JBzEL5eJlQOqTenRj90j91MZETJ36/aSr0ZQSopkW88SVTNwcVYass9/VDHk2B8jSYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746716802; c=relaxed/simple;
	bh=ra5iBHGkapTcOi1otMQa/i0aB5FjRDZq+hWL7YgMopc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oFsQEilKjnX5UnufVGdn+pkkRk5Negil0MX6/PH7QbiGwfIQ1UYon1muGi8JeEt2qLxUujAs4e7sp5c8z5uJEhVDG05y21fbCE0EDOk5QSCq7uhJMHviimdz6AuL4BTBDwJM3ujm5fGCGFJHUWAk7liwSScPOsS3EO/Mj6g73Jk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=g3ybMeIZ; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746716797; x=1778252797;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ra5iBHGkapTcOi1otMQa/i0aB5FjRDZq+hWL7YgMopc=;
  b=g3ybMeIZv5nek/Tvw8aFNFuVm76KZPvCTRrmIz/gTXmYxpbOryojVWhP
   f4iSpJwB23libFHhlmUauXTFBcBEvsefbJyhYezr6mImUcZ63hureC5sk
   CGvXjtZnWTDyCOpBqtPuqAylrl1Iawg+HrKjCqqBpyM0u80bftbcxYKan
   2s/i2KcqE0waa7gI0CWKTgBcNo//eRKy2jdPBPxjNJ1EKeF4aNZFss020
   Qfay7dS1a8c+NrUTqGdzfB3HTNzrm5buCvdv4XzYoQI/1o2kwSthvxH6y
   VxWMrxujQQlnl+ueHPNaXU1h5NzJ9nBFYSC8whabyJqLiDR9lXU8DF2GE
   Q==;
X-CSE-ConnectionGUID: AoJZyTT6R8KFITrpkimusg==
X-CSE-MsgGUID: sruI83EkQpOObf3JHCjEIg==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="73888288"
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="73888288"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 08:06:37 -0700
X-CSE-ConnectionGUID: i2rWL60MSB+7XpkVg2Vtag==
X-CSE-MsgGUID: OWiKGi97QPOp3EJe58MLnQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="141440174"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa005.jf.intel.com with ESMTP; 08 May 2025 08:06:34 -0700
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
Subject: [PATCH v9 33/55] i386/cpu: Introduce enable_cpuid_0x1f to force exposing CPUID 0x1f
Date: Thu,  8 May 2025 10:59:39 -0400
Message-ID: <20250508150002.689633-34-xiaoyao.li@intel.com>
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

Currently, QEMU exposes CPUID 0x1f to guest only when necessary, i.e.,
when topology level that cannot be enumerated by leaf 0xB, e.g., die or
module level, are configured for the guest, e.g., -smp xx,dies=2.

However, TDX architecture forces to require CPUID 0x1f to configure CPU
topology.

Introduce a bool flag, enable_cpuid_0x1f, in CPU for the case that
requires CPUID leaf 0x1f to be exposed to guest.

Introduce a new function x86_has_cpuid_0x1f(), which is the wrapper of
cpu->enable_cpuid_0x1f and x86_has_extended_topo() to check if it needs
to enable cpuid leaf 0x1f for the guest.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
---
 target/i386/cpu.c     | 4 ++--
 target/i386/cpu.h     | 9 +++++++++
 target/i386/kvm/kvm.c | 2 +-
 3 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index ea73b2225282..a255f4d1b81f 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -7006,7 +7006,7 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
         break;
     case 0x1F:
         /* V2 Extended Topology Enumeration Leaf */
-        if (!x86_has_extended_topo(env->avail_cpu_topo)) {
+        if (!x86_has_cpuid_0x1f(cpu)) {
             *eax = *ebx = *ecx = *edx = 0;
             break;
         }
@@ -7870,7 +7870,7 @@ void x86_cpu_expand_features(X86CPU *cpu, Error **errp)
          * cpu->vendor_cpuid_only has been unset for compatibility with older
          * machine types.
          */
-        if (x86_has_extended_topo(env->avail_cpu_topo) &&
+        if (x86_has_cpuid_0x1f(cpu) &&
             (IS_INTEL_CPU(env) || !cpu->vendor_cpuid_only)) {
             x86_cpu_adjust_level(cpu, &env->cpuid_min_level, 0x1F);
         }
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 76f24446a55d..3910b488f775 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -2251,6 +2251,9 @@ struct ArchCPU {
     /* Compatibility bits for old machine types: */
     bool enable_cpuid_0xb;
 
+    /* Force to enable cpuid 0x1f */
+    bool enable_cpuid_0x1f;
+
     /* Enable auto level-increase for all CPUID leaves */
     bool full_cpuid_auto_level;
 
@@ -2513,6 +2516,12 @@ void host_cpuid(uint32_t function, uint32_t count,
                 uint32_t *eax, uint32_t *ebx, uint32_t *ecx, uint32_t *edx);
 bool cpu_has_x2apic_feature(CPUX86State *env);
 
+static inline bool x86_has_cpuid_0x1f(X86CPU *cpu)
+{
+    return cpu->enable_cpuid_0x1f ||
+           x86_has_extended_topo(cpu->env.avail_cpu_topo);
+}
+
 /* helper.c */
 void x86_cpu_set_a20(X86CPU *cpu, int a20_state);
 void cpu_sync_avx_hflag(CPUX86State *env);
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index a76f34537908..741b50181ed9 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -1871,7 +1871,7 @@ uint32_t kvm_x86_build_cpuid(CPUX86State *env, struct kvm_cpuid_entry2 *entries,
             break;
         }
         case 0x1f:
-            if (!x86_has_extended_topo(env->avail_cpu_topo)) {
+            if (!x86_has_cpuid_0x1f(env_archcpu(env))) {
                 cpuid_i--;
                 break;
             }
-- 
2.43.0


