Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A74A421A28
	for <lists+kvm@lfdr.de>; Tue,  5 Oct 2021 00:34:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235915AbhJDWgY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Oct 2021 18:36:24 -0400
Received: from mail-bn7nam10on2070.outbound.protection.outlook.com ([40.107.92.70]:25849
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234726AbhJDWgX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Oct 2021 18:36:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DUUV+N6KGLCM/W/sEal1Iu822Ed6BNRaddwGzBD/scpLkdSeObK8rvbV5R/yEYaUmcFgO8/lBYC01VxcqCwL5GJzOg3kwktrw4EZ/Qhqyqa4snDJJ84SLiBgxjf6ly88Njyz/RHFu+qHzn7L4PrwDusiO2GrqfajrAm3AixoTK3/LrsYrg273zX5133KBQ5R8i44UeLMuQ8NM0x7Lfi7i3gblTnEhU26/M8GChVeFfp17DnkDninwhDeYHatelNRAKrjOJQwNOgWeP17kkrn4zcWHw52jaWYAGqsEG73FpO0fRrv8tzaLKhFkUslFWBTwmy+HodJOARcVcmlEQej4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=thQIM8PAcrt3jQNvy/yhfifhbrGbOX8R6RFHtn5vehE=;
 b=V7jkFRTzxu4VyGuMAQLjyjtBHInabwZndRedx0cxFpxy45ioG7lXEDJ1t4I1eHp9bbbi/CC0hLc2QCRrHVgSeqVrgDoFlE+jOkyKN35Zc2k+bd+97olyTc85rQXMLJBi9oEYps9wGz1SP9hq+ZlD0JrbuxN9Byo3exshFk9/6qEfJOkpSRTOW/p5yzKCHCDLsr8hga+yo0L4mLqEQ6x1YuviKOVCtUHIcguoxDGnjjBFVGS7zCi9bjaQMOUBg+ctpbbyChRFC5YjLtUEstLYWBS4Z6ZDjObzYD7fmbuYhs90ghRs9VlQYbRQpVruB1Rg5lkrfdjElc2xl/SeKIa9Zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=thQIM8PAcrt3jQNvy/yhfifhbrGbOX8R6RFHtn5vehE=;
 b=lYvTjHGLUF56YNRmsqAV+oTNgoAftotqRxzkV3+hfWettFejpLdOActn2Sg/GYJqgKABQPdrLkTJdi/wtLvJyne877V/HiDE/W7mYwyCCmGGF0Yho4mrq8oG3LZPWetKJbUqxrZTaLM0ft5PfzI8qC6kL7S61X5cfi2rErQWrmlg8yFVg9W+26OdDJ1Czlz5jZomJdK3kMnVqzZGPp0jDE1qIr3Hj++RJiWUDphR/XUGfk6HCMEVzWA3wkwWCtxpHW1Cd3I0WOZs2K0VSmZH0Fhbuusd9D2ejnQeSUXVVfFSkJFW7s17osZHaTbdzNJm4V70XmAVPYV4K8vYL1lYxA==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5174.namprd12.prod.outlook.com (2603:10b6:208:31c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.17; Mon, 4 Oct
 2021 22:34:32 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4566.022; Mon, 4 Oct 2021
 22:34:32 +0000
Date:   Mon, 4 Oct 2021 19:34:31 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        "Tian, Kevin" <kevin.tian@intel.com>, Liu Yi L <yi.l.liu@intel.com>
Subject: Re: [PATCH 1/5] vfio: Delete vfio_get/put_group from
 vfio_iommu_group_notifier()
Message-ID: <20211004223431.GN964074@nvidia.com>
References: <0-v1-fba989159158+2f9b-vfio_group_cdev_jgg@nvidia.com>
 <1-v1-fba989159158+2f9b-vfio_group_cdev_jgg@nvidia.com>
 <20211004162532.3b59ed06.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211004162532.3b59ed06.alex.williamson@redhat.com>
X-ClientProxiedBy: BL0PR02CA0059.namprd02.prod.outlook.com
 (2603:10b6:207:3d::36) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by BL0PR02CA0059.namprd02.prod.outlook.com (2603:10b6:207:3d::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend Transport; Mon, 4 Oct 2021 22:34:32 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mXWXX-00ArO3-84; Mon, 04 Oct 2021 19:34:31 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 99ee6fa5-e9ff-426c-3d63-08d9878722b9
X-MS-TrafficTypeDiagnostic: BL1PR12MB5174:
X-Microsoft-Antispam-PRVS: <BL1PR12MB5174F9E4A686F795085E21C4C2AE9@BL1PR12MB5174.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Zi6QdTnEPP92+9YjDwOSc9KikcCxa4yhx5z3pzNl6UPAAXLSRTrb5qutQGhB157P3pB9j4pKioEktM82uZY5yGW8PYLCQLw5iK6k1OxMc1d8UsTK3TurpaZjsXkst02al4ow0rTCf6lCdMHkNL1Nurt1WBkY5vrnN3WyLOmrZXFcPSvENjTVvtb5rvc5N5hHQYU+XuAjgUtbcfPqNVNwWU6OzWoXsICKsi6tS+ZfUIMSHqn6CR5IFC7+9xIQyzDMpEZGOm0KJtWwAzWDCaOSF3J7txfvT9wM2vn56oZD/C+ESvRIv19avX6hmSJ3mRV8l11FLbA0YASTt1Y8X0NyPKikCbGAHtt+18ceFygwkvQ0TdcWXJkTgAmKVoMC3xDTXqFnfoeV9QUXBc4eB/SSVZh2qFJ0y23eAn0IUy8xuL7PUiAc3aeT9DP5Wq5fLXaokx5BleoM0960QhoQTRJ1ItV0CEN5M16o24J6vtSgZEJxOoa31UuRFhKdUcL7vpG6VC0OGbVCZdM2SONtg/qkYYJeSnQ+m1jNfdf8OILhZ8OlfhI6AiqGEipG/YSb4+yUAWD8DsiJH37oLBDkndscE6GcGM3jWDIfWdtauG1e01hQykWXiDX+8wMNJkmvSCT6p/M8OJIFWRFwq9M5ufnbmHLPtSOYUh/qXC0CS6KzZXSAvfhTOIuZijGfPNXeu6CvD4CL25cgmz3YdiaUwKAL/w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66946007)(66476007)(26005)(8936002)(4326008)(2906002)(1076003)(316002)(2616005)(54906003)(6916009)(66556008)(8676002)(426003)(83380400001)(186003)(9786002)(9746002)(5660300002)(36756003)(33656002)(86362001)(38100700002)(508600001)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OKpCgFcWsoZeOliXpZpcGPu6eo6xDrbnip9/kGbEzmLFKCBz1+2hp0OpdIcD?=
 =?us-ascii?Q?UcvI+O0M1ivZtgneVNETGrzyPnVhKb6IQ41Q6ZHmgpD/xzzxqrW/NQuYf5jz?=
 =?us-ascii?Q?lVpuEnzc7vYK46GbacKt608XvgkreysQsvWiFEBM0YfQUpY/VjivmfZGm6uG?=
 =?us-ascii?Q?+txhU9ZR0iVdb2IHCgSL3/KZBENjix4hjTmO1331NQyh3Ed9zrpyjrZ3kMQ4?=
 =?us-ascii?Q?eylt+0ZSkXDZOui/weK/FnRiE4e+df6IWR0aOH33As5e467p6fT46DepDp2M?=
 =?us-ascii?Q?Loq5uyuSiQKAJgVYWxS4F89rTaLlSUk0gOn/L8z2+eh/HiV5QP548A3H6XLd?=
 =?us-ascii?Q?t1Yn9Y6gH7jlw/KwPQf/NXPtAxhRGKxHQiB708VDbVKBEZeYUb9j1OKAsuz3?=
 =?us-ascii?Q?hZOZAnAROqu0UazxEzZmemdi2RaFZjk6gpw8sPgENQsmrpoweKRhTg7//484?=
 =?us-ascii?Q?61vHHtpRN3q8Y6+yPSqoJFPPeUmHdYlX6TMhcPkWtRs+QKPcX33fxDt/zDTb?=
 =?us-ascii?Q?KJM4qwvxXw8VCDRf5mY27LvDmGCnfsaIJDu/yAL3JjqDFIEyiaZy8jquQPO4?=
 =?us-ascii?Q?kluvmdhYbP2lc3VSMLT6d1PuWIsyCWkbsa2YgbrNZK+GRu57NJZOWNTfYsAq?=
 =?us-ascii?Q?+99xUD0aNe8HGOtEP0XIn6SH7FKL0Zu/R6yLoruogx7s55Ist/OQLpO6g6Fo?=
 =?us-ascii?Q?Ue6QIxAhm/4RiHX8vuJCTG1h4TR4ClF/cVAPusT2hAVm0EvxV29KoGXOgG40?=
 =?us-ascii?Q?UMGo+o55E1JlBAFgszCE2dv8yhKeCzIb1n9Kjwk18loxoLi0qByN0/kLMmjK?=
 =?us-ascii?Q?rk8SusNk+ol4T7E3ZwjZvA82yFaBJbJ4H6pxfKRxKzQitsCVXZIzp77IbwGX?=
 =?us-ascii?Q?mncRI7+HnB2SqVm9rmmndX7DpkxKgt36ZNmUaucuuPbaiL8C+lsSMQENMkJv?=
 =?us-ascii?Q?F9uRDyEH4Esp4QxUoydxoHzFtEx8qLWO3WJj8Cg+xf+mgc2IVRkgR7rNzEnZ?=
 =?us-ascii?Q?0GoE8qlcFydtvmViisFH5lHjuS984GY4m5grhwYov4dn2f5Rwg1ci0e4j1vX?=
 =?us-ascii?Q?zN75/AMHJFFXpXExwY29gL4v6zgmzr2RIWH/OC5UTGCS2WrPxcxqYk4HBK+L?=
 =?us-ascii?Q?5ePiD7skQXaAUFPnVvejdagoi/h45HhbQR4zp+Z2X7oNMWkdycVfl2YFn86J?=
 =?us-ascii?Q?qKzvs8jBFmJ+vmJf/UtcOdLj+LkudE7SjI/YX2fkmxQb7SUyj/2rHTxm/rsN?=
 =?us-ascii?Q?DISCjasozZ8zbYj9K68TRPPU+vpF3SIZIOFMwVg2SC2wZbu9Wxr0r7ve5tRC?=
 =?us-ascii?Q?WDNKSH467l4cfgcGP86SpLV6?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99ee6fa5-e9ff-426c-3d63-08d9878722b9
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2021 22:34:32.4527
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0T9lhHXT181/E93RVlUmT2EdDQNvMGm32h8oV0Pg3bbKo0bKZh4UbJTBQ30E4NkG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5174
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 04, 2021 at 04:25:32PM -0600, Alex Williamson wrote:
> On Fri,  1 Oct 2021 20:22:20 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > iommu_group_register_notifier()/iommu_group_unregister_notifier() are
> > built using a blocking_notifier_chain which integrates a rwsem. The
> > notifier function cannot be running outside its registration.
> > 
> > When considering how the notifier function interacts with create/destroy
> > of the group there are two fringe cases, the notifier starts before
> > list_add(&vfio.group_list) and the notifier runs after the kref
> > becomes 0.
> > 
> > Prior to vfio_create_group() unlocking and returning we have
> >    container_users == 0
> >    device_list == empty
> > And this cannot change until the mutex is unlocked.
> > 
> > After the kref goes to zero we must also have
> >    container_users == 0
> >    device_list == empty
> > 
> > Both are required because they are balanced operations and a 0 kref means
> > some caller became unbalanced. Add the missing assertion that
> > container_users must be zero as well.
> > 
> > These two facts are important because when checking each operation we see:
> > 
> > - IOMMU_GROUP_NOTIFY_ADD_DEVICE
> >    Empty device_list avoids the WARN_ON in vfio_group_nb_add_dev()
> >    0 container_users ends the call
> > - IOMMU_GROUP_NOTIFY_BOUND_DRIVER
> >    0 container_users ends the call
> > 
> > Finally, we have IOMMU_GROUP_NOTIFY_UNBOUND_DRIVER, which only deletes
> > items from the unbound list. During creation this list is empty, during
> > kref == 0 nothing can read this list, and it will be freed soon.
> > 
> > Since the vfio_group_release() doesn't hold the appropriate lock to
> > manipulate the unbound_list and could race with the notifier, move the
> > cleanup to directly before the kfree.
> > 
> > This allows deleting all of the deferred group put code.
> > 
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> >  drivers/vfio/vfio.c | 89 +++++----------------------------------------
> >  1 file changed, 9 insertions(+), 80 deletions(-)
> > 
> > diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> > index 08b27b64f0f935..32a53cb3598524 100644
> > +++ b/drivers/vfio/vfio.c
> > @@ -324,12 +324,20 @@ static void vfio_container_put(struct vfio_container *container)
> >  
> >  static void vfio_group_unlock_and_free(struct vfio_group *group)
> >  {
> > +	struct vfio_unbound_dev *unbound, *tmp;
> > +
> >  	mutex_unlock(&vfio.group_lock);
> >  	/*
> >  	 * Unregister outside of lock.  A spurious callback is harmless now
> >  	 * that the group is no longer in vfio.group_list.
> >  	 */
> 
> This comment is indirectly referencing the vfio_group_try_get() in the
> notifier callback, but as you describe in the commit log, it's actually
> the container_users value that prevents this from racing group release
> now.  Otherwise, tricky but looks good.  Thanks,

Do you think the comment should be deleted in this commit? I think I
got it later on..

Jason
