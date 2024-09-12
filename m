Return-Path: <kvm+bounces-26609-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AD0DD975FF2
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 06:06:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 64D6F285AEF
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 04:06:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C45511885A0;
	Thu, 12 Sep 2024 04:06:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="WGDupeOQ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2064.outbound.protection.outlook.com [40.107.220.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7B482C190;
	Thu, 12 Sep 2024 04:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726113966; cv=fail; b=iTM5d+ZiQ6RHFPrHg3GeH8celoYHVIAYBtJG23+mOhVCn1m2h8PnsG4reg0EYg0oFICmeTZJNW6xloVApZbIEFOa0Ctz2/TulLMHnrKjJNzXSnGtGFhxcihup5PwN/PZMuZuOJd3BNLcCiVdGLqHiYD5fOFk1swK1d4B0i0a4nI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726113966; c=relaxed/simple;
	bh=N5k0exz7n+TNiBGs1NH7L/U4lGBfpNw6enozDOuIenA=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZJqQwjU+/tv/weBYpxKyColW9lto7nhpIBv2V3S+I3DViBaPGtk2a7tmuDBwZ1/2Ds5ij5ELBPab/8UfR3oYz4Eb3VqxPGkxL+Zr1K6iLD9xJM/1F5Cf/z2FQWtZR8b+INBuUV2QUcapOid1bJJIscPzCoPI6OrcXr5oyA+99Yo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=WGDupeOQ; arc=fail smtp.client-ip=40.107.220.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=M9V/B4aIpHYrKhjaQU/grMaFhlHmFGHsn4g/bRNxWo3ODrq/W4lppiKM/wRb63p+S2LO7BZxCaUTYvHHahjceBnSV9biSdHoIjAdDxtOngBeSUArzCqj0+cMBhEV0LGokITKa91HTSyQNX4deA3t3EYsFAIbd92DcqHfCN1sU7zQEro59K6Q0USml6px+a4JLHs3ciJOxg8izYcdbml7+JmcCxs3nrq0TL+s+6yvSLlFQUDojJQNlMPeWny6YpzssIblx40olMY5/rz1Jr1yDhJX5e2Rd111Z/0RKh+WUkh+cUlgShEIAp7xP9ag1/a71i1HIRgdnnZeQTSq6p3lHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r6l2vSGdIkV+LPLtQZL/c1DMm4/usLJ89pizdW/ufZI=;
 b=Yb+YwDiYn3sYYeVDuh2CWBg24dPckX5PSmXV6OIwAxk8j73PSH5JPoJL1KyZpt8uTjL2Hu5Inh6MLq7WxQ/DeIBKA/4h97FqE2xUAmhst/oGCAWpxJMAvku/P9y6M5r1zw9outhyMfveDlgHiMJmpJPjDazccxY+cGPrs3aEOw3J2ui32ZcCWQ3SauGeGSio76L/ZeC1o/k0a56R1rFaFWO94IY7zGIgItcJTGjWrzgiXrernaaIevTNmsnE3C4R+MJ1YhvhwZbDGmhtZ8wj9RrXp5DB1X7yNNsWdWTOFd82iKfTqYoJKn9XWbcg7Zg47q+GcmdOpBvE7XoqH+1K3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linaro.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r6l2vSGdIkV+LPLtQZL/c1DMm4/usLJ89pizdW/ufZI=;
 b=WGDupeOQTxAuRGhwonMcPKIFy37zeQZ5spQkvZWbSODaNiEF4f+SGcaRjuQJjXWGMEU+jy1E8qS022IuK84B/A6Bs23HGwgHmGuhczGqkTOESNUdFJRr+0bp8hvonB+jJH28EP3RhC+7n404Zz78r0PzxnALvlizWDOLZdoBqD6fsOc2YRzVrTyXfBRhpViesJJ63d4IjvKj0TKmcMB0IUofv79otGQiL2ieq2sjZF1Fbf6WFDn2rVAUzF1ZpYz7z4XIoOwRNKq++pwz6Xb0+U/yYNGbUAnponZ3S7WhE1lW9RqUPy7pfzJdDvZPCl+6xsTdA/94Tjj288Sh+2hgMA==
Received: from CH0PR04CA0076.namprd04.prod.outlook.com (2603:10b6:610:74::21)
 by PH0PR12MB7814.namprd12.prod.outlook.com (2603:10b6:510:288::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.28; Thu, 12 Sep
 2024 04:05:59 +0000
Received: from CH1PEPF0000AD78.namprd04.prod.outlook.com
 (2603:10b6:610:74:cafe::1f) by CH0PR04CA0076.outlook.office365.com
 (2603:10b6:610:74::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.24 via Frontend
 Transport; Thu, 12 Sep 2024 04:05:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CH1PEPF0000AD78.mail.protection.outlook.com (10.167.244.56) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7918.13 via Frontend Transport; Thu, 12 Sep 2024 04:05:59 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 11 Sep
 2024 21:05:48 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 11 Sep
 2024 21:05:48 -0700
Received: from nvidia.com (10.127.8.11) by mail.nvidia.com (10.129.68.6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Wed, 11 Sep 2024 21:05:42 -0700
Date: Wed, 11 Sep 2024 21:05:40 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Zhangfei Gao <zhangfei.gao@linaro.org>
CC: Jason Gunthorpe <jgg@nvidia.com>, <acpica-devel@lists.linux.dev>, "Hanjun
 Guo" <guohanjun@huawei.com>, <iommu@lists.linux.dev>, Joerg Roedel
	<joro@8bytes.org>, Kevin Tian <kevin.tian@intel.com>, <kvm@vger.kernel.org>,
	Len Brown <lenb@kernel.org>, <linux-acpi@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, Lorenzo Pieralisi
	<lpieralisi@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, "Robert
 Moore" <robert.moore@intel.com>, Robin Murphy <robin.murphy@arm.com>, "Sudeep
 Holla" <sudeep.holla@arm.com>, Will Deacon <will@kernel.org>, Alex Williamson
	<alex.williamson@redhat.com>, Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>, Moritz Fischer
	<mdf@kernel.org>, Michael Shavit <mshavit@google.com>,
	<patches@lists.linux.dev>, Shameerali Kolothum Thodi
	<shameerali.kolothum.thodi@huawei.com>, Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH v2 0/8] Initial support for SMMUv3 nested translation
Message-ID: <ZuJolClcPAd8OY52@nvidia.com>
References: <0-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <Zs5Fom+JFZimFpeS@Asurada-Nvidia>
 <CABQgh9HChfeD-H-ghntqBxA3xHrySShy+3xJCNzHB74FuncFNw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CABQgh9HChfeD-H-ghntqBxA3xHrySShy+3xJCNzHB74FuncFNw@mail.gmail.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD78:EE_|PH0PR12MB7814:EE_
X-MS-Office365-Filtering-Correlation-Id: 1b4695a5-ef0b-4b04-9899-08dcd2e035b2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|82310400026|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?+6eNplVX7WD+lZJLypmm7x5lw6GYFseJpFYNiAsqM6rEFJvUcjHYW9Zcn1Cy?=
 =?us-ascii?Q?Z8d+fqdEgH843sRH0/8rOK6LTc62yE2laGBoi3P7xZAn+R+W9kjx75uKThJK?=
 =?us-ascii?Q?x6gDgOn+rBApBUmimLhJTjcBrsdRej/X7IMgZ4U4K6AyFODRcobVHfDUru6V?=
 =?us-ascii?Q?uhTPZu2w0WtcI8SA6Bve0QB87fYetRWXDpUMFeJEpwiY7s4vdQp8iLQrcnnw?=
 =?us-ascii?Q?drr0lpC2OvXJ8P74RrEoIJYXtDBiHDFFJ3pCfoN8O+UbLYuJJYaP+5aHeMZk?=
 =?us-ascii?Q?unxDnE37X4J8GONLm+vwXCqDFj+d+0c2Mh3dYCVKpALr62vnly08cs/u3BNC?=
 =?us-ascii?Q?CQVWGEZ1Xi9IrhR72zNR7FlEPiBAHqmprpfSYwbAOvYwlgCglmrDehuc0c+O?=
 =?us-ascii?Q?fEeSNlfsb1ow++ZLJtR7JEqD0O8RlGxDJd6i5BJmrFRC+N//eIcMjwUz4mCb?=
 =?us-ascii?Q?Y9xG2WpuKNndGKUBv8s8gwT/Gr78HVT/ga/NFLGkC/0gIEwi3QOmgKdT10gB?=
 =?us-ascii?Q?5f5B4pylVSPQbRpxpFAa3nRptweBqUgHRWPBaRga34rfqGHMzeAsxevEV44o?=
 =?us-ascii?Q?wYMOMERCPHvEQK1v8o+rFIlEDuAnwCxy3qRRE7JGfcBC8GkDxyta0rU2pEvw?=
 =?us-ascii?Q?YlKBKnECEYoVPJ821APVRVmixtIsuxuofeqU9Rre9ScqX4LyawYj7SLf6z3q?=
 =?us-ascii?Q?mw49v0kufbDwSPxCYoCx1tByLhQEJuxbrPxcaZS4OKaSpwyq+NvWqLImVsD+?=
 =?us-ascii?Q?VA3TqT6btG8AVYBqip3KC812gYm64kmTlAA8Baflk9bgBcxpSDWtBo6gZdes?=
 =?us-ascii?Q?KTJiOW+VcIBeKMTHq0n+BzhQC9fSemM0a3cTQgCvwX+/wMfNSB04xYCV+JPu?=
 =?us-ascii?Q?rjenB6KUkvxdmUY1WwJ16Oo4SMzZ2cFGokTXVUApLSuYWiFgKHRlmN6hBdW8?=
 =?us-ascii?Q?H3dJRd9QScoXHou/XBLJjpQHuQbHy1wpWBAUFjMk56P10ObbcruSIXk2UtJd?=
 =?us-ascii?Q?CekWh1MPfAEfVzRurT3BLSqMg1ltshQvwHisjiMWQI26DE+RcICOZZhAEK/L?=
 =?us-ascii?Q?iJLjUddalJcjbufqgtJLAEo+UQqe3Ja5O602+qFAquebCWxGODJ/WM907nOu?=
 =?us-ascii?Q?XD+muuz0DvRPeFHT61nETxAyui62eL2fRNlDLhMHjHDZs3JlO3zWfWqZT4QO?=
 =?us-ascii?Q?hfJN9otQFW78GsQeAlgL04DVAU4boGFj0FBoaw98dWYzw+NzR5rNNGM7YUNs?=
 =?us-ascii?Q?FsLtBn0nK6XDDUMaVBtb+aABB7HCzK1uoL9RK+0Z7HmcBghw/OcHOvEmIzcl?=
 =?us-ascii?Q?sR2io6iQYp6bQEmD4yZ3IN/gL0qJOAsu5yBKO3RvNF2htymROD0uRvebO4i5?=
 =?us-ascii?Q?d90nX/j0nhyLRoqhMYQh/hlvObExzKoH+Pmi523S5HXhTk0iaSaDDv4oYsf5?=
 =?us-ascii?Q?MnXyDfVmkGNiRotMRg8bnJ5zh+k3Tomy?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(82310400026)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2024 04:05:59.3765
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b4695a5-ef0b-4b04-9899-08dcd2e035b2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD78.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7814

On Thu, Sep 12, 2024 at 11:42:43AM +0800, Zhangfei Gao wrote:
> > > The VIOMMU series is essential to allow the invalidations to be processed
> > > for the CD as well.
> > >
> > > It is enough to allow qemu work to progress.
> > >
> > > This is on github: https://github.com/jgunthorpe/linux/commits/smmuv3_nesting
> > >
> > > v2:
> >
> > As mentioned above, the VIOMMU series would be required to test
> > the entire nesting feature, which now has a v2 rebasing on this
> > series. I tested it with a paring QEMU branch. Please refer to:
> > https://lore.kernel.org/linux-iommu/cover.1724776335.git.nicolinc@nvidia.com/
> > Also, there is another new VIRQ series on top of the VIOMMU one
> > and this nesting series. And I tested it too. Please refer to:
> > https://lore.kernel.org/linux-iommu/cover.1724777091.git.nicolinc@nvidia.com/
> >
> > With that,
> >
> > Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> >
> Have you tested the user page fault?

No, I don't have a HW to test PRI. So, I've little experience with
the IOPF and its counter part in QEMU. I recall that Shameer has a
series of changes in QEMU.

> I got an issue, when a user page fault happens,
>  group->attach_handle = iommu_attach_handle_get(pasid)
> return NULL.
> 
> A bit confused here, only find IOMMU_NO_PASID is used when attaching
> 
>  __fault_domain_replace_dev
> ret = iommu_replace_group_handle(idev->igroup->group, hwpt->domain,
> &handle->handle);
> curr = xa_store(&group->pasid_array, IOMMU_NO_PASID, handle, GFP_KERNEL);
> 
> not find where the code attach user pasid with the attach_handle.

In SMMUv3 case (the latest design), a DOMAIN_NESTED is a CD/PASID
table. So one single attach_handle (domain/idev) should be enough
to cover the entire thing. Please refer to:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/iommu/io-pgfault.c?h=v6.11-rc7#n127

Thanks
Nicolin

