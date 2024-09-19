Return-Path: <kvm+bounces-27164-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A2D0997C400
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 07:56:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id ED4EAB21728
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 05:56:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5580770E2;
	Thu, 19 Sep 2024 05:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WHDwuFn9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94C1373440
	for <kvm@vger.kernel.org>; Thu, 19 Sep 2024 05:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726725381; cv=none; b=O362I5vfFASSd36KXkS2BD8nYOtg59yITlZsCVvSbpEcKKW4dWh86w4qST7BFbdCGK3gimvAzrQ9mO51bfQ4sXckEJJyXQU0yfv4ojcD0318+M8sIz2hmw5/LXVLsQCeCOhBCVfuiCxuYVnQhedF4yxlPiyjOwrLiYZQPUSkzFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726725381; c=relaxed/simple;
	bh=swUKe7Dk5Q6yJ5VJiLcmgO4PNjWAtrL0i/B6l+A1Xbk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Nuoi9vvIbhEksCKb0IMhn8dbL5Ker0xvgxncWb3WK/WclL7n9a9ugl8I5qoOYLCPKFMNKMxer8ODEvu6XVlvP/C5pWq5RWn0Ap8dBny8AcRTBNgyxWqTTsXOkr8HQEqNrTO+eenYaFJWgK7ZtHPw6phNL10opR7DS9gDqdpCagc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WHDwuFn9; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726725380; x=1758261380;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=swUKe7Dk5Q6yJ5VJiLcmgO4PNjWAtrL0i/B6l+A1Xbk=;
  b=WHDwuFn9niMr1dnnkyHVT6BFJsdS/nmbNTOeIiRkAOSmA3Xw+LjnisSj
   vHkHl375bqP/ShLWzrvL/wgPknGK8a/kn8luXlNyEFLv8lcErj5H7GzdA
   bayDTZ+hpkmsZeNzxI6JTco5CK/335DeLVI5ZkxK82BTrlWBkPtFVis5W
   W9DD/A/cLBF8yVLlnO/k9d2zTks3uHOdJCA1+ssOYqE4yi1J5C7lNOaF8
   J+32pixO8YwX2cN/oApWbKVUr5rj0qCngux13deUUdZ1XwQyudZQWPmAC
   +XAyi55WxK6wClhChMtflBUyHRUh4e1U0RYqJynfr0PO6pdsiqzvbBc6P
   w==;
X-CSE-ConnectionGUID: LHD5sCEvT1yyB69mSbp4/g==
X-CSE-MsgGUID: DBI0aclfQZqsOVdl2amF4Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11199"; a="25813662"
X-IronPort-AV: E=Sophos;i="6.10,240,1719903600"; 
   d="scan'208";a="25813662"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2024 22:56:20 -0700
X-CSE-ConnectionGUID: 0tIfENWWT32Xu6SDNpEnXA==
X-CSE-MsgGUID: OO4hh/zZRMaI4/Pt2zCRAA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,240,1719903600"; 
   d="scan'208";a="69418778"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by fmviesa006.fm.intel.com with ESMTP; 18 Sep 2024 22:56:13 -0700
From: Zhao Liu <zhao1.liu@intel.com>
To: =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Sergio Lopez <slp@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Anthony PERARD <anthony@xenproject.org>,
	Paul Durrant <paul@xen.org>,
	"Edgar E . Iglesias" <edgar.iglesias@gmail.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Peter Maydell <peter.maydell@linaro.org>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	qemu-arm@nongnu.org,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Yongwei Ma <yongwei.ma@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [RFC v2 08/12] hw/i386: Use get_max_topo_by_level() to get topology information
Date: Thu, 19 Sep 2024 14:11:24 +0800
Message-Id: <20240919061128.769139-9-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240919061128.769139-1-zhao1.liu@intel.com>
References: <20240919061128.769139-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

To honor the custom topology case and generate correct APIC ID for
hybrid CPU topology, Use get_max_topo_by_level() to get topology
information instead of accessing MachineState.smp directly.

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 hw/i386/x86-common.c | 19 +++++++++++++------
 hw/i386/x86.c        | 20 +++++++++++++-------
 2 files changed, 26 insertions(+), 13 deletions(-)

diff --git a/hw/i386/x86-common.c b/hw/i386/x86-common.c
index 75d4b2f3d43a..58591e015569 100644
--- a/hw/i386/x86-common.c
+++ b/hw/i386/x86-common.c
@@ -202,11 +202,15 @@ void x86_cpus_init(X86MachineState *x86ms, int default_cpu_version)
 
 static void x86_fixup_topo_ids(MachineState *ms, X86CPU *cpu)
 {
+    int max_modules, max_dies;
+
+    max_modules = get_max_topo_by_level(ms, CPU_TOPOLOGY_LEVEL_MODULE);
+    max_dies = get_max_topo_by_level(ms, CPU_TOPOLOGY_LEVEL_DIE);
     /*
      * die-id was optional in QEMU 4.0 and older, so keep it optional
      * if there's only one die per socket.
      */
-    if (cpu->module_id < 0 && ms->smp.modules == 1) {
+    if (cpu->module_id < 0 && max_modules == 1) {
         cpu->module_id = 0;
     }
 
@@ -214,7 +218,7 @@ static void x86_fixup_topo_ids(MachineState *ms, X86CPU *cpu)
      * module-id was optional in QEMU 9.0 and older, so keep it optional
      * if there's only one module per die.
      */
-    if (cpu->die_id < 0 && ms->smp.dies == 1) {
+    if (cpu->die_id < 0 && max_dies == 1) {
         cpu->die_id = 0;
     }
 }
@@ -393,6 +397,7 @@ void x86_cpu_pre_plug(HotplugHandler *hotplug_dev,
     MachineState *ms = MACHINE(hotplug_dev);
     X86MachineState *x86ms = X86_MACHINE(hotplug_dev);
     X86CPUTopoInfo topo_info;
+    int max_modules, max_dies;
 
     if (!object_dynamic_cast(OBJECT(cpu), ms->cpu_type)) {
         error_setg(errp, "Invalid CPU type, expected cpu type: '%s'",
@@ -413,13 +418,15 @@ void x86_cpu_pre_plug(HotplugHandler *hotplug_dev,
 
     init_topo_info(&topo_info, x86ms);
 
-    if (ms->smp.modules > 1) {
-        env->nr_modules = ms->smp.modules;
+    max_modules = get_max_topo_by_level(ms, CPU_TOPOLOGY_LEVEL_MODULE);
+    if (max_modules > 1) {
+        env->nr_modules = max_modules;
         set_bit(CPU_TOPOLOGY_LEVEL_MODULE, env->avail_cpu_topo);
     }
 
-    if (ms->smp.dies > 1) {
-        env->nr_dies = ms->smp.dies;
+    max_dies = get_max_topo_by_level(ms, CPU_TOPOLOGY_LEVEL_DIE);
+    if (max_dies > 1) {
+        env->nr_dies = max_dies;
         set_bit(CPU_TOPOLOGY_LEVEL_DIE, env->avail_cpu_topo);
     }
 
diff --git a/hw/i386/x86.c b/hw/i386/x86.c
index cdf7b81ad0e3..55904b545d84 100644
--- a/hw/i386/x86.c
+++ b/hw/i386/x86.c
@@ -44,16 +44,20 @@ void init_topo_info(X86CPUTopoInfo *topo_info,
 {
     MachineState *ms = MACHINE(x86ms);
 
-    topo_info->dies_per_pkg = ms->smp.dies;
+    topo_info->dies_per_pkg =
+        get_max_topo_by_level(ms, CPU_TOPOLOGY_LEVEL_DIE);
     /*
      * Though smp.modules means the number of modules in one cluster,
      * i386 doesn't support cluster level so that the smp.clusters
      * always defaults to 1, therefore using smp.modules directly is
      * fine here.
      */
-    topo_info->modules_per_die = ms->smp.modules;
-    topo_info->cores_per_module = ms->smp.cores;
-    topo_info->threads_per_core = ms->smp.threads;
+    topo_info->modules_per_die =
+        get_max_topo_by_level(ms, CPU_TOPOLOGY_LEVEL_MODULE);
+    topo_info->cores_per_module =
+        get_max_topo_by_level(ms, CPU_TOPOLOGY_LEVEL_CORE);
+    topo_info->threads_per_core =
+        get_max_topo_by_level(ms, CPU_TOPOLOGY_LEVEL_THREAD);
 }
 
 /*
@@ -103,7 +107,7 @@ static const CPUArchIdList *x86_possible_cpu_arch_ids(MachineState *ms)
     X86MachineState *x86ms = X86_MACHINE(ms);
     unsigned int max_cpus = ms->smp.max_cpus;
     X86CPUTopoInfo topo_info;
-    int i;
+    int i, max_dies, max_modules;
 
     if (ms->possible_cpus) {
         /*
@@ -120,6 +124,8 @@ static const CPUArchIdList *x86_possible_cpu_arch_ids(MachineState *ms)
 
     init_topo_info(&topo_info, x86ms);
 
+    max_dies = get_max_topo_by_level(ms, CPU_TOPOLOGY_LEVEL_DIE);
+    max_modules = get_max_topo_by_level(ms, CPU_TOPOLOGY_LEVEL_MODULE);
     for (i = 0; i < ms->possible_cpus->len; i++) {
         X86CPUTopoIDs topo_ids;
 
@@ -131,11 +137,11 @@ static const CPUArchIdList *x86_possible_cpu_arch_ids(MachineState *ms)
                                  &topo_info, &topo_ids);
         ms->possible_cpus->cpus[i].props.has_socket_id = true;
         ms->possible_cpus->cpus[i].props.socket_id = topo_ids.pkg_id;
-        if (ms->smp.dies > 1) {
+        if (max_dies > 1) {
             ms->possible_cpus->cpus[i].props.has_die_id = true;
             ms->possible_cpus->cpus[i].props.die_id = topo_ids.die_id;
         }
-        if (ms->smp.modules > 1) {
+        if (max_modules > 1) {
             ms->possible_cpus->cpus[i].props.has_module_id = true;
             ms->possible_cpus->cpus[i].props.module_id = topo_ids.module_id;
         }
-- 
2.34.1


