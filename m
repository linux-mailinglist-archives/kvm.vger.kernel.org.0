Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C29B6EABF7
	for <lists+kvm@lfdr.de>; Fri, 21 Apr 2023 15:45:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231636AbjDUNot (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Apr 2023 09:44:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232628AbjDUNoa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Apr 2023 09:44:30 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2068.outbound.protection.outlook.com [40.107.244.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5737D10278
        for <kvm@vger.kernel.org>; Fri, 21 Apr 2023 06:44:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JzUTSZ3XAl/9Z4eeRT8qjfH4RetMSPcR6LubAqnYd5K13d+pWmlrWcpY9Wxax9T+M/xCUP+gGfa9h5laXw4fQfc5EdUKFGiQFEWJfq1jcrvqrBZ+QIa5bwnAkh1Dyw0V9k5lLja8tkwJnkQQLnr81TdJU8/gwNTqDYWk3yjpa2lryiVe9nWBoF86Hw2KGXgpJkOKD+fFnXz1Cg7osCICqt0PtbwlQHsn+RRWY33IMlEeMShQEp8JaJSDXVYsl/xKe3ZMUAYBuCdzkCP73e6oEl9rKbtpfiCktCt6fgZ37hIHuz7V3koa9DTuB83k4D5gO6QQoBaE1hHOkH5PnSD2VQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=znHZY817BMDBTG/1GV/zKGEsjdZY5xxmZX+IeTvwtGo=;
 b=HAmEAAsksa91JaqS4V2AnR7wVwFUvYkzR67jrKLN6EsMoAO3wf7056E9aIYXXy1WY9TtpCK95veJefjgWNcLsnPNfNZrTZ/f6I3M97ML04VBeWVUgKID4qbtERptk0yoN0MAaTcGpm8QIvxHkij0svwDbZCJUmJ6Adma2SHoJG8dte+4o/jq88Gr7KIvizWKR+0BUuF+8Ymh26uRLOqEZHH+lLQiB4MTa18NPtR8FPjEqIHqW1X478SPFMDHEYnvYqqnuGKofKV3BHMg5XE5Oz4hvxUnCHl0PbiXg02p3MF8RMG1vtdNTjAog3dD8kGqGt1DmcsJhB4YHlJC0nPrDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=znHZY817BMDBTG/1GV/zKGEsjdZY5xxmZX+IeTvwtGo=;
 b=ad/pa/ZX0rQqvNrjg4Rvm2oo3/vVzqZINeSDpSILpMACWF4vtrsGW87OunoUx9SJyvHKV1gaC60OlNjlvOt2aMHc4BUacZbPayq+oz2ZKWydFlg7oSdvU9b+2rOPp5bIk/K/xZZCRllKSsPQYK1pjDc5hIghg31oYIqKAQenB/5ijbilbFqKSDuqlfQfk3OLTscuGyZo6sD1mJ4xm2g6n+BD6YnkI/Ob9BkPrwu0l6Qq9NvXKhs3kOOWfifuvGd81gVm7/qqtgMyXabE+/pIGFdzLyCMb6lTsTFmsf74onuNCsbRIj7e60jaqpYj6S1srVpRvNqd4RHMg2mx30uWVQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CH0PR12MB5372.namprd12.prod.outlook.com (2603:10b6:610:d7::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Fri, 21 Apr
 2023 13:44:23 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%6]) with mapi id 15.20.6319.020; Fri, 21 Apr 2023
 13:44:23 +0000
Date:   Fri, 21 Apr 2023 10:44:21 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Yi Liu <yi.l.liu@intel.com>
Cc:     alex.williamson@redhat.com, kevin.tian@intel.com,
        cohuck@redhat.com, eric.auger@redhat.com, nicolinc@nvidia.com,
        kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com
Subject: Re: [PATCH v3] docs: kvm: vfio: Suggest KVM_DEV_VFIO_GROUP_ADD vs
 VFIO_GROUP_GET_DEVICE_FD ordering
Message-ID: <ZEKTNVhWiHb0BmWX@nvidia.com>
References: <20230421053611.55839-1-yi.l.liu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230421053611.55839-1-yi.l.liu@intel.com>
X-ClientProxiedBy: BL0PR02CA0002.namprd02.prod.outlook.com
 (2603:10b6:207:3c::15) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CH0PR12MB5372:EE_
X-MS-Office365-Filtering-Correlation-Id: d7fcce59-fa02-4c71-f2bc-08db426e83d4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lkwFFR48933d8ne9NkYIM+7Dn1drBjJkk5JK9+c9BV1XkotvlahK6qp68Jw2tcYWU1N+Tl+y9rJ0V5ezFiuh6KQqB5KWl6qK2aZHsvEJnrmoxVQ/A1spIuctMaeH4OHBRtGM+8ger6tSIM9xnpeePTC8IxDw/gzqApseovJ6RN7kxt9DnPWtt5rjU8GovRKRpGIsl+UHFtet30MpJouAHLt6Kfe7DMpDN405tNUZ98X6cBaOwvckOjAgJcwb30D/dMjyYFSsqoz2aUgmoeNhvURzJ4r8XDg5Hyq4JxnQhgd9o+GNgvzPIEVoGx9c5Dw0BtPikcc++C+sJsu87q6VML1LPmwoqf9RPICXOy+hdsuJBZ1lQlBDy9Z15AhBnL0srBN7fu6MhXXVzjpUnHjf81M3tXLrof16/pf6rS82wRegUU1i0NzUYzHv2Y/gkO/B9YpAEQu4jqOkV5MFhctG7NLp+a8kXU5WLK1fgpDx/Nm+a6WWHHFs9uzqLsN9z1ixZQRxy6IThpIO9DE/BSWGX3rMkFbf9+EleeZ7Y7Rv/hZ5Dy3q7PUBr68ZXlhizc2HA339A7hcoMgl5c3Y0Nd5AN6U3i4oJheJh0wkvVfxRs46u7p8uURF4CfvZkbFzxbF81TZtZpqIskC2tcer0d4Eg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(396003)(346002)(136003)(376002)(39860400002)(451199021)(2616005)(83380400001)(6506007)(36756003)(26005)(6512007)(966005)(478600001)(6486002)(86362001)(316002)(66556008)(8676002)(6916009)(66946007)(66476007)(38100700002)(4326008)(41300700001)(8936002)(186003)(4744005)(5660300002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?32f4ENMitSNvhJXQG514l92UYiLFMjgtTpFeCkRNE4AU1sHs+ITFaHDci0hT?=
 =?us-ascii?Q?hQP8vlR8jDXxPyzNqgY59JNNBZRiKot2KZIdwgGoEt2q46MIfFsKTbTd3VHp?=
 =?us-ascii?Q?ZSvIrwz0pGiM4CwQysgCUXzWWHWLs0rp8zxHfp3mOq5xA+oibfizeVSAbSMu?=
 =?us-ascii?Q?N+7PyBGAdxlCdktyJVgQAqeTQK47RoejcUQeNrmR+wgqrHKDNiDLsavT0ENP?=
 =?us-ascii?Q?fVS4/M98ClQBYKWT1zMsJU1Zp8u4OQIhMvcG5dEkpALHGkeJ3uIdRqC02E8P?=
 =?us-ascii?Q?Ni3LjYTYsH46eTfxc360VampQC0vIhRycBpItABH/4xjjN61rGCeLQ1fCHSs?=
 =?us-ascii?Q?b9dALoZwmfgLXnDn1lYsdpn+tRqjzraswSJp3F3s1C7adDoogX+UIpEELQfQ?=
 =?us-ascii?Q?b6h30BgOwhrv2+ssfsd5s34GwDrb8IGn52GHyflJsepluwgB8Jq42Jgkva/o?=
 =?us-ascii?Q?ezKdw6Hnf2aGod/AaPhEpopK4b31T8wlChAVu9N59WIfbkRCgErzH0PraPbu?=
 =?us-ascii?Q?0Nh38gd8AcM8WdFfHTwcdscu+elfHIKYMlLUUBBN8SSQR/L2I4VDOPD0UWRQ?=
 =?us-ascii?Q?ik9WW5fUN3zl/7CUpp3s2tqfQCu6xWFPTdX3h3uHVu2DnwYbI2sLKcwt9emQ?=
 =?us-ascii?Q?B4vIdg8ijukB8Gh+2AQNbp40gHST9mH/BefXHKy+zLFK87ZDqL6iQJ828hyL?=
 =?us-ascii?Q?oWzdO70Yc4p3j8h71qRqHlUi0UL6uj2DC1XyBZuyAG0f5SLQxYLqsKssq1ta?=
 =?us-ascii?Q?2IIw0+Lz8OBhkwic11+vCnsHqSUdiYQIuQpq0W59SxhPPPzOunA2Mikpr+5c?=
 =?us-ascii?Q?EwO+F/85L9ZeuawqJ9UvFwQ4K9it3qDr1VOicipf0lrmnjxOiOs5PC39sYlT?=
 =?us-ascii?Q?Qv4s9PurqNghMOCmIu7FB/m88Yd8FzsTwbnilbsGnOhIzx5BEU91zjOfNsVz?=
 =?us-ascii?Q?N7OtAwzjxOyZ9PRpKO3ZcrJSXCZy0fYGbHQXJcBZGrJ8hdRetDn2HQ8AYD1R?=
 =?us-ascii?Q?8mMaS20ATcC8/AOscppzEIFk1tsAWH8i8floFrLcmMUN8Ts5GzV9k5sv2ito?=
 =?us-ascii?Q?a/pUXJMceHDzRfCYUGUC4jtWpNoEUg/WssUyqR0G5d+o0dcIIXeJCrhA82kR?=
 =?us-ascii?Q?wxkV0qIsCVWz2LrI3iSLcvpKmPlbRD6SXtjOcy75jZWaAdeNInzJIhqqjdPc?=
 =?us-ascii?Q?GYrfvVjTICDk1HCqkI0PUYWeX3Wyrmvc5Ze+nk2uZKU95gKUm1a+o4WD+qXw?=
 =?us-ascii?Q?b9jJnfk5CX++FxSMSuKw8gZBHfk6VF1S70biZMrpcxJ67RwR4xXWFG3ybwnf?=
 =?us-ascii?Q?4ntgUHYv+Iz+xRTafF0mk8Z5Mgs7q7RLFZW4N03XEgQ0hcmLje2Or6S9d8hc?=
 =?us-ascii?Q?CJ1PAK2O7MrT420TlUY0zHTdWnoKsHfQKPQqQ+naBV6Y81a/aAYMh5hRv6vq?=
 =?us-ascii?Q?6fjjRQz/7s3s6dvSnKwJSdSqSezj4KKuZvW43gtOfrIMFTRhDqnjPpHSF029?=
 =?us-ascii?Q?uavDjmAjUjLipJ/s+a+l7o3NpuFC5ufc8ZS2UwW9tMFeOXq2M8M+Jwcwmw97?=
 =?us-ascii?Q?zLplp3C36RxXUng/dK47TDap87AeCmBnouomvfZa?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7fcce59-fa02-4c71-f2bc-08db426e83d4
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2023 13:44:23.0140
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pBRb8sqc5t8/wgsD2yJPpVgIh1RZluWTrol8/wxi/t5n7wrt5bhTH9FZ2nvjryze
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5372
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

On Thu, Apr 20, 2023 at 10:36:11PM -0700, Yi Liu wrote:
> as some vfio_device's open_device op requires kvm pointer and kvm pointer
> set is part of GROUP_ADD.
> 
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
> v3:
>  - Add r-b from Kevin
>  - Remove "::" to fix "WARNING: Literal block expected; none found."
>    "make htmldocs" looks good.
>  - Rename the subject per Alex's suggestion
> 
> v2: https://lore.kernel.org/kvm/20230222022231.266381-1-yi.l.liu@intel.com/
>  - Adopt Alex's suggestion
> 
> v1: https://lore.kernel.org/kvm/20230221034114.135386-1-yi.l.liu@intel.com/
> ---
>  Documentation/virt/kvm/devices/vfio.rst | 5 +++++
>  1 file changed, 5 insertions(+)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
