Return-Path: <kvm+bounces-69431-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AhDjL0+ZemnZ8QEAu9opvQ
	(envelope-from <kvm+bounces-69431-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 00:18:39 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 20E40A9EA0
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 00:18:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 90DA7304E311
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 23:17:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0689F345736;
	Wed, 28 Jan 2026 23:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nr2oCLy4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B60E333123C
	for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 23:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769642261; cv=none; b=sSATP6DvfhptjllvkCN6G6Va8VLIgjnWBCMC2CPJ0kAnrvfwPoJHMVOHpCeRMp+YSFgOjtIsBiKo8B1FFB77QGVBR1pcRHTQn/pu1mjPgoUxUrJSjzDYUcRLDQM7/6N3qmr64TA9BJYA2Ho/oUyMlo+tFKDNHeJaQXqkGtrxB6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769642261; c=relaxed/simple;
	bh=+awSK6wqynaFUARSToROBiJ71pQVspy2QEWKMVFoHg8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gp1/JINMyXmxVfndZP7G2fBUe1iHBzf4MchkG4GPqDpEM01MWzhA7Ua3KLA9Y3IPhRIqmoQ84/zdw/C5Qd4M9mfhJ4WoTVrWV3dMOG0Jz/MWWxFkhaJmLB74MWa9DCae9IjzoQXMOLmKeE0LbQq3X9sr/xq6vHT4N35VO7oWMoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nr2oCLy4; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769642260; x=1801178260;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+awSK6wqynaFUARSToROBiJ71pQVspy2QEWKMVFoHg8=;
  b=nr2oCLy4iLkQ473HSq0NI1gZOfQs1IXKa0WO8J/G+GhCU9L24kwI8wIl
   CvUcaz0aiRhBNTH9pKM01AGVhUt4AOjYjmwI56fgpId0mZNilPai24ctA
   bBjWWSpWR8U69BpsrSq/PokK58az1Nb7Ppcob8lhaVGo/NXAPCGfh/Ybc
   6qx9Zfzz4Xj9WC26sRO7VuUXQO8OurwrM3gGYYYohh5GvSCceou63HYGW
   B3eXW9xw2sro1QgArdnZev8UkdmieiHYuip/lxLt6h0KynPKKNJH5Jv3u
   y0q7AJHWftCxOD4rliGdpXI2YFZL20DZUoUioNYsy7C64kWK+DTrtnTFu
   w==;
X-CSE-ConnectionGUID: KyiZklw8RzKOcvSopDlWYQ==
X-CSE-MsgGUID: UtfddQfCTbGodNKT+VzXKw==
X-IronPort-AV: E=McAfee;i="6800,10657,11685"; a="73462317"
X-IronPort-AV: E=Sophos;i="6.21,258,1763452800"; 
   d="scan'208";a="73462317"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2026 15:17:39 -0800
X-CSE-ConnectionGUID: QQvBP4kiTpykiVbyP/BrTQ==
X-CSE-MsgGUID: ncoN2kERSCaQLjeOvJY2MA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,258,1763452800"; 
   d="scan'208";a="208001766"
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
Subject: [PATCH V2 03/11] target/i386: Gate enable_pmu on kvm_enabled()
Date: Wed, 28 Jan 2026 15:09:40 -0800
Message-ID: <20260128231003.268981-4-zide.chen@intel.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69431-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,intel.com:email,intel.com:dkim,intel.com:mid]
X-Rspamd-Queue-Id: 20E40A9EA0
X-Rspamd-Action: no action

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

Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Zide Chen <zide.chen@intel.com>
---
V2:
- Replace a tab with spaces.

 target/i386/cpu.c     | 9 ++++++---
 target/i386/kvm/kvm.c | 4 ++--
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 37803cd72490..d3e9d3c40b0a 100644
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
+        cpu->enable_pmu = false;
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


