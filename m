Return-Path: <kvm+bounces-27232-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3383D97DA9F
	for <lists+kvm@lfdr.de>; Sat, 21 Sep 2024 00:36:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5674D1C21011
	for <lists+kvm@lfdr.de>; Fri, 20 Sep 2024 22:36:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E716818E361;
	Fri, 20 Sep 2024 22:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="KIYz1VNm"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2063.outbound.protection.outlook.com [40.107.92.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7504618CC00;
	Fri, 20 Sep 2024 22:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726871731; cv=fail; b=cq9fKDTDLnwG1PNO9vjwTOHLi+dZH5smN5pKWvAA+3xdVatN+920TL8o6OIIk1SaTAI2As88lRjfmcirsKGv/ZEiaP8j9PqkGvzb+QdL581oVFtCErNIRmO3ZLo0WY8ZDQA2zRxwilu9U25MI3iUR9Wh24O/QoVMvqB2fdc0xO4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726871731; c=relaxed/simple;
	bh=S9seR/d0SVyLFTzT31jY9HV1U2jInepA0Tm4eCjUG8k=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sMUAyiiD2nqYnhmsSV1/nSWj0IFCdwImD9VMqb5N/1apM16lBSSMZoJZLcxHqtd74t4hg0iyxfwsifwKB86np1GmUsYsYWy1Fnt2Do56vpDvbzTRdinl8aE03k5D1i6FPN8T8JJTOf8WntVDsRdg5Ck0AkvSbN5Z5lrbbc6YeZs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=KIYz1VNm; arc=fail smtp.client-ip=40.107.92.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=v2M8KsSMJtk8Kd+sICVEelvvH89ks0BFHJ3wE9mxuzJoyFfZh7Yo6/yPxd5x6evd0AlOTslPvA3AGHEire12Xkp6ljdKrObFcRafIiRJSL2XF+Z5FlyJff+99W/imknH1+UESYCnZgXessvVPk+pV94eBoyiuIBknpEyPRJT5F/BYIjqZCtM2KBvJUWWqxkH25ePsKqMkPIZ+QhoCCJHT6w2GWzbK1nl2d5z2OHTgY4GU5wYBnBUewhZZJE/gJ74Desp/Cf2HHu1dOhvV7QkDlfvL/TbTjkzYAjsuGu3K/DFx6nNhNp3mCLoLpIOusSq0GM58pdOwX7iZ3CC5U5a1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eGUDSrJQe9VV7/IpqIXRQO7ulPicSS7l9Z3LgxEvO7o=;
 b=iXiEaEagujTff4Cv/uAQCJjc1jvCGgdeXDOAbtebkAcAXySgdoWfTFfMpJj2uNXZDH0CR9gk+aS/5UiCR1YeO+xS07omwylL/mvdcj4G8BMqMpfXn5frmD3lxORPzMwbnX9ZX5Wa8gyFu0MY6/DwWOxkIMrhjuTfdBOWChlQG1F0O1lpvCKgtZPVEsiblmWiyf07kMLeeaA+LWXRaa6v8x6KAmYN2GM0I8IOgYPo9w8wwqmnB2O/CiHZkcFvShw7lfB2vIk5PMMpy/MRAWt3kTld1yO9DAwflGj8Pd4dZKGqurqJQfOTqFvfBRHKQdcngjuj+0iLjTyTzhtOd4XbFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eGUDSrJQe9VV7/IpqIXRQO7ulPicSS7l9Z3LgxEvO7o=;
 b=KIYz1VNmi99dGUBMHwcGf4/1JQ86eJYLM5WZOQHZ1qWPHVjepEtG+KecKaWuzu4Mu3A3AADcHPPeDyBFN81kEyg8FNKZeXPEpxvSWinOoaj6PL6+/tm7E4CsbqG+oPPUIbaI4PNlNygPWBaiohD3jpEeD8Nplk74porUfALGsaIH4usvNbg2FGzGT71ABN2463v2nqF34IouBKEfzZKpQP+S6Vk+tTr62QFH+tZXDXBZcoAhoz1HBQ78zsXXkhj5bfjwLUwPRvaXKzCpcARmrlqW0YYaQ6vPBvTV4eSzifN6Eprk0aSAkaUg+80ipIyXFzbvqJqNFeAjLkgo/kr32A==
Received: from BN9PR03CA0688.namprd03.prod.outlook.com (2603:10b6:408:10e::33)
 by SN7PR12MB7452.namprd12.prod.outlook.com (2603:10b6:806:299::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.21; Fri, 20 Sep
 2024 22:35:24 +0000
Received: from BL02EPF0002992A.namprd02.prod.outlook.com
 (2603:10b6:408:10e:cafe::a) by BN9PR03CA0688.outlook.office365.com
 (2603:10b6:408:10e::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.29 via Frontend
 Transport; Fri, 20 Sep 2024 22:35:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL02EPF0002992A.mail.protection.outlook.com (10.167.249.55) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7918.13 via Frontend Transport; Fri, 20 Sep 2024 22:35:24 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 20 Sep
 2024 15:35:08 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 20 Sep
 2024 15:35:07 -0700
Received: from inno-linux.nvidia.com (10.127.8.13) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Fri, 20 Sep 2024 15:35:06 -0700
From: Zhi Wang <zhiw@nvidia.com>
To: <kvm@vger.kernel.org>, <linux-cxl@vger.kernel.org>
CC: <alex.williamson@redhat.com>, <kevin.tian@intel.com>, <jgg@nvidia.com>,
	<alison.schofield@intel.com>, <dan.j.williams@intel.com>,
	<dave.jiang@intel.com>, <dave@stgolabs.net>, <jonathan.cameron@huawei.com>,
	<ira.weiny@intel.com>, <vishal.l.verma@intel.com>, <alucerop@amd.com>,
	<acurrid@nvidia.com>, <cjia@nvidia.com>, <smitra@nvidia.com>,
	<ankita@nvidia.com>, <aniketa@nvidia.com>, <kwankhede@nvidia.com>,
	<targupta@nvidia.com>, <zhiw@nvidia.com>, <zhiwang@kernel.org>
Subject: [RFC 13/13] vfio/cxl: workaround: don't take resource region when cxl is enabled.
Date: Fri, 20 Sep 2024 15:34:46 -0700
Message-ID: <20240920223446.1908673-14-zhiw@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF0002992A:EE_|SN7PR12MB7452:EE_
X-MS-Office365-Filtering-Correlation-Id: e5f1de34-add2-4b63-f95b-08dcd9c484f4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?x1oK/IPxaSt6TbWzlRCmcv7HmXJO37cZsmpJWYkvk1QJmyr4m5mykTbp5mXk?=
 =?us-ascii?Q?YID+JLhU3pfY3dbW4JUVcN211+ytJFwFPPMNMlZNzZsdxwRvQPmk+ECXQp1F?=
 =?us-ascii?Q?AD0LEsGdmCDIR6NT9xxhyABq4TcqstpzSlMS8Qqk6a1QRlHZgqEhpfHr+lHa?=
 =?us-ascii?Q?09tYdTxq1Yd5NWg/56MQozFsN76Q2hajikqGR24Y5Vz2+9mig7qGDkBVOLmt?=
 =?us-ascii?Q?+70G6s82zpmy1qAJQroUtFMDjKo1kGJu//RAuA0fBCD1GBqkGcqgmYxidAPX?=
 =?us-ascii?Q?zqxpYh1Zp9/s4qo6YMWa/XF3d5e7XuNYSRSKlLbMicTZtolBNlGFt2KsAu+q?=
 =?us-ascii?Q?N8T7XZ+9tRGRH1MpBW/Ai1xUeMoLu0EW8PQxdOBzyPWXG51H2wY8mfy54f+b?=
 =?us-ascii?Q?MLFrP/95XW+XtCdJAxjKPPc8pxm1bZAvCdJw+tcElXhzIbS/PeFx4M6j3wSP?=
 =?us-ascii?Q?FeEwGQknIWNLEXq6PKXJio4Kr84Kznc5S+5rsURt6zurXOLeayyOuITDSuvH?=
 =?us-ascii?Q?rF8OEH4qs9UWV164WVE+ZtqKQsLbb4YLF0wobPjBZ3tY3N1FVOl/5cqu3uXm?=
 =?us-ascii?Q?lY2Dtw85Ulmtt0oGoE2cVs5oedWtKXoySNH/CFL4YhahV+yPEYWEo0I+aHO3?=
 =?us-ascii?Q?xEwAmEiE0d6RtTCjvoVaTXzu9UuJfcfPYy9bpxyl5Ft/En62p3GiGB9jGUhn?=
 =?us-ascii?Q?rrEM6rHrYtOAqUep8zanD68xFCRGVaZSc0Y0SaV9aoBQv+e5VyO3wAlLgEWS?=
 =?us-ascii?Q?Ju4JJS0chIWUCCo4C8rhG9VJ64nkrMG7C5UIH/0JU91o/OW96Ctu+ATSSCJD?=
 =?us-ascii?Q?t4Qt/spXMKauokT4yuhygqKpD0nOJzhzz6bP3BSqLPuWjAxZIsq4jMCy0tYC?=
 =?us-ascii?Q?SY50fatqhOcSXvWEcWPDoWi/QTUZMxS0b4MJPVHDG2lngSEmARq8OBCW7WH7?=
 =?us-ascii?Q?nXItSideraBVqebQfANw/xEYbvhv2H54GsveqA8dgbXOR6yTGZPYFTsigpq8?=
 =?us-ascii?Q?qifqckU6JAKKzoiVWLXia91hkZhM03U8S48P9XMfzWpVsTNibOwBLVzTVYmc?=
 =?us-ascii?Q?v8XPTPrIK+UNKQgk3Ff9ElBu/2Vv2afyX+ZJXWoPSWzxXWsWari2zk5AKuIY?=
 =?us-ascii?Q?EorOC2sM0u5mymFKJgELjz505AOPanNW+Io2AN4lz88bZBhyGABdYZ/QA6J1?=
 =?us-ascii?Q?IZwzFJcvS+pmRsO0vKeM5uxy2BVYQrumLp+gmWUHDOxaMn2KCw9mJSCJyOQQ?=
 =?us-ascii?Q?v86vdzbnGmAnby/M4qmxSLhsrX79cenrKpi4Wz8LVF9aAKl4OoElC3X6WWiK?=
 =?us-ascii?Q?hZuBMNAFpBR5sRXz2VxkAuwViGM5QPzyrFtJzz1BX70NAhJkzUDHvriHSApX?=
 =?us-ascii?Q?ZSyn7CiosieIE+/7t55A+LzW2oswNl5UHGEE1H/KXv/kGVs3c0kYcXzq9Qid?=
 =?us-ascii?Q?46j9G2RluQCpmFDCbiG5PewKvs8bQo6F?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2024 22:35:24.5044
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e5f1de34-add2-4b63-f95b-08dcd9c484f4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0002992A.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7452

Looking for a better suggestion here.

vfio-cxl-core uses the kernel CXL core to initialize the CXL device
and the kernel CXL core has requested the resource regions when accessing
the PCI BARs. Thus, requesting resource region in vfio-pci-core always
fails.

Signed-off-by: Zhi Wang <zhiw@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 15 +++++++++------
 drivers/vfio/pci/vfio_pci_rdwr.c |  8 +++++---
 2 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 47e65e28a42b..91f8b984b53c 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -633,7 +633,8 @@ void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)
 		if (!vdev->barmap[bar])
 			continue;
 		pci_iounmap(pdev, vdev->barmap[bar]);
-		pci_release_selected_regions(pdev, 1 << bar);
+		if (!vdev->has_cxl)
+			pci_release_selected_regions(pdev, 1 << bar);
 		vdev->barmap[bar] = NULL;
 	}
 
@@ -1775,13 +1776,15 @@ int vfio_pci_core_mmap(struct vfio_device *core_vdev, struct vm_area_struct *vma
 	 * we need to request the region and the barmap tracks that.
 	 */
 	if (!vdev->barmap[index]) {
-		ret = pci_request_selected_regions(pdev,
-						   1 << index, "vfio-pci");
-		if (ret)
-			return ret;
+		if (!vdev->has_cxl) {
+			ret = pci_request_selected_regions(pdev,
+					1 << index, "vfio-pci");
+			if (ret)
+				return ret;
+		}
 
 		vdev->barmap[index] = pci_iomap(pdev, index, 0);
-		if (!vdev->barmap[index]) {
+		if (!vdev->barmap[index] && !vdev->has_cxl) {
 			pci_release_selected_regions(pdev, 1 << index);
 			return -ENOMEM;
 		}
diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci_rdwr.c
index 66b72c289284..df7b5aa078e9 100644
--- a/drivers/vfio/pci/vfio_pci_rdwr.c
+++ b/drivers/vfio/pci/vfio_pci_rdwr.c
@@ -214,9 +214,11 @@ int vfio_pci_core_setup_barmap(struct vfio_pci_core_device *vdev, int bar)
 	if (vdev->barmap[bar])
 		return 0;
 
-	ret = pci_request_selected_regions(pdev, 1 << bar, "vfio");
-	if (ret)
-		return ret;
+	if (!vdev->has_cxl) {
+		ret = pci_request_selected_regions(pdev, 1 << bar, "vfio");
+		if (ret)
+			return ret;
+	}
 
 	io = pci_iomap(pdev, bar, 0);
 	if (!io) {
-- 
2.34.1


