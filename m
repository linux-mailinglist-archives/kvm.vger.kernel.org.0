Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BA4634F64F
	for <lists+kvm@lfdr.de>; Wed, 31 Mar 2021 03:42:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233105AbhCaBmW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Mar 2021 21:42:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233072AbhCaBmE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Mar 2021 21:42:04 -0400
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D42E5C061574;
        Tue, 30 Mar 2021 18:42:03 -0700 (PDT)
Received: by mail-ot1-x336.google.com with SMTP id l12-20020a9d6a8c0000b0290238e0f9f0d8so17483780otq.8;
        Tue, 30 Mar 2021 18:42:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=L4HYU4B9MhVI856+wwgWJOvRn6PAtGJxDH9mTJTEHWg=;
        b=EAozvNtnt/hXIX+huZvvL9zStrqs4tAOwk/wr8sADXChnhppi9G4+6E/VTUMZSz+2T
         5+D7Ro3oopY062c1QAhgf7tROaG+dgDUi3gTE0Xp1Ge4/u1C0tx5k3sBIMAGdgPLbN41
         XJQwIe99+LOMRFFX7ly/7ZabjKNSmwJ+13I7ceNWYyoeHEwi+50duu1tZ/S1fAzhnK2E
         3ciuHvMaRzU35DrVK+GwGCZn2kAWLCn3A4NQzDsvFv3jT8FJCTqGx6tQv0ujOejgd128
         bdFwF/H4adrifd95OpyVeiiJrSGx0ysfuaQqEOtS5aP0vQvmts/MKvspiIVfcAXY/SxV
         jyuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=L4HYU4B9MhVI856+wwgWJOvRn6PAtGJxDH9mTJTEHWg=;
        b=W3IcfzTimRAsn0B8sTXg7dNYetKU6yGSOcIAxMYF8A0hbL22pO1or/oI+uQtliwGOT
         mHF8bWK6UqAP2Htb26/vjJshDNgNWf0tC1gLF99P5s7TdrTjjF8nDrQrSHlqF1rprcoR
         9aaOGmoSufN6c0ZU64QU75wyFXO4WHKQLWVf9nMhh0W9Iuo2Rv8vHfHeeC1IoO/EhFSt
         b80FECHn7/49bckoYEtZha91c11LoK8Gkv7w9u75WLFJObRb6+zyYN8/LblxS1eHTt4K
         6q9Oi0mpJx3c53S4YMZ6wrOiJ473tvfE2T4vNaaLV6aIltkfz1EB8BfgxCWgl0TVex+k
         FQKg==
X-Gm-Message-State: AOAM531LBc+Bs5HALEGSL6KNwxkKwT/FLesdiH529oIVV1j1QMhbM2hn
        lMBkWAV9v8veKpwQLPmsRrr6nyfv/zOYMUzMwTc=
X-Google-Smtp-Source: ABdhPJx0p1d/UvRuh0/hNiwqfk+eAkt745fo+ViXHnc+fvKtGeoliaVn+G5xXna7bYb2yPzm39m2KMSZVzAP9Muwj6U=
X-Received: by 2002:a9d:470b:: with SMTP id a11mr599411otf.254.1617154923144;
 Tue, 30 Mar 2021 18:42:03 -0700 (PDT)
MIME-Version: 1.0
References: <20210330165958.3094759-1-pbonzini@redhat.com> <20210330165958.3094759-3-pbonzini@redhat.com>
In-Reply-To: <20210330165958.3094759-3-pbonzini@redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Wed, 31 Mar 2021 09:41:51 +0800
Message-ID: <CANRm+CwFDiZVGhfJNz8hqe1B1t37=1R1x=bjQCkBX1-nZwe17g@mail.gmail.com>
Subject: Re: [PATCH 2/2] KVM: x86: disable interrupts while
 pvclock_gtod_sync_lock is taken
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        David Woodhouse <dwmw@amazon.co.uk>,
        syzbot <syzbot+b282b65c2c68492df769@syzkaller.appspotmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 31 Mar 2021 at 01:01, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> pvclock_gtod_sync_lock can be taken with interrupts disabled if the
> preempt notifier calls get_kvmclock_ns to update the Xen
> runstate information:
>
>    spin_lock include/linux/spinlock.h:354 [inline]
>    get_kvmclock_ns+0x25/0x390 arch/x86/kvm/x86.c:2587
>    kvm_xen_update_runstate+0x3d/0x2c0 arch/x86/kvm/xen.c:69
>    kvm_xen_update_runstate_guest+0x74/0x320 arch/x86/kvm/xen.c:100
>    kvm_xen_runstate_set_preempted arch/x86/kvm/xen.h:96 [inline]
>    kvm_arch_vcpu_put+0x2d8/0x5a0 arch/x86/kvm/x86.c:4062
>
> So change the users of the spinlock to spin_lock_irqsave and
> spin_unlock_irqrestore.
>
> Reported-by: syzbot+b282b65c2c68492df769@syzkaller.appspotmail.com
> Fixes: 30b5c851af79 ("KVM: x86/xen: Add support for vCPU runstate information")
> Cc: David Woodhouse <dwmw@amazon.co.uk>
> Cc: Marcelo Tosatti <mtosatti@redhat.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Reviewed-by: Wanpeng Li <wanpengli@tencent.com>

> ---
>  arch/x86/kvm/x86.c | 25 ++++++++++++++-----------
>  1 file changed, 14 insertions(+), 11 deletions(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 0a83eff40b43..2bfd00da465f 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2329,7 +2329,7 @@ static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 data)
>         kvm_vcpu_write_tsc_offset(vcpu, offset);
>         raw_spin_unlock_irqrestore(&kvm->arch.tsc_write_lock, flags);
>
> -       spin_lock(&kvm->arch.pvclock_gtod_sync_lock);
> +       spin_lock_irqsave(&kvm->arch.pvclock_gtod_sync_lock, flags);
>         if (!matched) {
>                 kvm->arch.nr_vcpus_matched_tsc = 0;
>         } else if (!already_matched) {
> @@ -2337,7 +2337,7 @@ static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 data)
>         }
>
>         kvm_track_tsc_matching(vcpu);
> -       spin_unlock(&kvm->arch.pvclock_gtod_sync_lock);
> +       spin_unlock_irqrestore(&kvm->arch.pvclock_gtod_sync_lock, flags);
>  }
>
>  static inline void adjust_tsc_offset_guest(struct kvm_vcpu *vcpu,
> @@ -2559,15 +2559,16 @@ static void kvm_gen_update_masterclock(struct kvm *kvm)
>         int i;
>         struct kvm_vcpu *vcpu;
>         struct kvm_arch *ka = &kvm->arch;
> +       unsigned long flags;
>
>         kvm_hv_invalidate_tsc_page(kvm);
>
>         kvm_make_mclock_inprogress_request(kvm);
>
>         /* no guest entries from this point */
> -       spin_lock(&ka->pvclock_gtod_sync_lock);
> +       spin_lock_irqsave(&ka->pvclock_gtod_sync_lock, flags);
>         pvclock_update_vm_gtod_copy(kvm);
> -       spin_unlock(&ka->pvclock_gtod_sync_lock);
> +       spin_unlock_irqrestore(&ka->pvclock_gtod_sync_lock, flags);
>
>         kvm_for_each_vcpu(i, vcpu, kvm)
>                 kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
> @@ -2582,17 +2583,18 @@ u64 get_kvmclock_ns(struct kvm *kvm)
>  {
>         struct kvm_arch *ka = &kvm->arch;
>         struct pvclock_vcpu_time_info hv_clock;
> +       unsigned long flags;
>         u64 ret;
>
> -       spin_lock(&ka->pvclock_gtod_sync_lock);
> +       spin_lock_irqsave(&ka->pvclock_gtod_sync_lock, flags);
>         if (!ka->use_master_clock) {
> -               spin_unlock(&ka->pvclock_gtod_sync_lock);
> +               spin_unlock_irqrestore(&ka->pvclock_gtod_sync_lock, flags);
>                 return get_kvmclock_base_ns() + ka->kvmclock_offset;
>         }
>
>         hv_clock.tsc_timestamp = ka->master_cycle_now;
>         hv_clock.system_time = ka->master_kernel_ns + ka->kvmclock_offset;
> -       spin_unlock(&ka->pvclock_gtod_sync_lock);
> +       spin_unlock_irqrestore(&ka->pvclock_gtod_sync_lock, flags);
>
>         /* both __this_cpu_read() and rdtsc() should be on the same cpu */
>         get_cpu();
> @@ -2686,13 +2688,13 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
>          * If the host uses TSC clock, then passthrough TSC as stable
>          * to the guest.
>          */
> -       spin_lock(&ka->pvclock_gtod_sync_lock);
> +       spin_lock_irqsave(&ka->pvclock_gtod_sync_lock, flags);
>         use_master_clock = ka->use_master_clock;
>         if (use_master_clock) {
>                 host_tsc = ka->master_cycle_now;
>                 kernel_ns = ka->master_kernel_ns;
>         }
> -       spin_unlock(&ka->pvclock_gtod_sync_lock);
> +       spin_unlock_irqrestore(&ka->pvclock_gtod_sync_lock, flags);
>
>         /* Keep irq disabled to prevent changes to the clock */
>         local_irq_save(flags);
> @@ -7724,6 +7726,7 @@ static void kvm_hyperv_tsc_notifier(void)
>         struct kvm *kvm;
>         struct kvm_vcpu *vcpu;
>         int cpu;
> +       unsigned long flags;
>
>         mutex_lock(&kvm_lock);
>         list_for_each_entry(kvm, &vm_list, vm_list)
> @@ -7739,9 +7742,9 @@ static void kvm_hyperv_tsc_notifier(void)
>         list_for_each_entry(kvm, &vm_list, vm_list) {
>                 struct kvm_arch *ka = &kvm->arch;
>
> -               spin_lock(&ka->pvclock_gtod_sync_lock);
> +               spin_lock_irqsave(&ka->pvclock_gtod_sync_lock, flags);
>                 pvclock_update_vm_gtod_copy(kvm);
> -               spin_unlock(&ka->pvclock_gtod_sync_lock);
> +               spin_unlock_irqrestore(&ka->pvclock_gtod_sync_lock, flags);
>
>                 kvm_for_each_vcpu(cpu, vcpu, kvm)
>                         kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
> --
> 2.26.2
>
