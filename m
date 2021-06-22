Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A5C53B102B
	for <lists+kvm@lfdr.de>; Wed, 23 Jun 2021 00:39:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230429AbhFVWll (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 18:41:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230397AbhFVWlk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Jun 2021 18:41:40 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9248BC061756
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 15:39:22 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id a16so332474ljq.3
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 15:39:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qSJCzIJ/W2NmiCitrgwllPiyxSA/GA4EEsJjyUuSU30=;
        b=oyktG73YZVDch+DxSWZBlUYtTGIHzL78FhJ/G2Cbmc71waG4Z3/lFnjGgL/IqYV1jK
         WNgB53E8bbLHlfKWSbaUvcRVQ0hDjyeWDlu7jqP5TG3374N87wFX5FrYF2gH1GdTuiF0
         fvBIv425RseHG54g0rrjatewbzwOGEMhiJN4MGdVl1VZpe+XaMpFC5hPJ2OGz7H2Hnbq
         vIwjhSa91ZLHE9SMWkb1kEBUcrC1dIUSUsc4ei7J+JRpJUywEUIXu3wpLc8QX74URK8i
         Xaf9ixG9oTKgJeT1mj9JiIJ3wlzmN117pUM3cmqzeg4iQxgQp7JVx4peowqd1zckZW2Y
         KNjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qSJCzIJ/W2NmiCitrgwllPiyxSA/GA4EEsJjyUuSU30=;
        b=CeMeeSBjZaEw2Noy3Kma4DgH0xB6YqlPr0kyPyMHISnuthhUGaV0JpvNsnXTDs10nW
         URE4vuYNuAtgic//+XRFiJS9BxeNCdHF7d7d/xxVKkX6kG9mML6EmZ8Fh8m6tuIPvNGN
         QGoilqBG+lLq9USnDTbXwxrpzKCXW9xc9bHoFYRdgR+fUiqmFTDDb5J5lHUvX4WhmzgT
         WQKxjPRHtiwg1aBU8JD9oP5gCTt4TmbdJsfYM+WLiRQA1Zr9Rwxng0IWOI+q+N2V8eA3
         mwH8LeAwaBwI4+TXaCSG0BfBOcCcgbdJRfnitPEOBVtO59o6/hh2m7zTCKRVmcnS/lAY
         /S3A==
X-Gm-Message-State: AOAM533+r+CKUU467Gi2my6+QBoztQ1kPjLtcG2oiyo8VpoZ+kHVDb9a
        lHSBxMk0Q0DstIDtirLvaxogZ3SfEEP/nCL99qSgQQ==
X-Google-Smtp-Source: ABdhPJw2Yg00hzHazgi3MZjogWibQF77gMBQryIXZWZM6wakxe7xGXaEhMgdRdfNr1ZNECK2l63IHrBYnC437gewZdo=
X-Received: by 2002:a2e:9852:: with SMTP id e18mr5092607ljj.383.1624401560707;
 Tue, 22 Jun 2021 15:39:20 -0700 (PDT)
MIME-Version: 1.0
References: <20210622072454.3449146-1-seanjc@google.com>
In-Reply-To: <20210622072454.3449146-1-seanjc@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Tue, 22 Jun 2021 15:38:54 -0700
Message-ID: <CALzav=d+_fLJBJ14=e5aOUa_ufQQdLcNVhTOjeRoodd+7V=NCg@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86/mmu: Don't WARN on a NULL shadow page in TDP MMU check
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 22, 2021 at 12:24 AM Sean Christopherson <seanjc@google.com> wrote:
>
> Treat a NULL shadow page in the "is a TDP MMU" check as valid, non-TDP
> root.  KVM uses a "direct" PAE paging MMU when TDP is disabled and the
> guest is running with paging disabled.  In that case, root_hpa points at
> the pae_root page (of which only 32 bytes are used), not a standard
> shadow page, and the WARN fires (a lot).
>
> Fixes: 0b873fd7fb53 ("KVM: x86/mmu: Remove redundant is_tdp_mmu_enabled check")
> Cc: David Matlack <dmatlack@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Thanks for the fix. I was able to reproduce the issue by running a
kvm-unit-test with EPT=N. I'll add that to my "pre-send-email"
workflow in the future.

Reviewed-by: David Matlack <dmatlack@google.com>

> ---
>  arch/x86/kvm/mmu/tdp_mmu.h | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
> index b981a044ab55..1cae4485b3bc 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.h
> +++ b/arch/x86/kvm/mmu/tdp_mmu.h
> @@ -94,11 +94,13 @@ static inline bool is_tdp_mmu(struct kvm_mmu *mmu)
>         if (WARN_ON(!VALID_PAGE(hpa)))
>                 return false;
>
> +       /*
> +        * A NULL shadow page is legal when shadowing a non-paging guest with
> +        * PAE paging, as the MMU will be direct with root_hpa pointing at the
> +        * pae_root page, not a shadow page.
> +        */
>         sp = to_shadow_page(hpa);
> -       if (WARN_ON(!sp))
> -               return false;
> -
> -       return is_tdp_mmu_page(sp) && sp->root_count;
> +       return sp && is_tdp_mmu_page(sp) && sp->root_count;
>  }
>  #else
>  static inline bool kvm_mmu_init_tdp_mmu(struct kvm *kvm) { return false; }
> --
> 2.32.0.288.g62a8d224e6-goog
>
