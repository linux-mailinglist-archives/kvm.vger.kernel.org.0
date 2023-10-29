Return-Path: <kvm+bounces-27-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A10067DAD26
	for <lists+kvm@lfdr.de>; Sun, 29 Oct 2023 17:01:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2BCF628144E
	for <lists+kvm@lfdr.de>; Sun, 29 Oct 2023 16:01:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4C0610A39;
	Sun, 29 Oct 2023 16:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="YE+SxysN"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D845FFC19
	for <kvm@vger.kernel.org>; Sun, 29 Oct 2023 16:01:08 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2044.outbound.protection.outlook.com [40.107.237.44])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CC80BF
	for <kvm@vger.kernel.org>; Sun, 29 Oct 2023 09:01:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UKxPhNI5mXIpcYoSNk1XOrrhdMKeRcoWWzxmBRXMYbFaE6bY23SYjvdy8zj2q8QpzZuLTUxfeu4attmag83kPctcMlpd/DzrQYSFNts7gImVWk4RSE7Xiz/uvHSRgILgdgd9fzqIUFqRrx1jM0rshxhcOa6xT1nDXDLafTxyxoD4jyBBTtZ0TCe2lL1bFxVgBLd5zpvqye5XL9DUdYBzZuz9We2Kn0+ijYUfwf3NN93By+edZlPQ1MHvuo5VYWme5AinP0qkYaKd+2sQBwxMdu0r7ncLjRT5VNFL+Gp7T4LPL8+Rrv15fVQl14KOwvbcRPZEt66DSAXQU0WuzN4K1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fT7udtf6zR1xRRtM+1fmu+PJ6vH+kmiuBERLT2pD+Wo=;
 b=e2m7N0ndiFnM1/eOtuBVciC51o2LmFUSHQjtbzf4wCKvOP6BM1dFxqTXKN8A3G5lwQMqp6mWjEx4xmknNAqwmvKwKkipzcgWIfSgrDF16jMM2Hxo25VNiIUlU6CYL/PHvNdsTh01A2v87SrO2qoixXIDKWeDJyaCMEiLHX3HtFReYGAUPF4tXaaJI9FKO3IKOQyhs3BYdGiNk5d0YF8GqVV+lWGX4/S+KMmK3KbTlpddYK/NBLIxRvojr/DhvXlivezsBRudUBdyVcrpBeo8QaY7aOgcgx266MLadpgVB1OwQwYaUatkt2yXimJd35fLov5rCv0fTpYWmiKVlJNAHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fT7udtf6zR1xRRtM+1fmu+PJ6vH+kmiuBERLT2pD+Wo=;
 b=YE+SxysNNfirfllAMLlSq+xt32xx+Rsra2AbmEVJf1FxAttdTe8AhWY0h/UT21bOIH+Ts+j46lfXcpV0UhKFHWpDoKS0/5u+JLgTiD/wmT+g8Q2aHBRwLH3iFQEGE/aBfnA5bJgTU6KsEv9qR2uh70liNl3LFMW2jRMS1jEoq9s/o8S9Q+ld6zS/5+KrjEm4fzZ+NffE+KIUXwl6in/+BGnhWd09zgH/7MiN1DwBuviz/WcHSMt+0XumK6qlqPgzCss8rU64PoFoaySjv0bc2pu3G6QozoBLP1yunPNziHbotdB5vQoN71yZeoc5fhgJS6+2RI9o2gOk9i66J9yVvw==
Received: from DM6PR06CA0004.namprd06.prod.outlook.com (2603:10b6:5:120::17)
 by MN0PR12MB6077.namprd12.prod.outlook.com (2603:10b6:208:3cb::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.26; Sun, 29 Oct
 2023 16:00:57 +0000
Received: from DS1PEPF00017099.namprd05.prod.outlook.com
 (2603:10b6:5:120:cafe::5b) by DM6PR06CA0004.outlook.office365.com
 (2603:10b6:5:120::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.27 via Frontend
 Transport; Sun, 29 Oct 2023 16:00:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 DS1PEPF00017099.mail.protection.outlook.com (10.167.18.103) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6933.15 via Frontend Transport; Sun, 29 Oct 2023 16:00:57 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Sun, 29 Oct
 2023 09:00:48 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.41; Sun, 29 Oct 2023 09:00:47 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.986.41 via Frontend
 Transport; Sun, 29 Oct 2023 09:00:44 -0700
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <mst@redhat.com>, <jasowang@redhat.com>,
	<jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<parav@nvidia.com>, <feliu@nvidia.com>, <jiri@nvidia.com>,
	<kevin.tian@intel.com>, <joao.m.martins@oracle.com>, <si-wei.liu@oracle.com>,
	<leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V2 vfio 9/9] vfio/virtio: Introduce a vfio driver over virtio devices
Date: Sun, 29 Oct 2023 17:59:52 +0200
Message-ID: <20231029155952.67686-10-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20231029155952.67686-1-yishaih@nvidia.com>
References: <20231029155952.67686-1-yishaih@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF00017099:EE_|MN0PR12MB6077:EE_
X-MS-Office365-Filtering-Correlation-Id: bd5968e0-6ddb-43ca-eaf7-08dbd8983d27
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	mrgOsV64HkpwdWCARijf9oa3vooYsr8PeQpNxAewflG09silQ11RIGxCVijBLG09ToxVpsLeYXpGih1gmuEs/PlqoxkrXMaLzLX+u3+iIXPGfSXgnsKMhFD6ZBxBlMbje4F35RAOIpbOeAEejVh7Wmq6aB7MSefP9Ie4dpOkssEvZ3116avhLLgOvMAefX1MnvGp6QDQTO2aJ/7zpGs2tVALATPDTCBMMWL4jULqCrGjly4cPeMnH3txrNCHsLpEYeN6LNTef2OGa++7Iq1aAY/Q9G6f5BMtWPjt3z9NckyMOH+seQ/3R3AHPoar3i/ini65Hf+KF1l1RoLKCIThnlB4bsoXZ7UxxMNlDX6YavZv9kYSKDzZGwuKCYmM31VpatriiyWHQDrsRZjSiU1A8UVXH3okysq/v5WJ9o6u6g3/iT7GV61cqWNJlyI0HVSTPPo+zVDYHjOBnJdMP26ukjVnUxbTgqSnvY1Yy57/DCJ/m1UaohBl9JXQfNBT62SJ+1SjG3N8aCyN40/kSbzLQjPwHzd+yDpDx3IH7SbWJkYlLxsu6/NE7EtudcLChDilRicSBpmJA9twN8aVFPDB/d2hQnLSRxGMsx9OtE8bYWXyFlV4RMl5NZ5Gby3nL/r/MAKh5Dr+rQ0ZpusWKOKr1HMvonaTgWbRCLXs5K+srPmYwe35qmX7LQ9dPXogz9kZ/RX1MODIo7fkCwBnD944off2ja2NT2S7KXvPyvdm9YhvVCIkygZI1hyTZpNveGRaTJJFF9y5fzb7ah6t0y8E4A==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(396003)(346002)(376002)(39860400002)(136003)(230922051799003)(64100799003)(82310400011)(186009)(1800799009)(451199024)(46966006)(36840700001)(7696005)(6666004)(966005)(478600001)(83380400001)(30864003)(47076005)(26005)(2616005)(107886003)(1076003)(336012)(426003)(2906002)(5660300002)(54906003)(41300700001)(70586007)(316002)(6636002)(70206006)(110136005)(8936002)(8676002)(4326008)(36860700001)(86362001)(36756003)(356005)(7636003)(82740400003)(40480700001)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2023 16:00:57.4305
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bd5968e0-6ddb-43ca-eaf7-08dbd8983d27
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS1PEPF00017099.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6077

Introduce a vfio driver over virtio devices to support the legacy
interface functionality for VFs.

Background, from the virtio spec [1].
--------------------------------------------------------------------
In some systems, there is a need to support a virtio legacy driver with
a device that does not directly support the legacy interface. In such
scenarios, a group owner device can provide the legacy interface
functionality for the group member devices. The driver of the owner
device can then access the legacy interface of a member device on behalf
of the legacy member device driver.

For example, with the SR-IOV group type, group members (VFs) can not
present the legacy interface in an I/O BAR in BAR0 as expected by the
legacy pci driver. If the legacy driver is running inside a virtual
machine, the hypervisor executing the virtual machine can present a
virtual device with an I/O BAR in BAR0. The hypervisor intercepts the
legacy driver accesses to this I/O BAR and forwards them to the group
owner device (PF) using group administration commands.
--------------------------------------------------------------------

Specifically, this driver adds support for a virtio-net VF to be exposed
as a transitional device to a guest driver and allows the legacy IO BAR
functionality on top.

This allows a VM which uses a legacy virtio-net driver in the guest to
work transparently over a VF which its driver in the host is that new
driver.

The driver can be extended easily to support some other types of virtio
devices (e.g virtio-blk), by adding in a few places the specific type
properties as was done for virtio-net.

For now, only the virtio-net use case was tested and as such we introduce
the support only for such a device.

Practically,
Upon probing a VF for a virtio-net device, in case its PF supports
legacy access over the virtio admin commands and the VF doesn't have BAR
0, we set some specific 'vfio_device_ops' to be able to simulate in SW a
transitional device with I/O BAR in BAR 0.

The existence of the simulated I/O bar is reported later on by
overwriting the VFIO_DEVICE_GET_REGION_INFO command and the device
exposes itself as a transitional device by overwriting some properties
upon reading its config space.

Once we report the existence of I/O BAR as BAR 0 a legacy driver in the
guest may use it via read/write calls according to the virtio
specification.

Any read/write towards the control parts of the BAR will be captured by
the new driver and will be translated into admin commands towards the
device.

Any data path read/write access (i.e. virtio driver notifications) will
be forwarded to the physical BAR which its properties were supplied by
the admin command VIRTIO_ADMIN_CMD_LEGACY_NOTIFY_INFO upon the
probing/init flow.

With that code in place a legacy driver in the guest has the look and
feel as if having a transitional device with legacy support for both its
control and data path flows.

[1]
https://github.com/oasis-tcs/virtio-spec/commit/03c2d32e5093ca9f2a17797242fbef88efe94b8c

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 MAINTAINERS                      |   7 +
 drivers/vfio/pci/Kconfig         |   2 +
 drivers/vfio/pci/Makefile        |   2 +
 drivers/vfio/pci/virtio/Kconfig  |  16 +
 drivers/vfio/pci/virtio/Makefile |   4 +
 drivers/vfio/pci/virtio/main.c   | 551 +++++++++++++++++++++++++++++++
 6 files changed, 582 insertions(+)
 create mode 100644 drivers/vfio/pci/virtio/Kconfig
 create mode 100644 drivers/vfio/pci/virtio/Makefile
 create mode 100644 drivers/vfio/pci/virtio/main.c

diff --git a/MAINTAINERS b/MAINTAINERS
index dd5de540ec0b..f59f84a6992d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -22622,6 +22622,13 @@ L:	kvm@vger.kernel.org
 S:	Maintained
 F:	drivers/vfio/pci/mlx5/
 
+VFIO VIRTIO PCI DRIVER
+M:	Yishai Hadas <yishaih@nvidia.com>
+L:	kvm@vger.kernel.org
+L:	virtualization@lists.linux-foundation.org
+S:	Maintained
+F:	drivers/vfio/pci/virtio
+
 VFIO PCI DEVICE SPECIFIC DRIVERS
 R:	Jason Gunthorpe <jgg@nvidia.com>
 R:	Yishai Hadas <yishaih@nvidia.com>
diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
index 8125e5f37832..18c397df566d 100644
--- a/drivers/vfio/pci/Kconfig
+++ b/drivers/vfio/pci/Kconfig
@@ -65,4 +65,6 @@ source "drivers/vfio/pci/hisilicon/Kconfig"
 
 source "drivers/vfio/pci/pds/Kconfig"
 
+source "drivers/vfio/pci/virtio/Kconfig"
+
 endmenu
diff --git a/drivers/vfio/pci/Makefile b/drivers/vfio/pci/Makefile
index 45167be462d8..046139a4eca5 100644
--- a/drivers/vfio/pci/Makefile
+++ b/drivers/vfio/pci/Makefile
@@ -13,3 +13,5 @@ obj-$(CONFIG_MLX5_VFIO_PCI)           += mlx5/
 obj-$(CONFIG_HISI_ACC_VFIO_PCI) += hisilicon/
 
 obj-$(CONFIG_PDS_VFIO_PCI) += pds/
+
+obj-$(CONFIG_VIRTIO_VFIO_PCI) += virtio/
diff --git a/drivers/vfio/pci/virtio/Kconfig b/drivers/vfio/pci/virtio/Kconfig
new file mode 100644
index 000000000000..3a6707639220
--- /dev/null
+++ b/drivers/vfio/pci/virtio/Kconfig
@@ -0,0 +1,16 @@
+# SPDX-License-Identifier: GPL-2.0-only
+config VIRTIO_VFIO_PCI
+        tristate "VFIO support for VIRTIO NET PCI devices"
+        depends on VIRTIO_PCI
+        select VFIO_PCI_CORE
+        help
+          This provides support for exposing VIRTIO NET VF devices which support
+          legacy IO access, using the VFIO framework that can work with a legacy
+          virtio driver in the guest.
+          Based on PCIe spec, VFs do not support I/O Space; thus, VF BARs shall
+          not indicate I/O Space.
+          As of that this driver emulated I/O BAR in software to let a VF be
+          seen as a transitional device in the guest and let it work with
+          a legacy driver.
+
+          If you don't know what to do here, say N.
diff --git a/drivers/vfio/pci/virtio/Makefile b/drivers/vfio/pci/virtio/Makefile
new file mode 100644
index 000000000000..2039b39fb723
--- /dev/null
+++ b/drivers/vfio/pci/virtio/Makefile
@@ -0,0 +1,4 @@
+# SPDX-License-Identifier: GPL-2.0-only
+obj-$(CONFIG_VIRTIO_VFIO_PCI) += virtio-vfio-pci.o
+virtio-vfio-pci-y := main.o
+
diff --git a/drivers/vfio/pci/virtio/main.c b/drivers/vfio/pci/virtio/main.c
new file mode 100644
index 000000000000..0f7d2f442f6c
--- /dev/null
+++ b/drivers/vfio/pci/virtio/main.c
@@ -0,0 +1,551 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2023, NVIDIA CORPORATION & AFFILIATES. All rights reserved
+ */
+
+#include <linux/device.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/pci.h>
+#include <linux/pm_runtime.h>
+#include <linux/types.h>
+#include <linux/uaccess.h>
+#include <linux/vfio.h>
+#include <linux/vfio_pci_core.h>
+#include <linux/virtio_pci.h>
+#include <linux/virtio_net.h>
+#include <linux/virtio_pci_admin.h>
+
+struct virtiovf_pci_core_device {
+	struct vfio_pci_core_device core_device;
+	u8 bar0_virtual_buf_size;
+	u8 *bar0_virtual_buf;
+	/* synchronize access to the virtual buf */
+	struct mutex bar_mutex;
+	void __iomem *notify_addr;
+	u64 notify_offset;
+	__le32 pci_base_addr_0;
+	__le16 pci_cmd;
+	u8 notify_bar;
+};
+
+static int
+virtiovf_issue_legacy_rw_cmd(struct virtiovf_pci_core_device *virtvdev,
+			     loff_t pos, char __user *buf,
+			     size_t count, bool read)
+{
+	bool msix_enabled =
+		(virtvdev->core_device.irq_type == VFIO_PCI_MSIX_IRQ_INDEX);
+	struct pci_dev *pdev = virtvdev->core_device.pdev;
+	u8 *bar0_buf = virtvdev->bar0_virtual_buf;
+	bool common;
+	int ret;
+
+	common = pos < VIRTIO_PCI_CONFIG_OFF(msix_enabled);
+	mutex_lock(&virtvdev->bar_mutex);
+	if (read) {
+		if (common)
+			ret = virtio_pci_admin_legacy_common_io_read(pdev, pos,
+					count, bar0_buf + pos);
+		else
+			ret = virtio_pci_admin_legacy_device_io_read(pdev, pos,
+					count, bar0_buf + pos);
+		if (ret)
+			goto out;
+		if (copy_to_user(buf, bar0_buf + pos, count))
+			ret = -EFAULT;
+	} else {
+		if (copy_from_user(bar0_buf + pos, buf, count)) {
+			ret = -EFAULT;
+			goto out;
+		}
+
+		if (common)
+			ret = virtio_pci_admin_legacy_common_io_write(pdev, pos,
+					count, bar0_buf + pos);
+		else
+			ret = virtio_pci_admin_legacy_device_io_write(pdev, pos,
+					count, bar0_buf + pos);
+	}
+out:
+	mutex_unlock(&virtvdev->bar_mutex);
+	return ret;
+}
+
+static int
+translate_io_bar_to_mem_bar(struct virtiovf_pci_core_device *virtvdev,
+			    loff_t pos, char __user *buf,
+			    size_t count, bool read)
+{
+	struct vfio_pci_core_device *core_device = &virtvdev->core_device;
+	u16 queue_notify;
+	int ret;
+
+	if (pos + count > virtvdev->bar0_virtual_buf_size)
+		return -EINVAL;
+
+	switch (pos) {
+	case VIRTIO_PCI_QUEUE_NOTIFY:
+		if (count != sizeof(queue_notify))
+			return -EINVAL;
+		if (read) {
+			ret = vfio_pci_ioread16(core_device, true, &queue_notify,
+						virtvdev->notify_addr);
+			if (ret)
+				return ret;
+			if (copy_to_user(buf, &queue_notify,
+					 sizeof(queue_notify)))
+				return -EFAULT;
+		} else {
+			if (copy_from_user(&queue_notify, buf, count))
+				return -EFAULT;
+			ret = vfio_pci_iowrite16(core_device, true, queue_notify,
+						 virtvdev->notify_addr);
+		}
+		break;
+	default:
+		ret = virtiovf_issue_legacy_rw_cmd(virtvdev, pos, buf, count,
+						   read);
+	}
+
+	return ret ? ret : count;
+}
+
+static bool range_intersect_range(loff_t range1_start, size_t count1,
+				  loff_t range2_start, size_t count2,
+				  loff_t *start_offset,
+				  size_t *intersect_count,
+				  size_t *register_offset)
+{
+	if (range1_start <= range2_start &&
+	    range1_start + count1 > range2_start) {
+		*start_offset = range2_start - range1_start;
+		*intersect_count = min_t(size_t, count2,
+					 range1_start + count1 - range2_start);
+		*register_offset = 0;
+		return true;
+	}
+
+	if (range1_start > range2_start &&
+	    range1_start < range2_start + count2) {
+		*start_offset = 0;
+		*intersect_count = min_t(size_t, count1,
+					 range2_start + count2 - range1_start);
+		*register_offset = range1_start - range2_start;
+		return true;
+	}
+
+	return false;
+}
+
+static ssize_t virtiovf_pci_read_config(struct vfio_device *core_vdev,
+					char __user *buf, size_t count,
+					loff_t *ppos)
+{
+	struct virtiovf_pci_core_device *virtvdev = container_of(
+		core_vdev, struct virtiovf_pci_core_device, core_device.vdev);
+	loff_t pos = *ppos & VFIO_PCI_OFFSET_MASK;
+	size_t register_offset;
+	loff_t copy_offset;
+	size_t copy_count;
+	__le32 val32;
+	__le16 val16;
+	u8 val8;
+	int ret;
+
+	ret = vfio_pci_core_read(core_vdev, buf, count, ppos);
+	if (ret < 0)
+		return ret;
+
+	if (range_intersect_range(pos, count, PCI_DEVICE_ID, sizeof(val16),
+				  &copy_offset, &copy_count, &register_offset)) {
+		val16 = cpu_to_le16(VIRTIO_TRANS_ID_NET);
+		if (copy_to_user(buf + copy_offset, (void *)&val16 + register_offset, copy_count))
+			return -EFAULT;
+	}
+
+	if ((le16_to_cpu(virtvdev->pci_cmd) & PCI_COMMAND_IO) &&
+	    range_intersect_range(pos, count, PCI_COMMAND, sizeof(val16),
+				  &copy_offset, &copy_count, &register_offset)) {
+		if (copy_from_user((void *)&val16 + register_offset, buf + copy_offset,
+				   copy_count))
+			return -EFAULT;
+		val16 |= cpu_to_le16(PCI_COMMAND_IO);
+		if (copy_to_user(buf + copy_offset, (void *)&val16 + register_offset,
+				 copy_count))
+			return -EFAULT;
+	}
+
+	if (range_intersect_range(pos, count, PCI_REVISION_ID, sizeof(val8),
+				  &copy_offset, &copy_count, &register_offset)) {
+		/* Transional needs to have revision 0 */
+		val8 = 0;
+		if (copy_to_user(buf + copy_offset, &val8, copy_count))
+			return -EFAULT;
+	}
+
+	if (range_intersect_range(pos, count, PCI_BASE_ADDRESS_0, sizeof(val32),
+				  &copy_offset, &copy_count, &register_offset)) {
+		u8 log_bar_size = ilog2(roundup_pow_of_two(virtvdev->bar0_virtual_buf_size));
+		u32 mask_size = ~((BIT(log_bar_size) - 1));
+		u32 pci_base_addr_0 = le32_to_cpu(virtvdev->pci_base_addr_0);
+
+		val32 = cpu_to_le32((pci_base_addr_0 & mask_size) | PCI_BASE_ADDRESS_SPACE_IO);
+		if (copy_to_user(buf + copy_offset, (void *)&val32 + register_offset, copy_count))
+			return -EFAULT;
+	}
+
+	if (range_intersect_range(pos, count, PCI_SUBSYSTEM_ID, sizeof(val16),
+				  &copy_offset, &copy_count, &register_offset)) {
+		/*
+		 * Transitional devices use the PCI subsystem device id as
+		 * virtio device id, same as legacy driver always did.
+		 */
+		val16 = cpu_to_le16(VIRTIO_ID_NET);
+		if (copy_to_user(buf + copy_offset, (void *)&val16 + register_offset,
+				 copy_count))
+			return -EFAULT;
+	}
+
+	if (range_intersect_range(pos, count, PCI_SUBSYSTEM_VENDOR_ID, sizeof(val16),
+				  &copy_offset, &copy_count, &register_offset)) {
+		val16 = cpu_to_le16(PCI_VENDOR_ID_REDHAT_QUMRANET);
+		if (copy_to_user(buf + copy_offset, (void *)&val16 + register_offset,
+				 copy_count))
+			return -EFAULT;
+	}
+
+	return count;
+}
+
+static ssize_t
+virtiovf_pci_core_read(struct vfio_device *core_vdev, char __user *buf,
+		       size_t count, loff_t *ppos)
+{
+	struct virtiovf_pci_core_device *virtvdev = container_of(
+		core_vdev, struct virtiovf_pci_core_device, core_device.vdev);
+	struct pci_dev *pdev = virtvdev->core_device.pdev;
+	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
+	loff_t pos = *ppos & VFIO_PCI_OFFSET_MASK;
+	int ret;
+
+	if (!count)
+		return 0;
+
+	if (index == VFIO_PCI_CONFIG_REGION_INDEX)
+		return virtiovf_pci_read_config(core_vdev, buf, count, ppos);
+
+	if (index != VFIO_PCI_BAR0_REGION_INDEX)
+		return vfio_pci_core_read(core_vdev, buf, count, ppos);
+
+	ret = pm_runtime_resume_and_get(&pdev->dev);
+	if (ret) {
+		pci_info_ratelimited(pdev, "runtime resume failed %d\n",
+				     ret);
+		return -EIO;
+	}
+
+	ret = translate_io_bar_to_mem_bar(virtvdev, pos, buf, count, true);
+	pm_runtime_put(&pdev->dev);
+	return ret;
+}
+
+static ssize_t
+virtiovf_pci_core_write(struct vfio_device *core_vdev, const char __user *buf,
+			size_t count, loff_t *ppos)
+{
+	struct virtiovf_pci_core_device *virtvdev = container_of(
+		core_vdev, struct virtiovf_pci_core_device, core_device.vdev);
+	struct pci_dev *pdev = virtvdev->core_device.pdev;
+	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
+	loff_t pos = *ppos & VFIO_PCI_OFFSET_MASK;
+	int ret;
+
+	if (!count)
+		return 0;
+
+	if (index == VFIO_PCI_CONFIG_REGION_INDEX) {
+		size_t register_offset;
+		loff_t copy_offset;
+		size_t copy_count;
+
+		if (range_intersect_range(pos, count, PCI_COMMAND, sizeof(virtvdev->pci_cmd),
+					  &copy_offset, &copy_count,
+					  &register_offset)) {
+			if (copy_from_user((void *)&virtvdev->pci_cmd + register_offset,
+					   buf + copy_offset,
+					   copy_count))
+				return -EFAULT;
+		}
+
+		if (range_intersect_range(pos, count, PCI_BASE_ADDRESS_0,
+					  sizeof(virtvdev->pci_base_addr_0),
+					  &copy_offset, &copy_count,
+					  &register_offset)) {
+			if (copy_from_user((void *)&virtvdev->pci_base_addr_0 + register_offset,
+					   buf + copy_offset,
+					   copy_count))
+				return -EFAULT;
+		}
+	}
+
+	if (index != VFIO_PCI_BAR0_REGION_INDEX)
+		return vfio_pci_core_write(core_vdev, buf, count, ppos);
+
+	ret = pm_runtime_resume_and_get(&pdev->dev);
+	if (ret) {
+		pci_info_ratelimited(pdev, "runtime resume failed %d\n", ret);
+		return -EIO;
+	}
+
+	ret = translate_io_bar_to_mem_bar(virtvdev, pos, (char __user *)buf, count, false);
+	pm_runtime_put(&pdev->dev);
+	return ret;
+}
+
+static int
+virtiovf_pci_ioctl_get_region_info(struct vfio_device *core_vdev,
+				   unsigned int cmd, unsigned long arg)
+{
+	struct virtiovf_pci_core_device *virtvdev = container_of(
+		core_vdev, struct virtiovf_pci_core_device, core_device.vdev);
+	unsigned long minsz = offsetofend(struct vfio_region_info, offset);
+	void __user *uarg = (void __user *)arg;
+	struct vfio_region_info info = {};
+
+	if (copy_from_user(&info, uarg, minsz))
+		return -EFAULT;
+
+	if (info.argsz < minsz)
+		return -EINVAL;
+
+	switch (info.index) {
+	case VFIO_PCI_BAR0_REGION_INDEX:
+		info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
+		info.size = virtvdev->bar0_virtual_buf_size;
+		info.flags = VFIO_REGION_INFO_FLAG_READ |
+			     VFIO_REGION_INFO_FLAG_WRITE;
+		return copy_to_user(uarg, &info, minsz) ? -EFAULT : 0;
+	default:
+		return vfio_pci_core_ioctl(core_vdev, cmd, arg);
+	}
+}
+
+static long
+virtiovf_vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
+			     unsigned long arg)
+{
+	switch (cmd) {
+	case VFIO_DEVICE_GET_REGION_INFO:
+		return virtiovf_pci_ioctl_get_region_info(core_vdev, cmd, arg);
+	default:
+		return vfio_pci_core_ioctl(core_vdev, cmd, arg);
+	}
+}
+
+static int
+virtiovf_set_notify_addr(struct virtiovf_pci_core_device *virtvdev)
+{
+	struct vfio_pci_core_device *core_device = &virtvdev->core_device;
+	int ret;
+
+	/*
+	 * Setup the BAR where the 'notify' exists to be used by vfio as well
+	 * This will let us mmap it only once and use it when needed.
+	 */
+	ret = vfio_pci_core_setup_barmap(core_device,
+					 virtvdev->notify_bar);
+	if (ret)
+		return ret;
+
+	virtvdev->notify_addr = core_device->barmap[virtvdev->notify_bar] +
+			virtvdev->notify_offset;
+	return 0;
+}
+
+static int virtiovf_pci_open_device(struct vfio_device *core_vdev)
+{
+	struct virtiovf_pci_core_device *virtvdev = container_of(
+		core_vdev, struct virtiovf_pci_core_device, core_device.vdev);
+	struct vfio_pci_core_device *vdev = &virtvdev->core_device;
+	int ret;
+
+	ret = vfio_pci_core_enable(vdev);
+	if (ret)
+		return ret;
+
+	if (virtvdev->bar0_virtual_buf) {
+		/*
+		 * Upon close_device() the vfio_pci_core_disable() is called
+		 * and will close all the previous mmaps, so it seems that the
+		 * valid life cycle for the 'notify' addr is per open/close.
+		 */
+		ret = virtiovf_set_notify_addr(virtvdev);
+		if (ret) {
+			vfio_pci_core_disable(vdev);
+			return ret;
+		}
+	}
+
+	vfio_pci_core_finish_enable(vdev);
+	return 0;
+}
+
+static int virtiovf_get_device_config_size(unsigned short device)
+{
+	/* Network card */
+	return offsetofend(struct virtio_net_config, status);
+}
+
+static int virtiovf_read_notify_info(struct virtiovf_pci_core_device *virtvdev)
+{
+	u64 offset;
+	int ret;
+	u8 bar;
+
+	ret = virtio_pci_admin_legacy_io_notify_info(virtvdev->core_device.pdev,
+				VIRTIO_ADMIN_CMD_NOTIFY_INFO_FLAGS_OWNER_MEM,
+				&bar, &offset);
+	if (ret)
+		return ret;
+
+	virtvdev->notify_bar = bar;
+	virtvdev->notify_offset = offset;
+	return 0;
+}
+
+static int virtiovf_pci_init_device(struct vfio_device *core_vdev)
+{
+	struct virtiovf_pci_core_device *virtvdev = container_of(
+		core_vdev, struct virtiovf_pci_core_device, core_device.vdev);
+	struct pci_dev *pdev;
+	int ret;
+
+	ret = vfio_pci_core_init_dev(core_vdev);
+	if (ret)
+		return ret;
+
+	pdev = virtvdev->core_device.pdev;
+	ret = virtiovf_read_notify_info(virtvdev);
+	if (ret)
+		return ret;
+
+	/* Being ready with a buffer that supports MSIX */
+	virtvdev->bar0_virtual_buf_size = VIRTIO_PCI_CONFIG_OFF(true) +
+				virtiovf_get_device_config_size(pdev->device);
+	virtvdev->bar0_virtual_buf = kzalloc(virtvdev->bar0_virtual_buf_size,
+					     GFP_KERNEL);
+	if (!virtvdev->bar0_virtual_buf)
+		return -ENOMEM;
+	mutex_init(&virtvdev->bar_mutex);
+	return 0;
+}
+
+static void virtiovf_pci_core_release_dev(struct vfio_device *core_vdev)
+{
+	struct virtiovf_pci_core_device *virtvdev = container_of(
+		core_vdev, struct virtiovf_pci_core_device, core_device.vdev);
+
+	kfree(virtvdev->bar0_virtual_buf);
+	vfio_pci_core_release_dev(core_vdev);
+}
+
+static const struct vfio_device_ops virtiovf_acc_vfio_pci_tran_ops = {
+	.name = "virtio-vfio-pci-trans",
+	.init = virtiovf_pci_init_device,
+	.release = virtiovf_pci_core_release_dev,
+	.open_device = virtiovf_pci_open_device,
+	.close_device = vfio_pci_core_close_device,
+	.ioctl = virtiovf_vfio_pci_core_ioctl,
+	.read = virtiovf_pci_core_read,
+	.write = virtiovf_pci_core_write,
+	.mmap = vfio_pci_core_mmap,
+	.request = vfio_pci_core_request,
+	.match = vfio_pci_core_match,
+	.bind_iommufd = vfio_iommufd_physical_bind,
+	.unbind_iommufd = vfio_iommufd_physical_unbind,
+	.attach_ioas = vfio_iommufd_physical_attach_ioas,
+};
+
+static const struct vfio_device_ops virtiovf_vfio_pci_ops = {
+	.name = "virtio-vfio-pci",
+	.init = vfio_pci_core_init_dev,
+	.release = vfio_pci_core_release_dev,
+	.open_device = virtiovf_pci_open_device,
+	.close_device = vfio_pci_core_close_device,
+	.ioctl = vfio_pci_core_ioctl,
+	.device_feature = vfio_pci_core_ioctl_feature,
+	.read = vfio_pci_core_read,
+	.write = vfio_pci_core_write,
+	.mmap = vfio_pci_core_mmap,
+	.request = vfio_pci_core_request,
+	.match = vfio_pci_core_match,
+	.bind_iommufd = vfio_iommufd_physical_bind,
+	.unbind_iommufd = vfio_iommufd_physical_unbind,
+	.attach_ioas = vfio_iommufd_physical_attach_ioas,
+};
+
+static bool virtiovf_bar0_exists(struct pci_dev *pdev)
+{
+	struct resource *res = pdev->resource;
+
+	return res->flags ? true : false;
+}
+
+static int virtiovf_pci_probe(struct pci_dev *pdev,
+			      const struct pci_device_id *id)
+{
+	const struct vfio_device_ops *ops = &virtiovf_vfio_pci_ops;
+	struct virtiovf_pci_core_device *virtvdev;
+	int ret;
+
+	if (pdev->is_virtfn && virtio_pci_admin_has_legacy_io(pdev) &&
+	    !virtiovf_bar0_exists(pdev))
+		ops = &virtiovf_acc_vfio_pci_tran_ops;
+
+	virtvdev = vfio_alloc_device(virtiovf_pci_core_device, core_device.vdev,
+				     &pdev->dev, ops);
+	if (IS_ERR(virtvdev))
+		return PTR_ERR(virtvdev);
+
+	dev_set_drvdata(&pdev->dev, &virtvdev->core_device);
+	ret = vfio_pci_core_register_device(&virtvdev->core_device);
+	if (ret)
+		goto out;
+	return 0;
+out:
+	vfio_put_device(&virtvdev->core_device.vdev);
+	return ret;
+}
+
+static void virtiovf_pci_remove(struct pci_dev *pdev)
+{
+	struct virtiovf_pci_core_device *virtvdev = dev_get_drvdata(&pdev->dev);
+
+	vfio_pci_core_unregister_device(&virtvdev->core_device);
+	vfio_put_device(&virtvdev->core_device.vdev);
+}
+
+static const struct pci_device_id virtiovf_pci_table[] = {
+	/* Only virtio-net is supported/tested so far */
+	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_REDHAT_QUMRANET, 0x1041) },
+	{}
+};
+
+MODULE_DEVICE_TABLE(pci, virtiovf_pci_table);
+
+static struct pci_driver virtiovf_pci_driver = {
+	.name = KBUILD_MODNAME,
+	.id_table = virtiovf_pci_table,
+	.probe = virtiovf_pci_probe,
+	.remove = virtiovf_pci_remove,
+	.err_handler = &vfio_pci_core_err_handlers,
+	.driver_managed_dma = true,
+};
+
+module_pci_driver(virtiovf_pci_driver);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Yishai Hadas <yishaih@nvidia.com>");
+MODULE_DESCRIPTION(
+	"VIRTIO VFIO PCI - User Level meta-driver for VIRTIO NET devices");
-- 
2.27.0


