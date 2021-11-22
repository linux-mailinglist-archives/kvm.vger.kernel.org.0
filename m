Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEC3545970A
	for <lists+kvm@lfdr.de>; Mon, 22 Nov 2021 22:57:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237918AbhKVWAg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Nov 2021 17:00:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237453AbhKVWAe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Nov 2021 17:00:34 -0500
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE3EEC061574
        for <kvm@vger.kernel.org>; Mon, 22 Nov 2021 13:57:27 -0800 (PST)
Received: by mail-io1-xd32.google.com with SMTP id z26so25290209iod.10
        for <kvm@vger.kernel.org>; Mon, 22 Nov 2021 13:57:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DXGfPpbQic+jC8P7dcy3GoN3wRlBo8QMxW6F4njlwrg=;
        b=NJHB1yCu6ije/v77hoI9V8CFrh/itNDBfwe/zNuayvj3LxjejgkRKz7pptrZ6VSZaz
         /iTYQvUaeVf4Ck1eYJnZFj65iQd1R2MJz+6s0koeHc60wrijmoaUl7Q7M6bXYyz+UHNG
         mTYS+D/Ppp7rHAdOkzLHVqcPu2fnt2QNLnY7580i+zSLUiZiDqsu9LxnZ/a/vKv/wYAJ
         a/OSnoDjoGIDGXyOVZ+yRs7QadV2h/VF1uSJmTLaelR5BC+KdrcHJsCz01J0JztmVLZA
         znzWT05gOE+Hu0Fgs+FFy14SIrZDDd6qpoBQgV6mC5rCFLdgkq43zYQNQndZtN/1pMHR
         hbkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DXGfPpbQic+jC8P7dcy3GoN3wRlBo8QMxW6F4njlwrg=;
        b=j0fGdZeBlVPWgZyc1Vic7CO+0/g3Xdb/OmjWwJR5OV6o2AR3Au47KA3K7zbTut0o+K
         uK9raDqi+iNv/RyF2Gbl2msTYl4WavfU/AUuaGuGlF/QYnfsJYLw4JjJZt16qSD7SRou
         MnJT70eNnstniQufCSxCNBkeV+PsTpKFsc1LtBMkTO4vNlfv7VcxoM+fVlzaqnyZYKcd
         q1NQaJH9JUUJKdFzUxSAP/3CkkNx1IBgNpgUSr8lXsSjViQckeU4uynq5yXCgsbyQjZ5
         Di94USsJeA+ATwd1/tp8NFD3luldmL+jFAaHYemQ/HrQG/xV9ddb1BeDBsPxra3ou41E
         RGVw==
X-Gm-Message-State: AOAM532FLeUtrbi3Oin3WnB7mV6NCiJv7GoT0U/w1Ky0l4jYUiXaLcJp
        OlvVAhz+lC8bPqB7BqBXjjbitHez1F4tKs7SjadUpw==
X-Google-Smtp-Source: ABdhPJwtqc09dCzuzmqGkO2wfZtq4x5EKSdT94Ltu4HrWeB72KncSYsFwDVX/wlatkzS3wOuoNIdT73Tqfe9L/t1UPs=
X-Received: by 2002:a5d:8049:: with SMTP id b9mr42673ior.41.1637618246707;
 Mon, 22 Nov 2021 13:57:26 -0800 (PST)
MIME-Version: 1.0
References: <20211120045046.3940942-1-seanjc@google.com> <20211120045046.3940942-17-seanjc@google.com>
In-Reply-To: <20211120045046.3940942-17-seanjc@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Mon, 22 Nov 2021 13:57:15 -0800
Message-ID: <CANgfPd9N2HspOiVeLo5Pqi_wCETuYWcx==97Bhi1bqXBzU7c0A@mail.gmail.com>
Subject: Re: [PATCH 16/28] KVM: x86/mmu: WARN if old _or_ new SPTE is REMOVED
 in non-atomic path
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
> WARN if the new_spte being set by __tdp_mmu_set_spte() is a REMOVED_SPTE,
> which is called out by the comment as being disallowed but not actually
> checked.  Keep the WARN on the old_spte as well, because overwriting a
> REMOVED_SPTE in the non-atomic path is also disallowed (as evidence by
> lack of splats with the existing WARN).
>
> Fixes: 08f07c800e9d ("KVM: x86/mmu: Flush TLBs after zap in TDP MMU PF handler")
> Cc: Ben Gardon <bgardon@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Ben Gardon <bgardon@google.com>

> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 085f6b09e5f3..d9524b387221 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -638,13 +638,13 @@ static inline void __tdp_mmu_set_spte(struct kvm *kvm, struct tdp_iter *iter,
>         lockdep_assert_held_write(&kvm->mmu_lock);
>
>         /*
> -        * No thread should be using this function to set SPTEs to the
> +        * No thread should be using this function to set SPTEs to or from the
>          * temporary removed SPTE value.
>          * If operating under the MMU lock in read mode, tdp_mmu_set_spte_atomic
>          * should be used. If operating under the MMU lock in write mode, the
>          * use of the removed SPTE should not be necessary.
>          */
> -       WARN_ON(is_removed_spte(iter->old_spte));
> +       WARN_ON(is_removed_spte(iter->old_spte) || is_removed_spte(new_spte));
>
>         kvm_tdp_mmu_write_spte(iter->sptep, new_spte);
>
> --
> 2.34.0.rc2.393.gf8c9666880-goog
>
