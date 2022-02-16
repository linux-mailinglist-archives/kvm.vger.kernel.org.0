Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D2E04B9149
	for <lists+kvm@lfdr.de>; Wed, 16 Feb 2022 20:37:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233665AbiBPThi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Feb 2022 14:37:38 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230187AbiBPThh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Feb 2022 14:37:37 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD17EC1C8A
        for <kvm@vger.kernel.org>; Wed, 16 Feb 2022 11:37:24 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id a8so1593235ejc.8
        for <kvm@vger.kernel.org>; Wed, 16 Feb 2022 11:37:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mRg5i9FxBCuyu7j5+LZOCq98UGmFvnJVRmxunwhbq/g=;
        b=eUIvgz7x9myH0OIKWZ9CMO7ztlHpipKLwppJwkxGJw8MAKEgbRikaFuMPovigUSvof
         0dmXc6KHzxzyYD/bmkWodfzarqDJDoUw5laPAkTRSQsLG6UtThvJ/r7U6mFLpf4vLGHg
         K2LOYSQc1VJJJHQecTQO3pkfScqtGC4egP350zfINuBWDLizpUGpurDK/U8ZxLLvjdpJ
         5V0nasEgcXF2XMquY1nOVX8sKmo8SQfATNjlpsYiqEmwQR/kZYmUy0jJQ3HpPvlsYYol
         4WgjkoD/BDQ6jY0E0pA9mMH3M0f7dlFTvzwWcjJc9czAXRL/7YJAMzMsPN6LlxxpDvkW
         S2Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mRg5i9FxBCuyu7j5+LZOCq98UGmFvnJVRmxunwhbq/g=;
        b=1hEF7UaOFG3Md2O7W+I8oIViNQuZeouac3yMNCQqKzpEq37Izlj0rMU+j+mW4YRDIL
         kNYyK6qDWHNEQKuUBO4Oi7+Ie4fT8/UEFy5KkRzD76ohb0HnwsBfioK7SzYs4/AKCg4j
         fiQoBxWd2WjqjfeAISJo7SFPdz8hTFt2HxrxyBg3s0Bp57V9Dtouh0D1ClVawCDBUVar
         6vgRiILKZLNDQDk3Py+lKMZ3DrFUrx7fx/hVKGyipMtJEbBfW/hekg+SnpLvAhWbe4+i
         7mr8y7qulLtrQHEtsIErWnUKM+ddRhhXkUVONsamQ7tzl19NytA8tlv43k8fNIgIibRV
         kdlg==
X-Gm-Message-State: AOAM530zq7mbmbe6pSFHJzQHtNbUwnVWwTbYweiw+RYK3qiuANCH5rQr
        vQBCxsa3OKsuaK13f1D55HSOyyDWO9ir8UPWBw8ySg==
X-Google-Smtp-Source: ABdhPJwPrMhC4KjCIlJeigopCpNBlxWvgbEbPbtKAGIiCsTsJAwvC/BZelt3mClFZjyWgh1l5eSgsyn0rI+Nz5yzWaU=
X-Received: by 2002:a17:906:5cb:b0:6cf:954:d84d with SMTP id
 t11-20020a17090605cb00b006cf0954d84dmr3772227ejt.560.1645040243121; Wed, 16
 Feb 2022 11:37:23 -0800 (PST)
MIME-Version: 1.0
References: <20220203010051.2813563-1-dmatlack@google.com> <20220203010051.2813563-7-dmatlack@google.com>
In-Reply-To: <20220203010051.2813563-7-dmatlack@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Wed, 16 Feb 2022 11:37:11 -0800
Message-ID: <CANgfPd-5HM7+etr=TCEACMSSgrZo3vV8LmA5JbJw4x8Q5VnLmw@mail.gmail.com>
Subject: Re: [PATCH 06/23] KVM: x86/mmu: Separate shadow MMU sp allocation
 from initialization
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        leksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Peter Feiner <pfeiner@google.com>,
        Andrew Jones <drjones@redhat.com>,
        "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>,
        kvm <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 2, 2022 at 5:02 PM David Matlack <dmatlack@google.com> wrote:
>
> Separate the code that allocates a new shadow page from the vCPU caches
> from the code that initializes it. This is in preparation for creating
> new shadow pages from VM ioctls for eager page splitting, where we do
> not have access to the vCPU caches.
>
> No functional change intended.
>
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 44 +++++++++++++++++++++---------------------
>  1 file changed, 22 insertions(+), 22 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 49f82addf4b5..d4f90a10b652 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -1718,7 +1718,7 @@ static void drop_parent_pte(struct kvm_mmu_page *sp,
>         mmu_spte_clear_no_track(parent_pte);
>  }
>
> -static struct kvm_mmu_page *kvm_mmu_alloc_sp(struct kvm_vcpu *vcpu, int direct)
> +static struct kvm_mmu_page *kvm_mmu_alloc_sp(struct kvm_vcpu *vcpu, bool direct)
>  {
>         struct kvm_mmu_page *sp;
>
> @@ -1726,16 +1726,7 @@ static struct kvm_mmu_page *kvm_mmu_alloc_sp(struct kvm_vcpu *vcpu, int direct)
>         sp->spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache);
>         if (!direct)
>                 sp->gfns = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_gfn_array_cache);
> -       set_page_private(virt_to_page(sp->spt), (unsigned long)sp);

I'd be inclined to leave this in the allocation function instead of
moving it to the init function. It might not be any less code, but if
you're doing the sp -> page link here, you might as well do the page
-> sp link too.

>
>
> -       /*
> -        * active_mmu_pages must be a FIFO list, as kvm_zap_obsolete_pages()
> -        * depends on valid pages being added to the head of the list.  See
> -        * comments in kvm_zap_obsolete_pages().
> -        */
> -       sp->mmu_valid_gen = vcpu->kvm->arch.mmu_valid_gen;
> -       list_add(&sp->link, &vcpu->kvm->arch.active_mmu_pages);
> -       kvm_mod_used_mmu_pages(vcpu->kvm, +1);
>         return sp;
>  }
>
> @@ -2144,27 +2135,34 @@ static struct kvm_mmu_page *kvm_mmu_get_existing_sp(struct kvm_vcpu *vcpu,
>         return sp;
>  }
>
> -static struct kvm_mmu_page *kvm_mmu_create_sp(struct kvm_vcpu *vcpu,
> -                                             struct kvm_memory_slot *slot,
> -                                             gfn_t gfn,
> -                                             union kvm_mmu_page_role role)
> +
> +static void kvm_mmu_init_sp(struct kvm *kvm, struct kvm_mmu_page *sp,
> +                           struct kvm_memory_slot *slot, gfn_t gfn,
> +                           union kvm_mmu_page_role role)
>  {
> -       struct kvm_mmu_page *sp;
>         struct hlist_head *sp_list;
>
> -       ++vcpu->kvm->stat.mmu_cache_miss;
> +       ++kvm->stat.mmu_cache_miss;
> +
> +       set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
>
> -       sp = kvm_mmu_alloc_sp(vcpu, role.direct);
>         sp->gfn = gfn;
>         sp->role = role;
> +       sp->mmu_valid_gen = kvm->arch.mmu_valid_gen;
>
> -       sp_list = &vcpu->kvm->arch.mmu_page_hash[kvm_page_table_hashfn(gfn)];
> +       /*
> +        * active_mmu_pages must be a FIFO list, as kvm_zap_obsolete_pages()
> +        * depends on valid pages being added to the head of the list.  See
> +        * comments in kvm_zap_obsolete_pages().
> +        */
> +       list_add(&sp->link, &kvm->arch.active_mmu_pages);
> +       kvm_mod_used_mmu_pages(kvm, 1);
> +
> +       sp_list = &kvm->arch.mmu_page_hash[kvm_page_table_hashfn(gfn)];
>         hlist_add_head(&sp->hash_link, sp_list);
>
>         if (!role.direct)
> -               account_shadowed(vcpu->kvm, slot, sp);
> -
> -       return sp;
> +               account_shadowed(kvm, slot, sp);
>  }
>
>  static struct kvm_mmu_page *kvm_mmu_get_sp(struct kvm_vcpu *vcpu, gfn_t gfn,
> @@ -2179,8 +2177,10 @@ static struct kvm_mmu_page *kvm_mmu_get_sp(struct kvm_vcpu *vcpu, gfn_t gfn,
>                 goto out;
>
>         created = true;
> +       sp = kvm_mmu_alloc_sp(vcpu, role.direct);
> +
>         slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
> -       sp = kvm_mmu_create_sp(vcpu, slot, gfn, role);
> +       kvm_mmu_init_sp(vcpu->kvm, sp, slot, gfn, role);
>
>  out:
>         trace_kvm_mmu_get_page(sp, created);
> --
> 2.35.0.rc2.247.g8bbb082509-goog
>
