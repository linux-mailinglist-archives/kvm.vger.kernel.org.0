Return-Path: <kvm+bounces-64424-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F9E7C82448
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 20:19:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4D3023AC6BC
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 19:19:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 762802D97A4;
	Mon, 24 Nov 2025 19:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="QJPKD3rB"
X-Original-To: kvm@vger.kernel.org
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012051.outbound.protection.outlook.com [52.101.53.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 236512DF6E9;
	Mon, 24 Nov 2025 19:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764011816; cv=fail; b=dLYim+a70/lCJEPaatS90krZOqwxhkXSbTNXROUKDu4v6e5TKz6v44XPqXNUB89qZQMa4jFjYgLFkE5Mi9twSPFC4EDCBtDbp6nVw6G67aLGHu4OA6bQzNg3lNgzfg42/k8IJ5JzB7NadJXJKRpnroE+mBHp3bfJWWUZ/Lh8ajk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764011816; c=relaxed/simple;
	bh=akLlukVNOmMqTq6FjuDyjf4LpspU13r2IIaX6axiYUI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=O6RY06v7hYJOkleaHaK+TduNp7qFaUBGb7Ydl9sl/PEwZj+sUGfdp3Cv5SfVbVwYrLRDK48UF2i5VJ2csIr4QOj9cI+xwQsj9UvLGvDLZoqKN5NJaLgRlsxKwgh/WmXsMDps6DkV83SiZJNLMmxy9R7u/piv5H5u2WMsm1pJn64=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=QJPKD3rB; arc=fail smtp.client-ip=52.101.53.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xHNc2TM1e6LiJpJkPSRrvCCKgFujvGshbOX1bkHu77aTw37RSJjwL8WKmTopvY/0UBblmeXipp7nj0YLs5i7AGUOzEbV90q3tslO3MZBMNMYbGBf46/d5NqArwjFTVYTvm3/4C0M1qbScWwLfA6XA+UYEcRJVz7t15Q2al3IroGjydHOWwa3JH1g8C+J069bRhphNSaKj2RSb6iS9I3pOB410fxlHtj2ljbtaxsgg1y06EoxbvxrER8FHcx4ynSEEwFCo1cMLs2UnHsBUwW56lmM+Kg9xv3lXNoR/dCxtFATVY2OrMQu/4beTrFxEirHfLqfhBoFGcncWmPq9rhX3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CqIMSxLGCLAWVTpX82IpWtga1+1XTPQYuFHrDA+wc/I=;
 b=MFSFnFylsOINuFtxySiCreA27GEoQtUPE6ie0oireiZeR9+f1hPSwIj3PttfYnEVOsADse/C6KGLYSGWkCWO1m8tipB8RJCeY4Ljlr3ZkXUGOCUwkKp/myUb7GtSWNYGuqaaJDCTvuzq/PobKZURm8xx20bkhPbo8oVMJXFMslWzVU7H8W0R/kokjP4ZEKPA2ht/YQi1OyAbwLZKpSKQir5o17AN/yZmDI26DGgSg7RB+VJe+sTnwv/JQoKgjmJPLpSyVGasnExJikJbfrFWNHOYMLmMQ7dKOhzp1i3eN5i7I2AwcXuO3hgNzzS1Ysd+ki5BlpSXlE5OOfzrO03Nzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CqIMSxLGCLAWVTpX82IpWtga1+1XTPQYuFHrDA+wc/I=;
 b=QJPKD3rBCUOAglX1zOlq9myHKi7oro2+QjXZ3ys6dMJ5f6Vl/MQd/Yqc3xO0ijPjeG4VU5HJ4SeZ+Ir/FVMsze5zRC3+vGNb1Dv2bx/1M6J8eDa+inphmMx8+w0auKhWQvhxv/YovS3LKbb3/mNW45OdjjvAgnOOWCHBYCqEF4p1ywAae+E8JtJR3Y0RSHQ5I3e14hNawRML5UWAencMiAYLWq16Y+9VdJhuiocj3/J5RsH9nXIBLmrOnYEank7Q8LqkWz2CY6UZqAzicddIXA17Ytoz+x9ND6u96wPxq1YUUO+SI4/vh526UzheLNX7fD33gY7hCVwYj86g2h1HNg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB3613.namprd12.prod.outlook.com (2603:10b6:208:c1::17)
 by SJ1PR12MB6340.namprd12.prod.outlook.com (2603:10b6:a03:453::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.17; Mon, 24 Nov
 2025 19:16:49 +0000
Received: from MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b]) by MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b%4]) with mapi id 15.20.9343.009; Mon, 24 Nov 2025
 19:16:49 +0000
Date: Mon, 24 Nov 2025 15:16:48 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: Baolu Lu <baolu.lu@linux.intel.com>, joro@8bytes.org, afael@kernel.org,
	bhelgaas@google.com, alex@shazbot.org, kevin.tian@intel.com,
	will@kernel.org, robin.murphy@arm.com, lenb@kernel.org,
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
	linux-pci@vger.kernel.org, kvm@vger.kernel.org,
	patches@lists.linux.dev, pjaroszynski@nvidia.com, vsethi@nvidia.com,
	helgaas@kernel.org, etzhao1900@gmail.com
Subject: Re: [PATCH v5 3/5] iommu: Add iommu_driver_get_domain_for_dev()
 helper
Message-ID: <20251124191648.GJ153257@nvidia.com>
References: <cover.1762835355.git.nicolinc@nvidia.com>
 <0303739735f3f49bcebc244804e9eeb82b1c41dc.1762835355.git.nicolinc@nvidia.com>
 <d5445875-76bd-453d-b959-25989f5d3060@linux.intel.com>
 <aRTGwJ2CABOIKtq6@Asurada-Nvidia>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aRTGwJ2CABOIKtq6@Asurada-Nvidia>
X-ClientProxiedBy: BN0PR02CA0022.namprd02.prod.outlook.com
 (2603:10b6:408:e4::27) To MN2PR12MB3613.namprd12.prod.outlook.com
 (2603:10b6:208:c1::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB3613:EE_|SJ1PR12MB6340:EE_
X-MS-Office365-Filtering-Correlation-Id: 15c96b5b-99a4-4e6a-0a93-08de2b8e0442
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?OVCuPvg/ZpkHUYba+K2cioPoLRasuHpSJIV5w9TDAGRAbEDpVboFUQCX2X9r?=
 =?us-ascii?Q?SVnlM42VQpK38QxwdI7JVzZMdBQ/GWuuGImghEFbpaJ5Pa9/qO4w+o+cZfKg?=
 =?us-ascii?Q?Swxlqidy0xeb68b7wNIesgL+HJEdI5LUnGkwGtXFjU591urDZu8/wSiCsykl?=
 =?us-ascii?Q?PUBjWq255HqHpHxzguslDtHvodJwWQ2p0eejNfJ6/huMZtDJ4w6IYj0Pbofh?=
 =?us-ascii?Q?f7Sln7A9J47XrLTTb1e0nYz1ixaLkzuOYAbLFk/UOfRcRIIenFxSfiMtyWxA?=
 =?us-ascii?Q?Caowx311rex+/Q+7VcH/FkQ8fzh4TUi1qrFfTyTD9HKa7g6WfAMlRgeUdtmq?=
 =?us-ascii?Q?cPEKiaEww89+cdhoAhZ4g4haSjQ2sqqfgGXyJy1lpMDGE+9PdA1xWPqm8QSy?=
 =?us-ascii?Q?9vOcQepYPsUNy0VYRa6sxFAsu2l9H7jwvOwXermGd/luyDN9cIpKKeLDoveE?=
 =?us-ascii?Q?t6yf1rAyCKP/4d5mqYxnHiWlsJegcNYufWDTA3MWhxzgCu3BSStgs68slJTD?=
 =?us-ascii?Q?6L6TFJZvMr06jIjIdHmouEnIhdvLoX38epIYbsVsM3xVik3ON0V1aDmawJgA?=
 =?us-ascii?Q?2CszyNLvBroCTcXhrxIO17dEd3DgmgoG7h6/QofWC6M1imy0yixde3d14M1V?=
 =?us-ascii?Q?4Wlm0+Whe+lvyCgO3R4BKcLtoPa9+FP9cQNX0xOPlZOM6JsIWKiD67ESERPs?=
 =?us-ascii?Q?SrePQ0nyY3zLmwnQmU9C3UhgMuZpunBegoW2lWgZ34uF9Uhbi2wzALo3NXk3?=
 =?us-ascii?Q?8YmxX97QVsW9DT7iO3PrzxYu/vbf3akENV8DNoofxkUlbM7J96pc3OJ6DyYa?=
 =?us-ascii?Q?qA29lBrGfyst/axKbIOqwuPasoYU3WScWUHJfmKTYAmvw4M+iQrvcm56fvzW?=
 =?us-ascii?Q?bX286Pu6BLEyHN/TlhrtRaGZvkrcbFXcmZhLct659pHOWU27Q7WD7RtAJ8W0?=
 =?us-ascii?Q?JHny2nC7l680/StrHYCCxIiW8lvXY5XUP1b4mv3bfi2WD/237WNn5AmIPWgW?=
 =?us-ascii?Q?FP5x3J/eggx43LJlykqpUfGN13WQTLwg+oPrQj5Crc1aaiflEGXgBQXnjJ3x?=
 =?us-ascii?Q?EpEEwH/F7rM4mIaocC0NY76UzT7xfFKk7RZltJLTTG6TJNBNVpARLTzmD0ww?=
 =?us-ascii?Q?7QCHShvxUC13QYrzDelHui65z0QD4zIeQbJQ+u2PN0TG6ZJumyQJXNBQaej2?=
 =?us-ascii?Q?VkYEvUGlXh5zu5Wx3HC7Pvkv0duG0Jy0YqGFELceTuIprTyuDQv855+b9Xz7?=
 =?us-ascii?Q?F9XVVQ/LxCHWALkYGuikczr73SVPdNbx3bRDb3xZjrkX8EO28N637BvChNQG?=
 =?us-ascii?Q?W1evCScEqMlF1TIGN/92DOAmnkTqAz8r0BUzFDyOsuMC7/ZC00OiFz96c7A0?=
 =?us-ascii?Q?Ib2wYhXXaT55xmMz0SxGTk+bK0v1jSxNcg7T2oOuwBP3LJeNSG/OejkGuTwg?=
 =?us-ascii?Q?4Exio4eFXjwNOmUVEUl1PrdAtToibtCiq6IndPyBrzs+L78ek4S0aA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3613.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?N+JXPEHKYikkpZWQMtliH3V1e/EEREOxEGiJCLloGfW/eXHQqcf2GXlrZ21l?=
 =?us-ascii?Q?4RqU31VNglTKBx0zKOcIvcZ+tdH2trHAAZMlz//yDs2KBBr64Lx7T8f5mc7C?=
 =?us-ascii?Q?ZjqJI6eRo1dfPNSiXaU/SDuBFV/UPHyxvtXi+/hCTroHgU44ivho4OJiIDIZ?=
 =?us-ascii?Q?6rn1V2JztpHLv8fESJ4y9Mb2MuIYS6kiSiVMb2XGRjfjHCUGK+lkXQiC+PPi?=
 =?us-ascii?Q?M9o8nEyO51DWujn2+Ds8t6AS2Bd2oRns1SFL8oBYj+uOSYuYgSzWRqNvJbXa?=
 =?us-ascii?Q?ys5UbkTYS/J6sem5vbI4oYfaXPVGxbvKmya8xMKAU7PNh2gS6PtgHJSUOGL+?=
 =?us-ascii?Q?VwvoEg4RYNrmQaKvy6XDej5db7zeDlPVB9SGyl95ODUJmsba9ADtv8OQE+d1?=
 =?us-ascii?Q?ibgJhspb2vvY8lXyd+9eVHM06q8NhqobP/T/qaGwKb4NG1yQ6nHy3BSzyljh?=
 =?us-ascii?Q?CJv37Arq+VQAtd2c/Mw3y63syTrqTffXNfdNJ+xH0qTi+mjjny6q1wv51pjm?=
 =?us-ascii?Q?ybCcIirZ+lEM0lBW04oioIV1JS06nHgw+XzWctJZ71HSdgiGxAsUITq1RWzM?=
 =?us-ascii?Q?VWYMByjPD6WfslRdCKW2kHJ0n0nXoeWUjRgetkEyMdiukQ7WU8IyaE5BMCEC?=
 =?us-ascii?Q?zg7sRTqHzRmXQPssGhvGcTErnneLpk9i2zyoYQtYemmAI3OiREChGAeqgssI?=
 =?us-ascii?Q?4JWC5Rf4v0WN+hA1ltJ4kArvjSUtWhZyNgXy0uz8aWazM68phhN6AC145Jw/?=
 =?us-ascii?Q?w3dieS0VdGrAIsYH/GMzibAU4WtSGUGO8w4eiu6uLFTKT9hBM8apA2VHmH+S?=
 =?us-ascii?Q?t6JmB9LxcXQ1TEELqcOJiPePwTVs8RP4U4kltykrVYb/7iCSeynISzUpn/ZD?=
 =?us-ascii?Q?jhaJEZghHbRc0s1txqcIva20AtUwYci+UUYz2HTt1cx/ntCdOe+nU9BV+oqP?=
 =?us-ascii?Q?1yyBh0GceD9L96EJ9i3WhomCMEKkhd2AWEvJVissAvnhgHp2LqPAt/b5t06v?=
 =?us-ascii?Q?ulHcOAlKlSu3L60VWRVTMhRV40PThhlllsuEKaMbWesHF7t+pr1ABH7iL18T?=
 =?us-ascii?Q?n5AgWEsSQlN6p876ZmrfFRSZcExvmvtOr8V9utrYyqPkc0e+9k6OBEHtRq7z?=
 =?us-ascii?Q?Z5SN11PXQ2vR3aA6cmdpL6Me3IM8BOUb5ZlkG/ivSl3p52pI/O2RdRE3nU0V?=
 =?us-ascii?Q?/FqzpiWRce+AI7iKN9WpNDq/218bwwZZMCI7MZ1F2lT4QfCr6/Wu9bGsoeQ2?=
 =?us-ascii?Q?+2JXR5DqqVC54WluiyeoUOFHNd1ezBtyvGho6cYr5kDHBoxM7XzbaQV7pMwh?=
 =?us-ascii?Q?5mEvXNmNCcEzw9wjJHbOrPIGffgjLaixLkDL8FJyuzvtbCX8XPndyU6FL748?=
 =?us-ascii?Q?HgreLS8ohNT7Ou1MH8tnPZ49qJckVS9OtlvkY3tuLuJIG70t2RGtW77CgmwB?=
 =?us-ascii?Q?/CKS0+0cgEyX4j65Lvahawdpd+g2X9rzXFTQdvWgdmqEjzEqC0VUdXfLWnZa?=
 =?us-ascii?Q?kaq99r5kn2RgDdJaSX3zSNDC8eH6XojQ5hwyJUliDDBmBt8loRrvdO03TOWn?=
 =?us-ascii?Q?sjw0snBkpVi+veELzAI=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15c96b5b-99a4-4e6a-0a93-08de2b8e0442
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3613.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2025 19:16:49.1744
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tgS9XQJA6uQ17BGNjPJJ4VLqe57gEOcGLHvdWM3Zs3dvfx8Epe+25BMPFzRukyBi
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6340

On Wed, Nov 12, 2025 at 09:41:20AM -0800, Nicolin Chen wrote:
> Hi Baolu,
> 
> On Wed, Nov 12, 2025 at 01:58:51PM +0800, Baolu Lu wrote:
> > On 11/11/25 13:12, Nicolin Chen wrote:
> > > +/**
> > > + * iommu_get_domain_for_dev() - Return the DMA API domain pointer
> > > + * @dev - Device to query
> > > + *
> > > + * This function can be called within a driver bound to dev. The returned
> > > + * pointer is valid for the lifetime of the bound driver.
> > > + *
> > > + * It should not be called by drivers with driver_managed_dma = true.
> > 
> > "driver_managed_dma != true" means the driver will use the default
> > domain allocated by the iommu core during iommu probe.
> 
> Hmm, I am not very sure. Jason's remarks pointed out that There
> is an exception in host1x_client_iommu_detach():
> https://lore.kernel.org/all/20250924191055.GJ2617119@nvidia.com/
> 
> Where the group->domain could be NULL, i.e. not attached to the
> default domain?

That is impossible these days, the group->domain is always something.

For host1x it changes the domain and ignores the driver_managed_dma
safety mechanism to do it, so it is kind of broken.

> > > + */
> > >   struct iommu_domain *iommu_get_domain_for_dev(struct device *dev)
> > >   {
> > >   	/* Caller must be a probed driver on dev */
> > > @@ -2225,10 +2234,29 @@ struct iommu_domain *iommu_get_domain_for_dev(struct device *dev)
> > >   	if (!group)
> > >   		return NULL;
> > > +	lockdep_assert_not_held(&group->mutex);
> > 
> > ...
> > 	if (WARN_ON(!dev->driver || !group->owner_cnt || group->owner))
> > 		return NULL;
> 
> With that, could host1x_client_iommu_detach() trigger WARN_ON?

I don't really know but I strongly suspect that host1x has a NULL
dev->driver in some cases.

I think the best you could do is detect that a driver is bound and
that driver_managed_dma != true, host1x should still be OK with it,
but in practice it only effects VFIO.

Jason

