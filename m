Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34E3F715E02
	for <lists+kvm@lfdr.de>; Tue, 30 May 2023 13:55:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232068AbjE3Lzh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 May 2023 07:55:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229799AbjE3Lze (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 May 2023 07:55:34 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 315CFE47;
        Tue, 30 May 2023 04:55:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SECCyVzRGZKLtFKxYiNJRX1VBkTkn0AclI+kkKHWFJIsMO6xr9tYMY1boXXFxLZ3ea3cucJeMjjMfIhuTtuGYHbTpX7QBfpFBF675K74hjKuiTKdwJgJ1+kOMmNzWCzdxyJTSiRRG7JM1cCU1fydDFXsLy4F3IVtqCyNRh8rbCTtNDbZh151gTkdTKoPGNo1gput1MdhQJveUBtwOvLUVMA3WkQUIkLCbvLIdR1MeoCTLWjknQg/9HT/rsTsP6wWPoYjWzTarVYeg7ch0EWZi71h0uzGwIRa9nCYc7HGXhX4DLIcoSf1LXy567D1VyiRlINi5rIUMGZyL2jB6UYwpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YDz/Uti4wqajUGITXZ3x5QJ/kGpgp0BXh8WTRRjEoOw=;
 b=Ie7Hk3h7vAgLFr1KAPH94TuU16qxo3xaYW8Ca1ODORCc5SOZ0UI9okIExlgqiKII/7KTJzFBrWmJXPY3+SmXZx8loJBdMCOT0FA/Ha54uSKBHTh39GqpOLcptwV2ph2zyuAIMVFLYeHpuFw1WypRLYmhxjagD1lgBl+9UtB5fLUKprzBYQRejZuKh9SmdAVSirP2fxCfSewCJc1nSPbQpvEee1VQs4LCd2xxe5NZDddHKpzAw5hk28a+vucsucep+MRDQxMm1iBpIoXz0EP8YSH6GT8tX1CZOQzEp5mkeT863PJ0L/d1JMkCdhWA5faE08mxIIfN/PYEolI6K09U6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YDz/Uti4wqajUGITXZ3x5QJ/kGpgp0BXh8WTRRjEoOw=;
 b=FzcSNdit4aKJrZZby6iC8Hq85n2BVHT61EHAvRsSdxW9eOkCYMUXsRPT2Mt5Eg0jIfsdrUXaWS9VW+BGy1aio54Vcio2uJnVwmm868NUB5QCW/wQ7nxKA1AiKYGLC5V4tI9A2o46CeuQ58roAD4tsHtLO2qM5Tn03adD/Q1hqno6CuMlaFM23VSn8csR9W4YEVguPI8nycwLB5ElxHbjhXSLanNv/w7/Ez8JelpihoVRg1A0MZDY5F6MoJlYdoycWK54/xoCWRJBD09Dv9rdncWIIT3MPuoBYT4zZ9qGL0zDDF5jOcCkdYu6B05Ba1U5vS9C29meuwjG80MdulBIlw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CH3PR12MB8073.namprd12.prod.outlook.com (2603:10b6:610:126::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Tue, 30 May
 2023 11:54:42 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%6]) with mapi id 15.20.6433.017; Tue, 30 May 2023
 11:54:42 +0000
Date:   Tue, 30 May 2023 08:54:39 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alistair Popple <apopple@nvidia.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>, will@kernel.org,
        catalin.marinas@arm.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, robin.murphy@arm.com,
        nicolinc@nvidia.com, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, John Hubbard <jhubbard@nvidia.com>,
        zhi.wang.linux@gmail.com, Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH 2/2] arm64: Notify on pte permission upgrades
Message-ID: <ZHXj/6Bjraxqk4YR@nvidia.com>
References: <3cece716fc09724793aa832e755abfc9d70a8bb3.1684892404.git-series.apopple@nvidia.com>
 <5d8e1f752051173d2d1b5c3e14b54eb3506ed3ef.1684892404.git-series.apopple@nvidia.com>
 <ZHKaBQt8623s9+VK@nvidia.com>
 <87pm6ii6qi.fsf@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87pm6ii6qi.fsf@nvidia.com>
X-ClientProxiedBy: BY3PR04CA0012.namprd04.prod.outlook.com
 (2603:10b6:a03:217::17) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CH3PR12MB8073:EE_
X-MS-Office365-Filtering-Correlation-Id: c75b8e6b-bb3d-415b-0852-08db6104a796
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CCUm4sRzc4qIGo4BsMKNqic1xNYj8iGp4vlTwFFV7wvAvM7Ney79eQdiGxBexk962SJwGnPDM1CRebepprJ8MkbXGQ2S9qfGLz//uoR3wlpMfnZP2faeYc9RBjPyngr3eSSEILhg+hfypAJhDq8VYBgSkQDzTjX0p9SuDvhmlSOtZvGMfm5Q9uI+OT67oCGZDMCw6wVxFMrkUip0bFXzQ3ZWDmKGxPIUfNMpvaCPjw1K6EoFtHDeCvc5CVAGq+uAKyEOzMXcQphNTlHYt6p1PLepn/GVbNRQsfRt+lfTApqdThoCmnv76LQ0RjGQ4efdi3jPi6KbtNz46Rle5/GcDPUD613otL9+0oCasr+oM6t/KvML85O/qSiyitWfYh8arXXqWi7tEOozyvzbm8YanRx3JW93k3esKW8Wti0b9/jaloe6rZcAbtty7lmsIUWyjDFIkqakgNe2GonMoGau1m07VryF49DC2SdaWRDJttqMrTDSGqJdP1Vy8ggYj2nNrkvqro1vnXFF9z6c6jq+B8OZZAIA3usr6/DtXScYPPYS9p5ABn9sOLirIoA4/rXV
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(376002)(39860400002)(396003)(366004)(346002)(451199021)(26005)(38100700002)(41300700001)(6486002)(6666004)(186003)(83380400001)(6512007)(6506007)(2616005)(478600001)(54906003)(37006003)(66556008)(66476007)(6636002)(4326008)(316002)(66946007)(5660300002)(6862004)(8676002)(8936002)(7416002)(2906002)(86362001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?99CBBfdiy+qFEzhsQQQbW5bpbSiqsNrvSjjAspDBr8eQLaQLuydZqR3yMgy7?=
 =?us-ascii?Q?x5mscC6f7qoFbdNZsCCu6cFYFhTxpDzvbEgjzOxu5+sy3rJmi8rtwi3mNzof?=
 =?us-ascii?Q?7E/DScWdqPaekPqCgzAYDTqkQ1poioInZBDPGn0lgrlAxi2/PuqWWgPEOfmB?=
 =?us-ascii?Q?dhU2+9wTLltRvwPJTOBWhsyr/O4dElE/41nh2HTb2CezY+YugSoaBaKMb3NC?=
 =?us-ascii?Q?mq2ZJnufi/eiT79GZoD0Ou087fSFAJh+h2KOUgjivnsFpro+8DAyLR8TuJ15?=
 =?us-ascii?Q?wDfovsMt76xNJq5Kyb/Dl4z8zqQfVf50slKNmhSy7VI0KWE84mAD58666c0u?=
 =?us-ascii?Q?ilP4ED5W0dTL6l+cQcB21HaeDMg1ic91/lc5+FDpQmuiIK4Czf8s5veaEg/P?=
 =?us-ascii?Q?uQ9vsi27EFwb8mcth89tKh3FUlyxSRM5EYRZb1xUAvx3FT2/ve9+wVZ2sDDF?=
 =?us-ascii?Q?EiI374Pa3Kid/cz+W6CY7L8qVQ/oRFwrP/m2SNoWLZHVH4/KEM0Tz1kGHJa5?=
 =?us-ascii?Q?qQQ1ZUrBAjJinFCF6wj/yi9n74/ljim+NAsfpSHfEaFyD4n18zu+T3CPLT1s?=
 =?us-ascii?Q?mWgd3/mDyJQnk28L2hxw1SBKwrHj3bHM1/BZHbeSMT+wB0HOc9QBn/I2kGuD?=
 =?us-ascii?Q?gVwMp1nVYBYodOwERC6HbVuu/RpVBgweOw8z4lf3weUDQpBIuAVFG75ys2lq?=
 =?us-ascii?Q?+hGzY3cZMv3clIIBIoGrLTbwWjRhKhR3kzW0bJ0KPut4RUnHhnybIWobZ+aB?=
 =?us-ascii?Q?D6pH/mWjcc4ovJ2izBGhXAjcC4DYYgsBaqnOAlTajrKfi1mbNN580l6hYmvR?=
 =?us-ascii?Q?JjsQt/F1iUqDFhIEbE+tITCYe996/Z6dJ8G1BcU0ExdMXgFwKEGfeUeWJ8J8?=
 =?us-ascii?Q?XzD6ipCW437zhQl9IcsaSPEYbsrFh1Ggp0Zn8oXjeMLGYjNw86pOpmK76WrJ?=
 =?us-ascii?Q?f6lRn8pnEDUkItoMu+xnNOpkDLtow/AM5cy1L9UX0uKnzm1urGy8BX5DXUxB?=
 =?us-ascii?Q?gUmnwwd0wnog8dN6ckvRyhepQh0Gj7nUOtqtG4f7TYYDjTNiAQyxBRo4CY2j?=
 =?us-ascii?Q?UhxWrStpWILpoMQ6EIwIhNH5ucE+HIFT5ZdR9kQpZixy5tGOQLdh+czLrJ8/?=
 =?us-ascii?Q?ZsfN3QrJBwzcB2YNhC/ewOQqdU9xBz4B8lAaSR7jw7yupFIrKhIw13/AIQXy?=
 =?us-ascii?Q?CnYUUEKqZRRTRdPKrrnWmzLb7zB/9eG2bpbpQ804WgfEF64lCBkWEP2/v0MG?=
 =?us-ascii?Q?5ve3GU0C2/uRWMFAVD4Xc9TRVG/sp7p5PpGQy+/blmkGt7oYGaqL0pTF6GQW?=
 =?us-ascii?Q?h3du0iA9M8Cpqxw1eSsOaf5H8PRq8C6PAySiyLovd5AUVVG45G1VX2mfCMGE?=
 =?us-ascii?Q?De/ZfV9QFxqYV3N6iSCy8Js9WuJM1Z5C2dYdepYPMwsT610L2Mgj3bGLb3K2?=
 =?us-ascii?Q?EUXGOuB6SB/5s7f8ZDg5DlMOK8qonIqTN6lE7mhQ8mjgpnSlit0PXEuhNeIp?=
 =?us-ascii?Q?kruZav6KBBBZBHh4JDug2ahoZ5rv0yVNrteq7rugLodjzMcqPOFFy4fbL0Ry?=
 =?us-ascii?Q?cMJCLXde65SfXh5H796ceZuwdV+DTp7EuNVz+Lyk?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c75b8e6b-bb3d-415b-0852-08db6104a796
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2023 11:54:42.4432
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Af/ul9D4cgxeMxYzU4cE0owH+KU2K/Ek9vkpnESgOumVEO0CnXVQ5rH5JBnHVRtO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8073
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

On Tue, May 30, 2023 at 06:05:41PM +1000, Alistair Popple wrote:
> 
> >> As no notification is sent and the SMMU does not snoop TLB invalidates
> >> it will continue to return read-only entries to a device even though
> >> the CPU page table contains a writable entry. This leads to a
> >> continually faulting device and no way of handling the fault.
> >
> > Doesn't the fault generate a PRI/etc? If we get a PRI maybe we should
> > just have the iommu driver push an iotlb invalidation command before
> > it acks it? PRI is already really slow so I'm not sure a pipelined
> > invalidation is going to be a problem? Does the SMMU architecture
> > permit negative caching which would suggest we need it anyhow?
> 
> Yes, SMMU architecture (which matches the ARM architecture in regards to
> TLB maintenance requirements) permits negative caching of some mapping
> attributes including the read-only attribute. Hence without the flushing
> we fault continuously.

Sounds like a straight up SMMU bug, invalidate the cache after
resolving the PRI event.

Jason
