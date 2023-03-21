Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF7B46C3485
	for <lists+kvm@lfdr.de>; Tue, 21 Mar 2023 15:41:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231253AbjCUOlK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Mar 2023 10:41:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229914AbjCUOlI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Mar 2023 10:41:08 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on20600.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e88::600])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B5474E5F7;
        Tue, 21 Mar 2023 07:41:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BY6x21y+faCY8Vnf+7+5oVtDq33neDPpQZEa4I44XT/P2JD38F1WCLDz4HGKxnJ5+vk0LTsJa1TViee/SwLKtSg0mNRmDjQ+zssdhjaGeCKKJHgSliRnEuSGXSRc4iUHBP8FbaC+fXGRIIc0Kbjf14tplnM+RVsC4GbtPcA6k+rnW0eLTcLexAP9SgANQ6grnmvFhRh9L/Gv671lulWcmrP3NfAGS47pkR7x/uQ4h6VxAzx+kvV9Kiwt2o/HTs8cyrqQ2B37MyhJqs6i6sMXIAZa3Q0j9gfqkMXOV1YbPsSRlpIN/cl4zxg0TK7sUIk0evDjq9JqegLEqRglSkGgSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iOM55zJ1kmNKv6v/mI/Ex3PxNTP+v6mjrLt/ls91b5U=;
 b=ZgR95mOuuFCuW9Zaj4EJDvKwdDvrXwoZQQ7Fa1mTbeu9k/8sIiBxqz63D30EJ/zZRebPVrgFXEgyBdBlC6nHoPZ+Zpc7VygteFF6lz42QcIWien4A2qQ8DpA3JoIcUIQgfny3li+qv7ZoDv5EnU8NlytaxcbRiGLYmsvPOxZpYwrvgHQrFOzuw4dOkGuyHpeKRNQe7LMi9lTsOGoRfchpYbHXwPEHW+k0nErzm2SPTzsFjKH6bUAQS811cA0UvBb8ikuwoyhiZwpUCKxLsF+MGfPwptSP1AQ0ifDxRDTYBkYRfhG/0yMr68mYS3863TE54RqZZYHA3K4/RGwt+H9OQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iOM55zJ1kmNKv6v/mI/Ex3PxNTP+v6mjrLt/ls91b5U=;
 b=qLAusfnQlqoWJaGpk5a7YQW7KvMs5s2e5E+gMUeC/BYAe1/MiyJ123bUJnIH9W+9RADaeGjblstsXvMceX0g1pdpbPjB3Jaguvsa/KsnWCZhsi7Qp2FIvosIJIM2DO5LS9uxo0c3XtKrEAtOH3J9VqfICEsdwj9u8xPWPDmVIqEHg1k8DYAZiU3lA/mNTE4E1MZvSOXe1xNb/FNbaONxtEYsIjcMlggtS184n5OUNxStwNLzTAQbBLF0uSjLQwdS5CHmFZex9x8Fls3K7Wy2n5ed7PCKvJYrxf06WAmi3i3isto289HTif8nplMqvW+jU3jWUHncQiNDXrXZmogu9w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SA0PR12MB4414.namprd12.prod.outlook.com (2603:10b6:806:9a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Tue, 21 Mar
 2023 14:41:04 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1%3]) with mapi id 15.20.6178.037; Tue, 21 Mar 2023
 14:41:04 +0000
Date:   Tue, 21 Mar 2023 11:41:02 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
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
        "Xu, Terrence" <terrence.xu@intel.com>
Subject: Re: [PATCH v6 21/24] vfio: Add VFIO_DEVICE_BIND_IOMMUFD
Message-ID: <ZBnB/mOIvzYEPdsj@nvidia.com>
References: <BN9PR11MB527665CA5753E413CB4291AE8CBA9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <DS0PR11MB7529B3BFD999C9720836F049C3BA9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <BN9PR11MB5276684B2C0CD076FA3CD0938CBA9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <DS0PR11MB752922A0C9058583F677369EC3BF9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <ZBhpNyrBr9nm5Ae+@nvidia.com>
 <9875e60c-68a7-b360-9d52-66d4915808a0@intel.com>
 <ZBiU8KoSmiM+JkAw@nvidia.com>
 <BN9PR11MB527605E6609222431DFB8AA58C819@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZBmcbMuE4lyDIpT6@nvidia.com>
 <DS0PR11MB7529569D40415AA283E1EA55C3819@DS0PR11MB7529.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DS0PR11MB7529569D40415AA283E1EA55C3819@DS0PR11MB7529.namprd11.prod.outlook.com>
X-ClientProxiedBy: MN2PR15CA0062.namprd15.prod.outlook.com
 (2603:10b6:208:237::31) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SA0PR12MB4414:EE_
X-MS-Office365-Filtering-Correlation-Id: 7c55c03a-d979-45ea-c578-08db2a1a4c59
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 96ROUPebQr7sBK5PCNA1PrhXi2TMe5t2JbeTmKBEn+16Ds8/kxSkp7hqKJtBwciTHhUZUbyuVMhkNVsXIGVreQM8f/aQ98BfcUGaFakr3PqfVQdmpqsVlPMBWvzxDi1lLhGm6xfV3oEStFHr2bexB/RiIp/IYs7m+KBM4h4vbyA9r8xlSSuYEHNDUnU9NVhIeQUK8YZ0ZdVvA5Kp4p5gPbCGtUoJqu6F/Dzi+gER0/qmie98K0s0dau3TWaJexZ5IO0CrKYFYeh7FNr2SRQO+Kw3kej0jmX2O03bbDAzj9GgJpZdCzuHdEU3dIgPlbvK42pc45dtq1DgVfijlTfF/KfVLnCAX5Os7lPp5PwVldOiCjCD4TLG+gPqKR1LgmR4PF5bjDfPP5twkYO6u47oxuugetCQdrKiYExhbt0z17MU2ELHC9XRkb+tgG7weOCr+4kebNnJAtLHl7AuKZFya4v7cpw/vCJymT6LEg8bTNyucJigC7fAy2LY3BoBbHrUr4H8Qnv8xhX3PjkqOeCmnsHeuXg0xgUyx7GY9fg/wmXNP0vd3FpDKuijRJK9TpW12BTNAzdQgPQdCGaX51t2npSNbYtsdTBpT8udmrjERf8CatVdg/l7l55HubBmS5dth/cokR3v7VKZzl33uuu5hg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(366004)(346002)(136003)(376002)(39860400002)(451199018)(83380400001)(186003)(53546011)(6506007)(6512007)(2616005)(478600001)(26005)(54906003)(66476007)(66556008)(66946007)(6486002)(316002)(41300700001)(4326008)(6916009)(8676002)(5660300002)(7416002)(2906002)(38100700002)(86362001)(36756003)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HUR6ItTJwZXPbNCpFyzOhDH3gr53E4Utl0ouTHg553XPhBbLkPoWNS3UBQ97?=
 =?us-ascii?Q?FDbIIsxz+e4lDcPrYhyj48qRYEDckXln2RnylTQrCOvRwvFZDN2afodSAIqq?=
 =?us-ascii?Q?tGfrQMdPSsnLggs2WFeTL3rET1+u3CWSN+4Cw+cA7nWUB46yyfgQBYZhBsaK?=
 =?us-ascii?Q?fen81E+e6TG128XEu2JKzKEfuOnsTAX0A2wwdmS+zEedoccm+7RJWblbK7xA?=
 =?us-ascii?Q?1NaGLH6Do+1ywf6Qnww1HVkTGLNTUi9RjgOk+oNKJl3S2OxTM3tkRTdFC3FX?=
 =?us-ascii?Q?56B5R6wJFW0Y6DP5LbCHrApbf15uk5RX3l0QqzgIl0hzHV25phAwixf5pBq8?=
 =?us-ascii?Q?KlydgolmFejkAFMqIxsJkBbFqNcRDhe5iOuBHziN+LmKOucpZsmgFku5cOeZ?=
 =?us-ascii?Q?DaLFtXd0UVbXWIFPFZ6Kz2TYbOku6YFfdYzALFdNQesdZ7o5kptB2gAgvr1K?=
 =?us-ascii?Q?qgOQ2BFx0PpbOMsM2aIq7RNXUairozACj11Z7F7N++pSvCvB6pe2CaY1oLcl?=
 =?us-ascii?Q?t6V6w0pl5czYGMUYtWlon3xmIg4c6WA0zjobSwSSChbl6D79nvesvTSps/C5?=
 =?us-ascii?Q?KJEBDGWw6fwBlilU1tDXObSW1RaCtNaxJsFbLiH5uw9mc6NUI9eSx6G3WWLG?=
 =?us-ascii?Q?nb2clssY+NeNZiUz7Xq0UIzn6BI8etu40rF4Xv7SxBqDa/nvSDpIxn0Sk435?=
 =?us-ascii?Q?Oi2MoZdOfNw00dCveftJc67YQ88fUIMnEknoQsAt4oJzFV6csaKUHa99xhxt?=
 =?us-ascii?Q?/IgacKivlaSzm6h1GU2gZwm1OqVS01LhXpKtyDiZRB1dskhFLKeFAQfMm4+L?=
 =?us-ascii?Q?rBdl8UjB3P3DOOFP7XFx2zOJzO6FQZBFgJcWj3g0xcpsusiFc1gIOZqbbWvM?=
 =?us-ascii?Q?OrI2ITsMH0n2/x+O7EwpkZsrgcskGQoa3uPBZ+5txjTCTR+NE4m92DIbczFe?=
 =?us-ascii?Q?1Y/UlrA2mU6GzKbN7cGNSRy8ZVOaxQdVOmB+Rt8n5lIryWrllklxlpP/hsq1?=
 =?us-ascii?Q?wtfXd0Hg9XIa90EKoKxjfO1DQ0zIfWF+2sxZ4WGqc0BdHwmj/XJ1is9Wdf/1?=
 =?us-ascii?Q?Cr7LVGg3jpdZP3j4bq7Sq7Q8W9WJFPbebO5kzt22gdvjuTq76Tf0g7O0pGZl?=
 =?us-ascii?Q?RpTQhaC3pbHQbxOKmascjxBr52UineTsMGWGd5IDdLse4VDDx+XZeYVB7v0b?=
 =?us-ascii?Q?HDidu7N58a+0esf1yeLjjlKU7ycABAHYjCMUWw5BYrs6Xp9e/flB7rWaCmea?=
 =?us-ascii?Q?WZa/tCtgI6fzgJdTyULF3zCzqC6epm5iBVzHOEDmDDUUUrMogoE0nWZ3UUu4?=
 =?us-ascii?Q?en+bu+jEqLuxI8FJvEwzI2EJ7BkUoN9Mvy0vORHpEMpqukuMpJKMY2zp0UDA?=
 =?us-ascii?Q?wn/ZUOUrbhGpy5P3uwsVI1eATiWCiMA5a9ExzW4oXoM0u5InxMkapod3GjAi?=
 =?us-ascii?Q?oX/xPNTD4qBH9YZP0nF/euIFUI3f1y3JJBZKu9dzFl4/QY7tPhwTHnYGys+f?=
 =?us-ascii?Q?shGGEX0WD/EoCxpIcMGxZwISBXqSAZ897H3PnXlaghKA4NGgXticGs5GCjOI?=
 =?us-ascii?Q?5Wtm7beR/vHF+80KGm0WlBC4Iu7F8jwEGKyiZRpl?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c55c03a-d979-45ea-c578-08db2a1a4c59
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2023 14:41:04.3868
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: POazII5nDzmrUuzgLnflLL6Fsgr6OLmMBeBHkeD3t0wMKLk+e4qbOtiqy2VjS7g9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4414
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 21, 2023 at 02:37:58PM +0000, Liu, Yi L wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Tuesday, March 21, 2023 8:01 PM
> > 
> > On Tue, Mar 21, 2023 at 01:30:34AM +0000, Tian, Kevin wrote:
> > > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > > Sent: Tuesday, March 21, 2023 1:17 AM
> > > >
> > > > On Mon, Mar 20, 2023 at 10:31:53PM +0800, Yi Liu wrote:
> > > > > On 2023/3/20 22:09, Jason Gunthorpe wrote:
> > > > > > On Wed, Mar 15, 2023 at 04:40:19AM +0000, Liu, Yi L wrote:
> > > > > >
> > > > > > > # if IS_ENABLED(CONFIG_VFIO_GROUP)
> > > > > > > static inline bool vfio_device_is_noiommu(struct vfio_device
> > *vdev)
> > > > > > > {
> > > > > > >          return IS_ENABLED(CONFIG_VFIO_NOIOMMU) &&
> > > > > > >                 vdev->group->type == VFIO_NO_IOMMU;
> > > > > > > }
> > > > > > > #else
> > > > > > > static inline bool vfio_device_is_noiommu(struct vfio_device
> > *vdev)
> > > > > > > {
> > > > > > >          struct iommu_group *iommu_group;
> > > > > > >
> > > > > > >          if (!IS_ENABLED(CONFIG_VFIO_NOIOMMU)
> > || !vfio_noiommu)
> > > > > > >                  return -EINVAL;
> > > > > > >
> > > > > > >          iommu_group = iommu_group_get(vdev->dev);
> > > > > > >          if (iommu_group)
> > > > > > >                  iommu_group_put(iommu_group);
> > > > > > >
> > > > > > >          return !iommu_group;
> > > > > >
> > > > > > If we don't have VFIO_GROUP then no-iommu is signaled by a NULL
> > > > > > iommu_ctx pointer in the vdev, don't mess with groups
> > > > >
> > > > > yes, NULL iommufd_ctx pointer would be set in vdev and passed to
> > the
> > > > > vfio_device_open(). But here, we want to use this helper to check if
> > > > > user can use noiommu mode. This is before calling vfio_device_open().
> > > > > e.g. if the device is protected by iommu, then user cannot use
> > noiommu
> > > > > mode on it.
> > > >
> > > > Why not allow it?
> > > >
> > > > If the admin has enabled this mode we may as well let it be used.
> > > >
> > > > You explicitly ask for no-iommu mode by passing -1 for the iommufd
> > > > parameter. If the module parameter says it is allowed then that is all
> > > > you need.
> > > >
> > >
> > > IMHO we should disallow noiommu on a device which already has
> > > a iommu group. This is how noiommu works with vfio group. I don't
> > > think it's a good idea to further relax it in cdev.
> > 
> > This isn't the same thing, this will trigger for mdevs and stuff that
> > should not be noiommu as well.
> 
> But the group path does disallow noiommu usage if the device has
> a real iommu_group (the one created by VFIO code is not real). Would
> it be better to keep it consistent from this angle?
> 
> > If you want to copy what the group code does then noiommu needs to be
> > statically determined at physical vfio device allocation time.
> 
> There is another reason which may not that strong. For devices protected
> by iommu, user needs to program IOVA mappings in order to do DMA. Such
> device has a real iommu_group. 

Oh that is a good reason for sure

But still, this check should be done at device creation time just like
in group mode, not during each attach call.

Jason
