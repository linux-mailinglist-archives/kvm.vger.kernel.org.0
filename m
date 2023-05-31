Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33F767173DE
	for <lists+kvm@lfdr.de>; Wed, 31 May 2023 04:46:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234018AbjEaCq3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 May 2023 22:46:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231417AbjEaCq1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 May 2023 22:46:27 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2060.outbound.protection.outlook.com [40.107.94.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AD80C9;
        Tue, 30 May 2023 19:46:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dwqeOzpFU6toXcDU7LHc6EU49u1DvXpvmYDmCLKlQ7mfxEYG5auim9NelUbaqMdrOZLQpInD75N9pt5H8ufHF1falhNnGmKz00bZn9Q3LDmNxf06jB5f08PjRuc+Bp0t2VXTFqX3awgM25G+7nsPvLLN+9MI5ZjaKJkYJZTBM+cSYAZvdrODDVj4HsvE0+c8g0OJCVOL2JutK/nph2fbFlf2e2PnYx5QAMXRjslTmXhd9Be1HdbEF2gSPI/OxDOCkFYbvpsAWrczC4iZZw6l3dqy7t21Reff1ygYfXv+Fym67U/gRGuvOFT87AtpJuc4aM1Wj8E5kmNz/DAUJ3goZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E05DdwudcC5FVe/0kaWO3L5NadkeK89rondzpdE2K4Y=;
 b=NVH6PvUBSZezSshxWu5psq2lirpF8QlmU98Hiil2L44CAsX6wPWOkTFYC6pESoKx7v1/LJEbTnoHRZSb7QFhk9u6edpsO9pxyIETUlJgnpgBn4RNMl7jN2lfKjmsfCJ3PFjKTBasRplLhtH1rfMAscozm8mp4fbmuvJzYMZyOwS1OHt6J+QhxWGq/H71aKLcHCyGECDwbeUyy3HmuNE7c4GZQOXJQ1fS68tO9NpilF9ZMFC0zR2rMwLzR8heyft9NJeEfMxg4Nm3FAWOYVC+Uy9eMos5R9/1SWAiIw8eLpQ3NldnpOeklGqzik8avsmv79zuXxujl2JGADYDsKCVGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E05DdwudcC5FVe/0kaWO3L5NadkeK89rondzpdE2K4Y=;
 b=Xt6jVLddbDnp9iUuH4nktN8puB/WoPmC42z+/7Cmsd6JzKGzbC/t2By5/ZBg/0TJdxzU8/xQU+PC+3aOtzRcHmwEz+VTp+2u0890aDwvcD4lMN72jyjABSCH49B+dEOkDqGH7FNEmTUwZ5RBgraGlX+5ESYJ0J5KXWlj2n3j433+GyUBH7HIqr6cjmU36m8IErcQy9iJurLT0h1OLNf2u0u2qp9GTUD2uj+eBOetgxZIxU9tGoI02miarsHIhWHfh80D5CFqcp4720IX6YnMZbQwCUxDnfXukU/weey19X3J26uCMXIwe7ALZXIJUIdpkHbqhfS0NbdHiLWOZbRMag==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB3176.namprd12.prod.outlook.com (2603:10b6:a03:134::26)
 by MN2PR12MB4455.namprd12.prod.outlook.com (2603:10b6:208:265::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Wed, 31 May
 2023 02:46:22 +0000
Received: from BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::f6e4:71a5:4998:e6b2]) by BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::f6e4:71a5:4998:e6b2%5]) with mapi id 15.20.6433.022; Wed, 31 May 2023
 02:46:22 +0000
References: <ZHKaBQt8623s9+VK@nvidia.com> <87pm6ii6qi.fsf@nvidia.com>
 <ZHXj/6Bjraxqk4YR@nvidia.com>
 <d2e591c1-eb43-377b-d396-8335f77acef6@arm.com>
 <ZHXxkUe4IZXUc1PV@nvidia.com>
 <89dba89c-cb49-f917-31e4-3eafd484f4b2@arm.com>
 <ZHYCygONW53/Byp3@nvidia.com> <ZHZuSDp6ioPqI272@google.com>
 <ZHaCAJI+OgIfDWSx@nvidia.com> <87v8g9qr2z.fsf@nvidia.com>
 <ZHaVsa3oXfXqE1Pu@nvidia.com>
User-agent: mu4e 1.8.10; emacs 28.2
From:   Alistair Popple <apopple@nvidia.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>, will@kernel.org,
        catalin.marinas@arm.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, nicolinc@nvidia.com,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        John Hubbard <jhubbard@nvidia.com>, zhi.wang.linux@gmail.com
Subject: Re: [PATCH 2/2] arm64: Notify on pte permission upgrades
Date:   Wed, 31 May 2023 12:46:06 +1000
In-reply-to: <ZHaVsa3oXfXqE1Pu@nvidia.com>
Message-ID: <87ilc9qkuc.fsf@nvidia.com>
Content-Type: text/plain
X-ClientProxiedBy: BYAPR04CA0009.namprd04.prod.outlook.com
 (2603:10b6:a03:40::22) To BYAPR12MB3176.namprd12.prod.outlook.com
 (2603:10b6:a03:134::26)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB3176:EE_|MN2PR12MB4455:EE_
X-MS-Office365-Filtering-Correlation-Id: 815727ef-1043-42ac-c434-08db61813815
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: i+xoWaR3fKM1FCQteBQO2CzgVCVeOgyFFSCnS62eK9uxyeskIziK7XoYnlTeMwhWPrA8i/IMUzbgabTtOo8qGNYWZaAE8rb48/9kkCPbikqeC3ErijlJv0uWsh3htCw7XSEXrcODjKMqTnBmynUTVhPffCSUk6t/RmDYAiQO9A7AKAU/KxOSK+fNiI0AFE5gxmNu0Ech7ZPSVf3Ox/K6Y0WqolUzhopziubNBL7kYBuiylNB+diFvs+zNoG/6o9XoN57P3pvvteuj5DIaz1855zKA1Y1XM4bgDV5dqZu+RLO463BHnxQmndV90MapFr3UraDfmYySbqvsGVbNF0Uq5fPBQxl3CChAMaccqPhu8DmNd8PgyT5zIjwZ9ICU03Ef56T+nVFqv8yAn9QWssazLJwJ9P7k66UByDt9pV28H4A0kvK6Nh1+yL78ZEUR2vsxf9s35uBqqScirdofnKtzKDtwLqZ2dMEmm2xB4LqT+luGxijc+DrhH35JqNav5ee2ak6NENGtfZ/dT8//9Yewly84EBPJVGsDBwMsWUjmuLwuKjOjZHb3O61J9QXChxH
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3176.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(366004)(396003)(39860400002)(136003)(376002)(451199021)(6506007)(6512007)(37006003)(186003)(2906002)(2616005)(54906003)(478600001)(26005)(83380400001)(8936002)(38100700002)(8676002)(41300700001)(6862004)(6486002)(6666004)(66556008)(316002)(5660300002)(66946007)(36756003)(86362001)(66476007)(7416002)(4326008)(6636002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Wa/xjTp2OgsOBI8ZrwTTBcY//2m//52ZQRoWKnW6cgbxFecgw0wEKPsHCq27?=
 =?us-ascii?Q?kdENGirhuHOWzC3UxTq+fvHbY+a1g0h31u0x7FXPwP6U2+u0psg5VOINx17G?=
 =?us-ascii?Q?nak8RIctvXU7qyPk2iQmQL8K6ATRvgtEInSpJEyHFRYARDRV4BYPcwzUG3Z3?=
 =?us-ascii?Q?dB/YvThsihT85GLguMD4cWxTXC7k+39LO8tahP/h4CFhTGNO6OjD0v8KlPaq?=
 =?us-ascii?Q?32Vf3QakZSI6eZMelPWwdCXMB9gMEz70iA3vIRbDbcVJXr8zAJsQYqOa6hii?=
 =?us-ascii?Q?4DE/EhBl3DE+SNuJE1T75Fmuu64uSlbIpsb7RVwdpoS9br9lIre7m16S+reG?=
 =?us-ascii?Q?DYaIkaO3zjnRmLSU/eC1B19srB3UtpHLAdMZEp0bsiWXaYqGSn7tKIqHduCz?=
 =?us-ascii?Q?2VUkOxp/DEETJP6Q87dYnNPEgpQq+VG0BA4aIyDL3VebCXpFyEBC8PNc1ZHl?=
 =?us-ascii?Q?XI47lgRDUVD67ZqwNK8CpqqI38euIod7N/LUoorz5PKadqTWbE02hvviYn/D?=
 =?us-ascii?Q?2tTpexf6poxTfhLwzsRqTEXOFkOV8nwaiSK1Wk65HJKHi/xNS4FRqdgW7xS6?=
 =?us-ascii?Q?mw24OhRMrb/rbjQbI81NfNA2//aGGtVAzXgLoh6lBw+mVw7vSQz8WTn37ZwL?=
 =?us-ascii?Q?2utQXY/x/vSj4rWDlUSDTyOu+EF1RIqbjqEXZJroQ9pYlUq6uL8sjlVf+6qL?=
 =?us-ascii?Q?Uel+ouexfiTLFhRVeh/2JJw6/nbMOoXejBpFmXFCgjO1cXoGYurtFGnhcKch?=
 =?us-ascii?Q?RmnwfVUHE48r1W83w1efUGUMgHFYh4sj1oTWGJAHAD3ZwDoEd+QTCCWWYHfY?=
 =?us-ascii?Q?3qEl6wXCK93J8LiKuTOPZSrjV+X542HQzw1Gz1cwuRSnKah3c+RT/EFnyaGF?=
 =?us-ascii?Q?enPZsUCb9fU4OPGCyFzb22IB36hhxgFJu60pSPPttMCHuSLpImp5tS1pPbYg?=
 =?us-ascii?Q?YAcCxAKheSiUyfRCQIhaPfeYY3Dx54TauswkdZlaZ65VNO6KaGf9927V1eZR?=
 =?us-ascii?Q?aU2GLFUAlXJ5xryW7pFO2jMYPiA8feRCbTTfJezNPCeyJPNKbwvDyZdYp0va?=
 =?us-ascii?Q?1Q9uwy8x9qF/+DJCUkF1vk2c2giJ1N+KPVnVpSKgQRDAO+Cn3JU5Uj7LbE09?=
 =?us-ascii?Q?thJRSezo8KE8QbnYWUSDE9hi5unBIaWxmnlMicv5TIc3PpNMLoINhUxRm2Cg?=
 =?us-ascii?Q?jIfUb1WxubfmOY41jRggJEjMJZSvDSD79WodzO8TIMkU00xoSnAtKsJk2esQ?=
 =?us-ascii?Q?uoDnhtzjGpX4Tn/HIY5bF/AaLnxGoJkUCWA9FNdi6wdMdc2pdQRIupOd+JaG?=
 =?us-ascii?Q?3dmIYT1wXnprE+rv5COGn/0iZ8bidqguzianNSzLAjORarE/R60fNkWDoIDn?=
 =?us-ascii?Q?4wtYDn/GldnOVkX6bKnaqASDbjliKGpfLMd7vadcqqHuJYzbx+KnlGqVaQox?=
 =?us-ascii?Q?k9zgdPv6yUMeGU3KkFcqIp3n+GqOywb/gmd1npUMEnw81SUOOKSfErVhF+dJ?=
 =?us-ascii?Q?/8ckZ4rhWBXwSJB6y6SDt1VASwT6zf5J8OoghmgwWMbNFv4PxwlFcxibcC3i?=
 =?us-ascii?Q?JYkL1CSqltpXFEbGChqJCoLLKXnZ/w/LS/Js/Yrr?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 815727ef-1043-42ac-c434-08db61813815
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3176.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2023 02:46:22.4762
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jxQoUcO8GD+0R9SQ0Nqy81pnTlSc+ueCYO1l2VhAS6nlMvA7L0SCjkl+2ws43SvwtFbjoACF+LhxafDmGSd/jQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4455
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

> On Wed, May 31, 2023 at 10:30:48AM +1000, Alistair Popple wrote:
>
>> So I'd rather keep the invalidate in ptep_set_access_flags(). Would
>> renaming invalidate_range() to invalidate_arch_secondary_tlb() along
>> with clearing up the documentation make that more acceptable, at least
>> in the short term?
>
> Then we need to go through removing kvm first I think.

Why? I don't think we need to hold up a fix for something that is an
issue today so we can rework a fix for an unrelated problem. Strongly
agree the API/interface/documentation could be better but neither this
nor the KVM fix are abusing the API based on how it's currently
documented IMHO. So I think improving the API is a separate problem.
Happy to help with that, but don't see why it has to happen first given
KVM usage was acceptable and still presumably works even though its
implementation isn't something we like now.

>> And maybe rename invalidate_range() and/or invalidate_range_{start,end}() to make
>> it super obvious that they are intended for two different purposes?  E.g. instead
>> of invalidate_range(), something like invalidate_secondary_tlbs().
>
> Yeah, I think I would call it invalidate_arch_secondary_tlb() and
> document it as being an arch specific set of invalidations that match
> the architected TLB maintenance requrements. And maybe we can check it
> more carefully to make it be called in less places. Like I'm not sure
> it is right to call it from invalidate_range_end under this new
> definition..

I will look at this in more depth, but this comment reminded me there is
already an issue with calling .invalidate_range() from
invalidate_range_end(). We have seen slow downs when unmapping unused
ranges because unmap_vmas() will call .invalidate_range() via
.invalidate_range_end() flooding the SMMU with invalidates even though
zap_pte_range() skipped it because the PTEs were pte_none.

- Alistair
