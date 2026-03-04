Return-Path: <kvm+bounces-72731-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aLEeLDN6qGl0uwAAu9opvQ
	(envelope-from <kvm+bounces-72731-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 19:30:11 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1594E2065B9
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 19:30:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9229531E25D2
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2026 18:16:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 808133D1CD5;
	Wed,  4 Mar 2026 18:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FHbMeaqt"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52E3B3D5228
	for <kvm@vger.kernel.org>; Wed,  4 Mar 2026 18:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772648129; cv=none; b=t7XzKMmxt3Joop0ky3AhaiPqJvFS+M0wKc+hn7D83mcVcGUXw4GoE982gkXuMOcbcoGwOwHsi2VfNCNrZNC081m2AuAnXQkTHL9Y5JBYmh2M2fz1iZyPKdHmAPH5qFOt4uqSUzufhlcGWB/f1275j9p6p3jeuqzDn3oMi4BB8Cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772648129; c=relaxed/simple;
	bh=VZJX/cbeax9wgy2Ci5nCoiNVdgNf6qrvDnITxrEY52M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o1KMN+a0+aIaNOvRLzgC+nPDCPuNaGwOtdEEnzNLWqA838Mpm9NXoWXZxIVdNIPNDTZvD+O8u7GRErlkokZNruN2mMVhu8tdWpLpLQA4pMMRh07FQUWXhJXW5MvcjNGX5j3oXnWvvx+Fh8vRzDIRBRPQYyBYaZt4Rk4EDXf24jM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FHbMeaqt; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772648127; x=1804184127;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VZJX/cbeax9wgy2Ci5nCoiNVdgNf6qrvDnITxrEY52M=;
  b=FHbMeaqtLOeni7XR9FthOWFyh35EiqNKFj/M5aekIvq6Dcp05IVffU7v
   M3gGotN22JwXk+8NT/bo7dPr1PmqGRSOlm9k610Mbqnq4CpzVzAehdZ7j
   GCd5uW8a9nWa8bV7mf+UOzFJsd7yf1o4jYOGnONHsTSkUIrry8FHBTEF/
   xNXFPhkfaGq/GrQG9j74DvDGFsefV2p9dYJy52E67Ut9/s3QGqJxQvXzi
   +tx3UqnzXgpVXlKq6WtcLvaGJr8IKOJ2E9gOqM7AYK1bYaN/wb2IoEBg3
   ysLXlkOP4wUqXkQbeatkEZDLHgrrRw3duvPMPnzYFL0Lyc1W5aBxj+swa
   g==;
X-CSE-ConnectionGUID: IqhLYiFzQNqkHZkakDMtkg==
X-CSE-MsgGUID: EY6KFf+OSXC1VUUpkzhhOg==
X-IronPort-AV: E=McAfee;i="6800,10657,11719"; a="73909404"
X-IronPort-AV: E=Sophos;i="6.21,324,1763452800"; 
   d="scan'208";a="73909404"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2026 10:15:26 -0800
X-CSE-ConnectionGUID: Yn6q0i+jQ4yfIrXTiqiRsQ==
X-CSE-MsgGUID: wgySaHQIR42rBkpgqzh75g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,324,1763452800"; 
   d="scan'208";a="214542866"
Received: from 9cc2c43eec6b.jf.intel.com ([10.54.77.43])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2026 10:15:25 -0800
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
Subject: [PATCH V3 13/13] target/i386: Add Topdown metrics feature support
Date: Wed,  4 Mar 2026 10:07:12 -0800
Message-ID: <20260304180713.360471-14-zide.chen@intel.com>
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
X-Rspamd-Queue-Id: 1594E2065B9
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
	TAGGED_FROM(0.00)[bounces-72731-lists,kvm=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,intel.com:dkim,intel.com:email,intel.com:mid]
X-Rspamd-Action: no action

From: Dapeng Mi <dapeng1.mi@linux.intel.com>

IA32_PERF_CAPABILITIES.PERF_METRICS_AVAILABLE (bit 15) indicates that
the CPU provides built-in support for TMA L1 metrics through
the PERF_METRICS MSR.  Expose it as a user-visible CPU feature
("perf-metrics"), allowing it to be explicitly enabled or disabled and
used with migratable guests.

Plumb IA32_PERF_METRICS through the KVM MSR get/put paths to be able
to save and restore this MSR.

Migrate IA32_PERF_METRICS MSR using a new subsection of
vmstate_msr_architectural_pmu.

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Co-developed-by: Zide Chen <zide.chen@intel.com>
Signed-off-by: Zide Chen <zide.chen@intel.com>
---
V3: New patch
---
 target/i386/cpu.c     |  2 +-
 target/i386/cpu.h     |  3 +++
 target/i386/kvm/kvm.c | 10 ++++++++++
 target/i386/machine.c | 19 +++++++++++++++++++
 4 files changed, 33 insertions(+), 1 deletion(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 3ff9f76cf7da..88cfd3529851 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -1620,7 +1620,7 @@ FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
             NULL, NULL, NULL, NULL,
             NULL, NULL, "pebs-trap", "pebs-arch-reg",
             NULL, NULL, NULL, NULL,
-            NULL, "full-width-write", "pebs-baseline", NULL,
+            NULL, "full-width-write", "pebs-baseline", "perf-metrics",
             NULL, "pebs-timing-info", NULL, NULL,
             NULL, NULL, NULL, NULL,
             NULL, NULL, NULL, NULL,
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 6a9820c4041a..5d0ed692ae06 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -428,6 +428,7 @@ typedef enum X86Seg {
                                          PERF_CAP_PEBS_FMT_SHIFT)
 #define PERF_CAP_FULL_WRITE             (1U << 13)
 #define PERF_CAP_PEBS_BASELINE          (1U << 14)
+#define PERF_CAP_TOPDOWN                (1U << 15)
 
 #define MSR_IA32_TSX_CTRL		0x122
 #define MSR_IA32_TSCDEADLINE            0x6e0
@@ -514,6 +515,7 @@ typedef enum X86Seg {
 #define MSR_CORE_PERF_FIXED_CTR0        0x309
 #define MSR_CORE_PERF_FIXED_CTR1        0x30a
 #define MSR_CORE_PERF_FIXED_CTR2        0x30b
+#define MSR_PERF_METRICS                0x329
 #define MSR_CORE_PERF_FIXED_CTR_CTRL    0x38d
 #define MSR_CORE_PERF_GLOBAL_STATUS     0x38e
 #define MSR_CORE_PERF_GLOBAL_CTRL       0x38f
@@ -2111,6 +2113,7 @@ typedef struct CPUArchState {
     uint64_t msr_fixed_ctr_ctrl;
     uint64_t msr_global_ctrl;
     uint64_t msr_global_status;
+    uint64_t msr_perf_metrics;
     uint64_t msr_ds_area;
     uint64_t msr_pebs_data_cfg;
     uint64_t msr_pebs_enable;
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 8c4564bcbb9e..3f533cd65708 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -4295,6 +4295,10 @@ static int kvm_put_msrs(X86CPU *cpu, KvmPutState level)
                 kvm_msr_entry_add(cpu, MSR_CORE_PERF_FIXED_CTR0 + i,
                                   env->msr_fixed_counters[i]);
             }
+            /* SDM: Write IA32_PERF_METRICS after fixed counter 3. */
+            if (env->features[FEAT_PERF_CAPABILITIES] & PERF_CAP_TOPDOWN) {
+                    kvm_msr_entry_add(cpu, MSR_PERF_METRICS, env->msr_perf_metrics);
+            }
             for (i = 0; i < num_pmu_gp_counters; i++) {
                 kvm_msr_entry_add(cpu, perf_cntr_base + i,
                                   env->msr_gp_counters[i]);
@@ -4868,6 +4872,9 @@ static int kvm_get_msrs(X86CPU *cpu)
             kvm_msr_entry_add(cpu, MSR_CORE_PERF_GLOBAL_CTRL, 0);
             kvm_msr_entry_add(cpu, MSR_CORE_PERF_GLOBAL_STATUS, 0);
         }
+        if (env->features[FEAT_PERF_CAPABILITIES] & PERF_CAP_TOPDOWN) {
+            kvm_msr_entry_add(cpu, MSR_PERF_METRICS, 0);
+        }
         for (i = 0; i < num_pmu_fixed_counters; i++) {
             kvm_msr_entry_add(cpu, MSR_CORE_PERF_FIXED_CTR0 + i, 0);
         }
@@ -5234,6 +5241,9 @@ static int kvm_get_msrs(X86CPU *cpu)
         case MSR_AMD64_PERF_CNTR_GLOBAL_STATUS:
             env->msr_global_status = msrs[i].data;
             break;
+        case MSR_PERF_METRICS:
+            env->msr_perf_metrics = msrs[i].data;
+            break;
         case MSR_CORE_PERF_FIXED_CTR0 ... MSR_CORE_PERF_FIXED_CTR0 + MAX_FIXED_COUNTERS - 1:
             env->msr_fixed_counters[index - MSR_CORE_PERF_FIXED_CTR0] = msrs[i].data;
             break;
diff --git a/target/i386/machine.c b/target/i386/machine.c
index 5cff5d5a9db5..6b7141cfead7 100644
--- a/target/i386/machine.c
+++ b/target/i386/machine.c
@@ -680,6 +680,24 @@ static const VMStateDescription vmstate_msr_ds_pebs = {
         VMSTATE_END_OF_LIST()}
 };
 
+static bool perf_metrics_enabled(void *opaque)
+{
+    X86CPU *cpu = opaque;
+    CPUX86State *env = &cpu->env;
+
+    return !!env->msr_perf_metrics;
+}
+
+static const VMStateDescription vmstate_msr_perf_metrics = {
+    .name = "cpu/msr_architectural_pmu/msr_perf_metrics",
+    .version_id = 1,
+    .minimum_version_id = 1,
+    .needed = perf_metrics_enabled,
+    .fields = (const VMStateField[]){
+        VMSTATE_UINT64(env.msr_perf_metrics, X86CPU),
+        VMSTATE_END_OF_LIST()}
+};
+
 static bool pmu_enable_needed(void *opaque)
 {
     X86CPU *cpu = opaque;
@@ -721,6 +739,7 @@ static const VMStateDescription vmstate_msr_architectural_pmu = {
     },
     .subsections = (const VMStateDescription * const []) {
         &vmstate_msr_ds_pebs,
+        &vmstate_msr_perf_metrics,
         NULL,
     },
 };
-- 
2.53.0


