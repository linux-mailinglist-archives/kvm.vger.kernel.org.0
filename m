Return-Path: <kvm+bounces-64270-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 12E81C7C20D
	for <lists+kvm@lfdr.de>; Sat, 22 Nov 2025 02:58:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 8AA6A35F9A5
	for <lists+kvm@lfdr.de>; Sat, 22 Nov 2025 01:58:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 790832C3770;
	Sat, 22 Nov 2025 01:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="CmhGFo0i"
X-Original-To: kvm@vger.kernel.org
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013065.outbound.protection.outlook.com [40.107.201.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDAFD13AD05;
	Sat, 22 Nov 2025 01:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763776679; cv=fail; b=DoDreYFmajmCjFmASwlkhrGr0wRJ857NxBC6vKOaaVYeObe34cY2Pf/2OflvRFfE1i9pCu1Qr/+vEDwbg77YMZeYNU3EuPzl3fWEWKxp77LieWjYhInC5eJJIoP3VWqeU9qnqejKQ43VjD/Lky/gKeduMsgeOWpISQ0oYj06/tc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763776679; c=relaxed/simple;
	bh=zygvyRf8iVJZfTeOONOEj6jHA6bECqcSFQ3liTODmy0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bcMm/+76CcZ0pq4QdhIeJ/8leKPOC62l5oYygfrN93mxVKxmT8UgjICOkiNTzpihiF2sCi56qNasZAnQQp81IizvhfnBLAD2k3asu4O/nUGrURVIirRbxJRXtHJTyYXaYnPuSBzf5MKwObot6wJQx8EMF4D2Yb58VY5oIXssTNw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=CmhGFo0i; arc=fail smtp.client-ip=40.107.201.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vQSdpwVdXIUbBtVWzcHJytMEj9d7icDuc2ebf9Hv/wGaOl6IZS+KGgNbOQCQQcAcszRrbBTEGG9AIyvQtXeDufPRH5B6Yb/puPB/YNo/esFm+d1GSDRy9mYt5diyT/KroQZ8qENF+hAiZ8RlnPmIQhETSETFQOvYFJYbCulFZ5x3nQrzDkrqTW3MGxiHjhdyoKygfRF718lJjm0tVe91KbxCbrXa1D1ha6bzajaR0Yrx3U+y+pbCiB7cet7njUBfMGJc+d5M5KRYkrlZDfkdkE6qne9bY9/OdsFMNhb2SwBgdWuZW3dR3zqKrXx8IskHk1478MXrAsDFD856M61Reg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mNY9x1RtcvkkzqkoxtEh/9kLnwrlK2GzglZgK+WuMC0=;
 b=F+zEMag8HgUi7/v14ENra57DSmXow2xTDcZbRuO+2acubK+l+pyp5rE+4T87k40GgSVSUJ3W5QU/ot7T38N3peJMHVPuU6LxEXkj8uQ8WWl1pWTSMRzgOQV6CNLt+BDOPgaUtqiFOZfPDTAr6F6+q+moC93XxJx4YmQZruZdKe/gBQFj4V63qre2KmFjuVIU1qWwavdCaqcfI1OV+n/HmPwW+C7bdzI6HV0KglR8pB2E6LltISR9HdgyEkbpLH8AgjqXb/UdaQ3RiPoWnwalHLbq90WA/eJam36IaFuNB8IQKs0SMkUanSskanUcOtLF4/YDqv/eLv05I5LzgfvRbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=8bytes.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mNY9x1RtcvkkzqkoxtEh/9kLnwrlK2GzglZgK+WuMC0=;
 b=CmhGFo0ilh7R27IRidcUngcqJgzwWgn9t0KZg7y6Va30N/vMRc3BzAjbBvwnItien7NIpRa+ls1V9uPPHEOAY5zLiNVF5dyFe6ZHpumv0IN3+GsHSdzFaH514h8Yfms0nCDR8k0ZEwvhDmOGFZjQeYBVToLglHoBAhB5FG4pQJ2QxzGYMqf3DooohvRt2JyUvHcpX+4kTp50loanLrvmQRnQpBSRgsGVQZkhwgp4eVGkmRU4/AJPH2C5gvo6YHUsDDhfHlWD4h7c6Ry/1QVHaUyvU4zfB9Eera685qsW6hjqsfzW3mjSQbZaRCYxJM4TRTOBmp31GFR5eNhGWDPbGw==
Received: from BL1PR13CA0383.namprd13.prod.outlook.com (2603:10b6:208:2c0::28)
 by LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Sat, 22 Nov
 2025 01:57:54 +0000
Received: from BL02EPF0001A104.namprd05.prod.outlook.com
 (2603:10b6:208:2c0:cafe::fa) by BL1PR13CA0383.outlook.office365.com
 (2603:10b6:208:2c0::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9343.10 via Frontend Transport; Sat,
 22 Nov 2025 01:57:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BL02EPF0001A104.mail.protection.outlook.com (10.167.241.135) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9343.9 via Frontend Transport; Sat, 22 Nov 2025 01:57:54 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 21 Nov
 2025 17:57:46 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Fri, 21 Nov 2025 17:57:45 -0800
Received: from Asurada-Nvidia.nvidia.com (10.127.8.11) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.2562.20 via Frontend
 Transport; Fri, 21 Nov 2025 17:57:44 -0800
From: Nicolin Chen <nicolinc@nvidia.com>
To: <joro@8bytes.org>, <afael@kernel.org>, <bhelgaas@google.com>,
	<alex@shazbot.org>, <jgg@nvidia.com>
CC: <will@kernel.org>, <robin.murphy@arm.com>, <lenb@kernel.org>,
	<kevin.tian@intel.com>, <baolu.lu@linux.intel.com>,
	<linux-arm-kernel@lists.infradead.org>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-acpi@vger.kernel.org>,
	<linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
	<patches@lists.linux.dev>, <pjaroszynski@nvidia.com>, <vsethi@nvidia.com>,
	<helgaas@kernel.org>, <etzhao1900@gmail.com>
Subject: [PATCH v7 1/5] iommu: Lock group->mutex in iommu_deferred_attach()
Date: Fri, 21 Nov 2025 17:57:28 -0800
Message-ID: <a7ebae88c78e81e7ff0d14788ddff2e6a9fcecd3.1763775108.git.nicolinc@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1763775108.git.nicolinc@nvidia.com>
References: <cover.1763775108.git.nicolinc@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF0001A104:EE_|LV8PR12MB9620:EE_
X-MS-Office365-Filtering-Correlation-Id: 62534e43-b3c3-4174-4052-08de296a8d0d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|82310400026|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?+kv2YfsnkNt0kMCYVKtsZ8zyP1GJ3R8/jmda4KS+5y20ZMZzyHODGCsSGl/R?=
 =?us-ascii?Q?hEJKGqNVz9r8DWBEDghN/kSlt//TYeCtQe9lIF9w0nO7qvv7TVYfBIawY3oI?=
 =?us-ascii?Q?vRPQvTpwZ3JvwiHSl4xXsfT0jLhzjI/IOpRuZ9hdPAc96WIafBbwdGK8uwPb?=
 =?us-ascii?Q?JtT2DxZxw6YD55rh/G5/yY1ZfGxHMoMkeySZGcOtnfrdOEqg7Cg2Oy21oyl2?=
 =?us-ascii?Q?0HtsWCd6oh3H+l7FjInTP5T8sCrc495SioIU3aeFRqp3vmCJP70wWaJthSxu?=
 =?us-ascii?Q?bGQ72YBiMp+O2dV+R+GQCJymSoOR+8sHqjKuzMac9Bte33LjA+0PycUyYv8/?=
 =?us-ascii?Q?LQrxLNaXJORmsR2mgIe25lLkPaA5nl2AopK6K1bXuzTRMfu9Sz+qxtIeChtg?=
 =?us-ascii?Q?+azQ/GkpPUX5Q5x2EgeBvLUxwW8SZ1UHx5PEhopQZfNZlZAy1wxIjobDEj9v?=
 =?us-ascii?Q?wZBCaaLj/taDYPpdErsEHNFBmfXS0sjPqLzfKstOWFD7LXoUrKAFwoMgp0X7?=
 =?us-ascii?Q?q9j8lE3MhrlrYXs3G+C/N742E1qoSHYfgz6+xqoX93ni+VYAlX91uQHp5Elf?=
 =?us-ascii?Q?NyMgl/decmiju0CiQaEvTbcUYuonK8bvkQkBYXmxeXTY5QtKnNlZdOwteZ4t?=
 =?us-ascii?Q?YZYt0Sw0Gwmi3THmumyMt99slLNEl/70c662f1Egdt3RgNYYaQerD9QhWFzP?=
 =?us-ascii?Q?tjI21y2n28H2byTkAWtjW6qXmQLyeuo5i9w7ou1LesS84LwGlO+kofW/tFG0?=
 =?us-ascii?Q?N3brHG1ePe7WaxWq06zNL1f7wPsHCL661xR6kHxTCKxjiTYziSYJS+BxKRTp?=
 =?us-ascii?Q?dI34OqeclD8Hy7urJm/qEyNb8b0f1ZwGDi+mH4j32mOZFB4V0yVRfPlYNDxk?=
 =?us-ascii?Q?NOYYa/A1ZCg9vh+3afaBsUrut1O2wa/fixAJW1j5X4fabj/fLLsrRQ2ANHOy?=
 =?us-ascii?Q?CpyhkyYzghsyOYCKe9M+A1VtYZAB2a1pib/aBY7RKIEadcGgdZDsVJFEanL1?=
 =?us-ascii?Q?IKveDvtA54uXagiihOrpEOEnodl4btaeRdrVkLSxweGgDHqb/gn45rL3pcsz?=
 =?us-ascii?Q?Qmbp4oJgsLdatDGxEuHeh6Hg8lJuE0s3XS2NCOz7tJlahDnN3vHmkzjATUNi?=
 =?us-ascii?Q?uX6X1A7IjCEekBTOTnLAUcVwAxzlE+6sDGVzgypNOAR6HBotrLYyPa/YR52H?=
 =?us-ascii?Q?wMyqAqWNrazOca/oUxNCYIIXxM2Po1skUWmXpo7Q630Mj6zQtIYGCZSKaZKU?=
 =?us-ascii?Q?bOjW09B/H33J50dFPbVuFGeuyYu2qA+muAaNqdP0UGLeEQSkhgumcFA2AVsA?=
 =?us-ascii?Q?1EpuQbCjCdg0pWje3nuRLZXj7B7WNm7EGmBKpGjxj2HVMyA5PFGEZ4PN6wN0?=
 =?us-ascii?Q?JWoqHveK7U172iNOA6zDJlZ1/mfDL7YZ8L1ZMySpRLrY07K7iw4jkxc7++GL?=
 =?us-ascii?Q?18NikgUrz3Yj4z37uli3JcJ/zag9HlyHLemlERd+QjPwGwVQyagjT8HChm72?=
 =?us-ascii?Q?uDJuaDcRNzF28cWd3NnyZ3evc4hC1GdsFcUrm5KjkrhB3veHWsv7Vwj6at8N?=
 =?us-ascii?Q?LLgrE8PqYSe0fhzgz3U=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(82310400026)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2025 01:57:54.1226
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 62534e43-b3c3-4174-4052-08de296a8d0d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A104.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9620

The iommu_deferred_attach() function invokes __iommu_attach_device(), but
doesn't hold the group->mutex like other __iommu_attach_device() callers.

Though there is no pratical bug being triggered so far, it would be better
to apply the same locking to this __iommu_attach_device(), since the IOMMU
drivers nowaday are more aware of the group->mutex -- some of them use the
iommu_group_mutex_assert() function that could be potentially in the path
of an attach_dev callback function invoked by the __iommu_attach_device().

Worth mentioning that the iommu_deferred_attach() will soon need to check
group->resetting_domain that must be locked also.

Thus, grab the mutex to guard __iommu_attach_device() like other callers.

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/iommu/iommu.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 2ca990dfbb884..170e522b5bda4 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -2185,10 +2185,17 @@ EXPORT_SYMBOL_GPL(iommu_attach_device);
 
 int iommu_deferred_attach(struct device *dev, struct iommu_domain *domain)
 {
-	if (dev->iommu && dev->iommu->attach_deferred)
-		return __iommu_attach_device(domain, dev, NULL);
+	/*
+	 * This is called on the dma mapping fast path so avoid locking. This is
+	 * racy, but we have an expectation that the driver will setup its DMAs
+	 * inside probe while being single threaded to avoid racing.
+	 */
+	if (!dev->iommu || !dev->iommu->attach_deferred)
+		return 0;
 
-	return 0;
+	guard(mutex)(&dev->iommu_group->mutex);
+
+	return __iommu_attach_device(domain, dev, NULL);
 }
 
 void iommu_detach_device(struct iommu_domain *domain, struct device *dev)
-- 
2.43.0


