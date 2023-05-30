Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F067E716092
	for <lists+kvm@lfdr.de>; Tue, 30 May 2023 14:53:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231993AbjE3Mx3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 May 2023 08:53:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232374AbjE3Mx0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 May 2023 08:53:26 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2072.outbound.protection.outlook.com [40.107.220.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9021CE4B;
        Tue, 30 May 2023 05:53:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SDivpmQghpK1UUf5t8mxaRYl/5zqgTAjnHnja+e63o9wkiFKtnj8JX7CTx99IwqQI5ZdJmEJIgiB3Ef7UxEQHbExRQ8sFhSsAjvkW7zTiIoJynprCrHLryNGspxqCNUuLwFuQzwJMIfg032y+ApS/L9zny6Ybh61dJG2xA7BJAnwmy5jbezF7Xx2kONjaHKhB2CCobZQQJpxQtWa9NMfvCVTkuZun8j80t/9qbgc5rQPY3/E519U/V1MvJyY4KbGUXT+mggCVBWPGsRfGsp9Da+3QVcuPqbFB/nh5Ga/gi422/5TL+aZ524npfYH58r4Ub57DuzMctbEcoERlnxN7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gOTjVUbkENSjUSTkeOmWH9YX6YWCj1y+LVHKLzlMyvY=;
 b=OIUsj19Ihmr9VlFo48lhUlafMZHRz0S8MMDKdpmgxl0r/iEHSFx2I6+hfaRk6e7er+nOUVTCG6LuDOMHzbtybeo04wSdCYi9hDoreaVxM1cIRYWk5Qt22g0H1aKkmFZaKTCtMjzxQOg2NB/imEIIBSsA1jZ3w8xhBVaJqD1PMozBDgmuMM0LXX7h0xlbvbRNY3pLCbB3poeKwtA6xzOeL1SWWRhSCz3j5EwYi2JGxJaMeX0sG8B68uHrGOcHQ3wWYVTGUPEsbWllgg1vE3Y49337TXt+J8gsnB2oJM3TJ42V2tziHXTvobSbCmb4Nx6whRNK4Uo/M8KFkgF7DGoKkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gOTjVUbkENSjUSTkeOmWH9YX6YWCj1y+LVHKLzlMyvY=;
 b=f+HKngsq6psykViI0U/lWN93od4eh9dDCqCgsqq4A73KGmTQpNQo800rZEtAa0wANrIomg5+tuM8wSkI1gyZ01K3rUQhX2JDVk6RJd6vShgx9jAbiSNofDg7yh2aZj50QtTGXj8o0mLRnF5puBb3Bt6k+9x+6BvmC9KnJoYpkLD4Kw/pyS5INhv0+if1FULXU3oxfhKablvYhHIsjBvhSTKmJvW7T/gZ8xy7cGWueOB0+lDRiyUxYj9NdwaaBhEhyV6H2bEKZQ3DwUAMjqHuPIKJfdbNf7I/mC/GA/quBzNHbVI9FH7rxx7VA86SDuuGkrdMK17o63G70Q/pKrltfw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by MW4PR12MB6976.namprd12.prod.outlook.com (2603:10b6:303:20a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Tue, 30 May
 2023 12:52:37 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%6]) with mapi id 15.20.6433.017; Tue, 30 May 2023
 12:52:37 +0000
Date:   Tue, 30 May 2023 09:52:33 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     Alistair Popple <apopple@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>, will@kernel.org,
        catalin.marinas@arm.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, nicolinc@nvidia.com,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        John Hubbard <jhubbard@nvidia.com>, zhi.wang.linux@gmail.com,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH 2/2] arm64: Notify on pte permission upgrades
Message-ID: <ZHXxkUe4IZXUc1PV@nvidia.com>
References: <3cece716fc09724793aa832e755abfc9d70a8bb3.1684892404.git-series.apopple@nvidia.com>
 <5d8e1f752051173d2d1b5c3e14b54eb3506ed3ef.1684892404.git-series.apopple@nvidia.com>
 <ZHKaBQt8623s9+VK@nvidia.com>
 <87pm6ii6qi.fsf@nvidia.com>
 <ZHXj/6Bjraxqk4YR@nvidia.com>
 <d2e591c1-eb43-377b-d396-8335f77acef6@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d2e591c1-eb43-377b-d396-8335f77acef6@arm.com>
X-ClientProxiedBy: SJ0PR13CA0130.namprd13.prod.outlook.com
 (2603:10b6:a03:2c6::15) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|MW4PR12MB6976:EE_
X-MS-Office365-Filtering-Correlation-Id: 54672bda-2efc-4a0b-7cda-08db610cbe8f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Cgfy64LfmCJ4sRAW2b8QwWt9XTriw/P1zI3ON9Wrt4xYXoBJ1/rbur69ZAAAw1cGjx4RflTl2lYONspEexYSy+MBks0np0wQmHMLmSRKHJTI/ELpTmv3LNCYlmbWyjKhHzuju4+KzyHPA8uh+zFNoIHVI1/BQfbQBtXOaAe1jkuuVN/EAm7edWrM1ecP3f7+b32XTNlkCCxKtSOE7rM2n+fJkSn748MjZAMrCuTreQnNz7P1kmKtJeB2VL+wZRTIKQmoNPPPd03EKUnTxR6iPnm0/np09F9RPiKbQQgh+iA3eHhTlaKZ20enU8LhFWT9NzOf56BKV/TUISMemUBntZ9t1Yzd/mb/fLEKHHvrFAvD1yqr5f6U5jkP5ZLpoPWacsxnBmpCInkMPKzP5DiYI9PnGxtawKTtNrpF3dW1EJMfQBZLoKQKxHS9DVm5oWGUdIW1nEJDWlY9KMcbU/ZAT37u4BrqWTXM6Hpv6+B/amlvD8ZWK0wSV2mVsYDRWSUZ4h7WqiBRYWzNoG6viTpE4l7+ZYYW9gU76l1s6erHRu6oywNsWzv4ap1ruCT5XYpM
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(39860400002)(396003)(376002)(136003)(366004)(451199021)(83380400001)(2616005)(2906002)(186003)(36756003)(38100700002)(41300700001)(316002)(6666004)(6486002)(5660300002)(86362001)(8676002)(8936002)(478600001)(54906003)(4326008)(6916009)(66556008)(66476007)(66946007)(26005)(53546011)(6512007)(6506007)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vtF8GQfl9cYrgqK0QCcdx5yPA62+HVWCu15E0MMw6+LYSQxrqDdBK5lSiuHR?=
 =?us-ascii?Q?c4mnLUyjdApvAHNwnrgsU8SUhyk6wrdq5AcdW7bxTSX3BKcvMnIxe/z65v2m?=
 =?us-ascii?Q?shPYO5xoK5mKIlq5tXIoP38foRK5IIdHjxwXtUdUx2pElPiuvPvm7/oBSu45?=
 =?us-ascii?Q?YY/wHtytJVy7PaZnXc1SRsChT9DL6Twe1gxEmYLeuQeK7f7EBq+xbRZTlRRz?=
 =?us-ascii?Q?1YxePvf5HmxgLCdSCrn2GULXfGyCkTCUr9XZz/VbMwZlpVXarYEGsNYj1R4J?=
 =?us-ascii?Q?QUQsP2Ha9MsOHxfgeI7Q8zWPuwdtNffcb64NCNJKNL37N3xvOdi4+7W7e4qf?=
 =?us-ascii?Q?7ubwOS3R113vOhgzixDhyPcEfGeyz+6PqgXHq9GxJikMxhMjjVJ5BqxlwU8j?=
 =?us-ascii?Q?OTqWHQkOJGL0sTvIs91FJ8Xm7WJhVJkGTuao10UACqGeSwluL2C4N7PyDraU?=
 =?us-ascii?Q?HebZWoIrzt1bHF+vEP9f34ZlZtrF+nIoykZ9480y24CH3r2g3kDRYPxUEq8C?=
 =?us-ascii?Q?v8D+ZxTvabcHUA3m1Oi1Wrp47I0Q7hmUel0EXksCyVg+Trjv79qPu9lAXcv9?=
 =?us-ascii?Q?G78/U4d4jI+aREqqCyJBuCt/IK7xfK9CyUovnF+gPXM6qD+PmhauT9K+lZXA?=
 =?us-ascii?Q?m0IXfu7618gxfh/mFTyq1sjAkbgYnKrqocqC+S1Rbv2p7KRL3XX44mKoPN1j?=
 =?us-ascii?Q?DheDvUlRzL2LJvlkJcES1i2ota+HF8mVAGoWGAYvQ6jJCoiVEhh9BoWcoJcv?=
 =?us-ascii?Q?/GtOau7vLryI288lyA9wr8GPJxnSoCBqXt4a8qtOFEtCwdnjU2UWMO3wL50E?=
 =?us-ascii?Q?EtfDakt9oU++3MaOwZO+YVDIfGR5tQk9wYPCyeFKTxFqAGJx6PINGOBz9bSF?=
 =?us-ascii?Q?Simp2HF3HJoEHgiWnauv4AvwKxA1lxyOp4vEiQBQ/33tUWJ3oZ6WVW/hnM0T?=
 =?us-ascii?Q?NcCaMrDHAo0mGsKa4i5nyS8lWL7ULu09sAfr6t029mtwRhZ1WfKmzrtBErR3?=
 =?us-ascii?Q?jEsVD55kWt/OLE9Jp3RrmXs3PXc7rB9SEyDmABCpF+7u0DBg/o2OYJiTdIG6?=
 =?us-ascii?Q?vVmYSQY8Q++zb3JsJA+KsqmjzHlr7+TimmynYSHuD1RVLGj8S5cSuY1QW+mt?=
 =?us-ascii?Q?H+OJEg3ojYveKQTaYuGs191KkhCtkbrO6LcEZnBYLr3GITDH24wogcrTZeP6?=
 =?us-ascii?Q?o1ijA1JHTxOdmGIqyEoWBYosCf6R8ArmHHTy5DsI9FRh1pf3LhZ8jASvCOOs?=
 =?us-ascii?Q?48AgV19rf5u0nyKGsuvig+UcLim/YkZ2NywxCfdkwy71jrg/BySBL0OqvrsP?=
 =?us-ascii?Q?ba2DS3FjNfJnEkOcY3ZqZ+7LtKmszA4d3w5qyQ6Irv8RbUMsl15E0p5AkMzr?=
 =?us-ascii?Q?URjYyI7geCFlEnoCRQ3JDH8VdHSy1OmNyTTxCEQXEjk2y6S86O88fC8ePTuu?=
 =?us-ascii?Q?pNnD92b0ofQG6RhD6sdwbQeNZGRYvYKIiaPwwk0/bkngBqJHCscYMLPdaCPs?=
 =?us-ascii?Q?MXWa5EZXcKnk5p2+PfTpd34d5mY1NsAzOA6gFvBXCAie8fqW3ce4uQofgvdG?=
 =?us-ascii?Q?XMeolG4hJyNREKaY4k30xRwcNV1DFoB79qhyJ6kD?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54672bda-2efc-4a0b-7cda-08db610cbe8f
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2023 12:52:36.9412
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w2LyC9ODDECO+7B1IUuFf5TymVmxl6zdNST+UXzrJhwnzD+lr9Jx2epf12mmtHyZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6976
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

On Tue, May 30, 2023 at 01:14:41PM +0100, Robin Murphy wrote:
> On 2023-05-30 12:54, Jason Gunthorpe wrote:
> > On Tue, May 30, 2023 at 06:05:41PM +1000, Alistair Popple wrote:
> > > 
> > > > > As no notification is sent and the SMMU does not snoop TLB invalidates
> > > > > it will continue to return read-only entries to a device even though
> > > > > the CPU page table contains a writable entry. This leads to a
> > > > > continually faulting device and no way of handling the fault.
> > > > 
> > > > Doesn't the fault generate a PRI/etc? If we get a PRI maybe we should
> > > > just have the iommu driver push an iotlb invalidation command before
> > > > it acks it? PRI is already really slow so I'm not sure a pipelined
> > > > invalidation is going to be a problem? Does the SMMU architecture
> > > > permit negative caching which would suggest we need it anyhow?
> > > 
> > > Yes, SMMU architecture (which matches the ARM architecture in regards to
> > > TLB maintenance requirements) permits negative caching of some mapping
> > > attributes including the read-only attribute. Hence without the flushing
> > > we fault continuously.
> > 
> > Sounds like a straight up SMMU bug, invalidate the cache after
> > resolving the PRI event.
> 
> No, if the IOPF handler calls back into the mm layer to resolve the fault,
> and the mm layer issues an invalidation in the process of that which isn't
> propagated back to the SMMU (as it would be if BTM were in use), logically
> that's the mm layer's failing. The SMMU driver shouldn't have to issue extra
> mostly-redundant invalidations just because different CPU architectures have
> different idiosyncracies around caching of permissions.

The mm has a definition for invalidate_range that does not include all
the invalidation points SMMU needs. This is difficult to sort out
because this is general purpose cross arch stuff.

You are right that this is worth optimizing, but right now we have a
-rc bug that needs fixing and adding and extra SMMU invalidation is a
straightforward -rc friendly way to address it.

Jason
