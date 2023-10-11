Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3D247C573C
	for <lists+kvm@lfdr.de>; Wed, 11 Oct 2023 16:46:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232650AbjJKOqW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Oct 2023 10:46:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232256AbjJKOqU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Oct 2023 10:46:20 -0400
Received: from AUS01-SY4-obe.outbound.protection.outlook.com (mail-sy4aus01olkn2174.outbound.protection.outlook.com [40.92.62.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68376A7;
        Wed, 11 Oct 2023 07:46:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O0S2LN1qew1id2a2kCj3HalObHIPLAobb2qS4l5pA5rT+la4Fdixj3mmFkvzD9X+Lv2aTlLOx2Ipf5SWtnDJJnCLVDxsMXkg4PwP0+pG0+jvmpQEGJFzeaNxQvfZ9N+D+bOcs1t5HwqEgzIN8xTz1czPJ2EFJOh1JHZOO5vVH+QS9aVqaULPkCmeRqp0kn1C3OpnapMphJbx2ZsuV5JfUr7DgEVjhJZKbiRIEiHSplKalaptecxD30G+syIft5zWeOtu+/fhgjlg7rxYHbpHbSVCMkg1gJumm3z7lgN0ZMMSpN99efERMu6LDEYsYZNd/9m7RDGvUuPYsWPnyPwA9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ta3ROJZdl/t6UE4QZQyhhLeXJ7Wu3sqihRLvCP6OBh4=;
 b=J3wimk/lCkO+3j2+gcJ5s1GdHRsICtajCTdVafBOz2EVDssIKAwsFciTAnah5/dqU69ofvSCs0MDQEqFshizEK5mcm19pwlsP4SELlNLBx6X8mnfBdL9ICyJ9g5xvDcRpw3+j6sSwNc5MCHKw+q/Xg+lRSeobO1m674OZd2rQl01ugP09xcIZD0hb9Bxer0yUlr6fOi1Yke4zztBkIXN3nme4yjuboOMbMxynz+hGLj2hpz7X2VnAew6wUxB7ckp75vMd/2SHtsu2lD4xZfSIeX3S8hHecqNJZ2nWmv8ojKVuIjs5nz83n/qnrhMp1bb1RMc3ny1EJmBPlReS+GeYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ta3ROJZdl/t6UE4QZQyhhLeXJ7Wu3sqihRLvCP6OBh4=;
 b=CRTSsJ3TmdCGLOIClDsU2w/g6AhacYaR3Gham7R7ad4EJpZtzi5Wc99GR+TtwS6NHPJ4F+gbTCA3bJJ5mRXix7VL0JQFhsnirCorON8EmyV4GhtcwErF2S7rkFjqi76s0XzV+wIYdOzHo9+C1470FIF30rO+TVABrRAikLUgdRa1vhPLWI5As9J9cPte1EZB3GkLI0ytNa5g4mKV+bTevn1T7m+u3g2GMZrfo/ubxi3yavySqSxvGoUKiDtKwK+zpmvmtvFoybV746KmHCcaVsJ3HOVwkfo3hDYQa+wBBtT7dd2Z7XLkhkFhgyO9yTosogQGuUP9M8HB5D4d8cmkrg==
Received: from SY4P282MB1084.AUSP282.PROD.OUTLOOK.COM (2603:10c6:10:ac::13) by
 MEYP282MB4270.AUSP282.PROD.OUTLOOK.COM (2603:10c6:220:17d::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6863.41; Wed, 11 Oct 2023 14:46:11 +0000
Received: from SY4P282MB1084.AUSP282.PROD.OUTLOOK.COM
 ([fe80::e39e:17fc:36d8:1ea8]) by SY4P282MB1084.AUSP282.PROD.OUTLOOK.COM
 ([fe80::e39e:17fc:36d8:1ea8%3]) with mapi id 15.20.6863.032; Wed, 11 Oct 2023
 14:46:11 +0000
From:   Tianyi Liu <i.pear@outlook.com>
To:     mlevitsk@redhat.com
Cc:     acme@kernel.org, adrian.hunter@intel.com,
        alexander.shishkin@linux.intel.com, i.pear@outlook.com,
        irogers@google.com, jolsa@kernel.org, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        mark.rutland@arm.com, mingo@redhat.com, namhyung@kernel.org,
        pbonzini@redhat.com, peterz@infradead.org, seanjc@google.com,
        x86@kernel.org
Subject: Re: [PATCH v2 4/5] perf kvm: Support sampling guest callchains
Date:   Wed, 11 Oct 2023 22:44:55 +0800
Message-ID: <SY4P282MB1084293EB22AB6FBF72DA0599DCCA@SY4P282MB1084.AUSP282.PROD.OUTLOOK.COM>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <ce964b43f926708f30c85640591b2fc62397b719.camel@redhat.com>
References: <ce964b43f926708f30c85640591b2fc62397b719.camel@redhat.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-TMN:  [tYjoVVzhBVCi3TNiAPX2d/YxH12ViUyazIybUuDNCNggmMdSG4raWA==]
X-ClientProxiedBy: SG2PR01CA0190.apcprd01.prod.exchangelabs.com
 (2603:1096:4:189::11) To SY4P282MB1084.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:ac::13)
X-Microsoft-Original-Message-ID: <20231011144455.80083-1-i.pear@outlook.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SY4P282MB1084:EE_|MEYP282MB4270:EE_
X-MS-Office365-Filtering-Correlation-Id: bf82b402-d673-4f3c-346a-08dbca68cedd
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8Mtiy/4+8nxePELceqHkyV2VIKRZZZKlw/IBJ+7YKhNdB7K65FDm8KBbFYevgSST3Pu1PHitECUtxlso2wTFJdPSx7Wke2JF1mg+z49/ABxF3uADOpQdBBfQU96GibrPw1wT+A1HgcrI1uTizxU0eKeXliWQ0DNsRIwKVMtcf1e+KSpj9C/stqubi0L1NetIV7yWbJdH/LQfw++7Q05ZK1Tthfubwo6k22OsXrsM0adlfqo0sc1Urwiu4YeLdDUL+0mVHCClAHHTdfgxlv1Nutp8KNsOVJggvkiY4cN3+Vdk31hodMjoRmQfYms+XZ8vbCJ08ZVPe/W1Dm7qpanFLJZTjZXh9jkoxJGI0oX09lASCJ+C+M70dGi/MA5s6bKptQmGV8KGR9rCL0JEPqnksqi7J8e5gRczLBmJ50FB12+qW73rho788qn53C98djt2c8af0CKxvlfyPwK8ul0ZbhOAE6QncJ2aUVTTJ9oa99hUGJ6So65r9LjTgd52+DcHUE6ieF/CzLCQOcHkUAhM2BpH3MgMebwzeiixV6Q5PLhyyiTG+SsoBPfhEs7tYKks8dnZlTCQwPhcIJusaR54lG3TFXhpF4rWEr8EITwe1pAcB10pTiSaNCmMpeGRCMmK6ohkZPJRsi450MnlUcUvScbu0mSCEKNbSeWXmLHH6L8=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0klE0HF+fBCtKN1M3+nOJGxQzgBDvzHl60CUdkNNZksOHCHoFqNr6MkJ/Tzi?=
 =?us-ascii?Q?6GJ9lsgnuV0ek2feMmbBahwvTbYm0HxcBI3izVNugdMyDnHQLqtj4Niq444i?=
 =?us-ascii?Q?LNVkqIc8HF/jGUVEjB/ufAS0+IPxeQdoUcQnA4lG/+Voj8QO5gjUa0Cxt2Ib?=
 =?us-ascii?Q?x/2YAZ/JVu2MWGJ+S9NxDBZmSqfX/InSLfCDEtHSNhINO1j94X6xZ0xQFAhK?=
 =?us-ascii?Q?kV8yJG+2wM/+3vwGl1oxCkHc3vvFQS0uJV0082JmcXkfy4PISf/gJL37cRqS?=
 =?us-ascii?Q?DfVwG4gsD78W51IgY/KP6ev8wmCZM0v/HUnO8HRHs+6IgIgnzXtPs9RlPRSC?=
 =?us-ascii?Q?daDhz9WK2k+0IScEPP3XZ5jK8V51KUmkzWRAV3I1M6r58KTPZOOR32qOGFFu?=
 =?us-ascii?Q?2A8IHHltNqFQW/ESEFXmxU20csrjpDa2g7uMfzSs+148vwg7bA+9j4msQAnx?=
 =?us-ascii?Q?+35zlgz0YwGQqcKSzL/1AXhqMoc34QLwvrv64wlFBTSpuycZ3RXyhNBNJijo?=
 =?us-ascii?Q?PVpEq8RqxLgRi6LkX0EDAclKmJzu3RZIdo3/cuLrujeTuFvdyDoza2rjlHch?=
 =?us-ascii?Q?oBDohmVGB/y9lwFOUad1HKMXlN3TWcsYp7CENb8bzBR8ruh6/tp7aDYRJDdA?=
 =?us-ascii?Q?fJ+7v57hS75lXzDF4/65oE7b2BK7fcduIzs41uOo/DxSE5Jc3T+8Bh/WXL2W?=
 =?us-ascii?Q?kM3ZKMvjiyQ+Jhf0fSpKpLDhD1yk/5NBZ6nRGgEneViIFcM5zcMsZwfOdeyk?=
 =?us-ascii?Q?sGB/Tx6rloCJ+jmPrYOkkZ5fwGRlaIQsDheJPupQVlXZfdD384CIuVdq0UV4?=
 =?us-ascii?Q?i2q4LT6VfmypJjcGVPnBRPYlR8Y9XLav85Y3ByfdZj/DrOFR4lqAqwy7VFo8?=
 =?us-ascii?Q?2Y0croLwd+XKpeI26Pu+AxXKhTLYvn0WXIWLAR8Jre+fNt+3Q+jZkMweJD1W?=
 =?us-ascii?Q?Peen+5xw/r5ATA+D6oDRmf2G+r2Y3nBkLr1byRTGEwwQKF5bPuRzpS0fmg/U?=
 =?us-ascii?Q?DN3g9V0KXfj+iQfPmY5xQ6w0U7W0L5IV4IwVIUaVhXASy2bPR9aMrjnU0yCA?=
 =?us-ascii?Q?dTYXxXkHo2ewQTPVm3dAV8LaNsN5ZtLvD9clrIp8JeGXxhOV/kAkHtn/ZZiI?=
 =?us-ascii?Q?EJbNNjDSOlL6IwDQ0Z2aWHNxANs9UEnGkj6m2/E9jRIC+6tE5L3BlYwE3DTy?=
 =?us-ascii?Q?yqOOpSMcz//080LyM949VkKbj+5Cz5nGnAwjrnFXWyrPP917YnAfmrZLepOZ?=
 =?us-ascii?Q?uzd/TD836E1YcAvWD5U6?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf82b402-d673-4f3c-346a-08dbca68cedd
X-MS-Exchange-CrossTenant-AuthSource: SY4P282MB1084.AUSP282.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Oct 2023 14:46:11.3399
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MEYP282MB4270
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Maxim,

At 2023-10-10 16:12 +0000, Maxim Levitsky wrote:
> > +static inline void
> > +perf_callchain_guest32(struct perf_callchain_entry_ctx *entry)
> > +{
> > +	struct stack_frame_ia32 frame;
> > +	const struct stack_frame_ia32 *fp;
> > +
> > +	fp = (void *)perf_guest_get_frame_pointer();
> > +	while (fp && entry->nr < entry->max_stack) {
> > +		if (!perf_guest_read_virt(&fp->next_frame, &frame.next_frame,
> This should be fp->next_frame.
> > +			sizeof(frame.next_frame)))
> > +			break;
> > +		if (!perf_guest_read_virt(&fp->return_address, &frame.return_address,
> Same here.
> > +			sizeof(frame.return_address)))
> > +			break;
> > +		perf_callchain_store(entry, frame.return_address);
> > +		fp = (void *)frame.next_frame;
> > +	}
> > +}
> > +

The address space where `fp` resides here is in the guest memory, not in
the directly accessible kernel address space. `&fp->next_frame` and
`&fp->return_address` are simply calculating address offsets in a more
readable manner, much like `fp + 0` and `fp + 4`.

The original implementation of `perf_callchain_user` and
`perf_callchain_user32` also use this approach [1].

>
> For symmetry, maybe it makes sense to have perf_callchain_guest32 and perf_callchain_guest64
> and then make perf_callchain_guest call each? No strong opinion on this of course.
>

The `perf_callchain_guest` and `perf_callchain_guest32` here are simply
designed to mimic `perf_callchain_user` and `perf_callchain_user32` [2].
I'm also open to make the logic fully separate, if this doesn't seem
elegant enough.

[1] https://github.com/torvalds/linux/blob/master/arch/x86/events/core.c#L2890
[2] https://github.com/torvalds/linux/blob/master/arch/x86/events/core.c#L2820


Best regards,
Tianyi Liu
