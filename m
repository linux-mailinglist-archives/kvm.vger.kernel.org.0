Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 460AD6D13CA
	for <lists+kvm@lfdr.de>; Fri, 31 Mar 2023 01:56:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231766AbjC3X4T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Mar 2023 19:56:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230340AbjC3X4R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Mar 2023 19:56:17 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2066.outbound.protection.outlook.com [40.107.212.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74AD9B771;
        Thu, 30 Mar 2023 16:56:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QOp6KFlb2N0BTy0OUJhUKWk5s2UxG7lBzYnkZp88XQkOJ+3Ed7tlShCjL/JY5avUUhtIs2W4wTpn5iNvNF3OEu5Sb9gr0aFFyWCBAYvF8qpLCI7flpPZyXKpWjBvRk6xjYzg6V9pTawzcLSwWo1/9bNmc4D2CwXe8VZCd7iJZpfaSQlV6ciITluimHPettyUpvvkbRPCJXqC8RULyCJYwEsFpoxJ4RxpzoUYvxBTIqdlW5OA6dT4idO0K5uYrh5cu/jYfNEoeQX+eMJxZL5xxQtiqGu/90ewT/z3tBVQsTaYpTCyvElDtlqC8m/f8nQjgFcAl5/eXZpdyQnjB9wfeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zhq6MxTlc4BrKBO8xKxfkZnpSUl/f80xjDnJjIpS9k8=;
 b=KeZT2RVFL+3rH5ItWjQ9EfF9W3sRcChw7d8tEUGxZ3GWQSmyVBkK+8FGQ1SutMDMlUlQotbfcwMi2wGdIix7XiIXUKIeTcuwRCwpBghMqyPyHGUkIudHJZddQ3BuVObcuquzkV9dGxfK1e2Ku9JY1AvdsXZVgc6CZ5Xcdh46j+x2Yfngl+UnGBVZ2Uam1HpFMx0XZcsLhIjZ1R5Ejo61zSGvy5AqNKge1wewnpP3RW/7T6W0zzVm7BTMD2RMTW69NV1P3nzbyc9HkemiFvRgdFN/1ggQFJImwF3yAghdXza0pU+bFj8F/+lYTpAGYohYwFb5yZGwf4ckD4D8aVSdsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zhq6MxTlc4BrKBO8xKxfkZnpSUl/f80xjDnJjIpS9k8=;
 b=c9EaURBIfwHlT7CYoQkXSZtNMqZg3ZMgYQDQaB86bMHNDvqdklIjGCJ3Wc0ijBtCwrXfgE3tBXHDR6ne1Ju+5w5hFGAWlaSwjMBBR/lx2cG6g5s+9uw+Tt2djvQgwKnynDak4cTlO2HbB5dxntDYRqaIWTPGUfPbsngxGlDG5h1n+aV8D65kp38Rg6BUNji/RhBYWnPck7qF/7m/A/1xDvGVpitRjswT3I9hwtqbHpGG46NlpkZI7fcXLQeNnVtjbpeRraPkHYg/HVAG/gwEMaIjEQ0xtVYwNvZsJHXQCz7UAxvxVTRe1pC7yAQnbzft5ibbfekvxe5r8/A0g/iLQg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CH0PR12MB5091.namprd12.prod.outlook.com (2603:10b6:610:be::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.22; Thu, 30 Mar
 2023 23:56:14 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1%3]) with mapi id 15.20.6178.037; Thu, 30 Mar 2023
 23:56:14 +0000
Date:   Thu, 30 Mar 2023 20:56:13 -0300
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
        yanting.jiang@intel.com
Subject: Re: [PATCH v8 11/24] vfio: Make vfio_device_first_open() to accept
 NULL iommufd for noiommu
Message-ID: <ZCYhnd/+6mG7itWA@nvidia.com>
References: <20230327094047.47215-1-yi.l.liu@intel.com>
 <20230327094047.47215-12-yi.l.liu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230327094047.47215-12-yi.l.liu@intel.com>
X-ClientProxiedBy: BLAPR03CA0019.namprd03.prod.outlook.com
 (2603:10b6:208:32b::24) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CH0PR12MB5091:EE_
X-MS-Office365-Filtering-Correlation-Id: c695e74f-0f42-4802-6fd4-08db317a5897
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0dpAjcS6kYojbYRJnloaA/y7PLuaorl2QgNBYLC820V4u1SbLU+cHetEXwUPBe3F6/4YMmLT2aGt7rt2Jtn9Z6SJYyMa15ZCW6y7tQumMhVGqmtF1Tc+DUUKrLYVS3Y/syQIvG3yPwAbjQ/kq3r4PlExDVHAi24+n6uJaNlglTUiTcXCCKVoC+qDNfObasdcdLVFPp2YKAvNzGGGCfPbBmkagnZBczCtQcBcdVIwJkziPJyybeF1kQlyk/vuYIEkdpSUA1uFuSbNwevPfqccixhXos7j6x2Z48lEuf28v94q19T+j3LLU3SvrNoXHGp69M3tcaLzuebg1RyYsrZA77iFt8bTo5vVRI0fcxr8qg8RS73PI77pGYlrpltthAdmC3z6jDhFA5vkF1DNBL05mn8JnCRrdcItErwHrpgDgE7R6+JXx3ehAxLPm4EgKdkwkFqKUbM78GmWkQlqPBs/+bB1dj9j+ajP2O9OfKHecCdsncStNsZHxiOy8PqOhsenahb0H1TmF6uHZdtYeqL3b8X8DzC9K2XIbJkslC4UQux2xwDFlCXKMzuzeLf0mpvZ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(366004)(396003)(346002)(39860400002)(136003)(451199021)(8936002)(26005)(6512007)(6506007)(41300700001)(83380400001)(4744005)(66476007)(316002)(6916009)(478600001)(66946007)(4326008)(6486002)(8676002)(2616005)(7416002)(5660300002)(186003)(66556008)(86362001)(2906002)(36756003)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sGTIuyiOvFX8LfVzVjbkPGqgK3TbBR2pc9wNhXVmQGqW75efUB7Rbox4sRHi?=
 =?us-ascii?Q?DBo+vYVhCO+NwdS0YgdsQtYM3S58Un5V9xibaS0ad/iNiiSSedRcTvNHxAZj?=
 =?us-ascii?Q?HE4YMwC7RT5TgOADfdrB/dLftl2UP0C472S7HsP4WpOrncz6cTEWHyIVfzUu?=
 =?us-ascii?Q?vHe84mnobl3iQ+oFBOe15Us7u2MVa8pilBE/Ga2Wr2CioLE9We5h/5YckBjd?=
 =?us-ascii?Q?qQwBABdEfikHiLqbvrYEVjcxy4h2J4M9a/v9SLRTAy7Ts27nEq422ZzeGT0+?=
 =?us-ascii?Q?ok59c87D5WGZ29dOcUAOinrH/zuVAQuxgzU4+TIX+fKmAQ/x2HS2zWk2s0pr?=
 =?us-ascii?Q?j7+z6LWo3DXsZK72u1NTCBa0xmhBb+tIN0F/tY3O6SaKl55Cp3q1UJ1dUGha?=
 =?us-ascii?Q?Y0khI25+AUd/HQbtWreUb5hFCOrnoW+3ko8/twoSSoPiaGKv9ppRT8SBNocU?=
 =?us-ascii?Q?5yzlIc3LQt4GkmAvuU6zQajA8G448hVjQ9kAmF6kNfym2YCXubWiRsACQGGK?=
 =?us-ascii?Q?efyfuy30E3UGOKbqU2RglYt5OI4mIwiI0uzW+Kf17MSdC51Np0APXxRpZiY3?=
 =?us-ascii?Q?npgkOcgf4zRUMlcToZRIdCubKewUiaNFgjoStRxwXHwWOlPxWQSuWMhz+kfK?=
 =?us-ascii?Q?JOG6wWe+pGh3W3pVmbTzQ5ETsNlcEjfROQFJqnUBTObiGZPL4WVLBTc3rBrt?=
 =?us-ascii?Q?S/t5yTzisruTzXAvdnitIGObWrggm8E4ZK9zQ/lOlMIVmdGduqt7dlcZy3tA?=
 =?us-ascii?Q?XFHHOeKp76VdFmiDsnh+Xi7hCedT82kKIvTmk+vIIfGeAUgyAxfYn/K48Qkn?=
 =?us-ascii?Q?7IP8M/Qn04Hy2vW72rHrNRzT2d2h7TSbRDmIaxhrjDQfQWZ6kXK1luOkzZFT?=
 =?us-ascii?Q?cxUHy9YtPuz6Vsiy6kHTYA5zcoTTR6qSY3Xa2dbE6gu/cWbxzk5So2XePnAY?=
 =?us-ascii?Q?a2bn1+CdySDwf/TyDotrB1EEgQD3dDnGJZW8Wj8oKvUtcUYt4hNb7izlJweg?=
 =?us-ascii?Q?n8Vk6DF/wWUE5cScIJL3phdP5NrUIoxUwGI4f/viBjcCF4iiSKCtOOpfxGR7?=
 =?us-ascii?Q?73MR3PtXymsXouwLtS2ym9/AwgJ560MiPhxjDaytDaTHQYE6Cr6tcmEfLZOm?=
 =?us-ascii?Q?N9vmRTnDduoodPPZjVRL+VNAO3V6GmfhevULJtbE1IkdAbYjxDqBO4HCafkA?=
 =?us-ascii?Q?L3aryI+heWo8H0UPDKX5GHNi5ZHZKbX3UgtmgfY/2lnVpvZNvIex3MeTcMEu?=
 =?us-ascii?Q?ga4YVfFEws9GP8OHdiXeVKeVrUGZ5nQ6MWZO1teXESdoAsuWzK5g7GDbvdzQ?=
 =?us-ascii?Q?TppWjrANFCJBShsAc0tQfcfXEdCLW67QPsuPA9cYKOmhJltKCQ+8iGiCijb2?=
 =?us-ascii?Q?N3Wb6nkieOubbigBY8Wa2u2vWEWRq7gkPmTywW/KVxVFbI07EInS4UlM2naB?=
 =?us-ascii?Q?42K94iP/rBjx/jWQl2zR+F5LD2IoqKDkHWn15MjkdQ45mPkoyqfdUcCRHOR5?=
 =?us-ascii?Q?t6jVJ/qZhh3y8MjBcXKMtlcIdvTBq9xZVERdUXA8AZS4Hqd0VbncK8o0+Kge?=
 =?us-ascii?Q?Y15GEwCWztlR0+Jee1oMsG6zjTnybojw8bonFG5Q?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c695e74f-0f42-4802-6fd4-08db317a5897
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2023 23:56:14.6084
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vhPvF6nt/+TFUQ3at4ChwLo6vge+5BNZyncS3E411BNvICtxSKzRYOoWU2MDWzAd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5091
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 27, 2023 at 02:40:34AM -0700, Yi Liu wrote:
> vfio_device_first_open() requires the caller to provide either a valid
> iommufd (the group path in iommufd compat mode) or a valid container
> (the group path in legacy container mode). As preparation for noiommu
> support in device cdev path it's extended to allow both being NULL. The
> caller is expected to verify noiommu permission before passing NULL
> to this function.
> 
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Tested-by: Terrence Xu <terrence.xu@intel.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  drivers/vfio/group.c     |  8 ++++++++
>  drivers/vfio/vfio.h      |  1 +
>  drivers/vfio/vfio_main.c | 12 ++++++++----
>  3 files changed, 17 insertions(+), 4 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
