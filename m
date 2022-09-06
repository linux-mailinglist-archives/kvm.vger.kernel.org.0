Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 631065AEBC2
	for <lists+kvm@lfdr.de>; Tue,  6 Sep 2022 16:27:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241186AbiIFOUV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Sep 2022 10:20:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241952AbiIFOTG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Sep 2022 10:19:06 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on20608.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5a::608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 747C42DA99;
        Tue,  6 Sep 2022 06:50:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DICauO5hqixwXFKSQTKdNMFcXmzgwFB5DxXonw0y26XV5KzWOi6vnNSYos00Xb/GGYeoA5GVk4mXa5DFRRCYoUmE/YdCBcSrbHX/PraTdZpvo5GCV3scmhVfLeGTDA8P/Ajmcqmp1c18tA47qRECGTPfqTA9nAGQRDeuO692vDG3FoAewSEHwAzX0CZxTd5fjYcDwoG6ldkxKHdbGpoQLqhBkj+93sBqI3hTcoBC5mXhsziHRXDj7d0gDJ4WNmoYpQ+f2qqzg3X+kSJJBpGNUAS1ZYtKHPtM9Uji9P38uZCqDs2mhlROCcTmIrmV7VVgEnCyRVLchJHq7d4X4oS1fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aCp0J6mFf0usW5jRRvzPBYB3jYF/nC/WPt5Rmt/qE4I=;
 b=OmPyzFTyrWdQxrBSe0Q69PXO2zHg22i8Rt1L7trE+6kdQ/IFQbIDwmK21CgpDFsDfj4xV1P9jL30SEdmcGwzPchgBaghoWD/rKsX6+B63y2CWvOkIBtyKzLJ98uVNUhewL8u+ZvY47hg4auBZAerSKvgOY+8pRHO4JiO0pbvo343AnVgXRlVeYsbiR0vIpU3Txnu70wE+XzZIyK5R/O8iwq+tuROUqmavFuDrcoEAX1os6RPRgcXRKcTI4TTBgkJNngkCT5U3QWqbG2iU/kx7jXo9IrmJ54wtvNX+MxerjFH9kx0MZcOvr8Y9GLQhvKBxSU9FP0j1aRYCOnhi4yoMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aCp0J6mFf0usW5jRRvzPBYB3jYF/nC/WPt5Rmt/qE4I=;
 b=Sit96zWuBZiqy0vhS7QcBH68wYK4yGh1ddBagnYffPNyZUTD1bColb0M/IZ3+Z2SkKtVY7VsUvbBfNBqP0jIqxmgco4lEj+Yi1TB0BM+FHuvVnoQC7uQTQZEu30SIrSzZc8l5lgy8l7Rgcm/79L24jqovw/M4hNAfXjFOW66X2Y=
Received: from CY8PR22CA0014.namprd22.prod.outlook.com (2603:10b6:930:45::23)
 by SJ0PR12MB7082.namprd12.prod.outlook.com (2603:10b6:a03:4ae::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.11; Tue, 6 Sep
 2022 13:48:54 +0000
Received: from CY4PEPF0000B8EF.namprd05.prod.outlook.com (2603:10b6:930:45::4)
 by CY8PR22CA0014.outlook.office365.com (2603:10b6:930:45::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5612.12 via Frontend Transport; Tue, 6 Sep 2022 13:48:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CY4PEPF0000B8EF.mail.protection.outlook.com (10.167.241.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5612.9 via Frontend Transport; Tue, 6 Sep 2022 13:48:54 +0000
Received: from SATLEXMB06.amd.com (10.181.40.147) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Tue, 6 Sep
 2022 08:48:53 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB06.amd.com
 (10.181.40.147) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Tue, 6 Sep
 2022 08:48:52 -0500
Received: from xhdipdslab49.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2375.28 via Frontend
 Transport; Tue, 6 Sep 2022 08:48:43 -0500
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
Subject: [RFC PATCH v3 4/7] bus/cdx: add cdx-MSI domain with gic-its domain as parent
Date:   Tue, 6 Sep 2022 19:17:58 +0530
Message-ID: <20220906134801.4079497-5-nipun.gupta@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220906134801.4079497-1-nipun.gupta@amd.com>
References: <20220803122655.100254-1-nipun.gupta@amd.com>
 <20220906134801.4079497-1-nipun.gupta@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000B8EF:EE_|SJ0PR12MB7082:EE_
X-MS-Office365-Filtering-Correlation-Id: 224e707c-e629-46e6-c8a8-08da900e89c2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6Bqco0WgZCmwCPkWZlZZSKX/xxpdS0VtHkrEye1n0O9PlKi+42ECHyv0kK4iAYDmGleQgaPZVuugBzfjevyhKZGdaiK/SlY2TcZlHWoA026BGrBqHtX6wkZtziTMXtomR/NpCummpTQ/yYrawtcY1IhlBgB1Ny3/7O05hmpUodH/WJpRUhFVMWptYZB3DQcUF1kqFet5VRsK5AuOdq7i+0vZzhS/TNT3wz9snNOeX6Ob9NSyDOoTDQYJv1dGTm2Xd2SuOYZulf4NOx9+cdHWJEw2+gTVyjgB5+k4YchRnksZJQdwdbYd2hk/Yy1/74WkkyLWDjS2b2sSnSiRWU0q628X6CCXPQM5jI81WZqryov8z29BhbpDfk/7rdIcHEDwMCIhKFq3PbSmCYl5b13vH7D87HYyKkuy4kVS9mWLcNBcNI+bfKcRgkj5meJBhEMRwnqPf+/hDYvUo6R4XL1zvHK/b7wnu0PEIO8Fbbjm/rtmecj4vFAFWD6QPAcm7jXe72v1m7LUP3ynyb+N6fxcNgGeiG0UfHzxiME8ImStA4emtjb4QD4siBTRb/UDlWA4uXMbkvwQYw7EsCye8gQ2ET4sr9MTWVWAhADCBdCfwqeUsLg7yphcRCHYoJ7yCKHOlVbFlnTp6XZItjYyFwYMlyXz5V3RmtvtO45fAVHVvaoKL+7mc8SVnzD8n6eViSAd2GDMMq1fumAAgh6+IuENj8+KmYhfQjjtV9R93v/v5Dw9vCBcJPRL1pPJpdYx0j9lr46qL7kMfvWxmv1+KRCEC3F5SXbN7RUGMPz7C5aIby3tJoNvL3vOc+5upnqiv0fdyzfSZeQEG1HdMpxEbn39wmeKnyTF7uXtaThYGbMdU4JK/4cYE/jpbMHX03X3xVLt
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(346002)(396003)(136003)(39860400002)(376002)(40470700004)(46966006)(36840700001)(921005)(83380400001)(356005)(81166007)(36756003)(1076003)(426003)(86362001)(47076005)(6666004)(41300700001)(336012)(26005)(186003)(2616005)(40460700003)(40480700001)(54906003)(82310400005)(4326008)(110136005)(316002)(70206006)(8676002)(8936002)(478600001)(2906002)(70586007)(36860700001)(30864003)(82740400003)(5660300002)(7416002)(44832011)(2101003)(83996005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2022 13:48:54.0282
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 224e707c-e629-46e6-c8a8-08da900e89c2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000B8EF.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB7082
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Devices on cdx bus are dynamically detected and registered using
platform_device_register API. As these devices are not linked to
of node they need a separate MSI domain for handling device ID
to be provided to the GIC ITS domain.

This also introduces APIs to alloc and free IRQs for CDX domain.

Signed-off-by: Nipun Gupta <nipun.gupta@amd.com>
Signed-off-by: Nikhil Agarwal <nikhil.agarwal@amd.com>
---
 drivers/bus/cdx/cdx.c        |  18 +++
 drivers/bus/cdx/cdx.h        |  19 +++
 drivers/bus/cdx/cdx_msi.c    | 236 +++++++++++++++++++++++++++++++++++
 drivers/bus/cdx/mcdi_stubs.c |   1 +
 include/linux/cdx/cdx_bus.h  |  19 +++
 5 files changed, 293 insertions(+)
 create mode 100644 drivers/bus/cdx/cdx_msi.c

diff --git a/drivers/bus/cdx/cdx.c b/drivers/bus/cdx/cdx.c
index fc417c32c59b..02ececce1c84 100644
--- a/drivers/bus/cdx/cdx.c
+++ b/drivers/bus/cdx/cdx.c
@@ -17,6 +17,7 @@
 #include <linux/dma-map-ops.h>
 #include <linux/property.h>
 #include <linux/iommu.h>
+#include <linux/msi.h>
 #include <linux/cdx/cdx_bus.h>
 
 #include "cdx.h"
@@ -236,6 +237,7 @@ static int cdx_device_add(struct device *parent,
 			  struct cdx_dev_params_t *dev_params)
 {
 	struct cdx_device *cdx_dev;
+	struct irq_domain *cdx_msi_domain;
 	int ret;
 
 	cdx_dev = kzalloc(sizeof(*cdx_dev), GFP_KERNEL);
@@ -252,6 +254,7 @@ static int cdx_device_add(struct device *parent,
 
 	/* Populate CDX dev params */
 	cdx_dev->req_id = dev_params->req_id;
+	cdx_dev->num_msi = dev_params->num_msi;
 	cdx_dev->vendor = dev_params->vendor;
 	cdx_dev->device = dev_params->device;
 	cdx_dev->bus_id = dev_params->bus_id;
@@ -269,6 +272,21 @@ static int cdx_device_add(struct device *parent,
 	dev_set_name(&cdx_dev->dev, "cdx-%02x:%02x", cdx_dev->bus_id,
 			cdx_dev->func_id);
 
+	/* If CDX MSI domain is not created, create one. */
+	cdx_msi_domain = cdx_find_msi_domain(parent);
+	if (!cdx_msi_domain) {
+		cdx_msi_domain = cdx_msi_domain_init(parent);
+		if (!cdx_msi_domain) {
+			dev_err(&cdx_dev->dev,
+				"cdx_msi_domain_init() failed: %d", ret);
+			kfree(cdx_dev);
+			return -1;
+		}
+	}
+
+	/* Set the MSI domain */
+	dev_set_msi_domain(&cdx_dev->dev, cdx_msi_domain);
+
 	ret = device_add(&cdx_dev->dev);
 	if (ret != 0) {
 		dev_err(&cdx_dev->dev,
diff --git a/drivers/bus/cdx/cdx.h b/drivers/bus/cdx/cdx.h
index db0569431c10..95df440ebd73 100644
--- a/drivers/bus/cdx/cdx.h
+++ b/drivers/bus/cdx/cdx.h
@@ -20,6 +20,7 @@
  * @res: array of MMIO region entries
  * @res_count: number of valid MMIO regions
  * @req_id: Requestor ID associated with CDX device
+ * @num_msi: Number of MSI's supported by the device
  */
 struct cdx_dev_params_t {
 	u16 vendor;
@@ -29,6 +30,24 @@ struct cdx_dev_params_t {
 	struct resource res[MAX_CDX_DEV_RESOURCES];
 	u8 res_count;
 	u32 req_id;
+	u32 num_msi;
 };
 
+/**
+ * cdx_msi_domain_init - Init the CDX bus MSI domain.
+ * @dev: Device of the CDX bus controller
+ *
+ * Return CDX MSI domain, NULL on failure
+ */
+struct irq_domain *cdx_msi_domain_init(struct device *dev);
+
+/**
+ * cdx_find_msi_domain - Get the CDX-MSI domain.
+ * @dev: CDX controller generic device
+ *
+ * Return CDX MSI domain, NULL on error or if CDX-MSI domain is
+ *   not yet created.
+ */
+struct irq_domain *cdx_find_msi_domain(struct device *parent);
+
 #endif /* _CDX_H_ */
diff --git a/drivers/bus/cdx/cdx_msi.c b/drivers/bus/cdx/cdx_msi.c
new file mode 100644
index 000000000000..2fb7bac18393
--- /dev/null
+++ b/drivers/bus/cdx/cdx_msi.c
@@ -0,0 +1,236 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * AMD CDX bus driver MSI support
+ *
+ * Copyright (C) 2022, Advanced Micro Devices, Inc.
+ *
+ */
+
+#include <linux/of.h>
+#include <linux/of_device.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
+#include <linux/irq.h>
+#include <linux/irqdomain.h>
+#include <linux/msi.h>
+#include <linux/cdx/cdx_bus.h>
+
+#include "cdx.h"
+
+#ifdef GENERIC_MSI_DOMAIN_OPS
+/*
+ * Generate a unique ID identifying the interrupt (only used within the MSI
+ * irqdomain.  Combine the req_id with the interrupt index.
+ */
+static irq_hw_number_t cdx_domain_calc_hwirq(struct cdx_device *dev,
+					     struct msi_desc *desc)
+{
+	/*
+	 * Make the base hwirq value for req_id*10000 so it is readable
+	 * as a decimal value in /proc/interrupts.
+	 */
+	return (irq_hw_number_t)(desc->msi_index + (dev->req_id * 10000));
+}
+
+static void cdx_msi_set_desc(msi_alloc_info_t *arg,
+			     struct msi_desc *desc)
+{
+	arg->desc = desc;
+	arg->hwirq = cdx_domain_calc_hwirq(to_cdx_device(desc->dev), desc);
+}
+#else
+#define cdx_msi_set_desc NULL
+#endif
+
+static void cdx_msi_update_dom_ops(struct msi_domain_info *info)
+{
+	struct msi_domain_ops *ops = info->ops;
+
+	if (!ops)
+		return;
+
+	/* set_desc should not be set by the caller */
+	if (!ops->set_desc)
+		ops->set_desc = cdx_msi_set_desc;
+}
+
+static void cdx_msi_write_msg(struct irq_data *irq_data,
+			      struct msi_msg *msg)
+{
+	/*
+	 * Do nothing as CDX devices have these pre-populated
+	 * in the hardware itself.
+	 */
+}
+
+static void cdx_msi_update_chip_ops(struct msi_domain_info *info)
+{
+	struct irq_chip *chip = info->chip;
+
+	if (!chip)
+		return;
+
+	/*
+	 * irq_write_msi_msg should not be set by the caller
+	 */
+	if (!chip->irq_write_msi_msg)
+		chip->irq_write_msi_msg = cdx_msi_write_msg;
+}
+/**
+ * cdx_msi_create_irq_domain - Create a CDX MSI interrupt domain
+ * @fwnode:	Optional firmware node of the interrupt controller
+ * @info:	MSI domain info
+ * @parent:	Parent irq domain
+ *
+ * Updates the domain and chip ops and creates a CDX MSI
+ * interrupt domain.
+ *
+ * Returns:
+ * A domain pointer or NULL in case of failure.
+ */
+static struct irq_domain *cdx_msi_create_irq_domain(struct fwnode_handle *fwnode,
+						    struct msi_domain_info *info,
+						    struct irq_domain *parent)
+{
+	if (WARN_ON((info->flags & MSI_FLAG_LEVEL_CAPABLE)))
+		info->flags &= ~MSI_FLAG_LEVEL_CAPABLE;
+	if (info->flags & MSI_FLAG_USE_DEF_DOM_OPS)
+		cdx_msi_update_dom_ops(info);
+	if (info->flags & MSI_FLAG_USE_DEF_CHIP_OPS)
+		cdx_msi_update_chip_ops(info);
+	info->flags |= MSI_FLAG_ALLOC_SIMPLE_MSI_DESCS | MSI_FLAG_FREE_MSI_DESCS;
+
+	return msi_create_irq_domain(fwnode, info, parent);
+}
+
+int cdx_msi_domain_alloc_irqs(struct device *dev, unsigned int irq_count)
+{
+	struct irq_domain *msi_domain;
+	int ret;
+
+	msi_domain = dev_get_msi_domain(dev);
+	if (!msi_domain) {
+		dev_err(dev, "msi domain get failed\n");
+		return -EINVAL;
+	}
+
+	ret = msi_setup_device_data(dev);
+	if (ret) {
+		dev_err(dev, "msi setup device failed: %d\n", ret);
+		return ret;
+	}
+
+	msi_lock_descs(dev);
+	if (msi_first_desc(dev, MSI_DESC_ALL))
+		ret = -EINVAL;
+	msi_unlock_descs(dev);
+	if (ret) {
+		dev_err(dev, "msi setup device failed: %d\n", ret);
+		return ret;
+	}
+
+	ret = msi_domain_alloc_irqs(msi_domain, dev, irq_count);
+	if (ret)
+		dev_err(dev, "Failed to allocate IRQs\n");
+
+	return ret;
+}
+EXPORT_SYMBOL(cdx_msi_domain_alloc_irqs);
+
+void cdx_msi_domain_free_irqs(struct device *dev)
+{
+	struct irq_domain *msi_domain;
+
+	msi_domain = dev_get_msi_domain(dev);
+	if (!msi_domain)
+		return;
+
+	msi_domain_free_irqs(msi_domain, dev);
+}
+EXPORT_SYMBOL(cdx_msi_domain_free_irqs);
+
+static struct irq_chip cdx_msi_irq_chip = {
+	.name = "CDX-MSI",
+	.irq_mask = irq_chip_mask_parent,
+	.irq_unmask = irq_chip_unmask_parent,
+	.irq_eoi = irq_chip_eoi_parent,
+	.irq_set_affinity = msi_domain_set_affinity
+};
+
+static int cdx_msi_prepare(struct irq_domain *msi_domain,
+			   struct device *dev,
+			   int nvec, msi_alloc_info_t *info)
+{
+	struct cdx_device *cdx_dev = to_cdx_device(dev);
+	struct msi_domain_info *msi_info;
+	struct device *parent = dev->parent;
+	u32 dev_id;
+	int ret;
+
+	/* Retrieve device ID from requestor ID using parent device */
+	ret = of_map_id(parent->of_node, cdx_dev->req_id, "msi-map",
+			"msi-map-mask",	NULL, &dev_id);
+	if (ret) {
+		dev_err(dev, "of_map_id failed for MSI: %d\n", ret);
+		return ret;
+	}
+
+	/* Set the device Id to be passed to the GIC-ITS */
+	info->scratchpad[0].ul = dev_id;
+
+	msi_info = msi_get_domain_info(msi_domain->parent);
+
+	/* Allocate at least 32 MSIs, and always as a power of 2 */
+	nvec = max_t(int, 32, roundup_pow_of_two(nvec));
+	return msi_info->ops->msi_prepare(msi_domain->parent, dev, nvec, info);
+}
+
+static struct msi_domain_ops cdx_msi_ops __ro_after_init = {
+	.msi_prepare = cdx_msi_prepare,
+};
+
+static struct msi_domain_info cdx_msi_domain_info = {
+	.flags	= (MSI_FLAG_USE_DEF_DOM_OPS | MSI_FLAG_USE_DEF_CHIP_OPS),
+	.ops	= &cdx_msi_ops,
+	.chip	= &cdx_msi_irq_chip,
+};
+
+struct irq_domain *cdx_msi_domain_init(struct device *dev)
+{
+	struct irq_domain *parent;
+	struct irq_domain *cdx_msi_domain;
+	struct fwnode_handle *fwnode_handle;
+	struct device_node *parent_node;
+	struct device_node *np = dev->of_node;
+
+	fwnode_handle = of_node_to_fwnode(np);
+
+	parent_node = of_parse_phandle(np, "msi-map", 1);
+	if (!parent_node) {
+		dev_err(dev, "msi-map not present on cdx controller\n");
+		return NULL;
+	}
+
+	parent = irq_find_matching_fwnode(of_node_to_fwnode(parent_node),
+			DOMAIN_BUS_NEXUS);
+	if (!parent || !msi_get_domain_info(parent)) {
+		dev_err(dev, "unable to locate ITS domain\n");
+		return NULL;
+	}
+
+	cdx_msi_domain = cdx_msi_create_irq_domain(fwnode_handle,
+				&cdx_msi_domain_info, parent);
+	if (!cdx_msi_domain) {
+		dev_err(dev, "unable to create CDX-MSI domain\n");
+		return NULL;
+	}
+
+	dev_dbg(dev, "CDX-MSI domain created\n");
+
+	return cdx_msi_domain;
+}
+
+struct irq_domain *cdx_find_msi_domain(struct device *parent)
+{
+	return irq_find_host(parent->of_node);
+}
diff --git a/drivers/bus/cdx/mcdi_stubs.c b/drivers/bus/cdx/mcdi_stubs.c
index cc9d30fa02f8..2c8db1f5a057 100644
--- a/drivers/bus/cdx/mcdi_stubs.c
+++ b/drivers/bus/cdx/mcdi_stubs.c
@@ -45,6 +45,7 @@ int cdx_mcdi_get_func_config(struct cdx_mcdi_t *cdx_mcdi,
 	dev_params->res_count = 2;
 
 	dev_params->req_id = 0x250;
+	dev_params->num_msi = 4;
 	dev_params->vendor = 0x10ee;
 	dev_params->device = 0x8084;
 	dev_params->bus_id = bus_id;
diff --git a/include/linux/cdx/cdx_bus.h b/include/linux/cdx/cdx_bus.h
index 6e870b2c87d9..bf86024783d2 100644
--- a/include/linux/cdx/cdx_bus.h
+++ b/include/linux/cdx/cdx_bus.h
@@ -25,6 +25,7 @@
  * @dma_mask: Default DMA mask
  * @flags: CDX device flags
  * @req_id: Requestor ID associated with CDX device
+ * @num_msi: Number of MSI's supported by the device
  * @driver_override: driver name to force a match; do not set directly,
  *                   because core frees it; use driver_set_override() to
  *                   set or clear it.
@@ -40,6 +41,7 @@ struct cdx_device {
 	u64 dma_mask;
 	u16 flags;
 	u32 req_id;
+	u32 num_msi;
 	const char *driver_override;
 };
 
@@ -90,4 +92,21 @@ void cdx_driver_unregister(struct cdx_driver *driver);
 
 extern struct bus_type cdx_bus_type;
 
+/**
+ * cdx_msi_domain_alloc_irqs - Allocate MSI's for the CDX device
+ * @dev: device pointer
+ * @irq_count: Number of MSI's to be allocated
+ *
+ * Return 0 for success, -errno on failure
+ */
+int cdx_msi_domain_alloc_irqs(struct device *dev, unsigned int irq_count);
+
+/**
+ * cdx_msi_domain_free_irqs - Free MSI's for CDX device
+ * @dev: device pointer
+ *
+ * Return 0 for success, -errno on failure
+ */
+void cdx_msi_domain_free_irqs(struct device *dev);
+
 #endif /* _CDX_BUS_H_ */
-- 
2.25.1

