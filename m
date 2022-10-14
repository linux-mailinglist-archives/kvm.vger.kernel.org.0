Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C60A75FE824
	for <lists+kvm@lfdr.de>; Fri, 14 Oct 2022 06:43:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229693AbiJNEn2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Oct 2022 00:43:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbiJNEnT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Oct 2022 00:43:19 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2049.outbound.protection.outlook.com [40.107.244.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0ED51FF84;
        Thu, 13 Oct 2022 21:43:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OygbywTLIE5polI2PfYFN27+1flLuQKb/k5tLW4b0L8lG3+mdilyFu6RWGCOiOKb3yvsUlfkI5mI5JU98GZQKCvDrU04et9AiKkPDg97rUQlp2/jYWo65A2oH3jWIQAEz3z3vA0uz2sdWcqXpU5HUA6lb/VbC1lEHndNjUZ1G1m7hJqwUBiunq46iGPHPm0reTp1jhvmiW1vTNJrG0lpdIY/ro5R5yNUCLQrfFaptb05ts7xa3oPFnHf2MOG7FlPe3ejPA+71ORYIfGmIZjllx5cVSPJ99x+wCQYl2vwpf8QMQ/ji1ly6I2P74CYgy8dsWAxNQ2WR+NF9LIP5XW7NQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C0i80iGOTH8V7qAjgrWDHN6Y7bOnMG8d0gejaNCQVK8=;
 b=gkAmgu4n9QeS+jCqukC6+KJTUN8DsvgABfHCsZkGXZY8kRVcH3c/sYTTR8b6HewqsTCZIP+9zVYu1uCAaegWVrXc20y4tsXX3ic8mUeIdNv4Ev5Kjy81Ctg5u4VkZHjV7eSg3HkoxmR76eZk/3pp+QDEpKNQ9qske7xGRzhkMqkbB5qqAMe38sceuB2UzGE1MaRpfnyK5yaDbidB3DNTtTnQkRsT7KJlDS4g4snHL88gV2dBvc7nQDq3Ha8Xbvf13XDCU48j4LpE+76zFkq+QKofYpUlpzY9l/cYYh32WJtI0DegmdZBRsbEuMkfH2sxYH6Ssz3uDI5boeE1P6f/7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C0i80iGOTH8V7qAjgrWDHN6Y7bOnMG8d0gejaNCQVK8=;
 b=debeD+Zos4XmXb/NZp0q8azt9bOF3PABVF9OBEvjva8+lgKu6cnPBsw40z2S8bruKY4hSK+O9GUkVxsZZNlfG2DkMWMOGOHBUYq3H/f69IxO8QoJQfrMeZpmsHH9HcLDkOCebiAJhRFD1wfHi4X+glsNKSF5l1IOezN939fyPJA=
Received: from DM5PR07CA0073.namprd07.prod.outlook.com (2603:10b6:4:ad::38) by
 SN7PR12MB7023.namprd12.prod.outlook.com (2603:10b6:806:260::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.22; Fri, 14 Oct
 2022 04:43:00 +0000
Received: from DM6NAM11FT069.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:ad:cafe::96) by DM5PR07CA0073.outlook.office365.com
 (2603:10b6:4:ad::38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.15 via Frontend
 Transport; Fri, 14 Oct 2022 04:43:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DM6NAM11FT069.mail.protection.outlook.com (10.13.173.202) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5723.20 via Frontend Transport; Fri, 14 Oct 2022 04:42:59 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Thu, 13 Oct
 2022 23:42:58 -0500
Received: from xhdipdslab49.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2375.28 via Frontend
 Transport; Thu, 13 Oct 2022 23:42:50 -0500
From:   Nipun Gupta <nipun.gupta@amd.com>
To:     <robh+dt@kernel.org>, <krzysztof.kozlowski+dt@linaro.org>,
        <gregkh@linuxfoundation.org>, <rafael@kernel.org>,
        <eric.auger@redhat.com>, <alex.williamson@redhat.com>,
        <cohuck@redhat.com>, <puneet.gupta@amd.com>,
        <song.bao.hua@hisilicon.com>, <mchehab+huawei@kernel.org>,
        <maz@kernel.org>, <f.fainelli@gmail.com>,
        <jeffrey.l.hugo@gmail.com>, <saravanak@google.com>,
        <Michael.Srba@seznam.cz>, <mani@kernel.org>, <yishaih@nvidia.com>,
        <jgg@ziepe.ca>, <jgg@nvidia.com>, <robin.murphy@arm.com>,
        <will@kernel.org>, <joro@8bytes.org>, <masahiroy@kernel.org>,
        <ndesaulniers@google.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kbuild@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <okaya@kernel.org>, <harpreet.anand@amd.com>,
        <nikhil.agarwal@amd.com>, <michal.simek@amd.com>,
        <aleksandar.radovanovic@amd.com>, <git@amd.com>,
        Nipun Gupta <nipun.gupta@amd.com>
Subject: [RFC PATCH v4 8/8] bus/cdx: add cdx controller
Date:   Fri, 14 Oct 2022 10:10:49 +0530
Message-ID: <20221014044049.2557085-9-nipun.gupta@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221014044049.2557085-1-nipun.gupta@amd.com>
References: <20220803122655.100254-1-nipun.gupta@amd.com>
 <20221014044049.2557085-1-nipun.gupta@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT069:EE_|SN7PR12MB7023:EE_
X-MS-Office365-Filtering-Correlation-Id: dd8332cd-d0f7-495c-4497-08daad9e91f1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Cyd5b2BcfjSyrm/0HpJOcosbcXziUYj/9uXEa0J5tizFHYz7SXwIN7gy7asQncLLg5AAmxH+2dEkDNnjXSElS271sslEvphRzX+M3zd183WpR9WjffBOMxJkOFi9WrsrPRhSzKVJOe6tHWMmcgs7+8/ErZqs3f31LVsDTkWUjEWXWJ7sERlX0vhZ66BDXn3ki0Hw/NtJIfDDYMir/r4XmcItxpszkHVuvZUhKoWMNn64TgE/uV3R3F22MkNKcRtT22NiAS4GppFtSD5q545sm3wu8PgXYj7km04eEauQEydRrDZph7znmt62O8lI5l66/8YJfWiOZJ3Jbg6qWdort4DZp/d5Jb0NsJRAC9sYCiWCOVcZd3xTGah4T0stV9zYEuYAqM8TOjdGGrMPGA7SXqI8Te0eBIzauBexhq/BbW8WsilbESzE7eiGbak/oRjwSZ0ez6D+AE+ISuK/NShVFIED/nE5/DH+PJmWuqewnTpRalK/1ikg+myZBaQYYGG4F7FhJeXz/po27Lt19AWIkIVR3MRy5TCiwVVlpAv3vqSZ9EaTnExFkcrGYalVJH9glz0NAZzrAcbBRRw16sqp3BIuvN5qgA5vtb4lTLgvJ11HEW/Ouc3Y/+KjuLYNXch9iVeGR/kmwzojVTsJjBpItm4sT5VmKyZO2nDveSWHfLgOpTp8f58pC6AA7lNefzs4VYPjew9jixsb3oJJNF82LmZp7/BNqVgJCqIk1+3PuT3YZWgiduIfW0aNUy0/feVk9xkEGr0jX2nIgd9nacjirEI7CXQUNtbisJ4axWsQfyCUcS6AVGUglukmbLcEvV1c4ApJPKHRDJLhkn3ZTgo18KAXPUP3QWRs8BnkNUezUAWy2NqDlhDK5Vm7yZyZ7Sje
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(376002)(396003)(136003)(346002)(451199015)(40470700004)(36840700001)(46966006)(26005)(81166007)(316002)(82740400003)(356005)(70206006)(110136005)(4326008)(8676002)(70586007)(36860700001)(40460700003)(921005)(36756003)(40480700001)(86362001)(82310400005)(83380400001)(8936002)(44832011)(478600001)(54906003)(2616005)(1076003)(2906002)(426003)(186003)(336012)(47076005)(30864003)(5660300002)(41300700001)(7416002)(2101003)(83996005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2022 04:42:59.0667
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dd8332cd-d0f7-495c-4497-08daad9e91f1
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT069.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7023
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add driver for CDX controller. The controller discovers the
CDX devices with the help of firmware and add those devices
to the CDX bus.

CDX controller also provide ops to be registered to CDX
bus for scanning, resetting and writing MSI data to CDX
devices.

Signed-off-by: Nipun Gupta <nipun.gupta@amd.com>
---
 drivers/bus/cdx/Kconfig                     |   2 +
 drivers/bus/cdx/Makefile                    |   2 +-
 drivers/bus/cdx/controller/Kconfig          |  16 ++
 drivers/bus/cdx/controller/Makefile         |   8 +
 drivers/bus/cdx/controller/cdx_controller.c | 210 ++++++++++++++++++++
 drivers/bus/cdx/controller/mcdi_stubs.c     |  68 +++++++
 drivers/bus/cdx/controller/mcdi_stubs.h     | 101 ++++++++++
 7 files changed, 406 insertions(+), 1 deletion(-)
 create mode 100644 drivers/bus/cdx/controller/Kconfig
 create mode 100644 drivers/bus/cdx/controller/Makefile
 create mode 100644 drivers/bus/cdx/controller/cdx_controller.c
 create mode 100644 drivers/bus/cdx/controller/mcdi_stubs.c
 create mode 100644 drivers/bus/cdx/controller/mcdi_stubs.h

diff --git a/drivers/bus/cdx/Kconfig b/drivers/bus/cdx/Kconfig
index 062443080d6f..8036d754a0a6 100644
--- a/drivers/bus/cdx/Kconfig
+++ b/drivers/bus/cdx/Kconfig
@@ -12,3 +12,5 @@ config CDX_BUS
 		Driver to enable CDX Bus infrastructure. CDX bus uses
 		CDX controller and firmware to scan the FPGA based
 		devices.
+
+source "drivers/bus/cdx/controller/Kconfig"
diff --git a/drivers/bus/cdx/Makefile b/drivers/bus/cdx/Makefile
index 95f8fa3b4db8..285fd7d51174 100644
--- a/drivers/bus/cdx/Makefile
+++ b/drivers/bus/cdx/Makefile
@@ -5,4 +5,4 @@
 # Copyright (C) 2022, Advanced Micro Devices, Inc.
 #
 
-obj-$(CONFIG_CDX_BUS) += cdx.o cdx_msi.o
+obj-$(CONFIG_CDX_BUS) += cdx.o cdx_msi.o controller/
diff --git a/drivers/bus/cdx/controller/Kconfig b/drivers/bus/cdx/controller/Kconfig
new file mode 100644
index 000000000000..29bd45626d38
--- /dev/null
+++ b/drivers/bus/cdx/controller/Kconfig
@@ -0,0 +1,16 @@
+# SPDX-License-Identifier: GPL-2.0-only
+#
+# CDX controller configuration
+#
+# Copyright (C) 2022, Advanced Micro Devices, Inc.
+#
+
+config CDX_CONTROLLER
+	tristate "CDX hardware driver"
+	depends on CDX_BUS
+	help
+	  CDX controller drives the CDX bus. It interacts with
+	  firmware to get the hardware devices and registers with
+	  the CDX bus. Say Y to enable the CDX hardware driver.
+
+	  If unsure, say N.
diff --git a/drivers/bus/cdx/controller/Makefile b/drivers/bus/cdx/controller/Makefile
new file mode 100644
index 000000000000..83bcd4ae1874
--- /dev/null
+++ b/drivers/bus/cdx/controller/Makefile
@@ -0,0 +1,8 @@
+# SPDX-License-Identifier: GPL-2.0-only
+#
+# Makefile for CDX controller drivers
+#
+# Copyright (C) 2022, Advanced Micro Devices, Inc.
+#
+
+obj-$(CONFIG_CDX_CONTROLLER) += cdx_controller.o mcdi_stubs.o
diff --git a/drivers/bus/cdx/controller/cdx_controller.c b/drivers/bus/cdx/controller/cdx_controller.c
new file mode 100644
index 000000000000..792fbb8314d5
--- /dev/null
+++ b/drivers/bus/cdx/controller/cdx_controller.c
@@ -0,0 +1,210 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Platform driver for CDX bus.
+ *
+ * Copyright (C) 2022, Advanced Micro Devices, Inc.
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/of.h>
+#include <linux/slab.h>
+#include <linux/of_platform.h>
+#include <linux/cdx/cdx_bus.h>
+
+#include "../cdx.h"
+#include "mcdi_stubs.h"
+
+static int cdx_reset_device(struct cdx_controller_t *cdx,
+			    uint8_t bus_num, uint8_t dev_num)
+{
+	return cdx_mcdi_reset_dev(cdx->priv, bus_num, dev_num);
+}
+
+static int cdx_scan_devices(struct cdx_controller_t *cdx)
+{
+	struct cdx_mcdi_t *cdx_mcdi = cdx->priv;
+	int num_cdx_bus, num_cdx_dev;
+	uint8_t bus_num, dev_num;
+	int ret;
+
+	/* MCDI FW Read: Fetch the number of CDX buses present*/
+	num_cdx_bus = cdx_mcdi_get_num_buses(cdx_mcdi);
+
+	for (bus_num = 0; bus_num < num_cdx_bus; bus_num++) {
+		/* MCDI FW Read: Fetch the number of devices present */
+		num_cdx_dev = cdx_mcdi_get_num_devs(cdx_mcdi, bus_num);
+
+		for (dev_num = 0; dev_num < num_cdx_dev; dev_num++) {
+			struct cdx_dev_params_t dev_params;
+
+			/* MCDI FW: Get the device config */
+			ret = cdx_mcdi_get_dev_config(cdx_mcdi, bus_num,
+						      dev_num, &dev_params);
+			if (ret) {
+				dev_err(cdx->dev,
+					"CDX device config get failed for bus: %d\n", ret);
+				return ret;
+			}
+			dev_params.cdx = cdx;
+
+			/* Add the device to the cdx bus */
+			ret = cdx_device_add(&dev_params);
+			if (ret) {
+				dev_err(cdx->dev, "registering cdx dev: %d failed: %d\n",
+					dev_num, ret);
+				return ret;
+			}
+
+			dev_dbg(cdx->dev, "CDX dev: %d on cdx bus: %d created\n",
+				dev_num, bus_num);
+		}
+	}
+
+	return 0;
+}
+
+static int cdx_write_msi(struct cdx_controller_t *cdx, uint8_t bus_num,
+			 uint8_t dev_num, uint16_t msi_index,
+			 uint32_t data, uint64_t addr)
+{
+	return cdx_mcdi_write_msi(cdx->priv, bus_num, dev_num,
+				  msi_index, data, addr);
+}
+
+static int cdx_probe(struct platform_device *pdev)
+{
+	struct cdx_mcdi_t *cdx_mcdi;
+	struct cdx_controller_t *cdx;
+	struct device_node *iommu_node;
+	struct platform_device *plat_iommu_dev;
+	int ret;
+
+	/*
+	 * Defer probe CDX controller in case IOMMU is not yet initialized.
+	 * We do not add CDX devices before the IOMMU device is probed, as
+	 * in cleanup or shutdown time (device_shutdonw()), which traverse
+	 * device list in reverse order of device addition, we need to remove
+	 * CDX devices, before IOMMU device is removed.
+	 */
+	iommu_node = of_parse_phandle(pdev->dev.of_node, "iommu-map", 1);
+	if (!of_device_is_available(iommu_node)) {
+		dev_err(&pdev->dev, "No associated IOMMU node found\n");
+		return -EINVAL;
+	}
+
+	plat_iommu_dev = of_find_device_by_node(iommu_node);
+	if (!plat_iommu_dev) {
+		ret = -EPROBE_DEFER;
+		goto iommu_of_cleanup;
+	}
+
+	if (!plat_iommu_dev->dev.driver) {
+		ret = -EPROBE_DEFER;
+		goto iommu_of_cleanup;
+	}
+
+	cdx_mcdi = kzalloc(sizeof(*cdx_mcdi), GFP_KERNEL);
+	if (!cdx_mcdi) {
+		dev_err(&pdev->dev, "Failed to allocate memory for cdx_mcdi\n");
+		ret = -ENOMEM;
+		goto iommu_of_cleanup;
+	}
+
+	/* MCDI FW: Initialize the FW path */
+	ret = cdx_mcdi_init(cdx_mcdi);
+	if (ret) {
+		dev_err(&pdev->dev, "MCDI Initialization failed: %d\n", ret);
+		goto mcdi_init_fail;
+	}
+
+	cdx = kzalloc(sizeof(*cdx), GFP_KERNEL);
+	if (!cdx) {
+		dev_err(&pdev->dev, "Failed to allocate memory for cdx\n");
+		ret = -ENOMEM;
+		goto cdx_alloc_fail;
+	}
+	platform_set_drvdata(pdev, cdx);
+
+	cdx->dev = &pdev->dev;
+	cdx->priv = cdx_mcdi;
+	cdx->ops.scan = cdx_scan_devices;
+	cdx->ops.reset_dev = cdx_reset_device;
+	cdx->ops.write_msi = cdx_write_msi;
+
+	/* Register CDX controller with CDX bus driver */
+	ret = cdx_register_controller(cdx);
+	if (ret) {
+		dev_err(&pdev->dev, "Failed to register CDX controller\n");
+		goto cdx_register_fail;
+	}
+
+	return 0;
+
+cdx_register_fail:
+	kfree(cdx);
+cdx_alloc_fail:
+	cdx_mcdi_finish(cdx_mcdi);
+mcdi_init_fail:
+	kfree(cdx_mcdi);
+iommu_of_cleanup:
+	of_node_put(iommu_node);
+
+	return ret;
+}
+
+static int cdx_remove(struct platform_device *pdev)
+{
+	struct cdx_controller_t *cdx = platform_get_drvdata(pdev);
+	struct cdx_mcdi_t *cdx_mcdi = cdx->priv;
+
+	cdx_unregister_controller(cdx);
+	kfree(cdx);
+
+	cdx_mcdi_finish(cdx_mcdi);
+	kfree(cdx_mcdi);
+
+	return 0;
+}
+
+static void cdx_shutdown(struct platform_device *pdev)
+{
+	cdx_remove(pdev);
+}
+
+static const struct of_device_id cdx_match_table[] = {
+	{.compatible = "xlnx,cdxbus-controller-1.0",},
+	{ },
+};
+
+MODULE_DEVICE_TABLE(of, cdx_match_table);
+
+static struct platform_driver cdx_pdriver = {
+	.driver = {
+		   .name = "cdx-controller",
+		   .pm = NULL,
+		   .of_match_table = cdx_match_table,
+		   },
+	.probe = cdx_probe,
+	.remove = cdx_remove,
+	.shutdown = cdx_shutdown,
+};
+
+static int __init cdx_controller_init(void)
+{
+	int ret;
+
+	ret = platform_driver_register(&cdx_pdriver);
+	if (ret < 0)
+		pr_err("platform_driver_register() failed: %d\n", ret);
+
+	return ret;
+}
+module_init(cdx_controller_init);
+
+static void __exit cdx_controller_exit(void)
+{
+	platform_driver_unregister(&cdx_pdriver);
+}
+module_exit(cdx_controller_exit);
diff --git a/drivers/bus/cdx/controller/mcdi_stubs.c b/drivers/bus/cdx/controller/mcdi_stubs.c
new file mode 100644
index 000000000000..17737ffeae1c
--- /dev/null
+++ b/drivers/bus/cdx/controller/mcdi_stubs.c
@@ -0,0 +1,68 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * MCDI Firmware interaction for CDX bus.
+ *
+ * Copyright (C) 2022, Advanced Micro Devices, Inc.
+ */
+
+#include <linux/ioport.h>
+
+#include "mcdi_stubs.h"
+
+int cdx_mcdi_init(struct cdx_mcdi_t *cdx_mcdi)
+{
+	cdx_mcdi->id = 0;
+	cdx_mcdi->flags = 0;
+
+	return 0;
+}
+
+void cdx_mcdi_finish(struct cdx_mcdi_t *cdx_mcdi)
+{
+}
+
+int cdx_mcdi_get_num_buses(struct cdx_mcdi_t *cdx_mcdi)
+{
+	return 1;
+}
+
+int cdx_mcdi_get_num_devs(struct cdx_mcdi_t *cdx_mcdi, int bus_num)
+{
+	return 1;
+}
+
+int cdx_mcdi_get_dev_config(struct cdx_mcdi_t *cdx_mcdi,
+			    uint8_t bus_num, uint8_t dev_num,
+			    struct cdx_dev_params_t *dev_params)
+{
+	dev_params->res[0].start = 0xe4020000;
+	dev_params->res[0].end = 0xe4020FFF;
+	dev_params->res[0].flags = IORESOURCE_MEM;
+	dev_params->res[1].start = 0xe4100000;
+	dev_params->res[1].end = 0xE411FFFF;
+	dev_params->res[1].flags = IORESOURCE_MEM;
+	dev_params->res_count = 2;
+
+	dev_params->req_id = 0x250;
+	dev_params->num_msi = 4;
+	dev_params->vendor = 0x10ee;
+	dev_params->device = 0x8084;
+	dev_params->bus_num = bus_num;
+	dev_params->dev_num = dev_num;
+
+	return 0;
+}
+
+int cdx_mcdi_reset_dev(struct cdx_mcdi_t *cdx_mcdi,
+		       uint8_t bus_num, uint8_t dev_num)
+{
+	return 0;
+}
+
+int cdx_mcdi_write_msi(struct cdx_mcdi_t *cdx_mcdi,
+		       uint8_t bus_num, uint8_t dev_num,
+		       uint16_t msi_index, uint32_t data,
+		       uint64_t addr)
+{
+	return 0;
+}
diff --git a/drivers/bus/cdx/controller/mcdi_stubs.h b/drivers/bus/cdx/controller/mcdi_stubs.h
new file mode 100644
index 000000000000..3256f0e306fa
--- /dev/null
+++ b/drivers/bus/cdx/controller/mcdi_stubs.h
@@ -0,0 +1,101 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Header file for MCDI FW interaction for CDX bus.
+ *
+ * Copyright (C) 2022, Advanced Micro Devices, Inc.
+ */
+
+#ifndef _MCDI_STUBS_H_
+#define _MCDI_STUBS_H_
+
+#include "../cdx.h"
+
+/**
+ * struct cdx_mcdi_t - CDX MCDI Firmware interface, to interact
+ *		       with CDX controller.
+ * @id: ID for MCDI Firmware interface
+ * @flags: Associated flags
+ */
+struct cdx_mcdi_t {
+	u32 id;
+	u32 flags;
+	/* Have more MCDI interface related data */
+};
+
+/**
+ * cdx_mcdi_init - Initialize the MCDI Firmware interface
+ *	for the CDX controller.
+ * @cdx_mcdi: pointer to MCDI interface
+ *
+ * Return 0 on success, <0 on failure
+ */
+int cdx_mcdi_init(struct cdx_mcdi_t *cdx_mcdi);
+
+/**
+ * cdx_mcdi_finish - Close the MCDI Firmware interface.
+ * @cdx_mcdi: pointer to MCDI interface
+ */
+void cdx_mcdi_finish(struct cdx_mcdi_t *cdx_mcdi);
+
+/**
+ * cdx_mcdi_get_num_buses - Get the total number of busses on
+ *	the controller.
+ * @cdx_mcdi: pointer to MCDI interface.
+ *
+ * Return total number of busses available on the controller,
+ *	<0 on failure
+ */
+int cdx_mcdi_get_num_buses(struct cdx_mcdi_t *cdx_mcdi);
+
+/**
+ * cdx_mcdi_get_num_devs - Get the total number of devices on
+ *	a particular bus.
+ * @cdx_mcdi: pointer to MCDI interface.
+ * @bus_num: Bus number.
+ *
+ * Return total number of devices available on the bus, <0 on failure
+ */
+int cdx_mcdi_get_num_devs(struct cdx_mcdi_t *cdx_mcdi, int bus_num);
+
+/**
+ * cdx_mcdi_get_dev_config - Get configuration for a particular
+ *	bus_num:dev_num
+ * @cdx_mcdi: pointer to MCDI interface.
+ * @bus_num: Bus number.
+ * @dev_num: Device number.
+ * @dev_params: Pointer to cdx_dev_params_t, this is populated by this
+ *	function with the configuration corresponding to the provided
+ *	bus_num:dev_num.
+ *
+ * Return 0 total number of devices available on the bus, <0 on failure
+ */
+int cdx_mcdi_get_dev_config(struct cdx_mcdi_t *cdx_mcdi,
+			    uint8_t bus_num, uint8_t dev_num,
+			    struct cdx_dev_params_t *dev_params);
+
+/**
+ * cdx_mcdi_reset_dev - Reset cdx device represented by bus_num:dev_num
+ * @cdx_mcdi: pointer to MCDI interface.
+ * @bus_num: Bus number.
+ * @dev_num: Device number.
+ *
+ * Return 0 on success, <0 on failure
+ */
+int cdx_mcdi_reset_dev(struct cdx_mcdi_t *cdx_mcdi,
+		       uint8_t bus_num, uint8_t dev_num);
+
+/**
+ * cdx_mcdi_write_msi_data - Write MSI related info to the Firmware
+ * @cdx_mcdi: pointer to MCDI interface.
+ * @bus_num: Bus number.
+ * @dev_num: Device number.
+ * @msi_index: MSI Index for which the data and address is provided
+ * @data: MSI data (i.e. eventID) for the interrupt
+ * @addr: the address on which the MSI is to be raised
+ */
+int cdx_mcdi_write_msi(struct cdx_mcdi_t *cdx_mcdi,
+		       uint8_t bus_num, uint8_t dev_num,
+		       uint16_t msi_index, uint32_t data,
+		       uint64_t addr);
+
+#endif /* _MCDI_STUBS_H_ */
-- 
2.25.1

