Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C84C4596BE
	for <lists+kvm@lfdr.de>; Mon, 22 Nov 2021 22:31:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234057AbhKVVeE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Nov 2021 16:34:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233849AbhKVVeB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Nov 2021 16:34:01 -0500
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8919DC06174A
        for <kvm@vger.kernel.org>; Mon, 22 Nov 2021 13:30:54 -0800 (PST)
Received: by mail-il1-x129.google.com with SMTP id s14so19562011ilv.10
        for <kvm@vger.kernel.org>; Mon, 22 Nov 2021 13:30:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=j79CtY0bfjdMDVlZteIFrRDRXy1oeMcitRahwpeWG0g=;
        b=nXW3qgiltK+KRqBM1hNqdtgOlfAFz2lqGSwfS7Fbi9KIUN9VGkE2s/zKXCJAetJcjX
         tWd1TPRmaMoslqcQtOobFyVpZa73QMZNgWQaNIUuLgBezjnOuIjjLe2HG3xyoeoZDJ91
         d8y4w+ddIDtyMIasI07u+fzZnTeAW1PnmbmJ4rgMLuK5/AR1JRX32H5gCaEZ8StYUgS/
         Y2N1tXM998iFrPJ5OGjklZK/q8sGp5PcLIV0LVkfDsocHcqWvM6zMjmAu4HtgyIIz55+
         WP2dbdfD63p/HikhsGKqQlJ+/Tet/xHPOyxibvf8O+xvR009Qvfe4FiZN9Qf47p5m4xY
         PWuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=j79CtY0bfjdMDVlZteIFrRDRXy1oeMcitRahwpeWG0g=;
        b=WUrmpQssGlu/NmzqCUjBazqjVzq90JbPWm8Kdk2ra5SBSGaBbynDovgfIzlEvQxtgX
         ltA9XYqwX3o6ebA2bu+gGkiR4P/4EZ/lSh+thNARCSfHq+MH48b6C6latxo4kaoCA0a/
         9KQ3nHxoYlsnGNO4cjQsgmSqpv18sfAL0zjoT8MkHNTT7OGkOBvJmJwfcCRy3N+dQeo9
         ypBXx3m7HNb6Ksl22urks/ZDZ/r6YiHwrhJzlbVz6gj9axnCrQz5ODle+FipLqdWlvLr
         C+7UBLjVs7HLBwLWgMSTTSJd/+fHjAyZk7lww76+H0xlB2bAllLXCCIjiSBdEpHWhbKS
         B66Q==
X-Gm-Message-State: AOAM530wxJdbAQKBBmsJvpPfjYDpPognOKsDx7OWVxREPSd7q+RDFS4L
        zRiwsMpmsqd94fgrvxUxmR8sZ4557l0EzCDPPSMZ3w==
X-Google-Smtp-Source: ABdhPJzfEiX0RnDUHeGJN7+Q9r9rtKDEIehxSABvnK1iAq5liBjFJFAlUUAo1ETMei3xCZQl21u9J7/fBA95j3WS3WE=
X-Received: by 2002:a92:cda2:: with SMTP id g2mr80401ild.2.1637616653732; Mon,
 22 Nov 2021 13:30:53 -0800 (PST)
MIME-Version: 1.0
References: <20211120045046.3940942-1-seanjc@google.com> <20211120045046.3940942-11-seanjc@google.com>
In-Reply-To: <20211120045046.3940942-11-seanjc@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Mon, 22 Nov 2021 13:30:42 -0800
Message-ID: <CANgfPd_H3CZn_rFfEZoZ7Sa==Lnwt4tXSMsO+eg5d8q9n39BSQ@mail.gmail.com>
Subject: Re: [PATCH 10/28] KVM: x86/mmu: Allow yielding when zapping GFNs for
 defunct TDP MMU root
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
> Allow yielding when zapping SPTEs for a defunct TDP MMU root.  Yielding
> is safe from a TDP perspective, as the root is unreachable.  The only
> potential danger is putting a root from a non-preemptible context, and
> KVM currently does not do so.
>
> Yield-unfriendly iteration uses for_each_tdp_mmu_root(), which doesn't
> take a reference to each root (it requires mmu_lock be held for the
> entire duration of the walk).
>
> tdp_mmu_next_root() is used only by the yield-friendly iterator.
>
> kvm_tdp_mmu_zap_invalidated_roots() is explicitly yield friendly.
>
> kvm_mmu_free_roots() => mmu_free_root_page() is a much bigger fan-out,
> but is still yield-friendly in all call sites, as all callers can be
> traced back to some combination of vcpu_run(), kvm_destroy_vm(), and/or
> kvm_create_vm().
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Ben Gardon <bgardon@google.com>

I'm glad to see this fixed. I assume we don't usually hit this in
testing because most of the teardown happens in the zap-all path when
we unregister for MMU notifiers and actually deleting a fully
populated root while the VM is running is pretty rare.

> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 3086c6dc74fb..138c7dc41d2c 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -79,6 +79,11 @@ static void tdp_mmu_free_sp_rcu_callback(struct rcu_head *head)
>         tdp_mmu_free_sp(sp);
>  }
>
> +/*
> + * Note, putting a root might sleep, i.e. the caller must have IRQs enabled and
> + * must not explicitly disable preemption (it will be disabled by virtue of
> + * holding mmu_lock, hence the lack of a might_sleep()).
> + */
>  void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root,
>                           bool shared)
>  {
> @@ -101,7 +106,7 @@ void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root,
>          * intermediate paging structures, that may be zapped, as such entries
>          * are associated with the ASID on both VMX and SVM.
>          */
> -       (void)zap_gfn_range(kvm, root, 0, -1ull, false, false, shared);
> +       (void)zap_gfn_range(kvm, root, 0, -1ull, true, false, shared);
>
>         call_rcu(&root->rcu_head, tdp_mmu_free_sp_rcu_callback);
>  }
> --
> 2.34.0.rc2.393.gf8c9666880-goog
>
