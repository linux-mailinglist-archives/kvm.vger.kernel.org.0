Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED13145952E
	for <lists+kvm@lfdr.de>; Mon, 22 Nov 2021 19:56:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237678AbhKVS7y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Nov 2021 13:59:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235819AbhKVS7x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Nov 2021 13:59:53 -0500
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77CC3C061574
        for <kvm@vger.kernel.org>; Mon, 22 Nov 2021 10:56:46 -0800 (PST)
Received: by mail-il1-x135.google.com with SMTP id e8so19184534ilu.9
        for <kvm@vger.kernel.org>; Mon, 22 Nov 2021 10:56:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sXxs9rMu+l9NsgXI+txVcxSrWzApa2L2qGn211j8/h4=;
        b=kYG+l93bqIjMH1U9F0hDMpfN14yagEbdk1ch20QdYvJSmspX9aHRjnKWz8Dwp5xHvR
         m+ZrWjFXNOboH9gFZLoNbqaEP9//jbYCXc995JCteNtMLPI+3vxypH0euqkrjvqtxL3j
         Lu3Bv59hs2cQPYyvWwq+JEEHG/kLZ6ueKizNCZN15FowSH/jMHtOjr7kuLjrqT7ad0hO
         VczfuZfDZBo7OBYa6QvrqDLh3hhMWkealSevhPBvwEAHv8fqlz8a2yrb9c2X5G1vzhN5
         h9+pG8I+h1Of5fyeG8rGhh3/IywL58Q8mayMdnhLyrqaEw/x6mCJZYhkwDITWV8TMezN
         lx1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sXxs9rMu+l9NsgXI+txVcxSrWzApa2L2qGn211j8/h4=;
        b=pYO2ugwoOZ0xR5q46rtAsCUZTbaCnSelCrD6ikWf8acos8s9AY2S91xeTp1R13zvuO
         z9hHNYPAi1avnWIb2Qd2LLpL19cM8X6X0E7LSXrHiPNO+wAu8b+ljLTKScd+k6ZM9QoY
         yClK8ObllU8kqOWrO+EuGHVHvU2wbupd9lCiNn5UQ2+stOvKbaHJ4e0O01Ci9e2xTibF
         NvSiLSuP/gUFSgJv4p4gIiiKaHbDfaV6LVnAjM8BPx2A+T1L1VFSW1a3BsmFq+dXbIyY
         nRu1c/xHdPJuiymfLIHc8CHSdlZJVMBa0O3fITTPXViZUH36C2cP49Ctn9a/nhImf6aj
         i/wQ==
X-Gm-Message-State: AOAM532BnZkRGSGu2+OkyjPQMV1GLlRmSt/9QabEIrtvm9/iQGUE6gqC
        DU+X6RzRulmB1WdFJ9mg8OjRhvVs/UX2ApnvTx6PYw==
X-Google-Smtp-Source: ABdhPJw7Elxtj2OJfm3L9bB+utra00vix3bn0tJEoqtoLBqZGaMfame1OZ8dM3pPnNCtsrr9dFFEUo+q0TaYAGJb584=
X-Received: by 2002:a05:6e02:1809:: with SMTP id a9mr21299141ilv.203.1637607405765;
 Mon, 22 Nov 2021 10:56:45 -0800 (PST)
MIME-Version: 1.0
References: <20211119235759.1304274-1-dmatlack@google.com> <20211119235759.1304274-11-dmatlack@google.com>
In-Reply-To: <20211119235759.1304274-11-dmatlack@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Mon, 22 Nov 2021 10:56:34 -0800
Message-ID: <CANgfPd93aeZaWaMUb+V9_2yaYFD4=9XXhNvDhtTAgPWeHk82Pg@mail.gmail.com>
Subject: Re: [RFC PATCH 10/15] KVM: x86/mmu: Abstract need_resched logic from tdp_mmu_iter_cond_resched
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>,
        Junaid Shahid <junaids@google.com>,
        Oliver Upton <oupton@google.com>,
        Harish Barathvajasankar <hbarath@google.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 19, 2021 at 3:58 PM David Matlack <dmatlack@google.com> wrote:
>
> Abstract out the logic that checks whether or not we should reschedule
> (including the extra check that ensures we make forward progress) to a
> helper method. This will be used in a follow-up commit to reschedule
> during large page splitting.
>
> No functional change intended.
>
> Signed-off-by: David Matlack <dmatlack@google.com>

Reviewed-by: Ben Gardon <bgardon@google.com>


> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 15 ++++++++++-----
>  1 file changed, 10 insertions(+), 5 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index f8c4337f1fcf..2221e074d8ea 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -645,6 +645,15 @@ static inline void tdp_mmu_set_spte_no_dirty_log(struct kvm *kvm,
>         for_each_tdp_pte(_iter, __va(_mmu->root_hpa),           \
>                          _mmu->shadow_root_level, _start, _end)
>
> +static inline bool tdp_mmu_iter_need_resched(struct kvm *kvm, struct tdp_iter *iter)
> +{
> +       /* Ensure forward progress has been made before yielding. */
> +       if (iter->next_last_level_gfn == iter->yielded_gfn)
> +               return false;
> +
> +       return need_resched() || rwlock_needbreak(&kvm->mmu_lock);
> +}
> +
>  /*
>   * Yield if the MMU lock is contended or this thread needs to return control
>   * to the scheduler.
> @@ -664,11 +673,7 @@ static inline bool tdp_mmu_iter_cond_resched(struct kvm *kvm,
>                                              struct tdp_iter *iter, bool flush,
>                                              bool shared)
>  {
> -       /* Ensure forward progress has been made before yielding. */
> -       if (iter->next_last_level_gfn == iter->yielded_gfn)
> -               return false;
> -
> -       if (need_resched() || rwlock_needbreak(&kvm->mmu_lock)) {
> +       if (tdp_mmu_iter_need_resched(kvm, iter)) {
>                 rcu_read_unlock();
>
>                 if (flush)
> --
> 2.34.0.rc2.393.gf8c9666880-goog
>
