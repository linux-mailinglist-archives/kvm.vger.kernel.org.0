Return-Path: <kvm+bounces-56736-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BB42B430EA
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 06:11:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id C5C044E2963
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 04:11:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76F80275878;
	Thu,  4 Sep 2025 04:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ln6rCOKh"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2060.outbound.protection.outlook.com [40.107.244.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3715E26A0D0;
	Thu,  4 Sep 2025 04:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756958931; cv=fail; b=GMB5uRFxvEaZINHFngdDX7kwZNsmeV+nB+OevW50OTwcqhBagdYrPSSZ9TDdy/hK956i9e3YS7hO+xKkLrRO5Li8BUOZtFCc52M33ic8jZM+1VT/oES9gt0jeEzETBHH/0P1s9QfzoimMJ91OyyS6/jOuNiqnw+HHy0img/WRzk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756958931; c=relaxed/simple;
	bh=DoenhJrFU6v7o5G24aQrCwzf7T8hAdaUmpHbYhYxcX4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kNc+rjelZN1VzraW4Pel0q10M4uMuPn1WwiR8G1NaEAMYQoOCTREcDFqRknwnwwm2wXdHIcPAm6yM4KeT8LLN4vOGHhN4suVw6Wko3ZOM8I1pB1P2BL1g762Z8G19xnr6vf1xYkKfC+jfr/d7NZ+ud1huOx0HmLRFv9l7q/xvXc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ln6rCOKh; arc=fail smtp.client-ip=40.107.244.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KzPQ10OtFm80sn5Sun5atlwIVuZuuNRK9ZUnqNCkgrtDOADGSehzZffvv5pyDOE5nHVyihwx3RosDLCHBo8RMceGpsOR8gkdCcwOApR1XLXrRmlQsv8BNgDaYv0l6ybOTkEOOgjA9QXEux/RZINiZfOJ0virsNBme965dwN0uWh9sjGQ2QN+Fs+KIS2HG12UAu29uoFjQVLYuBTmgLsu2Hhjuc73OaSSm7tP+XkF8jyMofsHM1iGLL2KlglmcJnX00I4JQP+So2Pwnrgyi5itbH0wT95qofoDsoIcLedGFISzWGghgdfumpHAAWAi2qpViZ9/vdJAter3B+va0Z8OA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W4pJrldtDqCm0V6xmb+gDx89f9jCAL9lyWiaOTDXJp8=;
 b=eruxdA1Rke5CzaWF5E0rTRbjU/LT9x/RaIyKokgWXlQTq6rxsuGd97aefE8FY+oFVaE380Ac9fduUTSxmoK9wG50lzrePIRIzX5hVb3rpIt4NMsdg3MvYRM8KY2of3y6omxyjhRvNevNP+KslY/e42WTPm7ak29e7y1qzDxdMyRMTwHuAN3tyRpwvaHqdKEz4LIBch4sjHzU1Rgh6TkGVMO4JbLbK9kWghFz75sc7dWm5yiiuXiPCKkEGv8wIL+yxmMshqAy+KHwSxQu+hG3Ixyv7i86JThx+ZXPQrbqGuzXTZ78NAgx3rWvJUAKdguUOZbaSC/McrAm0OXQrcbBUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W4pJrldtDqCm0V6xmb+gDx89f9jCAL9lyWiaOTDXJp8=;
 b=ln6rCOKhAml42T9LQMbZeMLKddGd5ic8cDUG8zHU2M0Mh1JwpZKsOXBDHxPuvGVtUUjtgp8SRskOkNgQiqrWpqRW4/pT1J1knGZz2Oar21IGNKlysA1tEQd9nHqICfJ9vSQvyQphZIDTnhXbUG4QlFdszu8lslkDnarHVNeiHi/G/+Mh3ntLG6ovwGRlJX/y+OR+UbxTqrizB5DmTRdwAofgjt7yHZeZPLT58aruHCZo+/B/6SEH7XPpNM11mCafw5pzbfZxq/8smKIzfvcdX4huiq7iz4eL24eLPKRcakB1M6Uc5mqzP451fuc4Y6oLdl42+EZO4mzmebd6rkD1nQ==
Received: from BYAPR03CA0009.namprd03.prod.outlook.com (2603:10b6:a02:a8::22)
 by DS4PR12MB9611.namprd12.prod.outlook.com (2603:10b6:8:277::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.19; Thu, 4 Sep
 2025 04:08:41 +0000
Received: from SJ5PEPF000001D5.namprd05.prod.outlook.com
 (2603:10b6:a02:a8:cafe::b4) by BYAPR03CA0009.outlook.office365.com
 (2603:10b6:a02:a8::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9094.17 via Frontend Transport; Thu,
 4 Sep 2025 04:08:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 SJ5PEPF000001D5.mail.protection.outlook.com (10.167.242.57) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9094.14 via Frontend Transport; Thu, 4 Sep 2025 04:08:40 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 3 Sep
 2025 21:08:33 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 3 Sep 2025 21:08:32 -0700
Received: from localhost.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Wed, 3 Sep 2025 21:08:32 -0700
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <jgg@nvidia.com>, <alex.williamson@redhat.com>,
	<yishaih@nvidia.com>, <skolothumtho@nvidia.com>, <kevin.tian@intel.com>,
	<yi.l.liu@intel.com>, <zhiw@nvidia.com>
CC: <aniketa@nvidia.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
	<targupta@nvidia.com>, <vsethi@nvidia.com>, <acurrid@nvidia.com>,
	<apopple@nvidia.com>, <jhubbard@nvidia.com>, <danw@nvidia.com>,
	<anuaggarwal@nvidia.com>, <mochs@nvidia.com>, <kjaju@nvidia.com>,
	<dnigam@nvidia.com>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [RFC 10/14] vfio/nvgrace-egm: Clear Memory before handing out to VM
Date: Thu, 4 Sep 2025 04:08:24 +0000
Message-ID: <20250904040828.319452-11-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001D5:EE_|DS4PR12MB9611:EE_
X-MS-Office365-Filtering-Correlation-Id: e8d26349-154a-476f-2d35-08ddeb68bb6c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?BQu7E88s/TA1ZfBHlGbVhP+V3dwCdQOhEWC44LoCzJq/P1GIKTK3FqNd9a2N?=
 =?us-ascii?Q?MFGNCXk7Sox2nQDfLqIumi1+n7xuLrrdcggO4s4k3lsMjx2EXyjpq3fBxwo3?=
 =?us-ascii?Q?CyEo3424nQj/H9Ll/Oq6Qx8WKeiE3+Uel7bFGp8Fqaja2/jbDZ9JLE5Dxr6b?=
 =?us-ascii?Q?QPUPBrDaRFjPFdv3l8djtGX2jyDCc8DGVJDRA6M778CUUSM2ietpV/q1MAul?=
 =?us-ascii?Q?PPPjw8e7QmcWd1YNhkWLm2JC95OjVIj1X+2wPhM8ZzZYzf/Liu34aHGOWenw?=
 =?us-ascii?Q?rMxpUAqNCWa056s1PbMTslqpd/hH1uYCRmaRoIcO/I3MlWgoV0eAcSx893KX?=
 =?us-ascii?Q?ZlMWAXPrKAydenIBo+uOrV+5AwhViB5aPZ5gsClmU2Xw6AHV+KlNOwKxw6Ef?=
 =?us-ascii?Q?py3+/F+JN2MhB6DCF+R02zKADx5oaXO7evcOp+PYwaoXwVgNxiGoXlMjRs85?=
 =?us-ascii?Q?rCa7H3AZBGR7KhCDr7aJ8xmG8/fKp1J/edIF7t4VgtZHTHUcMccc1/eSAoxJ?=
 =?us-ascii?Q?5cc4aJytARfBw9XS3Ez6Dhxh13yb0bfknb3mLu2TTkLeAsHYY07Ex72pDD8X?=
 =?us-ascii?Q?7L13BddpvMwQiqAjcVXkBjla/VaCQTumav9nv8m9HmN7c9dVXgVuUNhsaofN?=
 =?us-ascii?Q?qyguf6itBXUwNfy+DxuPn83mAl7/YVvFE9yWOVEWCsFzdMDhxoloCFowRsqU?=
 =?us-ascii?Q?LCipOPmsuV8yxWDXMy9LCLlbV2J+tEWc1OYGVkccTbtKYog0mZ8m8Hutj992?=
 =?us-ascii?Q?qazlV2FWBlplrjBfi6gG09PsTXn6zqfWhf11mmDIhwnBqF8olA92AtOyD8Tg?=
 =?us-ascii?Q?va74FP8sDEENsJwC6QEMZ8/aCmEPc6LPtYV9S4J0NVeo1myZpA1LjmR2xDK8?=
 =?us-ascii?Q?jvkqCKqEe/P/PIxBg7seCXaPwsyqZZg2nL+bRSSeL42tOC2S3dPK/BOeRTtX?=
 =?us-ascii?Q?5MNZgq1wq1G3dXfIH77n9YAsLiJvtLtrYirAG/nfeRfnH/RgMmSUsLIFIYw0?=
 =?us-ascii?Q?bHVcYeuM/woqcBXKoGroxn2beFgMVIxrwIa+5aCUnjRgqMtHmWrSJcRGz5Q+?=
 =?us-ascii?Q?8iJFiBr7Y/5agWPOw0s3NhVyIeLjAMV360j2NVl0My4FWSD8qbUZJshcGDTg?=
 =?us-ascii?Q?JwkNBK68VDXE7AplRurHVKP0FxLzNgmxkAhTorfpElIYtPe01YT2pnA/2ctZ?=
 =?us-ascii?Q?XPgCw66IYVRv9B0Z+1rrouATBifgbj0CTVr8tYPl39RFYpKkZqGjn+Ha9JPe?=
 =?us-ascii?Q?+rUdZypVoOJP3v4+Kfs6rwuZWykCTWKcgYrJR3U0NagOWmCbt2sh/JtEsf35?=
 =?us-ascii?Q?cFNVdkhZuPk6rg4AVGEzISxdtApGiiYqm8+bTk6I3eoRalJxP6tu5DtK9AWN?=
 =?us-ascii?Q?RSTUyESssAEXnxu5uKeyaqoegph/BAPwRhG6sXdMdJl487x/o2SE6ME5FKvB?=
 =?us-ascii?Q?U+wW40rXtraUBy6T05azFx/2jwgOyDkNta5bhiOqMoNeCwuLOWab0jaCb+i4?=
 =?us-ascii?Q?DecmWplDYxhKMIdRtjMt2zwY7M2dtTQ1FUB7?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(1800799024)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2025 04:08:40.9764
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e8d26349-154a-476f-2d35-08ddeb68bb6c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001D5.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR12MB9611

From: Ankit Agrawal <ankita@nvidia.com>

The EGM region is invisible to the host Linux kernel and it does not
manage the region. The EGM module manages the EGM memory and thus is
responsible to clear out the region before handing out to the VM.

Clear EGM region on EGM chardev open. It is possible to trigger open
multiple times by tools such as kvmtool. Thus ensure the region is
cleared only on the first open.

Suggested-by: Vikram Sethi <vsethi@nvidia.com>
Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 drivers/vfio/pci/nvgrace-gpu/egm.c | 28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/nvgrace-gpu/egm.c b/drivers/vfio/pci/nvgrace-gpu/egm.c
index 7bf6a05aa967..bf1241ed1d60 100644
--- a/drivers/vfio/pci/nvgrace-gpu/egm.c
+++ b/drivers/vfio/pci/nvgrace-gpu/egm.c
@@ -15,6 +15,7 @@ static DEFINE_XARRAY(egm_chardevs);
 struct chardev {
 	struct device device;
 	struct cdev cdev;
+	atomic_t open_count;
 };
 
 static struct nvgrace_egm_dev *
@@ -30,6 +31,26 @@ static int nvgrace_egm_open(struct inode *inode, struct file *file)
 {
 	struct chardev *egm_chardev =
 		container_of(inode->i_cdev, struct chardev, cdev);
+	struct nvgrace_egm_dev *egm_dev =
+		egm_chardev_to_nvgrace_egm_dev(egm_chardev);
+	void *memaddr;
+
+	if (atomic_inc_return(&egm_chardev->open_count) > 1)
+		return 0;
+
+	/*
+	 * nvgrace-egm module is responsible to manage the EGM memory as
+	 * the host kernel has no knowledge of it. Clear the region before
+	 * handing over to userspace.
+	 */
+	memaddr = memremap(egm_dev->egmphys, egm_dev->egmlength, MEMREMAP_WB);
+	if (!memaddr) {
+		atomic_dec(&egm_chardev->open_count);
+		return -EINVAL;
+	}
+
+	memset((u8 *)memaddr, 0, egm_dev->egmlength);
+	memunmap(memaddr);
 
 	file->private_data = egm_chardev;
 
@@ -38,7 +59,11 @@ static int nvgrace_egm_open(struct inode *inode, struct file *file)
 
 static int nvgrace_egm_release(struct inode *inode, struct file *file)
 {
-	file->private_data = NULL;
+	struct chardev *egm_chardev =
+		container_of(inode->i_cdev, struct chardev, cdev);
+
+	if (atomic_dec_and_test(&egm_chardev->open_count))
+		file->private_data = NULL;
 
 	return 0;
 }
@@ -96,6 +121,7 @@ setup_egm_chardev(struct nvgrace_egm_dev *egm_dev)
 	egm_chardev->device.parent = &egm_dev->aux_dev.dev;
 	cdev_init(&egm_chardev->cdev, &file_ops);
 	egm_chardev->cdev.owner = THIS_MODULE;
+	atomic_set(&egm_chardev->open_count, 0);
 
 	ret = dev_set_name(&egm_chardev->device, "egm%lld", egm_dev->egmpxm);
 	if (ret)
-- 
2.34.1


