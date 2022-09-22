Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 182825E6BC9
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 21:36:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231990AbiIVTgW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 15:36:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229864AbiIVTgV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 15:36:21 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2054.outbound.protection.outlook.com [40.107.92.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C22810B21A
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 12:36:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fLNIXGxXN451Ay0kfL6qjZe8JyG0nfxRFHsaWAhQjnOs01Kl/g9U9lT0clkEdappDXxC7Jc7JF6bhX1CZ6B4dVRbOtofuP2YwnbX/AckRqmD5886+fBEPxDT3RnusnswLCVL0kM2Sv3MsimgBttTLXuNXhWCVX4YRLTsL6x72A2yfyLwYkLQgUr54vN1+1dLvI3di5DGrKNGu0Dz9TAcjXhAgSvi9tsBGEqSbX91lRUF91KpSaPzmSDwOxdUeknlIC45H7bgWI4L/3R+x/Tjv6vWbOgdEjb+yZJShryfm68dll85+0hG2nk6HtleNJtuHccvdDd/wRMbmPxS4k5GEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iy4UQnRW/dP4HGGrvRmJnlJyQh9PfBUkecaIKklNnMM=;
 b=RnUZBlqbjrlChe0x8DwDOBlLmVkW2YQZ3+ZIgELq2BWlDrZf9oI5GiELVMHxRsvUykxhRgZOBkBPRnm4pUMBCmvmGgJsGx2lPEEDzZIL1WLg4pt5IDJtErzn/TAi3Vftr0uq2f7TE+O4bLC3l/eh9qUmUkmPXgpIb+xJ25zYTX0z2iauybsj77APRuLL+PnHNWtLTqUVHqbuvEjQHdEkc8N/T+OLMlTAHcsJa6kv00pPuLrE8IMB51pvqHEgzrWHv3ZpX0wsZceRsXpTPVPOf0jzRVjqOkntg6UMjmMiyyN5WcmTMnTu5zjNipYeq4T8ZwHLB8jevLMU3/lTsIVGbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iy4UQnRW/dP4HGGrvRmJnlJyQh9PfBUkecaIKklNnMM=;
 b=elhx9ssSVNNyA7EICtAzPi575l+a11cflLMLtMLK7kCXN5Xx9aV6wHh0lqn4FxepFwEyis9QkTWfjrSZnprnvJFBqPsTbwVdam0HdxZF2v1M3Sjdh0ZR+HY2Q3zGxjNDZGdYnZSun16o7LzfAgy1w1TvQDAGmrGcFkkRBMcfARZMGIGWisxDtv8JMKXE0NuoFo6LxNu5izwDwC4tcbXpkiudD5LDmAbrn7P9lO+mAEvOHRHTr2dwQ9LQ0oW2dMg5uHVGMyX0gpD2JI0H323c1wSG1mXBbD8HKTj7QcOFfJONQOU9cqjpQ8X2w18RWtMrTltHFpOTBECg38+KMYcjNw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BL0PR12MB5011.namprd12.prod.outlook.com (2603:10b6:208:1c9::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.18; Thu, 22 Sep
 2022 19:36:15 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%7]) with mapi id 15.20.5654.019; Thu, 22 Sep 2022
 19:36:15 +0000
Date:   Thu, 22 Sep 2022 16:36:14 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, iommu@lists.linux.dev,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        Will Deacon <will@kernel.org>, Qian Cai <cai@lca.pw>,
        Joerg Roedel <jroedel@suse.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Robin Murphy <robin.murphy@arm.com>
Subject: Re: [PATCH 2/4] vfio: Move the sanity check of the group to
 vfio_create_group()
Message-ID: <Yyy5Lr30A3GuK4Ab@nvidia.com>
References: <0-v1-ef00ffecea52+2cb-iommu_group_lifetime_jgg@nvidia.com>
 <2-v1-ef00ffecea52+2cb-iommu_group_lifetime_jgg@nvidia.com>
 <20220922131050.7136481f.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220922131050.7136481f.alex.williamson@redhat.com>
X-ClientProxiedBy: MN2PR06CA0016.namprd06.prod.outlook.com
 (2603:10b6:208:23d::21) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB4192:EE_|BL0PR12MB5011:EE_
X-MS-Office365-Filtering-Correlation-Id: 802a508f-71d4-4c14-a7b6-08da9cd1b6c4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AspAt9sLkA/Z24A6Xv7IFULEulUk/VoYos4geV1B7ClnG0K6tJOOwuAnEl5+sZNBTP2seyH4nL6xgT3dz961RWbYedJ9q5NIA8hZ1HTBcYqqxx/udqf+lnhXzK0W35TL1tL3JcF8YMo5t6wO28TRjIgZ1dbTu0mkcRl82gQqitMYKsWVAEoZM/xjmJbvfWtiyG0YPfKR8nS3IVNgzsvLoIsZeLsSsNltm7HF4pAUTlxnHzPYIPyNkNMQD1FwnltEZhVDcpE/glAAJNIhO+DA7RvFL9KJStvvInSMl5sH50X+n9VQ4ibRE5AGn6HE8o9hIgTXLqRjOYI0s8AtIrVqxkpdm3xXoSrg8yMr1ovaG2a7YVax/8mabVn2TUG/dZzMqRi/FFMn7YmoUIqoS2BS2w9+YPuQbLAI17o+qepfV/jGh/wSoo6wXfqBm9abMcPQ4LPWhWzu7+v/XbbpQzcJo+0pCyGwe85WZdyCThmHLF0iqaGPA2AVjOo+iIbjXeixmk8TF0deeIyjJZ0IhDKbT0a73+9K5RjmMypWXBLkkWKTTVjQCW6m4kxs4OMHa9pAYkqnBX4Ok0odhS+DKfwAHDJuNUDs9SWoIYreMRocHtzUCxl6IetOnrOsCLDyhPLqpFfh5krBf9ee5FBo8Owmy5uDgvSkSsrURZgGmAtSu0xaUa4oqLk+Hg1YmXxS3hu5TAMgvlN/uapqrMW8i74JvQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(396003)(366004)(136003)(39860400002)(451199015)(66946007)(66556008)(4326008)(6916009)(54906003)(86362001)(66476007)(316002)(478600001)(6486002)(8676002)(7416002)(5660300002)(6512007)(26005)(186003)(2906002)(41300700001)(2616005)(6506007)(83380400001)(36756003)(8936002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?88Fti1aDXDUvgYhXPFm0cmAdkBKWIt6s/T1MhvzL+DmsQFa/Jat98YKEzXq7?=
 =?us-ascii?Q?uQ/ZtyCXZR2977yhzq/bAzinPp3qqVf56puhLwFLSRqdc22k5NYtVyjRuBnn?=
 =?us-ascii?Q?8crA+2SOMdwWPRf+9lA0IktSiSG2nMwqcFrHQE7+7HQq6XRCUOexcg1Sc5oP?=
 =?us-ascii?Q?ZyRKxioqE6stLB+EWGWYPG2yXlBTJS7iu5WSTIn/7BXd1OtvgVJ8bqS7gNAn?=
 =?us-ascii?Q?zo18LQlJgsLlxYjInWRGg+nYKr5NmpDsgVLQuLxxjtiztuwZmNo46tjNC8xf?=
 =?us-ascii?Q?0GkMDYejGiYEZzwO3lXPi/kffczCLTRmYQhv6OH5asQVSrG2A6TnYmVy/nxi?=
 =?us-ascii?Q?MqhFcg1IJkvxDP+hoDbylTUow/pl2nCyYNlgpm/bOlABZXE+acY1sNc67Mkv?=
 =?us-ascii?Q?pVy3eKGW7YT59M8BAueGRE/VJ9fCkZH7gnEAftp6ua4W8ITNZgr5K20GcD1g?=
 =?us-ascii?Q?64/Y4v9Rer6kJ9dZ7HoWgrKGjFajp7R2FIkoPxAr6VTV4uxpK0pkrJEKas4e?=
 =?us-ascii?Q?70qmU/MNO70wNwTGRvHDEX56DzIBiL/peawf5lQv9J2M3A93/HKoHN4iKTtJ?=
 =?us-ascii?Q?8MELjMK26ZTJshljgHKB2diL8Qis0I01fkDid0OAb5ZRBwuSF4OFUoOhkKgc?=
 =?us-ascii?Q?9oAo4gWawl/J/LR41vM/xaNLnpWT5uIBdTxSmH8JUtBktQvdBUGYmi8pNChY?=
 =?us-ascii?Q?324quW/Y/Yr7PUDcsu6TYeeplslzBePLT236jfT36h4Pf/6OYBEcQdsd+dAR?=
 =?us-ascii?Q?GLD22JLZiWXuSOQKFtoUmwHxB8CPGUKqNwmXImY2HIPZ5lD9uVVKJxLRNDd7?=
 =?us-ascii?Q?d0LjFXCQ3WgGiTAz/ashXd8kKlc+bPY71S45UPfp4fMru8A9dnYtm7Ja0UKE?=
 =?us-ascii?Q?iXQnaX9TN5jCZj3r0DXf5mswcVD1x0WGJyzkA3ufFrBsSiFd8BYFXSaIdV7O?=
 =?us-ascii?Q?m8+5GWUrorsZAfn/bihQXngDmEoYc6tzalFP+x0AkX/ZiTRrHceBdB+yrdom?=
 =?us-ascii?Q?0D4P/I4pGENAOhSNp2xKT9oKXb/rz0p/BChcpXGWlnhtdkG6xq1Ec+WS1l+q?=
 =?us-ascii?Q?TjofWBeitAfuZXrVnkOu90MUUt2wRnPSIz7u0FZ1s6LDlU3t7BjnVLCkP5eN?=
 =?us-ascii?Q?yLVjtl7Ji4WIcaeEZ6QHYd/dKEXOkj/kzuMbjVREfSc7ZXgLAiQnqx+jWFz+?=
 =?us-ascii?Q?p0ejlDIwch9e8iDwC39Vfa2oS+QDG+1injGl0RdJTG+1U0mJRt1NjQzvhMwl?=
 =?us-ascii?Q?o4jGfYgFVzFQwXvTadPATjc21g8/wmeAgT1xK8jJ79ZMCuQT9u0Po/AmyZcz?=
 =?us-ascii?Q?XCzwPLSDCOM+YENuolNIpFg51Zc3zQDCSxjKqzt+Oi0NWdF7srMVaFh+jzoV?=
 =?us-ascii?Q?AgvDR3GR3hiwYtxDzzRMYCa3fQseG3JBXj4c+EjaQsVZZHmuKpYGm7cII283?=
 =?us-ascii?Q?tjqhMBbVRAMXaAiTIalvF5mjWRFDxV8/NMHEL61N6QPdcRZDtF6E7mWbJLyl?=
 =?us-ascii?Q?Rng5UWYY+ZIvu3+pUVBtAsBsT8jiwtOEbzCkTE6NBfpQae6UA9BBtidFAc94?=
 =?us-ascii?Q?mB2ZWHvj6j8OarMBfhtn72HF0pzILSOIS2jMVAKk?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 802a508f-71d4-4c14-a7b6-08da9cd1b6c4
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 19:36:15.6347
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Wr4+35yYxrD89wklg+Y5jq9zv0WsAXDnRhtiENmKr7JdAXO/1zY+MRRmT3uSGsA5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB5011
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 22, 2022 at 01:10:50PM -0600, Alex Williamson wrote:
> > @@ -378,13 +394,20 @@ static struct vfio_group *vfio_get_group(struct iommu_group *iommu_group,
> >  
> >  	mutex_lock(&vfio.group_lock);
> >  
> > -	ret = __vfio_group_get_from_iommu(iommu_group);
> > -	if (ret)
> > -		goto err_unlock;
> > +	ret = vfio_group_find_from_iommu(iommu_group);
> > +	if (ret) {
> > +		if (WARN_ON(vfio_group_has_device(ret, dev))) {
> > +			ret = ERR_PTR(-EINVAL);
> > +			goto out_unlock;
> > +		}
> 
> This still looks racy.  We only know within vfio_group_has_device() that
> the device is not present in the group, what prevents a race between
> here and when we finally do add it to group->device_list?

This is a condition which is defined to be impossible and by
auditing I've checked it can't happen.

There is no race in the sense that this can't actually happen, if it
does happen it means the group is corrupted. At that point reasoning
about locks and such goes out the window too - eg it might be
corrupted because of bad locking.

When it comes to self-debugging tests we often have these
"races", eg in the destroy path we do:

	WARN_ON(!list_empty(&group->device_list));

Which doesn't hold the appropriate locks either.

The point is just to detect that group has been corrupted at a point
in time in hopes of guarding against a future kernel bug.

> The semantics of vfio_get_group() are also rather strange, 'return a
> vfio_group for this iommu_group, but make sure it doesn't include this
> device' :-\  Thanks,

I think of it as "return a group and also do sanity checks that the
returned group has not been corrupted"

I don't like the name of this function but couldn't figure a better
one. It is something like "find or create a group for a device which
we know doesn't already have a group"

Jason
