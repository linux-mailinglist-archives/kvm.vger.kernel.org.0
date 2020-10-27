Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73EB429CBE0
	for <lists+kvm@lfdr.de>; Tue, 27 Oct 2020 23:17:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1832225AbgJ0WRw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Oct 2020 18:17:52 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:45000 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S374824AbgJ0WRw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Oct 2020 18:17:52 -0400
Received: by mail-io1-f67.google.com with SMTP id z17so3266695iog.11
        for <kvm@vger.kernel.org>; Tue, 27 Oct 2020 15:17:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=62OzoS6jE3LG56i9QRNtmxnthDjr2E4kCAi69SS72Zw=;
        b=q+D08P7qTsKjEmbe0ZH0WPHKGGZ3w2aqohalDMbwNYrMiVkKx/qDzlkWZpgb87aj5F
         pVsOm9DZAuzwqM2Et4Ok7TJeadBmahf1C4JCF0PGafZgPE7YRCUTnXOj52jz7DHZi8a0
         S6+EkaSFUTikvMxv44FDHXux9vxt0WdiF0FtdpMms3LyojV1O8mD6Z+qtF7vvtwlQuZ2
         uGSpAtUJk7NvfIPtrOSY9irefb7Q5baQrFaDpBKxQpx+KQ2cuFOxSUjGNmcsBk4zTR5R
         sB+Kywdpy1FlJbikyLZgjDDP+H4GTbqJvNyo33zFJ3REJ4LgezEoUlvT63VTZM+XeL0d
         4tsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=62OzoS6jE3LG56i9QRNtmxnthDjr2E4kCAi69SS72Zw=;
        b=JAG7t2B5KoXQZUJPKTL10DZAxG4pqP92ghe4F34/Hgeh8iHEzxPOkIipSrx20wj6xf
         zSLmcPOr2Trzmll95r7LbrOXhfJmmywC7EaM63CfrhspnyV/m6h8qCKEner4WDRte7TK
         L1ZATUKZkWbxw4aVBE4fkbyKvA9bcNxBfGVIik4IkAgekQM40fTg1ctpAM0PRPBkLbFs
         o4EeBzcxyxovPwX/qUVGaeopKv5Bhmp0xFFu3EVbu2u7m4VPrfjNof5cRHBSxu+wJzT1
         2wdCNSFEJ4GdsQg36UdnMNJOUE+DDXwospv1guP/RaoU1mRTVGrEWs2m+GesY7+bqfyk
         Yn/g==
X-Gm-Message-State: AOAM5304k4OK48b0jVyyPXttCuXp9zhVpETnQgdnlwtCJf76k9bO8+8Q
        L5/iSn5w5ZC4fb6wowqf6GW6EUCMs3iBAzNIm6tbVQ==
X-Google-Smtp-Source: ABdhPJy8rgksvrWbZXU1ua51s7r30XI0K+ADItFUxV3nB4RXbbqF9QVjsuvg6wr0i+SAo9xJuPhGZinlLmwQZmfkcwM=
X-Received: by 2002:a5e:9411:: with SMTP id q17mr3774548ioj.157.1603837070988;
 Tue, 27 Oct 2020 15:17:50 -0700 (PDT)
MIME-Version: 1.0
References: <20201027214300.1342-1-sean.j.christopherson@intel.com> <20201027214300.1342-2-sean.j.christopherson@intel.com>
In-Reply-To: <20201027214300.1342-2-sean.j.christopherson@intel.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Tue, 27 Oct 2020 15:17:40 -0700
Message-ID: <CANgfPd9eZp6pzSZceWD10EZw1mSef+6PSZj=d7g=YzQi-cJt0A@mail.gmail.com>
Subject: Re: [PATCH 1/3] KVM: x86/mmu: Add helper macro for computing hugepage
 GFN mask
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 27, 2020 at 2:43 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> Add a helper to compute the GFN mask given a hugepage level, KVM is
> accumulating quite a few users with the addition of the TDP MMU.
>
> Note, gcc is clever enough to use a single NEG instruction instead of
> SUB+NOT, i.e. use the more common "~(level -1)" pattern instead of
> round_gfn_for_level()'s direct two's complement trickery.

As far as I can tell this patch has no functional changes intended.
Please correct me if that's not correct.

>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

Reviewed-by: Ben Gardon <bgardon@google.com>

> ---
>  arch/x86/include/asm/kvm_host.h | 1 +
>  arch/x86/kvm/mmu/mmu.c          | 2 +-
>  arch/x86/kvm/mmu/paging_tmpl.h  | 4 ++--
>  arch/x86/kvm/mmu/tdp_iter.c     | 2 +-
>  4 files changed, 5 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index d44858b69353..6ea046415f29 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -119,6 +119,7 @@
>  #define KVM_HPAGE_SIZE(x)      (1UL << KVM_HPAGE_SHIFT(x))
>  #define KVM_HPAGE_MASK(x)      (~(KVM_HPAGE_SIZE(x) - 1))
>  #define KVM_PAGES_PER_HPAGE(x) (KVM_HPAGE_SIZE(x) / PAGE_SIZE)
> +#define KVM_HPAGE_GFN_MASK(x)  (~(KVM_PAGES_PER_HPAGE(x) - 1))

NIT: I know x follows the convention on adjacent macros, but this
would be clearer to me if x was changed to level. (Probably for all
the macros in this block)

>
>  static inline gfn_t gfn_to_index(gfn_t gfn, gfn_t base_gfn, int level)
>  {
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 17587f496ec7..3bfc7ee44e51 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -2886,7 +2886,7 @@ static int __direct_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
>                         disallowed_hugepage_adjust(*it.sptep, gfn, it.level,
>                                                    &pfn, &level);
>
> -               base_gfn = gfn & ~(KVM_PAGES_PER_HPAGE(it.level) - 1);
> +               base_gfn = gfn & KVM_HPAGE_GFN_MASK(it.level);
>                 if (it.level == level)
>                         break;
>
> diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
> index 50e268eb8e1a..76ee36f2afd2 100644
> --- a/arch/x86/kvm/mmu/paging_tmpl.h
> +++ b/arch/x86/kvm/mmu/paging_tmpl.h
> @@ -698,7 +698,7 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, gpa_t addr,
>                         disallowed_hugepage_adjust(*it.sptep, gw->gfn, it.level,
>                                                    &pfn, &level);
>
> -               base_gfn = gw->gfn & ~(KVM_PAGES_PER_HPAGE(it.level) - 1);
> +               base_gfn = gw->gfn & KVM_HPAGE_GFN_MASK(it.level);
>                 if (it.level == level)
>                         break;
>
> @@ -751,7 +751,7 @@ FNAME(is_self_change_mapping)(struct kvm_vcpu *vcpu,
>                               bool *write_fault_to_shadow_pgtable)
>  {
>         int level;
> -       gfn_t mask = ~(KVM_PAGES_PER_HPAGE(walker->level) - 1);
> +       gfn_t mask = KVM_HPAGE_GFN_MASK(walker->level);
>         bool self_changed = false;
>
>         if (!(walker->pte_access & ACC_WRITE_MASK ||
> diff --git a/arch/x86/kvm/mmu/tdp_iter.c b/arch/x86/kvm/mmu/tdp_iter.c
> index 87b7e16911db..c6e914c96641 100644
> --- a/arch/x86/kvm/mmu/tdp_iter.c
> +++ b/arch/x86/kvm/mmu/tdp_iter.c
> @@ -17,7 +17,7 @@ static void tdp_iter_refresh_sptep(struct tdp_iter *iter)
>
>  static gfn_t round_gfn_for_level(gfn_t gfn, int level)
>  {
> -       return gfn & -KVM_PAGES_PER_HPAGE(level);
> +       return gfn & KVM_HPAGE_GFN_MASK(level);
>  }
>
>  /*
> --
> 2.28.0
>
