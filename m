Return-Path: <kvm+bounces-63376-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 91EFEC643D4
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 14:00:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 5B743363CC4
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 12:50:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1757F338F2F;
	Mon, 17 Nov 2025 12:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="J1jrDJEn"
X-Original-To: kvm@vger.kernel.org
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010034.outbound.protection.outlook.com [52.101.56.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F4E73376A7;
	Mon, 17 Nov 2025 12:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.34
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763383348; cv=fail; b=f+os7cYX1RW7cJfNirMCwmcCGBkzAMjPUQGiXCG7ZuFTmw2WcuuZ2bWdUy8X3+GRODmDSN4MALgUQT3gY/fh1ZiSmrLqC/FYjdLuiA5EcdgXhCRWAf5nsv3uTOvhfK0WzNmcqrATJoUagtVhuqp/RNBXxWdQNcNUZpLx/ic1fSQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763383348; c=relaxed/simple;
	bh=QfjZPxFaK7CPz6juKUXrfv1V+I68yAqxS4o2XHxeB3A=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ipOIJLGUOwVhNiwegnYrKsR2u7NVmEWP8TfELtiZonuqpP/d1tKmityGsaqYtIupS/oFFQ2vDBHzfY+39HaoCBgyKEzPUCMBHz6KQwA160RowEcTeJVsjN1g46KLJacTBTtLcFqLSrsUfldDyjgf6zWSaFo4dsOIWkRjNWjzVYA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=J1jrDJEn; arc=fail smtp.client-ip=52.101.56.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z8AD/cLlVcf+0tB7dL+uE+MG8xhVGcadObMxz2ZkEdrzAWUY8h9MsINLQhPHF14gLKWMVv3KW/77dOEDGF4ro0JfniUk8bxKulHm3H0YK1VYgGUNh3e7TMkVJkE239WoO/Ng5sLeEge6e8boUuZY4mFiJgT3WuaUTHy+P0t0hWL/bP/h542/ggdl9VoBO9seVEWubEHGCYPG/PK0ucFRzcvXuoVcKnrLSKtoKNQs23Dtloej8cOGaCQks72JSrm7ixGGMQD7t1P9gWd3/crSrEZt+DfJkmhvjWLkMyh5NO3X8PbK06sYy4cwzb02Hd7OEUW12BoNtjcR2wAxH9cuvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j8Ss9jKZEDXm9xtCRD34PRqcnXYfOZ7m/d9MMJT8tCw=;
 b=Z89Ob3XzF21HCMR8KwFkl+b9sLvOkuuKSzqeSYphEzE/XSKZVQrOBEaaJd64E1kM9qKK7BGCuAt45TAmjQCv8sVKvxitu5j7A9X88bPcjupOeF0Qmi3JuO0f0LrzgaWJEqRHWpQrFT6hBukoZ2O+rBJmck8wH+xs1QJ/SSjv6Nr8woq7opNvx/k4+mLzbdw72Ain4zSQtnIulZ950EcDUSOoVDJdGOwboY4z4KQkHc1Vt59ZVfU+oQD7GSjxCAp5ZWK7zIbLljxhtbHKKuMD/GvlHdQGbwCz32Q4c9IArrPAaHuUx6eU3V3J5We7D8mkbC7S3w0VuLQpRbmUwEdtlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j8Ss9jKZEDXm9xtCRD34PRqcnXYfOZ7m/d9MMJT8tCw=;
 b=J1jrDJEnuc2c4yxLS9Z9CUMu0ewyRIDTAlI4fetqiuaVAUo4azk36NnNb/+ZRBs5rhqiYSAl08SrmWCDfpyaE4OivnFA5Al0eL1eAHgRlBs3R/pycdURn7lAo+VbaYS2khZgN8i5eK95Faz21aTYFB8y8fbyRpZL8ml7avC7mJbuow8qap5SUJonsRKpSv5cKbf42HVsH0cBGjPHo7tbLc/krnLPseDHMVAJ7TRCtiLlhEMk52NDhHqBIbDCnHCGrUltKQ9QtPfH9Te9QMGotMKqLVKEME4aiB99UxKX03K0YADvqnni3ljH1uHQo6yoMYnLm8/RCyk45MVeeQjKEw==
Received: from BL1PR13CA0261.namprd13.prod.outlook.com (2603:10b6:208:2ba::26)
 by BY5PR12MB4034.namprd12.prod.outlook.com (2603:10b6:a03:205::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.22; Mon, 17 Nov
 2025 12:42:22 +0000
Received: from BL02EPF0001A105.namprd05.prod.outlook.com
 (2603:10b6:208:2ba:cafe::44) by BL1PR13CA0261.outlook.office365.com
 (2603:10b6:208:2ba::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9343.10 via Frontend Transport; Mon,
 17 Nov 2025 12:42:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL02EPF0001A105.mail.protection.outlook.com (10.167.241.137) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9343.9 via Frontend Transport; Mon, 17 Nov 2025 12:42:21 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 17 Nov
 2025 04:42:07 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 17 Nov
 2025 04:42:06 -0800
Received: from
 gb-nvl-073-compute01.l16.internal032k18.bmc032b17.internal032f11.internal032huang.bmc032l04.bmc
 (10.127.8.11) by mail.nvidia.com (10.129.68.7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20 via Frontend Transport; Mon, 17 Nov 2025 04:42:06 -0800
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <jgg@ziepe.ca>, <yishaih@nvidia.com>,
	<skolothumtho@nvidia.com>, <kevin.tian@intel.com>, <alex@shazbot.org>,
	<aniketa@nvidia.com>, <vsethi@nvidia.com>, <mochs@nvidia.com>
CC: <Yunxiang.Li@amd.com>, <yi.l.liu@intel.com>,
	<zhangdongdong@eswincomputing.com>, <avihaih@nvidia.com>,
	<bhelgaas@google.com>, <peterx@redhat.com>, <pstanner@redhat.com>,
	<apopple@nvidia.com>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<cjia@nvidia.com>, <kwankhede@nvidia.com>, <targupta@nvidia.com>,
	<zhiw@nvidia.com>, <danw@nvidia.com>, <dnigam@nvidia.com>, <kjaju@nvidia.com>
Subject: [PATCH v1 5/6] vfio/nvgrace-gpu: split the code to wait for GPU ready
Date: Mon, 17 Nov 2025 12:41:58 +0000
Message-ID: <20251117124159.3560-6-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251117124159.3560-1-ankita@nvidia.com>
References: <20251117124159.3560-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF0001A105:EE_|BY5PR12MB4034:EE_
X-MS-Office365-Filtering-Correlation-Id: e5f927c1-219a-4779-4035-08de25d6c05c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|376014|82310400026|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?M549eLc5QL3kqzR6g6ArY684KeFLEzdzAkouSti5EFCCtFQrIlGR/CtKeywD?=
 =?us-ascii?Q?tWsSPjkDUaR0QQy08p7tIkdBjVbKQcu/2J2rDh+DohQbdv5PCiiQhR9/GXFZ?=
 =?us-ascii?Q?8zAVLM6AcG6/a26e5BRfBd9iMW4wvu7WxLLg5dMvFl5ZvYNOEuH0+obKj8Ij?=
 =?us-ascii?Q?TT+zYuXI9R5LwzuwxVykx/WN2ITG8ky23/hLE3F7HyiFLapqJ3ZEPrsIqnHq?=
 =?us-ascii?Q?8fuNAO71ANgOWt9TGSgplBNuqJQn73G5beNzfBULDdwe1L6QaJIP7PMKPO86?=
 =?us-ascii?Q?Qba0ov4MUfu+LPzXJ8rsleNQj9Kp4v5Yi7r16R0mANAlPjPKDKTMa+etiD7q?=
 =?us-ascii?Q?Z8KK+Pytx/VfHLs+0eic6+0Nng6pMSBjqya0xJAKm/9XOaaR3HMSGYvZKRms?=
 =?us-ascii?Q?97TAvE+BWOCmOtfXcjY2Z3jUpshZ5hrhiic9drWPex9d/9uHtSu71Z95GdUH?=
 =?us-ascii?Q?8dkaawQl3aWI7RY3tW+StArhTtWzWtwFj1OBvOD+oxCdy5TyytpamWsd5OH3?=
 =?us-ascii?Q?MEhx2uO7PATjwK6H/DkbGsJ65OatQk5ywh8yxGlEemNC5Kp+aOueNVLc425F?=
 =?us-ascii?Q?p6TMk85fALzcWj2mbz7K0ZWreczaKhB6TFpSbVjUqB/NuaP+N60x9oOHSL0J?=
 =?us-ascii?Q?1AVOz19fxsA2UMTkOGRS5dqo7u1B1Gp1qKCazYFzfL0+W0EOA9mIhuMQhx4+?=
 =?us-ascii?Q?uMGQRVX34Zk39xG2glWUaugDmshkSCdy4Te7i5J3NnutMdKRgy4ESRHpxJ2k?=
 =?us-ascii?Q?dn3A2xrE/CMoYH1bRROJeuiUY8uZ7k28cVTxZj6d4wIZNsTpQ3dFdsaAoHfQ?=
 =?us-ascii?Q?zoPZDaJ4zLbyAHTTP7hRwJwqbzRCTszxUF3ZadWkuzZG7+nRROpSF0AL44uD?=
 =?us-ascii?Q?Axpx6qUwehjQ69b4ac/410LwIVzjz9SnNi1A+b/RKZcBld5M/RIt24zMguqn?=
 =?us-ascii?Q?bbE44x9bPrHH9eTsVRY9Ddz6izdhOUc9OHh++u60fi6VzU3EIKxcI6VgdHLk?=
 =?us-ascii?Q?uqK6seLVuFdAdav+Txya41dJ4O9GeQ8KWsh64r88QnMMCnRRCUZ41dzH1rbl?=
 =?us-ascii?Q?lO/PvQS6iJO2nRVueuWYlG6RsKSP/xqBvfW7WTWvwJDOelFomV9YaKyMATGp?=
 =?us-ascii?Q?tkWYR22SkVQnbLumQV0SenvVNHrc0uIoyzJu8Ekyzzc1S3a/Vq1I09BCsEIB?=
 =?us-ascii?Q?pWVDMRAuMhhAGlpjzksGMVgvisOiwvoLJtEp2oONXSEAatvKw8//43uTpF39?=
 =?us-ascii?Q?lxTg8ne0bFG+Pib/kOgeHF2uedPxNfrW5AFd78dhMLAuwTADKeMTPtqQYkMj?=
 =?us-ascii?Q?pXiLwyxj6nxTcjRykbJy3AIRXWOQG39w/FON+CqL/GFFAqAhWhd7iyOOj11K?=
 =?us-ascii?Q?U0aeNiPCZgblMvCCWsopU3VaX5sOU3JukBNFUOXVSq3expfKR8z/wy7YTNE5?=
 =?us-ascii?Q?W5e6L08iOTv0lKIm+9ELlB60sZKPses9xHbPgNfrXnVyZdBQMYiuvv6mgaKX?=
 =?us-ascii?Q?8f54Vl2pDr9M0in9jgQRFIukWp/6EoAV29fLYh76gG6zDDQlEFsQAZeiryCw?=
 =?us-ascii?Q?nOs6e6ytUGaQCU/3vV0=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(376014)(82310400026)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2025 12:42:21.2314
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e5f927c1-219a-4779-4035-08de25d6c05c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A105.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4034

From: Ankit Agrawal <ankita@nvidia.com>

Split the function that check for the GPU device being ready on
the probe.

Move the code to wait for the GPU to be ready through BAR0 register
reads to a separate function. This would help reuse the code.

Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 drivers/vfio/pci/nvgrace-gpu/main.c | 33 ++++++++++++++++++-----------
 1 file changed, 21 insertions(+), 12 deletions(-)

diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
index 25b0663f350d..fc89c381151a 100644
--- a/drivers/vfio/pci/nvgrace-gpu/main.c
+++ b/drivers/vfio/pci/nvgrace-gpu/main.c
@@ -130,6 +130,24 @@ static void nvgrace_gpu_close_device(struct vfio_device *core_vdev)
 	vfio_pci_core_close_device(core_vdev);
 }
 
+static int nvgrace_gpu_wait_device_ready(void __iomem *io)
+{
+	unsigned long timeout = jiffies + msecs_to_jiffies(POLL_TIMEOUT_MS);
+	int ret = -ETIME;
+
+	do {
+		if ((ioread32(io + C2C_LINK_BAR0_OFFSET) == STATUS_READY) &&
+		    (ioread32(io + HBM_TRAINING_BAR0_OFFSET) == STATUS_READY)) {
+			ret = 0;
+			goto ready_check_exit;
+		}
+		msleep(POLL_QUANTUM_MS);
+	} while (!time_after(jiffies, timeout));
+
+ready_check_exit:
+	return ret;
+}
+
 static vm_fault_t nvgrace_gpu_vfio_pci_huge_fault(struct vm_fault *vmf,
 						  unsigned int order)
 {
@@ -930,9 +948,8 @@ static bool nvgrace_gpu_has_mig_hw_bug(struct pci_dev *pdev)
  * Ensure that the BAR0 region is enabled before accessing the
  * registers.
  */
-static int nvgrace_gpu_wait_device_ready(struct pci_dev *pdev)
+static int nvgrace_gpu_check_device_ready(struct pci_dev *pdev)
 {
-	unsigned long timeout = jiffies + msecs_to_jiffies(POLL_TIMEOUT_MS);
 	void __iomem *io;
 	int ret = -ETIME;
 
@@ -950,16 +967,8 @@ static int nvgrace_gpu_wait_device_ready(struct pci_dev *pdev)
 		goto iomap_exit;
 	}
 
-	do {
-		if ((ioread32(io + C2C_LINK_BAR0_OFFSET) == STATUS_READY) &&
-		    (ioread32(io + HBM_TRAINING_BAR0_OFFSET) == STATUS_READY)) {
-			ret = 0;
-			goto reg_check_exit;
-		}
-		msleep(POLL_QUANTUM_MS);
-	} while (!time_after(jiffies, timeout));
+	ret = nvgrace_gpu_wait_device_ready(io);
 
-reg_check_exit:
 	pci_iounmap(pdev, io);
 iomap_exit:
 	pci_release_selected_regions(pdev, 1 << 0);
@@ -976,7 +985,7 @@ static int nvgrace_gpu_probe(struct pci_dev *pdev,
 	u64 memphys, memlength;
 	int ret;
 
-	ret = nvgrace_gpu_wait_device_ready(pdev);
+	ret = nvgrace_gpu_check_device_ready(pdev);
 	if (ret)
 		return ret;
 
-- 
2.34.1


