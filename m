Return-Path: <kvm+bounces-25293-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D82099630EE
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 21:27:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 08C5D1C22B2D
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 19:27:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E9761ABEB8;
	Wed, 28 Aug 2024 19:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="WC20kxtE"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2055.outbound.protection.outlook.com [40.107.101.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F28C61547DD;
	Wed, 28 Aug 2024 19:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724873256; cv=fail; b=fwec96HxX86bYsGs0ivYnI3f5FuP6xLbMbQ4R+1TaH+OB5urkAO7Wwch4viaV+pAIIdUH4sS8miNZn5PDH7Bj8tpzhS8iyYE+0xWhggnpGxnDwuMbKNxQVSwxJAHhiVYPY6DSsX4OPFv4MCFL0owmj06QXT3rkTR13Tirh8o8Es=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724873256; c=relaxed/simple;
	bh=zeFcb4q4a4pO9A2C+0bgW4Eq0+U763aIk1U8GG49oSY=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TEBcZaMJziAkKbmKtm2Rad7aF/m5m7LGpn7lHZHTKVlrfPVobKDZGCdXrCyFx0awgnst5M7oiB7+02j0nM5lXHtO6cK968MrhbLIP4OBfvDMiuXv2j2SSMFFXQz4Dl282Ziwa0PPhsZqT2HWk7OzTNbTNnVPkCVR7xJtezsWIRY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=WC20kxtE; arc=fail smtp.client-ip=40.107.101.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JuR0OKgo2CtbXK5lsn5jKgogCxHqb2ON4NuzjlB9BrvH6xVZEYdxEMEIfMxrp3Jid6oQ0rYTWuWOVeF5HOSfVwYW6hx8j/52TSFmvjGOVNNeUbzftwM9FG8RtvdyIiO7z1/MhK++mKOpAw7YYKfaujJ+wBTjRvKjJh9jTukXJqj7ibtX+lCXowfs7wrMiyta38yJxL4LtSQNNUgzsNGTDZZcM8x2xq4RY2TLrD/RLWBqNZnaowmEtJyWQOmlzC35EuhGYvzv/S/sAn1zMJs5vvZsUad3EQYjX1xt1VhN0D7nKNAfi9LXvbMd+RL5hdN2FEY5Pq1R/DkmWT5Qef8QxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u5o74GjldS76Aouu3F8J7rUSmu8qXl7a3Y4k/WLsGEA=;
 b=jCvwNuOr5us6GQvkMoIRE9PEG3cOMy3HJzPSrrDztDLmP98hGjYrxuVv4LoGmsuLs53w8JxlzkT11ra2ceq1Aro4K5OpLI1qHs6TFlioPyt+Ts0IjGWCTltrWFfVdkvB4CSiosq67W3tpn0ThzwYwJV612swuF20syh5MWGYgkSmYsXMJBzhSXAVb7G3zUq9qk2ytm6rNhOQb88KZl+ZS6QN1xte6Q1ENLvMjKLwgAEma+0nlDTFYwXyPHcGZGwZhrsXQJJB6y8A/twjIPza/zdnqr1Qoiay+1XeqGIfrfOeJ39zNsqyEZQeKiaNKuUuTT5dvIYvTYfkRvlL5vUVuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u5o74GjldS76Aouu3F8J7rUSmu8qXl7a3Y4k/WLsGEA=;
 b=WC20kxtEzpYm8YPOFkoQpBqAWUwJCM9uLsDrYzMNX3DQofOOxUWzd7iJuUi7sAwR3eUbjD6D+ZO0aUTzJvNFP3TFLODjb/v6XGwovoEkyXklyPC94bHgjDi+kDIqQ9XdjsWPb0nd2EmcQcE8Yl2B+nFbZChAnBWP2681xjf6JNRwJd7aFE+fpMLQ/lf46pApE/z+ilFw3eoUyYjbHzv2ZcQtsEcBdGw66JZEjDfsi6uSDugb7E2cXqcxLKS2oo6W1IJOTULQm/mkYPgK+L3HEVOFWeXRWDOnVVMrr7vtVQZx2QNEYnrM+iHcdLV2ceudOZ3d59V5h3LxzHgr1jWefA==
Received: from DS7PR03CA0079.namprd03.prod.outlook.com (2603:10b6:5:3bb::24)
 by SJ0PR12MB8137.namprd12.prod.outlook.com (2603:10b6:a03:4e5::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.26; Wed, 28 Aug
 2024 19:27:30 +0000
Received: from CH3PEPF00000014.namprd21.prod.outlook.com
 (2603:10b6:5:3bb:cafe::eb) by DS7PR03CA0079.outlook.office365.com
 (2603:10b6:5:3bb::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.28 via Frontend
 Transport; Wed, 28 Aug 2024 19:27:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CH3PEPF00000014.mail.protection.outlook.com (10.167.244.119) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7939.2 via Frontend Transport; Wed, 28 Aug 2024 19:27:30 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 28 Aug
 2024 12:27:15 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 28 Aug
 2024 12:27:15 -0700
Received: from Asurada-Nvidia (10.127.8.13) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Wed, 28 Aug 2024 12:27:13 -0700
Date: Wed, 28 Aug 2024 12:27:12 -0700
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
Message-ID: <Zs96EOG48M6AiDwf@Asurada-Nvidia>
References: <0-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <8-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <Zs5Du208eSxU67wT@Asurada-Nvidia>
 <20240828190100.GA1373017@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240828190100.GA1373017@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PEPF00000014:EE_|SJ0PR12MB8137:EE_
X-MS-Office365-Filtering-Correlation-Id: 7a07d0e7-8215-4eca-52e5-08dcc797754e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?m43J9tHwiEmR4s66slbZAyslcg1rx2QDu/KY7MhnTrmP3Dl69JBHxAnl+iuB?=
 =?us-ascii?Q?yuXiLiY2tACA4W+otP6giQ2Ce1tL2/Vdq1PfyKbn71z9dvJZzIIACQoNK7RF?=
 =?us-ascii?Q?RgX3cK4FQigvbBqpeKv9sofTzZ3PgnwaWOZhg1zuD6RxIYv1m6BgFKwThcvh?=
 =?us-ascii?Q?rjKLrOiztobljJp/t5JkGnuLwaAzMrtDpFDOTMUXfZM8xg4vzxnTpCpS6qXi?=
 =?us-ascii?Q?SE0YaJx0kGXpl3h3FpEWRwUY8kpLHlflJYG3ncY/RyQDghulM/8ftTyROGSc?=
 =?us-ascii?Q?5DpxxaTTbw3WSvpeJ/R+1PWlh5iCpCMqfrB4X6+Y6LtDffKubgv8lVaaXH49?=
 =?us-ascii?Q?vLUWglvaOunL3JOZ+yl+HwpJpCFxvwmMziZuJhHgnqgZD6rhzl3Jy1GHTfcP?=
 =?us-ascii?Q?JBAGKfr5H3+tkGsN0yLGBLXsDYOtxUZgbkWgAzNxy2YSHODFPdaK/TYPLaCa?=
 =?us-ascii?Q?omtWHPj/zTX2SzTabr1MGX+wIZexaLTr2btMTBv2E7FK7la2g93cenpbSHjQ?=
 =?us-ascii?Q?ThBOCSc5Y+JqkpFgUaigb+wtN3fR6H+cOAiEkymWmU051ApW2P4RZE9pa5zR?=
 =?us-ascii?Q?3hpWMYqIZd6R0rUa9oI7vPHSppbfVnCzg1UO+UeOSxG4P2q3N34UHlUHWiZQ?=
 =?us-ascii?Q?WS853Q95ihRxcjzHHa6Zj/EcuP5kY7QVlqE3FWcnwbgruxCEFXBg0j4w4eo5?=
 =?us-ascii?Q?Vs0nNOWhBuOx9QRRpiv9NscIeLrtcW2PlgQy3sG/X3rCyQCt92d5JIazDDvE?=
 =?us-ascii?Q?WYi+ojYjOdPHboeQ5FIYnYSKLCdwGBDELrT8naexAZ+8fHlE4CS9cyldDLu4?=
 =?us-ascii?Q?BBfFjx15qWqmKrEvV1nVXu2CAbk/aIfdAHhJtYTDaLShbWdvxmC/nd9FFlZj?=
 =?us-ascii?Q?JGGnM0RmXHhv+z4MwnVwPRCK80y04J2/Xtu1qMau4ZkZ+n2DGOLnPVhtRcHT?=
 =?us-ascii?Q?WkarN8F+RKK0P0nsSVEBZ+V98kJWpkcmQy7Po6ymafrXmGYz9iXZ0hdPUw/c?=
 =?us-ascii?Q?PrM+hkZcnGOAHGAzfTXs2ABYgFKvSoe/Hoz/zWkf6or2NSM8lI1sZDm1W2Wv?=
 =?us-ascii?Q?kJXl6rDjWrJW2acr8vWDKxzjhxX1VxWJf53jLgSA6HtzOIKh+TP5bOugYCCf?=
 =?us-ascii?Q?NcVreU+OH1dr6m1GmnZRc6CQttK8Gr9ekE9CAGfdMcwFwh/ee/9yrKEsNN4N?=
 =?us-ascii?Q?HWI29gxd11bO2SnDHUuA77kbOubSvcYXqFVX9SNQrL8OmuWxf2lqFlzWrHXm?=
 =?us-ascii?Q?9zWdKc9h/gYmgGzZ5Y/OjUfBR13gmljwtTOmoIa3RgLLdqSvMmxIpfDbV7s8?=
 =?us-ascii?Q?bUPjFRIJeMPNc33B0q4RU50oBvm5Ff8VyTuS2ECC7Gdj+o7t2NINJ5TbK4L+?=
 =?us-ascii?Q?FLWWW4GiUs4W/mZYzsYI2WjCI46Xe+Ce6ferk3eHJ5NId1cd2v+zg3JDs2QJ?=
 =?us-ascii?Q?nS7dPXItqnS6LmTPN3TwzexV3qQ6dgEk?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2024 19:27:30.0105
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a07d0e7-8215-4eca-52e5-08dcc797754e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF00000014.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB8137

On Wed, Aug 28, 2024 at 04:01:00PM -0300, Jason Gunthorpe wrote:

> > > +
> > > +	if (!(parent->type & __IOMMU_DOMAIN_PAGING))
> > > +		return ERR_PTR(-EINVAL);
> > > +
> > > +	smmu_parent = to_smmu_domain(parent);
> > > +	if (smmu_parent->stage != ARM_SMMU_DOMAIN_S2 ||
> > 
> > Maybe "!smmu_parent->nest_parent" instead.
> 
> Hmm, yes.. Actually we can delete it, and the paging test above.
> 
> The core code checks it.

Yea, we can rely on the core.

> Though I think we missed owner validation there??
> 
> @@ -225,7 +225,8 @@ iommufd_hwpt_nested_alloc(struct iommufd_ctx *ictx,
>         if ((flags & ~IOMMU_HWPT_FAULT_ID_VALID) ||
>             !user_data->len || !ops->domain_alloc_user)
>                 return ERR_PTR(-EOPNOTSUPP);
> -       if (parent->auto_domain || !parent->nest_parent)
> +       if (parent->auto_domain || !parent->nest_parent ||
> +           parent->common.domain->owner != ops)
>                 return ERR_PTR(-EINVAL);
> 
> Right??

Yea, this ensures the same driver.

> > [---]
> > > +	    smmu_parent->smmu != master->smmu)
> > > +		return ERR_PTR(-EINVAL);

Then, we only need this one.

Thanks
Nicolin

