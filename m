Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45E19407355
	for <lists+kvm@lfdr.de>; Sat, 11 Sep 2021 00:26:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230018AbhIJW13 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Sep 2021 18:27:29 -0400
Received: from mail-bn8nam08on2053.outbound.protection.outlook.com ([40.107.100.53]:11617
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229474AbhIJW12 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Sep 2021 18:27:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZLjx8eZezaCKXGaV+09ZVoo4kBoxvcptFwUDCk6xfFN8VmpuCfl24stcV6c8riZ5hR3bR2YYTySVEYl3LZavl9jcsPPZUK9FVxhkWm7gHKYjuTTaZ0fF4IG1DfsZLKkk0lK1hzQRt8gs7IoRFtMIVqfw27oDb47DCVkcv71GvlF/xPi+yA1x5PztbglirhxAVKiT4tbIeu4X4gAlYonjvbY9d9PeSHDWPLUa6Io2L/+CdwLe8DwDQhxAeftjE6CxDHjMygJ4rST1iJr7P0E2NEquTlVGGxvy3tNMjJGVswcGQbrn3HTfrc4Ucr/DcLAYIBgZLoEwEVmLi7zw3Dljfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=npimqYWbevy/eUHfWf3Ti49kTeL2kV6d+BBqrJQJ8cU=;
 b=cwUIiyhftypH+e0vXlzEMHuFdoiIRzJedO810Xbk+8lqaoGRHwkyq8Zlje3fNqKpgQS8IVYTPiDV/Lml+jjBqirnJeG3WEgzq+18wMpDwNJpLUFjqVKYX+bH61tKylvsu1SPpVlxnIXwAqAo2/kLP4pFw+tLFvlMLwzeyb8MAEIGm3MpymXP7CHnFdTpEWkr/sT83jvAOdHyWRnXpN+L0ITQp7nWHArAoo+DfPQmok4Omkqj5Y9gzBoF0VVQsDw5a8JFKlsJJYLzd0lRYX+gDqzeTLBuwqQkvHMbg4fUylQbzgj6jzvNqdY2HCuPO1LVHZwBBVGPpdgZTL7LBDzLXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=npimqYWbevy/eUHfWf3Ti49kTeL2kV6d+BBqrJQJ8cU=;
 b=nNP3AEewukPRg7LkPzD8MMr9v58035pPnTxE2W3wt3oblEVEs9eQ+n1bUn7Zm25lxcLwQBxLVTzu+lAGy3fMN8ZXvuCMxlX8BovX6JU9wf3+LswgsTC7f1Wr9M53h+FV8lCJRahZuB9oJIc1t0FDd0zuw+JhIEazqp6SMhvh/B1JkAZLKauJqGWuZZX5E2aBWod6COLOLTNxhGMl8IKbMOODk3Ps5NLGdD+oNeCYXUFIS4Out9rcuPjYurOCY46UCekixCRbExLn/Kt6XFuwv8lk47kY7Q2BEhqri6PsiYGh+D6F4If59kV2VOjMfcEt7nZ2+Go2Sp3vkdcbbw+WXA==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5191.namprd12.prod.outlook.com (2603:10b6:208:318::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.16; Fri, 10 Sep
 2021 22:26:16 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4500.014; Fri, 10 Sep 2021
 22:26:16 +0000
Date:   Fri, 10 Sep 2021 19:26:14 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        linux-s390@vger.kernel.org, Halil Pasic <pasic@linux.ibm.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Christoph Hellwig <hch@lst.de>, kvm@vger.kernel.org
Subject: Re: [PATCH] vfio/ap_ops: Add missed vfio_uninit_group_dev()
Message-ID: <20210910222614.GV2505917@nvidia.com>
References: <0-v1-3a05c6000668+2ce62-ap_uninit_jgg@nvidia.com>
 <20210910142531.2e18e73a.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210910142531.2e18e73a.alex.williamson@redhat.com>
X-ClientProxiedBy: MN2PR22CA0009.namprd22.prod.outlook.com
 (2603:10b6:208:238::14) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by MN2PR22CA0009.namprd22.prod.outlook.com (2603:10b6:208:238::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Fri, 10 Sep 2021 22:26:15 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mOoyM-00FgFE-IP; Fri, 10 Sep 2021 19:26:14 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4c44059a-5e72-4e4a-47bb-08d974aa00e1
X-MS-TrafficTypeDiagnostic: BL1PR12MB5191:
X-Microsoft-Antispam-PRVS: <BL1PR12MB5191C00C2DEE07A032F471DEC2D69@BL1PR12MB5191.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:178;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bup3HnYnhez/UnL9SRRwlmxxtwkjWxebN8Mi7kjGxVCN+Glsc4h2rNnErXdrg5XKhjb1ifDg7o4EsEbozjeSdheqFrpQaRoJjQFNjfC79GOYiiFhRwiYfKSTlQ4XdMvvRUMJneZbF9R2AS+2zDGSp9VO1LZkPU8K29Pqv8LZq7eqWQ+PuAs45F93VHLZHaxpFKyzPgbaq8b3OBmzcbMbFjElbtrIJ+kXDh9crO/4gcthnwEbKpk/SrEnuFtwf2MbTDS+ob19sD81udXWm2D7iGJhgby5LHef3pYz3Ta3RICCezJJvaT738nR1gny2caGNVWikwmsVH02o7OkfKK2pZCEzbjG24qlUFkvA87qFgPXX4OSj8oyBOMgiTT+1IYMNx/Rhbnqrc1THWliQDos1CtD5VpXo3nFrHBpZB+XnvyzROnWanZVIl1OPJpRexEBgWCOHjiw+Kp/KmC+EV+ESk3SafmXRqDKvZlRvIsdUv4NGB9V2cVcNayfOtk7aGTkUrBauKPBYArZsFe7dr6sNcN3kA4ldOoLlo5hcg/8TST6rXCNK6Gvf6vR7RY5wYCQ/wc//zJIjspXCIRNydVULEqapSzBQ32HkX1vOmWOni1WKKpLKqEt0dE9RmJ5VHHiCgPM3PbuN6ao7/labn7/yQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(396003)(136003)(366004)(346002)(83380400001)(2616005)(66946007)(38100700002)(26005)(54906003)(1076003)(33656002)(4326008)(36756003)(478600001)(9786002)(9746002)(7416002)(8936002)(2906002)(8676002)(6916009)(316002)(66476007)(66556008)(5660300002)(186003)(86362001)(426003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ox/e+NZSGahMtKCbSLYpdj4lXduXYTVSACipY/19RvM94C3ZQUEg06la47/G?=
 =?us-ascii?Q?mg9w7o/GXTq4C1eb1huhTj/rfrcZYiyiTToezQBqr/jqv9px71Fx0li0P1iH?=
 =?us-ascii?Q?YYNx5dDWdCbzT8zepSAn+IIEcwVPaoPO+srQcFYw8wU+qTHdQHRwwDm+hFn5?=
 =?us-ascii?Q?7JyoojRYldwDJ7eln/3ST1eTq8ID4aPa3cMrX9O87EurBIYZ2hB2SgXrBAuu?=
 =?us-ascii?Q?rCTo/timccuaXUw8SpncofcAygSOC2zW+9S1dQYfEO3JilAx5VVIDkj+DEYV?=
 =?us-ascii?Q?bPAMJmDAY8QlaXwL0OtmcKZR3/S+eA4ibqN8gb1uCjzzbIHJh5UTjiNO4nJg?=
 =?us-ascii?Q?cAnRotMsOZramD9Z73WBShD+jSYDxKQTscVNBnIUTvb1h9pIBKPbWsUWsgBp?=
 =?us-ascii?Q?5KvHoY1niN0E71Vvh95MdaPJBqsWHVTtc0Lcg0L+3RENt45NfErWiIgyqcvJ?=
 =?us-ascii?Q?F5AQlC7fAWNz2JDvyVJJjv2Kt2GgP7ilrqWmzCU/CRQV3eYVJNnBBqa1w4O0?=
 =?us-ascii?Q?pILX9ixGtpN7V0fQSqg35dfx3rk1C1xILQMZa8AMFb+az38AGDSbp7VwAFBW?=
 =?us-ascii?Q?2HWC5OTG14aBSuVUuYQPfmG+XNGFqHJgyP30IE6WQgJekDQBgt+HyPhMcNru?=
 =?us-ascii?Q?pU5EnmfSTjPsXfljUv3XJMtTk66EEHEpQk7B7ERpXN1KBh9Th2qrYCPG3Ss3?=
 =?us-ascii?Q?4WyLEvZSjkB9Lzwnyd3oNsnmZlh2ETpRCb00z1zPeFKQtgWD/EJia5cfGxk8?=
 =?us-ascii?Q?TBR3/AhOdrtsy4P68TX6/rmVP8MfkDXkhnt3u1x83AQsxDAIoJubEAHYmBOm?=
 =?us-ascii?Q?GzqoFo+QXqVeSFrvuw+zzYbYA86fVMunkQ3wNgEi100zr41jes5+GHeiIQOz?=
 =?us-ascii?Q?zkXyNnCYWAnU3cvOziMZ3yQXrW5uKO5AanEB92cUkI2UWKd19y2x4v1wl8Xe?=
 =?us-ascii?Q?0NIbMRgu5X31EpQYP8GKZy9EhQHwnHqi3tYfbAfm4Vf7+qcj13OxvIZ7HuuE?=
 =?us-ascii?Q?ExAFzt5zX/6XLIESp5O2qTDyRKvYcLgySkdzhcKvGAqfw5VP4VDU21SIwdvQ?=
 =?us-ascii?Q?DbvvCnGvIppV0Pw912wq5qX4wdl/OCCJspeA3GpbdxS4Ii8empfWqoOWKJVG?=
 =?us-ascii?Q?ceLCr1iE1QrbA5es1dfH5Cyp25QKbiLpKCokKT8fObxwlwEsyaebVpcICEr4?=
 =?us-ascii?Q?Mt0CEkNaK49VFdPB/lCqkbgYcgUm+VlvIlKnzUMfyLvVvHdSyjXae0bLVq7x?=
 =?us-ascii?Q?9h+6IeeWWYqu622R6RTfVInY84fCi6D+9UcGbBUGAwYMjkXfOnS7pY0r4twt?=
 =?us-ascii?Q?pTsnPjW3LHGHst2t19WaJHw/?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c44059a-5e72-4e4a-47bb-08d974aa00e1
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2021 22:26:15.9802
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c9DxdtHw1ymNcrNv2/gI6Qu7V1KLtlNZHLo5qX2STE5NGCf3vKGEf971R57BZx2Q
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5191
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 10, 2021 at 02:25:31PM -0600, Alex Williamson wrote:
> On Thu,  9 Sep 2021 14:24:00 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > Without this call an xarray entry is leaked when the vfio_ap device is
> > unprobed. It was missed when the below patch was rebased across the
> > dev_set patch.
> > 
> > Fixes: eb0feefd4c02 ("vfio/ap_ops: Convert to use vfio_register_group_dev()")
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> >  drivers/s390/crypto/vfio_ap_ops.c | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> > index 2347808fa3e427..54bb0c22e8020e 100644
> > +++ b/drivers/s390/crypto/vfio_ap_ops.c
> > @@ -360,6 +360,7 @@ static int vfio_ap_mdev_probe(struct mdev_device *mdev)
> >  	mutex_lock(&matrix_dev->lock);
> >  	list_del(&matrix_mdev->node);
> >  	mutex_unlock(&matrix_dev->lock);
> > +	vfio_uninit_group_dev(&matrix_mdev->vdev);
> >  	kfree(matrix_mdev);
> >  err_dec_available:
> >  	atomic_inc(&matrix_dev->available_instances);
> > @@ -375,8 +376,8 @@ static void vfio_ap_mdev_remove(struct mdev_device *mdev)
> 
> 
> Not sure if you're editing patches by hand, but your line counts above
> don't match the chunk below, should be ,6..,7 as the previous chunk.

No, never... 

It took awhile to figure out but it turns out emacs did it?!

I've been trying out the 'base-commit' trailer feature and removed it
by hand from this patch before sending because it was just some bogus
local merge. When I did this emacs diff mode wrongly thought the diff
was being edited and corrupted the @@ line.

Wow, I had no idea it could edit patches :\

Jason
