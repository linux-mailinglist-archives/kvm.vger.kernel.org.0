Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C90A47132C
	for <lists+kvm@lfdr.de>; Sat, 11 Dec 2021 10:38:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230225AbhLKJi0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 11 Dec 2021 04:38:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229835AbhLKJiZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 11 Dec 2021 04:38:25 -0500
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9046EC061714
        for <kvm@vger.kernel.org>; Sat, 11 Dec 2021 01:38:25 -0800 (PST)
Received: by mail-io1-xd33.google.com with SMTP id p65so13009085iof.3
        for <kvm@vger.kernel.org>; Sat, 11 Dec 2021 01:38:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=p3C4s4KqOD1h4ZUgwYhTIXX5RK9WIsFxfn73zdhJs5M=;
        b=LdQYszvuNnXkM9BjEujv3wXoxOVzmm994hXH10EDlBbyRZ0tmAAgLKW9CM3vM0B6Kb
         dnc/Gs0ooYQi9AHhkeePzWpRWO5xw6XkcEg6WKTJoNBg56HxltloyMOme8Jw6kahgSXX
         8TuOnIp8WaMfjlOctuAdEchoA7djQksOePJ48=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=p3C4s4KqOD1h4ZUgwYhTIXX5RK9WIsFxfn73zdhJs5M=;
        b=1rQxjb90KqpE1K/hL1baecu8S31NbYnE0eu/GXHOv51jO9jucMcKMjnN1Y1FjRTNgw
         dvIcSAWlQsMU3Nx1jNzAbF72ZIvHQqAxrHKExFHCrYfdOcuuhWTOJnaK8KI8rsVdqQj1
         gImMqSV1dWfV6NiZ1UOHEmvvZz7prTWH5fAU2c4iu2tTndq27Ef6kXwo53BFOUghJvtq
         QjXJRCUPxpTO24d6ahWzHdtAB4hYUHUziVgkbKZVjnUbBd0luUYIR0teA/DYHyyNoWxy
         EvPg677eVCf98CGvmRfozRdrINU1ovXOl+ELvFEcnTHIhGKc5Ml1wvGeGHTfH4nRqIGS
         dpyg==
X-Gm-Message-State: AOAM532YockSCcqAp6iMXD2LS16Z7Vcxw1ha8Ip8wkVKBq+iYipP8/jI
        HxR7VqZHfNj3SRPYd0A6Ib6yv8nrSxQnR5GjJCJCbBm079k3Gg==
X-Google-Smtp-Source: ABdhPJyRffBbIyge+mxx3+rocW2yBPQPsr3ydSTIpmTalNBESQZDakdQjJ8vxpfHURqjys+PlniLHyXxp7XbExrM0AA=
X-Received: by 2002:a05:6602:1604:: with SMTP id x4mr25723516iow.84.1639215504879;
 Sat, 11 Dec 2021 01:38:24 -0800 (PST)
MIME-Version: 1.0
References: <CALrw=nEaWhpG1y7VNTGDFfF1RWbPvm5ka5xWxD-YWTS3U=r9Ng@mail.gmail.com>
 <d49e157a-5915-fbdc-8103-d7ba2621aea9@redhat.com> <CALrw=nHTJpoSFFadmDL2EL95D2kAiH5G-dgLvU0L7X=emxrP2A@mail.gmail.com>
 <YaaIRv0n2E8F5YpX@google.com> <CALrw=nGrAhSn=MkW-wvNr=UnaS5=t24yY-TWjSvcNJa1oJ85ww@mail.gmail.com>
 <CALrw=nE+yGtRi-0bFFwXa9R8ydHKV7syRYeAYuC0EBTvdFiidQ@mail.gmail.com> <YbQPcsnpowmCP7G8@google.com>
In-Reply-To: <YbQPcsnpowmCP7G8@google.com>
From:   Ignat Korchagin <ignat@cloudflare.com>
Date:   Sat, 11 Dec 2021 09:38:14 +0000
Message-ID: <CALrw=nFK7vhBXXzAB0pti-pdp1T_wtr+50Dj8nwYDHF77AsBZA@mail.gmail.com>
Subject: Re: Potential bug in TDP MMU
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        stevensd@chromium.org, kernel-team <kernel-team@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Dec 11, 2021 at 2:39 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Fri, Dec 10, 2021, Ignat Korchagin wrote:
> > I've been trying to figure out the difference between "good" runs and
> > "bad" runs of gvisor. So, if I've been running the following bpftrace
> > onliner:
>
> ...
>
> > That is, I never get a stack with
> > kvm_tdp_mmu_put_root->..->kvm_set_pfn_dirty with a "good" run.
> > Perhaps, this may shed some light onto what is going on.
>
> Hmm, a little?
>
> Based on the WARN backtrace, KVM encounters an entire chain of valid, present TDP
> MMU paging structures _after_ exit_mm() in the do_exit() path, as the call to
> task_work_run() in do_exit() occurs after exit_mm().
>
> That means that kvm_mmu_zap_all() is guaranteed to have been called before the
> fatal kvm_arch_destroy_vm(), as either:
>
>   a) exit_mm() put the last reference to mm_users and thus called __mmput ->
>      exit_mmap() -> mmu_notifier_release() -> ... -> kvm_mmu_zap_all().
>
>   b) Something else had a reference to mm_users, and so KVM's ->release hook was
>      invoked by kvm_destroy_vm() -> mmu_notifier_unregister().
>
> It's probably fairly safe to assume this is a TDP MMU bug, which rules out races
> or bad refcounts in other areas.

Most likely. Currently we're using kvm.tdp_mmu=0 kernel cmdline as a
workaround and haven't encountered any issues.

> That means that KVM (a) is somehow losing track of a root, (b) isn't zapping all
> SPTEs in kvm_mmu_zap_all(), or (c) is installing a SPTE after the mm has been released.
>
> (a) is unlikely because kvm_tdp_mmu_get_vcpu_root_hpa() is the only way for a
> vCPU to get a reference, and it holds mmu_lock for write, doesn't yield, and
> either gets a root from the list or adds a root to the list.
>
> (b) is unlikely because I would expect the fallout to be much larger and not
> unique to your setup.
>
> That leaves (c), which isn't all that likely either.  I can think of a variety of
> ways KVM might write a defunct SPTE, but I can't concoct a scenario where an
> entire tree of a present paging structures is written.
>
> Can you run with the below debug patch and see if you get a hit in the failure
> scenario?  Or possibly even a non-failure scenario?  This should either confirm
> or rule out (c).
>
>
> ---
>  arch/x86/kvm/mmu/mmu.c     | 2 ++
>  arch/x86/kvm/mmu/tdp_mmu.c | 5 +++++
>  include/linux/kvm_host.h   | 2 ++
>  3 files changed, 9 insertions(+)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 1ccee4d17481..e4e283a38570 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -5939,6 +5939,8 @@ void kvm_mmu_zap_all(struct kvm *kvm)
>         LIST_HEAD(invalid_list);
>         int ign;
>
> +       atomic_set(&kvm->mm_released, 1);
> +
>         write_lock(&kvm->mmu_lock);
>  restart:
>         list_for_each_entry_safe(sp, node, &kvm->arch.active_mmu_pages, link) {
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index b69e47e68307..432ccf05f446 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -504,6 +504,9 @@ static inline bool tdp_mmu_set_spte_atomic(struct kvm *kvm,
>  {
>         lockdep_assert_held_read(&kvm->mmu_lock);
>
> +       WARN_ON(atomic_read(&kvm->mm_released) &&
> +               new_spte && !is_removed_spte(new_spte));
> +
>         /*
>          * Do not change removed SPTEs. Only the thread that froze the SPTE
>          * may modify it.
> @@ -577,6 +580,8 @@ static inline void __tdp_mmu_set_spte(struct kvm *kvm, struct tdp_iter *iter,
>  {
>         lockdep_assert_held_write(&kvm->mmu_lock);
>
> +       WARN_ON(atomic_read(&kvm->mm_released) && new_spte);
> +
>         /*
>          * No thread should be using this function to set SPTEs to the
>          * temporary removed SPTE value.
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index e7bfcc3b6b0b..8e76e2f6c3be 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -569,6 +569,8 @@ struct kvm {
>
>         struct mutex slots_lock;
>
> +       atomic_t mm_released;
> +
>         /*
>          * Protects the arch-specific fields of struct kvm_memory_slots in
>          * use by the VM. To be used under the slots_lock (above) or in a
>
> base-commit: 1c10f4b4877ffaed602d12ff8cbbd5009e82c970
> --

Thanks. Applied the patch, but no warnings are triggered neither in
"good" case nor in "bad" case.

Ignat
