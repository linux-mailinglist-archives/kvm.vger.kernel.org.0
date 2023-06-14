Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6543C72FE75
	for <lists+kvm@lfdr.de>; Wed, 14 Jun 2023 14:24:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244513AbjFNMXq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Jun 2023 08:23:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244544AbjFNMXT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Jun 2023 08:23:19 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2048.outbound.protection.outlook.com [40.107.92.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F5331FE3;
        Wed, 14 Jun 2023 05:23:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=INK95+pMbKb9DMgznYwhWAxRZGemLsrFwnNg6nez1UySHO15IuHC+ZI/jG0yy+PtlFs+oujeCOhAdvOFxgC2wrQzNNdZXdjqWH2EHzhEmTquxT847yYpydNVCrvC3w0fPXxrps4T1scrUQBSIQcxeuh5qkehTZ2QAixQ4irIddK0mF/cLYA28PnSwpNxPCbL2cX3RelGV1k6x2/+HHp+3HaJ8Q1DeF4aWkm+16sqkdi9ZtDRRYdyQ/vWNRiA5hz/Q44lA1gfZYXm+aVybQvXpGU8V7Bmtbs9XOvVzfECMnwM8sKXKs6GlrVq9fbIFLGoJJg5DIGKu5GPxVOeRj8pvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v20CECxC2aEMExwSgQZLxD9oRP6uiSUDvOTRMX5bgRI=;
 b=jZ/W2WwxDb9t91E5Pf3jF/Xq0FH5sBr8dSC845kaqbfhH4RfqdmeBpdFIiwcnljeSjkA1FMFDkmERlTFH5eM2+nSQcYgwRdaYcrOnqZjGX0+ZLqD96YtHhHhXv35Afy5nmirTluPW1mKGek4pOTrAKChVWVKFfupGzkvYzMHCxaOkpL/JwXQDzqAh8FJLZUqJDUTBgghK0KvJevmS9e/KLAc/9K45HYs5Tzk9oaFRzb/Fgy6nD99RpoEJMsTb9R2hieaFDZF8fzFRkRrMVfLs9oZmy4TBJEYS8gZJYWuue8jlGMvURz2oRJrecwPpiJC2RHRAS/wBcFfMXeydmpNxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v20CECxC2aEMExwSgQZLxD9oRP6uiSUDvOTRMX5bgRI=;
 b=Q2GcYvQRsQ3U8vVEB0bBegY7x063TFasO4ja933sug9gycRjGYy/+j483J2NIaFkqoL6faEWAlr+P7eHZV6AbwqXXbk0Bet2V5zQcvjn/uBX6Ft2PzKCs6bheZfCELnn1iWlIP+y2jeCSOxHQQ56fCu8Yf2ehkzxAgcbzSVuNo/4MZzvOA3ZaNWhfJyN8RrJc+V5Dpo9g3PPvUqeRdNvU9QyScC3b74Y6IswMbla+wDuHpYOsJSepS32asKAXJdJYj9mk7w524thSmvYW5rOewC9UzeumV19Du6g2HbUBvKIOYjePsppeYylDjyIMZV9fwesLaPSfLEyjVl8l+7Z7A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM4PR12MB7766.namprd12.prod.outlook.com (2603:10b6:8:101::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.44; Wed, 14 Jun
 2023 12:23:15 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%7]) with mapi id 15.20.6477.037; Wed, 14 Jun 2023
 12:23:15 +0000
Date:   Wed, 14 Jun 2023 09:23:12 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     "Liu, Yi L" <yi.l.liu@intel.com>,
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
Message-ID: <ZImxMHrOHHwbpNmd@nvidia.com>
References: <20230613084828.7af51055.alex.williamson@redhat.com>
 <DS0PR11MB7529E84BCB100DE620FD2468C355A@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230613091301.56986440.alex.williamson@redhat.com>
 <20230613111511.425bdeae.alex.williamson@redhat.com>
 <ZIiozfqet185iLIs@nvidia.com>
 <20230613141050.29e7a22b.alex.williamson@redhat.com>
 <DS0PR11MB7529F2D5EF95E9E1D63C9264C35AA@DS0PR11MB7529.namprd11.prod.outlook.com>
 <BN9PR11MB52761B4E9C401A46FA5B4F2E8C5AA@BN9PR11MB5276.namprd11.prod.outlook.com>
 <DS0PR11MB7529E50A3F122449AAE5733FC35AA@DS0PR11MB7529.namprd11.prod.outlook.com>
 <BN9PR11MB5276FF400A7860DD23CF222B8C5AA@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276FF400A7860DD23CF222B8C5AA@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: BYAPR06CA0023.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::36) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM4PR12MB7766:EE_
X-MS-Office365-Filtering-Correlation-Id: afa4865b-e1bf-4968-2fb1-08db6cd220ef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TyGGkhr0pxhvY3nZeDYboK2BVii1mF54yv2MZAU0Cgrcht0JumrqbA+aRhPKxOWvD8YmjmqCinkdoTd1G6PZLDpCerR8XiRE5G493EGSS6yCLX46iiEUZtXLjLJh73pBLwfURQsHYkhQJQurWn8UYYm65sLL0iB5gNoIh1C7+1iW/rrSRRT9YukH07P41gSwWAbWPdPH0nyNsH3Gytm2KZcRXvN11sFQxVN8A0JufyCJ2U/oVg4tFYN8JqU3GmhRISK22hfI6aShG8+aQYQq/fTgiiGC9nnxSFDiumRyxGrZKC79o+8lpAsYL6ikKm7pvpckdw1+yiMyInkIWGIj0EsXXOp49gceGhXpozUJCYQ1BDPB+908+lPjSxxj/0CsB+yxp1SBoRz9e3tIMuk0FbNQLN3jPbVzd5CNL9kc6bnRnWbNDVI1pLNTYs+twFCaOWwddsZXQhNPoH0r3A6HTdDv9c7PiFx2QDcHKbdLYWZ0EpQ0qcJQGuvMWQm9RrC1K73Vs87rxCburxe1Hq2he9gG3HI7OxMMWh/zRIrcMEaVVRatQC+ago5FbbBTMjIK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(396003)(346002)(136003)(39860400002)(366004)(451199021)(316002)(6486002)(41300700001)(86362001)(6506007)(2616005)(83380400001)(186003)(2906002)(26005)(7416002)(6512007)(38100700002)(36756003)(5660300002)(8936002)(8676002)(66556008)(66476007)(66946007)(478600001)(54906003)(6666004)(66899021)(6916009)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?I5LhLC2nU6aDNHa3dDUDwpkcAmWmB3YO/VornabTKudE1Mpg1xJ8h9YYR254?=
 =?us-ascii?Q?5t4AV/OzjUpPSmpuq6NutrXslYIhxrWo221waypKpIj2QK3xr7FiZqq5jG62?=
 =?us-ascii?Q?7wBgaGoZYISbWvbMaUoWJT3+gbDHyve/SOcVBfxt4X/5z17aTqbZ0+icvmAm?=
 =?us-ascii?Q?b2A491wDaj7BKlDKK+DfSu9a340mSubp/ktmMsmT26/m25fKgzJ+cx0ZSNyp?=
 =?us-ascii?Q?t84pY9SSNTSJKFf1dWG4vWqf9/ZGlxX1b/cBObd01VeXMq7mHfQWjKJXBKuO?=
 =?us-ascii?Q?nPHxs+Eb4P7+C6eSeg0WEGFBXwltuDu78b5uRCvya3bTICxD1ntVyt4VPLrB?=
 =?us-ascii?Q?IrREKhb97ZcH4tSIGbkJUa69ZiZskqLMYCTnHPognmXzorFlOjmJu9WSz8x/?=
 =?us-ascii?Q?TvEmiOKwJdvGCYC4qvfyj4FQtbndZKSyOIZGHNwUQtCO0cZd6wFXM96t2bcl?=
 =?us-ascii?Q?lGOjd7x7P4tVCoTecK1DeZmxowp3t4Ry9QkH/8fpgP6ypNMws8aknysKUYUy?=
 =?us-ascii?Q?23iTCyWWUPb7ErGv2NVDp/y4SvlcCZHXz/dBUl+FuiQC6jz1fO6mjsMv9nnm?=
 =?us-ascii?Q?0t8v6TP5rGSDQK9o8weivCplKHvYa1Ywk5RKJhGIXA1BCYqmpivbsLJ+DHj5?=
 =?us-ascii?Q?y9YQwnC5/KXEquL3hu5x/BnnYMyuDtCY5Wz1ZMN8uiql09wX+k6eCWVgGpDE?=
 =?us-ascii?Q?Pmw5CUdhne0H+2SCtXQh7vTjH8b5LEiQUHdRmBbt15ExsP/nnMnBlFikQbjP?=
 =?us-ascii?Q?SnkwlY3iv7x5dozYcACmmM4tcUDhYcrXW8wvQDWC9QH7V5fuSlwhdFF+GJau?=
 =?us-ascii?Q?nhmph64hCvBNygVOorqEkDjfjQ13L7dUwUt8rJmEThshtNloMkOFw8A6VBk8?=
 =?us-ascii?Q?ulzzSAGRzhYlQ2tV1ZcWCLz+dAsWQ9jYO2YClfyg/gbqX7/enKFgo3oTuuuf?=
 =?us-ascii?Q?46FlzhFIE9Jceeg9yMSqV1hBJpdtHXALBGJ7dDM0FQg3TXwC2BOU9BhC7eiZ?=
 =?us-ascii?Q?ezF2VTLsTSbmm2M2LnZmtKz6ppJtHA/Qa/PjriXmHrX/pJVOnU0Kxm16Xnra?=
 =?us-ascii?Q?+Ih2yFXsHNpRe6m9jV7M/QQh41J1jFZ6NbcJVWZ+9Yb3d75RODL35IOrsKNj?=
 =?us-ascii?Q?7aaiLzfRrfnLgjzVNBvNWGvwvhoO5if8tMyKwUYZciCVKcplEvNA++YuIww3?=
 =?us-ascii?Q?++D65emLwlA5oLR49J9wRzuC0nYqid3Q1xEp7sHNsk40wDIpwznGuwcmmm2M?=
 =?us-ascii?Q?x8jASLLkq4PctQzBo3uK5z9OkBk50U2n7PVIBBHpJnRnB1Akghdeft/Nj4z/?=
 =?us-ascii?Q?1oZ6BoFUe8r8jDXPirus88/P7XcCWKn8emZA20bc4Xrzcppe80T8GGMJ4fro?=
 =?us-ascii?Q?GounC8rE+wxMXT8mzaW+7QcAKktmmhHAG1DP5tgx8IdJVHinTxrkmfA9ew+5?=
 =?us-ascii?Q?DTwZGaGdJvWX52ZGcfQMcBiAxBGlX5dnttCj6mmVk0GKioXXUx5sb3Gtni3d?=
 =?us-ascii?Q?VsrDWSTK/v4f1ayPUoy8D0B3QvCGUv22pHMXLO3rN6eKcYyfiUEOPKhdcUwF?=
 =?us-ascii?Q?z5RTfqiejmj+ki2Vqs6nQckPAdQtJdK99y4eeVU3?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: afa4865b-e1bf-4968-2fb1-08db6cd220ef
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2023 12:23:15.5960
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HZ1/GoV+wS6c+hWO6AdaVpANqWnSo1EYRh/kRbbSpAMeQxEser4miurDLxdZ0RK3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7766
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 14, 2023 at 06:20:10AM +0000, Tian, Kevin wrote:
> > From: Liu, Yi L <yi.l.liu@intel.com>
> > Sent: Wednesday, June 14, 2023 2:14 PM
> > 
> > 
> > > With that I think Jason's suggestion is to lift that test into main.c:
> > >
> > > int vfio_register_group_dev(struct vfio_device *device)
> > > {
> > > 	/*
> > > 	 * VFIO always sets IOMMU_CACHE because we offer no way for
> > userspace to
> > > 	 * restore cache coherency. It has to be checked here because it is
> > only
> > > 	 * valid for cases where we are using iommu groups.
> > > 	 */
> > > 	if (type == VFIO_IOMMU && !vfio_device_is_noiommu(device) &&
> > > 	    !device_iommu_capable(dev, IOMMU_CAP_CACHE_COHERENCY))
> > > 		return ERR_PTR(-EINVAL);
> > 
> > vfio_device_is_noiommu() needs to be called after vfio_device_set_group().
> > Otherwise, it's always false. So still needs to call it in the
> > __vfio_register_dev().
> 
> yes

Right, but it needs to be in vfio_main.c, not in the group.c - so
another patch should be added to move it.

I prefer the idea that vfio_device_is_noiommu() works in all the
kconfig scenarios rather than adding #ifdefs.

Jason
