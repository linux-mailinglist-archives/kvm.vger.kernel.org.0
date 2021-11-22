Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 425ED45952D
	for <lists+kvm@lfdr.de>; Mon, 22 Nov 2021 19:56:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235439AbhKVS7r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Nov 2021 13:59:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235954AbhKVS7q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Nov 2021 13:59:46 -0500
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99913C061746
        for <kvm@vger.kernel.org>; Mon, 22 Nov 2021 10:56:39 -0800 (PST)
Received: by mail-il1-x12f.google.com with SMTP id m5so10758862ilh.11
        for <kvm@vger.kernel.org>; Mon, 22 Nov 2021 10:56:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GAVLNmxHUQr1bJNCgr9I9kA7CoO8f9nYHWR/e53sjzs=;
        b=l8L+ZBeiNiAdgLiBSe0gpTVDL/zah7DahnFM4VZkxTEkN758JR1UllUTgg5G+RlYXJ
         fxcLjzEsz59THeBJy+lUy82PRlpVhmbbs4FgU9rsX95NoYmXE4PtOQ5IKu/Wz9q2Ye5R
         2uBBBHTAIdV43NRhH1H6hlt+5udW5rFPbydOypG7ZQKOdJ1JMrmiIVNnAEb1TzWWgxpG
         sDVH1g+OOJ/U9k5pqi2uTgFhWmEYlsf9l4AFDLDdY7+tcfVnOx1APU0iDaxCrFaeH06b
         yS/I5EGPCpxmr9YjYT3EozMUCtxcfJkLSPCvKntyQiCmA+isnJMTqt4J9ZIMg8geB9SV
         WUAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GAVLNmxHUQr1bJNCgr9I9kA7CoO8f9nYHWR/e53sjzs=;
        b=qF5Rvqs8Eu4XANY4NgYcLbVgEiMjYvOfSKaklknRxT5LgtyXji0mrJGxooYBLKbIEn
         b+vHFevwDYZGCRu5j6f2+ySa2XWtD3KNa2xjTMPbc/J0Jg845gGhgZaBkqjJAt8Qjlyg
         N/ltxFFstDqxxHZJua94A+fIX/2Vu6p8iQzAdQ0ohp1Cg2KUOt0maUW654S2TNZTA2kC
         xoeQ/p3N0KRpSBl8wMW0U2tG0hcAAev1Cpwg7LO4kkGwsopXaxxRwyK8BckJE+RPaUvv
         hXrV5FrG7fclbxFiJ5RF9qOpe9RueaMx3KjCbYA1vgF69lnv4sUb7/+qpK11aEY04dcZ
         4Rxg==
X-Gm-Message-State: AOAM5333xk8+aEHuRLro3851AXiV2MLCg15JZVlVGdtBXzjs61rBcu4T
        kvcGD/kiAvQrHbqh0PpPl6sg42mZK23xikHCMiONy5XbSzo=
X-Google-Smtp-Source: ABdhPJxBO31rlkbJXq0WFTDaeAWm7Q3G1QotPV3YnD44HEC9euPoPLwLHkojLSsKatyyLv1ZTDdozHCFtXiQQCpEL4E=
X-Received: by 2002:a05:6e02:52d:: with SMTP id h13mr21861508ils.274.1637607398919;
 Mon, 22 Nov 2021 10:56:38 -0800 (PST)
MIME-Version: 1.0
References: <20211119235759.1304274-1-dmatlack@google.com> <20211119235759.1304274-10-dmatlack@google.com>
In-Reply-To: <20211119235759.1304274-10-dmatlack@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Mon, 22 Nov 2021 10:56:28 -0800
Message-ID: <CANgfPd_Sbrjy-bPWq-3mVd=wxwF=rRw7yLrN3VXV3s+o9p+Chw@mail.gmail.com>
Subject: Re: [RFC PATCH 09/15] KVM: x86/mmu: Move restore_acc_track_spte to spte.c
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
> restore_acc_track_spte is purely an SPTE manipulation, making it a good
> fit for spte.c. It is also needed in spte.c in a follow-up commit so we
> can construct child SPTEs during large page splitting.
>
> No functional change intended.
>
> Signed-off-by: David Matlack <dmatlack@google.com>

Reviewed-by: Ben Gardon <bgardon@google.com>

Love it.


> ---
>  arch/x86/kvm/mmu/mmu.c  | 18 ------------------
>  arch/x86/kvm/mmu/spte.c | 18 ++++++++++++++++++
>  arch/x86/kvm/mmu/spte.h |  1 +
>  3 files changed, 19 insertions(+), 18 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 537952574211..54f0d2228135 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -652,24 +652,6 @@ static u64 mmu_spte_get_lockless(u64 *sptep)
>         return __get_spte_lockless(sptep);
>  }
>
> -/* Restore an acc-track PTE back to a regular PTE */
> -static u64 restore_acc_track_spte(u64 spte)
> -{
> -       u64 new_spte = spte;
> -       u64 saved_bits = (spte >> SHADOW_ACC_TRACK_SAVED_BITS_SHIFT)
> -                        & SHADOW_ACC_TRACK_SAVED_BITS_MASK;
> -
> -       WARN_ON_ONCE(spte_ad_enabled(spte));
> -       WARN_ON_ONCE(!is_access_track_spte(spte));
> -
> -       new_spte &= ~shadow_acc_track_mask;
> -       new_spte &= ~(SHADOW_ACC_TRACK_SAVED_BITS_MASK <<
> -                     SHADOW_ACC_TRACK_SAVED_BITS_SHIFT);
> -       new_spte |= saved_bits;
> -
> -       return new_spte;
> -}
> -
>  /* Returns the Accessed status of the PTE and resets it at the same time. */
>  static bool mmu_spte_age(u64 *sptep)
>  {
> diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
> index 0c76c45fdb68..df2cdb8bcf77 100644
> --- a/arch/x86/kvm/mmu/spte.c
> +++ b/arch/x86/kvm/mmu/spte.c
> @@ -268,6 +268,24 @@ u64 mark_spte_for_access_track(u64 spte)
>         return spte;
>  }
>
> +/* Restore an acc-track PTE back to a regular PTE */
> +u64 restore_acc_track_spte(u64 spte)
> +{
> +       u64 new_spte = spte;
> +       u64 saved_bits = (spte >> SHADOW_ACC_TRACK_SAVED_BITS_SHIFT)
> +                        & SHADOW_ACC_TRACK_SAVED_BITS_MASK;
> +
> +       WARN_ON_ONCE(spte_ad_enabled(spte));
> +       WARN_ON_ONCE(!is_access_track_spte(spte));
> +
> +       new_spte &= ~shadow_acc_track_mask;
> +       new_spte &= ~(SHADOW_ACC_TRACK_SAVED_BITS_MASK <<
> +                     SHADOW_ACC_TRACK_SAVED_BITS_SHIFT);
> +       new_spte |= saved_bits;
> +
> +       return new_spte;
> +}
> +
>  void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 mmio_mask, u64 access_mask)
>  {
>         BUG_ON((u64)(unsigned)access_mask != access_mask);
> diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
> index e73c41d31816..3e4943ee5a01 100644
> --- a/arch/x86/kvm/mmu/spte.h
> +++ b/arch/x86/kvm/mmu/spte.h
> @@ -342,6 +342,7 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
>  u64 make_nonleaf_spte(u64 *child_pt, bool ad_disabled);
>  u64 make_mmio_spte(struct kvm_vcpu *vcpu, u64 gfn, unsigned int access);
>  u64 mark_spte_for_access_track(u64 spte);
> +u64 restore_acc_track_spte(u64 spte);
>  u64 kvm_mmu_changed_pte_notifier_make_spte(u64 old_spte, kvm_pfn_t new_pfn);
>
>  void kvm_mmu_reset_all_pte_masks(void);
> --
> 2.34.0.rc2.393.gf8c9666880-goog
>
