Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6954A7157EB
	for <lists+kvm@lfdr.de>; Tue, 30 May 2023 10:06:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbjE3IGL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 May 2023 04:06:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229939AbjE3IGI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 May 2023 04:06:08 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07213A0;
        Tue, 30 May 2023 01:06:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VXWRF4F74MYeoDJgbZIYAF9AuV/+FAAdRKhXwc6kVw6Uh7kWwnlHXX7sIKuuJFwdgEbW8u4qHlJJmgmMJZ1wNz728J33LoBxZnVNNhN3YZ58601RMKeLKGWDtpM6E/ZUmYzJBZ41X+Eg1vRsPH3viP0QP9bO96NrUMBS4CeiUxywqft+jYmajXtSvOE+yKktiCrPq2Mug2kV0uDkDUPY7Rp4epPxq6BbKYeIO2eyfrR9xySJ6DYPfwx0hYi+IQOOdHZBrIPdRlXAIyOdBRy6gae0hphv5I5uYyhqkMk0SqHoHOcNmlbMXelKObUuYhrTROs6zBqIow6aWYtUDcP3ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Cu/cZyGIdTR2QkqayNlX5O32vheKkYfreRb0eOZgwWE=;
 b=Djg3freXlOVdG9foPbnvSaeM70/EUnOsedG/cwrhvRnFTZeKN4uaNTSAsAXIW3nRTTtNKlBNbKvqMe4duUl4WyNNVSprLSPuEFL6m0cd1RD7SX+AKOIJzM4tXcZDZD//j3jKG0mMwB+otlL7VV4Za39o2r2n5iiwFm1yNKkK3Uuh5dzNIWLoJ/pb5DwSy8/InuULJ0nKTt5jZduhtJnXNj+OJeVoYUrnD3JGjouI0pRm8k+CL7aMneXEn/bm6kIb31h3VkwAm6PvsTpkA7TPFsv0nGBPG8q3LQWJqMHz2hPY+9qfoDvNNTcG/OrFOBmJ+FuxOu8vD0eIFDzyyLisJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cu/cZyGIdTR2QkqayNlX5O32vheKkYfreRb0eOZgwWE=;
 b=gaMYh1ms0Xz8PJvUtJHyURoCZx412/e2rp1tv6ungiku04Kvmg/Cp7N+rb9SS3e6jLbJmgOcEmYXCl86k5jvfJtWvneoeozB+PH02WCTszSSGO44iKtSQ7Ssm/Yh2XKVnuhT8oORyKtyX92mnPBn6Tc1/fp1ll8zk5eMg8XZ83BzWKJIvrpR+VP7JpsQWYV3V0vb31dGrIuMmYZLoWPkhVizaXGQpo4IVEcKyBClsmuOeibKFHK96S/5S3EE9qITBrVGs9CtM9fRJPJQCN+SslUT849A2bHlO8U9hzCI2AndLXenTsPYRqONrMthU71IZVTAdZLzRop1566Fw7x/Qg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB3176.namprd12.prod.outlook.com (2603:10b6:a03:134::26)
 by LV2PR12MB5895.namprd12.prod.outlook.com (2603:10b6:408:173::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Tue, 30 May
 2023 08:06:02 +0000
Received: from BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::f6e4:71a5:4998:e6b2]) by BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::f6e4:71a5:4998:e6b2%5]) with mapi id 15.20.6433.022; Tue, 30 May 2023
 08:06:02 +0000
References: <3cece716fc09724793aa832e755abfc9d70a8bb3.1684892404.git-series.apopple@nvidia.com>
 <5d8e1f752051173d2d1b5c3e14b54eb3506ed3ef.1684892404.git-series.apopple@nvidia.com>
 <ZHKaBQt8623s9+VK@nvidia.com>
User-agent: mu4e 1.8.10; emacs 28.2
From:   Alistair Popple <apopple@nvidia.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>, will@kernel.org,
        catalin.marinas@arm.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, robin.murphy@arm.com,
        nicolinc@nvidia.com, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, John Hubbard <jhubbard@nvidia.com>,
        zhi.wang.linux@gmail.com, Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH 2/2] arm64: Notify on pte permission upgrades
Date:   Tue, 30 May 2023 18:05:41 +1000
In-reply-to: <ZHKaBQt8623s9+VK@nvidia.com>
Message-ID: <87pm6ii6qi.fsf@nvidia.com>
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0366.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1::11) To BYAPR12MB3176.namprd12.prod.outlook.com
 (2603:10b6:a03:134::26)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB3176:EE_|LV2PR12MB5895:EE_
X-MS-Office365-Filtering-Correlation-Id: 551db2a2-8667-4009-e606-08db60e4b547
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FlZoAslYsD1AL+7YjTITuiS1pATnHlhE4AJTCkG8LT6DP8grYdBFvSUfEymreexwXKC23lb3BIf7Wsb/ghRwF0IIYL1EjIVHTlHtZxUheH6UxSlD/xhE8z//5DgdFZAJGc/S3jAIeM0/iUqvCR6xx0K84OI+M+rIubzRXSh0dR7LFq4YmuAFWmzBIa/vWDTlP6YglXgT/i7Brdnwklp8dHyWSAYTmc0F89sQM6oJ8sTNFpXzixHVS35qTqDMt3iPakUUuP0Xkl4iDZ88mv6SI5kkXSlIu8sbGT1ybbWBnx4zDY2IYxMrqfCxnyWw/HejnwZ484sQ6LYqAcXeReS7FU49L4QwNzaxpELGEWETSW8UbBPvQSnruq/Jz7X15zw0r2RkxgZAV9uZSIPR4bwdR2PM5aleZVLspRPTvkQa0INag+NTO81MAKqysfHfd2RddlX6EXuvMa9FOEp7BY1zyQb/a1ljwjN82SGnZWkdYZ66KyrNygeP8xhmZnrGxDdJj+2UcDPSOXhV1DHqI3T8UlsaGYagTbi+jTWBk5H8C66gIi/3naxo3yOQU17cS1IP51jNumH+UBewSqeY1s8Op03AxfW8ukT5IkJ4zhBqzf8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3176.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(366004)(346002)(136003)(396003)(376002)(451199021)(38100700002)(41300700001)(316002)(6666004)(6512007)(6636002)(4326008)(86362001)(8936002)(2906002)(8676002)(6862004)(6486002)(7416002)(66946007)(2616005)(66556008)(36756003)(66476007)(54906003)(37006003)(6506007)(26005)(83380400001)(966005)(478600001)(5660300002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5CHNArRb6WOrjeo3LhdHi+dmpmspmm9AwyflH+61qVoQsVfwINOB/6lYi7PX?=
 =?us-ascii?Q?qmqzRyx+JNLsVD9UXc64Lsr5hie0+PpPNUD5iSD6ioecRw6YxzfKsY/tS2Bw?=
 =?us-ascii?Q?cdCZnjHXjlTd8otPcX12/EX55FGtajNNWtTyhX95XWsYJp57syPXXZ9za81v?=
 =?us-ascii?Q?kwpa3w8Eg8dFG+wovzdevwLk5rFTrPQb8IoPyY6gZwDBpzhtM1cZdNloEg/8?=
 =?us-ascii?Q?GlO1nLmaD8JPPypRIdKx/eL8njY1J38nMqJqyfQ2WAfGuHaiTOSKb0uaimF7?=
 =?us-ascii?Q?fcXhqGHZ5EIHXFfiDPsVkRrdqur9d/CWS3c9c34ujstzhrv2Evt84jnyPlRV?=
 =?us-ascii?Q?ME3Bppmc5HFnrGSG2Edro9YFhB+u63702i7jEBfaEK7LT2LdZWtpGsYWMLXi?=
 =?us-ascii?Q?tZ5/VzLsdDpIW67aKeEQ5BEE0J/mdh12X9HIFV3k88bdYzUUqu6JaJMJw3D0?=
 =?us-ascii?Q?9nNnF5RyfY2Z/ZUYoxbghu0LWsRsAHlyDbq195NzROD6SmPLx7ZKwu3Yudak?=
 =?us-ascii?Q?tDqbiQH8Q51qyXLxVZq4tM6Bw5gptTBI1r//Z+nh00Bh9W8ar2r2xVHMOYXF?=
 =?us-ascii?Q?X255aM8bwcrlQWeJXGwjDBkNMTIN1L37NHZK6XVuBmqQB2EE+o2gc8TaCCR0?=
 =?us-ascii?Q?CMiCzQKfK8kMnsmUUdxxj88sFykQ+vbGrEZ69HwmwsC1NeoqMRKWbL5M95GP?=
 =?us-ascii?Q?ruIvNSYhgu+JMoXAKAln6qpuVT32GMj5zTEFOKmr/OCrIdHBRXudFnQPkuT/?=
 =?us-ascii?Q?t0WxWZWIzcgEOV/g9jBGf+8y0/WMKdh85pkHMAfjzAIArrUv+LTcBQL9pe+h?=
 =?us-ascii?Q?6/c9JqQaxFAyFnjT+oVOH+/nRhex3fyZ4iNftMWl13HVNYaJKZN8u1MPEwmb?=
 =?us-ascii?Q?QszQ1ZleF56FqBhIBwxFVplkyUqqd4nrI5KSGXvk3XpbiImgRZmiAj2YW2S8?=
 =?us-ascii?Q?DNo41QZbViiH+w6mCmaMUowiGjVWP5E3/zdeXroq7NCJk/0bT7LIrqD+R0yx?=
 =?us-ascii?Q?xFy0LqF64wz3+aTqxJ/J1JIE+UM/tox3JOJ4vnrD0pkKYwzj7BVd5f6wA01P?=
 =?us-ascii?Q?x+qit2C/Mj8FnUCXoRU/pT3eeUmuCeV6sTRFRRxsNEMvIXxtK/bg7WzH2tWE?=
 =?us-ascii?Q?rO5vvCvweC5Z/uUYuoCJdWpTW3o9sRL1kipvzwgFE4SEYfMYYMhFOy2uGt8L?=
 =?us-ascii?Q?Av53WW9iB6UAX78SD6LQcc2i0rH9puK2K0ixPTp8jMp4HgxuVEkYfoAh39Sb?=
 =?us-ascii?Q?R+TCrNpYsyyvFBxmNmtUBits+ycbNZNQ81nCeFm22D6Wgc/Ndq6SArGsWzxz?=
 =?us-ascii?Q?i4LSEOcyPMwLTgLRs7TQlLKUH9b6q3ooxnNlCk4JcvGd2ZktJ6Syrr9otQup?=
 =?us-ascii?Q?jOVuLXcsPfnfonRUngv6bwk9A6fzTPwyHUgRv6coILKtX2wDYvL0IQ7MA2Ni?=
 =?us-ascii?Q?FnXPks49pfuOa3B52juEYwxdjAsKZof5CFbQpeS43TS9Awtd5wcqbG2qNr8s?=
 =?us-ascii?Q?HOMkA4c8b18gdJwdsVpJ79XpNZKbolaLrpgAM4pveCuVrIbtOJb3VHi/q7rd?=
 =?us-ascii?Q?sPXGGA7P+CJu9WD8aJmFpAugwuu8ZaN8B6fD20I5?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 551db2a2-8667-4009-e606-08db60e4b547
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3176.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2023 08:06:01.5595
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Tlm3XGR36qREhRvMGxV3pur+5KPLmbiKbnHaxz/drtxHnUDqh3GyrFPVFY3crRsYqHfoCIQ9AEOeO0b6bboMPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5895
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Jason Gunthorpe <jgg@nvidia.com> writes:

> On Wed, May 24, 2023 at 11:47:29AM +1000, Alistair Popple wrote:
>> ARM64 requires TLB invalidates when upgrading pte permission from
>> read-only to read-write. However mmu_notifiers assume upgrades do not
>> need notifications and none are sent. This causes problems when a
>> secondary TLB such as implemented by an ARM SMMU doesn't support
>> broadcast TLB maintenance (BTM) and caches a read-only PTE.
>
> I don't really like this design, but I see how you get here..

Not going to argue with that, I don't love it either but it seemed like
the most straight forward approach.

> mmu notifiers behavior should not be tied to the architecture, they
> are supposed to be generic reflections of what the MM is doing so that
> they can be hooked into by general purpose drivers.

Interesting. I've always assumed mmu notifiers were primarly about
keeping cache invalidations in sync with what the MM is doing. This is
based on the fact that you can't use mmu notifiers to establish mappings
and we instead have this rather complex dance with hmm_range_fault() to
establish a mapping.

My initial version [1] effectivly did add a generic event. Admittedly it
was somewhat incomplete, because I didn't hook up the new mmu notifier
event type to every user that could possibliy ignore it (eg. KVM). But
that was part of the problem - it was hard to figure out which mmu
notifier users can safely ignore it versus ones that can't, and that may
depend on what architecture it's running on. Hence why I hooked it up to
ptep_set_access_flags, because you get arch specific filtering as
required.

Perhaps the better option is to introduce a new mmu notifier op and let
drivers opt-in?

> If you want to hardwire invalidate_range to be only for SVA cases that
> actually share the page table itself and rely on some arch-defined
> invalidation, then we should give the op a much better name and
> discourage anyone else from abusing the new ops variable behavior.

Well that's the only use case I currently care about because we have hit
this issue, so for now at least I'd much rather a straight forward fix
we can backport.

The problem is an invalidation isn't well defined. If we are to make
this architecture independent then we need to be sending an invalidation
for any PTE state change
(ie. clean/dirty/writeable/read-only/present/not-present/etc) which we
don't do currently.

>> As no notification is sent and the SMMU does not snoop TLB invalidates
>> it will continue to return read-only entries to a device even though
>> the CPU page table contains a writable entry. This leads to a
>> continually faulting device and no way of handling the fault.
>
> Doesn't the fault generate a PRI/etc? If we get a PRI maybe we should
> just have the iommu driver push an iotlb invalidation command before
> it acks it? PRI is already really slow so I'm not sure a pipelined
> invalidation is going to be a problem? Does the SMMU architecture
> permit negative caching which would suggest we need it anyhow?

Yes, SMMU architecture (which matches the ARM architecture in regards to
TLB maintenance requirements) permits negative caching of some mapping
attributes including the read-only attribute. Hence without the flushing
we fault continuously.

> Jason

[1] - https://lore.kernel.org/linux-mm/ZGxg+I8FWz3YqBMk@infradead.org/T/
