Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7373356793
	for <lists+kvm@lfdr.de>; Wed,  7 Apr 2021 11:03:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349877AbhDGJDm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Apr 2021 05:03:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239586AbhDGJDl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Apr 2021 05:03:41 -0400
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F462C06174A;
        Wed,  7 Apr 2021 02:03:30 -0700 (PDT)
Received: by mail-oi1-x22a.google.com with SMTP id k25so18047268oic.4;
        Wed, 07 Apr 2021 02:03:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GPeMpQW+Y5lQJAmVYLhBnP7OU/14j0M55xHvhj50bTE=;
        b=XB4tkI/D0rx83UvVfaq3nU85IGV7tlB9UDvSrJgv+ASys6/fzFEdJe0I06Cn5SX7l+
         S9W2dj8sOqFlqUHwOs0pDS9+BlAb5A4xcJW1ivx3Gbv9bWsB3wo7RhJaVt/3AS1YvElB
         JgqQwj77iFvHbnbjDSoGGCjwpgHAgGg95OhRjCDf2p4zaeTB80SohsWeVuEjwCQpTdgT
         VXmvirTqYjt9LqTgrVNNH4HekL3A31Cw0s7VEUr2KPluGD0b/wO3wK2dfUmg+pXHxX54
         kunvhPtnpCfsh15AoWoJFBYPt4XHeNBy4oybuEUYGiG5E/m7CVxZqQ8Mq1d/SHgHI7eP
         oNew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GPeMpQW+Y5lQJAmVYLhBnP7OU/14j0M55xHvhj50bTE=;
        b=k0PeTJAD5TLMOh4NH15imF24oe1OaTNALJ9Pio8uJqAIbgvCWZVnP1jlTfN21VX3hQ
         fm95bgz8rAElAOth5PlUgUiT6xintxZFx5w8P6ah/tG7QsNHp0HImQ7wJAdAJP6RXlBp
         ELye6PbTs9yLg+AN2Hk/WdAwhtdxgS8sW+1Ps7eUcSXWG5YX7LNffijHWU/XbW/uoJT+
         MOfbux1ds6KOpgCDqTksUnslWaj1Mb+EXwzXfys2+Qi9GWDwrCwU9kgjTA76+mQ5+qn7
         wo1zSQuGsG0Luvrs0ifRRuRcDJ1ZZM+lXhT+VkKiYxh+xINyc7afztK1vLenGH/hYNbL
         ZzLQ==
X-Gm-Message-State: AOAM5318s0oSgjuDozIxne3jt2zSQ9NnHyatpw6fJKwNJ3Cu5Syoe0NS
        9yyb5I6Af6JHCmxJSWuoCseJW7j2ZO0zMQ+ijNM=
X-Google-Smtp-Source: ABdhPJxyw/r6k87xfjnQTDJyhr+w2lVLfHwJf0CLBwwmX33evgv2H1n6rqqrXs5cjG5hLKsLujqxo7Z2fW1nZCgMaOc=
X-Received: by 2002:a54:408a:: with SMTP id i10mr1582600oii.141.1617786209542;
 Wed, 07 Apr 2021 02:03:29 -0700 (PDT)
MIME-Version: 1.0
References: <20210406190740.4055679-1-seanjc@google.com>
In-Reply-To: <20210406190740.4055679-1-seanjc@google.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Wed, 7 Apr 2021 17:03:17 +0800
Message-ID: <CANRm+CyjA3UPQvZoJBZuW0hfPkc8t_p71v_D5ChC5jftibLdog@mail.gmail.com>
Subject: Re: [PATCH v2] KVM: Explicitly use GFP_KERNEL_ACCOUNT for 'struct
 kvm_vcpu' allocations
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 7 Apr 2021 at 03:07, Sean Christopherson <seanjc@google.com> wrote:
>
> Use GFP_KERNEL_ACCOUNT when allocating vCPUs to make it more obvious that
> that the allocations are accounted, to make it easier to audit KVM's
> allocations in the future, and to be consistent with other cache usage in
> KVM.
>
> When using SLAB/SLUB, this is a nop as the cache itself is created with
> SLAB_ACCOUNT.
>
> When using SLOB, there are caveats within caveats.  SLOB doesn't honor
> SLAB_ACCOUNT, so passing GFP_KERNEL_ACCOUNT will result in vCPU
> allocations now being accounted.   But, even that depends on internal
> SLOB details as SLOB will only go to the page allocator when its cache is
> depleted.  That just happens to be extremely likely for vCPUs because the
> size of kvm_vcpu is larger than the a page for almost all combinations of
> architecture and page size.  Whether or not the SLOB behavior is by
> design is unknown; it's just as likely that no SLOB users care about
> accounding and so no one has bothered to implemented support in SLOB.
> Regardless, accounting vCPU allocations will not break SLOB+KVM+cgroup
> users, if any exist.
>
> Cc: Wanpeng Li <kernellwp@gmail.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Wanpeng Li <wanpengli@tencent.com>

> ---
>
> v2: Drop the Fixes tag and rewrite the changelog since this is a nop when
>     using SLUB or SLAB. [Wanpeng]
>
>  virt/kvm/kvm_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 0a481e7780f0..580f98386b42 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -3192,7 +3192,7 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
>         if (r)
>                 goto vcpu_decrement;
>
> -       vcpu = kmem_cache_zalloc(kvm_vcpu_cache, GFP_KERNEL);
> +       vcpu = kmem_cache_zalloc(kvm_vcpu_cache, GFP_KERNEL_ACCOUNT);
>         if (!vcpu) {
>                 r = -ENOMEM;
>                 goto vcpu_decrement;
> --
> 2.31.0.208.g409f899ff0-goog
>
