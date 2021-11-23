Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A06DF459C5F
	for <lists+kvm@lfdr.de>; Tue, 23 Nov 2021 07:33:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230018AbhKWGgr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Nov 2021 01:36:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbhKWGgq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Nov 2021 01:36:46 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4BE4C061574
        for <kvm@vger.kernel.org>; Mon, 22 Nov 2021 22:33:38 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id np3so15795204pjb.4
        for <kvm@vger.kernel.org>; Mon, 22 Nov 2021 22:33:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=N1DhwfL/dAaPxWYOCXBEgHNa0iAItO0iF87qmEq8azM=;
        b=Lsx/ceq6Amb35FAv277nuefAnbs70GD9bILMPu7hXr2SQAmEIjqNyS0jwThXRqZWOB
         /c6olH5mcnpP32La6Dc4bF2RBpcBHz+J/fQyGO6uhqngE5kS/xliULNjV5MwLtXliZWz
         H7aSSwiF6GFIiv/epnQ4qMKv/XraA7ifrihKd5gxo0L8z5QnuzumcDWkt7EbUaZ+rpTM
         hw6NyCpEF6AD7cMBYs5OpO9tutG7ZRXmCAf+RS3UVF1gbMTrYhXh9yORwlAiDJzLQDfM
         wt/TDbYyzpua+rDJLRyqrrAFZnWjkCqv4iXgCxSzmPXgLe/1llfSGm7g/Vvw5XYDltje
         497g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=N1DhwfL/dAaPxWYOCXBEgHNa0iAItO0iF87qmEq8azM=;
        b=U/WRWR/keGYn5dAnFEhwN6fBHpKh8OE40wV35XMETLt5uQcBZPCNTax5Lzp6dLi+HP
         R6WML1QAXLScowtiyftGOcmyL33cb6+7uENY6jY3vqI1L4Yau2BX+mZQFzFdS6xwpN7Y
         YfEoAnV/IWcDl2DUQrh9isuZ2xlX7dnJHuWOWrPzXZT+AMEYW49XspSLCqGqi1pXq9DR
         NlqMK9kbx2l5VY7bJp1oVMxKcPyVg2vc6yEwJmM1ZGm/TN3Yul/pUtX9JgLQ2V+jVyCm
         wbeIcomyHntnOtAlZHp0V2YpzyOJgd+Hb5RxpE2vhy2DEnEHJ7jeb8Bimgb2Y1xSYaES
         HltA==
X-Gm-Message-State: AOAM533CpTaTYpyTpI77CpS2blDaG91X9erV1U6my5kNDICiTqImth90
        Vklr86beNrByXcQQ7qKg/pHsL6i/zIR0uMnWQJqhMby7x9KPMg==
X-Google-Smtp-Source: ABdhPJxJGk4RZIvde1sXTurZ/i5ykabAS+rsbgQfmHlHHIvts4RAk8a4NDOxu0z5sBvZxls5rl4QLmeBeTZWsvu/lhM=
X-Received: by 2002:a17:90b:380d:: with SMTP id mq13mr102324pjb.110.1637649218063;
 Mon, 22 Nov 2021 22:33:38 -0800 (PST)
MIME-Version: 1.0
References: <20211117064359.2362060-1-reijiw@google.com> <20211117064359.2362060-30-reijiw@google.com>
 <a695d763-b631-e639-3708-2623f4842064@redhat.com> <CAAeT=FwmmLJCR-WumnvxjiRuafD_7gr3JjHZWWO5O=jedh2daQ@mail.gmail.com>
 <8dfa692e-5aa1-c6b3-55f8-3c2bb83df9cd@redhat.com>
In-Reply-To: <8dfa692e-5aa1-c6b3-55f8-3c2bb83df9cd@redhat.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Mon, 22 Nov 2021 22:33:21 -0800
Message-ID: <CAAeT=FzAiM3RwyFSrTvrXPCUvM7Rr87LLVuMZ8r1pC0i2JtMFw@mail.gmail.com>
Subject: Re: [RFC PATCH v3 29/29] KVM: arm64: selftests: Introduce id_reg_test
To:     Eric Auger <eauger@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        Peng Liang <liangpeng10@huawei.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Eric,

> >> After fixing the mem_pages stuff I get the following error on a cavium
> >> machine.
> >>
> >> augere@virtlab-arm04:~/UPSTREAM/ML/tools/testing/selftests/kvm#
> >> ./aarch64/id_reg_test
> >> ==== Test Assertion Failure ====
> >>   aarch64/id_reg_test.c:814: fval >= min
> >>   pid=11692 tid=11692 errno=4 - Interrupted system call
> >>      1  0x00000000004028d3: test_feature at id_reg_test.c:813
> >>      2   (inlined by) test_feature_all at id_reg_test.c:863
> >>      3   (inlined by) run_test at id_reg_test.c:1073
> >>      4  0x000000000040156f: main at id_reg_test.c:1124
> >>      5  0x000003ffa9420de3: ?? ??:0
> >>      6  0x00000000004015eb: _start at :?
> >>   PERFMON field of ID_DFR0 is too small (0)
> >>
> >> Fails on
> >> test_feature: PERFMON (reg ID_DFR0)
> >>
> >> I will do my utmost to further debug
> >
> > Thank you for running it in your environment and reporting this !
> > This is very interesting...
> >
> > It implies that the host's ID_DFR0_EL1.PerfMon is zero or 0xf
> > (meaning FEAT_PMUv3 is not implemented) even though the host's
> > ID_AA64DFR0_EL1.PMUVer indicates that FEAT_PMUv3 is implemented.
> >
> > Would it be possible for you to check values of those two
> > registers on the host (not on the guest) to see if both of them
> > indicate the presence of FEAT_PMUv3 consistently ?
>
> Here are both values printed in armpmu_register()
> [   33.320901] armpmu_register perfmon=0x0 pmuver=0x4
>
>         perfmon =
> cpuid_feature_extract_unsigned_field(read_cpuid(ID_DFR0_EL1),
>                         ID_DFR0_PERFMON_SHIFT);
>         pmuver =
> cpuid_feature_extract_unsigned_field(read_cpuid(ID_AA64DFR0_EL1),
>                         ID_AA64DFR0_PMUVER_SHIFT);
>         printk("%s perfmon=0x%x pmuver=0x%x\n", __func__, perfmon, pmuver);
>
> My machine is a Gigabyte R181-T90 (ThunderX2)

Thank you for your providing the information !!

Since the test incorrectly expects that ID_DFR0_EL1.PerfMon indicates
PMUv3 on any CPUs that support PMUv3 even when they don't support
32bit EL0, I will fix the test.
(ThunderX2 doesn't seem to support 32bit EL0)

Thanks,
Reiji
