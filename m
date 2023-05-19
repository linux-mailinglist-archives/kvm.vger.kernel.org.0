Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C8F47096B0
	for <lists+kvm@lfdr.de>; Fri, 19 May 2023 13:40:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231181AbjESLko (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 May 2023 07:40:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230313AbjESLkn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 May 2023 07:40:43 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2070.outbound.protection.outlook.com [40.107.220.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F22E21B4
        for <kvm@vger.kernel.org>; Fri, 19 May 2023 04:40:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TxfaOmKa//XmHyiLWmZ04yQvM3anTGB2UAMFrmL1Quwsm2XbsX41HAsYA4okGhtwxvS1Ydwl7SyG/rcydnAu4UtJu5N6VTcqzYOxW/4GFYlQHFAEYFM+G670XpZ0gXcuxCitB7q0RsboLwrASB4zpOAPeL5n2510bB5G7e6dojgxkOOrp+Urtfrn5KpC3nxJ/9BAx1URqX59OBFK3y0bYkZpdxOvrSsYGIn4SCmHEvvtOkaboY08wqxeVNaPMgTfpY1owjGtJl/yq7rTwvx3GRSJCn3j7ZWiMjXv7vb5US/5ugaMWIXTAMA/6TpaFnVFEis+3PtNlUmEdKX5VD94Bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hitmx/XL7MtPNqC5YDjk4olOLotJD5tgPHHI8+GJTS0=;
 b=Eh6vV7+3cvxx5kOr86JW0mh7nb9BcuuxSTuAMrt7KGzjRlH0hTILtB1RgWdWGtcdfRoeKzwFcadOvQYBvyY/muWqBS3lqRALhyoD+7pJjAZyDX6r60shnRc9SCSgywrCSB3DAzYqeLnRC7sG7bVfuMQOv8Bbfm6Vx2aFB+mhp78c1LBMukkMNJ69+CpP9jjW5a9pLE57ka2W0rcaQwGbJ8AF+LT69TUeMYvkGXnP4xCJnrpxBB9myhAtBKUXuUjgiFHqgnrOh16Dael/K4hzYNoFaSyRqEDwNkV5ED81s0ClJIvRALJ1XXd2niUooklyP4dtUE2Rxc/M4plTApEReg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hitmx/XL7MtPNqC5YDjk4olOLotJD5tgPHHI8+GJTS0=;
 b=GKUOpbw7eq4ZQOx3+geYRq8++caXC2+UoLnuyblJSBY0E/2mzISGiOjzuOVsogyBz4U9//D/GVuKIFTBYg2d+e9MrUUhXEwUbLz9Ewjnk3UUajLyzb8j1N4icddGSFcUA/PKuv2cJ+PnN9rls4/33KpyMacM2hUJJ/9E7Dfvs9W4eG05mZD+WLhFcNuOSQWbkjXgY6oiaLgXLIWydmy7dZ4iRBgXBW8EJzrMBqdTtqNAa2o5TuygLGWzgoxTkYK26NYCjs/OgrCO/FSQMW0q2I+KMAKVvvhUqZ+aVS91brxf3we7xpul5h8x2WabvuvkvWuaNB199wbviy+MYOZQPQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SA3PR12MB9091.namprd12.prod.outlook.com (2603:10b6:806:395::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.21; Fri, 19 May
 2023 11:40:39 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%6]) with mapi id 15.20.6411.021; Fri, 19 May 2023
 11:40:38 +0000
Date:   Fri, 19 May 2023 08:40:37 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Joao Martins <joao.m.martins@oracle.com>
Cc:     iommu@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Eric Auger <eric.auger@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH RFCv2 04/24] iommu: Add iommu_domain ops for dirty
 tracking
Message-ID: <ZGdgNblpO4rE+IF4@nvidia.com>
References: <20230518204650.14541-1-joao.m.martins@oracle.com>
 <20230518204650.14541-5-joao.m.martins@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230518204650.14541-5-joao.m.martins@oracle.com>
X-ClientProxiedBy: BL6PEPF00013E12.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:22e:400:0:1001:0:16) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SA3PR12MB9091:EE_
X-MS-Office365-Filtering-Correlation-Id: d05354bd-2520-4018-5566-08db585dde41
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uca/XXvEmyYQlIInPW5hLfghr0SW20kTesofiUnGXGY75K7S68/TqVA9sPromzuuq991eJ+wCQHqt3xpAtXzDNbJ3AhwY1V9dfDXbJQZRlQ2d/QWViHjZ11edem490FYF2DtE3B4pfpQs2/wn/bY+RMMAJiL+RcI+g/GAa/gAFnZvzHL0sG4RMd2lnUFNPtZBr217iNfsTg7wWHxd5LZZDvhj7EdelO8UH5B4gyzs6po4KskyrsVt/c0jri7igIvA2vJJQbDTXJgw/oeGLwOFVW7xKAxIyvberhJkyemMO5pe6jM9RdP+JboCbolLH5E5nejn/rMhPSGwRZKrDGLMREMI5LS3WGfxl7iCz4CvlaIY5ZPprClk8XPavHKAoTAjruZ7FaVylv1pUOYGwx4LOkQ4sxgIGz2D0nC9zb4NKqiDiyVGn2yPg1zawWr/eRHglBVWwa2hc8WmU5yfb9Q7d1VGhZqMeXgmPt2D4DIxcATY9LP5UXBt9qZWLMz/BZ2zXYNZR2K7iSrkrQYg3HeGHgsCCcAQYhJEfOM6M7Mk+kE01dmC75PLQCOzM0bgFOj5k1FhbfeJyLCnDe00D4H3oTqP5kSfpL9IA2/UBR6O0BaqMxDY9nBAwYHG0o1k0OsFy+YsQlAbb09oXNgWFSm4Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(39860400002)(136003)(376002)(346002)(366004)(451199021)(478600001)(316002)(5660300002)(8936002)(8676002)(41300700001)(7416002)(4326008)(6916009)(2906002)(66476007)(66556008)(66946007)(54906003)(36756003)(6486002)(6512007)(186003)(6506007)(26005)(38100700002)(2616005)(86362001)(83380400001)(14143004)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qtoD9AKdjzI5De1Wr+airDeovu/IV+fv/8Eu0nYp6pN3LOU+0l2WcHsoXzQP?=
 =?us-ascii?Q?GAMPDrdscniqcI5oEWklEUWKNA8QeQufYVP7wEPK4Z45qwRlC/2Zbg3ze3aC?=
 =?us-ascii?Q?8zzNOSYpzonJLeV6EZL3NmCkRk9PhQgtKImerYtw5FXwe7E51AJM3WDll93F?=
 =?us-ascii?Q?VJh7s7v0zJyX7Cm+J73D7LrQ/kGZ3eRZhIonZKsGQBtoUj9rG/BAb32Dmd13?=
 =?us-ascii?Q?NtkjZu9GKxkgshWl4y9jAV/wbFn0dbPz+UvWRsDZ6YH5hL/g3QN1pkAGj2Gz?=
 =?us-ascii?Q?UjGh4wFIk+D4w4ks5XEFpwXdWlUWVHb0c86ykc1lyWrJL1VTGjMxjNEOGvK1?=
 =?us-ascii?Q?lOaLi0cPkSjl3oVQ1sA2hg1NYQkS86mQhDjQisCqoFhBNLmTPzjzsES4JrGK?=
 =?us-ascii?Q?+rr6xz2D5sTdQNvbOq5a4ymSPpj3OZu2vtOG6SttLWrUn3uH6SeP1X9K+BFg?=
 =?us-ascii?Q?y/JbhzJeg/3DRQLlLZPch1nN0hh2hvqCGnFvPqWYaKqt7X8ZUkcxKtshJ9j0?=
 =?us-ascii?Q?tzEqZOKKmcd/Sn/9UNyw1k/sD8nyaxCwGuQyUgXFyCG6kBGHjmJqIKMHe2Wr?=
 =?us-ascii?Q?FFfQW5yvP2HPFY5o6zXaLzjbKATRasQC573FOpUYro9rXUx0LJucYJKX1W3e?=
 =?us-ascii?Q?KsS9r9qXocBp6kVZk2qUDqG9Kv8fgEPeEviAH7BVJBZuuLQYpmR99b6D6Eb9?=
 =?us-ascii?Q?wKNhdZnRef7fyYYyy4voIifAhgF/ZXTonL7V2oyTy3OUUQzHBYSpmp7AYtIC?=
 =?us-ascii?Q?tPwMgL+Ywibj3meJM/jvuuFQIUiHNNq5/704kJALPRttLWgXUK4Tlv/03YXP?=
 =?us-ascii?Q?l5e+jITijbtTM2nvrq7mZUk3YLyUWt7ADzyNyuxmEvvrP/dFm6jv17/7ES4N?=
 =?us-ascii?Q?JMAaCwr55MKZXU1Kjz3Yi/BjJDEx97u0pLDtOhIOdIfsKLaYEMRuG9n3XrSu?=
 =?us-ascii?Q?6chqyYrCwtaDpJ95F7bc8P/JYVsEfXImGPxHmK+Ftm8SYy/XPI0NjB0g7JDc?=
 =?us-ascii?Q?fq/tx7kFtCG7RIS78dLF1DxeFCC579q3msU9muYrjBxyrahIxNEUGmL/ScEL?=
 =?us-ascii?Q?DfnzET13v4RduCmY95D22llVsQ+zMGAKvxiXhnCPuLpOL/PzE0Yf9X3C4nVs?=
 =?us-ascii?Q?BBv23L4WVOvckrA/cfNG+qH81+QWKa+Bn3kUvEaugTEOQAIlXpXDN8BrmeQw?=
 =?us-ascii?Q?yyVVU5v+cqG2unO41TgRC0wwxOpw3xySzp4rvc+t0UjpJLvaaWqqQ3a42ZFI?=
 =?us-ascii?Q?Jrdo+Rt9AitxTpOo8LuK/EMOOv+FzeSug31MFcn4r85MtaqhafER8Gt/P3nQ?=
 =?us-ascii?Q?v7gDopf6tlia/r+3Me+hDcBD67nFcU1IPh+ncoyXQUUEOQRAFg9pkPHm7WVu?=
 =?us-ascii?Q?mXWIUF6PHsXKI9nP170hPDlp8OnAhgJIoO0tjRFzwWyXl3+NjTpb8raTsbT1?=
 =?us-ascii?Q?AjPGWjQ8D2oPcbFuDQUssGjGv6Cb5vkjqter7HEknsh78OMQDTTg8HEUCXuK?=
 =?us-ascii?Q?RVRedIrJxb0AypCkXXpW9tlrCkfJ4WD4zNJuLmsLgQfLJ1KLqLKAelf9Qzug?=
 =?us-ascii?Q?rvLddE0z9fH07tXez0p+T71ItKH+xdV/6dGo6b1C?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d05354bd-2520-4018-5566-08db585dde41
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2023 11:40:38.8959
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yGzqoJTAZReuS9oXSvkVkoesg8/DG5spOcqCLo3PmR9XehlOpY4xYZlTCEnD25JH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB9091
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

On Thu, May 18, 2023 at 09:46:30PM +0100, Joao Martins wrote:
> Add to iommu domain operations a set of callbacks to perform dirty
> tracking, particulary to start and stop tracking and finally to read and
> clear the dirty data.
> 
> Drivers are generally expected to dynamically change its translation
> structures to toggle the tracking and flush some form of control state
> structure that stands in the IOVA translation path. Though it's not
> mandatory, as drivers will be enable dirty tracking at boot, and just flush
> the IO pagetables when setting dirty tracking.  For each of the newly added
> IOMMU core APIs:
> 
> .supported_flags[IOMMU_DOMAIN_F_ENFORCE_DIRTY]: Introduce a set of flags
> that enforce certain restrictions in the iommu_domain object. For dirty
> tracking this means that when IOMMU_DOMAIN_F_ENFORCE_DIRTY is set via its
> helper iommu_domain_set_flags(...) devices attached via attach_dev will
> fail on devices that do *not* have dirty tracking supported. IOMMU drivers
> that support dirty tracking should advertise this flag, while enforcing
> that dirty tracking is supported by the device in its .attach_dev iommu op.
> 
> iommu_cap::IOMMU_CAP_DIRTY: new device iommu_capable value when probing for
> capabilities of the device.
> 
> .set_dirty_tracking(): an iommu driver is expected to change its
> translation structures and enable dirty tracking for the devices in the
> iommu_domain. For drivers making dirty tracking always-enabled, it should
> just return 0.
> 
> .read_and_clear_dirty(): an iommu driver is expected to walk the iova range
> passed in and use iommu_dirty_bitmap_record() to record dirty info per
> IOVA. When detecting a given IOVA is dirty it should also clear its dirty
> state from the PTE, *unless* the flag IOMMU_DIRTY_NO_CLEAR is passed in --
> flushing is steered from the caller of the domain_op via iotlb_gather. The
> iommu core APIs use the same data structure in use for dirty tracking for
> VFIO device dirty (struct iova_bitmap) abstracted by
> iommu_dirty_bitmap_record() helper function.
> 
> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
> ---
>  drivers/iommu/iommu.c      | 11 +++++++
>  include/linux/io-pgtable.h |  4 +++
>  include/linux/iommu.h      | 67 ++++++++++++++++++++++++++++++++++++++
>  3 files changed, 82 insertions(+)
> 
> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> index 2088caae5074..95acc543e8fb 100644
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -2013,6 +2013,17 @@ struct iommu_domain *iommu_domain_alloc(const struct bus_type *bus)
>  }
>  EXPORT_SYMBOL_GPL(iommu_domain_alloc);
>  
> +int iommu_domain_set_flags(struct iommu_domain *domain,
> +			   const struct bus_type *bus, unsigned long val)
> +{

Definately no bus argument.

The supported_flags should be in the domain op not the bus op.

But I think this is sort of the wrong direction, the dirty tracking
mode should be requested when the domain is created, not changed after
the fact.

Jason
