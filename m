Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F0EF276466
	for <lists+kvm@lfdr.de>; Thu, 24 Sep 2020 01:19:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726691AbgIWXT2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Sep 2020 19:19:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726466AbgIWXT2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Sep 2020 19:19:28 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42271C0613D1
        for <kvm@vger.kernel.org>; Wed, 23 Sep 2020 16:19:28 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id g128so1286926iof.11
        for <kvm@vger.kernel.org>; Wed, 23 Sep 2020 16:19:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iZOApGC20HnhhJiLh+fQ5O3fgDHPiGbwUwpUBeQPkwI=;
        b=hmTl02N9oaSnCdbp3B9syLLDD4VuLhaBuXkhB5WOWMpHR7b9ZnhC5mvkT/TSH2UN6r
         el8RTasDbtfFRWEMxhJHv4MRGcv4wrw4Snb5rHDWZHzr34CTWW31F13iuiyeNGQ43o31
         Z0dtQs4SonnQU3g77d6uU6tO5xyEr4gypmze1MIM+FR4VrnKRnX8zKIDkCdj7BKfR6tS
         EBclxE+Rd6VD4IgvF1WuhkcV7Cs6byEAbJF3UgqIN7icRmHbSiKTSLJ0TnxLbBe0eJmN
         eMBvbm5tYjrjCZFfpec+aXv1Lf1GMwnZr3yq9e8bwKemM9XvOt8fM+y76sFn+3e4Cq6K
         v94Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iZOApGC20HnhhJiLh+fQ5O3fgDHPiGbwUwpUBeQPkwI=;
        b=t1aw5BPAjh1OFcdhoP0HUfYyj8edoBTyivwpcclhkwbIRr/ocMtNP73T7j5UBKeQXA
         kbh1zhJ7dVGO/kviz9zde5fCpe/sF9UZuK7GlyZIQfLwhGjm6x8S8ViO82pdeKsoAshi
         jFho9C96+76vDE4MmsQJOePe4CaUUd4aYr1aKUCCiw8FcT/PpZdtTp3/6YWd/1BZeng7
         DwwUiaYaXYnHO9ny7WyQRt0Afe9As5rWVU7CX0/diflTJONJzgFA5PArUrfwdh0gnYX2
         VnyrquoBA9Ldwp52pLrHEzt9HMdzq9o6OutHWyrpUjEAuKXYYjTTphP5rCrA9IhgmYO+
         pwVg==
X-Gm-Message-State: AOAM532W3Bu+4IeOQ9XD6alBDnPd3vcSM1xiv6Lde7eV7NO4IjZEMXkl
        OYQ/EDYcziM6X2UwjfceUF0K7QWM0Jg2Ns4Yb90pWg==
X-Google-Smtp-Source: ABdhPJyywv0N4Sq5HyrTKpf0BLx0dTf1f8TFMfzwSd2vInPWcEQ9MrdKCg8lPTlShY6kT8gRRslHqFCB7XozbyzyvFM=
X-Received: by 2002:a05:6638:611:: with SMTP id g17mr1452858jar.40.1600903167128;
 Wed, 23 Sep 2020 16:19:27 -0700 (PDT)
MIME-Version: 1.0
References: <20200923221406.16297-1-sean.j.christopherson@intel.com> <20200923221406.16297-2-sean.j.christopherson@intel.com>
In-Reply-To: <20200923221406.16297-2-sean.j.christopherson@intel.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Wed, 23 Sep 2020 16:19:15 -0700
Message-ID: <CANgfPd_POgKeMNa+PbtGvCMyzNi0YY=4E9w8LzgWhLwGSqX-OQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] KVM: x86/mmu: Move flush logic from
 mmu_page_zap_pte() to FNAME(invlpg)
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 23, 2020 at 3:14 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> Move the logic that controls whether or not FNAME(invlpg) needs to flush
> fully into FNAME(invlpg) so that mmu_page_zap_pte() doesn't return a
> value.  This allows a future patch to redefine the return semantics for
> mmu_page_zap_pte() so that it can recursively zap orphaned child shadow
> pages for nested TDP MMUs.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

Reviewed-by: Ben Gardon <bgardon@google.com>

>
> ---
>  arch/x86/kvm/mmu/mmu.c         | 10 +++-------
>  arch/x86/kvm/mmu/paging_tmpl.h |  7 +++++--
>  2 files changed, 8 insertions(+), 9 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 76c5826e29a2..a91e8601594d 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -2615,7 +2615,7 @@ static void validate_direct_spte(struct kvm_vcpu *vcpu, u64 *sptep,
>         }
>  }
>
> -static bool mmu_page_zap_pte(struct kvm *kvm, struct kvm_mmu_page *sp,
> +static void mmu_page_zap_pte(struct kvm *kvm, struct kvm_mmu_page *sp,
>                              u64 *spte)
>  {
>         u64 pte;
> @@ -2631,13 +2631,9 @@ static bool mmu_page_zap_pte(struct kvm *kvm, struct kvm_mmu_page *sp,
>                         child = to_shadow_page(pte & PT64_BASE_ADDR_MASK);
>                         drop_parent_pte(child, spte);
>                 }
> -               return true;
> -       }
> -
> -       if (is_mmio_spte(pte))
> +       } else if (is_mmio_spte(pte)) {
>                 mmu_spte_clear_no_track(spte);
> -
> -       return false;
> +       }
>  }
>
>  static void kvm_mmu_page_unlink_children(struct kvm *kvm,
> diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
> index 4dd6b1e5b8cf..3bb624a3dda9 100644
> --- a/arch/x86/kvm/mmu/paging_tmpl.h
> +++ b/arch/x86/kvm/mmu/paging_tmpl.h
> @@ -895,6 +895,7 @@ static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva, hpa_t root_hpa)
>  {
>         struct kvm_shadow_walk_iterator iterator;
>         struct kvm_mmu_page *sp;
> +       u64 old_spte;
>         int level;
>         u64 *sptep;
>
> @@ -917,7 +918,8 @@ static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva, hpa_t root_hpa)
>                 sptep = iterator.sptep;
>
>                 sp = sptep_to_sp(sptep);
> -               if (is_last_spte(*sptep, level)) {
> +               old_spte = *sptep;
> +               if (is_last_spte(old_spte, level)) {
>                         pt_element_t gpte;
>                         gpa_t pte_gpa;
>
> @@ -927,7 +929,8 @@ static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva, hpa_t root_hpa)
>                         pte_gpa = FNAME(get_level1_sp_gpa)(sp);
>                         pte_gpa += (sptep - sp->spt) * sizeof(pt_element_t);
>
> -                       if (mmu_page_zap_pte(vcpu->kvm, sp, sptep))
> +                       mmu_page_zap_pte(vcpu->kvm, sp, sptep);
> +                       if (is_shadow_present_pte(old_spte))
>                                 kvm_flush_remote_tlbs_with_address(vcpu->kvm,
>                                         sp->gfn, KVM_PAGES_PER_HPAGE(sp->role.level));
>
> --
> 2.28.0
>
