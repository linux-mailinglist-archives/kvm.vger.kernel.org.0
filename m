Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B38F171726F
	for <lists+kvm@lfdr.de>; Wed, 31 May 2023 02:31:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233637AbjEaAbn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 May 2023 20:31:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbjEaAbl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 May 2023 20:31:41 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2054.outbound.protection.outlook.com [40.107.223.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF484C7;
        Tue, 30 May 2023 17:31:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EueekF99Fy34FQu64vQmzWfI5urjtgpLWMBgYzS3ZatQtlMEKMELt8SkXMi04mtQMNaA2ky6xzYaMUYz8Wts0LXDs9gPrRZOct8KBfWMAiovaq0Lb15hbD07wfHDxL4e58abGhBtfSx8T954Te79uL5u7vEH4VH3j71BbgUuPKvfEO2wK8tLZZ8cw2JIyVohOb8qlitLQiThiT2KH5U4aSHf7DOR3by/uJYH+PzyRYnnq4xMXJlqf4l2cjaof51aYRtWul1V5/X4Y59OfD1tf42MldfrMs1O5nbBHFR3uuOfXlLY0MO3pQxWFQr52LQtfWGUyXMO5b+AIePC7IfXpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a1idkH5qd0NH2E0Pwf83gb214G96FOO/0z1Jj0p+J+g=;
 b=M5BSa2uo/sYxsZuH6fKvKI6QTi31iQDrXpm6PHkPvS4OlrYGW02nLx/JyTnzrkBJx6Bt5OHrmQSoGEO3gTTJ1VqvVUH33Dv/4+OMGK94YPENBP7EXztXs2Nl0NdTE5K3MmiIVfM4PdFXjj5f+gTXwOPmGdOnKgzLSBMtiNp7yALfaqjWsrpbnKEWLVR3x1ybvDcfO9G17G0wJvRn2SkmjnQYr4BymONjOw+P2Ma0oFr+lcAMWi5E64USmpc25LgunPNPGNTP4R/b1Oa36WfEmcBJAw1LsOBldQ8NAbse4gO9ezQ/4+C1ubxekIcy/20oLVeMNIT9HGieJQqW9c205A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a1idkH5qd0NH2E0Pwf83gb214G96FOO/0z1Jj0p+J+g=;
 b=Dod+HlkEsh8aBRHlOW693CDdEYwj3OK2mx0yv1NnUjZ+Nu9d3vtrMJUeQb4oXN225qCUdmzht/st0SOzvXcOn5UbIajyy3WKjnz/TGYFsh5D7UnFK9/6yCeFu7sh7oqm/3lsHjQXy04QfE6F2QLwmobR6irxK9fb50XJm4qz/InR0ieaQ01hT9Y7Lb42ZfTcYsOeX/slJVx2mljgH5YNIiLROM5LWiizB0QyvemTazyAYNHGAelNFMcX3ZAB8NURopFxhuvEzJzXSEHRNoVX1EYWrTBYGtExnIK/mW8V4H3jdetJmoozHyfHVeNv0/fDBKlGfuRI2CGgh7OHXVi7mw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB3176.namprd12.prod.outlook.com (2603:10b6:a03:134::26)
 by DM6PR12MB4356.namprd12.prod.outlook.com (2603:10b6:5:2aa::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.22; Wed, 31 May
 2023 00:31:37 +0000
Received: from BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::f6e4:71a5:4998:e6b2]) by BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::f6e4:71a5:4998:e6b2%5]) with mapi id 15.20.6433.022; Wed, 31 May 2023
 00:31:37 +0000
References: <3cece716fc09724793aa832e755abfc9d70a8bb3.1684892404.git-series.apopple@nvidia.com>
 <5d8e1f752051173d2d1b5c3e14b54eb3506ed3ef.1684892404.git-series.apopple@nvidia.com>
 <ZHKaBQt8623s9+VK@nvidia.com> <87pm6ii6qi.fsf@nvidia.com>
 <ZHXj/6Bjraxqk4YR@nvidia.com>
 <d2e591c1-eb43-377b-d396-8335f77acef6@arm.com>
 <ZHXxkUe4IZXUc1PV@nvidia.com>
 <89dba89c-cb49-f917-31e4-3eafd484f4b2@arm.com>
 <ZHYCygONW53/Byp3@nvidia.com> <ZHZuSDp6ioPqI272@google.com>
 <ZHaCAJI+OgIfDWSx@nvidia.com>
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
Date:   Wed, 31 May 2023 10:30:48 +1000
In-reply-to: <ZHaCAJI+OgIfDWSx@nvidia.com>
Message-ID: <87v8g9qr2z.fsf@nvidia.com>
Content-Type: text/plain
X-ClientProxiedBy: BYAPR01CA0033.prod.exchangelabs.com (2603:10b6:a02:80::46)
 To BYAPR12MB3176.namprd12.prod.outlook.com (2603:10b6:a03:134::26)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB3176:EE_|DM6PR12MB4356:EE_
X-MS-Office365-Filtering-Correlation-Id: 82d59cdc-e9a7-470c-8eb9-08db616e6487
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: epq3zai19LiAjCRW7zH3WmpU6Q6i9QNrBOYl7VqM1JQcekdgfkYon9ujFPwVjQ6XIvtLhDJi6ZPyUUKV3OnXNtrHX1aNRzprP5jcIbvoWLcJ+DQFEox2sa/Z7d3Bwcgft32AuQl/sXAzQEzqAHQgpPJBiRgZhjRFtvV1ShJq7KKxqQvdRFZt5ClWaL+PBoWMbQsj7NWrwUjZbSGKhKxOLyYQCkhNFBOM7GfqbSG2sxV/QNks+vhPGbjDoOBJm6YToyhUUMtiJ8BB1K8u5uhk4JQjF8Yf6EcODJKTmRX17Xc3maOewCeEIKc0dNt4JVc0V/rIuZLBjZl2gAE999XmUG4jdf4ueRlmaDaKCgzPHLm5IEEYf9S3xhDq7tWh/WLlw1Z2L7nANWKf/M3OBkS3STf9ZxROd1rkbyG4wtxYXnERAKFPIXBMEHxGb8xLkpd1bzPzGQEtjxMaMNUDBiLCgch2Lv4el6+A0gZAdvtjmIJLTWUAyMXqI99ISYyrhWYmJSIILLw1a4Vh7nP5fJA4tcfpG00fB6VBZNxS27zsM9Qw1mbRsAXGaq8f1mRcu+oo
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3176.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(39860400002)(376002)(346002)(136003)(396003)(451199021)(6486002)(26005)(6512007)(5660300002)(53546011)(6506007)(186003)(36756003)(316002)(6636002)(66476007)(66946007)(66556008)(2616005)(4326008)(478600001)(37006003)(41300700001)(83380400001)(86362001)(54906003)(38100700002)(6666004)(6862004)(8676002)(8936002)(2906002)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0/5r/wVqcoXkBHQIluUC3CjaiOYfoizfR71T9NcPnHasLlTbR/e+spsg4obA?=
 =?us-ascii?Q?4J92QUqSeBoLTA4xnVnjeoIP5BhPGnudkpnBdENhNO80QE6Di7/w0z1+lmMs?=
 =?us-ascii?Q?E+bTZG/ZX8GI0/7LlbV1uVeUeiVKO73mCRYCPguPeKEena5BU/nm3iEPh1rV?=
 =?us-ascii?Q?3vTeWDgKuHY1HlsXahsIJIYQg/48uHr7NCrbwFoeEXg3nynMcKBnNNsO59Ru?=
 =?us-ascii?Q?+Dv/j8qOgEph/1xbXrFvrhmIbNkL7c42hHVTHFMKSjrCQwqAd347wLG7FmYi?=
 =?us-ascii?Q?DHrDi0K5b1/uW/1g2LcZ3mYHeARrPBQOPd6SBrVyC+isK7CDpxReB6yAxfrZ?=
 =?us-ascii?Q?9HrQi3bgbmUflz5/3q+qLNa1i5TFG7cSzDgJxfuQzu7T5sQNoJTrvZay1Z9P?=
 =?us-ascii?Q?+ssdk1FbFAcykbgc5tzCsqebrEMrxCJDrBAOfMhGUJZL8oKlznjmA0Qj1SX6?=
 =?us-ascii?Q?0phsk84qX5p0SVNY4e622W+zPlTVl3a/CobrlRoRNsDcw5qDKXobkGXuqIQn?=
 =?us-ascii?Q?3Hnb0+PmO0SOigRQWaXT+8cwiAAH6K1+lYlqOewgS+nYfS05JSBKIdqArnHS?=
 =?us-ascii?Q?A5L2/BWGl6igIOgRs/Z5xE11u8HrVJkoEJ1NIh+6UeH1ejUE6gPWDYHqOvqN?=
 =?us-ascii?Q?O2xm/tH1CBGMpOdh7fMZSwEm9RSKDZ7LFuLvouXWlBIBDuztLsU25llDMfZ1?=
 =?us-ascii?Q?23C0oOy6XD/vIp7Gz1uG8kUC+QhU/r52rd8gSulx8XEAhG7q5+wm95XltGsN?=
 =?us-ascii?Q?mH6OZ3F59x36N4zAHeHtcDG0u4+EZGcXKOmJWcSJ3qWW6mm29eT3YoWWg/8M?=
 =?us-ascii?Q?ypZDDwG8kDH5kLw5XDWd8V4bGDPemctoxqTSuWWlbGGlazGWjvF2YDVA1OJS?=
 =?us-ascii?Q?BHPrFYx7YeNbiG0RQKWFVUrPWmqANaL2CfBoqJGg9JmAGHKukyQPVX3KswlD?=
 =?us-ascii?Q?ezGa4cQAs2D1YJzT82re4g3V/BLs7OfjQj7zSdgZJb2GP7z2TkPwXucuUx6+?=
 =?us-ascii?Q?eAQqLuNPUJIq9ViIb4KP9w56Ez7CHY4it9inR3clVnIA+kbEcJgHJMbCEidP?=
 =?us-ascii?Q?RaOzHYPeSdhKkzVoW81s1X0931Em9LASxPR9YZ47d2Ct5Ayuai16H73QA8KF?=
 =?us-ascii?Q?T/tY3/8yxJ6wb2MFTdAl36oODsqx2Q19SP1YEp99kofoEj7oP4QiyqRo3SIA?=
 =?us-ascii?Q?8IEgFBFWe+injf7jOXwEho0hVTsIDeQ6ERCaioPMhgUoKrI3lwGWiYw/zUr3?=
 =?us-ascii?Q?UZNViZBU3hD7abV4QUfPFBxPg+qqOnfeuVyd4RxIImoDHb+olt5oMd0BtUW8?=
 =?us-ascii?Q?cAcQKpiZk6JWaotoXyxG0qcLjRWkiyu9D3Eil4Fg+Ynv8qDBglvppaywY3D6?=
 =?us-ascii?Q?DEoI++OomG2BtDL2icHUy+nfQ/S8W20vMiPjZJINaJrPKIc1YSz+YOuxDAfZ?=
 =?us-ascii?Q?djI7bFFO9Errhx5VhIVMYbjnpAhFET0xsuLHO/CHfnubZhYEmyrDLpLOSyxC?=
 =?us-ascii?Q?rb9qKb50iRmPbfuN+xy7be+Ahwn+1pDYRFBjB7PBG4PwS4P/ZWluo5+jwBCw?=
 =?us-ascii?Q?n9dU6Fnbluk7O4ernBO2QFNUjDoK1csS/Mpgqm4f?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82d59cdc-e9a7-470c-8eb9-08db616e6487
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3176.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2023 00:31:36.6755
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CBcKH3EwLBxynIE1NZrM89OGK4QilZQkVDfecT6TpbTMWfuJflBMlq+EnEyifQibHX5CddnRrUkOl9HymxqpOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4356
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

> On Tue, May 30, 2023 at 02:44:11PM +0100, Robin Murphy wrote:
>> On 30/05/2023 1:52 pm, Jason Gunthorpe wrote:
>> > On Tue, May 30, 2023 at 01:14:41PM +0100, Robin Murphy wrote:
>> > > On 2023-05-30 12:54, Jason Gunthorpe wrote:
>> > > > On Tue, May 30, 2023 at 06:05:41PM +1000, Alistair Popple wrote:
>> > > > > 
>> > > > > > > As no notification is sent and the SMMU does not snoop TLB invalidates
>> > > > > > > it will continue to return read-only entries to a device even though
>> > > > > > > the CPU page table contains a writable entry. This leads to a
>> > > > > > > continually faulting device and no way of handling the fault.
>> > > > > > 
>> > > > > > Doesn't the fault generate a PRI/etc? If we get a PRI maybe we should
>> > > > > > just have the iommu driver push an iotlb invalidation command before
>> > > > > > it acks it? PRI is already really slow so I'm not sure a pipelined
>> > > > > > invalidation is going to be a problem? Does the SMMU architecture
>> > > > > > permit negative caching which would suggest we need it anyhow?
>> > > > > 
>> > > > > Yes, SMMU architecture (which matches the ARM architecture in regards to
>> > > > > TLB maintenance requirements) permits negative caching of some mapping
>> > > > > attributes including the read-only attribute. Hence without the flushing
>> > > > > we fault continuously.
>> > > > 
>> > > > Sounds like a straight up SMMU bug, invalidate the cache after
>> > > > resolving the PRI event.
>> > > 
>> > > No, if the IOPF handler calls back into the mm layer to resolve the fault,
>> > > and the mm layer issues an invalidation in the process of that which isn't
>> > > propagated back to the SMMU (as it would be if BTM were in use), logically
>> > > that's the mm layer's failing. The SMMU driver shouldn't have to issue extra
>> > > mostly-redundant invalidations just because different CPU architectures have
>> > > different idiosyncracies around caching of permissions.
>> > 
>> > The mm has a definition for invalidate_range that does not include all
>> > the invalidation points SMMU needs. This is difficult to sort out
>> > because this is general purpose cross arch stuff.
>> > 
>> > You are right that this is worth optimizing, but right now we have a
>> > -rc bug that needs fixing and adding and extra SMMU invalidation is a
>> > straightforward -rc friendly way to address it.
>> 
>> Sure; to clarify, I'm not against the overall idea of putting a hack in the
>> SMMU driver with a big comment that it is a hack to work around missing
>> notifications under SVA, but it would not constitute an "SMMU bug" to not do
>> that. SMMU is just another VMSAv8-compatible MMU - if, say, KVM or some
>> other arm64 hypervisor driver wanted to do something funky with notifiers to
>> shadow stage 1 permissions for some reason, it would presumably be equally
>> affected.
>
> Okay, Alistair can you make this?

Right, I agree this isn't a bug in SMMU. I could add the hack to the
SMMU driver, but it doesn't address my issue because we're using SVA
without PRI. So I'd much rather update the MM to keep SVA IOMMU TLBs in
sync.

So I'd rather keep the invalidate in ptep_set_access_flags(). Would
renaming invalidate_range() to invalidate_arch_secondary_tlb() along
with clearing up the documentation make that more acceptable, at least
in the short term?

> On Tue, May 30, 2023 at 02:44:40PM -0700, Sean Christopherson wrote:
>> > KVM already has locking for invalidate_start/end - it has to check
>> > mmu_notifier_retry_cache() with the sequence numbers/etc around when
>> > it does does hva_to_pfn()
>> > 
>> > The bug is that the kvm_vcpu_reload_apic_access_page() path is
>> > ignoring this locking so it ignores in-progress range
>> > invalidations. It should spin until the invalidation clears like other
>> > places in KVM.
>> > 
>> > The comment is kind of misleading because drivers shouldn't be abusing
>> > the iommu centric invalidate_range() thing to fix missing locking in
>> > start/end users. :\
>> > 
>> > So if KVM could be fixed up we could make invalidate_range defined to
>> > be an arch specific callback to synchronize the iommu TLB.
>> 
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

I'd be happy to look at that, although it sounds like Sean already is.

>> FWIW, PPC's OpenCAPI support (drivers/misc/ocxl/link.c) also uses invalidate_range().
>> Though IIUC, the use case is the same as a "traditional" IOMMU, where a device can
>> share the CPU's page tables, so maybe the devices can be considered IOMMUs in practice,
>> if not in name?
>
> OpenCAPI is an IOMMU HW for sure. PPC just doesn't have integration
> with the drivers/iommu infrastructure.

Yep it sure is. I worked on that a fair bit when it was first being
brought up. It doesn't suffer this problem because it follows the PPC
MMU architecture which doesn't require TLB invalidates for RO/RW
upgrades. It's a pity it was never integrated with the rest of the
driver iommu infrastructure though.

>> I have patches coded up.  Assuming testing goes well, I'll post them regardless
>> of the OCXL side of things.  I've disliked KVM's one-off use of invalidate_range()
>> for a long time, this is a good excuse to get rid of it before KVM gains more usage.

Feel free to CC me, I'd be happy to review them and can probably help
with the OCXL side of things.

> Nice!
>
> Thanks,
> Jason

