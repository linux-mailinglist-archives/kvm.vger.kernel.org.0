Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 268E74149AA
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 14:51:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236140AbhIVMw0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Sep 2021 08:52:26 -0400
Received: from mail-bn8nam11on2058.outbound.protection.outlook.com ([40.107.236.58]:49080
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236045AbhIVMwW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Sep 2021 08:52:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NV4qCjeCPRWRR83jGB0e3g9k5QlMKh1E9C4otziesbnrznvNQzaRGmRw/NxT7hsr2LcVqk8ZfK/iEXtzQKgiFI7u4jeYyMFcwVY7ozDyI88j7zpHMbemAlKwebVt+j0aTIbLmu21viKztSICWAzneU1m6aYHhmlIPzgIIsiPg9w6q4UGn5kQl/33DBaDCg0dg8hLv02DriSmSHnHUDxZa1UFZQuEko0sgLniufkKIGSW/NVIcQV3m/GT7c2TwrJLi7up+1zzQCxD+L6LcVjhuA3MCjCpBODgOh5MW4qZqFIa0TbCkxopWMijKNx8nxKWFvx9PUQxMZS/QqQFyIDYTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=OHdt55+FMlCtFHNx1YggktsZBOs+yBUpYoNLMN4FTf0=;
 b=FH290lQpVgBLCow9CmOTxI/Ewyj7V/feZzE/LoBIJF2e9Ga2IaCscCL2QsCHbGDnqXR3pTCY/8OnXIlS/8xhIzcTFAtjqHPph/g5RbwzMAjZvScQoatvCa+WumuRtAHntkc58XOb2vt/lBDzAD4u5E+qLZXiqIOHwKwPx8VEN4wnZu0TK54qG93ZIjE11ASvwOHmmW8Lckkf8ylqE/9bXfphshX4JqYqqblhKo5Hlqsvz/9HfOFG9FuAXdR0z9xL+VOeLnjEfr6FRf9NUVep2HBvs/hzJw2XTNlNj8vR7XeQ8ojhnRigVYp6XQMVh5G65n50KCyRDqFKOh5CgGmMrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OHdt55+FMlCtFHNx1YggktsZBOs+yBUpYoNLMN4FTf0=;
 b=eaibNO0DrSx0f6pcHOFvNZGhszZX/yYKXT3be49dV3XloHAixLW2LYhE7D/h1+6puny4+dbivnw9xgaWS90cSjF+vMmwuyzwSjfdSiGuncwmi58/aaCcXCf5tddATgyYJmLvvN0xn6l1hOzU+0nvHPuTMv08uXwQ65ELWbEeJ1jdKjOswCKcZnAk2Zcp7pOndbDwBgpfzWmYN8BR00xpONKdG2+pYf17gXgXKVQkCaX0wU0+8bvHVHF7DUFff9NxEI6mB0F/BPCPYtJuNdZtlyWn+jUJA/NifQGvwRfgBQCOUE5FyNtUpFNRPeAO2vngvTlHrAdvHUWm+oLsy2QKVg==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5238.namprd12.prod.outlook.com (2603:10b6:208:31e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Wed, 22 Sep
 2021 12:50:51 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4544.013; Wed, 22 Sep 2021
 12:50:51 +0000
Date:   Wed, 22 Sep 2021 09:50:49 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "hch@lst.de" <hch@lst.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "lkml@metux.net" <lkml@metux.net>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "lushenming@huawei.com" <lushenming@huawei.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "yi.l.liu@linux.intel.com" <yi.l.liu@linux.intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>
Subject: Re: [RFC 02/20] vfio: Add device class for /dev/vfio/devices
Message-ID: <20210922125049.GL327412@nvidia.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-3-yi.l.liu@intel.com>
 <20210921155705.GN327412@nvidia.com>
 <BN9PR11MB5433A709ED352FD81DDBF5A68CA19@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210922005501.GD327412@nvidia.com>
 <BN9PR11MB5433023B883A6EBDE8D80AC68CA29@BN9PR11MB5433.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5433023B883A6EBDE8D80AC68CA29@BN9PR11MB5433.namprd11.prod.outlook.com>
X-ClientProxiedBy: MN2PR01CA0027.prod.exchangelabs.com (2603:10b6:208:10c::40)
 To BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by MN2PR01CA0027.prod.exchangelabs.com (2603:10b6:208:10c::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13 via Frontend Transport; Wed, 22 Sep 2021 12:50:50 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mT1i5-003xBE-Ru; Wed, 22 Sep 2021 09:50:49 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9f587440-0836-4efb-80af-08d97dc79b62
X-MS-TrafficTypeDiagnostic: BL1PR12MB5238:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5238A5D298780DEFBFFF2E21C2A29@BL1PR12MB5238.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0c2kk3qkl2Ln1dDmBHZcwQgCd6p848uzWHGwAWpnQGoo/a6ku+wuMuKbvjvtFIqvSayMQJvC+Aw/VpcOuGf0Ok4Qf8+TIZKLqFFuzYPUG5z9ac04lg3PWOT6UIOhjPY4qfWIQGVIWteHzm7dStt+er9PTc9SqEMQYebkA7H2ISakfn1jq1i00tF85ztkP7IVdnaNmGKIiIT1gjc+34W1Q1CjEMlbrkC63N+5fSjstOTOxIeQ/fYLv2sbw+kPhxdgVnWayEb8ECq7kJnrKNK02hM9fBkff2g/JzqD7CHcM1CPlS4EdiGNrU3Y114cuT1oyhoa3Ux1UmoOWRnz1Oor3VkjaRNR3ZtWG82Md8ESCX1xCaxQiB3nFfzg2KdDpn3OEk4weMMcSQ5N8lji9uWEOUbgntvRqXy/uQmbZPqvgfkDrwEBId0NfSZaEtPNIxAW1Jpbhedd17k2rLM5WgInvr1ckWQ7RvMJhsUNe3rTvgtaZ4eaV9nrSKIHY66NtrWgguU8zcHqV1myrvfzfQzarQmj3L75L0llD6phiESbQrc1jEzg8/T2pi5aM8wTTaAcjze2ZvFQj2YledWc+jKhtE2T8NmKXMhr9hlzOJZ4rDsw1jK6WXg+6qVHSITJ6UrTEOI4TrChdUMkvryvhxALqFumAvLxek+qSRZtZz0dnS6sJDa7rb2nrp7Q7Ekr1wiq
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(9786002)(8936002)(426003)(5660300002)(186003)(4326008)(7416002)(54906003)(9746002)(2906002)(8676002)(83380400001)(107886003)(316002)(38100700002)(86362001)(2616005)(1076003)(26005)(33656002)(36756003)(66946007)(6916009)(66556008)(66476007)(508600001)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Jer3FTy1LiHy2F8u/oS5Uq6ZT/XBXBq7qNCzBuNw6S03RiBdwc2m9dENCLWy?=
 =?us-ascii?Q?QW9WrSikFKuhN1YS3TFnWwjoE9ItCUdQGKO1ew54xZywxQ4cXMCi2C6yuXhw?=
 =?us-ascii?Q?4IZ7XwvpDfk60HqI8jrM3FgyH/X6nAttU66GVvJlCYW1FM9AE/F7UlyxLOGM?=
 =?us-ascii?Q?oFWggHSGY/2EevOgjOAvZxvFxcE10/plWWyjDFgL13AtSnGj9kH9JHyH0S5p?=
 =?us-ascii?Q?7sSu++qtp3uCwLpHwffRs8ehtydVcs3Lk7pb8k8oBr88FjUkTBvAd3NW0L8m?=
 =?us-ascii?Q?RRtIET7wsGUrhu5mhZf3umAK3gfRXW3oZiRmny43rSRJh0JNkwj06aASc2QP?=
 =?us-ascii?Q?aEq0nAB3BNlGv/rou9sonYRWPiXWwijKrPvWZZCAeRHGJurkWtXpAK5nAe3G?=
 =?us-ascii?Q?U0QIcCYnE3fxo98XCBVFP8PN/yw0s23CzAbH2smPHzql+7ISmO1GGFTriGBb?=
 =?us-ascii?Q?FZ/vmphh6KhrPq524N3Na0o8C7QNnLaLKgOPdV72cQ+1LoQbKH1hwtmNn/13?=
 =?us-ascii?Q?t/o6Ir7LrQcWDS8GWijEovYppU6fBbrKZAvDxZPDU/zTau3Gmfnau2ch7YEQ?=
 =?us-ascii?Q?GyvBl2AXHu7skyXgSh4e673iCUBDpdbpn0e+xlXvD430ox04bUGeYkytqGNe?=
 =?us-ascii?Q?KgYLeiqaI8lVQDzXE23nzUesCopD5H3fplOhdItDKg2Nz5tpjkYHjsEayrI4?=
 =?us-ascii?Q?gzWX6hil103555xS/RSnB/TT7luh3LnDo84v1xlkz4KIS+Qb+tUSEOro6Huu?=
 =?us-ascii?Q?KtMh0K3puG9zotm2T0xGtSDRaY1f1w6OL0pV4kcVZ3JnFw+nM6CLxVVGid5s?=
 =?us-ascii?Q?DNA56vvQ/3hgJXztKq7cv+JMOanqMAFIFxouydi5oCGLsMMBvEjuvs9TZFxx?=
 =?us-ascii?Q?pObvYXX4IO23GAVhQ96BmLYBKbngU/hhalpMr6WVjrGk/Sq7XlTk1zp4fC68?=
 =?us-ascii?Q?gNmdniUOKeMZI/IR1Zvd+WM+lmhv2uD4E5cEkg2J/pEktW/ST9iKJbiJRptf?=
 =?us-ascii?Q?N6CioA69eZsveOwek17/n0KFzydwH/zpTISuHDk8Bni0h+4mjUIT8FXMylcz?=
 =?us-ascii?Q?WBbf7Fvw4RjZNQeItMqPDniSqidjNQiPqlaJwEjS2fcuI2rJoZacJ7sJr8r1?=
 =?us-ascii?Q?nJQPA+85aXes9QEiaQZ27EtRPiHMUX+4DoJXpl7MLXGpbdKk9Kjjmtuoh712?=
 =?us-ascii?Q?loIGRQnvEkoz+8yiQ6Z+T3q0G0TpWJSNetIW5fjOg/uBSt7WRfHTKTdZQ9s8?=
 =?us-ascii?Q?w2EBsgYqm62OJOLjNPbVTnyF/vta++G6PxWp+5F35rjxJjuUIhPBJqbfkNIW?=
 =?us-ascii?Q?/fLr5OnxRPIVnAeDP7zlutNo?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f587440-0836-4efb-80af-08d97dc79b62
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2021 12:50:51.1779
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cCI5NC8XjRswLghFbaEv3iYR0CTwOBVO15RSCw1sB3MZeCeqqIDtxUDBq3xLUPdk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5238
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 22, 2021 at 03:22:42AM +0000, Tian, Kevin wrote:
> > From: Tian, Kevin
> > Sent: Wednesday, September 22, 2021 9:07 AM
> > 
> > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > Sent: Wednesday, September 22, 2021 8:55 AM
> > >
> > > On Tue, Sep 21, 2021 at 11:56:06PM +0000, Tian, Kevin wrote:
> > > > > The opened atomic is aweful. A newly created fd should start in a
> > > > > state where it has a disabled fops
> > > > >
> > > > > The only thing the disabled fops can do is register the device to the
> > > > > iommu fd. When successfully registered the device gets the normal fops.
> > > > >
> > > > > The registration steps should be done under a normal lock inside the
> > > > > vfio_device. If a vfio_device is already registered then further
> > > > > registration should fail.
> > > > >
> > > > > Getting the device fd via the group fd triggers the same sequence as
> > > > > above.
> > > > >
> > > >
> > > > Above works if the group interface is also connected to iommufd, i.e.
> > > > making vfio type1 as a shim. In this case we can use the registration
> > > > status as the exclusive switch. But if we keep vfio type1 separate as
> > > > today, then a new atomic is still necessary. This all depends on how
> > > > we want to deal with vfio type1 and iommufd, and possibly what's
> > > > discussed here just adds another pound to the shim option...
> > >
> > > No, it works the same either way, the group FD path is identical to
> > > the normal FD path, it just triggers some of the state transitions
> > > automatically internally instead of requiring external ioctls.
> > >
> > > The device FDs starts disabled, an internal API binds it to the iommu
> > > via open coding with the group API, and then the rest of the APIs can
> > > be enabled. Same as today.
> > >
> 
> After reading your comments on patch08, I may have a clearer picture
> on your suggestion. The key is to handle exclusive access at the binding
> time (based on vdev->iommu_dev). Please see whether below makes 
> sense:
> 
> Shared sequence:
> 
> 1)  initialize the device with a parked fops;
> 2)  need binding (explicit or implicit) to move away from parked fops;
> 3)  switch to normal fops after successful binding;
> 
> 1) happens at device probe.

1 happens when the cdev is setup with the parked fops, yes. I'd say it
happens at fd open time.

> for nongroup 2) and 3) are done together in VFIO_DEVICE_GET_IOMMUFD:
> 
>   - 2) is done by calling .bind_iommufd() callback;
>   - 3) could be done within .bind_iommufd(), or via a new callback e.g.
>     .finalize_device(). The latter may be preferred for the group interface;
>   - Two threads may open the same device simultaneously, with exclusive 
>     access guaranteed by iommufd_bind_device();
>   - Open() after successful binding is rejected, since normal fops has been
>     activated. This is checked upon vdev->iommu_dev;

Almost, open is always successful, what fails is
VFIO_DEVICE_GET_IOMMUFD (or the group equivilant). The user ends up
with a FD that is useless, cannot reach the ops and thus cannot impact
the device it doesn't own in any way.

It is similar to opening a group FD

> for group 2/3) are done together in VFIO_GROUP_GET_DEVICE_FD:
> 
>   - 2) is done by open coding bind_iommufd + attach_ioas. Create an 
>     iommufd_device object and record it to vdev->iommu_dev
>   - 3) is done by calling .finalize_device();
>   - open() after a valid vdev->iommu_dev is rejected. this also ensures
>     exclusive ownership with the nongroup path.

Same comment as above, groups should go through the same sequence of
steps, create a FD, attempt to bind, if successuful make the FD
operational.

The only difference is that failure in these steps does not call
fd_install(). For this reason alone the FD could start out with
operational fops, but it feels like a needless optimization.

> If Alex also agrees with it, this might be another mini-series to be merged
> (just for group path) before this one. Doing so sort of nullifies the existing
> group/container attaching process, where attach_ioas will be skipped and
> now the security context is established when the device is opened.

I think it is really important to unify DMA exclusion model and lower
to the core iommu code. If there is a reason the exclusion must be
triggered on group fd open then the iommu core code should provide an
API to do that which interworks with the device API iommufd will work.

But I would start here because it is much simpler to understand..

Jason
