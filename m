Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97CA97637C8
	for <lists+kvm@lfdr.de>; Wed, 26 Jul 2023 15:39:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234177AbjGZNjQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jul 2023 09:39:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234092AbjGZNjL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jul 2023 09:39:11 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF23D1739;
        Wed, 26 Jul 2023 06:39:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eeY7+QT0odlXRIULyc+3tKqrWjDQFKaR9LtdRsAe0X9ITiYfcQHAm0ds2VrpbSwxBu6FnhPiST1ZA80mk0v2zAHgz1j+xpwUiycqNTeZRg3THmHfqapssZcwAPQUKu8OeJU5DF4XwaxvlJtumW1wVDMbSaSD8RjBAwK6NzryiKGDGc9Ctqd3FtzVgEhAoCICXV+CuPruGpg1XG5HqODSgh1LqII0fLq7Gwy6WjNRCHqAKDOljAjFAWNX3p//VCXo/PRbzXGa+p8mDZpGP/GWLdHGBZheCX3Kiwhy7fOUxRPLxH689OZMrjg0vJLp4CU6tn4IXAzILd520MtRk9g+NA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2eISYb6xR6OFuMkY96Is2/ZYPEfjhST3DydRw81EG1U=;
 b=XchXuAKI51rGi+a33mn7qLTPHGPG5EuFKOWrGYR7lo58H9o3V8AShz+ZwSTtYdKjIn3G49J+PxM1BFW4U+05zbyBnsQLXXNtTwfAtkvpQsF8jjF/hIN9ohHcuMYa16I9j/5K65NuRolcGb/mmbePGrJ+EHg1Ei8ovnNib3zXz0yH4qxjTseARpyL4/KnevD4QrKDF0hCuId65n6stabgZnODrQRt9cC1m+aRHuXJqx2wWvqulCf3pdj9hEUHPyTKo+ClfdfZczui+AsfzwnTN5611EF6/f7BnUM1UBaYkGMkKHlL5cQwKe9iDp1kLoyZrjOnilkdK+vZuTJSBZsq5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2eISYb6xR6OFuMkY96Is2/ZYPEfjhST3DydRw81EG1U=;
 b=du5uY22g/g1igVUdVKScLwmoGnCwACJjtQxNUGlEEZ81ccKC7ltFWLQkpVM74NmLCODvHdzeJzf/wPgFYVTLyqYycY1HFNhHG2/6H05aUtRGdLkBgJ1JPVwP2MQEKV1HjqyrKXU1UHV47TPKaHYIzFdtDlVL3I/hEwMF9D8zqd8ZpDIDrGnva+GAW2OZzn1hHxMU0Mh8r5csUu6Vp8niagpYbUTA+emEMor/ppXj9/48MW79NHK5n/sx6oiEELn4IfVRL8Re3DrKhAksnB1ZPBYxEFMkMbe4Qso5y1HB1UFNorEklCjeT/lX1UBwRbjk/EtQRdEWPnh6ZvDg/Aowuw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH7PR12MB6610.namprd12.prod.outlook.com (2603:10b6:510:212::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.29; Wed, 26 Jul
 2023 13:39:07 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::5111:16e8:5afe:1da1]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::5111:16e8:5afe:1da1%6]) with mapi id 15.20.6631.026; Wed, 26 Jul 2023
 13:39:07 +0000
Date:   Wed, 26 Jul 2023 10:39:05 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Yi Liu <yi.l.liu@intel.com>, kevin.tian@intel.com, joro@8bytes.org,
        robin.murphy@arm.com, cohuck@redhat.com, eric.auger@redhat.com,
        nicolinc@nvidia.com, kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.y.sun@linux.intel.com,
        peterx@redhat.com, jasowang@redhat.com,
        shameerali.kolothum.thodi@huawei.com, lulu@redhat.com,
        suravee.suthikulpanit@amd.com, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-s390@vger.kernel.org,
        xudong.hao@intel.com, yan.y.zhao@intel.com, terrence.xu@intel.com,
        yanting.jiang@intel.com, zhenzhong.duan@intel.com,
        clegoate@redhat.com
Subject: Re: [PATCH v15 00/26] Add vfio_device cdev for iommufd support
Message-ID: <ZMEh+doLuZAYdXpz@nvidia.com>
References: <20230718135551.6592-1-yi.l.liu@intel.com>
 <ZLbEigQvwSZFiCqv@nvidia.com>
 <20230724130922.5bf567ef.alex.williamson@redhat.com>
 <20230725120009.2ff17e77.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230725120009.2ff17e77.alex.williamson@redhat.com>
X-ClientProxiedBy: BL1P223CA0021.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:2c4::26) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH7PR12MB6610:EE_
X-MS-Office365-Filtering-Correlation-Id: 0c420627-4d91-4208-ae95-08db8dddaf5c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: f/rs9gP0rfr/rvLfu7h80SHGYfcxVFGz6KE3SGIgXRVqYwPtv5H4EL5QrhAJRsjNBj0bcOnBxVqp6lOxyPUHL/5jbNdym+FBEv65QLOcpyzl3tebF/Vc+vTM5V5rdOTzM1TNXAbqIg2J/g0Xj2a8KEgOni38piwdKj+mdxcyjJb8QvzupSWJtW9C4cxDRF/nsD4A0ujTDEKUDwgtmHX7lyEmXYpkgdgZkQNb8CYyxAkz2lQMAWFYfn/GRlF79PY19pZ6FL6qtdkri4xQoI7j9BvFoIfcLV+z+6WOr76XrYNNp4J9OY4TuuJaFzELwzy7+bkw9O4akGv1Xlvlj89yLGY0JFPp7LNZgK9rmYXcyqbiRuQA659ghY7gNItPN0npQXcTguVNqMz0YAcdhAb1m1Mrj8zw1lloPGzZdY53gh2V7VPIxaoncmWFEkxvtCGyz+NCzF+/k7BaCNmTttR3Ht3qyYnciiEO5qy2UQXeSNL75twL9p0VquH5UXfVDSwyU/BJwj/YJF5Ql6DYJOYc6v3J3pvlbbumYJfdhNe0xBNieqf3O4JIoLeAkGZpfGoL8aw8VeAX4HaGxGq8VF6bDOPxz1mRqcSTCTbSxGtiJpaT8JJRgfnG9qjcN9dlbtRnis3v4w6lIQnKCVMFHkSxqw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(346002)(366004)(376002)(396003)(39860400002)(451199021)(6486002)(2906002)(36756003)(478600001)(316002)(8936002)(8676002)(5660300002)(41300700001)(7416002)(38100700002)(66946007)(4326008)(6916009)(66476007)(66556008)(26005)(86362001)(6506007)(83380400001)(2616005)(186003)(6512007)(966005)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?krweCpXkwESeXuyY9F1crxefYLWNDBBdGFwm4emXI0wNlLe1kPA+pFk19mUd?=
 =?us-ascii?Q?tcI8DNXgx8XjHcA1JhShy6HckE4tMOt6sj7/qoVe8Mfb/lZm0083ZedS+Qgc?=
 =?us-ascii?Q?bi11VKaruAjoobcEPvB4e/Mt+27vp8G66tlLcTqc8a78HfY4uw0SbYts+qV7?=
 =?us-ascii?Q?S7+Aa7pHQTRul81mFbNuw/aFHYe1Db2P39Ch4My3tgvDvNKVO7qEc8IwNiYO?=
 =?us-ascii?Q?l8RjDH09+vqWoxmv6VfXEXdvVC11LFUnWV5QHH6m816O3zqlmHo3pNlQdNAW?=
 =?us-ascii?Q?Iza9E01EOILgI3TKaqzUcrIourTASbJ30qLuhkYMRPy7r3Spk0gDf6KCUHte?=
 =?us-ascii?Q?PgqfT/7dO1wtH0IwlbUtvvOisdPNpSj+UI9vOwXbPVNSTnjG++uJUrpOiqxA?=
 =?us-ascii?Q?OqDAeMdkmO4F2l5WU2k6sYNdv7hbuIhk0qWLuU8Sv/fqXwG0eLTuJgaJTEgV?=
 =?us-ascii?Q?OkaR3bGdqBKRLDGgPniYAQ51y3dUPkGLAkOJczBxTJDJwypajEumYMru83NH?=
 =?us-ascii?Q?hVuoNWXkQQb92j31wCEN5h1acvnIkicFm7F8X50EyOHr+tGuRlPHlVwdutpw?=
 =?us-ascii?Q?GwuTBrBOwUJ115VS7Kuwxd6owXLk2OgZ3bg02101lN6MnamnTkWeyKb3efb+?=
 =?us-ascii?Q?z13H/NEC/W68XpbvxQPRCFRIDI51f6JsZSXaXpPWDuiUzjaxRQ0gooAvzDI0?=
 =?us-ascii?Q?D2GsEw0uiWt3lqqZcKy333Y4Q0YcA+BEY+Z26C/uw2e0PXMoi/alENQqecjZ?=
 =?us-ascii?Q?GbaniVGwl8cjBzyr9VyTh0UdkbFOsFXrUESQ3ZtQ58OraXJn0BHQwH33TeKm?=
 =?us-ascii?Q?NQZDy6yzjidgLv7+TA6NumZ9kZrw1uXoQtVGGYLET99vVdX7xBK9YJNp+Ema?=
 =?us-ascii?Q?Oz8EDNv/lIsVLgHrd69XjoRYdNZXQntYvj2RuVvoFt0fSZrycqHp1i8iQqU4?=
 =?us-ascii?Q?mlPfgcY9XtRrTKFBS6U+wxGi0v0riTuXTtSjnUIcWDQgFRfL8ZdKHVAQvpno?=
 =?us-ascii?Q?THRd4P/zQdD4AbAzBhtiqR+RBS4nTTjtjul2wEfnAV5Dpu6yOeM4s6UVOqbf?=
 =?us-ascii?Q?5pq4rZR1nuU7Upumsjztaht5iwyvFXX2pY/h8T8SzNSFYpMI4vT42E8tShbq?=
 =?us-ascii?Q?cFTOq0o1dlRJRH2uFzzaak7KVWAtgQUgSUGNFHxDZMP3xVPdX2Q4Hntbn2QL?=
 =?us-ascii?Q?7Srexmn4xgfDMe0xqFCG2l16HbKlLjCFO0ONVGT45LqFG/mmVJUY+9KK/E4v?=
 =?us-ascii?Q?/6Y9x+ZZYJHJn9TYRxopKM6Wh3lL8Yu1uRSljeKKASdtgLHmyKkGQDt09cCc?=
 =?us-ascii?Q?uH52Px/T+Uw/uMN/lcT1gehG5zuNlmWtlliYvbVSDhhHaUWZYuRu+uIZQw+X?=
 =?us-ascii?Q?lN4/5QRhVFskRBe6Ac9lKKApA0G1M6xshwahRTq6V2FiPjv1oRaJN4Zv/36T?=
 =?us-ascii?Q?8Y6v3fBNcqC5bf+qIwlQimwwDcONWpIPuA4LeZPvvPG1xIf32E0NzYLRAoMP?=
 =?us-ascii?Q?SenraNgiTxzzgN4XyvSmauQwlh9/Ns2dKl/LuwBCduUr6Tagv9EuziKDQL1r?=
 =?us-ascii?Q?pQ1Cyek/1HglPuIjJ8GyRYBybWrZyx3xfk0PnMuX?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c420627-4d91-4208-ae95-08db8dddaf5c
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2023 13:39:07.4496
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LBitSuLj1RLpyoOOUd61QYuotfCvf/u+RsNstLPvpTX76QuE9OYOfxvTQCuJiP3q
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6610
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

On Tue, Jul 25, 2023 at 12:00:09PM -0600, Alex Williamson wrote:
> On Mon, 24 Jul 2023 13:09:22 -0600
> Alex Williamson <alex.williamson@redhat.com> wrote:
> 
> > On Tue, 18 Jul 2023 13:57:46 -0300
> > Jason Gunthorpe <jgg@nvidia.com> wrote:
> > 
> > > On Tue, Jul 18, 2023 at 06:55:25AM -0700, Yi Liu wrote:  
> > > > Existing VFIO provides group-centric user APIs for userspace. Userspace
> > > > opens the /dev/vfio/$group_id first before getting device fd and hence
> > > > getting access to device. This is not the desired model for iommufd. Per
> > > > the conclusion of community discussion[1], iommufd provides device-centric
> > > > kAPIs and requires its consumer (like VFIO) to be device-centric user
> > > > APIs. Such user APIs are used to associate device with iommufd and also
> > > > the I/O address spaces managed by the iommufd.
> > > > 
> > > > This series first introduces a per device file structure to be prepared
> > > > for further enhancement and refactors the kvm-vfio code to be prepared
> > > > for accepting device file from userspace. After this, adds a mechanism for
> > > > blocking device access before iommufd bind. Then refactors the vfio to be
> > > > able to handle cdev paths (e.g. iommufd binding, no-iommufd, [de]attach ioas).
> > > > This refactor includes making the device_open exclusive between the group
> > > > and the cdev path, only allow single device open in cdev path; vfio-iommufd
> > > > code is also refactored to support cdev. e.g. split the vfio_iommufd_bind()
> > > > into two steps. Eventually, adds the cdev support for vfio device and the
> > > > new ioctls, then makes group infrastructure optional as it is not needed
> > > > when vfio device cdev is compiled.
> > > > 
> > > > This series is based on some preparation works done to vfio emulated devices[2]
> > > > and vfio pci hot reset enhancements[3]. Per discussion[4], this series does not
> > > > support cdev for physical devices that do not have IOMMU. Such devices only
> > > > have group-centric user APIs.
> > > > 
> > > > This series is a prerequisite for iommu nesting for vfio device[5] [6].
> > > > 
> > > > The complete code can be found in below branch, simple tests done to the
> > > > legacy group path and the cdev path. QEMU changes are in upstreaming[7]
> > > > and the complete code can be found at[8]
> > > > 
> > > > https://github.com/yiliu1765/iommufd/tree/vfio_device_cdev_v15
> > > > (config CONFIG_IOMMUFD=y CONFIG_VFIO_DEVICE_CDEV=y)    
> > > 
> > > Alex, if you are still good with this lets make this into a shared
> > > branch, do you want to do it or would you like a PR from me?  
> > 
> > Sorry, was out much of last week.  Yes, my intent would be to put this
> > both in a shared branch and my next branch for v6.6.  Given this is
> > mostly vfio, it seems like it'd make sense for me to provide that
> > branch but I may not get to it until tomorrow.  Thanks,
> 
> Both series are applied to my next branch for v6.6 and I've also
> published them to the v6.6/vfio/cdev branch[1].  Thanks for all the
> work and collaboration on this effort!

Great, I pulled it and merged the next series

Thanks,
Jason
