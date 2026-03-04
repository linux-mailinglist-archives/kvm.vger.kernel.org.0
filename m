Return-Path: <kvm+bounces-72729-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0C1HAd16qGmHuwAAu9opvQ
	(envelope-from <kvm+bounces-72729-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 19:33:01 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 57C14206665
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 19:33:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3230B3042087
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2026 18:16:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 843E63DA5A5;
	Wed,  4 Mar 2026 18:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="I4Wumsp5"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC9F43CF698
	for <kvm@vger.kernel.org>; Wed,  4 Mar 2026 18:15:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772648128; cv=none; b=Q5yBcqVh3nWAtPBGdvLiuhegLVMxwZo+uDfQdViEZ9ouUUoux+xd1LaIp2saHELRJ8JaPt1RPKxMNrgHOdgmKrEozWVlEJmZ12c4zdKQbvwe9i6AhbFox/JU7XekOUjSLDiQHzZ4vrYln6EfVT9eBCrV4i7L5WoeUo/XPoky7gg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772648128; c=relaxed/simple;
	bh=Nqn9+/IeRnwRhn8vdFZLmIj8U3Mq5+pWQSK7f2G+5Z4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m/ns4HIVWuCE0woWnDh2xrKv/+IeEpXYGqWmQoxhfjgMdGuJI0At9EOR8dsAd6Rj1eT80mmLSjo6e1daJlSAxue+QC8egKRPNJYKCkHRzXH5A/lwryX1KovHBz3LhWx7lyVYSa6FZav8hmDDvWfbl6Wn8dN4D4sD6DmdmlPK/6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=I4Wumsp5; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772648125; x=1804184125;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Nqn9+/IeRnwRhn8vdFZLmIj8U3Mq5+pWQSK7f2G+5Z4=;
  b=I4Wumsp5SkitacRTiieP6f6TV9dvUQHaY/kTwhB5c+RPnSOQdfzvPyL7
   HgLCWWZI/leIZhFR5omnkyU9mX+M60e0rasuQRjaR4mQsDWhinbQeQEyN
   rs7N7BR0DvsBKPlNQbJ7NRLk1pLTj99q6YaN0e6NYHsxLYtcmqtNq1TE8
   v3Ohgjl8aMBrhaIWzOBYy0ZJIpojDFn769ACCVYFbVc//Ch+mclo6qpAE
   2EpuO32ptV3Y6Gh1udbX3OKo8rZxMp10FQwqG8xe1mw5eeUb2RX/IlTif
   CPPaFX1PB+gYW1BuNvgs4fQUxt6GRRcX1/ChJLwaL4/lcY3LKC9Pf2Uq8
   g==;
X-CSE-ConnectionGUID: LfOk9RqwRde4PMqAnaHN3g==
X-CSE-MsgGUID: VxVdJQ0nQRKz0pMh22YJOw==
X-IronPort-AV: E=McAfee;i="6800,10657,11719"; a="73909390"
X-IronPort-AV: E=Sophos;i="6.21,324,1763452800"; 
   d="scan'208";a="73909390"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2026 10:15:24 -0800
X-CSE-ConnectionGUID: 1/HGIhLtRyuq3BW4KwY8DA==
X-CSE-MsgGUID: yWizD7/3QUyE4Fp3mytiCQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,324,1763452800"; 
   d="scan'208";a="214542851"
Received: from 9cc2c43eec6b.jf.intel.com ([10.54.77.43])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2026 10:15:23 -0800
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
Subject: [PATCH V3 11/13] target/i386: Add pebs-fmt CPU option
Date: Wed,  4 Mar 2026 10:07:10 -0800
Message-ID: <20260304180713.360471-12-zide.chen@intel.com>
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
X-Rspamd-Queue-Id: 57C14206665
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72729-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,intel.com:dkim,intel.com:email,intel.com:mid]
X-Rspamd-Action: no action

Similar to lbr-fmt, target/i386 does not support multi-bit CPU
properties, so the PEBS record format cannot be exposed as a
user-visible CPU feature.

Add a pebs-fmt option to allow users to specify the PEBS format via the
command line.  Since the PEBS state is part of the vmstate, this option
is considered migratable.

We do not support PEBS record format 0.  Although it is a valid format
on some very old CPUs, it is unlikely to be used in practice.  This
allows pebs-fmt=0 to be used to explicitly disable PEBS in the case of
migratable=off.

If PEBS is not enabled, mark it as unavailable in IA32_MISC_ENABLE and
clear the PEBS-related bits in IA32_PERF_CAPABILITIES.

If migratable=on on PEBS capable host and pmu is enabled:
- PEBS is disabled if pebs-fmt is not specified or pebs-fmt=0.
- PEBS is enabled if pebs-fmt is set to the same value as the host.

When migratable=off, the behavior is similar, except that omitting
the pebs-fmt option does not disable PEBS.

Signed-off-by: Zide Chen <zide.chen@intel.com>
---
V3:
- If DS is not available, make this option invalid.
- If pebs_fmt is 0, mark PEBS unavailable.
- Move MSR_IA32_MISC_ENABLE_PEBS_UNAVAIL code from [patch v2 11/11] to
  this patch for tighter logic.
- Add option usage to commit message.

V2: New patch.
---
 target/i386/cpu.c         | 23 ++++++++++++++++++++++-
 target/i386/cpu.h         |  7 +++++++
 target/i386/kvm/kvm-cpu.c |  1 +
 3 files changed, 30 insertions(+), 1 deletion(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index d5e00b41fb04..2e1dea65d708 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -9170,6 +9170,13 @@ static void x86_cpu_reset_hold(Object *obj, ResetType type)
         env->msr_ia32_misc_enable |= MSR_IA32_MISC_ENABLE_MWAIT;
     }
 
+    if (!(env->features[FEAT_1_EDX] & CPUID_DTS) ||
+	!(env->features[FEAT_PERF_CAPABILITIES] & PERF_CAP_PEBS_FORMAT)) {
+        /* Mark PEBS unavailable and clear all PEBS related bits. */
+        env->msr_ia32_misc_enable |= MSR_IA32_MISC_ENABLE_PEBS_UNAVAIL;
+        env->features[FEAT_PERF_CAPABILITIES] &= ~0x34fc0ull;
+    }
+
     memset(env->dr, 0, sizeof(env->dr));
     env->dr[6] = DR6_FIXED_1;
     env->dr[7] = DR7_FIXED_1;
@@ -9784,10 +9791,17 @@ static bool x86_cpu_apply_lbr_pebs_fmt(X86CPU *cpu, uint64_t host_perf_cap,
         shift = PERF_CAP_LBR_FMT_SHIFT;
         name = "lbr";
     } else {
-        return false;
+        mask = PERF_CAP_PEBS_FMT_MASK;
+        shift = PERF_CAP_PEBS_FMT_SHIFT;
+        name = "pebs";
     }
 
     if (user_req != -1) {
+        if (!is_lbr_fmt && !(env->features[FEAT_1_EDX] & CPUID_DTS)) {
+            error_setg(errp, "vPMU: %s is unsupported without Debug Store", name);
+            return false;
+        }
+
         env->features[FEAT_PERF_CAPABILITIES] &= ~(mask << shift);
         env->features[FEAT_PERF_CAPABILITIES] |= (user_req << shift);
     }
@@ -9825,6 +9839,11 @@ static int x86_cpu_pmu_realize(X86CPU *cpu, Error **errp)
         return -EINVAL;
     }
 
+    if (!x86_cpu_apply_lbr_pebs_fmt(cpu, host_perf_cap,
+                                    cpu->pebs_fmt, false, errp)) {
+        return -EINVAL;
+    }
+
     return 0;
 }
 
@@ -10291,6 +10310,7 @@ static void x86_cpu_initfn(Object *obj)
 
     object_property_add_alias(obj, "hv-apicv", obj, "hv-avic");
     object_property_add_alias(obj, "lbr_fmt", obj, "lbr-fmt");
+    object_property_add_alias(obj, "pebs_fmt", obj, "pebs-fmt");
 
     if (xcc->model) {
         x86_cpu_load_model(cpu, xcc->model);
@@ -10462,6 +10482,7 @@ static const Property x86_cpu_properties[] = {
     DEFINE_PROP_INT32("node-id", X86CPU, node_id, CPU_UNSET_NUMA_NODE_ID),
     DEFINE_PROP_BOOL("pmu", X86CPU, enable_pmu, false),
     DEFINE_PROP_UINT64_CHECKMASK("lbr-fmt", X86CPU, lbr_fmt, PERF_CAP_LBR_FMT_MASK),
+    DEFINE_PROP_UINT64_CHECKMASK("pebs-fmt", X86CPU, pebs_fmt, PERF_CAP_PEBS_FMT_MASK),
 
     DEFINE_PROP_UINT32("hv-spinlocks", X86CPU, hyperv_spinlock_attempts,
                        HYPERV_SPINLOCK_NEVER_NOTIFY),
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index a064bf8ab17e..6a9820c4041a 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -422,6 +422,10 @@ typedef enum X86Seg {
 #define MSR_IA32_PERF_CAPABILITIES      0x345
 #define PERF_CAP_LBR_FMT_MASK           0x3f
 #define PERF_CAP_LBR_FMT_SHIFT          0x0
+#define PERF_CAP_PEBS_FMT_MASK          0xf
+#define PERF_CAP_PEBS_FMT_SHIFT         0x8
+#define PERF_CAP_PEBS_FORMAT            (PERF_CAP_PEBS_FMT_MASK << \
+                                         PERF_CAP_PEBS_FMT_SHIFT)
 #define PERF_CAP_FULL_WRITE             (1U << 13)
 #define PERF_CAP_PEBS_BASELINE          (1U << 14)
 
@@ -2410,6 +2414,9 @@ struct ArchCPU {
      */
     uint64_t lbr_fmt;
 
+    /* PEBS_FMT bits in IA32_PERF_CAPABILITIES MSR. */
+    uint64_t pebs_fmt;
+
     /* LMCE support can be enabled/disabled via cpu option 'lmce=on/off'. It is
      * disabled by default to avoid breaking migration between QEMU with
      * different LMCE configurations.
diff --git a/target/i386/kvm/kvm-cpu.c b/target/i386/kvm/kvm-cpu.c
index 1d0047d037c7..60bf3899852a 100644
--- a/target/i386/kvm/kvm-cpu.c
+++ b/target/i386/kvm/kvm-cpu.c
@@ -231,6 +231,7 @@ static void kvm_cpu_instance_init(CPUState *cs)
     }
 
     cpu->lbr_fmt = -1;
+    cpu->pebs_fmt = -1;
 
     kvm_cpu_xsave_init();
 }
-- 
2.53.0


