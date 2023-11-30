Return-Path: <kvm+bounces-2953-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F1147FF20D
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 15:34:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B7D7328261F
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 14:34:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B3DD51011;
	Thu, 30 Nov 2023 14:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="S/litHEE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2C0D85
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 06:34:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701354887; x=1732890887;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dK+ilj3Q1LqgiJ2/EiJWYjQp1qXfjG6+/g3hE8BTtcM=;
  b=S/litHEEPlLj4+wgkh1mEAp5J1yrYpLldgYLk0xRximKCTZWGG+W1rZf
   XxztKhczgxavnNT2Q60R58VEb1r8Zvtj7LaKkERfZcvbnXSrjVuggSB2U
   S/fXmcExIUg/EtyqETQRU762lZ2DfjcWsNHjbcQBz9/igPVGpygZkLyse
   36X13NukCQVpVEQSMuCZEfxONFxHSGUzN5zU1pCpbRuk3oJx3uDLRneZw
   MqOi+KeHYYDO3TBify8CvFHKL838HprEG4VzQR2bZncgc7K9rSpm+MX7x
   WX2QWBgF7zTRaZ55GiYnCYoAzlW2KVqsjSUcituJpRwi2yyN0ZMo9x0XT
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10910"; a="479532294"
X-IronPort-AV: E=Sophos;i="6.04,239,1695711600"; 
   d="scan'208";a="479532294"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2023 06:34:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10910"; a="942730118"
X-IronPort-AV: E=Sophos;i="6.04,239,1695711600"; 
   d="scan'208";a="942730118"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by orsmga005.jf.intel.com with ESMTP; 30 Nov 2023 06:34:37 -0800
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
Subject: [RFC 27/41] hw/core/slot: Introduce CPU slot as the root of CPU topology
Date: Thu, 30 Nov 2023 22:41:49 +0800
Message-Id: <20231130144203.2307629-28-zhao1.liu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231130144203.2307629-1-zhao1.liu@linux.intel.com>
References: <20231130144203.2307629-1-zhao1.liu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhao Liu <zhao1.liu@intel.com>

Abstract the root of topology tree as a special topology device
"cpu-slot".

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 MAINTAINERS                |  2 ++
 hw/core/cpu-slot.c         | 48 ++++++++++++++++++++++++++++++++++++++
 hw/core/meson.build        |  1 +
 include/hw/core/cpu-slot.h | 38 ++++++++++++++++++++++++++++++
 4 files changed, 89 insertions(+)
 create mode 100644 hw/core/cpu-slot.c
 create mode 100644 include/hw/core/cpu-slot.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 4b373ff46ce3..ac08b5a8c4e0 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1856,6 +1856,7 @@ R: Philippe Mathieu-Daudé <philmd@linaro.org>
 R: Yanan Wang <wangyanan55@huawei.com>
 S: Supported
 F: hw/core/cpu.c
+F: hw/core/cpu-slot.c
 F: hw/core/cpu-topo.c
 F: hw/core/machine-qmp-cmds.c
 F: hw/core/machine.c
@@ -1872,6 +1873,7 @@ F: qapi/machine-common.json
 F: qapi/machine-target.json
 F: include/hw/boards.h
 F: include/hw/core/cpu.h
+F: include/hw/core/cpu-slot.h
 F: include/hw/core/cpu-topo.h
 F: include/hw/cpu/book.h
 F: include/hw/cpu/cluster.h
diff --git a/hw/core/cpu-slot.c b/hw/core/cpu-slot.c
new file mode 100644
index 000000000000..5aef5b0189c2
--- /dev/null
+++ b/hw/core/cpu-slot.c
@@ -0,0 +1,48 @@
+/*
+ * CPU slot device abstraction
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
+
+#include "hw/core/cpu-slot.h"
+
+static void cpu_slot_class_init(ObjectClass *oc, void *data)
+{
+    DeviceClass *dc = DEVICE_CLASS(oc);
+    CPUTopoClass *tc = CPU_TOPO_CLASS(oc);
+
+    set_bit(DEVICE_CATEGORY_CPU_DEF, dc->categories);
+    dc->user_creatable = false;
+
+    tc->level = CPU_TOPO_ROOT;
+}
+
+static const TypeInfo cpu_slot_type_info = {
+    .name = TYPE_CPU_SLOT,
+    .parent = TYPE_CPU_TOPO,
+    .class_init = cpu_slot_class_init,
+    .instance_size = sizeof(CPUSlot),
+};
+
+static void cpu_slot_register_types(void)
+{
+    type_register_static(&cpu_slot_type_info);
+}
+
+type_init(cpu_slot_register_types)
diff --git a/hw/core/meson.build b/hw/core/meson.build
index 501d2529697e..3347c054e162 100644
--- a/hw/core/meson.build
+++ b/hw/core/meson.build
@@ -23,6 +23,7 @@ else
 endif
 
 common_ss.add(files('cpu-common.c'))
+common_ss.add(files('cpu-slot.c'))
 common_ss.add(files('cpu-topo.c'))
 common_ss.add(files('machine-smp.c'))
 system_ss.add(when: 'CONFIG_FITLOADER', if_true: files('loader-fit.c'))
diff --git a/include/hw/core/cpu-slot.h b/include/hw/core/cpu-slot.h
new file mode 100644
index 000000000000..718c8ecaa751
--- /dev/null
+++ b/include/hw/core/cpu-slot.h
@@ -0,0 +1,38 @@
+/*
+ * CPU slot device abstraction
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
+#ifndef CPU_SLOT_H
+#define CPU_SLOT_H
+
+#include "hw/core/cpu-topo.h"
+#include "hw/qdev-core.h"
+
+#define TYPE_CPU_SLOT "cpu-slot"
+
+OBJECT_DECLARE_SIMPLE_TYPE(CPUSlot, CPU_SLOT)
+
+struct CPUSlot {
+    /*< private >*/
+    CPUTopoState parent_obj;
+
+    /*< public >*/
+};
+
+#endif /* CPU_SLOT_H */
-- 
2.34.1


