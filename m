Return-Path: <kvm+bounces-18576-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 62BA08D7133
	for <lists+kvm@lfdr.de>; Sat,  1 Jun 2024 18:48:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 47254282091
	for <lists+kvm@lfdr.de>; Sat,  1 Jun 2024 16:48:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 373FF153517;
	Sat,  1 Jun 2024 16:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Ugq2/YtQ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2046.outbound.protection.outlook.com [40.107.220.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E2D8152E05;
	Sat,  1 Jun 2024 16:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717260514; cv=fail; b=alqyAgafZysCV9mNIyleYRQ4MxgZdGgNB6ghBDoGnvar8tZqQiH8fWz3Z4M9ut31z9PzqO8PnbX7pAF7QbcADMlYfPwwZGlMJ38fDRAL4ZHR439lpydkVqMnpP1g+Ke+bADvgI7CwQzuqxFt3Wf2K1i2dsY69k16xfJyaHeAN4g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717260514; c=relaxed/simple;
	bh=8AbxMhhPBBrocvEj29GdIFM0rX3FQyLSvXUZVPdOopM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=nQgLYwuwil4HxPt+6pRZnU/BXjiHHMt5yXgVYD5atLZosx3B6M9uvycbKgimmsBrZ9cBh3mlOYkXXWH4DSNp3vPuO9ppGdmNF25B2dNb5ZkqallQAh2qmJaql2CNXtz38Q3uCnbi9J9onwHLXLchTzxnS87zQr436xo+hiwSMEo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Ugq2/YtQ; arc=fail smtp.client-ip=40.107.220.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FafvB9zCBlIjCpsZDVSzKugYy/7smm53Kj9YfBbsa0e5vftUuTOLD4P77h3HkEJ4/HS47J6o7AU6BrSVB29tmTxfPis9Ivu7brXdd9WTdkV52THPq6vdGZuZD1whskHj95LzD/AY6e0qCPBCnDVhnbK2ejM/2JzhhDf0o+u9NmjbtV9+VPIyCZhKJ8yKXkZEsmbkvDE5f6oV5CEV5r3VDs/882U9PlTk4PQzGJnLi9F7z88oMv6O4XrCVmQlDjn4lDE/kB+1JMdr9deKZP103PGTmtzAXuxZtZIdu27VgYXadOXIodl8ZmPlWNLlb6lJuK8niUQnvwdJ/d0gLT0bMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9Zr5paz6Qnf56E3KYeiebIXp4Ic0jrkiSHdKl/gh1Dk=;
 b=fhzUPn4sYFCap3aFK/+RKpJqOka/dvNGEgvCp4kEyy8Sv7QnIJ/9X0/b9FRh0CxSefkIhTrAPA2MzK97DNYBR//Yq6rFYtpK03ACvbgvhZbtVJin/C7GzpTXu8YZD1j+Xrg8CEmq6gN5NDyaYAgAoWA2IPXnhtQM6XWtKk814lz6MCkIEjwmlHozuH5BVDHdBuF5skAA0frOzeHPz4l0ZIhVMcrJjBSo2G00XirDRN5fRELjoG73I7+M+IvNjCaJp5xqwfRaDoUXPIPoj4vK26jL1gJSBDRk34P/5aF2Ktkpyf0OH4WCNyrfqR/VxVZTMAxthJbVnVgr3Ezi2/4Shg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9Zr5paz6Qnf56E3KYeiebIXp4Ic0jrkiSHdKl/gh1Dk=;
 b=Ugq2/YtQ1QjGiAVDX3yyL5Ar7uM/WLlD9KVKnz/gnqQbhb4HLvZJ8y6IwO4Hc5vpSEOSSoc+tbxe7ZP+aPiXTjx844fzzqePAoBWaCBqNnuA8wm2GCexmfDNeQfGqGC5KYZjP7ySm7uPNLHpy2tM0ClFKVI1/WiiX5EKUytbavH6SZ5CV9mesdI4Xb/WE6kF8vYFcRZ96huL6qia8PVcNHRdn9l7w3M33X8li9fck5BuBoiQ0ERN2AMJDuQ2U+LkTHzprzE20341cwwa8YRAIYdjTpo6QYKL1d1LEfNEoeycZ4Yi4KUUxm9wPUfdUOvFbCqnUiTTEdE7vszzo6x8Rw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by CH3PR12MB7644.namprd12.prod.outlook.com (2603:10b6:610:14f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.30; Sat, 1 Jun
 2024 16:48:29 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%4]) with mapi id 15.20.7633.021; Sat, 1 Jun 2024
 16:48:29 +0000
Date: Sat, 1 Jun 2024 13:48:28 -0300
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
Message-ID: <ZltQ3PyHKiQmN9SU@nvidia.com>
References: <ZkRe/HeAIgscsYZw@yzhao56-desk.sh.intel.com>
 <ZkUeWAjHuvIhLcFH@nvidia.com>
 <ZkVwS8n7ARzKAbyW@yzhao56-desk.sh.intel.com>
 <20240517170418.GA20229@nvidia.com>
 <Zkq5ZL+saJbEkfBQ@yzhao56-desk.sh.intel.com>
 <20240521160442.GI20229@nvidia.com>
 <Zk1jrI8bOR5vYKlc@yzhao56-desk.sh.intel.com>
 <Zk2Qv4pnSKZBsLYv@yzhao56-desk.sh.intel.com>
 <20240522170150.GE20229@nvidia.com>
 <ZlQzGzU1/CLY0eOg@yzhao56-desk.sh.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZlQzGzU1/CLY0eOg@yzhao56-desk.sh.intel.com>
X-ClientProxiedBy: BN9PR03CA0189.namprd03.prod.outlook.com
 (2603:10b6:408:f9::14) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|CH3PR12MB7644:EE_
X-MS-Office365-Filtering-Correlation-Id: dd21882a-90a8-4308-6827-08dc825aaa5c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|7416005|366007|376005|1800799015;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?tbVKXrkzUgePHP1A5yr+VafsgjoV1I2cZW1y56Qi895PC3Vwp/PeLTRGqeUa?=
 =?us-ascii?Q?+OajErhEty9b/SnO60ZvxkFQFosnsjKSy6KYQwtz0zzmT3rdL6KbnZlep+cg?=
 =?us-ascii?Q?YFnRfUEs+FkZe96Aozu4g8Bx8+LrO0CcF35g98jMma7YeXRGY7kQvp0XtVtw?=
 =?us-ascii?Q?N/5onP0nHKAmkb77thmKn9jVHKAv63ExD2JN1QRh+iBgvf78xgux02zN12YS?=
 =?us-ascii?Q?tpN+QkK3BnY4d+9Vek3ZbaDaFPG5J34LUuYX/icSp1a271AfLS0GltwhfFmp?=
 =?us-ascii?Q?2b6PE2PC4HKUXUzybvWdZMnCju3syW3wWChrmfEY9lJtSuOhEdnVU//ONU73?=
 =?us-ascii?Q?6gUA9OEv6KD4Eci0qX61NfF+gNLHC19ZSUmM6oQ/Jh+RM57vyZ4+96AueMgn?=
 =?us-ascii?Q?m5RbMwFSuOe852XjA07PHySGeVUCJNJ5F7NDUt357Tkhg7cFfzkhxDS11PpQ?=
 =?us-ascii?Q?TZlULUqMSW8ryu+ArtSgWWVe7Zq069bX8Vzs7lXSQSHcbfUavgzI2q9jFNVu?=
 =?us-ascii?Q?nkt2PtYntSqr3aFQbOJUuoIKZDVmeRgKJy3ywdwvwCIc8R/uqg2BCkzMlPtI?=
 =?us-ascii?Q?c1RnHavgCaakCbGxJLXnXi3mH6NGXex/leBAjc+rTALZq4L0+DyhPsGGCKW8?=
 =?us-ascii?Q?Geo7JJBb5TxBScR9ej3QP0Z3ig9mY+j0oGRXGxl3JssaG0p4n3zR5eXSaC1R?=
 =?us-ascii?Q?g9rroP8sUWitdfHdb3OZOfzyCOVdYUAd2H/XGIZElyw9Vj+IL8vtt97VHmWi?=
 =?us-ascii?Q?uqaoC7M/CXpFWRcAk3rT7iI3DMiguf0lNfDLhkI1gHQHiy8G9OGz1WU+KtZj?=
 =?us-ascii?Q?dd7nNjfLrVxVsfAD80jd8gMSpYSA1MRoizn2rM8G9UW+oyMQL6UKK6DHE7CC?=
 =?us-ascii?Q?JkEjrwEzoLzNFVReSfuQLiGSvS6KdqYlSRMFX24Cm2uKS1n3M0kcLq88yBNh?=
 =?us-ascii?Q?wsdUOxhUxigsXz/cKR5cAzQfx/sEW/uMB1+CxpfC9OR0JXfdN7fRpj8+RZzP?=
 =?us-ascii?Q?i+uoFZ5dZgr4zz7npxSP+4oinzrdGtGU8KdzXJiOlZa/98eqKpI6x6rYXENQ?=
 =?us-ascii?Q?K7YcTIQaoqERZwXz6BObEjLnL5RM6JElvZNgysmkixLkCVmP8K0+K4TOsmNL?=
 =?us-ascii?Q?C1H9HFZZq4Vwsz0W3iqqpHIJ9Qrh/TL9QNJxbEKtfXiio4jrY/bIjN16YcmE?=
 =?us-ascii?Q?ombA89EtBlvgd2ehAigz+CGr4gDrJ5ZYzGu/Wz0ryL7hizdH8JzRJxumhcGu?=
 =?us-ascii?Q?YdjBo1Bvb7bQMgRhy6wfcHB6MDiTxS9uJVXeMWL19w=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(366007)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?hu7Ka6iGyv5zMPGBrR4H05LouMdVpZYxahABYhHLr9nYR+nfuGeE1HxOOS53?=
 =?us-ascii?Q?/3qTikQGctDoAjEvE5bZCW1oRxtqMILP+crn2H76Vt0Pq8o/6ajQnHKsnqMf?=
 =?us-ascii?Q?/Ma9+j/DZlwZM/uzKwrPjZ8jNNqOQJnH4cyLQJQflGUa9pxG3kYai/D2xlEi?=
 =?us-ascii?Q?CtSW0fzazacmj0Kjk6pZI4EzkCh7fJ30Jsa2fF39cV84tLXiUdTQ/JYmEedj?=
 =?us-ascii?Q?WVJyfgWlAJHW30IAoMylXReP29WCtyD2pNz4NGXFGYVs8hmmG7mtwqvwZ+CP?=
 =?us-ascii?Q?O3Gjjrs1AbbPjtXfqQ9gPD22Sfwr1UfCWf9iqvRZPeguG6a1lHfwYZxR6l46?=
 =?us-ascii?Q?eW05c/QTojg4Lld2PQp5JgxWFWizVfOFRfiknN2Oa2i8RTpuYzbiuFJY98Op?=
 =?us-ascii?Q?KHt/sl8dThe5ddY5tg7lg3JdfFL7x8+D0KexsjPsE8ctko2e4fheNel6UsSI?=
 =?us-ascii?Q?lGY2xBK0Ogp50kH9+TaFVTGa1WvNdEmEn7ILTvFityPUPKofIYhJn1Lr1Mf/?=
 =?us-ascii?Q?up5JB8uW1vKeLq9Li3+tg1KvO+NWWikBb+qRYQ/6qyCNZ59blxq9CsyaXeoy?=
 =?us-ascii?Q?3QYEbar06O2SBXN1H1TzNEZjrhcHr2A/YaB/ICIGsV3vHTDqOnyFhEEvIRBq?=
 =?us-ascii?Q?IJIEuVSVfv10K11/L6d1vHQ9QjWVZ/zKqF0YlA022lhjxiNsgLdq3tOE/2Ob?=
 =?us-ascii?Q?Zq1T8P1s+QGRmkxrefDB0b7IUCYUNe9rWrDmdg7ZZH1oqQilBaxHUVQpFxre?=
 =?us-ascii?Q?Lcs/FcJKodXYuidt/4avzhND62XwQXNa6HAWUqIRXakGVwZtfMegT2ap/Ie8?=
 =?us-ascii?Q?gqwxEMH+Wneb3T6xjgZDIT7FNqtAr/PwpZPiv6V2Dll1R4yFyoG/P69d9KK0?=
 =?us-ascii?Q?5rZa9WMT90D3BGjS37nBoe2cF52Qp20iBqZ1DEyatvjuSa1jE4afzpsiPdHZ?=
 =?us-ascii?Q?FXMuyr09nsXrQIqZ+Qe/hZMR0VxEnF17b95dJp22Zo/2wV8vZt4pUfo6V6d/?=
 =?us-ascii?Q?ryn2wha7gxM/796BMoW1hCOOyqIQwStr9DmLz0Ipacbpbz4Is1lWx3CUDEnN?=
 =?us-ascii?Q?fvZnP/5Ws/kQnbUMethdrJaMQXba/CjuYtzS0St3d7AnJO/YgsWk1QJbRTU+?=
 =?us-ascii?Q?wVbrM2L+mTkt3//xunCFtrIyKZabTRwZ4eYnY3k66Adji93rzP55uHrethAM?=
 =?us-ascii?Q?g0AKAAS6CbOxxfUvNIRtQZ9HZMRUJDkY2GLtscv9CS9JTNJRnUoKUtyAbaib?=
 =?us-ascii?Q?/eWayiYGhv/NRRlulJM+3yWGT5HGP7g3I6IO6ou8fl6PVlhKOZ5db70dTulj?=
 =?us-ascii?Q?5I4n093Hj6oFIhKIexQcdvT1Cq/NVSowAglaS2hSGIp2QJs5qVvS6nDtQWuw?=
 =?us-ascii?Q?skXeJllUOsyqMY3H/dGqyGpLqz6VHkwbeyZBEtDrIgS9W59qutk3aOI4SZCO?=
 =?us-ascii?Q?fbRNPwPv5LlRfWRb+MJYn7ghyBUp6/MsQIN2H7YD6uKtIHbVo9LWhv8FkRcJ?=
 =?us-ascii?Q?HQi+HcOeodSyeaGYREUu/ORXvWi8wMW6r0B83fKrp3zy9fHnQTf4L8cyMFC6?=
 =?us-ascii?Q?/5Uc8boZEQOFEbPHZKJqFNbsWE+CuJiMQRtjJDwZ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd21882a-90a8-4308-6827-08dc825aaa5c
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2024 16:48:29.7914
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oRPlreXWCyRoUqKtSwK4vYnuHcUmU431cuH8oE2iXuZXtNony8dJBmAu7wJpls1u
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7644

On Mon, May 27, 2024 at 03:15:39PM +0800, Yan Zhao wrote:
> On Wed, May 22, 2024 at 02:01:50PM -0300, Jason Gunthorpe wrote:
> > On Wed, May 22, 2024 at 02:29:19PM +0800, Yan Zhao wrote:
> > > > > If you want to minimize flushes then you can't store flush
> > > > > minimization information in the pages because it isn't global to the
> > > > > pages and will not be accurate enough.
> > > > > 
> > > > > > > If pfn_reader_fill_span() does batch_from_domain() and
> > > > > > > the source domain's storage_domain is non-coherent then you can skip
> > > > > > > the flush. This is not pedantically perfect in skipping all flushes, but
> > > > > > > in practice it is probably good enough.
> > > > > 
> > > > > > We don't know whether the source storage_domain is non-coherent since
> > > > > > area->storage_domain is of "struct iommu_domain".
> > > > >  
> > > > > > Do you want to add a flag in "area", e.g. area->storage_domain_is_noncoherent,
> > > > > > and set this flag along side setting storage_domain?
> > > > > 
> > > > > Sure, that could work.
> > > > When the storage_domain is set in iopt_area_fill_domains(),
> > > >     "area->storage_domain = xa_load(&area->iopt->domains, 0);"
> > > > is there a convenient way to know the storage_domain is non-coherent?
> > > Also asking for when storage_domain is switching to an arbitrary remaining domain
> > > in iopt_unfill_domain().
> > > 
> > > And in iopt_area_unfill_domains(), after iopt_area_unmap_domain_range()
> > > of a non-coherent domain which is not the storage domain, how can we know that
> > > the domain is non-coherent?
> > 
> > Yes, it would have to keep track of hwpts in more case unfortunately
> > :(
> Current iopt keeps an xarray of domains. Could I modify the xarray to store
> hwpt instead? 

Probably yes

Jason

