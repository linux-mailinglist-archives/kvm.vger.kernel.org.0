Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E3CF459805
	for <lists+kvm@lfdr.de>; Mon, 22 Nov 2021 23:55:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229986AbhKVW6T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Nov 2021 17:58:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231390AbhKVW6Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Nov 2021 17:58:16 -0500
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C9EEC061714
        for <kvm@vger.kernel.org>; Mon, 22 Nov 2021 14:55:09 -0800 (PST)
Received: by mail-io1-xd2c.google.com with SMTP id 14so25365651ioe.2
        for <kvm@vger.kernel.org>; Mon, 22 Nov 2021 14:55:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zh9CFupaQEsImYNyAs58bopMZGL1j+sruJ4MSTS5OT8=;
        b=T/RhWcG4Bhqm7CtvqKJ5jA68sB38XyNr32oMSgKc2wQswplPemB9jd5eagcW+3pP6m
         wjvnq1mF/8wiPmHtmGcYF6ooGbPl4OZ26V6JNS6jAmT1uxtAPwEXnIxo1CF839xds1Nh
         omfvmUBuFr6f0asEEJw0rzQ+wWetTRu3FfPcHdUIwnAzY4/D/xz0bsxWPsqTAMkR4MVW
         1WurGYJX/HDZdern0dxZRWtKLhXxbf40PnWx4f9JkzSJuzNz/MTIYoFkZWmmh5yPkfOv
         pMxKZ7m/m/Khg2aYukSDtjjuC6Q97nNmoDYFJwM161Smkv4bhQod0aOanJu/pcGg7IQf
         WQ3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zh9CFupaQEsImYNyAs58bopMZGL1j+sruJ4MSTS5OT8=;
        b=FYcg3XCalQqFfYso6R80pA470V9XUz7mMEzAVM9KiV1FZcdhgypfZjlKFosDU7+m6z
         oODP8CvDLFfh/bDZnx+cPxeGtlEK7Hdxe19+7LiiUnUDz9Id8Z91VqJHot5RipNxj3qS
         c0EUPb7qsfx0AXqVzs3gLgMGuTB0IuN2gkIu4J4gzxpQPOh43BdOi57O1UshgFGlgbr4
         seRLPbefwoTq659YNFFSCOOothm5Xj+2WX9lkDzWnmPRH7sAEQ685kJWPJOTHZu7aJuc
         zSL4qO0RCPDA0PQhBFciDOvv0kzz2Hmvx2Gfij72Ax9UN80cm0WUWJxCz4ezYtzzmVOQ
         oamg==
X-Gm-Message-State: AOAM533MjWkFuYEeyAOAX4SjjJb9PCHG9usPu+n8wyL0O2hfBd47M+mb
        r7+irUdOTypvDQLGnOFWqCLB8vZPwFO1RTbt39ckoA==
X-Google-Smtp-Source: ABdhPJzQf+uXOlKY00zavpohO2RVjxIgnyYkQZO79zO2ndWUHwKR/Em345CTtZYRg5LGdARhllrhxoaGOM6Ok7AuQ7Y=
X-Received: by 2002:a5d:9493:: with SMTP id v19mr502434ioj.34.1637621708875;
 Mon, 22 Nov 2021 14:55:08 -0800 (PST)
MIME-Version: 1.0
References: <20211120045046.3940942-1-seanjc@google.com> <20211120045046.3940942-22-seanjc@google.com>
In-Reply-To: <20211120045046.3940942-22-seanjc@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Mon, 22 Nov 2021 14:54:57 -0800
Message-ID: <CANgfPd83-1yT=p1bMTRiOqCBq_m5AZuuhzmmyKKau9ODML39oA@mail.gmail.com>
Subject: Re: [PATCH 21/28] KVM: x86/mmu: Add TDP MMU helper to zap a root
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
> Add a small wrapper to handle zapping a specific root.  For now, it's
> little more than syntactic sugar, but in the future it will become a
> unique flow with rules specific to zapping an unreachable root.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 9449cb5baf0b..31fb622249e5 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -79,11 +79,18 @@ static void tdp_mmu_free_sp_rcu_callback(struct rcu_head *head)
>         tdp_mmu_free_sp(sp);
>  }
>
> +static bool tdp_mmu_zap_root(struct kvm *kvm, struct kvm_mmu_page *root,
> +                            bool shared)
> +{
> +       return zap_gfn_range(kvm, root, 0, -1ull, true, false, shared);

Total aside:
Remembering the order of these three boolean parameters through all
these functions drives me nuts.
It'd be really nice to put them into a neat, reusable struct that tracks:
MMU lock mode (read / write / none)
If yielding is okay
If the TLBs are dirty and need to be flushed

I don't know when I'll have time to do that refactor, but it would
make this code so much more sensible.

> +}
> +
>  /*
>   * Note, putting a root might sleep, i.e. the caller must have IRQs enabled and
>   * must not explicitly disable preemption (it will be disabled by virtue of
>   * holding mmu_lock, hence the lack of a might_sleep()).
>   */
> +
>  void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root,
>                           bool shared)
>  {
> @@ -118,7 +125,7 @@ void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root,
>          * should have been zapped by kvm_tdp_mmu_zap_invalidated_roots(), and
>          * inserting new SPTEs under an invalid root is a KVM bug.
>          */
> -       if (zap_gfn_range(kvm, root, 0, -1ull, true, false, shared))
> +       if (tdp_mmu_zap_root(kvm, root, shared))
>                 WARN_ON_ONCE(root->role.invalid);
>
>         call_rcu(&root->rcu_head, tdp_mmu_free_sp_rcu_callback);
> @@ -923,7 +930,7 @@ void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm,
>                  * will still flush on yield, but that's a minor performance
>                  * blip and not a functional issue.
>                  */
> -               (void)zap_gfn_range(kvm, root, 0, -1ull, true, false, true);
> +               (void)tdp_mmu_zap_root(kvm, root, true);
>                 kvm_tdp_mmu_put_root(kvm, root, true);
>         }
>  }
> --
> 2.34.0.rc2.393.gf8c9666880-goog
>
