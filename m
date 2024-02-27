Return-Path: <kvm+bounces-10047-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 250AF868D31
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 11:19:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B90A3B263D6
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 10:19:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEF941384BA;
	Tue, 27 Feb 2024 10:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="P/3HC15l"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F9E7138497
	for <kvm@vger.kernel.org>; Tue, 27 Feb 2024 10:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709029142; cv=none; b=PBczJ+xqcx2gUbce2+AStuQD8F54aPPITkxLYx+MUmjSGaWd55va4jjHPFNk913LIuzbuiZi9tTnVNplvO0BByHF/21IC+33n73Byq2bIktv5zv1M7VivjTsszN6nt8gDdlodnkX7o37kOqf0lGMMoa2KcyBk/pZ1EsCdkwzmdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709029142; c=relaxed/simple;
	bh=qc0dznObfB75mojGTQm+npA6PcQftZi09ZySj53xoz8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZyNhf3uEU3uFvJTAhCy5cecFMBQ9abl6GTkWaidzzPhroYreRzBQSOxrNFMgtRvAA+J7KW7vjgsoSioTZQjrDtZuf/scDS/2ILlTJyWOd3E4tnkE1UtO5BP3W10FpLlD6DnrFRKpzk6K3ICm8lRiD3ow+I3VqNFiu3YS/PQf/eA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=P/3HC15l; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709029141; x=1740565141;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qc0dznObfB75mojGTQm+npA6PcQftZi09ZySj53xoz8=;
  b=P/3HC15l8AaKa/W6cQ2u13RdItoVsp85Mg/KAD4wM97aZo19Cd2FH9p0
   wOorNrbp0pRkVUkXGgynhWzmclLMGPQh7Mli9ZmstsJAZzGDuF4eNMFQy
   NsbdCw+TjfimekdHBEdGfaqTL5+ubp3X6uLFcLjLdM8OBttFPCjMMVzW6
   StIIGgNjtKhq//yuctC2wekl6tpNua8sO3lfbxk4t9gRR58ypiuPF7Ad7
   fGHeEQJxnCIs91F+yXaxWNE6UlrgPakl4zl8thxIv/szPzBAwoo0mOqN2
   PFAFyzB1cK+ccgeS2DSiRlQMNyGnjtVna0aU7uRPdb70HMMbRnALvYKbx
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10996"; a="6310202"
X-IronPort-AV: E=Sophos;i="6.06,187,1705392000"; 
   d="scan'208";a="6310202"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2024 02:19:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,187,1705392000"; 
   d="scan'208";a="6954741"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by fmviesa010.fm.intel.com with ESMTP; 27 Feb 2024 02:18:56 -0800
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
Subject: [PATCH v9 01/21] hw/core/machine: Introduce the module as a CPU topology level
Date: Tue, 27 Feb 2024 18:32:11 +0800
Message-Id: <20240227103231.1556302-2-zhao1.liu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240227103231.1556302-1-zhao1.liu@linux.intel.com>
References: <20240227103231.1556302-1-zhao1.liu@linux.intel.com>
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
index 25019c91ee36..a0a30da59aa4 100644
--- a/hw/core/machine-smp.c
+++ b/hw/core/machine-smp.c
@@ -234,7 +234,7 @@ void machine_parse_smp_config(MachineState *ms,
 
 unsigned int machine_topo_get_cores_per_socket(const MachineState *ms)
 {
-    return ms->smp.cores * ms->smp.clusters * ms->smp.dies;
+    return ms->smp.cores * ms->smp.modules * ms->smp.clusters * ms->smp.dies;
 }
 
 unsigned int machine_topo_get_threads_per_socket(const MachineState *ms)
diff --git a/hw/core/machine.c b/hw/core/machine.c
index fb5afdcae4cc..36fe3a4806f2 100644
--- a/hw/core/machine.c
+++ b/hw/core/machine.c
@@ -1148,6 +1148,7 @@ static void machine_initfn(Object *obj)
     ms->smp.sockets = 1;
     ms->smp.dies = 1;
     ms->smp.clusters = 1;
+    ms->smp.modules = 1;
     ms->smp.cores = 1;
     ms->smp.threads = 1;
 
diff --git a/include/hw/boards.h b/include/hw/boards.h
index bcfde8a84d10..78dea50054a1 100644
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


