Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2FE7713738
	for <lists+kvm@lfdr.de>; Sun, 28 May 2023 01:56:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229483AbjE0X4Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 27 May 2023 19:56:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjE0X4P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 27 May 2023 19:56:15 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2055.outbound.protection.outlook.com [40.107.100.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97EBFD8;
        Sat, 27 May 2023 16:56:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O5NAbfel1Ryz+7EObSEcvJ6X7AZ8+My+Vnrm+7P2qWt4pQqhKx6OHEU22wJScWr4hQSBGFrnUxMnk8U7ZEWsD15x5/digHcs+NYF+CnImWQ4TFs1nf2kHLMgz1mti2rxAu79Q1ne5gmPhZ8vroC0iQ3whpLwkowBoRQR+GCsVNsXEEV1vnI94GNCJRuHZvcfbiW0lYWBjwYYI0XJXKvQl1C0MlHZgiFaJlMJZY1zlwN4RIFP4llRVY2+NY7e+2IFZoR36CgtOYmCSyWPXUEuuYRMCI1xh8R4MlUQdZprP6pRKOFzIMBdE+gg3JLGjTHGWM9X+ZMlGdbzHLtUd8pi3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XmAEx+cqMmhdq4g4e1XqUP33UszhnkQmwwCX5+N6ffI=;
 b=SPEihRWIGQHq9dTkTDrx+WooxzoTJzDi8AF1UUZC6xmmcDRFPQAPER5NE6uvWjeSYwYdAIjilIBpd0zb1OHo6I/Xn3/WoN5J/B1BLveuMI3+da8b7bNazoIP0GgUSCe8baWXHyme8duXYmcgKv/cmjma/izohlAD7qOvVkANJZa51LY+CodUOwKRw7RHrFLEQgEm9uN46uCJGNW0WbTe4MNmZ8LT3Ch780qxs2IR9An99tnhWWFN/QC2CLMjZ9d8oWdf7G8sJs7ezo5k6cP1C3+eG7DbApDWp/YL5fPM3iNusmz6dzahtDaLTqt3uLe5rJvS2Y+lkDtofquR/qb4Ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XmAEx+cqMmhdq4g4e1XqUP33UszhnkQmwwCX5+N6ffI=;
 b=t81A7V7SVhEiUe7urkaArG7It7+LvlSL8Xn4cz3tMsQ/vrJnaZ6pm9VPITZ7ur+91dbB5aaIA+4qqnT3+eLX61jwpem64FNjQzEAsH7gq9CrDd2Ew9y0IFsDNre5KP/h/mSQkDmosOWz4nASFsWiRR+OqRFhdrc+HjkoqZpdrio2WTA61g8sEjqZHHHMnqEALZBqkGPhOMTJ3jdV+PoLEf9Dsi2gQTA3rGbRGOdf3MHJvVs4PK5MkE7UySCQwFMlkskux/iZC1EgV1a8ws/rX742APAPaiFMbXrQv4zhdurrt6pvsj85G+UEac6b8Le+7C/5zwtF5Lr4ACbDghYgvg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SN7PR12MB6692.namprd12.prod.outlook.com (2603:10b6:806:270::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.15; Sat, 27 May
 2023 23:56:11 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%6]) with mapi id 15.20.6433.017; Sat, 27 May 2023
 23:56:11 +0000
Date:   Sat, 27 May 2023 20:56:08 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     John Hubbard <jhubbard@nvidia.com>
Cc:     Alistair Popple <apopple@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>, will@kernel.org,
        catalin.marinas@arm.com, David Rientjes <rientjes@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        robin.murphy@arm.com, nicolinc@nvidia.com,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        zhi.wang.linux@gmail.com, Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH 1/2] mmu_notifiers: Restore documentation for
 .invalidate_range()
Message-ID: <ZHKYmOc/x+0w2Nd3@nvidia.com>
References: <3cece716fc09724793aa832e755abfc9d70a8bb3.1684892404.git-series.apopple@nvidia.com>
 <cb706d3f-1fa8-2047-e65c-e1dc1fa6821f@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cb706d3f-1fa8-2047-e65c-e1dc1fa6821f@nvidia.com>
X-ClientProxiedBy: BL1PR13CA0145.namprd13.prod.outlook.com
 (2603:10b6:208:2bb::30) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SN7PR12MB6692:EE_
X-MS-Office365-Filtering-Correlation-Id: e4178ea1-0505-4e46-715c-08db5f0df2a3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tr4H4sdeQCnmLupINX3r2xX2p/wk0i79CitwmWhDdHXglHY3W3OMDVK9ljJdcLCp4auPehR2W3xxP3OQhtg88b8zki+eYMF2PeaNjXwlSJQCUiHkcxpVoZfZ1XM8POOb/xObsV64md3xLqtnq/DxiuWlzwQRPEsBroJBN9rJ5FlJhbGhLaunoDxzbxXAG/JT/kfLnli2mfVhLiUiJ6z5KYu/XYcMQ+G9vC4w1uVQyQxcue4W9U5Eunk7w9Zh36wZjgd/d2negz5Kvbfamup/hooP8DABf8B3q86l3FPiO1McbDtsBrejimo9EiYORo8gMCiw1YoBaGUHqOpLsFNVhrlx6BuXnu95GFjf8nzVkR449So963GbOeUi4B4JzFw7NPUa384760YLYdn6UrtnQOrsIuUC4d4ZGQMYUct5wmrgFHZugfpxOJKydASctAcaL68j9DFkJJMyn1W12DFvCKh0Vz166RsMc7MxMMCJP7gdhtOtMEOt6LaXWHdaoHzth00H+ySrV0REBPskj1GSuX2HbkBavyHvGCuoSmATPLDwy/hlsqg5f9IVsHF7atlsIm/r/yN+hx5lOogjuolfr5oEsZjymWkNLmFSgt5o1WAPgZoyZxh019tgWcKR7AX3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(39860400002)(136003)(396003)(366004)(451199021)(2616005)(83380400001)(2906002)(186003)(36756003)(38100700002)(86362001)(37006003)(6486002)(6666004)(316002)(41300700001)(8936002)(7416002)(8676002)(5660300002)(6862004)(478600001)(54906003)(6636002)(66946007)(66556008)(26005)(53546011)(6506007)(6512007)(66476007)(4326008)(142923001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?H8a118EZulG665EjGKET8lrljgLqGdjROFfrlG14wAQzAZ/cqx63siD3b8uN?=
 =?us-ascii?Q?yZsor5AJedRB9QOFUmQ9vwNy2k4gC3Ng3nBvdAfaGnvF99DtSq2R5FJa/APg?=
 =?us-ascii?Q?YbMVb8j2gv4/mZ+NrjJxcvqcOyn31jMZyKMoAhu6nPO+dGndbizDtLHdVOBz?=
 =?us-ascii?Q?Gdl7wBmCsrcjtSquXa5fZr+tkARlpC8YrlQsSFfQy2qi0Ag09JQv6rvDbALQ?=
 =?us-ascii?Q?XNVdxIL+JpBsy1EC59l9OnNlwA4hDzZ0P/13WcdbdRDktoG0tmaUzitvY6Ce?=
 =?us-ascii?Q?1XIIzxsTCeX1wfyGbb3fG25oYf9SVbl2SoRrk1LNLwy/j3eFDz/g+7XSeG96?=
 =?us-ascii?Q?jPb607C6i8eHdOFVWK+c7ar9ErBS/QFrUF4I0yFnuKBzZSk23MFKVubMSwVb?=
 =?us-ascii?Q?ArppKr6PvOtQ4k2OtWEJ8zCh/+sDOwg3t1L0PsjrmrQ+LkXatlliyYInrTJM?=
 =?us-ascii?Q?6ATS6ue1aoJBPaXThU43AhPevWuiDZyhlh9Ds83XpdXGjTkE0Gd/C2XhwS0S?=
 =?us-ascii?Q?WiYpYA74Wj5lVIMRIjyf3IHYkYHa1vi/bwhTRihOKyT+5+ZpC9Znz4frE/3Z?=
 =?us-ascii?Q?ROv63INTuEs66AbLWWmvsrdAKWbjAWUBArX0kyGZq/ZiMJ4XeDVd61gt69qi?=
 =?us-ascii?Q?4noIpMftvgSW7hgQXzKoDuyBM9mxPVlNSnFrgX9MMxLxPllx/ob8bgZyTjHF?=
 =?us-ascii?Q?xSakHago7geXhJK77xlSnIh/GqCQqnoVHBbVSbGVh/tnZQM/Hg0Sal68IPzp?=
 =?us-ascii?Q?Mr0rNX/zkhgwnqhazJXARI5PKNyEzdccslllWG03nRriKG1H1N9hJ0v9X0jm?=
 =?us-ascii?Q?sRIIwRFdQf0S3W1WKM2lLQISe3dt6aUmQ/jebOVWk7Btwh7l3N5jGhSko53K?=
 =?us-ascii?Q?qvuHa+iE7QA4J1EqceH4rSkt+aJpNVMNYTRmi2ppxhn/r7qMjvmIBQb9GTFs?=
 =?us-ascii?Q?jJbE4jsBdcE2MG3ruPoitpxg9SB5xmHsPa3yWD5XlAOp8CB+Jj95zhhEpu5+?=
 =?us-ascii?Q?vqontdw/m72VKsoG6GFqcQ9qW76evLgPQzcN+STZ5hNVwcN7PwwNWLeSHwR2?=
 =?us-ascii?Q?uMYx1gjHZuv4U7M0t36jBJpkir2qi60+zibDlwoOfelUomEQf8VzmKcQ17re?=
 =?us-ascii?Q?TlLyAba2PF4VTSUnOetGjkHis6iiA/Uhppt8p9QOUA+jEMebM4aQqm3zKGgq?=
 =?us-ascii?Q?BT5XrtqybJFqvtxVsAZJhIxpRFYAQSmjdsWwgtxYTEancGDsv4I/RaSt2Ugb?=
 =?us-ascii?Q?ZAcOevzcctvzsa11PRCH8GWVWTWVz3u8qU8Ft3JpaMSaye+YjMIocxlWTzR5?=
 =?us-ascii?Q?HZS9XG3HHQSEfHQAfhai/xtmNOWekDRRcFBjwS0JJqxeTluXcejAXcenlpx+?=
 =?us-ascii?Q?+++07jklvqOyDaZgr9NF7LuKqJ03sabpStPbHjmWa9UOkjK2d3TPoA6lUKgK?=
 =?us-ascii?Q?0XEPXc4ujm99RNo0FKP0emgjEP4+bOMRIS0EgMrcdStmDCoMsHr84oNS522R?=
 =?us-ascii?Q?9jHZIyIArcSGHKcsIuSRvvpG5gOCj8tcXVAbvxQrHOcKRb1e78wLw1EaT705?=
 =?us-ascii?Q?VOahJ8MebC+dt0pyx9o=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4178ea1-0505-4e46-715c-08db5f0df2a3
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2023 23:56:11.5172
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xS6d4zE1ctTU9ls1A4G56OD5Q5FC/+vTszLplnASE5VYnWq0UXsoacUZVOF8P1cV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6692
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 23, 2023 at 07:20:31PM -0700, John Hubbard wrote:
> On 5/23/23 18:47, Alistair Popple wrote:
> > The .invalidate_range() callback is called by
> > mmu_notifier_invalidate_range() which is often called while holding
> > the ptl spin-lock. Therefore any implementations of this callback must
> > not sleep. This was originally documented when the call back was added
> > in commit 0f0a327fa12c ("mmu_notifier: add the callback for
> > mmu_notifier_invalidate_range()") but appears to have been
> 
> Thanks for digging into this. I expect that you're on the right
> track, I'm just wondering about something still:
> 
> > inadvertently removed by commit 5ff7091f5a2c ("mm, mmu_notifier:
> > annotate mmu notifiers with blockable invalidate callbacks").
> 
> Was it really inadvertent, though? The initial patch proposed said this:
> 
> "Also remove a bogus comment about invalidate_range() always being called
> under the ptl spinlock." [1]

Right, it is not always called under PTL spinlocks and the
implementation cannot assume it, but that doesn't mean the
implementation is allowed to block.

That was one of the main motivating reasons to have both the
invalidate_start/end and invalidate_range variations, start/end are
allowed to block and range is not.

invalidate_range really only exists for the iommu drivers to use it
for SVA designs, there are a few other weird users, but iommu was the
motivation to create it in the first place.

So the comment should just clarify that it is not allowed to sleep and
can't assume anything about its locking environment.

Jason
