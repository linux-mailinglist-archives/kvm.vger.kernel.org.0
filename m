Return-Path: <kvm+bounces-51484-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E43D0AF7418
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 14:29:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 79D9C16452C
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 12:28:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48D832E54BF;
	Thu,  3 Jul 2025 12:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="nc/sOBye"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2072.outbound.protection.outlook.com [40.107.220.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E88E72E0400;
	Thu,  3 Jul 2025 12:28:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751545682; cv=fail; b=pwTEc8+8yY1BkpjYqH5GJDfHKQtoznf2ybCk+TTEAzyko+9JUo22b1qftmAlfTMMBWk/G0TVZZt7NBeDKsC9KdsQ2O9kHawiSu7ppd+VW8x2L4KCNCy2cGYdnu/2M4/gwth8vnmwSdoqW8vJi+HfBIPSSOPOwGYAkFammAYPKRU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751545682; c=relaxed/simple;
	bh=hyvrOnyQT4mzZ7N1YyCli+0im9XkN3dw1r55aCyZ19s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=r1b85CUAzKFXiD6f4yjdewikebfFj+gtNreiX6mi1zimeO4Qp0unFl4DKuM5Yu9Lmcsvhvl8tWbTwsYTUptnO8RhqGKrlQHtZMDSiPUzCsVWgUQNLZ7cF2SjWhFbsNCkV9cE7FLaFMD6Tc7es+QcxpLS4G/YbWtc+OCodnyr2nA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=nc/sOBye; arc=fail smtp.client-ip=40.107.220.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oy1eWd3Lx/whCn59PG/fpVW7Q1s04znZplStsfay8iBdwhHpvVn84/cHOl3Mo+HfuZB99mGn92CyhqcArP/2w5kAuN/HafKEC+SO+FQPggjUE1K6rNMeXRJtehuWqY1zacDYTCW7luLnEmwv5jh30qJzcpq8NXm37V+vCTItCWhEWbbPmSdeXYxeLT1Vih3pSXAo0tsRFllUjxRq+xPROEpRNv/rqQyMYDpp1GoJ5FRaNrHTO0SSwhM8GDFKu34jPsJgKMkwd5CHYxHGdhPEAP7hjlF+FFACdqdVszha9qUPH4HWIlD4h4M0+COL4Aw7T+q7GH/U0Lk+9mVTsClKHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SBekq9YqvmSPK2tYh67su7BwKvhl1iR1+bq9Ib5x2dU=;
 b=KGYEk8Ep8pTntIZhurL2lyTJkNEQItcFvkhVnJhEhFWTO7MkQSNCJFySnqQoqyYhzmWy+hAbDi9D/ndU4Pz1qvCg7MBwh1JVAsVTRchb4yM3+m7CFHHRoLKPPTE0IOd9aTb3f6Eia0gePgq6fgt20TzMGJfvF0EGpVv6CgsUkngfBm/yp68Ngah3zwKFIetzoNZUqsFiLDBD39KUiRp9VqkHG/wMcaDGj3uWMufCWDvGHRnZKzFzZUFHz+bXjKMa07dG7MIWRztEicwi3mFCi9xXj1hviYhP2F/OuVHNNu3orTKiE5+iji1ru9BQgpoVhLX5KWAqwXFWglVkiSArlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SBekq9YqvmSPK2tYh67su7BwKvhl1iR1+bq9Ib5x2dU=;
 b=nc/sOByeoyvHunWdI7MsmIH8I1VcZq+4dRNcrCG4TWwnxb9Pb4dHdRnJeuJdvTFmUccm0deUPxc2pdaPZ5n5JF/ynISWO7RxKdo1A3YbqoGhaKewF4SbJi8A51c96+iFqgnhmyUMIIe3JevhLeq6kFPp/hK7LJ3Jk779Vqrryhdr/yjb+QkIXZ/IIR2y3oCyyuMHnDsucSP/XFEI/Lt9bXPCc4zEOv4EzGuVx6cAwgEd8Bbz39Qio/SXZgptLiCI/JnG2QP7uuC2AE8oaHlej2QUlZsoMR7VcZ4Y+8ony9N+3WL03PJZjKwMIIh4DGHE6i5LohwDpQ0yS7p48DHspg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by DM4PR12MB6326.namprd12.prod.outlook.com (2603:10b6:8:a3::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.30; Thu, 3 Jul
 2025 12:27:58 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8880.030; Thu, 3 Jul 2025
 12:27:58 +0000
Date: Thu, 3 Jul 2025 09:27:56 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: lizhe.67@bytedance.com
Cc: alex.williamson@redhat.com, david@redhat.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, peterx@redhat.com
Subject: Re: [PATCH 2/4] vfio/type1: batch vfio_find_vpfn() in function
 vfio_unpin_pages_remote()
Message-ID: <20250703122756.GB1209783@nvidia.com>
References: <20250702182759.GD904431@ziepe.ca>
 <20250703041822.37063-1-lizhe.67@bytedance.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250703041822.37063-1-lizhe.67@bytedance.com>
X-ClientProxiedBy: BLAPR03CA0056.namprd03.prod.outlook.com
 (2603:10b6:208:32d::31) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|DM4PR12MB6326:EE_
X-MS-Office365-Filtering-Correlation-Id: 2cf5481b-3639-49fa-e944-08ddba2d0b22
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?CNLuBQoOv8OpDA+3RKsw2d65YmhJrHcXNfiiGgYObI34BsOVygjxZZvscpg1?=
 =?us-ascii?Q?PUWA6OwoiKATEGc3F2pPCCjNtonV2gl5JLO2EmBr7DawTrCr0RGZsmBj7VQm?=
 =?us-ascii?Q?A8r4YwWARai6UfVJ5MCiZNj6jl+7nf0tcwo9/F3lyzRgK6hzyFvGuQeUxaMQ?=
 =?us-ascii?Q?iSGAtFh6XfL8TUB5HfSROANShWdIGyy1GX0Ya7w+7cUfQO1j2q2y4iR/NZAU?=
 =?us-ascii?Q?HxLWy5c8gtBp/zdPn237ZiGRyTRCxdHMQnhlyEDPLxKKKEbD6ReCVqPgAtiq?=
 =?us-ascii?Q?QQN12DXSDXKL8/83ptkYwOL2vx7wAYeicLe6IYc/s+cMeCgYDe0rtv/ENWIj?=
 =?us-ascii?Q?obw5XxLhHpqFjsZ+X8te17AwwVPrn6LoIXwXh0Mb0GghcnD6D0KaQLq2rV2+?=
 =?us-ascii?Q?mbUzFv1fwgBAAq2i8J5xmMTLJai/WMX1bQzvvWpYNEA52TIYsXOTyDP9wVDS?=
 =?us-ascii?Q?Yuei42zo6I3c5B0bHdEqIh29NOq8CPD6y80Qgs2ZoNpCx9TpMcpaSVdpuVHP?=
 =?us-ascii?Q?R4Hv4UhT8LQ15azwtshIWWTbMqxG1uWoHDIdyntQgjjYLH+AryNv7lRQa2w8?=
 =?us-ascii?Q?QUV+wxwxEfHv0HKevNhDGBV9oRWj0j8/dsItfYNpUwX0GLHRZsgVIE+sTwwQ?=
 =?us-ascii?Q?H7fcn6o2wBpVwn3300zz40YtRFT1IDedawJ98zFtKRAldZefNR9HbL8sJJK1?=
 =?us-ascii?Q?Ru1TB2hTFBQ1EvfHw8a9t3Ig/on6vsP0LAc6brk4XthERf4Lxp8VldBE8Xqq?=
 =?us-ascii?Q?d4lRUkNSFP1VvF2cw23cjjTNsKF1ALkK34WeFJ4Q9z7E4CXi0q5XM0krj6Vc?=
 =?us-ascii?Q?o74X7TnVMjy9syAntvk+71rR+v1nc58U84Ibdwg/p9/cZBrwZ/Ntxn0gQDtI?=
 =?us-ascii?Q?cTsNq7LLC1L+zx0dYHmVRDjtqcX/zRde0s2ocyiCMTGCP77Bj+e+b6YFllSm?=
 =?us-ascii?Q?sDBWBaFTev8DsecGSMckfruUytMMjWnYk/8q1SNqd//DxhDVRe0MGMVLoX5j?=
 =?us-ascii?Q?j49W4yuBDkZONmDJtvaiwWy6v7pyB1K+jIuOvGgyHEx7QNpT2DsMsC9s7LxC?=
 =?us-ascii?Q?o3efyBWNa45QVwj9EhMPfGLAm0JH0ofYTfowadFZn/Ve0XAJW0ZCDjBiglOF?=
 =?us-ascii?Q?LZ8xAszAQnLXNkwytHqF+EkOJYTiJY2WrMqNY5lHiENZNXClkuecMecfZbKl?=
 =?us-ascii?Q?4B0PzMLoNtuDucFdf/7wnoHAK2pZ63INpziPzySHg1Swt/fXSRI98Px8vhGl?=
 =?us-ascii?Q?U88SgiCtS6G4Ku8hTHZvogL8dhPQ9My1jbGK4m0WTQRF3QIJAO1oMluBMMMz?=
 =?us-ascii?Q?YdVEUMUJyOV2rS6hqC1bpOgEWEdlqi2AMHdGf7wyTj7Azk112+FOUDaCrllB?=
 =?us-ascii?Q?8sV2HwvJGzHmAYaqnmPOZ9FlQVLmUpzuA/S13n2BIQy4b55Li848oEUoov0Y?=
 =?us-ascii?Q?I9jqtbp7GQY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?GgN4ReYn0L5SLtexS+6lBlLIAO89dN87xFp/1OkE211FFelZiJ2wfGBF5Hq4?=
 =?us-ascii?Q?PZyXlUCoRy7SwIquGKJHKUN2y7ejJ6xQ6C0dEe0JkpIgioZox0/OMbow/vzJ?=
 =?us-ascii?Q?58BycHOuYDOjsqHvmTytMBztXJhfqHqP3FZscydL9eP1BK93O7msc9fWUee4?=
 =?us-ascii?Q?0IyLi3V5AS+lfkgYHPu+CORHO8OwMfQEG14ucsMqtpHX7wukIvgzMEQ2YPut?=
 =?us-ascii?Q?jOa7SeUzkRBUkJG4cWSAiAnypa84YGWdE4lgAnUPYnrbhAgVSHwYG4B0kYxy?=
 =?us-ascii?Q?RJhpTQt2DeUX3LZhOGZRClMougjT7h3FzWFmPuTAeqyXOoVmoug7YcmZF6o2?=
 =?us-ascii?Q?ODirKzsPkwIcEwhfBFX3v2NhM1WKkvnkrvAWpPqnky9ZWZtQF5nkgbNhe00q?=
 =?us-ascii?Q?Zjk1SYDGn+932FqLoLNKBiZADw5oBns61ozE0EecVUXQZNiKupkjeLLSRVRK?=
 =?us-ascii?Q?ZSrg/YvfeCj8gNiS/IDBhR1WfxgxYCTNvF+oGVkud5D2wxMGEzNwWytU3sB9?=
 =?us-ascii?Q?sEe3Zl244N7PRMsX638STff/ykRI1MsJQ188SS4FdaIMW8iy0QTF/HvgrwR0?=
 =?us-ascii?Q?AwtZHvgC2b81hzuexLj/HxwTAxi02ShKf4+cjULVvCOKrI0AQKcdN2uMm3Ib?=
 =?us-ascii?Q?ej9B7QJqZuozCjCCUzlywUpCIWrSPaglahYiE87fooRExotqCeKCJfy/2cVD?=
 =?us-ascii?Q?0b42/z8Q+8Wiu1VVDyKHkoZpG1Q3O6zzmG12eYL10/9ucJ2OrlaC5KSc9PfL?=
 =?us-ascii?Q?qyFyl891g8sbTe0i+YrtKklQQcF5LGbylnK9R3FN4Q1F42/jreV03ZbsH5qt?=
 =?us-ascii?Q?FjYOGHA4okyxBdEuB+n5smgmulojLMOmuh9X9Ky5F1BThOGDDrmChXT7kdxt?=
 =?us-ascii?Q?aOfu8kr6ra4phsK0HXKC10CVBMLxuWHd3X3G2XW1pPdeY4/xVOwZcx86Kgsm?=
 =?us-ascii?Q?B3WE1bZC2MBUCCN5oLf30wdLLvGqTTx1sYzoPY/v+GvoQdSI2e6/wzEVssQ5?=
 =?us-ascii?Q?hK8GBfSzmB5MQL3Zpu3Lgy3ccce0FNkQp+0eUTnV0e0C4+T0J9VTgK3G17oO?=
 =?us-ascii?Q?YL3cueqyX7g2xFGk9+G9599/h/8p22JP3eVCS4le6ZLyP/l1qN3o6iKGflDP?=
 =?us-ascii?Q?AHk0XWb9610fOvg6BbkDWRl73pn8uwxmtiXShZTAABetF/wPNikmSvKpP1G4?=
 =?us-ascii?Q?WbsxUCUDp5twvbxN1gOBhTIzvaynKhZVWZrLcDRyaZSU/0KTCKh+r3Wem4tM?=
 =?us-ascii?Q?nA4O3Me5ay7fwqBdFS7DhBDnEgdqOy1asQ+qg85ZSkzYGTf4quNRe9aCl0en?=
 =?us-ascii?Q?wMIoyzlNmEzHFftEsOAmDKwFpxP565bFW3FW3TGrjjVpAbat34vmSW9kVYY3?=
 =?us-ascii?Q?/H7gBGjA31BLDU+bDjuKuZo/IASHsDJecIRKk1GEzRrBDlNN5YK9hZ0psSK4?=
 =?us-ascii?Q?wS3Xrxy/wUAELRxKp1yJDBUQkbc7uTWO8HKJuTVsPeY0mqXVOqdf+vbEfgmt?=
 =?us-ascii?Q?NSnCt/fpOb/7n6Bgq49O83Xywfbv9LzJi83x7otWkqQkQ32TswFKcRtBfXpY?=
 =?us-ascii?Q?JeWjlDPtjCS0jNr0HEbIvbPNidGVHC+zilMrpy6V?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2cf5481b-3639-49fa-e944-08ddba2d0b22
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2025 12:27:58.4343
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v+BptVZ/WCUUWa5UIrIbGMy6hJ4gdyWAe1UB/eED6e6a6rpDNrCR7tv537IF/fsM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6326

On Thu, Jul 03, 2025 at 12:18:22PM +0800, lizhe.67@bytedance.com wrote:
> On Wed, 2 Jul 2025 15:27:59 -0300, jgg@ziepe.ca wrote:
> 
> > On Mon, Jun 30, 2025 at 03:25:16PM +0800, lizhe.67@bytedance.com wrote:
> > > From: Li Zhe <lizhe.67@bytedance.com>
> > > 
> > > The function vpfn_pages() can help us determine the number of vpfn
> > > nodes on the vpfn rb tree within a specified range. This allows us
> > > to avoid searching for each vpfn individually in the function
> > > vfio_unpin_pages_remote(). This patch batches the vfio_find_vpfn()
> > > calls in function vfio_unpin_pages_remote().
> > > 
> > > Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
> > > ---
> > >  drivers/vfio/vfio_iommu_type1.c | 10 +++-------
> > >  1 file changed, 3 insertions(+), 7 deletions(-)
> > > 
> > > diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> > > index a2d7abd4f2c2..330fff4fe96d 100644
> > > --- a/drivers/vfio/vfio_iommu_type1.c
> > > +++ b/drivers/vfio/vfio_iommu_type1.c
> > > @@ -804,16 +804,12 @@ static long vfio_unpin_pages_remote(struct vfio_dma *dma, dma_addr_t iova,
> > >  				    unsigned long pfn, unsigned long npage,
> > >  				    bool do_accounting)
> > >  {
> > > -	long unlocked = 0, locked = 0;
> > > +	long unlocked = 0, locked = vpfn_pages(dma, iova, npage);
> > >  	long i;
> > 
> > The logic in vpfn_pages?() doesn't seem quite right? Don't we want  to
> > count the number of pages within the range that fall within the rb
> > tree?
> > 
> > vpfn_pages() looks like it is only counting the number of RB tree
> > nodes within the range?
> 
> As I understand it, a vfio_pfn corresponds to a single page, am I right?

It does look that way, it is not what I was expecting iommufd holds
ranges for this job..

So this is OK then

Jason

