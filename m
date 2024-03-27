Return-Path: <kvm+bounces-12857-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7874F88E629
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 15:33:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 054FF1F3074A
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 14:33:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23EF315381A;
	Wed, 27 Mar 2024 13:05:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="nNtRtGmd"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2073.outbound.protection.outlook.com [40.107.243.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7433153821
	for <kvm@vger.kernel.org>; Wed, 27 Mar 2024 13:05:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711544708; cv=fail; b=Mx+4yhfn2yg1pMca0XMG6DOSJ1/H4zVH9VN5dfUlJ+krQTMPzcoQHbqQg8n/JXRrj5T+BmYTSqmgQxr1up4LNceN8s0G10f9XJ1kSB2xcultvfWpIAyqla+BXwy41oNZgm5f0gfGedLzo5/Y8sDs7QyDr8etQ6DMWIjFkCaclg4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711544708; c=relaxed/simple;
	bh=53AfUpYAlXB0XJEWU2KU6d/qzEr8ASIEC+5MTUDA5MU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=F4ou6qmi2f9Voka6+CB8eHCTDwdAH/d1iH9K3GtW3x3SFUrjvBLzw4kp3mQQuf2+iH68rsLpdqO3u/vwnmvQxHxZQugvQe2wbKN/KxTXAgRvbG8RoHkwhMLwOc1wXFGWxSUveHYrhSAA8kTzAhGwq5WpAcmh9I2SDEhNKh2THdU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=nNtRtGmd; arc=fail smtp.client-ip=40.107.243.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NpYpUZfLGXUGm3hOcuc9fLg5mZmxDo3ulJaULUCj1iWVqffz+xVRcJNTCqTezZuyfuZJVMFYqgemDhnwogNydAzO1DGVpPgoEKCg4SpUmDbEW+MinJQ1PHkq0dpg2a1YouhNtLlXC6OIgzk8x+ziDc/1GNt4M6bIWdeeEoM+t5DtEQR4Z7pG9WGRRNBXxcIWf2ph/q2Ku09xCuXOudrSi/L3t7OS8lwULqTjM8HVJqPuGpmqY20SGtXLEFhYzAdKWRrkpqEXMf/Gr61YiISopF/RdE2mvHfXUhVPCGVI9S7jK4D41L1Trb2mn7t2kbXXq8ZSXox+jAjK/ApWbX/7SQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EF4AeJzabIJoCxKI/EjHioU1eH8nnlXVDdst2TiQmc8=;
 b=HRCpooCuep8t1AmO1xt5ucgHtiBuD0GlymDSxB2hwpuldnDwy8TKwlb9c6TFBpVdpxMdDBGhVk45bzmKkqN3Gnj91ygnJoP2UNgAURmKrzDopCEMhj9L0UoVvJZnosZnxpbA9d+3ouO5xzjYbcvYlFTfS9hHjoprfQfWmp3bmiq0wB2qhLSq0mlft8ZMKgxlQcAvmLpaY3p1zquxvL5CS7oa/KgQWwkRCLK1D4VIv8IfdC896ns8paMmpLyMok8jd/vCQS1EgeadCVS5VrudSwYF6XIGQksnoqJ/dcX/LPtEsfbodhD7XFwDqu4pz/rmSnY7xLCnb6pjDTPySfZKRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EF4AeJzabIJoCxKI/EjHioU1eH8nnlXVDdst2TiQmc8=;
 b=nNtRtGmdgs6SQCyPU6Mx0xLmTwM/CzPG8CDNQmPM94vBQiDUe2qicZDQG2tY62U14eljgcPUzlTM/1k0WV5gyUw6cj0r36OznvgbMjUvt7z0a+SUsYgb4MTQi0SwAZ8U2OxSlwEf+UqFTN/afi1wY22nupqsOplzBESBx3zyM+Es7sDYPINfDUtQBOcPPoD3ebma9PvkRm1AYaxePUHHuuK8CGmNxkZIxPEY6dWNfojJXY6NmFWHSEoeUdrkJCA7hgLSwHn6yBi5OCnODioEDblRjTCqciA9YdRg2Ib9oTWSNb7PNVGhq785aO0I3hK0l6N5agcPcQB8toj1zCy1jw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by MN2PR12MB4079.namprd12.prod.outlook.com (2603:10b6:208:1d5::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.33; Wed, 27 Mar
 2024 13:05:02 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222%5]) with mapi id 15.20.7409.031; Wed, 27 Mar 2024
 13:05:02 +0000
Date: Wed, 27 Mar 2024 10:05:01 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Yi Liu <yi.l.liu@intel.com>
Cc: joro@8bytes.org, kevin.tian@intel.com, baolu.lu@linux.intel.com,
	alex.williamson@redhat.com, robin.murphy@arm.com,
	eric.auger@redhat.com, nicolinc@nvidia.com, kvm@vger.kernel.org,
	chao.p.peng@linux.intel.com, iommu@lists.linux.dev,
	zhenzhong.duan@intel.com, jacob.jun.pan@intel.com
Subject: Re: [PATCH 2/2] iommu: Undo pasid attachment only for the devices
 that have succeeded
Message-ID: <20240327130501.GF946323@nvidia.com>
References: <20240327125433.248946-1-yi.l.liu@intel.com>
 <20240327125433.248946-3-yi.l.liu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240327125433.248946-3-yi.l.liu@intel.com>
X-ClientProxiedBy: BL1P223CA0013.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:2c4::18) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|MN2PR12MB4079:EE_
X-MS-Office365-Filtering-Correlation-Id: 9e5c8c41-eb97-4356-a418-08dc4e5e83ae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	W2SazMdX19beH6w+vHP0VEd6teykssYiTmV6V+1kY82M8k/tI5mHyYhU/xuOXZ1CqHm5lzQJUu1S9a8PeYafQ/Xa30CQkxXvkLMSiaopXyUoC6vFfRcWqctFeSfmDJkpKNBuForK9Hp642Jser6YPJl0RzUycWZeWmL6qW6YQ9ccNQYi2wWZ1eKPvP9orsPKqSO8wnfFJqeQNS7k4tQKfvz8rMCgdNOPOWab+SGFRvnJJHvgIA7olTlcTmXTbbw0754DD3QFjJ0IJhwGsdw0WyRgbHFvBzf9gNIkh7jhAE4xDLZ9J9vF5swFreuz4nsHi9c3jBm2c4hdtxV9Zr9uLsWI6wtlZ9nmzz9sfLk6d1dQ9UzANaofhnkONRYX1dEHQ1F+IeM3Gp18Mt9Jhuo2xobgzyVsiOCEr3OwMtiUZC1Pro6qGpXsaVM1VI17M/wX7KWlMAbES3TOyZ5A5G6SZ6jacYGGlHvFpCYNMm5wrQdf+kZ9KizofjOPkyVBJlOwyjMXLJTLiRpssbB76NH0UmJ/5U76yAuHoT2ksF9E+RDMphuE3kc3+iUQIpj/55ZZD+PozoHj8KBqr3fVRFyuKkdo3KMGEIc1dCtHv7rXrj0cSjd8Oc9hxlJZtYyM3UPIQQRBpz4FZ5ysUiyScv9O103KvUVhpRjsSsnSKV23bTE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(1800799015)(376005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?W0BTuaSibj21g9kkybCHqYqxBoxla6VvqfWhlo2NflhTNoWfq+FsTlpapaBL?=
 =?us-ascii?Q?dy8vRbOe/7wG66Hno9LOvDRaNzxj+wiGyiJWayEdjcDaM7M0fuLZkrr2p4Tv?=
 =?us-ascii?Q?txjtEUhciAuAwRroG8VS9ZR7+xkyPa0rrouzoyHjqT/OHMkDjnEbsxa+fwc3?=
 =?us-ascii?Q?r1NNfDcs+h1FmzHAKxz9SttydmVLvf5zXrya77525qlXwqG9ZAyfgAxqAsLd?=
 =?us-ascii?Q?KRUvybusscyxUm70Wu6g+alaCVApEaDIvkMPZCxBkLeQ4fxqjbgRAg2M0aIx?=
 =?us-ascii?Q?Pg7kSz80sEa7XNGVmaH73woq5w05iRaUHTvPzRPKK0tD/9DatyT8pz+I5fMC?=
 =?us-ascii?Q?ta7dmV7WcjUwHeEi62ykIVS5hdVZOQavSeY/iij8yiwNhJYRZ7sRpBPdVec8?=
 =?us-ascii?Q?bXJXpcTxDxzPqynhG2gs56S6bXmuKXZpFPEDxvE0GZZActCTUvMPxD5/KWvK?=
 =?us-ascii?Q?UnglFSSIG5qq8pK1E9kU0j3I+FfygHA7XPKXWASRgS4oD8C3HqVb+eCtc14S?=
 =?us-ascii?Q?uxxOvDBPlT9E/zNPLGQWozyN88/O9gnNdXfYPtcGtSNVLdkZvUUTvR7+MRoP?=
 =?us-ascii?Q?og6jL2NM57GD2lnvzAkRFxQXfoxB3kjflgEmlj8T5ixsBhPdryMSETnRudcO?=
 =?us-ascii?Q?kMkCHHA2Y1SfCLb4JAB+BKCmlA+FHu/uZcPKRyXeE3HLHBBnYMWvOOYykwdG?=
 =?us-ascii?Q?6pN4CWibw3D/dyFd8zj+tXWgezUrqBulE4u/FCt3jKzkWV4mQqHk6L/jXUWg?=
 =?us-ascii?Q?2v4pgGFbaRNI7XV6x2Ipcus4i4l5LgOKXUgW11MVjLybyeVnEO0cPOqC0pAY?=
 =?us-ascii?Q?qiideriRL57gnUYwVtP6IhCYyGNiHZLKlVquYhtpvgsqfFURbjbgEVttSuFz?=
 =?us-ascii?Q?g6O8SOth0twMIwnaUq04dJB/JrIhKhFToAJHHcakknZGG47odai+yjodLye+?=
 =?us-ascii?Q?uOapBB69C5qc4WadbhLfHlUBzA1bxVTsW7565+Ag5k2k7XePeRYj3tBi4HQ0?=
 =?us-ascii?Q?NWCyduc/6N1yMh7ad7RaXx10yQxUPOTFPhrekhWSbei7oTRcYl/qD7hHiCCk?=
 =?us-ascii?Q?7WGxQaMveJ4+ly9AgSfILfHvkn0crc731L3Af4MZa77O1nuQOgrimj425cGP?=
 =?us-ascii?Q?AvkLMz9WJ9+EMaFZ3vD94SAfzPDV/lQupmrreU7LHfR7MC3hTtts6IhoBNkk?=
 =?us-ascii?Q?tBf0weY3DyYOyeq/9YpZyzO08d7HViouSvfVtbgZ7e4jG5o1XTqhiz0xqTqV?=
 =?us-ascii?Q?LkkN0C5LQQA6IDGM4hsgHvsBmEfx77ZdifwCVLTCLVbu6mTolHx6o/kBqstM?=
 =?us-ascii?Q?La695eAL28jMn2/gnYwVloZ2mgGcG5PGhwLw2yZVb2oEhF56nEqh27JBzzz8?=
 =?us-ascii?Q?yr6YLVlpYkFjUsu4LHtoD1BmHuu17gepucBcm8N+4NNAv3JnrvmGN0XOCNR/?=
 =?us-ascii?Q?B6GeSmIV2InnyieDPyoklzeJ3pj4Sb4Nw2MTocieeQ96kkykNOX6vGIwI5R9?=
 =?us-ascii?Q?Xfke35wONBaKXcmgVnWIGFtWXH8zqun2kal880m3VzF21iKD8RikC9bC2gPE?=
 =?us-ascii?Q?79jVg9xg00lZste2sZ41GqDiGEdtYfTXX5D3THTy?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e5c8c41-eb97-4356-a418-08dc4e5e83ae
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2024 13:05:02.4066
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pNdMxm/NVQYTDlQD1IUaSWOO/tLMY0xwcJf9ds6EyLyCqeFdTdOQJyim+Mx5cXgg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4079

On Wed, Mar 27, 2024 at 05:54:33AM -0700, Yi Liu wrote:
> There is no error handling now in __iommu_set_group_pasid(), it relies on
> its caller to loop all the devices to undo the pasid attachment. This is
> not self-contained and has unnecessary remove_dev_pasid() calls on the
> devices that have not changed in the __iommu_set_group_pasid() call. this
> results in unnecessary warnings by the underlying iommu drivers. Like the
> Intel iommu driver, it would warn when there is no pasid attachment to
> destroy in the remove_dev_pasid() callback.
> 
> The ideal way is to handle the error within __iommu_set_group_pasid(). This
> not only makes __iommu_set_group_pasid() self-contained, but also avoids
> unnecessary warnings.
> 
> Fixes: 16603704559c7a68 ("iommu: Add attach/detach_dev_pasid iommu interfaces")
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  drivers/iommu/iommu.c | 20 ++++++++++++++------
>  1 file changed, 14 insertions(+), 6 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

This will need revising when we get to PASID replace, but good enough
for now

Thanks,
Jason

