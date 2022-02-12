Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87D2E4B33DC
	for <lists+kvm@lfdr.de>; Sat, 12 Feb 2022 09:39:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232733AbiBLIjY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 12 Feb 2022 03:39:24 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232647AbiBLIjX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 12 Feb 2022 03:39:23 -0500
Received: from mail-oo1-xc2f.google.com (mail-oo1-xc2f.google.com [IPv6:2607:f8b0:4864:20::c2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 213E82613A
        for <kvm@vger.kernel.org>; Sat, 12 Feb 2022 00:39:20 -0800 (PST)
Received: by mail-oo1-xc2f.google.com with SMTP id t75-20020a4a3e4e000000b002e9c0821d78so13191518oot.4
        for <kvm@vger.kernel.org>; Sat, 12 Feb 2022 00:39:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=knbguSrX3xagYUpZD20aO/zcWDU1J9IHxC/2QTmVdh0=;
        b=QTnl6TjaqYf1gXjMYo2qS5Xy0BQjvXfZTfbKa9AmzM0Amqr3YLk2VXin504ONCvS4c
         D71CiHvHMQkMBc4NFA40dBjG6HaiGxlTqyD0jgv9VsVSErXQX2ezpCgwzAb1d/O+TQlR
         tN0M7EElLBsyjeEJCaLZoqBQhJ/hthGxULgvKNce6noV8UYJe24ndI4FMdxlV/NLqxUM
         yxgiPwY7bWqL2Jfinf0P4erYgY1JUON6gMKKtJYqcb22eoYuoHgtRWijmu0lwVTz5r4m
         bQRNMj0TI4O2OWCtLkj1bAqtcLZaLDMaIThdAKUvgWYh9rdv/P5EehSVP9yJSC4wb/U/
         3Lwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=knbguSrX3xagYUpZD20aO/zcWDU1J9IHxC/2QTmVdh0=;
        b=n5ItgqMjcmPT1Anx63Cd073T4bHmOB3Q11nF1RTvIkOzCu5nMdlrTcYkRHxqnKEYsM
         6ZngjHpGYet3hy8BX9Lx/DuCs6m93dnI/lWTycLs4xaOjv9So/jRwE1QWbGxPlAHiNKL
         AfleL8EIH7GYk92ChB7d2zfcjG4srq+2/ZUfs8LKxLhdFTlUOx1+xNPwz3T4VXDjsC/d
         OwJqijJH98FSprLUjERggMgN9iAzUeVVbdoI8JLvgpdyJNR5o5br3wIsECghD5+6mCEn
         5nHWf6B0yyrlsp6A5mAN+OcNxpBNYyBZaujDJj9UaKJ1RbV2Fk/DcQNmoLW525eca1WV
         BzNw==
X-Gm-Message-State: AOAM532PpkaFbWZ4bDHce6/F9dzMrfLX06Apl4SBOA3WePCobZSNg15Q
        F2pMdYFTBpOgSaxmZLFP6Ff7e6TIefItnDNULXUECA==
X-Google-Smtp-Source: ABdhPJyns7ddLPUyPQCSMDyfKbEyJqJSYRTCQnSQAozx4Oxa7MiPTV/AB9Nyf62p7APdboNF7lqfYKu1g/ZHT3BaAeQ=
X-Received: by 2002:a05:6870:f812:: with SMTP id fr18mr1245704oab.129.1644655159211;
 Sat, 12 Feb 2022 00:39:19 -0800 (PST)
MIME-Version: 1.0
References: <20211118130320.95997-1-likexu@tencent.com>
In-Reply-To: <20211118130320.95997-1-likexu@tencent.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Sat, 12 Feb 2022 00:39:08 -0800
Message-ID: <CALMp9eTONaviuz-NnPUP2=MEOb8ZBkZ7u_ZQBWBUne-i6cRUkA@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86/pmu: Fix reserved bits for AMD PerfEvtSeln register
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Kim Phillips <kim.phillips@amd.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 18, 2021 at 5:03 AM Like Xu <like.xu.linux@gmail.com> wrote:
>
> From: Like Xu <likexu@tencent.com>
>
> If we run the following perf command in an AMD Milan guest:
>
>   perf stat \
>   -e cpu/event=0x1d0/ \
>   -e cpu/event=0x1c7/ \
>   -e cpu/umask=0x1f,event=0x18e/ \
>   -e cpu/umask=0x7,event=0x18e/ \
>   -e cpu/umask=0x18,event=0x18e/ \
>   ./workload
>
> dmesg will report a #GP warning from an unchecked MSR access
> error on MSR_F15H_PERF_CTLx.
>
> This is because according to APM (Revision: 4.03) Figure 13-7,
> the bits [35:32] of AMD PerfEvtSeln register is a part of the
> event select encoding, which extends the EVENT_SELECT field
> from 8 bits to 12 bits.
>
> Opportunistically update pmu->reserved_bits for reserved bit 19.
>
> Reported-by: Jim Mattson <jmattson@google.com>
> Fixes: ca724305a2b0 ("KVM: x86/vPMU: Implement AMD vPMU code for KVM")
> Signed-off-by: Like Xu <likexu@tencent.com>
> ---
>  arch/x86/kvm/svm/pmu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
> index 871c426ec389..b4095dfeeee6 100644
> --- a/arch/x86/kvm/svm/pmu.c
> +++ b/arch/x86/kvm/svm/pmu.c
> @@ -281,7 +281,7 @@ static void amd_pmu_refresh(struct kvm_vcpu *vcpu)
>                 pmu->nr_arch_gp_counters = AMD64_NUM_COUNTERS;
>
>         pmu->counter_bitmask[KVM_PMC_GP] = ((u64)1 << 48) - 1;
> -       pmu->reserved_bits = 0xffffffff00200000ull;
> +       pmu->reserved_bits = 0xfffffff000280000ull;

Bits 40 and 41 are guest mode and host mode. They cannot be reserved
if the guest supports nested SVM.

>         pmu->version = 1;
>         /* not applicable to AMD; but clean them to prevent any fall out */
>         pmu->counter_bitmask[KVM_PMC_FIXED] = 0;
> --
> 2.33.1
>
