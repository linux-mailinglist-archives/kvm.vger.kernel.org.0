Return-Path: <kvm+bounces-12383-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FB82885AA5
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 15:27:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 428F4283158
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 14:27:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0325C85275;
	Thu, 21 Mar 2024 14:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZKy4bWJ3"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B78E84FD8
	for <kvm@vger.kernel.org>; Thu, 21 Mar 2024 14:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711031239; cv=none; b=CQvqs0/F/qoGioxiGr/usAyyZULVhsqLxRy38nHds6u7tbIxrTJosQ6fYVumucvaSs4TbRXucnPNWyebArwUFUyDD/SBsmhslvUnTWat5FgXXcG42rQn3IhSE5BzMDhefUmgTmqiqOITnIxgiEw2vqyMFJtKgw49oc8wQ2D30Fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711031239; c=relaxed/simple;
	bh=pEpRExdp6uKxP0in0zooiKeUqh4L1Jbkwo0U9EmY0gE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=K3Hltl6tgW1pQbp0B2W8VEBS+mDmfrUVC7uDrAhCK89Qe57dKQO6HYlpV/Y0llW1bsWGcmssfivQ76JN5CE8QO406F0dp06cP+Q/b16SnLdiU0OjN6/0J7gG7fVhqmEjzRgAtmzC01alW4r5u4BkpC+998dkEEcENfH4SyYa2PA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZKy4bWJ3; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711031238; x=1742567238;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pEpRExdp6uKxP0in0zooiKeUqh4L1Jbkwo0U9EmY0gE=;
  b=ZKy4bWJ358ZOSL3zodGRwBgjHc02eDrXtStVYA5HJA1nXQ2TlMqQNRlu
   lsgdSZGvI9QMzVIzc8Dh6iFNdCQyuj8HoLIlu9otzFKcq7PFWhRCGdTKt
   ZrBF/rxFubaIdOKsk9AR4SicJi7thq2Lt9a4YMTKtsb7D9HQO/zMxVDvE
   dAlnlkUoQVk5n7VNFsIQw2EGx+jRd+0rXEotUrhC84TS9au0tUY+Sfm0S
   EXMsQ55CThLaGUIbt92ebvDde9Aj1PafzQ/Z5tUVRFmV0vr8KmHOGih0g
   pD6PQw2NGYPiWOA0OaxQVVUGPueIIzArQRI7MFauG3TcDPb/07OlMlS/m
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11020"; a="9806342"
X-IronPort-AV: E=Sophos;i="6.07,143,1708416000"; 
   d="scan'208";a="9806342"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2024 07:27:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,143,1708416000"; 
   d="scan'208";a="14527799"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by orviesa009.jf.intel.com with ESMTP; 21 Mar 2024 07:27:12 -0700
From: Zhao Liu <zhao1.liu@linux.intel.com>
To: Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	=?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Zhuocheng Ding <zhuocheng.ding@intel.com>,
	Babu Moger <babu.moger@amd.com>,
	Yongwei Ma <yongwei.ma@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH v10 01/21] hw/core/machine: Introduce the module as a CPU topology level
Date: Thu, 21 Mar 2024 22:40:28 +0800
Message-Id: <20240321144048.3699388-2-zhao1.liu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240321144048.3699388-1-zhao1.liu@linux.intel.com>
References: <20240321144048.3699388-1-zhao1.liu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Zhao Liu <zhao1.liu@intel.com>

In x86, module is the topology level above core, which contains a set
of cores that share certain resources (in current products, the resource
usually includes L2 cache, as well as module scoped features and MSRs).

Though smp.clusters could also share the L2 cache resource [1], there
are following reasons that drive us to introduce the new smp.modules:

  * As the CPU topology abstraction in device tree [2], cluster supports
    nesting (though currently QEMU hasn't support that). In contrast,
    (x86) module does not support nesting.

  * Due to nesting, there is great flexibility in sharing resources
    on cluster, rather than narrowing cluster down to sharing L2 (and
    L3 tags) as the lowest topology level that contains cores.

  * Flexible nesting of cluster allows it to correspond to any level
    between the x86 package and core.

  * In Linux kernel, x86's cluster only represents the L2 cache domain
    but QEMU's smp.clusters is the CPU topology level. Linux kernel will
    also expose module level topology information in sysfs for x86. To
    avoid cluster ambiguity and keep a consistent CPU topology naming
    style with the Linux kernel, we introduce module level for x86.

The module is, in existing hardware practice, the lowest layer that
contains the core, while the cluster is able to have a higher
topological scope than the module due to its nesting.

Therefore, place the module between the cluster and the core:

    drawer/book/socket/die/cluster/module/core/thread

With the above topological hierarchy order, introduce module level
support in MachineState and MachineClass.

[1]: https://lore.kernel.org/qemu-devel/c3d68005-54e0-b8fe-8dc1-5989fe3c7e69@huawei.com/
[2]: https://www.kernel.org/doc/Documentation/devicetree/bindings/cpu/cpu-topology.txt

Suggested-by: Xiaoyao Li <xiaoyao.li@intel.com>
Tested-by: Yongwei Ma <yongwei.ma@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
Tested-by: Babu Moger <babu.moger@amd.com>
---
Changes since v8:
 * Add the reason of why a new module level is needed in commit message.
   (Markus).
 * Add the description about how Linux kernel supports x86 module level.
   (Daniel)

Changes since v7:
 * New commit to introduce module level in -smp.
---
 hw/core/machine-smp.c | 2 +-
 hw/core/machine.c     | 1 +
 include/hw/boards.h   | 4 ++++
 3 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/hw/core/machine-smp.c b/hw/core/machine-smp.c
index 27864c950766..2e68fcfdfd79 100644
--- a/hw/core/machine-smp.c
+++ b/hw/core/machine-smp.c
@@ -266,7 +266,7 @@ void machine_parse_smp_config(MachineState *ms,
 
 unsigned int machine_topo_get_cores_per_socket(const MachineState *ms)
 {
-    return ms->smp.cores * ms->smp.clusters * ms->smp.dies;
+    return ms->smp.cores * ms->smp.modules * ms->smp.clusters * ms->smp.dies;
 }
 
 unsigned int machine_topo_get_threads_per_socket(const MachineState *ms)
diff --git a/hw/core/machine.c b/hw/core/machine.c
index 37ede0e7d4fd..fe0579b7a7e9 100644
--- a/hw/core/machine.c
+++ b/hw/core/machine.c
@@ -1154,6 +1154,7 @@ static void machine_initfn(Object *obj)
     ms->smp.sockets = 1;
     ms->smp.dies = 1;
     ms->smp.clusters = 1;
+    ms->smp.modules = 1;
     ms->smp.cores = 1;
     ms->smp.threads = 1;
 
diff --git a/include/hw/boards.h b/include/hw/boards.h
index 8b8f6d5c00d3..392be94f3cd7 100644
--- a/include/hw/boards.h
+++ b/include/hw/boards.h
@@ -143,6 +143,7 @@ typedef struct {
  *                 provided SMP configuration
  * @books_supported - whether books are supported by the machine
  * @drawers_supported - whether drawers are supported by the machine
+ * @modules_supported - whether modules are supported by the machine
  */
 typedef struct {
     bool prefer_sockets;
@@ -151,6 +152,7 @@ typedef struct {
     bool has_clusters;
     bool books_supported;
     bool drawers_supported;
+    bool modules_supported;
 } SMPCompatProps;
 
 /**
@@ -338,6 +340,7 @@ typedef struct DeviceMemoryState {
  * @sockets: the number of sockets in one book
  * @dies: the number of dies in one socket
  * @clusters: the number of clusters in one die
+ * @modules: the number of modules in one cluster
  * @cores: the number of cores in one cluster
  * @threads: the number of threads in one core
  * @max_cpus: the maximum number of logical processors on the machine
@@ -349,6 +352,7 @@ typedef struct CpuTopology {
     unsigned int sockets;
     unsigned int dies;
     unsigned int clusters;
+    unsigned int modules;
     unsigned int cores;
     unsigned int threads;
     unsigned int max_cpus;
-- 
2.34.1


