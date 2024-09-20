Return-Path: <kvm+bounces-27229-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 69E9597DA9B
	for <lists+kvm@lfdr.de>; Sat, 21 Sep 2024 00:36:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D08CFB21882
	for <lists+kvm@lfdr.de>; Fri, 20 Sep 2024 22:36:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08AA518E042;
	Fri, 20 Sep 2024 22:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="M5nEo36D"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2046.outbound.protection.outlook.com [40.107.94.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A10ED18DF93;
	Fri, 20 Sep 2024 22:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726871723; cv=fail; b=kPOcVs7fD6ANC8sNdqF0kS4p5SyrPQzavkis7UsAqOr5c8miNvCp370aZmn95+svMCC1YC/Hu3AQ7xiK44GL4EVEMN7/+vHW82AiPgqK5dzy1f9Q8XpGgJPSnQ3Uqb1KH3XjsdGzJobd5GRQTWZxqggnvbKCnVhoaKHAOZquwiY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726871723; c=relaxed/simple;
	bh=9iQqp0Xg16+bvOvxGOUK5RL3LGwnUWpBuuXcFaZe7as=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BfaKSk10UOcpHndtW7lS8jYbyDxHdXbJpNbKtiY7yunI3DdFWHQoQNm1SmtE0NbmIuNTVHMnt1h74J9mGSVfR2ogMDI1vFy2omIkZoVMJd6k/0y1Y7yms1mdJCHzEJVZApf91tYdgu1nYbNDnsHAbGZ2u85cEClmHlhGtZm/XVw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=M5nEo36D; arc=fail smtp.client-ip=40.107.94.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tY1Y6ZQaXQCMWIg3lnHaueLP2NpR0eU7qZPqEFKEzqIdzUAjWiM2hJbdYPYbe/Lhplq+kS8m1P7s4o4+FjaUkOx1zpYdQQWdD1grw2JXUjDH6fcga6myjElrgsYly45GmwyQW5HIW8ncEeMU9OT+cjUMrwhsIq0AuTLtEAUfYwdZtr8bV10/aJ1Bk8MxfZuhj66BFo45Vpi60bfNAiWfeu9eEyuzgS+lRNZEHGAouGxKwTnx+ln5VO9E9+vqBvyQuXoyOUBhEWVYdSWpE19JFFoCwDGD1+1dy1XyQQoUPQL6dnROX4aU3EaNPrRwS1F49zsmJMR1l44PowcAWwLeUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L659QQc2Yqg/ZLysXrPLTj7fZzo3aetDWC8XIgo2i/c=;
 b=L/TJhUC30sn5yP5GqQXqy8sn2Mbfw+CQoUhFyt9acVgXXNEMGKBwnx/TwlRep2p/oKg+FevaVL4ACLIfK+aJkiYp3siosxFcR4zAc/AiS6MvtHp6paq5nr5nHbxd5y0SnghB66/445n16Ps2phCjeoAkAOluWBA/RE2HNmFpcHxgiU4v/tivrfz3j8hpTAK7mf65A/MFLmDTGW1iDaCoALNJJhrf3zi8e8R4ugVV7z+qzDkeK7ebKCiNz8oWUSSjSirqerI4ZW+bLxGPNxjhZSPUQK7Dbyz2DYy2RDr4bfT5Hf7pne6kEyTHo5Dp+ajs+uMnG7exUGt+s2GaB1UmmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L659QQc2Yqg/ZLysXrPLTj7fZzo3aetDWC8XIgo2i/c=;
 b=M5nEo36DmK7I2z7cm/9szHo2/yxK0OGRBvxkCxZe8Bs0Z5TXUvJuustNpevn+NtI9K9cqFaGZdLgpbq3OCLvq4QMvdbEUUzsUZXyIYfDpomhUJmDli9q+1W17PzIP+fuN5zs60kVyZQMa/e1xwFGq60gMSx9X8+ad3X/tEXhHeyUU7Dqz85md08fC+A9xnfExDmPPjrjKq84xWFLWDi/en17VX3OsOWbhCueeNLWNWYOXzGHUs3SUHk9n0pBC/TDKjGAjpX4wMFb9UsSdkHpXnDde1IQsXIRPKaP2ULiUGNMdO05a0ePrWOOhli1rigNv0qAM7/TT73blfPi47DRow==
Received: from MN2PR18CA0024.namprd18.prod.outlook.com (2603:10b6:208:23c::29)
 by PH7PR12MB5903.namprd12.prod.outlook.com (2603:10b6:510:1d7::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.17; Fri, 20 Sep
 2024 22:35:15 +0000
Received: from BL02EPF00029928.namprd02.prod.outlook.com
 (2603:10b6:208:23c:cafe::a8) by MN2PR18CA0024.outlook.office365.com
 (2603:10b6:208:23c::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7849.23 via Frontend
 Transport; Fri, 20 Sep 2024 22:35:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL02EPF00029928.mail.protection.outlook.com (10.167.249.53) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7918.13 via Frontend Transport; Fri, 20 Sep 2024 22:35:14 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 20 Sep
 2024 15:35:00 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 20 Sep
 2024 15:35:00 -0700
Received: from inno-linux.nvidia.com (10.127.8.13) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Fri, 20 Sep 2024 15:34:59 -0700
From: Zhi Wang <zhiw@nvidia.com>
To: <kvm@vger.kernel.org>, <linux-cxl@vger.kernel.org>
CC: <alex.williamson@redhat.com>, <kevin.tian@intel.com>, <jgg@nvidia.com>,
	<alison.schofield@intel.com>, <dan.j.williams@intel.com>,
	<dave.jiang@intel.com>, <dave@stgolabs.net>, <jonathan.cameron@huawei.com>,
	<ira.weiny@intel.com>, <vishal.l.verma@intel.com>, <alucerop@amd.com>,
	<acurrid@nvidia.com>, <cjia@nvidia.com>, <smitra@nvidia.com>,
	<ankita@nvidia.com>, <aniketa@nvidia.com>, <kwankhede@nvidia.com>,
	<targupta@nvidia.com>, <zhiw@nvidia.com>, <zhiwang@kernel.org>
Subject: [RFC 07/13] vfio/cxl: introduce vfio_cxl_core_{read, write}()
Date: Fri, 20 Sep 2024 15:34:40 -0700
Message-ID: <20240920223446.1908673-8-zhiw@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240920223446.1908673-1-zhiw@nvidia.com>
References: <20240920223446.1908673-1-zhiw@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF00029928:EE_|PH7PR12MB5903:EE_
X-MS-Office365-Filtering-Correlation-Id: e77516d8-f883-40b8-a900-08dcd9c47f2a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|36860700013|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?yP/8Bjf9ZzPlcZDrax67rK8qe/WhXEz2m2MHpII7D0n/xzZmjVJiu7y/ViOo?=
 =?us-ascii?Q?2pgBeahLKxyEZzXsxLAlO13tUMn78dLi1cR4Ba54jNlapW+GHMbe+reKmuyo?=
 =?us-ascii?Q?s3zrVT013XoDKPw/366V4+JuRXyClej/hjUmJX5+sMCfbdYEM95uhvYGiJjM?=
 =?us-ascii?Q?+ufW0h/uP309xgn9JTOyIKuMPzlGheJL0Byn+WEnj6LOUSmYk9scFNYfztT1?=
 =?us-ascii?Q?2dm5G+zFScl8jlF+ZuVTUakHL3qTEY/EA+PlK2LABb5/WGPwxq+NFsEMgxGe?=
 =?us-ascii?Q?TDGQlYKywFs0Jhet+uFwmRFVSRslBnIBD6rQhokrNzvqsKRG5gYxM7MxlclV?=
 =?us-ascii?Q?ZzXJ4Wb3oolFj38HsH0jLj2NFWpZFL3VKKTnuRyZXD5svvV1KabA9GwSnsao?=
 =?us-ascii?Q?wE8S5Fqp+NhVbze0bQpKuu6uKYLuVXDAcc7FbcvVBJrtL+wT6EdmO1FKZYFD?=
 =?us-ascii?Q?BquBsqxLFqMYdswnYiYaPIijhRNQFeHyoqfRzn2c3KXxzhGzLuknCk3/HVfz?=
 =?us-ascii?Q?VvqJUc6af84BEyPaBtR1PCc1/KAwYaJ0J00xlOHKPBO8ZzNChrz5Yq61pGu8?=
 =?us-ascii?Q?GRUiYcllodc6hbQQHBwnpMyn7YJJlNaKUtuekIejb+0eWMWKrjaW7XcVgNPT?=
 =?us-ascii?Q?h8/0XbWA1pZSOlzKQArrxlNcsZ/BIUn+B6zoAuTnHgTqi6b+TupKfFX5lEPz?=
 =?us-ascii?Q?wDEfjqhPDXU3X+mZe6WCC8HhxwBIlBMa9OqVQn8/isK4pneCFOHpnR6c5bja?=
 =?us-ascii?Q?rmoCs2Ccl8l1MAZRmETXfsmS9FVhwkLqytD/VPTjUtRmqIDGVd8EUPpXMTBG?=
 =?us-ascii?Q?373oQyaIkTLmXLrvO3kWVOF/SrcTRUCIXAl6MJjOPvQoGaK/LlPPaVlbQqgS?=
 =?us-ascii?Q?sjBhZQzaGBOiRA8mt+gn6dQld3Mr/lVsBfteMufUAXP4KYPntd7Avs5mLhfP?=
 =?us-ascii?Q?2hn7eodAc4TWkgjKvYD4he13V2GkR0dwZPRdbGJMHzLHQFvMnGZjfFGK6Fx+?=
 =?us-ascii?Q?gCd59ZXE25S21ssBmu7l/lHRO3uMPI4G7Wp+VZbkkerGHaXE5ogVLwbT6+Ol?=
 =?us-ascii?Q?625VN/EZp66EUQBMTvekKU1+yy7kU4g4HmJTBjVvy4kGiM1ojuirtWPXgD3n?=
 =?us-ascii?Q?1GARAVHYNIbzEGSl9Id69MJmH/3gFAzg5rUBwdBmfe5HZ6Tkk1xMoh73fLxz?=
 =?us-ascii?Q?6qlmmAo4p+UHwkmMWmTtqe/eQHbO06yuKa4N/uR34sUvG7Bv4wLb8vxP+wo8?=
 =?us-ascii?Q?9wLy7ckci58DHrmvWXUKlhjIBBb1emgDcOA3Pi7KSnZDmOnL0rnQLeJuRpKm?=
 =?us-ascii?Q?5f7RFwJRjuOYj6v6sNp8xgNvh3zoXVkHZTORpfzINq4/60MXJU6oxcy2GdpA?=
 =?us-ascii?Q?ovFc8+03+mjizaOOXre/DjgffV1pltfTqXEYwWj32CxWzm4wE5+Cnyo1gCgT?=
 =?us-ascii?Q?XSn7e4Nr/JeDcq0ABGdI290T2fWoEchN?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(82310400026)(36860700013)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2024 22:35:14.8056
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e77516d8-f883-40b8-a900-08dcd9c47f2a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF00029928.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5903

The read/write callbacks in vfio_device_ops is for accessing the device
when mmap is not support. It is also used for VFIO variant driver to
emulate the device registers.

CXL spec illusrates the standard programming interface, part of them
are MMIO registers sit in a PCI BAR. Some of them are emulated when
passing the CXL type-2 device to the VM. E.g. HDM decoder registers are
emulated.

Introduce vfio_cxl_core_{read, write}() in the vfio-cxl-core to prepare
for emulating the CXL MMIO registers in the PCI BAR.

Signed-off-by: Zhi Wang <zhiw@nvidia.com>
---
 drivers/vfio/pci/vfio_cxl_core.c | 20 ++++++++++++++++++++
 include/linux/vfio_pci_core.h    |  5 +++++
 2 files changed, 25 insertions(+)

diff --git a/drivers/vfio/pci/vfio_cxl_core.c b/drivers/vfio/pci/vfio_cxl_core.c
index ffc15fd94b22..68a935515256 100644
--- a/drivers/vfio/pci/vfio_cxl_core.c
+++ b/drivers/vfio/pci/vfio_cxl_core.c
@@ -396,6 +396,26 @@ void vfio_cxl_core_set_driver_hdm_cap(struct vfio_pci_core_device *core_dev)
 }
 EXPORT_SYMBOL(vfio_cxl_core_set_driver_hdm_cap);
 
+ssize_t vfio_cxl_core_read(struct vfio_device *core_vdev, char __user *buf,
+		size_t count, loff_t *ppos)
+{
+	struct vfio_pci_core_device *vdev =
+		container_of(core_vdev, struct vfio_pci_core_device, vdev);
+
+	return vfio_pci_rw(vdev, buf, count, ppos, false);
+}
+EXPORT_SYMBOL_GPL(vfio_cxl_core_read);
+
+ssize_t vfio_cxl_core_write(struct vfio_device *core_vdev, const char __user *buf,
+		size_t count, loff_t *ppos)
+{
+	struct vfio_pci_core_device *vdev =
+		container_of(core_vdev, struct vfio_pci_core_device, vdev);
+
+	return vfio_pci_rw(vdev, (char __user *)buf, count, ppos, true);
+}
+EXPORT_SYMBOL_GPL(vfio_cxl_core_write);
+
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR(DRIVER_AUTHOR);
 MODULE_DESCRIPTION(DRIVER_DESC);
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index 62fa0f54a567..64ccdcdfa95e 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -199,4 +199,9 @@ void vfio_cxl_core_set_resource(struct vfio_pci_core_device *core_dev,
 void vfio_cxl_core_set_region_size(struct vfio_pci_core_device *core_dev,
 				   u64 size);
 void vfio_cxl_core_set_driver_hdm_cap(struct vfio_pci_core_device *core_dev);
+ssize_t vfio_cxl_core_read(struct vfio_device *core_vdev, char __user *buf,
+			   size_t count, loff_t *ppos);
+ssize_t vfio_cxl_core_write(struct vfio_device *core_vdev, const char __user *buf,
+			    size_t count, loff_t *ppos);
+
 #endif /* VFIO_PCI_CORE_H */
-- 
2.34.1


