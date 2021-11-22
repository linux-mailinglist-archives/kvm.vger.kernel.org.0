Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 230D64596EE
	for <lists+kvm@lfdr.de>; Mon, 22 Nov 2021 22:48:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235247AbhKVVvM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Nov 2021 16:51:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234057AbhKVVvM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Nov 2021 16:51:12 -0500
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F5F7C061574
        for <kvm@vger.kernel.org>; Mon, 22 Nov 2021 13:48:05 -0800 (PST)
Received: by mail-il1-x136.google.com with SMTP id i9so14109416ilu.1
        for <kvm@vger.kernel.org>; Mon, 22 Nov 2021 13:48:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cUC78J9wnQRA3xZgTEIrovLm14ZaQAPvQlLV0U3n2pw=;
        b=IT5jT8xzVfVGW6Mg1OOKSuNBTjB5AxkIvoS5Gl0u42kXXs4oP+xw21Z8ZHe4TeNaf/
         YIxy+giqHsn9DArXeYwptZPg62aL7WHvrjVDjRMCPWglGdcuaMjDGROwVJuY42TCV0y4
         3JfzZGRGEQDZOsfxIhWF/x2h9vBh500cRRoW83ff6Pq2WaVhXFnkOZdR5OtBOUY7OFeN
         XzpiM/yKFK7A6mqYKuN6ak/jSlf3n5joGkcfFiETt0E6vQoozvQXXIFautgmRH/dFxUQ
         omXJIJ5zCYGHwqDkkmoyTXtRlQEiXlDguA7I9iHoKuUOPjElC+pcRbSOtx/OKQefGN0X
         LiWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cUC78J9wnQRA3xZgTEIrovLm14ZaQAPvQlLV0U3n2pw=;
        b=HK9z/sbgmrKIV1YCdgaABYK7k3hjI3MiNs/Knd/9SR6A/e9XzHlphx+1+m+1csROch
         LY07L1wwfYLpvcb6v/UWwvbDroAWu3pWwqX9L1cgNj3js1D0tp2nxntTuEHubkiUW4fr
         jZ/D5GrCsWJPwXsTdvdGwd6/SAxQnje69psH4c332q4lqv64PMCoIOvJ3TSucbFJxMfo
         kmsaO0bkB5m/cAHNZyZRJ/WI77gZ2kKU9Z5r+4H132dj90zBp2qsW6d7BB7m4f8yphka
         saN2AyA2v8yYqBhR8WxR9sn/SX3m/zP2Fc8RIHm0sKvLQ3PFGihKRTQgZJzXeDNse3LT
         XO4g==
X-Gm-Message-State: AOAM530e+bzmCs8PzFZxLhQWjRa5aTtx7KLPi/MhpSLA6il088nmUoYS
        WS4Xflktjk3jwCMB2ak2Y3JfiuQy9cmcQ41Xca9R5w==
X-Google-Smtp-Source: ABdhPJzzT5CLp/xkYMUjDKH3WpZQW3gASaEDHJx3UvFMjqMssQrQnFx5SlykLjKhKNwT9fHnMlGwWUATHUYWkb1YQBY=
X-Received: by 2002:a92:dccc:: with SMTP id b12mr130966ilr.129.1637617684507;
 Mon, 22 Nov 2021 13:48:04 -0800 (PST)
MIME-Version: 1.0
References: <20211120045046.3940942-1-seanjc@google.com> <20211120045046.3940942-14-seanjc@google.com>
In-Reply-To: <20211120045046.3940942-14-seanjc@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Mon, 22 Nov 2021 13:47:53 -0800
Message-ID: <CANgfPd8pWuH9aC4FEJg6WBOBjUrCpNnsBL23d+nwmkCsM-niNQ@mail.gmail.com>
Subject: Re: [PATCH 13/28] KVM: x86/mmu: Drop RCU after processing each root
 in MMU notifier hooks
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Hou Wenlong <houwenlong93@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 19, 2021 at 8:51 PM Sean Christopherson <seanjc@google.com> wrote:
>
> Drop RCU protection after processing each root when handling MMU notifier
> hooks that aren't the "unmap" path, i.e. aren't zapping.  Temporarily
> drop RCU to let RCU do its thing between roots, and to make it clear that
> there's no special behavior that relies on holding RCU across all roots.
>
> Currently, the RCU protection is completely superficial, it's necessary
> only to make rcu_dereference() of SPTE pointers happy.  A future patch
> will rely on holding RCU as a proxy for vCPUs in the guest, e.g. to
> ensure shadow pages aren't freed before all vCPUs do a TLB flush (or
> rather, acknowledge the need for a flush), but in that case RCU needs to
> be held until the flush is complete if and only if the flush is needed
> because a shadow page may have been removed.  And except for the "unmap"
> path, MMU notifier events cannot remove SPs (don't toggle PRESENT bit,
> and can't change the PFN for a SP).
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Ben Gardon <bgardon@google.com>

> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 06b500fab248..3ff7b4cd7d0e 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1079,18 +1079,19 @@ static __always_inline bool kvm_tdp_mmu_handle_gfn(struct kvm *kvm,
>
>         lockdep_assert_held_write(&kvm->mmu_lock);
>
> -       rcu_read_lock();
> -
>         /*
>          * Don't support rescheduling, none of the MMU notifiers that funnel
>          * into this helper allow blocking; it'd be dead, wasteful code.
>          */
>         for_each_tdp_mmu_root(kvm, root, range->slot->as_id) {
> +               rcu_read_lock();
> +
>                 tdp_root_for_each_leaf_pte(iter, root, range->start, range->end)
>                         ret |= handler(kvm, &iter, range);
> +
> +               rcu_read_unlock();
>         }
>
> -       rcu_read_unlock();
>
>         return ret;
>  }
> --
> 2.34.0.rc2.393.gf8c9666880-goog
>
