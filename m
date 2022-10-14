Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7597F5FE827
	for <lists+kvm@lfdr.de>; Fri, 14 Oct 2022 06:43:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbiJNEnm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Oct 2022 00:43:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229886AbiJNEna (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Oct 2022 00:43:30 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2087.outbound.protection.outlook.com [40.107.94.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20FBB1FF8E;
        Thu, 13 Oct 2022 21:43:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iAHj3NAnlfOwImi+jNwB/u1V8lBEs5iTawJArSrj3wmkirFsTrnnZhRP0bEoIvIrR8o+dNCrZ2gIKDIEeCreNmMMHB1mzBU5joPSWa9WbgfVyVlh1HoG/Z/axlHzTGtxQZ/Yp70ZuCfRqCovFHmW8pVMYt+XFVo37A0IvzjiNIELzwcdNVEmeJp9l3KobqxLgD7kAyUdS4NsWFf/YdnvqUKyBv/WIj8/Vie/9qzZilv6Xmqo7InmdyoW7LozDLaL9evZ2pU0YhHWT4XXIf2/kBfiboTTJYHWWaQ1a/v/luj0vHWa2XLo9KcQuDK+9F1Zw5L3SSbVRfNjntiIIW9OVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u3JptsUvS1Ep5IrkL1vqw0fo28X1LbRqDw7CQaH72V8=;
 b=RqyEeh+wIB9jYVFQsne3QG4vwsx/JJ5JP3NlSG4UCnKSyWQMJQOZB5AFEJKgSxsrZaE82t9Z0qFBi4yAuYyNgcI6cEKcyaAtve5WpwdzYER32CAm/EK/Js9OsQjNl0U6iwT6meIy1EJWg5M5DL2Ak73jtZu0EhkovR6hs4e94mOMZSF76LdYqi8T4cJYEDO5vool1u2nkeAY3JuLmdMc3NYeoCGgOED3CaRjN6EnCVyUzQcitKHRThuUy2BKaUi5NfxqewH09XDWRtCD/6DHuTciqD16Q7XtYqMirEU/Pr5IFBXTrM+hz8JyCZwKoKARc7T7DDzXb9EsW993zPSbPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u3JptsUvS1Ep5IrkL1vqw0fo28X1LbRqDw7CQaH72V8=;
 b=jk1GIm+sunoN/4uvdpbuGWoxaeL6uqW9F8/7r75fYWHBz6T5mHKbnwuILJI8XwwLMTE6mUHBTR25I1KzXwbe4QtehD3yZzSxMl45Nn2S3+36V1sJpkq2NR+Fz5foi0w3/bOs5o6a2pEei0RAi3DRxZVVhAEN96ZbIrlKbqo3ZnE=
Received: from MW3PR06CA0022.namprd06.prod.outlook.com (2603:10b6:303:2a::27)
 by IA1PR12MB7688.namprd12.prod.outlook.com (2603:10b6:208:420::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.29; Fri, 14 Oct
 2022 04:43:21 +0000
Received: from CO1NAM11FT014.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:2a:cafe::11) by MW3PR06CA0022.outlook.office365.com
 (2603:10b6:303:2a::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.21 via Frontend
 Transport; Fri, 14 Oct 2022 04:43:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT014.mail.protection.outlook.com (10.13.175.99) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5723.20 via Frontend Transport; Fri, 14 Oct 2022 04:43:19 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Thu, 13 Oct
 2022 23:42:50 -0500
Received: from xhdipdslab49.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2375.28 via Frontend
 Transport; Thu, 13 Oct 2022 23:42:42 -0500
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
Subject: [RFC PATCH v4 7/8] bus/cdx: add cdx-MSI domain with gic-its domain as parent
Date:   Fri, 14 Oct 2022 10:10:48 +0530
Message-ID: <20221014044049.2557085-8-nipun.gupta@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221014044049.2557085-1-nipun.gupta@amd.com>
References: <20220803122655.100254-1-nipun.gupta@amd.com>
 <20221014044049.2557085-1-nipun.gupta@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT014:EE_|IA1PR12MB7688:EE_
X-MS-Office365-Filtering-Correlation-Id: f8baff6a-97b7-4431-8f5e-08daad9e9e45
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9ch7QSCJGJ03M8WgGz9QfTwaSRarQoYz6jvs5nbxvMyBcwyM1euadmAcDdUGYoVzQLbqWQwZMQr0IqHlGdJAGQjlYkEKdH7Z67t/0owSBmuH8m8cvXXOTdplLYRRkaRpGQFlVQVep3hhwhSlMLnTTo446Dg6Y7oCXyIw9gJY2xdzk6fS0UgBC47pukh5u7CDpb89WbHy9Z+1XEdcxKYDriD7lMdcq2pDR2ZWXQwD8w4DNSHuEiAjxw/RyHHJxVGyQN1zmCZ0PMr0K/6Qjyq0NG5GNs5arQyT7mJsASRCNxbYSsUGxZck+WDiCQHfIZMaAw7pNVmmifXC/p1paF2k7H4dM2EpQ5EU2WLOKVo+KgKllTnvA9YC7bdCYJRAG/y7B5yLaCLQmfDMQnCdJKJAd5l6An5Eeu1fB6pmt5IsZrvIoeydevMIe9glH3a3nzPYlHJZEzk5c2G90N4E+0nl1I2fv0STCkE5WGrC/KpvX3jwmevkPFddnefYXd2gp+LztrJ4xXqoDEPA6qAjv+6RjyM7a3PLvKu0knvC0rx3ng1NhluPyYx/o3GjHvfqHOM1lb6dKLYj8JNLj5wh7mJ0yWwOhW5cO9g3Xn7++tM6KGP6cKTjIFJLhbia9i+FEtzQ1Fg9MEOJzdBJ5kIrn1Is+rAzELbeJYgMgr0hDNkAF3fYhqok4DSdOLuhdzITM8/i3ClZflz5N2qv0JNureb2lUSbFaRcJ2DOjjxWKVg6jB7ZW4AXnqSVuhJq6hS89I4gq/2iv1qf3Lhb3E5CaqrPE3UWcyDY4dXqBAmcV0ueu7igE+AOC4ERg9Wv9jlRbEp0lHLZaPbbHCyBc6fgSccgkwTqP4CgnvcmBQOFoB3yyIdNotICvNEMsYa/X/+KfGIh
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(346002)(396003)(39860400002)(451199015)(40470700004)(36840700001)(46966006)(54906003)(110136005)(316002)(478600001)(4326008)(8676002)(70206006)(70586007)(8936002)(26005)(356005)(41300700001)(186003)(1076003)(44832011)(2906002)(336012)(5660300002)(7416002)(30864003)(2616005)(81166007)(426003)(47076005)(36756003)(83380400001)(36860700001)(82740400003)(921005)(82310400005)(40460700003)(40480700001)(86362001)(83996005)(2101003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2022 04:43:19.6580
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f8baff6a-97b7-4431-8f5e-08daad9e9e45
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT014.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7688
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since CDX devices are not linked to of node they need a
separate MSI domain for handling device ID to be provided to
the GIC ITS domain.

This also introduces APIs to alloc and free IRQs for CDX domain.

Signed-off-by: Nipun Gupta <nipun.gupta@amd.com>
Signed-off-by: Nikhil Agarwal <nikhil.agarwal@amd.com>
---
 drivers/bus/cdx/Kconfig     |   1 +
 drivers/bus/cdx/Makefile    |   2 +-
 drivers/bus/cdx/cdx.c       |  18 ++++
 drivers/bus/cdx/cdx.h       |  10 +++
 drivers/bus/cdx/cdx_msi.c   | 161 ++++++++++++++++++++++++++++++++++++
 include/linux/cdx/cdx_bus.h |  26 ++++++
 kernel/irq/msi.c            |   1 +
 7 files changed, 218 insertions(+), 1 deletion(-)
 create mode 100644 drivers/bus/cdx/cdx_msi.c

diff --git a/drivers/bus/cdx/Kconfig b/drivers/bus/cdx/Kconfig
index 98ec05ad708d..062443080d6f 100644
--- a/drivers/bus/cdx/Kconfig
+++ b/drivers/bus/cdx/Kconfig
@@ -7,6 +7,7 @@
 
 config CDX_BUS
 	bool "CDX Bus driver"
+	select GENERIC_MSI_IRQ_DOMAIN
 	help
 		Driver to enable CDX Bus infrastructure. CDX bus uses
 		CDX controller and firmware to scan the FPGA based
diff --git a/drivers/bus/cdx/Makefile b/drivers/bus/cdx/Makefile
index 2e8f42611dfc..95f8fa3b4db8 100644
--- a/drivers/bus/cdx/Makefile
+++ b/drivers/bus/cdx/Makefile
@@ -5,4 +5,4 @@
 # Copyright (C) 2022, Advanced Micro Devices, Inc.
 #
 
-obj-$(CONFIG_CDX_BUS) += cdx.o
+obj-$(CONFIG_CDX_BUS) += cdx.o cdx_msi.o
diff --git a/drivers/bus/cdx/cdx.c b/drivers/bus/cdx/cdx.c
index 41c61bf6d5f0..a3accde0421f 100644
--- a/drivers/bus/cdx/cdx.c
+++ b/drivers/bus/cdx/cdx.c
@@ -56,6 +56,7 @@
  */
 
 #include <linux/init.h>
+#include <linux/irqdomain.h>
 #include <linux/kernel.h>
 #include <linux/of_device.h>
 #include <linux/slab.h>
@@ -449,6 +450,7 @@ int cdx_device_add(struct cdx_dev_params_t *dev_params)
 	struct cdx_controller_t *cdx = dev_params->cdx;
 	struct device *parent = cdx->dev;
 	struct cdx_device *cdx_dev;
+	struct irq_domain *cdx_msi_domain;
 	int ret;
 
 	cdx_dev = kzalloc(sizeof(*cdx_dev), GFP_KERNEL);
@@ -465,6 +467,7 @@ int cdx_device_add(struct cdx_dev_params_t *dev_params)
 
 	/* Populate CDX dev params */
 	cdx_dev->req_id = dev_params->req_id;
+	cdx_dev->num_msi = dev_params->num_msi;
 	cdx_dev->vendor = dev_params->vendor;
 	cdx_dev->device = dev_params->device;
 	cdx_dev->bus_num = dev_params->bus_num;
@@ -483,6 +486,21 @@ int cdx_device_add(struct cdx_dev_params_t *dev_params)
 	dev_set_name(&cdx_dev->dev, "cdx-%02x:%02x", cdx_dev->bus_num,
 			cdx_dev->dev_num);
 
+	/* If CDX MSI domain is not created, create one. */
+	cdx_msi_domain = irq_find_host(parent->of_node);
+	if (!cdx_msi_domain) {
+		cdx_msi_domain = cdx_msi_domain_init(parent);
+		if (!cdx_msi_domain) {
+			dev_err(&cdx_dev->dev,
+				"cdx_msi_domain_init() failed: %d", ret);
+			kfree(cdx_dev);
+			return -ENODEV;
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
index 80496865ae9c..5fd40c7e633e 100644
--- a/drivers/bus/cdx/cdx.h
+++ b/drivers/bus/cdx/cdx.h
@@ -23,6 +23,7 @@
  * @res: array of MMIO region entries
  * @res_count: number of valid MMIO regions
  * @req_id: Requestor ID associated with CDX device
+ * @num_msi: Number of MSI's supported by the device
  */
 struct cdx_dev_params_t {
 	struct cdx_controller_t *cdx;
@@ -35,6 +36,7 @@ struct cdx_dev_params_t {
 	struct resource res[MAX_CDX_DEV_RESOURCES];
 	u8 res_count;
 	u32 req_id;
+	u32 num_msi;
 };
 
 /**
@@ -63,4 +65,12 @@ void cdx_unregister_controller(struct cdx_controller_t *cdx);
  */
 int cdx_device_add(struct cdx_dev_params_t *dev_params);
 
+/**
+ * cdx_msi_domain_init - Init the CDX bus MSI domain.
+ * @dev: Device of the CDX bus controller
+ *
+ * Return CDX MSI domain, NULL on failure
+ */
+struct irq_domain *cdx_msi_domain_init(struct device *dev);
+
 #endif /* _CDX_H_ */
diff --git a/drivers/bus/cdx/cdx_msi.c b/drivers/bus/cdx/cdx_msi.c
new file mode 100644
index 000000000000..b9e7e9d6fb51
--- /dev/null
+++ b/drivers/bus/cdx/cdx_msi.c
@@ -0,0 +1,161 @@
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
+#define REQ_ID_SHIFT	10
+
+/*
+ * Convert an msi_desc to a globaly unique identifier (per-device
+ * reqid + msi_desc position in the msi_list).
+ */
+static irq_hw_number_t cdx_domain_calc_hwirq(struct cdx_device *dev,
+					     struct msi_desc *desc)
+{
+	return (dev->req_id << REQ_ID_SHIFT) | desc->msi_index;
+}
+
+static void cdx_msi_set_desc(msi_alloc_info_t *arg,
+			     struct msi_desc *desc)
+{
+	arg->desc = desc;
+	arg->hwirq = cdx_domain_calc_hwirq(to_cdx_device(desc->dev), desc);
+}
+
+static void cdx_msi_write_msg(struct irq_data *irq_data,
+			      struct msi_msg *msg)
+{
+	struct msi_desc *msi_desc = irq_data_get_msi_desc(irq_data);
+	struct cdx_device *cdx_dev = to_cdx_device(msi_desc->dev);
+	struct cdx_controller_t *cdx = cdx_dev->cdx;
+	uint64_t addr;
+	int ret;
+
+	addr = ((uint64_t)(msi_desc->msg.address_hi) << 32) |
+	       msi_desc->msg.address_lo;
+
+	ret = cdx->ops.write_msi(cdx, cdx_dev->bus_num, cdx_dev->dev_num,
+				 msi_desc->msi_index, msi_desc->msg.data,
+				 addr);
+	if (ret)
+		dev_err(&cdx_dev->dev, "Write MSI failed to CDX controller\n");
+}
+
+int cdx_msi_domain_alloc_irqs(struct device *dev, unsigned int irq_count)
+{
+	int ret;
+
+	ret = msi_setup_device_data(dev);
+	if (ret)
+		return ret;
+
+	msi_lock_descs(dev);
+	if (msi_first_desc(dev, MSI_DESC_ALL))
+		ret = -EINVAL;
+	msi_unlock_descs(dev);
+	if (ret)
+		return ret;
+
+	ret = msi_domain_alloc_irqs(dev, irq_count);
+	if (ret)
+		dev_err(dev, "Failed to allocate IRQs\n");
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(cdx_msi_domain_alloc_irqs);
+
+static struct irq_chip cdx_msi_irq_chip = {
+	.name			= "CDX-MSI",
+	.irq_mask		= irq_chip_mask_parent,
+	.irq_unmask		= irq_chip_unmask_parent,
+	.irq_eoi		= irq_chip_eoi_parent,
+	.irq_set_affinity	= msi_domain_set_affinity,
+	.irq_write_msi_msg	= cdx_msi_write_msg
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
+	return msi_info->ops->msi_prepare(msi_domain->parent, dev, nvec, info);
+}
+
+static struct msi_domain_ops cdx_msi_ops __ro_after_init = {
+	.msi_prepare	= cdx_msi_prepare,
+	.set_desc	= cdx_msi_set_desc
+};
+
+static struct msi_domain_info cdx_msi_domain_info = {
+	.ops	= &cdx_msi_ops,
+	.chip	= &cdx_msi_irq_chip,
+	.flags	= MSI_FLAG_USE_DEF_DOM_OPS | MSI_FLAG_USE_DEF_CHIP_OPS |
+		  MSI_FLAG_ALLOC_SIMPLE_MSI_DESCS | MSI_FLAG_FREE_MSI_DESCS
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
+	cdx_msi_domain = msi_create_irq_domain(fwnode_handle,
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
diff --git a/include/linux/cdx/cdx_bus.h b/include/linux/cdx/cdx_bus.h
index 9e6872a03215..dfc0bd289834 100644
--- a/include/linux/cdx/cdx_bus.h
+++ b/include/linux/cdx/cdx_bus.h
@@ -21,14 +21,21 @@ typedef int (*cdx_scan_t)(struct cdx_controller_t *cdx);
 typedef int (*cdx_dev_reset_t)(struct cdx_controller_t *cdx,
 			       uint8_t bus_num, uint8_t dev_num);
 
+typedef int (*cdx_write_msi_msg_t)(struct cdx_controller_t *cdx,
+				   uint8_t bus_num, uint8_t dev_num,
+				   uint16_t msi_index, uint32_t data,
+				   uint64_t addr);
+
 /**
  * Callbacks supported by CDX controller.
  * @scan: scan the devices on the controller
  * @reset_dev: reset a CDX device
+ * @write_msi: callback to write the MSI message
  */
 struct cdx_ops_t {
 	cdx_scan_t scan;
 	cdx_dev_reset_t reset_dev;
+	cdx_write_msi_msg_t write_msi;
 };
 
 /**
@@ -57,6 +64,7 @@ struct cdx_controller_t {
  * @dma_mask: Default DMA mask
  * @flags: CDX device flags
  * @req_id: Requestor ID associated with CDX device
+ * @num_msi: Number of MSI's supported by the device
  * @driver_override: driver name to force a match; do not set directly,
  *                   because core frees it; use driver_set_override() to
  *                   set or clear it.
@@ -73,6 +81,7 @@ struct cdx_device {
 	u64 dma_mask;
 	u16 flags;
 	u32 req_id;
+	u32 num_msi;
 	const char *driver_override;
 };
 
@@ -136,4 +145,21 @@ extern struct bus_type cdx_bus_type;
  */
 int cdx_dev_reset(struct device *dev);
 
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
+#define cdx_msi_domain_free_irqs msi_domain_free_irqs
+
 #endif /* _CDX_BUS_H_ */
diff --git a/kernel/irq/msi.c b/kernel/irq/msi.c
index 14983c82a9e3..f55a5e395686 100644
--- a/kernel/irq/msi.c
+++ b/kernel/irq/msi.c
@@ -1034,6 +1034,7 @@ void msi_domain_free_irqs(struct device *dev)
 	msi_domain_free_irqs_descs_locked(dev);
 	msi_unlock_descs(dev);
 }
+EXPORT_SYMBOL_GPL(msi_domain_free_irqs);
 
 /**
  * msi_get_domain_info - Get the MSI interrupt domain info for @domain
-- 
2.25.1

