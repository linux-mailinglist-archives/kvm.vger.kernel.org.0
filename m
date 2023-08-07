Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 690577730CB
	for <lists+kvm@lfdr.de>; Mon,  7 Aug 2023 22:58:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230291AbjHGU64 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Aug 2023 16:58:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230146AbjHGU6z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Aug 2023 16:58:55 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2057.outbound.protection.outlook.com [40.107.243.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D94231711;
        Mon,  7 Aug 2023 13:58:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b4kNQch+27IEFs1I6WLPfGjsaxG/1OpM1ebq4tcjo0kW5N3v4Hg534or0LBuU0FBYms4NzuyWvTPgGERM0BWj91UwT+A0j6i25BMdVh9U/CQW/TDhNswyEBiwN9RlMzcr0eQyfAybuf62w7byuJqgczn0KavrRKIG3tGUxEAfMG4Szx9/Q2P6QRtiNw6H83ksJbr7KAHN5r2pTxA1BKJ9CLnG979VTzhztAJWAHWMuJtWF2gBqVuvbIRKIWhZQ1CuX+Uk30bezMeaWZlp4nEFP2sdHEXHdnJgVrqDhC3cf7CqaodYQI/T4WGoVE0+8/T6abflLsbh3gvF+jDa6UKNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Tp66w1FH9J2oE9vXkrj+lObFvq3n9LQi3eVWyFqzfAU=;
 b=lWKHSGjbCkzLwySuKYOQXyB17jrHHhV6Smfs1ibgQCQisEoZ651sb25z6kQlb7K2NfpS125ugggbV3BU0+jYAQ/56LFsADbiw5Ig9k7kUEJuWKkOo7+4Q4uw5PtsONlS7T4lj5JnydLEvVwdhoHgg7rbRlVq96zlJ2V30OqLbjDEFdD22iZoAnGruYkOGXalAvZ1ZoIOmeQw4i0Vd8FYbSLcr6vZrZ2ev7HX7evYntYwbF3Lkka7CnqBlNcyolhb3lk2FLgotc81KctyEtxJXhlLnX57kG+8jaxM/t5kYa9+yhdhquT/XZkxVTS+4knLPqmirYc72uNpMekJC7Ug4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tp66w1FH9J2oE9vXkrj+lObFvq3n9LQi3eVWyFqzfAU=;
 b=K741BpdX5FFHNrHPhwoMca4Vp/zeFbZsDtcji7Ann3Q4itlLOZTt4afJ/LQ+OjPBttdr53MIjixFkxIVPHiZwNtM8EYgUoeIoVWUKaJ0bczyenIyMKMJpgtWVmT4OS1JcInfjQzK+dNnWGCHAP26/A6xuOu2U66ZEN2EFTXPHNw=
Received: from BY3PR05CA0032.namprd05.prod.outlook.com (2603:10b6:a03:39b::7)
 by MW6PR12MB9018.namprd12.prod.outlook.com (2603:10b6:303:241::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.25; Mon, 7 Aug
 2023 20:58:40 +0000
Received: from MWH0EPF000989E6.namprd02.prod.outlook.com
 (2603:10b6:a03:39b:cafe::29) by BY3PR05CA0032.outlook.office365.com
 (2603:10b6:a03:39b::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6678.15 via Frontend
 Transport; Mon, 7 Aug 2023 20:58:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MWH0EPF000989E6.mail.protection.outlook.com (10.167.241.133) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6652.20 via Frontend Transport; Mon, 7 Aug 2023 20:58:40 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Mon, 7 Aug
 2023 15:58:31 -0500
From:   Brett Creeley <brett.creeley@amd.com>
To:     <kvm@vger.kernel.org>, <netdev@vger.kernel.org>,
        <alex.williamson@redhat.com>, <jgg@nvidia.com>,
        <yishaih@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
        <kevin.tian@intel.com>
CC:     <horms@kernel.org>, <brett.creeley@amd.com>,
        <shannon.nelson@amd.com>
Subject: [PATCH v14 vfio 8/8] vfio/pds: Add Kconfig and documentation
Date:   Mon, 7 Aug 2023 13:57:55 -0700
Message-ID: <20230807205755.29579-9-brett.creeley@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230807205755.29579-1-brett.creeley@amd.com>
References: <20230807205755.29579-1-brett.creeley@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000989E6:EE_|MW6PR12MB9018:EE_
X-MS-Office365-Filtering-Correlation-Id: dc5beec1-6507-4910-f49b-08db978913de
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7jMVXYuE6hgF/Wjj1Sibd51C/3NO+eVbx0NslspPuYsxj/qee2Z+yZEWJ0kCyryoCYM3AhUWsmV9+S+bZuyxYDyf/m4351Pydn1NmlJELfBDgT/MIWdZjgX5e07+V9mfI67DsLDfbRLayxqTsBjBGdV0GC5Rqd+sEy0pD3nkR/aKziJrN5iwRLO/cj9PGDwigUKpykt1oBf7LlYxT9/4Uq8vw6HlwEjgY3Ma9sI/LM+liEukBh4iqiPzgk0Qc/I37f8r6Pax2mejDFVfWfZZrYinP42n1CaBfVvxyGxY7u5ZQcoWAw6tIeLlyvYr+JENu7uOQHicJGkk7kE19uQ88b7htxZf9jkBQQdtzqFa07yUSSX65LBiOseDT9NKSBlgFCyDoUVNXfllQLzXvacgKGY/M/Ue8FpLMNTh1yoSiIhyzHkd4p8kRCzS+EOstphcaZsYbbNVUS8TDIBdSDw+CnyrUv4dctmZJgVhRsFxzVTUyxWJm06II+rrUD7s/J6ze4XIOzSw5BJji1+5qp+XVuPAE0bl/91aurUdW7AxkvBfhph1lGEAJO9sytN9j7tsvOT/Ui67LOGjR11yx4ZjOo1o5FKIC7uFtjoAVSbiEBkast5diA17NKXV2UcvAurLH44OKjVbnw4OY1YrxOxeJ/5cSgOUIzr/QkWrndw8TTMvX+6EU1MKdoozGYAoWvSx505Nc1Oh3s4Yx3vLw5rIwdTINAohRf9psLDp+7EC31T3XYhwxCoOkHnw3tKou+VNt2bZrZX71Eix0SpWW1ES/g==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(396003)(136003)(346002)(376002)(451199021)(186006)(1800799003)(82310400008)(40470700004)(46966006)(36840700001)(40480700001)(336012)(16526019)(2616005)(40460700003)(36756003)(4326008)(316002)(81166007)(86362001)(82740400003)(110136005)(356005)(54906003)(70586007)(6666004)(478600001)(70206006)(41300700001)(1076003)(26005)(426003)(8676002)(8936002)(47076005)(36860700001)(2906002)(83380400001)(5660300002)(44832011)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2023 20:58:40.1030
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dc5beec1-6507-4910-f49b-08db978913de
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: MWH0EPF000989E6.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB9018
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
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
Reviewed-by: Simon Horman <horms@kernel.org>
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
index d516295978a4..7b1306615fc0 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -22348,6 +22348,13 @@ S:	Maintained
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

