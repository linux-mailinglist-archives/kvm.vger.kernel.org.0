Return-Path: <kvm+bounces-36517-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9154CA1B70F
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 14:40:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D3377162615
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 13:39:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F100713BC18;
	Fri, 24 Jan 2025 13:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lLbRk5Fb"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F49338FB9
	for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 13:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737725941; cv=none; b=kvYP91M4OZSYrh4dRMjWa6ig74jgRBcnKvZhhIuxAmxnEQWRaQqFInbt3T2U/uZfBK4jEAKps28QOcLbEKW+kgOeK5F7kyeNQ/uEAdZq0BJd3QvRqIWqs7jfg3QTA39UwxfV2WIjQpELi2XzEIkIvs+efAAAAZG58sN/IMO8vUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737725941; c=relaxed/simple;
	bh=AIvTamkBOmKspnXO3UXE/eRzJSG4/8lw/StlhSw6xEg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=h90WvN/ssXvVFkiNy/bPvfecXq9LJjtMet/1aE/sX5Fp02/F7u5Qg8qo3x8QlLsOyCaeiBk0MCDMkNOh0KDlhP+jxf6w6fYP/pqPTVzy/hoDnR69J/lYx/jOwVPkWh8gZfZ4w0mEkaK/qLKYH8i2hdLDPiSwiPUEqxVQeU/yQLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lLbRk5Fb; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737725940; x=1769261940;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=AIvTamkBOmKspnXO3UXE/eRzJSG4/8lw/StlhSw6xEg=;
  b=lLbRk5Fbk1BUx18fMUMCNUPsTjHMeSBZm6uN7LJk8c66UMDNMGgF6nEa
   sFfcv2DLuK0U88k5U4Jw9jUCe134Ab8ZewmM5GTqBBv4Z+FSFk39RvVJU
   dh8bXHX07tBmvkVFgaNKcHHp3+BvKmW66Qnsz0QVqlHdl866HVaF2hrpj
   PdwFBtXHpX1qdBFtmUN+Nlc9ytQ+4VXv8H3lyJAjDW/P1bz/fROdS41pZ
   jOXC4t8YHhoN+4eivkqbhilz6lWsE31eE6l98QHnniiJ1PpY3pXY6ca0l
   jIM8OfOXvBF6/9KscX/ypz7n6lB8Ka4YnAXbVenMw5sTO4i35fSCsgQE9
   Q==;
X-CSE-ConnectionGUID: QNObTAbeT1W/AlYRlMXKTA==
X-CSE-MsgGUID: P8uO3BKSSW2gxr2iz8tPFA==
X-IronPort-AV: E=McAfee;i="6700,10204,11325"; a="49246482"
X-IronPort-AV: E=Sophos;i="6.13,231,1732608000"; 
   d="scan'208";a="49246482"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2025 05:39:00 -0800
X-CSE-ConnectionGUID: WmHn80zLQV22oN/URjP/rQ==
X-CSE-MsgGUID: 4GbByw3iST+eUc/xzSjrRA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="111804389"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmviesa003.fm.intel.com with ESMTP; 24 Jan 2025 05:38:55 -0800
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Igor Mammedov <imammedo@redhat.com>
Cc: Zhao Liu <zhao1.liu@intel.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Francesco Lavra <francescolavra.fl@gmail.com>,
	xiaoyao.li@intel.com,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org
Subject: [PATCH v7 31/52] i386/cpu: Introduce enable_cpuid_0x1f to force exposing CPUID 0x1f
Date: Fri, 24 Jan 2025 08:20:27 -0500
Message-Id: <20250124132048.3229049-32-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250124132048.3229049-1-xiaoyao.li@intel.com>
References: <20250124132048.3229049-1-xiaoyao.li@intel.com>
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

Introduce a new function x86_has_cpuid_0x1f(), which is the warpper of
cpu->enable_cpuid_0x1f and x86_has_extended_topo() to check if it needs
to enable cpuid leaf 0x1f for the guest.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 target/i386/cpu.c     | 4 ++--
 target/i386/cpu.h     | 9 +++++++++
 target/i386/kvm/kvm.c | 2 +-
 3 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index a369cf90f5f6..4088bf63c48f 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -6725,7 +6725,7 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
         break;
     case 0x1F:
         /* V2 Extended Topology Enumeration Leaf */
-        if (!x86_has_extended_topo(env->avail_cpu_topo)) {
+        if (!x86_has_cpuid_0x1f(cpu)) {
             *eax = *ebx = *ecx = *edx = 0;
             break;
         }
@@ -7588,7 +7588,7 @@ void x86_cpu_expand_features(X86CPU *cpu, Error **errp)
          * cpu->vendor_cpuid_only has been unset for compatibility with older
          * machine types.
          */
-        if (x86_has_extended_topo(env->avail_cpu_topo) &&
+        if (x86_has_cpuid_0x1f(cpu) &&
             (IS_INTEL_CPU(env) || !cpu->vendor_cpuid_only)) {
             x86_cpu_adjust_level(cpu, &env->cpuid_min_level, 0x1F);
         }
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index b26e25ba15e0..ca6295605985 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -2191,6 +2191,9 @@ struct ArchCPU {
     /* Compatibility bits for old machine types: */
     bool enable_cpuid_0xb;
 
+    /* Force to enable cpuid 0x1f */
+    bool enable_cpuid_0x1f;
+
     /* Enable auto level-increase for all CPUID leaves */
     bool full_cpuid_auto_level;
 
@@ -2453,6 +2456,12 @@ void host_cpuid(uint32_t function, uint32_t count,
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
2.34.1


