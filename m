Return-Path: <kvm+bounces-2966-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A3307FF22D
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 15:37:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8A9541C20DEC
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 14:37:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A51A4879F;
	Thu, 30 Nov 2023 14:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cJJcnj4d"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B169DB5
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 06:36:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701355012; x=1732891012;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=n1bOTd1De6zljXfwth5hOf8VQYb/0aDsDjxTGUGzfGQ=;
  b=cJJcnj4djBSXCFZKU33AlXGj9mOn+ducggIf8x7DGjj3JShPVMkMvfvs
   S+CVuRrAuM5PD+ZFCW6gYfjkFZuZhzKf/M6Z3jaWu7zU6cXsezzer+oTy
   Jh/hnDrvB7hHX0CQ8IDf2i+YzDUDPTEBNupmrCXaMxn49J9bSIdvcm2KN
   CMPtwJQLN5sLxkYQtYdvcr54HbYAo9mn6D+dXjM9QXW4uU2BK9wwGjkJW
   HDD663qPprD9YGxnUI+w4JODQvN5dxb6X46HSIjaWi8H5+HAn4+47r7qi
   K90S8/MIAvd5uHd9lJZ0vva1wtCSwUp2Hr/Dl1M1zaGsERMsza+wTdheK
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10910"; a="479532830"
X-IronPort-AV: E=Sophos;i="6.04,239,1695711600"; 
   d="scan'208";a="479532830"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2023 06:36:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10910"; a="942730582"
X-IronPort-AV: E=Sophos;i="6.04,239,1695711600"; 
   d="scan'208";a="942730582"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by orsmga005.jf.intel.com with ESMTP; 30 Nov 2023 06:36:42 -0800
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
Subject: [RFC 40/41] hw/i386: Support QOM topology
Date: Thu, 30 Nov 2023 22:42:02 +0800
Message-Id: <20231130144203.2307629-41-zhao1.liu@linux.intel.com>
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

Set MachineClass.smp_props.possible_cpus_qom_granu and
TopoClass.search_parent_pre_plug for i386.

So far, the i386 topology is based on the QOM topology.

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 hw/i386/x86.c     | 1 +
 target/i386/cpu.c | 4 ++++
 2 files changed, 5 insertions(+)

diff --git a/hw/i386/x86.c b/hw/i386/x86.c
index 595d4365fdd1..99f6c502de43 100644
--- a/hw/i386/x86.c
+++ b/hw/i386/x86.c
@@ -1565,6 +1565,7 @@ static void x86_machine_class_init(ObjectClass *oc, void *data)
     mc->cpu_index_to_instance_props = x86_cpu_index_to_props;
     mc->get_default_cpu_node_id = x86_get_default_cpu_node_id;
     mc->possible_cpu_arch_ids = x86_possible_cpu_arch_ids;
+    mc->smp_props.possible_cpus_qom_granu = CPU_TOPO_THREAD;
     x86mc->save_tsc_khz = true;
     x86mc->fwcfg_dma_enabled = true;
     nc->nmi_monitor_handler = x86_nmi;
diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index cd16cb893daf..1de5726691e1 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -41,6 +41,7 @@
 #include "exec/address-spaces.h"
 #include "hw/boards.h"
 #include "hw/i386/sgx-epc.h"
+#include "hw/i386/x86.h"
 #endif
 
 #include "disas/capstone.h"
@@ -8009,6 +8010,9 @@ static void x86_cpu_common_class_init(ObjectClass *oc, void *data)
 #if !defined(CONFIG_USER_ONLY)
     object_class_property_add(oc, "crash-information", "GuestPanicInformation",
                               x86_cpu_get_crash_info_qom, NULL, NULL, NULL);
+
+    CPU_TOPO_CLASS(oc)->search_parent_pre_plug =
+        x86_cpu_search_parent_pre_plug;
 #endif
 
     for (w = 0; w < FEATURE_WORDS; w++) {
-- 
2.34.1


