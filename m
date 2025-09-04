Return-Path: <kvm+bounces-56738-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2377DB430EE
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 06:12:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D2E6B5E0C86
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 04:12:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48E4827A11A;
	Thu,  4 Sep 2025 04:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="CyI8JK9u"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2085.outbound.protection.outlook.com [40.107.220.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26AAC270ED9;
	Thu,  4 Sep 2025 04:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756958933; cv=fail; b=LvDj4fApgsYUT0InqeRf/e1HTlmbixZevA5g2Yy0o8NTUBt661aR9vtQSonGRkNu/Vg4eXocMba9gasQzTkT2QYYjmla9mF4DgXX2lSznwTaeKhZd0zE2/2wHZv8hky7FKVjJe1D3JySgO198rII903/lVu7uAvyXmYFljdevko=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756958933; c=relaxed/simple;
	bh=RMWczn1FNhW+1XGc2lfPXuslvoZbcc6h22zsEt8Frjk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cpvA+lI6jscKq1hOQTbAtbOoyhCEdOGge8/hUZuU86GQw5Rp7Rnvcg5si6NLBKamzlxmYcGy3XVBOSQQexxEwd+uVv4daxV1VtDcamg+l0m/2w1mqsE82DMUENS9riZyD4edBuIxsJR3ItNxtthcKQGIQQtmHyCdwflzNKjBdWA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=CyI8JK9u; arc=fail smtp.client-ip=40.107.220.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z1gKk3rxBRihZ/22jKVLDpqHTzMNtv3BAxkAYglHQr6a8sZTK/8FSuTRo+iRFh9kmZIZEdNNExNG7wkyxyg40BVoIuMlkODRluTK3PbM3dqg2CWU0gBcDWnufeO1iDzKdqMvn5iRTX6fr6zVqUspIRhLKZhhfpiRpjDyxw/VDE1T++gJ44TJyC/umxSVGsQMrEl8faykagfYFWUkuVtRvyfZY6GtVvYtnfEEpBO3vsl3rkU44LX2yzC7XGIqcF/f5xcOs94FDyW0MD5OlqNTJG2fCWTjWBVH9lisOibpeKEwNSHSxcZD5+059RVcINP33eMFchqyB74cleuNfERQaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cDVxtfNzHkobm8rKo2QFfNTB6iNwPUmxc7x505yGi/Q=;
 b=GpiEQg4O3klf8hnJswBE+DhQfvW0e7TzJyZJEK4+WoiMYFYE+svMSgqKuHCfLh+uUaMrc+n6y0/sIVp1m8TXiEbS6ZIoGWAC+psBMTiiDE5d1FQZjgAWyOoBRaEYJD92q+B2MNb5/xYVmxxI/zDD4jgDdeTwhBOCpPIlpTC7C075ZAmQ6/IGiOPuocOM58rdOSnhTdRvug7f3IwijfhHX0X5FvkvLV6LynGDLx24M3HzH7TCZ0mdeR1v1UZFmr3p7TcJG56+rEFJx0wruG3rpbk35f6Ee2AnsbxyFsqERuZZ4ntYHPLKgHRDQ2KsV5or7KC79KpokwcYPzmlgPxoow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cDVxtfNzHkobm8rKo2QFfNTB6iNwPUmxc7x505yGi/Q=;
 b=CyI8JK9utZ9HpvPpMzEWMV25DwCZgAtLaI6nvLPcRyqVLwsgQPhS1tUH2CbMxH/gmZ6ORy0vpNhOZ/46OoV+DvDwDq6VePAHHHlQ6njuvkAXN3Jl2Ufu9QpruNstg/uz/MnqXGAS4hY+DQjn65hjsW50Yu3uCf4mQGCidFYDAxTdjOO1TiDZlleUSCwNPxkr+cQQNflXx9vVtDgPdpaLetVyzGnucS9wM/35G7GBm/vR/v9NP5MibBOalXlqaZhuR5k+VV3gt7MvQSCBZ9P+L/pseTb2frhX3EwnKziJR2dnn2eBwzeEwwkIBpkqkKwQ87GGZ3ShE+b5CiJhR1Gn9w==
Received: from SA9PR13CA0124.namprd13.prod.outlook.com (2603:10b6:806:27::9)
 by BL1PR12MB5993.namprd12.prod.outlook.com (2603:10b6:208:399::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.16; Thu, 4 Sep
 2025 04:08:44 +0000
Received: from SN1PEPF0002529D.namprd05.prod.outlook.com
 (2603:10b6:806:27:cafe::7f) by SA9PR13CA0124.outlook.office365.com
 (2603:10b6:806:27::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9094.16 via Frontend Transport; Thu,
 4 Sep 2025 04:08:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 SN1PEPF0002529D.mail.protection.outlook.com (10.167.242.4) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9094.14 via Frontend Transport; Thu, 4 Sep 2025 04:08:44 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 3 Sep
 2025 21:08:34 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 3 Sep 2025 21:08:34 -0700
Received: from localhost.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Wed, 3 Sep 2025 21:08:34 -0700
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <jgg@nvidia.com>, <alex.williamson@redhat.com>,
	<yishaih@nvidia.com>, <skolothumtho@nvidia.com>, <kevin.tian@intel.com>,
	<yi.l.liu@intel.com>, <zhiw@nvidia.com>
CC: <aniketa@nvidia.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
	<targupta@nvidia.com>, <vsethi@nvidia.com>, <acurrid@nvidia.com>,
	<apopple@nvidia.com>, <jhubbard@nvidia.com>, <danw@nvidia.com>,
	<anuaggarwal@nvidia.com>, <mochs@nvidia.com>, <kjaju@nvidia.com>,
	<dnigam@nvidia.com>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [RFC 13/14] vfio/nvgrace-egm: expose the egm size through sysfs
Date: Thu, 4 Sep 2025 04:08:27 +0000
Message-ID: <20250904040828.319452-14-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250904040828.319452-1-ankita@nvidia.com>
References: <20250904040828.319452-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF0002529D:EE_|BL1PR12MB5993:EE_
X-MS-Office365-Filtering-Correlation-Id: 08f378de-9d51-4c51-7dcf-08ddeb68bd84
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?oQ80znGw+L7IqJyrzaW35bVFahTmCEt7MDQq6m/LxcFVUxKL5DMEpcsqubvv?=
 =?us-ascii?Q?edPKcZLv4LIr7/7uPA6jSLuiCw/KHv7QVAXAU4MhizxekaT9gTPysgqGY5R1?=
 =?us-ascii?Q?+sj//5ydIsoapUFg1Ev8Xoqi55lHPe3JQhUh4ICmPOBvdAWoBbw9BIp2lBJN?=
 =?us-ascii?Q?Cf/UguQlm/OaboWaoZ9h5nwmPhtQG9Lm2MmspHYfjAlBXAdJEezWWCOVfXC/?=
 =?us-ascii?Q?Wh4CEToB80Mo4uHE+rlsBsXFMRwlutVrBfM7BgI2IVVs9XTuCRoOMGZxRn15?=
 =?us-ascii?Q?YaITtIPocIviNM13qf9BKLi/Q6HguuHNEDrnv7qt1won4LNITdboiRme3JXw?=
 =?us-ascii?Q?URtusZ5l9/RL4IwWmmMbTI6mlCpqBhHEEaMwtBLVendzQ/IGwmCvS9KvwPaR?=
 =?us-ascii?Q?6BRrnVk0avoeEUoGIq/nEFx3/zYAdOOx1A2qY4FTqH7iP6tE+J1dug/2Pp8q?=
 =?us-ascii?Q?7yL0ftLG9x7lYrbwRy1MmMKFbjWTTrgrWiRb14WNKhwXlcozwLLyW0dC8Sog?=
 =?us-ascii?Q?DnR4tCj0bo5YEAme95uAyUtoKBHcpeX6+sh/R6VD7P7K4yGE+X8d1YHB35Kq?=
 =?us-ascii?Q?6xJ/Ox2Znlf/aVFuQmAwqVlrgEGhdmbAkzqtepczqWturw2aPCIgRHlMyB8d?=
 =?us-ascii?Q?0wT0CBka1UZbMBJol/wwfVBTTbO4lAshvlc23MPqiZnxngx3RIViWa2zXxO9?=
 =?us-ascii?Q?HdQWE1fUp5LbSDb/vo4fumxSo6iynVByAMNpueUaLCYHswLNaqtHD/KldLV3?=
 =?us-ascii?Q?JD819INL8ez9GFG1Ducj+lXM9rV1W8cvGW35LZy/ru98JddErcSLv0ls7VDo?=
 =?us-ascii?Q?y1Dng4F+8f6WkhT174lZIMf9vUkhToVAfxhtBzX095UB4uipQA6fvNUDIIOv?=
 =?us-ascii?Q?qTePFlyzOuAMwMM/v5QvXqqJXMOQSAVCHoi55lcdiohyfzJWLQnJ/AmI1XmE?=
 =?us-ascii?Q?GY0V2ear/kIu9kzuPV+hVFGdpntf4r2r9UQQ44dWvt07a78fsXHIPXtKG3C+?=
 =?us-ascii?Q?1cnRSAeTpCS5v/WpF9IRiXiiqE4bTX+XJhRhYBGh5rKsuc5kRmHCUnZRaai4?=
 =?us-ascii?Q?+WAKvzyk8v5sijphQq7OEtZwSvhAJQ8O+1p6T8OFf0avapeFnZLp0L2U8t0y?=
 =?us-ascii?Q?eNDxJ2o9V+6CWyFmMZZU8XmRhzmRDyF2KLZNxxn3fQc/66hKAWGzDQvO4LWQ?=
 =?us-ascii?Q?Bsw/QNOZRkG708VSGErviv2J56IJ1ChObFfPTWHRfXs3YsUxP6XP2G7E9zlp?=
 =?us-ascii?Q?4oMl4jPtaYqAtbF7oRsR6tF9ZdIhoMa87j/7BtVrTrcdqA26PfP8aR2rM+wf?=
 =?us-ascii?Q?qqRs6m3T1eHcuFRO/236KFDOJkMhC2Qxr3YulbFjDTOGXp9afLfEsktWXN9p?=
 =?us-ascii?Q?JaFjAmWaIQlTO8Y/G70OglERsQk5+zg4OtIoKWw1Pf7ha8hets9UUPxbrjfR?=
 =?us-ascii?Q?ICSAqoKh8XHbkIxNKnp1y6L9hjExRncJ63kWvQdmGYfvsi640X8ezaG38PiT?=
 =?us-ascii?Q?aF2RB+2C9A9U+FX/EIRGlukNa8/6EHnb89UC?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(1800799024)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2025 04:08:44.3780
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 08f378de-9d51-4c51-7dcf-08ddeb68bd84
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002529D.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5993

From: Ankit Agrawal <ankita@nvidia.com>

To allocate the EGM, the userspace need to know its size. Currently,
there is no easy way for the userspace to determine that.

Make nvgrace-egm expose the size through sysfs that can be queried
by the userspace from <aux_dev_path>/egm_size.

On a 2-socket, 4 GPU Grace Blackwell setup, it shows up as:
Socket0:
/sys/devices/pci0008:00/0008:00:00.0/0008:01:00.0/nvgrace_gpu_vfio_pci.egm.4/egm/egm4/egm_size
/sys/devices/pci0009:00/0009:00:00.0/0009:01:00.0/nvgrace_gpu_vfio_pci.egm.4/egm/egm4/egm_size

Socket1:
/sys/devices/pci0018:00/0018:00:00.0/0018:01:00.0/nvgrace_gpu_vfio_pci.egm.5/egm/egm5/egm_size
/sys/devices/pci0019:00/0019:00:00.0/0019:01:00.0/nvgrace_gpu_vfio_pci.egm.5/egm/egm5/egm_size

Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 drivers/vfio/pci/nvgrace-gpu/egm.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/vfio/pci/nvgrace-gpu/egm.c b/drivers/vfio/pci/nvgrace-gpu/egm.c
index 2cb100e39c4b..346607eeb0f9 100644
--- a/drivers/vfio/pci/nvgrace-gpu/egm.c
+++ b/drivers/vfio/pci/nvgrace-gpu/egm.c
@@ -343,6 +343,32 @@ static char *egm_devnode(const struct device *device, umode_t *mode)
 	return NULL;
 }
 
+static ssize_t egm_size_show(struct device *dev, struct device_attribute *attr,
+			     char *buf)
+{
+	struct chardev *egm_chardev = container_of(dev, struct chardev, device);
+	struct nvgrace_egm_dev *egm_dev =
+		egm_chardev_to_nvgrace_egm_dev(egm_chardev);
+
+	return sysfs_emit(buf, "0x%lx\n", egm_dev->egmlength);
+}
+
+static DEVICE_ATTR_RO(egm_size);
+
+static struct attribute *attrs[] = {
+	&dev_attr_egm_size.attr,
+	NULL,
+};
+
+static struct attribute_group attr_group = {
+	.attrs = attrs,
+};
+
+static const struct attribute_group *attr_groups[2] = {
+	&attr_group,
+	NULL
+};
+
 static int __init nvgrace_egm_init(void)
 {
 	int ret;
@@ -364,6 +390,7 @@ static int __init nvgrace_egm_init(void)
 	}
 
 	class->devnode = egm_devnode;
+	class->dev_groups = attr_groups;
 
 	ret = auxiliary_driver_register(&egm_driver);
 	if (!ret)
-- 
2.34.1


