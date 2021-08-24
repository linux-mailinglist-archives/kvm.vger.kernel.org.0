Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2AA23F59DC
	for <lists+kvm@lfdr.de>; Tue, 24 Aug 2021 10:30:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235369AbhHXIb2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Aug 2021 04:31:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235291AbhHXIb1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Aug 2021 04:31:27 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACD55C061757;
        Tue, 24 Aug 2021 01:30:43 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id q3so7892165iot.3;
        Tue, 24 Aug 2021 01:30:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+j7IjoUFYR/jGQIsG5Kc/GnPz7mkjdiN+rdILANXXEQ=;
        b=cw7kQmPLTiLl+GcnjDtkNylKIH5YQtQ1Evnmix6ZwvW1SORH65Sh2h8dyigIa2RHSx
         5kuogtWnnigiA79DLq1MlyNKAFeHbmoPiQ6cbtp88jc3Zx7kXQee1ix6XgoNj68cYpaX
         34ETEjUo3OHirUDomXGn/aOhPwfLtEvx5NqC1fX5cUh0neHKoFBbFhTyUfYu+lCwVFCJ
         YVab9WlnkYN5VSJOD4rRHcdeLJ23RmvWy1o/E6urHZFaODhaaFwolTvYo/REghMniLJi
         kpVIjAW6uq9N/WrqmxI6PBWdOCMLkgWc0BAc5uF5XtR8JnYmn34AHPRKcf/1IbzLFizl
         PG7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+j7IjoUFYR/jGQIsG5Kc/GnPz7mkjdiN+rdILANXXEQ=;
        b=OlTaTbg7a8hHg58/fgCaGHvzfyeGxxE2UE2S7Fo6LUFcZtXVFaM4n5sSNwELrYCIUs
         UgW3fHEXNv4+BpnttBf3Ntjw10VDIXvN0nI46aw9FIqsSIKTsekavRhSrPZYni/CHhUJ
         gBXwuZFBzLtf8swRcZxp4hAbMleJX0I+uuqzIP72FZOoQ0eBbPQ0jcRrP/q4TSzcE5vN
         z297MAPPHEwh4YPrPP3AykPiphWkUZwVJqPxLnvzMcCuuNWO8CwoAK62r4BV3TrupKY5
         e014OJNjj2WiSG86FymEBlUMV1Kdm/v4mWRa5X31NBaq923VGpctArtVNVloQzY2959A
         MZGg==
X-Gm-Message-State: AOAM530X8ay3UUpVOKFvNfnPwXgv+JkZUO7CxrZw9g+2Exh5rV0gXMSk
        FOn9fy43kEwn9XsJp4C3p3lA3d3tUODEYj4HQlHGcEzz
X-Google-Smtp-Source: ABdhPJyTgmhzpAyp/zZOvJ8sEkMJXon/cESPXGJG4jfzkW0CnkZ0MUVxnfQyOs0gTKzpE4HhiqsQTpWaaI10Rk6RIkg=
X-Received: by 2002:a6b:ec0b:: with SMTP id c11mr15025302ioh.207.1629793843119;
 Tue, 24 Aug 2021 01:30:43 -0700 (PDT)
MIME-Version: 1.0
References: <YRVGY1ZK8wl9ybBH@google.com> <20210813031629.78670-1-jiangshanlai@gmail.com>
In-Reply-To: <20210813031629.78670-1-jiangshanlai@gmail.com>
From:   Lai Jiangshan <jiangshanlai@gmail.com>
Date:   Tue, 24 Aug 2021 16:30:31 +0800
Message-ID: <CAJhGHyBhx1+HdZ_a43HtMBUApOoVC=MvP-R13XHtycOAtUW7ew@mail.gmail.com>
Subject: Re: [PATCH V2] KVM: X86: Move PTE present check from loop body to __shadow_walk_next()
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Lai Jiangshan <laijs@linux.alibaba.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello, Paolo

Could you have a review please.

Thanks
Lai

On Fri, Aug 13, 2021 at 9:01 PM Lai Jiangshan <jiangshanlai@gmail.com> wrote:
>
> From: Lai Jiangshan <laijs@linux.alibaba.com>
>
> So far, the loop bodies already ensure the PTE is present before calling
> __shadow_walk_next():  Some loop bodies simply exit with a !PRESENT
> directly and some other loop bodies, i.e. FNAME(fetch) and __direct_map()
> do not currently terminate their walks with a !PRESENT, but they get away
> with it because they install present non-leaf SPTEs in the loop itself.
>
> But checking pte present in __shadow_walk_next() is a more prudent way of
> programing and loop bodies will not need to always check it. It allows us
> removing unneded is_shadow_present_pte() in the loop bodies.
>
> Terminating on !is_shadow_present_pte() is 100% the correct behavior, as
> walking past a !PRESENT SPTE would lead to attempting to read a the next
> level SPTE from a garbage iter->shadow_addr.  Even some paths that do _not_
> currently have a !is_shadow_present_pte() in the loop body is Ok since
> they will install present non-leaf SPTEs and the additinal present check
> is just an NOP.
>
> The checking result in __shadow_walk_next() will be propagated to
> shadow_walk_okay() for being used in any for(;;) loop.
>
> Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
> ---
> Changed from V1:
>         Merge the two patches
>         Update changelog
>         Remove !is_shadow_present_pte() in FNAME(invlpg)
>  arch/x86/kvm/mmu/mmu.c         | 13 ++-----------
>  arch/x86/kvm/mmu/paging_tmpl.h |  2 +-
>  2 files changed, 3 insertions(+), 12 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index a272ccbddfa1..42eebba6782e 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -2231,7 +2231,7 @@ static bool shadow_walk_okay(struct kvm_shadow_walk_iterator *iterator)
>  static void __shadow_walk_next(struct kvm_shadow_walk_iterator *iterator,
>                                u64 spte)
>  {
> -       if (is_last_spte(spte, iterator->level)) {
> +       if (!is_shadow_present_pte(spte) || is_last_spte(spte, iterator->level)) {
>                 iterator->level = 0;
>                 return;
>         }
> @@ -3152,9 +3152,6 @@ static u64 *fast_pf_get_last_sptep(struct kvm_vcpu *vcpu, gpa_t gpa, u64 *spte)
>         for_each_shadow_entry_lockless(vcpu, gpa, iterator, old_spte) {
>                 sptep = iterator.sptep;
>                 *spte = old_spte;
> -
> -               if (!is_shadow_present_pte(old_spte))
> -                       break;
>         }
>
>         return sptep;
> @@ -3694,9 +3691,6 @@ static int get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes, int *root_level
>                 spte = mmu_spte_get_lockless(iterator.sptep);
>
>                 sptes[leaf] = spte;
> -
> -               if (!is_shadow_present_pte(spte))
> -                       break;
>         }
>
>         return leaf;
> @@ -3811,11 +3805,8 @@ static void shadow_page_table_clear_flood(struct kvm_vcpu *vcpu, gva_t addr)
>         u64 spte;
>
>         walk_shadow_page_lockless_begin(vcpu);
> -       for_each_shadow_entry_lockless(vcpu, addr, iterator, spte) {
> +       for_each_shadow_entry_lockless(vcpu, addr, iterator, spte)
>                 clear_sp_write_flooding_count(iterator.sptep);
> -               if (!is_shadow_present_pte(spte))
> -                       break;
> -       }
>         walk_shadow_page_lockless_end(vcpu);
>  }
>
> diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
> index f70afecbf3a2..13138b03cc69 100644
> --- a/arch/x86/kvm/mmu/paging_tmpl.h
> +++ b/arch/x86/kvm/mmu/paging_tmpl.h
> @@ -977,7 +977,7 @@ static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva, hpa_t root_hpa)
>                         FNAME(update_pte)(vcpu, sp, sptep, &gpte);
>                 }
>
> -               if (!is_shadow_present_pte(*sptep) || !sp->unsync_children)
> +               if (!sp->unsync_children)
>                         break;
>         }
>         write_unlock(&vcpu->kvm->mmu_lock);
> --
> 2.19.1.6.gb485710b
>
