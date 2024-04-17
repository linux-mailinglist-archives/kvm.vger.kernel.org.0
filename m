Return-Path: <kvm+bounces-14958-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 937C98A8305
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 14:19:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4A75E2834F7
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 12:19:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88EB713D290;
	Wed, 17 Apr 2024 12:19:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="sLoF2oE8"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2070.outbound.protection.outlook.com [40.107.223.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E7A413CF87
	for <kvm@vger.kernel.org>; Wed, 17 Apr 2024 12:19:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713356357; cv=fail; b=nagTuam/yPmAACqY1LKmkAE/kF/tlnCum+zD36W5qnRP/cAMh04auWNSUXWxh++Tb2EjyhJzyNcZr1mGcNppi8cyX1Gx2akfjqUTTt4kI3QwL3ZUgQd1xp4mQKcHse19LzbSIzFHXYzhTTTBAtx3C/DrSzlFEhRv4InFaSKHe2A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713356357; c=relaxed/simple;
	bh=JSG7VFnhMjXwU2zym3OGOjnA3XWNji2GIilj+jzmqps=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=JaUqBexQq396BU7hoGTxtVHEsjfseh8RbzRhQIRpt1wUCeefs9cs9ol2RcZoLWVgGQNA+3NifDrTmK/xbJpTvoogiErdt3rZBAEp9l/I62VeGIL9lPTByqA5G7G27YcxJk0C2VdcvIFQ/Fq/Z/Q9Lv1b/6Kyt2UMCbpCVr0VaR8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=sLoF2oE8; arc=fail smtp.client-ip=40.107.223.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VSxtz/REbBsJo+BzbSRNuqRVW4CvXwn8gOGmI5oLUZw1HCmDIFKb/o5O3gWK6wzp1WgCojHFsbl7/yLZ1M+Ag2082gMsOvmlEXvLvcfbYuyOm24RF1nOS97mkg3WcBqUYnQV3mpGl9GRpLdLUSkrmBs/EqkB+4v1fun9kkuGnZdFEVVfGSMZqIws6qDtmjv3ddCOlADk0u5e/IG9e2cJgQ1gMktLD6Lr2AHPfqR1fegWUUn0VICHPSWPLGubhmH0TfqaEmPOnJOiuNjUa4nl+cwRKlPOPx5HMzmqVEKhXCxOzDmiDmgsmtVBN8fbr4QfPH/cnKXXAbNlxBTKmPNcwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XAjCDydbyszEkplR/+RtOaQN2kXZSjktIOojwpiUhjQ=;
 b=oVLBuJH1DrFWLF1x0AXXDzwVgGAKZ5NJ35V/GmLdhbBuLTiMcXz2fenDJkznLmS+XCsUO8azXV6JEk/5mL0rEwwMF0V/9ni1gAmTCmPBjw6S4UwJSis3hWy/q/nxyNkaqRN8jNYNJ/Zhr28+zSa5t/1wHuq+25/CjyhmzeJ/gWIdqeioDaXOHJB06Ih1PbbxvAPMLO5IAVLMccdoMEPgdG5FR1LJY/1R8xw1bzHZmgdGeMFSmPfx42D3x0VFXpNczJrTeMxKPAiUOte7eXz6uF9kCOUJ87VH5P7hdfIjRFWnFyVcK+lRyxMFc00JcDGZJq2KNByCzMrY+QRQoBR/pA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XAjCDydbyszEkplR/+RtOaQN2kXZSjktIOojwpiUhjQ=;
 b=sLoF2oE8aPEXSyjuQNv0zvHd1PbuvuKWRfkzSEpkpyqd5pFyRFRwuIsCssFBK+mMC+CsUa6brZDlfk36OqOQjfAUeWlP1izCRlLXDuWb9+EEOPhv4kYF7NCL23968yMZdXIZ7p0KaKhHXlQXstOSPRfQz5rhV0KWSZisUJM5BnR6bnq1jgWyo7Q0GDIVxyxPUpRQQElUQeREwXOR9RRMi3WnRsPa240NEEZSOQmz81oZ0+2UJ9bpd5R4P0IWOxnGgh5TvfMLlrOc0q4pPPaPP2NdKKFSzDrGrDOYiLMCgoAB3mAsYH9pr2bW28q2Qq9GgZlbr5ZIL6ASyxSKu2/hTQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by CH3PR12MB7641.namprd12.prod.outlook.com (2603:10b6:610:150::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.46; Wed, 17 Apr
 2024 12:19:13 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222%5]) with mapi id 15.20.7472.037; Wed, 17 Apr 2024
 12:19:13 +0000
Date: Wed, 17 Apr 2024 09:19:11 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Yi Liu <yi.l.liu@intel.com>
Cc: "Tian, Kevin" <kevin.tian@intel.com>,
	"joro@8bytes.org" <joro@8bytes.org>,
	"baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"robin.murphy@arm.com" <robin.murphy@arm.com>,
	"eric.auger@redhat.com" <eric.auger@redhat.com>,
	"nicolinc@nvidia.com" <nicolinc@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	"Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
	"Pan, Jacob jun" <jacob.jun.pan@intel.com>
Subject: Re: [PATCH v2 11/12] iommu/vt-d: Make intel_iommu_set_dev_pasid() to
 handle domain replacement
Message-ID: <20240417121911.GM3637727@nvidia.com>
References: <20240412081516.31168-1-yi.l.liu@intel.com>
 <20240412081516.31168-12-yi.l.liu@intel.com>
 <BN9PR11MB52768C98314A95AFCD2FA6478C0F2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <52e38f2f-0e45-49ab-a426-53ad57c20b0c@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52e38f2f-0e45-49ab-a426-53ad57c20b0c@intel.com>
X-ClientProxiedBy: DM6PR07CA0076.namprd07.prod.outlook.com
 (2603:10b6:5:337::9) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|CH3PR12MB7641:EE_
X-MS-Office365-Filtering-Correlation-Id: cf000080-baca-44fd-9bc7-08dc5ed897b7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	BlBGlzp2k7OVqs7o5dlyduU2jhmwa4MwBt6c3OoDKNGkx9L8YBAnlzdrM+WP6yx0TJonkqkWLfl3TG70U+h9bJgeopF6K//l7O2d10a+EfbemTkVJkEq51xARVXkcac0MDN7YWA1MsJR2sjdI+7pIaS7TC0TiZZ2M6REipHMtPDyBppDuD2XJk94ebQubIy6/S8MIQCDOgf+/EAwURjQ6n3I0PeEgVZOlWyZGAboB61jmyY5LRN1qhH6NqrkZPzXYt4QZQIYQO4ctiucJ6FvNthbY9eIXO9iPuWOWO0gSTVVbqUJgrtf3KoJVekcci2kVefrpGr5f0UOR9W3lCBuOk21TQStNUjhOHwr/bZ0CSYEyLvktNZEzpif9ho6u7sdkJfpfMBzIOtAZwsa4ol0F7j6UBjFfQmiUuddaSap1Ed/TjZ23Nym9hAz7e7md2SWHj+Rr8QC59xwBBJ19t4VLiitXeGrrF6rqDPvgp4Fkaq1uQRV+xpHpMR0n0jSeYYdm3woPBNhoEzXN7B9JMCiigAH4SCA8EI+WdHZtXOEH/TmkD/hJm4VTxXZWFZ1RdGtvJNuk5v92COL1K0P4DXBYrNQB1jor0+qfJkhyg6HkF1GU8cscz2+Y1GAHJFd6ZbQUVDKMraYXZjIR5oPmQxSwbTK2Su9PCKxudhfQMSSff4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007)(7416005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?CSL0w2Y/TiNjcuIGjJKh1kFcDGQ8N3sY2bTcbbf60ZDhruljhO+C8XfZprQp?=
 =?us-ascii?Q?xc1ssaTLHPqxPeMJjfvcFdlltvQQtHYK6wDnZMTOYENYkE0J/t+7sQjsDlCy?=
 =?us-ascii?Q?zlaHgQGuw0emg8iOO1+e/UWGsXSYn1GFyK9GJdFLS1kU9MYzYQdtpOOK+xbw?=
 =?us-ascii?Q?gOP1PwY4nqtCExaKK/k1ZPlfR3U6vTuxQdH1dmGwwslXXs/mu+ZHZ22Jucnn?=
 =?us-ascii?Q?AHFsACEH5lkNgMva8diBR86hBLEA/NwnId6P/gWRVVNM1NmZ4Hm02geBWhQk?=
 =?us-ascii?Q?fKtjLwhJGjaBZpTEVOlJflGYwHZMtnPWvRZT/Kw43EDjWbk5vcrJR1XqXG4k?=
 =?us-ascii?Q?Upbdw2zqBlQ83Ti5y3VsvCIXQPwN/Km4zQWptSMGrBku+q12KDuJ7uUcn92p?=
 =?us-ascii?Q?EL7yWgSXPxEP3Nyt3Oz2XOPTJVaL/lTtBqDb88itlzPnPiY2f8do4zAqsu6K?=
 =?us-ascii?Q?+mhDuc3xcltaSGY+gdgq4EWHf9BkZ7ZESvmp8Q8Mf1qcCFziYdQb+DQANp/i?=
 =?us-ascii?Q?gdABfPAxaD8xi7yKyDKQVB0WWuc/KtXdF1053LlyZ/AxS2aNMoJuqu13gGx+?=
 =?us-ascii?Q?lOhuJq+N0Ywdfj3XU5ySAZrcNagHDm/9LAFKtioYh0Sjiy8XCfh7AS1GJ7j0?=
 =?us-ascii?Q?YuYEj+pJrqXeoXZJp0iMhmhv5DJpl6eme4/E4dlmxPRkGUwnbcvBBTiMeJGV?=
 =?us-ascii?Q?CgOWb008lUMQE0xyG4WaJjRzGA+0UQjfeL7hRtH5BvBub787hMp7IWoSZvYH?=
 =?us-ascii?Q?sN0UbCh5U9Fj9pRalZOalijvmr5I+tNnnd7XOG4Jn+aGMHM38AR+TFp+Z0Sd?=
 =?us-ascii?Q?jjJ2gMgTDvA7ZbRpvgWDDPFlzPQo/R2j+6M2WIAqqx7GsZWaRAemmQwS78le?=
 =?us-ascii?Q?NcUcntmiAd9w9YR836ssD7wWDaR7/2v4Tq6wDbYhSyRyPTP4/fBt95OxPVsa?=
 =?us-ascii?Q?sHkjWXA7ggwgXT6p0QxJAjG+/CfH0jcMKrlaUVGgpyKyH5dEXCJOjr3epuR6?=
 =?us-ascii?Q?N3m7hYlUMuBxcJs1Qb+9rx/N7So9EYbewJjhQlYgxMiSbetg4ouGFbgnw/Hi?=
 =?us-ascii?Q?4SSD73mhlDX25ETDENmnBx8A0IChnB8DJb3SRYAGT8l44GvEWYPmty84z6YS?=
 =?us-ascii?Q?cyR72WHXzQPGezc27CI1G5s37Kyu2CsYGy/U1GFu2qOsK3spLpMsOEB/IDC3?=
 =?us-ascii?Q?HlCUOTxKCn89baraf+I3bnscIRvfl1HHeT6l1J6jG7+UMasCu7kqGtO642Q2?=
 =?us-ascii?Q?ElIbB6EI4Hz32ieJ13knUqtLZnb4CmiSeXupkRCyZ50PlaGlnoAaybNeHJ2c?=
 =?us-ascii?Q?Lx/r4OnTxyBRN6JvZNpoZoioF1ZEx82RfYPnQ6iOdS9Fo1cygv6i/zZsrAoh?=
 =?us-ascii?Q?x7t3IsLR84s6q9MbPCbaEsnnWeWHI4w4uLByIgNWANkkChd1k7tzDYSQLuhx?=
 =?us-ascii?Q?AdHRCODbfN6zzjHihjRlnoH367UV7JqCGnf/2ZcMmM5PK3FEoTFjMSo4CeR1?=
 =?us-ascii?Q?YFNT1mAP9Mll7JKtslNXzwLvkJnZVnUe2rrnHdCIv/BXUBjPQLDbyKAHN7Gf?=
 =?us-ascii?Q?M0IoPTV6uCAHkmk1sjuZTlCqoU1NwVETzWY+bJEs?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf000080-baca-44fd-9bc7-08dc5ed897b7
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2024 12:19:13.2331
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IeCRQnHgjmo0X6zMrHSvgAEsQOMrmKWiLZZCJdDJoIVGNa9bQ9S7L1uUWoZohkgL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7641

On Wed, Apr 17, 2024 at 05:35:47PM +0800, Yi Liu wrote:
> > do we want to force iommu driver to block translation upon
> > any error in @set_dev_pasid (then rely on the core to recover
> > it correctly) or tolerate duplicated attaches?
> 
> The second one seems better? The first option looks a too heavy especially
> considering the atomic requirement in certain scenarios.

On set_dev_pasid() failure the driver should make no change to the
translation.

It is the only sane answer.

Jason 

