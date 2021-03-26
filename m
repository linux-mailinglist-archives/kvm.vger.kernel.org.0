Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D1C534A6A5
	for <lists+kvm@lfdr.de>; Fri, 26 Mar 2021 12:55:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbhCZLyk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Mar 2021 07:54:40 -0400
Received: from mail-dm6nam10on2068.outbound.protection.outlook.com ([40.107.93.68]:1312
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229695AbhCZLxy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Mar 2021 07:53:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nWOSJRnDZR5/L4RAHYroISDUYdqcV2WCDh2fZCYUNjVL9N4L1N5p60VKvSr4fjq4XF7w8cinfvOqMsMKkxg4F5vVVIq01YjjxuXxwvL64hfiTxSTwmQhFiILN7qUOkMio2OV7Tl+tXgJnghfNwkO8x774sT2cBZZlrd91fK3VW1C9wFVWwb2JT38nq9Lr7+aR9IIxe96SgxW/LWnMSeSKYhoqS1e2XcW4wCtdq1hZFPZWjiVlc6k6SHUrS3m6mO2neMwxFCPykwH48OhJeG0+xUG6VmC34WB10rLZ28KH23E0/ULt9R0FsPhTZ/gcl1b5jgN1IVea5CcySOrYHTPmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ihibEwgQvT/lGW3644xzPSKPmjjX9DPzohR9hnMZyeQ=;
 b=T9ataSSdFf3o0piizIuIy/XifRMYNJWbNl8UhCpsBMpzFLRFmy+EnHDPPFY6xR26+vfpyv9D6SYcOQhyEu40+vqTFEXfmwKKzQBgbsXPnNaxH+uc/sZ9ITDHRVKScANOb13HEv9mLQ+SW9mnmM2LVk+ubhB4ii6X1B2e5Kz6z5eF9XwJvZSqGpy0zrXv1Hb86SSB0KUBi4T2o5NrD5rJxZP+dRbjEsK2+eZabr2+DSByafGlqPvk1Wn+s35E4dfe9kT8hpFdf9fnozEC+ZieaIhyA6aFDT1/LCWUp6XLr8cF5Hb7hRBo8TCxq2PfVKJ4TREf1hz+6G5E0SveX33j+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ihibEwgQvT/lGW3644xzPSKPmjjX9DPzohR9hnMZyeQ=;
 b=iCKse1OaulwmGVSqocTVTl2iY970gMaO9Zyw4yn7W5iGOCNy84rW3XCp25gTqaCJFDpfW0tTdI3M1fJ8bt6FX6RWY6hoA0xvERT7cn9Rol2iYZ/2iF+JwRQ4yT/egB8omR4liff8hZWddCiz9mfvIjHPnAd6BLuoknaMP2w8/kJhF0QH1ShZFGhX/L2Y+k12nBMcTWRFjDt8YmO4HAk5pvtrZesxCjMriqdST+h41sAl1uyCCYIQk0qjta+ZLIBZcdjMU27UU/EWIm628L9+midrbkgHfgGNqs3XHGs7CFBTeJjWQIp+0VdF27Y8O5J2Zvs293bG99ZnBgJJHJKBCQ==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB3017.namprd12.prod.outlook.com (2603:10b6:5:3e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.29; Fri, 26 Mar
 2021 11:53:52 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3977.029; Fri, 26 Mar 2021
 11:53:52 +0000
Date:   Fri, 26 Mar 2021 08:53:50 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: Re: [PATCH 10/18] vfio/mdev: Remove duplicate storage of parent in
 mdev_device
Message-ID: <20210326115350.GM2356281@nvidia.com>
References: <0-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
 <10-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
 <MWHPR11MB18864F0836984277A52BB4CB8C619@MWHPR11MB1886.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MWHPR11MB18864F0836984277A52BB4CB8C619@MWHPR11MB1886.namprd11.prod.outlook.com>
X-Originating-IP: [206.223.160.26]
X-ClientProxiedBy: CH0PR04CA0001.namprd04.prod.outlook.com
 (2603:10b6:610:76::6) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by CH0PR04CA0001.namprd04.prod.outlook.com (2603:10b6:610:76::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend Transport; Fri, 26 Mar 2021 11:53:51 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lPl2E-003J8a-5K; Fri, 26 Mar 2021 08:53:50 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fb441fab-dd6f-465b-841e-08d8f04dd338
X-MS-TrafficTypeDiagnostic: DM6PR12MB3017:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB3017DB8A959517820BBCA3ABC2619@DM6PR12MB3017.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5Q26WG1KYZ0m2D6soO/GPCw9hD43gswQ3rSZL/nW7+ojGsZhI0PNUAs45JOsVsUpNzIBOJGsX1dkxQU6PdI/QOt1EB/hq8bibllAboeiC3RDznyGRAi5AZuj0XXvqWZnkroWh/khKAed3DYtB3Arj/kXr1qlE0ZQE/OEiBb0y37uJ6M8tj0v5SkHWiWO81pRy0Txqf1uCNCpBPkXs7m+PmcP4N4LFPn8o7W4JAYn4M1wplGIiDh16tNG+vd5PnfU/uaMsZA9lhxNHj5LuDsVc1xUMxEStShJ5OzJX/Inp/aJ76JNSsEvJO+C7IVwE5gZnAFVW4MhcBk608QUqn4IcV2kKxqnkQrbIHa2F74KQyI/xCCSAOAUcQhDAu8U0kh++UprPMUopnn87U+5ZFWSHPVliaYSRAuMx8GKUw6+wkrzcAbgALGZ9ylnfrsfkBsDOcng25DkPDgkkBAk8RtBXY9ma1KJZyZDJ86WI/yyq514i4mwJMNZwalpqmFYuC9xsntFdtNFToPeyi+tgrKXsEgo3q3XZwBjXzgJZb9G44ATkGRCl8rY/aFf6ZZMpubfJizZiv5staVwZRY01YjSJfjrvhrAe2MvY5I8Ke6YD5t5R5bjl1Msr1Lup2zDDeEudEbis1k3V0CyucnNYvGQ/+4dNEI1P66u8YoYw/U3svI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(346002)(366004)(396003)(39860400002)(1076003)(38100700001)(2906002)(426003)(186003)(2616005)(6916009)(83380400001)(478600001)(316002)(26005)(9746002)(8676002)(4326008)(54906003)(86362001)(36756003)(107886003)(9786002)(8936002)(5660300002)(66946007)(66556008)(66476007)(33656002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?/1ARWQ30JmjM/yZD9dJFddmVU/47pWnufp4inQugep6vDjM2bpXiHXAMXsLM?=
 =?us-ascii?Q?rzC9AQSBKYEMhPhYhVeu7fKgP2MYK4/DN/Vj2QrcQGjZnhxcqzB57W6A+aF0?=
 =?us-ascii?Q?lG8D5H3hrqzx5f9c+6Sl8Oz/0hGCXdOVf9s/8HuJOokLrOswnUyDKD9Fi/Y1?=
 =?us-ascii?Q?LQd9uQe3KRopmXMIzebNDet5ENAN/kz9o/Dp9a2KJH4zIAMhQXnh8QdmkjV3?=
 =?us-ascii?Q?rIt/yABvLlH+dZmvvmfJzTwr03MMeS5Fofc+eZVWNVcbbYa7pzMFpgGIR8/i?=
 =?us-ascii?Q?Hoz6xvpZAeFqzWXKfFgutSZoUK6e2IV+kYliIX32l1XldQdE3OOWZ8VUnZLJ?=
 =?us-ascii?Q?OAzPRbirsThZolCX11Qos+/+qWy3iCSC6pIkvjlxBkSztfqoUAg7Q/GaFdFW?=
 =?us-ascii?Q?zwVPUaIGmk3je7tiCKZj9spgFTdFR6WnrzsvvmWNsP8RIHKZcfV281XSRX3E?=
 =?us-ascii?Q?LWi6XwdtgssK9qf1H8RxyS2Kc7cxHpfzYj3JbAfYWkJ3cIWbnTyoQ4Is23mM?=
 =?us-ascii?Q?XbLujNlNCsduG9gG1ni9x47YP/cABjjY6+lwxAkeMEastMyeV/ZeheSEBf1o?=
 =?us-ascii?Q?jb1QF5q1ONX4EXwvuvQGxsqjs0IqDp2F3htCvJ+QaABNUgRqRvXwXLQSxo6K?=
 =?us-ascii?Q?qClp2hPt8lSpkIuTSyK2SSw1vZZS4yEv2J4SRGzlb7UBmUWACm77s7RP/U0Z?=
 =?us-ascii?Q?PODkPR1jxO4BTRUeoEOydXdECpRA0M8fT2vFzuAYlcWc4yApuyfYAjxmUAr9?=
 =?us-ascii?Q?DLZ6vjlOSIrOS3A6cIDmz6tWOF2ZTJQiRyBQnM/gWAMS1OxphBlCOICS1bdl?=
 =?us-ascii?Q?AYqYANvKNtfkXdojL/DSzX003tswSP6rwRWbLWyKNx0cikKqEQ5Y65RGofcf?=
 =?us-ascii?Q?kL0xo/G/5i+YC+c78Pb66/xx4SV8qjkAG7HTZq88/Jxsamgmh+NREhYXG38W?=
 =?us-ascii?Q?lDrOSWgY9OLtLSYKMX+TvvB+OyCL1OdYAOMzjpqTOv1oddWbgXeq13pn3H3/?=
 =?us-ascii?Q?q7vTNkvuooTYlfT7g+cOyDHZ3kHdb1Gvl+Uxos+5cUJ2Z12NZQ9OcuT20Qzi?=
 =?us-ascii?Q?u1NbhmnubblzqGSsflBmhniVBwkIsruS7tf8ASmXMst4ZCeu+YJmqyMMRjw9?=
 =?us-ascii?Q?P/d4Ui+4JfApojukKCqk5N4XoZa/aLJXye2QB12GtRsefIgVGmUBzjA55WoZ?=
 =?us-ascii?Q?q8lImLCsHS2UeUgg0Z4xmI7MbXzELU7GEmTYGIPspcejgIZ+DRnJIQ2o9Etg?=
 =?us-ascii?Q?JJqZLKgubLlDj8btzb6Vc1nmUh0Fn/tYr/iaobaWYz2JXx7m7exGgApGU438?=
 =?us-ascii?Q?O+fO+F3xNB8iQONItfoyXZqP?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb441fab-dd6f-465b-841e-08d8f04dd338
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2021 11:53:52.1998
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T1lq7Nxm1qtatr0S+pw2iD60iTIxcdQg7hkyM+LK1Rr5NMnL2woFmJCk2lc2eo0m
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3017
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 26, 2021 at 03:53:10AM +0000, Tian, Kevin wrote:

> > @@ -58,12 +58,11 @@ void mdev_release_parent(struct kref *kref)
> >  /* Caller must hold parent unreg_sem read or write lock */
> >  static void mdev_device_remove_common(struct mdev_device *mdev)
> >  {
> > -	struct mdev_parent *parent;
> > +	struct mdev_parent *parent = mdev->type->parent;
> 
> What about having a wrapper here, like mdev_parent_dev? For
> readability it's not necessary to show that the parent is indirectly
> retrieved through mdev_type.

I think that is too much wrappering, we only have three usages of the
mdev->type->parent sequence and two are already single line inlines.

> >  	int ret;
> > 
> >  	mdev_remove_sysfs_files(mdev);
> >  	device_del(&mdev->dev);
> > -	parent = mdev->parent;
> >  	lockdep_assert_held(&parent->unreg_sem);
> >  	ret = parent->ops->remove(mdev);
> >  	if (ret)
> > @@ -212,7 +211,7 @@ static void mdev_device_release(struct device *dev)
> >  	struct mdev_device *mdev = to_mdev_device(dev);
> > 
> >  	/* Pairs with the get in mdev_device_create() */
> > -	mdev_put_parent(mdev->parent);
> > +	kobject_put(&mdev->type->kobj);
> 
> Maybe keep mdev_get/put_parent and change them to accept "struct
> mdev_device *" parameter like other places.

We do keep mdev_get/put_parent() they manipulate the refcount inside
the parent and this is only done in side the type logic now.

This is get/put of the refcount on the type, and this is the only
place that does it, so I don't see a reason for more wrappers.

Jason
