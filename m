Return-Path: <kvm+bounces-39814-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A434CA4B321
	for <lists+kvm@lfdr.de>; Sun,  2 Mar 2025 17:28:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D2D397A5A41
	for <lists+kvm@lfdr.de>; Sun,  2 Mar 2025 16:27:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE31F1E9B26;
	Sun,  2 Mar 2025 16:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="a9WYXCrb"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2085.outbound.protection.outlook.com [40.107.94.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 420AA339A8
	for <kvm@vger.kernel.org>; Sun,  2 Mar 2025 16:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740932880; cv=fail; b=VKOueRhhE1XBqGjZ/zdKoYrvWFcdHrvwle6rHnFxCTvG+IEhZERtnkTWn2FhGUwACCFX9P0iI55lN5i62M2Zr2/RsPPQnbCOZW3R224S+YQrGiL6kfHRsrfVTxMI0tF6A3M6KLKApRPEoIFgFOcH3UTA/aMAGKgH23BWND07u04=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740932880; c=relaxed/simple;
	bh=v3jbDvGiflYinMF/s6sBajN7Qb31K0I5jwRX7mnH8vs=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=sOTl/ZhlnCHmaI1jbNMuauP9uK/I1mqrZ75Vjud90dMj+BUzltdqjDZpRNhpLmsie2at2lPMIN4fPv1XziVti/pBK7WXIgLZMKehaSKrPJihkbJjBhmjdo64ap/EjW6/fdikduhfL3Vjn+7p/+rS1Rc0lSnOYlM/dXggM+3tNBg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=a9WYXCrb; arc=fail smtp.client-ip=40.107.94.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SSbb22ZhiHdp36jOvp90rW/NuSnNuxXXCjmN2jw6/wjvgZZ7YJiFk5tqhs+IIZoZy3mhnLdJ2kipNtv+NP0ewcZY/7OYAlJs/b22huH0gYo9W8N/DkVypu15YxWz0SEVLA/guI/gm+989cQDdMndmbkFv6izip0qBXJNs60euFgCAaz7Vg7kWgW6syqwgSWobnktVqhrK8VnHd23KIw4YCTMcJtrHYrTrNpFXV5qNEGyB1DzuuQ27w3RmCKkR9LR+khwd8MIVUszMm/ybC+8zrrZlkMAc9AVyu+a5ySJ0SiE1CDbj0y+TE3a2jFu1+weqfMBay9MO4i1bN+N6Fn1qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rPr90Wu9jAWdeMSd7miOX1dNVQQOvmRDwxX24Ds12G4=;
 b=ttyibdEx8vdZlliO2fFvQNhLRa997kYvbYfvyrZ90NYYOug4qUAjVJJnkZv7u1z6qawKYVz8L/VJ7SwWJZmJfiegUd0Wo0ZGcH3g8jDJbro+Tz2mr1hbnuJN6k8HZUtWpND2qhE79bBl3oYfBfnZJVFbaXpvm1RetrcHXeUZe565kbSpkOWQcVs4lzzXEc3oWsvLyu5oteZeam2vMM24ZNO55UEoeEBa6af7ZpoBYq/aPAaunNj64H9tpq/4isLBtTjYpGU2uG7x7/t4MGcYbbufX1i6cOtKy8YUn6pK98e3YrmZnp6ppJPNuh05ak0mHHkZdSVxYYUTG4v/lEaRGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rPr90Wu9jAWdeMSd7miOX1dNVQQOvmRDwxX24Ds12G4=;
 b=a9WYXCrbAF6MEAaVu0aOrSLtwxOd4CksAc8j8qBEQvk8sEOWLSI6bWPMdlNKMq5wnnyUNw9soNFazd+wQTBxrrE8wlnsBByQ2/n6n3W5QhDq24abBxOt1vLJU6B86OdbfUsoG0ea1oBnPWp+gQfmTdz/Nnm9sVEPdwirGvnSVmkUVWw22an51iUPF2anhWypjPZk+Fuhk8jSYLdhgEViiK4YjdxEQl7f1OKFjTHU02oYssLTYLDv7OqK6Zhlo7NMtHOq1oaRQP4jcqvu6zUyDgg5PwLdDRZesA9PrCrPUjoLi47iJ2GLo95f0qfPfz+ChYelGUyUiuAdbbV6G1K2DA==
Received: from SJ2PR07CA0024.namprd07.prod.outlook.com (2603:10b6:a03:505::14)
 by DS0PR12MB6607.namprd12.prod.outlook.com (2603:10b6:8:d1::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.23; Sun, 2 Mar
 2025 16:27:53 +0000
Received: from SJ1PEPF000023CE.namprd02.prod.outlook.com
 (2603:10b6:a03:505:cafe::d8) by SJ2PR07CA0024.outlook.office365.com
 (2603:10b6:a03:505::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8489.26 via Frontend Transport; Sun,
 2 Mar 2025 16:27:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SJ1PEPF000023CE.mail.protection.outlook.com (10.167.244.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8489.16 via Frontend Transport; Sun, 2 Mar 2025 16:27:53 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Sun, 2 Mar 2025
 08:27:40 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Sun, 2 Mar
 2025 08:27:40 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.1544.14 via Frontend Transport; Sun, 2 Mar
 2025 08:27:37 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <jgg@nvidia.com>, <mst@redhat.com>
CC: <jasowang@redhat.com>, <kvm@vger.kernel.org>,
	<virtualization@lists.linux-foundation.org>, <parav@nvidia.com>,
	<israelr@nvidia.com>, <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
	<yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V1 vfio] vfio/virtio: Enable support for virtio-block live migration
Date: Sun, 2 Mar 2025 18:27:23 +0200
Message-ID: <20250302162723.82578-1-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF000023CE:EE_|DS0PR12MB6607:EE_
X-MS-Office365-Filtering-Correlation-Id: 78369151-6059-4c8a-c9ee-08dd59a72eda
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|1800799024|36860700013|7053199007|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?StzvfH3LPISLV3EY5lOvSMbQUfswHCidA3nosJLN623kzqYtZxLpOMrsoico?=
 =?us-ascii?Q?EAYaeuZ8L77JhyWruYn+laa62tGo/UqNLopb/s25ghQnYwSmxEU26/KRfmH1?=
 =?us-ascii?Q?QsZCWlP9p7hJ14PyBcfs92whEjJ8SkabM0jVNkNrzgmKa3ldLLQ9Lysr4Gpq?=
 =?us-ascii?Q?wGu4IcnaHjLqKjF3AhfbdLDLJYUXhgLa9958OKjimr4Lad6ewHmPeAJ5e+3I?=
 =?us-ascii?Q?Dur7gulHev97AMv3BP2F9Kr+i6KlXTnYRuH4rgbmlPRuLqxVdB8WWvfx0u+z?=
 =?us-ascii?Q?0sLMlHzQAKn9/5etOW3Wuq9JGvrt9wgeeI6mZOJW4XbKFsFsYYs4k/GsMhxC?=
 =?us-ascii?Q?CEiIqYefWj89D68dBpwpg50vbF7ATEYobrxc/3C3VST9uZXLDbO2LaKkDZb0?=
 =?us-ascii?Q?WiO3hISNjl24fWd3jx630cEg5IBptPupib5o9nhwuHk+HIZQB+XJwHBg0FVq?=
 =?us-ascii?Q?Fx2RvNgiVB5c+AchC1ZD952bCEFrvt4UtTH6ZWwr5z+jLQTrsxFK9WI+6fiu?=
 =?us-ascii?Q?GB7ObPI1pMQOxObsYcXLDyvEhKPjwrUo40g0z/Vn1hI7HlPKM8aZupnvSoTT?=
 =?us-ascii?Q?q7MUEwSkNhBEeeXoPGgahafarldRNzr/Cmlvdaea4RSzJ6NBMLoIht86t7i5?=
 =?us-ascii?Q?zNnw3fId6RNp5Ku4QmjOLptpUZVxcDXuCR7/pRWol/Z1zHInRkGf/uEFksEk?=
 =?us-ascii?Q?qQ8TW2kGT7C7rw7q58E4YAWN4YnG8gMkShZ/F0sVyCyCHC0Sx3VGriNG4RgB?=
 =?us-ascii?Q?KJ5ChzrY2AKADPrrMlbYlZomenOOqOVJHZkPSsc3SjI8Zyxzw0WvIsStp9tD?=
 =?us-ascii?Q?y0EKSr4nB5OE9E50B1Ta+EUNyhhgVCDZLar4NaOcjaYWajYbAvKfIjQu6G45?=
 =?us-ascii?Q?w1ej83LO984zaPMjMSV6lf5lz4KAIDlFDPuQ9wxQ+haIPHiIbuBgpjy+95Ne?=
 =?us-ascii?Q?O/u6u91RPcsDDTkk+h4GM8zBmVaCnt4aOrA2Q8aTwK35d7iexI+8hZhJt/Rt?=
 =?us-ascii?Q?14TaEdRqlCR7yveK9F5mQz206SGDSWmf1CPRQOTaDlveNf2zaKNCkj8qhro6?=
 =?us-ascii?Q?dZzafGcs7G31Jn9ZDg65E7Ph7hvHlW5mjL7a9gOaUu0pNxFFfDeE95YfG5GY?=
 =?us-ascii?Q?LvBXOsRZThRFcMuKwumpbA6mSYLfQSkqfVnaeZWRiSKo/BmhuDVlB/GeSPzJ?=
 =?us-ascii?Q?wJfsYGT0zIXjNhd0j3QanwTBrBVfLbwlTRP4AWCTOFylGlFmx98FqHkVGJXC?=
 =?us-ascii?Q?EgeAhImNSKCXqk9MRxVlgLUcRIThTW9sPr3vY6ciF8rUmBOH4UO55olwQlfU?=
 =?us-ascii?Q?5VsYi0Ig4/+f5MzV3aKyGXOvbpRdQrCkEjggPUEHvVPPDtjN5P52MCf3pEg6?=
 =?us-ascii?Q?b40uTazELyfgXzpZnx6keaAEaiqBDNUcwG54uLP0UBU+E9wmobb12Cm19P9a?=
 =?us-ascii?Q?L9f50/ZnluDv3d5TQHD4ZHvPC7EoCL/gLcczYkfpHr4eH7FZlwNANv8fnpkX?=
 =?us-ascii?Q?legkN5Z6pqAGd2w=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(82310400026)(1800799024)(36860700013)(7053199007)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2025 16:27:53.5729
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 78369151-6059-4c8a-c9ee-08dd59a72eda
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000023CE.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6607

With a functional and tested backend for virtio-block live migration,
add the virtio-block device ID to the pci_device_id table.

Currently, the driver supports legacy IO functionality only for
virtio-net, and it is accounted for in specific parts of the code.

To enforce this limitation, an explicit check for virtio-net, has been
added in virtiovf_support_legacy_io(). Once a backend implements legacy
IO functionality for virtio-block, the necessary support will be added
to the driver, and this additional check should be removed.

The module description was updated accordingly.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
Changes from V0:
https://lore.kernel.org/kvm/20250227155444.57354e74.alex.williamson@redhat.com/T/

- Replace "NET,BLOCK" with "NET and BLOCK" for readability, as was
  suggested by Alex.
- Make the tristate summary more generic as was suggeted by Kevin and
  Alex.
- Add Kevin Tian Reviewed-by clause.

 drivers/vfio/pci/virtio/Kconfig     | 6 +++---
 drivers/vfio/pci/virtio/legacy_io.c | 4 +++-
 drivers/vfio/pci/virtio/main.c      | 5 +++--
 3 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/vfio/pci/virtio/Kconfig b/drivers/vfio/pci/virtio/Kconfig
index 2770f7eb702c..33e04e65bec6 100644
--- a/drivers/vfio/pci/virtio/Kconfig
+++ b/drivers/vfio/pci/virtio/Kconfig
@@ -1,11 +1,11 @@
 # SPDX-License-Identifier: GPL-2.0-only
 config VIRTIO_VFIO_PCI
-	tristate "VFIO support for VIRTIO NET PCI VF devices"
+	tristate "VFIO support for VIRTIO PCI VF devices"
 	depends on VIRTIO_PCI
 	select VFIO_PCI_CORE
 	help
-	  This provides migration support for VIRTIO NET PCI VF devices
-	  using the VFIO framework. Migration support requires the
+	  This provides migration support for VIRTIO NET and BLOCK PCI VF
+	  devices using the VFIO framework. Migration support requires the
 	  SR-IOV PF device to support specific VIRTIO extensions,
 	  otherwise this driver provides no additional functionality
 	  beyond vfio-pci.
diff --git a/drivers/vfio/pci/virtio/legacy_io.c b/drivers/vfio/pci/virtio/legacy_io.c
index 20382ee15fac..832af5ba267c 100644
--- a/drivers/vfio/pci/virtio/legacy_io.c
+++ b/drivers/vfio/pci/virtio/legacy_io.c
@@ -382,7 +382,9 @@ static bool virtiovf_bar0_exists(struct pci_dev *pdev)
 
 bool virtiovf_support_legacy_io(struct pci_dev *pdev)
 {
-	return virtio_pci_admin_has_legacy_io(pdev) && !virtiovf_bar0_exists(pdev);
+	/* For now, the legacy IO functionality is supported only for virtio-net */
+	return pdev->device == 0x1041 && virtio_pci_admin_has_legacy_io(pdev) &&
+	       !virtiovf_bar0_exists(pdev);
 }
 
 int virtiovf_init_legacy_io(struct virtiovf_pci_core_device *virtvdev)
diff --git a/drivers/vfio/pci/virtio/main.c b/drivers/vfio/pci/virtio/main.c
index d534d48c4163..515fe1b9f94d 100644
--- a/drivers/vfio/pci/virtio/main.c
+++ b/drivers/vfio/pci/virtio/main.c
@@ -187,8 +187,9 @@ static void virtiovf_pci_remove(struct pci_dev *pdev)
 }
 
 static const struct pci_device_id virtiovf_pci_table[] = {
-	/* Only virtio-net is supported/tested so far */
+	/* Only virtio-net and virtio-block are supported/tested so far */
 	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_REDHAT_QUMRANET, 0x1041) },
+	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_REDHAT_QUMRANET, 0x1042) },
 	{}
 };
 
@@ -221,4 +222,4 @@ module_pci_driver(virtiovf_pci_driver);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Yishai Hadas <yishaih@nvidia.com>");
 MODULE_DESCRIPTION(
-	"VIRTIO VFIO PCI - User Level meta-driver for VIRTIO NET devices");
+	"VIRTIO VFIO PCI - User Level meta-driver for VIRTIO NET and BLOCK devices");
-- 
2.18.1


