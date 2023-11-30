Return-Path: <kvm+bounces-2952-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BD50E7FF20B
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 15:34:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 786C82825F7
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 14:34:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81CC251001;
	Thu, 30 Nov 2023 14:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="C1oXJx6L"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71B3693
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 06:34:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701354878; x=1732890878;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RiCVpo1qnLcoDF3gFOkmvt/7Et6vXhRGVnHUCJw060w=;
  b=C1oXJx6LFfRijL7UDcD55xtdke5NEqDVMrgviEKAfR6ROrazjKETGRO9
   Bo0zfeQhJzEfNRLcmu+0izLtZM5p5Onew2g9tiuP6CpsyWTTuoUoJxqGt
   kIu99PsI6jXzVe38WdUspqIgcOkirAH36CgTsUhXPRboYzlakiWdLxZvj
   i2woSfxdNVuFgznqLrzlV2dIs2zdcQAvtUnOU+DubMKMgycCeblqVPm7w
   3zznz8rTltKT44DINW3GlX+nzJhAFanva1l5sURrCuQbklgyOX8ZFux56
   se0/bKU5tW/cMLBii3AP8+g696iobeGNqAvhRIjbshEfsBBhHYUXFmhMJ
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10910"; a="479532237"
X-IronPort-AV: E=Sophos;i="6.04,239,1695711600"; 
   d="scan'208";a="479532237"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2023 06:34:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10910"; a="942730101"
X-IronPort-AV: E=Sophos;i="6.04,239,1695711600"; 
   d="scan'208";a="942730101"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by orsmga005.jf.intel.com with ESMTP; 30 Nov 2023 06:34:28 -0800
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
Subject: [RFC 26/41] hw/cpu/drawer: Abstract cpu-drawer level as topology device
Date: Thu, 30 Nov 2023 22:41:48 +0800
Message-Id: <20231130144203.2307629-27-zhao1.liu@linux.intel.com>
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

Abstract drawer level as a topology device "cpu-drawer" to allow user to
create drawer level topology from cli and later the cpu-drawers could be
added into topology tree.

In addition, mark the cpu-drawer as DEVICE_CATEGORY_CPU_DEF category to
indicate it belongs to the basic CPU definition and should be created
from cli before board initialization.

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 MAINTAINERS             |  2 ++
 hw/cpu/drawer.c         | 46 +++++++++++++++++++++++++++++++++++++++++
 hw/cpu/meson.build      |  2 +-
 include/hw/cpu/drawer.h | 38 ++++++++++++++++++++++++++++++++++
 4 files changed, 87 insertions(+), 1 deletion(-)
 create mode 100644 hw/cpu/drawer.c
 create mode 100644 include/hw/cpu/drawer.h

diff --git a/MAINTAINERS b/MAINTAINERS
index dd5adfda64cc..4b373ff46ce3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1865,6 +1865,7 @@ F: hw/core/numa.c
 F: hw/cpu/book.c
 F: hw/cpu/cluster.c
 F: hw/cpu/die.c
+F: hw/cpu/drawer.c
 F: hw/cpu/socket.c
 F: qapi/machine.json
 F: qapi/machine-common.json
@@ -1875,6 +1876,7 @@ F: include/hw/core/cpu-topo.h
 F: include/hw/cpu/book.h
 F: include/hw/cpu/cluster.h
 F: include/hw/cpu/die.h
+F: include/hw/cpu/drawer.h
 F: include/hw/cpu/socket.h
 F: include/sysemu/numa.h
 F: tests/unit/test-smp-parse.c
diff --git a/hw/cpu/drawer.c b/hw/cpu/drawer.c
new file mode 100644
index 000000000000..f1ccfd153284
--- /dev/null
+++ b/hw/cpu/drawer.c
@@ -0,0 +1,46 @@
+/*
+ * CPU drawer abstract device
+ *
+ * Copyright (c) 2023 Intel Corporation
+ * Author: Zhao Liu <zhao1.liu@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License,
+ * or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include "qemu/osdep.h"
+#include "hw/cpu/drawer.h"
+
+static void cpu_drawer_class_init(ObjectClass *oc, void *data)
+{
+    DeviceClass *dc = DEVICE_CLASS(oc);
+    CPUTopoClass *tc = CPU_TOPO_CLASS(oc);
+
+    set_bit(DEVICE_CATEGORY_CPU_DEF, dc->categories);
+
+    tc->level = CPU_TOPO_DRAWER;
+}
+
+static const TypeInfo cpu_drawer_type_info = {
+    .name = TYPE_CPU_DRAWER,
+    .parent = TYPE_CPU_TOPO,
+    .class_init = cpu_drawer_class_init,
+    .instance_size = sizeof(CPUDrawer),
+};
+
+static void cpu_drawer_register_types(void)
+{
+    type_register_static(&cpu_drawer_type_info);
+}
+
+type_init(cpu_drawer_register_types)
diff --git a/hw/cpu/meson.build b/hw/cpu/meson.build
index c44b54c5abb0..0dea39364b98 100644
--- a/hw/cpu/meson.build
+++ b/hw/cpu/meson.build
@@ -1,4 +1,4 @@
-system_ss.add(files('core.c', 'cluster.c', 'die.c', 'socket.c', 'book.c'))
+system_ss.add(files('core.c', 'cluster.c', 'die.c', 'socket.c', 'book.c', 'drawer.c'))
 
 system_ss.add(when: 'CONFIG_ARM11MPCORE', if_true: files('arm11mpcore.c'))
 system_ss.add(when: 'CONFIG_REALVIEW', if_true: files('realview_mpcore.c'))
diff --git a/include/hw/cpu/drawer.h b/include/hw/cpu/drawer.h
new file mode 100644
index 000000000000..34ae089d33bf
--- /dev/null
+++ b/include/hw/cpu/drawer.h
@@ -0,0 +1,38 @@
+/*
+ * CPU drawer abstract device
+ *
+ * Copyright (c) 2023 Intel Corporation
+ * Author: Zhao Liu <zhao1.liu@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License,
+ * or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see <http://www.gnu.org/licenses/>.
+ */
+
+#ifndef HW_CPU_DRAWER_H
+#define HW_CPU_DRAWER_H
+
+#include "hw/core/cpu-topo.h"
+#include "hw/qdev-core.h"
+
+#define TYPE_CPU_DRAWER "cpu-drawer"
+
+OBJECT_DECLARE_SIMPLE_TYPE(CPUDrawer, CPU_DRAWER)
+
+struct CPUDrawer {
+    /*< private >*/
+    CPUTopoState obj;
+
+    /*< public >*/
+};
+
+#endif /* HW_CPU_DRAWER_H */
-- 
2.34.1


