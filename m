Return-Path: <kvm+bounces-25202-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 15B8B961926
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 23:23:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8B9BF1F246C7
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 21:23:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D90711BF329;
	Tue, 27 Aug 2024 21:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="GhbXSna/"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2072.outbound.protection.outlook.com [40.107.93.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 323EA17C60;
	Tue, 27 Aug 2024 21:23:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724793808; cv=fail; b=uOkf0hl9Cazu7zBYe+EXkZNflSPXwIIhuYSyAL5HbQmAyOx8c6UBl/vhCqM6IiI8/KYWmlN9UbLUJhHk/sBIuJcRonOcACgwppmZVaBI/eP5zWHZLuUPk01MVHP71NznzsWZZskF/qjP0URBwoTsNn4VuhvAmaxRQgvkb4ZL1f0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724793808; c=relaxed/simple;
	bh=eOuN07ACcvHMngwrw/1nEG7fsHciIW1VUd6gH3nWfYs=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ztr+o5w7ZZil1bEXLoGcvKdwhRtLy23WC0WCqZF7hprjPW+v0lYcB2fqVnLYW9JUaevrcJ8hwiSDcMkp9f84B+bTzdFQNlZL2druCCGrGS+njdnv2JfXvRy9MDb5Yk+yowOz6cbuhFf9I+T+KZNtWFQQdG8qVQw3X31rltLVu4c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=GhbXSna/; arc=fail smtp.client-ip=40.107.93.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YKkh/EqP2E86AtPbypfQGD3utUZjKTZhSqljv9V/Jq6DVzimrMIkCq7HrjN/6KFFQdZnKvbbJOKTJcZP/Q1BrZezzUUWfB82NVPaTPzFrUkG8wqF0AVezFiN9dc+D+bnLB++CY+HY3WHQW0J2Jp/ygQtIU7uhgI4C8PmNC5Qll6fyEgDGdCaI9BxyOx+qBsVVneMBj8ERZj9RcBy84FZk/z/+98IZr4DPb4ZC41lWUwg0mtz0x0JcTvcpdcPNUa8gGWdyBTFxo1Sp4T7jZ2PocviG9luzQ6/spRMuLFySyUFLECu30ss9z5yVnitxmmm0bwzyi86QiD/jdtk5nUNIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w44ZimNARQvX4E+8UQw9TGsvvE2lLhMigGW34OIvqpM=;
 b=JF8duvxuTvPNDDlldjniH59ugP2GtEBuMBQYmHbIS0hszaF3ACVBb8nfpIj1NhtEUo1TA+fhGQDu6jfSVW2cy1CyIj0EQqvJGdhfLR+JyVII0uBpKU2wbfKLzuIAQ2PFQoPiFAwfYq/4lQ8UHdVWCy3zVLXRTvR7jp0/6C+w2U3MFCxli+DqPoGX4fzrXugTPkFGq5540zLzMCAxWBIrbyhlkc1pnFhKpb0Kd/1S18R1Z8H2S7oBTxObZgP9wGg/rL4L+P4Geuoz+2SJHF3WcHoMXtAAYUHJv3vd44jC5QijVKLgzh2zlwPZPQgx6dQ4PhN9QJEPClFuFluysh7/nA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w44ZimNARQvX4E+8UQw9TGsvvE2lLhMigGW34OIvqpM=;
 b=GhbXSna/k/H891n93+jOAZhlW+/Sz+WQ+JZXtwbY9Q2ln17ngWkec7eXBbyZU0sSRvafsKFZe4dn/7U+oVV761/RVK15ySCpVbpT/ZU4YXxV5lgWNCt6rEXtr/RfKZBKol4+oeSLnCnyQeO99zwam+lwdb61n5AMpN7p25jVdxYtxfm2V9OjXVSuQ8C9dAVNTKViPwOHDrJ9GYfGHGtQQ9EDJYHj4C4nkcSwZefu8z5q0bxwjVmmbbVWMo23QceRYN2HPQvOrFvA+BdxCdSObSiGBLspqdZGw70SzU9eP9mKDs7tmFOVyqIZTYcp/7Xf0DArlAekSiUhRf1sbGOLpQ==
Received: from PH7PR17CA0055.namprd17.prod.outlook.com (2603:10b6:510:325::16)
 by SJ0PR12MB8166.namprd12.prod.outlook.com (2603:10b6:a03:4e2::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.26; Tue, 27 Aug
 2024 21:23:21 +0000
Received: from CY4PEPF0000E9D5.namprd05.prod.outlook.com
 (2603:10b6:510:325:cafe::10) by PH7PR17CA0055.outlook.office365.com
 (2603:10b6:510:325::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.21 via Frontend
 Transport; Tue, 27 Aug 2024 21:23:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CY4PEPF0000E9D5.mail.protection.outlook.com (10.167.241.68) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7918.13 via Frontend Transport; Tue, 27 Aug 2024 21:23:20 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 27 Aug
 2024 14:23:09 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Tue, 27 Aug 2024 14:23:09 -0700
Received: from Asurada-Nvidia (10.127.8.13) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Tue, 27 Aug 2024 14:23:08 -0700
Date: Tue, 27 Aug 2024 14:23:07 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <acpica-devel@lists.linux.dev>, Hanjun Guo <guohanjun@huawei.com>,
	<iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>, Kevin Tian
	<kevin.tian@intel.com>, <kvm@vger.kernel.org>, Len Brown <lenb@kernel.org>,
	<linux-acpi@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	"Lorenzo Pieralisi" <lpieralisi@kernel.org>, "Rafael J. Wysocki"
	<rafael@kernel.org>, Robert Moore <robert.moore@intel.com>, Robin Murphy
	<robin.murphy@arm.com>, Sudeep Holla <sudeep.holla@arm.com>, Will Deacon
	<will@kernel.org>, "Alex Williamson" <alex.williamson@redhat.com>, Eric Auger
	<eric.auger@redhat.com>, Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>, Michael Shavit <mshavit@google.com>,
	<patches@lists.linux.dev>, Shameerali Kolothum Thodi
	<shameerali.kolothum.thodi@huawei.com>, Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH v2 8/8] iommu/arm-smmu-v3: Support IOMMU_DOMAIN_NESTED
Message-ID: <Zs5Du208eSxU67wT@Asurada-Nvidia>
References: <0-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <8-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <8-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9D5:EE_|SJ0PR12MB8166:EE_
X-MS-Office365-Filtering-Correlation-Id: cf3918e4-8eab-4fa6-da96-08dcc6de79e5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?NWX6stM1pw7GUa0ElGwOwjG/aZAQ8+Idu7m6mYUdJAxqY0cwcm9E3HIm0yKd?=
 =?us-ascii?Q?tf9HM2CGwXBGyi2vGV9SjgnOtwyUwoW3d5Q3DbVjCICNMsruIna08+YnGnLG?=
 =?us-ascii?Q?JRRtA+glOmlZMBhsj6GdWB9WRG16XVmgKzqTlF0GFza0NbiLrpAMnESGunGq?=
 =?us-ascii?Q?VTgv5XyuQwZrWBlySu57OdLD+PMmc9hlh4L37salcf0PAWDV48PYW/prFoZm?=
 =?us-ascii?Q?rTTmvoLusdzCEMDSnZac0pbWsoiSyCod2zdnv4DlBFgZ0L++InW6XJ1GY0n/?=
 =?us-ascii?Q?2nRTlI20dBkzmdZppO8R3D/JUReV8YoRx3V7tpvXyPlipwvuiuAdZnLrssxB?=
 =?us-ascii?Q?r9emHnxrRRROxGaxe/W9mRZvIqgtc0RNoUZ+vFzP1+i+cQwoFHcyAMllCB+f?=
 =?us-ascii?Q?CuuYpYqkCgexNxvZc8wYllUA5MYPezpS3XrnegXDVEYTOulTjDOdoiFZWP23?=
 =?us-ascii?Q?VleskrE8WbRPgMMwHWUWSOLb/LhvA/myLoqVrrTrzn3i20mPs8u71RWTWeCJ?=
 =?us-ascii?Q?ftR55jM7/KaN9HjrPWzOb7CYG0w8DqE/fw0qDWiXufZChRsod2qYWZhbnJW3?=
 =?us-ascii?Q?eqY5xl16NGmBmvSfB7keTijXf94Z/v1Nh2b07u6eyi0noS96BxeA4vNpmhMZ?=
 =?us-ascii?Q?pERaMVs7GQlgXRSMgUXCiCkvY13eFo6GBOMC6RnJkCJTaleuD24rTr/s6NOt?=
 =?us-ascii?Q?qWE8/lBQmO/+3lqXLwVJwimo8lvJXYuaZw0ksUKYvC+az9yw3ZwYmcgfJyGT?=
 =?us-ascii?Q?dXTbXKz2wv1gZXrzIzHMBaUZUWBDRNYE3VUTdi8KVLrat8Jlb+8gz2a01oLs?=
 =?us-ascii?Q?+a6dm7LwGJ6JE6TWdf9oRrtQl0phodp+EQXAW5MaQNEf7Dy4zcdoDzULfStc?=
 =?us-ascii?Q?sxapRnLesHU1EFzpKmuPX0QkQrCWME/sdjhopf5+YLsw+71cKGYsN8rOUed4?=
 =?us-ascii?Q?HapAByPL2dP2O1t436u1pb/kVcq2gaM5HWJmTo2LGLBQv92ohCfmo86C20TD?=
 =?us-ascii?Q?PETn/wm2BDPyW95/vMr8/OsQ3PhRlHlQojwP4I5lrwC67VNfqTdxfpBWewZB?=
 =?us-ascii?Q?1pVLP1nZOio5+VLFzhobR9iopteoLLY/oqz35QnRLYr0QdeWin/ZIRk17uib?=
 =?us-ascii?Q?d1Bf89vdh2rJ2cPI2I6s+VLMZPk46PSW3z4XM8su19UOVEtXl4BHgoiR0l6x?=
 =?us-ascii?Q?c+hUNjduqhxgBjVbrQH9XAJnxSl6UCIUlcLvVJk/FMxyX5ZEg3uJRA30Emvq?=
 =?us-ascii?Q?CbWIMZs0XiuPxiI/I9igBfSfdov0Iv1nmWiVYBSBjfnC3jCgGRrsR+ZdWYeq?=
 =?us-ascii?Q?mqbKT47xAmFpnadDhspOVMMDI+M9zUvA2azUXOSyxOwPkZcyhFsEwxGL52vK?=
 =?us-ascii?Q?OdE611b/fjNm2v7qVZQ3w2yrJnykLAoUykkXp3SNFk9wsW7843uM5iX9GKfm?=
 =?us-ascii?Q?g7uJBX4TyuKUVaiW7xCFldiHT5s56ubf?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2024 21:23:20.8820
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cf3918e4-8eab-4fa6-da96-08dcc6de79e5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000E9D5.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB8166

On Tue, Aug 27, 2024 at 12:51:38PM -0300, Jason Gunthorpe wrote:
> For SMMUv3 a IOMMU_DOMAIN_NESTED is composed of a S2 iommu_domain acting
> as the parent and a user provided STE fragment that defines the CD table
> and related data with addresses translated by the S2 iommu_domain.
> 
> The kernel only permits userspace to control certain allowed bits of the
> STE that are safe for user/guest control.
> 
> IOTLB maintenance is a bit subtle here, the S1 implicitly includes the S2
> translation, but there is no way of knowing which S1 entries refer to a
> range of S2.
> 
> For the IOTLB we follow ARM's guidance and issue a CMDQ_OP_TLBI_NH_ALL to
> flush all ASIDs from the VMID after flushing the S2 on any change to the
> S2.
> 
> Similarly we have to flush the entire ATC if the S2 is changed.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>

With some small nits:

> @@ -2192,6 +2255,16 @@ static void arm_smmu_tlb_inv_range_domain(unsigned long iova, size_t size,
>  	}
>  	__arm_smmu_tlb_inv_range(&cmd, iova, size, granule, smmu_domain);
>  
> +	if (smmu_domain->stage == ARM_SMMU_DOMAIN_S2 &&
> +	    smmu_domain->nest_parent) {

smmu_domain->nest_parent alone is enough?
  
[---]
> +static int arm_smmu_attach_dev_nested(struct iommu_domain *domain,
> +				      struct device *dev)
> +{
[..]
> +	if (arm_smmu_ssids_in_use(&master->cd_table) ||

This feels more like a -EBUSY as it would be unlikely able to
attach to a different nested domain?

> +	    nested_domain->s2_parent->smmu != master->smmu)
> +		return -EINVAL;
[---]

> +static struct iommu_domain *
> +arm_smmu_domain_alloc_nesting(struct device *dev, u32 flags,
> +			      struct iommu_domain *parent,
> +			      const struct iommu_user_data *user_data)
> +{
> +	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
> +	struct iommu_fwspec *fwspec = dev_iommu_fwspec_get(dev);
> +	struct arm_smmu_nested_domain *nested_domain;
> +	struct arm_smmu_domain *smmu_parent;
> +	struct iommu_hwpt_arm_smmuv3 arg;
> +	unsigned int eats;
> +	unsigned int cfg;
> +	int ret;
> +
> +	if (!(master->smmu->features & ARM_SMMU_FEAT_NESTING))
> +		return ERR_PTR(-EOPNOTSUPP);
> +
> +	/*
> +	 * Must support some way to prevent the VM from bypassing the cache
> +	 * because VFIO currently does not do any cache maintenance.
> +	 */
> +	if (!(fwspec->flags & IOMMU_FWSPEC_PCI_RC_CANWBS) &&
> +	    !(master->smmu->features & ARM_SMMU_FEAT_S2FWB))
> +		return ERR_PTR(-EOPNOTSUPP);
> +
> +	ret = iommu_copy_struct_from_user(&arg, user_data,
> +					  IOMMU_HWPT_DATA_ARM_SMMUV3, ste);
> +	if (ret)
> +		return ERR_PTR(ret);
> +
> +	if (flags || !(master->smmu->features & ARM_SMMU_FEAT_TRANS_S1))
> +		return ERR_PTR(-EOPNOTSUPP);

A bit redundant to the first sanity against ARM_SMMU_FEAT_NESTING,
since ARM_SMMU_FEAT_NESTING includes ARM_SMMU_FEAT_TRANS_S1.

> +
> +	if (!(parent->type & __IOMMU_DOMAIN_PAGING))
> +		return ERR_PTR(-EINVAL);
> +
> +	smmu_parent = to_smmu_domain(parent);
> +	if (smmu_parent->stage != ARM_SMMU_DOMAIN_S2 ||

Maybe "!smmu_parent->nest_parent" instead.

[---]
> +	    smmu_parent->smmu != master->smmu)
> +		return ERR_PTR(-EINVAL);

It'd be slightly nicer if we do all the non-arg validations prior
to calling iommu_copy_struct_from_user(). Then, the following arg
validations would be closer to the copy().

> +
> +	/* EIO is reserved for invalid STE data. */
> +	if ((arg.ste[0] & ~STRTAB_STE_0_NESTING_ALLOWED) ||
> +	    (arg.ste[1] & ~STRTAB_STE_1_NESTING_ALLOWED))
> +		return ERR_PTR(-EIO);
[---]


>  /* The following are exposed for testing purposes. */
>  struct arm_smmu_entry_writer_ops;
>  struct arm_smmu_entry_writer {
> @@ -830,6 +849,7 @@ struct arm_smmu_master_domain {
>  	struct list_head devices_elm;
>  	struct arm_smmu_master *master;
>  	ioasid_t ssid;
> +	u8 nest_parent;

Would it be nicer to match with the one in struct arm_smmu_domain:
+	bool				nest_parent : 1;
?

> + * struct iommu_hwpt_arm_smmuv3 - ARM SMMUv3 Context Descriptor Table info
> + *                                (IOMMU_HWPT_DATA_ARM_SMMUV3)
> + *
> + * @ste: The first two double words of the user space Stream Table Entry for
> + *       a user stage-1 Context Descriptor Table. Must be little-endian.
> + *       Allowed fields: (Refer to "5.2 Stream Table Entry" in SMMUv3 HW Spec)
> + *       - word-0: V, Cfg, S1Fmt, S1ContextPtr, S1CDMax
> + *       - word-1: S1DSS, S1CIR, S1COR, S1CSH, S1STALLD

It seems that word-1 is missing EATS.

Thanks
Nicolin

