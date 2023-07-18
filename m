Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 778287589BA
	for <lists+kvm@lfdr.de>; Wed, 19 Jul 2023 01:54:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231716AbjGRXyd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jul 2023 19:54:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231713AbjGRXyA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jul 2023 19:54:00 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2062d.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eb2::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93BFC2125;
        Tue, 18 Jul 2023 16:50:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dAPLunpmoTGbc5X7ebNQm5/k44nkLmU2GtVKoOaq3cx/ZMK8FPZX82z7o1RBXdGtbuKNYlJg4XFbwgQXxWysOoZgTP4ZARd1HgHQGc6zj0FMVRYcP6Vp6Gass3yiXWJAOv/AZ8KXvhVGcvD48Az7SItvA5VZRNnzXnPhRhjetuWK4ypzipryMuDi7JtU6d5lGG1cJBE647x0EjgRkhw/1cbzrOzt9FuYGXu4aYaJqQvN2qENvKskxecE9tGmkwH9EA4p4HA+Nmcr3D/ZAMAbyTuozJnc/5zvNnnWNGr+OIkKn0bRHR10i6X7Q4ucUk79DbLAZ1m5aAlWNitARNx9pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mrn6D6SoRhcvmAHJASm/gIoOJXoIm08P3y5EpKvVA2A=;
 b=Zv6W6AaZjE0Ww3s1b17qpDsYyB7vvoC5cG2jzpMkgP8c6oDchK0R/Kd/ADHM9RO6ybn6+gNjKNHYV/c6FSQRQ7X85V34X966n6YHibRtz86IJaxyhtaNBLRBAQpTrkh0xWl2WVdbGrpYdTTn+FYpDTPtjRU0/ronPUiiUb5J/e5ma47gKpuWgSfGnDH6rlHqrxVyq87H5/mbqwQuMKPvHiJ7G7Mnos111f0+LvtRgKOzFARuotbgpGL83wUJsNDxd6Bi2m1yIcbbfdaLkQwRAOvv4H6GIDiJDcTgMaQ38oxMy4y0ukiQaaqgasyXrngP2aZ/i3wrjpkHPSbnra0P+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mrn6D6SoRhcvmAHJASm/gIoOJXoIm08P3y5EpKvVA2A=;
 b=nb8rakvUJBE5nBwQNiYksQGlK6vWJLV0LpQWZgLidqXWHhbdP45S3+BYfWqVSqN0mzHVxKvdHAv+iXmpEuwQ015MANy4kTLH2VBIOvMMoK+8eotuM7dfFfFFk/UYYF/arPt72A540p2izeP7sErW/0vi1kJ594svfp+vbAMZxXQ519zCajKW457ku+fr2pHr0SCds+TwhgL7bYxCz62JEo/TpRf++aFGfoDXibzk4TQi1NVwUC6c3P7hKrKig/7SHnEEmlMSRG+xu2u1LF25IAZ6I/xc24JTrthFgJFeLB3nweKxqbBEmJ67j2rh/5jPCssDIRyEsvgA7brr96q3fQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB3176.namprd12.prod.outlook.com (2603:10b6:a03:134::26)
 by SJ2PR12MB8781.namprd12.prod.outlook.com (2603:10b6:a03:4d0::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.31; Tue, 18 Jul
 2023 23:49:36 +0000
Received: from BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::cd5e:7e33:c2c9:fb74]) by BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::cd5e:7e33:c2c9:fb74%7]) with mapi id 15.20.6588.031; Tue, 18 Jul 2023
 23:49:36 +0000
References: <cover.b4454f7f3d0afbfe1965e8026823cd50a42954b4.1689666760.git-series.apopple@nvidia.com>
 <c0daf0870f7220bbf815713463aff86970a5d0fa.1689666760.git-series.apopple@nvidia.com>
 <ZLbSeO+XjSx1W795@ziepe.ca>
 <20230718113620.fb29217344238307c3be76d7@linux-foundation.org>
User-agent: mu4e 1.8.13; emacs 28.2
From:   Alistair Popple <apopple@nvidia.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>, ajd@linux.ibm.com,
        catalin.marinas@arm.com, fbarrat@linux.ibm.com,
        iommu@lists.linux.dev, jhubbard@nvidia.com, kevin.tian@intel.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linuxppc-dev@lists.ozlabs.org, mpe@ellerman.id.au,
        nicolinc@nvidia.com, npiggin@gmail.com, robin.murphy@arm.com,
        seanjc@google.com, will@kernel.org, x86@kernel.org,
        zhi.wang.linux@gmail.com
Subject: Re: [PATCH 1/4] mm_notifiers: Rename invalidate_range notifier
Date:   Wed, 19 Jul 2023 09:49:07 +1000
In-reply-to: <20230718113620.fb29217344238307c3be76d7@linux-foundation.org>
Message-ID: <87o7k8lr06.fsf@nvdebian.thelocal>
Content-Type: text/plain
X-ClientProxiedBy: SY2PR01CA0016.ausprd01.prod.outlook.com
 (2603:10c6:1:14::28) To BYAPR12MB3176.namprd12.prod.outlook.com
 (2603:10b6:a03:134::26)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB3176:EE_|SJ2PR12MB8781:EE_
X-MS-Office365-Filtering-Correlation-Id: dfc97c43-3907-419a-04d8-08db87e9a483
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: R3vSaSgrSzD++uludQwY8jGbD2nunvh4lCEOjmvofc04550eo1/O45OZxwSa8NIwukKEMHbd2NRT7tpXerYVnvN7U4Cml+gbJx1akCVKN1a5y4g4+zsV4pISmXPxgVyXPPBCRX7zlqwOyiJxPcKbSQLQ+cjOjeK/BZaJdfL5Jv25izxgWeTgDD5f0KOAXURkP1mCm4fqMgShIeaFk5ejdwWj4YmOhQIsX659nsaozcebEulPWQC8LoLrq8HFpkyk7B+gL6EqXtoDHh4m0OSOCbMHyv3gaz+cvFIjHlfooKVQj7KgMDiwyQXoYbxUFB91F8ZCDYilVQnIUChEAUNqrQEIZfFDRFRaJaC178X4irUp0ZIG+uTm3ewuM457mMPu0hcbf2IgUmnQ/xs4Tbp9Gtbye7SPX9rJvf0m0ar4Ci2sBJ1OPSXUPNJBO089b7ppBqJIJeXpD3QN8m1U1zndPvsSwRGPOVMUFoQ+RLiHktBAZGFcruo6soXzwFhpKvxlqHkiJj3Kuua6xYa/7UVuBFSHVASW0Cgxu7DfczvHCOdiBaaTaBSOjU3Bi+ggMhgm
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3176.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(366004)(346002)(136003)(39860400002)(376002)(451199021)(2906002)(478600001)(6486002)(6666004)(8676002)(7416002)(4326008)(6916009)(316002)(66556008)(41300700001)(66476007)(66946007)(8936002)(83380400001)(6512007)(38100700002)(9686003)(86362001)(186003)(6506007)(26005)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QWgzXg0Bofz9MnT3fd4dcjn+/PojRfEPShcITF1cMTwkaCNOqbqMtvdwokVu?=
 =?us-ascii?Q?Wm2xVxF4kc0E9ENSgaNbEVS84BCQqUiyFydZ8IM3BsYLRIGjzwF+vQtCzMTK?=
 =?us-ascii?Q?xIp8DHRZVfDDCC6JeR/5ed4YW7oshqp6usuQWS0rNJ+fQcEe71gkewn6Ssvz?=
 =?us-ascii?Q?wPNkNQ3axMCGnbeGHbqMoIpi2PQSd1etDOM9UvfA4MfdMfTZnM390FbhrMVh?=
 =?us-ascii?Q?N3tm4stULn2Hnf2MvSV8VjF+qwNtxJHzE3ty/MrPbtRf5EIurCvDwwp9zaz8?=
 =?us-ascii?Q?bJHneJYniAzbaGujDtlE5xAbJ3GT2WIt5sEWdFlttYFxi8CuIbnNH5jFOJiX?=
 =?us-ascii?Q?3WhsFRi8PuMbbzQxu0869JRdRefCLUC0eeT9gBIo0bShk8ekN5rbNocnj2AU?=
 =?us-ascii?Q?O8BYz9LsG8IqpxGOMz8K+X1Y6sjCpJ//PEQ9/QqFhfG+++wdnOvR8Cp3pXfp?=
 =?us-ascii?Q?kusmNioISlDhRsSGIol5mmwg/v48cbHveAfMkN6QsXiTqyZvobc0KovVY31Y?=
 =?us-ascii?Q?jRZBErSSmkPYW93KZx5IlqtNt5UtWeW9OwXo5EcMHojoGyWNChkhXlh7CZ+A?=
 =?us-ascii?Q?IxlMUiX4s7Pox4EeW81rXcLLa1Zmc568odGOZCSeD1o+oxtLUrmufLzyQtws?=
 =?us-ascii?Q?597Yt7O0nlh1eBLppdSxB2/AuMMu9vozGdvUTEuE5ApESXz97tVxkScqgj5N?=
 =?us-ascii?Q?iDgy9JfglFlRIuX4q13XIPMWzv/gMzZXPiqSCssA4Yp3WcLsR1ZXYV+fVhyR?=
 =?us-ascii?Q?wrrokmfqE2RaPCT/FkPXxBRqx8eQdKiV0wLjtSnvM7/rwrY61JzT3bo/Q7jc?=
 =?us-ascii?Q?N/Ofshrxd2crq5WwvsAZ+4z9CKwSCIt2dO93VIXkuu7pfbTnVlprR9gkErdx?=
 =?us-ascii?Q?JDbsWsgb7nOpRZNaXZk238lBR293dfuD+oOLJiAvftFSGU88NJuigjf4CZdD?=
 =?us-ascii?Q?Oyl6jVoJa+YRpd4WAiiMTOKoxo474wFYf/HDgN76H8IKxubH0HlW+XccHUMM?=
 =?us-ascii?Q?7AoLbbxt6oHtPd8liSWhmdzO3nrP8dUIhDMBLt34/5CUdRXu7awa2MHLpSFX?=
 =?us-ascii?Q?u8u8fie12Sio1rCVT2neoQH4xLWQC8rTfOlZwinpyP3Qo2cbZKDSCCxe0cfT?=
 =?us-ascii?Q?QFtmexTUhNgBhSQLSfs6z9swN4UC+UxQxDcTevttIv+RMI5DJwYumkahAvD7?=
 =?us-ascii?Q?Bbee6Ic0tGH7Xv0KQwN4x8Q+rdoKJ92k/35jk87hhBnW3wHi5jUY3wym9EVY?=
 =?us-ascii?Q?58Qq4BqSXvU8B59iqef5468+JdmSoyhpsq3nzjkSqlnW1PQvyBUMMrdRXM+A?=
 =?us-ascii?Q?2O5xcgwE3kLEcIawJJ9U8kVBUgPNcKlB6tMwGWDTxRDvWT33zFPQSgY6oOTK?=
 =?us-ascii?Q?qLNn3YNAJ9ZRuX8C/omKF1LMQALyO7Jl0GOUDgw7DlT+PkFWYaTnzDN4Gb4f?=
 =?us-ascii?Q?hEjJa6PT4KEEk9Qkm0/khHpFeEA6QZ/wdGh99f60bL3eTLTdpZl1PqYZiHWR?=
 =?us-ascii?Q?/+0OWwlNXxoroJ5NuT/432Sr4V6EeeZaXHw0Mwi49N6IqdApVSw4m+Fg25kf?=
 =?us-ascii?Q?3Fjdi1b+KpglRAgraw173yLjGfD/ZiTHilFByBuK?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dfc97c43-3907-419a-04d8-08db87e9a483
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3176.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2023 23:49:36.1713
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Akzwb99bLLKLfxt5kFFzquMQ41Uvluz1U33QXpQ/VWPzb8MYPCEZpsA2s9cUAMGUy9zpmtc42LLlashuP/zw+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8781
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Andrew Morton <akpm@linux-foundation.org> writes:

> On Tue, 18 Jul 2023 14:57:12 -0300 Jason Gunthorpe <jgg@ziepe.ca> wrote:
>
>> On Tue, Jul 18, 2023 at 05:56:15PM +1000, Alistair Popple wrote:
>> > diff --git a/include/asm-generic/tlb.h b/include/asm-generic/tlb.h
>> > index b466172..48c81b9 100644
>> > --- a/include/asm-generic/tlb.h
>> > +++ b/include/asm-generic/tlb.h
>> > @@ -456,7 +456,7 @@ static inline void tlb_flush_mmu_tlbonly(struct mmu_gather *tlb)
>> >  		return;
>> >  
>> >  	tlb_flush(tlb);
>> > -	mmu_notifier_invalidate_range(tlb->mm, tlb->start, tlb->end);
>> > +	mmu_notifier_invalidate_secondary_tlbs(tlb->mm, tlb->start, tlb->end);
>> >  	__tlb_reset_range(tlb);
>> 
>> Does this compile? I don't see
>> "mmu_notifier_invalidate_secondary_tlbs" ?

Dang, sorry. The original rename was to that but then we added *_arch_*
and I obviously missed some of the already renamed calls.

> Seems this call gets deleted later in the series.
>
>> But I think the approach in this series looks fine, it is so much
>> cleaner after we remove all the cruft in patch 4, just look at the
>> diffstat..
>
> I'll push this into -next if it compiles OK for me, but yes, a redo is
> desirable please.

Yep, will respin.
