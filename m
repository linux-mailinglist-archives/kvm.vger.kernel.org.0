Return-Path: <kvm+bounces-51970-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CE55AFECB7
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 16:55:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 906954E048F
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 14:54:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F8C52E9EC3;
	Wed,  9 Jul 2025 14:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="O8+pJl0N"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2052.outbound.protection.outlook.com [40.107.102.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4A432E973B;
	Wed,  9 Jul 2025 14:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752072759; cv=fail; b=KXVYNvgcmVhb5N2mNlw7SlAH9Qg4MylnIMTbq22qTdsr5MM/1GPyxgoBPc1QL33wCUKLry2yUFpijB4JFjyYVWQ7m5f1x3RNhM1+0hI4PZX4Ow2S2B70Bj8QUJAO2GPr0LdNxn33cUMEax/HpqIEzls8xgnU04sj7MsQJMcuV/M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752072759; c=relaxed/simple;
	bh=CtkWxyf6Yi16+pUN8yVA/kSr2MVQOvH2WvW1EX19OXQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=GLejHtSmocF6zB0P5fRp0sOdlKdbW6D9+eIP/GQGoJI6SmBeKOvSdSYrWXxMcPu5YtNG54SIOWg6EgEhT8MIAT5P26P6hj85SVqSi8VoOg+XKOpHkb3y76trsKU3I3KkTxWKe+oSwhCp0WwsY6580IsvHUMKr6xRdyn4+mH1Sds=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=O8+pJl0N; arc=fail smtp.client-ip=40.107.102.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=e5WsVQemmmUgdbbfDhItVZEDYDwq71POmyUHND0hCP9kE8378KyPU/wecM3NliEuUDxwzWac/xcezEpIn5L1+sfnJdvxYF2cLOwIAANpwReyoCp9Ni6afGAEJ9YoyV1Qj/ioWFuanop8kNhINj6ODxrSodFlsz++lfdbVCwJkmxtl8cFPT+jFaYKIHxNpFXQxQKjScpue4NM1ZQ67N/nT+vBstc/VIQEXSj3F8krlHEfrntIoJK6K2//x64xJ9UsfK1LFLRwNRIjr+DcKtj3RcCiyElByjXRD9QVJPPvgalq9Zs2UaFEoLxrASUZrzpedBMjDgRGqpLMF+FYJPVpSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=em1Tln6JGHEDN2x4VwmBeFNgmCXUC1i4KzbjaD64r5s=;
 b=hN7g72I8b/FxVuCwWbAf1mxjZO084wFfp1lnPE4qBVC0dPlX7B5p9+F5vLkl226YklnNblZCx8/MuHdi3gl/3beT90q5TJuzuFLVHKxdLD77TsLkLtLZp6Gh3P0pMNkul0RQsEzTdF6bhPpR49U28mhvfIdqWOMKfDHwf35Dd4yLSMwsEeIbd4an2jyibQ2he4HWjAVKIL9dhgBaAiNwWC2DdSJFefmGVhcoocfwDPHZbzo9BFYz8vJFiymZAijYjaBFtBP8Io7jtFAq5Ej//dmB1qzjoSBOkwU8jlsZONj0GWp+qiUSIf3zBwe2Mvf/XCz8cQ11cwT/P+lMHNDz0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=em1Tln6JGHEDN2x4VwmBeFNgmCXUC1i4KzbjaD64r5s=;
 b=O8+pJl0NumtysgBUqYmNGrr5dQGKRiyEnY+iv6qPZAmHAYoergrJUBx91vIif2AwhwYogHY6ZNGKNilVYshcDN9FF1zjkTJwFRLWtB4mR+Arr1oxMqAUsRLqW+bT4uvKF0/rgQ0GQ2iE7St2UU+BxbaEkzYnwGkSERbRg0yfkTZXhemEMK4Zja5r6aI4iOuniXisQdE0FmAyrUO+vvB6h60zqhPOZT1oQXpL+Ffq3LrE6ugEYebgucuPIrfMHrvIi4SAprGXM1gu2UZbCIvZTHdQ5jGKwuMi8FYCGMLuGvlJuOyRMoNNsYDXhpqb1Dr2mVi3dfLXDc/VKb6/ZKhw7g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by IA1PR12MB6356.namprd12.prod.outlook.com (2603:10b6:208:3e0::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.26; Wed, 9 Jul
 2025 14:52:28 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8901.024; Wed, 9 Jul 2025
 14:52:28 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Bjorn Helgaas <bhelgaas@google.com>,
	iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-pci@vger.kernel.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Alex Williamson <alex.williamson@redhat.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	galshalom@nvidia.com,
	Joerg Roedel <jroedel@suse.de>,
	Kevin Tian <kevin.tian@intel.com>,
	kvm@vger.kernel.org,
	maorg@nvidia.com,
	patches@lists.linux.dev,
	tdave@nvidia.com,
	Tony Zhu <tony.zhu@intel.com>
Subject: [PATCH v2 04/16] iommu: Organize iommu_group by member size
Date: Wed,  9 Jul 2025 11:52:07 -0300
Message-ID: <4-v2-4a9b9c983431+10e2-pcie_switch_groups_jgg@nvidia.com>
In-Reply-To: <0-v2-4a9b9c983431+10e2-pcie_switch_groups_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SA9PR11CA0010.namprd11.prod.outlook.com
 (2603:10b6:806:6e::15) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|IA1PR12MB6356:EE_
X-MS-Office365-Filtering-Correlation-Id: 5382d336-010c-485d-c963-08ddbef837e3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?E4mtmxp/jk5SLyZaECpH3O+ugrdiJ3j6Nl+Q46m8WbyVQhh6o5Zh6DmwnVwQ?=
 =?us-ascii?Q?gdPK8C6EKbkx1ovZPHVFvprXaSc9T3X0d103JNSw3QHGH+/5E4agxGOHS2Kt?=
 =?us-ascii?Q?LZdDEQ87obnQl1/zyCkOtYoMemve4OpW0YvkawWctx3gVTn6beshrwTzxYFh?=
 =?us-ascii?Q?F37i3u59oEuvMPVRNmLK6r+Kf6k6MSPsqBoTHtDdwpJl5+wWpzKbVUx+6x1v?=
 =?us-ascii?Q?iw7fSRN42/q2/6dFEFwtkZcbfAt1tz5OZiGV8xilm2osY3Z5nQxBDu2wng3Q?=
 =?us-ascii?Q?1ckXOMJoqDwBRplU34ARK7ndRygR+79QFvUwMvoJ7qb1HQOpeUEvfnc+9R2W?=
 =?us-ascii?Q?lziwX/Bxz64Uw6Nnk7/Mvhl4alPGMRE9vhFPtBHHbjvQmdBmhNZVL0Q3yb6H?=
 =?us-ascii?Q?O7+yDZsuFME9Dc8b+Ox/pwExILkc1WOcKQUvkmbYjg5XHfRdjzUWnF9Ag8wd?=
 =?us-ascii?Q?Jl7wmkKb5RPc+zZTI6NEIAtTsS0ii7Mz5w1FE0n5ftLBFayfoLxAx7p2n7tM?=
 =?us-ascii?Q?kMeqjC8lt3nxr8ohANER3+mKsaMHGTv6W8iaKAqwG+6qWwMhReCtsqQ6tSMR?=
 =?us-ascii?Q?GbC1P0U2ra/wU9qCC7LGxUWddJiQMT9p9lg76PgWPx3dho+L26zTmJ/igU0J?=
 =?us-ascii?Q?r1lHvq9nqLINt5BTfNi6+7Ayyb8oxrN65/LI2ho00POvYDRhFpiobjfh67rZ?=
 =?us-ascii?Q?9Qa8+32tYkMy8lBnzQrrLO6Rqm0TId1JjKOWox+INm0MIVutZecK6iTWnJWn?=
 =?us-ascii?Q?NymxPgdDXytBaxjs+4thChq2SCmJFCZCB0CuJYFRGPRoAqSS9u9GJ2L//pRl?=
 =?us-ascii?Q?qHF5W0oFktCZT6HMU2Mw6YpgaT0gXS4b7zkLkzX51gdBTpp4nF9ipvd7yEV1?=
 =?us-ascii?Q?wiBfODYofhAPyz4rnK3EfUZdG+9ahpwP7YcqiID65BDh8cjcZPIrgYIaBB3a?=
 =?us-ascii?Q?+VRAkLmylhLCR8OojfWGzsE84omLVy8354cd5VfEr/Ep/ZmgQNA8yhiW0Sry?=
 =?us-ascii?Q?nKAT2jL7FBmGKLeprgqiXRhQClv2lh1VOzzZdcbtJ7L+O+0ndJFr2dCdleW7?=
 =?us-ascii?Q?EyN67ybNvenSkLUA+PlNH/EBi//JHchCCOebvXGOKwo5y0fkvxdVXfAbEsAh?=
 =?us-ascii?Q?RRiHsy/mhUf99471z+ssaUI5xgM51CSdonwqT316sAg6qAouFIPm82hPMQbB?=
 =?us-ascii?Q?QSvCSHxgiCvUFDJLD/tQwBM75P/SA1IGxe4MCMUam74AmLhw6Rl/5e1pU6uU?=
 =?us-ascii?Q?+hVSu7YivCnZOqixgYA6Qhi1+MBNxBsxCW/QgHjC5duITafygY/e9YHeLLrJ?=
 =?us-ascii?Q?PSBJEW8CzSikjt1jq6pohWYLeLt9mOIeIPHFOmLniV7YFOiAG/opfP7Cs8Fu?=
 =?us-ascii?Q?gqg+m9Ro9ptlciJx2uAkPZRGyuLeTuqCSwf+0O6fCL1bEWMENtx2HWQReZpj?=
 =?us-ascii?Q?L+xQpTdZ6Nc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?6uoRtHWcWvZqn0vdZPgY35ZCVDL39gEzVd+akz3vrt1D9/7mSY2wmu39KTX1?=
 =?us-ascii?Q?bAm8LBjB0h3EJf6FLRK8GJ0tFv6LtPS/H9PukRByBb0AB5PDBKduoJwxaTnl?=
 =?us-ascii?Q?BZL+JB8scA9OIUZsJklWYJWiL14qOgcTmuxatSbQi/QuuanI6AYoQvVBa8Bj?=
 =?us-ascii?Q?T4MSuypCGXNzxIZZkK6Ii08Wlv7uM8w83/uG4vv+kV+sVmuysKMVoDYyb/dv?=
 =?us-ascii?Q?J+LsroxsUqq0rtqhAcyEF0bKANsafMnhCPRPKy3GURaQE6bSYikCJF37/Q34?=
 =?us-ascii?Q?iXmrwky/Hm7IrDw1A0MwNCGOfWCz7TwNykcnHwGhToKjZxkDv7I3dPhBLfUi?=
 =?us-ascii?Q?8eTlMra1GV+7Sg2mxf4De3tMu3abe6ndNZm6Lg967RDvn7x+RhdmTOu+6/Qj?=
 =?us-ascii?Q?QH7ABlMdb20MGuzMfsCftFvMqQ/bVvoSZUEfHalhMwYtQ9FP84cOA50VvBW/?=
 =?us-ascii?Q?bmiqOB5pClDI7vZPVCxDZF66xPrl+/7/draCIJJ6f+nAJElVtW4sMaaNLOJT?=
 =?us-ascii?Q?RVcE00Yefhy4adnd9+9WX8ZhfAp7PsewPPQwziYb1g1El3Im3XkYq7v2DWvv?=
 =?us-ascii?Q?7eiTwKR68K08f3/2npNM4VpFdVTIczhSGTA8uT0Fk2lvcaI8SjTJRIkj7VRg?=
 =?us-ascii?Q?K7W3LmkvszzxUDH88FEufWV5lbf8MYlYqkHM3ffH7LwHTR3I+GygcDbNJ7ng?=
 =?us-ascii?Q?SXXsZfk0XPahJVkKz9+hLYDYSaPmkhs4h7hHQ5fMNExHitq/DhwS0gVaYBfq?=
 =?us-ascii?Q?hBHQLRaPMkPKNajhXARLH7gWzTeZ+6sU4kEQePeEEsheCciPVBbu4dSCaZ6q?=
 =?us-ascii?Q?Ed92t9RLrQDZQuMC+hzBJbv0fHioR/YkaXQCvdPqlpnKUDkwz6CtvOvn/6HS?=
 =?us-ascii?Q?HolaAJTUzUNa9TfK85HjAh01QkFv/vdwWN/DdZ1AclXAUhGXZ84nJw/SoJNB?=
 =?us-ascii?Q?WpJUKWRppl5WgbnWLYkMB6GAJsxt6xCY4jwVicPwSq108WrfFkJzfbuAnYCq?=
 =?us-ascii?Q?y6in4Y3hJuLdQLYS1pAx5MhjWY/iGiBL2IHQRlt8MY7XyzCImpR4heC2Sy/R?=
 =?us-ascii?Q?BCba/Z88VvHhfFtE1iVEtoosC+UEB1VomdcylF6P9QZQBO5GNXMk3Jd7l9Ro?=
 =?us-ascii?Q?ZfTXms1plcZiYBPMXpnBS+6MHNlFp5JVYOJo92HUl35V6Obn2yw3n5nYYpVy?=
 =?us-ascii?Q?FQr7sFs+e+1105GIT4LF7guEO5CqB//JicIAy48cansWS7gFf9P7gIuCdp+y?=
 =?us-ascii?Q?Le6nsXaT+NSYxQBMDd3U2loIZH9h5evBU47DO5SY2szG259FQc4QNeHfRpko?=
 =?us-ascii?Q?pv8KbwRYUFGNiD2PVm9bzPun0waNTEhE3uX0EdAIrnj1bAkzCKXnpfnT9yNi?=
 =?us-ascii?Q?yjWNtDmvoIWTfUZOymBo7Z5Bg7X19Zs4hwwTZJPnMqpG6c9n5GPewtrxm4vW?=
 =?us-ascii?Q?UXfXtyFMBV8iK/IOQKd9+ULIgxFShGOVilJaDgFheMXLTzLKuWdperaFII2B?=
 =?us-ascii?Q?jOF32iaiulphO1LpJhLYnxeYCoBgMiW3y/dEuiGkukb8fD6CZwRo5CzHBAjg?=
 =?us-ascii?Q?RHvFLJPo/z1gz8c9A5jTlKtWyh9m7q8D6cHjLNAg?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5382d336-010c-485d-c963-08ddbef837e3
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2025 14:52:25.8373
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U2zUuieJURb6EuHtEiJQHyqGJ+IIZiAICVNSWSEjRPCqu8E2DvrhrB3SEQtfKsz0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6356

To avoid some internal padding.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/iommu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 8b152266f20104..7b407065488296 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -58,13 +58,13 @@ struct iommu_group {
 	void *iommu_data;
 	void (*iommu_data_release)(void *iommu_data);
 	char *name;
-	int id;
 	struct iommu_domain *default_domain;
 	struct iommu_domain *blocking_domain;
 	struct iommu_domain *domain;
 	struct list_head entry;
-	unsigned int owner_cnt;
 	void *owner;
+	unsigned int owner_cnt;
+	int id;
 
 	/* Used by the device_group() callbacks */
 	u32 bus_data;
-- 
2.43.0


