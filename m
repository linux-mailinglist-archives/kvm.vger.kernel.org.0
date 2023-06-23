Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 438A273BCA2
	for <lists+kvm@lfdr.de>; Fri, 23 Jun 2023 18:35:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232035AbjFWQfJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Jun 2023 12:35:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjFWQfI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Jun 2023 12:35:08 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 718561FE7;
        Fri, 23 Jun 2023 09:35:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dwa/w5fmtqpqCW1vl+Y2HLdBMbol4Wy0KVgAp848Yws6lxr08aBkBJWPhrgZS0mdD5B/IrLRM85MmPeVMpDnT5MozrtKS+gG1z3FLf+YXuxelR8W/WTORizG3zQSynLxPQ1hibBb4x3J1ePgLgkPiX6rHy+gty2ZAOwBIDgtYvF8G/uhEIB7Ioog/yB4/Ode5MzyUl9+7X1y5NDGpMoV2eJLIJG92YKt4YcNLIXY68bN+aVbiT2LOr2QciMK0QZrt4+2wwn0s9H09LiuCSVmo5rKPRmFmAJJoE7xoOCbw19U0aAMDywuWYH8RLkOCgtpFRd/NODJ9YjeRTiG+UvpSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kCaZJehyyEO+7dFM4b9tI3sbWYarwKK91ZDvOOQmq+0=;
 b=jIZfpbLupwcWwNF8rclR8xBjn8MOfk8UN+FewZ8Vh5w5irlPqDcmLoXkg0fOV41vjziBFBg23GnM0IJXivKmDx6D8IgNdEOSXug2Oia4cEv8gsB4jO7IXLd2SeEIJyiv9lnw6UJ8AJ9NoinYnQ50VnCNTGprNfBR1miKtkmoRMVGwBijtP/AdfJre3uB3QhRmMhW3insvi7ShZbbO4Pf2zO02NCzFl4RM87P18tgo10Y+Vzz/MfeulsLY/JtTxkO8DmeO97DcpN/iKPAQCJrV34QZ6ilB7NxBHScvKSVBo/PpFf88+ddHna2+YShT08sdgZrx7kuSowoecRw2wkc0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kCaZJehyyEO+7dFM4b9tI3sbWYarwKK91ZDvOOQmq+0=;
 b=q/NQW7VBfTnkEva3zB1lTr/ExHdXUmpBQA+GQlRvAqIHiZVLZEjSmp061TUWgWsG7+4AOvenKgBZIq0nCwskxETHJkrNAKX71iCCdNSvC7MGOGzE2ufAju80KZyiCdQTs579oH7RWVnAwe8iHgL7rU9/uJmg+emD4eg+uzpjTglxhPrNCTPfRZKjUm46+akI9HazVaNdHQxen2AhdsnHJKYW/PoMtcBkFDKfaJX44I4HQeguP0PuZkVpyrXw+leERcvcVP729LOqbNUf/cbWSUY6nm/nZlFZ0wdGtk3UTyt+ESv6ewLaRxl8Ai5mwyuOQV9V3q3wcHOgD95tk3iCag==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by IA1PR12MB8333.namprd12.prod.outlook.com (2603:10b6:208:3fe::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.23; Fri, 23 Jun
 2023 16:35:05 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%7]) with mapi id 15.20.6521.024; Fri, 23 Jun 2023
 16:35:05 +0000
Date:   Fri, 23 Jun 2023 13:35:03 -0300
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
Subject: Re: [PATCH v12 23/24] vfio: Compile vfio_group infrastructure
 optionally
Message-ID: <ZJXJt2K42DpNIxBY@nvidia.com>
References: <20230602121653.80017-1-yi.l.liu@intel.com>
 <20230602121653.80017-24-yi.l.liu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230602121653.80017-24-yi.l.liu@intel.com>
X-ClientProxiedBy: YT1PR01CA0040.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2e::9) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|IA1PR12MB8333:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c6fcee9-328f-4601-0cdc-08db7407cc8d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: geS7PEWW92tmgK9RHuPA6fvCeqn6N4nF1QqJyP01Bsav7255TWkjP4CHARURCdHAA1IKv6q8mR30OYZaP9cI7vQ4h0V4+neuB+57Ws701JN81Xu0Pv/190inrHEF8wj8jGdn6wDFhZ1yyHBdI1ng3D6VT9Uu9jt9Cv6ShAUz8Q00JorLOgYA5pYknE3Db21fJSrAJeHmDX5NrA5tFUjm6vbX9QQiQca+4RNxLdpD1hcmdtuMs8Bgfdb3GHx3pyS+3wJE53lK5GzpAEnlKFjNve2jCpgLxqPOWXW73pk8/SUEYbFOWbLKOKCwMvKWYndXw04SK/TzlSaSy82GqQyHbgsWvjEfJ3lwLc1RMMpVpzeoNCg0sQ6tBvzgIUz85ySiQvkdginFws7QE4KbFwr2JDr/E+5FRJQ4hxsUSLUu8bb9+5QmF7ry0QOQwdg0c0lyHVBMi3unJwRJafQQPAYEg9Ya2cjKUkwlj4UE7WT/LAGBUimSl6NfeH01WlgxVa5VAmudDOaRl+6TqmI3dQCd8k8CIkLWvFFQO2UCVQ/9MqO7V6QOsWdgZFkjdtRsNXYw
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(376002)(366004)(346002)(136003)(396003)(451199021)(478600001)(36756003)(6916009)(66946007)(66476007)(83380400001)(66556008)(4326008)(316002)(86362001)(6512007)(26005)(6506007)(2616005)(6486002)(38100700002)(186003)(8936002)(5660300002)(8676002)(41300700001)(4744005)(2906002)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bs1E1GsWQPXCqvlWrF2GB+j9FBHNykISdyyGcc4LwLN0wSOCoQAZVY/XcGVk?=
 =?us-ascii?Q?pB7JvMsoGFJbbRpI3nBO50K3SZblVUKTGhdw0xww1h4FkMhpj6MIhaKMNNUG?=
 =?us-ascii?Q?WcRjgc3ioAPlJJRAHDqEGMe4UDw5wCfAUGPoNKGsSCYxp++HVryf6DB9Yq36?=
 =?us-ascii?Q?VpvMA02EVRjQXdmI3RT2HOBc+dPfRmneO2lvCeVNqSk0ONiMwAeLCrBFUxWF?=
 =?us-ascii?Q?uEJBpOtsZUUW0FDLr0hbVeknhg8rPiarz7fxueDXrf8WPPCfZ1RoREPNPd/X?=
 =?us-ascii?Q?xInDmN3RMqD+bZcNXGy6wtvy2IligD7oTMobmlpWcIOwCoIVEElAtRVJ/Bb6?=
 =?us-ascii?Q?ZV6vihOP7S/cZiYjI6hcJUUfwPRu4i4EaYlUXiM/mPnbX5SBG3HAyx/nkM+d?=
 =?us-ascii?Q?Zu1YMMl85n1mMqyQk821amP+v4xazofzTOwidBsf3h4w8q9tRmNBdH9FhmsV?=
 =?us-ascii?Q?skPaYbm9N+61hOeAelKo3ketX9rfui9VpnG/Fds1C7f6v1JZH/b+QGcSXIhb?=
 =?us-ascii?Q?YQPs47FPREugKpT6Jv24LYqej7rl76duGVw+I5d1MqUfy1A+TAMn3oquaFQ+?=
 =?us-ascii?Q?HIU31V0GcAzYjZt0pSh+6bVmh+VXlv/Jnj2aZXVL9U4/jllHIvZ5bW8FCJ1l?=
 =?us-ascii?Q?VFJXvYCth/jiAh9Sp7eCXfWU6fO2vVizMAdkoba7t91wJ8De0cRYpHESUSGK?=
 =?us-ascii?Q?j9oYt0iQRtG9OSIyAlGI/HsTIQ7Qsl+IDzBgDfyCy+PztaTs7uft5KhsCVzo?=
 =?us-ascii?Q?P8ZVbnkcrlIQuAFNfQqq4Lg20ECJihOUdr/bnRw4FE+Mqt6tmMEUm0BmWAG8?=
 =?us-ascii?Q?MZDuChTL4Q5fClPh53W4FPuPwGkOdjFXTYjvU8hB5kQRbqLg95rQE33YhuQz?=
 =?us-ascii?Q?VmjpunOaokhoIyWufw/DiDinrSyIO0lxJjvCFAWA6fPWOtOKbuhrtEtfGzIS?=
 =?us-ascii?Q?6BMboKMIgpHD1HhtHkn5kSiGBR+y5+2brJWNpR6emxdXMZxVgWAp5dLt1tPA?=
 =?us-ascii?Q?5a82MqT6OXjm6QGXqx0l8SEHpj5/vWkbH5ygd8xClWBc+El7OFRPIYOF4reN?=
 =?us-ascii?Q?dbsY1FgDsEezEblU/4GdHuGchvCY2E41FTefbBeUgzH+SeZgS7XBrtXS8BZg?=
 =?us-ascii?Q?Us55KC9aFF9T5SdtJQhaJxXJr1eYVhK2I34pM4w5TwD+PYiLlAGzAABmtCKf?=
 =?us-ascii?Q?Y6yN0Tyy5jCOKbLsNzKb8p3aeEV3Pspy3ll6s/s8/4QfMMGGBx9paNi8ZgbF?=
 =?us-ascii?Q?ovCgLh1i53e20rPBx+x1MtCU05/1OQul1AoYutrhy/FP+Ibiyu8TmaQemZp3?=
 =?us-ascii?Q?DkRhBuaxey0qgbBoJzAmUPLM3E6HrmVn/kBjtfh5plXIeUhMWcFUDLzz1ipn?=
 =?us-ascii?Q?aQ0z6jogl02Uk1wEbKGjuIoLFFBvzW+xOJbxFJKLy3vmlUDP8fH7XF1D1D97?=
 =?us-ascii?Q?9p1Kdnk1Vj1HZqVY6qUhGeFJ0hAbkcxFKEosS4/aLyz8a0XVU7D92D+qMHdQ?=
 =?us-ascii?Q?MyfA0qOXsP9RWPmDB+GJZHhFjJnuD8+0hq+nH8D/JLhhZUa+iGQ/RbCcUTAE?=
 =?us-ascii?Q?Ih41mXH+/RzztZFSer3/MBbVRafk4D7KCMtmvsjj?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c6fcee9-328f-4601-0cdc-08db7407cc8d
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2023 16:35:05.2187
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5bosPnsxOTHXr8k7unetDXg6jx/FfVbWmWzpW3/sb60k9+D6nTlCXCa0NObxedRl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8333
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

On Fri, Jun 02, 2023 at 05:16:52AM -0700, Yi Liu wrote:
> vfio_group is not needed for vfio device cdev, so with vfio device cdev
> introduced, the vfio_group infrastructures can be compiled out if only
> cdev is needed.
> 
> Tested-by: Yanting Jiang <yanting.jiang@intel.com>
> Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> Tested-by: Terrence Xu <terrence.xu@intel.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  drivers/iommu/iommufd/Kconfig |  4 +-
>  drivers/vfio/Kconfig          | 15 +++++++
>  drivers/vfio/Makefile         |  2 +-
>  drivers/vfio/vfio.h           | 84 ++++++++++++++++++++++++++++++++---
>  include/linux/vfio.h          | 25 +++++++++--
>  5 files changed, 118 insertions(+), 12 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
