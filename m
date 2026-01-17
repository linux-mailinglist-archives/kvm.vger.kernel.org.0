Return-Path: <kvm+bounces-68425-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D603D38B1B
	for <lists+kvm@lfdr.de>; Sat, 17 Jan 2026 02:18:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 4A476301F220
	for <lists+kvm@lfdr.de>; Sat, 17 Jan 2026 01:18:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42846228CB8;
	Sat, 17 Jan 2026 01:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="d81ut/iu"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AECC21ABD0
	for <kvm@vger.kernel.org>; Sat, 17 Jan 2026 01:18:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768612690; cv=none; b=Q3ZGkO1c0VEF0vye8+wnahTEq2H3qMpDXKDLAosYcxbrIggLKKVQw/VICheImquxKdtXvUkhZmn3F7CrOCnCccGnC1GOW5lXpDJfxpZGQVr2qPxepWYpg5Hd52rf9mIhEFmvesWFd2U9M0eVM/4TCb/baqCVzbVS4KCu+TusEQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768612690; c=relaxed/simple;
	bh=WVJQSNpNKHu3X0iUjOMBxv0QHS5KDEf9o+KQJ8gyVAQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DZ5H+9D/FIohu5MqDYTfF2f3LwEE9gPJVB+ml1VLUxi/mjb9YFQtDW7zCkn78SDkz1ZkNHx+URD2esbrlgPWMxdRYTzqw/1aCifhHRY+wPKSNzTUJZPAp7gPUksemI2aQWt0rGjJQMO2GP9KETYYg1BGo7KSL1sqoa1Lur4/nKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=d81ut/iu; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768612689; x=1800148689;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WVJQSNpNKHu3X0iUjOMBxv0QHS5KDEf9o+KQJ8gyVAQ=;
  b=d81ut/iuKh8h1OH+mfFzd5GNEjRTcaH/u1vMR0p54jz8CHKYScFPd36o
   T+TQtKKZ/YudGKVSsAqeQWM+RO5XlUDTaqf9mBRF23Jc3A/IJpzAdsJ+T
   vl1/i77inQ5FXp+v+BD3W9NQY0xM00pKFXE0NzSJ/d1ZbRDJxCLrD9jfW
   YwnsydCtn6v/BFCm3y5eQZ0FUzS1WuweuIsf9pbN3orMzYS9fK44mbLHX
   OBHFDWMz8TFPZO3bz8KyMXddJF/sanbpHZPFnWjM9al5UzH0t2R92pxx/
   bIAwxg7czU+xbNL04DKO7XMFXJIOCOK3ZGqhHaZ0d9eweup5kXzVGOfRN
   Q==;
X-CSE-ConnectionGUID: ogRZfwJiRdGkkom6/lBavg==
X-CSE-MsgGUID: d+SDG5fZQOCTe/JPS8CXcg==
X-IronPort-AV: E=McAfee;i="6800,10657,11673"; a="69131151"
X-IronPort-AV: E=Sophos;i="6.21,232,1763452800"; 
   d="scan'208";a="69131151"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2026 17:18:08 -0800
X-CSE-ConnectionGUID: /+z504YORU+VnwiO6lsoeA==
X-CSE-MsgGUID: UW7hqU9YRR2jgIAvFDbxCg==
X-ExtLoop1: 1
Received: from 9cc2c43eec6b.jf.intel.com ([10.54.77.43])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2026 17:18:07 -0800
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
Subject: [PATCH 2/7] target/i386: Don't save/restore PERF_GLOBAL_OVF_CTRL MSR
Date: Fri, 16 Jan 2026 17:10:48 -0800
Message-ID: <20260117011053.80723-3-zide.chen@intel.com>
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

From: Dapeng Mi <dapeng1.mi@linux.intel.com>

MSR_CORE_PERF_GLOBAL_OVF_CTRL is a write-only MSR and reads always
return zero.

Saving and restoring this MSR is therefore unnecessary.  Replace
VMSTATE_UINT64 with VMSTATE_UNUSED in the VMStateDescription to ignore
env.msr_global_ovf_ctrl during migration.  This avoids the need to bump
version_id and does not introduce any migration incompatibility.

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Zide Chen <zide.chen@intel.com>
---
 target/i386/cpu.h     | 1 -
 target/i386/kvm/kvm.c | 6 ------
 target/i386/machine.c | 4 ++--
 3 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index f2b79a8bf1dc..0b480c631ed0 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -2086,7 +2086,6 @@ typedef struct CPUArchState {
     uint64_t msr_fixed_ctr_ctrl;
     uint64_t msr_global_ctrl;
     uint64_t msr_global_status;
-    uint64_t msr_global_ovf_ctrl;
     uint64_t msr_fixed_counters[MAX_FIXED_COUNTERS];
     uint64_t msr_gp_counters[MAX_GP_COUNTERS];
     uint64_t msr_gp_evtsel[MAX_GP_COUNTERS];
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 7b9b740a8e5a..cffbc90d1c50 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -4069,8 +4069,6 @@ static int kvm_put_msrs(X86CPU *cpu, KvmPutState level)
             if (has_architectural_pmu_version > 1) {
                 kvm_msr_entry_add(cpu, MSR_CORE_PERF_GLOBAL_STATUS,
                                   env->msr_global_status);
-                kvm_msr_entry_add(cpu, MSR_CORE_PERF_GLOBAL_OVF_CTRL,
-                                  env->msr_global_ovf_ctrl);
 
                 /* Now start the PMU.  */
                 kvm_msr_entry_add(cpu, MSR_CORE_PERF_FIXED_CTR_CTRL,
@@ -4588,7 +4586,6 @@ static int kvm_get_msrs(X86CPU *cpu)
             kvm_msr_entry_add(cpu, MSR_CORE_PERF_FIXED_CTR_CTRL, 0);
             kvm_msr_entry_add(cpu, MSR_CORE_PERF_GLOBAL_CTRL, 0);
             kvm_msr_entry_add(cpu, MSR_CORE_PERF_GLOBAL_STATUS, 0);
-            kvm_msr_entry_add(cpu, MSR_CORE_PERF_GLOBAL_OVF_CTRL, 0);
         }
         for (i = 0; i < num_architectural_pmu_fixed_counters; i++) {
             kvm_msr_entry_add(cpu, MSR_CORE_PERF_FIXED_CTR0 + i, 0);
@@ -4917,9 +4914,6 @@ static int kvm_get_msrs(X86CPU *cpu)
         case MSR_CORE_PERF_GLOBAL_STATUS:
             env->msr_global_status = msrs[i].data;
             break;
-        case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
-            env->msr_global_ovf_ctrl = msrs[i].data;
-            break;
         case MSR_CORE_PERF_FIXED_CTR0 ... MSR_CORE_PERF_FIXED_CTR0 + MAX_FIXED_COUNTERS - 1:
             env->msr_fixed_counters[index - MSR_CORE_PERF_FIXED_CTR0] = msrs[i].data;
             break;
diff --git a/target/i386/machine.c b/target/i386/machine.c
index c9139612813b..1125c8a64ec5 100644
--- a/target/i386/machine.c
+++ b/target/i386/machine.c
@@ -666,7 +666,7 @@ static bool pmu_enable_needed(void *opaque)
     int i;
 
     if (env->msr_fixed_ctr_ctrl || env->msr_global_ctrl ||
-        env->msr_global_status || env->msr_global_ovf_ctrl) {
+        env->msr_global_status) {
         return true;
     }
     for (i = 0; i < MAX_FIXED_COUNTERS; i++) {
@@ -692,7 +692,7 @@ static const VMStateDescription vmstate_msr_architectural_pmu = {
         VMSTATE_UINT64(env.msr_fixed_ctr_ctrl, X86CPU),
         VMSTATE_UINT64(env.msr_global_ctrl, X86CPU),
         VMSTATE_UINT64(env.msr_global_status, X86CPU),
-        VMSTATE_UINT64(env.msr_global_ovf_ctrl, X86CPU),
+        VMSTATE_UNUSED(sizeof(uint64_t)),
         VMSTATE_UINT64_ARRAY(env.msr_fixed_counters, X86CPU, MAX_FIXED_COUNTERS),
         VMSTATE_UINT64_ARRAY(env.msr_gp_counters, X86CPU, MAX_GP_COUNTERS),
         VMSTATE_UINT64_ARRAY(env.msr_gp_evtsel, X86CPU, MAX_GP_COUNTERS),
-- 
2.52.0


