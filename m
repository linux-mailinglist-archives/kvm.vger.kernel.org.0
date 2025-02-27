Return-Path: <kvm+bounces-39633-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E8B58A48A3E
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 22:03:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E51FA16A38B
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 21:03:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CBAC26E976;
	Thu, 27 Feb 2025 21:03:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="tPmsIiDW"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2061.outbound.protection.outlook.com [40.107.243.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A22B3225A50;
	Thu, 27 Feb 2025 21:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740690223; cv=fail; b=J8OSa+UfK2HSx5Dq+mf1x7o6/0sQig7lF5k2JZ5z5LcpdofpZuQYQbjRtqNffB5MjhHso6wMWYP9Dg2daS2Odnj1+mloL3ON/EgUcHOB3tDYNhdsiTHwzZPJE+3bZQIWpS4uUTDIBqhztYyI6Qe5pl3dOuqbOQ1l66aEqNdbDwg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740690223; c=relaxed/simple;
	bh=YgzVoQNXG1qKIgLGSqs517cAz8mu5fmjZErMswDKOCo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=SzuTx7OjVU0lhRIq6xEB9VYCBKLw5smZc6tNT0mm/tsOWRPJ5FAo7UY11DOU0toI2z6/IIWAjvtcMycOPfzpaTQEkb7Kuhfecyq+zIlBTcCgr3n46iB9gCxcNz+7ILd10eRBva4BpWcvMf6yf/7dHaSXREJmEVOVIpGaP/SDt9g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=tPmsIiDW; arc=fail smtp.client-ip=40.107.243.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Xdza57FlP/6yeP1nXQA8igpHl1302p99MDriRYh4oOCEUSLTCdr881GZXjZtCYsL3F3+TomrNqjKfFeOa9GNk39emNx7Q5nrNtq2RjxikYnXYhRUbLxOOVg8199DDI/ho3APdpEiwoso4O29RG2itEfmB1/1/c5T7q0Lc7nGVU0FzQK6KIdA/fpJ8eM+MMY1AktfMNcqUFXFjHiTDyq7QfVa4po2q15xMxzW2Hu3zsHwvLAcX+k4fn68Mhfc89QZMexCq9+52mZQjQar2lExuU5Xf1/cwZR+4MiNZ3mKTxyTJIQmm3KKyZcBmj3+G+XvZIpdYEITmO91RUTC5AWsMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yarOgKWjGz88cOqyxMQqlUewe9DXgYHye0LwQMPZWGI=;
 b=u4Tr7GUk4pjZ4c+IjmHSDyI6QPgc0TqgHXojUlpCav3RMFqaYXTQYCef++/CVbEGskQ1XOh/wp+dlFO+48rAfgkcbWcFmifOunC3DTdWVlcIOCl5prdlfmEgIlNyAjcNP7znNZiYO7MhgIrfDHSFwC7Hf/ev/duNtj5PCoxO27OnkYQOCUme87AKvUqSXRZA/GUuAWkN+UGkcsNmqIAI5llteCbMCrFkBIccUruLWPRCzOItLdtQOo4I2A/ThvFGEwkvrxE1mWqI0ZHPmnJNh/WHWN922MUsCD2Unqf5xK+rGxiAMZKfl8ImY2b8n5phPDlnEfSXpx/xSdqxbySl6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yarOgKWjGz88cOqyxMQqlUewe9DXgYHye0LwQMPZWGI=;
 b=tPmsIiDW4rFmWNTRQ1q599cTA7gI07usP+EDwM3hImz/PoKGcTY1zAEx71YzWYOlAn4WEHBz4HOXS5eEQoaCHKkMhsN2h/WfsK5Sg6QbUv8gwEdD2Y+i3uuZySk3DVuyEs4yJa0Ww0JqayU0XNY1/xRddHmVZ4loRkmxnjJt0rYzxcexT0L0OJbXMQK4/ovM7PDAWRpWUFr3eFkOkACrWwn1PulQMqcwNgdmXip7IugNy+ps+7vyIHY7o80es7tNN2PX0EMzgx70n0uFXBExcFclN8yZ5plo4USr3XWKezkV822ujxIcTNCrBxTR0cSnv1Teu86E+ryW0aY/DdhuwA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MW6PR12MB8663.namprd12.prod.outlook.com (2603:10b6:303:240::9)
 by DS0PR12MB7772.namprd12.prod.outlook.com (2603:10b6:8:138::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.18; Thu, 27 Feb
 2025 21:03:38 +0000
Received: from MW6PR12MB8663.namprd12.prod.outlook.com
 ([fe80::594:5be3:34d:77f]) by MW6PR12MB8663.namprd12.prod.outlook.com
 ([fe80::594:5be3:34d:77f%2]) with mapi id 15.20.8489.018; Thu, 27 Feb 2025
 21:03:38 +0000
Date: Thu, 27 Feb 2025 17:03:36 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: robin.murphy@arm.com, joro@8bytes.org, will@kernel.org,
	alex.williamson@redhat.com, iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v1 2/4] iommu: Add iommu_default_domain_free helper
Message-ID: <20250227210336.GP39591@nvidia.com>
References: <cover.1740600272.git.nicolinc@nvidia.com>
 <64511b5e5b2771e223799b92db40bee71e962b56.1740600272.git.nicolinc@nvidia.com>
 <20250227195036.GK39591@nvidia.com>
 <Z8DSGF0tGgvkJh41@Asurada-Nvidia>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z8DSGF0tGgvkJh41@Asurada-Nvidia>
X-ClientProxiedBy: BN0PR10CA0020.namprd10.prod.outlook.com
 (2603:10b6:408:143::11) To MW6PR12MB8663.namprd12.prod.outlook.com
 (2603:10b6:303:240::9)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW6PR12MB8663:EE_|DS0PR12MB7772:EE_
X-MS-Office365-Filtering-Correlation-Id: f8d002aa-a3f8-451f-2407-08dd577234f8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?HqBpIgA3zsFB5eODrXOaJ546mu4Yho0A+eOzsbVDattvh07GR9pDEC5ROH7s?=
 =?us-ascii?Q?GGiepLwiRjPR/9J7v/dxALo5d42hV0yWgu9YhK/QK4HbXXTpbII7hp0jgd5B?=
 =?us-ascii?Q?sMm8IQOd4s/tTNOx+5XNs3X3KSEFboKNI2UYI9h2vzqLOGpdZLMG7Qmi9P7I?=
 =?us-ascii?Q?/yYcKasqOlO5xue1oGJt5kq5ImNpnWSgZXBMUTHkQK+ZjV+A7fNfJcyARn17?=
 =?us-ascii?Q?hTp86Q13VB0pec62BaSMXqK+sV4a/OcEM8EDMqrfCFtf6Op/c4IkgdHGJugE?=
 =?us-ascii?Q?cHcStb7juIN/Nhd7ILtE98dOuHWm2ZLXUn57rTNKzgwjz/hVV15293a7O33l?=
 =?us-ascii?Q?k4h3cC7Nn8vVWsL84lmf8g+RsfXZJHcYgsepVpjyKvYCPwG3geuZgyDig9qM?=
 =?us-ascii?Q?S+zwwNrtDYycmmtQhwf8MPtsz9ObUWZW8Cd9SH1H/GXdysYUvoVzlEH+jXRO?=
 =?us-ascii?Q?8vIlWcTgaTMe8rYAwVeypBVnPQsXOQqI/scKUtNf7j7bXOW8BMm7279+AbBh?=
 =?us-ascii?Q?OnoHQ4GZ4B/gOWpLlEfNfdL6f1LiOkb9Zsv6MaPrCiyJVt/WMvcKV96+LfqS?=
 =?us-ascii?Q?GFtsrIjMX+9Y9rD1XggFx1w4CPS9fkjUi/Q5KshJ6/50/n9qL/DmOfZOGnYA?=
 =?us-ascii?Q?iDC+5EzPo4jKGOz1Kz7iMXQ4/PTQWBqNWNdkqX54bKWGAE/EAYUgVxR5Adut?=
 =?us-ascii?Q?cxtq2+jewJJDRIXt2wJylPg+5Q4OJGPD6Ct//RElRCCBkSwCyDnCo8A+MIhn?=
 =?us-ascii?Q?dtyVCSEpvloNjP5fTCuvw/NFwfSn4HpCq9BD26iZOOzN4x1Ern5yUElync7p?=
 =?us-ascii?Q?JQlHebV/+GkPORGhbxY9iy+LmZIjLoNEcnGtgd4NZm/C94edJgOR+sUKf2pX?=
 =?us-ascii?Q?Fteh+eHGFST7awk2I1ioKFSMbNwviPZ1AlY/aSYD6/E7+1CN6HSjpXZv0twI?=
 =?us-ascii?Q?Uy4rPDzIg9oEnZF6gER/Zf/ktUcF8twK3ZUtcXdgtA6jxTmZ6ZyNsAoX3/WJ?=
 =?us-ascii?Q?ZbSs/ECqmWX3XqH4ulb+WFuQ6zU53BQHgKAI7P2XklgkcGHfcj11QYOPESon?=
 =?us-ascii?Q?Jlag9Do8qnJuQnqd9x9TxoTIQtVfGMyheV2Ph7T7WW0IiGqCEqoK0IXl6uZz?=
 =?us-ascii?Q?00PsgW18iw2U1XUBZkT52HFKExx7c4ARtiSZI9g1ZVHidytGC/4YeHuV5y6s?=
 =?us-ascii?Q?GZ7/eocUOmc7R8syqhGr7iR3xdcm4R4A0wZ8TpZ+sPzbugIUaELEVtq5/MCY?=
 =?us-ascii?Q?OGeEWSlzxCRTIbivVPZ5l9n1nSHMvyTOJb0p6WcXnSDGu8c4aWeXt9uBT0TO?=
 =?us-ascii?Q?9nEfjRk7Nt9IVQKkXMKo/KdJZ2FLxhMHMb0vSiN3rQHSHyxRAvkmeOYkPd1O?=
 =?us-ascii?Q?ere8+URTuoMje9A8ewaiUhQFjtNJ?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW6PR12MB8663.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?d24bm5J818t7uAHYhLUIielLHNLjfxUyM2CiMpaYQVOBW+rCc7AixnEHNW8O?=
 =?us-ascii?Q?vUCsmdPbuevs8Nu+6SR+Npy6DEzEP2Iz6B3fjYkJDPtCaO7dtIIh2HYy4Mi7?=
 =?us-ascii?Q?9Ghsj7WSZ8AKgaWR5cjTXBqQAhsd5KHr/nlqbFVjtuoY0vddyHN2jin9hfrG?=
 =?us-ascii?Q?PVmjYsrIvrB9ndlZNHv1buKvvAM3fF5yz1OTJpLSnEaNEo7z7oEWN8PXYzYS?=
 =?us-ascii?Q?CyJWMkuQzIKyu7AoyFCQp6RlXPj2mrNqcWzzawMXwC561w9PT1FYFOnq8tz+?=
 =?us-ascii?Q?ro6pp0RCkDb95R4c4FzQbpmpdRtYsovn/LvLkFJs+L1pL4wAXuM2q58JLhs+?=
 =?us-ascii?Q?QfQwp+WR0tmQ9+dUoirdC/d2m+N5Pmv9YEx7sfxIQ/jWtEHlUv+bEjQDYbW0?=
 =?us-ascii?Q?ARnb2hsiFTudvKfLpPpo4TPXnazAHTq8b68HAkDMlpOfP3rp3z9a++FmkMGx?=
 =?us-ascii?Q?QMu3S0nnElD4vJuCu1ptJ1eBysuxjGp6qaqXdWicxaXXFM4g1OKvYKUUpVJ1?=
 =?us-ascii?Q?EvA2+C2WhUT8um5EgHCE19A7ZphsZbVlPgFiDfSSExhZx7vXpBSdD1k4Cw7M?=
 =?us-ascii?Q?MO3U02+tLHvjYqlILBVsfKAo0+H46H+PacQafUjLD+xnLsj1V+ZPKPbA3OOT?=
 =?us-ascii?Q?giXWRVVJZBuBVvBsvYoZGbv3yQATnwS8mRbm4FsIHyjctzJPFtwgAyx+6jiZ?=
 =?us-ascii?Q?0nT+AifKOTFY9M+QTPUNFshmDh/9hu1uCFL09G30AD2CurAON8qky1tZvX6L?=
 =?us-ascii?Q?brwCjnIApj3qyXfrCv4D8MFvSky1UG5RKeWpdvcqtP4C/I29V59A69bjLT5a?=
 =?us-ascii?Q?LXJThVoOXNWa3Z1E4hhOKMIAvHa6LLr/YTIzPj05oUCD872oOlN76q+5i81R?=
 =?us-ascii?Q?uLm8pexH3IqMRPgUzavCqBugJ51R0d8tTdyWVSVKaTZs+dcRpylaSBVU4hJE?=
 =?us-ascii?Q?IsKr65hVpaqtk6SIe4mTa84r02BD/qRkUOk6G82rFZlncg9chS/l32jRprWY?=
 =?us-ascii?Q?7QKLCGftvR0Pdq3BNV7fYBKiyUXh9Fg/6+Tq9f+qCroq1KPpAe7tStLg6PaL?=
 =?us-ascii?Q?acBQEjDuoetaY9ohbFeO83MoCpKEd3FSEPIUqn/zjpnjoj4hlnCpkL4jXpMg?=
 =?us-ascii?Q?OCgRvQuXDZsOavSKri6fybDJsRuj3DgRIDFBKMHUHJIZHq1Esq2sgpRSe/6O?=
 =?us-ascii?Q?el4L3vyn9DKbDqowSA/iZ9yrsBLH9Rw+dE2BHcRzJUq8FOQIXCRAT3XT/4px?=
 =?us-ascii?Q?3rbmrV8zTnMrhJLxTT/X7Qz5Weouf65Ra4fU83JbcNOw3wJK3dxerORiAIxD?=
 =?us-ascii?Q?ofg3W56ngQYG3SXfjhv7jN0YGOngQbLVKZR4fS4SlqQ3JVdkQ10R4BJBgHxy?=
 =?us-ascii?Q?Rej4pVnrpnUIHsGT2qeW98BICFDOs0nLBkPvKrvPpxUyfL/V57UuM4lAesKs?=
 =?us-ascii?Q?qH36r3Cs+UXuXT5UlBU3uWZmDMwBrFQ7LTgxa5AB07p3djVZbliUb3n5MIuP?=
 =?us-ascii?Q?IMB7eBYWU9dmiZWSFrXADoPAD+/frlSHleO2jHD0L5/QTxZFL9FNV30rT6Ra?=
 =?us-ascii?Q?Cl/R8jAI9nBrTyeEuywUUS6A5TJL8K56p7oUOEbK?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8d002aa-a3f8-451f-2407-08dd577234f8
X-MS-Exchange-CrossTenant-AuthSource: MW6PR12MB8663.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2025 21:03:38.4523
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4DqRRYPvZipL6afBFMqOJnkk0+l6XXdQDC5Fo9Xauyla8phCl6EvHGwA4fzza/Oy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7772

On Thu, Feb 27, 2025 at 12:59:04PM -0800, Nicolin Chen wrote:
> On Thu, Feb 27, 2025 at 03:50:36PM -0400, Jason Gunthorpe wrote:
> > On Wed, Feb 26, 2025 at 12:16:05PM -0800, Nicolin Chen wrote:
> > > The iommu_put_dma_cookie() will be moved out of iommu_domain_free(). For a
> > > default domain, iommu_put_dma_cookie() can be simply added to this helper.
> > > 
> > > Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> > > Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
> > > ---
> > >  drivers/iommu/iommu.c | 11 ++++++++---
> > >  1 file changed, 8 insertions(+), 3 deletions(-)
> > 
> > Let's try to do what Robin suggested and put a private_data_owner
> > value in the struct then this patch isn't used, we'd just do
> > 
> >       if (domain->private_data_owner == DMA)
> > 	iommu_put_dma_cookie(domain);
> > 
> > Instead of this change and the similar VFIO change
> 
> Ack. I assume I should go with a smaller series starting with this
> "private_data_owner", and then later a bigger series for the other
> bits like translation_type that you mentioned in the other thread.

That could work, you could bitfiled type and steal a few bits for
"private_data_owner" ?

Then try the sw_msi removal at the same time too?

Jason

