Return-Path: <kvm+bounces-17386-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id ECD468C5880
	for <lists+kvm@lfdr.de>; Tue, 14 May 2024 17:11:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A0E0628268B
	for <lists+kvm@lfdr.de>; Tue, 14 May 2024 15:11:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D98626AC6;
	Tue, 14 May 2024 15:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="kopBWkAk"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2083.outbound.protection.outlook.com [40.107.223.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9889D17BB3E;
	Tue, 14 May 2024 15:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.83
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715699486; cv=fail; b=HcC1YwsLoroziqgORAAU9YyKhzuWMUuVuKskOyAn+J/2SeWdTvvzrWsgwMD+HGe2vCyFhiMoKWL2YqKi04LDlwGM0mIDO7yFmEp4XmJQtzcSFSXUAdizxQQAy0hDxVh1gGB3UPcPgxvDJn5NkVQBhDaZcA9biWs4Mvyd9vfCSis=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715699486; c=relaxed/simple;
	bh=dtxijAdLjaEAam3NGeCkh6LPnhfwXdDGz4REVE/dob0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=QvF3Ln2WsMUve+xPwIRKAS+GlBM6Av9b9e2fEDHW26+f2H5Cr608hEP1/nxJc+7EP3gi96PS9b0dA78MwLpKvNx3ZN/LeblVqv0XU6s12NE3pVv0KajMtze6baK1cBgBTAYklQQQrgzZdvvs9B92xyzhmIDilzsdm0Rk10f7XJk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=kopBWkAk; arc=fail smtp.client-ip=40.107.223.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LGjDcpCnOnL+RhhLG4+ptjtFCJ5t4f/HHBVnArzSXSWa0yCZvKaUmG2+Pz58aM5vPYu9Pd+PoFIJyRAw9xV5wjK6OKlqPQ11offh1EupGplutTBYbALrJn+Ue/lXU2dUu2E3E8sH9wK3PfpoRLiIyrjjD5NP5IZVgAXAvE/et+ZjylhfCNvP1mgrIDK8xYZ2XxTZjrrnLDk+ekai3U5P+mZawXDBrSqy+gDc8+RQg+6M46pMLvSGAuU67SjUCYfboGUX80/KU3jUTNtnxMFFpd1e1Hj1GsZF+O43bf4ZB3He6hffIEkX6t5g0SERWotJadZS3GftnJFqUdj7VKUs3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pnUnAWVZReo78fLwqksvfsK1aF1Xntu5eBqyr45fkLo=;
 b=JKup0KzXJSYD7hUlHpnm1gFNW8aZ8F6ezrR3UVjVfSgbmSBh/EeeKrFoLKp5+NvuKW92QNO+LuHlYb2NUDAWeFp7PMuR9k0ECFuT0xZ73tgth8RoVOHt3ioYlUCKoGsVwJIIlz3N8gGmbufeYnxnD/0/dp2zvr4+GvMevTypbSvHHtnm/SRYxArTnaFGm5vwUD+Ff2RHt0gycRdeUx47H9+YBi33I5yEuszlBuZDjkLaEXEjCYi9K4pQYV8/xVi7FXDWjZ6xxyRVrjgzuyQjNQ+dAypQmiWve81SL5xg26U5yLIEUbtTcaSgUoNj6t8Wf8jRcJLkimyG249IkUkePw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pnUnAWVZReo78fLwqksvfsK1aF1Xntu5eBqyr45fkLo=;
 b=kopBWkAkFL/cFXgtVQtBhZYyjHSYd+GMdhx2CqBXghtQdB/h+Gc8RsfYUILF5zRQtZJvy+pyFX2cotiVvJEu4djZvzGoLsQUqZ2Sz25WyzLp22JHTErpb7HjDR/tgAN/xeKqMJxNW08KaA/YOfjaOHzQJqyP+kNPa2V1/dAbUTLJP3QAScuIvQzMWvBmvENgTP1ACDIFXjSokDTlxf8zGGlojld7n/++PO6WQQhyJQdVE3A2YVXb2eunMrKBGFU2Aebu+RQf+DIQckbhcScpINzzWPltBktRiry07g23tiy1voTrwXsinEdM0pBJ2SKdga5OTV++NEP5EFYKvSQUFQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by PH8PR12MB6962.namprd12.prod.outlook.com (2603:10b6:510:1bd::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55; Tue, 14 May
 2024 15:11:21 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%4]) with mapi id 15.20.7544.052; Tue, 14 May 2024
 15:11:20 +0000
Date: Tue, 14 May 2024 12:11:19 -0300
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
Message-ID: <ZkN/F3dGKfGSdf/6@nvidia.com>
References: <20240507061802.20184-1-yan.y.zhao@intel.com>
 <20240507062212.20535-1-yan.y.zhao@intel.com>
 <20240509141332.GP4650@nvidia.com>
 <Zj3UuHQe4XgdDmDs@yzhao56-desk.sh.intel.com>
 <20240510132928.GS4650@nvidia.com>
 <ZkHEsfaGAXuOFMkq@yzhao56-desk.sh.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZkHEsfaGAXuOFMkq@yzhao56-desk.sh.intel.com>
X-ClientProxiedBy: SJ0PR13CA0162.namprd13.prod.outlook.com
 (2603:10b6:a03:2c7::17) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|PH8PR12MB6962:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f01da41-8fc3-4de6-78ce-08dc74281c97
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|7416005|366007|376005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?IcACAOt1XXixgcjtBvmRsPqlE1L8j4L8j7powGIJea6cNwXvAw5aLhrJjAkA?=
 =?us-ascii?Q?kyJqeiW1b3eA3IAO7SYiXpONrKmU2TMRn61d8sAd/wvu+DhWzAdGN5gOVP9S?=
 =?us-ascii?Q?i6PnVda9khNpWfvV8Ri+4p4x9llNT8CSr2G2D63xTBQe+wR4DaCgWwLMHJH9?=
 =?us-ascii?Q?o1CVgGRuOTboJnEaw0fgc0PCeguKVMrlUrPkkuhHTtCXQeCIj59eM4QR64BE?=
 =?us-ascii?Q?dacNHPM7gsL8+6h3blDBOFqaK4efALwBUB+qCQBCMwOrR6GkW/XSx/KtjM5b?=
 =?us-ascii?Q?AFReG70q5v6pHvIdYtiNhYz3tXNVhNSQC5O1GOOvLdTfJhVgVwDlaW5Dy62X?=
 =?us-ascii?Q?k2xWdqpsUstNeI+j6wCDZu9RGQWPcjrFj9f5GSWCtbSWnnZ8IHEPwDeLUUyG?=
 =?us-ascii?Q?+5LjXvltyH+vCzYTixPegba6Vlp4ab+2MzvSH/xpN0ZMrWz9KSBtrYblA//C?=
 =?us-ascii?Q?Cu8opirCrVHAH1OX2ZWtS/VBdM86B6Vgrw0nLG/GqLzNLgRlp+Y8EpOxKeV6?=
 =?us-ascii?Q?xvJyL8fLLd+EiTdl0wLCencsYsfXJQVf//lioHmDsmcy0GnQRYzMLgiRcaSM?=
 =?us-ascii?Q?Kp86Dyv5/bxg8lip5BqPesp5xIYdStobjfWBEeflPoLvIch4DyVSjIzKQX6D?=
 =?us-ascii?Q?/N4OhnoMq+HryBAVDQDYqs3NBwrXgyIMe6cMFI5BysmEk4eBXG5CdmWEBo3S?=
 =?us-ascii?Q?QPzd8DBjJaWdrDGC9iSrZw/m21jiZ3LV99fTmn38rgx0KXUkP585mg14FCjn?=
 =?us-ascii?Q?67/kE1WYNqsCyXpBKCybot3fi/F30kcEhwW2Zsk1yOtCAh6jA/uBiXWwE9YF?=
 =?us-ascii?Q?HQDf+1eyoz79Msc0esWskseR2WJ2gq4uFYb0VaakwNvv3cSwRbZNIAWMknoy?=
 =?us-ascii?Q?tRNr4xngPK+bTAg6knHfB6mq/8AUkmj8WnB1vv0Gvt8rr7x7uFBVDXaDCY6Q?=
 =?us-ascii?Q?JDPXdtiBSYwW6oTBxufZLlWPpKgQ6sfk48r7itkwgf7k36rz6tF/vtQLAQEO?=
 =?us-ascii?Q?JBohPBTi/BxRolxke5NG79MEAYsvJQY2F7tFlOABhs1XE4KR2L/x1vQ/mxrs?=
 =?us-ascii?Q?ZgkmQAabcpHBzNiABziLW5jVrQuFaGJhsAzu+jbRbXhuGgXqEV4w5utFkuAf?=
 =?us-ascii?Q?k5a0qJJ3Nl8CnIV1GvkI5eRQ+JTP1qgNKZbqGQ9+R63oduSJYUD/cdYW1vGd?=
 =?us-ascii?Q?MWXHFyoXN04ct2yqVVH3sFXCEkORrnZ9yiGzA3FUw3bWsqUJUfjQxzsxFr30?=
 =?us-ascii?Q?k2Yzx9S9mRdcrW8iUOuVZnEB+h1LjNxw+bIuA/+0Ng=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(7416005)(366007)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?KlPwLS9e0SPWxkjMHgFPpzA4KX1LEwlLu9Afz6bm4nnOejuAyOge4kcmNaMB?=
 =?us-ascii?Q?H0mX2nwzXv8Fu7Pi4rJ2XX1eDsWvpC82PTOHgFWRj1ICzkWecLStp+VkPLpr?=
 =?us-ascii?Q?cp9XjWGYkmo5B4DLmuvuO1L+9woKGvjYA8LzJPAAvBBudkk1oP9bOvWX9PQs?=
 =?us-ascii?Q?k5vz6G15QMfWGr34yJCMkkdAOVxaglzu6HxGh82yFLIO/uxEBO4wNn3cVTbE?=
 =?us-ascii?Q?sF0oLXgYFPSMQG386YmGTIWl+ap3IAAzS5OuKYkEvgdlX97eDHXsmOgVcdAX?=
 =?us-ascii?Q?Hu+jd1mwVltm1fKSP3KsCdeXPYkovk2Y+SclpdHmFvZyuNTBTq8KvKgioVhR?=
 =?us-ascii?Q?NwUrJf2V4Uu24nExrPDgRM/4R4U5HrlFZdfLyHARJVhAGa9DQIdg5amkY8nG?=
 =?us-ascii?Q?iU/F2f0/469DAc7PqZSimExDIcOa49tIvAtQuSVaapcvMtTwCZivAvBOqO6m?=
 =?us-ascii?Q?6EDUKAHsuSRv42lnCthtHc10CAxReF3xgz0azuazkutQse1DioDlrogRk7iY?=
 =?us-ascii?Q?DMfjksmd7pd7HAy1B6dvwSAV9/MgY+V2qls/vNq+s0rWTI9KIuHmuy4vUwmG?=
 =?us-ascii?Q?FoL6lnxUbmXLXNlE3jz3jw1HkNyTFeGIgA344+yy9I3aNpxqH0v+TwrArrNz?=
 =?us-ascii?Q?CLQxeizY8Md8CrsHRn/IsHwm+hxm1QGD3HlNutSOWjeQNFRDTrUXNTOhe6Gh?=
 =?us-ascii?Q?+6ddlE5k47ztHFleQbi5OLsJBi84hvy365FPM5RWb9iysWSVkbWeNtq4JXNq?=
 =?us-ascii?Q?j6Ufnl8lqPMQi5YG+QCQ39fP2r7Z1/D2xXbJih4H+A5xsNWcub3WnGf0TMeN?=
 =?us-ascii?Q?BNlZIMxk72rcZuYghGEzyMc4w8647yTW4QaBPjXXeEd3BD0x8+g8F66QnSgE?=
 =?us-ascii?Q?7mWMcp/tjGaJcO1cKQ0THU/hyf/DS+Y8h+Bd26Wj5vknwJoz1cZmXQpI7pEm?=
 =?us-ascii?Q?RNM1cUtVzq9qEsV7VxmOnpwyRqI1F0efCMDXcgl8noVHQDOEPf7j/imRSSSB?=
 =?us-ascii?Q?vMVIQ+GsaEZ1Sps7xLTqNLmfa8Z0DBRUO9tWvB87QwERbOMCEyFpvQnc/pTX?=
 =?us-ascii?Q?eubTUzw4bWi+eSmq5pIP0OUi5+ORz9dz9XgZsh6lnV0wrNTbcx7n3LfE28ls?=
 =?us-ascii?Q?9Gy966uMvU5SGNMkR1SMclLgiSgyYD7hVQNLW5v/vH49F9YWYtmCEt40zDEC?=
 =?us-ascii?Q?jhpKENHLJT5YTXtl+UvxOC6jWiNATzRGWudftA5laRvhwBJx5O66ZY3REowx?=
 =?us-ascii?Q?seBoNHixcWfAXujvq7oEskMpsAVCjuhlnI3MW2ySSwoWHqwc2fDwQXGBVxWq?=
 =?us-ascii?Q?m0OjI2/XeZ+4B7a8a9pwknPkWe4nci0kp03JmXlrHTra6WXeDVbIw5tkOBh9?=
 =?us-ascii?Q?t0XErAbch3LiDrNg7DXiQ5UxUeGlxe4Fe2IdI91EFjXsixwId8Ji/dU5xXg3?=
 =?us-ascii?Q?mUFxBE/YBSG/4Hj5ExDjCwWdas75VHwdqLOs2QMUcHfE//n9gE2ot0/DeHMp?=
 =?us-ascii?Q?97RYC+lmU01RtyfTGST8ZUX76k8/+zBSW1dFJy9xGEtqCAyx/P2yjCnfkbP6?=
 =?us-ascii?Q?TW4JtYwpNnGr3CZpZfY=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f01da41-8fc3-4de6-78ce-08dc74281c97
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2024 15:11:20.8433
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 89glvbja7oZt9QXMa5AgdztnUpgcfDejN/HBIgcaadohBx46m76lWPC0Lqo+itOa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6962

On Mon, May 13, 2024 at 03:43:45PM +0800, Yan Zhao wrote:
> On Fri, May 10, 2024 at 10:29:28AM -0300, Jason Gunthorpe wrote:
> > On Fri, May 10, 2024 at 04:03:04PM +0800, Yan Zhao wrote:
> > > > > @@ -1358,10 +1377,17 @@ int iopt_area_fill_domain(struct iopt_area *area, struct iommu_domain *domain)
> > > > >  {
> > > > >  	unsigned long done_end_index;
> > > > >  	struct pfn_reader pfns;
> > > > > +	bool cache_flush_required;
> > > > >  	int rc;
> > > > >  
> > > > >  	lockdep_assert_held(&area->pages->mutex);
> > > > >  
> > > > > +	cache_flush_required = area->iopt->noncoherent_domain_cnt &&
> > > > > +			       !area->pages->cache_flush_required;
> > > > > +
> > > > > +	if (cache_flush_required)
> > > > > +		area->pages->cache_flush_required = true;
> > > > > +
> > > > >  	rc = pfn_reader_first(&pfns, area->pages, iopt_area_index(area),
> > > > >  			      iopt_area_last_index(area));
> > > > >  	if (rc)
> > > > > @@ -1369,6 +1395,9 @@ int iopt_area_fill_domain(struct iopt_area *area, struct iommu_domain *domain)
> > > > >  
> > > > >  	while (!pfn_reader_done(&pfns)) {
> > > > >  		done_end_index = pfns.batch_start_index;
> > > > > +		if (cache_flush_required)
> > > > > +			iopt_cache_flush_pfn_batch(&pfns.batch);
> > > > > +
> > > > 
> > > > This is a bit unfortunate, it means we are going to flush for every
> > > > domain, even though it is not required. I don't see any easy way out
> > > > of that :(
> > > Yes. Do you think it's possible to add an op get_cache_coherency_enforced
> > > to iommu_domain_ops?
> > 
> > Do we need that? The hwpt already keeps track of that? the enforced could be
> > copied into the area along side storage_domain
> > 
> > Then I guess you could avoid flushing in the case the page came from
> > the storage_domain...
> > 
> > You'd want the storage_domain to preferentially point to any
> > non-enforced domain.
> > 
> > Is it worth it? How slow is this stuff?
> Sorry, I might have misunderstood your intentions in my previous mail.
> In iopt_area_fill_domain(), flushing CPU caches is only performed when
> (1) noncoherent_domain_cnt is non-zero and
> (2) area->pages->cache_flush_required is false.
> area->pages->cache_flush_required is also set to true after the two are met, so
> that the next flush to the same "area->pages" in filling phase will be skipped.
> 
> In my last mail, I thought you wanted to flush for every domain even if
> area->pages->cache_flush_required is true, because I thought that you were
> worried about that checking area->pages->cache_flush_required might results in
> some pages, which ought be flushed, not being flushed.
> So, I was wondering if we could do the flush for every non-coherent domain by
> checking whether domain enforces cache coherency.
> 
> However, as you said, we can check hwpt instead if it's passed in
> iopt_area_fill_domain().
> 
> On the other side, after a second thought, looks it's still good to check
> area->pages->cache_flush_required?
> - "area" and "pages" are 1:1. In other words, there's no such a condition that
>   several "area"s are pointing to the same "pages".
>   Is this assumption right?

copy can create new areas that point to shared pages. That is why
there are two structs.

> - Once area->pages->cache_flush_required is set to true, it means all pages
>   indicated by "area->pages" has been mapped into a non-coherent
>   domain

Also not true, the multiple area's can take sub slices of the pages,
so two hwpts' can be mapping disjoint sets of pages, and thus have
disjoint cachability.

So it has to be calculated on closer to a page by page basis (really a
span by span basis) if flushing of that span is needed based on where
the pages came from. Only pages that came from a hwpt that is
non-coherent can skip the flushing.

Jason

