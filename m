Return-Path: <kvm+bounces-63658-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 71C06C6C7FB
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 04:01:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 308BE355EDD
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 02:58:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F6DF2D4816;
	Wed, 19 Nov 2025 02:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="V2NNDAYl"
X-Original-To: kvm@vger.kernel.org
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011013.outbound.protection.outlook.com [52.101.52.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF3FE2D63F2;
	Wed, 19 Nov 2025 02:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763521091; cv=fail; b=PdQ+eu3Dh55FDhtyttSwoPIprLwImnGvhdRmTOXt8nBXrQpQ3dvUhlwuUirGXgSKPPgztNb4TjGoWBjCJ2yzn3wg4vd6PPFLR1CtlFLMcI6dpv+bWLUGtMycakJV01xiRIW93usO+Y+EaqvsIVTrMknJkpzkbqF0gk8LY4veUqE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763521091; c=relaxed/simple;
	bh=IU+xN4mGlYYcOWYy8U2067Tzm1156ueIINw++idTvGQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O9I/AQnR/HlAsqQqzn06Qgn1E0D3KdfzEoMR2hBh0+r3UGU53P0c8FuxtfqsgdSDeNspLjwlh5pTMB1wBFbV9BBNjdKQCOy5OdDsGu4579OTkv++qeZh82Q3+gY/nKF4OP8sPjDs6u16iTUdnfK63JNLOuXBVUlhwv7BVtKR9x0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=V2NNDAYl; arc=fail smtp.client-ip=52.101.52.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=d9svGsATLQpCMy30lRbYg99UkUmruAYoUEUbJWXDH+8tQ0WO0KskJ7b6icSYLoALckynO3y/yyst3i2YO8OPLG2m40Pa+NgAx7yqYDIUoIDk67u2OyNbC2xO8g39avgD3CtcMWasyQkIE+IpBUZM7M3IgYD5AyzkiZZItuicMr4/xbdPzGdnkUAzF9lRk4vusrI3hmW6M0nifFw2Xn4RxE99orO5wUyzoBm2kZJ80T9cdNW+A1DHZ2AMLFfFt/ShJAW7LB0gMpS6H5xActMOyAUlplNcHiAvJ8KNsZf2OhwkdDM+p2eamV2IDMFuO2TlrGlpQ8sepFsSxbZsb/KDFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oQgO+5ebdOnWGfqH9mnnlh3Ijz/z4H6/GahjpM15XXQ=;
 b=f7zTvl6h/hqco1xGjkhkgaWStgbtd0eYroItl46fKignklJmpYWbxA3wpXTt5w21x1Vl8nNyIGFLuOjkrqB8UCJbjOw0gxre4TeXkYUglQ3kobqfkqcnxzk2TydSHdPlpA03JzmX+w4ueyIljUB4mp64FlbKS1+Rt7udtQ4I1Ivw9GCjV8IOXDZUVsER49JeZWne2orQmX282/A9tZhArgsY/AZASe5fN8GyqKKdXckmSW0zTyZx1Zzdog3r8KNhym5YNr9G757xhI+p9PUm9WF7UmLxNQhYfWXjtClg4PUm39jaL39b79tV/TcclxyKTfbGq3lZn/YoJAytG2FpNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=arm.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oQgO+5ebdOnWGfqH9mnnlh3Ijz/z4H6/GahjpM15XXQ=;
 b=V2NNDAYlaI1nkJ/u7LVncD4T4tXWH8Gpyges8bOyAidNY/nYYeNeGQi22PzGdl8vnlAOEHUk0mhMrKmcmCvrS/dUrMtl2usnnMOPiASNldRaJsJmi2Il59Mz+4AzMe7R05aDccDGz/px1pSd/aHJPZ7TZmNPo3v99e4oMPN290SWzDZkpYPgq8qN1Fp2WnMFmrttax09HyoXYMuoSWiCljuV0NrMH/vqM1WRi3x5CqMbgcDinASoVq0mNW8u6CvDFtlwOqnXDn72PBixIDzsGWt5jrj3M+z0fN3QZciIyHBRDza6KB/YbmlcxFeHthiCSGSTxEWtsvVwkoQ3nfdGEg==
Received: from SN6PR08CA0005.namprd08.prod.outlook.com (2603:10b6:805:66::18)
 by LV2PR12MB5822.namprd12.prod.outlook.com (2603:10b6:408:179::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Wed, 19 Nov
 2025 02:56:53 +0000
Received: from SN1PEPF000397B2.namprd05.prod.outlook.com
 (2603:10b6:805:66:cafe::de) by SN6PR08CA0005.outlook.office365.com
 (2603:10b6:805:66::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9343.10 via Frontend Transport; Wed,
 19 Nov 2025 02:56:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SN1PEPF000397B2.mail.protection.outlook.com (10.167.248.56) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9343.9 via Frontend Transport; Wed, 19 Nov 2025 02:56:52 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 18 Nov
 2025 18:56:36 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 18 Nov
 2025 18:56:36 -0800
Received: from Asurada-Nvidia (10.127.8.11) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Tue, 18 Nov 2025 18:56:34 -0800
Date: Tue, 18 Nov 2025 18:56:33 -0800
From: Nicolin Chen <nicolinc@nvidia.com>
To: <robin.murphy@arm.com>, <joro@8bytes.org>, <afael@kernel.org>,
	<bhelgaas@google.com>, <alex@shazbot.org>, <jgg@nvidia.com>,
	<kevin.tian@intel.com>
CC: <will@kernel.org>, <lenb@kernel.org>, <baolu.lu@linux.intel.com>,
	<linux-arm-kernel@lists.infradead.org>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-acpi@vger.kernel.org>,
	<linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
	<patches@lists.linux.dev>, <pjaroszynski@nvidia.com>, <vsethi@nvidia.com>,
	<helgaas@kernel.org>, <etzhao1900@gmail.com>
Subject: Re: [PATCH v6 4/5] iommu: Introduce
 pci_dev_reset_iommu_prepare/done()
Message-ID: <aR0x4b7fN22K36jR@Asurada-Nvidia>
References: <cover.1763512374.git.nicolinc@nvidia.com>
 <246a652600f2ba510354a1a670fa1177280528be.1763512374.git.nicolinc@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <246a652600f2ba510354a1a670fa1177280528be.1763512374.git.nicolinc@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF000397B2:EE_|LV2PR12MB5822:EE_
X-MS-Office365-Filtering-Correlation-Id: 8802f48b-3f4d-441b-19b5-08de27174af8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?WB284D0OZKvWVVk/HR/th4cqbIRvwj2B8ljPQw1FJiyLqJrZ/tuQk2DC3Rsx?=
 =?us-ascii?Q?DdP5e58a+E/xAKIbyS9QiAclQrk5LcG2x7OymHNMzyETNChNvbrYJqrNLBJK?=
 =?us-ascii?Q?2y4N4zyAgjpGqvgRXUIjGADxSFBc1Hj2mD7aVvIeJCS6A7qIk2PirwhjLmux?=
 =?us-ascii?Q?ZgmkUF7IHzlzHLjHHGskYmNrVY+QwV3BtnaTAyEf5olKg7ND4vOtuR85L5Jv?=
 =?us-ascii?Q?2QVWOv04CDR7nXcOxrNRtHZNUfNjftk7Z6RJcPHh22Og6I9K1tdBddAlNP/R?=
 =?us-ascii?Q?Ltxy6UGNL193QZLsbjeyRz0oZlN8KsLvD139nC1h4L/Fybz2N8NNekYKlRVQ?=
 =?us-ascii?Q?EtLZ8AJWFZTQp3aqSNSYYLkPe11BrGsF8dPak9dfyJBb0TyMHHYA/hsChUk0?=
 =?us-ascii?Q?BcNEZZytQpD57+Fky7PPDEnMbQISz6FIYP8FVaJqjY4qvUcin7JQE110KdSP?=
 =?us-ascii?Q?Ui/nE7U5al3vsYOioi1LLbd8Wh+kbNhjUKpmZrLP+KydY5FhQET28CZVETV7?=
 =?us-ascii?Q?eO+HyKpEsSzMfhf5jD24StiXRjA5DLDe4qpKd5eXGcnzqwiK4QpBU1xrO1pC?=
 =?us-ascii?Q?BWUVTXIV9Z4+gc+CZFN82dpcyIYpuGzDvnM58iCUW0RcRQSOn5pb7o2zl1zx?=
 =?us-ascii?Q?tPO72iVg+6XS6jpowvLdifNRw0LCR6VnxLX7yvu8oPFnwIZxbCaunXZKOmWf?=
 =?us-ascii?Q?XEqtO18rR+5x8vmv9bM0SZYy5LYjmkJRqeCmKX4kfWNGx27yNblnD0Od+Jh5?=
 =?us-ascii?Q?ubgmZJ0SQT2z0yk5/cuvnB5oRvJbTq2Z+cObGKUr/bnPh6214i/3Y8Xvm24C?=
 =?us-ascii?Q?5rO/pGNuRaL7l7r5ydi18E46voWJllN7oe62dnDrCKmyJkgUsrnY3yqQOlxB?=
 =?us-ascii?Q?BwPsnih+80i9fXeza35K6B/f+K2DIIXOgisPKpT+h6F08qDjgJX5ZGp9Vd7n?=
 =?us-ascii?Q?mWt1sp9TY3qGol8t/R1tfVYQtg1L1s7dpQT/SJcWjRAlsI/vBrNi+Pp7ljQc?=
 =?us-ascii?Q?g6/57bsEbR4iQVlsIxAHlzB/Um4wLCf/9xpnm089HmKLFzF0+ijl16UiznRf?=
 =?us-ascii?Q?KjpH0r1YjHugNjyHXDzVSYjNeFggaaNO8IVhRPUzzf9UEyZvCRgQPpW6IjSf?=
 =?us-ascii?Q?VH+4KmdN6/NPB+7famYrygT5gztAb7fiS68+v2k8amZRAqVTvGnxXHWCWld4?=
 =?us-ascii?Q?PVTLBHBUoelfUXKQs+vVqnwCx3QMwCIt1bG+ySB9crnL0ppkgh3wbxHCbl6M?=
 =?us-ascii?Q?QK2TVj3AJo3CCbLCUaZycWaGd7Yij22/BBbQulWY3lwt0YaBNhsryOU6HJ85?=
 =?us-ascii?Q?GV3KJ2soHUHLMTKItMg+qEn1erRB9Nd01YHhv6hXfNcDefKabMU59U4W+T7+?=
 =?us-ascii?Q?FC46GrTvuFaGCwof8WIDW9AnTwWf1Ud0Xf/GkTjfFzTpB4p3YJ89GtHs64+8?=
 =?us-ascii?Q?5cCxwl7UmagVzTfWyrv1TIkNNDaPyb7lTbSYS9ZHd60xvHxbHVKpk4Bf/2SH?=
 =?us-ascii?Q?GePaZePPxSojFpG0AmcgXevrgSLgB3kz5eKL4ncGxrghX0um7KYCoSC31/iC?=
 =?us-ascii?Q?IjRBMgD6Z4S42c61RqM=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2025 02:56:52.7433
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8802f48b-3f4d-441b-19b5-08de27174af8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF000397B2.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5822

On Tue, Nov 18, 2025 at 04:52:10PM -0800, Nicolin Chen wrote:
> +/* PCI device reset functions */
> +int pci_dev_reset_iommu_prepare(struct pci_dev *pdev);
> +void pci_dev_reset_iommu_done(struct pci_dev *pdev);
>  #else /* CONFIG_IOMMU_API */
>  
>  struct iommu_ops {};
> @@ -1509,6 +1513,15 @@ static inline ioasid_t iommu_alloc_global_pasid(struct device *dev)
>  }
>  
>  static inline void iommu_free_global_pasid(ioasid_t pasid) {}
> +
> +static inline int pci_dev_reset_iommu_prepare(struct device *dev)
> +{
> +	return 0;
> +}
> +
> +static inline void pci_dev_reset_iommu_done(struct device *dev)

Ah, I forgot to update these two using struct pci_dev..

Will fix this in v7.

Nicolin

