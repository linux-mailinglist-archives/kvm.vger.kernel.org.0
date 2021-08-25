Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42F8A3F7681
	for <lists+kvm@lfdr.de>; Wed, 25 Aug 2021 15:52:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241545AbhHYNxa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Aug 2021 09:53:30 -0400
Received: from mail-dm6nam12on2059.outbound.protection.outlook.com ([40.107.243.59]:40298
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241531AbhHYNxY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Aug 2021 09:53:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V+PxW+icyblQr0vG1T17CskMdXHPwhUP/oEGD2ilMVLpaAJpP4lHgJ/3DRa7pk94/oTNymJPuUkogLp+Rx5DkSJjRPx2svEkVs5hiSJkaa462x9xlgYKB8mKWWQB288g11QFshxjCHFJnE0XJWInGe/5vlVKD3ESsHf51y6pO9o8Ogy+WkC1iWrTfT9FXBoHEywv9TscDmYixBJNkg3gmoNFlaqT9+Q7C7scU4xLzNHii81jGFyY7pcXqmE1lawmSEzTGy58kKI0rNaiL0YWltxWFVIGWYwdgXZ9KQZvJ35XH6PxGMjCITFMf1OGvpQVRkonzBxTyb/+xDP3fYNwPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B0jxLfSLQhTamdl86+R8B7UypRkdNcOGdJYHo3zm0n8=;
 b=L2hIlfj72UkCaFH1VjHfoYPsyefiucTdpWYsOvQ50UcAQhyQOsc6Pxr9uh4sfMsu6hvID8FBKhGGo8M4+/aU7fDvjlXheaRN3iGcgIQKMMWWlZJ2lFsU8YgPVzWhE3JzbTn5mYVSLk31It4m5wBYa+IPdHpG9Jqm7BxOs1zPtb4qx4pOhzyTyWUimahOA1SJkug2it+QxCBNxZI9i8M5S+Sb1acoj14ZGRcsirxFnu9ugUVXFlRM+k4USu4SqlGagQJLYx5GlleXwaoTeM40GglbmyQtHe0gbnBg2KUL1HH1ITniD4rn2bRZN/28h68myvf8zWmKnCfxxFsIBWL5ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B0jxLfSLQhTamdl86+R8B7UypRkdNcOGdJYHo3zm0n8=;
 b=H2VJUt4DDt+DDh5n48olBbROEABkxwqjrenjhrxswP5E/09tl9w6hqQZNdFlHrfoBSPcBPruSzWBjugW/0KdDmaZwzThEqqkCdgBxQjesTW4PJQ6E/Bmg1LC8JOGnbelmhY1WB5nQnKb4NV/kiNEoz635DjCCamM+a6LBypNODxl6UflYa/zc9PHT4ypvUm3efIpjJJOH9Dk/PapY6D4+03eR+2w1GUU43toYeSHLMjfpcmjdoFFHPWws47a2pwxsRZHxPT2oVml13mNBiOCeOvbl/AIZw4eHCwME7zm2HDufhpUEAfR6PaKIcIeyRPxaWzH1DK0u9ZWeypO5DMGgg==
Received: from BN9PR03CA0936.namprd03.prod.outlook.com (2603:10b6:408:108::11)
 by DM6PR12MB4825.namprd12.prod.outlook.com (2603:10b6:5:1d4::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.19; Wed, 25 Aug
 2021 13:52:37 +0000
Received: from BN8NAM11FT059.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:108:cafe::ef) by BN9PR03CA0936.outlook.office365.com
 (2603:10b6:408:108::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend
 Transport; Wed, 25 Aug 2021 13:52:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 BN8NAM11FT059.mail.protection.outlook.com (10.13.177.120) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4457.17 via Frontend Transport; Wed, 25 Aug 2021 13:52:37 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 25 Aug
 2021 13:52:36 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 25 Aug 2021 06:52:32 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <bhelgaas@google.com>, <corbet@lwn.net>,
        <alex.williamson@redhat.com>, <diana.craciun@oss.nxp.com>,
        <kwankhede@nvidia.com>, <eric.auger@redhat.com>,
        <masahiroy@kernel.org>, <michal.lkml@markovi.net>
CC:     <linux-pci@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <kvm@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        <linux-kbuild@vger.kernel.org>, <mgurtovoy@nvidia.com>,
        <jgg@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <leonro@nvidia.com>
Subject: [PATCH V4 09/13] PCI: Add 'override_only' field to struct pci_device_id
Date:   Wed, 25 Aug 2021 16:51:35 +0300
Message-ID: <20210825135139.79034-10-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20210825135139.79034-1-yishaih@nvidia.com>
References: <20210825135139.79034-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 46cb73b8-2171-47c8-cc74-08d967cf9932
X-MS-TrafficTypeDiagnostic: DM6PR12MB4825:
X-Microsoft-Antispam-PRVS: <DM6PR12MB4825C230C8C717FE1FD10D51C3C69@DM6PR12MB4825.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vIAitb8w8Ki+8tbxmEAyNIgw7IwdYVBzm+xdcHDlyw26VPSibSYDcu5zAj/aaH3UpOQ2y98avtlYKC75T2j/e34EW+1lZ/P5W/lwh1zTb6y8TVnnNgGe8G7VlnBULQcthVRgP8JZRyg8+4BAYZX1mL/UDk6C4autQFMzZ8SVOQ/onJ4e6ddr0rvhT97JJ+58B318bukwlR8ttHa1i/qJZiIrmeb9cDeOBaEGXC+4wxGSCa3PBWCp8YH0X8cSHgi3gDKw9rXOz9nT3OSKt0w3Vb5X6Uq44WDtfYq8YG85tqJsExlc2VjnZ4b3h5OhWC9Cfh7ddT/N9Q/qDKISSO1yWYTIqMUXu13DQAn4Lv8xDQ30fYD8f8uhxRVh6B0hiz29ySrh4wUhl14A/uPqkkNfv4G5OB0klShB59RvWE8WnmRYjwYvYObhznKhz4IgX39TyPcMFJhzR2GJPnTDE9+mO3OHAGIWqj8ayq1JBc1azUQQPFshKaDsaZub7iFBmMR9jpEDcSOpUQYZFJTdex66g1650qXiHG6PkTnlu/xHkDTRjyNrjgw0S+GN1Eb0PUs/O+0amTK8oRAHT6q7sQiTBE0E2ws85n+jCu5n9nEkSHWwX+85v38TOMRLawDvSsUuzDC4u9bZvWNrwK1j3t32B6mhFWeNcWF3L1ujY/7QmdNbAqAw8Jny0ntdKrsAGI3vbXUEtCo/guuhBAKif6YEyyX4M8Z0GAToTiVHVGx8GGU=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(39860400002)(396003)(136003)(346002)(36840700001)(46966006)(1076003)(5660300002)(70206006)(4326008)(82310400003)(54906003)(110136005)(70586007)(8936002)(316002)(36906005)(8676002)(7636003)(47076005)(2906002)(82740400003)(7416002)(26005)(426003)(7696005)(86362001)(336012)(186003)(36860700001)(478600001)(356005)(2616005)(83380400001)(36756003)(107886003)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2021 13:52:37.4161
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 46cb73b8-2171-47c8-cc74-08d967cf9932
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT059.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4825
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Max Gurtovoy <mgurtovoy@nvidia.com>

Add 'override_only' field to struct pci_device_id to be used as part of
pci_match_device().

When set, it means that matching is true only when dev->driver_override
is this driver.

In addition, add a helper macro named 'PCI_DEVICE_DRIVER_OVERRIDE' to
enable setting some data on it.

Next patch from this series will use the above functionality.

Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 Documentation/PCI/pci.rst       |  1 +
 drivers/pci/pci-driver.c        | 28 +++++++++++++++++++++-------
 include/linux/mod_devicetable.h |  2 ++
 include/linux/pci.h             | 15 +++++++++++++++
 4 files changed, 39 insertions(+), 7 deletions(-)

diff --git a/Documentation/PCI/pci.rst b/Documentation/PCI/pci.rst
index fa651e25d98c..87c6f4a6ca32 100644
--- a/Documentation/PCI/pci.rst
+++ b/Documentation/PCI/pci.rst
@@ -103,6 +103,7 @@ need pass only as many optional fields as necessary:
   - subvendor and subdevice fields default to PCI_ANY_ID (FFFFFFFF)
   - class and classmask fields default to 0
   - driver_data defaults to 0UL.
+  - override_only field defaults to 0.
 
 Note that driver_data must match the value used by any of the pci_device_id
 entries defined in the driver. This makes the driver_data field mandatory
diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index 3a72352aa5cf..123c590ebe1d 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -136,7 +136,7 @@ static const struct pci_device_id *pci_match_device(struct pci_driver *drv,
 						    struct pci_dev *dev)
 {
 	struct pci_dynid *dynid;
-	const struct pci_device_id *found_id = NULL;
+	const struct pci_device_id *found_id = NULL, *ids;
 
 	/* When driver_override is set, only bind to the matching driver */
 	if (dev->driver_override && strcmp(dev->driver_override, drv->name))
@@ -152,14 +152,28 @@ static const struct pci_device_id *pci_match_device(struct pci_driver *drv,
 	}
 	spin_unlock(&drv->dynids.lock);
 
-	if (!found_id)
-		found_id = pci_match_id(drv->id_table, dev);
+	if (found_id)
+		return found_id;
 
-	/* driver_override will always match, send a dummy id */
-	if (!found_id && dev->driver_override)
-		found_id = &pci_device_id_any;
+	for (ids = drv->id_table; (found_id = pci_match_id(ids, dev));
+	     ids = found_id + 1) {
+		/*
+		 * The match table is split based on driver_override.
+		 * In case override_only was set, enforce driver_override
+		 * matching.
+		 */
+		if (found_id->override_only) {
+			if (dev->driver_override)
+				return found_id;
+		} else {
+			return found_id;
+		}
+	}
 
-	return found_id;
+	/* driver_override will always match, send a dummy id */
+	if (dev->driver_override)
+		return &pci_device_id_any;
+	return NULL;
 }
 
 /**
diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
index 8e291cfdaf06..2e3ba6d9ece0 100644
--- a/include/linux/mod_devicetable.h
+++ b/include/linux/mod_devicetable.h
@@ -34,12 +34,14 @@ typedef unsigned long kernel_ulong_t;
  *			Best practice is to use driver_data as an index
  *			into a static list of equivalent device types,
  *			instead of using it as a pointer.
+ * @override_only:	Match only when dev->driver_override is this driver.
  */
 struct pci_device_id {
 	__u32 vendor, device;		/* Vendor and device ID or PCI_ANY_ID*/
 	__u32 subvendor, subdevice;	/* Subsystem ID's or PCI_ANY_ID */
 	__u32 class, class_mask;	/* (class,subclass,prog-if) triplet */
 	kernel_ulong_t driver_data;	/* Data private to the driver */
+	__u32 override_only;
 };
 
 
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 540b377ca8f6..0506b1a8c921 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -901,6 +901,21 @@ struct pci_driver {
 	.vendor = (vend), .device = (dev), \
 	.subvendor = PCI_ANY_ID, .subdevice = PCI_ANY_ID
 
+/**
+ * PCI_DEVICE_DRIVER_OVERRIDE - macro used to describe a PCI device with
+ *                              override_only flags.
+ * @vend: the 16 bit PCI Vendor ID
+ * @dev: the 16 bit PCI Device ID
+ * @driver_override: the 32 bit PCI Device override_only
+ *
+ * This macro is used to create a struct pci_device_id that matches only a
+ * driver_override device. The subvendor and subdevice fields will be set to
+ * PCI_ANY_ID.
+ */
+#define PCI_DEVICE_DRIVER_OVERRIDE(vend, dev, driver_override) \
+	.vendor = (vend), .device = (dev), .subvendor = PCI_ANY_ID, \
+	.subdevice = PCI_ANY_ID, .override_only = (driver_override)
+
 /**
  * PCI_DEVICE_SUB - macro used to describe a specific PCI device with subsystem
  * @vend: the 16 bit PCI Vendor ID
-- 
2.18.1

