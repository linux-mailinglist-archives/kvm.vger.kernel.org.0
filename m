Return-Path: <kvm+bounces-18579-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E4DF8D71BC
	for <lists+kvm@lfdr.de>; Sat,  1 Jun 2024 21:58:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 247441C20D0B
	for <lists+kvm@lfdr.de>; Sat,  1 Jun 2024 19:58:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 825F2154C19;
	Sat,  1 Jun 2024 19:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="OeReX0/Z"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2053.outbound.protection.outlook.com [40.107.220.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0087A14E2EF;
	Sat,  1 Jun 2024 19:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717271918; cv=fail; b=VyjUThOgMLbJUOeY2umeWRIGk5xsH4gVvNB1tgIxT1dbf1cPz94agqRfq+Hp2Zvix+Kdn5HBDy1TbT4oCCUxUQRvIdwA7+PI1bCA9ksdqJazC6j/kqbp1/ijRh1rvskTVTO9YkCa0lFeKTtAy2J2wvHl8INMAJtZVsAnY6Na7lY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717271918; c=relaxed/simple;
	bh=MGFV9J6cHxW5w+ZGgN9i8GNmneTVf6heCN5itv/mTBU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=qL3xbVJ6vlYRJt2GFXX/FxqcDY67y5fz2FsFGYuJk2jmExe4H07eDBLbE3pYLEOR3ir9amM5sopjlS+GF+ELVVOoC7XeAn4FAH7lCmF7jKfyjQ57UxRU+gn4bnKBiIZXtHpsaQUwjCda7C/WTSBfLUwV1YGZqGggE4lHBshFFug=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=OeReX0/Z; arc=fail smtp.client-ip=40.107.220.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jC6Es0n2CR3VWijRaKvneAaamrrtBdX1ddlUL1tWW5azu4cmHT1iqKMMMkDEebwTQbDsed1MEpg59598zymrlJ1jthLjort02LlwpGc539f3596dM2xuN6cw4gPPW/IlgPnKGkS8G+seIGaQj8PwbEZVWwQVOXk4KkymSzDF24B8HGggK7xt53f1THsHkrbpLSunzIJG1xsmlxov+yaOYn6EKVFusOHkFmRZfBNasnuoH5i+GNkqFn6YiKU6GT6iXFZSdQhmGppgbNaPgYly+yE0NNVooTgVD3fSfcmwf0IRRPioO0zDe9f9jgtbGrg1VAcsomtYbILgulWdVPwmFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i//7Uz2Q6Fsxe/l+Bg7v6FFAFgtCIZ+L3OKRPBrbwWI=;
 b=E34olvGvWqYEaFHKrRNj7lkcGXdvRWzHN4Qov83NhGwMso2zJPC0omwUrFn4pa44SL51h0YtYKPvtG4051TkOyG1Iyk6fvbBr0F8fFm37OOlIGrLRF8wJ3pYauK7+wfid6bw9ZymMZw0olV8II2D0yY+z0pS/v6rqj4DK2AJV3tOcyjFURgVUxCjVBDT7+AJTAv7EwPEZHWWuleLCr3YILqLgc7v+at2saWanTwdXo6VINAqPQMBEl6BjHI4jcWfadPFbmDRYhgCsdjb88PdtWu90j8cuQpbwbDyHY0qEgG7iI9VY165fiEbQICg5ZgvgxteJgdJnnN0KWdD4j1eMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i//7Uz2Q6Fsxe/l+Bg7v6FFAFgtCIZ+L3OKRPBrbwWI=;
 b=OeReX0/ZVF2mVWPkrcylekddFmStdt00QT7fBw3hA/bmEafqDed+VnC1BJDF24xJ8GPF7vnOy3y2sBA3QvkS2PhqNOH1iUdyd9WrtzUmU8iDUndMNMe/0CsmtBlLy4yj26hDsi9WDr5TFUrKRNd6igZ2/E8MhqbEE0Ve2sYo7oMad1+tRquC5t66RHmoc9Z7mjKSigwl+xWC6DJTNxPYcSUPNjdKpxL2hlAIgq0W3pxC2GPkUgVDwVCh+AXHkQpTIVKUQEiRE/h1pubAUh0Kvc2aJGEtcXS64KIYF1GriN7MblULg8WRV0KzBT4a3iz+k//xqz90EYBXXIVUL4fmkg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by BL3PR12MB6451.namprd12.prod.outlook.com (2603:10b6:208:3ba::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.24; Sat, 1 Jun
 2024 19:58:34 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%4]) with mapi id 15.20.7633.021; Sat, 1 Jun 2024
 19:58:34 +0000
Date: Sat, 1 Jun 2024 16:46:14 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Yan Zhao <yan.y.zhao@intel.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, x86@kernel.org,
	alex.williamson@redhat.com, kevin.tian@intel.com,
	iommu@lists.linux.dev, pbonzini@redhat.com, seanjc@google.com,
	dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
	corbet@lwn.net, joro@8bytes.org, will@kernel.org,
	robin.murphy@arm.com, baolu.lu@linux.intel.com, yi.l.liu@intel.com,
	Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH 3/5] x86/mm: Introduce and export interface
 arch_clean_nonsnoop_dma()
Message-ID: <Zlt6huNJeW8ekJlE@nvidia.com>
References: <20240507061802.20184-1-yan.y.zhao@intel.com>
 <20240507062044.20399-1-yan.y.zhao@intel.com>
 <ZktZDmcNnsHhp4Tm@infradead.org>
 <20240521154939.GH20229@nvidia.com>
 <20240521160016.GA2513156@nvidia.com>
 <ZlV7rlmWdU7dJZKo@infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZlV7rlmWdU7dJZKo@infradead.org>
X-ClientProxiedBy: SJ0PR03CA0003.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::8) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|BL3PR12MB6451:EE_
X-MS-Office365-Filtering-Correlation-Id: 76ba1885-f7f3-481e-d511-08dc82753833
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|376005|7416005|1800799015;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?E0bZL2YjU0RYVofIbqZVR8L3vlS/hXglAApVpAtEzOANB1FD/YUq+ZdoNWBZ?=
 =?us-ascii?Q?BHQLaZiQHo2Me0DxvxG6AHv/72ta4fu/dksdia/lU1LpIXTwgbXI04I0fsQ3?=
 =?us-ascii?Q?I3Mrym3q5+7TLEuQT+O1NWy3dFXCqcUHvArhmvf2brw4tdnm0vRF9HrQEATB?=
 =?us-ascii?Q?mHDMr0FLBpI9hVRPeX03qTofUFdRnuMD0nZgOdE/nUE/+zSQL40YjTNneT3n?=
 =?us-ascii?Q?/RQs/wriM94r/CX4ufUjDyJHP3Yu0hLAZsENZ65py0BBDgiUASkNRh3oLyX4?=
 =?us-ascii?Q?eS6I4YVxXo9EdV53p05YFCyQqeG20vPmaLNzTO/tdmEEbxwpWciQvgnm6HOV?=
 =?us-ascii?Q?rxEgb9/0YoN07LRtii85QjAtvM1HrFQQPBq/Mg+XpDxI/7wdyZJoU5w3FNct?=
 =?us-ascii?Q?g246fv/Xj+HxK4GVMHCgdvIv6TGcaVs5xoOthgcjhJlGfiLH24/6NXW+eU7A?=
 =?us-ascii?Q?3pm0n6vqVD3iQTFscB5vfbLZ9x5b7iufUyXClHoEvQVhz3IqMVxuv5Fn15hH?=
 =?us-ascii?Q?vQ4UVul6S12jHDS2wjjh1d6RE0XKjL4YQ/9LCEzg1aijIQXfYeuxZws43TMh?=
 =?us-ascii?Q?NUG/srP2zS1w94B5NPj1JdapkArGmZ9Vr/m4Lzj10k5S8i+zFEPXRaqSxDLs?=
 =?us-ascii?Q?DPHVmiZ/ykgM3HBbFb6f8ritO+Rcp2nxWIscYxbHC8jCNWlAc4Ot6I4EZ4V6?=
 =?us-ascii?Q?S5tREYnzry3BO2TKAyUVq4eCxHUlbBHENY/HgPTZUas2CxsdZopZXMYf0fP7?=
 =?us-ascii?Q?XFRcD4nUx6uPx5er+DO+Hh02ESYvCrNJhA7k5dGpkdJM+qXWvQz61qGH+P55?=
 =?us-ascii?Q?u4M2RI7fYZOPMLQs5mBL7CxZhHSjUN1rywzqbGmHv4gGm7by8UrpWz/B7YTB?=
 =?us-ascii?Q?n2OlFFK+Vq++JMpv+INYW/cEr5UqpKpXC52dJpDz0A1bblvS420C6R0AB7eh?=
 =?us-ascii?Q?krMeN4fOIeayadRC+sD7k+KI38w5vI/XlX4zIMvcad+kslRe17Ll+yEq/vb9?=
 =?us-ascii?Q?Kjl8u7g82VtxTNBV41T/n/y/cNY/dsM1gAsRp6Oq/a+3PhWBaez4XHRP/tMn?=
 =?us-ascii?Q?qbxOly/U4BBEu940o/qjTq0E5rOvDuh0RTYPfDzSexde8tYtHrtfP7Bmmbec?=
 =?us-ascii?Q?v7Mf/26cqnn0LuUtLb0k3LqvipM7RudeP2fy1PO2BB983Bq1xxlIA/QAgpkw?=
 =?us-ascii?Q?tc/HR1wvYYMn54jLoQTgl1jfOcKnXBdlodU3P5LaJmUzx49bq8ir41nT/LTW?=
 =?us-ascii?Q?uedM/X4ebZMZ25VxNK/E6vRvu287yBboUKodp0HzFw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(7416005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?P/8kWTuwQoFriPEkjQniHEJvlQK4LkaKSrvr0dXh7qUflSsTges7Gtu4xHad?=
 =?us-ascii?Q?rcldTNVwvsJfG2FAfEldhV7AKUdmymkP+5WXRfKAb8JwfJSSxnqkBs5G4+fg?=
 =?us-ascii?Q?Cwgd0jMCNOcW1TAxU0xr3L9TtDH0ZjqhE+q6KiGZbVZ4p3rDm9GGEVR/2hXy?=
 =?us-ascii?Q?8LYsujT90my5IxMqhx+jI0krk3ZXabBW5goiX0z+JrcJbOqDST4EzwK8EjNo?=
 =?us-ascii?Q?Y6AAUCVccMJjvGN75ZonHjf8hEzKbfMJq07LD/ZnNvkUN2h1M530RCP2WEIx?=
 =?us-ascii?Q?qYP6U3GIsl3UecpNiCyW/YPb4N2LYwSgnRA7dsAuX0TM6GJtjHyUc9EClklh?=
 =?us-ascii?Q?e9t4+Js3W6Z0qndNuD2gZ2ggh+a/HkKbPKlOwMSl7voCXgKfxa8jjv4uEoN1?=
 =?us-ascii?Q?Z250v/DlyqRVZr7uKXuSWlPxh84MlTsB7jQyRk+8EOl1eJBXW6jxuMjp8/i8?=
 =?us-ascii?Q?mj7i+0cG06ZDAsUMTNNC8gnRjqIjE88IxcMMcnsqNYh+N3TvJoG6E1UVRJ4A?=
 =?us-ascii?Q?2SmBMblWUQWNFkh6xzCj9LA17vcRiWDWoC5F/fNmBa8P3MDrzqw7Ie/iN0LD?=
 =?us-ascii?Q?Znf7295ficAcRmR9x9EHjIo9HsaJ18cIu7DzsCrVfAhKhmIQkDx+1Udf5nW5?=
 =?us-ascii?Q?/eng2pWRcK/QyLXLE1qprMYAJJmIIQ725aOQ6PGhHyeBdV4dmvNjR2g74kqB?=
 =?us-ascii?Q?xJ5kjSEP7gWuvDzdp36RusPwn+rSisYrmro3CgjLrk0TqKmkdr5tovL1PsPj?=
 =?us-ascii?Q?0oRIjLbPDPTNa45kqhOH0ZHUYZ0ipUoCaDxtFWC7ATXe3U5GamgRHrffjYJs?=
 =?us-ascii?Q?pJ26jyNKrekd/h6PBCTjUdKqovXbH7gEzQ6AcI49lScMigus1fbwF3XagNh+?=
 =?us-ascii?Q?XE69wxjvpCLsVtdIekH6s+ZER3+YOq+e4f4bEctBFaqq2k+nwOaL1im5BgvA?=
 =?us-ascii?Q?pEMWmbPtsmvtA0Yo+GZTaJVvmh6SUkKNmSXMi7F904jf+UVHAXXRslEBL86Y?=
 =?us-ascii?Q?HLL5rlYrLoZwN93IEMAvn9+JyILkUCgPi7jkO7QOdHCxXfv5sMQ+9PFmDhDE?=
 =?us-ascii?Q?8TpkFVlCbPUeFXTEvE3FhhEdAMshwi0UNNwnUeGiTxVnRCYzPqijhCj1jiT+?=
 =?us-ascii?Q?Xi5GaHRoHvGVlgUNF4udpT4HDl6CPZq3+LY+FMCzMAs6pO82dg2NvbIlF0V5?=
 =?us-ascii?Q?+QE2X7Q7Thl7TxrV7RNlqZfUpgfhRmq87JoynUE/IUgGIO7S1HDfMaXh+V2L?=
 =?us-ascii?Q?CGIATwmAqsNVTmNWnpbI+00o0I0AUO0xMBbMQEUvbEfMWFWZ1PH1tL00UgZx?=
 =?us-ascii?Q?nhJGEDAUoZSJbA/IqKHeADHmRV8+1b8z/3WnNOTbs+RmJzZ0reexcik6tGPp?=
 =?us-ascii?Q?VmFsI6zKNvGXVDRebKIzvLTUVE4LHQ0SBBlSsJWEzQQBnIEzYmVX5R7pR3U+?=
 =?us-ascii?Q?+ZlcHI2SWNDAQsQNq9mpFMiDX5CZ9fZ+E4DTmL4jKtWHoo7wbBuiz70oRfCl?=
 =?us-ascii?Q?PteBQK4TnCM0GbbSqIw4if4ixsVP+eDh5VHDAavkM2O7NQWkhQHnvoJQB4Ui?=
 =?us-ascii?Q?/ZULHwxonSKl1qNPgygrAAz2RVUJwOtkN4I2YUoz?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76ba1885-f7f3-481e-d511-08dc82753833
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2024 19:58:34.6771
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qjdotqbYU/h1WmL8nfzHLxwp8opmcEYxUqfBTKrJbvGeFYFNxKhZZ1Mly3xgoMZ+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6451

On Mon, May 27, 2024 at 11:37:34PM -0700, Christoph Hellwig wrote:
> On Tue, May 21, 2024 at 01:00:16PM -0300, Jason Gunthorpe wrote:
> > > > Err, no.  There should really be no exported cache manipulation macros,
> > > > as drivers are almost guaranteed to get this wrong.  I've added
> > > > Russell to the Cc list who has been extremtly vocal about this at least
> > > > for arm.
> > > 
> > > We could possibly move this under some IOMMU core API (ie flush and
> > > map, unmap and flush), the iommu APIs are non-modular so this could
> > > avoid the exported symbol.
> > 
> > Though this would be pretty difficult for unmap as we don't have the
> > pfns in the core code to flush. I don't think we have alot of good
> > options but to make iommufd & VFIO handle this directly as they have
> > the list of pages to flush on the unmap side. Use a namespace?
> 
> Just have a unmap version that also takes a list of PFNs that you'd
> need for non-coherent mappings?

VFIO has never supported that so nothing like that exists yet.. This
is sort of the first steps to some very basic support for a
non-coherent cache flush in a limited case of a VM that can do its own
cache flushing through kvm.

The pfn list is needed for unpin_user_pages() and it has an ugly
design where vfio/iommufd read back the pfns seperately from unmap,
and they both do it differently without a common range list
datastructure here.

So, we'd need to build some new unmap function that returns a pfn list
that it internally fetches via the read ops. Then it can do the read,
unmap, flush iotlb, flush cache in core code.

I've been working towards this very slowly as I want to push this
stuff down into the io page table walk and remove the significant
inefficiency, so it is not throw away work, but it is certainly some
notable amount of work to do.

Jason

