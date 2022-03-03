Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8C624CC495
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 19:05:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233175AbiCCSGM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 13:06:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231868AbiCCSGJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 13:06:09 -0500
Received: from mail-oo1-xc29.google.com (mail-oo1-xc29.google.com [IPv6:2607:f8b0:4864:20::c29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15AC11959FF
        for <kvm@vger.kernel.org>; Thu,  3 Mar 2022 10:05:24 -0800 (PST)
Received: by mail-oo1-xc29.google.com with SMTP id d134-20020a4a528c000000b00319244f4b04so6661018oob.8
        for <kvm@vger.kernel.org>; Thu, 03 Mar 2022 10:05:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/ovabB264TUfiikvyHgOc2D5zXM9RNGNE3+8hMb4K1Q=;
        b=VLtZb6YUqbdwpT+ckMqn9vj4WkFREB8maD+Pl0b4g6ayGbk0l60ornYMsL1GkfMmFS
         pK6r4jMMd25Z4cqUgONEiBJJsmVAKyUXz/msVSwF3nzEfIkxmrMIWYZnlVYk/e3m29oO
         OIQpS9yQOSVwBnrrWps+64QmebwvSkKcqa2Q1LeKxvV4gRu0/YgrkDExNi63MGeHEh8G
         jv5hZ3tC0rbIj8yZjWuiUTic3ZqcSlkJjzOj1SAfbysCQV/7re5e/rw4hdVrJ/qy/lnQ
         VWB49C0AFbvAf/qex/F/cywZfLKg9yyXGekNo2PI5lvBu09KqyuZZa7fSEaQMcpSAO7y
         /Ayw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/ovabB264TUfiikvyHgOc2D5zXM9RNGNE3+8hMb4K1Q=;
        b=YvHcIY/pzLtIyLoOlnCua6vL9j8MD1MiLNFgjGjCqFHozbLQfxy4USgCpZKZLlF6SE
         hcUnvGtKFAcMiU//8CV0id8J+Pg/jPIrg9QKVc3yI/HYfkOMe7hw5TGw9XICjhhsRhFc
         G/t8EMVW0t/LrYkL+ga/jFKMEpmirmNqkBu4mCHsLv+fFIovpFShyB24mLTw2vg4/2u8
         NX7l62LzV3D/LdEAJ+RDDv9+8NxE8Ad/HH8xB80tUHRHBnn+KxbTljEKpZI4baEip0Qt
         8E8J+dMT+Hw3vlMSUKRZb2VmHG4nM7sgV9+lrGFlhBIJAE9HB9fqNSOoZjAggInH2tsT
         8wNQ==
X-Gm-Message-State: AOAM530biSyX+CR6znVvYsBnWKHCtx//DOsT0DL03CHM5RmH4wxx/AFF
        i1zSRNxSWVwMqwiiZkYMxNEv12BrZJXiIr1T/xmuvw==
X-Google-Smtp-Source: ABdhPJyEcCe0YZDxh1cT9exb/+QzY5fiz55WHLtf3SayuTdiDhpLL3G+Dr3i2wqPjPQ7qOPVT8ozFxb8qsVadn1zCsw=
X-Received: by 2002:a4a:5596:0:b0:2dd:bb93:8800 with SMTP id
 e144-20020a4a5596000000b002ddbb938800mr18965773oob.85.1646330722922; Thu, 03
 Mar 2022 10:05:22 -0800 (PST)
MIME-Version: 1.0
References: <20220221073140.10618-1-ravi.bangoria@amd.com> <20220221073140.10618-4-ravi.bangoria@amd.com>
 <1e0fc70a-1135-1845-b534-79f409e0c29d@gmail.com> <80fce7df-d387-773d-ad7d-3540c2d411d1@amd.com>
 <CALMp9eQtW6SWG83rJa0jKt7ciHPiRbvEyCi2CDNkQ-FJC+ZLjA@mail.gmail.com> <54d94539-a14f-49d7-e4f3-092f76045b33@amd.com>
In-Reply-To: <54d94539-a14f-49d7-e4f3-092f76045b33@amd.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 3 Mar 2022 10:05:11 -0800
Message-ID: <CALMp9eTTpdtsEek17-EnSZu53-+LmwcSTYmou1+u34LdT3TMmQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] KVM: x86/pmu: Segregate Intel and AMD specific logic
To:     Ravi Bangoria <ravi.bangoria@amd.com>
Cc:     Like Xu <like.xu.linux@gmail.com>, seanjc@google.com,
        dave.hansen@linux.intel.com, peterz@infradead.org,
        alexander.shishkin@linux.intel.com, eranian@google.com,
        daviddunn@google.com, ak@linux.intel.com,
        kan.liang@linux.intel.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kim.phillips@amd.com,
        santosh.shukla@amd.com,
        "Paolo Bonzini - Distinguished Engineer (kernel-recipes.org) (KVM HoF)" 
        <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-18.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 3, 2022 at 8:25 AM Ravi Bangoria <ravi.bangoria@amd.com> wrote:
>
>
>
> On 03-Mar-22 10:08 AM, Jim Mattson wrote:
> > On Mon, Feb 21, 2022 at 2:02 AM Ravi Bangoria <ravi.bangoria@amd.com> wrote:
> >>
> >>
> >>
> >> On 21-Feb-22 1:27 PM, Like Xu wrote:
> >>> On 21/2/2022 3:31 pm, Ravi Bangoria wrote:
> >>>>   void reprogram_counter(struct kvm_pmu *pmu, int pmc_idx)
> >>>>   {
> >>>>       struct kvm_pmc *pmc = kvm_x86_ops.pmu_ops->pmc_idx_to_pmc(pmu, pmc_idx);
> >>>> +    bool is_intel = !strncmp(kvm_x86_ops.name, "kvm_intel", 9);
> >>>
> >>> How about using guest_cpuid_is_intel(vcpu)
> >>
> >> Yeah, that's better then strncmp().
> >>
> >>> directly in the reprogram_gp_counter() ?
> >>
> >> We need this flag in reprogram_fixed_counter() as well.
> >
> > Explicit "is_intel" checks in any form seem clumsy,
>
> Indeed. However introducing arch specific callback for such tiny
> logic seemed overkill to me. So thought to just do it this way.

I agree that arch-specific callbacks are ridiculous for these distinctions.

> > since we have
> > already put some effort into abstracting away the implementation
> > differences in struct kvm_pmu. It seems like these differences could
> > be handled by adding three masks to that structure: the "raw event
> > mask" (i.e. event selector and unit mask), the hsw_in_tx mask, and the
> > hsw_in_tx_checkpointed mask.
>
> struct kvm_pmu is arch independent. You mean struct kvm_pmu_ops?

No; I meant exactly what I said. See, for example, how the
reserved_bits field is used. It is initialized in the vendor-specific
pmu_refresh functions, and from then on, it facilitates
vendor-specific behaviors without explicit checks or vendor-specific
callbacks. An eventsel_mask field would be a natural addition to this
structure, to deal with the vendor-specific event selector widths. The
hsw_in_tx_mask and hsw_in_tx_checkpointed_mask fields are less
natural, since they will be 0 on AMD, but they would make it simple to
write the corresponding code in a vendor-neutral fashion.

BTW, am I the only one who finds the HSW_ prefixes a bit absurd here,
since TSX was never functional on Haswell?

> >
> > These changes should also be coordinated with Like's series that
> > eliminates all of the PERF_TYPE_HARDWARE nonsense.
>
> I'll rebase this on Like's patch series.

That's not exactly what I meant, but okay.
