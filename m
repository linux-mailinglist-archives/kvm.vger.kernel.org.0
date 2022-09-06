Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0DE25AEC93
	for <lists+kvm@lfdr.de>; Tue,  6 Sep 2022 16:28:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241490AbiIFOU3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Sep 2022 10:20:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241477AbiIFOST (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Sep 2022 10:18:19 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2087.outbound.protection.outlook.com [40.107.212.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80D9813F44;
        Tue,  6 Sep 2022 06:49:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ip1A1B6FDOM6rlP75tR7hdjI1Zw5m35rOB1WJOpTXLjjMHxVgcUmg7njnDFxxE5T0Z4vsebUtJRciao0I5IU4vsPjF9OnwGRFrP2OJCQGZ3sURG2CrFXep5ej4TKYqd17mz85XYqQWjXOGu8WlUGJVK/PMr8Ghc0067ouscJyspFFWKQSFaQaK4tZ7VvaHAekK9eoSnSTftPTSVPZ/bjVEokf3/7uZKSXDWO1AXlPaa1UdkilkzpqmWijiba0ZB49+vV296POBUYT0hhN/jwhiOELAwXdr/y7OP9pj6y8CRmM23yXLcD5GRDs5dmdzRxAGfOEs0fa+A3jIflQUMm6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=19Or6RyAdh73nl9HFYxk5QBVg/k5Qxra85q9l63LoP8=;
 b=X04dggzMiigRkhFQSh3e+bhtbLNclDZZ4UMzDg9lt7jXLgfPtymTbDW/DV83LlaO+9fqOjuJwlffWy12nZTbNZjlS9cm2zb84U+BP77mtZxzQnFqrBqekq8rPLutPtLFj5sQO0eMsUmn5GBuR1ADX+lcoJWqD46BVmKhuuPjgxbY8ChWhta5HHua8+zC7Xm84O3jHFToKo5RMJ3ObNYN/UUpYpyp+0WQHS1G+YIBWt052azxoNkmdzPasImj8JnN8mktqngSTpZ4Y9TpSFdBT1Ir2jIOVgtvWFkHduxxOt09V+tFrzOFQIUUUcslU7jtbwJmYOEbGHrdLHRJiD+d7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=19Or6RyAdh73nl9HFYxk5QBVg/k5Qxra85q9l63LoP8=;
 b=xUcxF1tCZtqRFlI0poi98gSIybzal6mmTErfsYIkzjb841Ij2UAOjqXmKZYTmvc+0NfwvCaEir92EtMuVblwMRQzeKU104ZT60FpFx+wGYqg8Kec78az7MRJ1nbiGYZsR6RKoa0DFgjACD6amPs6YlGRqKDgPiXLHJ5Rll+UPSE=
Received: from BN1PR14CA0010.namprd14.prod.outlook.com (2603:10b6:408:e3::15)
 by BL1PR12MB5141.namprd12.prod.outlook.com (2603:10b6:208:309::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.12; Tue, 6 Sep
 2022 13:48:34 +0000
Received: from BN8NAM11FT023.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e3:cafe::5f) by BN1PR14CA0010.outlook.office365.com
 (2603:10b6:408:e3::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.12 via Frontend
 Transport; Tue, 6 Sep 2022 13:48:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT023.mail.protection.outlook.com (10.13.177.103) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5612.13 via Frontend Transport; Tue, 6 Sep 2022 13:48:33 +0000
Received: from SATLEXMB07.amd.com (10.181.41.45) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Tue, 6 Sep
 2022 08:48:33 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB07.amd.com
 (10.181.41.45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Tue, 6 Sep
 2022 06:48:32 -0700
Received: from xhdipdslab49.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2375.28 via Frontend
 Transport; Tue, 6 Sep 2022 08:48:22 -0500
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
Subject: [RFC PATCH v3 2/7] bus/cdx: add the cdx bus driver
Date:   Tue, 6 Sep 2022 19:17:56 +0530
Message-ID: <20220906134801.4079497-3-nipun.gupta@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220906134801.4079497-1-nipun.gupta@amd.com>
References: <20220803122655.100254-1-nipun.gupta@amd.com>
 <20220906134801.4079497-1-nipun.gupta@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT023:EE_|BL1PR12MB5141:EE_
X-MS-Office365-Filtering-Correlation-Id: a0c9127b-b601-49f2-0181-08da900e7dc0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qK9Jof4FCZafs7uTKXSL7rdMpkcmjveHidReNyoI/yUbCgb58RgKdQ4hEIoGrLkEUZ0oHWqLo105zP03EBTZKJ5a7CfKvvhm2hRsmCxYLGwVNIRDcMnPHaiNmeiyLH4YurGF4EEWtYx6824Wcn9JEAmHGlxKGjMEaTkXXtFl+7mbYMhD3YZCwVudUSQlgAH3Opblsxjf19PaDV4v+RINqkiJfuOkmfm3m2LJH0hUfnnY/Exf+XMdkzPcboaS4uER8CGWdy/AVJE1LDFCgzSXUr0RkyM8YVYD0cTtNRRpEzD3ZxACVoV+SWZv+FaNJd0t8WiqUR9rna7C2i72Lnn08c+AKPmgcEbS1vR6l8Jp4MdgwNPtweewAY4v0kaTtiTXrJeKwdjrPercW2kGi5PnhSQNse+Y6k9AL9qi406dHgOvUXOJAohiTa6Oeu6i6xZS3ERBuXEwkLFheiE2HBmOT9LyOtypGYL58KEjGEOft+zwF+rqrgkEOCmwo+xS/aOzzvMRw93DliYt4sqX6sfO9oi3vBpAtUKRrNfITaQ6E9/637Rl0w+7TdtK0pv+MQOZQf8LK6uGUnS298oXpBxlsg0i3V3iy8OicSTbnJWJH0Dc1MK3ihNvMeVagAVX8Zr35FeAFYa/r5XP/RoirQC9lMcTydl6UpgeyluvBlidfpzc30m72oNHJvr63JhqQZFdpx3DOfcXomDbmgtxtT7AEfZklRFTtzqCl8Z4z6GaziSRhJ0UvTq2FlNSOfX9vbfUmbgTitmTpEalrDzizIFc3aKq/VB5oQ+6E0QqoIoolgVgqzLO4wDyWzIz2/XPDoxaWuNROP1fdvg4lTulQbUOo+AeKBKHEvpP2WwXSjEjocSkXmagaiNOG0Iu4sCvUTOf
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(346002)(39860400002)(136003)(396003)(376002)(36840700001)(46966006)(40470700004)(41300700001)(70206006)(7416002)(86362001)(70586007)(5660300002)(82310400005)(110136005)(44832011)(8936002)(4326008)(316002)(36756003)(6666004)(8676002)(30864003)(478600001)(186003)(83380400001)(2616005)(336012)(2906002)(426003)(26005)(40460700003)(54906003)(40480700001)(47076005)(356005)(36860700001)(81166007)(1076003)(921005)(82740400003)(36900700001)(2101003)(83996005);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2022 13:48:33.9242
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a0c9127b-b601-49f2-0181-08da900e7dc0
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT023.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5141
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CDX bus supports the scanning and probing of FPGA based
devices. These devices are registers as CDX devices.

The bus driver sets up the basic infrastructure and fetches
the device related information from the firmware.

CDX bus is capable of scanning devices dynamically,
supporting rescanning of dynamically added, removed or
updated devices.

Signed-off-by: Nipun Gupta <nipun.gupta@amd.com>
---

Basic overview of CDX bus architecture is provided in [patch 0/7].

Please NOTE: This RFC change does not support the CDX bus firmware
interface as it is under development, and this series aims to get
an early feedback from the community. Firmware interaction are
stubbed as MCDI APIs which is a protocol used by AMD to interact
with Firmware.

 MAINTAINERS                       |   2 +
 drivers/bus/Kconfig               |   1 +
 drivers/bus/Makefile              |   3 +
 drivers/bus/cdx/Kconfig           |   7 +
 drivers/bus/cdx/Makefile          |   3 +
 drivers/bus/cdx/cdx.c             | 437 ++++++++++++++++++++++++++++++
 drivers/bus/cdx/cdx.h             |  34 +++
 drivers/bus/cdx/mcdi_stubs.c      |  54 ++++
 drivers/bus/cdx/mcdi_stubs.h      |  76 ++++++
 include/linux/cdx/cdx_bus.h       |  93 +++++++
 include/linux/mod_devicetable.h   |  13 +
 scripts/mod/devicetable-offsets.c |   4 +
 scripts/mod/file2alias.c          |  12 +
 13 files changed, 739 insertions(+)
 create mode 100644 drivers/bus/cdx/Kconfig
 create mode 100644 drivers/bus/cdx/Makefile
 create mode 100644 drivers/bus/cdx/cdx.c
 create mode 100644 drivers/bus/cdx/cdx.h
 create mode 100644 drivers/bus/cdx/mcdi_stubs.c
 create mode 100644 drivers/bus/cdx/mcdi_stubs.h
 create mode 100644 include/linux/cdx/cdx_bus.h

diff --git a/MAINTAINERS b/MAINTAINERS
index f0598b3d731c..61af11c9fe06 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -939,6 +939,8 @@ M:	Nipun Gupta <nipun.gupta@amd.com>
 M:	Nikhil Agarwal <nikhil.agarwal@amd.com>
 S:	Maintained
 F:	Documentation/devicetree/bindings/bus/xlnx,cdx.yaml
+F:	drivers/bus/cdx/*
+F:	include/linux/cdx/*
 
 AMD CRYPTOGRAPHIC COPROCESSOR (CCP) DRIVER - SEV SUPPORT
 M:	Brijesh Singh <brijesh.singh@amd.com>
diff --git a/drivers/bus/Kconfig b/drivers/bus/Kconfig
index 7bfe998f3514..b0324efb9a6a 100644
--- a/drivers/bus/Kconfig
+++ b/drivers/bus/Kconfig
@@ -251,5 +251,6 @@ config DA8XX_MSTPRI
 
 source "drivers/bus/fsl-mc/Kconfig"
 source "drivers/bus/mhi/Kconfig"
+source "drivers/bus/cdx/Kconfig"
 
 endmenu
diff --git a/drivers/bus/Makefile b/drivers/bus/Makefile
index d90eed189a65..88649111c395 100644
--- a/drivers/bus/Makefile
+++ b/drivers/bus/Makefile
@@ -20,6 +20,9 @@ obj-$(CONFIG_INTEL_IXP4XX_EB)	+= intel-ixp4xx-eb.o
 obj-$(CONFIG_MIPS_CDMM)		+= mips_cdmm.o
 obj-$(CONFIG_MVEBU_MBUS) 	+= mvebu-mbus.o
 
+#CDX bus
+obj-$(CONFIG_CDX_BUS)		+= cdx/
+
 # Interconnect bus driver for OMAP SoCs.
 obj-$(CONFIG_OMAP_INTERCONNECT)	+= omap_l3_smx.o omap_l3_noc.o
 
diff --git a/drivers/bus/cdx/Kconfig b/drivers/bus/cdx/Kconfig
new file mode 100644
index 000000000000..c1eed5225328
--- /dev/null
+++ b/drivers/bus/cdx/Kconfig
@@ -0,0 +1,7 @@
+config CDX_BUS
+	bool "CDX Bus driver"
+	help
+		Driver to enable CDX Bus infrastructure. CDX bus is
+		capable of scanning devices dynamically, supporting
+		rescanning of dynamically added, removed or updated
+		devices.
diff --git a/drivers/bus/cdx/Makefile b/drivers/bus/cdx/Makefile
new file mode 100644
index 000000000000..e91bfe706294
--- /dev/null
+++ b/drivers/bus/cdx/Makefile
@@ -0,0 +1,3 @@
+obj-$(CONFIG_CDX_BUS) += cdx-bus-driver.o
+
+cdx-bus-driver-objs := cdx.o cdx_msi.o mcdi_stubs.o
diff --git a/drivers/bus/cdx/cdx.c b/drivers/bus/cdx/cdx.c
new file mode 100644
index 000000000000..fc417c32c59b
--- /dev/null
+++ b/drivers/bus/cdx/cdx.c
@@ -0,0 +1,437 @@
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
+#include <linux/property.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
+#include <linux/of_platform.h>
+#include <linux/dma-mapping.h>
+#include <linux/dma-map-ops.h>
+#include <linux/property.h>
+#include <linux/iommu.h>
+#include <linux/cdx/cdx_bus.h>
+
+#include "cdx.h"
+#include "mcdi_stubs.h"
+
+/*
+ * Default DMA mask for devices on a CDX bus
+ */
+#define CDX_DEFAULT_DMA_MASK	(~0ULL)
+
+struct platform_device *cdx_controller_pdev;
+
+static int cdx_bus_device_discovery(struct platform_device *pdev);
+
+static int cdx_unregister_device(struct device *dev,
+				 void * __always_unused data)
+{
+	struct cdx_device *cdx_dev = to_cdx_device(dev);
+
+	kfree(cdx_dev->driver_override);
+	cdx_dev->driver_override = NULL;
+
+	/*
+	 * Do not free cdx_dev here as it would be freed in
+	 * cdx_device_release() called from within put_device().
+	 */
+	device_del(&cdx_dev->dev);
+	put_device(&cdx_dev->dev);
+
+	return 0;
+}
+
+void cdx_unregister_devices(struct bus_type *bus)
+{
+	int ret;
+
+	/* Reset all the devices attached to cdx bus */
+	ret = bus_for_each_dev(bus, NULL, NULL, cdx_unregister_device);
+	if (ret)
+		pr_err("error in CDX unregister for all devices\n");
+}
+
+/**
+ * cdx_match_one_device - Tell if a CDX device structure has a matching
+ *			  CDX device id structure
+ * @id: single CDX device id structure to match
+ * @dev: the CDX device structure to match against
+ *
+ * Returns the matching cdx_device_id structure or %NULL if there is no match.
+ */
+static inline const struct cdx_device_id *
+cdx_match_one_device(const struct cdx_device_id *id,
+		     const struct cdx_device *dev)
+{
+	if ((id->vendor == dev->vendor) && (id->device == dev->device))
+		return id;
+	return NULL;
+}
+
+/**
+ * cdx_match_id - See if a CDX device matches a given cdx_id table
+ * @ids: array of CDX device ID structures to search in
+ * @dev: the CDX device structure to match against.
+ *
+ * Used by a driver to check whether a CDX device is in its list of
+ * supported devices.  Returns the matching cdx_device_id structure or
+ * %NULL if there is no match.
+ */
+static inline const struct cdx_device_id *
+cdx_match_id(const struct cdx_device_id *ids, struct cdx_device *dev)
+{
+	if (ids) {
+		while (ids->vendor || ids->device) {
+			if (cdx_match_one_device(ids, dev))
+				return ids;
+			ids++;
+		}
+	}
+	return NULL;
+}
+
+/**
+ * cdx_bus_match - device to driver matching callback
+ * @dev: the cdx device to match against
+ * @drv: the device driver to search for matching cdx device
+ * structures
+ *
+ * Returns 1 on success, 0 otherwise.
+ */
+static int cdx_bus_match(struct device *dev, struct device_driver *drv)
+{
+	struct cdx_device *cdx_dev = to_cdx_device(dev);
+	struct cdx_driver *cdx_drv = to_cdx_driver(drv);
+	const struct cdx_device_id *found_id;
+
+	/* When driver_override is set, only bind to the matching driver */
+	if (cdx_dev->driver_override)
+		return !strcmp(cdx_dev->driver_override, cdx_drv->driver.name);
+
+	found_id = cdx_match_id(cdx_drv->match_id_table, cdx_dev);
+	if (found_id)
+		return true;
+
+	return false;
+}
+
+static int cdx_dma_configure(struct device *dev)
+{
+	struct cdx_device *cdx_dev = to_cdx_device(dev);
+	u32 input_id = cdx_dev->req_id;
+	int ret;
+
+	ret = of_dma_configure_id(dev, dev->parent->of_node, 0, &input_id);
+	if (ret) {
+		dev_err(dev, "of_dma_configure_id() failed\n");
+		return ret;
+	}
+
+	return 0;
+}
+
+struct bus_type cdx_bus_type = {
+	.name = "cdx",
+	.match = cdx_bus_match,
+	.dma_configure  = cdx_dma_configure,
+};
+EXPORT_SYMBOL_GPL(cdx_bus_type);
+
+static int cdx_driver_probe(struct device *dev)
+{
+	struct cdx_driver *cdx_drv = to_cdx_driver(dev->driver);
+	struct cdx_device *cdx_dev = to_cdx_device(dev);
+	int error;
+
+	error = cdx_drv->probe(cdx_dev);
+	if (error < 0) {
+		if (error != -EPROBE_DEFER)
+			dev_err(dev, "%s failed: %d\n", __func__, error);
+		return error;
+	}
+
+	return 0;
+}
+
+static int cdx_driver_remove(struct device *dev)
+{
+	struct cdx_driver *cdx_drv = to_cdx_driver(dev->driver);
+	struct cdx_device *cdx_dev = to_cdx_device(dev);
+	int error;
+
+	error = cdx_drv->remove(cdx_dev);
+	if (error < 0) {
+		dev_err(dev, "%s failed: %d\n", __func__, error);
+		return error;
+	}
+
+	return 0;
+}
+
+static void cdx_driver_shutdown(struct device *dev)
+{
+	struct cdx_driver *cdx_drv = to_cdx_driver(dev->driver);
+	struct cdx_device *cdx_dev = to_cdx_device(dev);
+
+	cdx_drv->shutdown(cdx_dev);
+}
+
+/*
+ * __cdx_driver_register - registers a CDX device driver
+ */
+int __cdx_driver_register(struct cdx_driver *cdx_driver,
+			  struct module *owner)
+{
+	int error;
+
+	cdx_driver->driver.owner = owner;
+	cdx_driver->driver.bus = &cdx_bus_type;
+
+	if (cdx_driver->probe)
+		cdx_driver->driver.probe = cdx_driver_probe;
+
+	if (cdx_driver->remove)
+		cdx_driver->driver.remove = cdx_driver_remove;
+
+	if (cdx_driver->shutdown)
+		cdx_driver->driver.shutdown = cdx_driver_shutdown;
+
+	error = driver_register(&cdx_driver->driver);
+	if (error < 0) {
+		pr_err("driver_register() failed for %s: %d\n",
+		       cdx_driver->driver.name, error);
+		return error;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(__cdx_driver_register);
+
+/*
+ * cdx_driver_unregister - unregisters a device driver from the
+ * CDX bus
+ */
+void cdx_driver_unregister(struct cdx_driver *cdx_driver)
+{
+	driver_unregister(&cdx_driver->driver);
+}
+EXPORT_SYMBOL_GPL(cdx_driver_unregister);
+
+static void cdx_device_release(struct device *dev)
+{
+	struct cdx_device *cdx_dev = to_cdx_device(dev);
+
+	kfree(cdx_dev);
+}
+
+static int cdx_device_add(struct device *parent,
+			  struct cdx_dev_params_t *dev_params)
+{
+	struct cdx_device *cdx_dev;
+	int ret;
+
+	cdx_dev = kzalloc(sizeof(*cdx_dev), GFP_KERNEL);
+	if (!cdx_dev) {
+		dev_err(parent,
+			"memory allocation for cdx dev failed\n");
+		return -ENOMEM;
+	}
+
+	/* Populate resource */
+	memcpy(cdx_dev->res, dev_params->res, sizeof(struct resource) *
+		dev_params->res_count);
+	cdx_dev->res_count = dev_params->res_count;
+
+	/* Populate CDX dev params */
+	cdx_dev->req_id = dev_params->req_id;
+	cdx_dev->vendor = dev_params->vendor;
+	cdx_dev->device = dev_params->device;
+	cdx_dev->bus_id = dev_params->bus_id;
+	cdx_dev->func_id = dev_params->func_id;
+	cdx_dev->dma_mask = CDX_DEFAULT_DMA_MASK;
+
+	/* Initiaize generic device */
+	device_initialize(&cdx_dev->dev);
+	cdx_dev->dev.parent = parent;
+	cdx_dev->dev.bus = &cdx_bus_type;
+	cdx_dev->dev.dma_mask = &cdx_dev->dma_mask;
+	cdx_dev->dev.release = cdx_device_release;
+
+	/* Set Name */
+	dev_set_name(&cdx_dev->dev, "cdx-%02x:%02x", cdx_dev->bus_id,
+			cdx_dev->func_id);
+
+	ret = device_add(&cdx_dev->dev);
+	if (ret != 0) {
+		dev_err(&cdx_dev->dev,
+			"cdx device add failed: %d", ret);
+		goto fail;
+	}
+
+	return 0;
+
+fail:
+	/*
+	 * Do not free cdx_dev here as it would be freed in
+	 * cdx_device_release() called from within put_device().
+	 */
+	put_device(&cdx_dev->dev);
+
+	return ret;
+}
+
+static int cdx_bus_device_discovery(struct platform_device *pdev)
+{
+	struct cdx_mcdi_t *cdx_mcdi = platform_get_drvdata(pdev);
+	int num_cdx_bus, num_cdx_func;
+	uint8_t bus_id, func_id;
+	int ret;
+
+	cdx_controller_pdev = pdev;
+
+	/* MCDI FW Read: Fetch the number of CDX buses present*/
+	num_cdx_bus = cdx_mcdi_get_num_buses(cdx_mcdi);
+
+	for (bus_id = 0; bus_id < num_cdx_bus; bus_id++) {
+		/* MCDI FW Read: Fetch the number of devices present */
+		num_cdx_func = cdx_mcdi_get_num_funcs(cdx_mcdi, bus_id);
+
+		for (func_id = 0; func_id < num_cdx_func; func_id++) {
+			struct cdx_dev_params_t dev_params;
+
+			/* MCDI FW: Get the device config */
+			ret = cdx_mcdi_get_func_config(cdx_mcdi, bus_id,
+					func_id, &dev_params);
+			if (ret) {
+				dev_err(&pdev->dev,
+					"CDX device config get failed for bus: %d\n",
+					ret);
+				goto fail;
+			}
+
+			/* Add the device to the cdx bus */
+			ret = cdx_device_add(&pdev->dev, &dev_params);
+			if (ret == -EPROBE_DEFER) {
+				goto fail;
+			} else if (ret) {
+				dev_err(&pdev->dev,
+					"registering cdx dev: %d failed: %d\n",
+					func_id, ret);
+				goto fail;
+			} else {
+				dev_dbg(&pdev->dev,
+					"CDX dev: %d on cdx bus: %d created\n",
+					func_id, bus_id);
+			}
+		}
+	}
+
+	return 0;
+fail:
+	cdx_unregister_devices(&cdx_bus_type);
+	return ret;
+}
+
+static int cdx_bus_probe(struct platform_device *pdev)
+{
+	struct cdx_mcdi_t *cdx_mcdi;
+	int ret;
+
+	cdx_mcdi = kzalloc(sizeof(*cdx_mcdi), GFP_KERNEL);
+	if (!cdx_mcdi) {
+		dev_err(&pdev->dev, "Failed to allocate memory for cdx_mcdi\n");
+		return -ENOMEM;
+	}
+
+	/* MCDI FW: Initialize the FW path */
+	ret = cdx_mcdi_init(cdx_mcdi);
+	if (ret) {
+		dev_err(&pdev->dev, "MCDI Initialization failed: %d\n", ret);
+		goto mcdi_init_fail;
+	}
+	platform_set_drvdata(pdev, cdx_mcdi);
+
+	/* Discover all the devices on the bus */
+	ret = cdx_bus_device_discovery(pdev);
+	if (ret) {
+		dev_err(&pdev->dev,
+			"CDX bus device discovery failed: %d\n", ret);
+		goto device_discovery_fail;
+	}
+
+	return 0;
+
+mcdi_init_fail:
+	kfree(cdx_mcdi);
+device_discovery_fail:
+	cdx_mcdi_finish(cdx_mcdi);
+
+	return ret;
+}
+
+static int cdx_bus_remove(struct platform_device *pdev)
+{
+	struct cdx_mcdi_t *cdx_mcdi = platform_get_drvdata(pdev);
+
+	cdx_unregister_devices(&cdx_bus_type);
+
+	cdx_mcdi_finish(cdx_mcdi);
+	kfree(cdx_mcdi);
+
+	return 0;
+}
+
+static void cdx_bus_shutdown(struct platform_device *pdev)
+{
+	cdx_bus_remove(pdev);
+}
+
+static const struct of_device_id cdx_match_table[] = {
+	{.compatible = "xlnx,cdxbus-controller-1.0",},
+	{ },
+};
+
+MODULE_DEVICE_TABLE(of, cdx_match_table);
+
+static struct platform_driver cdx_bus_driver = {
+	.driver = {
+		   .name = "cdx-bus",
+		   .pm = NULL,
+		   .of_match_table = cdx_match_table,
+		   },
+	.probe = cdx_bus_probe,
+	.remove = cdx_bus_remove,
+	.shutdown = cdx_bus_shutdown,
+};
+
+static int __init cdx_bus_driver_init(void)
+{
+	int ret;
+
+	ret = bus_register(&cdx_bus_type);
+	if (ret < 0) {
+		pr_err("bus type registration failed for CDX: %d\n", ret);
+		return ret;
+	}
+
+	ret = platform_driver_register(&cdx_bus_driver);
+	if (ret < 0) {
+		pr_err("platform_driver_register() failed: %d\n", ret);
+		goto fail;
+	}
+
+	return 0;
+
+fail:
+	bus_unregister(&cdx_bus_type);
+	return ret;
+}
+postcore_initcall(cdx_bus_driver_init);
diff --git a/drivers/bus/cdx/cdx.h b/drivers/bus/cdx/cdx.h
new file mode 100644
index 000000000000..db0569431c10
--- /dev/null
+++ b/drivers/bus/cdx/cdx.h
@@ -0,0 +1,34 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Header file for the CDX Bus
+ *
+ * Copyright (C) 2022, Advanced Micro Devices, Inc.
+ */
+
+#ifndef _CDX_H_
+#define _CDX_H_
+
+#include <linux/cdx/cdx_bus.h>
+#include <linux/irqdomain.h>
+
+/**
+ * struct cdx_dev_params_t - CDX device parameters
+ * @vendor: Vendor ID for CDX device
+ * @device: Device ID for CDX device
+ * @bus_id: Bus ID for this CDX device
+ * @func_id: Function ID for this device
+ * @res: array of MMIO region entries
+ * @res_count: number of valid MMIO regions
+ * @req_id: Requestor ID associated with CDX device
+ */
+struct cdx_dev_params_t {
+	u16 vendor;
+	u16 device;
+	u8 bus_id;
+	u8 func_id;
+	struct resource res[MAX_CDX_DEV_RESOURCES];
+	u8 res_count;
+	u32 req_id;
+};
+
+#endif /* _CDX_H_ */
diff --git a/drivers/bus/cdx/mcdi_stubs.c b/drivers/bus/cdx/mcdi_stubs.c
new file mode 100644
index 000000000000..cc9d30fa02f8
--- /dev/null
+++ b/drivers/bus/cdx/mcdi_stubs.c
@@ -0,0 +1,54 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * MCDI Firmware interaction for CDX bus.
+ *
+ * Copyright (C) 2022, Advanced Micro Devices, Inc.
+ */
+
+#include <linux/ioport.h>
+
+#include "cdx.h"
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
+int cdx_mcdi_get_num_funcs(struct cdx_mcdi_t *cdx_mcdi, int bus_num)
+{
+	return 1;
+}
+
+int cdx_mcdi_get_func_config(struct cdx_mcdi_t *cdx_mcdi,
+			     uint8_t bus_id, uint8_t func_id,
+			     struct cdx_dev_params_t *dev_params)
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
+	dev_params->vendor = 0x10ee;
+	dev_params->device = 0x8084;
+	dev_params->bus_id = bus_id;
+	dev_params->func_id = func_id;
+
+	return 0;
+}
diff --git a/drivers/bus/cdx/mcdi_stubs.h b/drivers/bus/cdx/mcdi_stubs.h
new file mode 100644
index 000000000000..7b6f79d48ce9
--- /dev/null
+++ b/drivers/bus/cdx/mcdi_stubs.h
@@ -0,0 +1,76 @@
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
+#include "cdx.h"
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
+ * cdx_mcdi_get_num_funcs - Get the total number of functions on
+ *	a particular bus of the controller.
+ * @cdx_mcdi: pointer to MCDI interface.
+ * @bus_num: Bus number.
+ *
+ * Return total number of functions available on the bus, <0 on failure
+ */
+int cdx_mcdi_get_num_funcs(struct cdx_mcdi_t *cdx_mcdi, int bus_num);
+
+/**
+ * cdx_mcdi_get_func_config - Get configuration for a particular
+ *	bus_id:func_id
+ * @cdx_mcdi: pointer to MCDI interface.
+ * @bus_num: Bus number.
+ * @func_id: Function number.
+ * @dev_params: Pointer to cdx_dev_params_t, this is populated by this
+ *	function with the configuration corresponding to the provided
+ *	bus_id:func_id.
+ *
+ * Return 0 total number of functions available on the bus, <0 on failure
+ */
+int cdx_mcdi_get_func_config(struct cdx_mcdi_t *cdx_mcdi,
+			     uint8_t bus_id, uint8_t func_id,
+			     struct cdx_dev_params_t *dev_params);
+
+#endif /* _MCDI_STUBS_H_ */
diff --git a/include/linux/cdx/cdx_bus.h b/include/linux/cdx/cdx_bus.h
new file mode 100644
index 000000000000..6e870b2c87d9
--- /dev/null
+++ b/include/linux/cdx/cdx_bus.h
@@ -0,0 +1,93 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * CDX bus public interface
+ *
+ * Copyright (C) 2022, Advanced Micro Devices, Inc.
+ *
+ */
+#ifndef _CDX_BUS_H_
+#define _CDX_BUS_H_
+
+#include <linux/mod_devicetable.h>
+#include <linux/device.h>
+
+#define MAX_CDX_DEV_RESOURCES	6
+
+/**
+ * struct cdx_device - CDX device object
+ * @dev: Linux driver model device object
+ * @vendor: Vendor ID for CDX device
+ * @device: Device ID for CDX device
+ * @bus_id: Bus ID for this CDX device
+ * @func_id: Function ID for this device
+ * @res: array of MMIO region entries
+ * @res_count: number of valid MMIO regions
+ * @dma_mask: Default DMA mask
+ * @flags: CDX device flags
+ * @req_id: Requestor ID associated with CDX device
+ * @driver_override: driver name to force a match; do not set directly,
+ *                   because core frees it; use driver_set_override() to
+ *                   set or clear it.
+ */
+struct cdx_device {
+	struct device dev;
+	u16 vendor;
+	u16 device;
+	u8 bus_id;
+	u8 func_id;
+	struct resource res[MAX_CDX_DEV_RESOURCES];
+	u8 res_count;
+	u64 dma_mask;
+	u16 flags;
+	u32 req_id;
+	const char *driver_override;
+};
+
+#define to_cdx_device(_dev) \
+	container_of(_dev, struct cdx_device, dev)
+
+/**
+ * struct cdx_driver - CDX device driver
+ * @driver: Generic device driver
+ * @match_id_table: table of supported device matching Ids
+ * @probe: Function called when a device is added
+ * @remove: Function called when a device is removed
+ * @shutdown: Function called at shutdown time to quiesce the device
+ * @suspend: Function called when a device is stopped
+ * @resume: Function called when a device is resumed
+ * @driver_managed_dma: Device driver doesn't use kernel DMA API for DMA.
+ *		For most device drivers, no need to care about this flag
+ *		as long as all DMAs are handled through the kernel DMA API.
+ *		For some special ones, for example VFIO drivers, they know
+ *		how to manage the DMA themselves and set this flag so that
+ *		the IOMMU layer will allow them to setup and manage their
+ *		own I/O address space.
+ */
+struct cdx_driver {
+	struct device_driver driver;
+	const struct cdx_device_id *match_id_table;
+	int (*probe)(struct cdx_device *dev);
+	int (*remove)(struct cdx_device *dev);
+	void (*shutdown)(struct cdx_device *dev);
+	int (*suspend)(struct cdx_device *dev, pm_message_t state);
+	int (*resume)(struct cdx_device *dev);
+	bool driver_managed_dma;
+};
+
+#define to_cdx_driver(_drv) \
+	container_of(_drv, struct cdx_driver, driver)
+
+/*
+ * Macro to avoid include chaining to get THIS_MODULE
+ */
+#define cdx_driver_register(drv) \
+	__cdx_driver_register(drv, THIS_MODULE)
+
+int __must_check __cdx_driver_register(struct cdx_driver *cdx_driver,
+				       struct module *owner);
+
+void cdx_driver_unregister(struct cdx_driver *driver);
+
+extern struct bus_type cdx_bus_type;
+
+#endif /* _CDX_BUS_H_ */
diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
index 549590e9c644..9b94be83d53e 100644
--- a/include/linux/mod_devicetable.h
+++ b/include/linux/mod_devicetable.h
@@ -911,4 +911,17 @@ struct ishtp_device_id {
 	kernel_ulong_t driver_data;
 };
 
+/**
+ * struct cdx_device_id - CDX device identifier
+ * @vendor: vendor ID
+ * @device: Device ID
+ *
+ * Type of entries in the "device Id" table for CDX devices supported by
+ * a CDX device driver.
+ */
+struct cdx_device_id {
+	__u16 vendor;
+	__u16 device;
+};
+
 #endif /* LINUX_MOD_DEVICETABLE_H */
diff --git a/scripts/mod/devicetable-offsets.c b/scripts/mod/devicetable-offsets.c
index c0d3bcb99138..62dc988df84d 100644
--- a/scripts/mod/devicetable-offsets.c
+++ b/scripts/mod/devicetable-offsets.c
@@ -262,5 +262,9 @@ int main(void)
 	DEVID(ishtp_device_id);
 	DEVID_FIELD(ishtp_device_id, guid);
 
+	DEVID(cdx_device_id);
+	DEVID_FIELD(cdx_device_id, vendor);
+	DEVID_FIELD(cdx_device_id, device);
+
 	return 0;
 }
diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
index 80d973144fde..c36e1f624e39 100644
--- a/scripts/mod/file2alias.c
+++ b/scripts/mod/file2alias.c
@@ -1452,6 +1452,17 @@ static int do_dfl_entry(const char *filename, void *symval, char *alias)
 	return 1;
 }
 
+/* Looks like: cdx:vNdN */
+static int do_cdx_entry(const char *filename, void *symval,
+			   char *alias)
+{
+	DEF_FIELD(symval, cdx_device_id, vendor);
+	DEF_FIELD(symval, cdx_device_id, device);
+
+	sprintf(alias, "cdx:v%08Xd%08Xd", vendor, device);
+	return 1;
+}
+
 /* Does namelen bytes of name exactly match the symbol? */
 static bool sym_is(const char *name, unsigned namelen, const char *symbol)
 {
@@ -1531,6 +1542,7 @@ static const struct devtable devtable[] = {
 	{"ssam", SIZE_ssam_device_id, do_ssam_entry},
 	{"dfl", SIZE_dfl_device_id, do_dfl_entry},
 	{"ishtp", SIZE_ishtp_device_id, do_ishtp_entry},
+	{"cdx", SIZE_cdx_device_id, do_cdx_entry},
 };
 
 /* Create MODULE_ALIAS() statements.
-- 
2.25.1

