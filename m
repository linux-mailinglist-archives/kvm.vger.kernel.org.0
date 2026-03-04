Return-Path: <kvm+bounces-72723-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yJ6OD/R3qGnpugAAu9opvQ
	(envelope-from <kvm+bounces-72723-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 19:20:36 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D17632062FC
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 19:20:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 3358B3034265
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2026 18:15:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D93F3D5221;
	Wed,  4 Mar 2026 18:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hf/SALo/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 425303D564F
	for <kvm@vger.kernel.org>; Wed,  4 Mar 2026 18:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772648115; cv=none; b=iVxroT4EGDs/N0yYlk95eBi3rP+HZkuJ6ez+zyUuvC7P/cJtmhTZZp5BZplZRT/ANaT6ouH46oK0qgJv4m1Y8JFTNulRb1PR/uvzAg4XiZk7xFa49sI1v9el/M/8WRQYfZKjYgDc8Mk0DKDovu9yOMYyzVZKVvt+ByRd++6QESA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772648115; c=relaxed/simple;
	bh=TXzV5YALbTIXFtN89Y/dKhPioR1OVvAMc+TrUWW9fPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sGb/kOp2S5USPjydZg0I4o78ufAR/A39QI/ujUYQZ3UYsgqCphX1OLNWMBHJRHvHpr2cWjimaviqb88EIaJ6bTJr6kbZ39t5R4YpKNPkPipIp+0Q2BLlFM5whyVStr3tIOpMZqUvi1ZzvRwYoZ4UTIPLTqqcP/n/nTKvKY5Bs4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hf/SALo/; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772648114; x=1804184114;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TXzV5YALbTIXFtN89Y/dKhPioR1OVvAMc+TrUWW9fPg=;
  b=hf/SALo/qiYbd4jd8YpRS07zzsYZAjGUdhsJMeZV5gXG2Pn3r7yQiQ0I
   Il3wlTMTEeZpsTJMfGiesd6fRQ9JbHVYmez6e8+3OCbMZxlusEYUv9FiL
   p74/63GWL0X4jjZx0Vimq80pyDe/3/XJel81iDTi3A99HQnib2BFPSgK0
   YeCPHQ4hc4OAI664SgjjhEeE2gRZVxIiFKpsS08ZayR4HuBwP8ZJf2Ulz
   Am0N2uWjxwcNLWzhh5KELEK7Vfl73oCIXaAOa0awBMKvzrjFC/AWSnT2D
   qRS/FtRBVsFPh2nyhnSk0t5sSGPGaY2SsIOW+s/ZM2EScnzNl9rAN/dX9
   w==;
X-CSE-ConnectionGUID: QwZN6TT4TPucBBd3XDyCZA==
X-CSE-MsgGUID: 9hDTYL06RrOVLofGm0tXCQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11719"; a="73909316"
X-IronPort-AV: E=Sophos;i="6.21,324,1763452800"; 
   d="scan'208";a="73909316"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2026 10:15:13 -0800
X-CSE-ConnectionGUID: hzGDNRoNQ9yj0lykJiXVJA==
X-CSE-MsgGUID: ICWqvXsARmOHbFN2BrLoUQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,324,1763452800"; 
   d="scan'208";a="214542804"
Received: from 9cc2c43eec6b.jf.intel.com ([10.54.77.43])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2026 10:15:12 -0800
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
Subject: [PATCH V3 05/13] target/i386: Support full-width writes for perf counters
Date: Wed,  4 Mar 2026 10:07:04 -0800
Message-ID: <20260304180713.360471-6-zide.chen@intel.com>
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
X-Rspamd-Queue-Id: D17632062FC
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72723-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo,intel.com:dkim,intel.com:email,intel.com:mid]
X-Rspamd-Action: no action

From: Dapeng Mi <dapeng1.mi@linux.intel.com>

If IA32_PERF_CAPABILITIES.FW_WRITE (bit 13) is set, each general-
purpose counter IA32_PMCi (starting at 0xc1) is accompanied by a
corresponding 64-bit alias MSR starting at 0x4c1 (IA32_A_PMC0).

The legacy IA32_PMCi MSRs are not full-width and their effective width
is determined by CPUID.0AH:EAX[23:16].

Since these MSRs are architectural aliases, when IA32_A_PMCi is
supported, these alias MSRs can safely be used for save/restore
instead of the legacy IA32_PMCi MSRs

Full-width write is a user-visible feature and can be disabled
individually.

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Zide Chen <zide.chen@intel.com>
---
V3:
- Move the MAX_GP_COUNTERS change and migrate version ID code to
  [patch v3 4/13] to avoid bumping version IDs twice in one patch
  series.
V2:
- Slightly improve the commit message wording.
- Update the comment for MSR_IA32_PMC0 definition.
---
 target/i386/cpu.h     |  3 +++
 target/i386/kvm/kvm.c | 18 ++++++++++++++++--
 2 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 23d4ee13abfa..7c241a20420c 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -421,6 +421,7 @@ typedef enum X86Seg {
 
 #define MSR_IA32_PERF_CAPABILITIES      0x345
 #define PERF_CAP_LBR_FMT                0x3f
+#define PERF_CAP_FULL_WRITE             (1U << 13)
 
 #define MSR_IA32_TSX_CTRL		0x122
 #define MSR_IA32_TSCDEADLINE            0x6e0
@@ -448,6 +449,8 @@ typedef enum X86Seg {
 #define MSR_IA32_SGXLEPUBKEYHASH3       0x8f
 
 #define MSR_P6_PERFCTR0                 0xc1
+/* Alias MSR range for full-width general-purpose performance counters */
+#define MSR_IA32_PMC0                   0x4c1
 
 #define MSR_IA32_SMBASE                 0x9e
 #define MSR_SMI_COUNT                   0x34
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 144585df5ba6..39a67c58ac22 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -4187,6 +4187,12 @@ static int kvm_put_msrs(X86CPU *cpu, KvmPutState level)
         }
 
         if ((IS_INTEL_CPU(env) || IS_ZHAOXIN_CPU(env)) && pmu_version > 0) {
+            uint32_t perf_cntr_base = MSR_P6_PERFCTR0;
+
+            if (env->features[FEAT_PERF_CAPABILITIES] & PERF_CAP_FULL_WRITE) {
+                perf_cntr_base = MSR_IA32_PMC0;
+            }
+
             if (pmu_version > 1) {
                 /* Stop the counter.  */
                 kvm_msr_entry_add(cpu, MSR_CORE_PERF_FIXED_CTR_CTRL, 0);
@@ -4199,7 +4205,7 @@ static int kvm_put_msrs(X86CPU *cpu, KvmPutState level)
                                   env->msr_fixed_counters[i]);
             }
             for (i = 0; i < num_pmu_gp_counters; i++) {
-                kvm_msr_entry_add(cpu, MSR_P6_PERFCTR0 + i,
+                kvm_msr_entry_add(cpu, perf_cntr_base + i,
                                   env->msr_gp_counters[i]);
                 kvm_msr_entry_add(cpu, MSR_P6_EVNTSEL0 + i,
                                   env->msr_gp_evtsel[i]);
@@ -4761,6 +4767,11 @@ static int kvm_get_msrs(X86CPU *cpu)
     }
 
     if ((IS_INTEL_CPU(env) || IS_ZHAOXIN_CPU(env)) && pmu_version > 0) {
+        uint32_t perf_cntr_base = MSR_P6_PERFCTR0;
+
+        if (env->features[FEAT_PERF_CAPABILITIES] & PERF_CAP_FULL_WRITE) {
+            perf_cntr_base = MSR_IA32_PMC0;
+        }
         if (pmu_version > 1) {
             kvm_msr_entry_add(cpu, MSR_CORE_PERF_FIXED_CTR_CTRL, 0);
             kvm_msr_entry_add(cpu, MSR_CORE_PERF_GLOBAL_CTRL, 0);
@@ -4770,7 +4781,7 @@ static int kvm_get_msrs(X86CPU *cpu)
             kvm_msr_entry_add(cpu, MSR_CORE_PERF_FIXED_CTR0 + i, 0);
         }
         for (i = 0; i < num_pmu_gp_counters; i++) {
-            kvm_msr_entry_add(cpu, MSR_P6_PERFCTR0 + i, 0);
+            kvm_msr_entry_add(cpu, perf_cntr_base + i, 0);
             kvm_msr_entry_add(cpu, MSR_P6_EVNTSEL0 + i, 0);
         }
     }
@@ -5135,6 +5146,9 @@ static int kvm_get_msrs(X86CPU *cpu)
         case MSR_P6_PERFCTR0 ... MSR_P6_PERFCTR0 + MAX_GP_COUNTERS - 1:
             env->msr_gp_counters[index - MSR_P6_PERFCTR0] = msrs[i].data;
             break;
+        case MSR_IA32_PMC0 ... MSR_IA32_PMC0 + MAX_GP_COUNTERS - 1:
+            env->msr_gp_counters[index - MSR_IA32_PMC0] = msrs[i].data;
+            break;
         case MSR_P6_EVNTSEL0 ... MSR_P6_EVNTSEL0 + MAX_GP_COUNTERS - 1:
             env->msr_gp_evtsel[index - MSR_P6_EVNTSEL0] = msrs[i].data;
             break;
-- 
2.53.0


