Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13A8E414A37
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 15:11:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230526AbhIVNNY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Sep 2021 09:13:24 -0400
Received: from mail-bn8nam11on2071.outbound.protection.outlook.com ([40.107.236.71]:24036
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230109AbhIVNNX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Sep 2021 09:13:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V31op0Mn9f2AJ5/J+/fOrfAPDb0hSm7N3xC16RcXsjW0bNPWgvV5HV7xOqo9xz7ld3PQPtkG14laciop39YNRSWSRdwFPqaE2sEcHINFxt6z+lUBh1O82WPlWY0RKqgoVgP+V3zwxv6ybpEVUV3XSgLmelusx1kvVL8xWxp0JmArsE3C+IXUqZHqSQZMVXVWuTBmDbas1AtUJJuQ/vy/yS2nqEBqva/0vGWt28yq3FgSOmvHjYE3dTVUjhySGB32/L3uTjyS54uzGuSyZABhJiMhpN+hbzO2yn8+Vf3xpybiAXFw0ZBqev/aPx4Rq6MRpyQFfvnsVUI1JIdh3/6NxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=B5vtOs+zIFEqItQsUKz2NjuNmHDj2kyT3HO9yFbIFMY=;
 b=d5hiLT2J5QXDB8RGVsmKsv022OONibR4VtusF9YzfJT0CJy0NI//TTdpKzIImZ0KhuOVLoeM5d1+OFHptsQZi69FB9AMjmv5d4J4ijzOxw8CkWASVUqS0mGF68iDLg2s90IscU2kl4aASqOM0upJ4/HuSEYLb0uoI5pzYsHTPcT0xEX9tCEHMoBzOLjG5SbLYU8c8Boy6VKZ3IwnDkI0NfqAJPemzX74V3OfylfL1OGRxmrqsaSnl7y2s9RbC/9c0YRz+ByijM/BnzmS36G2ev+2uFJmxmsBBjFxRD1tQvL36dW9f6o8T8R1itcav6y6PBB6NCjE8wp9NO7dr/l6GA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B5vtOs+zIFEqItQsUKz2NjuNmHDj2kyT3HO9yFbIFMY=;
 b=oUG8dAObvWDAWbFHEbh9HVww2E3SqzBiICmRK0HDQyyNQ2MSZZxsPuHsm5qXga/PGkYliC+mDvup6K4+so1naZMn6JzTbiyNDRlZqLPelmnOr6T4fUUNWy6Uce6xSLe0AiISH9ZENW2fi/lqUUzi4maHjNhtUdP9oZ8hOvrJPKCjDgPfB2UXye5nc8wZy2zeYkDCUXma0FElhCAGwCzRtjeZJzTmj3pSCmq6bEJm0fMhDSpyWI3EPmbPwp7Y1tPlzSA1gJ/UAXYsrESxhvzQWe1wzOaplmC6AlyOTFzT0IDyEUulagptf1PBngOnUFEatbsAC/yItI+lYOhqOUYSoA==
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5046.namprd12.prod.outlook.com (2603:10b6:208:313::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Wed, 22 Sep
 2021 13:11:51 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4544.013; Wed, 22 Sep 2021
 13:11:51 +0000
Date:   Wed, 22 Sep 2021 10:11:50 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        linux-s390@vger.kernel.org, Halil Pasic <pasic@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Christoph Hellwig <hch@lst.de>, kvm@vger.kernel.org
Subject: Re: [PATCH v3] vfio/ap_ops: Add missed vfio_uninit_group_dev()
Message-ID: <20210922131150.GP327412@nvidia.com>
References: <0-v3-f9b50340cdbb+e4-ap_uninit_jgg@nvidia.com>
 <4a50ed05-c60c-aad0-bceb-de9665602aed@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4a50ed05-c60c-aad0-bceb-de9665602aed@linux.ibm.com>
X-ClientProxiedBy: BL0PR0102CA0002.prod.exchangelabs.com
 (2603:10b6:207:18::15) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by BL0PR0102CA0002.prod.exchangelabs.com (2603:10b6:207:18::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15 via Frontend Transport; Wed, 22 Sep 2021 13:11:51 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mT22Q-003xWG-RL; Wed, 22 Sep 2021 10:11:50 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e540e16a-d946-4a28-fb49-08d97dca8aea
X-MS-TrafficTypeDiagnostic: BL1PR12MB5046:
X-Microsoft-Antispam-PRVS: <BL1PR12MB5046F5B1604674DCCACC21E6C2A29@BL1PR12MB5046.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uRnxFL0Rou+WITpB3bFzya+Jg4jqGXe3sUa5OHe6k9co2b7tmCNYBBWJ/41m7JNVOtmPdlLLNl5AJAsUrOayEwZMwt24Dqw5OOHJUCN9YuNqnbDkeQ0miNggDk0NjKNtTeE7JIaciTQTb7xBdWmH2GdMYB9B+8H7TMXjACFHbIojUUiy/pkyH2He69r03JlFpG3kWNwjnjkTclpEvpkYVWrjpH0nSUNz7tbmWQGo+8CF+mFJFxxO5vSoUgtujwLAKPizNZnHG+FlO3nbRpaJz2P0QnVExQFJN0bqWF5pFz2oMuKfQRJ0zSDoZY8VJF8sbkDelD6HUJfSErLeL+ALaglnetVd27TUtPcpwcOZ3UjNzDkR6vUK14S4XW9/W3WQtAMXirX5Q2ydHDfxjKORzknOP9HoDNgDX57GHSLfnRIqNukJfyYBIXOFDt4JUmU7Nb7KiXdQS/EL54DF4iEKKMu4FQu3e0Tl7+YezGYL7mEmjAZuAIE+ScttyshcGYe1uERzajBa4tpymVRM9HOKskD5ZD7LV9V49HEUQIyAX8dc/p3xCbSgyg8JZBIU3+tSgNcVIBI4hQa4jXktfPoc+Wi9mYIPwqLvPOHuEV9B3S+8CGjOOm90ko2bT8KSP33OE+0oX/aKOlNwxmYI4oFCr3PiCu7ataVxpK3vDbqvVNNQ9enrO/3wu8sLltW7kQpCR2J3tSga+dboIEPWwJSMsjP3FlfRuJDFFa2n6bSF2vSFqFti+UdtqXege5mFnv126I6jZz6rK1qqL9xikhZPKqs5uag3K8Wa4T+JvoS7tlo3kp+kLaFaTP3brRdBW/GE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6916009)(33656002)(36756003)(53546011)(508600001)(5660300002)(26005)(966005)(7416002)(186003)(66556008)(66476007)(54906003)(66946007)(1076003)(8676002)(426003)(9746002)(9786002)(316002)(38100700002)(83380400001)(4326008)(2906002)(2616005)(86362001)(8936002)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RcqSjB6HQ8sNGz3roHgjoshMW7fiamXmQ1zSnsISx3fLBNSQgocsTcKKejYy?=
 =?us-ascii?Q?PoQWu4u/RTdGj16RFJUy448oBauOxmUl+b4EaZU1x6oyFqmwCnM/e4niJKQV?=
 =?us-ascii?Q?3OcFd3NhDzpDUDz2tfq65h8IOuga14UxsexBqMsZYxb6qBjYPybJuRukTVWZ?=
 =?us-ascii?Q?8cXLd66lkMfRWJx/mwubszSwPHbfMQ5sbK5balG/DDqj+RqFASnPumij/S5G?=
 =?us-ascii?Q?OmyYTFNy/LmMmLlSYBssoqzm8Az9B8VoQkg1Fx+6dLrDI+rPF8bhOdXvTt0w?=
 =?us-ascii?Q?tvjQ+QFKh7pGVPKpJqJv1Lo4fCCwloQD/F6RpSCCr8vdVz+4ll1UyooXrlye?=
 =?us-ascii?Q?xbitqfFIU90RUm+S3JNMgz6dMCjHuXoD5tMfTP7f/VRJs2WlVo/TR+WWffwX?=
 =?us-ascii?Q?/jD1sAndq+puR6kmCEFnUPxj9AZdEAw/kWmVcFP23+WQmQ2d0OFEWTuyjw9/?=
 =?us-ascii?Q?LibxaVz6eNqwOfK8uQIIzgmI7aWBU7/b/d9tbvr8F0PCKup7Z0NGpcA8/Xr5?=
 =?us-ascii?Q?EtfCQJbfsd1YgjaRhQh4k9JXVGSNPSMxTAov8KgeBrRj3O0fcArkExd9kMsF?=
 =?us-ascii?Q?MjxABtvLRUfmyTnwiQ5iA8d0nLBFOgbVW2M7GdMpN3jg2UvOnqHaRoj/sb1Y?=
 =?us-ascii?Q?CGU+8juAChTuH2O1GZwUDpKJOSQ2eo8sZ9LNeuP4sNlu8+2Xw2HkYKZS3JHr?=
 =?us-ascii?Q?5kZxsdWwC8ht5USmxyYW9CAY3bsPUN8NdQmr1o+7SrBGlYTcCqOlb1CyqIPD?=
 =?us-ascii?Q?nVm9oxYdowGdpjThlssnjwpPgM+nfMxt5bLR9OJkaWBGSdh98h+8VEILnbUt?=
 =?us-ascii?Q?3HkFOjZHhEtfVMHajRK1GXUi7+IDMsl+0p6MBFp+/PPTU6Ekpr2z5W2ra5Aj?=
 =?us-ascii?Q?Uerwku0C3FIdaHOptZ0YBI3pLsknyA2gnDDRD+dWLRhyIH6LEYe5ViDlfyxU?=
 =?us-ascii?Q?yGeLgUFSVLz2icEL8tuMoHBHNjQDVZdjwlNjYwl5rWenHutrLG0hG1vywcmO?=
 =?us-ascii?Q?uT071Ya1bw+Y1qPKlmAekdQcqlJfDy7TzJzMNpYI+FBA+OKYENTpKNYTZyGu?=
 =?us-ascii?Q?AEYyYqoJXxyv1IaavbwX7TcjV9LAEz9byG/yc2ZPnBSyBKstasrdfaqxcply?=
 =?us-ascii?Q?KhbVwqFNIAj8lZzkkCqWc7Uwh7wNRLjeSyWsvK+STPAw9j8zBrJzp2Bw6NE1?=
 =?us-ascii?Q?2MKD8EdvvQAGCsk0kubYBh4jzY4l1Nv+6oP3dcn+qjePjTy5rQEvf58/sM5S?=
 =?us-ascii?Q?eIW9UZJVnq7287IEUbhNiIgLLkXLaSWtDx8VWik0ENDtJXdLDN5GoqrW6Dc8?=
 =?us-ascii?Q?HCe3fxiA7IVjluch/v8Pr69f?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e540e16a-d946-4a28-fb49-08d97dca8aea
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2021 13:11:51.8879
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XEPNnswbjtdA6HJElGxgEqvXo52LsTk2VF4u8ZhO0hYxGjfZ/xSH/fcMshMSUPYC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5046
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 22, 2021 at 09:05:06AM -0400, Tony Krowiak wrote:
> 
> 
> On 9/21/21 8:11 AM, Jason Gunthorpe wrote:
> > Without this call an xarray entry is leaked when the vfio_ap device is
> > unprobed. It was missed when the below patch was rebased across the
> > dev_set patch. Keep the remove function in the same order as the error
> > unwind in probe.
> > 
> > Fixes: eb0feefd4c02 ("vfio/ap_ops: Convert to use vfio_register_group_dev()")
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > Tested-by: Tony Krowiak <akrowiak@linux.ibm.com>
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> >   drivers/s390/crypto/vfio_ap_ops.c | 4 +++-
> >   1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > v3:
> >   - Keep the remove sequence the same as remove to avoid a lockdep splat
> > v2: https://lore.kernel.org/r/0-v2-25656bbbb814+41-ap_uninit_jgg@nvidia.com/
> >   - Fix corrupted diff
> > v1: https://lore.kernel.org/r/0-v1-3a05c6000668+2ce62-ap_uninit_jgg@nvidia.com/
> > 
> > diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> > index 118939a7729a1e..623d5269a52ce5 100644
> > +++ b/drivers/s390/crypto/vfio_ap_ops.c
> > @@ -361,6 +361,7 @@ static int vfio_ap_mdev_probe(struct mdev_device *mdev)
> >   	mutex_lock(&matrix_dev->lock);
> >   	list_del(&matrix_mdev->node);
> >   	mutex_unlock(&matrix_dev->lock);
> > +	vfio_uninit_group_dev(&matrix_mdev->vdev);
> >   	kfree(matrix_mdev);
> >   err_dec_available:
> >   	atomic_inc(&matrix_dev->available_instances);
> > @@ -376,9 +377,10 @@ static void vfio_ap_mdev_remove(struct mdev_device *mdev)
> >   	mutex_lock(&matrix_dev->lock);
> >   	vfio_ap_mdev_reset_queues(matrix_mdev);
> >   	list_del(&matrix_mdev->node);
> > +	mutex_unlock(&matrix_dev->lock);
> > +	vfio_uninit_group_dev(&matrix_mdev->vdev);
> >   	kfree(matrix_mdev);
> >   	atomic_inc(&matrix_dev->available_instances);
> 
> I think the above line of code should be done under the
> matrix_dev->lock after removing the matrix_mdev from
> the list since it is changing a value in matrix_dev.

No, the read-side doesn't hold the lock

	if ((atomic_dec_if_positive(&matrix_dev->available_instances) < 0))
		return -EPERM;

I think it is just a leftover from the atomic conversion that Alex
did to keep it under the matrix_dev struct.

If we were going to hold the lock then it wouldn't need to be an
atomic.

Jason
