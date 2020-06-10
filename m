Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09CFF1F5E44
	for <lists+kvm@lfdr.de>; Thu, 11 Jun 2020 00:20:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726650AbgFJWUh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jun 2020 18:20:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726669AbgFJWUg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Jun 2020 18:20:36 -0400
Received: from mail-vs1-xe43.google.com (mail-vs1-xe43.google.com [IPv6:2607:f8b0:4864:20::e43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 215E3C08C5C1
        for <kvm@vger.kernel.org>; Wed, 10 Jun 2020 15:20:35 -0700 (PDT)
Received: by mail-vs1-xe43.google.com with SMTP id 190so2248489vsr.9
        for <kvm@vger.kernel.org>; Wed, 10 Jun 2020 15:20:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gbYrwjkRNzZs52wtNe5b9ymrBledc5fgJdW/7CYMczg=;
        b=QyyXrmeKJSKKc54VOXRhBA48lstvw0q3ctLwmRUmYvuniF6MaKqprw76G6WKeXgKXB
         r/jbdUg8yJ7iw34oE1OWz0dWyMIlim7iHYcQtD67/ivBRy+I7B838Bxvx4JWOVUAxYN3
         POzPLtPUSvRylefwwyiJnNCwZ28r+eFHCfQTlfjzukPMl52cDhRE0H8vA3A5R5qZ//vK
         hyVJruxV9jjEt3XKZbDLdCyH9tLqObhgWfqQJpRCLqqkFBHz8EB0eQ7avKhqHHK0zYzj
         RESHvTrXTKtZufFfvsuK5nk/vVANKcnKj1isrCHWI7ENKEYpAZgFY60ZfqvyNfgEDVAL
         29Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gbYrwjkRNzZs52wtNe5b9ymrBledc5fgJdW/7CYMczg=;
        b=jwHpREPDb4LW83dQpfglmM5p8xBlEHti5foXoAgBw5KQeqmz+OUE2hhMO3gjQso1o8
         4/fl/UfFYfiNMjLIdibkakH0v458KH23JB2fDaPB8D6q3Q5Muqm8xP++AUENiqfqYMfn
         D4S9zv5E11/uPNkqfu3KBUKRAIJYf99kZrfqPdo9p0qBG0vB+Rucy7Ik5X5HewtYo/xE
         TVaFkZW6mTcJQ6sRnafNYKIf4MEsh3Bd0frmBjItPZ6XBbGYZ/cBgWAR2lRbsu4l3KpP
         MhV4HPr82TSQS0btI+8+Ix9HRO487KUHTvJitif8orbbn+03yLEIbbic+wjLY9UcLe3T
         chIg==
X-Gm-Message-State: AOAM533H/qlFUc79iAvgYodF/GvF1iMO9meGIE8fRannzM+NskkEn5OX
        ZY5JqEOlLGPKZSAu62AcUQjyz6iZDVogzk/16W9ceQ==
X-Google-Smtp-Source: ABdhPJzOjvq/kbEr1iPy17gDm6Y5SxC/Oi9n4y5NbS27Re14ZbRVe9raYSH+GiU0z+vIPd8N4LFp9am07TBNHW7Kx80=
X-Received: by 2002:a67:d287:: with SMTP id z7mr4666597vsi.2.1591827633895;
 Wed, 10 Jun 2020 15:20:33 -0700 (PDT)
MIME-Version: 1.0
References: <20200605213853.14959-1-sean.j.christopherson@intel.com> <20200605213853.14959-9-sean.j.christopherson@intel.com>
In-Reply-To: <20200605213853.14959-9-sean.j.christopherson@intel.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Wed, 10 Jun 2020 15:20:19 -0700
Message-ID: <CANgfPd-19pam9sujfsk1pdrp8YhVft1+JAmSS=xgUULqXRyUDg@mail.gmail.com>
Subject: Re: [PATCH 08/21] KVM: x86/mmu: Clean up the gorilla math in mmu_topup_memory_caches()
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Marc Zyngier <maz@kernel.org>, Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Feiner <pfeiner@google.com>,
        Peter Shier <pshier@google.com>,
        Junaid Shahid <junaids@google.com>,
        Christoffer Dall <christoffer.dall@arm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 5, 2020 at 2:39 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> Clean up the minimums in mmu_topup_memory_caches() to document the
> driving mechanisms behind the minimums.  Now that encountering an empty
> cache is unlikely to trigger BUG_ON(), it is less dangerous to be more
> precise when defining the minimums.
>
> For rmaps, the logic is 1 parent PTE per level, plus a single rmap, and
> prefetched rmaps.  The extra objects in the current '8 + PREFETCH'
> minimum came about due to an abundance of paranoia in commit
> c41ef344de212 ("KVM: MMU: increase per-vcpu rmap cache alloc size"),
> i.e. it could have increased the minimum to 2 rmaps.  Furthermore, the
> unexpected extra rmap case was killed off entirely by commits
> f759e2b4c728c ("KVM: MMU: avoid pte_list_desc running out in
> kvm_mmu_pte_write") and f5a1e9f89504f ("KVM: MMU: remove call to
> kvm_mmu_pte_write from walk_addr").
>
> For the so called page cache, replace '8' with 2*PT64_ROOT_MAX_LEVEL.
> The 2x multiplier is needed because the cache is used for both shadow
> pages and gfn arrays for indirect MMUs.
>
> And finally, for page headers, replace '4' with PT64_ROOT_MAX_LEVEL.
>
> Note, KVM now supports 5-level paging, i.e. the old minimums that used a
> baseline derived from 4-level paging were technically wrong.  But, KVM
> always allocates roots in a separate flow, e.g. it's impossible in the
> current implementation to actually need 5 new shadow pages in a single
> flow.  Use PT64_ROOT_MAX_LEVEL unmodified instead of subtracting 1, as
> the direct usage is likely more intuitive to uninformed readers, and the
> inflated minimum is unlikely to affect functionality in practice.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Reviewed-by: Ben Gardon <bgardon@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 4b4c3234d623..451e0365e5dd 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -1103,14 +1103,17 @@ static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu)
>  {
>         int r;
>
> +       /* 1 rmap, 1 parent PTE per level, and the prefetched rmaps. */
>         r = mmu_topup_memory_cache(&vcpu->arch.mmu_pte_list_desc_cache,
> -                                  8 + PTE_PREFETCH_NUM);
> +                                  1 + PT64_ROOT_MAX_LEVEL + PTE_PREFETCH_NUM);
>         if (r)
>                 return r;
> -       r = mmu_topup_memory_cache(&vcpu->arch.mmu_page_cache, 8);
> +       r = mmu_topup_memory_cache(&vcpu->arch.mmu_page_cache,
> +                                  2 * PT64_ROOT_MAX_LEVEL);
>         if (r)
>                 return r;
> -       return mmu_topup_memory_cache(&vcpu->arch.mmu_page_header_cache, 4);
> +       return mmu_topup_memory_cache(&vcpu->arch.mmu_page_header_cache,
> +                                     PT64_ROOT_MAX_LEVEL);
>  }
>
>  static void mmu_free_memory_caches(struct kvm_vcpu *vcpu)
> --
> 2.26.0
>
