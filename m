Return-Path: <kvm+bounces-27168-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C843E97C407
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 07:57:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1D17EB2175C
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 05:56:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7F6080631;
	Thu, 19 Sep 2024 05:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FzbPRY7R"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 920FF73440
	for <kvm@vger.kernel.org>; Thu, 19 Sep 2024 05:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726725409; cv=none; b=F5W+XPwlPUaoaOCsbdFxyIOAKQk1XqnGnttYlerzv9Smc8PARzMUt5XUrzWF8w4TbSwu60HLwVdykKl7cbkkobfTll4TaYvapDRRMUMgwfoQgdHSXS/WxxU+Sx5SFSUEtyQmWT0oSPXCjmx7NdFUvbRZvsbEbAipcZOeq6Za1QM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726725409; c=relaxed/simple;
	bh=cQ08ivvbyToxE/NhN3+dCAQERQMlDYEq9vSrgiTrea4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XnaGI1nLXFoWKNh/NsPnZ3y9xqeCDNpKTIj4qh9mbmMjc20o+fg3It654+tbEJx+x+v27mHWEFeJrO+Yumsb1QL5NBlytk4fh+6Nf6iteNB0I9gXB4kShOzS3huiCmISk0CNrTukbYd5288JvTgubG5iaatJb73wEOuYgB7YTcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FzbPRY7R; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726725408; x=1758261408;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cQ08ivvbyToxE/NhN3+dCAQERQMlDYEq9vSrgiTrea4=;
  b=FzbPRY7RjX+lsDbZ0xCBZ+NiepSm/QvGvMQbNw/kC5qgBki47tuWsjB7
   YWnoKTDF+j0BHFTpDhG9xFRq5v2heFXJj87dO4yFZ/7nBi5VKfRutEwr1
   LhTUUeu40xE3IbP+H8VK7tN/k2Cg3VL2pFOQDWsR78oa5dw1NBXy+A13B
   YS2OVzDHPDHmAMDSTWK1gAMpDvLoo1mi0OXFeIFQsrQKj8mvR7hRP6U82
   c509UKeqxdYzWVWy6yfkOlLqedX28sPM8waRTq4Dt0UrvkT/8t54bhTcm
   b4d4V+xKyQfPPnKdH6EPo55qpZLK/9NCAXpNB4hiZabLjI8G0xAFXwzzN
   w==;
X-CSE-ConnectionGUID: /lZVJ7rZSfK6VIiMCKyf1A==
X-CSE-MsgGUID: Yo9J0bN5Q7yPSZk5dy8oiA==
X-IronPort-AV: E=McAfee;i="6700,10204,11199"; a="25813795"
X-IronPort-AV: E=Sophos;i="6.10,240,1719903600"; 
   d="scan'208";a="25813795"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2024 22:56:47 -0700
X-CSE-ConnectionGUID: rMNYl1sATnOo2bqgjGFlQw==
X-CSE-MsgGUID: V3LeJGc2RIC+vnG1nDqGFA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,240,1719903600"; 
   d="scan'208";a="69418845"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by fmviesa006.fm.intel.com with ESMTP; 18 Sep 2024 22:56:41 -0700
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
Subject: [RFC v2 12/12] i386: Support custom topology for microvm, pc-i440fx and pc-q35
Date: Thu, 19 Sep 2024 14:11:28 +0800
Message-Id: <20240919061128.769139-13-zhao1.liu@intel.com>
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

With custom topology enabling, user could configure hyrid CPU topology
from CLI.

For example, create a Intel Core (P core) with 2 threads and 2 Intel
Atom (E core) with single thread for PC machine:

-smp maxsockets=1,maxdies=1,maxmodules=2,maxcores=2,maxthreads=2
-machine pc,custom-topo=on \
-device cpu-socket,id=sock0 \
-device cpu-die,id=die0,bus=sock0 \
-device cpu-module,id=mod0,bus=die0 \
-device cpu-module,id=mod1,bus=die0 \
-device x86-intel-core,id=core0,bus=mod0 \
-device x86-intel-atom,id=core1,bus=mod1 \
-device x86-intel-atom,id=core2,bus=mod1 \
-device host-x86_64-cpu,id=cpu0,socket-id=0,die-id=0,module-id=0,core-id=0,thread-id=0 \
-device host-x86_64-cpu,id=cpu1,socket-id=0,die-id=0,module-id=0,core-id=0,thread-id=1 \
-device host-x86_64-cpu,id=cpu2,socket-id=0,die-id=0,module-id=1,core-id=0,thread-id=0 \
-device host-x86_64-cpu,id=cpu3,socket-id=0,die-id=0,module-id=1,core-id=1,thread-id=0

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 hw/i386/microvm.c    | 1 +
 hw/i386/pc_piix.c    | 1 +
 hw/i386/pc_q35.c     | 1 +
 hw/i386/x86-common.c | 6 ++++++
 4 files changed, 9 insertions(+)

diff --git a/hw/i386/microvm.c b/hw/i386/microvm.c
index dc9b21a34230..bd03b6946e6c 100644
--- a/hw/i386/microvm.c
+++ b/hw/i386/microvm.c
@@ -671,6 +671,7 @@ static void microvm_class_init(ObjectClass *oc, void *data)
     mc->reset = microvm_machine_reset;
 
     mc->post_init = microvm_machine_state_post_init;
+    mc->smp_props.custom_topo_supported = true;
 
     /* hotplug (for cpu coldplug) */
     mc->get_hotplug_handler = microvm_get_hotplug_handler;
diff --git a/hw/i386/pc_piix.c b/hw/i386/pc_piix.c
index c1db2f3129cf..9c696a226858 100644
--- a/hw/i386/pc_piix.c
+++ b/hw/i386/pc_piix.c
@@ -473,6 +473,7 @@ static void pc_i440fx_machine_options(MachineClass *m)
     m->no_floppy = !module_object_class_by_name(TYPE_ISA_FDC);
     m->no_parallel = !module_object_class_by_name(TYPE_ISA_PARALLEL);
     m->post_init = pc_post_init1;
+    m->smp_props.custom_topo_supported = true;
     machine_class_allow_dynamic_sysbus_dev(m, TYPE_RAMFB_DEVICE);
     machine_class_allow_dynamic_sysbus_dev(m, TYPE_VMBUS_BRIDGE);
 
diff --git a/hw/i386/pc_q35.c b/hw/i386/pc_q35.c
index 9ce3e65d7182..9241366ff351 100644
--- a/hw/i386/pc_q35.c
+++ b/hw/i386/pc_q35.c
@@ -356,6 +356,7 @@ static void pc_q35_machine_options(MachineClass *m)
     m->max_cpus = 4096;
     m->no_parallel = !module_object_class_by_name(TYPE_ISA_PARALLEL);
     m->post_init = pc_q35_post_init;
+    m->smp_props.custom_topo_supported = true;
     machine_class_allow_dynamic_sysbus_dev(m, TYPE_AMD_IOMMU_DEVICE);
     machine_class_allow_dynamic_sysbus_dev(m, TYPE_INTEL_IOMMU_DEVICE);
     machine_class_allow_dynamic_sysbus_dev(m, TYPE_RAMFB_DEVICE);
diff --git a/hw/i386/x86-common.c b/hw/i386/x86-common.c
index 58591e015569..2995eed5d670 100644
--- a/hw/i386/x86-common.c
+++ b/hw/i386/x86-common.c
@@ -195,6 +195,12 @@ void x86_cpus_init(X86MachineState *x86ms, int default_cpu_version)
     }
 
     possible_cpus = mc->possible_cpu_arch_ids(ms);
+
+    /* Leave user to add CPUs. */
+    if (ms->topo->custom_topo_enabled) {
+        return;
+    }
+
     for (i = 0; i < ms->smp.cpus; i++) {
         x86_cpu_new(x86ms, i, possible_cpus->cpus[i].arch_id, &error_fatal);
     }
-- 
2.34.1


