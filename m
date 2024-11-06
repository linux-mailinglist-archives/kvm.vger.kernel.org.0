Return-Path: <kvm+bounces-30836-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 592989BDD34
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 03:50:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8B2781C2309C
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 02:50:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60D3519067C;
	Wed,  6 Nov 2024 02:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PeJ1Kage"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A036190056
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 02:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730861406; cv=none; b=eIFEfMdPUu1GhGHZWYB3VQke28M7C8v3HY+3LwTjG8cHEqd+2poPl3Ke35w3nJwFzNzGFAFljoHpDWUIqwduoTztnqd3wJQV62FP3n329b08iAXjZDjj51hlsGMcacDAO0KXudpc1fZJoP0DpwydYLxhRHGsZxZg9LFzu1IcM/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730861406; c=relaxed/simple;
	bh=JcVwYkgHmlLrfByBJgICNQrNbswie+WUwEU7n23xvn8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HxK4PqmCu3NDb0QvBDj5EjhcBDCwTbf/AnXh09A173tbohMle9GY4D7Ei9uWu2TUWrXLXLb41Pg5LEQarjL0EKR/N5EdS7aZ16FE7XMMr7ccQXgjO/rn4gE5nlhNC3eoCRPmIyH69XhlhOuZx6v/0J06aK5CBsQZ0HeqMkEWy7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PeJ1Kage; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730861405; x=1762397405;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JcVwYkgHmlLrfByBJgICNQrNbswie+WUwEU7n23xvn8=;
  b=PeJ1Kage2MCxJUE4vbI7rdNMR3yqN1V/K5YgjhxmvBjmk08LdEp2ocTo
   7RDaRcIT7A73pVdxXMqyxVE7HfHWmHQgR3kgRUeKTO02r02iCVagWZCyK
   iumvmdJ9+/fv6mW1Y8oMeOPmtkL7KI6Zg9MfRMUwx2vSJeuz7KMeW/a6/
   /yKRl5YW0tcIy40Tzl6w5nHAPL336dh82utdBa021QZ7ng3JIrcKFwENt
   l7vMsFtMALzeQnRZF9SR0Q06AihAffOKwA/jwjIg5JAjwXIzjrfhvVx61
   rR56outVl1+WWZBZtvYIFMWp9QQ1i8Gwp/YWr+SiOKcHbEY+4PIF2oaFF
   Q==;
X-CSE-ConnectionGUID: YDPoDqDUTfGO6Ev2z7CtSQ==
X-CSE-MsgGUID: uik7HcDoQYGsZlBEg3JolA==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="30492269"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="30492269"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2024 18:50:05 -0800
X-CSE-ConnectionGUID: T5TLU2G+Su6PkrVLoalTGw==
X-CSE-MsgGUID: YSLwJp0WSqyljdTgl/zOVA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,261,1725346800"; 
   d="scan'208";a="115077998"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by fmviesa001.fm.intel.com with ESMTP; 05 Nov 2024 18:50:02 -0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eduardo Habkost <eduardo@habkost.net>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Tao Su <tao1.su@linux.intel.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>,
	Pankaj Gupta <pankaj.gupta@amd.com>,
	Zide Chen <zide.chen@intel.com>,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH v5 05/11] target/i386/kvm: Save/load MSRs of kvmclock2 (KVM_FEATURE_CLOCKSOURCE2)
Date: Wed,  6 Nov 2024 11:07:22 +0800
Message-Id: <20241106030728.553238-6-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241106030728.553238-1-zhao1.liu@intel.com>
References: <20241106030728.553238-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

MSR_KVM_SYSTEM_TIME_NEW and MSR_KVM_WALL_CLOCK_NEW are bound to
kvmclock2 (KVM_FEATURE_CLOCKSOURCE2).

Add the save/load support for these 2 MSRs just like kvmclock MSRs.

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
Reviewed-by: Zide Chen <zide.chen@intel.com>
---
 target/i386/cpu.h     |  2 ++
 target/i386/kvm/kvm.c | 16 ++++++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index c4ec64e0078f..79c28a48eb70 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -1886,6 +1886,8 @@ typedef struct CPUArchState {
 
     uint64_t system_time_msr;
     uint64_t wall_clock_msr;
+    uint64_t system_time_new_msr;
+    uint64_t wall_clock_new_msr;
     uint64_t steal_time_msr;
     uint64_t async_pf_en_msr;
     uint64_t async_pf_int_msr;
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 4aba034865bb..b175cd4a4bcb 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -3962,6 +3962,12 @@ static int kvm_put_msrs(X86CPU *cpu, int level)
             kvm_msr_entry_add(cpu, MSR_KVM_SYSTEM_TIME, env->system_time_msr);
             kvm_msr_entry_add(cpu, MSR_KVM_WALL_CLOCK, env->wall_clock_msr);
         }
+        if (env->features[FEAT_KVM] & CPUID_KVM_CLOCK2) {
+            kvm_msr_entry_add(cpu, MSR_KVM_SYSTEM_TIME_NEW,
+                              env->system_time_new_msr);
+            kvm_msr_entry_add(cpu, MSR_KVM_WALL_CLOCK_NEW,
+                              env->wall_clock_new_msr);
+        }
         if (env->features[FEAT_KVM] & CPUID_KVM_ASYNCPF_INT) {
             kvm_msr_entry_add(cpu, MSR_KVM_ASYNC_PF_INT, env->async_pf_int_msr);
         }
@@ -4442,6 +4448,10 @@ static int kvm_get_msrs(X86CPU *cpu)
         kvm_msr_entry_add(cpu, MSR_KVM_SYSTEM_TIME, 0);
         kvm_msr_entry_add(cpu, MSR_KVM_WALL_CLOCK, 0);
     }
+    if (env->features[FEAT_KVM] & CPUID_KVM_CLOCK2) {
+        kvm_msr_entry_add(cpu, MSR_KVM_SYSTEM_TIME_NEW, 0);
+        kvm_msr_entry_add(cpu, MSR_KVM_WALL_CLOCK_NEW, 0);
+    }
     if (env->features[FEAT_KVM] & CPUID_KVM_ASYNCPF_INT) {
         kvm_msr_entry_add(cpu, MSR_KVM_ASYNC_PF_INT, 0);
     }
@@ -4708,6 +4718,12 @@ static int kvm_get_msrs(X86CPU *cpu)
         case MSR_KVM_WALL_CLOCK:
             env->wall_clock_msr = msrs[i].data;
             break;
+        case MSR_KVM_SYSTEM_TIME_NEW:
+            env->system_time_new_msr = msrs[i].data;
+            break;
+        case MSR_KVM_WALL_CLOCK_NEW:
+            env->wall_clock_new_msr = msrs[i].data;
+            break;
         case MSR_MCG_STATUS:
             env->mcg_status = msrs[i].data;
             break;
-- 
2.34.1


