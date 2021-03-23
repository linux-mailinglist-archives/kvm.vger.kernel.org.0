Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 372AB345EEC
	for <lists+kvm@lfdr.de>; Tue, 23 Mar 2021 14:06:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231278AbhCWNGX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Mar 2021 09:06:23 -0400
Received: from mail-mw2nam10on2050.outbound.protection.outlook.com ([40.107.94.50]:21056
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231420AbhCWNGE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Mar 2021 09:06:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lMHXtLfp3FL7Q+CYnD0+JHpqQ85viGPUYnfk5xrqxnJvMX7LrrG9dWOka/hG9jiw6HGf8QVBfdO6TAPfK/oOu31JnhfYER2MtS+6gyxHzi2rhRSS4E4EQCNgFgyrA7US6Iyi/HpG0p29iqAsno0ZbqK5Lb2qsVKtYlY75LFumxDViNYOyF87UxxkwF0wGfVUqSBZtAuxLgyzlBtI6nsSIsc1aMQYbEcrlQRhs8fETGRG2XcTTplPb9ygaWt09sp7qbgD8qmhGeV6F8VOnPEC9ojG0pEUsnIgCO1eKy3S12mfdK1BZS/0bhemSJZOK0Z5L4RF02rd+3u8UxekM7khQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dUGe3y9jBJVg18Pl4UMgE1IJZk4wiIe4wf+5XXNvurE=;
 b=nJaOqXOCNLblrBia7lhhC76OYlu+V3wPANWd599Yzdn8jYSIp+n+LHPEG1OHGXfsclPKIKDBBBVxFBvS0P42GFL9+YFX6n9zGOcxAF6duB3Q4b0Y+BZvypZqynZl96QCeq0MNy3iJxPaCYVc5tUMHPyya/US3DheQD6PeSaysWlVNSFybQC3Ed72T+cWnKtlkMrce+Kde56Q1rSjc6nIUHIqu+AvTATJj0eVMndr/4WV6fSJjbQ8ZY4usU9Hi4mQblEbDqvl50iG1tkHlJXTOqEkZcqJGLSD/KVTGOJrTr5GsdtfzXXAQzKJ/J2YDXhGeEyMKQKdnFhsFsUApTI9Ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dUGe3y9jBJVg18Pl4UMgE1IJZk4wiIe4wf+5XXNvurE=;
 b=nBSvBqGoPpkxbeJ0rBt76gMb7zzRgkGWKBnnT+8m+5J/AvQzNaT9t+qno+gxzrx/HqRefxmburwU6t1QYxxCxoOebdT5DKHejZbitmSzBkMj4cqyNUZ/fz8NxwT+y8jq+HNKxaf+C9EqrbvNVlYYBQ+VLYE7rb6FYCWlLphSXUB3lltgbfO/EE6Qp4XEibxNrKDtGi2uDXfkNE2AmASkm6WHh0UQ4aGBh4fL4JTSlzA1CBsfNsCGq2qElqOR+Mzt1GMMhD3TxQ7qhahRj4pMXW08h+rzDGOfXz6ogzNWzfCiVx/pDJEEs6vyvb/ZmMAaBK3dClLL72sgRBncMZ2+QQ==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4498.namprd12.prod.outlook.com (2603:10b6:5:2a2::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24; Tue, 23 Mar
 2021 13:06:03 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3955.027; Tue, 23 Mar 2021
 13:06:02 +0000
Date:   Tue, 23 Mar 2021 10:06:00 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: Re: [PATCH v2 02/14] vfio: Simplify the lifetime logic for
 vfio_device
Message-ID: <20210323130600.GB2356281@nvidia.com>
References: <0-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
 <2-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
 <MWHPR11MB18865B08DE53D9E9EE04DA5B8C6B9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210316142454.401d77fb@omen.home.shazbot.org>
 <20210317091244.26457621.cohuck@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210317091244.26457621.cohuck@redhat.com>
X-Originating-IP: [206.223.160.26]
X-ClientProxiedBy: CH2PR05CA0048.namprd05.prod.outlook.com
 (2603:10b6:610:38::25) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by CH2PR05CA0048.namprd05.prod.outlook.com (2603:10b6:610:38::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.9 via Frontend Transport; Tue, 23 Mar 2021 13:06:02 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lOgjQ-001VYG-IQ; Tue, 23 Mar 2021 10:06:00 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 75a11c85-efdf-4f6c-8508-08d8edfc6924
X-MS-TrafficTypeDiagnostic: DM6PR12MB4498:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB449824BD28079E635638CE9BC2649@DM6PR12MB4498.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZuIpvNj8OwNTdtR1a/EQs96+E9Y1iXd2QKjA4UtEf/H3GUb1hAffRnBhZyJmgUkUceSlz/dYLGOjC/KNYTo7eADL3FR9XxNmcH++pI9RjYLcMZ8OZnNW3VrP3XPidRXq3J7Obw7Qt42gDGcEw+2Drp/GudEHN6ept0ZPWS2oekrv3tcJeKJ9aE2KDQC+rcktXIyT+bHLWiGTpQBNnxS8XhTt2LKgHTi5sl2ebCfRa7MTUd6pjapl5lESw4FGD1HqtXXARmha+SSC4dSZ8Xg7YRUwEyXEQvTyxhsMrv8WJ8E2pS/FFuGD77Y5FpRHsLgqQPAFAqNH1gRaFW4ngsKD15NnAlRjA4jG88sbnlrFieusL3hpFQD68gvMkkNZRKsixlv0B2KjWcUTPBzIXKxUVS5Dz9eyZtv3Tb0b2mtqjxnwSNHbM22rPqH79aZuL2yV0O+sARG/rLv8Lmmvnosayc2Xl+ptO4QrfmKkbqFgttL4L8KIladPrRxhkSOHhoLluFk7Pah8Mqo78OKbrA+1/MZw/oXSPqTkZQdRXLoOCRr+ArWZzCPuXHkiBOtW1ujQobwnJrGEs6benGrDlThkoDMMPk45Nlwc7GlmYEK0Mu6KUcdo5ROttFtNqP8cr4Hoe0miUGrqJ4ZXKkiD0ii3O/4gryvHQGapX8VI506jQ/U=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(396003)(136003)(366004)(39860400002)(54906003)(1076003)(2906002)(2616005)(426003)(107886003)(86362001)(38100700001)(478600001)(6916009)(186003)(8936002)(4326008)(66946007)(26005)(36756003)(33656002)(66556008)(316002)(83380400001)(9786002)(9746002)(5660300002)(8676002)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?7Yic/U0s3LPsdYA4o1AmWrHef8R+t7H/lP9RAo0EIpzEHqeAbFrWgPovwpK1?=
 =?us-ascii?Q?2bdUwdkwK4OcIYe0HCfsFRd+MthWZB295CcQzigZA0AgW21Fp3vdjGZj8VeK?=
 =?us-ascii?Q?UhdPHXde525573MbjOwkuxZp4EI8TAVIkPFfJT25RO6G3LeMi4KSeHZZrfOJ?=
 =?us-ascii?Q?+fMpfYtxzeQT5rHMtFljlc1wq5q+Ub+eHrsPy8WU9h/kSLBKsdibMg6iITmb?=
 =?us-ascii?Q?tXEzbDfnpsCVGVicFfrAFI8vd1/uEfH5Zj/NhejRc5+lqD143lMyu6qOB2V8?=
 =?us-ascii?Q?GQprt9d7169ibfOZdn8/fwU4tZMjRzWmspNnxiLofxZGqCmaXIDfPhq03wpq?=
 =?us-ascii?Q?Ti6+nbGagxycYZ7gzJiwtF5C1eNJeYctx4HJMcHTeCI610+UswbMJDcMOcdK?=
 =?us-ascii?Q?pdKhMbCXHwsvlYlOEl1Al73X7bO+a5WqSWSue0CR5wFD56QATRgMaG8q64hD?=
 =?us-ascii?Q?pVH86rHg273h5830mPARe8AJj/rmU7dX2Oxe4adtT4xLVf3UeEJa3nrlAVlX?=
 =?us-ascii?Q?VsVCSm32QY/a6Aq2HizwjtQY/+UpZMb0NR+JniL8SU5yNuWvi3Hqo9XIHY59?=
 =?us-ascii?Q?QN7cfdEeyfnDB8Om7uP4+87P0bWwzcaZQXr8iqT9dFzZKmio7dZWvLV1Q//R?=
 =?us-ascii?Q?eMkDk3IUtQ1q7/KINPJYLmzVIAeFaS0xOxrh3egCGpXJmtYRzTOb6US2enys?=
 =?us-ascii?Q?kDMFGkLtt+pS9hfHv8qaSgrp6KiZ0LzNKepc/fclU75VWFMkZmVn3l5+ZNWA?=
 =?us-ascii?Q?UeafU9a5Es2cLtmt8G6Gs5dtjY+Ox5meU0PtecasvtwljLeTCXtidPd7TABw?=
 =?us-ascii?Q?JA1FT/jo3bh5oqHzuXR+aq2aOVoZr+DUKJkHq6xnE8lGNGuaXbu+9LTIM8st?=
 =?us-ascii?Q?lTTkZc8FjFs7LbrBcPEb9M/6d5cXrI9fB2gpytpP811SP1JOp/Iw9dRvBu2z?=
 =?us-ascii?Q?m+Z0MbAmND4DP69DXiYzc3ny2YLABasdic0wX/EDQ4PXjBDeaJUSE3yNXZFJ?=
 =?us-ascii?Q?vZx8h9GyN7A9l3hxgPj74Yjk6YGWeUapkL4RYhbWNSqO2onHuX8iGaHZ1Y++?=
 =?us-ascii?Q?lfZVxnyIjZeBc+wkACKbGaQE1I3C5im9j6oGMxj8JLj/pBLkTJzDPaKB26Ak?=
 =?us-ascii?Q?y90Lk8Zc3BxolAGuKHT3fPX+x0MT8FEr1KqsmtqCUfdZRE8R3Q+va1ftYsJ5?=
 =?us-ascii?Q?TFgZ+RPdxQ4jbGtdIPOV/QdUdAkgpoAsdxJz6feQYQ9qQbhtlBwaKe4NQn0R?=
 =?us-ascii?Q?f7eqoK3T7DbE7GMSOoOOJm99vi3b4qOoZSV9EnXzmXWiRllDsHDT4HbMFSHU?=
 =?us-ascii?Q?RC/W/11c7SBQhf0p/wrK/NUh?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75a11c85-efdf-4f6c-8508-08d8edfc6924
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2021 13:06:02.7645
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /WFVH+nJkHlRf9XRLKl677JzXT0pQnxzER05TrfbvPXxcnZ4ZxueYy6SWVhNRJRl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4498
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 17, 2021 at 09:12:44AM +0100, Cornelia Huck wrote:
> On Tue, 16 Mar 2021 14:24:54 -0600
> Alex Williamson <alex.williamson@redhat.com> wrote:
> 
> > On Tue, 16 Mar 2021 07:38:09 +0000
> > "Tian, Kevin" <kevin.tian@intel.com> wrote:
> > 
> > > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > > Sent: Saturday, March 13, 2021 8:56 AM
> > > > 
> > > > The vfio_device is using a 'sleep until all refs go to zero' pattern for
> > > > its lifetime, but it is indirectly coded by repeatedly scanning the group
> > > > list waiting for the device to be removed on its own.
> > > > 
> > > > Switch this around to be a direct representation, use a refcount to count
> > > > the number of places that are blocking destruction and sleep directly on a
> > > > completion until that counter goes to zero. kfree the device after other
> > > > accesses have been excluded in vfio_del_group_dev(). This is a fairly
> > > > common Linux idiom.
> > > > 
> > > > Due to this we can now remove kref_put_mutex(), which is very rarely used
> > > > in the kernel. Here it is being used to prevent a zero ref device from
> > > > being seen in the group list. Instead allow the zero ref device to
> > > > continue to exist in the device_list and use refcount_inc_not_zero() to
> > > > exclude it once refs go to zero.
> > > > 
> > > > This patch is organized so the next patch will be able to alter the API to
> > > > allow drivers to provide the kfree.
> > > > 
> > > > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > > > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > > >  drivers/vfio/vfio.c | 79 ++++++++++++++-------------------------------
> > > >  1 file changed, 25 insertions(+), 54 deletions(-)
> > > > 
> 
> > > > @@ -935,32 +916,18 @@ void *vfio_del_group_dev(struct device *dev)
> > > >  	WARN_ON(!unbound);
> > > > 
> > > >  	vfio_device_put(device);
> > > > -
> > > > -	/*
> > > > -	 * If the device is still present in the group after the above
> > > > -	 * 'put', then it is in use and we need to request it from the
> > > > -	 * bus driver.  The driver may in turn need to request the
> > > > -	 * device from the user.  We send the request on an arbitrary
> > > > -	 * interval with counter to allow the driver to take escalating
> > > > -	 * measures to release the device if it has the ability to do so.
> > > > -	 */    
> > > 
> > > Above comment still makes sense even with this patch. What about
> > > keeping it? otherwise:  
> > 
> > The comment is not exactly correct after this code change either, the
> > device will always be present in the group after this 'put'.  Instead,
> > the completion now indicates the reference count has reached zero.  If
> > it's worthwhile to keep more context to the request callback, perhaps:
> > 
> > 	/*
> > 	 * If there are still outstanding device references, such as
> > 	 * from the device being in use, periodically kick the optional
> > 	 * device request callback while waiting.
> > 	 */
> 
> I like that comment; I don't think it hurts to be a bit verbose here.

I would prefer the comment explain why the driver should return from
request with refs held and what it is supposed to do on later
calls. This loop mechanism is strange, I didn't look at what the
drivers implement under this.

I don't see this approach in other places that are able to disconnect
their HW drivers from the uAPI (in RDMA land we call this
disassociation)

Jason
