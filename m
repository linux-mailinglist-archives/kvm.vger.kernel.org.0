Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD1EF323906
	for <lists+kvm@lfdr.de>; Wed, 24 Feb 2021 09:50:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234512AbhBXIuf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Feb 2021 03:50:35 -0500
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:30360 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234163AbhBXIt2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Feb 2021 03:49:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1614156568; x=1645692568;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=GBixk0bY31BaRj+oTNFRWto5HJ/WoStkkYZ0X+blJ/Q=;
  b=MZznFhGJk3B84Ca9QqodY9vv/dL0iqBL1ldL5pDW9qo0EEZ48SlHdg0d
   Ls5x45qjjkRhVRcctip90UwVB1RxgkXbwk2mY/I5gpVgq/Ft6FKd90pxF
   5R6tbOOWJaiN1cFBrKzkbPtWKQkdz81T8e2GBZ6PEtGFzXIMfOFqPoN+g
   o=;
X-IronPort-AV: E=Sophos;i="5.81,202,1610409600"; 
   d="scan'208";a="90157180"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1e-57e1d233.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 24 Feb 2021 08:48:39 +0000
Received: from EX13D08EUB004.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1e-57e1d233.us-east-1.amazon.com (Postfix) with ESMTPS id 577BA1416D4;
        Wed, 24 Feb 2021 08:48:26 +0000 (UTC)
Received: from uf6ed9c851f4556.ant.amazon.com (10.43.160.157) by
 EX13D08EUB004.ant.amazon.com (10.43.166.158) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 24 Feb 2021 08:48:11 +0000
From:   Adrian Catangiu <acatan@amazon.com>
To:     <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>,
        <linux-s390@vger.kernel.org>
CC:     <gregkh@linuxfoundation.org>, <graf@amazon.com>,
        <rdunlap@infradead.org>, <arnd@arndb.de>, <ebiederm@xmission.com>,
        <rppt@kernel.org>, <0x7f454c46@gmail.com>,
        <borntraeger@de.ibm.com>, <Jason@zx2c4.com>, <jannh@google.com>,
        <w@1wt.eu>, <colmmacc@amazon.com>, <luto@kernel.org>,
        <tytso@mit.edu>, <ebiggers@kernel.org>, <dwmw@amazon.co.uk>,
        <bonzini@gnu.org>, <sblbir@amazon.com>, <raduweis@amazon.com>,
        <corbet@lwn.net>, <mst@redhat.com>, <mhocko@kernel.org>,
        <rafael@kernel.org>, <pavel@ucw.cz>, <mpe@ellerman.id.au>,
        <areber@redhat.com>, <ovzxemul@gmail.com>, <avagin@gmail.com>,
        <ptikhomirov@virtuozzo.com>, <gil@azul.com>, <asmehra@redhat.com>,
        <dgunigun@redhat.com>, <vijaysun@ca.ibm.com>, <oridgar@gmail.com>,
        <ghammer@redhat.com>, Adrian Catangiu <acatan@amazon.com>
Subject: [PATCH v7 2/2] drivers/virt: vmgenid: add vm generation id driver
Date:   Wed, 24 Feb 2021 10:47:32 +0200
Message-ID: <1614156452-17311-3-git-send-email-acatan@amazon.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1614156452-17311-1-git-send-email-acatan@amazon.com>
References: <1614156452-17311-1-git-send-email-acatan@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.160.157]
X-ClientProxiedBy: EX13D38UWC002.ant.amazon.com (10.43.162.46) To
 EX13D08EUB004.ant.amazon.com (10.43.166.158)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The VM Generation ID is a feature defined by Microsoft (paper:
http://go.microsoft.com/fwlink/?LinkId=260709) and supported by
multiple hypervisor vendors.

The feature can be used to drive the `sysgenid` mechanism required in
virtualized environments by software that works with local copies and
caches of world-unique data such as random values, uuids, monotonically
increasing counters, etc.

The VM Generation ID is a hypervisor/hardware provided 128-bit unique
ID that changes each time the VM is restored from a snapshot. It can be
used to differentiate between VMs or different generations of the same
VM.
This VM Generation ID is exposed through an ACPI device by multiple
hypervisor vendors.

The `vmgenid` driver acts as a backend for the `sysgenid` kernel module
(`drivers/misc/sysgenid.c`, `Documentation/misc-devices/sysgenid.rst`)
to drive changes to the "System Generation Id" which is further exposed
to userspace as a monotonically increasing counter.

The driver uses ACPI events to be notified by hardware of changes to the
128-bit Vm Gen Id UUID. Since the actual UUID value is not directly exposed
to userspace, but only used to drive the System Generation Counter, the
driver also adds it as device randomness to improve kernel entropy
following VM snapshot events.

This patch builds on top of Or Idgar <oridgar@gmail.com>'s proposal
https://lkml.org/lkml/2018/3/1/498

Signed-off-by: Adrian Catangiu <acatan@amazon.com>
---
 Documentation/virt/vmgenid.rst |  36 ++++++++++
 MAINTAINERS                    |   7 ++
 drivers/virt/Kconfig           |  13 ++++
 drivers/virt/Makefile          |   1 +
 drivers/virt/vmgenid.c         | 153 +++++++++++++++++++++++++++++++++++++++++
 5 files changed, 210 insertions(+)
 create mode 100644 Documentation/virt/vmgenid.rst
 create mode 100644 drivers/virt/vmgenid.c

diff --git a/Documentation/virt/vmgenid.rst b/Documentation/virt/vmgenid.rst
new file mode 100644
index 0000000..a429c2a3
--- /dev/null
+++ b/Documentation/virt/vmgenid.rst
@@ -0,0 +1,36 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=======
+VMGENID
+=======
+
+The VM Generation ID is a feature defined by Microsoft (paper:
+http://go.microsoft.com/fwlink/?LinkId=260709) and supported by
+multiple hypervisor vendors.
+
+The feature is required in virtualized environments by applications
+that work with local copies/caches of world-unique data such as random
+values, UUIDs, monotonically increasing counters, etc.
+Such applications can be negatively affected by VM snapshotting when
+the VM is either cloned or returned to an earlier point in time.
+
+The VM Generation ID is a simple concept through which a hypevisor
+notifies its guest that a snapshot has taken place. The vmgenid device
+provides a unique ID that changes each time the VM is restored from a
+snapshot. The hardware provided UUID value can be used to differentiate
+between VMs or different generations of the same VM.
+
+The VM Generation ID is exposed through an ACPI device by multiple
+hypervisor vendors. The driver for it lives at
+``drivers/virt/vmgenid.c``
+
+The ``vmgenid`` driver acts as a backend for the ``sysgenid`` kernel module
+(``drivers/misc/sysgenid.c``, ``Documentation/misc-devices/sysgenid.rst``)
+to drive changes to the "System Generation Id" which is further exposed
+to userspace as a monotonically increasing counter.
+
+The driver uses ACPI events to be notified by hardware of changes to the
+128-bit Vm Gen Id UUID. Since the actual UUID value is not directly exposed
+to userspace, but only used to drive the System Generation Counter, the
+driver also adds it as device randomness to improve kernel entropy
+following VM snapshot events.
diff --git a/MAINTAINERS b/MAINTAINERS
index b812dad8..f21451e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -19086,6 +19086,13 @@ F:	drivers/staging/vme/
 F:	drivers/vme/
 F:	include/linux/vme*
 
+VMGENID
+M:	Adrian Catangiu <acatan@amazon.com>
+L:	linux-kernel@vger.kernel.org
+S:	Supported
+F:	Documentation/virt/vmgenid.rst
+F:	drivers/virt/vmgenid.c
+
 VMWARE BALLOON DRIVER
 M:	Nadav Amit <namit@vmware.com>
 M:	"VMware, Inc." <pv-drivers@vmware.com>
diff --git a/drivers/virt/Kconfig b/drivers/virt/Kconfig
index 80c5f9c1..95d82c9 100644
--- a/drivers/virt/Kconfig
+++ b/drivers/virt/Kconfig
@@ -13,6 +13,19 @@ menuconfig VIRT_DRIVERS
 
 if VIRT_DRIVERS
 
+config VMGENID
+	tristate "Virtual Machine Generation ID driver"
+	depends on ACPI && SYSGENID
+	help
+	  The driver uses the hypervisor provided Virtual Machine Generation ID
+	  to drive the system generation counter mechanism exposed by sysgenid.
+	  The vmgenid changes on VM snapshots or VM cloning. The hypervisor
+	  provided 128-bit vmgenid is also used as device randomness to improve
+	  kernel entropy following VM snapshot events.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called vmgenid.
+
 config FSL_HV_MANAGER
 	tristate "Freescale hypervisor management driver"
 	depends on FSL_SOC
diff --git a/drivers/virt/Makefile b/drivers/virt/Makefile
index f28425c..889be01 100644
--- a/drivers/virt/Makefile
+++ b/drivers/virt/Makefile
@@ -4,6 +4,7 @@
 #
 
 obj-$(CONFIG_FSL_HV_MANAGER)	+= fsl_hypervisor.o
+obj-$(CONFIG_VMGENID)		+= vmgenid.o
 obj-y				+= vboxguest/
 
 obj-$(CONFIG_NITRO_ENCLAVES)	+= nitro_enclaves/
diff --git a/drivers/virt/vmgenid.c b/drivers/virt/vmgenid.c
new file mode 100644
index 0000000..d9d089a
--- /dev/null
+++ b/drivers/virt/vmgenid.c
@@ -0,0 +1,153 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Virtual Machine Generation ID driver
+ *
+ * Copyright (C) 2018 Red Hat Inc. All rights reserved.
+ *
+ * Copyright (C) 2020 Amazon. All rights reserved.
+ *
+ *	Authors:
+ *	  Adrian Catangiu <acatan@amazon.com>
+ *	  Or Idgar <oridgar@gmail.com>
+ *	  Gal Hammer <ghammer@redhat.com>
+ *
+ */
+#include <linux/acpi.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/random.h>
+#include <linux/uuid.h>
+#include <linux/sysgenid.h>
+
+#define DEV_NAME "vmgenid"
+ACPI_MODULE_NAME(DEV_NAME);
+
+struct vmgenid_data {
+	uuid_t uuid;
+	void *uuid_iomap;
+};
+static struct vmgenid_data vmgenid_data;
+
+static int vmgenid_acpi_map(struct vmgenid_data *priv, acpi_handle handle)
+{
+	int i;
+	phys_addr_t phys_addr;
+	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
+	acpi_status status;
+	union acpi_object *pss;
+	union acpi_object *element;
+
+	status = acpi_evaluate_object(handle, "ADDR", NULL, &buffer);
+	if (ACPI_FAILURE(status)) {
+		ACPI_EXCEPTION((AE_INFO, status, "Evaluating ADDR"));
+		return -ENODEV;
+	}
+	pss = buffer.pointer;
+	if (!pss || pss->type != ACPI_TYPE_PACKAGE || pss->package.count != 2)
+		return -EINVAL;
+
+	phys_addr = 0;
+	for (i = 0; i < pss->package.count; i++) {
+		element = &(pss->package.elements[i]);
+		if (element->type != ACPI_TYPE_INTEGER)
+			return -EINVAL;
+		phys_addr |= element->integer.value << i * 32;
+	}
+
+	priv->uuid_iomap = acpi_os_map_memory(phys_addr, sizeof(uuid_t));
+	if (!priv->uuid_iomap) {
+		pr_err("Could not map memory at 0x%llx, size %u\n",
+			   phys_addr,
+			   (u32) sizeof(uuid_t));
+		return -ENOMEM;
+	}
+
+	memcpy_fromio(&priv->uuid, priv->uuid_iomap, sizeof(uuid_t));
+
+	return 0;
+}
+
+static int vmgenid_acpi_add(struct acpi_device *device)
+{
+	int ret;
+
+	if (!device)
+		return -EINVAL;
+	device->driver_data = &vmgenid_data;
+
+	ret = vmgenid_acpi_map(device->driver_data, device->handle);
+	if (ret < 0) {
+		pr_err("vmgenid: failed to map acpi device\n");
+		device->driver_data = NULL;
+	}
+
+	return ret;
+}
+
+static int vmgenid_acpi_remove(struct acpi_device *device)
+{
+	if (!device || acpi_driver_data(device) != &vmgenid_data)
+		return -EINVAL;
+	device->driver_data = NULL;
+
+	if (vmgenid_data.uuid_iomap)
+		acpi_os_unmap_memory(vmgenid_data.uuid_iomap, sizeof(uuid_t));
+	vmgenid_data.uuid_iomap = NULL;
+
+	return 0;
+}
+
+static void vmgenid_acpi_notify(struct acpi_device *device, u32 event)
+{
+	uuid_t old_uuid;
+
+	if (!device || acpi_driver_data(device) != &vmgenid_data) {
+		pr_err("VMGENID notify with unexpected driver private data\n");
+		return;
+	}
+
+	/* update VM Generation UUID */
+	old_uuid = vmgenid_data.uuid;
+	memcpy_fromio(&vmgenid_data.uuid, vmgenid_data.uuid_iomap, sizeof(uuid_t));
+
+	if (memcmp(&old_uuid, &vmgenid_data.uuid, sizeof(uuid_t))) {
+		/* HW uuid updated */
+		sysgenid_bump_generation();
+		add_device_randomness(&vmgenid_data.uuid, sizeof(uuid_t));
+	}
+}
+
+static const struct acpi_device_id vmgenid_ids[] = {
+	{"VMGENID", 0},
+	{"QEMUVGID", 0},
+	{"", 0},
+};
+
+static struct acpi_driver acpi_vmgenid_driver = {
+	.name = "vm_generation_id",
+	.ids = vmgenid_ids,
+	.owner = THIS_MODULE,
+	.ops = {
+		.add = vmgenid_acpi_add,
+		.remove = vmgenid_acpi_remove,
+		.notify = vmgenid_acpi_notify,
+	}
+};
+
+static int __init vmgenid_init(void)
+{
+	return acpi_bus_register_driver(&acpi_vmgenid_driver);
+}
+
+static void __exit vmgenid_exit(void)
+{
+	acpi_bus_unregister_driver(&acpi_vmgenid_driver);
+}
+
+module_init(vmgenid_init);
+module_exit(vmgenid_exit);
+
+MODULE_AUTHOR("Adrian Catangiu");
+MODULE_DESCRIPTION("Virtual Machine Generation ID");
+MODULE_LICENSE("GPL");
+MODULE_VERSION("0.1");
-- 
2.7.4




Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in Romania. Registration number J22/2621/2005.

