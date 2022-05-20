Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33DAF52EC0B
	for <lists+kvm@lfdr.de>; Fri, 20 May 2022 14:28:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347852AbiETM2P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 May 2022 08:28:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236590AbiETM2O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 08:28:14 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2079.outbound.protection.outlook.com [40.107.220.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CE06163F7B
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 05:28:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gckbal3umQ6li0ScZhlQtPV+arwa7ntodDMPG/ShuyLaCwGQtmBZtgRD9Qxmfqt9jpXqtSrgzJBEk4x6Bb8OfvyIEoRkEqSXI/+6jnHDqUHucOlG/yAaJKoHcNhVO4zB9R+vPoaa5fpMtyAlzsdgyYwwtvvNsZLw06lZQj10qLbZ8QX9j1TP4O7NgWyi0oN4u7ZKMqpxQ4Y0s6AMPkXTCy+VfmRmP006pqHWXPSo6ZjsYCqhH2LN2x1ecfAauRojb/uMm8QDa8cb4Pqgc8SOgky6XH/+iaNVS83zIAseNIQZPpfUZWJTkVYLEma8xrculQyLpuuCK7Xq3oIegXb01g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3y2kvtYChaWykyXEepG4Kelmzw1nPOyscyowY9LPixI=;
 b=NiAWOkIewYZ/UGW4CnJxPNb8xqlPDuHEHWcHWxWmvxv0FiG5JoZfEjBK86QGHGyalDBXPFJGwwLU/2yNZVhitN6sbtrcBgzx9HFnMkFGRorTugHN4ThtcmAM1wehwWKurtR8MDM5wQcbjm8eICQvfHWD0ZoGdUt9v0B4Pzg/AMIiFxdKBQfOkvl5Ar/8/jXTq0VlEjJmRnoHchtoo54H59AIOmdFrofAr0MhP5CyGtgLx80MYpV1Zu4iuXktcFnRAxw6TbsEAlc7MSA17C4SrHSGIzg8DB/bFVAO0hboEZr6rbDasUL+/EYQBkFYc2sv4N/9bpJiDTw9HPIsp0KKDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3y2kvtYChaWykyXEepG4Kelmzw1nPOyscyowY9LPixI=;
 b=oMbtvkmPEcOVy/gE6NbApSgo2GkonXQ18xhTzoLTjt9OKoTyWukQBGtvY95XtP5I0FpQmXHl/aq78w9iz1sURXHtzF1l39gdwj3bffL98oal1b9SKu2F0v/Rin3PQeOZ87ccD6WgSqa3HrEhQQh/Z+xYRZxzQXkiiuwOC/VmanVVoKOTHjsN5hsjXY6biErhWOXmzbXfPUFzlwEHZ65wZTx92TB1WzWYtOVoXZkSCJeJXvTs3/kFYimQ3kd3Veu/W34bqPqej3LfrIhkgGHkguyISIWTVxjQWpFUG0eXbpg6K/LZMs3o3Bu2IaKLvQJl2ul02PV/G8YsOJnCx++RRA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by MN2PR12MB4584.namprd12.prod.outlook.com (2603:10b6:208:24e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.15; Fri, 20 May
 2022 12:28:09 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%7]) with mapi id 15.20.5273.017; Fri, 20 May 2022
 12:28:08 +0000
Date:   Fri, 20 May 2022 09:28:07 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Will Deacon <will@kernel.org>
Cc:     Robin Murphy <robin.murphy@arm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        iommu@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] vfio: Remove VFIO_TYPE1_NESTING_IOMMU
Message-ID: <20220520122807.GF1343366@nvidia.com>
References: <0-v1-0093c9b0e345+19-vfio_no_nesting_jgg@nvidia.com>
 <3521de8b-3163-7ff0-a823-5d4ec96a2ae5@arm.com>
 <20220520120032.GB6700@willie-the-truck>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220520120032.GB6700@willie-the-truck>
X-ClientProxiedBy: MN2PR02CA0009.namprd02.prod.outlook.com
 (2603:10b6:208:fc::22) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6741cf5d-2465-4cae-ea1a-08da3a5c328d
X-MS-TrafficTypeDiagnostic: MN2PR12MB4584:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB4584F9B789D19393024A6EDCC2D39@MN2PR12MB4584.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KzssQnVGDvz2BsQiWyUliCzl6S3KuGvxYpfe92GV/xeHZZ76v7BkFD9Ih3WkJt+vlcegWOMAJPVdJX0+8RcThahSs0iKKjsAiaCgbA4fiKL8SFYXeEJjabkGjJ9o4jipPkaJw1QcOG55V2j5EtEmo/61EIGu2ui5Y01+JZtSD4h4RqJ4ijEKGSWeFMnGGbM06ujVzYShoISp8C3BoAklgEQdxb0IVsRcqccOvtQqMS6i35EFVBXdBppWN4tLpHUdkJY+kYbKkymGu/4gmsgQz4yHvD/Ra7YRGRlSM/ASxhDsi0gUum60vNXDuihv3fGI+zea43VwlUsK2NU+O104Fij5U93FnHeFPtL0R6d4lIgd7RHmxfSLo6uvD3oUSmWa/ApCcvzGw0MMHwVEqNg1MebLpLxh2Cbrv5Q4U6rIUtW87yR29Kl+4/+drv3Qg60pJ1cQi/cSEea44Rm4/pnI6S8SFp2f15Jwc4+PFJP5EwjveheSsImSST5ews03xuB0Sp/jNtczkPpcaTfs7WinaM9/OLhfcBC2cJpbQ9xMaHwLVJa7/dSr05s4hQwhom6ueoe61LBzE0p6VOlDOCHOSRpVLHcS1r2AmSyjXv3dNn/YShcekwexG2A3N8QHVPUMcH0yfUwo6+V9MwtMZ11TrA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66946007)(8676002)(66556008)(66476007)(83380400001)(4326008)(38100700002)(33656002)(26005)(6512007)(5660300002)(86362001)(2906002)(6486002)(2616005)(1076003)(36756003)(508600001)(8936002)(316002)(186003)(6506007)(6916009)(54906003)(53546011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZjhKdEt4z1tjclLwYZrvquWToqi8jb5qs06YaERjnnDHGbEOihHrJcjd1KKM?=
 =?us-ascii?Q?U550gJYFUXx8iudASMzqjdW1IonqNgthbXrtU7cG93GKSwhwr2VClHCOuw/Y?=
 =?us-ascii?Q?e07fNA7kFUj7rpJVsopjb2WsOGOZBow0GuY4CJqxRxj2dU0ZcglIyVz5zcbO?=
 =?us-ascii?Q?BM5Bh7iobpmaRmNcvGsjvCxGqN2vLWj1DeKLSqB4VeBs6KOtCcnoGHPQ0vjb?=
 =?us-ascii?Q?LS/3x4nQKxDCOGHMFJUxmflpRGRdZDes6Hw6mlk28EPS8Yv/TRCaFgj/7gFE?=
 =?us-ascii?Q?x7HoFyrrH3j+zxHXpCYr314ZdsWI23U3AgH115ezirxNTm14ZtP9+K9MfAF8?=
 =?us-ascii?Q?p1WByg5e9n1yF449Ar68f76ikiAHyPLYfyb2UFTId0p8z19LzAlGPMMnBGBW?=
 =?us-ascii?Q?B3+fFzi9KFxRJjMPU8mzbL+LZ8E8K13/x6XQ6KSwlw6+0UHq+nNI8KXoIi0t?=
 =?us-ascii?Q?4TW6nTnVuAU7aWerUrHH2Z4wuXs1SG36ozhvYgAXDn23EwmXBI+BXbgzlOZ6?=
 =?us-ascii?Q?srr7QvQQgRSzzsdf1kCmIHdXR5T0gKJYFmLDdYTtN5HKiRxGhFs/7Z+wcu27?=
 =?us-ascii?Q?fFpqRw2D1sioSWcrSEX5jt2+WnGaraLFtTe7zSwAb+LfhkDzGN4Cg1Sajf1l?=
 =?us-ascii?Q?Nb0+9T6r3BXex4qQAFOBZA0dX8xK2NrbqIY1DOZ56UCiHTMRg1l3ADqw5kPJ?=
 =?us-ascii?Q?R+HlwjnXye6F3WvXY+t4jeZtP+TVnfgLmo+aw4q1dFzxiHmaJF0fSn0zKnkX?=
 =?us-ascii?Q?2QfWkEgqCnAwH1VfFunJXFA82aLQEP6HS4kG5VwuEwmWvbln9sJHwTd5qJPP?=
 =?us-ascii?Q?2tHgIfx5UOArHenXsLODCC20ueXVPwlEvTxC7hJizebKeN3pT1h90nfvXWMY?=
 =?us-ascii?Q?l22Q6TsVh6s4oIv+XzGYK7ZNw5u0+M2iAItqLnrfE65WhgpBQya1XdXJkzAn?=
 =?us-ascii?Q?dQEmf7GplXHqQTLucSZfqbE7hoXiy/2pErP5ZDfnekhDNGemD+f0SmQdXvKQ?=
 =?us-ascii?Q?faNDhRx0CuKb2RVgLIwHUAeCN71YSnCJVq2dAqCCXr+ukthITjBmAWlt0n6V?=
 =?us-ascii?Q?e+vTP/2uxANBLfLocwZ3jY7tcEOwhOCUaChRdD/XX1DqFYuWw4lmH1tysIY2?=
 =?us-ascii?Q?UyPwyThl0+hk+x7xFG/crJDDmlrv8/9BCLbqinlq3M/Z3vzELUxf8dCCtbEt?=
 =?us-ascii?Q?dHEZRu7acw6qC6sklMJnjsC9gn8K7VMpp3+1kRnD7wFuqGp2OB5kC2cbpmuc?=
 =?us-ascii?Q?yAFWze/fQc8Qkh3WEq6TVZ3uZMY9Uq4Dm7dK3ctuEGtnFtTXgl4hIUKC/kMv?=
 =?us-ascii?Q?xNk2r14hx6VprgWksBKnfPYUs5INTPCInKy8n7pPtG+XMa9IOi/FEoOqwkxV?=
 =?us-ascii?Q?J+10sR3QnLl7QALYeX3XNM8LftJec6jwOokiF6Ka5JI+Lcbm/r2t4Z+izgMm?=
 =?us-ascii?Q?5KZaOebxYAe7cuXLywUmxZB/voAmx+RfvWlgnbGYxUg2BzD7A7UNsMwTAKiQ?=
 =?us-ascii?Q?t72tUtzne9c6KBxy2qmpqBrnVZ2XrkjdDiYLbK32APJN56UKhMigygyHoFZ0?=
 =?us-ascii?Q?WS5vdZ2CUnqaQGZBCZ1J+hXf2Wbo5GXP9G8LpIcK4Gdk9RPI0t8d5P6V+RlV?=
 =?us-ascii?Q?HPnyL4BBs4hRRmL4bim8izE536pK3Mtyo9hS8PbA8f5Z1rCcGogY8Nn3AxkB?=
 =?us-ascii?Q?j2DqA5K3jAX6zYDBpQjI92QC3UAwnZCjJ00PuZNSCBpT4uzn5tIWc6Zii0TD?=
 =?us-ascii?Q?J3TaJJpSKw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6741cf5d-2465-4cae-ea1a-08da3a5c328d
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2022 12:28:08.7159
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: trmXGprEb2LUPIzaq/K70yERfHfJBU3Nusm8WvNBzo+q7J7Sx+uv/GOqdPRL5BqM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4584
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 20, 2022 at 01:00:32PM +0100, Will Deacon wrote:
> On Fri, May 20, 2022 at 12:02:23PM +0100, Robin Murphy wrote:
> > On 2022-05-10 17:55, Jason Gunthorpe via iommu wrote:
> > > This control causes the ARM SMMU drivers to choose a stage 2
> > > implementation for the IO pagetable (vs the stage 1 usual default),
> > > however this choice has no visible impact to the VFIO user.
> > 
> > Oh, I should have read more carefully... this isn't entirely true. Stage 2
> > has a different permission model from stage 1, so although it's arguably
> > undocumented behaviour, VFIO users that know enough about the underlying
> > system could use this to get write-only mappings if they so wish.
> 
> There's also an impact on combining memory attributes, but it's not hugely
> clear how that impacts userspace via things like VFIO_DMA_CC_IOMMU.

VFIO_DMA_CC_IOMMU has been clarified now to only be about the ability
to reject device requested no-snoop transactions. ie ignore the
NoSnoop bit in PCIe TLPs.

AFAICT SMMU can't implement this currently, and maybe doesn't need to.

VFIO requires the IO page tables be setup for cache coherent operation
for ordinary device DMA otherwises users like DPDK will not work.

It is surprising to hear you say that VFIO_TYPE1_NESTING_IOMMU might
also cause the IO to become non-coherent..

Jason
