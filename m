Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78289730617
	for <lists+kvm@lfdr.de>; Wed, 14 Jun 2023 19:31:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236795AbjFNRbB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Jun 2023 13:31:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbjFNRa7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Jun 2023 13:30:59 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on20601.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e88::601])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA60F122;
        Wed, 14 Jun 2023 10:30:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SZyqkaHrUAoDvF5VeelLuCm+YvNu9mXXwZO9i/SskxrskaWxdDyXLosb2zPFFMxAhWWnghVNagxzhxUt/iTf7iJFO+LXTEFg4FSIIBQmDPb0vI6WgJpu04MGV23HXEOf47BK2hP58WPQF0+jnW5S3hLyF0nX4fxqN3NdhHJ34vzg0ycLvAa0FPUCZR7I7LQrn7Lxd/EjEuXiQ6Y1aLctSq/yFc+ATNMUJ8zMpPrZuhBG2s4LYIKsS0DUXeHS6+V0loX3ux1Yyl5JgEJJugMtsYxPkeeA9vPOXTUbTyQtF+40jmV3vxhVyT1WLz1HPzZh8fyPsPF72zZtIeyMWdMUOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DeMADfgaUTcwOla0KPnXpa8mFr/d3az1NruE65+bhmc=;
 b=f8dcV8FhDz2EfRUq/BlfLPBuEYyD0rz3LiO3mN++UGaE5hiDB4KKPweK7jnJShsaqn/sncarxmC/UF1OEJ0IWhUemRtXH4JkqzvK4wgIHvtVk2ePg0S3H6oESI/jJttdVnwnx2arKUVKsiPj4Bhdv5ZHgyEtNEp8RmcJRlZSsLC26YIXVYwlRR2lWvvSBN1DXZ1Es8cm2Mq3XZ2uUkzj6Z8N+v8u7fXjqnXxUY02l3y5wcRnqPAOMi45vi8O8ZImzMuNaOQ7cny7XEeFfNTJ+c+8I9vpHLli61meKQI8Q+6HQJFAZZtDopchjT7TldHMxU1iAi3Ura/pgG6lCWWaxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DeMADfgaUTcwOla0KPnXpa8mFr/d3az1NruE65+bhmc=;
 b=me3wF8Moj8o2j9hX+Ht/WhUl6MS8U4krSCCkQtUVeH500DbXsFVEZP8Nrpo20NBb+T07JaAN+1hqAg/8eRWIrHDR+4XzGPoGEwoC/oCBeRn87608WvY/6Q4QByIB3ny5WYxRLs0xoBCrCZFmUIFX6aTTnDWYZH7esmBwV9QYT4LJqH4S6mF4bVbqNM42c5T0v95OGZhYj5p7aoNCgsrZszBsutWZQ3n0OZdICwh/I4hblNHIYb2ZhQdC6QUr4GEDEhRHrZs5E8IW3ZiFVpvRfDkzC8P21PghPVvEucuqhttI2/RUJsMXBcpR5TJYuQOnXqCovvdNWdhvoQmx70fe9A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by BY5PR12MB4097.namprd12.prod.outlook.com (2603:10b6:a03:213::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.37; Wed, 14 Jun
 2023 17:30:53 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%7]) with mapi id 15.20.6477.037; Wed, 14 Jun 2023
 17:30:53 +0000
Date:   Wed, 14 Jun 2023 14:30:50 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "Jiang, Yanting" <yanting.jiang@intel.com>,
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
        "clegoate@redhat.com" <clegoate@redhat.com>
Subject: Re: [PATCH v12 21/24] vfio: Determine noiommu device in
 __vfio_register_dev()
Message-ID: <ZIn5SihJ45URLlQ/@nvidia.com>
References: <20230613091301.56986440.alex.williamson@redhat.com>
 <20230613111511.425bdeae.alex.williamson@redhat.com>
 <ZIiozfqet185iLIs@nvidia.com>
 <20230613141050.29e7a22b.alex.williamson@redhat.com>
 <DS0PR11MB7529F2D5EF95E9E1D63C9264C35AA@DS0PR11MB7529.namprd11.prod.outlook.com>
 <BN9PR11MB52761B4E9C401A46FA5B4F2E8C5AA@BN9PR11MB5276.namprd11.prod.outlook.com>
 <DS0PR11MB7529E50A3F122449AAE5733FC35AA@DS0PR11MB7529.namprd11.prod.outlook.com>
 <BN9PR11MB5276FF400A7860DD23CF222B8C5AA@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZImxMHrOHHwbpNmd@nvidia.com>
 <DS0PR11MB7529918D45D6402639F9ED68C35AA@DS0PR11MB7529.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DS0PR11MB7529918D45D6402639F9ED68C35AA@DS0PR11MB7529.namprd11.prod.outlook.com>
X-ClientProxiedBy: SJ0PR03CA0276.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::11) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|BY5PR12MB4097:EE_
X-MS-Office365-Filtering-Correlation-Id: d836360c-ad52-4e33-ca75-08db6cfd1a93
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pZ+QO2/JR1AGWj1feF3scfwEscA3QAwUJ33G3YRM98vDksKQk1WHfKD+/nEJOlr87h/u13UKCF3e2zMcGo/ORSNvGAVg47yTlkYLVeVqU66e6XNP9wdgYAm7wUEeOeQmasA/6uSMirkF6KZ4q5rOnc6QEyB0x7fIuD3IzNZlS95FwvYdhOZxyD0SSZw17Ia+8/IO1xv66xe41ssszPyeGZAPGX8+29EuGT0VNnghyvnwGnk/RmgqRtTTctCR9bVbIF3My+jKczUZYCjADNF8wsj0UFBwWmE6W5WTxtw9teNxzsOL1e9wtMQ4aRoR3bJgOrMVkQWafu5THqzxI6IizVt/lTFdLkgIf1cIEMQcx/dPhKWb6uyp9cmcLxbJukX6RKynuVIEOr89wbqmBrqWwcmPzRTmBSMw2KoBgDio2YkyhiYNyAVuqx+YcwksYgpS7hweTrk9AuVUz20yTW18w/dSpWk2JiENNGapru843qufdUrzAqRwfZyxk6PXweAy7vPSOpbrY3MX9mjoerds7xlSn7aEEh96MwzVKWK1rXLlT2kVOgg03MVLY0+tGYkC
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(346002)(136003)(376002)(396003)(39860400002)(451199021)(83380400001)(5660300002)(186003)(6506007)(66899021)(2906002)(2616005)(7416002)(41300700001)(6512007)(8936002)(26005)(8676002)(6486002)(316002)(54906003)(36756003)(478600001)(38100700002)(4326008)(66556008)(66476007)(86362001)(66946007)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pX/sH4ko/EWTkHJSzDL9gehYCbaNubCHQd8Phh0m8zI6wEKzdlNIkGSNW7DB?=
 =?us-ascii?Q?QG9Vallx4fwsAcXUkTu9co6Bwe7iVZJrsHSlOH2jRVqfN4MCswjnWS+CHDHd?=
 =?us-ascii?Q?DFcHQoPIyxVWJ+gtU6995FtUPZnjTKVpLkTwRd/9MZEzVEVTLPkqBiP/c8/h?=
 =?us-ascii?Q?8rO8mRZhWeLWJ7yZZnATsx/vNX5M0PJdx93KlodgNEef38ea0iSYE+/rWWvb?=
 =?us-ascii?Q?+V1LUAaZs4iuQ/Xhlk9fm9eQqBr4D6Jgx6uw/KCnFuqoqaG0Bb0iom8tKAix?=
 =?us-ascii?Q?4exZs386Z6ojjfXE2+wNaL/lyOYEVicq+87HpkAJIqpMvl9kHIFrMc30gOFI?=
 =?us-ascii?Q?2eaIpEQjdhWoc9JIfnFJicZ3EiUqDTDybqhs1sRYgPVFBQJAj728Mor5D2Vi?=
 =?us-ascii?Q?EsHRfqUfb0PITWzwolIIbLiMgm0C0ZH7AuG3sWnS2XNstx9zQyL1VA8jDvty?=
 =?us-ascii?Q?u2p9Ol0wG++E7Nrdwv5fQDCIBDnZOmeJtFfYRSOaIuC0tergrOxiNAp9153t?=
 =?us-ascii?Q?cu6TEDjwlM6BQFvD06x405rKWPcI0KYs9WWHe/rv3+lgjYNFhKEwUOkVCnZk?=
 =?us-ascii?Q?Swn7Lt2MFiF31SlFECcdd0cVExZX3exMd8SAVYiHM2k8J2nlByMY3W0ZDqgR?=
 =?us-ascii?Q?yRmiuOoCc9x8UgCsUgc/nqo5GbvlD0ZIoIUPeNjt2gongGmFbRD8bqjBCvIz?=
 =?us-ascii?Q?hwNYEtC3ar/GErOkM6qzJSulSaYf6h6zwGlqkv30AAZuc63MdU5KnxZC2mjq?=
 =?us-ascii?Q?+W5uOxNO4PGXpfeq8ipFRXCj+vkLa262VMd0ahKLio/BzlCFwUPVPAN3w5I9?=
 =?us-ascii?Q?VBQpSLcHoTFRST+zuLTrCWA+AgNx1hd0aZWFOQV/gk3jNCG3j5xDHSQWhCD1?=
 =?us-ascii?Q?w91TaJ5y0XnxaUBdlOlRuwWY1R1XnTJpmW7MJiPtxYpPA3sGQwQDrOIY+NTR?=
 =?us-ascii?Q?ZFScRxoLMUz1WlYLn1jB7oH6ged4Hw7xp6tFtiNDU9bA+2pu8WVNHLJ15qoz?=
 =?us-ascii?Q?XhREr2A4L9SGLL23xcIGmjGdXFxsOdf6RtLkiGPxvE2fHbcaGO/E3Vt6SLfv?=
 =?us-ascii?Q?uwAe8QcjUPOtcppXH2dJBl6wWUK56Vqq3bZ5s+dxinCSn2opNagayM6z+v8B?=
 =?us-ascii?Q?UJIVSfqGrECTG/jjvnWZ+eszkMBJNF67M9YhF16BoD/mUcECP13hT2WAzPRD?=
 =?us-ascii?Q?LvUYi0hCxMc/EMx2yZtPeT/rnmdwPIsxCqJrntO+tDcv5XVZQvlXSZX1a5pB?=
 =?us-ascii?Q?C78sUxAE7sPa8yTjv8+Pn9hDaihzNh62BgnedahCV/UrHGwmq9UB6U/lR61d?=
 =?us-ascii?Q?16rW+BgpLULJWSyGYfoA5+lgFyS68c+CTe5XVyL5AlvSO6XZcmGRrIMKHG/l?=
 =?us-ascii?Q?Q41m1XPQ2nt2Pnq7+4TNf+LAOlPU5XZdx74sUr+zL9m9r5/Ot4wyGdvtC/s7?=
 =?us-ascii?Q?xftn51WXy18tJcK1KjxkXQJ+C64mDYxUSZ1QkesAZ7wweQsHGG+Or/sr3W+8?=
 =?us-ascii?Q?odh9xFJ5r+WtCJvCrP4Uoq2p9ga76ZDsXoW93ny7WGtdy7XsNih/LLQ6Li6A?=
 =?us-ascii?Q?hsBbYuVXf02sRQJApCk1I1SX0V7z3cJCABBsK1bc?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d836360c-ad52-4e33-ca75-08db6cfd1a93
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2023 17:30:53.4774
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AscMcF2B2erWNzGuyUFpo5tyJUlym9832XX2BpipnDsI6A+NGbwzYv9XoNm9rgMk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4097
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 14, 2023 at 01:12:50PM +0000, Liu, Yi L wrote:
> diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
> index 41a09a2df690..c2e0128323a7 100644
> --- a/drivers/vfio/group.c
> +++ b/drivers/vfio/group.c
> @@ -687,16 +687,6 @@ static struct vfio_group *vfio_group_find_or_alloc(struct device *dev)
>  	if (!iommu_group)
>  		return ERR_PTR(-EINVAL);
>  
> -	/*
> -	 * VFIO always sets IOMMU_CACHE because we offer no way for userspace to
> -	 * restore cache coherency. It has to be checked here because it is only
> -	 * valid for cases where we are using iommu groups.
> -	 */
> -	if (!device_iommu_capable(dev, IOMMU_CAP_CACHE_COHERENCY)) {
> -		iommu_group_put(iommu_group);
> -		return ERR_PTR(-EINVAL);
> -	}
> -
>  	mutex_lock(&vfio.group_lock);
>  	group = vfio_group_find_from_iommu(iommu_group);
>  	if (group) {
> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index 51c80eb32af6..ffb4585b7f0e 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -292,6 +292,17 @@ static int __vfio_register_dev(struct vfio_device *device,
>  	if (ret)
>  		return ret;
>  
> +	/*
> +	 * VFIO always sets IOMMU_CACHE because we offer no way for userspace to
> +	 * restore cache coherency. It has to be checked here because it is only
> +	 * valid for cases where we are using iommu groups.
> +	 */
> +	if (type == VFIO_IOMMU && !vfio_device_is_noiommu(device) &&
> +	    !device_iommu_capable(device->dev, IOMMU_CAP_CACHE_COHERENCY)) {
> +		ret = -EINVAL;
> +		goto err_out;
> +	}
> +
>  	ret = vfio_device_add(device);
>  	if (ret)
>  		goto err_out;

Yes that looks right

> 
> > I prefer the idea that vfio_device_is_noiommu() works in all the
> > kconfig scenarios rather than adding #ifdefs.
> 
> But the vfio_group would be empty when CONFIG_VFIO_GROUP is unset.
> From what I got now, when CONFIG_VFIO_GROUP is unset, the stub
> function always returns false.

It seems fine, you could also put the ifdef inside the stub

Jason
