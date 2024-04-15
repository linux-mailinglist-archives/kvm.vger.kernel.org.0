Return-Path: <kvm+bounces-14639-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2AAF08A4E26
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 13:55:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4E2D41C20B81
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 11:55:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 349E9664B7;
	Mon, 15 Apr 2024 11:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="USwuu7wG"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2046.outbound.protection.outlook.com [40.107.93.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A4DF5A0E3
	for <kvm@vger.kernel.org>; Mon, 15 Apr 2024 11:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713182093; cv=fail; b=b6fxmeAajA2qABguHOB5T1ww6kOy80yH6LF1NlLoV/Pv3iJiJPiQDspAUuVwLD9GtC/Y2WGF3pQCGsRD1Yhf7qgWi3NqwzFQQraDwVMDLhTr0b5CSaL2gSDB8/MKmEcoSCjsdm/2nJRg1t5doTLzyklCty5zapph29PbewqgiPQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713182093; c=relaxed/simple;
	bh=TPPcD5ZNYL9s3wxy8ScrLuVBGkTIk0yc1Yt4kuDHWf0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=M45pRCSWZ/jHCzaxSq8YGKz3V3gwEHirni872CaWRvus4t0LCBmvp05LAlNjb2lFZi4qDFo9MWvd4K1slaav5iEFTTcmQMqh1Kd5n/cVG6632MyHgVzcCBMf4Qae1DJXHZTYET/zRvjwNgpQn/W8n6iLv5nUKsuJuOg25mt0eIU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=USwuu7wG; arc=fail smtp.client-ip=40.107.93.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zqh1bQAdllhCn8Hnn4nxPPLDcm9dil1nDlf/r8TjsRR8C1J4GYD661pmdes5aZqtMqHQCzdEhPJ+e8FqC4zzIfJckx6fhlxxQOyZz0paVyegMNsUgs4/6rzS+VKDyHERDlevzmG/RmstPvzoT+HskmGRCZ0nRrV5nFiIKwOrfLlJyY1i7beua+JIxK+WlTetpB2ZxIuh0FBQx4vvjWHKClzK5zWPeaD+TkG/PqfE6aN8ai2TtsuBihQsd7ubs9gSDUT/kSoEqXj8ux+KCbFB/2eoyDqmA8bvgAPAl7ZGFv89aFGzPDBA2B7Ef6eH984e3zOe9rM27OvBupd4zGF9pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n6i8XeolLdTmFkeQKbxbbgJWcM3WQDFZj0qPTg6wCXY=;
 b=gtTdOjvCBHlVP0C3No788WNGLx6VYRsxCB3zkDT+xZ0RmGsez9JtDGBaBX4tChwQ2YkOKs22KmcW6uTwpzOdbUnS9LSH/C4MheMddKiiz5jYsUQ9Mbl8NAIzZiDmML1B/kz44gVyXcDOUrewqbvOIJyfCsyh0Dd/QiLAckxHcbvwzjQWD3dmjbSffxoihMoQa4MEZe4CSzKiSiKhX55Ptq0Trh6C1BgcIN9C3lCfIYNQij5eThCDW67PCipBeZk9TbMq5WBp95ET0CIGcvpLWVnZlYdQWPjdtjA74v0kCcfx8505PsqDnN8NVneH9Kd94Xt59XxZLyn022xJ9cnBmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n6i8XeolLdTmFkeQKbxbbgJWcM3WQDFZj0qPTg6wCXY=;
 b=USwuu7wGVCJ5RcLaGju+knpEVIxg+rva8pI+7CKwCuOuOEI8XY3Ka4WUgZ8aqqAL8VGu1cdxeTHOASSXg1WciyvH5wxQ5lmsGVb23r8SZuyIw+UvoJPUwZG91+hOIDGPTlUbSjhEppCzu3qJ5CXr/v5N6r/8qFzEFfFNEnW6FgmTvOjK2+ALw+St0ppzM+aqiPLOQ91vuCXVaM7o45EX/cNvWVTE/En9tipkHCXTAfJv102Oo4SZucOswRqy34ZIcRpqRtUmzKY9Cwjo76zo3YrW04Z2fRr7moxTmCj2fcJYEl+dA6S/hPC1DsNAg52q+ZClFBFprS6CY0OOJWjubw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by PH0PR12MB8008.namprd12.prod.outlook.com (2603:10b6:510:26f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.50; Mon, 15 Apr
 2024 11:54:44 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222%5]) with mapi id 15.20.7452.049; Mon, 15 Apr 2024
 11:54:44 +0000
Date: Mon, 15 Apr 2024 08:54:42 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Baolu Lu <baolu.lu@linux.intel.com>
Cc: Yi Liu <yi.l.liu@intel.com>, joro@8bytes.org, kevin.tian@intel.com,
	alex.williamson@redhat.com, robin.murphy@arm.com,
	eric.auger@redhat.com, nicolinc@nvidia.com, kvm@vger.kernel.org,
	chao.p.peng@linux.intel.com, iommu@lists.linux.dev,
	zhenzhong.duan@intel.com, jacob.jun.pan@intel.com
Subject: Re: [PATCH v2 01/12] iommu: Pass old domain to set_dev_pasid op
Message-ID: <20240415115442.GA3637727@nvidia.com>
References: <20240412081516.31168-1-yi.l.liu@intel.com>
 <20240412081516.31168-2-yi.l.liu@intel.com>
 <3cfb2bb1-3d66-450d-b561-f8f0939645ba@linux.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3cfb2bb1-3d66-450d-b561-f8f0939645ba@linux.intel.com>
X-ClientProxiedBy: BL1PR13CA0092.namprd13.prod.outlook.com
 (2603:10b6:208:2b9::7) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|PH0PR12MB8008:EE_
X-MS-Office365-Filtering-Correlation-Id: 93a19177-9a93-4053-bff6-08dc5d42d71c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	XDkxhk6rv5Jyi2ggR/Adwdyn4EXMdnkFTEb8hSYKBPNTCyimqegSutlaO9fP0yQEg9k+C3QmY4p0f1v4HzjcTiQj3EoujwnaoprQd8drRu4Ndf06t5KXAmWyt3XjpitFoqrArJx/p3kYfihRWTSmE9BWlop0ydO4FQCs4SMAwU6WjA+iBmXXuKokmZ9Rq9PMtuG5iTOZ9SD+wq5z+6hBfLD+chfnaTDFZsFL3bzucV94bLNk7Y/c7I1wowMIebIL1OhN73A5Uz7cN1LmedEV7i914HlyGn2Xn7K+Z9ECxsv6gVQiT1m0J+bGjjuXofPZ4gZvW3B0wY2vkmkqSmqHSEk1D65ln82JGhzf+jsPrOx/2DUAFH2kekgeec/4heGF9FZlPEAuaMt7cjPJwoVn8Qs8pNq5P64pkivumernfXxYBHLzuMfrHSO1lWGeVQyKuTvugZcalNzOaE/LuhJXZoXsYEcw3aYqr6Vbfr+GTQTy53JridZ4VALz3IrJBrgJvDJV2Uj3btjtX+F1FOlB44sd81MWrEJ9uEU4O2EEpE27tBkg/IpgNsSxJlePI23uHVQW/ID0iUfWT4ewv4IJCmJgPDlK2Tx+u9e32NUR02dEu1s5Bt9tHzeXXOT5W6aMPP+LvJ2nRVRF8Ij2df3dLWBiwDDDo29z13f/RQpxE9A=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(7416005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?sOGOfjl0Hm8nsrWPbOyXw7OVthIxm0MZngtxBO6gka2p5IXvK45fkOfQBWuW?=
 =?us-ascii?Q?Ew3Z9vZkFKsAoRlfklLkueEq03XjSQFBashr0bYyd3g2IlhwpcFscrIwzfMu?=
 =?us-ascii?Q?iYYNR3p6QnA/z5o+17VkkZhckJJMA09qY4B0qBaK1SICma2Dzs0oj6Wdfll/?=
 =?us-ascii?Q?miocKsS7T04ztXvSw+tJLLqsitMKPymsNGIKlBY0vO+0+0ppXg7dymUy+yfh?=
 =?us-ascii?Q?OLsqwTyXETCkWIaPwndcGX+/SQGS2jB/52vBGB9dO65yPZsrKliUyYMmaH+J?=
 =?us-ascii?Q?KAI9f7tOuHaTSd1EaamVY9yLyutPlihTbwGZ3zBEJIZHl11ZSSmZL8v6KOhM?=
 =?us-ascii?Q?tPmna+r3UTAVM1GOZz1kNK3muANTMNnQ786P4hUJqFT8hqsvV4UsmjWQZSa2?=
 =?us-ascii?Q?4dF5B8uk+iuOmX2/mSnA+Gk8L0wZIVe+mqkYBeoMDhiAY2OKDwSwZvaf6p1L?=
 =?us-ascii?Q?u2hzA7HCurcAvel/BzAIU1bTXrmvQNFzR0Lfr0iJTCzlDd61FgNMRoCYk0NL?=
 =?us-ascii?Q?DFj3U15xHBq47PXKAjldcAAI1IADSXYaKWctRbC+S2jC10aV3Xg8nFGSryW0?=
 =?us-ascii?Q?L8b4n2JbkPHFA5ykidSO8PZXIGp9+B3ewS1Yhmq51N2F/cYWqpMhT9VUk+av?=
 =?us-ascii?Q?Avl6sQyNv62bcpe51spVPVyQo/x5EiF+lvzFIeDumyX0t29rk9gx9khwBv4u?=
 =?us-ascii?Q?nNP+nN9thK2YgRplYqyl9n4zOPuhNxg2NxFGfY+bhNEew7GXM3OXaPuF99Gr?=
 =?us-ascii?Q?hBYqAtYi+ZmIe/1tyrkav1QoIaAKiQJMc49QRjGrsXE4NU3EydaLZTCx99qv?=
 =?us-ascii?Q?+nxsZHCq0vAoJXI3kblWjE/l5tdGqtBgj/hkRt6hv79nkO32LVKEEQoytg8G?=
 =?us-ascii?Q?yVK7jVnr785WQjlCLDBM6ImicGKq+h1Ca8a3mcS+Dmhu68z1lbMI2LU2JraZ?=
 =?us-ascii?Q?RSmz92/gJOCgmSMDuA5GF+hA+bFi31posEWsHLphjQBcK3IOkHzoxc45Y2fq?=
 =?us-ascii?Q?vuwTAZwvgFUevcdPTMsKtj3tm/FS8uSvp58tJC1t6rLWRO5SuavTAHFfWYLZ?=
 =?us-ascii?Q?xl+Nmm7s/GFxhix6oFTXzKBVUDTXmgwjczybaYUWoiCz79cxUOCdGognj2Hr?=
 =?us-ascii?Q?9+kJcBauEAL6EiXg85gPSdYcTHJCYxPUWUCDIBu5SE1MATs8eIpbTJo91zoU?=
 =?us-ascii?Q?6vb+bi08/rcVPkuFAJssgprbalUqSZpovEyFcZu2OsLEsMZkBGk1l3qO7qwd?=
 =?us-ascii?Q?qGbRpMTqBvKLZPrZqt0ixatp5bBSxqz337GyZZy5pl/jb7cMOfMeUc92w2Ha?=
 =?us-ascii?Q?WX5lNjP04w/djFQTtRb7j36T8nYxfumYoA9lKlvobzxx4vz2Xsx0e9C4+Esx?=
 =?us-ascii?Q?O9GXvX2Tt3UdrN0XxA9PSGrWc9vviVqktIWfVqsSW5tdpb1rUYIIFnod8DZI?=
 =?us-ascii?Q?ALFFUufNdgXGj+GDZrRmjLTXn5lSb3HO53J+MNbbFo+a+0kh0VgJIA7m2Cuu?=
 =?us-ascii?Q?sgpfse6YWfEjnNNR6z89moOKhrEG15DiQMDtiXJMslDjSadP6cCzRtmD8GS8?=
 =?us-ascii?Q?qLONgmtUjMio3B78/a4=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93a19177-9a93-4053-bff6-08dc5d42d71c
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2024 11:54:43.9787
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3kL7tZJgCJk/8I/985m/WIT3hmWB0M5CHUOSMKWxAhUvQ8eYsSoFNKNTkwp36SC7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8008

On Mon, Apr 15, 2024 at 01:32:03PM +0800, Baolu Lu wrote:
> On 4/12/24 4:15 PM, Yi Liu wrote:
> > diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> > index 40dd439307e8..1e5e9249c93f 100644
> > --- a/include/linux/iommu.h
> > +++ b/include/linux/iommu.h
> > @@ -631,7 +631,7 @@ struct iommu_ops {
> >   struct iommu_domain_ops {
> >   	int (*attach_dev)(struct iommu_domain *domain, struct device *dev);
> >   	int (*set_dev_pasid)(struct iommu_domain *domain, struct device *dev,
> > -			     ioasid_t pasid);
> > +			     ioasid_t pasid, struct iommu_domain *old);
> 
> Is it possible to add another op to replace a domain for pasid? For
> example,
> 
> 	int (*replace_dev_pasid)(domain, dev, pasid, old_domain)

We haven't needed that in the normal case, what would motivate it
here?

Jason

