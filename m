Return-Path: <kvm+bounces-9176-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0550085BAF2
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 12:51:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 86CCC1F22CF7
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 11:51:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5251967C7A;
	Tue, 20 Feb 2024 11:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="YRbpfjjz"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2058.outbound.protection.outlook.com [40.107.101.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C687667C6F;
	Tue, 20 Feb 2024 11:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708429890; cv=fail; b=BviPxcmZcJBj+lZhlH240675g7oSk6au2M84nD0AiQoqwawRRrnwyjTDD853ykXxVTTe1BzxJekZg2s6RfVM9mNfi/+K0W12+cMsM5u6cLtlu2RseMU9/PWvuZ3AmmYrYBoyTDpzM5MiYvg0aGI+DSBnprNEuqG27Cdlf5s9gBA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708429890; c=relaxed/simple;
	bh=XvckWhUwyDPPhOMwwYQbhXVU6yiXX7O5807MKZ8UUlM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=omDrKTkF5XGgzv7+jw5E1JQx/HXcEmJ5TbJ1l4IHCh+CpW+o3DC26+WylIJbnrwsVLQYksI6wIpiL7BvRLx+gKCujNf8Iu/WN3mTj9Xn5swiOoASPpe1iipo6/ZtBetxFLxK2b88Tswao1dg+L1ZOgZ3/sN81F9jzPX3sw6H1OQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=YRbpfjjz; arc=fail smtp.client-ip=40.107.101.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mDbWAUSBkUUf3itwcEsJRfD4QMNtRnBKE8TlzRny2arrvtmyh6Klai4flSQ1zxsPuSYc2kIhdHM3vZ/3CXmTLdkkPCLBVuoiZtJL6dXbpg8jSk3kTBVdbGB2XOSFqVkXz5KWNtiRgNOmgvqgmsJYD6ZX704wpWriDAsDqj3y7bRYbwoGnY7l7OKLkmnxmoAIU2t29sIrkFqMmRweP64l3o1a0HBCOjIIUbUrZo++Ko4i7Za4bAAxbB/5A2sx8sKrJlT/vo8/b1sxFuYsjcx0MqdVnxLRDOqpbB0nnTYuqVbTYPitzalFE9DZnLk+FgCOepZT8NaiZFz6RxVb4e856w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UtQVIZVSifP8A3bu/r66HL1pX6ik8cJMdrIih4F7BwY=;
 b=DnFDg1F0H7kNOGFzdZCXS1l0t8WNt1i+689oKiQTFURcHfoS+ek3MVWk9kBt4iFFbN/6AZ9VZrGSYMADQQahheQ8cDbKNb1akrl/JYH6LhmvlcOGJSZNaTVc6DQG5yGTRcNZ3rVs929d/euX0kIB2cCxMpXHNAFQ5aXVwnJNbuhwOZoW+LJIypgolrMVgXYzCpWI/bb/he+AZsWvjxlPKAIWMZ9CJe+i7dkhjtfuBkSCZRA/ECJSbzrw7iWpUGc0LK/i+Rb6atQCdwBSAccykg2ku/lnZ5p/myTpvJpr2dMErS+tGlAqMREq3OXBv2FsztwuePd/JgWJG+K/TwJe+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UtQVIZVSifP8A3bu/r66HL1pX6ik8cJMdrIih4F7BwY=;
 b=YRbpfjjzlErM6j80XHxn/9DRHq/ZvAtfd9LiEsyagWDEdRUb6/Sp6zVVdz5sTS5yeyKKqylaGzLgigtWksh8hBDpO3fKh0NtKqeL9oXmmc7HjaB5rF5MpgXQO7FFpzIaEZt52L0K9FHVJqsrAxl4gnc2D+JybNH0qp0py13k2GAj9b+AxzbSEG0kaShxThtadN41JDb4nMLOq2807KrWsRKTjMoF8f95cQIWSLjfGECNV4Va0DjvpStKDV1Z6Z4f57pQoPIm2kFvHgDITXF0/lErRT1pFRTmda6m77UlpnK/2SQZGb6PGyecv0GVmP0UPpqYKUupFgVUjgqqL4EfdQ==
Received: from MW4PR02CA0025.namprd02.prod.outlook.com (2603:10b6:303:16d::11)
 by CH2PR12MB4326.namprd12.prod.outlook.com (2603:10b6:610:af::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.20; Tue, 20 Feb
 2024 11:51:25 +0000
Received: from CO1PEPF000044F5.namprd05.prod.outlook.com
 (2603:10b6:303:16d:cafe::77) by MW4PR02CA0025.outlook.office365.com
 (2603:10b6:303:16d::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.39 via Frontend
 Transport; Tue, 20 Feb 2024 11:51:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CO1PEPF000044F5.mail.protection.outlook.com (10.167.241.75) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7292.25 via Frontend Transport; Tue, 20 Feb 2024 11:51:25 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 20 Feb
 2024 03:51:13 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.12; Tue, 20 Feb 2024 03:51:13 -0800
Received: from sgarnayak-dt.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.12 via Frontend
 Transport; Tue, 20 Feb 2024 03:51:05 -0800
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <jgg@nvidia.com>, <alex.williamson@redhat.com>,
	<yishaih@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
	<kevin.tian@intel.com>, <mst@redhat.com>, <eric.auger@redhat.com>,
	<jgg@ziepe.ca>, <oleksandr@natalenko.name>, <clg@redhat.com>,
	<satyanarayana.k.v.p@intel.com>, <brett.creeley@amd.com>, <horms@kernel.org>,
	<shannon.nelson@amd.com>, <rrameshbabu@nvidia.com>, <zhiw@nvidia.com>
CC: <aniketa@nvidia.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
	<targupta@nvidia.com>, <vsethi@nvidia.com>, <acurrid@nvidia.com>,
	<apopple@nvidia.com>, <jhubbard@nvidia.com>, <danw@nvidia.com>,
	<anuaggarwal@nvidia.com>, <mochs@nvidia.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <virtualization@lists.linux-foundation.org>
Subject: [PATCH v19 1/3] vfio/pci: rename and export do_io_rw()
Date: Tue, 20 Feb 2024 17:20:53 +0530
Message-ID: <20240220115055.23546-2-ankita@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20240220115055.23546-1-ankita@nvidia.com>
References: <20240220115055.23546-1-ankita@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000044F5:EE_|CH2PR12MB4326:EE_
X-MS-Office365-Filtering-Correlation-Id: 3142ab28-c97b-435f-07cf-08dc320a4460
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	MCZhJwkQLw21wbJsOyI5OaN9hxBmbqEFJDQXQvtUh+lhgKK6Fiu7Xi2bwtcJqaVN+LWYmpZUp/dMfQUiBWDtXzuGUUxCYr6YGedz66HoFGlU+gW7H5SsT6x/K7KCb+4PslD7nWDjcEqze9VNdwHfijAGiV3nzJ9Jr7Xvdwz9kAYaGH4uDEKowH8DFKzpuEchJ3KmTwVr9X35Nj8n3clFcLQNZ/gF7JiynGD3FECfCHCofiy9JfWsDVjelcC635j8DsxYV+B9RFqycHWPZnJDxCEcnOl98OetgNg37ewq2MfrhLe/YKhHJR0q8MvkZphqz3VZ+nMfQjMF9/TTqdrZvDLDZl67xTlgMwEHAs5UgbTJY5xiEg7ZP0UEkWXsfWkW6aJofKh90Cj7gPew0mHbr7qPYyeVtL70Zv0FR2VYxNyP68/bLEhULPrCcr9uc4kg4oLSq9J5rXtpXYFJQ+gDzq4sRU41XQ61lXiq/ZUXskjowkNB/wOYa+HBVUQ8ViBay9oA7K3w30gNxSutwlQqzS2gGUQOZXEvtHAtqZ9NBDXdT5oUm5pNaQGG65jhrPfaJ6UZpWrJwygsxQ37AQ7mnMT/+9ZsbVop0MPV0z/icBqPEwTyvUWmeRj5Vm56xqxhUg/C7snESIww9sguNEl69guICtgK4zZXDaBrnT9cX6w=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230031)(36860700004)(46966006)(40470700004)(921011);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2024 11:51:25.7036
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3142ab28-c97b-435f-07cf-08dc320a4460
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044F5.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4326

From: Ankit Agrawal <ankita@nvidia.com>

do_io_rw() is used to read/write to the device MMIO. The grace hopper
VFIO PCI variant driver require this functionality to read/write to
its memory.

Rename this as vfio_pci_core functions and export as GPL.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Yishai Hadas <yishaih@nvidia.com>
Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_rdwr.c | 16 +++++++++-------
 include/linux/vfio_pci_core.h    |  5 ++++-
 2 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci_rdwr.c
index 07fea08ea8a2..03b8f7ada1ac 100644
--- a/drivers/vfio/pci/vfio_pci_rdwr.c
+++ b/drivers/vfio/pci/vfio_pci_rdwr.c
@@ -96,10 +96,10 @@ VFIO_IOREAD(32)
  * reads with -1.  This is intended for handling MSI-X vector tables and
  * leftover space for ROM BARs.
  */
-static ssize_t do_io_rw(struct vfio_pci_core_device *vdev, bool test_mem,
-			void __iomem *io, char __user *buf,
-			loff_t off, size_t count, size_t x_start,
-			size_t x_end, bool iswrite)
+ssize_t vfio_pci_core_do_io_rw(struct vfio_pci_core_device *vdev, bool test_mem,
+			       void __iomem *io, char __user *buf,
+			       loff_t off, size_t count, size_t x_start,
+			       size_t x_end, bool iswrite)
 {
 	ssize_t done = 0;
 	int ret;
@@ -201,6 +201,7 @@ static ssize_t do_io_rw(struct vfio_pci_core_device *vdev, bool test_mem,
 
 	return done;
 }
+EXPORT_SYMBOL_GPL(vfio_pci_core_do_io_rw);
 
 int vfio_pci_core_setup_barmap(struct vfio_pci_core_device *vdev, int bar)
 {
@@ -279,8 +280,8 @@ ssize_t vfio_pci_bar_rw(struct vfio_pci_core_device *vdev, char __user *buf,
 		x_end = vdev->msix_offset + vdev->msix_size;
 	}
 
-	done = do_io_rw(vdev, res->flags & IORESOURCE_MEM, io, buf, pos,
-			count, x_start, x_end, iswrite);
+	done = vfio_pci_core_do_io_rw(vdev, res->flags & IORESOURCE_MEM, io, buf, pos,
+				      count, x_start, x_end, iswrite);
 
 	if (done >= 0)
 		*ppos += done;
@@ -348,7 +349,8 @@ ssize_t vfio_pci_vga_rw(struct vfio_pci_core_device *vdev, char __user *buf,
 	 * probing, so we don't currently worry about access in relation
 	 * to the memory enable bit in the command register.
 	 */
-	done = do_io_rw(vdev, false, iomem, buf, off, count, 0, 0, iswrite);
+	done = vfio_pci_core_do_io_rw(vdev, false, iomem, buf, off, count,
+				      0, 0, iswrite);
 
 	vga_put(vdev->pdev, rsrc);
 
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index 85e84b92751b..cf9480a31f3e 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -130,7 +130,10 @@ void vfio_pci_core_finish_enable(struct vfio_pci_core_device *vdev);
 int vfio_pci_core_setup_barmap(struct vfio_pci_core_device *vdev, int bar);
 pci_ers_result_t vfio_pci_core_aer_err_detected(struct pci_dev *pdev,
 						pci_channel_state_t state);
-
+ssize_t vfio_pci_core_do_io_rw(struct vfio_pci_core_device *vdev, bool test_mem,
+			       void __iomem *io, char __user *buf,
+			       loff_t off, size_t count, size_t x_start,
+			       size_t x_end, bool iswrite);
 #define VFIO_IOWRITE_DECLATION(size) \
 int vfio_pci_core_iowrite##size(struct vfio_pci_core_device *vdev,	\
 			bool test_mem, u##size val, void __iomem *io);
-- 
2.34.1


