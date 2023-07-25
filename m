Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5302A7624A0
	for <lists+kvm@lfdr.de>; Tue, 25 Jul 2023 23:41:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229664AbjGYVlc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jul 2023 17:41:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231164AbjGYVla (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 17:41:30 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2087.outbound.protection.outlook.com [40.107.92.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CAD01FEC;
        Tue, 25 Jul 2023 14:41:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f73467ZG4k0UVk0NRZGRrFXtOIaZOShvkXR9A5xoOjScfVW5QVngwBZhx9g9srAGizbhrGeBPinh5D081JqiquWiScRVlMufn9ddg6Zz8TY+NRaGxSdvOt4kxS4meMZ4U4nma/FXW1PdFPKhp4F7i2FHB/IkdAwlLY/R/0aUbnraF4z4UbDjmdgMGHAIZDIKjYllGBQnGqltQmHmCPji00ZqiFm63kd6mq0QkS46lC+gp9tLpqMk4uINGbOmAbEs7IRhe8PU+CJsiLNcUOti1MIu4sdBHstIkqw9h8X4wtDVjZeM1ygQsoJjjGCKbxnxplaDvSmyKJ3ComuHHdtFmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I1ML86yg3WfhuvkRkWK1nHNnmgGRHpodrBNZ6h5Zt9c=;
 b=hS3L3f0RZlR91I7NSxwq/HfVLonKVx5D/8VmYJKpIKWmXxgl2Q6j697TbvXiZgqVSCUrGEoAhmnST6OfZRgbYGd42Cnl763z/N6hb79GG082oAynQbIDfJTO2JJ1ZbKB0bDQEtOVAwP8J4KMgXo4RKC2h0zSOsIDzF1Pjt7AQmhy/VU0FVMAdFVuZXbwMmkfDpc1E4E80cR0EpzEn4+1EvkJOBMDQBlk/grwA/AzS1o/2cW/L7el3WXe39gA/hh1aUfGghX/2g9jyGiVBjXd88pyQ80m+UOEhihNgiYQgwMPIs0ZtdR1jE2tb7nT4f/DP+bCACSVJVuU91i6p1cH0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I1ML86yg3WfhuvkRkWK1nHNnmgGRHpodrBNZ6h5Zt9c=;
 b=udujvu84Q1mhecvDSoWp0mYiO1OhVD0d0BitdsgU+sTy2OPp+MnDesW4sGNME8TlUEJY1RckUQ2rHg4eIhpN8NLZOeolNGSNiOtV6+HcBxE91U5eXKZylJPj4jMuqkNgNv8LfLLt8EOOIYhr2bpDVRrp4X7/YWynsxff8UbdnFU=
Received: from BN9PR03CA0805.namprd03.prod.outlook.com (2603:10b6:408:13f::30)
 by PH0PR12MB5466.namprd12.prod.outlook.com (2603:10b6:510:d7::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.33; Tue, 25 Jul
 2023 21:41:23 +0000
Received: from BN8NAM11FT046.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13f:cafe::65) by BN9PR03CA0805.outlook.office365.com
 (2603:10b6:408:13f::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.31 via Frontend
 Transport; Tue, 25 Jul 2023 21:41:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT046.mail.protection.outlook.com (10.13.177.127) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6631.22 via Frontend Transport; Tue, 25 Jul 2023 21:41:23 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Tue, 25 Jul
 2023 16:41:02 -0500
From:   Brett Creeley <brett.creeley@amd.com>
To:     <kvm@vger.kernel.org>, <netdev@vger.kernel.org>,
        <alex.williamson@redhat.com>, <jgg@nvidia.com>,
        <yishaih@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
        <kevin.tian@intel.com>
CC:     <simon.horman@corigine.com>, <brett.creeley@amd.com>,
        <shannon.nelson@amd.com>
Subject: [PATCH v13 vfio 7/7] vfio/pds: Add Kconfig and documentation
Date:   Tue, 25 Jul 2023 14:40:25 -0700
Message-ID: <20230725214025.9288-8-brett.creeley@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230725214025.9288-1-brett.creeley@amd.com>
References: <20230725214025.9288-1-brett.creeley@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT046:EE_|PH0PR12MB5466:EE_
X-MS-Office365-Filtering-Correlation-Id: 58f1a6ad-1d6c-4ba7-987a-08db8d57e450
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fAAM1VtmkEVREGUx/NhgIvz0QVM7G6jmbHl493hQ9R7WtO/9PEuDmpK13Bopp/U6tz158MYDDPclPIrxmcYpZakFwhmWVlwNeJ6Y0o1H9DngqoI2ZI9vBLHq3rvPDYYLkVunKC9D+z8KBaDygNPNcLUPcPmcM0uUr/odLMoSc1LhI3drKAoSm47Kc/gwoeafx7Jzrftik1KA+wHXU83/fWuxOW/JDUgxRHHEhXArl28LK1hcEux2rPHWpA/pZn0GVVt/Pc/L/Mbv+JHARzy/WM3wlloI/1PUskn2F+gsENNet5rSp/Dct6uWluFH6JYrzJ6iLP1Ngl25JaJ4JDbwZDEWKPuMxpREl39KpqdXpRkD/ly9yaY0gADMOx7D69EA4fnNR577jER+Bvsf4LnPypBz9qYzDURdMFGDAhxm+jyPTol5pNtvy2Cg3FOB9oqHknezx4LCb3hXnZBl/77ajTFIZuLu2PqR99ZB3KqfiefBkdluvu8bPCArczr6gWG+t6pRLoEFFk8IoDdixgjSLtqxtH8ftBB4gGF1QYGxGbCWGHvIJsQWepKIZGGX5cPVoG4XgR/qvZ6gCmDAo68eyelhosdG+BM64JXAPR675pDBAgffjuixGfI7+4SYZ5P3hUoa+rpjByWMONEeNkC44klKSjoBYFbiY3KK0wtPYmM4qPnmBrMzAQafZkv0mbi1Yu1LRFzfEAsboYKu8KH7kr+nEMuD/eCoE8T2T1Ri8npSgt2Eh4nB9qXrmlcGmCoq5ChBFkyqUR9dbr9/rU8NeQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(136003)(346002)(396003)(376002)(451199021)(82310400008)(36840700001)(40470700004)(46966006)(82740400003)(478600001)(356005)(83380400001)(6666004)(47076005)(26005)(1076003)(4326008)(54906003)(110136005)(81166007)(16526019)(186003)(336012)(36860700001)(2616005)(70206006)(70586007)(426003)(44832011)(5660300002)(8936002)(8676002)(40460700003)(2906002)(316002)(41300700001)(40480700001)(86362001)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2023 21:41:23.4746
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 58f1a6ad-1d6c-4ba7-987a-08db8d57e450
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT046.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5466
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
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
 .../ethernet/amd/pds_vfio_pci.rst             | 79 +++++++++++++++++++
 .../device_drivers/ethernet/index.rst         |  1 +
 MAINTAINERS                                   |  7 ++
 drivers/vfio/pci/Kconfig                      |  2 +
 drivers/vfio/pci/pds/Kconfig                  | 19 +++++
 5 files changed, 108 insertions(+)
 create mode 100644 Documentation/networking/device_drivers/ethernet/amd/pds_vfio_pci.rst
 create mode 100644 drivers/vfio/pci/pds/Kconfig

diff --git a/Documentation/networking/device_drivers/ethernet/amd/pds_vfio_pci.rst b/Documentation/networking/device_drivers/ethernet/amd/pds_vfio_pci.rst
new file mode 100644
index 000000000000..7a6bc848a2b2
--- /dev/null
+++ b/Documentation/networking/device_drivers/ethernet/amd/pds_vfio_pci.rst
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
index 94ecb67c0885..9827e816084b 100644
--- a/Documentation/networking/device_drivers/ethernet/index.rst
+++ b/Documentation/networking/device_drivers/ethernet/index.rst
@@ -16,6 +16,7 @@ Contents:
    altera/altera_tse
    amd/pds_core
    amd/pds_vdpa
+   amd/pds_vfio_pci
    aquantia/atlantic
    chelsio/cxgb
    cirrus/cs89x0
diff --git a/MAINTAINERS b/MAINTAINERS
index ddc71b815791..1fbe4db3ec8c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -22436,6 +22436,13 @@ S:	Maintained
 P:	Documentation/driver-api/vfio-pci-device-specific-driver-acceptance.rst
 F:	drivers/vfio/pci/*/
 
+VFIO PDS PCI DRIVER
+M:	Brett Creeley <brett.creeley@amd.com>
+L:	kvm@vger.kernel.org
+S:	Maintained
+F:	Documentation/networking/device_drivers/ethernet/amd/pds_vfio_pci.rst
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
index 000000000000..407b3fd32733
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
+	  <file:Documentation/networking/device_drivers/ethernet/amd/pds_vfio_pci.rst>.
+
+	  To compile this driver as a module, choose M here. The module
+	  will be called pds-vfio-pci.
+
+	  If you don't know what to do here, say N.
-- 
2.17.1

