Return-Path: <kvm+bounces-13077-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B0EB89167D
	for <lists+kvm@lfdr.de>; Fri, 29 Mar 2024 11:06:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8EC001F2320E
	for <lists+kvm@lfdr.de>; Fri, 29 Mar 2024 10:06:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC29A524C6;
	Fri, 29 Mar 2024 10:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gKY8PGaU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E0BA54BF6
	for <kvm@vger.kernel.org>; Fri, 29 Mar 2024 10:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711706783; cv=none; b=aYDpbwvcqWWLfg5yv3M6NgDspdnGHAFB6/X6DqITCqQrytt1uNuid/xGQ/gr19LJEMuFDRzwpSMEtHVVN2loqaJn490NMJLTgPI/Zdt4mk4ikUcmJqXZVbJ9fs4MoXk9AnksYLS9O4xnDdUK+pYeLiAmldPOJLJTbzN+j5/4cxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711706783; c=relaxed/simple;
	bh=UcXLu1O/drx9QFOgVCmPf+BlIYW0CAl3F27Dh66GxMI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=uw3y5FFvvtv/3p3CV0U4/q0SV9AhagTLODOL42WCWdPPb4wGUSHdsIxbqqLJQDWHheKHkUEE3pyq30u/jSBVQRVzPzqFmYSfOqTH63ZUyAz+FWNEqxWneazpiPrzK2rcrfNCwjkoe62zW9mB64P79ZYQBM2H8/5JCS9Tbahck5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gKY8PGaU; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711706781; x=1743242781;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UcXLu1O/drx9QFOgVCmPf+BlIYW0CAl3F27Dh66GxMI=;
  b=gKY8PGaUeYnvjR6WM2z24GXRYKQ7lxyVEpURNWBI4U6X/oE9iAj83qQ5
   OxTTEMp4E8AiKHmFHMnBLflc2LXoyEN1QSLHJN72fxr+x9Kg1wbM9YsAI
   E5TJMfh4QkcM6ws0V1gkXEiwFZ2SJVVefPusXRmEwPO80rRZg4RNRQ0MM
   VsR8hALhrGmmTUfnHa+GnAP9bEEGpjg1z2TWfRC5uNHms3Iro9vTm+NVH
   vLMGlCLZSSmKCiU57GrEUshFamwJ+5v6HDEAFTMEO0wzLRR/z0o1g3wKr
   7hHA6W+g2CEW710P1/a/ZYhOOnPSNzRxm1OhOzfYI9RDe25Pyq3L1ewOv
   w==;
X-CSE-ConnectionGUID: bv4v7pBfTO6YjFt+KbtQcA==
X-CSE-MsgGUID: Ce+cA8yjT+yyYZX3uEPpGQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11027"; a="17519231"
X-IronPort-AV: E=Sophos;i="6.07,164,1708416000"; 
   d="scan'208";a="17519231"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2024 03:06:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,164,1708416000"; 
   d="scan'208";a="21441978"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by fmviesa003.fm.intel.com with ESMTP; 29 Mar 2024 03:06:18 -0700
From: Zhao Liu <zhao1.liu@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eduardo Habkost <eduardo@habkost.net>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Tim Wiederhake <twiederh@redhat.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH for-9.1 5/7] target/i386/kvm: Add legacy_kvmclock cpu property
Date: Fri, 29 Mar 2024 18:19:52 +0800
Message-Id: <20240329101954.3954987-6-zhao1.liu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240329101954.3954987-1-zhao1.liu@linux.intel.com>
References: <20240329101954.3954987-1-zhao1.liu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Zhao Liu <zhao1.liu@intel.com>

Currently, the old kvmclock (KVM_FEATURE_CLOCKSOURCE) and the new
(KVM_FEATURE_CLOCKSOURCE2) are always set/unset together since they have
the same feature name "kvmclock" since the commit 642258c6c7 ("kvm: add
kvmclock to its second bit").

Before renaming the new kvmclock, introduce legacy_kvmclock to inherit
the behavior of both old and new kvmclocks being enabled/disabled at the
same time.

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 hw/i386/pc.c              |  1 +
 target/i386/cpu.c         |  1 +
 target/i386/cpu.h         |  7 +++++++
 target/i386/kvm/kvm-cpu.c | 19 +++++++++++++++++++
 4 files changed, 28 insertions(+)

diff --git a/hw/i386/pc.c b/hw/i386/pc.c
index 9c4b3969cc8a..a452da0a45a1 100644
--- a/hw/i386/pc.c
+++ b/hw/i386/pc.c
@@ -80,6 +80,7 @@
 
 GlobalProperty pc_compat_9_0[] = {
     { TYPE_X86_CPU, "guest-phys-bits", "0" },
+    { TYPE_X86_CPU, "legacy-kvmclock", "true" },
 };
 const size_t pc_compat_9_0_len = G_N_ELEMENTS(pc_compat_9_0);
 
diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index eef3d08473ed..1b6caf071a6d 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -7941,6 +7941,7 @@ static Property x86_cpu_properties[] = {
      */
     DEFINE_PROP_BOOL("legacy-cache", X86CPU, legacy_cache, true),
     DEFINE_PROP_BOOL("xen-vapic", X86CPU, xen_vapic, false),
+    DEFINE_PROP_BOOL("legacy-kvmclock", X86CPU, legacy_kvmclock, false),
 
     /*
      * From "Requirements for Implementing the Microsoft
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index b339f9ce454f..b3ee2a35f2c1 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -2070,6 +2070,13 @@ struct ArchCPU {
     int32_t hv_max_vps;
 
     bool xen_vapic;
+
+    /*
+     * Compatibility bits for old machine types.
+     * If true, always set/unset KVM_FEATURE_CLOCKSOURCE and
+     * KVM_FEATURE_CLOCKSOURCE2 at the same time.
+     */
+    bool legacy_kvmclock;
 };
 
 typedef struct X86CPUModel X86CPUModel;
diff --git a/target/i386/kvm/kvm-cpu.c b/target/i386/kvm/kvm-cpu.c
index e6b7a46743b5..ae3cb27c8aa8 100644
--- a/target/i386/kvm/kvm-cpu.c
+++ b/target/i386/kvm/kvm-cpu.c
@@ -18,6 +18,8 @@
 #include "kvm_i386.h"
 #include "hw/core/accel-cpu.h"
 
+#include "standard-headers/asm-x86/kvm_para.h"
+
 static void kvm_set_guest_phys_bits(CPUState *cs)
 {
     X86CPU *cpu = X86_CPU(cs);
@@ -72,6 +74,23 @@ static bool kvm_cpu_realizefn(CPUState *cs, Error **errp)
                                                    MSR_IA32_UCODE_REV);
         }
     }
+
+    if (cpu->legacy_kvmclock) {
+        /*
+         * The old and new kvmclock are both set by default from the
+         * oldest KVM supported (v4.5, see "OS requirements" section at
+         * docs/system/target-i386.rst). So when one of them is missing,
+         * it is only possible that the user is actively masking it.
+         * Then, mask both at the same time for compatibility with v9.0
+         * and older QEMU's kvmclock behavior.
+         */
+        if (!(env->features[FEAT_KVM] & CPUID_FEAT_KVM_CLOCK) ||
+            !(env->features[FEAT_KVM] & CPUID_FEAT_KVM_CLOCK2)) {
+            env->features[FEAT_KVM] &= ~(CPUID_FEAT_KVM_CLOCK |
+                                         CPUID_FEAT_KVM_CLOCK2);
+        }
+    }
+
     ret = host_cpu_realizefn(cs, errp);
     if (!ret) {
         return ret;
-- 
2.34.1


