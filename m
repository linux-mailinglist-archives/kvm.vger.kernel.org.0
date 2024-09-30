Return-Path: <kvm+bounces-27709-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 104B098AF64
	for <lists+kvm@lfdr.de>; Mon, 30 Sep 2024 23:48:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B4CE3283DE0
	for <lists+kvm@lfdr.de>; Mon, 30 Sep 2024 21:48:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 207E2186E52;
	Mon, 30 Sep 2024 21:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="NZcH5ppZ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2041.outbound.protection.outlook.com [40.107.243.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6789E15E97
	for <kvm@vger.kernel.org>; Mon, 30 Sep 2024 21:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727732886; cv=fail; b=O4RHxXRDbb8yL4cDwduAqii6dbDaFhkFeH9n7Soe/xAgNfkTxANQdbzozw+o4WyRRhcgwbAZxfp79q8EGzp1V9UsKL2qvQWNQbxUkoC6BIYnKcQtKQqpCbH1kljsNTPrwMDNk1xElhn18jjrdtJ90/vhUrlK0BFEJ3LFyDKWkh0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727732886; c=relaxed/simple;
	bh=I2D/0OTfk19qUFZNhcVfZ6E4YCOeZIAb4LXVAXKYwq8=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d1+DqRfQeYSu0StbNQLNweRazizM7As8f4M9WCmdANZTSe2/JsyH6DAZSnI4+Ph+5hNe+h7AKYkouME1S35N5nxDHWo06Hj8/gRtxQnK6ViJF4QXgTXfPOYl24xDkpn5wN8aeNnRDMNL9G2U2ly80jP/RFLKofCychhO1pQvsoE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=NZcH5ppZ; arc=fail smtp.client-ip=40.107.243.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BOSQmqHqXf3OSUfnec4O7sKwc4/GoHdTs/Eh5JdM7WBkp1VY8mL8WbgkXBViR/BCfaFrwoo5sd7Lg8i41Hyr0RHe/VqGbjbhexgTdyJGy9H/U7aQFvuaMLS1hnNa6Ul57ucGdvB5dyp30SSoTYBfCCJFeDY844uJ/a7D4CHATCS3KXNqTdTvw2MUkSsJee1YF/7lpFTYFVmLz4WsD/EQyxJAR0M4PQ6AwrNak5Jxw88B7ok0se7JLWCpMtVS5rGt2zSW+Nz0Zsac1EmbZ5plmgRY6ir3rBFF2DUEf5JVcOaSJHN4in9zgMQgKfsrrmcxC/Ic5UYwlpmoqxpED7ZhcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NZP6Hb5rPOtx0NHH5eGWqAW26hT3KVvshudRm9YinA4=;
 b=qXvbuUVXxyY+WWmpoNlbEA40oBFBFP+28qUrytMrfF3oIJOQ+to0ZcOwNrUKutuKKlfMR1Jy4CiFwC8rhfJXwCsUDeBYjzW3Pw+NkgFZOTwod9rnVVFxk8ygcNIDUvAdifvNQUt/F3hvEVxgzOumP+TAecio5rJNt4zQ+CfJ+biFbB1r6xQS0viNyoAxP21SH5gM6sPZ8pzdgeABxAeNwP0KpG12hKCF/QTylzAiv6HmNux4QOZJNjZqwtuULsY1RjQckhFb8R7oYiBDoHj4k0maT7U2ZGAkFgaaXQsWzHhDVPz+W5gmiLvNlQKYJ/llhWclCXEzW5ZgftGalVkTYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NZP6Hb5rPOtx0NHH5eGWqAW26hT3KVvshudRm9YinA4=;
 b=NZcH5ppZauH2vB5jyrB62xLArup8ZHEjD612bYwj/2yoJbJUwqWMJOFPITctQ1HpjPIB2/HmSgNemxoK/joICzVlsPsfEydq4kZJIXVFAdD0mwPRW11SGv6OqRNb7I6jRdL0tbx8tBuQdNTKjW90Of2q/A2loWkGvF+blzmzCc3otLcFcStOh5C7D4Yu1jTiT9W22/zbbS+xEF/VdYznQHrd+fi0JZOiRaAWjPIUP573EuATfWXlZ9VfsgqoMn/aqvRFSz1EmA1LsVUh3PiGjWUGQn/D27yTRpuuGUAkx7Bp7Ab4L/UclJm0TIISdcR47otB1Vhxxiv0vaJX41kQ5g==
Received: from DS7PR03CA0077.namprd03.prod.outlook.com (2603:10b6:5:3bb::22)
 by IA1PR12MB7662.namprd12.prod.outlook.com (2603:10b6:208:425::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8005.26; Mon, 30 Sep
 2024 21:48:00 +0000
Received: from CY4PEPF0000EE3A.namprd03.prod.outlook.com
 (2603:10b6:5:3bb:cafe::a3) by DS7PR03CA0077.outlook.office365.com
 (2603:10b6:5:3bb::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8005.27 via Frontend
 Transport; Mon, 30 Sep 2024 21:48:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000EE3A.mail.protection.outlook.com (10.167.242.12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8026.11 via Frontend Transport; Mon, 30 Sep 2024 21:47:59 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 30 Sep
 2024 14:47:38 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 30 Sep
 2024 14:47:38 -0700
Received: from Asurada-Nvidia (10.127.8.13) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Mon, 30 Sep 2024 14:47:37 -0700
Date: Mon, 30 Sep 2024 14:47:36 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Michael Williamson <mike.a.williamson@gmail.com>
CC: Yi Liu <yi.l.liu@intel.com>, <kvm@vger.kernel.org>, Jason Gunthorpe
	<jgg@nvidia.com>, Vidya Sagar <vidyas@nvidia.com>
Subject: Re: Supporting VFIO on nVidia's Orin platform
Message-ID: <ZvsceAd20HVZ5Ugn@Asurada-Nvidia>
References: <CACcEcgQq_yxvjAo7BticTw6ne8S2uUjbCFxPTnWHT24oMkxf=w@mail.gmail.com>
 <e3680d93-0463-42d6-be13-03dd90bb0d8a@intel.com>
 <CACcEcgTuhgX5RYCCCwU+sWS7iGKUVpGQkFGdh8yWyTVxoU=fiw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACcEcgTuhgX5RYCCCwU+sWS7iGKUVpGQkFGdh8yWyTVxoU=fiw@mail.gmail.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE3A:EE_|IA1PR12MB7662:EE_
X-MS-Office365-Filtering-Correlation-Id: 452d0a70-e96c-497a-9ce0-08dce1998d83
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?T0VwUXh6WmtFclZqaUtzRUFqckpJSi9zUEloOWFSUkF6dDN4ZXUwelFDZjBk?=
 =?utf-8?B?WTB0bURrbHcySmtObjRsYVlHSnpVWE16dXJFMHF3MFJxMTR0K2tCVWF4RlMy?=
 =?utf-8?B?QTdsTHBabVlGKzRqSC82R1NDUkpadmtTVlNGeVJnY01DTmo2VzkxQkdhdDRQ?=
 =?utf-8?B?MDJWSnFraGQ5TkJpTnZqcWVTOXB5WERMZmc3SUJUeUpYaDZYdHd4VnZZaUxH?=
 =?utf-8?B?MG9UOGh2c0xSYUh4MEZDUGFvaVVJRFFMdzUrTVh1S21xY1hSb0M0Tnk4OGZF?=
 =?utf-8?B?OXRud2NkS2wrODhxaTkvU2FkWmsvQ1NtZHArQXlzWENwVU1pQTNicWlxSzFi?=
 =?utf-8?B?cjhmVURLZllmd3IzUTFxMjc5Z2s2RWdMUlNzZEVzTHBLR0xONWhueE1DV0Jl?=
 =?utf-8?B?YWR4OEl1YVc5VGdKUFZ1YjRVK1YvVU5xTWFRMU5lTHd0YlhnSnVmdnhuM2tD?=
 =?utf-8?B?OFA3eEw0NWVKdkF2ZEFtUnR6cmk5UDlCblFkMkRwNFUrSUNIMWFJR0xmMkds?=
 =?utf-8?B?UTJ0VkhpNVFjMnQxSW4yVHBhVXMzUUc5NUNESW02V1Y5MHBkK3d5cTBaRVBi?=
 =?utf-8?B?UFNyNlkwODl2TjdPam4yK3BXQlljTytCNktxTHRGcU5RcS82K1lWaVFuTTZJ?=
 =?utf-8?B?bXVqdXErQzlaUHdrRnJyWG8zbWEycGIvbnNHLzB6MjQ4Q2wyeDdOLzB1ejhh?=
 =?utf-8?B?VXVMQXRJalVFL2JpNE5vdHRlcmp2TlFQYXpiU1pucGNkNVpFaFplYjdKMXNj?=
 =?utf-8?B?REFQTFZQZXB5K2tsNzE2VGtEYzYvTGNMSzFjNW5QSEpnQzIvZVJtSFlpS2po?=
 =?utf-8?B?dUtvVmRWRGJra3NZN210RTI2UGJGREJ0QnRja1pLeVkxUUhzdnczTHhIcUxv?=
 =?utf-8?B?RFcxYkc2ZFdKRnBzWGdzVEhPWlFqYTZpZnU3cGlQSkNOeXBBc2dXMURMWTE4?=
 =?utf-8?B?M0pmWHV4QkpnQ0ZWU2FkcStNMGNSbVU5R2x2cmsxbXJmR2FBeitYSHZpOWtI?=
 =?utf-8?B?cE1uZURkRmh4a1I3bUhSL1VybStyTm16MGtnT0xzdGwxT0RYbmxlOXpTcnY4?=
 =?utf-8?B?OEJ4Qm51RzZqY0lTTzdhd1dMN1FLU0Nkb3NkNG9lMFBRamZPUzNKdUxSVXFs?=
 =?utf-8?B?QkpDM1RoSjI0Z1h1THRrbVFTYUtkUFM0YmFvM2x1SDF2azFUVDFZOUJKazl6?=
 =?utf-8?B?OXF4OXJ6TnR2SDdOQlcyT1kxMTBHeTZQbDJQK1RrS1ZYaVEvazgxTHNCYS80?=
 =?utf-8?B?QlBxY3JVaVFRZlU4UDhMU2g0bVhWRUdxQ2MvbVgyUWkzcGk0SGtlSjlodHVC?=
 =?utf-8?B?cFVDbFNxdjh3VkhLOGJ3WDFxUE9oUzdwWkVwVlgvSytMd3BhS09SVzFTK3Nh?=
 =?utf-8?B?T3ZmN1N2cUkyUW1vbnJ4aUpNdW82QVhOM2ZZcnpHTWlYM095VjdpNHNSOWND?=
 =?utf-8?B?bnZWcWh3eFZvNzU5QmExYUp1WW5WYUVVUndxc0hLQmV1eDJKTDh3bSs3QUtI?=
 =?utf-8?B?SjZrai8vRlFFZU14eGRaMjlxYVkwZHpoS25kcmlIY24wU3c4K2xqNTVxQXo2?=
 =?utf-8?B?aWpUL084ZFhGcGsyRGwrUkhLL05RL0ZTWnUyZUFibUh5d1MzY3F0TlZCQVZq?=
 =?utf-8?B?aExsTEtSQWM0RjlFemg4ZjNFTkJia1FtZ1RraDVlTHY0Z2VkNFYxSkoxb29y?=
 =?utf-8?B?NXMrRVFUSkNiemFRbHRBVXZWTHpZU205MjYrdEt3dy9kekRwL2FSb3FIako4?=
 =?utf-8?B?RmJBbnNhMS9vdFNMamprbFpMS3IwZ0RIcXR2MVVpcWQyUFI0eWdpRnFuY1hp?=
 =?utf-8?B?cFZ3VldLUlpRZTNWTEtieFA1dVdQK3U1K2ViNzZiOVgwOHdhVnNaTm1FWGdt?=
 =?utf-8?B?dExGOHBlTjV2SEhTdHp0SnVaUnlwYmNxd1hrYnpDeEtERGpGYWprOTQyb3RB?=
 =?utf-8?Q?u5x3GRedSxt2Mue263HhyxPSapyHWAsv?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(1800799024)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2024 21:47:59.9132
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 452d0a70-e96c-497a-9ce0-08dce1998d83
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE3A.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7662

On Mon, Sep 30, 2024 at 05:27:33PM -0400, Michael Williamson wrote:
> On Mon, Sep 30, 2024 at 12:00 AM Yi Liu <yi.l.liu@intel.com> wrote:
> >
> > On 2024/9/29 23:02, Michael Williamson wrote:
> > > Hello,
> > >
> > > I've been trying to get VFIO working on nVidia's Orin platform (ARM64) in
> > > order to support moving data efficiently off of an attached FPGA PCIe board
> > > using the SMMU from a user space application.  We have a full application
> > > working on x86/x64 boxes that properly support the VFIO interface.  We're
> > > trying to port support to the Orin.
> > >
> > > I'm on nVidia's 5.15.36 branch.  It doesn't work out of the box, as the
> > > tegra194-pcie platform controller is lumped in the same iommu group as the
> > > actual PCIe card.  The acs override patch didn't help to separate them.
> > >
> > > I have a patch below that *seems* to work for us, but I will admit I do not
> > > know the implications of what I am doing here.
> >
> > your below patch is to pass the vfio_dev_viable() check I suppose. If you
> 
> yes.
> 
> > are sure the tegra194-pcie platform controller will not issue DMA, then it
> > is fine. If not, you should be careful about it.
> >
> 
> There are multiple tegra194-pcie platform controllers defined in the dts.  This
> one only has the one PCIe slot we are working with and nothing else.  There
> are other instances of the tegra194-pcie controllers that have control over
> other PCIe devices in the system.  There appear to be two main smmu controllers
> that support multiple masters.  The tegra194-pcie platform controller tied
> to the PCIe bus I want has a unique smmu/iommu master ID but is sharing the main
> smmu controller with other devices.  However, they are all assigned to
> different iommu groups, so I think this is OK?
> 
> > > Can anyone let me know if this is (and why it is) a bad idea, and what really
> > > needs to be done?  Or if this is the wrong mailing list, point me in the right
> > > direction?
> >
> > this is the right place to ask. +NV folks I know.
> >
> 
> I appreciate the insight.  Thank you.

I am not quite sure about tegra194-pcie. +Vidya who's the owner.

Nicolin

> > > Thanks,
> > > Mike
> > >
> > > diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> > > index 818e47fc0896..a598a2204781 100644
> > > --- a/drivers/vfio/vfio.c
> > > +++ b/drivers/vfio/vfio.c
> > > @@ -638,8 +638,15 @@ static struct vfio_device
> > > *vfio_group_get_device(struct vfio_group *group,
> > >    * breaks anything, it only does so for user owned devices downstream.  Note
> > >    * that error notification via MSI can be affected for platforms that handle
> > >    * MSI within the same IOVA space as DMA.
> > > + *
> > > + * [MAW] - the tegra194-pcie driver is a platform PCie device controller and
> > > + * fails the dev_is_pci() check below.  Not sure if it's because its grouping
> > > + * needs to be reworked, but I don't know how this is (or if it
> > > should be) done.
> > > + * This is a hack to see if we can get it going well enough to use the
> > > + * SMMU from user space.  The other two devices (for the Orin) in the group
> > > + * are the host bridge and the PCIe card itself.
> > >    */
> > > -static const char * const vfio_driver_allowed[] = { "pci-stub" };
> > > +static const char * const vfio_driver_allowed[] = { "pci-stub",
> > > "tegra194-pcie" };
> > >
> > >   static bool vfio_dev_driver_allowed(struct device *dev,
> > >                                      struct device_driver *drv)
> > > diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> > > index 66bbb125d761..e34fbe17ae1a 100644
> > > --- a/drivers/vfio/vfio_iommu_type1.c
> > > +++ b/drivers/vfio/vfio_iommu_type1.c
> > > @@ -45,7 +45,8 @@
> > >   #define DRIVER_AUTHOR   "Alex Williamson <alex.williamson@redhat.com>"
> > >   #define DRIVER_DESC     "Type1 IOMMU driver for VFIO"
> > >
> > > -static bool allow_unsafe_interrupts;
> > > +/** [MAW] - hack, need this set for Orin test, not compiled is module
> > > currently */
> > > +static bool allow_unsafe_interrupts = true;
> > >   module_param_named(allow_unsafe_interrupts,
> > >                     allow_unsafe_interrupts, bool, S_IRUGO | S_IWUSR);
> > >   MODULE_PARM_DESC(allow_unsafe_interrupts,
> > > @@ -1733,8 +1734,18 @@ static int vfio_bus_type(struct device *dev, void *data)
> > >   {
> > >          struct bus_type **bus = data;
> > >
> > > -       if (*bus && *bus != dev->bus)
> > > +       /**
> > > +        * [MAW] - hack.  the orin tegra194-pcie is in this group and
> > > +        * reports in as bus-type of "platform".  We will ignore it
> > > +        * in an attempt to get vfio to play along.
> > > +        */
> > > +       if (!strcmp(dev->bus->name,"platform")) {
> > > +               return 0;
> > > +       }
> > > +
> > > +       if (*bus && *bus != dev->bus) {
> > >                  return -EINVAL;
> > > +       }
> > >
> > >          *bus = dev->bus;
> > >
> >
> > --
> > Regards,
> > Yi Liu
> 
> 
> 
> --
> Mike Williamson
> OpenPGP Public Key

