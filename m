Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95C3F4C7CD6
	for <lists+kvm@lfdr.de>; Mon, 28 Feb 2022 23:06:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231196AbiB1WGW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Feb 2022 17:06:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231274AbiB1WGR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Feb 2022 17:06:17 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 836D3C4E0B
        for <kvm@vger.kernel.org>; Mon, 28 Feb 2022 14:05:37 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id a8so27659804ejc.8
        for <kvm@vger.kernel.org>; Mon, 28 Feb 2022 14:05:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JvcF/uCui9GejoorR8kzc/i0AUGjtyXAWJIZdvZ03NQ=;
        b=cSeWu9QLPxDY4T3cjtJyzxfFc2K1Ozx68VyjxgERiihlulc7eVq/5SblXRpR/nvCw6
         tXE0HgjcCsUowDAj2oeNw+E+Qq+Wy2qrjCHpKVu+gzi4+1pJHnNqzf+IsjSX1g4q1NAf
         kTWfcOGfMFG8nUWsdKEKIKE9+0k2s247ZsfsMCIYPdVKniRsbxs+lgaJJiU9ySveyNGy
         rBrbgGCnny0NIcJb9dfeUGs5Gl5kxLLYJRHLU+oj2gXvhWOJVoW6yuNGWa4KXzPs9Z8E
         9l5BIMEj9AKjteiFx5OIqPPaLHkZp6c9Ey+JU7UVVCvNsOoZzY6RK8V2WELW6fGEPk0/
         wjnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JvcF/uCui9GejoorR8kzc/i0AUGjtyXAWJIZdvZ03NQ=;
        b=Pnh47ccLuK9EC4rUys4r4qDtPK9fL23al2kFHNT9tdrs/bX7O4gWBoWfVJai2AKzsM
         JL6g1+jFfEC/k84zaWFbROIre0APPRH4V4jY0VSFlsQkrtnbjMbyY2m+I+nxZVca26yh
         YOv4M4JoKojti1i2vCE3TdSjsxXkV0brLeAgASMh4VRW5YygsDXgW6uASpoLnZEssyhZ
         jUSTb/Z5Den/CoEj6E0ai3D60C8L8x2qeGUeSYEOif4vTgtRmLmcy/9zNBRkAlVzgNe0
         Ci+Wjh/jJlim6+Xy2wuOU5CyJVcCDpaYOX61rZ6hz620Jw1Z2NpSIeQyf5stSDYVjA2E
         wNlg==
X-Gm-Message-State: AOAM5313/Q70n137bW/5K4PIVCQkLhjrihLa7KxBfi78dPCsGYjvlw8J
        u1WaBk1qcL2Ilte9aPep4MrLYRhQYxjFQn5ZG5S7qw==
X-Google-Smtp-Source: ABdhPJwpkgVdZCj65iCTvwkPVrG3pCwzeMtzGd+dQTnVXHD2RKASDg/uq8cVcFevBFQRY7nJ1J8BcX2gApQC7gUftqA=
X-Received: by 2002:a17:906:eda9:b0:6ce:e24e:7b95 with SMTP id
 sa9-20020a170906eda900b006cee24e7b95mr16927248ejb.314.1646085935827; Mon, 28
 Feb 2022 14:05:35 -0800 (PST)
MIME-Version: 1.0
References: <20220225182248.3812651-1-seanjc@google.com> <20220225182248.3812651-4-seanjc@google.com>
In-Reply-To: <20220225182248.3812651-4-seanjc@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Mon, 28 Feb 2022 14:05:24 -0800
Message-ID: <CANgfPd_yjt7AL0aC++=QHkTnnbwi+qsnihc0S2dEZryytoyMGg@mail.gmail.com>
Subject: Re: [PATCH v2 3/7] KVM: Drop kvm_reload_remote_mmus(), open code
 request in x86 users
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Lai Jiangshan <jiangshanlai@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-18.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 25, 2022 at 10:22 AM Sean Christopherson <seanjc@google.com> wrote:
>
> Remove the generic kvm_reload_remote_mmus() and open code its
> functionality into the two x86 callers.  x86 is (obviously) the only
> architecture that uses the hook, and is also the only architecture that
> uses KVM_REQ_MMU_RELOAD in a way that's consistent with the name.  That
> will change in a future patch, as x86's usage when zapping a single
> shadow page x86 doesn't actually _need_ to reload all vCPUs' MMUs, only
> MMUs whose root is being zapped actually need to be reloaded.
>
> s390 also uses KVM_REQ_MMU_RELOAD, but for a slightly different purpose.
>
> Drop the generic code in anticipation of implementing s390 and x86 arch
> specific requests, which will allow dropping KVM_REQ_MMU_RELOAD entirely.
>
> Opportunistically reword the x86 TDP MMU comment to avoid making
> references to functions (and requests!) when possible, and to remove the
> rather ambiguous "this".
>
> No functional change intended.
>
> Cc: Ben Gardon <bgardon@google.com>

Reviewed-by: Ben Gardon <bgardon@google.com>

> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c   | 14 +++++++-------
>  include/linux/kvm_host.h |  1 -
>  virt/kvm/kvm_main.c      |  5 -----
>  3 files changed, 7 insertions(+), 13 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index b2c1c4eb6007..32c6d4b33d03 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -2353,7 +2353,7 @@ static bool __kvm_mmu_prepare_zap_page(struct kvm *kvm,
>                  * treats invalid shadow pages as being obsolete.
>                  */
>                 if (!is_obsolete_sp(kvm, sp))
> -                       kvm_reload_remote_mmus(kvm);
> +                       kvm_make_all_cpus_request(kvm, KVM_REQ_MMU_RELOAD);
>         }
>
>         if (sp->lpage_disallowed)
> @@ -5639,11 +5639,11 @@ static void kvm_mmu_zap_all_fast(struct kvm *kvm)
>          */
>         kvm->arch.mmu_valid_gen = kvm->arch.mmu_valid_gen ? 0 : 1;
>
> -       /* In order to ensure all threads see this change when
> -        * handling the MMU reload signal, this must happen in the
> -        * same critical section as kvm_reload_remote_mmus, and
> -        * before kvm_zap_obsolete_pages as kvm_zap_obsolete_pages
> -        * could drop the MMU lock and yield.
> +       /*
> +        * In order to ensure all vCPUs drop their soon-to-be invalid roots,
> +        * invalidating TDP MMU roots must be done while holding mmu_lock for
> +        * write and in the same critical section as making the reload request,
> +        * e.g. before kvm_zap_obsolete_pages() could drop mmu_lock and yield.
>          */
>         if (is_tdp_mmu_enabled(kvm))
>                 kvm_tdp_mmu_invalidate_all_roots(kvm);
> @@ -5656,7 +5656,7 @@ static void kvm_mmu_zap_all_fast(struct kvm *kvm)
>          * Note: we need to do this under the protection of mmu_lock,
>          * otherwise, vcpu would purge shadow page but miss tlb flush.
>          */
> -       kvm_reload_remote_mmus(kvm);
> +       kvm_make_all_cpus_request(kvm, KVM_REQ_MMU_RELOAD);
>
>         kvm_zap_obsolete_pages(kvm);
>
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index f11039944c08..0aeb47cffd43 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -1325,7 +1325,6 @@ int kvm_vcpu_yield_to(struct kvm_vcpu *target);
>  void kvm_vcpu_on_spin(struct kvm_vcpu *vcpu, bool usermode_vcpu_not_eligible);
>
>  void kvm_flush_remote_tlbs(struct kvm *kvm);
> -void kvm_reload_remote_mmus(struct kvm *kvm);
>
>  #ifdef KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE
>  int kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min);
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 83c57bcc6eb6..66bb1631cb89 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -354,11 +354,6 @@ void kvm_flush_remote_tlbs(struct kvm *kvm)
>  EXPORT_SYMBOL_GPL(kvm_flush_remote_tlbs);
>  #endif
>
> -void kvm_reload_remote_mmus(struct kvm *kvm)
> -{
> -       kvm_make_all_cpus_request(kvm, KVM_REQ_MMU_RELOAD);
> -}
> -
>  #ifdef KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE
>  static inline void *mmu_memory_cache_alloc_obj(struct kvm_mmu_memory_cache *mc,
>                                                gfp_t gfp_flags)
> --
> 2.35.1.574.g5d30c73bfb-goog
>
