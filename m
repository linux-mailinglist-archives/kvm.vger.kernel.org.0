Return-Path: <kvm+bounces-15661-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 63F268AE6CF
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 14:48:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E3BCA1F21D4E
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 12:48:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63FB5131BAF;
	Tue, 23 Apr 2024 12:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="cckOcuqy"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2089.outbound.protection.outlook.com [40.107.100.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8C7085C48
	for <kvm@vger.kernel.org>; Tue, 23 Apr 2024 12:45:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.89
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713876320; cv=fail; b=WDC6h5fn8MBoGKHRvqs84Zrpxxo424ilFd6x1ToJl2L/lhRJsLPMJO+nsASfRZwb/8NgxonI1XaGypjI/Ua2gflNSqkfGY6ZtuqTIT5v0YLwgcoW864ajqfZO1oLgererP7zudSQzn/CN3hbGYG4IW0jgHk2u3pTtU+tfyOO7Po=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713876320; c=relaxed/simple;
	bh=l7+dn0Hk7XxcUsQ8ssoNhZXFgpSewnpzEurCIfaUc5Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=F1GLy6jppMSTSIUk8X1fkXqF3r0/pqQaH/jQzTb/iJ7LJr11xLHX+nZjFjzolpvU8quQYT9P3bvGkshCl58zEg/PFZR+TxKXYnQIdJ3UH0vAtE49/eWQZelVtC/fJrgjvo2NgAz3pldIvGWrMEYfFMPAwMg6W94VONwTzaqIiwk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=cckOcuqy; arc=fail smtp.client-ip=40.107.100.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z0GcLhchVoWs+Z2gESnxzFm4Zg8fUS07AwyvqA8AiL/dqCL664dYaEImgErmctie4UgBI+1SgVwSv6SDtqrQy4CgcK40mesYa1r17beh8Fk9YZ2vvUK3kHDgYfyLsQ9c9DbTMhAFW8IXspKwoXEX+VMD1mmpC3PoK/4i1QN2KmMBaoHf5IUVw8h4BzAYxdXe/qTc9EdCUj8kxXSp3GoAxhrZ0g21WSwtVneFXk3N9lcmtX9dsXGA0I6g4wzsqAyUVGILnngFVhQjT31ajljhIFDA0hiCaAEMIfuwjmInv1tqKN0D4HwTiMS4V8eXtgTACcphyolZQh6c6KOnlwqwDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aCHykJszVtiPolJ8wB9i+C8C2Pep6VK3af2L0qFAjkE=;
 b=XOWNhMJEENVcu5d+8hHGM+NTEnBpV3Wp1yzVAJNj8p3EnhQ+ByD+kS0QX15zkeieQZZJ4JKvNus4x/SUy8hU6j5IlpFkRNgy7UH/uoKTc66/t7y4ZesdTEU8eOKkltGwlVuCmPVzqinZLI1IG1//q/B0ETi7HaXSf8BuER9EKCVFeKRu1/NgWbsimbULTcYzBHx/5g7xMSuWUCY17NzT3XMH7OuOd49MNdKgkS+vjm9VrEK3JZyH5msWwDMhriIUbuxEsfMhbFkRslKEeNKXW/9oLl7riiuuMJIYRjeGso80+dDAbnUbFCRplCXQfNGIQ4kp4jcZtaQI8uCXHVt3lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aCHykJszVtiPolJ8wB9i+C8C2Pep6VK3af2L0qFAjkE=;
 b=cckOcuqyA6rsT4SGzByFye1OsO9tritOWHwMFdOh77au3p2srhSYKywfL4e5H1KHbwKXzudVyUijqPZI3aOewC9gTZ8QbEAnmheuRfhiaXTcfhugqf512CkZN0Sjt02vBz1E66sqr88hCgzsYJBElqA89TePTPtVJrVQzqbcCz8hfhwLP7744RyIsq3i/8E5gE6lLjjyOYRMuBu4B7Dm29sR1AK574f9SQ3WhOHhLpt5O3K3wUS9hGGIPeC5U2MXTZd/2t+6NCG7f4JqQwKGzc6h6tDRRwlzOLaS4V0G61ubSz5UFWA4eQggnySOmOAPbud8SLnBeuSPJusEFCH3Bw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by PH8PR12MB6794.namprd12.prod.outlook.com (2603:10b6:510:1c5::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.44; Tue, 23 Apr
 2024 12:45:12 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%3]) with mapi id 15.20.7519.021; Tue, 23 Apr 2024
 12:45:12 +0000
Date: Tue, 23 Apr 2024 09:45:10 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Yi Liu <yi.l.liu@intel.com>
Cc: alex.williamson@redhat.com, kevin.tian@intel.com, joro@8bytes.org,
	robin.murphy@arm.com, eric.auger@redhat.com, nicolinc@nvidia.com,
	kvm@vger.kernel.org, chao.p.peng@linux.intel.com,
	iommu@lists.linux.dev, baolu.lu@linux.intel.com,
	zhenzhong.duan@intel.com, jacob.jun.pan@intel.com
Subject: Re: [PATCH v2 3/4] vfio: Add VFIO_DEVICE_PASID_[AT|DE]TACH_IOMMUFD_PT
Message-ID: <20240423124510.GC772409@nvidia.com>
References: <20240412082121.33382-1-yi.l.liu@intel.com>
 <20240412082121.33382-4-yi.l.liu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240412082121.33382-4-yi.l.liu@intel.com>
X-ClientProxiedBy: BL1PR13CA0010.namprd13.prod.outlook.com
 (2603:10b6:208:256::15) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|PH8PR12MB6794:EE_
X-MS-Office365-Filtering-Correlation-Id: 3796b71a-3c5a-4a37-ea45-08dc63933774
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?CDjkHkTFYS85GzU+iNF/ZfLKKSY+n4GCSeDsUg49WMPGGno+xs4OwP/xkZ9z?=
 =?us-ascii?Q?VMm7s4epTgPXL9ImwyI7eAPCscj/9yyZkzHJc5kYocjle5lMUEnhezJfi3Bi?=
 =?us-ascii?Q?SIl8jYQvehcbRRRYFEAOFmPvja8pxMKbxMtT8yFt4sT9jDoeEOfquQXp9kpk?=
 =?us-ascii?Q?F/2KTu2fZBfKbl+4XZKaDGM760rva0+f3Dax9CPsPhw6A9Te2sUAZJNG5inA?=
 =?us-ascii?Q?HEJTocOZfTfu1Yy5gkN5iR7zPkr8i+aOJz0qzXAD4FLU7TlwaG3N3KTtBZRu?=
 =?us-ascii?Q?Gc9wJrzvXyLpUyX5I4M1zbw/3Igain5KOyGVLRcL6P06vMaNgmChXl5R4lkM?=
 =?us-ascii?Q?9nHykTOOfirOuVkBB2hxXDSJQpBXP2mkVCAw/1j1+W4QqMOyV//Kk6t0bNCD?=
 =?us-ascii?Q?hfVr4zUv0SaF38/oTSM30L/V/j25GjXCeTYCdR++53/m45/z8xPwNjwKf0fF?=
 =?us-ascii?Q?xC0Dwn/mG9LQ2rUFgej12llqMa/BmGklMJBZLosDcMpLzfyPTDP2V+MrZw7a?=
 =?us-ascii?Q?TR26M5aPjyUiw3iLLc56QtX1MUUR8JFzAWct9G6i0jSR8GMpPgrgKQ/pj5h/?=
 =?us-ascii?Q?pzjtmO3l5JpPHQa+pW/tLFlTOQ7e87eI51eWaD6yunjzrW1mUrOGG4+P+iII?=
 =?us-ascii?Q?8tw+AVmReOX2eV55r9ZnN2f/vvHp7h59/90vtF7h6hZiatUzGhNF93Agh4ep?=
 =?us-ascii?Q?CjNQPxZc3jojCfK/8cBsAwIhBy9M1YRGm+HHUDv+dFOGv8F0U7AQBi3++9kZ?=
 =?us-ascii?Q?uaEFV18lcLt45BWk6Xj6OG5qoTNXmDtHJHShU1tNp4i0zRKqUgWQpK+z2xsx?=
 =?us-ascii?Q?+hXy0Ki1x/a7ArTP/NZFwxIzXxpKfFGfK1WN+VPIwzzrtk4qpM4YGydBXsWw?=
 =?us-ascii?Q?lEMBKZZ03cBhMyglV2JYgysxk7e04zTz3XKpG9IpiNV09sS4EHK2jxdk5zZ0?=
 =?us-ascii?Q?NmFVFhI86ifb7UxWFlQQmkG/gJEpQlI2/gEUvhjMzOYca3Ma6Y/ySByEpjzQ?=
 =?us-ascii?Q?uE4LheO2xSsC6q5QeIiWXlDd10aQvAdl6H+qkVCWQ9I4Zj8AGdUCsFy2s6KM?=
 =?us-ascii?Q?eXNKo6BdXFu3bvVGds2nDtc4a2IVIgzEt1IIIOYTtIvzWi+fnD6SlbuJwoIN?=
 =?us-ascii?Q?MTbAPB342cap5fGK5WO3qQmnTuuET7ULHsxjA9LZ9+mAG18K+xArBAn+b4Cu?=
 =?us-ascii?Q?xBJYKqmRIM9277IHvC7+r31VDtQsPtfTJF7lYkDOypWe/O6g4etluqURyBhM?=
 =?us-ascii?Q?gcsY8aClPHynigzw9/ycX7AaRiBXbv4vqZ7GOsmgkQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(7416005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?5Sv2gGMk7icEOJrKlQzO6QdLHaQrZ0ShWmQAs7BkYiOXQCNzAksN+QFQey0H?=
 =?us-ascii?Q?2yQpKqvRbPl4VZeskO1kBI2lgYbrddZypqqxfTU856pq4m4ay2vN3pYA9gxZ?=
 =?us-ascii?Q?Q74ZgHYc6Et0J/unhqApqPc9S32p/HTUjM3Bjse9q1QB0P3yIix6KjHCAObq?=
 =?us-ascii?Q?8UtXUVis6XJlOxKLL4QT7s16DNhM0BA8y95QQObqLMUiKelc+sa9IWwqKPC6?=
 =?us-ascii?Q?RwhheVa3jjNiEvpJbYlTgEyyHRfjJscAe+3WcEn6RcqXt16EmR4cP0yYk7l+?=
 =?us-ascii?Q?SI5CSy5dLH2iEu0EwOEq4z30qIVbG1XU1hMSijc45jhvSIR0nARUlNG6Ecwh?=
 =?us-ascii?Q?zFgUseyYxj+vIxgr86BYTXib/NEHL1lVuHnKtEBlbWr3ivjd67oizUjmsBzP?=
 =?us-ascii?Q?2uNnTkXf6zz95fhayhRkeKK9ZwyXTfbP0xrfcKe0a0+grMojN5Mmar4iVjWC?=
 =?us-ascii?Q?dfaUsa5I3N8V3X4Ck0fA/XuRJGwR9KGQJcyRfVNcieqXbcy+dIUNGW0+3l3S?=
 =?us-ascii?Q?1l2AKvth3iIteafmv2lBliZIdh+u3feiPqMUR4Wr5X7ryMk1ObdEU/+cvnj6?=
 =?us-ascii?Q?Iak2m8HvFWo7/uwsZkiJdt66YJvF0Pl/bulI0Wa0X657wSPNfjcGn9aPBJyN?=
 =?us-ascii?Q?DMWvyuKD0d1OX6EmXx3Ow58oTAQpR0GYpDEcgOo4u5CBB59m0IPOgvTRTglq?=
 =?us-ascii?Q?QnTRjFC9walwR8tSaB3hX94b/nAcdatwt9EC0Op5AULV6qVcmKgVQfQ+FdY3?=
 =?us-ascii?Q?rdAaFPgmKEOjjVmaTGvvFkAPx/mmS9/QqoSOG4kRZ/Twn2c7Dsh8Nuayz0/c?=
 =?us-ascii?Q?pUoQdGeKzKksl6QH1Y64QoXo8Z9mHP9o7y6fNkQveVFObhhRulttQx0Hw3hN?=
 =?us-ascii?Q?LCfrlIM9lTw3Bz9edO1PeV+1wPQt4jDPdDBFrkXKnaCoaJ3NiRLxz87my+bP?=
 =?us-ascii?Q?/tmkZ1cf+l8kh0a8LUa/SQP7aW7Y2Xvs+khvF0IRoga+XHHoExyFBgquMryQ?=
 =?us-ascii?Q?JCjLBN1GwJTHnqddqZPTPV9gEEl4s5WNWnXSrV3zQE8Fpacq+NtNWHmGYOz8?=
 =?us-ascii?Q?Fi0WX9X16ZmjBBKzdp5MmrwAUMPTVKhUWX5t44tFNRHPdhwJC2QkEfnHPEsF?=
 =?us-ascii?Q?BuIrsTllUXWPRK4U2p0lVymjgi7hhtGSKreTAjUlG5KYcjI42uiEr1U2QnUO?=
 =?us-ascii?Q?pH90LUZZsWbIc/71WjT1S8+0rsmOFgzO8J36jGBE+q6sfAJuiyx5VNUgOgSL?=
 =?us-ascii?Q?9H0LP5aSxzUzE5kgPI80zmx1bc5JiVmjVZyWk0XZUsh4TbEWoo5MGXfIIGTo?=
 =?us-ascii?Q?/4VnIJYIUHlmjQGtUtrwZu2WXATsNFrOv9gLkugpOtlDVGzZMgJqVbvM466w?=
 =?us-ascii?Q?r/vssaoYcEuCl3COcskTYPY4bGrTwpVX3/yN/JBQ41OIleTiE7xbvoLGrioK?=
 =?us-ascii?Q?PTl6qtOs0ILelp/NflvDfUA4qhO6WLaMgRJgp4/ddmMCGqpVv5hWgAkO+zt/?=
 =?us-ascii?Q?kt5mbY7VgkGtGGcsYW2Q+i7oXTxNWA22evpQEB+jWo5e6SfeQMq0eyTMEyzk?=
 =?us-ascii?Q?dgO9ztNWKiBU2GkWGN92cw2euQStwi9cR1Wh40A3?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3796b71a-3c5a-4a37-ea45-08dc63933774
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2024 12:45:12.2862
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fzPTCPpev/E6WQbrjjOmyTIX69hamIXiPqzI8UE7Z7q7vhLKhysukg7sCQWnBkM/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6794

On Fri, Apr 12, 2024 at 01:21:20AM -0700, Yi Liu wrote:
> This adds ioctls for the userspace to attach/detach a given pasid of a
> vfio device to/from an IOAS/HWPT.
> 
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  drivers/vfio/device_cdev.c | 51 +++++++++++++++++++++++++++++++++++
>  drivers/vfio/vfio.h        |  4 +++
>  drivers/vfio/vfio_main.c   |  8 ++++++
>  include/uapi/linux/vfio.h  | 55 ++++++++++++++++++++++++++++++++++++++
>  4 files changed, 118 insertions(+)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason

