Return-Path: <kvm+bounces-72720-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mP+MOqx6qGmHuwAAu9opvQ
	(envelope-from <kvm+bounces-72720-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 19:32:12 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4EEF0206639
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 19:32:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 45EB730D77C3
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2026 18:15:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAD0E3D524A;
	Wed,  4 Mar 2026 18:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TYe54S3z"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACB6C1FCFFC
	for <kvm@vger.kernel.org>; Wed,  4 Mar 2026 18:15:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772648111; cv=none; b=Q4/zqmHi46Rz7KzeZEvzYmznmSe3lWWzUSuME5FLSCwKzK+Bokq6Nncahmo1/fuJjYzS5jcxDdSFLFrlqcPbQpMI6enzNDXn2Ao9vH6pkUcz+aZeTNtbUVCjRiPQF1/MmoIIuFoxZqRrct2eI+5oL99cfHQcDMd6NoH3X/tALRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772648111; c=relaxed/simple;
	bh=0GOre7qKpzWJwAVBuNWzorXCo0i/pxRSHUotXKbkydo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ryFo1IHr+mljLi2R71+JI5zu0czsfYT9LMkgxZMbkGCL7bDjU4UpwhPHEWAfI8ouCzz8+UJlhSf3Z7v0CUtv8BT8ymIOObl5J1REGyQlchaWV3Er897kBdMx24bAoOKkKZaihFbf0jFDcBAv1YyGPJS89cjmfieaRQuRyiEpB2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TYe54S3z; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772648110; x=1804184110;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0GOre7qKpzWJwAVBuNWzorXCo0i/pxRSHUotXKbkydo=;
  b=TYe54S3zsvC8wm3x9N8D/iEvZaUNKQA1blN0hMOcDgt+sRpdZ2wlsZF5
   OCGaI433bvbvn6LrTH2V0lpv0fYRlQpv6J1WbzGYs2CTZJKgzeS8onV2j
   GN/3EPz83CbWXogzU9Wk8bZGCzgpiRZcOr0oAVfBL0hQ/aQ3nYLhkFhSv
   eMmCzJ8CJOuMUoNrNjzxJa18/kL0v87vrJCzwcgaHyOckOrhcBN61v5dj
   yCGj3XcJCM96tz+SE20SDAAt6oEJ7wk0D9pukFCICEsQRuHyFQnyvoymg
   xkQnV5wrVQuwOaRfiGQ4uGQzSqmDVmVsGTm/bvF33/b3ZDpfGrM//jNvn
   w==;
X-CSE-ConnectionGUID: lajJN3APQ6qRPyOUaIjyqA==
X-CSE-MsgGUID: MrDnS+UqSiGFxFEkcOpAuA==
X-IronPort-AV: E=McAfee;i="6800,10657,11719"; a="73909294"
X-IronPort-AV: E=Sophos;i="6.21,324,1763452800"; 
   d="scan'208";a="73909294"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2026 10:15:10 -0800
X-CSE-ConnectionGUID: M+LsFPKQQ4uhJhFnuLtQJQ==
X-CSE-MsgGUID: h6EC6ouGTjeGI/QGea5xbQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,324,1763452800"; 
   d="scan'208";a="214542788"
Received: from 9cc2c43eec6b.jf.intel.com ([10.54.77.43])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2026 10:15:09 -0800
From: Zide Chen <zide.chen@intel.com>
To: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Zhao Liu <zhao1.liu@intel.com>,
	Peter Xu <peterx@redhat.com>,
	Fabiano Rosas <farosas@suse.de>,
	Sandipan Das <sandipan.das@amd.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>,
	Dongli Zhang <dongli.zhang@oracle.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Zide Chen <zide.chen@intel.com>
Subject: [PATCH V3 02/13] target/i386: Don't save/restore PERF_GLOBAL_OVF_CTRL MSRs
Date: Wed,  4 Mar 2026 10:07:01 -0800
Message-ID: <20260304180713.360471-3-zide.chen@intel.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260304180713.360471-1-zide.chen@intel.com>
References: <20260304180713.360471-1-zide.chen@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4EEF0206639
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72720-lists,kvm=lfdr.de];
	RCVD_COUNT_FIVE(0.00)[5];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[zide.chen@intel.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	NEURAL_HAM(-0.00)[-1.000];
	DKIM_TRACE(0.00)[intel.com:+];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:dkim,intel.com:email,intel.com:mid,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,amd.com:email,oracle.com:email]
X-Rspamd-Action: no action

From: Dapeng Mi <dapeng1.mi@linux.intel.com>

MSR_CORE_PERF_GLOBAL_OVF_CTRL and MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_CLR
are write-only MSRs and reads always return zero.

Saving and restoring these MSRs is therefore unnecessary.  Replace
VMSTATE_UINT64 with VMSTATE_UNUSED in the VMStateDescription to ignore
env.msr_global_ovf_ctrl during migration.  This avoids the need to bump
version_id and does not introduce any migration incompatibility.

cc: Dongli Zhang <dongli.zhang@oracle.com>
cc: Sandipan Das <sandipan.das@amd.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Co-developed-by: Zide Chen <zide.chen@intel.com>
Signed-off-by: Zide Chen <zide.chen@intel.com>
---
V3:
- Remove MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_CLR.
---
 target/i386/cpu.h     |  3 ---
 target/i386/kvm/kvm.c | 10 ----------
 target/i386/machine.c |  4 ++--
 3 files changed, 2 insertions(+), 15 deletions(-)

diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 016fb1b30bbd..6d3e70395dbd 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -507,11 +507,9 @@ typedef enum X86Seg {
 #define MSR_CORE_PERF_FIXED_CTR_CTRL    0x38d
 #define MSR_CORE_PERF_GLOBAL_STATUS     0x38e
 #define MSR_CORE_PERF_GLOBAL_CTRL       0x38f
-#define MSR_CORE_PERF_GLOBAL_OVF_CTRL   0x390
 
 #define MSR_AMD64_PERF_CNTR_GLOBAL_STATUS       0xc0000300
 #define MSR_AMD64_PERF_CNTR_GLOBAL_CTL          0xc0000301
-#define MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_CLR   0xc0000302
 
 #define MSR_K7_EVNTSEL0                 0xc0010000
 #define MSR_K7_PERFCTR0                 0xc0010004
@@ -2102,7 +2100,6 @@ typedef struct CPUArchState {
     uint64_t msr_fixed_ctr_ctrl;
     uint64_t msr_global_ctrl;
     uint64_t msr_global_status;
-    uint64_t msr_global_ovf_ctrl;
     uint64_t msr_fixed_counters[MAX_FIXED_COUNTERS];
     uint64_t msr_gp_counters[MAX_GP_COUNTERS];
     uint64_t msr_gp_evtsel[MAX_GP_COUNTERS];
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 3b66ec8c42b2..1131c350d352 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -4207,8 +4207,6 @@ static int kvm_put_msrs(X86CPU *cpu, KvmPutState level)
             if (pmu_version > 1) {
                 kvm_msr_entry_add(cpu, MSR_CORE_PERF_GLOBAL_STATUS,
                                   env->msr_global_status);
-                kvm_msr_entry_add(cpu, MSR_CORE_PERF_GLOBAL_OVF_CTRL,
-                                  env->msr_global_ovf_ctrl);
 
                 /* Now start the PMU.  */
                 kvm_msr_entry_add(cpu, MSR_CORE_PERF_FIXED_CTR_CTRL,
@@ -4252,8 +4250,6 @@ static int kvm_put_msrs(X86CPU *cpu, KvmPutState level)
             if (pmu_version > 1) {
                 kvm_msr_entry_add(cpu, MSR_AMD64_PERF_CNTR_GLOBAL_STATUS,
                                   env->msr_global_status);
-                kvm_msr_entry_add(cpu, MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_CLR,
-                                  env->msr_global_ovf_ctrl);
                 kvm_msr_entry_add(cpu, MSR_AMD64_PERF_CNTR_GLOBAL_CTL,
                                   env->msr_global_ctrl);
             }
@@ -4769,7 +4765,6 @@ static int kvm_get_msrs(X86CPU *cpu)
             kvm_msr_entry_add(cpu, MSR_CORE_PERF_FIXED_CTR_CTRL, 0);
             kvm_msr_entry_add(cpu, MSR_CORE_PERF_GLOBAL_CTRL, 0);
             kvm_msr_entry_add(cpu, MSR_CORE_PERF_GLOBAL_STATUS, 0);
-            kvm_msr_entry_add(cpu, MSR_CORE_PERF_GLOBAL_OVF_CTRL, 0);
         }
         for (i = 0; i < num_pmu_fixed_counters; i++) {
             kvm_msr_entry_add(cpu, MSR_CORE_PERF_FIXED_CTR0 + i, 0);
@@ -4812,7 +4807,6 @@ static int kvm_get_msrs(X86CPU *cpu)
         if (pmu_version > 1) {
             kvm_msr_entry_add(cpu, MSR_AMD64_PERF_CNTR_GLOBAL_CTL, 0);
             kvm_msr_entry_add(cpu, MSR_AMD64_PERF_CNTR_GLOBAL_STATUS, 0);
-            kvm_msr_entry_add(cpu, MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_CLR, 0);
         }
     }
 
@@ -5135,10 +5129,6 @@ static int kvm_get_msrs(X86CPU *cpu)
         case MSR_AMD64_PERF_CNTR_GLOBAL_STATUS:
             env->msr_global_status = msrs[i].data;
             break;
-        case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
-        case MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_CLR:
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
2.53.0


