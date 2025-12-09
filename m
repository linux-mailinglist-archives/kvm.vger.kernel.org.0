Return-Path: <kvm+bounces-65561-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B6A6CCB0A61
	for <lists+kvm@lfdr.de>; Tue, 09 Dec 2025 17:57:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5B58E3143461
	for <lists+kvm@lfdr.de>; Tue,  9 Dec 2025 16:51:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A760327CCF2;
	Tue,  9 Dec 2025 16:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="pWt4GTeM"
X-Original-To: kvm@vger.kernel.org
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011041.outbound.protection.outlook.com [52.101.52.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6AD827815D;
	Tue,  9 Dec 2025 16:51:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765299103; cv=fail; b=pfapqOGQiMPg8w5mySKm3L5Sh1GOrlvu/YJNb6463eMnKvJ4vzK4HtEeUwkxeacN3rD9oANiATIpI9wNaKjBLMgFmSLWm7umgCYONCc7Q1roaihf/RKI7wvBoMQnAJMAiQqx6b/RyjgdzQyEZKXiI5JL6VvbOuXhzhP53uVuPkk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765299103; c=relaxed/simple;
	bh=UXIvMa0drT7HaL2qWubLLuMRZyspCFAGLd9wowG5U+k=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QkVsEtH4e+4Pu3BykpwepwnYUVqpJlztwMtC6ASpPQEdimIOJGCR0H7V0uVEMgTLRzDtPDieNHaR9v9vRigMsfXYXBzwmoxnCXnwxBgUEke+6ibmfRpcKypG6meH9Dupi+ECBf1Sf5eGYC0pZ1DEUzujTNuz/mSeEkhuXm4oFlU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=pWt4GTeM; arc=fail smtp.client-ip=52.101.52.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=URYB77LgiuLoW/I4feri+gg9Vd+buTD0ekJ/ih118NNpB2+SQ3FHmW5GEHZF8t2PRgQuujhPjcS83wuR40ZIGuhw5blrd30wD4y6CNca/0nf1QogYE/Ba5fdA0pNTY8Gt7EirXLKKFmFwoJwam18aFaq8IJ7osatPby+0Z4KtOTtBgJ3nHXUQckgsdI6dc7VNuGqKh4sMXiShTFIbill8q5uEn7oO12eMoirGkvJ9gK+qL0+ZPdwbmld8qS5eP57orVK9ccknu7d9irEujaT4PLBgq+Vp6dG/KBSl1NhAucGe8w/USZ2w/w2OZM1FP+NATQU321SJyIkcjcZ/bTJAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CbiHONk6rsIkLaUqeO1AhigTqTnAQrZFa43wA14OV1Y=;
 b=ls2ZC9XmG8B3tPuZPGwmX1CFX/uw4qWpAXumo2Tjl+1g3G+VeAGMQwKvEQXJejBVxhpxkPJlhtb+Q5+dU5L5KdImBAsD7NCe9mXhQLQqo6FC1rQEeQaViELLx2XwIk16+xbdwRwEvMes59OJR9ibyHfEb0WoP3jtmmR41OCPfvTewgMowvz72R+Rxo/VMsWA0iKCnqmHWhRc/8JuakfzcCFIunTW6BHaPoPEQ4Rgl7Wdi3TSsuYZ4wbLmwIWlqY3BPHpGuBCz469muhn8BLjs2VLyN5F9oIBdPxMpvLxPH11F/kRFhkxTIyywUQHNGyaMXtJYp1HXnmUbV8zqLFv9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CbiHONk6rsIkLaUqeO1AhigTqTnAQrZFa43wA14OV1Y=;
 b=pWt4GTeMHuKozvAS3cUmbONsRzqYxS8o6waGALbkJ18Fu/vVhzGlDuTG09NYkDx1IVdSjpzChbvNZJpwiSOYXik78FgrouDjDMztIKl+O05ySFSybPAa7lnO+/bynEOSsqaJbWUW5jLwdLsEA0aYmQ8BFJ0s7PCorZwcszR5mC3dl6suh71O/Fu9J7E0aCKia4M5fQkyjKambjRF5KEoloLCdptUP6Q1loiFX0K8AoDtnLbErBAeD/tPbKAO9FzK0aDbAswlB0K8or2xyyTzu9ymxfm92qShtMHIMpQc0fb9CoKShQw+Pc7TzebGwqryW3IzuS6OP4WloVOhqlX57g==
Received: from SJ0PR13CA0198.namprd13.prod.outlook.com (2603:10b6:a03:2c3::23)
 by DM6PR12MB4433.namprd12.prod.outlook.com (2603:10b6:5:2a1::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.7; Tue, 9 Dec
 2025 16:51:35 +0000
Received: from SJ1PEPF00002317.namprd03.prod.outlook.com
 (2603:10b6:a03:2c3:cafe::a6) by SJ0PR13CA0198.outlook.office365.com
 (2603:10b6:a03:2c3::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.6 via Frontend Transport; Tue, 9
 Dec 2025 16:51:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SJ1PEPF00002317.mail.protection.outlook.com (10.167.242.171) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9388.8 via Frontend Transport; Tue, 9 Dec 2025 16:51:34 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 9 Dec
 2025 08:51:12 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 9 Dec
 2025 08:51:11 -0800
Received: from nvidia-4028GR-scsim.nvidia.com (10.127.8.11) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Tue, 9 Dec 2025 08:51:04 -0800
From: <mhonap@nvidia.com>
To: <aniketa@nvidia.com>, <ankita@nvidia.com>, <alwilliamson@nvidia.com>,
	<vsethi@nvidia.com>, <jgg@nvidia.com>, <mochs@nvidia.com>,
	<skolothumtho@nvidia.com>, <alejandro.lucero-palau@amd.com>,
	<dave@stgolabs.net>, <jonathan.cameron@huawei.com>, <dave.jiang@intel.com>,
	<alison.schofield@intel.com>, <vishal.l.verma@intel.com>,
	<ira.weiny@intel.com>, <dan.j.williams@intel.com>, <jgg@ziepe.ca>,
	<yishaih@nvidia.com>, <kevin.tian@intel.com>
CC: <cjia@nvidia.com>, <kwankhede@nvidia.com>, <targupta@nvidia.com>,
	<zhiw@nvidia.com>, <kjaju@nvidia.com>, <linux-kernel@vger.kernel.org>,
	<linux-cxl@vger.kernel.org>, <kvm@vger.kernel.org>, <mhonap@nvidia.com>
Subject: [RFC v2 03/15] cxl: introduce cxl_find_comp_reglock_offset()
Date: Tue, 9 Dec 2025 22:20:07 +0530
Message-ID: <20251209165019.2643142-4-mhonap@nvidia.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20251209165019.2643142-1-mhonap@nvidia.com>
References: <20251209165019.2643142-1-mhonap@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002317:EE_|DM6PR12MB4433:EE_
X-MS-Office365-Filtering-Correlation-Id: bb8f11f1-2d9b-442b-9823-08de37433694
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|36860700013|82310400026|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?XvZS2iIGp/9mc5akGjw+MVa03Gnqp3Ee21ww9M1xdOaG0FVA/YdE4FLC0gH6?=
 =?us-ascii?Q?EAQkhelLgoIJnUCQQ6QHMUADPZdrgDA8AHFwMzY3j7iPS4eRmUhEF1JipfAz?=
 =?us-ascii?Q?yheYKAwNPWQs/Iq1MpVD4Gyr9FJhq8MrITbHqX18XukaOKsvGA7+Kq66CnRO?=
 =?us-ascii?Q?gTm2JlJOeV3k+D9gqJrhHhODj2ax/Jnu6OtB7crhvmXbJAwmTTzpeoQk0zDE?=
 =?us-ascii?Q?Qtt0r8FBxuH5Rr2MDQoxycQWBgiLOH4hVZaPetW298y8+y6dWhW8McinAcUV?=
 =?us-ascii?Q?kYRiCqB2bbs5J5MH5O/5blMdq1oY9t+USEX5lpqNIv5tOldaXXzYV3+TokuG?=
 =?us-ascii?Q?6l0HCsUlDaoMK5KaFbdv5CCMIQZPDu07R5+UZ7OJaZyI6xmwdJiMPDIgtP7k?=
 =?us-ascii?Q?cuO37AOl8HLHlBntXeS/XPrt9lb84D6x7r882S7Ibizfl3nBJsSpKI+8lc+1?=
 =?us-ascii?Q?tw66HgDUStrPczrEQsCEO7RtzxDLqLh4FRQiYg9Yqol/QPdfeDoKOET1lED8?=
 =?us-ascii?Q?89KsxTyrNROR0tfIgbLbEjMBrCpyuE+L4/xbme/0VmEJnm7YqW5vVXLq4Xuz?=
 =?us-ascii?Q?wf5WdPJ/F0nCeJGS1wgvXtiiM4hT+UyvJdFZDgmbjSn8/IeTEAk2WrfvjTrS?=
 =?us-ascii?Q?bKApxsBPzEIoPKW1f2SoVyMBUXZ1tOwjUZqeD7RbsA/wbgowvJu5oUbl9Hdi?=
 =?us-ascii?Q?SOngSySSO06vF3y68hr7UN21rucVGyPCFRMoPTRPtJTqcSQWA7uWKyUXewJr?=
 =?us-ascii?Q?5K+8tR4uP6mPpbre83GbGBRHOzRII+76/UC2qCV8OStsAKJdvgpk41gESOu5?=
 =?us-ascii?Q?zP0kSUEFjMkv6G1PAqVFDWd+hzHWyo8KSW4MOYtx2rFu67U+lnr8Cigh8m95?=
 =?us-ascii?Q?qlbBpIgKRuu8UJDY05fTNo5a4LiOPeNwZ3+5R97h9bnhRTJ/+j3ZMKNxZ5p3?=
 =?us-ascii?Q?YfW/74QKVVz1RKlX6O9nB6+oo/mrTG7rFuTvJH7x92lvft7bzr93DbNTelD5?=
 =?us-ascii?Q?lwlNd7aeZ/eQ5hYh7Htwfv2KsKLK7WIWSsCI/2cVyumkvfyr7WgoXQ6ttE7O?=
 =?us-ascii?Q?57UKBoQ65hQNmw00ejIqwez2hdGs6XuUGXHrkDrfo7Oi9wyR7trXphQLa7fE?=
 =?us-ascii?Q?6feJFzW+3On/y/uxRWeBN/y/BoAiA3nz6+kqol9WOwrmlOpUMH1FZSG1FuZH?=
 =?us-ascii?Q?hF9LTimY9FR4s4FArE9CGEmnuwOlDVZg++SLIkTA/4RU0oOw2heZHsdxMs/T?=
 =?us-ascii?Q?79BtSM6xLKtiOLWZVyUndPpw9a9Ixh9RggDsfce6fYyzUzIRgWkjG2bjhBrp?=
 =?us-ascii?Q?4AKa579D2MUatH5yQwjHGVlZxD+EOqXuT5/iXCx+Be1iKIs9Eve9nD8s3M0G?=
 =?us-ascii?Q?EhsRUvBWJRAvZSrHzYu3qwyroEkIpx50Gd6kSZvjmD436ZGWeCoemfSoFM/0?=
 =?us-ascii?Q?ToHw62ZMxKY+NprfX+V5lT05fWWKCYf7uSc1i/X2IXFaG6IxGPNLbO9JXtcy?=
 =?us-ascii?Q?AJAtH2GKlNFe5PxsjN9rmlBlcvaEMPXu4VCfdH7kMzWKP82wy7OeH8f8iNzH?=
 =?us-ascii?Q?A+g3peysew1vj1k5Hpz9dqBgNi+O9QY+joNPGZ/t?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(36860700013)(82310400026)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2025 16:51:34.9857
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bb8f11f1-2d9b-442b-9823-08de37433694
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002317.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4433

From: Zhi Wang <zhiw@nvidia.com>

CXL core has the information of what CXL register groups a device
has.When initializing the device, the CXL core probes the register
groups and saves the information. The probing sequence is quite
complicated.

vfio-cxl needs to handle the CXL MMIO BAR specially. E.g. emulate
the HDM decoder register inside the component registers. Thus it
requires to know the offset of the CXL component register to locate
the PCI BAR where the component register sits.

Introduce cxl_find_comp_regblock_offset() for vfio-cxl to leverage the
register information in the CXL core. Thus, it doesn't need to
implement its own probing sequence.

Signed-off-by: Zhi Wang <zhiw@nvidia.com>
Signed-off-by: Manish Honap <mhonap@nvidia.com>
---
 drivers/cxl/core/regs.c | 22 ++++++++++++++++++++++
 include/cxl/cxl.h       |  2 ++
 2 files changed, 24 insertions(+)

diff --git a/drivers/cxl/core/regs.c b/drivers/cxl/core/regs.c
index dcf444f1fe48..c5f31627fa20 100644
--- a/drivers/cxl/core/regs.c
+++ b/drivers/cxl/core/regs.c
@@ -345,6 +345,28 @@ static int __cxl_find_regblock_instance(struct pci_dev *pdev, enum cxl_regloc_ty
 	return -ENODEV;
 }
 
+/**
+ * cxl_find_comp_regblock_offset() - Locate the offset of component
+ * register blocks
+ * @pdev: The CXL PCI device to enumerate.
+ * @offset: Enumeration output, clobbered on error
+ *
+ * Return: 0 if register block enumerated, negative error code otherwise
+ */
+int cxl_find_comp_regblock_offset(struct pci_dev *pdev, u64 *offset)
+{
+	struct cxl_register_map map;
+	int ret;
+
+	ret = cxl_find_regblock(pdev, CXL_REGLOC_RBI_COMPONENT, &map);
+	if (ret)
+		return ret;
+
+	*offset = map.resource;
+	return 0;
+}
+EXPORT_SYMBOL_NS_GPL(cxl_find_comp_regblock_offset, "CXL");
+
 /**
  * cxl_find_regblock_instance() - Locate a register block by type / index
  * @pdev: The CXL PCI device to enumerate.
diff --git a/include/cxl/cxl.h b/include/cxl/cxl.h
index d84405afc72e..28a39bfd74bc 100644
--- a/include/cxl/cxl.h
+++ b/include/cxl/cxl.h
@@ -7,6 +7,7 @@
 
 #include <linux/node.h>
 #include <linux/ioport.h>
+#include <linux/pci.h>
 #include <linux/range.h>
 #include <cxl/mailbox.h>
 
@@ -292,5 +293,6 @@ int cxl_get_region_range(struct cxl_region *region, struct range *range);
 
 int cxl_get_hdm_reg_info(struct cxl_dev_state *cxlds, u64 *count, u64 *offset,
 			 u64 *size);
+int cxl_find_comp_regblock_offset(struct pci_dev *pdev, u64 *offset);
 
 #endif /* __CXL_CXL_H__ */
-- 
2.25.1


