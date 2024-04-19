Return-Path: <kvm+bounces-15295-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 98EB88AAFFA
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 16:01:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2655D1F23BCF
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 14:01:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61B2012D210;
	Fri, 19 Apr 2024 14:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="VtgDlRPC"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2078.outbound.protection.outlook.com [40.107.223.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E43C312CDBF
	for <kvm@vger.kernel.org>; Fri, 19 Apr 2024 14:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713535260; cv=fail; b=ethakAI4zaNwFqy0i9EJToWAibF/bWSrd6WzGVgWTdx/ive9CU95mP+VtgGa0fST7pWI6QJW64hPbhAmOGCQnpZ2x/jNqL5SC+nhDASONl3QNzOfIxtsmJo92xwhTu/m8blM77H9KywBAEfp2SIttjrlxNPsTzvJgltMDeUBmRM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713535260; c=relaxed/simple;
	bh=xpoYJpW0Xy51Cq+v0ClmjiM/e8tEVwCKCae+yTQYlkk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=g4uleARvVtsym5Tr5Zo/tj1g3w9/AAthF1+yBO9HXa4KBNo62oecGylpp/6eHa2ZWRl36CV5BvQfcm+gCfS+G+A+EfqJUkiLZQieU3X1Bat0A6FD1V1qeF6k5qVQvgmEzBFa0E8zZJOLIQSAW6TCDryN+dNZ7lF+siSbpWRolP8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=VtgDlRPC; arc=fail smtp.client-ip=40.107.223.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PowyLBdM42AOVryxIOdfb/aFKb8+IU76+YKrw2b7Uku1NWLHNtKv8OyPs+rJJOkL9UCadvkGgUTeW0+LK5JdqjbIJXvcdIpqJgc5qQKxDEfWCjxb7UkiGYdb+RdnPadtMIJebCj6/hiVa2WP7iRL8c6oC7CFLhn7gJ63EtZkEFODtvzmwBju2FY+WfJNL7vX6C9Rnb0B0dXjwQmkLZl1x6mflYef0+K8XojPKtATzSmonaizhidFmTaSAi4ALTHabrBsD6BFzLKcPDxihqiWZw/7leXmSNUZarcl5x/rQjUnZfktm0UU+/9tcLRbhjGotieOJPARm8UlofnEj/iBLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R/d0cd0GrIXVnx4O2Opr186LgRqlLbbpXnE4mVDkk/g=;
 b=l8MKQOGXiNK8xl4ZvbMOOVUfKfNTZtCGpbuJ7ehfmq6Q+GuZcgEM7B/FUIgqFihhUda4+2F+AwRY52d91P6BDIgl3GL6GD3gX/oukA3dZJlPoQZgObnCRitH8HXfywszdB/E7x6nSmuYmkYnmjdYkh/1snBWeQHp4r6+LE+BSN7RGgx8fq1mOiD9eZZS0wE59l5lUE8VNzbSxcwm6RzztazTkiSFIuSPt6TFHMWB3ZbPNugVp9BEXlHbUC/hmsTZEny6ksMXzqRGtOnbrI0AtG8gQqGfgD3WTpLmnKg5nSsm5zTKQ5esJ+eEexxO7m+xxcv3vWX1IOQYsGA+fm331w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R/d0cd0GrIXVnx4O2Opr186LgRqlLbbpXnE4mVDkk/g=;
 b=VtgDlRPCxkJJrYnOfEJ9ibrB/41Rm33xwTaaZ7/7okLpC3w3taiF8sAKJvdgwYR/xK/nwhGe8tOZkE5hByQE58HBBlhJCYwvT1huy2smZf8dOLlqiaHdrj8IQqUkwXGHQtqdrFFtvUrgz9KyG2KeGESNkKeBE2X71EbWQTrA5MsiR/mTLjOticDI14TG8LIYOvOtuePG4dm60tAfp50Be1iGSpKAxzCHjrXgKOH2KehdvAyCzqhuUB7mQoWssBxPk4pvfG19qQozGgsTklrfzWDjUK8V7yu8NQMQHArQ9SvgX8AFXI1zOih5ncRVJKiKfwuvKG7ZHx9uiEzWa+Rv8A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by DS0PR12MB7825.namprd12.prod.outlook.com (2603:10b6:8:14d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.41; Fri, 19 Apr
 2024 14:00:49 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222%5]) with mapi id 15.20.7472.044; Fri, 19 Apr 2024
 14:00:49 +0000
Date: Fri, 19 Apr 2024 11:00:47 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Yi Liu <yi.l.liu@intel.com>, kevin.tian@intel.com, joro@8bytes.org,
	robin.murphy@arm.com, eric.auger@redhat.com, nicolinc@nvidia.com,
	kvm@vger.kernel.org, chao.p.peng@linux.intel.com,
	iommu@lists.linux.dev, baolu.lu@linux.intel.com,
	zhenzhong.duan@intel.com, jacob.jun.pan@intel.com,
	Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v2 1/4] ida: Add ida_get_lowest()
Message-ID: <20240419140047.GF3050601@nvidia.com>
References: <20240412082121.33382-1-yi.l.liu@intel.com>
 <20240412082121.33382-2-yi.l.liu@intel.com>
 <20240416100329.35cede17.alex.williamson@redhat.com>
 <e3531550-8644-4a7e-94bd-75bdb52182be@intel.com>
 <20240418102314.6a3d344a.alex.williamson@redhat.com>
 <20240418171208.GC3050601@nvidia.com>
 <d4674745-1978-43b2-9206-3bf05c6cd75a@intel.com>
 <20240419075504.47dc3d75.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240419075504.47dc3d75.alex.williamson@redhat.com>
X-ClientProxiedBy: SA9PR13CA0011.namprd13.prod.outlook.com
 (2603:10b6:806:21::16) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|DS0PR12MB7825:EE_
X-MS-Office365-Filtering-Correlation-Id: 5c1a9156-318c-4d0c-e4dd-08dc60791de9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	dbZD9NqunNHOGxw2numshqAnSI707x/FfousSdHYJCd12bJ6zibMOZJ8cB2tPMBOhzT9/C+Y//yNb0DzBWoXIemick0Fs7DwOHmUyghr1uq0qsQ2tR7QTuqTt2mxDtyBwVbymGGr0RANb3aYzhQispIFQsXZa4CxrPabvp+a+2awOStBBILxm8ngrafJ5OEJXj4cZqcIbywKEHimLcf8gc3aKIj0vWuC4HDH5uDOVwssDE1ahC41k/mAckKB/cSlkmq8qCi+Ncwbg+EwRIm8jnaQWeXqgcSWUvOR4mlGmAMG4kgNUvYcnikACCvp/JnKmixr80zinVKqn5ZGqTMoZ2fxj/jVqhjlIjdHoWjL6n8TiH0RQN+i53jCRdLRyEGVVDbZFgP4ZHdt8kzI0waFDfqsrq065Thsb/SeDPUJJmjy/iPsNg924M/DaAFZqnipiBTWpJ7THf2YdGqIybpyKgT4BVPlJex6uqNHrqwaFTpqG18yycB29d9BjrrWkb/wgaylask4KHVC/sBq18tXmRwGQ55pHedgpuP2ZgAtb6BMhqoWJsl3MBWlS2uItUeWro3OLsDeIt+WeMSZ7ShUtp8yXzH9zq54DXUz/0vIEIJI8q1BHpWiNvE3OdHZapN9rj5ZJCAMtRtRzcvYIsrpPO+EVW0xAVti62H5EA9bkyg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(1800799015)(366007)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?1psg+l5zME7RBTnH8+bw0R7a+GiiGyJRHU00a0p3hJNRPmiyi/cD4P6ehB70?=
 =?us-ascii?Q?LeDXUHiZ52/MCZI05L5vRm5PDuj++hCmTSc3jJi94+8157GwGAwK3LSY6O+4?=
 =?us-ascii?Q?ODmPIPpWvDXiP3itohWfxdcWpb+L1nFOQZvig+gUATa/QV87jz30ljoobjtz?=
 =?us-ascii?Q?OvOCSLTxhRxP62k85WXeO7alLBiDNmTuGkF9OLter0tvKwntaDmscPt147/Y?=
 =?us-ascii?Q?HeWfU9JHYklGvY3sizAdVDn7JaXuX1TC8qBy222a49e6T/f0IFMz76clMSmA?=
 =?us-ascii?Q?YV34kz61blwUJEue9Xiqv4l7bfQ/24u1staYPV87qWe54HBDF0KWMEIWbuZf?=
 =?us-ascii?Q?fXCZKotN5vU9jd6uG3R8ldzEoYqXCLxs5hk76zj78e5J7biBfWcxsx4qJ+T3?=
 =?us-ascii?Q?fsQDIjnSHIpvZ7H29qjgymlIiKf4fSMEX1farjGzYtD65L3xI9ZusmPP5CCI?=
 =?us-ascii?Q?w6+6yB6jg+plBggJOrBracvW4No+1Hh3l8lC1nbgmDC8VMhv8kMVNaifMQ7I?=
 =?us-ascii?Q?m3f5e/1Q/+4zi52VUsUpwm0NYIOdc4lrQYXgqZ9g2t8100f30LcV2iPg74k7?=
 =?us-ascii?Q?FV3KJ3Z2K65OELp/vyM96C5RYneRnhJUBZsE7QiVU0tfplfu3Sf6fNHp/jzR?=
 =?us-ascii?Q?ae0B8DBVJXzMJryS14a6jB0HzfuZmME1t+JsetMvRd46HgAgEwFVmZdANl/U?=
 =?us-ascii?Q?svu39MGv5f/EdyvtBt+0zH95AF7V2v+60yPLSNxCxN7b4ITDVM+ANJCHuP+5?=
 =?us-ascii?Q?wTj9MbvHdG2j5a8CiDE6jYRxoSBX7SgNU4YM6uFxjH+Gawa9gfyGX1r0mpfP?=
 =?us-ascii?Q?YoT1mt1VdPUXaAuLG6imBROm+l5CupXHueFQFQbbfw0pSQTc33Ln5xP7uOmY?=
 =?us-ascii?Q?VFT3fd+efA6H0bPCgOpuy3jLNrCi3kZkgnikSMnWSVJW6O4PNMlUEm/sW/Pq?=
 =?us-ascii?Q?i8YAQRR8nF1Z106zXepzPo9dFwr2J12vqgiF2zMLwMz1zJjGAh1cUSdds7OP?=
 =?us-ascii?Q?bWkrngtU+xVTVsvILrxF3yt2CJg7PvFAQryLJiCVfvzSycohH1lsHy3Zx6+U?=
 =?us-ascii?Q?nZ4oubOVjzz51mEFlDntIidX5tUg4CC+zmIiFruMlI9TYGpT8L2+7fX3cBeQ?=
 =?us-ascii?Q?zvmb9xKQ6mwbOmP222CDsYhsZGguSEci9NAl2A84w3HwHdKWa2YPlJWX7/dM?=
 =?us-ascii?Q?xj+D2yTrCx2Qatfodiwo4m++qnq21TkgA58BNfJCtoPVUlMkTDGNXfi0goiO?=
 =?us-ascii?Q?Pq1ZGbQbc5J1OxU4vz1Tt/3D/TkI791kxVfHmWHaS7Z85PSK8nYmcrReanI7?=
 =?us-ascii?Q?lmU3eLgFhkPmSzKwoM7dccrVR1kcNC844tEKZ+Ib5/PshhVwf7Hd/6IHZ5h2?=
 =?us-ascii?Q?jXBok+TDFHHFVlbJqStba/GHUakFHLzayyK6hRPduTWULDuC/D5g6OZj2K9H?=
 =?us-ascii?Q?iIaQd0xWGKyl4IcZ18MeioBMpF0nho1T4tEkQdRGHpewaxW8TiccHU7FTiX3?=
 =?us-ascii?Q?wWuIoOmAcY0kQdEZ9LKR4dDJgPUDOdiMXmmGCbxFlax4Q7wMsCqJv6mwwqXd?=
 =?us-ascii?Q?n0uGee2uqfLxlHQqVBQEBNpP4ZKrNdS1JZbZtxUK?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c1a9156-318c-4d0c-e4dd-08dc60791de9
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2024 14:00:49.0577
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JaodgEbt8HDEEYFl18RNI0xm/C3c3TjVApMHviqZsoVquhSa1a9TErOkZqnjzGXS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7825

On Fri, Apr 19, 2024 at 07:55:04AM -0600, Alex Williamson wrote:
> On Fri, 19 Apr 2024 21:43:17 +0800
> Yi Liu <yi.l.liu@intel.com> wrote:
> 
> > On 2024/4/19 01:12, Jason Gunthorpe wrote:
> > > On Thu, Apr 18, 2024 at 10:23:14AM -0600, Alex Williamson wrote:  
> > >>> yep. maybe we can start with the below code, no need for ida_for_each()
> > >>> today.
> > >>>
> > >>>
> > >>>    	int id = 0;
> > >>>
> > >>>    	while (!ida_is_empty(&pasid_ida)) {
> > >>>    		id = ida_find_first_range(pasid_ida, id, INT_MAX);  
> > >>
> > >> You've actually already justified the _min function here:
> > >>
> > >> static inline int ida_find_first_min(struct ida *ida, unsigned int min)
> > >> {
> > >> 	return ida_find_first_range(ida, min, ~0);
> > >> }  
> > > 
> > > It should also always start from 0..  
> > 
> > any special reason to always start from 0? Here we want to loop all the
> > IDs, and remove them. In this usage, it should be more efficient if we
> > start from the last found ID.
> 
> In the above version, there's a possibility of an infinite loop, in the
> below there's not.  I don't think the infinite loop is actually
> reachable, but given the xarray backend to ida I'm not sure you're
> gaining much to restart after the previously found id either.  Thanks,

Right, there is no performance win on xarray and it only risks an
infinite loop compared to:

> > > while ((id = ida_find_first(pasid_ida)) != EMPTY_IDA) {
> > >    ida_remove(id);
> > > }  

Which does not by construction

Jason

