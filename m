Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 265FA5B059F
	for <lists+kvm@lfdr.de>; Wed,  7 Sep 2022 15:47:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbiIGNro (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Sep 2022 09:47:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbiIGNrn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Sep 2022 09:47:43 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2058.outbound.protection.outlook.com [40.107.220.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F49AB29;
        Wed,  7 Sep 2022 06:47:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i5TpSIbp7n4FdX03af0ZmzI4ryWc4TMAuZkv3OvL9l05db+cVpGU7AE3tL2J84r/TVILeTiDUjN5J25Uupx/FceUrz31NP+F3CpTMaExT48047NkmjH0lnI0NXB6JeQU6yxa3HODwgeNcvwYhvUUzNimReo5CDtSk364dCr0WZjoe+P5RLuu6Yuo1hdVQtq0UAjXL0FCwbMEhtjRuUGuGvbhr12I6jAjjy/KavShAUlmgCqHpunyxClfmuBnXqG5yHjvdrm5+hmTiLrEStXfLPV4BQ9XH33GStcLYZQP+hOsnnnjLZNlH5X3NRcXGs/bb8n+ZTq4Y/H/jnNYli2rRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YZWsgruCQzrAAiboQObmvUv93DwUbOOZ9VLx2Vr9ey4=;
 b=MouwyBWWvOnBlTWrtdnhhZB21loxIt1GbcX4qiRPmJQhHKyPCCwmrA5OfC65CD/PVw77MBCsRKwp3zZHhgyPqcG7ZmhD0pblOInZ9MLQ32im5SBJLzTwvK2GN5KsqPgNrxLUJGy4IHN791mEP1o+udQGf1bvDoiA/Sh4BKtgzqByVm6/D83xH0nsg4Vo3iBvCpp60f/yfHMtCb8knoj9T9sGtCk4//ugjiWWKOCcwILdl5RKEAeTU5GXSomAkKElb5ptnuw3GQJeoWFLc4Vt82ViGIpf1Ns74bzJszOuHtycwdFNJQ3no3FNHP4LakCulgESbmLL7x6HV0rHm27aJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YZWsgruCQzrAAiboQObmvUv93DwUbOOZ9VLx2Vr9ey4=;
 b=kRFiAR9hNc6FYP82KRGlAD0AcdHfu9fdrlWuiSInIuSzALPTktlPyAboGHtuz4TP8xEaewQuLoPgJwsB/6Rk+qiO5hVmQyltlot0+Twldf1tNYrbK/MQp8dAytI/yFCAAQaKsSXr1s6cP0WSzCRwcEFFim/Ib1iH2X8TfRuUHhEiRnMvwOYZLRvwZENKaKEvvjx5uuvA/+NT6KJvacgu6922Pbf+0UFnV4kKn1wVQyeL3wIBEZ886y+Dm6vRJtj6sDw6sM5XuRVYqbYGRF/nDN01iL5EX5U1oGfcGR4eV7Y5A63jl+gXnq6a4qfpee6zk2yruaaRC0vJBLCGt9Jp7g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by CH0PR12MB5331.namprd12.prod.outlook.com (2603:10b6:610:d6::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.14; Wed, 7 Sep
 2022 13:47:40 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%7]) with mapi id 15.20.5588.018; Wed, 7 Sep 2022
 13:47:40 +0000
Date:   Wed, 7 Sep 2022 10:47:39 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     Nicolin Chen <nicolinc@nvidia.com>, will@kernel.org,
        robin.murphy@arm.com, alex.williamson@redhat.com,
        suravee.suthikulpanit@amd.com, marcan@marcan.st,
        sven@svenpeter.dev, alyssa@rosenzweig.io, robdclark@gmail.com,
        dwmw2@infradead.org, baolu.lu@linux.intel.com,
        mjrosato@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        orsonzhai@gmail.com, baolin.wang@linux.alibaba.com,
        zhang.lyra@gmail.com, thierry.reding@gmail.com, vdumpa@nvidia.com,
        jonathanh@nvidia.com, jean-philippe@linaro.org, cohuck@redhat.com,
        tglx@linutronix.de, shameerali.kolothum.thodi@huawei.com,
        thunder.leizhen@huawei.com, christophe.jaillet@wanadoo.fr,
        yangyingliang@huawei.com, jon@solid-run.com, iommu@lists.linux.dev,
        linux-kernel@vger.kernel.org, asahi@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-tegra@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        kevin.tian@intel.com
Subject: Re: [PATCH v6 1/5] iommu: Return -EMEDIUMTYPE for incompatible
 domain and device/group
Message-ID: <Yxig+zfA2Pr4vk6K@nvidia.com>
References: <20220815181437.28127-1-nicolinc@nvidia.com>
 <20220815181437.28127-2-nicolinc@nvidia.com>
 <YxiRkm7qgQ4k+PIG@8bytes.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YxiRkm7qgQ4k+PIG@8bytes.org>
X-ClientProxiedBy: BL1PR13CA0090.namprd13.prod.outlook.com
 (2603:10b6:208:2b8::35) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 939f968a-b589-4854-2b87-08da90d78847
X-MS-TrafficTypeDiagnostic: CH0PR12MB5331:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NBMQxxKiyzg416DV7jH4U4XBQM+V94ouj2MvUczjBjUVT1dsKyi+I0hmF5qcbRIxWTENbw1sKdDYecITGKwSFyllmjXq8s3BFlqgV9Mm9bouqppxVJjCWees1FD4+4CYQ83PQbMY0ei+Jd5sk3LyQc7pJuEA4DG/TjnF9No51zGOmqXjUID7GE3aYwCzRuXJbo3bEpF1nEWSGBLyiSyKH1o5ptvC/oqtOMc2u9qQl61J1h8MoGmeyQZshLLmv95TkByc/ZaNfUMzVnGHa37yBVk66yFhaTWJj13YkIoEqX6zngVzQxe0tENXHBtDO9GuK4VxiMEU6K/UnZpBZezylCo/QdHq9B6IdXoC7y/ItJkozYGiu8htogeHloMVAAnh0UTwNCFodNfH8O38s2kLlJkbV6Ph5Y6+bb+K6mBRJo0lESCgE5V17raQM8vSCbGu1pzPTWXSp2iHscT3fj+WHdcGX3FEljl54jna4Ia7H9w9EQ7Nh/Hzo+jVaEPonrdKoQxRYGzUuQIjBsJGdTIevJ73n2LpaiSNF1+EHZkzjVsa+0hVQuQ6SUvtIPuRO7K+jqBDTQq1EnrhVMBXLBDEO10D7odmfuAtnHmUEbtJtHFCdiRqF+WqByhcSM6nKNN7ZGT+i+NHT78xhtByWKpoVF2BfDBHtfpQUfcEv+YIpnfVlRuvUtM7ZodXjdLb1okut9XuiiUGckb+am7BGMmTjhE0MWOVrpOGbL0J5FBv5r8gphtoySQGlaVPMfO1AYy0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(396003)(376002)(136003)(39860400002)(366004)(66946007)(478600001)(66556008)(4326008)(8676002)(41300700001)(8936002)(5660300002)(7416002)(7406005)(6486002)(2906002)(26005)(6506007)(6512007)(38100700002)(66476007)(86362001)(186003)(83380400001)(2616005)(316002)(36756003)(6916009)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kJ+P/cwLYf8csGl5q/TUd+eu3EG72FWaZXcxc2KAqanrOU7ITm7jpkCzPtsg?=
 =?us-ascii?Q?NPePokI8I4CbUxFp+Sud/jIwqKRBGR17PCs3S2LrEILS3e0EwrhmqYj5tHrD?=
 =?us-ascii?Q?WNuK0nP4zvPCr5f2Nm4dONUARBTLWoCrIz/6i4c8/J2HcmN0pM/ia/RG2vjU?=
 =?us-ascii?Q?knWJjWf5VkG86kpn8/21VLjTi1B04IjJh/Hl8JjeTljgf5BYOpcyeh21PKG5?=
 =?us-ascii?Q?m82QAAsvuVqBkj0HAKjhpV1Q91RwajirhRCFT/UpjUXUz/9UzhArXplHM2nV?=
 =?us-ascii?Q?LNAmrDEbpfE1yV1S92eH7u1k+JBfU/W5MYJawLPo/z6rrB2VZgpQEksj8nNz?=
 =?us-ascii?Q?vtHaU/JCAG5WVkDH61a/J8QsI7oq75nafVZo1UajV2krOJgF7/PhagDN2xxP?=
 =?us-ascii?Q?GJ23TEzjl3ti4T7xkzUviJvhkAMZYg6Dkg8vQ1ccHzyPKQzGoA5QK8qrMvj4?=
 =?us-ascii?Q?/gsdoJEWfGlCgh8sqanxiffNk7tFMwqrDeBeQpWs0W+es21xAIH8lOvOsSsD?=
 =?us-ascii?Q?fDOUBdvpeLtnsf0cZY+2OwXvlbyHrDkkZZneprYw+0AZAAwOZS/hmW/hKuMh?=
 =?us-ascii?Q?4+N5495W4GXn6N6u4tUgJA2ogfZyzQ8dMIB1VhwTwOJbtFAHXu8TTkrSQGpo?=
 =?us-ascii?Q?snD+vlSstRvz0sAxkq4wANQL1WtaXrPHrorawCzZl/aBNYJMHLaebi4uzBJ6?=
 =?us-ascii?Q?EqYkVUcIhsHV6YT+AM6dztCClTU46n2DpmMe8f3ugYUiJx93FygnaU710w/H?=
 =?us-ascii?Q?3wIbE1AhFKqFNDuYEH5v5dph6rCPkPHSB58Vr1aW2Q+3pb+eU4TmWb3OhjtA?=
 =?us-ascii?Q?53UDKg5ytmvozbp+BZ8UvregbxldzksAoFmMgu/NPpb4+DSTwTESvpxnVfWW?=
 =?us-ascii?Q?HutRV0+wMM/yNTiJFnUNfslHFnqTcJVPYslBhLVQKOEtd8+TTx8qyoLJvYzA?=
 =?us-ascii?Q?Ettme2uGEyM3hlWcMeJH55XQfYKaPqJ4jI0ynZkBIJ9pY13fuibADrGp9q+S?=
 =?us-ascii?Q?e5YU1Rq/zdSJ+ZZEbaQnLux9nY8bgL1xcwdpHe3r4T5LF61yFQwxefLKHuPg?=
 =?us-ascii?Q?aMBMA6puaP/+A5ur7ktIjoaSKO6HqqnM6MOPJCXwvqELm8u1FuGZgo6ZIiNq?=
 =?us-ascii?Q?CV0vl1XxCtaLY1HQgPXECzoIf6XAWW85CRBErbGf3MgUlpJpQixAcCrvOVx4?=
 =?us-ascii?Q?6zy4ZzDYHHUcWwm021+N4jgfTIwmzdOWixfy5w+A1b8IpEN1zZeOCe5FqfOB?=
 =?us-ascii?Q?zkhstKTFFol+n84bl2A0L10ry8KOsuewlS7aV6NRuJWoaCC05xQqPslCLwvF?=
 =?us-ascii?Q?IIo3ggYzCWrDyKeUYWQjBAniaf0zlv9f7elcyVDOcLIftDyKYzn9M0EZP9DA?=
 =?us-ascii?Q?TVtcKUohRXg9KFVTnPdADVia0mj8ws9QcwS69/PYPisxfL/vbiGVoZKSTlZU?=
 =?us-ascii?Q?ni0/5kjRuLxZqEnOrDNcX8Km64asXb76MmhJ/imC0yz7lFa6pJCpEu7ZtDTC?=
 =?us-ascii?Q?czk8UAo9F6tmae7rB5W6GKpYAxNpl08SozmrZ57UBR2hM15oaqlFhLGEkFwW?=
 =?us-ascii?Q?Xs4d7HjDz/zZvk9Z/eQ5qVnyxhqHzS036xD0EYOa?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 939f968a-b589-4854-2b87-08da90d78847
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2022 13:47:40.6486
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7DUF73AG/Y9P/XHw0GSfrLdc6rBLfLjx7MHZG3jgPm+iMkLqZCKhzu4g78TPUNym
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5331
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 07, 2022 at 02:41:54PM +0200, Joerg Roedel wrote:
> On Mon, Aug 15, 2022 at 11:14:33AM -0700, Nicolin Chen wrote:
> > Provide a dedicated errno from the IOMMU driver during attach that the
> > reason attached failed is because of domain incompatability. EMEDIUMTYPE
> > is chosen because it is never used within the iommu subsystem today and
> > evokes a sense that the 'medium' aka the domain is incompatible.
> 
> I am not a fan of re-using EMEDIUMTYPE or any other special value. What
> is needed here in EINVAL, but with a way to tell the caller which of the
> function parameters is actually invalid.

Using errnos to indicate the nature of failure is a well established
unix practice, it is why we have hundreds of error codes and don't
just return -EINVAL for everything.

What don't you like about it?

Would you be happier if we wrote it like

 #define IOMMU_EINCOMPATIBLE_DEVICE xx

Which tells "which of the function parameters is actually invalid" ?

> For that I prefer adding an additional pointer parameter to the attach
> functions in which the reason for the failure can be communicated up the
> chain.

That sounds like OS/2 :\

Jason
