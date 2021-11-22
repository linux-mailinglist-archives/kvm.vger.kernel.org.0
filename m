Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A38D34597B5
	for <lists+kvm@lfdr.de>; Mon, 22 Nov 2021 23:25:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232955AbhKVW2b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Nov 2021 17:28:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231591AbhKVW22 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Nov 2021 17:28:28 -0500
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75F94C061714
        for <kvm@vger.kernel.org>; Mon, 22 Nov 2021 14:25:21 -0800 (PST)
Received: by mail-il1-x12c.google.com with SMTP id i9so14192031ilu.1
        for <kvm@vger.kernel.org>; Mon, 22 Nov 2021 14:25:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qT9TxVtxS6w3b9COe1R8QwYertdS2APE4VdxODB+3g4=;
        b=MIkttWkw3Jcxbu2GO8ktmmkmQKcRpJLKxcm9butEcJnG+QpR8Fyvwg/bRrdD/TGB3s
         u6Z/gjHVBlCBByxClZrJRGhFWoG+KN//VNHWFVOzIaMT5dFlYYTlOmhmyAlGp0GfvJAq
         7RIUP97LXLwvjuHQvaCR8trmxtycTfta07m8h9EMU4u0HHQ/f2gIgMyHLtMK526/sXSh
         xyHl7ZwW/zz5rOJX4WDS7/w9rjdqJC4IK7N4mB9yM89J2Cag7ZAVB7QLLb/8y/o39lZH
         iQGLpRKTqVWMMCDezla5X48CUSU/K/l6BOFX9YDMyAli4420B/Mu8KdtUoVVfPin6U9S
         RQAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qT9TxVtxS6w3b9COe1R8QwYertdS2APE4VdxODB+3g4=;
        b=T8KwHgEwX7uZCq+SE4SUlZtdIOM05nc+g2m/sOhK6IGZXRRFWWU5GN7RiB6bW/CGeM
         qQBiYAhdo3clT2ILgi+Awmhr4B1gfSE+b6NO7sbO6mTeQAl41fgCRPgMzYJ0t+IzaaEq
         /wFFgwxzAExQiWQNJB5vg0lpLjfjwlHjWajIxK5eVoWbFgTgrYn4NbYWBfkwXGeXycFV
         rBmymg1f3hrba5x2n5XVDpI5UX1PXj4Ehr70M5O0ULIcJ15EjZyICl2i6hxuDgKjb7ik
         bKVpVL1Pw1zU4dqq3+Pjq89NxjgcmSnnutsKyMfwCsMKqM+IByaxSvPPODMjhAfNoFTc
         JhOw==
X-Gm-Message-State: AOAM530bvY+OzEqbKdVD8ggj7o206m1pR0N5hw2oBIyYbqiLxAx5HI4V
        bbuL5n1Px93TfrojQq6CM6G3LrdpYHSDCSnIIUaF/w==
X-Google-Smtp-Source: ABdhPJz/wCAf9hkpICFwO95kbbF0b61F2woiFAxo0aKHZw4EJJ67Lr4HfRDs4zA2HifJMw/MElPsFz2WCCfG+b/oBjY=
X-Received: by 2002:a92:dccc:: with SMTP id b12mr402048ilr.129.1637619920734;
 Mon, 22 Nov 2021 14:25:20 -0800 (PST)
MIME-Version: 1.0
References: <20211120045046.3940942-1-seanjc@google.com> <20211120045046.3940942-18-seanjc@google.com>
In-Reply-To: <20211120045046.3940942-18-seanjc@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Mon, 22 Nov 2021 14:25:09 -0800
Message-ID: <CANgfPd-M=xcB_heJQp0xe8UW5ybHogoqobrmj6vMD0NF1wGCJg@mail.gmail.com>
Subject: Re: [PATCH 17/28] KVM: x86/mmu: Terminate yield-friendly walk if
 invalid root observed
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
> Stop walking TDP MMU roots if the previous root was invalidated while the
> caller yielded (dropped mmu_lock).  Any effect that the caller wishes to
> be recognized by a root must be made visible before walking the list of
> roots.  Because all roots are invalided when any root is invalidated, if
> the previous root was invalidated, then all roots on the list when the
> caller first started the walk also were invalidated, and any valid roots
> on the list must have been added after the invalidation event.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 19 ++++++++++++-------
>  1 file changed, 12 insertions(+), 7 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index d9524b387221..cc8d021a1ba5 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -140,16 +140,21 @@ static struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
>         lockdep_assert_held(&kvm->mmu_lock);
>
>         /*
> -        * Restart the walk if the previous root was invalidated, which can
> -        * happen if the caller drops mmu_lock when yielding.  Restarting the
> -        * walke is necessary because invalidating a root also removes it from
> -        * tdp_mmu_roots.  Restarting is safe and correct because invalidating
> -        * a root is done if and only if _all_ roots are invalidated, i.e. any
> -        * root on tdp_mmu_roots was added _after_ the invalidation event.
> +        * Terminate the walk if the previous root was invalidated, which can
> +        * happen if the caller yielded and dropped mmu_lock.  Because invalid
> +        * roots are removed from tdp_mmu_roots with mmu_lock held for write,
> +        * if the previous root was invalidated, then the invalidation occurred
> +        * after this walk started.  And because _all_ roots are invalidated
> +        * during an invalidation event, any root on tdp_mmu_roots was created
> +        * after the invalidation.  Lastly, any state change being made by the
> +        * caller must be effected before updating SPTEs, otherwise vCPUs could
> +        * simply create new SPTEs with the old state.  Thus, if the previous
> +        * root was invalidated, all valid roots are guaranteed to have been
> +        * created after the desired state change and don't need to be updated.
>          */
>         if (prev_root && prev_root->role.invalid) {
>                 kvm_tdp_mmu_put_root(kvm, prev_root, shared);
> -               prev_root = NULL;
> +               return NULL;
>         }

Another option might be to walk the list FIFO so that the newly
created roots are encountered, but since they start empty, there might
not be any work to do.

>
>         /*
> --
> 2.34.0.rc2.393.gf8c9666880-goog
>
