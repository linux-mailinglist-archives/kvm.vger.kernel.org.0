Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A478768C917
	for <lists+kvm@lfdr.de>; Mon,  6 Feb 2023 23:06:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229664AbjBFWG4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Feb 2023 17:06:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbjBFWGz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Feb 2023 17:06:55 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C74F2FCCB
        for <kvm@vger.kernel.org>; Mon,  6 Feb 2023 14:06:54 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id mf7so38407395ejc.6
        for <kvm@vger.kernel.org>; Mon, 06 Feb 2023 14:06:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=FlqDpyPpyRc3qfoTqJA/NEC+lUkjqfAetcGAJ7W0YRk=;
        b=OUpBEhFa7AukjzvmDY6ZgsST5BbCa+a07g/Loxlvi6mzdVKDJnDhTnYgCFfBiF1Hwh
         SGI3qwaTsGGuMn3gyTcge2k3iTI5WUJ27p9rg98UBHx4Jka2eJ6s77AyAljWHbCtmOvY
         PgcNh5teA5pFxoDTv8SuZXLtOqS1wXt8YT7uISGWA/hWGeedU17WuRFX1CMRfZep0FO0
         PkCTMSenVclsoQjzlMJgFmR5SuzK0XiojRi3dXxyOnimHjxp/uR60w8eCyhyrVMZd6aE
         igd2mWvfq7oS9oPPJ2qybPqEs3KCNOjYhVGSKdqJnhGng1Gxuaan2LnDDkWIqVbxtK42
         pXZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FlqDpyPpyRc3qfoTqJA/NEC+lUkjqfAetcGAJ7W0YRk=;
        b=jNCm4d177OCbqmUmSR+I+amCroYz5AsDlNQqnLkgSEYRfRnYt0lWLQ+vnvLTm1pUi0
         sFujfWAFFpbEARoQTn+NiBbuKZioVr0E7FXMg+6SGyXsRs1I/qJXf2zqukSKNEuP68nn
         NVfqNWp+NdSk39RMrPKHfM/10TU2zYE/EqoakYT4jov7iCIX3w5/B3MEK6NAe5+LUBPL
         KxiNYlIpdGbiaXu3M6/zZ7Tut5cLEzUBYhYMIayQXZcFD1MD18mBv7ImFqRdqXttIJ9p
         f0QMF4WXHFl2GIMrHiJufc+0odoYjKxW4tyh9tU9zZaZwrrRkY9OT/HAfFbsRHqNmAam
         IYTg==
X-Gm-Message-State: AO0yUKWpVoTJv9L+rAwpiPNqQJ/x6T5btdzTVV3oBQGgDABjGhKpdWiZ
        F+v6qAGibA6dighr98i21dMrQoczXrMi0zNEPzBYhFBRf4emtarABOg=
X-Google-Smtp-Source: AK7set+MSciw1yovA+CyXf3oy5wxbvRarHn2fxoh4HMEokR1d+PMS4qDyCcyC2fXMEDgcR8rGBrjt4vRwqpLDZuSNYo=
X-Received: by 2002:a17:906:3008:b0:878:8bd5:4bdf with SMTP id
 8-20020a170906300800b008788bd54bdfmr258115ejz.270.1675721212602; Mon, 06 Feb
 2023 14:06:52 -0800 (PST)
MIME-Version: 1.0
References: <20230203192822.106773-1-vipinsh@google.com> <20230203192822.106773-3-vipinsh@google.com>
In-Reply-To: <20230203192822.106773-3-vipinsh@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Mon, 6 Feb 2023 14:06:41 -0800
Message-ID: <CANgfPd8en316O=iTijS5jseM8_eCYm822iwT2d-7Q+jhJBy+HQ@mail.gmail.com>
Subject: Re: [Patch v2 2/5] KVM: x86/mmu: Optimize SPTE change flow for clear-dirty-log
To:     Vipin Sharma <vipinsh@google.com>
Cc:     seanjc@google.com, pbonzini@redhat.com, dmatlack@google.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 3, 2023 at 11:28 AM Vipin Sharma <vipinsh@google.com> wrote:
>
> No need to check all of the conditions in __handle_changed_spte() as
> clearing dirty log only involves resetting dirty or writable bit.
>
> Make atomic change to dirty or writable bit and mark pfn dirty.
>
> Tested on 160 VCPU-160 GB VM and found that performance of clear dirty
> log stage improved by ~38% in dirty_log_perf_test

Dang! That's a big improvement.

...
> diff --git a/arch/x86/kvm/mmu/tdp_iter.h b/arch/x86/kvm/mmu/tdp_iter.h
> index 30a52e5e68de..21046b34f94e 100644
> --- a/arch/x86/kvm/mmu/tdp_iter.h
> +++ b/arch/x86/kvm/mmu/tdp_iter.h
> @@ -121,4 +121,17 @@ void tdp_iter_start(struct tdp_iter *iter, struct kvm_mmu_page *root,
>  void tdp_iter_next(struct tdp_iter *iter);
>  void tdp_iter_restart(struct tdp_iter *iter);
>
> +static inline u64 kvm_tdp_mmu_clear_spte_bit(struct tdp_iter *iter, u64 mask)
> +{
> +       atomic64_t *sptep;
> +
> +       if (kvm_tdp_mmu_spte_has_volatile_bits(iter->old_spte, iter->level)) {
> +               sptep = (atomic64_t *)rcu_dereference(iter->sptep);
> +               return (u64)atomic64_fetch_and(~mask, sptep);
> +       }
> +
> +       __kvm_tdp_mmu_write_spte(iter->sptep, iter->old_spte & ~mask);
> +       return iter->old_spte;
> +}
> +

If you do end up sending another version of the series and feel like
breaking up this patch, you could probably split this part out since
the change to how we set the SPTE and how we handle that change are
somewhat independent. I like the switch to atomic64_fetch_and though.
No idea if it's faster, but I would believe it could be.

Totally optional, but there's currently no validation on the mask.
Maybe we're only calling this in one place, but it might be worth
clarifying the limits (if any) on what bits can be set in the mask. I
don't think there necessarily need to be limits as of this commit, but
the handling around this function where it's called here would
obviously not be sufficient if the mask were -1UL or something.

>  #endif /* __KVM_X86_MMU_TDP_ITER_H */
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index bba33aea0fb0..83f15052aa6c 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -710,18 +710,13 @@ static inline int tdp_mmu_zap_spte_atomic(struct kvm *kvm,
>   *                   notifier for access tracking. Leaving record_acc_track
>   *                   unset in that case prevents page accesses from being
>   *                   double counted.
> - * @record_dirty_log: Record the page as dirty in the dirty bitmap if
> - *                   appropriate for the change being made. Should be set
> - *                   unless performing certain dirty logging operations.
> - *                   Leaving record_dirty_log unset in that case prevents page
> - *                   writes from being double counted.

I was kind of hesitant about getting rid of this but now that I see it
going, I love it.

...

> @@ -1694,18 +1681,22 @@ static void clear_dirty_pt_masked(struct kvm *kvm, struct kvm_mmu_page *root,
>                 mask &= ~(1UL << (iter.gfn - gfn));
>
>                 if (wrprot || spte_ad_need_write_protect(iter.old_spte)) {
> -                       if (is_writable_pte(iter.old_spte))
> -                               new_spte = iter.old_spte & ~PT_WRITABLE_MASK;
> -                       else
> +                       if (!is_writable_pte(iter.old_spte))
>                                 continue;
> +
> +                       clear_bits = PT_WRITABLE_MASK;
>                 } else {
> -                       if (iter.old_spte & shadow_dirty_mask)
> -                               new_spte = iter.old_spte & ~shadow_dirty_mask;
> -                       else
> +                       if (!(iter.old_spte & shadow_dirty_mask))
>                                 continue;
> +
> +                       clear_bits = shadow_dirty_mask;
>                 }
>
> -               tdp_mmu_set_spte_no_dirty_log(kvm, &iter, new_spte);
> +               iter.old_spte = kvm_tdp_mmu_clear_spte_bit(&iter, clear_bits);
> +               trace_kvm_tdp_mmu_spte_changed(iter.as_id, iter.gfn, iter.level,
> +                                              iter.old_spte,
> +                                              iter.old_spte & ~clear_bits);
> +               kvm_set_pfn_dirty(spte_to_pfn(iter.old_spte));
>         }

Nice!
