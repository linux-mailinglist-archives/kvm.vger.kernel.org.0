Return-Path: <kvm+bounces-2967-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D5317FF230
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 15:37:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 44EED1F20D47
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 14:37:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E78C051C37;
	Thu, 30 Nov 2023 14:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cA5uMCiq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A0CC93
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 06:37:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701355022; x=1732891022;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1TBuBuayUq5ep3LedB2XG6MRM6nllhfykxLgfM/A+kw=;
  b=cA5uMCiqPmVXC4rmr2YoRHZvV9E0yVxSq5CEqi+iGMSqr2CmddxsKPRE
   ES0h9ZKLr56zO5IEh7sDZKIwZ/gBPSqwd9yrH1lVT7vmerMwPVbvWlq17
   uOJETRu5qYFvCWjmPg0/BBSS8A3/DS00Hy8Ncm5wHT8qGCtctfw+Xy89N
   0RBXv9KWr1LHMzuZ/WY/QwvlYjoVRhqlRIox/xjAfgMo0XdiaFISr+sEe
   toPl9PBTiJd2Hzb6vXiBH/4bqatvaXBCBSp8FD+N0Lfu3th0HHZt7NlvL
   SAnP7ODucNMRclXKzLpRd27xgOH2GxU/21Ec1TFNMxwgmj40M+QZbtsrp
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10910"; a="479532888"
X-IronPort-AV: E=Sophos;i="6.04,239,1695711600"; 
   d="scan'208";a="479532888"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2023 06:37:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10910"; a="942730622"
X-IronPort-AV: E=Sophos;i="6.04,239,1695711600"; 
   d="scan'208";a="942730622"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by orsmga005.jf.intel.com with ESMTP; 30 Nov 2023 06:36:52 -0800
From: Zhao Liu <zhao1.liu@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Yanan Wang <wangyanan55@huawei.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	Igor Mammedov <imammedo@redhat.com>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
	=?UTF-8?q?Fr=C3=A9d=C3=A9ric=20Barrat?= <fbarrat@linux.ibm.com>,
	David Gibson <david@gibson.dropbear.id.au>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Anthony Perard <anthony.perard@citrix.com>,
	Paul Durrant <paul@xen.org>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Alistair Francis <alistair@alistair23.me>,
	"Edgar E . Iglesias" <edgar.iglesias@gmail.com>,
	=?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Bin Meng <bin.meng@windriver.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Weiwei Li <liwei1518@gmail.com>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	qemu-ppc@nongnu.org,
	xen-devel@lists.xenproject.org,
	qemu-arm@nongnu.org,
	qemu-riscv@nongnu.org,
	qemu-s390x@nongnu.org
Cc: Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
	Thomas Huth <thuth@redhat.com>,
	Zhiyuan Lv <zhiyuan.lv@intel.com>,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Yongwei Ma <yongwei.ma@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [RFC 41/41] hw/i386: Cleanup non-QOM topology support
Date: Thu, 30 Nov 2023 22:42:03 +0800
Message-Id: <20231130144203.2307629-42-zhao1.liu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231130144203.2307629-1-zhao1.liu@linux.intel.com>
References: <20231130144203.2307629-1-zhao1.liu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Zhao Liu <zhao1.liu@intel.com>

After i386 supports QOM topology, drop original topology logic.

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 hw/i386/x86.c | 52 +++++++++++----------------------------------------
 1 file changed, 11 insertions(+), 41 deletions(-)

diff --git a/hw/i386/x86.c b/hw/i386/x86.c
index 99f6c502de43..cba8b806cdb6 100644
--- a/hw/i386/x86.c
+++ b/hw/i386/x86.c
@@ -118,7 +118,8 @@ out:
 
 void x86_cpus_init(X86MachineState *x86ms, int default_cpu_version)
 {
-    int i;
+    CPUCore *core;
+    int i, cpu_index = 0, core_idx = 0;
     const CPUArchIdList *possible_cpus;
     MachineState *ms = MACHINE(x86ms);
     MachineClass *mc = MACHINE_GET_CLASS(x86ms);
@@ -153,34 +154,17 @@ void x86_cpus_init(X86MachineState *x86ms, int default_cpu_version)
 
     possible_cpus = mc->possible_cpu_arch_ids(ms);
 
-    /*
-     * possible_cpus_qom_granu means the QOM topology support.
-     *
-     * TODO: Drop the "!mc->smp_props.possible_cpus_qom_granu" case when
-     * i386 completes QOM topology support.
-     */
-    if (mc->smp_props.possible_cpus_qom_granu) {
-        CPUCore *core;
-        int cpu_index = 0;
-        int core_idx = 0;
-
-        MACHINE_CORE_FOREACH(ms, core) {
-            for (i = 0; i < core->plugged_threads; i++) {
-                x86_cpu_new(x86ms, possible_cpus->cpus[cpu_index].arch_id,
-                            OBJECT(core), cpu_index, &error_fatal);
-                cpu_index++;
-            }
-
-            if (core->plugged_threads < core->nr_threads) {
-                cpu_index += core->nr_threads - core->plugged_threads;
-            }
-            core_idx++;
+    MACHINE_CORE_FOREACH(ms, core) {
+        for (i = 0; i < core->plugged_threads; i++) {
+            x86_cpu_new(x86ms, possible_cpus->cpus[cpu_index].arch_id,
+                        OBJECT(core), cpu_index, &error_fatal);
+            cpu_index++;
         }
-    } else {
-        for (i = 0; i < ms->smp.cpus; i++) {
-            x86_cpu_new(x86ms, possible_cpus->cpus[i].arch_id,
-                        NULL, i, &error_fatal);
+
+        if (core->plugged_threads < core->nr_threads) {
+            cpu_index += core->nr_threads - core->plugged_threads;
         }
+        core_idx++;
     }
 }
 
@@ -460,20 +444,6 @@ void x86_cpu_pre_plug(HotplugHandler *hotplug_dev,
         return;
     }
 
-    /*
-     * possible_cpus_qom_granu means the QOM topology support.
-     *
-     * TODO: Drop the "!mc->smp_props.possible_cpus_qom_granu" case when
-     * i386 completes QOM topology support.
-     */
-    if (!mc->smp_props.possible_cpus_qom_granu) {
-        x86_topo_ids_from_apicid(cpu->apic_id, &topo_info, &topo_ids);
-        x86_cpu_assign_topo_id(cpu, &topo_ids, errp);
-        if (*errp) {
-            return;
-        }
-    }
-
     if (hyperv_feat_enabled(cpu, HYPERV_FEAT_VPINDEX) &&
         kvm_enabled() && !kvm_hv_vpindex_settable()) {
         error_setg(errp, "kernel doesn't allow setting HyperV VP_INDEX");
-- 
2.34.1


