Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1955E5FE81C
	for <lists+kvm@lfdr.de>; Fri, 14 Oct 2022 06:42:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229572AbiJNEmZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Oct 2022 00:42:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbiJNEmX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Oct 2022 00:42:23 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2077.outbound.protection.outlook.com [40.107.92.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C68771FF81;
        Thu, 13 Oct 2022 21:42:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l/Ik55ox7yhg0j6riOgdY6/9XjBy9JvunPZxX3AVUq4TqCj+O1bZGBqESktbAjB6ezFNNoiP7UKftnCXimokrN26ZGZ0W1fV0UtT+u/Y8h699ub8YXYZXhmpB3tj3EkGZ9Ng6t7dTTSnzXn1a5LPUYORxo/vnY059ouTYIiYTfZDyzpGq7JUFxswuIHrp35+3xJJe0azuVcPcQtCVrdk6yAOm8ffvDspwqM0bZsgjzNbG6g5D/ryhL7uoeOtkt/kQ5X6J4GrSfpGp/uuFt3/LHJCQXvdGn3e3cdsa+P5eQO09cefkfVJVtmk/IUtaalbNpc3/zZKk2emLylrmz+6WQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+K9ehIjOh8KhbrUhtSnOdU7U6y8AO5hjycEQmg07qXo=;
 b=j3NGV1jgbkgHXtu+I27d4IEOqrE0NHzBo9Z4TIs9ctf9Ni6DjelLVxMBhOa+YBHPqVMJUkItIAoRUP2O5y6Qq9KuYxol04pwlz8NLUG4IQ9E+C5Wu9RITuA1JaHfUoAvlimrZFdYUbMisHYbA/9DV10VEgwG/Ozw8WHNXtEky8ai0Pgc4BpliB9UF5xG9/YEwLfguSEGOLCUgTZbfFUKyPjkiII8wzFQpt31KynCKfTydArhLETqNXcCHwvqq2AIrm/gr+dsotDR3gt5D4jKq+WVfnFSRgWD3LHUk7jcYd/ywqxbo8Mmmo/zVwg3KcuXyEssfTJqizib9bQx5Fwq0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+K9ehIjOh8KhbrUhtSnOdU7U6y8AO5hjycEQmg07qXo=;
 b=EGqBfyUiICnbfWmcO4Z6rLQPCLRc+eeNuTtVCjIGFrNrsEHuWqJlX3xK6H4AfKKpRCiH564ogDwsaUdskYr/6PaID3HMtZ8LrsWehokzwCD4nfTQUW1+5Djcnm5MK7ca+nqkFEAF2kx1b2elH5H6RsdfgyvwnRhfTOUV4vMNeSI=
Received: from MW4PR04CA0142.namprd04.prod.outlook.com (2603:10b6:303:84::27)
 by DM4PR12MB5102.namprd12.prod.outlook.com (2603:10b6:5:391::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.26; Fri, 14 Oct
 2022 04:42:06 +0000
Received: from CO1NAM11FT038.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:84:cafe::b2) by MW4PR04CA0142.outlook.office365.com
 (2603:10b6:303:84::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.30 via Frontend
 Transport; Fri, 14 Oct 2022 04:42:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CO1NAM11FT038.mail.protection.outlook.com (10.13.174.231) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5723.20 via Frontend Transport; Fri, 14 Oct 2022 04:42:04 +0000
Received: from SATLEXMB08.amd.com (10.181.40.132) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Thu, 13 Oct
 2022 23:42:01 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB08.amd.com
 (10.181.40.132) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Thu, 13 Oct
 2022 21:41:45 -0700
Received: from xhdipdslab49.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2375.28 via Frontend
 Transport; Thu, 13 Oct 2022 23:41:37 -0500
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
Subject: [RFC PATCH v4 5/8] bus/cdx: add bus and device attributes
Date:   Fri, 14 Oct 2022 10:10:46 +0530
Message-ID: <20221014044049.2557085-6-nipun.gupta@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221014044049.2557085-1-nipun.gupta@amd.com>
References: <20220803122655.100254-1-nipun.gupta@amd.com>
 <20221014044049.2557085-1-nipun.gupta@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT038:EE_|DM4PR12MB5102:EE_
X-MS-Office365-Filtering-Correlation-Id: bec3c482-4fa4-48ae-d27d-08daad9e71a4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 49qNqjiwa2zYakv6++EVlujh38hxqhEj7Fj6r39gZYHlvJVzxU2I1gc8IX061RyWVqNu0tXP+aJivxWOLdY0Rfun61eDgsrtxmQoa4GMx2sE1ee+NZhbBz0oHONHh/xQ72XqBHTDcgDNDWJ6SxWiEoCGnBLQAD5jr6/JFBRN7iiDJ4xCs2YWOpEBiadmQ+LeS70aNHDZT9iElLU7JVQapaF1oWOvc0+lpnF9AV9Jnk8goj7xatNo/q+F33agokB3JjWzn537YBTJofIf4lp0GXOXmnjCBDHEyo6mDKjp90zG/qdPp5IWctgoj1AHwhfTurt4uB1fdyWCcgS3xKZ2pTBGBo3kkHpQTX7yjWy09BneoGkgwOw6UtCzM3+vzIUnBbXpIBxKVBG5VQJYew36W7B+t7g3kSUpXB4ERk2xr+e+8Oa7QPUecb3LBSJNN3yWtlMCCLJLefliiFeyg41EecuWK71bu0GR0CTRDCnSSpaOZIJHIm7ZAatwsypBs2is+VA/cDRdhkDuH8x7Cn7KN6wR8m+n9+eQdR2wxgTKGoETZDhlCdeWipCO8VFEe+nY4Mjs0GiOgzpV4et6fBMIBngPDqkOznnFJeF7ztR4Wss9U1lMGn9T5x9oAg4No10xmaxuDM9mZXOumLsrx1WEfMLd62RpgplhaCAe8zRR4m3ccmXxbK+kgGIeCJM2cfGorWp9e/rAfwK8r5OcPokwsbexb/2mZpvASoH2R+LCMpfbQ0IcRaf92NbvmtRvVYfOl/R3tBq67WT/HlmE753xocXE6sq5q9Ur4rPOpxN0t9r/jqkWFoaPDu8xGkjVHOFHMl99Pmv4Wnw5brHCGv8oepuj7n8gCYbEq3bUMkUaVYZQU1Q8d+YLeM5D8dKHtMGM
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(376002)(39860400002)(346002)(451199015)(36840700001)(40470700004)(46966006)(5660300002)(336012)(44832011)(7416002)(186003)(2906002)(2616005)(47076005)(82310400005)(356005)(41300700001)(26005)(8936002)(1076003)(921005)(40480700001)(426003)(86362001)(40460700003)(83380400001)(36756003)(36860700001)(82740400003)(316002)(54906003)(110136005)(81166007)(478600001)(4326008)(70206006)(8676002)(70586007)(6666004)(36900700001)(2101003)(83996005);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2022 04:42:04.7692
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bec3c482-4fa4-48ae-d27d-08daad9e71a4
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT038.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5102
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This change adds te support for rescanning and reset
of the CDX buses, as well as option to reset any device
on the bus. It also enables sysfs entry for vendor id
and device id.

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
 drivers/bus/cdx/cdx.c | 158 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 158 insertions(+)

diff --git a/drivers/bus/cdx/cdx.c b/drivers/bus/cdx/cdx.c
index b2a7e0b34df8..41c61bf6d5f0 100644
--- a/drivers/bus/cdx/cdx.c
+++ b/drivers/bus/cdx/cdx.c
@@ -107,6 +107,12 @@ static int cdx_unregister_device(struct device *dev,
 	return 0;
 }
 
+static void cdx_unregister_devices(struct bus_type *bus)
+{
+	/* Reset all the devices attached to cdx bus */
+	bus_for_each_dev(bus, NULL, NULL, cdx_unregister_device);
+}
+
 /**
  * cdx_match_one_device - Tell if a CDX device structure has a matching
  *			  CDX device id structure
@@ -196,11 +202,163 @@ static int cdx_dma_configure(struct device *dev)
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
+	const char *old = cdx_dev->driver_override;
+	char *driver_override;
+	char *cp;
+
+	if (WARN_ON(dev->bus != &cdx_bus_type))
+		return -EINVAL;
+
+	if (count >= (PAGE_SIZE - 1))
+		return -EINVAL;
+
+	driver_override = kstrndup(buf, count, GFP_KERNEL);
+	if (!driver_override)
+		return -ENOMEM;
+
+	cp = strchr(driver_override, '\n');
+	if (cp)
+		*cp = '\0';
+
+	if (strlen(driver_override)) {
+		cdx_dev->driver_override = driver_override;
+	} else {
+		kfree(driver_override);
+		cdx_dev->driver_override = NULL;
+	}
+
+	kfree(old);
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
+	if (!cdx_controller)
+		return -EINVAL;
+
+	/* Unregister all the devices on the bus */
+	cdx_unregister_devices(&cdx_bus_type);
+
+	/* Rescan all the devices */
+	ret = cdx_controller->ops.scan(cdx_controller);
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
 	.name		= "cdx",
 	.match		= cdx_bus_match,
 	.remove		= cdx_remove,
 	.dma_configure  = cdx_dma_configure,
+	.dev_groups	= cdx_dev_groups,
+	.bus_groups	= cdx_bus_groups,
 };
 EXPORT_SYMBOL_GPL(cdx_bus_type);
 
-- 
2.25.1

