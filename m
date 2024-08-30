Return-Path: <kvm+bounces-25469-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 58366965932
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 09:56:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 945F3B233A1
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 07:56:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 296ED15FA92;
	Fri, 30 Aug 2024 07:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="IehYidbV"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2047.outbound.protection.outlook.com [40.107.236.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8AB5158A37;
	Fri, 30 Aug 2024 07:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725004592; cv=fail; b=XKNBDSFDHntvaTyZc982T7ycZY2mGN+A2OtuZthh/6rXJxa57T2dlAFUOTnJnkpMlZP0vnm76Gur7Mm98AQLe0fgYJaX/jzCFoGLYqqKcIGhiS7SMiHDED++VASapcIGNHzHummP6yOPgFxnZF8UhVV11uY16vTqE3giMPSBA0o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725004592; c=relaxed/simple;
	bh=Z3mbyULqsZvaBFBDNNhdItmb2ZaKcd4ZR7F4HAChGjk=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P1vUDjJNTxXnbvHUM/M+27BGcCi4OtYq4x3rl1N1sLbLE2y0vyt4L2LAlgZlh2fCESPYKmZeDVd5X4tgKRrd/O2twY1JDdGdT6bo/NKlCAEcoz2irf5cX+tZo05whRrjvmCxQ7nzHJwrqSxf3f1eMKsrV3Lpl0eEzNTaxCYj4FI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=IehYidbV; arc=fail smtp.client-ip=40.107.236.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hJKL0F/CTsSoYIetQLY/aWcJuvV1eMakRCly+P9BF919Fak3WNLEZzEA4dY6olDJ5t+1fJfeHF4uH/hEUoBGIT9ROkDXRc5NsgmE7H9SSyJfQRJp7tqTss27xYQFUWnMzel82uq2Vrxu+lhWarHqhqpl/1r7KQpH3MnfuZPNNB3mIvMQDlzPxYqMa6BS8ZrXkOwljiPwTF3R78/GD89KT7QKCsoLCciWgY9wyHFshT89l8JoWXKNox2XJwdF5zC3//Pjr7eTZ6/6sdBh41KXJmleY/C91fgZNA+gGXSbhoxivrhJsKDUxHCWuCurL+ra6qFLgZjWT16H1nUqz3zSbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jsq8PTg+1zf/agVdzEy6/WGwIPsW99EeBxvQlklsS3g=;
 b=sNfrL7fVYjZcpJeJrEqkieEoSUHTE1IKPv5l1++hltD8OH1+P95w/Cl8+73SKtKuE+ERccYJ0D9IyRH4O/Dl7itYUGu6VN1soxs0QeA+7k2yhIbt+8iY3lJ70f5zFXHTHUyF1ZylRDYcn/x8DPiELI+ifYUIsSqt8JwoU5QNluBgFOqt5jVSzuWSaylj15RA+wU5ewoecIU2Mzp51lXht3N+/zHs8iNstOIxL89indRXGJ5LsBaT+nyBoLz/j/TG+sq7+Fyksmc7rJRciFMAFqzd+mIHDKnBLqw1NQa5dc8M8wPM+cBnUtscnDLTOizZkhH3ogUbFxmm7XnNq/HuDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jsq8PTg+1zf/agVdzEy6/WGwIPsW99EeBxvQlklsS3g=;
 b=IehYidbVS5+yGPF9Mhm3S/x5U/29egjhbvYkcb8O0u6Ycj1MjiRhGMPg1PGLhDqwhavGtEJ55OwQX5GBUyE1b+9kqyTh4NOB6SrsUwW9yqFVILCG4i80QyuKuiZmq41n6GBvW9VW2iQ5Hf/7x18+FBosSq6W2KPk1IP3Tx3Nv7FTWmseFPO4RSRN0jyc1HRygTMryEFFr8S9gUd3CLNv9UoydJCsibGkZWrbhI2z8Etm9+K8lddyiRGvDC5DzUgd6BeFkZiCY20OMXtpfp7NeUWCY13ghOYHrycNZYLyLht6CfoIZ0rmO/+izP4gJWpqzXbQaVTlvyN5teSmkDPcDQ==
Received: from PH7P220CA0174.NAMP220.PROD.OUTLOOK.COM (2603:10b6:510:33b::21)
 by MN0PR12MB6343.namprd12.prod.outlook.com (2603:10b6:208:3c0::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.27; Fri, 30 Aug
 2024 07:56:25 +0000
Received: from MWH0EPF000A672E.namprd04.prod.outlook.com
 (2603:10b6:510:33b:cafe::6c) by PH7P220CA0174.outlook.office365.com
 (2603:10b6:510:33b::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.20 via Frontend
 Transport; Fri, 30 Aug 2024 07:56:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 MWH0EPF000A672E.mail.protection.outlook.com (10.167.249.20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7918.13 via Frontend Transport; Fri, 30 Aug 2024 07:56:24 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 30 Aug
 2024 00:56:07 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Fri, 30 Aug 2024 00:56:06 -0700
Received: from Asurada-Nvidia (10.127.8.13) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Fri, 30 Aug 2024 00:56:05 -0700
Date: Fri, 30 Aug 2024 00:56:04 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: "Tian, Kevin" <kevin.tian@intel.com>
CC: Jason Gunthorpe <jgg@nvidia.com>, "acpica-devel@lists.linux.dev"
	<acpica-devel@lists.linux.dev>, Hanjun Guo <guohanjun@huawei.com>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>, Joerg Roedel
	<joro@8bytes.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Len Brown
	<lenb@kernel.org>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, Lorenzo Pieralisi
	<lpieralisi@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, "Moore,
 Robert" <robert.moore@intel.com>, Robin Murphy <robin.murphy@arm.com>,
	"Sudeep Holla" <sudeep.holla@arm.com>, Will Deacon <will@kernel.org>, Alex
 Williamson <alex.williamson@redhat.com>, Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>, Moritz Fischer
	<mdf@kernel.org>, Michael Shavit <mshavit@google.com>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>, "Shameerali Kolothum
 Thodi" <shameerali.kolothum.thodi@huawei.com>, Mostafa Saleh
	<smostafa@google.com>
Subject: Re: [PATCH v2 2/8] iommu/arm-smmu-v3: Use S2FWB when available
Message-ID: <ZtF7FINkcGFbnAKI@Asurada-Nvidia>
References: <0-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <2-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <BN9PR11MB5276AAA6242BE404D43F0D348C972@BN9PR11MB5276.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276AAA6242BE404D43F0D348C972@BN9PR11MB5276.namprd11.prod.outlook.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000A672E:EE_|MN0PR12MB6343:EE_
X-MS-Office365-Filtering-Correlation-Id: fe257d7f-07f5-4cba-6066-08dcc8c93eeb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?flTpaXdSBTElDz9FooRF4IbY8DQqnrW48AyscSvJi2O5rk13d7pl8ypUTtP3?=
 =?us-ascii?Q?CL1X0XSijp7jyTP7HthZ6WXS9tudvVaGk9pBvMowYK4LUtv35M9lKPC/yPn2?=
 =?us-ascii?Q?zwAPWWMQA7/w4N3YUIfFwv2tz8KNSdtxOHMioZPzwPYvhCsmGS+wZfYnfWrE?=
 =?us-ascii?Q?HTVMuX2/sTy6EZ1d6DOEuQDIhpeTS2rMgfdVpypih9r50tbd+AHhe0gXnPO8?=
 =?us-ascii?Q?Fw8a+C1ZoZHGKwNoHuejhVhhb2hLVfUzhi0niXgCfP2/7/8ml+3Tjv8xtAk6?=
 =?us-ascii?Q?WdatVBVT5VWvZ3izjIWHEkTpmGHnmP/gcj9gExJR3aU7sBxurO67r6GT5UD0?=
 =?us-ascii?Q?e8/Okeal3S+cqgz5ERIofe7AfWpPpyr4atfXy+I8pbVIsMD2q9fqxG1zqgYY?=
 =?us-ascii?Q?Lfx19Z0PK/Nkl+5NWrQcwE/xZlthHebKaUlkruQFM772zpLmS8i46PjigxkQ?=
 =?us-ascii?Q?8B8Ao1oyp8wLxvNZSzaGduVxvSTlI5JshOa+mFG9Zur0UgDVVhntt1d2iJZW?=
 =?us-ascii?Q?9m3C/tsMUzmKwjNFL586NEFj37r3n1acsnMPjZJk3OwAgHE8nNFx816OhJtA?=
 =?us-ascii?Q?Swx6494Ct7jxmMjhScZlFtOtJiyskn9sAVcxl/r8nUGKOCRLNKxbn6+K/hKA?=
 =?us-ascii?Q?1xveOZM9jyivVlKE568Yzu6RuZKiHULmhdkjpCcFzCn8wz9I+tsmoMN8Akq/?=
 =?us-ascii?Q?RsboFuGtUyqtDdsOV52827hEkPkEf6YurAPzzkknmSUOyYwlFHCtlhRLx3+P?=
 =?us-ascii?Q?LXWVhAob1WENOBcrgBBjkJToF85cSdSH1Gkqswu1CgzjckuEqumV0B0BDEj7?=
 =?us-ascii?Q?qcYIzQnNqr18EvdXtr/AhPAhFvoC9yuN+gr8kIboGE/+qLRW5TVHvj/I7Ywp?=
 =?us-ascii?Q?LwKiQy//WwBtWFw/xl1cM8faCsoztARHrIGufwhsJrtBm3VN9qIg5jcfspDT?=
 =?us-ascii?Q?uIlJhYwrN1fsSBkiEuKYvzTLjjPa3aDKV/ETfjYnmr83KcrlUidfOY47twJh?=
 =?us-ascii?Q?sREzRD5ARwGmL5UkPajhNxB3tlSwkj598l2AbeSGFwstHwJbIW76XyvQy1HX?=
 =?us-ascii?Q?fyZF8UxEYSFGiOuw2kB+QaXW66pOn9BLA4R4BG1e19HoRXxARbb43mRytP6r?=
 =?us-ascii?Q?vgEHse/IcmGTBm0B+E4/30M+tF3pITym44Q6/97xHKCKhfymMnBjKYCh0QU6?=
 =?us-ascii?Q?Yy34A5W8eGU+kXmS/qRrKxquG0DCHbPlkX1gliVT3KnN3nx3wJVZN/FikuTO?=
 =?us-ascii?Q?vkxQCYuUetIbMYb/v9NUMBBP967SA3eSD8YNDTx/tBZ0OSqCfI89//WoJ2qY?=
 =?us-ascii?Q?0jB5NuizFokzx2XnHvva9YnODj4G8IRBk7EOvQJ4IN9J35Hkvs7usd/M6C+r?=
 =?us-ascii?Q?kCsmxDhP4qOpXd5ZkcHJpN02tQdB64d0Cg6Ctv9Rx/aMj95ppEWeHcBIIlja?=
 =?us-ascii?Q?1nzFDHS/vFoWoAHD2bfO5EWKhTjA6vVJ?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2024 07:56:24.8268
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fe257d7f-07f5-4cba-6066-08dcc8c93eeb
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000A672E.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6343

On Fri, Aug 30, 2024 at 07:44:35AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Tuesday, August 27, 2024 11:52 PM
> >
> > @@ -4189,6 +4193,13 @@ static int arm_smmu_device_hw_probe(struct
> > arm_smmu_device *smmu)
> >
> >       /* IDR3 */
> >       reg = readl_relaxed(smmu->base + ARM_SMMU_IDR3);
> > +     /*
> > +      * If for some reason the HW does not support DMA coherency then
> > using
> > +      * S2FWB won't work. This will also disable nesting support.
> > +      */
> > +     if (FIELD_GET(IDR3_FWB, reg) &&
> > +         (smmu->features & ARM_SMMU_FEAT_COHERENCY))
> > +             smmu->features |= ARM_SMMU_FEAT_S2FWB;
> >       if (FIELD_GET(IDR3_RIL, reg))
> >               smmu->features |= ARM_SMMU_FEAT_RANGE_INV;
> 
> then also clear ARM_SMMU_FEAT_NESTING?

S2FWB isn't the only HW option for nesting. Pls refer to PATCH-8:
https://lore.kernel.org/linux-iommu/8-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com/

+static struct iommu_domain *
+arm_smmu_domain_alloc_nesting(struct device *dev, u32 flags,
[...]
+	/*
+	 * Must support some way to prevent the VM from bypassing the cache
+	 * because VFIO currently does not do any cache maintenance.
+	 */
+	if (!(fwspec->flags & IOMMU_FWSPEC_PCI_RC_CANWBS) &&
+	    !(master->smmu->features & ARM_SMMU_FEAT_S2FWB))
+		return ERR_PTR(-EOPNOTSUPP);

Thanks
Nicolin

