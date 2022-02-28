Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BA894C7E44
	for <lists+kvm@lfdr.de>; Tue,  1 Mar 2022 00:26:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229840AbiB1X1C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Feb 2022 18:27:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229842AbiB1X04 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Feb 2022 18:26:56 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A791C7E8E
        for <kvm@vger.kernel.org>; Mon, 28 Feb 2022 15:26:17 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id qk11so28039526ejb.2
        for <kvm@vger.kernel.org>; Mon, 28 Feb 2022 15:26:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IYj0iyPbAPJYK0pqqrQFmSosxig3GLvPltNcBRpBH2o=;
        b=iilCwxcJirrROzQlokAzirElITvzz8NVS309xa9R+fmGw9330A74LwBK3eZYQ3xy9n
         rkHxmIEDL09h+td2iWT3rJUObUBT6IN+zk9ezdTBBr1ySUm5aMgocqlq5Wp11cPe8ZNl
         ZqlyQsCZVSY7B2Z7kItx9x1BlIxIyzmf9rGVSmevoYvCMc3XR0zO/d7FJyGzHSdIaYoR
         NwJ1EOZz7pG4uMAOsjdUKz0MokxuetIYWe7DB7CFqDZL1LmrOI5am0cFISjMCncJLpJt
         9nkQE3cm2ATdP4rNDTAiLca6Hhh6myJYWOWRrKwlIg4wT3BPqIwz9IMq9iEl3Q3pbG7c
         WfZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IYj0iyPbAPJYK0pqqrQFmSosxig3GLvPltNcBRpBH2o=;
        b=HSZRZfNQ9nEAkc8Rxe5Bq3M6QQmgBUrOqxRnKVshVMEiA4GJdiNlJTe2oa6bQCk4V+
         1o8T5L2rqBX/NawDHdBSN2LR7/ejVUpfP1lpuaZaJ4ch8aMksYzk31dN+NpOuaNr4qr+
         AYZ/+nf4J+f1WyG7Wn3Uu81iGx44XgJd/H0FFzRU4ZmYEQB0AEwIysnpVBkwzuUW6M+Z
         1icDuqbxMm8S8oMhSBrtcNCEWvyTtulXYN7m57hFR7wjrdI4TlvbVa9OGNSiMDepcwMF
         ii2EKfACyoOWlJiTxKmN4CuphOqd09sJITMgM1kuby92DqVqRJwcJJWFD/0zmpvAal0b
         gmjg==
X-Gm-Message-State: AOAM533DGJUOeE+jomD5VueZNKShEHlBPbZ7GkfdwVqHN9j2w5sKXkaH
        Sn2DXUHSUvPNCDl6naczcDEfsrwVqTPR6HXhroTioP4x+/M=
X-Google-Smtp-Source: ABdhPJxpETjZNwVKbXGVCTkT2JrkFz4ve5APlqWONORpQL2mt2RgqVbwmsnHQ8548VmwQRXdL5XR+y0muIp0FqJC3kM=
X-Received: by 2002:a17:906:2486:b0:6cf:ced9:e4cc with SMTP id
 e6-20020a170906248600b006cfced9e4ccmr16841097ejb.201.1646090775588; Mon, 28
 Feb 2022 15:26:15 -0800 (PST)
MIME-Version: 1.0
References: <20220226001546.360188-1-seanjc@google.com> <20220226001546.360188-7-seanjc@google.com>
In-Reply-To: <20220226001546.360188-7-seanjc@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Mon, 28 Feb 2022 15:26:04 -0800
Message-ID: <CANgfPd-Y6Z=icq4ajhesu23AOZPNRVq+KNQ-2kyFHyVA6sx5Xg@mail.gmail.com>
Subject: Re: [PATCH v3 06/28] KVM: x86/mmu: Require mmu_lock be held for write
 in unyielding root iter
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Hildenbrand <david@redhat.com>,
        kvm <kvm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        David Matlack <dmatlack@google.com>,
        Mingwei Zhang <mizhang@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-18.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 25, 2022 at 4:16 PM Sean Christopherson <seanjc@google.com> wrote:
>
> Assert that mmu_lock is held for write by users of the yield-unfriendly
> TDP iterator.  The nature of a shared walk means that the caller needs to
> play nice with other tasks modifying the page tables, which is more or
> less the same thing as playing nice with yielding.  Theoretically, KVM
> could gain a flow where it could legitimately take mmu_lock for read in
> a non-preemptible context, but that's highly unlikely and any such case
> should be viewed with a fair amount of scrutiny.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Ben Gardon <bgardon@google.com>

> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 21 +++++++++++++++------
>  1 file changed, 15 insertions(+), 6 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 5994db5d5226..189f21e71c36 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -29,13 +29,16 @@ bool kvm_mmu_init_tdp_mmu(struct kvm *kvm)
>         return true;
>  }
>
> -static __always_inline void kvm_lockdep_assert_mmu_lock_held(struct kvm *kvm,
> +/* Arbitrarily returns true so that this may be used in if statements. */
> +static __always_inline bool kvm_lockdep_assert_mmu_lock_held(struct kvm *kvm,
>                                                              bool shared)
>  {
>         if (shared)
>                 lockdep_assert_held_read(&kvm->mmu_lock);
>         else
>                 lockdep_assert_held_write(&kvm->mmu_lock);
> +
> +       return true;
>  }
>
>  void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm)
> @@ -187,11 +190,17 @@ static struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
>  #define for_each_tdp_mmu_root_yield_safe(_kvm, _root, _as_id, _shared)         \
>         __for_each_tdp_mmu_root_yield_safe(_kvm, _root, _as_id, _shared, ALL_ROOTS)
>
> -#define for_each_tdp_mmu_root(_kvm, _root, _as_id)                             \
> -       list_for_each_entry_rcu(_root, &_kvm->arch.tdp_mmu_roots, link,         \
> -                               lockdep_is_held_type(&kvm->mmu_lock, 0) ||      \
> -                               lockdep_is_held(&kvm->arch.tdp_mmu_pages_lock)) \
> -               if (kvm_mmu_page_as_id(_root) != _as_id) {              \
> +/*
> + * Iterate over all TDP MMU roots.  Requires that mmu_lock be held for write,
> + * the implication being that any flow that holds mmu_lock for read is
> + * inherently yield-friendly and should use the yielf-safe variant above.
> + * Holding mmu_lock for write obviates the need for RCU protection as the list
> + * is guaranteed to be stable.
> + */
> +#define for_each_tdp_mmu_root(_kvm, _root, _as_id)                     \
> +       list_for_each_entry(_root, &_kvm->arch.tdp_mmu_roots, link)     \
> +               if (kvm_lockdep_assert_mmu_lock_held(_kvm, false) &&    \
> +                   kvm_mmu_page_as_id(_root) != _as_id) {              \
>                 } else
>
>  static struct kvm_mmu_page *tdp_mmu_alloc_sp(struct kvm_vcpu *vcpu)
> --
> 2.35.1.574.g5d30c73bfb-goog
>
