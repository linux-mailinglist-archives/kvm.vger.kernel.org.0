Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F0A6753E0D
	for <lists+kvm@lfdr.de>; Fri, 14 Jul 2023 16:50:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235672AbjGNOux (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jul 2023 10:50:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234562AbjGNOuw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jul 2023 10:50:52 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on20616.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eab::616])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0A372690;
        Fri, 14 Jul 2023 07:50:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dDbkCIVKS9Rns21VAIKRP+9ZQfz29lP0qT2NoJa+qwEjYWlodyhoTrmLJXQtDGGQhVkSvlq5y+9ztjTi225gDIum02DaiEDx0ZqrYFwJi/mMrXzry1oHbsg4f94B1e+1il5UQtctc3QSy+Zg3UZvP4fVsx4pSdeVXTE+b7livxAVQYsIPABXBHDD63svK6RKFtG8f45vffNznAJfaqnvUXi4ac5c8co57Oc/wnYhnYdvGzyWp5FerpAmHR28R7M3RBygPlX8NZGErh/RgCjvu42ce7k5yHQrg11oON/hYR5jzkYEf1cEGAunnu3rF8z5LtJIIPhvlxDbvVoxEhUXzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=prbNiI7Nns1kor3nHupY3Zwn5oZQAXNVJBENfYeapkI=;
 b=Ouj6FQdvhTpcwlrLLLlyMbC/18nKMNPr2usk8osY2DB4rBgujMMcGOpyd9VrHcIbWUWfARKM5fPIVxHA/2Zz112QlIxcTmUx5ha8OaJbVhknajZFnNNRL1IPW0hu9tXGaoJ19tF8TdbmOEkpqzqt4sVOq8nzxp98PN58tomPLT8cXk2KXrET6z1ZaFwF1DDzx2HwOBT3kP71wRO1+Nj/PZ1qTD0ObwccHcJs3nQ9ZcnVqLlyXevElJObv7967ciDiqW8/Ugm9pnD5UrKGB/wQ/ZSbwyMZX9S4GFwS8l3TRul8JWnLVJDDfpI58OFH0IHOeFZ3OkidpU7vQy7VPrrkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=prbNiI7Nns1kor3nHupY3Zwn5oZQAXNVJBENfYeapkI=;
 b=gO8QRVNm5121LlQjjTa6RrkolofpMcnule5ZWoNUEUMUUyxDwd9osxurLBoq817EvSBIBolP/xHTTXAIs/BQNvkN631J/bPmq5sTj31X77DhC0luqC7gV+0RuK5XlpQQlEcDFXv4YQPp0b1SWLZckKeYaxBq+C6IJtrUngaX68O52dHoRus0nCVyp0uv+SpIE/04p/hlQGTGvMUM4VKEnW77E2MZ4UuAXj/VmDmMb8GduUhaoqG1l6MkvD14BWMIh7DXYJKGVGwnW4ZXLUUvJiIwLmWHgGMDiQALEUielaJmrw+Mdm73IVCIy8hUcOslgbX5IX51Ac9onsPPlXMyjg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH7PR12MB9127.namprd12.prod.outlook.com (2603:10b6:510:2f6::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.27; Fri, 14 Jul
 2023 14:50:48 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::69c1:5d87:c73c:cc55]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::69c1:5d87:c73c:cc55%4]) with mapi id 15.20.6565.028; Fri, 14 Jul 2023
 14:50:48 +0000
Date:   Fri, 14 Jul 2023 11:50:45 -0300
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
Subject: Re: [PATCH v14 23/26] vfio: Add VFIO_DEVICE_[AT|DE]TACH_IOMMUFD_PT
Message-ID: <ZLFgxXcPWUO2ftig@nvidia.com>
References: <20230711025928.6438-1-yi.l.liu@intel.com>
 <20230711025928.6438-24-yi.l.liu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230711025928.6438-24-yi.l.liu@intel.com>
X-ClientProxiedBy: SJ0PR05CA0197.namprd05.prod.outlook.com
 (2603:10b6:a03:330::22) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH7PR12MB9127:EE_
X-MS-Office365-Filtering-Correlation-Id: 0000bff4-5322-4d1d-0340-08db8479b61f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o1M9H59GHM8NGJarC74J7w7G18jHa36EezpEl9vRYjUeSRQgMLjNyQFn5cWmmqUkOOeCXPHiJFUIsRp1O7dbTL0yaazX5dQuOTT/1D8tOwrHcRV55JB9qh+rnoz+KeyUTs4WbFX0Tx23TktAkhMuY0TiOIOX6hqkcsCFskJlFgsPKdS7pX0ZCYf0v64veIALgYyXFDjZ9Ploxe1FRS/GTly35J3zWV3FgMbUfP1V1s5EU8Xuen59UVn7qTwHQghTMqaubRKh9TnMpuZhWpUN3brSNegB2vXFMojVv9Y2XTFATe+BJI0mxR2ipktMPpVdrPcoEbxcRSxbFKvDvedRtqsmlk/tMsmCl/aUV7GB1Q+ZOLsnaM7fTvDoqYvt6z0kGPdNRoD7OxALDpGl4JNNHL/6l0iRZ5Ro5WIafNVJsFejIt2UG+xd8GkaLKtknTSdLk72HP8UA64TOympXl/X29P5wbaJbGZdItk8KSUbmvdX0lr5X4CclztetpqvhwiYZQs6rXmAPUIy/boayok5fyVD9Jcm9H/jZIQ57febaU5YxxiCpXhdEiE3L9bFm+TONsgw076stWhuuqdx9rC7yTT6GtvJgB5vTyIa5HJ/D1Y=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(136003)(366004)(39860400002)(396003)(451199021)(41300700001)(66476007)(7416002)(4326008)(66946007)(66556008)(6916009)(478600001)(5660300002)(2906002)(8936002)(8676002)(316002)(6666004)(6486002)(6512007)(26005)(6506007)(86362001)(186003)(83380400001)(36756003)(2616005)(38100700002)(83133001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cH00Gwv9wbWODtYEpMTG58664K4SOwTzfuC0rQW4RJCcFrZ1Y76aqRn9lVNN?=
 =?us-ascii?Q?PzP2GvnYxEkzwoFKnR339J22HI+cpyLiffT+V7oG78qdSoSedr0nyBXg5d3m?=
 =?us-ascii?Q?jFVvH4NfPWml4rXHAyOquZ/KptHEhwHo7hefP9/GGkMMx7S67PzKnspYjDXY?=
 =?us-ascii?Q?O3JYXaM9rsORWgH2TsurzlsJapblJECKvblZV8OWwopTpWYrkK6p81Jaosfw?=
 =?us-ascii?Q?Y8FqRaNyYxWlzqwY+lmCdPcKdmKrCeoSSdsgfaWz99dxM/d5cDuwnfMlONk3?=
 =?us-ascii?Q?wXT9c5IUlv/QhJ2+2Rhjdc4797gIzUtgTR0vrhKiLqUMMAn2jImkpe5ipjOS?=
 =?us-ascii?Q?5HQmmKSDJZY1rDzjJDN0UWboCadw3jcDfxkWn8IzUwXmwtaSDa4GawgD1dZB?=
 =?us-ascii?Q?mxY2IVGAzm0ihyS/u2RIpxSWphW98u3deB7BUJ5eIwPQ8Es4vZWWP2CK+oeX?=
 =?us-ascii?Q?Pr0o7vav8i3jIPCQpQnwKD/+kBmNrJ1vCrI4eZa7KLgElu1mU6Yvxdp33848?=
 =?us-ascii?Q?ep4stG9CCfU+3wxNZ47PWegnqO6yUG531b9hLe78ZKjfep8QXO3lim6UwJbO?=
 =?us-ascii?Q?VzA/AiABG9PEmsJQNcjY8/I03KwZUAuu2kEMs/pCMg2K9RYEBSip5fgSBTMs?=
 =?us-ascii?Q?IlEdaiPqVSwtk/gaXnBrx+k2LKOPwiFoBgacgJiG5T/eKm6yC2WnS031fTpb?=
 =?us-ascii?Q?ix9v4tbP78/v4px9qnck9ouQoU5paxxY8s0GjELBFXOnG6XLHF1xk/RTcA6C?=
 =?us-ascii?Q?Hk48T4fSIGRoFCW3/FWsdoefqmFnSs0Z5GPADgmM1xSHHkM09hEi3csTSq2I?=
 =?us-ascii?Q?ympSMj6pZF3zMKQjoW2+Aq73UwxyJc5rwn3Tcg6J+bgT5eIgwuSdm1j6pKC1?=
 =?us-ascii?Q?nhuoT2DZIroFXmHoJvS29y0eJ3dKNg+49CP0wmx207NN9IDau4crCc2UJ2Bv?=
 =?us-ascii?Q?emcR4d4CYVh/+QgvZUsrZT8jVC+wMP1vqlfYLFo6VGkc01UBbJfn3fc0WJxD?=
 =?us-ascii?Q?Q99pJleZNvMauP/+JMjO1m3sPEV78Iy8ANY25SDAdj6fj6ysh/KyP1PiiZtV?=
 =?us-ascii?Q?xP98WUwqJPUxNEnmN9PS2ZX8VkosEvgQR+J3veq01DrUULldtVrAvaMkWU1K?=
 =?us-ascii?Q?bs+pVQTHWB3c09mCJxM5INkr4k7HK50kgZjQTW03qSvM4/Aauv36Iz+R3eHl?=
 =?us-ascii?Q?L5BUkZoeJ2dySC7EmEadfBlr4JhXHwRRiYBHPr2Ku5n5nz20V0K43SneZnnr?=
 =?us-ascii?Q?y0FBYCo906/V7w9q6osJyg3jaNuXGBwfgR52EK1ANzLrBlDzWwu2GfWO6kpf?=
 =?us-ascii?Q?HABNJwEldtvmQFxyILLHvwsXxVOXUbCc3hO4nzBlArYdsTRk8WIHGm2kiZJJ?=
 =?us-ascii?Q?B4oMjDX6SsPTs1FFGiMgrrgMUX6ng2FWkdE2Oc5s117wPC4vpVsj3vXZdjWG?=
 =?us-ascii?Q?1xYNJMNNX2pEfy5qvwU2DJySKzsidunwrkjXdheuvULxtYYJsWlglwZxtOZS?=
 =?us-ascii?Q?H85X+wCrOiyGz42KTD5btZL8JSZRmMvSPofRodQDPkDcoE5arzxs5LyFwo0L?=
 =?us-ascii?Q?zy7bT8iCpwfobu50FEj0IPmvw7eT+3XCPPTPJMKG?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0000bff4-5322-4d1d-0340-08db8479b61f
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2023 14:50:48.6513
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hS/5BBzNz533Q1NIJOuRaQp3Sw7kmYzr26oZDCvcAI6l/uYaZqd30oscmW1TvC+u
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB9127
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 10, 2023 at 07:59:25PM -0700, Yi Liu wrote:
> This adds ioctl for userspace to attach device cdev fd to and detach
> from IOAS/hw_pagetable managed by iommufd.
> 
>     VFIO_DEVICE_ATTACH_IOMMUFD_PT: attach vfio device to IOAS or hw_pagetable
> 				   managed by iommufd. Attach can be undo
> 				   by VFIO_DEVICE_DETACH_IOMMUFD_PT or device
> 				   fd close.
>     VFIO_DEVICE_DETACH_IOMMUFD_PT: detach vfio device from the current attached
> 				   IOAS or hw_pagetable managed by iommufd.
> 
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
> Tested-by: Yanting Jiang <yanting.jiang@intel.com>
> Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> Tested-by: Terrence Xu <terrence.xu@intel.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  drivers/vfio/device_cdev.c | 58 ++++++++++++++++++++++++++++++++++++++
>  drivers/vfio/vfio.h        |  5 ++++
>  drivers/vfio/vfio_main.c   | 15 +++++++++-
>  include/uapi/linux/vfio.h  | 44 +++++++++++++++++++++++++++++
>  4 files changed, 121 insertions(+), 1 deletion(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
