Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 475D073A7DA
	for <lists+kvm@lfdr.de>; Thu, 22 Jun 2023 19:59:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231464AbjFVR7Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jun 2023 13:59:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229854AbjFVR7N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Jun 2023 13:59:13 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2076.outbound.protection.outlook.com [40.107.93.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0C27171C;
        Thu, 22 Jun 2023 10:59:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZvBCP5dRaffnC7yWox7PXRIF0pl0EH24cvjBEcqio4A9L00USgE4eYrr2bKSx5PjJS2YmZMgoKsO4SE+/cvpNIAmgblf9li/XSGTkduXz22psoYbPBNQxddzTawIRHYYNlraPm+wODnP5d4ZaE9oiqPGdW0R0x6NKGtDZq7JciY8SFUhh/bumhpzCct8At+CgG9NVd7Ryx8prxf1/aGzDJo7LKoYNX1CbLXQDhtDQbIIMLpV9k/QBCuDFYZqOvNYW//2rJpxHSdiKV5gpsKP0jG38b8KacUuSFV6urhnv9d008U9jxJBuVKgTlbhqpJWOBkr7COgOr3sw8meKJ6VjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YlQ1d37KzIHP72GeS2d8hjN+SzHt7bPE1+XcIVW1tO8=;
 b=SHB7239YLlbVwqL9Oz8FUrjUN+gujewR32m/p4HvL9xaLL/y8JksH9vLet3WkQJAMmMx2dfKI0JwXNpsLs+mnrU/Voz4ZSsGYoRqLXAppAd1R6rHBhjBIDFfUYhc8A32SU6mF5rZrrz2LR5G/3cUP+guqFHtJcn9t5otb9P9TMkF4ZufEbRWx50JhBE4V2bwcaTNZ1vi3/cQaNT4Ig9hFABHU3u/VX0/gapVP8UtbcnWLhLY71ZLfYOhMHuOd2X8NHL1SQvADVG4BRH2u0CFBxMBsnIYxvNeJI4O41G6vONnB30RJoJnugutACQyOgrBA53bCvc2++vdyWVw/uvBUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YlQ1d37KzIHP72GeS2d8hjN+SzHt7bPE1+XcIVW1tO8=;
 b=oufXNitkqRbJjw/LQK/XnIA6Qa91oyskF2UH1/HyAACrkIQLzD60w5EPE/VCRsmZadBpxZuUSRj9waUbzkXLdKUXzRP5byQZrTpNniEE9lg6o0vX2J4US+2Z1rMO2idfeR7nA23gy53bRTySPmjoBocX4I23fjdom1IXMB5MIyC1fXUp05f/Ant7l02AREn/zah5btk1NJPunBZyn4Y2u5sSM+elMxfiQBotoA63wNmIhZ4s/Wv7BBy1Eg1u65MDS3/Mj3OwucGJb/YlOmMzfy2ESWSWNM1w8/BJXp0GcbVDgUNVqiUXoi52WPfkmvDDlMaQvXx3oDmJwBPlzsgmZA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SA0PR12MB7073.namprd12.prod.outlook.com (2603:10b6:806:2d5::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.24; Thu, 22 Jun
 2023 17:59:10 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%7]) with mapi id 15.20.6521.024; Thu, 22 Jun 2023
 17:59:10 +0000
Date:   Thu, 22 Jun 2023 14:59:07 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Yi Liu <yi.l.liu@intel.com>
Cc:     alex.williamson@redhat.com, kevin.tian@intel.com, joro@8bytes.org,
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
Subject: Re: [PATCH v12 10/24] vfio-iommufd: Move noiommu compat validation
 out of vfio_iommufd_bind()
Message-ID: <ZJSL613KtzLXrGJ/@nvidia.com>
References: <20230602121653.80017-1-yi.l.liu@intel.com>
 <20230602121653.80017-11-yi.l.liu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230602121653.80017-11-yi.l.liu@intel.com>
X-ClientProxiedBy: BY3PR04CA0025.namprd04.prod.outlook.com
 (2603:10b6:a03:217::30) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SA0PR12MB7073:EE_
X-MS-Office365-Filtering-Correlation-Id: c9e687c1-a493-4329-5423-08db734a6180
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OMk2MdLcYgI1bot46QvdfiFHDfxxzvQKEohBABAcwInkojmebTe5L4d0xSbIuxqDlt+tMFdZoBX7Hx+XDyKSW4xEG5FqlJCeeXjsVDCh5lVNRlKdt9IUBwooCT6MCMdov1FlKL2SncJDrIvHjXPFNBry2zSxfYet0iy+C7erlut5TVKmuA+XoHEzHsr+Iz9cGFUgFvqszVHb4ZJ4aNVIm04aOEmfu3gnUNxsMjqttfZHaXuqbu9GhHpx5x3UIrnhKfh96Kz9rOElOEzr0mwGKHlLn2q7QQWkXo/4HfvBZpEeYLqBOAgDqq/wrXSuVfpO7UHRJuh3aDouCFiXGqc7uBgD1Xg7gQIolYZHG86aD9fGWR7c8IMwR7R00bPWNuxYrRHp6yKkzTeQxT4EGdDyVaQmQ0AXEcjYsRcUNu1NMO+SAEgz6fxkUT1j0OmWXBfiWPJ+kRuOSwY2XnFbfRXv0VPwmq6OPf1cMFZP7ZXww5JSZAiPk3azfIXi52+goJ79+wlGh4puTqzz6oDXjtSLFXO+TgKlJqKK9NUN6OISF/FvGw3O643lostqeZS39drd
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(136003)(366004)(39860400002)(346002)(451199021)(8936002)(8676002)(6486002)(83380400001)(36756003)(38100700002)(7416002)(5660300002)(6512007)(478600001)(26005)(66946007)(4326008)(6916009)(66476007)(66556008)(41300700001)(316002)(2616005)(186003)(6506007)(6666004)(2906002)(4744005)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uqtkN8n1PUpdLrsHFJ2ErNslSVtWUGn4dhyiWnGQa5OslW3UmLz3YGX/GbP+?=
 =?us-ascii?Q?CVzbFhU6geaIeByU8Kc0ke9uW5EhGC7coc4GBCHxZQADPIF3Tfl1sgSVv/jA?=
 =?us-ascii?Q?Yg7Mm7AKOWlg/HBpkqpmAc9h3AzlORU+QUo9tVJ7DO0EkKbxeYc1HjiFZw1W?=
 =?us-ascii?Q?U3WHUFj0ffcUmHygRHtdj2PJj9VpdPBlhv/sAK4kSTjePr+arAsUgqGlh+y+?=
 =?us-ascii?Q?UFPkMOBVRk7bF3TBCHdtUyG/TrtewhzpHSAL6MUIjCGqhyUYExQhlnXGwGY5?=
 =?us-ascii?Q?vrgdrh5ljtbenjxIi2XEjGRDOrGW0kzhrGYwiTPEEZ9J8fVjjKeCdp5ZaOxq?=
 =?us-ascii?Q?wZdF812h3XnX20j4/CbDurm3IElPjWv+kIMVUpkewJfTkwA0Et7IEBhQhz4Z?=
 =?us-ascii?Q?iwNtp8i/qYGio5Crm3n/wWQU+IuSRnltKfCC3PQZUbKsPsvLyTpEeQbciR3A?=
 =?us-ascii?Q?NTtx0h0WCJVWag8kwYDM1XSANxWYCju8GwsibraWNltWH3kxX3RnyfywbHNg?=
 =?us-ascii?Q?wFk26YjJU7U5wnBTRaBqU4YkRlO2CAhX+Y6/M1ikq0UspA/syC8BwY/qBwDx?=
 =?us-ascii?Q?NDDxTqb34I3LvBjYANHAB8gyjMnolULNT9ZWU6owsvPALE2TT1mq0I5l40Yv?=
 =?us-ascii?Q?h9prPAiKIy6Jbd64fs0NVWFoJSRnljw/Xi8xhVdmpnpBJ54cF32wrg80RAcV?=
 =?us-ascii?Q?0c1plVbGz50Dmk+gBviyi0QcT6/fl30auR4IEbvIbKMA427X5sEBjFhNBDGG?=
 =?us-ascii?Q?yKFd2Tqa1qYqrjHPB/JzmQobN2a9Mry83T+nXzBe/jUdLYKulO9uj9xOO6ne?=
 =?us-ascii?Q?gJ47v2kV8S3Ny/UDCqKkooMeFcp1Rp7soh0WOBVthlleO1mPrpbhMciR7wg6?=
 =?us-ascii?Q?z/IOK3giPP3emLBd5UILl/Gq8lLIqg1FMNaxaBv4l4JirmbW2HqrkP5Lw0PU?=
 =?us-ascii?Q?vHzYhzePU3eq42ZKDwTU0d7NX2dzTv2CJpWI95Fr99aqkdBHQwnkpQifM5Gq?=
 =?us-ascii?Q?6B3ro3vN9V/SiY1bQ2b7b89qBFuyxSDbYacgiFhB8gL4PMXEsft+JwhQzJOH?=
 =?us-ascii?Q?kGhvuqac869orRuNDn+NZ/7UDECwfpbO6gB6odCT06J9aAog24SuJc6b+2eY?=
 =?us-ascii?Q?zdPGGnyibWkuYjTKJGN3CCeqMi5y/GyKop3EcXoDnRwqq/b1tOa+oWGO+kw4?=
 =?us-ascii?Q?1FyAeeOnsok1I9vychlnt8V24ArDUlzp7bPuauqsXGWFZGcH63CimDnVDby8?=
 =?us-ascii?Q?v7ZWx+LV4LV5F26wE59CDKGhBgLI1qqwXd1t3+IhKPjbSK378ysplVfo+m+K?=
 =?us-ascii?Q?pV7mDPCcaaK7dwlMgaCNEyyZimdSu07IKTIaWdvl7hexIQvG/q73eehuwwJf?=
 =?us-ascii?Q?WgMP7k0FI04XVwtAkCJU5mcGnTsX05PiKgMqKCDAach/gS39Ks23Nj/scMjm?=
 =?us-ascii?Q?8+vnjZpgMPaTsFEjZG1MPcmFL/mH4IlNAX14RrijpGPcJ81wlHa+giKjbIQ/?=
 =?us-ascii?Q?2ZGr7GNtJdQpgYuUg7jgv+T0huP62LtK7z75XCDR9isG6G9BPIylHJemgba1?=
 =?us-ascii?Q?iSaFdiMmEcsX5MpBpj8ZraALzPfCy7x+PcHTNS6m?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9e687c1-a493-4329-5423-08db734a6180
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jun 2023 17:59:10.5311
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eiih1kh1uncN97QpGXbGiCJys95EhwPGzbPWJUcqeSHh8iU2nxuYZ/O4KszdPJ44
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB7073
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 02, 2023 at 05:16:39AM -0700, Yi Liu wrote:
> This moves the noiommu compat validation logic into vfio_df_group_open().
> This is more consistent with what will be done in vfio device cdev path.
> 
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Tested-by: Terrence Xu <terrence.xu@intel.com>
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Tested-by: Yanting Jiang <yanting.jiang@intel.com>
> Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  drivers/vfio/group.c   | 13 +++++++++++++
>  drivers/vfio/iommufd.c | 22 ++++++++--------------
>  drivers/vfio/vfio.h    |  9 +++++++++
>  3 files changed, 30 insertions(+), 14 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
