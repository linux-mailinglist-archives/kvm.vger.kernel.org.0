Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD8F448BA96
	for <lists+kvm@lfdr.de>; Tue, 11 Jan 2022 23:13:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346076AbiAKWNY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jan 2022 17:13:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346074AbiAKWNA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jan 2022 17:13:00 -0500
Received: from mail-vk1-xa2b.google.com (mail-vk1-xa2b.google.com [IPv6:2607:f8b0:4864:20::a2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71224C061756
        for <kvm@vger.kernel.org>; Tue, 11 Jan 2022 14:13:00 -0800 (PST)
Received: by mail-vk1-xa2b.google.com with SMTP id 78so453732vkz.7
        for <kvm@vger.kernel.org>; Tue, 11 Jan 2022 14:13:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KgSuaaKJVkTDH5MkZLE0ficG8YsE68nuOr/Ud7GU7tI=;
        b=jfXah/bPEescF48JKVg63L0WBB30CdAqD/ZwWtCGpXy4KzXIwHqi9fnSGC5FOtDZ0V
         ybn5KcpStmXtvAprXMcQvMvYrnm0F2XRw37O55bhVvLl4j5ITIYUJzUc3CxKM6jYD1pO
         Fk0pmjHdjhqusyKAd8tueoPUuMvVbc4e8GtxYJegzr1bNuRSXSwuvtcSUSCYlUDZ8nbO
         HGDSsdkIlg6XyyQ8SWn8U7lIsDL6hLHMRiULJRdYKJgm35XuO7Jlk/TxzgC8/Bcxoi7J
         lv7/RVvxynGu60l1Sab02Byw9w88BFJJ9AsUOoYpolahcoIGEEG9fYAcszCMlVcJEvEi
         FV9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KgSuaaKJVkTDH5MkZLE0ficG8YsE68nuOr/Ud7GU7tI=;
        b=qQ4f6l365lDtZiZFJ33Lmuh7vo27pdA+gvqVuqqGqYI9cNpA7K3AKs6gOx1sSHr6Ev
         ycwZiiEXRUQql01aLCtm3QmSmz+VvR0wt2tQ+zhBn7KhPKoK9rpTEQN/PaeUun6v3epN
         I8pxa+CKLc7o7VXAB0D5zGok4a4g/EvqBq0KPx0kCpOYyx6oJj+mMHUKpu6+hSThdPZP
         1IqEBDNA68M0AP+D9fxUrDw4CvcdOZCipI1RqUI8oTQQwwhZyiJalJIobeyCGK3G5Zwt
         dummXnVeNgympmAbBBXYXQkViAaW7YI9YwaFpK9oKFozSVXEaC+4K0MHuUa3xiUUtmWH
         g3jg==
X-Gm-Message-State: AOAM5328xYC8QCyistReQRS9xXXzcVc/yNeuBK+t2VMcviXCEaVRBHw4
        SGMJDLoikZ/aLEbhqQbawPQQ+z01ZMhNwVp95LchdQ==
X-Google-Smtp-Source: ABdhPJy5Cve+QK4XLU9I1o+V2WtNW4OgE1ZJiEVNw8PTVEUk7dSDq2cmvxsIgpO/b217sUnf/vOCIG3P6ho1ehhAPEg=
X-Received: by 2002:a05:6122:554:: with SMTP id y20mr3359887vko.35.1641939179496;
 Tue, 11 Jan 2022 14:12:59 -0800 (PST)
MIME-Version: 1.0
References: <20220110210441.2074798-1-jingzhangos@google.com>
 <20220110210441.2074798-3-jingzhangos@google.com> <878rvmtukq.wl-maz@kernel.org>
In-Reply-To: <878rvmtukq.wl-maz@kernel.org>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Tue, 11 Jan 2022 14:12:48 -0800
Message-ID: <CAAdAUtjgXN5-y9JGpMQ6m3hbD-UzwX8wStAfrmPB2YCd8awRQg@mail.gmail.com>
Subject: Re: [RFC PATCH 2/3] KVM: arm64: Add fast path to handle permission
 relaxation during dirty logging
To:     Marc Zyngier <maz@kernel.org>
Cc:     KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.cs.columbia.edu>,
        Will Deacon <will@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On Tue, Jan 11, 2022 at 2:50 AM Marc Zyngier <maz@kernel.org> wrote:
>
> Coming back to this, as it does bother me.
>
> On Mon, 10 Jan 2022 21:04:40 +0000,
> Jing Zhang <jingzhangos@google.com> wrote:
> >
> > To reduce MMU lock contention during dirty logging, all permission
> > relaxation operations would be performed under read lock.
> >
> > Signed-off-by: Jing Zhang <jingzhangos@google.com>
> > ---
> >  arch/arm64/kvm/mmu.c | 50 ++++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 50 insertions(+)
> >
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index cafd5813c949..dd1f43fba4b0 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -1063,6 +1063,54 @@ static int sanitise_mte_tags(struct kvm *kvm, kvm_pfn_t pfn,
> >       return 0;
> >  }
> >
> > +static bool fast_mark_writable(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> > +             struct kvm_memory_slot *memslot, unsigned long fault_status)
> > +{
> > +     int ret;
> > +     bool writable;
> > +     bool write_fault = kvm_is_write_fault(vcpu);
> > +     gfn_t gfn = fault_ipa >> PAGE_SHIFT;
> > +     kvm_pfn_t pfn;
> > +     struct kvm *kvm = vcpu->kvm;
> > +     bool logging_active = memslot_is_logging(memslot);
> > +     unsigned long fault_level = kvm_vcpu_trap_get_fault_level(vcpu);
> > +     unsigned long fault_granule;
> > +
> > +     fault_granule = 1UL << ARM64_HW_PGTABLE_LEVEL_SHIFT(fault_level);
> > +
> > +     /* Make sure the fault can be handled in the fast path.
> > +      * Only handle write permission fault on non-hugepage during dirty
> > +      * logging period.
> > +      */
> > +     if (fault_status != FSC_PERM || fault_granule != PAGE_SIZE
> > +                     || !logging_active || !write_fault)
> > +             return false;
> > +
> > +
> > +     /* Pin the pfn to make sure it couldn't be freed and be resued for
> > +      * another gfn.
> > +      */
> > +     pfn = __gfn_to_pfn_memslot(memslot, gfn, true, NULL,
> > +                                write_fault, &writable, NULL);
>
> Why the requirement to be atomic? Once this returns, the page will
> have an elevated refcount, atomic or not. Given that we're not in an
> environment that requires atomicity (we're fully preemptible at this
> stage), I wonder what this is achieving.
>
> > +     if (is_error_pfn(pfn) || !writable)
> > +             return false;
> > +
> > +     read_lock(&kvm->mmu_lock);
>
> You also dropped the hazarding against a concurrent MMU notifier. Why
> is it safe to do so?
>
> > +     ret = kvm_pgtable_stage2_relax_perms(
> > +                     vcpu->arch.hw_mmu->pgt, fault_ipa, PAGE_HYP);
> > +
> > +     if (!ret) {
> > +             kvm_set_pfn_dirty(pfn);
> > +             mark_page_dirty_in_slot(kvm, memslot, gfn);
> > +     }
> > +     read_unlock(&kvm->mmu_lock);
> > +
> > +     kvm_set_pfn_accessed(pfn);
> > +     kvm_release_pfn_clean(pfn);
> > +
> > +     return true;
> > +}
> > +
> >  static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> >                         struct kvm_memory_slot *memslot, unsigned long hva,
> >                         unsigned long fault_status)
> > @@ -1085,6 +1133,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> >       enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
> >       struct kvm_pgtable *pgt;
> >
> > +     if (fast_mark_writable(vcpu, fault_ipa, memslot, fault_status))
> > +             return 0;
> >       fault_granule = 1UL << ARM64_HW_PGTABLE_LEVEL_SHIFT(fault_level);
> >       write_fault = kvm_is_write_fault(vcpu);
> >       exec_fault = kvm_vcpu_trap_is_exec_fault(vcpu);
>
> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
Appreciate all the comments here. I'll refactor the patch to implement
the fast path in user_mem_abort and address all the problems you
mentioned.
Thanks,
Jing
