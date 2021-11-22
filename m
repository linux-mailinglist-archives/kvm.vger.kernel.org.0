Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B3B145952B
	for <lists+kvm@lfdr.de>; Mon, 22 Nov 2021 19:56:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234361AbhKVS7Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Nov 2021 13:59:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234897AbhKVS7X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Nov 2021 13:59:23 -0500
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60D1EC06174A
        for <kvm@vger.kernel.org>; Mon, 22 Nov 2021 10:56:16 -0800 (PST)
Received: by mail-il1-x134.google.com with SMTP id h23so19162111ila.4
        for <kvm@vger.kernel.org>; Mon, 22 Nov 2021 10:56:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OQKIEyvfXz0qzouYuFyz10TNkmZ9Jk/qkmry7bJ0hqE=;
        b=OCFI9UI8k5QD9mSL+mtD2eGKIOOe5tAowRbnGtf0w3jjycWIXCsdNRM2FAXykzrInZ
         oVBcRM5EVttBSV7OV69jYZXeVyBDfiz5KwD3RK2JpMGs4sDF6CSBDuZo8NWvgUNlIriq
         mmBfpOwTci/Lp5LtctpJTCc6tIxINZ+vkQxqR81k+BfX/v6sRzYuST3cIWocHyPkQM0V
         TDhBwjpLMcrQgOE9rIwY1hx+z/To0U/0csejcNXHt+YqU0YA5VDq8SZB3pYbx2zcXqnp
         ZT1BvhbSK6BT9PRrIx9/VgumC5yQjXX7H2pKuAQ/3LljdGrPYRD7cvN9GklTG9AgPwUX
         xwdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OQKIEyvfXz0qzouYuFyz10TNkmZ9Jk/qkmry7bJ0hqE=;
        b=rmF1OVecZkJpKmTEFdgKuDyvJzbTb64wUdSLpIvbmo9JngpWVUflUdKIhRWbXNiTpm
         uOgjeE2a/LSutz+sfxPTajYcBjThKeRM49BR+Y6h7phpFeX08hdhnUCj1YpAwaTMkMkM
         b7w+ixfy9Kl1361UulQLIUXcLCk5XFTEJV8HH7ZuCVuSWFxF51XchLNznvc5zUllMrfd
         rbAN9bFbPocgfYnTzFqP8CyKi1xTVOFBjGs9ZQWNWBc36YyNdiq8kXQv7YUw0sxhXI/o
         22MpChdcLZLx+pii7Vwg3QVVD7gqGq9LV8rT3S4qtRe7tUMXxGUJxByqrikOb81785Ut
         /5JA==
X-Gm-Message-State: AOAM530FpUsbUnBV8gGEn+/1rvVdDDpTNI5QLwvl84KwhPadd9b1L80W
        TgbLsSAfFlFPendWF+bU9irqNmddztWvSJ6D64BvMw==
X-Google-Smtp-Source: ABdhPJy8LfOz0NeBJtXYAGlLRcXJFm0cpAN19MLOng5+KnIJqSoZ9SerjWTINvNG7tFShqs9KJQ7VyayvWv1KsqLnYg=
X-Received: by 2002:a05:6e02:547:: with SMTP id i7mr21217550ils.298.1637607375629;
 Mon, 22 Nov 2021 10:56:15 -0800 (PST)
MIME-Version: 1.0
References: <20211119235759.1304274-1-dmatlack@google.com> <20211119235759.1304274-8-dmatlack@google.com>
In-Reply-To: <20211119235759.1304274-8-dmatlack@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Mon, 22 Nov 2021 10:56:04 -0800
Message-ID: <CANgfPd9Ycn31ZVWfs0xOeVc8dBMwcMofO4f4YQm-bGijuGxR4g@mail.gmail.com>
Subject: Re: [RFC PATCH 07/15] KVM: x86/mmu: Pass in vcpu->arch.mmu_caches
 instead of vcpu
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
> Pass in vcpu->arch.mmu_caches to alloc_{,_child}_tdp_mmu_page() instead
> of the vcpu. This is in preparation for eagerly splitting large pages
> during VM-ioctls which does not have access to the vCPU mmu_caches.
>
> No functional change intended.
>
> Signed-off-by: David Matlack <dmatlack@google.com>

Reviewed-by: Ben Gardon <bgardon@google.com>


> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 16 +++++++---------
>  1 file changed, 7 insertions(+), 9 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 1a409992a57f..ff4d83ad7580 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -157,14 +157,11 @@ static struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
>                 if (kvm_mmu_page_as_id(_root) != _as_id) {              \
>                 } else
>
> -static struct kvm_mmu_page *alloc_tdp_mmu_page(struct kvm_vcpu *vcpu, gfn_t gfn,
> -                                              union kvm_mmu_page_role role)
> +static struct kvm_mmu_page *alloc_tdp_mmu_page(struct kvm_mmu_memory_caches *mmu_caches,
> +                                              gfn_t gfn, union kvm_mmu_page_role role)
>  {
> -       struct kvm_mmu_memory_caches *mmu_caches;
>         struct kvm_mmu_page *sp;
>
> -       mmu_caches = &vcpu->arch.mmu_caches;
> -
>         sp = kvm_mmu_memory_cache_alloc(&mmu_caches->page_header_cache);
>         sp->spt = kvm_mmu_memory_cache_alloc(&mmu_caches->shadow_page_cache);
>         set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
> @@ -178,7 +175,8 @@ static struct kvm_mmu_page *alloc_tdp_mmu_page(struct kvm_vcpu *vcpu, gfn_t gfn,
>         return sp;
>  }
>
> -static struct kvm_mmu_page *alloc_child_tdp_mmu_page(struct kvm_vcpu *vcpu, struct tdp_iter *iter)
> +static struct kvm_mmu_page *alloc_child_tdp_mmu_page(struct kvm_mmu_memory_caches *mmu_caches,
> +                                                    struct tdp_iter *iter)
>  {
>         struct kvm_mmu_page *parent_sp;
>         union kvm_mmu_page_role role;
> @@ -188,7 +186,7 @@ static struct kvm_mmu_page *alloc_child_tdp_mmu_page(struct kvm_vcpu *vcpu, stru
>         role = parent_sp->role;
>         role.level--;
>
> -       return alloc_tdp_mmu_page(vcpu, iter->gfn, role);
> +       return alloc_tdp_mmu_page(mmu_caches, iter->gfn, role);
>  }
>
>  hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
> @@ -213,7 +211,7 @@ hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
>                         goto out;
>         }
>
> -       root = alloc_tdp_mmu_page(vcpu, 0, role);
> +       root = alloc_tdp_mmu_page(&vcpu->arch.mmu_caches, 0, role);
>         refcount_set(&root->tdp_mmu_root_count, 1);
>
>         spin_lock(&kvm->arch.tdp_mmu_pages_lock);
> @@ -1031,7 +1029,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>                         if (is_removed_spte(iter.old_spte))
>                                 break;
>
> -                       sp = alloc_child_tdp_mmu_page(vcpu, &iter);
> +                       sp = alloc_child_tdp_mmu_page(&vcpu->arch.mmu_caches, &iter);
>                         if (!tdp_mmu_install_sp_atomic(vcpu->kvm, &iter, sp, account_nx))
>                                 break;
>                 }
> --
> 2.34.0.rc2.393.gf8c9666880-goog
>
