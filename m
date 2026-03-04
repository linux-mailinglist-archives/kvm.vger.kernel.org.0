Return-Path: <kvm+bounces-72728-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aBKmORB4qGk4uwAAu9opvQ
	(envelope-from <kvm+bounces-72728-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 19:21:04 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id A93CF206320
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 19:21:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id C667C3087610
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2026 18:16:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D99B3D34AA;
	Wed,  4 Mar 2026 18:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="I3iwTCHl"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0F3A3D6CAE
	for <kvm@vger.kernel.org>; Wed,  4 Mar 2026 18:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772648126; cv=none; b=dFTNT8LtlW/XI8Racg+QzzztsfrUnOEcVOxx6FIG/hyKC9vpIfBjDJt3oMDQ0XmohfowVNss6o+cMglzm47MG7VfyAJW0hrIKtdR2+WytDDeDX+/eOw/MgjWpQOlc0T6gjl7TW/pxtqhHjy1IOict4cyLvsFgUMRdJTZkTBvQqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772648126; c=relaxed/simple;
	bh=PfiK2yNzIcNRNixRz4RZweZsa5EmXaMxakpMXh1yNJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CgXMZgEkSzKHOvQmoiwQsIY9E9JdDXJU8dvrvVyFdOQdHFJfF/djb5jZOPnvJ4OE4T8jZxVmHyZzzJ6rbqJBF+hi9GR/8uXgfKov7wO6hlzZlGZMVjeh35d9+ECkfK7w0zPkUHzv3ActU9Vn//C116XeMm2UQFv9hBYcO5dVPU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=I3iwTCHl; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772648123; x=1804184123;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PfiK2yNzIcNRNixRz4RZweZsa5EmXaMxakpMXh1yNJk=;
  b=I3iwTCHlM5UVnVD9IQ2gb8LIZiCVvnj00YED0FgpRpFNM9vumcmOb7Ju
   ZWfTsBw/qR+7WhzJhmVi+rZP5ZEcb/fNHGwxjvFEZuL15fY4pVayYUgwJ
   wIILCtc1LBFksPjJnbV9yEiVbBhfuQpCtKvVRp3zPdGoLvCPhTGw9pvkU
   5QK8BraKnrhfM7/RhDPD+0Mv64rkhgLYp2XJmaDwAHLXQuAsg2q2cGzzr
   3P3Zyr+c8gvqusgFrDG80xkO0mDDoCqY+jY6Y3BtG42nFB2IWvQ1b2mK3
   6njATi9oW2rd3e1ImNguwZVwPm+hiXJQDZnyAwixaStznpExXX+WBevGQ
   g==;
X-CSE-ConnectionGUID: el3FzKXBQx+Yab5xNuc/Tw==
X-CSE-MsgGUID: tEpFgR+wQ5idt//mtebQ+g==
X-IronPort-AV: E=McAfee;i="6800,10657,11719"; a="73909381"
X-IronPort-AV: E=Sophos;i="6.21,324,1763452800"; 
   d="scan'208";a="73909381"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2026 10:15:23 -0800
X-CSE-ConnectionGUID: kYqnLPcCT/mdlQAEtDyMnw==
X-CSE-MsgGUID: rpio76ldR8a/6Vfir0rCFg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,324,1763452800"; 
   d="scan'208";a="214542846"
Received: from 9cc2c43eec6b.jf.intel.com ([10.54.77.43])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2026 10:15:22 -0800
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
Subject: [PATCH V3 10/13] target/i386: Refactor LBR format handling
Date: Wed,  4 Mar 2026 10:07:09 -0800
Message-ID: <20260304180713.360471-11-zide.chen@intel.com>
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
X-Rspamd-Queue-Id: A93CF206320
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72728-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo,intel.com:dkim,intel.com:email,intel.com:mid]
X-Rspamd-Action: no action

Detach x86_cpu_pmu_realize() from x86_cpu_realizefn() to keep the latter
focused and easier to follow.  Introduce a dedicated helper,
x86_cpu_apply_lbr_pebs_fmt(), in preparation for adding PEBS format
support without duplicating code.

Convert PERF_CAP_LBR_FMT into separate mask and shift macros to allow
x86_cpu_apply_lbr_pebs_fmt() to be shared with PEBS format handling.

No functional change intended.

Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Zide Chen <zide.chen@intel.com>
---
V2: New patch.
---
 target/i386/cpu.c | 93 +++++++++++++++++++++++++++++++----------------
 target/i386/cpu.h |  3 +-
 2 files changed, 64 insertions(+), 32 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index da2e67ca1faf..d5e00b41fb04 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -9769,6 +9769,65 @@ static bool x86_cpu_update_smp_cache_topo(MachineState *ms, X86CPU *cpu,
 }
 #endif
 
+static bool x86_cpu_apply_lbr_pebs_fmt(X86CPU *cpu, uint64_t host_perf_cap,
+                                  uint64_t user_req, bool is_lbr_fmt,
+                                  Error **errp)
+{
+    CPUX86State *env = &cpu->env;
+    uint64_t mask;
+    unsigned shift;
+    unsigned user_fmt;
+    const char *name;
+
+    if (is_lbr_fmt) {
+        mask = PERF_CAP_LBR_FMT_MASK;
+        shift = PERF_CAP_LBR_FMT_SHIFT;
+        name = "lbr";
+    } else {
+        return false;
+    }
+
+    if (user_req != -1) {
+        env->features[FEAT_PERF_CAPABILITIES] &= ~(mask << shift);
+        env->features[FEAT_PERF_CAPABILITIES] |= (user_req << shift);
+    }
+
+    user_fmt = (env->features[FEAT_PERF_CAPABILITIES] >> shift) & mask;
+    if (user_fmt) {
+        unsigned host_fmt = (host_perf_cap >> shift) & mask;
+
+        if (!cpu->enable_pmu) {
+            error_setg(errp, "vPMU: %s is unsupported without pmu=on", name);
+            return false;
+        }
+        if (user_fmt != host_fmt) {
+            error_setg(errp, "vPMU: the %s-fmt value (0x%x) does not match "
+                        "the host value (0x%x).",
+                        name, user_fmt, host_fmt);
+            return false;
+        }
+    }
+
+    return true;
+}
+
+static int x86_cpu_pmu_realize(X86CPU *cpu, Error **errp)
+{
+    uint64_t host_perf_cap =
+        x86_cpu_get_supported_feature_word(NULL, FEAT_PERF_CAPABILITIES);
+
+    /*
+     * Override env->features[FEAT_PERF_CAPABILITIES].LBR_FMT
+     * with user-provided setting.
+     */
+    if (!x86_cpu_apply_lbr_pebs_fmt(cpu, host_perf_cap,
+                                    cpu->lbr_fmt, true, errp)) {
+        return -EINVAL;
+    }
+
+    return 0;
+}
+
 static void x86_cpu_realizefn(DeviceState *dev, Error **errp)
 {
     CPUState *cs = CPU(dev);
@@ -9776,7 +9835,6 @@ static void x86_cpu_realizefn(DeviceState *dev, Error **errp)
     X86CPUClass *xcc = X86_CPU_GET_CLASS(dev);
     CPUX86State *env = &cpu->env;
     Error *local_err = NULL;
-    unsigned guest_fmt;
 
     if (!kvm_enabled())
         cpu->enable_pmu = false;
@@ -9812,35 +9870,8 @@ static void x86_cpu_realizefn(DeviceState *dev, Error **errp)
         goto out;
     }
 
-    /*
-     * Override env->features[FEAT_PERF_CAPABILITIES].LBR_FMT
-     * with user-provided setting.
-     */
-    if (cpu->lbr_fmt != -1) {
-        env->features[FEAT_PERF_CAPABILITIES] &= ~PERF_CAP_LBR_FMT;
-        env->features[FEAT_PERF_CAPABILITIES] |= cpu->lbr_fmt;
-    }
-
-    /*
-     * vPMU LBR is supported when 1) KVM is enabled 2) Option pmu=on and
-     * 3)vPMU LBR format matches that of host setting.
-     */
-    guest_fmt = env->features[FEAT_PERF_CAPABILITIES] & PERF_CAP_LBR_FMT;
-    if (guest_fmt) {
-        uint64_t host_perf_cap =
-            x86_cpu_get_supported_feature_word(NULL, FEAT_PERF_CAPABILITIES);
-        unsigned host_lbr_fmt = host_perf_cap & PERF_CAP_LBR_FMT;
-
-        if (!cpu->enable_pmu) {
-            error_setg(errp, "vPMU: LBR is unsupported without pmu=on");
-            return;
-        }
-        if (guest_fmt != host_lbr_fmt) {
-            error_setg(errp, "vPMU: the lbr-fmt value (0x%x) does not match "
-                        "the host value (0x%x).",
-                        guest_fmt, host_lbr_fmt);
-            return;
-        }
+    if (x86_cpu_pmu_realize(cpu, errp)) {
+        return;
     }
 
     if (x86_cpu_filter_features(cpu, cpu->check_cpuid || cpu->enforce_cpuid)) {
@@ -10430,7 +10461,7 @@ static const Property x86_cpu_properties[] = {
 #endif
     DEFINE_PROP_INT32("node-id", X86CPU, node_id, CPU_UNSET_NUMA_NODE_ID),
     DEFINE_PROP_BOOL("pmu", X86CPU, enable_pmu, false),
-    DEFINE_PROP_UINT64_CHECKMASK("lbr-fmt", X86CPU, lbr_fmt, PERF_CAP_LBR_FMT),
+    DEFINE_PROP_UINT64_CHECKMASK("lbr-fmt", X86CPU, lbr_fmt, PERF_CAP_LBR_FMT_MASK),
 
     DEFINE_PROP_UINT32("hv-spinlocks", X86CPU, hyperv_spinlock_attempts,
                        HYPERV_SPINLOCK_NEVER_NOTIFY),
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 3a10f3242329..a064bf8ab17e 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -420,7 +420,8 @@ typedef enum X86Seg {
 #define ARCH_CAP_TSX_CTRL_MSR		(1<<7)
 
 #define MSR_IA32_PERF_CAPABILITIES      0x345
-#define PERF_CAP_LBR_FMT                0x3f
+#define PERF_CAP_LBR_FMT_MASK           0x3f
+#define PERF_CAP_LBR_FMT_SHIFT          0x0
 #define PERF_CAP_FULL_WRITE             (1U << 13)
 #define PERF_CAP_PEBS_BASELINE          (1U << 14)
 
-- 
2.53.0


