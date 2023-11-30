Return-Path: <kvm+bounces-2949-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 26D557FF201
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 15:34:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4F1D3B217C0
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 14:34:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04C9851C3C;
	Thu, 30 Nov 2023 14:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DDMxUwVD"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B3E385
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 06:34:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701354850; x=1732890850;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=IhpodbfJau6szIdQazmb+IK5Vtn7KUNNpXNSlzloW+Q=;
  b=DDMxUwVDVQzq66QkJ4aOUygoO8SDxvFuGJ/4Er5sk3LDA3hglk1sYARQ
   wQ3A1B+eo8pRZKd6nUZ+Xu1vQCbuNASN4cuhz+IDTb8pDDkcUfaffT/uF
   jmRhC7x6WImSGTWiceIGxuB/LSB8pKRxNdKaQg2VBSPOzsGYfYkZZ8VEY
   XN/+eRnLCnc49VUsDVOvxEjtxQamKwHvx6RyvYO3YVdnS95mxGSDqP0Y+
   WaJeZNs0ItEc2PGJp9EJyUuzAKhlubUhqBFnrWBB4wGKgsDXm+hb+C9k9
   eKwW16iaTcpy8ZcILMawbqgu1YgdcgVUsTg8/TSI0ibhaGQj2535X0Jom
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10910"; a="479532145"
X-IronPort-AV: E=Sophos;i="6.04,239,1695711600"; 
   d="scan'208";a="479532145"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2023 06:34:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10910"; a="942730068"
X-IronPort-AV: E=Sophos;i="6.04,239,1695711600"; 
   d="scan'208";a="942730068"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by orsmga005.jf.intel.com with ESMTP; 30 Nov 2023 06:34:00 -0800
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
Subject: [RFC 23/41] hw/cpu/die: Abstract cpu-die level as topology device
Date: Thu, 30 Nov 2023 22:41:45 +0800
Message-Id: <20231130144203.2307629-24-zhao1.liu@linux.intel.com>
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

Abstract die level as a topology device "cpu-die" to allow user to
create die level topology from cli and later the cpu-dies could be added
into topology tree.

In addition, mark the cpu-die as DEVICE_CATEGORY_CPU_DEF category to
indicate it belongs to the basic CPU definition and should be created
from cli before board initialization.

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 MAINTAINERS          |  2 ++
 hw/cpu/die.c         | 46 ++++++++++++++++++++++++++++++++++++++++++++
 hw/cpu/meson.build   |  2 +-
 include/hw/cpu/die.h | 38 ++++++++++++++++++++++++++++++++++++
 4 files changed, 87 insertions(+), 1 deletion(-)
 create mode 100644 hw/cpu/die.c
 create mode 100644 include/hw/cpu/die.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 89e350866d6a..91d0936edb32 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1863,6 +1863,7 @@ F: hw/core/machine-smp.c
 F: hw/core/null-machine.c
 F: hw/core/numa.c
 F: hw/cpu/cluster.c
+F: hw/cpu/die.c
 F: qapi/machine.json
 F: qapi/machine-common.json
 F: qapi/machine-target.json
@@ -1870,6 +1871,7 @@ F: include/hw/boards.h
 F: include/hw/core/cpu.h
 F: include/hw/core/cpu-topo.h
 F: include/hw/cpu/cluster.h
+F: include/hw/cpu/die.h
 F: include/sysemu/numa.h
 F: tests/unit/test-smp-parse.c
 T: git https://gitlab.com/ehabkost/qemu.git machine-next
diff --git a/hw/cpu/die.c b/hw/cpu/die.c
new file mode 100644
index 000000000000..06c4f7cc8fa2
--- /dev/null
+++ b/hw/cpu/die.c
@@ -0,0 +1,46 @@
+/*
+ * CPU die abstract device
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
+#include "hw/cpu/die.h"
+
+static void cpu_die_class_init(ObjectClass *oc, void *data)
+{
+    DeviceClass *dc = DEVICE_CLASS(oc);
+    CPUTopoClass *tc = CPU_TOPO_CLASS(oc);
+
+    set_bit(DEVICE_CATEGORY_CPU_DEF, dc->categories);
+
+    tc->level = CPU_TOPO_DIE;
+}
+
+static const TypeInfo cpu_die_type_info = {
+    .name = TYPE_CPU_DIE,
+    .parent = TYPE_CPU_TOPO,
+    .class_init = cpu_die_class_init,
+    .instance_size = sizeof(CPUDie),
+};
+
+static void cpu_die_register_types(void)
+{
+    type_register_static(&cpu_die_type_info);
+}
+
+type_init(cpu_die_register_types)
diff --git a/hw/cpu/meson.build b/hw/cpu/meson.build
index 6d319947ca0b..e685fe1c7d8a 100644
--- a/hw/cpu/meson.build
+++ b/hw/cpu/meson.build
@@ -1,4 +1,4 @@
-system_ss.add(files('core.c', 'cluster.c'))
+system_ss.add(files('core.c', 'cluster.c', 'die.c'))
 
 system_ss.add(when: 'CONFIG_ARM11MPCORE', if_true: files('arm11mpcore.c'))
 system_ss.add(when: 'CONFIG_REALVIEW', if_true: files('realview_mpcore.c'))
diff --git a/include/hw/cpu/die.h b/include/hw/cpu/die.h
new file mode 100644
index 000000000000..4c68786b5f2f
--- /dev/null
+++ b/include/hw/cpu/die.h
@@ -0,0 +1,38 @@
+/*
+ * CPU die abstract device
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
+#ifndef HW_CPU_DIE_H
+#define HW_CPU_DIE_H
+
+#include "hw/core/cpu-topo.h"
+#include "hw/qdev-core.h"
+
+#define TYPE_CPU_DIE "cpu-die"
+
+OBJECT_DECLARE_SIMPLE_TYPE(CPUDie, CPU_DIE)
+
+struct CPUDie {
+    /*< private >*/
+    CPUTopoState obj;
+
+    /*< public >*/
+};
+
+#endif /* HW_CPU_DIE_H */
-- 
2.34.1


