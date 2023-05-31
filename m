Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10FEA71865C
	for <lists+kvm@lfdr.de>; Wed, 31 May 2023 17:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234703AbjEaPaK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 May 2023 11:30:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234584AbjEaPaG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 May 2023 11:30:06 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2082.outbound.protection.outlook.com [40.107.92.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 054F9124;
        Wed, 31 May 2023 08:30:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T2m+FThx8c9UB3m9mgwf30ny3NZbwwe9+g+cDc3Lk40rEAhhvThLvj0YLmmcU9IJrkYzAwryiG3UAaBi0A61FpceSoo+yGFCf2QwcPAgMNilFvYFvSdriwX9aNYbrtszW41je23Pa9SKq/kiFEWBCmJX41uu2sO3NvEbSZyR7FpXpsMV+5zEkY1zmvL1aMl3zR1OI0yyhGuMP+EgzZwmOXCeLCWE1/QDw+/eyVTK3iR2egnGzdSFgQ9Iqo2IK5+9wdYzYhyGikdEm/fbIEFG9k67ZhPMWzAgkFUlpaUDywOPCAxTrxu7Cp9ndb2JQ83XMaVZiPKH2q+9PYKAkg8y1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=isLmgFvPfV7+8493UMURfK456zJcxiY+pt55Rrh7DWE=;
 b=ODQafFiP4G/1ZiXoNZhUEfTcwIft71h9wOVvMCe5x+6EBpxyWr9GfJW0IP6xTGKo4b3MwzHTIYGdQ4cZJeJ+4Emaipzgoxt53fAp1m5kZ6RlHvRSS8Jxq/qC72y6z6P4ellyjnUy10CBbPcZWmSrwS2y15R6hioqVeUgrgSspm/LuQMYuJl26Ab3t563ibioFwmUlndRzH226a0x1hK+U35UjxoNMkP0g5piSTbvN1Q7S6mG12ThBNN55KqFz+W7WSVTWDydYV7FAzYHS7jbbDulvZYdrLxoF3rFu6FHa/w7gqvz5rJkS8XM6JlRokktw22pR6NHlypbImMG311eGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=isLmgFvPfV7+8493UMURfK456zJcxiY+pt55Rrh7DWE=;
 b=Z0RyLdfVvBShncPfHVwa1BJYdbAOONAHJWIUrV31DgHq6OcscrfXiSKdQoyPL5zSde4jl7gkCbu4e8U2Ku3GORe4a3dyJ4vROuCSUS/a6drdNgqDxKKiNyGLdsJTGkQGonC/GCoW6gcu3zt6+ku1OSHwec/Tp6UkLg3Ckidj88vvVLhht+9ROwpEdpQ9/M5wqTb3tfY9zyPxHgMsvs5ZwUHp/w2clcsOyjspxqJixY3YVSB3gIunVaxybMtrUBLhMxav3uF6ZPSeN719GbHwUlm/XVVXMQg3C4uA8IwTfdzmDDMO1Hf1AUIBuPBNaCXYoA7wQZK4vFwLlm5FXgsi8g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH0PR12MB7488.namprd12.prod.outlook.com (2603:10b6:510:1e9::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.22; Wed, 31 May
 2023 15:30:02 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%6]) with mapi id 15.20.6433.024; Wed, 31 May 2023
 15:30:02 +0000
Date:   Wed, 31 May 2023 12:30:00 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alistair Popple <apopple@nvidia.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>, will@kernel.org,
        catalin.marinas@arm.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, nicolinc@nvidia.com,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        John Hubbard <jhubbard@nvidia.com>, zhi.wang.linux@gmail.com
Subject: Re: [PATCH 2/2] arm64: Notify on pte permission upgrades
Message-ID: <ZHdn+FsH6BWcK7C4@nvidia.com>
References: <ZHXj/6Bjraxqk4YR@nvidia.com>
 <d2e591c1-eb43-377b-d396-8335f77acef6@arm.com>
 <ZHXxkUe4IZXUc1PV@nvidia.com>
 <89dba89c-cb49-f917-31e4-3eafd484f4b2@arm.com>
 <ZHYCygONW53/Byp3@nvidia.com>
 <ZHZuSDp6ioPqI272@google.com>
 <ZHaCAJI+OgIfDWSx@nvidia.com>
 <87v8g9qr2z.fsf@nvidia.com>
 <ZHaVsa3oXfXqE1Pu@nvidia.com>
 <87ilc9qkuc.fsf@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ilc9qkuc.fsf@nvidia.com>
X-ClientProxiedBy: CH2PR19CA0029.namprd19.prod.outlook.com
 (2603:10b6:610:4d::39) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH0PR12MB7488:EE_
X-MS-Office365-Filtering-Correlation-Id: 8b52fea3-5f01-455e-568c-08db61ebe703
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: piMNs0f1oTMUUKGIAG7/1LoMyi2CyaV13ZI32jG74f4Y3odqQcCBx4R47nvSA+wsKgYxZYXbS+QBps8+VwlBUc2duUBt/3m/DAGLRYHsZ0Vo3ivCUDcL0a9axeLx2XKpsJqQxaSeB03lsl99V13DXjKI8x17b26Um3cujVAM/PQBnkYxlXjKW92C4eU2xY47TcNdE/EyHnObW1Mg3vke0hdHvdinlKprIq8KgNa909Lyl1fSjNoVP19ycqaVLL3nCCcF95V6LHnRTYAyo/og0/KLcV+qajP6O6S9+zK6HyiKAq10sfvYp8VcWcLh7ehDBKiI66Mry3PeacVZCgQn8yoLvaM+QdIkoTpxH/fsFWkAMWS+9hS5Hpur1mx2jbuT8AEutknAOHGd+TZJihsc6LSOFTCg8SP6+mrBtXCE3l522T0jGmzJJgp1EPOGMk5V/sl33bIz1nN/kIr5Mk+PVLuNHum4i9su6ff6klqlkQFi1ybaZaafl33EF3oSD64PhxF1vaLsK/L09l/PLPI2f2SLP/f0NO4VOduUsVrODuSy9AqDhCVOY09icXtZpivVEOSth55715SjyNqOhKVoH9BwQjkuFskrRGZZ55P7XPw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(39860400002)(376002)(366004)(136003)(346002)(451199021)(2616005)(83380400001)(186003)(2906002)(6636002)(4326008)(66476007)(66946007)(6486002)(66556008)(316002)(37006003)(478600001)(54906003)(7416002)(26005)(6506007)(6512007)(5660300002)(41300700001)(8936002)(8676002)(6862004)(38100700002)(36756003)(86362001)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?w+50XuAFlDY02Cp56ER3pnFOr8paMUfiWvyTB8cQAzyeL1iHu3baUbplIHqU?=
 =?us-ascii?Q?FnZuhXjp/uCp1R3vtdjp1knUsfxJp89wLQCQdEFGBU1dnvqGDBgxEIh0DXR6?=
 =?us-ascii?Q?z3Yg0Yu7X6e6W23XxWWUB7ezsQcX5GmHlansLjwLwLogzVGqmbE/20ClcmON?=
 =?us-ascii?Q?HdMDFTjKbGCmNSv7IOmDpwSDjMBdapJgOxJW6KIOVj56ZnAgRq0Mk+1uaB7o?=
 =?us-ascii?Q?xf8qNLhC0ZFr+HWxLhVVSvmHnP3jcsxtmRAkxi/kIVXmKwCEt1jjG5U5XtC5?=
 =?us-ascii?Q?OJzjMsDXqDq0qI1nh72OKjzwnDgt0m2/UrGaYGerXD9K0BJegij/Tm6T4cKT?=
 =?us-ascii?Q?diVZE0ChMU75VfFcjhU8/c2cuwM7XIKwKCZAqxmA8jxU6V1I4x+V+M3oRxwI?=
 =?us-ascii?Q?J92qLv/SEnib2HLV9tIwnQGDH9Vx51SSfSVdFIkHk+oUmVgNbs/IUncw7TuC?=
 =?us-ascii?Q?6fab2NaxTcM0U12ffSchxrBttUY9Nf5p0JjtF91YUIp73gjmJ88Quze6/TSL?=
 =?us-ascii?Q?SFyqXUpQCfQYX0Jm4TzeXXdvRvvcq9YDAZ4/MAjfJvdpRvunIAr25llNgMCE?=
 =?us-ascii?Q?f4yCYtkmv5UF0CN9CuIz8Kt78BomhDp3RIteMPx/ny55g/C9E8ulhP9bUg6q?=
 =?us-ascii?Q?LnrMTTTMtqzA+QQux2Neyoi4tfTdQQXcS1EAch3Baa4RdzKcNR1dmCLvqhGK?=
 =?us-ascii?Q?IDCicFBHn+XWNUGJc3qGu5nlahx8Yt/2NAWlnGMogKjO+twYjwxBjLQYRz2g?=
 =?us-ascii?Q?eI4MmyOSTZ9UB0xrl2kv+TWPM7XIZOMo6+shIKxJYHwaSL5axSZjc84GXVA2?=
 =?us-ascii?Q?+acFx01wV4CU5vtmO+2DRpa4yamhs4tAOTJsW3c0z4kG3xfFFe+t/ZiB30u2?=
 =?us-ascii?Q?9IkECE26qKCpqMctk9dCwM9dquPGuo5IFauQmHRFkURHRZL3dN+Wqwjp2d2k?=
 =?us-ascii?Q?vACEoXe8eGiVdC7X63YxjU2iKiRx8XN8c1NggmMjtV80CUzaCNinxPSIK+0o?=
 =?us-ascii?Q?ixrltu2hab1CyXBCfTqyHcLWlCBczw6Be2m8YTZ5sRlQLmvvSQ9QKbN3Hc9l?=
 =?us-ascii?Q?vu+A3IJxiulMOku6qR4AtBfXG4b1AIRHS53o8DG8sfnj0Ukpm6Lfts3LqVP0?=
 =?us-ascii?Q?MHrbdXD0lFKbXlpSExEri8wGMuK3s64G4tECRdYPG17u0AJsMwlW0uS/OMfh?=
 =?us-ascii?Q?Jxp+vL7kdD5Cf2cNbUSm/YGqr+QethpIlE2ZqPc7etMbGIO1yqYXs5as/D/J?=
 =?us-ascii?Q?JivAE6Spv0alGSQypft492+Gfe4wvkezWbD2ehJtl53MY5fn1ThQC8f/GAg5?=
 =?us-ascii?Q?06Ieru71b1qmcXjRttWNO1vnw8SdpQLxop2UYf14wHzTlxRWrMh42VqHoX68?=
 =?us-ascii?Q?bcuRfIrclXmJoz1aqvhHKeL2PSJsUhbkYqyfFjejT/j42QN6Bmx11ifvSVUm?=
 =?us-ascii?Q?SwuLJ2VzyLg56VXzGKvTJeewE1f9icRmNXgH8jYOPcDie1wE2vwFpFF8WF4s?=
 =?us-ascii?Q?9DmTrOwSAlDCyk9vDpAz4Fj3KiI7Vwu6jK7nFBsVSIpOs71TJV3VM5Mhg67i?=
 =?us-ascii?Q?rUGFbffkqRNyO4hqnhITR5CueWx9RztKdsvdMzsM?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b52fea3-5f01-455e-568c-08db61ebe703
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2023 15:30:02.5623
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: twz4hvVHZA4zj9cgZvKZXzHI4i4tCIenswQlnglcE9H6uDzkBo84l85UCeCu6Phl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7488
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

On Wed, May 31, 2023 at 12:46:06PM +1000, Alistair Popple wrote:
> 
> Jason Gunthorpe <jgg@nvidia.com> writes:
> 
> > On Wed, May 31, 2023 at 10:30:48AM +1000, Alistair Popple wrote:
> >
> >> So I'd rather keep the invalidate in ptep_set_access_flags(). Would
> >> renaming invalidate_range() to invalidate_arch_secondary_tlb() along
> >> with clearing up the documentation make that more acceptable, at least
> >> in the short term?
> >
> > Then we need to go through removing kvm first I think.
> 
> Why? I don't think we need to hold up a fix for something that is an
> issue today so we can rework a fix for an unrelated problem. 

I'm nervous about affecting KVM's weird usage if we go in and start
making changes. Getting rid of it first is much safer

> > Yeah, I think I would call it invalidate_arch_secondary_tlb() and
> > document it as being an arch specific set of invalidations that match
> > the architected TLB maintenance requrements. And maybe we can check it
> > more carefully to make it be called in less places. Like I'm not sure
> > it is right to call it from invalidate_range_end under this new
> > definition..
> 
> I will look at this in more depth, but this comment reminded me there is
> already an issue with calling .invalidate_range() from
> invalidate_range_end(). We have seen slow downs when unmapping unused
> ranges because unmap_vmas() will call .invalidate_range() via
> .invalidate_range_end() flooding the SMMU with invalidates even though
> zap_pte_range() skipped it because the PTEs were pte_none.

Yes, if the new API is specifically about synchronizing an architected
TLB then really the call to the op should be done near the
architectures TLB flush points, and not higher in the MM.

ie any flush of the CPU tlb should mirror 1:1 to a flush of the IOMMU
TLB, no broadinging or narrowing.

It is a very clean defintion and we can leap directly to it once we
get kvm out of the way.

Jason
