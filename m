Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E18D13F4001
	for <lists+kvm@lfdr.de>; Sun, 22 Aug 2021 16:37:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234305AbhHVOiV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 22 Aug 2021 10:38:21 -0400
Received: from mail-mw2nam10on2066.outbound.protection.outlook.com ([40.107.94.66]:14432
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234405AbhHVOiQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 22 Aug 2021 10:38:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AqCe78hr/R+J6/KxacWNP3Wk5Ot6UDojl0PKa7QHmY37X0HBl27UoCgGi94Y/EJe/NUyFw68v0In9IM/xAJLs5Ym6Ylz0f39sgDBybYi4TErusVbluHBC6h/LDWkPIURonjwKetKQrMjmVMhGh1skkdyryYZ9AiEKOXmiYgv3lwkPDWLXDsKFHbmRLhG8/HvsRcYF6pTn95Ex2V6oFF7KxLBDKdgcnORWdDlH/nSobfg4o3Itr9ZKP5McG4cFHMpRrTNiDl5okGdJqPaPMoJ6I7BBoIyHNNoAKA523420wz8xBs9uChr14l9bWf0KjBDpq91ZNgyN/cWN908/JA9ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B0jxLfSLQhTamdl86+R8B7UypRkdNcOGdJYHo3zm0n8=;
 b=jyr6bMGHZAsOBfjyDSJzrBUTLcdRNpby9F5yYhBqlc4uYu3Q3pafcliIO+9nSbRqJXSj9V7EpO42Z0q5H/yOmweYSNxD98TwXVvM+k3O/BXvmVZtEar+hJcbzQ/vNtzMASouxVxLwrbEDBgvuLnuRpdfnC4MyJMAf87EFBIDD97ZzTc0bhTtxlMSXUNMCVuIQo8zA00FvStngzy+gY9RujOiOhLMO+CDF22kv4q5qo5u26ZozHhE4LU+R1MJ9zLfrXv94W8G3eJXv2EuRhl9OTREDlAWjxMUuPkrddWNBr1s4vFc+FocNZ77gYV5zR1zma5HP4Ty/TeBX6ff/i0P2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B0jxLfSLQhTamdl86+R8B7UypRkdNcOGdJYHo3zm0n8=;
 b=hhILPzPzYvCjQHuaDhjeLQCQO88LKJDSZiwUq79pnWr85QMzoz5gHq7RxMsRovXz3CSc/2zsHjDrpg5Ha9Jyt/Z9IjExhRGf0Lj3TsokIEZlNPQXon+c8hVekeYokjU8ayemTmHU/sX0vBAJv9cRP7FvQ24L1L5M5seh2WvZkS63TlUs2wFfd9xD9VJvy4Q+RCRW/UCbNawmJzUNHtsOFGSJ9yKdGu50J/YCGZnV3QASm9KBTd3kuNJ0gwXmPaSsv0xu6bVnAXFCCZGzf/Nq2pduhV/TzSojJ9ROjE57INlS1k9NSGGbEZcVAI3lmna3TrS9hK2piX+AdhiUxlw/RQ==
Received: from DM5PR07CA0134.namprd07.prod.outlook.com (2603:10b6:3:13e::24)
 by DM5PR1201MB0107.namprd12.prod.outlook.com (2603:10b6:4:55::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Sun, 22 Aug
 2021 14:37:34 +0000
Received: from DM6NAM11FT003.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:13e:cafe::59) by DM5PR07CA0134.outlook.office365.com
 (2603:10b6:3:13e::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend
 Transport; Sun, 22 Aug 2021 14:37:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 DM6NAM11FT003.mail.protection.outlook.com (10.13.173.162) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4436.19 via Frontend Transport; Sun, 22 Aug 2021 14:37:33 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 22 Aug
 2021 14:37:33 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 22 Aug 2021 14:37:29 +0000
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
Subject: [PATCH V3 09/13] PCI: Add 'override_only' field to struct pci_device_id
Date:   Sun, 22 Aug 2021 17:35:58 +0300
Message-ID: <20210822143602.153816-10-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20210822143602.153816-1-yishaih@nvidia.com>
References: <20210822143602.153816-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3844a20a-0361-4fa4-eff5-08d9657a612b
X-MS-TrafficTypeDiagnostic: DM5PR1201MB0107:
X-Microsoft-Antispam-PRVS: <DM5PR1201MB01072376A67E5A3F4F125C5BC3C39@DM5PR1201MB0107.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jx827gnDO4qnVkJYYWWgrQ9NdBNfEYcadp+2Iws3eG/dQjFGhX0wz3F0+Yk/DqRAK7kj5i7mIRPCOt+fNBmumA1mIib17eBDHvSWJXGGORlpymWB0whqNYli+Z9UOvNbHZRgUaBblmrVlbnY6DymmeMpERNPdaw8lHT/iHP1ds0XvbI+cU6RwtSHD1w6q1f6x4TPN74aEtmYX4PIIoy2CjKYVbvb5d6idF2c2koicnE5vs94MZCEFheIGc/QbEy+u1GeutU52JJG1pL2uVufalUxe6wWZI0NQ5Vi6fJf+TvisoMAvaDHHNFT8p2hYTmMB3j4wh1A7Mm/hXse+FjNRc55gQ8WrASlK4oSkV7IxCPorENP0BHe76xGw93uhZ7V4HF6/grl6qqlNaDK1FU1NY+sFCtjR1Zo9Wuql6Kck82SYZtkAyB3ceVTKqOm5y1RrKuug4zdvb1dghA/pY8xIh5PlHV4rOxPBEOcVNCZYfr48zlOo0R4vwWhuccdQVcExT62/m22YXmVoirlcYxFmR37cloFdtXRvbf8wjb5A1GEwgolBPs5tclAw5zEI9AGM6las2SZn/YTpGtFUiVcjCfKxw66gHw7PUYW3ZTTKbwXXlu4MRxzixxbb6GtomgGuadz/JNe9lKFAhFVCjYQlttbvok75ori5B+9wb6p3XSEetBWCjiyP6kSt7BX/lwpgCsaqP8AAZ67Isal2j4pvN642/C/Zu+usCutXqwllvQ=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(376002)(396003)(346002)(39860400002)(46966006)(36840700001)(54906003)(110136005)(6666004)(1076003)(47076005)(4326008)(82740400003)(7636003)(186003)(82310400003)(356005)(7416002)(26005)(70586007)(86362001)(7696005)(5660300002)(70206006)(107886003)(478600001)(2906002)(8676002)(36860700001)(316002)(8936002)(36906005)(336012)(2616005)(83380400001)(426003)(36756003)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Aug 2021 14:37:33.8561
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3844a20a-0361-4fa4-eff5-08d9657a612b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT003.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0107
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

