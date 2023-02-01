Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C284B68691F
	for <lists+kvm@lfdr.de>; Wed,  1 Feb 2023 15:56:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232613AbjBAO4D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Feb 2023 09:56:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232520AbjBAO4B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Feb 2023 09:56:01 -0500
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2067.outbound.protection.outlook.com [40.107.95.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43B6E6601E;
        Wed,  1 Feb 2023 06:55:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MIV40u4v9TvyEZUbOmmm5iczX8nEvn9wXiG5WnE+N7srtkPace1w8wT9EEbaQQtxoU6t654obezCKKc+cuZaBZt9mdYvkx4re2bZ0jFENx+QMixhE4c0i4Ykp2AyCQ1SRDk9L20FqQyWv6DBWSommBaoWCwE7KV8lH9uVfAT8O2l05S6sIyNt+rSNQJLxodL97DGBdlVMOe9TcfmK6XXuge8z2DHud3NVvE6yUqTqhMDQMTUbs2rOXAEyPlMTz4domX8/TKro5EmBio13RGMyA7YcpTkYhs0AoKj4hzW4GDZr8FNjZJkc6nRTUtRyAyTULZeJ+wV+1tS+HexgdUOww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ba3qIqduVCFj0XaIg44SthSyEoSamoF8rAte4pXdOtQ=;
 b=HFuE1Etw+ssrIVTUTduyvwd3tw6cTzePaXetjT4RSr3umrXAz2a2d3sKtOguzQl15KCVoEUgyR1w3F/VKRDamS+BTs4HSo8WsmOVgi8l26qXfdM5EXYzo7o7CusezahgIefZG3VDI03RR1J1xHGcZ8TtlJrKdZ7eZcb4/v6EhT0oE81JiO8QgIQ5QJS8DBWrXpwf8zoLqEXsDHScANIHBuWcR3N15glkGdwBj4yjng3froePg33j9G6A8kM1lJF3d2L3Eo8q1l776Mx6nhCi7yXPKiO1ynXe0ish3JmRu+I4wJneRCveOaaq2CpNQnYJ/KbzYQ4rbn+hErp7MbXqJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ba3qIqduVCFj0XaIg44SthSyEoSamoF8rAte4pXdOtQ=;
 b=FYsNiVlgh/GRO4ISN4CwM2eNt82MYP8QcUvU8B/V2J0h6O4NqPK3O+uXkSGdjYRSA/6MpTWJyyhdylu/IGCsRMMf1ivpV9txHVE1sH6+C9dEQYtqTjUBu1lmUWObn4o6MJJTXQdUzdCTRVkmXy1WapFBi6LBpkV890clhtyGvDSvd8eXJAf/uzePdoPDJUY5LxTqo8DHjiZmoCconORHM696ZehrGiK94xKxBMYSgi9dEtHGJjPx3f1lKIBHTaAnqN/7MqfH8kgTWxmVlys1u48ho1nvQ7A62A27kkXPFo0uEQDasScMFWXCmiGX2KpjX0qutxlhd9CUkNR9b5UXMg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH0PR12MB7010.namprd12.prod.outlook.com (2603:10b6:510:21c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.36; Wed, 1 Feb
 2023 14:55:56 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee%4]) with mapi id 15.20.6043.038; Wed, 1 Feb 2023
 14:55:55 +0000
Date:   Wed, 1 Feb 2023 10:55:54 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Robin Murphy <robin.murphy@arm.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "will@kernel.org" <will@kernel.org>,
        "agross@kernel.org" <agross@kernel.org>,
        "andersson@kernel.org" <andersson@kernel.org>,
        "konrad.dybcio@linaro.org" <konrad.dybcio@linaro.org>,
        "yong.wu@mediatek.com" <yong.wu@mediatek.com>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "vdumpa@nvidia.com" <vdumpa@nvidia.com>,
        "jonathanh@nvidia.com" <jonathanh@nvidia.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH 1/4] iommu: Add a broken_unmanaged_domain flag in
 iommu_ops
Message-ID: <Y9p9ehPsg9Hdn1OK@nvidia.com>
References: <cover.1674849118.git.nicolinc@nvidia.com>
 <0875479d24a53670e17db8a11945664a6bb4a25b.1674849118.git.nicolinc@nvidia.com>
 <dfad6d75-6f4d-99ef-1c6a-4bf397dcaa13@arm.com>
 <Y9RkG2dejdXptUTB@nvidia.com>
 <BN9PR11MB5276C9BDCCA7FB295C25BC738CD29@BN9PR11MB5276.namprd11.prod.outlook.com>
 <Y9fHJSTIP6zXAStX@nvidia.com>
 <BN9PR11MB52769E3A3DD09983C11677F88CD19@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB52769E3A3DD09983C11677F88CD19@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: BL1PR13CA0133.namprd13.prod.outlook.com
 (2603:10b6:208:2bb::18) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH0PR12MB7010:EE_
X-MS-Office365-Filtering-Correlation-Id: 5adec3d1-e313-4f6f-497f-08db04646b86
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DZ+1smc6Z5k75EG5LuXooClvQ/CLev1mYodUjEft4L34lKITRRq3gWq8gGzHVcsXQ/mZMwqzPfoJ977z4tnMzWRAaEt3DGdNXh3kXeI4Bs6AhcXdV2yfu9zTJNxQneKrJUYkN63p38ZHjb3/Osa8VgRFps8wHwTY45c5x3gcPEuNAbHaR7OUYJu/ffVFk0YhULsWS3Gd8LOAe6SFxOtamivNJd6I9DHcKRDsPE+R+t7Fm7uuHal57o8x6UlzFytr8zbHOreXVc4S6d9b8gtqvZsQft5SEbX7fe+Mwwf6WxiYtuw5Q/Xb+wO/l7GMzeYsA4yNqrT1MaTFOc5IOmSKKKhj1JWQRbPr/0N103c7WOepkwGaEyTeUsRlhr5NLRRJQ+libOFUCxWXL4Ir0ceUwdAEL65k7dV/I2MVLfKmuRCtgox7k16G0+JApgAGxwLmatu0YIcRMcoSR/sIVO5r4U3gtYzks3no1isCiH4n1YPlY/F2+QyjwZw+usnPhFUEjm3ICgtvLJLK8NSNMNvdbXrAdIkAC7QI17FX8R3TgIGDDrhvkb98j+JaNFGGhsFNP8CHytf6b844emnjOGCd0CVImhKOyOhI0oMeItDbMrUpJgLJ5l5CpBWN0Ggf3o12/sI3NlgjtlSDQSb4/J+5Rg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(346002)(396003)(136003)(366004)(39860400002)(451199018)(5660300002)(7416002)(8936002)(2906002)(54906003)(6506007)(83380400001)(86362001)(41300700001)(6916009)(66476007)(8676002)(36756003)(66946007)(478600001)(4326008)(26005)(6512007)(186003)(6486002)(66556008)(2616005)(316002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jUkzPL9yeOQZTYN/DnVwTsivgruGid+ORYYiAGSAPEjI+nU3pkPOJ4Jyt8lH?=
 =?us-ascii?Q?WP6t+sq9fDEzETMZ5NvEwlUL3Vf2Acob1BMe6kd4+osElDqDk5hEQBN0Q9qI?=
 =?us-ascii?Q?knU+kPdgx3i/LHqeGQ+0/RHUAvuKupzpqopD0kqEKNjahrGg4WdgXgviyK+T?=
 =?us-ascii?Q?6QXeTcTx4Stk6DztQOeMPAfK37yTLJh6Jy6jE70F0cJkmcMKY3SbDpZKyrdJ?=
 =?us-ascii?Q?A7jLMxMMgprwe+n6RLdKCzSogs7JdhD1Ok2e4f9r4rayD6Gyf1soWkWF001W?=
 =?us-ascii?Q?lU8J0rryd8vWf/IvoxqQ5aOIOzVUOkLFB3jn+yDSLB+JeDeSWU42rqopRcD7?=
 =?us-ascii?Q?t0l3bgQbAoVVi/XByXMHxtis8IKyMnhMqJJie/givzaAcZ0ZUQ0mNMSWs89s?=
 =?us-ascii?Q?KZy0GtGdrMMIvdhQv2pLn6pUuVkYA/MpgdE6HAIyhlGS5ZuSRlbu6sPMQj8H?=
 =?us-ascii?Q?rz4tF9blppKo9bxaoABItefFBuUVK549+zqr0zWEnKEVrNHNQGCJpE6Dj6lN?=
 =?us-ascii?Q?tMJAiGyRpsrqNMDvYTTFMdTbcQteBHtbpPwLBva0DOo51dGW2b9fXA9oAv42?=
 =?us-ascii?Q?RKviGsYdiQM5nTDzMETKV9F8L/d0+VaeJVa60BIBM75SDl4/1SWfukIyqX5K?=
 =?us-ascii?Q?qIlT+D2FcYPKWCUJaDBkrecu8iXGVJrhTKKSjHtOKDwik+n2nmTJ5DszYMuT?=
 =?us-ascii?Q?7CdIlDIi9Gf/iyp8UWt+P3xMH30l10y8qIbgRg6vLe3UohVwWEFcYOQZBSNP?=
 =?us-ascii?Q?YwWBHYgWV4Mc9d/R4NQBgynxtGoTdLZ5yFZEPb0wtlAFx1Nvh+C7TPatBB/D?=
 =?us-ascii?Q?bRsC6jPa+oPlC/nvmdFrCSiw5nQY9HkNtXK14V4f0VjrPFoIfyo33mSEO34L?=
 =?us-ascii?Q?syKx2PY6snbByrWADu9Ghf46WvZxjkZ02QsM/iKO4OtLGes9VlHwHIeryJlF?=
 =?us-ascii?Q?WJjGaqTjSnyHt0H/0OhWLTwRlaPuVFon+tMl+tmrGWXB+uEZZABdQopsrJr2?=
 =?us-ascii?Q?cKNW+LKxj6yo7hbkBIK9J3UoOfwXiTFJQBIM1omJTTHzvIQD1hEedD0SbEH+?=
 =?us-ascii?Q?8ww9pGsz2uVnvn8kcxcCO1L7UPW/eVv7aov90Mvk3gekS4DYjsyUNxYoSSn3?=
 =?us-ascii?Q?oUJoj8SXxhCvjMP/sciYGckJgzdRh5ldYPfB714jWBBPgb0MP1kU/Cz36Tn+?=
 =?us-ascii?Q?af15CPPC7Fh9pypCZ9dhvmkjhb7gbYrGY0rKAJ0N5u0RDv76mnAiWEw71w+J?=
 =?us-ascii?Q?YcerYLQQz1qbtTG7Eol9AJmNW5K7Zr60q4MnjYhMTXmU6kd+RoYrnDV62Snl?=
 =?us-ascii?Q?GaEewEjK7kjnzegmOgq3DyTqi4y1YZ4ZCWpbVV98roEiw2TdySbEpGroauyZ?=
 =?us-ascii?Q?/vC03uIWaR4h9FkbqG8071I4pW1rsentMGKYCZV4Y0CmCvLcyszyZGgqvr1q?=
 =?us-ascii?Q?l1C4PUnI0NPf2gLGrnCCXnkNvskye/qACNaMxpl7iWyr51AhgyCPUfx1TT1o?=
 =?us-ascii?Q?/8y/2izP9JRWpOktafAnzYVCmg28DFkQZeWb5WlhI6ZYweVyyg2LAxekWIK2?=
 =?us-ascii?Q?KYUcoZi0wUWDcFUDIRRpuwGclVet//DdUxV3tH4/?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5adec3d1-e313-4f6f-497f-08db04646b86
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2023 14:55:55.3229
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XcwCMEEGmWYUdezhof4PYIle/2RRgR8UsoKldvFRulaVT738PXi//oUQG1/lGGb2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7010
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 01, 2023 at 03:14:03AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Monday, January 30, 2023 9:33 PM
> > 
> > On Sun, Jan 29, 2023 at 08:11:48AM +0000, Tian, Kevin wrote:
> > 
> > > " I'd also question sprd-iommu, which hardly has a generally-useful
> > > domain size, and has only just recently gained the ability to unmap
> > > anything successfully."
> > 
> > So long as it has a correct kernel API and exposes the right (small)
> > aperture then it is OK.
> > 
> > The device will not be useful for qemu, but it would run some dpdk
> > configurations just fine.
> 
> I still didn't get the restriction here. Can you elaborate why it works
> with dpdk but not qemu?

dpdk needs like, say, 64M of aperture and doesn't care what the IOVAs
are

qemu needs the entire guest memory of aperture and must have IOVAs
that are 1:1 with the GPA.

So aperture size and location can exclude qemu

> Can qemu verify this restriction via existing path or need new uAPI
> flag to communicate?

It already happens, the aperture/etc is convayed to qemu through
IOMMUFD_CMD_IOAS_IOVA_RANGES and if qemu cannot get the IOVA's it
needs to create the guest it should fail.

Jason
