Return-Path: <kvm+bounces-24309-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AE40995381E
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 18:19:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 61EF5286F4D
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 16:19:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CAE11B4C30;
	Thu, 15 Aug 2024 16:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="YU4Fcril"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2089.outbound.protection.outlook.com [40.107.102.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E534919D885;
	Thu, 15 Aug 2024 16:18:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.89
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723738735; cv=fail; b=CeqCJRkVAKTf4l0fr0lKEwNG8R8aMmkzxWkEzWqq5YPx5PY+s5EV9aEIpTbnbwYMCuB+NS+nUHzXPz4yIdhFOgNU5tN+DQS0w1KRwE8V5Rna1aO0DfXQFqd06o+7DLaQeAxZUXm22DHt4xWQIGKk8RhvqW25X+Cx/XXoGZMUJQU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723738735; c=relaxed/simple;
	bh=BDbfYIALJpT5TWgCkbmfn46YlCCxWbrtW9iAl1v2AhQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=TjRf9gENDz16AEBF/ynrumV1A1g6Izq45FVOVzwtMdG2CNHwtVMQ0qoyjwvTpr+qiVIwBOStxAYUXrJd5z7kbKM2wVRkYAYT2+X36K01RQv/fBwZEyhnbyw6/0t47Dhwy1whsp4JpfmcOLgQicmtpvmUDvI3lzF9IPMPSOO2Xe0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=YU4Fcril; arc=fail smtp.client-ip=40.107.102.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xAvqfxzaPDqc7mO9wb1BZ6dQ24ZYC6o+N/wGJx4/tdOQ5nW0A1OsZjdMs13bR3TV0Z7kjtl4oRRyAPlHRHj+Pz72YYXkWiKITthTxzRBCzkGVmF9aFtZhnm0nAyUvi05Mg8Tp0XIylUZRJl2ej6W0kw2uQ72TNyqiZ/oArnaqhSk1za3pMexSAiOzURvGEzC1LE52acSTipDzuqbG981UXJJyz8OiQPBTgf5Fdb13PtN/NLo5WgbLjxiTSd27kHOwrmtt4+6NsUBSnsGECpTaBzzGLs/0R4sUEyRrTLSUlE3v/wrn4i1XT51P2ix/asXOdITeOhn3Mydj9Nq//W5lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ualxfzon3I+nQ5bYyi0EznBb7HsWc0VAcLNMBTEE5Os=;
 b=J1dgu0p51GYu/Yavq9PwVT1yrO9aSmdCwcdLgTT0ohmGC74SjbmYEOSYq4T2IkT8s5wupXqhf+0RQdP69WpUI2hoAM/0HIwYtHi43G/Licx4DacQ5VoU4IJ5YZ9YwRQPpNO933v2IGGI8PLYitWGrl0JMHQMbfyHVJ1JE2ZdpEZNuFUfmjDZEgNtq5aZ/O6Hcz2G6Hj0XcBLUgsrl47HdnEVCR9Ak9qfxszavDaHYHFHtNQPUpSYhW+FpxLLetj+LhhXYxaXYJEMB4ws80WuVRAo4cdmwFLjNgBHLC20aUJfgS/k5hX46HOX+T/GRcOVgF6rvUTpZ3W0c8aTub+YfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ualxfzon3I+nQ5bYyi0EznBb7HsWc0VAcLNMBTEE5Os=;
 b=YU4FcrilIaA4UrmNh2mCtByrDQXD2c118CZhfvm5J3foThZk/D5qh4JIfkwJDML2Mqq09N+BbVGZ83bk2YTqCJk64jVEnrDw2qL7DI+5Suk7LCx9OdyGWQbRGL2KBElS9oLoi8kui/jREhurk33dkofpQ2BZ2Tlq/JSON4wWFY5U3RIWZUXZvcoViql2oW6P3Ggn3SA5BJrjQs5jwnbGAp8m7j/475k9/u/4gEL5wmkQPJLqc+cJxoLX9at5d0/t0B9XHTD49HH8MkYI778j/8NKyXLWIAGg3LuCTYXQQwJ6XXGUFpcnWdyYfwwhUZf3gqXwHZ5CjYxoxC6yUwqq4w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by CY8PR12MB8339.namprd12.prod.outlook.com (2603:10b6:930:7e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.18; Thu, 15 Aug
 2024 16:18:50 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7875.016; Thu, 15 Aug 2024
 16:18:50 +0000
Date: Thu, 15 Aug 2024 13:18:48 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Cc: "acpica-devel@lists.linux.dev" <acpica-devel@lists.linux.dev>,
	Alex Williamson <alex.williamson@redhat.com>,
	"Guohanjun (Hanjun Guo)" <guohanjun@huawei.com>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	Joerg Roedel <joro@8bytes.org>, Kevin Tian <kevin.tian@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	Len Brown <lenb@kernel.org>,
	"linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Robert Moore <robert.moore@intel.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>, Will Deacon <will@kernel.org>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	Linuxarm <linuxarm@huawei.com>
Subject: Re: [PATCH 2/8] iommu/arm-smmu-v3: Use S2FWB when available
Message-ID: <20240815161848.GI2032816@nvidia.com>
References: <0-v1-54e734311a7f+14f72-smmuv3_nesting_jgg@nvidia.com>
 <2-v1-54e734311a7f+14f72-smmuv3_nesting_jgg@nvidia.com>
 <5af45a0c060c487fb41983c434de0ec6@huawei.com>
 <20240809151219.GI8378@nvidia.com>
 <d902b4045443465db6dc5c6ceee1e589@huawei.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d902b4045443465db6dc5c6ceee1e589@huawei.com>
X-ClientProxiedBy: MN2PR17CA0016.namprd17.prod.outlook.com
 (2603:10b6:208:15e::29) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|CY8PR12MB8339:EE_
X-MS-Office365-Filtering-Correlation-Id: 79713279-ebd6-4eae-606b-08dcbd45f293
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?9VmtB0T7ROK0NcGweY9qzD/nEdeO1J4PCilE3zoMBiN8j5zonktZro7H94Ll?=
 =?us-ascii?Q?9TyOVtGSBMxfJ9h45nwvTXmJnxYyz+pkkLg5vSMv2DLKRnd+ALNPFlTm+DFJ?=
 =?us-ascii?Q?5k/9PbeR73xb+K8i5r6UDFeuykCrpQybngJ86iVpvFRHK/WgDdNY52hIjXil?=
 =?us-ascii?Q?FL6aqXhPOhdvUednGKVlZXNGT0Fsy9TZGbiMZEEpUnPjG6V3rfXbe6YJHsZp?=
 =?us-ascii?Q?wusFhSocVqh+3pIu40yxEfNc1VssCHZjJMt4TeELzwDLSxtc2IWlIpU8lCj9?=
 =?us-ascii?Q?Y1ukew05vz49LU55O67w0IAqEPeW7tToNuGhCjRCgJuLs1LsH5gsETHyQHno?=
 =?us-ascii?Q?PSFmT8dgONfiqFd11v/BMOGEVLXh6qETrfcO6jr8PMfR1Hbyqz+rD1/exKQP?=
 =?us-ascii?Q?Wwmyq6hvD6+/rvpvBTUz1BBiTnsfLOuBCDBA3NrgGNOkCpT5c0ZMTO5/PccA?=
 =?us-ascii?Q?9qMICqyGEYQZ7ddFse3fFMNr1jIH+0gFGAmt7x3ALlm8nTMZk4GILRA9HiD9?=
 =?us-ascii?Q?uT426pUT2OwcTv26ycvim0J7uKv0NqqbFLWlr43wAEZxfbYJAciHpsQe44nk?=
 =?us-ascii?Q?bhYpm/kL5uwTwy7U9LzKZQr7NesyL0WfvT5f3Kiroy997aca89mo5GJZBpBW?=
 =?us-ascii?Q?7YiPdmNGRY+Q4/N8mmSDLy4QiepXTw4W+bbiZRq/7kY5OzHhWf8pHZ1NcfC7?=
 =?us-ascii?Q?mhHYX89PwGuXJJA41H7Ao4YbsfnzCv3YJCfw1ZOKYeaC19vHQOT2/RlbOw8S?=
 =?us-ascii?Q?CmCf0hdCkpY5518NbZzHUo0Aza6mT6kkBqZGw/FqLPB3GJBD9zt/2xi/mfvi?=
 =?us-ascii?Q?ZKzDUmC2Hn38H6HQko1XsPECOwj9StiQvc4Fxmqfpxgv56hlfyXSHOfWagnM?=
 =?us-ascii?Q?2i2uaLOYwMG+6icTyE3xTN6Fs/4pNK99nGmY8Q0UO0zU8IdkZP+lxi3DcKQF?=
 =?us-ascii?Q?EL+3vbI4QWLuAfV1Ve/1xP8CX05vNpsk/wbWz6qb7uNrIFuFzlWZOcjoxpab?=
 =?us-ascii?Q?ptDmYvDvgi13tYi9bOG5hv11ehgkwdrOYcRQVShvKyoscPunjVlpu9qh8tQu?=
 =?us-ascii?Q?/uTWxdt6Hyr5g9whomGbu4gCxBXF/Rhou3uMTLzLexp0EUJh68I1ng7tskg2?=
 =?us-ascii?Q?gVZkYg9Us9l0RJmKYvADMt4LQ4xebKQhnl8BvaKIbsKYEFP70z18iBRbldAA?=
 =?us-ascii?Q?WnDCA/V8C8FFxYfIlEllVl8vKT0i0Ns96VFZ1YeMnJ2naRMIGkRg/uwHNUKH?=
 =?us-ascii?Q?cCONAmTdtNkKyNJ5ouJE3IvfykrvyRBiwsUsZIoA1OFYfMXzOg646vx7+CYB?=
 =?us-ascii?Q?/FDjPOFpYE2Gph6anRxKdB0JuibEDgpl2fMLXB1c/6EQpA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?iZwfH0Jdd1b0LSd7EYTxehtAlEH4IgdMxuiCdWCq7xwg7Tukm77bAiILpC7N?=
 =?us-ascii?Q?mqLFY65U5ESCajtZqbr6pGeElO4xevcnukfu27BWZ/BCeZRVjBuEx3c4NDFy?=
 =?us-ascii?Q?F2EJmvTHtfnaLKgHbSToQnDR+QTgzBm6mFDe8x8Edh+xqvnhaNoDWyqRSQl6?=
 =?us-ascii?Q?/6ltzRkVasuNrYmg2QyhofKk0A1y502R2gUCk3ludxcmpe/MjpC3Qw6KSWwq?=
 =?us-ascii?Q?ONdcDnMzqMy3D/xLPo5TIYGaVLuMX6QXw834xBaRTPB5rViWwM1MSBZ7+7l4?=
 =?us-ascii?Q?ukinHWt/1co77yIz9/wZu8L2XXgb5sSM91zf3ja8jj7uM8U38EKHypZgn6uN?=
 =?us-ascii?Q?HI7EMJ0a6NlFYB3PFAAupMWTo25geHLkcsBmUmW70gkD80oE9aSwQXtWTATZ?=
 =?us-ascii?Q?lubdQqw1oFDTAsscSSUTKpVK4E3/Wal4kGn7nWtmw5SzXc1piI7beDdURApg?=
 =?us-ascii?Q?RnRv4jPjGc4VP4voW9hV0hXwltRAI94DB6Uvi3Xx3pO/SoyzveWio/nEdgnp?=
 =?us-ascii?Q?4mGE1oxJFCb0sBlLv/DxWGi6f+YgGVZWjxztyScDDahF+0b2/ZhvUX1hmFNK?=
 =?us-ascii?Q?1neu4da3/tlZMYCkZJCQHFKvlZVAY3psuqvujhTta+/41BGLrTJb34InUTPu?=
 =?us-ascii?Q?asxKxsXy2l7fzmB1F20w+vcIuTkAzXW63TrDifGvGU3k0BGeKDuA+Bvtrckt?=
 =?us-ascii?Q?xuUPqF/wFzM0wdINpZpOkO3qt5uJqZ2imDfagTG6eRsajG2x8Sq8Fh1Nvr7d?=
 =?us-ascii?Q?0glq5HAdgrazsQy3aKW4pR5opvMKSyz6Csl+RYbqyk6xPRualz8cG9QnGokc?=
 =?us-ascii?Q?pIjmTOmeftuoTcr7hMg2gE/4SYTE59vkd4l9em3hNfecQ4QL1Ze5u2LfUHLy?=
 =?us-ascii?Q?7cK3UD/9pkuEkkBDB4OtBT9+2dY32XFbIm/FipZ6YdTi/vgJP2+QH6Iw9olI?=
 =?us-ascii?Q?FqKCIsg6+LTLimpyoHHEn1sPCL+1kwDZ1hlxuBEdOKLrqa5bYA7zdO/sxfF9?=
 =?us-ascii?Q?TY+0YCvJfYGAoo92LCaNAMgl6pPLAH+95CFBTDEo412eD5euVk6Nxnp2/Te5?=
 =?us-ascii?Q?uKMeEH1+Xb4996bGlCTPTJCQMxLp5JP9quMU+jNSKBwSmgBftvlg4xrsE+y9?=
 =?us-ascii?Q?D62IAMInBXWQHFtpf6BeMI7fg/luoH+TcJQHInd8LvcgRhtrDhDBSGou5z0e?=
 =?us-ascii?Q?dgVNb59eGr2mdYPPJXQCK1Hs7B9oOUKGNqPHwxLP7tEiKkB2IBpLOZ++Am0H?=
 =?us-ascii?Q?4dR2e117v1fayqNEHLDVyIPvdgFTH6g/oyrX+eYZvuktWURHl777+5ONICfS?=
 =?us-ascii?Q?223NvzHYerXBlsbZC4/NzY8vIu7P90/ZyN68E0/6jZ6WFjRsIwauHmnm6Odm?=
 =?us-ascii?Q?qWS2jPH+KBNFb0wGIkeYStlYbIX++odVK1NXneoDZjlU1NY87mOlCL5pzdBm?=
 =?us-ascii?Q?i2xRMb9LBTSX4OsbWZoA31oL+exhZ0vkJUe3cfgcZONzYc1rFfuUWicaMiRD?=
 =?us-ascii?Q?Y1gubNgF+xRx27eLxMggdKAG+tGh4X63PkaCvDiJvr/yzokHF+VKw4XTUyPf?=
 =?us-ascii?Q?r7fQJrLHkZDMX2jInAo=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79713279-ebd6-4eae-606b-08dcbd45f293
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2024 16:18:50.1237
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aOXHsi1OP6OZSz60xvvwPkpQDbdOG9pm38hd+M6inwmAUf4Exj+t8FlKTA9s55Oo
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8339

On Thu, Aug 15, 2024 at 04:14:22PM +0000, Shameerali Kolothum Thodi wrote:
> > On Fri, Aug 09, 2024 at 02:26:13PM +0000, Shameerali Kolothum Thodi wrote:
> > > > +		if (smmu->features & ARM_SMMU_FEAT_S2FWB)
> > > > +			pgtbl_cfg.quirks |= IO_PGTABLE_QUIRK_ARM_S2FWB;
> > >
> > > This probably requires an update in arm_64_lpae_alloc_pgtable_s2() quirks
> > check.
> > 
> > Yep, fixed I was hoping you had HW to test this..
> 
> Let me see if I can get hold of a test setup that supports S2FWB.

Thanks!
 
> I do have another concern with respect to the hardware we have which doesn't
> support S2FWB, but those can claim CANWBS. The problem is, BIOS update is not
> a very liked/feasible solution to already deployed ones. But we can probably add 
> an option/quirk in SMMUv3 driver for those platforms(based on 
> ACPI_IORT_SMMU_V3_HISILICON_HI161X).  I hope this is fine.

I don't have an issue with doing that, if you can reliably identify
the platform in some way a kernel quirk seems reasonable.

Thanks,
Jason

