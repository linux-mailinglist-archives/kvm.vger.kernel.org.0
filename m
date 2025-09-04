Return-Path: <kvm+bounces-56732-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 69354B430E3
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 06:10:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BC5AD7B607C
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 04:09:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9023626B755;
	Thu,  4 Sep 2025 04:08:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="hhhpFyJK"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2069.outbound.protection.outlook.com [40.107.220.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31C3723D7DA;
	Thu,  4 Sep 2025 04:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756958928; cv=fail; b=XGCjyapRsUJLaidM8wHQ+FvwXzx+qEQpKvry4AwNFPw/z6Z1AJrl+0PK2nrf9D3tPZPwcSLY+XC+DtGJWmh7fKN3YrsXBwJ7yKjIpxN38JxAO8wz1vf0qHVtyChzZjSnCyZDU6O9/RCxLVCOV2BEYvOT5XKESUBXZ99WyH33nXw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756958928; c=relaxed/simple;
	bh=QXlZETqdmAvmv2iWMPHfnuYBP49NTuNBRExgtcSimrA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pcwBYEIAWBqTQE9bZUfwwEuZYp1XADIOI704SvLNR9hnTHr38iQiSAsF5bdkXrFaBm0zgjTRcGjUdLtdCuCfosglw4RO5aW33M8RHX+iYF0tLa0eczLnW9nyZujFv0ouv6VgGmA5xeGHIRotGDXf82xXpPmR0RfMdCs0TR9zYmc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=hhhpFyJK; arc=fail smtp.client-ip=40.107.220.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lTBkQYqYI6U3CXV7lQFuOyIU0hJlllQR/0tlUGWFQYAwbe0fSrA0vmJxsKR2GsZC+SXnXg+JYFnJTu4lHPWXuit6BUGqsrh2KpTMvB9krbGLS8x2Etng6+IHrqblvuTbA+RV1cARlP3oQTm4Jde0Jl2+mbxYnwePYvKFFRfybefcxhkn+FGiq8uEJu02jbwRxpRrmncEhwNvO5sD8uneKOMYOfNNtparGhatfDRTXTdSMdDVB/cywxZfkHJExNlCtU5kCXwnTee+OtpFO36cC2wMzgAewil6BWmYTu5c+tE5ZK4oB4Y31imH2Z3F3VWMYZMPW+gaj0AF9ht/Cxn+uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QRbQJdpskjsg4IWQzFquwJE/UP4PjjXeSD376SvXuXU=;
 b=mA2whtfN1l5uQc/V7LqGhDDUbKtB72OrOmO3gpxA3iDUXLai8Zb+YkMNwfBCA+Zst2yYeTjY7CRs/QlZfaExuDbxIQqmbZbEeIskNic6ccitXen9c9eSVM22+JgrOuUaTC059X8c2soBKLv7BubgKTE4826nSY+bGAgPqO64gR1KjuHpWapiC/NKlSa7efty/YtP5wh1ElzOwgKx/6+bYvql4DUbiHmRNUU/8yJF5mwqvDeMU7fL/0jtIeNU/zC86d+HaI7xpQiDKpJGtpZuWYAH+77XX6vqZu/yhoB0wSalaSMVPLWogNvnlLXVsHay7M/iGBEcZQf7L7+qJjncvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QRbQJdpskjsg4IWQzFquwJE/UP4PjjXeSD376SvXuXU=;
 b=hhhpFyJKklHB4kSJWUfwC/ELNJBpddn9tIGF3CnzAhRh20JN59AlTm85knnSpC6Vim90OJ3DHTfAJAbxmOHoeq/r1WjohUXwOVjptZpYPir8pIsFwXGG2wtAqqIJ7CLSyiDb6AF+A5/OTp/CjUm1xtl77DXzUwY3lpUrxfyqBLpNgrDifWWE1dfDaYs9uddxiQYzGg4auYIvYXK6F/SHeNoXokDnSxk/ZSIBLwW5LaFadg5WVByrNxbTWmzJMfDqKhG9x6zMhMwjv6m+7ZqGLJoCm2JfuPzCHh1g+3wg19Xj25In6pLXWS9YttWlA1ONvxbv9pisDyuuUyeI0r66vg==
Received: from SA9PR13CA0130.namprd13.prod.outlook.com (2603:10b6:806:27::15)
 by MW4PR12MB7030.namprd12.prod.outlook.com (2603:10b6:303:20a::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.18; Thu, 4 Sep
 2025 04:08:41 +0000
Received: from SN1PEPF0002529D.namprd05.prod.outlook.com
 (2603:10b6:806:27:cafe::31) by SA9PR13CA0130.outlook.office365.com
 (2603:10b6:806:27::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9094.16 via Frontend Transport; Thu,
 4 Sep 2025 04:08:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 SN1PEPF0002529D.mail.protection.outlook.com (10.167.242.4) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9094.14 via Frontend Transport; Thu, 4 Sep 2025 04:08:40 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 3 Sep
 2025 21:08:32 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 3 Sep 2025 21:08:31 -0700
Received: from localhost.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Wed, 3 Sep 2025 21:08:31 -0700
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <jgg@nvidia.com>, <alex.williamson@redhat.com>,
	<yishaih@nvidia.com>, <skolothumtho@nvidia.com>, <kevin.tian@intel.com>,
	<yi.l.liu@intel.com>, <zhiw@nvidia.com>
CC: <aniketa@nvidia.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
	<targupta@nvidia.com>, <vsethi@nvidia.com>, <acurrid@nvidia.com>,
	<apopple@nvidia.com>, <jhubbard@nvidia.com>, <danw@nvidia.com>,
	<anuaggarwal@nvidia.com>, <mochs@nvidia.com>, <kjaju@nvidia.com>,
	<dnigam@nvidia.com>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [RFC 07/14] vfio/nvgrace-egm: Register auxiliary driver ops
Date: Thu, 4 Sep 2025 04:08:21 +0000
Message-ID: <20250904040828.319452-8-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF0002529D:EE_|MW4PR12MB7030:EE_
X-MS-Office365-Filtering-Correlation-Id: 881c359f-2940-4957-5a2c-08ddeb68bb49
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?IrlW6iJ8cyUQK0d1TifnTG1VDoHw382s5mIh/VGnlGoQwbu42lW08FzNGu+D?=
 =?us-ascii?Q?546VVvXno7hmBu4ayTqY2pz0AHKSM/WwE+ys0YL7RN/bYDmZJi05wM38uuRX?=
 =?us-ascii?Q?qlavQQ04iv5D2ESZQf6ysZ9/xYMyOPX6RxvM6XDNR06Opj/3x7ZoKmOg1/1e?=
 =?us-ascii?Q?pvnJy50Mx2p/VqMjp3VTiNZ0ZBAa6VNbnXrJE4u7KQt7tkOOpeSl10Vr+cew?=
 =?us-ascii?Q?4IkSAhwM6G0SkmNMoIloYmjH1pvG7VcqySW133IaD6BQ1ckPTyRan+nlNgTt?=
 =?us-ascii?Q?nqaSfR3CyglgzB7f1FCwhdc5wffrZzWggunry3z19AzpOUNA6/46pQs+Tin1?=
 =?us-ascii?Q?j3o2vX7dKb9QV8gKFFrqLT72eBnSAxJBbMdYg2EKMPUAcoxrR6M94FA5hM2S?=
 =?us-ascii?Q?eOrBEoFZjBAF6GBNtNCjDVeSqV94tEd6QUVWYKd97DZhIOG0MwVb0MtQMyXV?=
 =?us-ascii?Q?Y+JH0xoD9a2GHgU8FsH/fNNmuLwP08cM3iY6wZOlR26Ql9+WhabCsyq20FOo?=
 =?us-ascii?Q?Qg4IFLENIPOkBKU8EG3YJ47wNJqE5gLERMz6pAAXU5Cdka0yG++nj5EfEXqo?=
 =?us-ascii?Q?rlYKHch68877wOg4KgJ8sX6t7lBogwWpzerlDbhfd72+wCKJuGOS57CfXiC1?=
 =?us-ascii?Q?E4UHS2HufzVqaV1196dpKF/B9h7RbiImI8pR9cX2Y9+x2JejU8d9FBXqjjkK?=
 =?us-ascii?Q?iwS96H8YZcgxh8mgmhKDWPqrufwmoDiW+KFyZk5HLJn3p86uor91mzUenrcH?=
 =?us-ascii?Q?i3/HxAjEn4DNFOsp+VWAC+D+ftTkMQVXYrUWPseiAZXYlpoa6ZqhcgbKcE6e?=
 =?us-ascii?Q?CZBMDMOy3zzjcm932md9v7Ki51D0V8zUkvPPaodrLdeW36GNzNYqkGlaKQOX?=
 =?us-ascii?Q?U1oB7A4BeUkks7dmYrtEpnxSSPB90X7HCy9qcbvacVktkmTB5/frV6t3n7/E?=
 =?us-ascii?Q?EgKrLxiyr8NiGSqkcnWzRa/Sluj72sTVEDnt+eWHu0b7COl1L2oRWrLPtv45?=
 =?us-ascii?Q?ifJPiSRaCxgjvKA2eUF0A2bmEpmlViZeYFwTCRj15qpsMHOHgwLOM91Mo9+l?=
 =?us-ascii?Q?iDZLxjt/++GYueONjMsq+Nkr3F0w+UwlNP1wWBnlMbfyiBSq4qnleA7/iwAO?=
 =?us-ascii?Q?JUUUV5JynDJx0dVBSNKqQRXJ1sve3Lz0/zzdv2jRtAAavirl9pgPSgKCKd8n?=
 =?us-ascii?Q?8pQOlnVdNPRjXl04Ll4WVH6gzp/Zesv4RcAq1h/frxGOqN8KTGYLGIqyVzbf?=
 =?us-ascii?Q?xoj2nbm9hIzZAYkaKWqg7DACr3LZjD25v/J3DAW90Kw3O4mw2Yej03Z6y/0K?=
 =?us-ascii?Q?fEW+/kp+AG/ghQ7FVEgRfq6V0uuTSizdRRMH1HCa5uMKNm9bVBJvYIzMXinx?=
 =?us-ascii?Q?zrU2XB68WJplaVtQUCUk4s31B8R3uW4pernMvZw7u6MBT7Xcb1102hiDzqHM?=
 =?us-ascii?Q?VeMnbGj+tzsGHvx59YFN2kTFFltPcLYpZXctEOQO9FFdq4nnhvjFbXt94i+V?=
 =?us-ascii?Q?18kLPNgqMneCsjqaAht2wGpFwglgg4hjbanw?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2025 04:08:40.6323
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 881c359f-2940-4957-5a2c-08ddeb68bb49
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002529D.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7030

From: Ankit Agrawal <ankita@nvidia.com>

Setup dummy auxiliary device ops to be able to get probed by
the nvgrace-egm auxiliary driver.

Both nvgrace-gpu and the out-of-tree nvidia-vgpu-vfio will make
use of the EGM for device assignment and the SRIOV vGPU virtualization
solutions respectively. Hence allow auxiliary device probing for both.

Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 drivers/vfio/pci/nvgrace-gpu/egm.c | 39 +++++++++++++++++++++++++++---
 1 file changed, 36 insertions(+), 3 deletions(-)

diff --git a/drivers/vfio/pci/nvgrace-gpu/egm.c b/drivers/vfio/pci/nvgrace-gpu/egm.c
index 6bab4d94cb99..12d4e6e83fff 100644
--- a/drivers/vfio/pci/nvgrace-gpu/egm.c
+++ b/drivers/vfio/pci/nvgrace-gpu/egm.c
@@ -11,6 +11,30 @@
 static dev_t dev;
 static struct class *class;
 
+static int egm_driver_probe(struct auxiliary_device *aux_dev,
+			    const struct auxiliary_device_id *id)
+{
+	return 0;
+}
+
+static void egm_driver_remove(struct auxiliary_device *aux_dev)
+{
+}
+
+static const struct auxiliary_device_id egm_id_table[] = {
+	{ .name = "nvgrace_gpu_vfio_pci.egm" },
+	{ .name = "nvidia_vgpu_vfio.egm" },
+	{ },
+};
+MODULE_DEVICE_TABLE(auxiliary, egm_id_table);
+
+static struct auxiliary_driver egm_driver = {
+	.name = KBUILD_MODNAME,
+	.id_table = egm_id_table,
+	.probe = egm_driver_probe,
+	.remove = egm_driver_remove,
+};
+
 static char *egm_devnode(const struct device *device, umode_t *mode)
 {
 	if (mode)
@@ -35,19 +59,28 @@ static int __init nvgrace_egm_init(void)
 
 	class = class_create(NVGRACE_EGM_DEV_NAME);
 	if (IS_ERR(class)) {
-		unregister_chrdev_region(dev, MAX_EGM_NODES);
-		return PTR_ERR(class);
+		ret = PTR_ERR(class);
+		goto unregister_chrdev;
 	}
 
 	class->devnode = egm_devnode;
 
-	return 0;
+	ret = auxiliary_driver_register(&egm_driver);
+	if (!ret)
+		goto fn_exit;
+
+	class_destroy(class);
+unregister_chrdev:
+	unregister_chrdev_region(dev, MAX_EGM_NODES);
+fn_exit:
+	return ret;
 }
 
 static void __exit nvgrace_egm_cleanup(void)
 {
 	class_destroy(class);
 	unregister_chrdev_region(dev, MAX_EGM_NODES);
+	auxiliary_driver_unregister(&egm_driver);
 }
 
 module_init(nvgrace_egm_init);
-- 
2.34.1


