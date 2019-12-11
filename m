Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3142F11BBDC
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2019 19:39:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729447AbfLKSjf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Dec 2019 13:39:35 -0500
Received: from mail-ua1-f68.google.com ([209.85.222.68]:37871 "EHLO
        mail-ua1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727334AbfLKSjf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Dec 2019 13:39:35 -0500
Received: by mail-ua1-f68.google.com with SMTP id f9so8940476ual.4
        for <kvm@vger.kernel.org>; Wed, 11 Dec 2019 10:39:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jvwRzY6q6sEUlr5sjKgPT84DnfYGRvojIL+zk+mDmvc=;
        b=QCBjYOKGS8VgotL7RL1mAHYwBVd/jEaqUKD0dygCykJJ6XEP7LyitxuNOMLv3sriPg
         2wVGVG6EpAwrx6ArJEAC2ffQE4RqX1jLWhBYhFm/wKX75eFjP6MC6G9XIaKEIYww/Nrv
         UunoWMyRhm3UshUN5NCgLy+XBPv82wKSrcPv7A+3hek/qDxHEuPOpVmgfhgaAbFGtkWg
         Vi/D9mycOs9MU/BzASDG1CVeW6N38OI0yjDCi02eGudNPwcYg7axtN3FYQVYIzGJ5JHD
         jE8nCn+Cch4Csk2AQUU3myG7n5Mao/JzzZ49ILC1k2jYhZ1oz/KLA5Ho8trLN3qTaBNQ
         1U5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jvwRzY6q6sEUlr5sjKgPT84DnfYGRvojIL+zk+mDmvc=;
        b=PDf9xGy3YMq2KsEPerBSoUN0G1q1oHPSRMsaPei1pdnCxaRM6S+u/qXOzu0+ONZA4S
         TMJH/QxltyHmZQ2C4GyJ8MbyBT4qX+1d8ZsAYXokndxQkSaM3iLzBhwBhnRSEzbPlB9N
         oyRJXzUuj9ixzLFsKl8HSt9zPGI4zTx0Tfqa5leP+LfqGG20D1JtSX9cGPtSY0B1uC5b
         WLhdn0vPIz8jYAcEeFhmq9+Mut+zK+07csV1XdCQnfe8Tc7Ms+SLvIfxvYD/OfGwi47N
         t2U0Sv8p/uJJBP9cGd6/WpijMJQ9AOoYnd4HgAyLKjvne/+0fnhxxlDhmZdSZ+FofSfc
         nwrw==
X-Gm-Message-State: APjAAAUoDYj+lV1FSTVFE02EpnA/SFZZADhBdopojs5bU3nipd+CrmHU
        zuprcd6EhQv7fKbeklxgUw+PMsONqgYUW8JXqv6rn/5g
X-Google-Smtp-Source: APXvYqy6xPnfaUrI7lLh3KoBS7iHoKRPYaYIY62oaMx9roqeU7jll1yBN71P4HBHxz9spRjXkUGvDZvdNUuctO+BwG4=
X-Received: by 2002:a9f:3e84:: with SMTP id x4mr4323355uai.83.1576089573173;
 Wed, 11 Dec 2019 10:39:33 -0800 (PST)
MIME-Version: 1.0
References: <1569582943-13476-1-git-send-email-pbonzini@redhat.com> <1569582943-13476-2-git-send-email-pbonzini@redhat.com>
In-Reply-To: <1569582943-13476-2-git-send-email-pbonzini@redhat.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Wed, 11 Dec 2019 10:39:22 -0800
Message-ID: <CANgfPd8G194y1Bo-6HR-jP8wh4DvdAsaijue_pnhetjduyzn4A@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] KVM: x86: assign two bits to track SPTE kinds
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Junaid Shahid <junaids@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Has anyone tested this patch on a long-running machine? It looks like
the SPTE_MMIO_MASK overlaps with the bits used to track MMIO
generation number, which makes me think that on a long running VM, a
high enough generation number would overwrite the SPTE_SPECIAL_MASK
region and cause the MMIO SPTE to be misinterpreted. It seems like
setting bits 52 and 53 would also cause an incorrect generation number
to be read from the PTE.


On Fri, Sep 27, 2019 at 4:16 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> Currently, we are overloading SPTE_SPECIAL_MASK to mean both
> "A/D bits unavailable" and MMIO, where the difference between the
> two is determined by mio_mask and mmio_value.
>
> However, the next patch will need two bits to distinguish
> availability of A/D bits from write protection.  So, while at
> it give MMIO its own bit pattern, and move the two bits from
> bit 62 to bits 52..53 since Intel is allocating EPT page table
> bits from the top.
>
> Reviewed-by: Junaid Shahid <junaids@google.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  7 -------
>  arch/x86/kvm/mmu.c              | 28 ++++++++++++++++++----------
>  2 files changed, 18 insertions(+), 17 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 23edf56cf577..50eb430b0ad8 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -219,13 +219,6 @@ enum {
>                                  PFERR_WRITE_MASK |             \
>                                  PFERR_PRESENT_MASK)
>
> -/*
> - * The mask used to denote special SPTEs, which can be either MMIO SPTEs or
> - * Access Tracking SPTEs. We use bit 62 instead of bit 63 to avoid conflicting
> - * with the SVE bit in EPT PTEs.
> - */
> -#define SPTE_SPECIAL_MASK (1ULL << 62)
> -
>  /* apic attention bits */
>  #define KVM_APIC_CHECK_VAPIC   0
>  /*
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index 5269aa057dfa..bac8d228d82b 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -83,7 +83,16 @@ enum {
>  #define PTE_PREFETCH_NUM               8
>
>  #define PT_FIRST_AVAIL_BITS_SHIFT 10
> -#define PT64_SECOND_AVAIL_BITS_SHIFT 52
> +#define PT64_SECOND_AVAIL_BITS_SHIFT 54
> +
> +/*
> + * The mask used to denote special SPTEs, which can be either MMIO SPTEs or
> + * Access Tracking SPTEs.
> + */
> +#define SPTE_SPECIAL_MASK (3ULL << 52)
> +#define SPTE_AD_ENABLED_MASK (0ULL << 52)
> +#define SPTE_AD_DISABLED_MASK (1ULL << 52)
> +#define SPTE_MMIO_MASK (3ULL << 52)
>
>  #define PT64_LEVEL_BITS 9
>
> @@ -219,12 +228,11 @@ struct kvm_shadow_walk_iterator {
>  static u64 __read_mostly shadow_me_mask;
>
>  /*
> - * SPTEs used by MMUs without A/D bits are marked with shadow_acc_track_value.
> - * Non-present SPTEs with shadow_acc_track_value set are in place for access
> - * tracking.
> + * SPTEs used by MMUs without A/D bits are marked with SPTE_AD_DISABLED_MASK;
> + * shadow_acc_track_mask is the set of bits to be cleared in non-accessed
> + * pages.
>   */
>  static u64 __read_mostly shadow_acc_track_mask;
> -static const u64 shadow_acc_track_value = SPTE_SPECIAL_MASK;
>
>  /*
>   * The mask/shift to use for saving the original R/X bits when marking the PTE
> @@ -304,7 +312,7 @@ void kvm_mmu_set_mmio_spte_mask(u64 mmio_mask, u64 mmio_value, u64 access_mask)
>  {
>         BUG_ON((u64)(unsigned)access_mask != access_mask);
>         BUG_ON((mmio_mask & mmio_value) != mmio_value);
> -       shadow_mmio_value = mmio_value | SPTE_SPECIAL_MASK;
> +       shadow_mmio_value = mmio_value | SPTE_MMIO_MASK;
>         shadow_mmio_mask = mmio_mask | SPTE_SPECIAL_MASK;
>         shadow_mmio_access_mask = access_mask;
>  }
> @@ -323,7 +331,7 @@ static inline bool sp_ad_disabled(struct kvm_mmu_page *sp)
>  static inline bool spte_ad_enabled(u64 spte)
>  {
>         MMU_WARN_ON(is_mmio_spte(spte));
> -       return !(spte & shadow_acc_track_value);
> +       return (spte & SPTE_SPECIAL_MASK) == SPTE_AD_ENABLED_MASK;
>  }
>
>  static inline u64 spte_shadow_accessed_mask(u64 spte)
> @@ -461,7 +469,7 @@ void kvm_mmu_set_mask_ptes(u64 user_mask, u64 accessed_mask,
>  {
>         BUG_ON(!dirty_mask != !accessed_mask);
>         BUG_ON(!accessed_mask && !acc_track_mask);
> -       BUG_ON(acc_track_mask & shadow_acc_track_value);
> +       BUG_ON(acc_track_mask & SPTE_SPECIAL_MASK);
>
>         shadow_user_mask = user_mask;
>         shadow_accessed_mask = accessed_mask;
> @@ -2622,7 +2630,7 @@ static void link_shadow_page(struct kvm_vcpu *vcpu, u64 *sptep,
>                shadow_user_mask | shadow_x_mask | shadow_me_mask;
>
>         if (sp_ad_disabled(sp))
> -               spte |= shadow_acc_track_value;
> +               spte |= SPTE_AD_DISABLED_MASK;
>         else
>                 spte |= shadow_accessed_mask;
>
> @@ -2968,7 +2976,7 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
>
>         sp = page_header(__pa(sptep));
>         if (sp_ad_disabled(sp))
> -               spte |= shadow_acc_track_value;
> +               spte |= SPTE_AD_DISABLED_MASK;
>
>         /*
>          * For the EPT case, shadow_present_mask is 0 if hardware
> --
> 1.8.3.1
>
>
