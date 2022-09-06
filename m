Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A62895AED34
	for <lists+kvm@lfdr.de>; Tue,  6 Sep 2022 16:30:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236854AbiIFOUS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Sep 2022 10:20:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241972AbiIFOTI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Sep 2022 10:19:08 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2062.outbound.protection.outlook.com [40.107.244.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEEE42F65E;
        Tue,  6 Sep 2022 06:50:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PDosOneLBOD/vZLb77ApRCuBcAmUYng7y0C7AUVrzsA6IjYp7kG74kTkVHPFmsjIyUf0rUpbXRivX2eVPDn8zlMox5yu3w63WJ/WIF28bFzNhfr+JS3Mmya7lgtuj5sLi1koOROKEJ4Qwm7tWsWaxzpvqtuMchtAgmkgy1MMcivgQUlyE7EcnMlxePBxhg7wplg6hSSHrMdhgeu+PbVTymumuu/x1U1524ELLE4D9HloMs1IUtFgt7R4Cg3Nm2DJ97gHqttCEyAq/CeavDBpv+Og+87iyHMELgkp8n18vG64OYqzMuQ7w2Ivgz8JunxFdaCakr2W8y/bpVE9m/Fxow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y57p5ouHP4x8F9d9gwp37pMkcc6TTtTd0Z/zpH6bcTs=;
 b=eyQt9UqpoyVwCPncYVvTxL/D35Jv7haxOv7y2XVHyrJP21SCaK0NlEGIx7KwmpKSmaKZFOcO1P833C3XpSdKPS95gd6gFomsTiThtu8P48cCH9P/9ezMuwj4DqY+gDKgT7yJguVGaU7+Yooe5RH1Vsr3cc1IzOi6RuqJOcg9Xyz7dRIVG2yiyJYgn5IdRGmrLj3bTlRfj4gY7gHuV2YpqVnxOBH1N976ByDOtj8kXrYpz6MO3ZIGOEP8QPzQF6mJ4fWhaHvCNT9g8zmnsCOH6fHNYPT+k8E4x2Tap2JykmX77Zy4VPerAmVfORyKqeUDzNp5iU039/EiAVxRHc8XYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y57p5ouHP4x8F9d9gwp37pMkcc6TTtTd0Z/zpH6bcTs=;
 b=GJ/nlLLWmexxn39Q97Ag/1fQR7UH0S1e6mudd9LF0xYwYkNjeSV6PD6mucw3Xn3PUMy3K1Etr9ZZHjnA/+LeN6g37zdjH7ef5WWxmccnNuI1qBclZOWlFABitNcx1msqy6KE2nOp/7GXNPcACClMMIRjrMO98OaBlixTFhR66iY=
Received: from BN0PR04CA0133.namprd04.prod.outlook.com (2603:10b6:408:ed::18)
 by DM6PR12MB4202.namprd12.prod.outlook.com (2603:10b6:5:219::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Tue, 6 Sep
 2022 13:49:04 +0000
Received: from BN8NAM11FT039.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ed:cafe::25) by BN0PR04CA0133.outlook.office365.com
 (2603:10b6:408:ed::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10 via Frontend
 Transport; Tue, 6 Sep 2022 13:49:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT039.mail.protection.outlook.com (10.13.177.169) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5588.10 via Frontend Transport; Tue, 6 Sep 2022 13:49:03 +0000
Received: from SATLEXMB08.amd.com (10.181.40.132) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Tue, 6 Sep
 2022 08:49:03 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB08.amd.com
 (10.181.40.132) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Tue, 6 Sep
 2022 06:49:02 -0700
Received: from xhdipdslab49.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2375.28 via Frontend
 Transport; Tue, 6 Sep 2022 08:48:53 -0500
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
Subject: [RFC PATCH v3 5/7] bus/cdx: add bus and device attributes
Date:   Tue, 6 Sep 2022 19:17:59 +0530
Message-ID: <20220906134801.4079497-6-nipun.gupta@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220906134801.4079497-1-nipun.gupta@amd.com>
References: <20220803122655.100254-1-nipun.gupta@amd.com>
 <20220906134801.4079497-1-nipun.gupta@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eb72c8db-bfc4-4e71-64f6-08da900e8fa4
X-MS-TrafficTypeDiagnostic: DM6PR12MB4202:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gneOVv2jGrgvkTEE79Utgcm8kX2tgoleuRqJG14wR//ocqqT4qCRucHUqScaEktwc5hB1TxvPFEncLN6fTQHiORa7t8RqRMg+LUU6wfA+cFOPZiQqmXs6HGeAqY5Tw6mevwByQ8V6uLWXOCX9Rfq6rlUw6mEJnlkO6DwIccSSMCtr+yR/rp5npdQl5nL3R2coTFgKsadr+6XB7QivyGPb2TpRu0bdODEi3s7TJLCAtL+6c+RgShYlFLdhgL/4QMkbMGH+WNPsnACBQVdFim4brkFD74flfH3fAbfSbvt/5X8l7YGRvjxeEQdCixeJ+wpTTAoB5gL9YCYYO+7NZV+hXdUxhw+gcuhoNtZv7JYIYw0XuzRthIO4cu4+e75Zivd7LYUtyriyYst8RcHivWccMbzJYbHQBm2ZC1xDPEPT1HmbZC9COiscMb+IcaBp9tM4d3JXBr0Y75r5jR7FVj3/ELaHqImRYxwlmCzEfnAwUBQH88xutXAUo+qEZIAFxhZWFTApG7XEq6UFJUAy939LRHjDf05tV7T57sp+0UjUbttD4JPY6WUr3Wsy4oZSzTgSLa7Aa2O6FQ8lbyD2tSjDOR0omwK+5klGG/2S37LI67TMif1gjI49oVflcwReluqqf9CFLGGaNksf70bxjejOuEvr2evP80MqZX5QJqCtsA9zdcIfWnt0i3FA4pVcZdD8JlQ1pJAptOYgPV4qfUNNLx7Prd5UaE92ohQABpUVc6Zpao3p3ilqRZkVZ3Lnl2nMe1xR6AyJQRpqVnm4syzxwjfTuzkkDJlYSZeeSS0xq+4qq+T+M/CAGZcJfsaLFyXNGKeEZy/J6O1WV8wokXi66souE/Z26AzV5gM75zUCucXMERPRcniAV/oEQtA+AZM
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(376002)(346002)(396003)(136003)(46966006)(40470700004)(36840700001)(4326008)(44832011)(82310400005)(40480700001)(110136005)(316002)(86362001)(54906003)(36756003)(82740400003)(2906002)(356005)(921005)(81166007)(40460700003)(8936002)(5660300002)(7416002)(36860700001)(83380400001)(70586007)(8676002)(47076005)(70206006)(426003)(336012)(41300700001)(2616005)(186003)(1076003)(478600001)(26005)(83996005)(36900700001)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2022 13:49:03.9579
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: eb72c8db-bfc4-4e71-64f6-08da900e8fa4
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT039.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4202
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This change adds te support for rescanning and reset
of the CDX buses, as well as option to optionally reset
any devices on the bus. It also enables sysfs entry for
vendor and device id.

Sysfs entries are provided in CDX controller:
- rescan of the CDX controller.
- reset all the devices present on CDX buses.

Sysfs entry is provided in each of the platform device
detected by the CDX controller
- vendor id
- device id
- modalias
- reset of the device.

Signed-off-by: Puneet Gupta <puneet.gupta@amd.com>
Signed-off-by: Nipun Gupta <nipun.gupta@amd.com>
---
 Documentation/ABI/testing/sysfs-bus-cdx |  54 +++++++++
 drivers/bus/cdx/cdx.c                   | 148 ++++++++++++++++++++++++
 drivers/bus/cdx/mcdi_stubs.c            |   6 +
 drivers/bus/cdx/mcdi_stubs.h            |  11 ++
 include/linux/cdx/cdx_bus.h             |   8 ++
 5 files changed, 227 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-bus-cdx

diff --git a/Documentation/ABI/testing/sysfs-bus-cdx b/Documentation/ABI/testing/sysfs-bus-cdx
new file mode 100644
index 000000000000..5f84f0a93a66
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-bus-cdx
@@ -0,0 +1,54 @@
+What:		/sys/bus/cdx/rescan
+Date:		August 2022
+Contact:	puneet.gupta@amd.com
+Description:
+		Writing 1 to this would cause rescan of the bus
+		and devices on the CDX bus. Any new devices would
+		be scanned and added to the list of linux devices
+		and any devices removed are also deleted from linux.
+
+                For example::
+
+		  # echo 1 > /sys/bus/cdx/rescan
+
+What:		/sys/bus/cdx/reset_all
+Date:		August 2022
+Contact:	puneet.gupta@amd.com
+Description:
+		Writing 1 to this would reset all the devices present
+		on the CDX bus
+
+                For example::
+
+		  # echo 1 > /sys/bus/cdx/reset_all
+
+What:		/sys/bus/cdx/devices/.../vendor
+Date:		August 2022
+Contact:	nipun.gupta@amd.com
+Description:
+		Vendor ID for this CDX device
+
+What:		/sys/bus/cdx/devices/.../device
+Date:		August 2022
+Contact:	nipun.gupta@amd.com
+Description:
+		Device ID for this CDX device
+
+What:		/sys/bus/cdx/devices/.../reset
+What:		/sys/bus/cdx/devices/.../reset
+Date:		August 2022
+Contact:	nipun.gupta@amd.com
+Description:
+		Writing 1 to this would reset the CDX device
+
+                For example::
+
+		  # echo 1 > /sys/bus/cdx/.../reset
+
+What:		/sys/bus/cdx/devices/.../modalias
+Date:		August 2022
+Contact:	nipun.gupta@amd.com
+Description:
+		A CDX device has modalias:
+
+			- v`vendor`d`device`
diff --git a/drivers/bus/cdx/cdx.c b/drivers/bus/cdx/cdx.c
index 02ececce1c84..9b7a69de6a8f 100644
--- a/drivers/bus/cdx/cdx.c
+++ b/drivers/bus/cdx/cdx.c
@@ -32,6 +32,23 @@ struct platform_device *cdx_controller_pdev;
 
 static int cdx_bus_device_discovery(struct platform_device *pdev);
 
+static int reset_cdx_device(struct device *dev, void * __always_unused data)
+{
+	struct platform_device *cdx_bus_pdev = to_platform_device(dev->parent);
+	struct cdx_device *cdx_dev = to_cdx_device(dev);
+	struct cdx_mcdi_t *cdx_mcdi = platform_get_drvdata(cdx_bus_pdev);
+
+	/* MCDI FW: reset particular device represented by bus:func */
+	cdx_mcdi_func_reset(cdx_mcdi, cdx_dev->bus_id, cdx_dev->func_id);
+
+	return 0;
+}
+
+int cdx_dev_reset(struct device *dev)
+{
+	return reset_cdx_device(dev, NULL);
+}
+
 static int cdx_unregister_device(struct device *dev,
 				 void * __always_unused data)
 {
@@ -139,10 +156,141 @@ static int cdx_dma_configure(struct device *dev)
 	return 0;
 }
 
+static ssize_t vendor_show(struct device *dev, struct device_attribute *attr,
+			   char *buf)
+{
+	struct cdx_device *cdx_dev = to_cdx_device(dev);
+
+	return sprintf(buf, "0x%x\n", cdx_dev->vendor);
+}
+static DEVICE_ATTR_RO(vendor);
+
+static ssize_t device_show(struct device *dev, struct device_attribute *attr,
+			   char *buf)
+{
+	struct cdx_device *cdx_dev = to_cdx_device(dev);
+
+	return sprintf(buf, "0x%x\n", cdx_dev->device);
+}
+static DEVICE_ATTR_RO(device);
+
+static ssize_t reset_store(struct device *dev, struct device_attribute *attr,
+			   const char *buf, size_t count)
+{
+	int ret = 0;
+	bool reset = count > 0 && *buf != '0';
+
+	if (!reset)
+		return count;
+
+	ret = reset_cdx_device(dev, NULL);
+	if (ret)
+		return ret;
+
+	return count;
+}
+static DEVICE_ATTR_WO(reset);
+
+static ssize_t modalias_show(struct device *dev, struct device_attribute *attr,
+			     char *buf)
+{
+	struct cdx_device *cdx_dev = to_cdx_device(dev);
+
+	return sprintf(buf, "cdx:v%08Xd%d\n", cdx_dev->vendor,
+			cdx_dev->device);
+}
+static DEVICE_ATTR_RO(modalias);
+
+static ssize_t driver_override_store(struct device *dev,
+				     struct device_attribute *attr,
+				     const char *buf, size_t count)
+{
+	struct cdx_device *cdx_dev = to_cdx_device(dev);
+	int ret;
+
+	if (WARN_ON(dev->bus != &cdx_bus_type))
+		return -EINVAL;
+
+	ret = driver_set_override(dev, &cdx_dev->driver_override, buf, count);
+	if (ret)
+		return ret;
+
+	return count;
+}
+
+static ssize_t driver_override_show(struct device *dev,
+				    struct device_attribute *attr, char *buf)
+{
+	struct cdx_device *cdx_dev = to_cdx_device(dev);
+
+	return snprintf(buf, PAGE_SIZE, "%s\n", cdx_dev->driver_override);
+}
+static DEVICE_ATTR_RW(driver_override);
+
+static struct attribute *cdx_dev_attrs[] = {
+	&dev_attr_reset.attr,
+	&dev_attr_vendor.attr,
+	&dev_attr_device.attr,
+	&dev_attr_modalias.attr,
+	&dev_attr_driver_override.attr,
+	NULL,
+};
+ATTRIBUTE_GROUPS(cdx_dev);
+
+static ssize_t rescan_store(struct bus_type *bus,
+			    const char *buf, size_t count)
+{
+	bool rescan = count > 0 && *buf != '0';
+	int ret = 0;
+
+	if (!rescan)
+		return count;
+
+	/* Unregister all the devices on the bus */
+	cdx_unregister_devices(&cdx_bus_type);
+
+	/* Rescan all the devices */
+	ret = cdx_bus_device_discovery(cdx_controller_pdev);
+	if (ret)
+		return ret;
+
+	return count;
+}
+static BUS_ATTR_WO(rescan);
+
+static ssize_t reset_all_store(struct bus_type *bus,
+			       const char *buf, size_t count)
+{
+	bool reset = count > 0 && *buf != '0';
+	int ret = 0;
+
+	if (!reset)
+		return count;
+
+	/* Reset all the devices attached to cdx bus */
+	ret = bus_for_each_dev(bus, NULL, NULL, reset_cdx_device);
+	if (ret) {
+		pr_err("error in CDX bus reset\n");
+		return 0;
+	}
+
+	return count;
+}
+static BUS_ATTR_WO(reset_all);
+
+static struct attribute *cdx_bus_attrs[] = {
+	&bus_attr_rescan.attr,
+	&bus_attr_reset_all.attr,
+	NULL,
+};
+ATTRIBUTE_GROUPS(cdx_bus);
+
 struct bus_type cdx_bus_type = {
 	.name = "cdx",
 	.match = cdx_bus_match,
 	.dma_configure  = cdx_dma_configure,
+	.dev_groups = cdx_dev_groups,
+	.bus_groups = cdx_bus_groups,
 };
 EXPORT_SYMBOL_GPL(cdx_bus_type);
 
diff --git a/drivers/bus/cdx/mcdi_stubs.c b/drivers/bus/cdx/mcdi_stubs.c
index 2c8db1f5a057..2bc042d2b061 100644
--- a/drivers/bus/cdx/mcdi_stubs.c
+++ b/drivers/bus/cdx/mcdi_stubs.c
@@ -53,3 +53,9 @@ int cdx_mcdi_get_func_config(struct cdx_mcdi_t *cdx_mcdi,
 
 	return 0;
 }
+
+int cdx_mcdi_func_reset(struct cdx_mcdi_t *cdx_mcdi,
+			uint8_t bus_id, uint8_t func_id)
+{
+	return 0;
+}
diff --git a/drivers/bus/cdx/mcdi_stubs.h b/drivers/bus/cdx/mcdi_stubs.h
index 7b6f79d48ce9..535218bcdce0 100644
--- a/drivers/bus/cdx/mcdi_stubs.h
+++ b/drivers/bus/cdx/mcdi_stubs.h
@@ -73,4 +73,15 @@ int cdx_mcdi_get_func_config(struct cdx_mcdi_t *cdx_mcdi,
 			     uint8_t bus_id, uint8_t func_id,
 			     struct cdx_dev_params_t *dev_params);
 
+/**
+ * cdx_mcdi_func_reset - Reset cdx device represented by bus_id:func_id
+ * @cdx_mcdi: pointer to MCDI interface.
+ * @bus_num: Bus number.
+ * @func_id: Function number.
+ *
+ * Return 0 on success, <0 on failure
+ */
+int cdx_mcdi_func_reset(struct cdx_mcdi_t *cdx_mcdi,
+			uint8_t bus_id, uint8_t func_id);
+
 #endif /* _MCDI_STUBS_H_ */
diff --git a/include/linux/cdx/cdx_bus.h b/include/linux/cdx/cdx_bus.h
index bf86024783d2..8306b4d3fd82 100644
--- a/include/linux/cdx/cdx_bus.h
+++ b/include/linux/cdx/cdx_bus.h
@@ -109,4 +109,12 @@ int cdx_msi_domain_alloc_irqs(struct device *dev, unsigned int irq_count);
  */
 void cdx_msi_domain_free_irqs(struct device *dev);
 
+/**
+ * cdx_dev_reset - Reset CDX device
+ * @dev: device pointer
+ *
+ * Return 0 for success, -errno on failure
+ */
+int cdx_dev_reset(struct device *dev);
+
 #endif /* _CDX_BUS_H_ */
-- 
2.25.1

