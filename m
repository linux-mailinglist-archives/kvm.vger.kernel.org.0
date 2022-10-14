Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F68D5FE812
	for <lists+kvm@lfdr.de>; Fri, 14 Oct 2022 06:41:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229816AbiJNEls (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Oct 2022 00:41:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229815AbiJNElk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Oct 2022 00:41:40 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2060.outbound.protection.outlook.com [40.107.243.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D98218F90B;
        Thu, 13 Oct 2022 21:41:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LbWZop2/nI+L2n7223sA/BqbsaomppeJXeFk53hMAuc9gQoNhEWQdKLo3/7CqXnvtsVqb5xcD4ZlJZfCs6/BRo9sKs8tGNiX90igBqtb5iWV/yl3/XyGeaU8Thg8NB0iCpvWWf4897rD4fdqGxDD8HgXyS/i8V6DsGHpOH7j5hg3wTx2CxkTr/pfbCgpZdnw6YH09JTWbnH/rHwPXu1tmD3+ZPA7es1VFqIFGmDEEqptP6lMTghA0wwxaD5eui3pSFJY2LzivhTtVKKTAxT4LBnWRrQYfLN4VSeiynRSIr+pZzrKXRle1SJ2ppawogthTQnflWLPx+UNFrCyw9doTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BXNQooQpT2aawbW/eQJdibgyg56ZOYEfA1A1m9MPyLc=;
 b=DWVsSF/tDbLpEjESX8R/Jh3NlyzBW1oJ9vXG2keGh3tMAJpwoVaOosRPiecrVG3MUJpKQHJTKr0/v/3soQJP7ZcmtZmHvCyCadPIPhM4iehVp0qELMgEOF4es8zueqTEE8o6Kv1bzR7739Hki4cjowbM9uH0ZHYmX3FAHUDP+mjLmaV8L5pD9ps/QtOQBcvaC2TTLR2zSRqMXERHd7L8Hn8gTDzgOXCGkdik5+xr2U4xC3Y0ibjq25luvQ11oE6HneOiPxBPrIyFCLypkrV0pwchJNxf6agQym/Uy/C6C0lpMhVzK5wfoBuq0OeDGtXF+q0y3Xv5GFxGGmCQyT1LgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BXNQooQpT2aawbW/eQJdibgyg56ZOYEfA1A1m9MPyLc=;
 b=4sfKckbSJ5F9eXAkLGiCCIocDujCcph5yKP3Ltqq91Src3JPtECkCGqNbJbL2qOugpmybbuZFbvURBAi5vUjhFzFJEBPkPnmss+/M/kdxq4WrB3buJdrVNERjjJopoGh99ahP0he1+myXAus7d/0T7fuE7hcoQ4QGBQtdcvMTiU=
Received: from MWH0EPF00056D10.namprd21.prod.outlook.com
 (2603:10b6:30f:fff2:0:1:0:13) by SJ0PR12MB6806.namprd12.prod.outlook.com
 (2603:10b6:a03:478::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.15; Fri, 14 Oct
 2022 04:41:23 +0000
Received: from CO1NAM11FT038.eop-nam11.prod.protection.outlook.com
 (2a01:111:f400:7eab::209) by MWH0EPF00056D10.outlook.office365.com
 (2603:1036:d20::b) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.6 via Frontend
 Transport; Fri, 14 Oct 2022 04:41:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CO1NAM11FT038.mail.protection.outlook.com (10.13.174.231) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5723.20 via Frontend Transport; Fri, 14 Oct 2022 04:41:23 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Thu, 13 Oct
 2022 23:41:19 -0500
Received: from xhdipdslab49.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2375.28 via Frontend
 Transport; Thu, 13 Oct 2022 23:41:11 -0500
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
Subject: [RFC PATCH v4 2/8] bus/cdx: add the cdx bus driver
Date:   Fri, 14 Oct 2022 10:10:43 +0530
Message-ID: <20221014044049.2557085-3-nipun.gupta@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221014044049.2557085-1-nipun.gupta@amd.com>
References: <20220803122655.100254-1-nipun.gupta@amd.com>
 <20221014044049.2557085-1-nipun.gupta@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT038:EE_|SJ0PR12MB6806:EE_
X-MS-Office365-Filtering-Correlation-Id: 91349c1e-46cc-423c-f719-08daad9e58d2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nEfDjO9OSChj6+V/w2d/xu/wq5/BzcMFKOjmHVVUmqfav8spGh32UVrkkJMEKW8IFQh28LEhAhxrguPjyrYAt4nqx6saxuIgHNzYOE1aWW4QjH7NkqOBtIqBvHjMig3k8kfuK12ljTjrplBfnWqHcLXBrVgPk5Tv+BVBmLy0Qem3tvp91XLWmGzLp3lTS6+hAPoKQWbfF/JETx2dLE6CbkB3OoVCse+297wfJ96PNgiNrt82SL5e6lThLDC02sW5UckYLiTdXSUn5upk1cErhH9semJFhHN8PH/ZA6jA+WAIXcJe4vGD61ZcCprOK91f1rYKaVWkB5O6Z9uq760cSXWfrP8w05PUGJMVc9viymizk4WQjdr/DKQThu9BhWSTjGiWHHWqeGXWFxdNWR93b1Cso9/9LUu6VoW2Q1WcEwEKFdOuV5dDDdZOecWBGO4V0tbveEcYzYazswtc8QqGMxeYqXAft6NgCwnNZkZDtpUjIE2Ve2iU+cLFH8Rh+YN2foy/H7aln3y7zMpMV+wTctArz3K24lj2SdlYN0EHr5Q5ugsLSYMMR2QCgSPdF1l0SLCS6oSEwB2ZUQr0Iq1WR7StZOcMVUTo9nxJsE1TwItyhG4mheKKGdyr2oa4PxzsEd0fIOsgUGcVZuilZP1LVDz0P1MbwhFJP7AoduHF1rJR+ES7qq8a8wmz+m1XzSJK3nulF1a8HqAOb+zciOdwgZeb2t5m0/Xl3uUO6LIegdBWr/zjPJdeKpSiVhrntIrFyNXRCAq/EXFm3gDOZ2bIIqku9pI+ArO9DR34PKvITpjwxCexWBJepfZerWicWDafoaU53KcsQ+Pwr3mfLp27Pptvl5SKenbVrJGegEkD8xh3f5Bz2FmLkZlqEHD2OZFK
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(346002)(396003)(376002)(39860400002)(136003)(451199015)(40470700004)(46966006)(36840700001)(26005)(36860700001)(40460700003)(110136005)(82740400003)(40480700001)(81166007)(54906003)(356005)(336012)(86362001)(4326008)(7416002)(2616005)(44832011)(30864003)(186003)(47076005)(426003)(921005)(8676002)(70206006)(5660300002)(83380400001)(82310400005)(316002)(478600001)(2906002)(1076003)(8936002)(36756003)(6666004)(41300700001)(70586007)(36900700001)(2101003)(83996005);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2022 04:41:23.1286
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 91349c1e-46cc-423c-f719-08daad9e58d2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT038.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6806
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CDX bus supports the scanning and probing of FPGA based
devices. These devices are registered as CDX devices.

The bus driver sets up the basic infrastructure and triggers
the cdx controller to scan the cdx devices once registered.

CDX bus uses ops registered by the CDX controller to scan,
reset and write MSI message on the CDX devices.

Signed-off-by: Nipun Gupta <nipun.gupta@amd.com>
---
 MAINTAINERS                       |   2 +
 drivers/bus/Kconfig               |   1 +
 drivers/bus/Makefile              |   3 +
 drivers/bus/cdx/Kconfig           |  13 ++
 drivers/bus/cdx/Makefile          |   8 +
 drivers/bus/cdx/cdx.c             | 366 ++++++++++++++++++++++++++++++
 drivers/bus/cdx/cdx.h             |  66 ++++++
 include/linux/cdx/cdx_bus.h       | 139 ++++++++++++
 include/linux/mod_devicetable.h   |  13 ++
 scripts/mod/devicetable-offsets.c |   4 +
 scripts/mod/file2alias.c          |  12 +
 11 files changed, 627 insertions(+)
 create mode 100644 drivers/bus/cdx/Kconfig
 create mode 100644 drivers/bus/cdx/Makefile
 create mode 100644 drivers/bus/cdx/cdx.c
 create mode 100644 drivers/bus/cdx/cdx.h
 create mode 100644 include/linux/cdx/cdx_bus.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 5f48f11fe0c3..6b7b3c098839 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -940,6 +940,8 @@ M:	Nipun Gupta <nipun.gupta@amd.com>
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
index 000000000000..98ec05ad708d
--- /dev/null
+++ b/drivers/bus/cdx/Kconfig
@@ -0,0 +1,13 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# CDX bus configuration
+#
+# Copyright (C) 2022, Advanced Micro Devices, Inc.
+#
+
+config CDX_BUS
+	bool "CDX Bus driver"
+	help
+		Driver to enable CDX Bus infrastructure. CDX bus uses
+		CDX controller and firmware to scan the FPGA based
+		devices.
diff --git a/drivers/bus/cdx/Makefile b/drivers/bus/cdx/Makefile
new file mode 100644
index 000000000000..2e8f42611dfc
--- /dev/null
+++ b/drivers/bus/cdx/Makefile
@@ -0,0 +1,8 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# Makefile for CDX
+#
+# Copyright (C) 2022, Advanced Micro Devices, Inc.
+#
+
+obj-$(CONFIG_CDX_BUS) += cdx.o
diff --git a/drivers/bus/cdx/cdx.c b/drivers/bus/cdx/cdx.c
new file mode 100644
index 000000000000..5a366f4ae69c
--- /dev/null
+++ b/drivers/bus/cdx/cdx.c
@@ -0,0 +1,366 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * CDX bus driver.
+ *
+ * Copyright (C) 2022, Advanced Micro Devices, Inc.
+ */
+
+/*
+ * Architecture Overview
+ * =====================
+ * CDX is a Hardware Architecture designed for AMD FPGA devices. It
+ * consists of sophisticated mechanism for interaction between FPGA,
+ * Firmware and the APUs (Application CPUs).
+ *
+ * Firmware resides on RPU (Realtime CPUs) which interacts with
+ * the FPGA program manager and the APUs. The RPU provides memory-mapped
+ * interface (RPU if) which is used to communicate with APUs.
+ *
+ * The diagram below shows an overview of the CDX architecture:
+ *
+ *          +--------------------------------------+
+ *          |    Application CPUs (APU)            |
+ *          |                                      |
+ *          |                    CDX device drivers|
+ *          |     Linux OS                |        |
+ *          |                        CDX bus       |
+ *          |                             |        |
+ *          |                     CDX controller   |
+ *          |                             |        |
+ *          +-----------------------------|--------+
+ *                                        | (discover, config,
+ *                                        |  reset, rescan)
+ *                                        |
+ *          +------------------------| RPU if |----+
+ *          |                             |        |
+ *          |                             V        |
+ *          |          Realtime CPUs (RPU)         |
+ *          |                                      |
+ *          +--------------------------------------+
+ *                                |
+ *          +---------------------|----------------+
+ *          |  FPGA               |                |
+ *          |      +-----------------------+       |
+ *          |      |           |           |       |
+ *          | +-------+    +-------+   +-------+   |
+ *          | | dev 1 |    | dev 2 |   | dev 3 |   |
+ *          | +-------+    +-------+   +-------+   |
+ *          +--------------------------------------+
+ *
+ * The RPU firmware extracts the device information from the loaded FPGA
+ * image and implements a mechanism that allows the APU drivers to
+ * enumerate such devices (device personality and resource details) via
+ * a dedicated communication channel. RPU mediates operations such as
+ * discover, reset and rescan of the FPGA devices for the APU. This is
+ * done using memory mapped interface provided by the RPU to APU.
+ */
+
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/cdx/cdx_bus.h>
+
+#include "cdx.h"
+
+/*
+ * Default DMA mask for devices on a CDX bus
+ */
+#define CDX_DEFAULT_DMA_MASK	(~0ULL)
+
+static struct cdx_controller_t *cdx_controller;
+
+static int reset_cdx_device(struct device *dev, void * __always_unused data)
+{
+	struct cdx_device *cdx_dev = to_cdx_device(dev);
+	struct cdx_controller_t *cdx = cdx_dev->cdx;
+	int ret;
+
+	ret = cdx->ops.reset_dev(cdx, cdx_dev->bus_num, cdx_dev->dev_num);
+	if (ret)
+		dev_err(dev, "cdx device reset failed\n");
+
+	return ret;
+}
+
+int cdx_dev_reset(struct device *dev)
+{
+	return reset_cdx_device(dev, NULL);
+}
+EXPORT_SYMBOL_GPL(cdx_dev_reset);
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
+/**
+ * cdx_match_one_device - Tell if a CDX device structure has a matching
+ *			  CDX device id structure
+ * @id: single CDX device id structure to match
+ * @dev: the CDX device structure to match against
+ *
+ * Returns the matching cdx_device_id structure or NULL if there is no match.
+ */
+static inline const struct cdx_device_id *
+cdx_match_one_device(const struct cdx_device_id *id,
+		     const struct cdx_device *dev)
+{
+	/* Use vendor ID and device ID for matching */
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
+ * NULL if there is no match.
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
+static void cdx_remove(struct device *dev)
+{
+	struct cdx_driver *cdx_drv = to_cdx_driver(dev->driver);
+	struct cdx_device *cdx_dev = to_cdx_device(dev);
+
+	if (cdx_drv->remove)
+		cdx_drv->remove(cdx_dev);
+}
+
+struct bus_type cdx_bus_type = {
+	.name		= "cdx",
+	.match		= cdx_bus_match,
+	.remove		= cdx_remove,
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
+	int ret;
+
+	if (cdx_drv->remove) {
+		ret = cdx_drv->remove(cdx_dev);
+		if (ret < 0) {
+			dev_err(dev, "%s failed: %d\n", __func__, ret);
+			return ret;
+		}
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
+int cdx_device_add(struct cdx_dev_params_t *dev_params)
+{
+	struct cdx_controller_t *cdx = dev_params->cdx;
+	struct device *parent = cdx->dev;
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
+	cdx_dev->bus_num = dev_params->bus_num;
+	cdx_dev->dev_num = dev_params->dev_num;
+	cdx_dev->cdx = dev_params->cdx;
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
+	dev_set_name(&cdx_dev->dev, "cdx-%02x:%02x", cdx_dev->bus_num,
+			cdx_dev->dev_num);
+
+	ret = device_add(&cdx_dev->dev);
+	if (ret != 0) {
+		dev_err(&cdx_dev->dev,
+			"cdx device add failed: %d", ret);
+		goto fail;
+	}
+
+	/* Reset the device before use */
+	ret = cdx->ops.reset_dev(cdx, cdx_dev->bus_num, cdx_dev->dev_num);
+	if (ret) {
+		dev_err(&cdx_dev->dev, "cdx device reset failed\n");
+		goto fail;
+	}
+
+	return 0;
+
+fail:
+	/*
+	 * Do not free cdx_dev here as it would be freed in
+	 * cdx_device_release() called from put_device().
+	 */
+	put_device(&cdx_dev->dev);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(cdx_device_add);
+
+int cdx_register_controller(struct cdx_controller_t *cdx)
+{
+	int ret;
+
+	/* Scan all the devices */
+	ret = cdx->ops.scan(cdx);
+	if (ret) {
+		dev_err(cdx->dev, "CDX scanning failed: %d\n", ret);
+		return ret;
+	}
+
+	cdx_controller = cdx;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(cdx_register_controller);
+
+void cdx_unregister_controller(struct cdx_controller_t *cdx)
+{
+	device_for_each_child(cdx->dev, NULL, cdx_unregister_device);
+	cdx_controller = NULL;
+}
+EXPORT_SYMBOL_GPL(cdx_unregister_controller);
+
+static int __init cdx_bus_init(void)
+{
+	return bus_register(&cdx_bus_type);
+}
+postcore_initcall(cdx_bus_init);
diff --git a/drivers/bus/cdx/cdx.h b/drivers/bus/cdx/cdx.h
new file mode 100644
index 000000000000..80496865ae9c
--- /dev/null
+++ b/drivers/bus/cdx/cdx.h
@@ -0,0 +1,66 @@
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
+
+/**
+ * struct cdx_dev_params_t - CDX device parameters
+ * @cdx: CDX controller assocated with the device
+ * @parent: Associated CDX controller
+ * @vendor: Vendor ID for CDX device
+ * @device: Device ID for CDX device
+ * @subsys_vendor: Sub vendor ID for CDX device
+ * @subsys_device: Sub device ID for CDX device
+ * @bus_num: Bus number for this CDX device
+ * @dev_num: Device number for this device
+ * @res: array of MMIO region entries
+ * @res_count: number of valid MMIO regions
+ * @req_id: Requestor ID associated with CDX device
+ */
+struct cdx_dev_params_t {
+	struct cdx_controller_t *cdx;
+	u16 vendor;
+	u16 device;
+	u16 subsys_vendor;
+	u16 subsys_device;
+	u8 bus_num;
+	u8 dev_num;
+	struct resource res[MAX_CDX_DEV_RESOURCES];
+	u8 res_count;
+	u32 req_id;
+};
+
+/**
+ * cdx_register_controller - Register a CDX controller and its ports
+ *		on the CDX bus.
+ * @cdx: The CDX controller to register
+ *
+ * Returns -errno on failure, 0 on success.
+ */
+int cdx_register_controller(struct cdx_controller_t *cdx);
+
+/**
+ * cdx_unregister_controller - Unregister a CDX controller
+ * @cdx: The CDX controller to unregister
+ */
+void cdx_unregister_controller(struct cdx_controller_t *cdx);
+
+/**
+ * cdx_device_add - Add a CDX device. This function adds a CDX device
+ *		on the CDX bus as per the device paramteres provided
+ *		by caller. It also creates and registers an associated
+ *		Linux generic device.
+ * @dev_params: device parameters associated with the device to be created.
+ *
+ * Returns -errno on failure, 0 on success.
+ */
+int cdx_device_add(struct cdx_dev_params_t *dev_params);
+
+#endif /* _CDX_H_ */
diff --git a/include/linux/cdx/cdx_bus.h b/include/linux/cdx/cdx_bus.h
new file mode 100644
index 000000000000..9e6872a03215
--- /dev/null
+++ b/include/linux/cdx/cdx_bus.h
@@ -0,0 +1,139 @@
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
+#define MAX_CDX_DEV_RESOURCES	4
+
+/* Forward declaration for CDX controller */
+struct cdx_controller_t;
+
+typedef int (*cdx_scan_t)(struct cdx_controller_t *cdx);
+
+typedef int (*cdx_dev_reset_t)(struct cdx_controller_t *cdx,
+			       uint8_t bus_num, uint8_t dev_num);
+
+/**
+ * Callbacks supported by CDX controller.
+ * @scan: scan the devices on the controller
+ * @reset_dev: reset a CDX device
+ */
+struct cdx_ops_t {
+	cdx_scan_t scan;
+	cdx_dev_reset_t reset_dev;
+};
+
+/**
+ * struct cdx_controller: CDX controller object
+ * @dev: Linux device associated with the CDX controller.
+ * @priv: private data
+ * @ops: CDX controller ops
+ */
+struct cdx_controller_t {
+	struct device *dev;
+	void *priv;
+
+	struct cdx_ops_t ops;
+};
+
+/**
+ * struct cdx_device - CDX device object
+ * @dev: Linux driver model device object
+ * @cdx: CDX controller assocated with the device
+ * @vendor: Vendor ID for CDX device
+ * @device: Device ID for CDX device
+ * @bus_num: Bus number for this CDX device
+ * @dev_num: Device number for this device
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
+	struct cdx_controller_t *cdx;
+	u16 vendor;
+	u16 device;
+	u8 bus_num;
+	u8 dev_num;
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
+/* Macro to avoid include chaining to get THIS_MODULE */
+#define cdx_driver_register(drv) \
+	__cdx_driver_register(drv, THIS_MODULE)
+
+/**
+ * __cdx_driver_register - registers a CDX device driver
+ */
+int __must_check __cdx_driver_register(struct cdx_driver *cdx_driver,
+				       struct module *owner);
+
+/**
+ * cdx_driver_unregister - unregisters a device driver from the
+ * CDX bus.
+ */
+void cdx_driver_unregister(struct cdx_driver *driver);
+
+extern struct bus_type cdx_bus_type;
+
+/**
+ * cdx_dev_reset - Reset CDX device
+ * @dev: device pointer
+ *
+ * Return 0 for success, -errno on failure
+ */
+int cdx_dev_reset(struct device *dev);
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

