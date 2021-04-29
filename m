Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3400A36EEDB
	for <lists+kvm@lfdr.de>; Thu, 29 Apr 2021 19:25:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240918AbhD2R0E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Apr 2021 13:26:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233333AbhD2R0D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Apr 2021 13:26:03 -0400
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94D96C06138B
        for <kvm@vger.kernel.org>; Thu, 29 Apr 2021 10:25:15 -0700 (PDT)
Received: by mail-oi1-x236.google.com with SMTP id r3so13848120oic.1
        for <kvm@vger.kernel.org>; Thu, 29 Apr 2021 10:25:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ejvk/mFhlj/v9KWMMj3EmdKbvT3JznWO7+HFY+Yat4E=;
        b=PYEZ2XT3vHdYEVHFh7hBnxigIqbDBTKhdJOFmgn2OrXuKnw3IqOft3fssw7fY0/erY
         3Mx24vVXMxGEd3lWKGxIM4aljx/y9WYJasoXiQBgviTDhCzXyrGsrVHVa6m2AvcaV51w
         QTwIX/2XcDLsdr/G8xKv1XCRJH2C1+6ibBSl/B2k4owSUNwiD43T2y7a9yizNAJoWGem
         ChX7N24zQn8OWluIc8T2luhUgGGacDRuGIR+oecxCpeR0HpzEnCPR96MQbc2yJvN82nZ
         Qus8Ylv1mOPdeHMXoDc4YXA2fQavQVSicOYBpKkwdyzKrRjeZnAsF+AQN45YpXfDb52H
         96jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ejvk/mFhlj/v9KWMMj3EmdKbvT3JznWO7+HFY+Yat4E=;
        b=OCk1FBauzlZJrKzPsG5iE300TFUWW3Oxm9o9Qf0I3IjPICwoi+UWMcfFb+RAvjPEKv
         D92JhtIrjerbPPgH7RDmO5D2PrqzdmL1uP4/kg2X5jnk/BGWC62NpLUnpBroZIQVNSSM
         iJtNqLXc3XGjoNTC9U2jzUYeuPQ8ayOCpIf32LeOdPSl38rH+dCFHIarA0QnDH55r1KU
         eeXaWxcBtgqNe0WGV5WmU1wjrjHWKs41+YiLb2jwGVbTjqt2lgnWmOJ3OF3AJy4q53HO
         25+Ci6Ma+LTEkQWg97hkVs9yIU8go3JhkB18gYiLhT8W1Y5h6NDZ9jNzfxkEkV1zhS0f
         e/Hg==
X-Gm-Message-State: AOAM531Nn6pC1JEQ+GtG7/RK+GIFnGdM9o8pM8Gm7QdhISzx5FDDSnQA
        CTkuuXNf5+r98N7DFMbI6nCL+RZSFtU9cuMVZJpC1A==
X-Google-Smtp-Source: ABdhPJyVPt5+JA5M/gR1bb+6kNA71dlNQPLMt+waMgUtSXguDkTEApndphNY8SNFaRRq+rrxYvqDQJBgvf2BQZxkkv0=
X-Received: by 2002:aca:dc07:: with SMTP id t7mr1469997oig.164.1619717114763;
 Thu, 29 Apr 2021 10:25:14 -0700 (PDT)
MIME-Version: 1.0
References: <1619700409955.15104@amazon.de> <YIrjiXja3/5e6frs@google.com> <3bdf46db-bd64-0ca7-039a-9c123f5a40f9@redhat.com>
In-Reply-To: <3bdf46db-bd64-0ca7-039a-9c123f5a40f9@redhat.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Thu, 29 Apr 2021 10:25:03 -0700
Message-ID: <CANgfPd-JW3BNkQq=oFwi9SPtYz1_fQYw2F6RW+Y=weeWK5chmA@mail.gmail.com>
Subject: Re: Subject: [RFC PATCH] kvm/x86: Fix 'lpages' kvm stat for TDM MMU
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        "Shahin, Md Shahadat Hossain" <shahinmd@amazon.de>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Szczepanek, Bartosz" <bsz@amazon.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 29, 2021 at 10:04 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 29/04/21 18:49, Sean Christopherson wrote:
> > On Thu, Apr 29, 2021, Shahin, Md Shahadat Hossain wrote:
> >> Large pages not being created properly may result in increased memory
> >> access time. The 'lpages' kvm stat used to keep track of the current
> >> number of large pages in the system, but with TDP MMU enabled the stat
> >> is not showing the correct number.
> >>
> >> This patch extends the lpages counter to cover the TDP case.
> >>
> >> Signed-off-by: Md Shahadat Hossain Shahin <shahinmd@amazon.de>
> >> Cc: Bartosz Szczepanek <bsz@amazon.de>
> >> ---
> >>   arch/x86/kvm/mmu/tdp_mmu.c | 6 ++++++
> >>   1 file changed, 6 insertions(+)
> >>
> >> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> >> index 34207b874886..1e2a3cb33568 100644
> >> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> >> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> >> @@ -425,6 +425,12 @@ static void __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
> >>
> >>      if (old_spte == new_spte)
> >>              return;
> >> +
> >> +    if (is_large_pte(old_spte))
> >> +            --kvm->stat.lpages;
> >> +
> >> +    if (is_large_pte(new_spte))
> >> +            ++kvm->stat.lpages;
> >
> > Hrm, kvm->stat.lpages could get corrupted when __handle_changed_spte() is called
> > under read lock, e.g. if multiple vCPUs are faulting in memory.
>
> Ouch, indeed!
>
> One way to fix it without needing an atomic operation is to make it a
> per-vcpu stat.  It would be a bit weird for the binary stats because we
> would have to hide this one from the vCPU statistics file descriptor
> (and only aggregate it in the VM statistics).
>
> Alternatively, you can do the atomic_add only if is_large_pte(old_spte)
> != is_large_pte(new_spte), casting &kvm->stat.lpages to an atomic64_t*.

I forgot that the lpages stat existed upstream. Internally at Google
we also maintain a count for each mapping level and just update it
atomically. The per-vCPU stat approach would work too, but I doubt
it's worth the complexity unless we have other use cases for a
similarly aggregated stat.

>
> Paolo
>
