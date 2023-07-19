Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE6D375A205
	for <lists+kvm@lfdr.de>; Thu, 20 Jul 2023 00:36:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230517AbjGSWgD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jul 2023 18:36:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230512AbjGSWgB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jul 2023 18:36:01 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2052.outbound.protection.outlook.com [40.107.237.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 901951FF3;
        Wed, 19 Jul 2023 15:35:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PhEWyoxd6j76a+usbu2OOI/0Nca6hE6m/sQOZUB88Ja74S8ZP2pb2CoUO9R0I52EApe455bBIiE3vIIsd+r2g8TcLXetFskmHC/nmLFTrCyLsMkhhp8+fMvkvpvIWNGR/2bd9FWpZJ2vHc6TABsgLdyGo1dNLoQY253MdrN076LHv4eyO9bgv3aEH9KiPLXvL4Fo7PfzxI3gwr0V1AYyk46G03kJQd0jK02+m8FQed2kAZ1VY4IF9ce5/EV3gfowVEVWQJ/HwgoVa4FuOTiprs8lqpq7OV8HSNd0ZnUauH6/7+RPF376y9oqnGIVI89u8TxPFEuNBqfs8JQr/RwsQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7W3Xv+v/QshPyHRUjBk8bST9H/pxbU+hcgI2UZ96j1k=;
 b=VC10yaUjnfug8lGP3urG8JqwrkbqQlqGJAg2UjMfgjEMCCM0KAwCdawVfsKIieF9opyEhP1fQZy6x0ak+JEtlzzyFWRmadnoiLHie6Vgi3jmbJuOjtrZG5ZLhUof6kjA4oWiY3wW9CSo8Pdw/Wkx4DTGhop24J5TrFeVKAdo5ctqb48XyMUZVQjMceylE3jMoB+S12Xo/PsnUfxfFP8PrpUhQuWIxT0Y0bn40b9WuHcyM05XtxWMkO73rL+adEF3ly+pPwiqbYwnmIwglhuTSCJuCWTlhLmoFmc0MgwV4aSHgJWwYRkb8iBowqJKMva3oDrQri/mMhdRH5fkEar8YA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7W3Xv+v/QshPyHRUjBk8bST9H/pxbU+hcgI2UZ96j1k=;
 b=0iaObt4ckMg8rse/uoMEn2JTBHQa4pdH2QyqUqYRfJ1/CaLwW3vNRb7mbCsAXd4VLnYVy8bC2ijzweOvEM/czeC6rAm9LVzdYpkv4oHCXoK8wQZPCsUplAIaoq/bLufCJ3HwQLKFe+Eag8qizCpAo5oxT8w1lHBOUvBHKP/jagU=
Received: from BN9PR03CA0954.namprd03.prod.outlook.com (2603:10b6:408:108::29)
 by SA3PR12MB9225.namprd12.prod.outlook.com (2603:10b6:806:39e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.27; Wed, 19 Jul
 2023 22:35:54 +0000
Received: from BN8NAM11FT026.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:108:cafe::46) by BN9PR03CA0954.outlook.office365.com
 (2603:10b6:408:108::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.33 via Frontend
 Transport; Wed, 19 Jul 2023 22:35:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT026.mail.protection.outlook.com (10.13.177.51) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6588.34 via Frontend Transport; Wed, 19 Jul 2023 22:35:54 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Wed, 19 Jul
 2023 17:35:52 -0500
From:   Brett Creeley <brett.creeley@amd.com>
To:     <kvm@vger.kernel.org>, <netdev@vger.kernel.org>,
        <alex.williamson@redhat.com>, <jgg@nvidia.com>,
        <yishaih@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
        <kevin.tian@intel.com>
CC:     <brett.creeley@amd.com>, <shannon.nelson@amd.com>
Subject: [PATCH v12 vfio 7/7] vfio/pds: Add Kconfig and documentation
Date:   Wed, 19 Jul 2023 15:35:27 -0700
Message-ID: <20230719223527.12795-8-brett.creeley@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230719223527.12795-1-brett.creeley@amd.com>
References: <20230719223527.12795-1-brett.creeley@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT026:EE_|SA3PR12MB9225:EE_
X-MS-Office365-Filtering-Correlation-Id: 13d82df7-a432-4298-d6ab-08db88a88352
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mUxx04iWKhCHcocVfR3Vcefp3Alm+1eYXzcnECbjWOZi81Rf2gp3FJDOda4+jf8rosaJU3A1fn4QA3qqFIEXF3/zw2hksNgK3NwDmcm7Ki4b1Y/IZNl/P0Zr9h6oO8h3Jqa2HnYav85KLLPYnOCnH9MYyUtre8LdDTGk92TH6H9eTIzlzirEk5r1tUNyUkJoAhK95+7kczIds2rUfoTxQfmVT1DPOAvdlDLbs8UJWLMvGMHuJChTZFWuwfcM4Ed2i6kIpTc9Iux0MQZjA6wN5DvR15fQk+Fgicvh7Enp4hOMeyBdca6/fWP26gUv+f4RNfTFU4/lrEnypBU1DX+JgAV4UcyujhQIb+qaPkZxwqwtSFT17Y0rMqAnphHnRKGDuv9+GodSPt7SKoarVset22I9/KHHFuhMnr0lbwmUbFVPQJkXRwmHMRLaXmQf2yXuBwhYUgwlYfzJc6b6fzA47IdqwoJ/3egxN6eXvJ9a8wuSPcITgHFGpWsYoFgBVRbl+f26lCawGAHCvbnhai1o5WXeECQs+aUChG+elJCYdr/St4y82y8UjbWd0/EZ/oSxD/Ia06CHU6/8V1/NHisIqxYXkhx1WIy2tw7B5bBFUEirQNqUbvAJHnhAq//MnB0JCHMPc+G2/eGXUZI+9mTyzEumHMGAKmJybWlILL63X0+SvgVL9jfHf69X2Voa8HMnm8M/WPzWF3ewrXiSI0EjLYmWG+CMJkEeXTQACjx1g64eU0oAayVGAPfKtkJYNPF7wUX73gKAz3lIAD1MqqLWyw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(376002)(136003)(346002)(396003)(451199021)(82310400008)(40470700004)(46966006)(36840700001)(1076003)(40460700003)(6666004)(36860700001)(47076005)(186003)(16526019)(2616005)(336012)(83380400001)(426003)(36756003)(356005)(82740400003)(86362001)(81166007)(26005)(40480700001)(4326008)(70586007)(41300700001)(2906002)(44832011)(316002)(70206006)(110136005)(8936002)(8676002)(54906003)(5660300002)(478600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2023 22:35:54.1715
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 13d82df7-a432-4298-d6ab-08db88a88352
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT026.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB9225
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
index d30f622ed7b9..d320d76aaf7b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -22423,6 +22423,13 @@ S:	Maintained
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

