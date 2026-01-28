Return-Path: <kvm+bounces-69439-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QFYQIjGZemms8QEAu9opvQ
	(envelope-from <kvm+bounces-69439-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 00:18:09 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D6EBA9E77
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 00:18:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 66C02302D966
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 23:17:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0243A2DEA6E;
	Wed, 28 Jan 2026 23:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LZvv+tzW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D017343D75
	for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 23:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769642269; cv=none; b=ANs9uMy/EP5Z7SGMefvejK0USj8N1ImNjM2A9tyQfzdcualgMDddrQmiholDqKxl7icXnnCy51A3rF0ekgQzl9EHG+F6o0PSnvH22Z5J/Qn0UFCNvyv9Os6Rf8rP/V01RpaacBorxdekPqLwSIwWhl3Xfnt8L5tLXOdPP15DwQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769642269; c=relaxed/simple;
	bh=lBhmgOoCeHBQeHkVFHU09ZVdbzQMPRSBW0jjTwRm2OU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VKvK1Wt1nDJGRxe1ZF7imsreBgubl+jH9EUjQPojY2lEpgKvdpDOBALCDmzoo7V25zWcOatQ3enDFg5D10sJ4ZTb/nJ6KDsxub54hU/UHd39CY2MjBFHo9YzCBwtSUps11EMcO9lcLxzvuGD6G0qX42h4llMkmJYoCZD+aTIHyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LZvv+tzW; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769642263; x=1801178263;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lBhmgOoCeHBQeHkVFHU09ZVdbzQMPRSBW0jjTwRm2OU=;
  b=LZvv+tzWc8WKHZw7CavefSA4FAyuOfKCN9xHID8heToCPygLLS9M+OAf
   8hlctfc6ujt0WCqk4/1mZT3dOUyVJCpPPfzkkp7DCIfoJ0pSxq1RpM0k0
   +15RNSptMYoiS1RTQbk2fJGs3vx0KwB+/81QwHcRAAXSRJsFsx96XvQcO
   1AIkMHS+KWQij1ew1uD1dXNrjVCYZ82Vklz2ZLpXWYIRauMXiGVWjzn3R
   nYdAli9LKPJdB0zQxRZTgKxak+mmU+uDNWr2ysSBM+W6lAxYKpUnvB3Pv
   j5mx7NATBo7Pk/nexh+HKktMFjnRJvI90YmbC9X2czjIlPBX5G94B9tKH
   g==;
X-CSE-ConnectionGUID: 1L3S4GRSRFOQWkxYzzvGeA==
X-CSE-MsgGUID: 5Xg+Y9hkQMOPIvyRDVvKGw==
X-IronPort-AV: E=McAfee;i="6800,10657,11685"; a="73462349"
X-IronPort-AV: E=Sophos;i="6.21,258,1763452800"; 
   d="scan'208";a="73462349"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2026 15:17:43 -0800
X-CSE-ConnectionGUID: zpxgtPShSSOfhBkhCTjQ/Q==
X-CSE-MsgGUID: CCQLBDU8TNeu5lOAgoME6A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,258,1763452800"; 
   d="scan'208";a="208001791"
Received: from 9cc2c43eec6b.jf.intel.com ([10.54.77.43])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2026 15:17:42 -0800
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
Subject: [PATCH V2 10/11] target/i386: Add pebs-fmt CPU option
Date: Wed, 28 Jan 2026 15:09:47 -0800
Message-ID: <20260128231003.268981-11-zide.chen@intel.com>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69439-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,intel.com:email,intel.com:dkim,intel.com:mid]
X-Rspamd-Queue-Id: 2D6EBA9E77
X-Rspamd-Action: no action

Similar to lbr-fmt, target/i386 does not support multi-bit CPU
properties, so the PEBS record format cannot be exposed as a
user-visible CPU feature.

Add a pebs-fmt option to allow users to specify the PEBS format via the
command line.  Since the PEBS state is part of the vmstate, this option
is considered migratable.

With this option, PEBS can be enabled when migratable=on.

Signed-off-by: Zide Chen <zide.chen@intel.com>
---
V2: New patch

 target/i386/cpu.c         | 11 ++++++++++-
 target/i386/cpu.h         |  5 +++++
 target/i386/kvm/kvm-cpu.c |  1 +
 3 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 54f04adb0b48..ec6f49916de3 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -9796,7 +9796,9 @@ static bool x86_cpu_apply_lbr_pebs_fmt(X86CPU *cpu, uint64_t host_perf_cap,
         shift = PERF_CAP_LBR_FMT_SHIFT;
         name = "lbr";
     } else {
-        return false;
+        mask = PERF_CAP_PEBS_FMT_MASK;
+        shift = PERF_CAP_PEBS_FMT_SHIFT;
+        name = "pebs";
     }
 
     if (user_req != -1) {
@@ -9838,6 +9840,11 @@ static int x86_cpu_pmu_realize(X86CPU *cpu, Error **errp)
         return -EINVAL;
     }
 
+    if (!x86_cpu_apply_lbr_pebs_fmt(cpu, host_perf_cap,
+                                    cpu->pebs_fmt, false, errp)) {
+        return -EINVAL;
+    }
+
     return 0;
 }
 
@@ -10307,6 +10314,7 @@ static void x86_cpu_initfn(Object *obj)
 
     object_property_add_alias(obj, "hv-apicv", obj, "hv-avic");
     object_property_add_alias(obj, "lbr_fmt", obj, "lbr-fmt");
+    object_property_add_alias(obj, "pebs_fmt", obj, "pebs-fmt");
 
     if (xcc->model) {
         x86_cpu_load_model(cpu, xcc->model);
@@ -10478,6 +10486,7 @@ static const Property x86_cpu_properties[] = {
     DEFINE_PROP_INT32("node-id", X86CPU, node_id, CPU_UNSET_NUMA_NODE_ID),
     DEFINE_PROP_BOOL("pmu", X86CPU, enable_pmu, false),
     DEFINE_PROP_UINT64_CHECKMASK("lbr-fmt", X86CPU, lbr_fmt, PERF_CAP_LBR_FMT_MASK),
+    DEFINE_PROP_UINT64_CHECKMASK("pebs-fmt", X86CPU, pebs_fmt, PERF_CAP_PEBS_FMT_MASK),
 
     DEFINE_PROP_UINT32("hv-spinlocks", X86CPU, hyperv_spinlock_attempts,
                        HYPERV_SPINLOCK_NEVER_NOTIFY),
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index aa3c24e0ba13..5ab107dfa29f 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -422,6 +422,8 @@ typedef enum X86Seg {
 #define MSR_IA32_PERF_CAPABILITIES      0x345
 #define PERF_CAP_LBR_FMT_MASK           0x3f
 #define PERF_CAP_LBR_FMT_SHIFT          0x0
+#define PERF_CAP_PEBS_FMT_MASK          0xf
+#define PERF_CAP_PEBS_FMT_SHIFT         0x8
 #define PERF_CAP_FULL_WRITE             (1U << 13)
 #define PERF_CAP_PEBS_BASELINE          (1U << 14)
 
@@ -2399,6 +2401,9 @@ struct ArchCPU {
      */
     uint64_t lbr_fmt;
 
+    /* PEBS_FMT bits in IA32_PERF_CAPABILITIES MSR. */
+    uint64_t pebs_fmt;
+
     /* LMCE support can be enabled/disabled via cpu option 'lmce=on/off'. It is
      * disabled by default to avoid breaking migration between QEMU with
      * different LMCE configurations.
diff --git a/target/i386/kvm/kvm-cpu.c b/target/i386/kvm/kvm-cpu.c
index b4500ab69f82..7029629a9d09 100644
--- a/target/i386/kvm/kvm-cpu.c
+++ b/target/i386/kvm/kvm-cpu.c
@@ -232,6 +232,7 @@ static void kvm_cpu_instance_init(CPUState *cs)
     }
 
     cpu->lbr_fmt = -1;
+    cpu->pebs_fmt = -1;
 
     kvm_cpu_xsave_init();
 }
-- 
2.52.0


