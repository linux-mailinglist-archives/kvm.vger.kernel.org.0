Return-Path: <kvm+bounces-17974-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C823D8CC53E
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 19:02:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E9CB8B21623
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 17:02:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9CA11420D0;
	Wed, 22 May 2024 17:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Pcrt3nsW"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2073.outbound.protection.outlook.com [40.107.223.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8390B7483;
	Wed, 22 May 2024 17:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716397322; cv=fail; b=uCAPxCnJoCP8cXoAdNUwMwYMteFOdW11Rrw0+YIi8sbtAWE66QPH6xQ7n9NFFvy+fm/e3d6KifVgc2OetudJW2cekXEryj4H9fp0iv5R7ONJLewtc2avEYKsJl6L98bn4wHWl+MOHNT7+tv7Y1po8tOrf3NhKo1/fZmZPhEQlaA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716397322; c=relaxed/simple;
	bh=Th7PeKwlY7/HJUtpHpVt5mUxu694TPieU8BihlonvUw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=EeqxBuGv6yKEz4Yze3gP91fDCjRc728Bu4c6sYK1AkjntKBMDkyD6DLNOqWs2OrCifOGoF1KcUmxNbVEsffoWuNAlIG8xDd/h5QPy6DNrJpLQ9rCaoxeJZJGGgw5sJFF5oUkCUXbkzpC7vQLNeNJlnx4aD/0udNDtfDYqCDPtTA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Pcrt3nsW; arc=fail smtp.client-ip=40.107.223.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dk3ylOPpwwHv8yyZIPkJaGmJIxjhkKsykzcUqY5a4Z1ppPCKgiRydxgoZG9BnVW7QxIgpn1cC2mz3hC22TDvDXlybeIEWhcdyJurSzgrMPK/6Pftf0Q9dBQhLKTOI8CEzLyfU+Cwj9M8vA4x3S/HOhwUNWxoyxTt95scWbV8sNBt3f0OiIkijWHKmlN1+rq4MIUbQREE5FwS+fRlzApYcyUPsWVBW88i6N80ECWGCvLBV025/aim8O9fMfmKmemfU/PcscMMtk6vtZvbVOuHKHAp+lR+nsvMb0EwlKZq/nfRrTlmFRYNsL5B+rADffrFDC19QeEjEJYGqQL7BAV0Ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aC69G2Aw5jtkZU1PBkmoArfnkLj9msJc4quu2KnIS/0=;
 b=Sogq5MJzxEoLRssBjodxx8NKX1sjl4KzflEX9khc3eTu4LXkHJqUPE3cxFvRJtbwAaxe9IRcsABEzL+huPU1ZgyR+OgayVSKTCvTiibD3H4oJGTV2NDRGUIvn42xhpBWmmDvTjuw8xxLJ41ONrTfHzEnpIdIsMipYwnVWLV5vc3bn9lJUIV9XAYohWPmh+QdjWJfVsjxJLocg/lmewGhVTbGkpHvPIBNQXNCWrnKtXUBilgjoekIbel5os7gid2fjdTprOdeCl0N8wtpPKVn7mxzmO9K5lHlcXilLUqnOik9cSXzJZ0/+kLs9a+F70LrUBjdiFrJHEjl9ZdoNv1nUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aC69G2Aw5jtkZU1PBkmoArfnkLj9msJc4quu2KnIS/0=;
 b=Pcrt3nsW8QLMgeh2b2ez+FNthAMMZbJ4dZ4dkANRpfk4vaeChMzavLJbLHxYE8SB3I3/n1h7zsN0N93SiKc1BIao1VrWkpHcjv58TueVIffT07a8/6iKKJHKAY/IU4ivo1J6QqKLlriRVhHx4jyYplFP/dq+zIzETaCHslX2MLfvi1/kyIdOd9tfaPN4WZ24jn0grbJokpj4cYxhe5lfhsHSs0FYCNpw13pUxVKpyFLSV45GsrNxZv/ML3541GzN+3KrwNBGT7l5MyXIPV7VIJDxvZW0PJ6/nw8O3K3aIaGQY3hQolYav+IJiRZguDrhidxqLQ6kPfrut09otd3DGw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by SN7PR12MB8131.namprd12.prod.outlook.com (2603:10b6:806:32d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.19; Wed, 22 May
 2024 17:01:53 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%4]) with mapi id 15.20.7587.035; Wed, 22 May 2024
 17:01:53 +0000
Date: Wed, 22 May 2024 14:01:50 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
	alex.williamson@redhat.com, kevin.tian@intel.com,
	iommu@lists.linux.dev, pbonzini@redhat.com, seanjc@google.com,
	dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
	corbet@lwn.net, joro@8bytes.org, will@kernel.org,
	robin.murphy@arm.com, baolu.lu@linux.intel.com, yi.l.liu@intel.com
Subject: Re: [PATCH 5/5] iommufd: Flush CPU caches on DMA pages in
 non-coherent domains
Message-ID: <20240522170150.GE20229@nvidia.com>
References: <ZkHEsfaGAXuOFMkq@yzhao56-desk.sh.intel.com>
 <ZkN/F3dGKfGSdf/6@nvidia.com>
 <ZkRe/HeAIgscsYZw@yzhao56-desk.sh.intel.com>
 <ZkUeWAjHuvIhLcFH@nvidia.com>
 <ZkVwS8n7ARzKAbyW@yzhao56-desk.sh.intel.com>
 <20240517170418.GA20229@nvidia.com>
 <Zkq5ZL+saJbEkfBQ@yzhao56-desk.sh.intel.com>
 <20240521160442.GI20229@nvidia.com>
 <Zk1jrI8bOR5vYKlc@yzhao56-desk.sh.intel.com>
 <Zk2Qv4pnSKZBsLYv@yzhao56-desk.sh.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zk2Qv4pnSKZBsLYv@yzhao56-desk.sh.intel.com>
X-ClientProxiedBy: BL1PR13CA0305.namprd13.prod.outlook.com
 (2603:10b6:208:2c1::10) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|SN7PR12MB8131:EE_
X-MS-Office365-Filtering-Correlation-Id: 04fa9997-fa94-42fa-a24c-08dc7a80e11c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|7416005|366007|1800799015;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?J7Y04/5GzBuxkTdqbkZXFaxHleSuUo555WoUuccTVMWsEGVRG6HlOFOfUnIk?=
 =?us-ascii?Q?f60MfK2zhVqvCi+alvBsbmyHLzeVNGQhfIl1/MPNFpZ1Q5lRmsPFEEHserK1?=
 =?us-ascii?Q?MDVKR3Qaq3+8isuj31v7aXIJpkkZ2AWh34mlkUYznvBDG0Owv7ud/bgTdWMh?=
 =?us-ascii?Q?MST2DRAcANACy1Yx4ywxtkCOFOfdQKemYXZlQvYZF1cvPkO/zJZrIxZVgpg2?=
 =?us-ascii?Q?mgTz7Uw9aVIhc5hxpF56Ud+rlWrf96sXiHIQL9wMEbZlkGh+lvPYBdIh0Ta6?=
 =?us-ascii?Q?aXkOM1QESqBv5WQZjpLz17+rHtcw4QjydBgX4EB5Ggs6LXLar1I1ZhvJNvct?=
 =?us-ascii?Q?1b2O3GvEPVAmS4nMF8CyJxDCKifm/roo/CTLotTtfD0lR5JkoPwvcSFj76yl?=
 =?us-ascii?Q?9ee995RqXJ5hVEf8sz4F18aVA6AlxTUi+fes0WzM6PIqax6pMq/VTkVSz4BA?=
 =?us-ascii?Q?u6Qlj5fiQqyYVaLGF91AHVYyk4WEsGML5ar4AF/ACJhHwfA4cNtqzNMR9vCv?=
 =?us-ascii?Q?77rOjqhjl11xBL2+mzrNxNdxd0iUR7H6ffhsW0T4pK0rpfiNeCehL3Kh51yk?=
 =?us-ascii?Q?1obY6lsD0o8btQ4mBNqzENfSgkRYeVWdY4vT7e8QuA3B4fz02NgJtaoE0WZe?=
 =?us-ascii?Q?79QB/1GddmBLxUEmCJ/Jp36gdOusoyU5L0XF8DYNZsFXD7Qf4hZ5xuZpT9zZ?=
 =?us-ascii?Q?0+DtH8YpPlGNs7WHFfXspGiqcTYSKj9s/9/srGwbilQ6Z1t6MShkKPYLTeod?=
 =?us-ascii?Q?Fhtl/IuZpaLFpyHF8UQw/lxdXwe74NWwJKHjBt/caJTCvKnKg//INeH45ux/?=
 =?us-ascii?Q?+vn0v5cdKQsMQ+dNgFKGsSAZZ4GdGAIX7Zy0sMyjIDExmgqQ44wP2ByTEW7g?=
 =?us-ascii?Q?a2FZ7edYMTcKCqK7tgp0KHikRIu1WhN0dhBKXfU/lKlx00aiRk6vMMxV3W7j?=
 =?us-ascii?Q?ylv8kxA0NcTCX5nabgCisKRLboypRBY9bqZ42+sNJ4lTfFYU/Edrl3enwFLi?=
 =?us-ascii?Q?KXNitSo4kxsOKOoZrhncxgLsBcZFtwKYkfcuLBlJmauhaSTMH1y6rEIuRxZG?=
 =?us-ascii?Q?gWlY7gNNk0ZG0QZCOOvXaQR7hMzdZCZxEMAvlRKdXrrccCCvvgHO/oTskxNZ?=
 =?us-ascii?Q?b1kGRuZkN2c/mXn8HUS2jnWzkupSDp80WuvG6/50DAc03U94IDinbmaT2PwO?=
 =?us-ascii?Q?61ycS5ga3fX5z9vdO+IZvRDiffOJVQ0Aq/fBkZEWQtcEcP0W+ICe7muRa0uj?=
 =?us-ascii?Q?B/s2/MDTDTnloRI1zCOq/uDLURiEXHn/F39+uktSjg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(7416005)(366007)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?qkR0YwCDpwDhW90Di47FOceHGoU/5X7jwlOaXDIG8RYReXt+80VPNr5f7z36?=
 =?us-ascii?Q?oKWqZOghactjfIHh4jfsCHXvph7ac3v8Cq4Ax/dC7EcnpDdtRkFUfU29LK9T?=
 =?us-ascii?Q?fQCrwHqXV4ueMqVGVJ5hwzGbZpoWBDIEc5T40pI0Q15HgjUZBohKVXSvS7e7?=
 =?us-ascii?Q?z78AfZWWPHB8Xnj9MlgQ44QuA8vYyX12Apun+rXa1Pqtdssq2eVT78bv3Th2?=
 =?us-ascii?Q?NrZh+1qgjdec3OQHj9Kl10SQOzLv0LaNK3U+qY8U0Isl3IKnteylVgef7oHY?=
 =?us-ascii?Q?tDgqUolswZNVixo9F50tXyEABt/sWvPdhw4CtW9pUP67xDgxVPgYqyg5iE8l?=
 =?us-ascii?Q?6zo10L0qB3UlxaimKfBeW/fHQX70pb55vJtD/dw8JxChHprMqwetZpoteG0m?=
 =?us-ascii?Q?BLo8S9PKTmQ02q2hOAL1fjF/0keu5emyTA0ThIiwvWkyonb66ORFPEhNRcw5?=
 =?us-ascii?Q?MuhxqDE/YPU3PMSrGqCgw/eXTbqXUHlOpQMc1QhpAckFacCAXG7YbQnWEN5y?=
 =?us-ascii?Q?LSVbPKNbi1U7YoGheDKotwEset7mkWcvht8uMQSJzTBV8TDv3vwXGR/WHJhS?=
 =?us-ascii?Q?G8MsZ+01Dx0gpBna7rjrIilDf6+DdNQfLPWzCyHr+BbILQK1Gozb3NuygULf?=
 =?us-ascii?Q?mhMiCRPYnWSkcZvdObN31BIgIwWW+rulLFFCHLKpJmibT37wzGdmOu5Ecqwn?=
 =?us-ascii?Q?+FuQBzcf37kZ5gAckLgUPt0a0gLtEcS6DKyVmoMGdsKbt+g0ujZ9guBt++ir?=
 =?us-ascii?Q?l4Wsuay3bO22urlf8A7kv/Iv9PP39loFr59CxPz2XXSKekw2fQfFpACoKM4+?=
 =?us-ascii?Q?stlUQnGGtV70MD0JrWolk/WgSjujeddd6wpCToHai+Pj7yATjK7LqkGutUWb?=
 =?us-ascii?Q?WX0ouJHNd+1rPJO8396EeiuK6b847lU6R+OnhDBtw1p543vJ1vkWQo+DU/KD?=
 =?us-ascii?Q?GszZmCFnPoxN6Vu2FxFUz/PsPd7nxU3iRF2z89rN22kLr8w6/k6Z+XTwp8zl?=
 =?us-ascii?Q?mvY2nIwdR5eSi4JNC3S4Pg2UY6xllvfXNkHNPUR/eeHoRGwC7gPpveiSWu3P?=
 =?us-ascii?Q?ZlN6YQEFsUX1edKL4XhlBtIQzTNLr/ZVsTnAWl+8e0mvhYQevRg21YU3IBvc?=
 =?us-ascii?Q?M9rB1OilWRZISstDupbk6hT251mnLuW8Th00ynv4gGLp+W30cygBKcvUJz+T?=
 =?us-ascii?Q?C+SwECww+cy+ITeG21vLDzbwrPEAZd/g0rDXD1QhsnsSAEDGyqaGNMd8YKdI?=
 =?us-ascii?Q?eDOC77BJiUuJ48+jGtNC5rzC9VYnS1dGlU1ZJeMSczYYNEJvouSg5XJX8TxE?=
 =?us-ascii?Q?0QmX+SHjvCaKNvqU+tbg21bujgeDUJnKDYZNJljvcVdXDY3eeeHiGWFUAV1b?=
 =?us-ascii?Q?vqwF4pYCu3G4bhl8l2dft2iAdW/yOaRpsl4NCj7dcRkgwPQ6Yp0Wa0Uod3aY?=
 =?us-ascii?Q?P5aNs+htYkZ94n7yN+bL2mfcYmwnHqcE14+yiW03Tgbx+NReJIysNe75jan5?=
 =?us-ascii?Q?HubwFgHLYZCbgV+nOK6anfysj/Sh+wCCbmO2bk100p4ExL7iQqR2vjwHv1Ve?=
 =?us-ascii?Q?IcEtcFDSX5kB4maG9z8=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04fa9997-fa94-42fa-a24c-08dc7a80e11c
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2024 17:01:53.2688
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JUd3t17vvS3/Z+ltJuF32nWRorIo24NHdhQ3IutS7/YlUHZd2p0y+MTkIDCXVYSL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8131

On Wed, May 22, 2024 at 02:29:19PM +0800, Yan Zhao wrote:
> > > If you want to minimize flushes then you can't store flush
> > > minimization information in the pages because it isn't global to the
> > > pages and will not be accurate enough.
> > > 
> > > > > If pfn_reader_fill_span() does batch_from_domain() and
> > > > > the source domain's storage_domain is non-coherent then you can skip
> > > > > the flush. This is not pedantically perfect in skipping all flushes, but
> > > > > in practice it is probably good enough.
> > > 
> > > > We don't know whether the source storage_domain is non-coherent since
> > > > area->storage_domain is of "struct iommu_domain".
> > >  
> > > > Do you want to add a flag in "area", e.g. area->storage_domain_is_noncoherent,
> > > > and set this flag along side setting storage_domain?
> > > 
> > > Sure, that could work.
> > When the storage_domain is set in iopt_area_fill_domains(),
> >     "area->storage_domain = xa_load(&area->iopt->domains, 0);"
> > is there a convenient way to know the storage_domain is non-coherent?
> Also asking for when storage_domain is switching to an arbitrary remaining domain
> in iopt_unfill_domain().
> 
> And in iopt_area_unfill_domains(), after iopt_area_unmap_domain_range()
> of a non-coherent domain which is not the storage domain, how can we know that
> the domain is non-coherent?

Yes, it would have to keep track of hwpts in more case unfortunately
:(

Jason

