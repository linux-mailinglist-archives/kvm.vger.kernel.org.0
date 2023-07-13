Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50530751566
	for <lists+kvm@lfdr.de>; Thu, 13 Jul 2023 02:38:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233296AbjGMAiO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jul 2023 20:38:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233215AbjGMAiK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jul 2023 20:38:10 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2060a.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e83::60a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6D2C2120;
        Wed, 12 Jul 2023 17:38:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=arep3v2JzEc9OqxTWmmYN+Hav2JzoSOQy++EW6Q8icQego2H02s0YDPLd1egRYkgTefTuC9n8G367hwITGmJBU93P7mZqYbg1tuprN4gdsC7Tcfu3K94vcOIi/0Zy50rReHRJpLFZdiXB12ULuR0AEiWOU/jlN3OtQruSxly2rVfkSThtWcAWH4p0OZbXnTTTkjbheGHbCDdIu0dW2ii5eR+LPOjwE3GaMO4yYHFy8rdS70hGtCqmZovPWGAnsY64nmBkXElO98Unj0SLQEwLNRjE+XWn8hLdfq+CKjPN0U2W63YbD8M7dLUrOVZ0qEhDXr3w6BAzpoFjwHhxC55Rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iYbDbK4kb8TY0d4PLbZh4IQEtbKMNBV4hjTnaJE1W8Y=;
 b=W6hcU8uSiTRsfxs1XG5PnFDjDBqp9YAanSYTPVJvNq7+ne3XUqbwNsKOFVTvj7Af12n3KykMNVZ0AB2NV4Yi1pkf9TTUo0gt+aU8+ky97fn4h9YWO01uyZPjeMuGsytIqJfQll001GqSDl7FSSU/5PaAfp8pK4gC0HLS8r0RsdlW018vQEJhANYIbCPuVreT/jDNeoxikHGMyo95Uu4XNKzzyXPzhYgbbm7bi/2LVsRu/u6FU0b15g26fHRxV1OYHr44Vhal5IceOLFbn0XAFtENAgTy9UCFnAh+zEVc/GJ6di7bcy8RghaA8tvD42igg12lb2cmqTlOaHTqoYyTPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iYbDbK4kb8TY0d4PLbZh4IQEtbKMNBV4hjTnaJE1W8Y=;
 b=FVBU+woCCHDtnC/o5Eu7s9tAg+rFzBei0TjuS+sIeSGZgc7V9VhgPquWuQdbO2AxPrZ03m1dNR71KwN7ZHUUGE7nW4P8X7TJbK4Qxr0v1M7tbEt1GfbWQho+nDDkYI9RhRj9k1owd8ROuHNE1/kb0y+TVg0ZVOxutctPdxI/ZR8=
Received: from MW4PR04CA0106.namprd04.prod.outlook.com (2603:10b6:303:83::21)
 by CH0PR12MB5348.namprd12.prod.outlook.com (2603:10b6:610:d7::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.20; Thu, 13 Jul
 2023 00:37:57 +0000
Received: from CO1NAM11FT019.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:83:cafe::f2) by MW4PR04CA0106.outlook.office365.com
 (2603:10b6:303:83::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.22 via Frontend
 Transport; Thu, 13 Jul 2023 00:37:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT019.mail.protection.outlook.com (10.13.175.57) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6588.24 via Frontend Transport; Thu, 13 Jul 2023 00:37:57 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Wed, 12 Jul
 2023 19:37:56 -0500
From:   Brett Creeley <brett.creeley@amd.com>
To:     <kvm@vger.kernel.org>, <netdev@vger.kernel.org>,
        <alex.williamson@redhat.com>, <jgg@nvidia.com>,
        <yishaih@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
        <kevin.tian@intel.com>
CC:     <brett.creeley@amd.com>, <shannon.nelson@amd.com>
Subject: [PATCH v11 vfio 7/7] vfio/pds: Add Kconfig and documentation
Date:   Wed, 12 Jul 2023 17:37:27 -0700
Message-ID: <20230713003727.11226-8-brett.creeley@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230713003727.11226-1-brett.creeley@amd.com>
References: <20230713003727.11226-1-brett.creeley@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT019:EE_|CH0PR12MB5348:EE_
X-MS-Office365-Filtering-Correlation-Id: 01a9dd49-1a46-4634-9257-08db83396796
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Qwb8P2ln7reeJ3BCqYPvZmhtsysiJmwgZI5X9pXsDZ+K5hkAys5pR/4Zhk9vtcW0F2n2bhdM8pKBekkMoa8gufTSMBbqNhQZ06tnxR+eLa6EK/tzLXgbAr6BrR6/r8NeMTUn3SQ5qXQJ6GhW+gV55jlLvoM2c/bk2Rk2oO/PLe9MmFK1O81wNtbmeSf3jEMGTKWXvJurY/gjAaEtKVbphkHp2yBwTq9lQBsLg14gwXoYLn6p9egCZvaea9in+W1msHJu3Wh631Cylat67wxenBTTRPw4361s3W5BekY7eDyW3Yvo5h59E5Kutk5BnwUyyGg5ZopaQrHd7vHnKQWaWP4TNeEaQf63+0VTHILwIUSpR/M31ei9QEYYFJmqoZ5Bp4brWX3B+4N6b5Ek0A1ZjoKh/JRrfju0puoelk+x6Ny/0/wDU8yl09Gb+gN2AJh/AvycbVnqD2jPDL79ZY7xU/eiQHRA8YpKRbAmllXMspp3jd764xj0hpN4nG+SsiOLboeTofaMeCT/+n5i977o4e9nlgpKI6+dgbpt6KsZc+Vt4sDlIxhCYT0M37VkC9rp6eRNSXjxCjSHBDIBLc5huZ5LSxwJZRyPh2SnNBJz+VYWeIGe+YLZIOzT+sTyutWpceo4s7TOGf4NztNTHsh/S1MXxmzmcB4A/iMB/m2HEqpXzN70iDytEZSKA250fAWFnGInr7s9G5NMY3Kij29rwHz/d4pWr1RZnbTxbAEMtmj/UWJ+VFqfq5LZi0GVDmwnM8YNQ2BlrmofR6em1rTXTA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(396003)(39860400002)(136003)(451199021)(40470700004)(36840700001)(46966006)(47076005)(83380400001)(36860700001)(41300700001)(426003)(2616005)(44832011)(110136005)(16526019)(186003)(36756003)(336012)(40460700003)(2906002)(5660300002)(81166007)(82740400003)(356005)(26005)(4326008)(8936002)(40480700001)(8676002)(1076003)(316002)(86362001)(82310400005)(70206006)(54906003)(70586007)(478600001)(6666004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2023 00:37:57.5634
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 01a9dd49-1a46-4634-9257-08db83396796
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT019.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5348
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add Kconfig entries and pds-vfio-pci.rst. Also, add an entry in the
MAINTAINERS file for this new driver.

It's not clear where documentation for vendor specific VFIO
drivers should live, so just re-use the current amd
ethernet location.

Signed-off-by: Brett Creeley <brett.creeley@amd.com>
Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
---
 .../ethernet/amd/pds-vfio-pci.rst             | 79 +++++++++++++++++++
 .../device_drivers/ethernet/index.rst         |  1 +
 MAINTAINERS                                   |  7 ++
 drivers/vfio/pci/Kconfig                      |  2 +
 drivers/vfio/pci/pds/Kconfig                  | 19 +++++
 5 files changed, 108 insertions(+)
 create mode 100644 Documentation/networking/device_drivers/ethernet/amd/pds-vfio-pci.rst
 create mode 100644 drivers/vfio/pci/pds/Kconfig

diff --git a/Documentation/networking/device_drivers/ethernet/amd/pds-vfio-pci.rst b/Documentation/networking/device_drivers/ethernet/amd/pds-vfio-pci.rst
new file mode 100644
index 000000000000..7a6bc848a2b2
--- /dev/null
+++ b/Documentation/networking/device_drivers/ethernet/amd/pds-vfio-pci.rst
@@ -0,0 +1,79 @@
+.. SPDX-License-Identifier: GPL-2.0+
+.. note: can be edited and viewed with /usr/bin/formiko-vim
+
+==========================================================
+PCI VFIO driver for the AMD/Pensando(R) DSC adapter family
+==========================================================
+
+AMD/Pensando Linux VFIO PCI Device Driver
+Copyright(c) 2023 Advanced Micro Devices, Inc.
+
+Overview
+========
+
+The ``pds-vfio-pci`` module is a PCI driver that supports Live Migration
+capable Virtual Function (VF) devices in the DSC hardware.
+
+Using the device
+================
+
+The pds-vfio-pci device is enabled via multiple configuration steps and
+depends on the ``pds_core`` driver to create and enable SR-IOV Virtual
+Function devices.
+
+Shown below are the steps to bind the driver to a VF and also to the
+associated auxiliary device created by the ``pds_core`` driver. This
+example assumes the pds_core and pds-vfio-pci modules are already
+loaded.
+
+.. code-block:: bash
+  :name: example-setup-script
+
+  #!/bin/bash
+
+  PF_BUS="0000:60"
+  PF_BDF="0000:60:00.0"
+  VF_BDF="0000:60:00.1"
+
+  # Prevent non-vfio VF driver from probing the VF device
+  echo 0 > /sys/class/pci_bus/$PF_BUS/device/$PF_BDF/sriov_drivers_autoprobe
+
+  # Create single VF for Live Migration via pds_core
+  echo 1 > /sys/bus/pci/drivers/pds_core/$PF_BDF/sriov_numvfs
+
+  # Allow the VF to be bound to the pds-vfio-pci driver
+  echo "pds-vfio-pci" > /sys/class/pci_bus/$PF_BUS/device/$VF_BDF/driver_override
+
+  # Bind the VF to the pds-vfio-pci driver
+  echo "$VF_BDF" > /sys/bus/pci/drivers/pds-vfio-pci/bind
+
+After performing the steps above, a file in /dev/vfio/<iommu_group>
+should have been created.
+
+
+Enabling the driver
+===================
+
+The driver is enabled via the standard kernel configuration system,
+using the make command::
+
+  make oldconfig/menuconfig/etc.
+
+The driver is located in the menu structure at:
+
+  -> Device Drivers
+    -> VFIO Non-Privileged userspace driver framework
+      -> VFIO support for PDS PCI devices
+
+Support
+=======
+
+For general Linux networking support, please use the netdev mailing
+list, which is monitored by Pensando personnel::
+
+  netdev@vger.kernel.org
+
+For more specific support needs, please use the Pensando driver support
+email::
+
+  drivers@pensando.io
diff --git a/Documentation/networking/device_drivers/ethernet/index.rst b/Documentation/networking/device_drivers/ethernet/index.rst
index 94ecb67c0885..804e1f7c461c 100644
--- a/Documentation/networking/device_drivers/ethernet/index.rst
+++ b/Documentation/networking/device_drivers/ethernet/index.rst
@@ -16,6 +16,7 @@ Contents:
    altera/altera_tse
    amd/pds_core
    amd/pds_vdpa
+   amd/pds_vfio
    aquantia/atlantic
    chelsio/cxgb
    cirrus/cs89x0
diff --git a/MAINTAINERS b/MAINTAINERS
index 486fb3a84696..74f309b5de62 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -22353,6 +22353,13 @@ S:	Maintained
 P:	Documentation/driver-api/vfio-pci-device-specific-driver-acceptance.rst
 F:	drivers/vfio/pci/*/
 
+VFIO PDS PCI DRIVER
+M:	Brett Creeley <brett.creeley@amd.com>
+L:	kvm@vger.kernel.org
+S:	Maintained
+F:	Documentation/networking/device_drivers/ethernet/amd/pds-vfio-pci.rst
+F:	drivers/vfio/pci/pds/
+
 VFIO PLATFORM DRIVER
 M:	Eric Auger <eric.auger@redhat.com>
 L:	kvm@vger.kernel.org
diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
index 86bb7835cf3c..8125e5f37832 100644
--- a/drivers/vfio/pci/Kconfig
+++ b/drivers/vfio/pci/Kconfig
@@ -63,4 +63,6 @@ source "drivers/vfio/pci/mlx5/Kconfig"
 
 source "drivers/vfio/pci/hisilicon/Kconfig"
 
+source "drivers/vfio/pci/pds/Kconfig"
+
 endmenu
diff --git a/drivers/vfio/pci/pds/Kconfig b/drivers/vfio/pci/pds/Kconfig
new file mode 100644
index 000000000000..ef5c5972ad92
--- /dev/null
+++ b/drivers/vfio/pci/pds/Kconfig
@@ -0,0 +1,19 @@
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2023 Advanced Micro Devices, Inc.
+
+config PDS_VFIO_PCI
+	tristate "VFIO support for PDS PCI devices"
+	depends on PDS_CORE
+	select VFIO_PCI_CORE
+	help
+	  This provides generic PCI support for PDS devices using the VFIO
+	  framework.
+
+	  More specific information on this driver can be
+	  found in
+	  <file:Documentation/networking/device_drivers/ethernet/amd/pds-vfio-pci.rst>.
+
+	  To compile this driver as a module, choose M here. The module
+	  will be called pds-vfio-pci.
+
+	  If you don't know what to do here, say N.
-- 
2.17.1

