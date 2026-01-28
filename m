Return-Path: <kvm+bounces-69432-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WOTJDSCZemms8QEAu9opvQ
	(envelope-from <kvm+bounces-69432-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 00:17:52 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 60072A9E61
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 00:17:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 6330E3006D5E
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 23:17:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B122344D9F;
	Wed, 28 Jan 2026 23:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="H5lZ6LWu"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1345D33F8B1
	for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 23:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769642261; cv=none; b=j+jR6pbInCdIqSblvr1kGG0cJSnk4fM2ubqJrKMtp8vdOqMQmyASnsMRxORbll6ia8W8BAHPn2SCpSpnM2sKBw921rT2III/jASPSjEDTdhSSbIJSdOMELY/nC+Uu9HtR4iWSQPuJXwsl0pBw68kKmCrEhNy8AkyKXChvTsX1tc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769642261; c=relaxed/simple;
	bh=HxDTwFKOJhQLc+r8or/GUZgVFaHsSGDANaOspCSeX0w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hfSJV6wVwsbyXkOOjuWPivJUeCvjECMnPztBuoNBtLmCJk3fxRhaSget0k9D6LpPBLJ72lDR6Q4UrLyGvjReNySDrz3hUKsW1WjYDf6DBnw9Q24QPQhw6VH0QwpMm6X+MWUTpdJlWaJzJ5LaVjpkuuxOE0QWp4G1crpRxIeJVuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=H5lZ6LWu; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769642260; x=1801178260;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HxDTwFKOJhQLc+r8or/GUZgVFaHsSGDANaOspCSeX0w=;
  b=H5lZ6LWu+xIgWzzzVn/MW0ZTfO4nV+RuDBPK+U+FGcgC/1Wa7vfq+8YP
   i6qtDXbm6DRp2dfhloFHcHFzZEK9KH6+RqDMhszSiif7+/ApD+LCxqjrf
   5MPsYK1CIXj2bQzFf/loSx0gDNTNBt7SGC1HEQRJ5TxzkWUvOzYjMMpi2
   FtfzqL4QHoS9OPc59/ZbqNsbdv7EXJ+D3tzwoGQhUXsextcTnKC7tTrVy
   Nb2EsAk+RBQ7895WjCfjis8EdMGcnM/w8A7CG2opeIY+aj0P/3znAuI3a
   FMKLt7N8e9hyVwuPpk2XIRQjXAu56WHrFg6O94MYqQL6lyhObK5pNoSmE
   Q==;
X-CSE-ConnectionGUID: 8PS4XU+BTyW2OA1KP+jXxw==
X-CSE-MsgGUID: gkVnYCbORcOg8/hs5UcIbQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11685"; a="73462321"
X-IronPort-AV: E=Sophos;i="6.21,258,1763452800"; 
   d="scan'208";a="73462321"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2026 15:17:39 -0800
X-CSE-ConnectionGUID: Hh8IxSJ1SCu0vF0FTVPKpA==
X-CSE-MsgGUID: UoNBvUz8QoGKlSt0qHQIzQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,258,1763452800"; 
   d="scan'208";a="208001769"
Received: from 9cc2c43eec6b.jf.intel.com ([10.54.77.43])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2026 15:17:38 -0800
From: Zide Chen <zide.chen@intel.com>
To: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Zhao Liu <zhao1.liu@intel.com>,
	Peter Xu <peterx@redhat.com>,
	Fabiano Rosas <farosas@suse.de>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>,
	Dongli Zhang <dongli.zhang@oracle.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Zide Chen <zide.chen@intel.com>
Subject: [PATCH V2 04/11] target/i386: Support full-width writes for perf counters
Date: Wed, 28 Jan 2026 15:09:41 -0800
Message-ID: <20260128231003.268981-5-zide.chen@intel.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128231003.268981-1-zide.chen@intel.com>
References: <20260128231003.268981-1-zide.chen@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69432-lists,kvm=lfdr.de];
	RCVD_COUNT_FIVE(0.00)[5];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[zide.chen@intel.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[10];
	NEURAL_HAM(-0.00)[-1.000];
	DKIM_TRACE(0.00)[intel.com:+];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,intel.com:email,intel.com:dkim,intel.com:mid]
X-Rspamd-Queue-Id: 60072A9E61
X-Rspamd-Action: no action

From: Dapeng Mi <dapeng1.mi@linux.intel.com>

If IA32_PERF_CAPABILITIES.FW_WRITE (bit 13) is set, each general-
purpose counter IA32_PMCi (starting at 0xc1) is accompanied by a
corresponding 64-bit alias MSR starting at 0x4c1 (IA32_A_PMC0).

The legacy IA32_PMCi MSRs are not full-width and their effective width
is determined by CPUID.0AH:EAX[23:16].

Since these MSRs are architectural aliases, when IA32_A_PMCi is
supported it is safe to use it for save/restore instead of the legacy
IA32_PMCi MSRs.

Full-width write is a user-visible feature and can be disabled
individually.

Reduce MAX_GP_COUNTERS from 18 to 15 to avoid conflicts between the
full-width MSR range and MSR_MCG_EXT_CTL.  Current CPUs support at most
10 general-purpose counters, so 15 is sufficient for now and leaves room
for future expansion.

Bump minimum_version_id to avoid migration from older QEMU, as this may
otherwise cause VMState overflow. This also requires bumping version_id,
which prevents migration to older QEMU as well.

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Zide Chen <zide.chen@intel.com>
---
V2:
- Slightly improve the commit message wording.
- Update the comment for MSR_IA32_PMC0 definition.

 target/i386/cpu.h     |  5 ++++-
 target/i386/kvm/kvm.c | 19 +++++++++++++++++--
 target/i386/machine.c |  4 ++--
 3 files changed, 23 insertions(+), 5 deletions(-)

diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index f6e9b274e2ff..812d53e22c41 100644
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
@@ -1740,7 +1743,7 @@ typedef struct {
 #endif
 
 #define MAX_FIXED_COUNTERS 3
-#define MAX_GP_COUNTERS    (MSR_IA32_PERF_STATUS - MSR_P6_EVNTSEL0)
+#define MAX_GP_COUNTERS    15
 
 #define NB_OPMASK_REGS 8
 
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index e81fa46ed66c..530f50e4b218 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -4049,6 +4049,12 @@ static int kvm_put_msrs(X86CPU *cpu, KvmPutState level)
         }
 
         if (has_architectural_pmu_version > 0) {
+            uint32_t perf_cntr_base = MSR_P6_PERFCTR0;
+
+            if (env->features[FEAT_PERF_CAPABILITIES] & PERF_CAP_FULL_WRITE) {
+                perf_cntr_base = MSR_IA32_PMC0;
+            }
+
             if (has_architectural_pmu_version > 1) {
                 /* Stop the counter.  */
                 kvm_msr_entry_add(cpu, MSR_CORE_PERF_FIXED_CTR_CTRL, 0);
@@ -4061,7 +4067,7 @@ static int kvm_put_msrs(X86CPU *cpu, KvmPutState level)
                                   env->msr_fixed_counters[i]);
             }
             for (i = 0; i < num_architectural_pmu_gp_counters; i++) {
-                kvm_msr_entry_add(cpu, MSR_P6_PERFCTR0 + i,
+                kvm_msr_entry_add(cpu, perf_cntr_base + i,
                                   env->msr_gp_counters[i]);
                 kvm_msr_entry_add(cpu, MSR_P6_EVNTSEL0 + i,
                                   env->msr_gp_evtsel[i]);
@@ -4582,6 +4588,12 @@ static int kvm_get_msrs(X86CPU *cpu)
         kvm_msr_entry_add(cpu, MSR_KVM_POLL_CONTROL, 1);
     }
     if (has_architectural_pmu_version > 0) {
+        uint32_t perf_cntr_base = MSR_P6_PERFCTR0;
+
+        if (env->features[FEAT_PERF_CAPABILITIES] & PERF_CAP_FULL_WRITE) {
+            perf_cntr_base = MSR_IA32_PMC0;
+        }
+
         if (has_architectural_pmu_version > 1) {
             kvm_msr_entry_add(cpu, MSR_CORE_PERF_FIXED_CTR_CTRL, 0);
             kvm_msr_entry_add(cpu, MSR_CORE_PERF_GLOBAL_CTRL, 0);
@@ -4591,7 +4603,7 @@ static int kvm_get_msrs(X86CPU *cpu)
             kvm_msr_entry_add(cpu, MSR_CORE_PERF_FIXED_CTR0 + i, 0);
         }
         for (i = 0; i < num_architectural_pmu_gp_counters; i++) {
-            kvm_msr_entry_add(cpu, MSR_P6_PERFCTR0 + i, 0);
+            kvm_msr_entry_add(cpu, perf_cntr_base + i, 0);
             kvm_msr_entry_add(cpu, MSR_P6_EVNTSEL0 + i, 0);
         }
     }
@@ -4920,6 +4932,9 @@ static int kvm_get_msrs(X86CPU *cpu)
         case MSR_P6_PERFCTR0 ... MSR_P6_PERFCTR0 + MAX_GP_COUNTERS - 1:
             env->msr_gp_counters[index - MSR_P6_PERFCTR0] = msrs[i].data;
             break;
+        case MSR_IA32_PMC0 ... MSR_IA32_PMC0 + MAX_GP_COUNTERS - 1:
+            env->msr_gp_counters[index - MSR_IA32_PMC0] = msrs[i].data;
+            break;
         case MSR_P6_EVNTSEL0 ... MSR_P6_EVNTSEL0 + MAX_GP_COUNTERS - 1:
             env->msr_gp_evtsel[index - MSR_P6_EVNTSEL0] = msrs[i].data;
             break;
diff --git a/target/i386/machine.c b/target/i386/machine.c
index 1125c8a64ec5..7d08a05835fc 100644
--- a/target/i386/machine.c
+++ b/target/i386/machine.c
@@ -685,8 +685,8 @@ static bool pmu_enable_needed(void *opaque)
 
 static const VMStateDescription vmstate_msr_architectural_pmu = {
     .name = "cpu/msr_architectural_pmu",
-    .version_id = 1,
-    .minimum_version_id = 1,
+    .version_id = 2,
+    .minimum_version_id = 2,
     .needed = pmu_enable_needed,
     .fields = (const VMStateField[]) {
         VMSTATE_UINT64(env.msr_fixed_ctr_ctrl, X86CPU),
-- 
2.52.0


