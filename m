Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D555B597294
	for <lists+kvm@lfdr.de>; Wed, 17 Aug 2022 17:13:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240794AbiHQPGa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Aug 2022 11:06:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240720AbiHQPGY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Aug 2022 11:06:24 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2058.outbound.protection.outlook.com [40.107.93.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 414D8642F6;
        Wed, 17 Aug 2022 08:06:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dF2tNo3LY+2JOAks8CPstI63g0W5370Nr7nm2NCoAbww7bXXYK+oRpgDOy/DBkuRaej/mmjwdyNamZI5+gUrEKmDWe8NOUjkjxKYnXhllNQmFGkxdhdPTcZF13OmW8c6HjXUB7WPTdYQEpw9Mq+gf9MYOk4x2YSoLGwhwN/5DTp9yatgrBkvxzUui/SbBDn9JW+8PMGhXKXHwXnt8p3CY/9v90MdXNb4hdiUxlIcepb/yzVN5gtU2tlqSvfAwUGkyux+mq3Agj0Wh5atJ+JHffWP/GuRcFuFn1drx9BuZuL2MTXtJN3NGiFKO/X7W2JvcKe/GUyNXsAQ8dvucPJF8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IG0CxkEPtKFzkM779nOmO2wCuzLniQOlqX0it+XLEfI=;
 b=PS/rgaxjBw68gTBjYZvzq/VJ1oB0nW0bzgGb2m2Rvz2i0jPwAc76EtyZy2ndrtWb67Y3bI9Ta8TvZ4g0Vt9Zf8TyrGrEGu7yCOmFWiSb97wmIime/PbVegarnR7SKJNTca+SUr1GOyHm0XZ892HZvbpeWXTKw8xc3HtjlJBi8Of4drlETSCGlkHA3euYIMcfdMCN3NeshPZMHRQ6jEU/uaJDo/bmiDfKpMNVQYd0WMD/6SLcBuX+WEOXNj1TS8EK8dugu9nVzxQfIMIEUlnD4v40AyqFqDfHdfP+GY1ijPLCSoSkombdM/Ms1gLa7bSZ9N19iMhIxQ5nQS6E0CJFyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IG0CxkEPtKFzkM779nOmO2wCuzLniQOlqX0it+XLEfI=;
 b=kgOptAwgv/+T7bpS2dX6is3NYpVW/dP+SOK7isTyHRFEWOz216WoVZroWcGvv7tiTR37QVbDKYQ7cjtaeA5Cj/rYYf34FLXr8yZRDiTV7158wfjE5C9tFa0ZXCPQvdKxqIBCAXNggmgb1OYVU06CREtB/ww7AQoQaTdKJo/5Vc4=
Received: from MW4PR04CA0230.namprd04.prod.outlook.com (2603:10b6:303:87::25)
 by PH7PR12MB6859.namprd12.prod.outlook.com (2603:10b6:510:1b5::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.11; Wed, 17 Aug
 2022 15:06:09 +0000
Received: from CO1NAM11FT083.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:87:cafe::41) by MW4PR04CA0230.outlook.office365.com
 (2603:10b6:303:87::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.18 via Frontend
 Transport; Wed, 17 Aug 2022 15:06:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CO1NAM11FT083.mail.protection.outlook.com (10.13.174.92) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5546.7 via Frontend Transport; Wed, 17 Aug 2022 15:06:09 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Wed, 17 Aug
 2022 10:06:07 -0500
Received: from xhdipdslab49.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2375.28 via Frontend
 Transport; Wed, 17 Aug 2022 10:06:00 -0500
From:   Nipun Gupta <nipun.gupta@amd.com>
To:     <robh+dt@kernel.org>, <krzysztof.kozlowski+dt@linaro.org>,
        <gregkh@linuxfoundation.org>, <rafael@kernel.org>,
        <eric.auger@redhat.com>, <alex.williamson@redhat.com>,
        <cohuck@redhat.com>, <puneet.gupta@amd.com>,
        <song.bao.hua@hisilicon.com>, <mchehab+huawei@kernel.org>,
        <maz@kernel.org>, <f.fainelli@gmail.com>,
        <jeffrey.l.hugo@gmail.com>, <saravanak@google.com>,
        <Michael.Srba@seznam.cz>, <mani@kernel.org>, <yishaih@nvidia.com>,
        <jgg@ziepe.ca>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <okaya@kernel.org>, <harpreet.anand@amd.com>,
        <nikhil.agarwal@amd.com>, <michal.simek@amd.com>, <git@amd.com>,
        Nipun Gupta <nipun.gupta@amd.com>
Subject: [RFC PATCH v2 2/6] bus/cdx: add the cdx bus driver
Date:   Wed, 17 Aug 2022 20:35:38 +0530
Message-ID: <20220817150542.483291-3-nipun.gupta@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220817150542.483291-1-nipun.gupta@amd.com>
References: <20220803122655.100254-1-nipun.gupta@amd.com>
 <20220817150542.483291-1-nipun.gupta@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 74002ad6-3c20-49dc-a8e3-08da8062043f
X-MS-TrafficTypeDiagnostic: PH7PR12MB6859:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 20qPYbDfgdCpIo3sg0XSp7rN0BXA9TpGUmliRgP/S2nWMNhVCDKuThMApOnefvMKlZ5RPHIpULuBt3mh9hQczbQ342nvPD3Bv+rGI4vPhlM2oBcgRtkjL1MQ2hgtLScp3b6ZlXN+t05Xb4pjGXXUCYzwzdgiByV3rjnLd49t4W/KCuUIyXxn08jBlkpYuuPFCVwvmTX+B7yuMDOjMQc+38n01I+zE/v3/UNu2yImC0LEdnV4iuE3oIEEi9BWdyrikyy+LSh9u4UPLqAqHwARTpwVW5qPpQcaPOMFSpaECvs/8kVRC58iH8qEyfWcvW6pfwmDy3t54InRX11ft4sEWgLIq7n0V52R5h20bQ5zY0yoCvtutcpdWkkFXJsaIazxqPcahSHoTmrj+OQw62byYuSAJ34dn795AneXbnkLQDTtOhI1yZnHK0SDYXaRFDtvuuWSVpBMy8WoaGHqAThxYp88BvN73fb1Hin0NZPKgeuRDvkHdZxXUXRAUQzQtUv3zrd8Vd9PgMUzWZwu2shW9lN2CNdm9Rw6zuL7VN76CZvJOUyJJlAW5WZTuzitkFBViAzFJjJTLGS39gf88yeyggpZWVuROP6R9LFTM4rDCT7lajlxv285ya5iSkOSNAKixxQJkz+6JwxQLqt3yhchU2ibdlP4y6vnZX6PrbvXhjf+hmyQqRxssixYksFnV+FYrHCDvzf22Dwj1sfUmDmBVFm9Q5mUZZxms7rr/s8GR/XqCHhGusqGrlAvOufUnDn1mn/gdh4QtLJau9O5Xnjr3DkMRFOtDuAjCyb5IbhTavIfleFU8jNeNdGVHKNYQYQaKDslTAxu37PaO7WyA9/wM6uECa0lsJtasLLHAHU8peyQs1GdoW1YbJHHG7vXVMbN7Ag2RGZPwWn8/QPYr8y37A==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(376002)(346002)(136003)(396003)(46966006)(40470700004)(36840700001)(30864003)(47076005)(83380400001)(336012)(1076003)(426003)(921005)(81166007)(82740400003)(356005)(70586007)(70206006)(316002)(5660300002)(186003)(8676002)(44832011)(82310400005)(2616005)(6666004)(2906002)(4326008)(26005)(54906003)(110136005)(478600001)(36756003)(36860700001)(7416002)(41300700001)(40480700001)(86362001)(8936002)(40460700003)(36900700001)(2101003)(83996005);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2022 15:06:09.0902
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 74002ad6-3c20-49dc-a8e3-08da8062043f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT083.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6859
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CDX bus driver manages the scanning and populating FPGA
based devices present on the CDX bus.

The bus driver sets up the basic infrastructure and fetches
the device related information from the firmware. These
devices are registered as platform devices.

CDX bus is capable of scanning devices dynamically,
supporting rescanning of dynamically added, removed or
updated devices.

Signed-off-by: Nipun Gupta <nipun.gupta@amd.com>
---

Please NOTE: This is a RFC change which does not yet support
the CDX bus firmware interface as it is under development, and
this series aims to get an early feedback from the community.
There are TODO items mentioned in this patch which needs to
be updated once firmware support is complete.

 MAINTAINERS                 |   1 +
 drivers/bus/Kconfig         |   1 +
 drivers/bus/Makefile        |   3 +
 drivers/bus/cdx/Kconfig     |   7 ++
 drivers/bus/cdx/Makefile    |   3 +
 drivers/bus/cdx/cdx.c       | 241 ++++++++++++++++++++++++++++++++++++
 drivers/bus/cdx/cdx.h       |  35 ++++++
 include/linux/cdx/cdx_bus.h |  26 ++++
 8 files changed, 317 insertions(+)
 create mode 100644 drivers/bus/cdx/Kconfig
 create mode 100644 drivers/bus/cdx/Makefile
 create mode 100644 drivers/bus/cdx/cdx.c
 create mode 100644 drivers/bus/cdx/cdx.h
 create mode 100644 include/linux/cdx/cdx_bus.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 32c5be3d6a53..b0eea32dbb39 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -22301,6 +22301,7 @@ M:	Nipun Gupta <nipun.gupta@amd.com>
 M:	Nikhil Agarwal <nikhil.agarwal@amd.com>
 S:	Maintained
 F:	Documentation/devicetree/bindings/bus/xlnx,cdx.yaml
+F:	drivers/bus/cdx/*
 
 XILINX GPIO DRIVER
 M:	Shubhrajyoti Datta <shubhrajyoti.datta@xilinx.com>
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
index 000000000000..ae3f2ee5a768
--- /dev/null
+++ b/drivers/bus/cdx/Kconfig
@@ -0,0 +1,7 @@
+config CDX_BUS
+	bool "CDX Bus platform driver"
+	help
+		Driver to enable CDX Bus infrastructure. CDX bus is
+		capable of scanning devices dynamically, supporting
+		rescanning of dynamically added, removed or updated
+		devices.
diff --git a/drivers/bus/cdx/Makefile b/drivers/bus/cdx/Makefile
new file mode 100644
index 000000000000..c9cee5b6fa8a
--- /dev/null
+++ b/drivers/bus/cdx/Makefile
@@ -0,0 +1,3 @@
+obj-$(CONFIG_CDX_BUS) += cdx-bus-device-driver.o
+
+cdx-bus-device-driver-objs := cdx.o
diff --git a/drivers/bus/cdx/cdx.c b/drivers/bus/cdx/cdx.c
new file mode 100644
index 000000000000..f28329770af8
--- /dev/null
+++ b/drivers/bus/cdx/cdx.c
@@ -0,0 +1,241 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Platform driver for CDX bus.
+ *
+ * Copyright(C) 2022 Xilinx Inc.
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
+#include <linux/property.h>
+#include <linux/cdx/cdx_bus.h>
+
+#include "cdx.h"
+
+static struct cdx_device_types_t dev_types[MAX_CDX_DEVICE_TYPES] = {
+	{"cdx-cdma-1.0", "xlnx,cdx-cdma-1.0"}
+};
+
+static int cdx_populate_one(struct platform_device *pdev_parent,
+			    struct cdx_dev_params_t *dev_params)
+{
+	struct platform_device *new_pdev;
+	struct fwnode_handle *swnode;
+	struct platform_device_info pdevinfo;
+	struct cdx_device_data dev_data;
+	int ret = 0;
+	struct property_entry port_props[] = {
+		PROPERTY_ENTRY_STRING("compatible",
+			dev_types[dev_params->dev_type_idx].compat),
+		{ }
+	};
+
+	swnode = fwnode_create_software_node(port_props, NULL);
+	if (IS_ERR(swnode)) {
+		ret = PTR_ERR(swnode);
+		dev_err(&pdev_parent->dev,
+			"fwnode_create_software_node() failed: %d\n", ret);
+		goto out;
+	}
+
+	dev_data.bus_id = dev_params->bus_id;
+	dev_data.func_id = dev_params->func_id;
+
+	memset(&pdevinfo, 0, sizeof(pdevinfo));
+	pdevinfo.fwnode = swnode;
+	pdevinfo.parent = &pdev_parent->dev;
+	pdevinfo.name = dev_params->name;
+	pdevinfo.id = (dev_params->bus_id << 16) | (dev_params->func_id);
+	pdevinfo.res = dev_params->res;
+	pdevinfo.num_res = dev_params->res_cnt;
+	pdevinfo.data = &dev_data;
+	pdevinfo.size_data = sizeof(struct cdx_device_data);
+	pdevinfo.dma_mask = DMA_BIT_MASK(64);
+	new_pdev = platform_device_register_full(&pdevinfo);
+	if (IS_ERR(new_pdev)) {
+		ret = PTR_ERR(new_pdev);
+		dev_err(&pdev_parent->dev,
+			"platform_device_register_full() failed: %d\n", ret);
+		goto out;
+	}
+
+	/* Configure the IOMMU */
+	ret = of_dma_configure_id(&new_pdev->dev, pdev_parent->dev.of_node,
+			1, &dev_params->stream_id);
+	if (ret) {
+		if (ret != -EPROBE_DEFER)
+			dev_err(&pdev_parent->dev,
+				"of_dma_configure_id() failed: %d\n", ret);
+		goto out;
+	}
+
+	return 0;
+
+out:
+	if (new_pdev != NULL && !IS_ERR(new_pdev))
+		platform_device_unregister(new_pdev);
+
+	if (swnode != NULL && IS_ERR(swnode))
+		fwnode_remove_software_node(swnode);
+
+	return ret;
+}
+
+static int cdx_unregister_device(struct device *dev,
+		void * __always_unused data)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+
+	platform_device_unregister(pdev);
+	fwnode_remove_software_node(pdev->dev.fwnode);
+
+	return 0;
+}
+
+void cdx_unregister_devices(struct device *parent_dev)
+{
+	device_for_each_child(parent_dev, NULL, cdx_unregister_device);
+}
+
+static int cdx_bus_device_discovery(struct platform_device *pdev)
+{
+	int num_cdx_bus = 0, num_cdx_func = 0;
+	int bus_id = 0, func_id = 0;
+	struct device_node *np = pdev->dev.of_node;
+	int ret;
+
+	/* TODO: Get number of busses from firmware */
+	num_cdx_bus = 1;
+
+	for (bus_id = 0; bus_id < num_cdx_bus; bus_id++) {
+		/* TODO: Get number of functions/devices on the bus
+		 * from firmware
+		 */
+		num_cdx_func = 1;
+
+		for (func_id = 0; func_id < num_cdx_func; func_id++) {
+			struct cdx_dev_params_t dev_params;
+			u64 mmio_size; /* MMIO size */
+			u64 mmio_addr; /* MMIO address */
+			u32 req_id; /* requester ID */
+
+			/* TODO: Read device configuration from the firmware
+			 * and remove the hardcoded configuration parameters.
+			 */
+			mmio_addr = 0xe4020000;
+			mmio_size = 0x1000;
+			req_id = 0x250;
+
+			memset(&dev_params, 0, sizeof(dev_params));
+
+			/* Populate device parameters */
+			ret = of_map_id(np, req_id, "iommu-map", "iommu-map-mask",
+					NULL, &dev_params.stream_id);
+			if (ret != 0) {
+				dev_err(&pdev->dev,
+					"of_map_id failed for IOMMU: %d\n",
+					ret);
+				goto fail;
+			}
+
+			dev_params.dev_type_idx = 0;
+			dev_params.res_cnt = 1;
+
+			/* Populate dev_type_idx */
+			dev_params.dev_type_idx = 0;
+
+			/* Populate resource */
+			dev_params.res->start = (u64)mmio_addr;
+			dev_params.res->end = (u64)(mmio_addr + mmio_size - 1);
+			dev_params.res->flags = IORESOURCE_MEM;
+
+			dev_params.bus_id = bus_id;
+			dev_params.func_id = func_id;
+
+			strncpy(dev_params.name, dev_types[dev_params.dev_type_idx].name,
+				sizeof(dev_params.name));
+
+			ret = cdx_populate_one(pdev, &dev_params);
+			if (ret == -EPROBE_DEFER) {
+				goto fail;
+			} else if (ret) {
+				dev_err(&pdev->dev,
+					"registering cdx dev: %d failed: %d\n",
+					func_id, ret);
+				goto fail;
+			} else {
+				dev_info(&pdev->dev,
+					"CDX dev: %d on cdx bus: %d created\n",
+					func_id, bus_id);
+			}
+		}
+	}
+
+	return 0;
+fail:
+	cdx_unregister_devices(&pdev->dev);
+	return ret;
+}
+
+static int cdx_probe(struct platform_device *pdev)
+{
+	int ret;
+
+	/* TODO: Firmware path initialization */
+
+	ret = cdx_bus_device_discovery(pdev);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+static void cdx_shutdown(struct platform_device *pdev)
+{
+	/* TODO: add shutdown for CDX bus*/
+}
+
+static int cdx_remove(struct platform_device *pdev)
+{
+	/* TODO: add remove of CDX bus */
+	return 0;
+}
+
+static const struct of_device_id cdx_match_table[] = {
+	{.compatible = "xlnx,cdxbus-controller-1.0",},
+	{ },
+};
+
+MODULE_DEVICE_TABLE(of, cdx_match_table);
+
+static struct platform_driver cdx_driver = {
+	.driver = {
+		   .name = "cdx-bus",
+		   .pm = NULL,
+		   .of_match_table = cdx_match_table,
+		   },
+	.probe = cdx_probe,
+	.remove = cdx_remove,
+	.shutdown = cdx_shutdown,
+};
+
+static int __init cdx_driver_init(void)
+{
+	int error;
+
+	error = platform_driver_register(&cdx_driver);
+	if (error < 0) {
+		pr_err("platform_driver_register() failed: %d\n", error);
+		return error;
+	}
+
+	return 0;
+}
+postcore_initcall(cdx_driver_init);
diff --git a/drivers/bus/cdx/cdx.h b/drivers/bus/cdx/cdx.h
new file mode 100644
index 000000000000..7db8b06de9cd
--- /dev/null
+++ b/drivers/bus/cdx/cdx.h
@@ -0,0 +1,35 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Header file for the CDX Bus
+ *
+ * Copyright(c) 2022 Xilinx Inc.
+ */
+
+#ifndef _CDX_H_
+#define _CDX_H_
+
+#define CDX_DEV_NUM_RESOURCES	4
+#define CDX_NAME_LEN	64
+
+struct cdx_dev_params_t {
+	char name[CDX_NAME_LEN];
+	u32 bus_id;
+	u32 func_id;
+	u32 dev_type_idx;
+	struct resource res[CDX_DEV_NUM_RESOURCES];
+	int res_cnt;
+	u32 stream_id;
+};
+
+/**
+ * struct cdx_device_data_t - private data associated with the
+ *	CDX device.
+ * @bus_id: Bus ID for reset
+ * @func_id: Function ID for reset
+ */
+struct cdx_device_data {
+	u32 bus_id;
+	u32 func_id;
+};
+
+#endif /* _CDX_H_ */
diff --git a/include/linux/cdx/cdx_bus.h b/include/linux/cdx/cdx_bus.h
new file mode 100644
index 000000000000..7c6ad7dfe97a
--- /dev/null
+++ b/include/linux/cdx/cdx_bus.h
@@ -0,0 +1,26 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * CDX bus public interface
+ *
+ * Copyright(C) 2022 Xilinx Inc.
+ *
+ */
+#ifndef _CDX_BUS_H_
+#define _CDX_BUS_H_
+
+#define MAX_CDX_DEVICE_TYPES	16
+#define MAX_CDX_COMPAT_LEN	64
+#define MAX_CDX_NAME_LEN	64
+
+/**
+ * struct cdx_device_type_t - info on CDX devices type.
+ * @compatible: Describes the specific binding, to which
+ *	the devices of a particular type complies. It is used
+ *	for driver binding.
+ */
+struct cdx_device_types_t {
+	char name[MAX_CDX_NAME_LEN];
+	char compat[MAX_CDX_COMPAT_LEN];
+};
+
+#endif /* _CDX_H_ */
-- 
2.25.1

