Return-Path: <kvm+bounces-15807-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BF07A8B0BBA
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 15:59:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7488C28C92F
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 13:59:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C5C915AABA;
	Wed, 24 Apr 2024 13:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="AhDv7NwB"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2058.outbound.protection.outlook.com [40.107.96.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DAC715CD7F
	for <kvm@vger.kernel.org>; Wed, 24 Apr 2024 13:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713967156; cv=fail; b=pKDdcfUxMSsXJHqdPLpU1F8lOixdbnFyTwu+zEnKaZoIAxFdfl0FaUPIoc6ybVwC4vw4f8+e94rKczNo178YRJdG2MBpSgVpCnAWEPBO86xdbZxLY7VWzUVNjY8oBdXeueo95C1U6JJaH5UU6tK/D0UcB67OTNRBXBJhCMtROC0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713967156; c=relaxed/simple;
	bh=o8oAuVd9DrItd3fuErxNEmfTLBF+6dzb8/4QvTgS0w8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=LqJ2G047RJqRJ5RcAqIyiKZWZ9mlzu2vTGIbt4FqHYzjZwoRIDYRmGe7LKjITmhW9wBqe7Fz86kS/wAZnkRUg7cgy/zJimNE3tizK5HFftoXcEgTtE6a+dGsT0imH00MY4ouTMyPqN25Kc87cRbQZPL89EzA/9lPa6KwCfu3hjM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=AhDv7NwB; arc=fail smtp.client-ip=40.107.96.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iIEsj6YcX06VPF6EL4G0qr0pbabw4zFm3O1hGA3lS6Hl0rj43R7vzGipJxQnTlrN3mDSyE6MraaQz38CksxX57CCz3/69TIeAXMSrYjOh9ELispBbfxUDS9tUlcHfIY2zG+RV2SdBk9orm3++Ni14fOdxtxt0vz5pZEK5BkqvKqAG3633xxXAERdAfGxA0Jm95giLIl0aRSfXQW42d3CETKDPOpSm2BKDpTureBzjk1+OCdYgSN7uHZKDb4db05GfNpO4MBRznFm9ooh671CH+wDj9LhDkn5iDJOkgiH+4DBhMbDnyEkAOWglj1LwXa2jxsd0Fixbyh56Z1jiZEYpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qX0onZFIfHAzHJ7dhG3s8hwERmZdP0+ev/s6c4qH/1M=;
 b=ZlAXOkW3UcRsMZQmIC3Zpy1evua7PM29v0hsPDM0ICZrM1t3T8oIDImuDNzGC6m0QLLVOKbNeFQphRnBXWB8zrPNqYkr5OhHqCh3s5sKZGRrB/hKfc3w6dWK5veMBBuJmX/PmdkwlOcrc6BoRGpexXM39N9RWcsWdzWdxfm1CX+AvwURwzPVRplrGfceFWtzycrgKemlB7MnLD+4TXLhI8NXJg7U+z2wZZL4fAp5t8RJSAphJMMI+OqMe4+WCPPVLc65DeuJdXKsf6gOentg3mSX6BXJ1gdS+3X5RzLj+cH/4UfEeRAZ9GDgDdHg1/mIvLOKhJ1EjjN/DaQn9t/q9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qX0onZFIfHAzHJ7dhG3s8hwERmZdP0+ev/s6c4qH/1M=;
 b=AhDv7NwBIA+l0rUXKcZgehZ2WKKQhBSzs8FMgNXelafxnWJ+hxNxRe5DivhRvvvxeWID2CoNuYOMfKBBiAZQudlwYsEECWp34inHDzP7//4lgw34dHlg9Q8HGCPoVaWcmUbuRq6/yMyG3csIh3q0YEXbwQCYTULRtY0+bZQHyAxljgXrSJpp6eXtFFLCfssp4ma9e5JT+cFGFgtu8HmAN9kFfmCKpPKSrtEEF9wrhBQ86bxTCQBASJajp2fD3qJRLqzC0Usjqjeg4KqH0u67Hbmwj9WuMK7oBgm6UXagBvUMDR/61LvFCbR9fY54RphnxOSBAZPhboz8xycIOZq/RQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by BL3PR12MB6523.namprd12.prod.outlook.com (2603:10b6:208:3bf::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.44; Wed, 24 Apr
 2024 13:59:11 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%3]) with mapi id 15.20.7519.021; Wed, 24 Apr 2024
 13:59:11 +0000
Date: Wed, 24 Apr 2024 10:59:09 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: "Tian, Kevin" <kevin.tian@intel.com>
Cc: "Liu, Yi L" <yi.l.liu@intel.com>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"joro@8bytes.org" <joro@8bytes.org>,
	"robin.murphy@arm.com" <robin.murphy@arm.com>,
	"eric.auger@redhat.com" <eric.auger@redhat.com>,
	"nicolinc@nvidia.com" <nicolinc@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	"baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
	"Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
	"Pan, Jacob jun" <jacob.jun.pan@intel.com>
Subject: Re: [PATCH v2 4/4] vfio: Report PASID capability via
 VFIO_DEVICE_FEATURE ioctl
Message-ID: <20240424135909.GL941030@nvidia.com>
References: <20240412082121.33382-1-yi.l.liu@intel.com>
 <20240412082121.33382-5-yi.l.liu@intel.com>
 <20240423123953.GA772409@nvidia.com>
 <BN9PR11MB527649B15B3671D02BBF9F6D8C102@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB527649B15B3671D02BBF9F6D8C102@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: SN6PR2101CA0013.namprd21.prod.outlook.com
 (2603:10b6:805:106::23) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|BL3PR12MB6523:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c2f13c7-5c7e-4872-68d7-08dc6466b7e8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Nl83wWHZEfCzgANF4fioKQeg/FxBZC4+L+QXqXm5XXO8XqPqFSYEeZ1Etfzb?=
 =?us-ascii?Q?CBebdUqiFfMi4Q4/hQsxf7Vt18ozveYF7ZWbYVQeHJ2ATXpcnrRTbrr+Uvk9?=
 =?us-ascii?Q?9iZKP2MKs4ThakfAcQAie03Kx5kyL1cwn4uYtWg2tq+TDz0AXAqoSvAGNyvS?=
 =?us-ascii?Q?XTQdF6w5zGtyeq0mhrJ5DCyq5/wEr3n3c46gjZm88/PWPL5TyRN885Q/Qk3q?=
 =?us-ascii?Q?S39qwHI8959lEht3oboaFcUDlojFiN/Q6040+OX+68pJckhvOZyGzkbrni40?=
 =?us-ascii?Q?tOymmGpX2tjZCOx2oSBSl/0hKNuvqDn4wzkiPXD8GqrJDEolDk61rJo6GEQE?=
 =?us-ascii?Q?VP/wwpINI+riUpv4cPlvk1c2aY/suLYy3bE/LNlR12wilql5mjM5hC39ZTYU?=
 =?us-ascii?Q?eMx/Frun8FNhsp6pmHe2PWSQwkhKE38TNfxXW87WLJIoDag/AE0QiSkMVris?=
 =?us-ascii?Q?4QebfTIzbbwHJwrJSWPrJImGohIJ08QrU+LqWzmFOKeLEkONLzEPP6C9E4Uq?=
 =?us-ascii?Q?GXefsUaNCZ4Bq0+43qICMgPuPv+rFkV0LztVj4Y4YLdxNZm3pmvkEI3lCVcl?=
 =?us-ascii?Q?CvJfZP4AE1XEnSoXbSO9uYc+5/ynd2Lam9hq0KHfMtGhHoDVEkj3JC1EmII7?=
 =?us-ascii?Q?rsC1sQidvEAsVN2LmoWqNGNF3hnp+I314K3iYoYBLsOz5YEdycFB0gaj5H/R?=
 =?us-ascii?Q?5nRR6W9yvlqyHez0OIs7R2hbFFuRHDBsr/RKCRhDD4GMhtsRvPYM4/7MkNU4?=
 =?us-ascii?Q?HRffCXXk2jn2CUxFR+ExSedIy419s/PaawfXQ9tOfWpneug88PZ6esxf6fqz?=
 =?us-ascii?Q?sD9nDzioedXBavEXhnYhs6YT0H/oAEMKGQjL8UURLM9v/Q9ECVLnH5JMlUYI?=
 =?us-ascii?Q?Lq98mzZRHAW7DEjPkfFcNDkxbPNcKGkbaAUs7dCDYxnSLQBSgmuLHth8IOPo?=
 =?us-ascii?Q?rPMJ6MEbc/KZsIxQpOhCiwv1lUxjK7AeBWXI0oZPIIwwX9eqVBf1B2A6+zUs?=
 =?us-ascii?Q?DmIgSVWiwLede7GVQST3KCyWyQXUtF/3x0Xx/kh6rNlVPZf4WOP3LlUYdW2I?=
 =?us-ascii?Q?wGTz1IK8GGrKfQlX5SbBm5upjjTrZ4rvGDR7OO7mp4es9vjB8QjXiNrs6XAn?=
 =?us-ascii?Q?5zOjlu9KoTO/oPdCQtSAQP1HhlBTBQ2Q/YSO3SV0vBWof6/yyQbDb4Gwgqc2?=
 =?us-ascii?Q?cI54oVDqzIFiRSNUHJyV5N5rUxmgSHqUIbSO+hkIP49R9JSoQQc07GXMIlDn?=
 =?us-ascii?Q?yiWILyOL5SOsP6KQ2gRZuawuJaa0kFBJXcJPgNumsQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(7416005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gACLivn/qGA+ninGMW33fQzzxD0R8ZHTeTO9KEErSsg5kPd2VhEI/Q1MG994?=
 =?us-ascii?Q?rGiaJrGD6sX3iJ/sQOkYyawlccK8N2Z8vWnIubkr87mP3cpmyWNopg0w2jo4?=
 =?us-ascii?Q?s5iGcs0s2kwH1W/ZvALy2lfPu5V9YWPRkos8onRyxIY3jbsAz7nCBqexDs48?=
 =?us-ascii?Q?UyKaIE4uEknXMWx68kT95SEsdzBgKpur07tLKko+MQ4QCnqZ6cB9c2X/Mm3m?=
 =?us-ascii?Q?ju+AlweRYf2QjNdD42YIYkQ0TcdQSA9MILmjj7Q1kjbVB+a4A/MrS8bsoD+T?=
 =?us-ascii?Q?XNfE8Dp8iowtBukZnB5wssNBOh3GFZVt7iyQ7sVk3kLfZGA52QvCazplKvsW?=
 =?us-ascii?Q?ayL7ZOnibUCLn2cUdsA44ELNDff5CrIuUauDla+UAHY7DuYjqKf43y5QIjJ7?=
 =?us-ascii?Q?8MrJfAAAMgPLY2+kwnQK9VUWijgXhkUN7Abldb98slP2aLRvwjykd2eIeBJ2?=
 =?us-ascii?Q?T8kD65MPy69b4CEzT8QyoNu/kHpimnvHWFdRi4efkBJszr2pSRvAdJkVwiS6?=
 =?us-ascii?Q?U1x2SvoIW8DJWwv7569JTss3CbfV8maxeQY1BN3vIgWYL42VqMz4mqpqqt8e?=
 =?us-ascii?Q?mzTIaCt5QtUxAxhhIf22KQy4+QM2OPrzesCttfF2W+1FTKHJk6ra/mzBtIio?=
 =?us-ascii?Q?MCQTVBePUdNJLvBPzvwJMw8HILsS193RjPnGMMEynnQrryaNqWZwWjIGESpE?=
 =?us-ascii?Q?WnfuZTpsgXqt3aydVTLQWjhU8g62CQdddyqw0ftVY4+uBY9yQBYPJszCDvSw?=
 =?us-ascii?Q?8+LBTeERYnNTirLybGwmYyOrW04Cq0hfmbd3lKVzCH6BL79GAf2PcrcAU6JI?=
 =?us-ascii?Q?qGO/WN1RfxbD+YfdC5GXrKJnVujHtVYR4Im/9WV2D3dhGHYbnEdKgoqfNxaz?=
 =?us-ascii?Q?74nJjvqvTQZEEYBRPyc77zkNme3ycBWD5bKkNSEvZ3TeW342kf3r5SRN5T60?=
 =?us-ascii?Q?EPn+MnVCLSkPAaIYyYSIwWMAM+7MCbudOw0M+UvsX+609wDO2HCViBfq1PjW?=
 =?us-ascii?Q?PFN84xpGCaU1ziThRuBAWrSZKB5vgtJ2sm4cLXcuLEg5Jzc2hBDjnjC9v+9D?=
 =?us-ascii?Q?rFZaUIw3DXRKV8kddCSEtoEXeFstOd4g/Cnm7O11U84MdwvCQa+Kv9tNCKum?=
 =?us-ascii?Q?vFUt5v0UFEX36nObqLI7Jxe7wQm5gRBTa4wNwUiMfiJrdR3/HOkLwGA1VFhY?=
 =?us-ascii?Q?NR5J7aNfQrpBZiJMsWEJEfy5zSaTY0Y13nErcaJrc3VW9lhnyC0Sa+TvOwKT?=
 =?us-ascii?Q?7JwyppGBT5EaY7myTmMm7qQ6qdcBn24QNc2cwInItvoTwdjB2DD6Qm2FY91D?=
 =?us-ascii?Q?FPxgf7DbXhmXGoBQFNdKikcfimrsPe/nifyAojW1frhbuwNnVXoXX3AkXUQF?=
 =?us-ascii?Q?UN3MBa3GBQakLTTj+O2w+/C0z8E0D7fV8mwwcimpknTKsk9XrnSqokjUcR65?=
 =?us-ascii?Q?Qv9T7DIln/ssYMcnxzzomR2lHGfdYYF7m71+/kftdCMq1m55rpPTmCsgV7tP?=
 =?us-ascii?Q?TR5Apzu3xz5iG655DHMo9uVCRzPu+rcrcZN/d4r4RMuXsT+sa4Lp3xC8692T?=
 =?us-ascii?Q?ZgGRRzwpPGGTqG9XBYo8AhcnRsxn5daMqrkrszgg?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c2f13c7-5c7e-4872-68d7-08dc6466b7e8
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2024 13:59:11.5593
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2sQOh8Tp1l43AOR+Y3fSVPpGduW9pDpMgk8/AOV/7vC6YOXrsWov8OxCRVDBlzH9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6523

On Wed, Apr 24, 2024 at 12:24:19AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Tuesday, April 23, 2024 8:40 PM
> > 
> > On Fri, Apr 12, 2024 at 01:21:21AM -0700, Yi Liu wrote:
> > > Today, vfio-pci hides the PASID capability of devices from userspace. Unlike
> > > other PCI capabilities, PASID capability is going to be reported to user by
> > > VFIO_DEVICE_FEATURE. Hence userspace could probe PASID capability by
> > it.
> > > This is a bit different from the other capabilities which are reported to
> > > userspace when the user reads the device's PCI configuration space. There
> > > are two reasons for this.
> > 
> > I'm thinking this probably does not belong in VFIO, iommufd should
> > report what the device, driver and OS is able to do with this
> > device. PASID support is at least 50% an iommu property too.
> 
> We have PASID capability in both device side and iommu side.
> 
> VFIO is for the former and iommufd is for the latter.

iommu can do the device side too, we have a device info ioctl after
all.

Jason

