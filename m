Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 718E44866C9
	for <lists+kvm@lfdr.de>; Thu,  6 Jan 2022 16:35:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240526AbiAFPft (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jan 2022 10:35:49 -0500
Received: from mail-bn8nam12on2079.outbound.protection.outlook.com ([40.107.237.79]:55584
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240511AbiAFPfs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jan 2022 10:35:48 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pab/hAE8dvXzjJw6uyxK73g42f47iLq7zZWAPjFinBT1SaU9zulOttmZErWtbH9Z9tz3RgPP7xiyOFk8a3xxDlOKyzT8+3IRgJWACuhz2SP4eoFB/S878ktV8r73UT+9IWHoY1vTrGTX3OyFkPfwnabNU/PuwFZgGsA1IOyo4oEktRiosv72ZaDFzSmv7kk7NsGIip7HW85B0zXCuSBtNo6GPWiVGSqeYkLaRKnUvkAlYCE2pecccXHuhTW2bx1lq8fqF1pfwZGBn0QaXmJFvV8e/jQKXlQXC/zVgn4qHh6bI+GE9JtdyZliTcQsEPJQu591DvsbrBPVd+qVuJkcPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7WmO3rS3SFeGcWlh4Gd5lEoCguZVkzb1UGY0l2T0y70=;
 b=TcNhOIRgApwZV9ZXaXIGqs+GDFDUL3+kjfA3soIpfb7kGQE9DbESsZUCBfLvivHF0xHWmSgZGWI/vR9nMIvgVYRpH1WTyQ97ZF5GJduoIN1zq6oEjB8enM6kgjRLV8/ub3Y7cKIDYYjVx75g4XzEvXmkbz+/Vn+DA5mCjVAGJlOXbWg/QQfsaFgskd1BajyBqucOXiFHqm8Nmhwpep62qTDm4dSYsAGKXT6rXNgedB/FvjhNz4Nc+hmSPiykKcPDCGI+zZKdIAHp1KoWZgXbxj6o+xqyJFkF1FzclOcoGSk+00B/7rMqr/QEEq2Mw5l45kW5aSf8KLrzKrMMdZLlCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7WmO3rS3SFeGcWlh4Gd5lEoCguZVkzb1UGY0l2T0y70=;
 b=jyKb0lLtaSabqTg99CBuMNd/BHWRrDhaf/CMpj59vCS80vFP9Q7PLZssFmJy1dhyu8UPNwejpBWz9ZVAsGmAu3QXx9T+ezn3p5590NCgzyKv8STpC7LYcmdX7rUSaROv6QSDA4geUJk1cpK3VKSr0Yb93z9N+UaAf+8SB6u82+ihkn/5QqXnyDJ8IN7nEkjVVQ0gwS03Vdgo7Y28anfK6e1G9fz33DVQFSJQRQVCAfH6ruuZmXiLoJcHCx2KNdBeuZBKFAj+PDEYJO+RNj0IQ6UyxIhhNreW5DykXYvJj6hXgT3yZ2abub0iQHH4vZGapKMOuJzhHaGihcNQHuNBRA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5303.namprd12.prod.outlook.com (2603:10b6:208:317::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.9; Thu, 6 Jan
 2022 15:35:46 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::464:eb3d:1fde:e6af]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::464:eb3d:1fde:e6af%5]) with mapi id 15.20.4867.009; Thu, 6 Jan 2022
 15:35:46 +0000
Date:   Thu, 6 Jan 2022 11:35:43 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Lu Baolu <baolu.lu@linux.intel.com>
Cc:     Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Christoph Hellwig <hch@infradead.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Will Deacon <will@kernel.org>,
        Dan Williams <dan.j.williams@intel.com>, rafael@kernel.org,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Stuart Yoder <stuyoder@gmail.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Li Yang <leoyang.li@nxp.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 6/8] gpu/host1x: Use iommu_attach/detach_device()
Message-ID: <20220106153543.GD2328285@nvidia.com>
References: <20220106022053.2406748-1-baolu.lu@linux.intel.com>
 <20220106022053.2406748-7-baolu.lu@linux.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220106022053.2406748-7-baolu.lu@linux.intel.com>
X-ClientProxiedBy: YT2PR01CA0018.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:38::23) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1d8da26a-11fa-4ba6-df0b-08d9d12a350f
X-MS-TrafficTypeDiagnostic: BL1PR12MB5303:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB5303DAE19E5BCD2FD11CDA1CC24C9@BL1PR12MB5303.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2X2IdJHPhRa0Q2bOeKKRXszuVL2tD7AafBOmBYrBfElyWTjfraj5EtCq+CJIeSLHoeTqG/TLzvECR9XY+mcb9Z7wr00uPK8RuCcsla769YiKnwEk3I1qQZLvMXClvNfHAoD58y4jfBQ/SBWB92qeIKgk40SrCmqM/49XxSziui18LOXW6Zi1iK+3LXPVpv8A20iKED9bxuj8UtkSfTZA+v/V9CN5H8ncM/E55uYmvc7Pk24W3LGqQxatlyqj4u09a6VBz8CDmPAeDqpaog97idI49h5y6AoPrk62+20Ko/GFwB1ZL9hb7eLaMzIzsk+wX9baoYnRqLnkWl+Kaj7Bveak2Euy7Izlatp5oAkGunec4vyhxKNAzpyUUHBkMYuF43FcFOi42Ffw7pH5mWTul/cMl7H+mqWqthrqROeMypOH70namR3OKOJoxKcKbwJDlMYdqu7KnNkHVnsP5SsUm44YhxCPFcDH0Vm1LfRwPmNtDRbQHDge1DmRGAmg4EnSWRi+iPtoepQ5OkYwXz+mRS/gFgm5h5jy9Cd963Dq/m8kpyZLqArvXuCZkdx2621EBqXkQBCoCBYMVS6mHoGxhBRupB5vioxoWVzjMS8OUIGbru5hS/mg7wAqIEv9beotUH0BWkBlbur127l00wAHQYklBI6AbU8zmSLLBVML/PQ0NjM6HnS7Lt+2fjQ0XXLzLGMu58GMArETFFU0hHeTGQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6506007)(83380400001)(6916009)(8936002)(33656002)(186003)(54906003)(66556008)(2906002)(4326008)(316002)(86362001)(38100700002)(6486002)(7416002)(66476007)(36756003)(6666004)(2616005)(66946007)(26005)(6512007)(1076003)(508600001)(5660300002)(8676002)(357404004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/KJKsQx8GkM5lx5GfWWEf7ZdMA3wvv+Vtd3IGEPq3hMA2uWY7PqdjgL9O5H1?=
 =?us-ascii?Q?Gp1ObJ76yQb2tgjkk4LnRTJ2lttzpfA3ZSxRKWmyPt3U0+9KoMhcfTuBmksZ?=
 =?us-ascii?Q?msFYefzayytsSqO/iXCEyZOJqBRfhxdvyVqSI+jqlaRGkgcIzpf1XugkmygT?=
 =?us-ascii?Q?Y5pcJ2ASCSLK9GYvjPqkviOC+dYkth5L/opmc0JKQSxRBczqw26Wfa2R+6XR?=
 =?us-ascii?Q?BgSgFxqC6T1DbkNYo8lQkx3ZYzo+bm9koxMV9IFkbKIf8vGr6dJDmMqrmi/D?=
 =?us-ascii?Q?X3tyYEGB3gI4BERDDXLu/Ffyg//K8VWWhI4CHnAw8frCagChX55pQwBZC2nt?=
 =?us-ascii?Q?GdkZsndohZH/He3jkShF+sLRBXwW0ua3BxpivJdjuX1jQOur5kHcJXPbPSYp?=
 =?us-ascii?Q?23aDFMXMr7+xuPQJ9Z9Z56KIzk8mrzFQbm1/8iyhhmX7ljXc4nVG7kAqtoxY?=
 =?us-ascii?Q?S+pU6A6vTEIDOqRRjkMyNa2XVg5T6kWmtuCchMMDyDIVG0ya4iRRYTBSAlA7?=
 =?us-ascii?Q?jpfTR+2MZzr0f2CbcwcZ8/xYdqrU4E+WdYUmm633vaNyPg9Kya60lxgrLC7o?=
 =?us-ascii?Q?HAj+WlgwyftjNJwbc9rkaX88hoJKdL4wsYUcJUtLKVsGTPulo8waqOmaX8XM?=
 =?us-ascii?Q?ZaldPnOcaHoNeU+PuAZLTpEA271mcPA7IILtfb5e2viWIYM+WrLStI/UlJeD?=
 =?us-ascii?Q?MouSiNVF3pCvBZ9pOyMZGO0+Yivxq6KnToZprjYbgoYhKBmu28q5uZYCOT/l?=
 =?us-ascii?Q?tUKEueHbdwYqONp/l5hDkM4VYxYlpSH0XDCO2Dp7XVOxP2bZDp+wSjXKOh4d?=
 =?us-ascii?Q?isCtxGZl/f5QpkdxOwXQcrIufey3jn7TobOBTaTmvFj9DUHGxJRpBgs95xtu?=
 =?us-ascii?Q?eRDyPH212fED8YEXcRLIeK8bXEnjVUbETnHf7Coy4q0p7Csn1p4eKBO0h5iZ?=
 =?us-ascii?Q?cs110LXjWm8Q2nZOjv0cqjSBa1FIlYaSVQBJKgJzjzqEpntLfwL+mgwRGIyh?=
 =?us-ascii?Q?zcQ2PEH+U2YlVIT54k9I4fLeWgQJgFefCOdtEYsvPyMhSE1fs97Mrp7t2BV+?=
 =?us-ascii?Q?wTjciTbVHl0RbEvUV59NYKQ0COMTn2Tuq2sppad2Eqp33cRIYohUB6cXrMaE?=
 =?us-ascii?Q?mjc0SIKzAwU07lnG/P3LP5rZcTA1zoD9s62tLhT0LK2xwnMqv5i5f/9IFblF?=
 =?us-ascii?Q?ZC0KAw5hCQ6AqmjOhqGEQrPyQsdj4sTSePArqTA1oRcgBXnmgH7m2WbVFo7l?=
 =?us-ascii?Q?vZ7548KV4XHAKRwTzqseyBN0rbXlUA6TpPuKizOZ0XEl6laSUCY4kN20b8xI?=
 =?us-ascii?Q?JUTvBQ/eCm4OnyGv8kOoSed75GQoK8Ah9BT0i5BNcttsrzqtmfWo23Glt1PC?=
 =?us-ascii?Q?o/EHOeNx6gQotNpTZmjhA2lGSZOk+XRHj3CRgAb3rF8T6aoQlFQMpZpxS1FF?=
 =?us-ascii?Q?AA4mSQTiIWcsNSHIufpoucIik2z5Y+xVbNLhjKigU0QmqF9WClpU93yW40xd?=
 =?us-ascii?Q?8lslEIpE+PIvZfhsSdvhM0VSE/G19vhatsy2YmXGHt7MsVFJtLfkozlMyS0V?=
 =?us-ascii?Q?OuMfAFAym3LMY8pWjPQ=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d8da26a-11fa-4ba6-df0b-08d9d12a350f
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2022 15:35:46.0418
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D1LqUHPiC9QjoaujinuoJ1jwak2jdqHSVokiSZ5Nfl/L+iEU+h7Jcqid3HwUF4eV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5303
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 06, 2022 at 10:20:51AM +0800, Lu Baolu wrote:
> Ordinary drivers should use iommu_attach/detach_device() for domain
> attaching and detaching.
> 
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
>  drivers/gpu/host1x/dev.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/gpu/host1x/dev.c b/drivers/gpu/host1x/dev.c
> index fbb6447b8659..6e08cb6202cc 100644
> +++ b/drivers/gpu/host1x/dev.c
> @@ -265,7 +265,7 @@ static struct iommu_domain *host1x_iommu_attach(struct host1x *host)
>  			goto put_cache;
>  		}
>  
> -		err = iommu_attach_group(host->domain, host->group);
> +		err = iommu_attach_device(host->domain, host->dev);
>  		if (err) {
>  			if (err == -ENODEV)
>  				err = 0;
> @@ -335,7 +335,7 @@ static void host1x_iommu_exit(struct host1x *host)
>  {
>  	if (host->domain) {
>  		put_iova_domain(&host->iova);
> -		iommu_detach_group(host->domain, host->group);
> +		iommu_detach_device(host->domain, host->dev);
>  
>  		iommu_domain_free(host->domain);
>  		host->domain = NULL;

Shouldn't this add the flag to tegra_host1x_driver ?

And do like we did in the other tegra stuff and switch to the dma api
when !host1x_wants_iommu() ?

Jason
