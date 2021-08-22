Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6921C3F4005
	for <lists+kvm@lfdr.de>; Sun, 22 Aug 2021 16:37:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234236AbhHVOiY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 22 Aug 2021 10:38:24 -0400
Received: from mail-dm6nam10on2073.outbound.protection.outlook.com ([40.107.93.73]:29264
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233976AbhHVOiV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 22 Aug 2021 10:38:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n31Q1F3tyk1s6CfnoxeA9UXkcxQFFgrKBZ3QkdGfqHgB6jicnY6O7oiLbxKsSJy6Zh6GdmicfFkUj0T1JFMqzNhpp81u+ysgHkYzrKeR3UjVCnFWiJBHlaUVSQFab24lrcBnyAewVA2Z/WGkRmh5HCxRKz4xwgNYLme6onALOsHP0wsnN2oxeRr3vedvJBR0F6hIHyjcu6gkNqHXP8bNBRbZz6aQascJSyHYFYgPF2FLN1c5VqNboCYSv49jFu+Wd6cXWgUDFTZ3oTjOdiLd5b4DC/0+2XaD/phLM+ZeKTJ9PItyzhve1dW5YMxqb4W9epa9X735dcasginMf3YjCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c68CavaZQdzjNnkSiiX1CXVkFOE4ACJC6dBBsAKHYUc=;
 b=J7S+Zq+iX588P7CBLhWl2F/VDzLp1yHW2n11SS2QAioZzFL8GM62yfP6jM5icIzofxzF+IJbEHXShYgFqRkJ9zA7AvzLUk4k5bSVTdJFuHL7169kFIw1PwVKAz2sIlCkwCFwpQ7Jak1RSc2MOj3im0dgYfbiWfoyhW2TdyOrf6SSYw5pnllMaKDBJfvJ1Dd1fwW9nBjRLBiqorNDF64JJox3YkV5jNvwSYpv4Au6U3dcBqfh04w5tVQijgBbyl8swPKUMSPXWUUPCtc5/+ZaX3/phrxXRd33UO2xuQeyfTja/m81QJ/o1+iTn2nPwC64TU1GUhE4pX9wcMETMtZldg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c68CavaZQdzjNnkSiiX1CXVkFOE4ACJC6dBBsAKHYUc=;
 b=chie4cxiSBpge5VZckjvC1+RQv+Kau8YEwFWO9P8DHskpe4QCIGjxTGKZG2tnjGklmHkZ9nNuFu0w3khODnLNY8oxAIRMlwfWJGBZvJlUd6Dru0UjdCIYAoYnzciBPLdHLkHwxLNov0FZK/mPkgDm/fJKXBmSp3CTgCnVsprRfaXAsKmLhttGhOgnZJCjYzV/bJXc3wzzogPIbUq8dRP4JNaRPBv5vLsF+DIFjbdcrB5yQhyArLOi2KqH6u0YbmfKxtyp7mecnnnKvpwZ6yyUPieIY2pP/HO25DVEym4VBGB7c3GdxcWnq8zCmcSObd+D9GsnWcRjlV8wCqDBXtfkw==
Received: from DM6PR03CA0076.namprd03.prod.outlook.com (2603:10b6:5:333::9) by
 BL0PR12MB2468.namprd12.prod.outlook.com (2603:10b6:207:44::29) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4436.19; Sun, 22 Aug 2021 14:37:38 +0000
Received: from DM6NAM11FT050.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:333:cafe::38) by DM6PR03CA0076.outlook.office365.com
 (2603:10b6:5:333::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend
 Transport; Sun, 22 Aug 2021 14:37:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 DM6NAM11FT050.mail.protection.outlook.com (10.13.173.111) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4436.19 via Frontend Transport; Sun, 22 Aug 2021 14:37:38 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 22 Aug
 2021 14:37:37 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 22 Aug 2021 14:37:34 +0000
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <bhelgaas@google.com>, <corbet@lwn.net>,
        <alex.williamson@redhat.com>, <diana.craciun@oss.nxp.com>,
        <kwankhede@nvidia.com>, <eric.auger@redhat.com>,
        <masahiroy@kernel.org>, <michal.lkml@markovi.net>
CC:     <linux-pci@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <kvm@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        <linux-kbuild@vger.kernel.org>, <mgurtovoy@nvidia.com>,
        <jgg@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <leonro@nvidia.com>
Subject: [PATCH V3 10/13] PCI / VFIO: Add 'override_only' support for VFIO PCI sub system
Date:   Sun, 22 Aug 2021 17:35:59 +0300
Message-ID: <20210822143602.153816-11-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20210822143602.153816-1-yishaih@nvidia.com>
References: <20210822143602.153816-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5e724b3a-0f04-4184-46e4-08d9657a63b9
X-MS-TrafficTypeDiagnostic: BL0PR12MB2468:
X-Microsoft-Antispam-PRVS: <BL0PR12MB2468DE357028DB4674A3D2F3C3C39@BL0PR12MB2468.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6znBPvUe3bkigUqMR/FZdW9FD1h4Hjtpl7DemHA/FJzlAQYect43eLvZBwfCGe1Qs5EadvLOz2M2frbkO3R6FK0o7yItm2DMI2vljwtoxlgmRdSmJMEgawFl6jq8we6/V5SOyaouJsF74zY5zQoYhqhe2y3o2stxg+UBd9k7Vk6muAizUIST6cNm8MtAj7wY0h6ZQoM/NMeKaaHONCi6GWPX+zbOWQ0UsSIM/tjMCvEZCpAReKIiiwVaLfoE4SlvUn976ekDxqcwBTsg9fIqsDOq7EqoDNlx2wWZA4ZxdYGRoIqIvsPezFNFgzzQmpxgAn662doWjgvNY3IHUM/uR+j8oUMzsOeUkq3MxoIpyGHuCU1KxbFaBh5cJT/aK2XafzIwIN1Mtikpx4+LrQfyVL3yNi7AXD6cbAjoldamjOrCsTUI1cYg5AJJFJNnh1JSl6zJBEF4LmyQyVsWiscn/2qze3vJEGBc1GXhNtokPwF5qQ/64ZbqYLwsSiihotxR+Ik2zx8lNdHin7A1HmnaDie2NxTF6C+JODVxz2uVTOnO+qP7ejnO7zEQQRC+rmN4NHzOfXrM5+mD8P7MV4oWpToa6kZxrFb9TIVEerulr3Kg0l4YkSLj617XJHKQf5tFC8iLlp5E21Lz16D/L1GI82BvmdkzSL8Ie7IX5xMxUlm7mylq1XaeaEs9TChDdQEIV/BTKz34Kxq4DMOOFs87mafrcVByEDGzKk5J9Wz4S8Q=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(396003)(39860400002)(346002)(136003)(46966006)(36840700001)(36860700001)(7636003)(107886003)(478600001)(6666004)(36906005)(316002)(36756003)(356005)(7696005)(2906002)(5660300002)(4326008)(82310400003)(47076005)(82740400003)(70206006)(70586007)(8676002)(186003)(426003)(2616005)(1076003)(86362001)(7416002)(26005)(54906003)(110136005)(336012)(8936002)(83380400001)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Aug 2021 14:37:38.2018
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e724b3a-0f04-4184-46e4-08d9657a63b9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT050.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB2468
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Max Gurtovoy <mgurtovoy@nvidia.com>

Expose an 'override_only' helper macro (i.e.
PCI_DRIVER_OVERRIDE_DEVICE_VFIO) for VFIO PCI sub system and add the
required code to prefix its matching entries with "vfio_" in
modules.alias file.

It allows VFIO device drivers to include match entries in the
modules.alias file produced by kbuild that are not used for normal
driver autoprobing and module autoloading. Drivers using these match
entries can be connected to the PCI device manually, by userspace, using
the existing driver_override sysfs.

For example the resulting modules.alias may have:

  alias pci:v000015B3d00001021sv*sd*bc*sc*i* mlx5_core
  alias vfio_pci:v000015B3d00001021sv*sd*bc*sc*i* mlx5_vfio_pci
  alias vfio_pci:v*d*sv*sd*bc*sc*i* vfio_pci

In this example mlx5_core and mlx5_vfio_pci match to the same PCI
device. The kernel will autoload and autobind to mlx5_core but the
kernel and udev mechanisms will ignore mlx5_vfio_pci.

When userspace wants to change a device to the VFIO subsystem it can
implement a generic algorithm:

   1) Identify the sysfs path to the device:
    /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0

   2) Get the modalias string from the kernel:
    $ cat /sys/bus/pci/devices/0000:01:00.0/modalias
    pci:v000015B3d00001021sv000015B3sd00000001bc02sc00i00

   3) Prefix it with vfio_:
    vfio_pci:v000015B3d00001021sv000015B3sd00000001bc02sc00i00

   4) Search modules.alias for the above string and select the entry that
      has the fewest *'s:
    alias vfio_pci:v000015B3d00001021sv*sd*bc*sc*i* mlx5_vfio_pci

   5) modprobe the matched module name:
    $ modprobe mlx5_vfio_pci

   6) cat the matched module name to driver_override:
    echo mlx5_vfio_pci > /sys/bus/pci/devices/0000:01:00.0/driver_override

   7) unbind device from original module
    echo 0000:01:00.0 > /sys/bus/pci/devices/0000:01:00.0/driver/unbind

   8) probe PCI drivers (or explicitly bind to mlx5_vfio_pci)
    echo 0000:01:00.0 > /sys/bus/pci/drivers_probe

The algorithm is independent of bus type. In future the other buses with
VFIO device drivers, like platform and ACPI, can use this algorithm as
well.

This patch is the infrastructure to provide the information in the
modules.alias to userspace. Convert the only VFIO pci_driver which results
in one new line in the modules.alias:

  alias vfio_pci:v*d*sv*sd*bc*sc*i* vfio_pci

Later series introduce additional HW specific VFIO PCI drivers, such as
mlx5_vfio_pci.

Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/vfio_pci.c       |  9 ++++++++-
 include/linux/mod_devicetable.h   |  4 ++++
 include/linux/pci.h               | 14 ++++++++++++++
 scripts/mod/devicetable-offsets.c |  1 +
 scripts/mod/file2alias.c          |  8 ++++++--
 5 files changed, 33 insertions(+), 3 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 07edddf7e6ca..c52620ac5e70 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -180,9 +180,16 @@ static int vfio_pci_sriov_configure(struct pci_dev *pdev, int nr_virtfn)
 	return vfio_pci_core_sriov_configure(pdev, nr_virtfn);
 }
 
+static const struct pci_device_id vfio_pci_table[] = {
+	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_ANY_ID, PCI_ANY_ID) }, /* match all by default */
+	{}
+};
+
+MODULE_DEVICE_TABLE(pci, vfio_pci_table);
+
 static struct pci_driver vfio_pci_driver = {
 	.name			= "vfio-pci",
-	.id_table		= NULL, /* only dynamic ids */
+	.id_table		= vfio_pci_table,
 	.probe			= vfio_pci_probe,
 	.remove			= vfio_pci_remove,
 	.sriov_configure	= vfio_pci_sriov_configure,
diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
index 2e3ba6d9ece0..f0325a172f87 100644
--- a/include/linux/mod_devicetable.h
+++ b/include/linux/mod_devicetable.h
@@ -16,6 +16,10 @@ typedef unsigned long kernel_ulong_t;
 
 #define PCI_ANY_ID (~0)
 
+enum {
+	PCI_ID_F_VFIO_DRIVER_OVERRIDE	= 1 << 0,
+};
+
 /**
  * struct pci_device_id - PCI device ID structure
  * @vendor:		Vendor ID to match (or PCI_ANY_ID)
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 0506b1a8c921..527a1dfd1d06 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -916,6 +916,20 @@ struct pci_driver {
 	.vendor = (vend), .device = (dev), .subvendor = PCI_ANY_ID, \
 	.subdevice = PCI_ANY_ID, .override_only = (driver_override)
 
+/**
+ * PCI_DRIVER_OVERRIDE_DEVICE_VFIO - macro used to describe a VFIO
+ *                                   "driver_override" PCI device.
+ * @vend: the 16 bit PCI Vendor ID
+ * @dev: the 16 bit PCI Device ID
+ *
+ * This macro is used to create a struct pci_device_id that matches a
+ * specific device. The subvendor and subdevice fields will be set to
+ * PCI_ANY_ID and the driver_override will be set to
+ * PCI_ID_F_VFIO_DRIVER_OVERRIDE.
+ */
+#define PCI_DRIVER_OVERRIDE_DEVICE_VFIO(vend, dev) \
+	PCI_DEVICE_DRIVER_OVERRIDE(vend, dev, PCI_ID_F_VFIO_DRIVER_OVERRIDE)
+
 /**
  * PCI_DEVICE_SUB - macro used to describe a specific PCI device with subsystem
  * @vend: the 16 bit PCI Vendor ID
diff --git a/scripts/mod/devicetable-offsets.c b/scripts/mod/devicetable-offsets.c
index 9bb6c7edccc4..cc3625617a0e 100644
--- a/scripts/mod/devicetable-offsets.c
+++ b/scripts/mod/devicetable-offsets.c
@@ -42,6 +42,7 @@ int main(void)
 	DEVID_FIELD(pci_device_id, subdevice);
 	DEVID_FIELD(pci_device_id, class);
 	DEVID_FIELD(pci_device_id, class_mask);
+	DEVID_FIELD(pci_device_id, override_only);
 
 	DEVID(ccw_device_id);
 	DEVID_FIELD(ccw_device_id, match_flags);
diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
index 7c97fa8e36bc..c3edbf73157e 100644
--- a/scripts/mod/file2alias.c
+++ b/scripts/mod/file2alias.c
@@ -426,7 +426,7 @@ static int do_ieee1394_entry(const char *filename,
 	return 1;
 }
 
-/* Looks like: pci:vNdNsvNsdNbcNscNiN. */
+/* Looks like: pci:vNdNsvNsdNbcNscNiN or <prefix>_pci:vNdNsvNsdNbcNscNiN. */
 static int do_pci_entry(const char *filename,
 			void *symval, char *alias)
 {
@@ -440,8 +440,12 @@ static int do_pci_entry(const char *filename,
 	DEF_FIELD(symval, pci_device_id, subdevice);
 	DEF_FIELD(symval, pci_device_id, class);
 	DEF_FIELD(symval, pci_device_id, class_mask);
+	DEF_FIELD(symval, pci_device_id, override_only);
 
-	strcpy(alias, "pci:");
+	if (override_only & PCI_ID_F_VFIO_DRIVER_OVERRIDE)
+		strcpy(alias, "vfio_pci:");
+	else
+		strcpy(alias, "pci:");
 	ADD(alias, "v", vendor != PCI_ANY_ID, vendor);
 	ADD(alias, "d", device != PCI_ANY_ID, device);
 	ADD(alias, "sv", subvendor != PCI_ANY_ID, subvendor);
-- 
2.18.1

