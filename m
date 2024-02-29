Return-Path: <kvm+bounces-10503-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0358E86CB07
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 15:11:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F4162B23282
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 14:11:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F89E137744;
	Thu, 29 Feb 2024 14:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="OHLmBlWo"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2085.outbound.protection.outlook.com [40.107.95.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C715312FB29;
	Thu, 29 Feb 2024 14:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709215829; cv=fail; b=pQgR9I6EpqH7oJJxTEfn/RIlbsuSxu15W+ovHumlQgUHuVP8Xw1Pdx8x7sMI9a2Jms/ky4VtZIZ3mYjDQDt4bj/ycET5JfWIjm3M5+MAGWhfmjleorCIoXzQKAmtfCbIGesxx9tnkK3NW/alY5AsoF3/KCqwcfBH6t1emnkwg+c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709215829; c=relaxed/simple;
	bh=jDmLm27Ak0ia9gQBxYiS1rETOZBukA5TF9awMQ9ah4k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=qjMGFGNJtxA2otiuwB815xfmFRAfwn/pNz73kgpJDdjlO7Og0E213nAJOno3H3OxTw+tfpYWhkJZje+ha1t4tO3a1GenKGp5spZHKHsEE2MbKIe5bwe1zlg4xLR/sCLo2jSsnnqoTwn5pSv45mcobntch8PTsnSApwVZXXrKPdE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=OHLmBlWo; arc=fail smtp.client-ip=40.107.95.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m08CcA2vhNyhgi5CyiVV2tnekwDtQI1gm83X5CzCr//LeUVZ4GjBy7ajEptw2+WVCYgn9ZhNnKotVgi5mVpRpz7yFGB9nlpg0sO29NAX9ZMYsdOTt8ayyfNjMsXvNl4yGfD39p9wSeejDb/RNCHTbh0uyqEhbAV0mXhvppQCkyVXcNeJ6sYGGvOoSjitzhm/15YcOFlSEWRmL66W84mXs9L1AqJedukXzuzufbVf1DlVvY/L3VoQYP2ZBMadhMyaW0p0zacVMvFaDQZ1YmKmdFk/aXM7UNkjzw9O0ZVCkFHsJmGnfuRJ5I6uhXr3WX1O28ASRqN8b0r9ROQkq/aT3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UlwHjePsYabIFIp8e6qpLSo8m7ooE8az37R4M3kyNf8=;
 b=Vnqy/VXVYlj5VbFUpWLZZb6M4ILDDiZdhdwxaxEas4AZudXjfwpk+SQfzHNzyK42ojxqC4A73kXLu3Sko93SpqXEoRrsCHRnAQuI36P3ruX3IYSOc62MMMem2gnFWan+RIDCYKN1YZBDNEBXUxcijpobBtse2NWOGomCgjCI2mR0zfk+oJ+c1ki1/a5ANytLwoXiohZk3ftJmQn5LopEbeurV0fC+IlXbcw9zA2bNCzsuBqlUmqLVM1MgUQZ4uLbz7ipeUZvHf8+86fuVdCW7Zxjs5YXZGOXhn29psZO1/4i+GIvgXvSGflprXFrvMtafWBKSb9sfj4jc7Hwm6BJkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UlwHjePsYabIFIp8e6qpLSo8m7ooE8az37R4M3kyNf8=;
 b=OHLmBlWonU/mNBeM6xqqOrGnJKSz0f0phq4jMOo84kXa+RrSg7CBX0t9F6hz8MGS+clK6acw8KAiFTUkfAriYRCdMn3qY5GOY3uJNYVTTIBg893MzU/fYNN7/9u0yDx0sDQG8EURn7felcQ7mjVg/4qk26ewRo4c5Wc3G2vPB+ZTiqMP1+lwvV/iQ5QINfeIGaIl7+zbWr2XylwHbx8YRVrbRP0GBsEBAJhC3Kn7QEw0G3IrWMMxh5qif4qR54rZwSyWBQ/DTz0gScJKpIswMSM7a7i319YZYnDq/WUS8bE3m5jRqkbUOWEX89g5ioWikNGC1ZSBdtXgk3lde57nVA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by PH7PR12MB8056.namprd12.prod.outlook.com (2603:10b6:510:269::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.41; Thu, 29 Feb
 2024 14:10:24 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::2e3e:c7c0:84da:3941]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::2e3e:c7c0:84da:3941%6]) with mapi id 15.20.7316.037; Thu, 29 Feb 2024
 14:10:24 +0000
Date: Thu, 29 Feb 2024 10:10:23 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Xin Zeng <xin.zeng@intel.com>, herbert@gondor.apana.org.au,
	yishaih@nvidia.com, shameerali.kolothum.thodi@huawei.com,
	kevin.tian@intel.com, linux-crypto@vger.kernel.org,
	kvm@vger.kernel.org, qat-linux@intel.com,
	Yahui Cao <yahui.cao@intel.com>
Subject: Re: [PATCH v3 10/10] vfio/qat: Add vfio_pci driver for Intel QAT VF
 devices
Message-ID: <20240229141023.GF9179@nvidia.com>
References: <20240221155008.960369-1-xin.zeng@intel.com>
 <20240221155008.960369-11-xin.zeng@intel.com>
 <20240226115556.3f494157.alex.williamson@redhat.com>
 <20240226191220.GM13330@nvidia.com>
 <20240226124107.4317b3c3.alex.williamson@redhat.com>
 <20240226194952.GO13330@nvidia.com>
 <20240226152458.2b8a0f83.alex.williamson@redhat.com>
 <20240228120706.715bc385.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240228120706.715bc385.alex.williamson@redhat.com>
X-ClientProxiedBy: BLAPR03CA0046.namprd03.prod.outlook.com
 (2603:10b6:208:32d::21) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|PH7PR12MB8056:EE_
X-MS-Office365-Filtering-Correlation-Id: 085f9652-16ed-453c-c921-08dc39302c48
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	E8amRyn2N8n4F1IONrULkyvqflU7giboZmNlLkg3nUxoOizevisSnWxm1I3UCvvNv4JbXkFvTbToOkP4H/d7ln8K7OtmB7TUxGEjZIVNZjxjj+dyyanmeRC1m9+2olbdaDL0p2CDNpBzbVNamsPQh/imWreKhsTe9vqLKHnjaQQ8PQpxmDxEUGpuGLnp9KgXrubgj1mVZJ6wDYpSZIz7RDLkEOAY38yjFlGJ1jiKE3LD64Dnto4S0CPLY8sVWwYJon9YJXdZCMfXBi1JY4oI0cDFv+1WFtYuYPfA7drgSaAmvjrVhzJYtTy3xSJY4g68YUYsM2oSGR1Q/9nCRPSctZvol4DIHjeANG3EGs2vC38zE+7YsruCcxRZp42gA6ZLptE7TUY+GKDxm5hPAamMoz8WPGV1iWhx77vN5wakL0FGdsTjTnCb4SjVuo3KES55WyQoBiTmj1ee/NGD06yOl8WrBQeBHsSsiKpFfK3z+0pUCE3mY5GWYhWDWjp0fma6g59NSM5wslLNl5UCMkhF0h2bZS6w8/eifOgYR0lYXDK7KX11d9g7B/BZDt6KPsuFjNZ430ZnB54CfRZJGuwKW5NayWqmoijld1lagrz99seoNY/PG9l59p7PTFqnCouPZesLOkGQlRexN6unpLIUOw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?mLHo+UpBQpccpUJLEmKr/p0oAga5ClqWuliMYYkpf+nl+SMPucj7AcWcbKcR?=
 =?us-ascii?Q?1E3hxyX+N6cPHgLjc8mIZNlETtnk+AdaIf8QY5Z84ExY1DPzFqEH8Cttio8S?=
 =?us-ascii?Q?tQsRFrKMU3dnPOsVOWQfOAq8Wbx3cWXIDo+HYekLS5mkowqXc14bl4iJm92D?=
 =?us-ascii?Q?rG84eeOpAkCms/SSSP9O9xNlV3hYUZksJ+F9fJ+KNaGEGoPNnvFuOzp3dtUx?=
 =?us-ascii?Q?8uFjpgAOQSYevU1rMH4pWKC3eaN3BLv/o7SpTi7Dxp1to/Mev+PzB5tbOnOJ?=
 =?us-ascii?Q?InXrsNRzyk3RrnrgdugeOKh8l5mXBbYXWlzMEsudQtl+MBSuHzCGVGLDHGXe?=
 =?us-ascii?Q?W1I5a7QhSTK6ozBetFhN4111dFIIONr3iSJ3cRjJzCFWY9vshTL6V5sHdObr?=
 =?us-ascii?Q?r8xODUYgQrwokzljbceQ8s3nRLg8FHqWgkeXvc3DFJNk9acydsQVh6B4g6kt?=
 =?us-ascii?Q?/JIO3a0oW2b7oNNcSNA7ETohP9TCu/PvvEQnPczJ7dlCPR9HpQfPhEmHOPAD?=
 =?us-ascii?Q?AE7Lt77Z/Qb5xzBw7WslEVd0cIgtkEg7nJgMBO/n4wyRBqJWCzBXSEsep6Wi?=
 =?us-ascii?Q?yboJ3N1RkrApvyWJAfiSAEWH0IZkKRt1tz8SA5neLgrVTo/Eds4X2Jc7v1rp?=
 =?us-ascii?Q?rIODWQX2EdBQ49DeT7YYszw1AQkMDhpBJC6lpOATjXz/Fv/kEYVn8j/AyK4D?=
 =?us-ascii?Q?YHF+i1Oku71b6OpKLnQcIcmtnWSzqCuGX0dtCQd3WPYyoI6dP4rk07TYEpxh?=
 =?us-ascii?Q?UZd0q812iHIfLJxyjdNvTXgGJasNOZ10P1SWcgpOwBq0zgp5QT/Upi9nteEj?=
 =?us-ascii?Q?0Xzy4aFWhN6I3yAK7PkXGQLBjO33/x9rVeHXzRGphE/BTmQnkP/Jz6oHQrNr?=
 =?us-ascii?Q?hU8/hA9G4HqDUPNk0noMDQDL1ttvxNcCAyKfV2i81D7fxIezG3lgN8v4T9nY?=
 =?us-ascii?Q?dyAFqNszwVanJQUJqO5mKl0WxE8QHhz9vISWzZVcvEk+JkTq4/oTpzNlpPlA?=
 =?us-ascii?Q?gJiST4fjDHfeU3bC2GLXKwDoy3Yfb3Vgl+hoe1Rzfz94xNKc+5APJGfTdTQP?=
 =?us-ascii?Q?7nGUwUt6z1bwFSYGLiz3y4i+wnXi/3+Yj1pOBIbnVhSA1m9Z8HQ/yL4yS+Dc?=
 =?us-ascii?Q?eZMpWudfJD7Kdiho975kWpFWWLViVb/0Gt5SYUMZq1XQ05VvkEFyCQb2RP5p?=
 =?us-ascii?Q?WKYFJeWH4bgJqBcvl1eZX/s65AxL5mOzbsRPqIFe42MvtAshEO+hdkVy7qzS?=
 =?us-ascii?Q?RzMDZN28YEJxK+ddnCLBp/0UExFG6p9KhGA9eKQl7qr5cK75clL0Uc5mgRqS?=
 =?us-ascii?Q?3+oKggnOnuHVX6pJoppkxf+DsQoVMSNnvXDtOmO/2QdjX6ycp2XxfOB8ptxn?=
 =?us-ascii?Q?qgJagru6aeiKalcuV+rBFoi2RjLr6x9RwoSYJMFmE+cs6lLAIoc1cfu/PNsq?=
 =?us-ascii?Q?AVftmU0Q6tHScsqYGFUsFXbsbjUMm0euxpERkCoEIbItTKgJLvlVdxQfkulK?=
 =?us-ascii?Q?OZvOBFwIt5x/GAKmfd9ozZ9yPhYiwDVcDjHGpsfNG4OXp6lpHIe9Hyh1a6EX?=
 =?us-ascii?Q?dFgJ0sJZ8oEJEWwZMmGVSSQb+kOwLGeEoV6BtKc1?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 085f9652-16ed-453c-c921-08dc39302c48
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Feb 2024 14:10:24.5044
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fUQt7QNETO7EXUVonig/chnIqdzERpnT6QpbuEMArzkhLgemhpPiF1lnVdN/BHEt
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8056

On Wed, Feb 28, 2024 at 12:07:06PM -0700, Alex Williamson wrote:
> On Mon, 26 Feb 2024 15:24:58 -0700
> Alex Williamson <alex.williamson@redhat.com> wrote:
> 
> > On Mon, 26 Feb 2024 15:49:52 -0400
> > Jason Gunthorpe <jgg@nvidia.com> wrote:
> > 
> > > On Mon, Feb 26, 2024 at 12:41:07PM -0700, Alex Williamson wrote:  
> > > > On Mon, 26 Feb 2024 15:12:20 -0400
> > > > libvirt recently implemented support for managed="yes" with variant
> > > > drivers where it will find the best "vfio_pci" driver for a device
> > > > using an algorithm like Max suggested, but in practice it's not clear
> > > > how useful that will be considering devices likes CX7 require
> > > > configuration before binding to the variant driver.  libvirt has no
> > > > hooks to specify or perform configuration at that point.    
> > > 
> > > I don't think this is fully accurate (or at least not what was
> > > intended), the VFIO device can be configured any time up until the VM
> > > mlx5 driver reaches the device startup.
> > > 
> > > Is something preventing this? Did we accidentally cache the migratable
> > > flag in vfio or something??  
> > 
> > I don't think so, I think this was just the policy we had decided
> > relative to profiling VFs when they're created rather than providing a
> > means to do it though a common vfio variant driver interface[1].
>
> Turns out that yes, migration support needs to be established at probe
> time.  vfio_pci_core_register_device() expects migration_flags,
> mig_ops, and log_ops to all be established by this point, which for
> mlx5-vfio-pci occurs when the .init function calls
> mlx5vf_cmd_set_migratable().

This is unfortunate, we should look at trying to accomodate this,
IMHO. Yishai?

> That also makes me wonder what happens if migration support is disabled
> via devlink after binding the VF to mlx5-vfio-pci.  Arguably this could
> be considered user error, but what's the failure mode and support
> implication?  Thanks,

I think tThe FW will start failing the migration commands.

Jason

