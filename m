Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C58367D0B97
	for <lists+kvm@lfdr.de>; Fri, 20 Oct 2023 11:24:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376679AbjJTJYg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Oct 2023 05:24:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376659AbjJTJYd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Oct 2023 05:24:33 -0400
Received: from AUS01-ME3-obe.outbound.protection.outlook.com (mail-me3aus01olkn2179.outbound.protection.outlook.com [40.92.63.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B012CD57;
        Fri, 20 Oct 2023 02:24:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DnFjxroFIgbYeZ4x0EPCYSzzYcBfSNFNVb4Am/DwC+LPT7pNAKjZxFS1OTCiYAUw5tX0c48I1iTHDKEOij6/wLoG0Qw0Fp8nwP+VYHXxwiJQxvfDUHc4fw4p3dN6FbSnmOR2SjZGEnm8LKRNQv3OSAeu3jIgVw6/VAUO3+5mK5ZsQ5k9LnaFgQE7xHFwoFdCRpnKq9qBJzT+YEe2sFhH+e1Nsk85PZB84DuhFZieGsStBHZRhySWbEvaWoU+ztULrUXDANHxdv9gzygkPUgeaYV6eZ8W6YDQ4WuD4cTqJwG9ZK4MSNAxYKwK/C7Ad6iW7rGSqTK32CovGqlQr0AaOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hjd54qI8ZxXJcpP229dyBk33amg3RvMFL4iyPlgR+Oc=;
 b=d1jPpNAQzGcCFx0geVtImXz8vjiucbSj36vqTIXTuE4puvyOC2g2DirUadhobBJIkmCEgwQV0wTX3G19pCqf0eGDHwhaCSmyhH84lJNXkG2w0pjuc0hqEZPCKRcjcrs+xOY1XJAGIYgbq+eIQldMNxolaiLM1/59PcWq/Wj7tsPrMmc0OXGg03+15hFglIEm43uYpkhfpmt6nniUPr3s1V5ZpnErkzMgdDz51Kj9y1k2f5j23X87qklrvXVDEXWAsvvcrYKsICr2MY9LcKKNoEU+DxlrLM7GdhalCHQ/X12c8WzdMT1B1rnJwhojv0JwIj6VuFmanBjQm2khQ1EX7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hjd54qI8ZxXJcpP229dyBk33amg3RvMFL4iyPlgR+Oc=;
 b=aY4cBmeBtPnaWlrW0C6ki2ptAnRNAdH/1G51qU6kawZOQ85sT8X+LVl3CF1tSiDMsfO1RLlgzXZHQmn2EFDGC0oIn0x0dCYrJLHQSbbOAcHl6hTdss8cexwefJEue+h8EiZbfaoRtqKVO6y3+d5+ga76Z7V0TIcfPNH4a9MDNy1MU9OZLm5LuIUNcrlOFVZgKIbMPKEHLO7urL6Api+u2Topi67NlpyCteYNFdGGMMl6iRHftrAoxvzBJrd+DbVB6/37MBi9KiSBHuvvhvaDzAEp/t3t309sFfc3G6dNMCrQkta+IWG6Gig+AesI0dL10WdrR/QAYIVt815W+GfK3w==
Received: from SY4P282MB1084.AUSP282.PROD.OUTLOOK.COM (2603:10c6:10:ac::13) by
 SYYP282MB0752.AUSP282.PROD.OUTLOOK.COM (2603:10c6:10:71::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6907.24; Fri, 20 Oct 2023 09:24:22 +0000
Received: from SY4P282MB1084.AUSP282.PROD.OUTLOOK.COM
 ([fe80::e39e:17fc:36d8:1ea8]) by SY4P282MB1084.AUSP282.PROD.OUTLOOK.COM
 ([fe80::e39e:17fc:36d8:1ea8%3]) with mapi id 15.20.6907.025; Fri, 20 Oct 2023
 09:24:22 +0000
From:   Tianyi Liu <i.pear@outlook.com>
To:     mark.rutland@arm.com
Cc:     acme@kernel.org, adrian.hunter@intel.com,
        alexander.shishkin@linux.intel.com, i.pear@outlook.com,
        irogers@google.com, jolsa@kernel.org, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        maz@kernel.org, mingo@redhat.com, namhyung@kernel.org,
        pbonzini@redhat.com, peterz@infradead.org, seanjc@google.com,
        x86@kernel.org
Subject: Re: [PATCH v2 0/5] perf: KVM: Enable callchains for guests
Date:   Fri, 20 Oct 2023 17:21:14 +0800
Message-ID: <SY4P282MB10848CE48E2605CFC347AD659DDBA@SY4P282MB1084.AUSP282.PROD.OUTLOOK.COM>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <ZSlNsn-f1j2bB8pW@FVFF77S0Q05N.cambridge.arm.com>
References: <ZSlNsn-f1j2bB8pW@FVFF77S0Q05N.cambridge.arm.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-TMN:  [7UYIq8jZ07p1gQm1ShB5cGTFWmfZC1xVwcqfbEFDarFrrPHiHOoaHw==]
X-ClientProxiedBy: SG2PR06CA0203.apcprd06.prod.outlook.com (2603:1096:4:1::35)
 To SY4P282MB1084.AUSP282.PROD.OUTLOOK.COM (2603:10c6:10:ac::13)
X-Microsoft-Original-Message-ID: <20231020092114.143091-1-i.pear@outlook.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SY4P282MB1084:EE_|SYYP282MB0752:EE_
X-MS-Office365-Filtering-Correlation-Id: c2a82c67-8639-474c-00bd-08dbd14e5848
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2rRP/srRHzBw69owbbG2s3utbEq7wKBdm7bRIqSwihVWmHwrEx+xUpRYgjMAikvSq5kKoGv3CT2Bvt5FeMAZ+hAwdKwQxGskapzVnnEZI02+2DxF38nMciTAwL1bYvn44lW1t1rhsEIeXz+qsDoVujRhIafe0W89lt6+fAx1jKSPNKe59tW9PMfQ48VZHzuUxs/Ni0ORQJbumtLDMGd3cM339CKzCMkZOFHwKWkfKt8/ceWsOGzhBWEtuIwGqLRxYiEhW7Exvx8Lyf9RD4QVE/SDVvYutFzJHsHNRp5FtCD6LWwnDenrCsdAJLYW/uwq+JXWqegys5ZHncZuYvIFagt+eezxTHKlKVPLIOiObXtRRatsDXnEs5xZe2cIQkgE/3CwgxBwBozG0SGU6l6QtbABI0qYWzegYbMdu6ewlsE4P7zaW79d8GqNVmN486JDtSnf0vW501ZKEaF9gyvPtL53+4fZmi5qtLTE/xG/3Jg3q6X4cKhwsmRDM4JWQ2T7w20r4BfqdVUU7g+s/dKphSWZ4Mv9kiR1IyRP2MSDGnVPxydKr4LRIQ2FzO5frjMYOLbQ+XXG8R+YLeeDvTrJvuigcMxpAqztDjXTgLIVue9A26ewiYqXI0rq/mG8iS76
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vK5oGDU6pZTV9NZEMYjjL2VXpKxHeh8w3wESNiSCapJfFRLRxN+GVapxOVJl?=
 =?us-ascii?Q?wWkfa8bsK8fvxKj3KUmGHhzwftE05bFwyD/YCu6546yvdZVSWEngAyliG21O?=
 =?us-ascii?Q?6cU1GkA0TFtayZzBRyDD4UBgJOrjkggN26c3k4eOldpN81rlUtWtXjdrojBi?=
 =?us-ascii?Q?wUUpusOrAHWH5Epl4INEfZYETB4rfLr8SJija+R28eJDRmYwmiRffN0ac3Wi?=
 =?us-ascii?Q?Hq26VTm7rS/9tmBMYK+EdOyKEb9HhZqCLhXh3VIJzOriVDZHY6AB5jQe1fsC?=
 =?us-ascii?Q?PFNprDYtyQrXaEkxnSybIUMAP0t9AaeCzptkuUqgqgqL7hEsEJuw6YPNmIZ7?=
 =?us-ascii?Q?iw0G08TRez9wiYSkY2IjBUkLpcD+NaT6TZlSDUIp2zWiGmOH91WRWyTlD63A?=
 =?us-ascii?Q?peeg82/S8c5gXnKQDCjNqE9G+3rCWAilA0T0ijMH4c5TyncB65YWENKdEQIo?=
 =?us-ascii?Q?7gZe/EBxppsYUOvS9E948rKPaDnCGBGiXUqWxXhWIUe/1UaOU0FBeuHPZqxZ?=
 =?us-ascii?Q?NXkX9DjxUjllGHRcz8xoCbCkCcU2JM9reCIKn0+HWpn0j/9AiKpUdnnbXS8a?=
 =?us-ascii?Q?7Z4r+wT/foJnMrQ1O8/SuuSFVsyxHSEaGYvQNJAg+GQOWVJ6PrdtsnBjHLvd?=
 =?us-ascii?Q?1Qu4GUDY3PcyHdu+9QYuKOEuVl7i/vENXMvlfo5mrxuSlDJObmeKl9VNthOr?=
 =?us-ascii?Q?ckAFgh23W3E7R9HjQx/DBxzTwBg2soGv1Lp++N7jEaGzFTCIsYMEXDefiHBS?=
 =?us-ascii?Q?Kl3VLr+n29rj6DzFWUOqAT6Md3TZARmzZ+EofUp/YCcrI+AIdSKqoP55XdVG?=
 =?us-ascii?Q?SXUFNL2mGnGAekbc7+sJ7qNJBL2Yme+CZq6yjZ9Kto+zbqYAXMrOQbSXWhzd?=
 =?us-ascii?Q?+hdF2buLyh499LwKc7bUnq7/Oqw1HwIZgzbOs5oKFpH4I7PwzRIl1Uj2xYWA?=
 =?us-ascii?Q?hQxm690c20d0galxWYu/aCX429ubhtpn0GN+vZH0yDqrYEEb2eYP7cODXlSE?=
 =?us-ascii?Q?kdeZ09O90emfEqKO+y366iDQsCmnoy83mHA7ZOvf4W3NRo4py/KIgePcPFAp?=
 =?us-ascii?Q?gn8pPLDM+s5BCJkU8JaVM9E8niveSob6iMwzLrvfq+UY1GNPpXqC0PJldXXc?=
 =?us-ascii?Q?JH7s6nDkyziwLU+h0Re7e1YXiukllRNp3P3N45m+M5bcmziFkZHSltxPTFdq?=
 =?us-ascii?Q?m3MRt3EFld2VOLBhJ3nbkNPmhz2ptXziV991S3T2U4mrEOGSADMopz1Fmkit?=
 =?us-ascii?Q?T1CZGQfR9PuiWhYCGM8S?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2a82c67-8639-474c-00bd-08dbd14e5848
X-MS-Exchange-CrossTenant-AuthSource: SY4P282MB1084.AUSP282.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2023 09:24:22.6958
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SYYP282MB0752
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Mark,

On Fri, 13 Oct 2023 15:01:22 +0100, Mark Rutland wrote:
> > > > The event processing flow is as follows (shown as backtrace):
> > > >   #0 kvm_arch_vcpu_get_frame_pointer / kvm_arch_vcpu_read_virt (per arch)
> > > >   #1 kvm_guest_get_frame_pointer / kvm_guest_read_virt
> > > >      <callback function pointers in `struct perf_guest_info_callbacks`>
> > > >   #2 perf_guest_get_frame_pointer / perf_guest_read_virt
> > > >   #3 perf_callchain_guest
> > > >   #4 get_perf_callchain
> > > >   #5 perf_callchain
> > > >
> > > > Between #0 and #1 is the interface between KVM and the arch-specific
> > > > impl, while between #1 and #2 is the interface between Perf and KVM.
> > > > The 1st patch implements #0. The 2nd patch extends interfaces between #1
> > > > and #2, while the 3rd patch implements #1. The 4th patch implements #3
> > > > and modifies #4 #5. The last patch is for userspace utils.
> > > >
> > > > Since arm64 hasn't provided some foundational infrastructure (interface
> > > > for reading from a virtual address of guest), the arm64 implementation
> > > > is stubbed for now because it's a bit complex, and will be implemented
> > > > later.
> > >
> > > I hope you realise that such an "interface" would be, by definition,
> > > fragile and very likely to break in a subtle way. The only existing
> > > case where we walk the guest's page tables is for NV, and even that is
> > > extremely fragile.
> >
> > For walking the guest's page tables, yes, there're only very few
> > use cases. Most of them are used in nested virtualization and XEN.
> 
> The key point isn't the lack of use cases; the key point is that *this is
> fragile*.
> 
> Consider that walking guest page tables is only safe because:
> 
> (a) The walks happen in the guest-physical / intermiediate-physical address
>     space of the guest, and so are not themselves subject to translation via
>     the guest's page tables.
> 
> (b) Special traps were added to the architecture (e.g. for TLB invalidation)
>     which allow the host to avoid race conditions when the guest modifies page
>     tables.
> 
> For unwind we'd have to walk structures in the guest's virtual address space,
> which can change under our feet at any time the guest is running, and handling
> that requires much more care.
> 
> I think this needs a stronger justification, and an explanation of how you
> handle such races.

Yes, guests can modify the page tables at any time, so the page table
we obtain may be corrupted. We may not be able to complete the traversal
of the page table or may receive incorrect data.

However, these are not critical issues because we often encounter
incorrect stack unwinding results. In fact, here we assume that the
guest OS/program has stack frames (compiled with `fno-omit-frame-pointer`),
but many programs do not adhere to such an assumption, which often leads
to invalid results. This is almost unavoidable, especially when the
guest OS is running third-party programs. The unwind results we record
may be incorrect; if the unwind cannot continue, we only record the
existing results. Addresses that cannot be resolved to symbols will be
later marked as `[unknown]` by `perf kvm`, and this is very common.

Our unwind strategy is conservative to ensure safety and do our best in
readonly situations. If the guest page table is broken, or the address
to be read is somehow not in the guest page table, we will not inject a
page fault but simply stop the unwind. The function that walks the
page table is done entirely in software and is readonly, having no
additional impact on the guest. Some results could also be incorrect.
It is sufficient as long as most of the records are correct for profiling.

Do you think these address your concerns?

Thanks,
Tianyi Liu
