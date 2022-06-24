Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 473E1559A15
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 15:05:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230254AbiFXNFQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jun 2022 09:05:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiFXNFO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jun 2022 09:05:14 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2073.outbound.protection.outlook.com [40.107.223.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4281142EED;
        Fri, 24 Jun 2022 06:05:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dyw7WjpXO+n5zYagHqxq7Q6ar+LpGXWfHQtvX8CaYSeRW29653fzrzdV7wSHOmhpMhJwgWxzHmPkqst6YYC98VLAvn5lC2kf/kjRUUy4iSjRDazOPoS+0YAzZevCNpXF157pjCBzSpC91SZAzBr/gmF5WgTLJwcorxjhDwSMLVuZljyxnjj0FYPx6hYbA6Ev746AMjJCiu9BeJO8RjBp92y30zcc6qjFaHlFke6f33Q0u4HXUk7ZyLv+ltglOiD/hUpr4JvIrGb7oF7C7nW7Bt4iM4nzUpuURn4oze8gxjrQLoGGXc4WsGdtmZ9p1+JGxLO7Ty5I7cgJlM8Sxtnftw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jrJ8uVg2qtyQGO9CA9ZhcsZgntS5mWwmSBef+lEEnkA=;
 b=Pc/XhFK4wx1Hjdi69rshuGfRnUgEZzNxlAWZqxAQcjqkB16tODcJivh97nyojfIpw4FjvnuYS2++dpx4/NiPT83zfOtB4TdOXv2A2d4CShn7oGqPOWTNovvP9uqKkhSqJlYhqWh+1rz1czugFbqlgQR/lZ8rXgcDczyLvd34Yo5RkDGiNEzzvDjH1awQ2C5ZQiRpj5bg3jmXOcAZ93SDaaZwIKi6b/VSKmAYxMCvYUVUPJsp1zz5AixljFu7DpWjAAPgU2EHDZrhli+TaesjrIFEBeb5e4FSgOu3MQFamM05JJFP19bZMKTJL29aozkIOqd5Wlb4IxCcds7L+rTowQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jrJ8uVg2qtyQGO9CA9ZhcsZgntS5mWwmSBef+lEEnkA=;
 b=Ey0RiDFTfRNot59C67TE0cQsdGQ+CCKhkcswUQNM9Bzb0nNyNpGUx27P5NA71CFze1NR55PPt11DJDSM3X4/PQNmwOyEbvLToWd6OvUe14HsBbVW/iZpc35DDPr24Fu3w7T5WFII6UFFBIgK8mud1xFmfKX0D2TTwtN78gRli04AntlMyAFlFJlpeRWtz8ISGq1M6E0JMucg/EYZKLAp7on+OwCiX6d6btkWwI2Gpgu9UViPdm54M+bWpvUV+Po3ystY+HMPi8UVOHt4zsqUQA6zcn+Yk2+K+iPJxOMXwiv2ZzU4amwrL2KggBpznZ38xyPSWOlMDa4NLjTYywDWqA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by SA0PR12MB4591.namprd12.prod.outlook.com (2603:10b6:806:9d::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.17; Fri, 24 Jun
 2022 13:05:12 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ac35:7c4b:3282:abfb]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ac35:7c4b:3282:abfb%3]) with mapi id 15.20.5373.016; Fri, 24 Jun 2022
 13:05:12 +0000
Date:   Fri, 24 Jun 2022 10:05:10 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Kirti Wankhede <kwankhede@nvidia.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        intel-gvt-dev@lists.freedesktop.org, Neo Jia <cjia@nvidia.com>,
        Dheeraj Nigam <dnigam@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: Re: [PATCH 02/13] vfio/mdev: embedd struct mdev_parent in the parent
 data structure
Message-ID: <20220624130510.GA124353@nvidia.com>
References: <20220614045428.278494-1-hch@lst.de>
 <20220614045428.278494-3-hch@lst.de>
 <ab47e216-f027-2083-308b-89c6aaa2e806@nvidia.com>
 <20220623201844.GA48313@nvidia.com>
 <f152e97f-0d07-e7a5-baea-3ae7de5662cb@nvidia.com>
 <20220624123344.GL4147@nvidia.com>
 <b158ee0d-d7bf-c827-637b-3cd98c66b193@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b158ee0d-d7bf-c827-637b-3cd98c66b193@nvidia.com>
X-ClientProxiedBy: BL0PR02CA0044.namprd02.prod.outlook.com
 (2603:10b6:207:3d::21) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7105598f-e701-4e48-bfcb-08da55e22c46
X-MS-TrafficTypeDiagnostic: SA0PR12MB4591:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: M082E2Hxi4lhweswSDOISBD+kH28rxuFlVqOz3VOlVd9CIhRHao4YSnM5K1UFj0OfjfoA4L5bLsTtNuKWd0RdZkuzKUu4x6SL89SlEj/m/lk9felS3M80JlW0UNTDIDAjm21S+WhH6ZbYXMR6+GPiFfP68wDmYEZ6g+2vqLBOV6cROp94xav0GxuannQ5NJFpBN7YDjlErR2LkoFHCyzgVWWg+7qYA3KBbYpAy+1CqMcfYY+Mw3w5LH+3OUT0RFSrP/gz7xDp3X0hr/sGk+QMQFD3R+DVZvKvlEglsp4J5u4XYnSz7K+OHsuwEq4XpBnQhwmX43FbbwzqxW5knTPpetocxvolMItthfVzgRBQdRVp6MG9REGNUw6ACpWY4W48anGFfFHVZIQ7FWRzUqkJK2zTYkDmg0rxOckEOx+TqGs+ZyALdUV2xBNocXz1ufB16Ao236kum6MWtERwCqptQl7JcllQWY/ShtUVRByvHzkNXrUaiF9BNXH4NnOwg4ztqt8SQCr3zN0WunRwt7NWNRKojJw0sxDIUMMAntROaXuYU3nc/XOIdcGP8knboyM+LO7CIUFNS0kcV90GBl809bUKaEXDEh0FJabyw+m9fUWwdShgKmKkBP7+ZD9i2PlM6VFXGfzUyrraar8CrNjW+Ct6ImkX9IPqM8sO5CRTxYYd+r9V/5+S2UJNVDwFyXi3VBdaQ1306gJBIr/fFfmmB2t35SUoKekzZD4nhh/kd5YGDEf7YImUD+Xon8JRhfehbFPOPneaNF/0qBFtSS2rSxuD8vb2hJ0/HeFPcXSe7E=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(366004)(376002)(39860400002)(346002)(396003)(6506007)(53546011)(1076003)(186003)(7416002)(6512007)(26005)(5660300002)(107886003)(316002)(66476007)(37006003)(6636002)(8676002)(6486002)(4326008)(66556008)(54906003)(8936002)(6862004)(41300700001)(2906002)(2616005)(66946007)(38100700002)(478600001)(36756003)(86362001)(33656002)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+tVGliNVLjLETyuV2TTV8wBmxbX008DljXnBXaKm/yngXlsd73N9CEema0OO?=
 =?us-ascii?Q?xQ1MmZhVSfWOZBK3jQMPNdYxvsdoQF57s/Bzqj3WOs1f2FHqmWXxMXJqx2Fq?=
 =?us-ascii?Q?kGTA4BRlwN/VfV3vS/R+PUM5jMqs019/9cAE0/6YhCdo2ZvFKE9O4b5tM2U5?=
 =?us-ascii?Q?jKAQEwSZjWjaynK0QwgCkK9ttur1II+jsSMR2FAem3EXPEJeSoWozeM9u9eN?=
 =?us-ascii?Q?yDrbwD4TaerTS702L2r+c+d8G41VZx5OWo1miawEDQGt+CUEOcB+wmmIWhzz?=
 =?us-ascii?Q?s7w0bEnADrRENLGSxrhI8qap8RS6O11Vkf50YPgbrr4Uj75VGFswTSQht1VG?=
 =?us-ascii?Q?7Mll8HRvuaHcwYSt2QhB2vtJgZNgKOusMhV4Stfz5spM4LlgXVvsS38kSBPa?=
 =?us-ascii?Q?maJHRmywq+gzv+DjZS0AXyI6HQu2w+EDN0ig+dCys8ryQtUPHCmgBNw1/xic?=
 =?us-ascii?Q?UONCrlHX92YO/rjK4PfZHnZ53lG0a5RiERvqRTHkd08w+y2dHXEx+tdzk9gx?=
 =?us-ascii?Q?yKEkdCJVyNdqpXq/IbnS5bKXsZEF9HJHdElN6PvJ3MmTplbQq6dgqnqXk9Yo?=
 =?us-ascii?Q?Fp+lA/5mwjEtD5XiwKX3Y3M+eQN+efzr3yi8z4cDiLxOQ6K5M4jOODkx/cwZ?=
 =?us-ascii?Q?1x0V+Xq/ZchkA48eG5reYWjAJfyN5CGkM6wX/VWfvDvCrM9BjeW1LoVmZknE?=
 =?us-ascii?Q?oW4qPA9iJOAIgrFkP3zdGkc9k3JPtJMxjQQVRK+k4h2QKcARGB0JKFvw+nZc?=
 =?us-ascii?Q?S42iOEI+sTU82beLS7IiH49DK0bckclBq5fbtTtbalRHIkuidveaR1d7bdxr?=
 =?us-ascii?Q?iJFwv/QSAcdz0bvGe5Z8NQOLl+GkSwKFxz9Kq25bhR+2YiwehOysTywQ7iPT?=
 =?us-ascii?Q?m6wmIdePfci2HqcdV/suMMBoeeuqxDjXaHcoEnmVw3fUKWP8bIvtpVg7h4Um?=
 =?us-ascii?Q?5Cj8jT2yMbo+gcLQZQyN6D9pVFHnc4SzQL6Pr1kvgBGSueL3j+muI2U0O5cj?=
 =?us-ascii?Q?zluwHjYTqBlrA57L3k33LWOy8gNf+/PfoFBBDJHpcbwHeQYrhCCXRuJ7q7V4?=
 =?us-ascii?Q?CviC/2TSorTsDsq1GBXlFfkUODxlgrYwm8VqzVdBIWxCMIr1Sygjk2oR6tn2?=
 =?us-ascii?Q?QR48Wr9VPh2l4x+P767AZcVOBMUK1KEM9eJ245F1xrs4sr3kngv3cpjIEdW1?=
 =?us-ascii?Q?l+UkDvlhBI/UsMJEKhH+QX2NXH5OlruEXZ+dH1WoRWRTFotn8uhPbBWQEqsY?=
 =?us-ascii?Q?rbDYugCXgR4tZ1U6IKPJ7M2G8Y8MLaNx11z0S7omy6kmXIcgcJJ1A/jKNy+R?=
 =?us-ascii?Q?dh/O/UwiHtaK7p+XG9uzTwfpnGlD950klJ5r9fDn2eimets9PEKxjc0Tl3tL?=
 =?us-ascii?Q?+RPQKbcD39gic3AMoMA+tVvDgeIXORgFDXlqpMO5TX1ZiIs8DsXrH50JbBBj?=
 =?us-ascii?Q?76bTOXAkqKE199FjaTh1IgphewpJDPTgz1WsUK7Fe3vRj6PzK2f9cIrh5Eh/?=
 =?us-ascii?Q?nATBjVCi+6yyhf1EeZ2b/jCTa0U1UOj2ySJiW8XyxlSlEMsVg6Wg0zMMzVwI?=
 =?us-ascii?Q?1NhBzyXtlUELikRpemnSCL/WU6FmXCcWF+abA6Z2?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7105598f-e701-4e48-bfcb-08da55e22c46
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2022 13:05:12.2337
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2qxi4p6f1pD/kiu66nnWZW9fDhG9x4y03gsO6yzwYu+CoNTh8SeK+TUchyuT3WOr
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4591
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 24, 2022 at 06:23:48PM +0530, Kirti Wankhede wrote:
> 
> 
> On 6/24/2022 6:03 PM, Jason Gunthorpe wrote:
> > On Fri, Jun 24, 2022 at 05:59:58PM +0530, Kirti Wankhede wrote:
> > 
> > > > The reason this is here is because the type->parent is used in a few
> > > > places and is put back in release:
> > > > 
> > > > @@ -81,7 +81,7 @@ static void mdev_type_release(struct kobject *kobj)
> > > > 
> > > >           pr_debug("Releasing group %s\n", kobj->name);
> > > >           /* Pairs with the get in add_mdev_supported_type() */
> > > > -       mdev_put_parent(type->parent);
> > > > +       put_device(type->parent->dev);
> > > >           kfree(type);
> > > >    }
> > > > 
> > > > If this was a simple sysfs kobj with only a show/store we wouldn't
> > > > need to do anything as the natural kobj parentage holds a ref up to
> > > > the struct device - but this kobj is used internally, ie dependent
> > > > from mdev_device_create(), independently of the normal sysfs
> > > > life-cycle so that doesn't protect enough either.
> > > > 
> > > 
> > > 
> > > Life span of 'type' is from mdev_register_device to mdev_unregister_device.
> > > If device/parent is being unregistered then only types are removed, so
> > > referencing 'type' from mdev_device_create() is still safe. Therefore,
> > > parent device's reference should be held and release from
> > > register-unregister call.
> > 
> > No, I've already explained this.
> 
> Its not correct.
> 
> kobject_init_and_add(&type->kobj, ...) which called from
> mdev_register_parent()
>     -> parent_create_sysfs_files() holds reference for type->kobj
          -> add_mdev_supported_type_groups()
               -> add_mdev_supported_type()
                   -> kobject_init_and_add(&type->kobj)

> This is released from
>  mdev_unregister_parent()
>      -> parent_remove_sysfs_files()
>          -> kset_unregister()

It is not kset_unregister() that puts back.
           -> remove_mdev_supported_type()
	       -> kobject_put(&type->kobj) // pairs with kobject_init_and_add

So what is the issue? This is a properly paired usage of the ref.

> In the next patch [3/13] of this series, these calltraces are changed as
> mdev_register_parent()
>     -> mdev_type_add()
>         -> kobject_init_and_add(&type->kobj, ...) holds reference for
> type->kobj
> 
> which is released from
> 
> mdev_unregister_parent()
>     -> mdev_type_remove()
>         -> kobject_put(&type->kobj)

This is the same logic? What is the problem?

Jason
