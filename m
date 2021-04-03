Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D77035321F
	for <lists+kvm@lfdr.de>; Sat,  3 Apr 2021 04:31:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236138AbhDCCbW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Apr 2021 22:31:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:47340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234488AbhDCCbU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Apr 2021 22:31:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D3FF2611CB;
        Sat,  3 Apr 2021 02:31:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617417074;
        bh=MFUAh5s3SuwjEHlAMEDnTACaZ4uAxpBnRgM/Kb3ZUDI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=WWyluHXl8aOsF6dcsI9GWncN2yOyapdZpPBfTEuNYYIIedxooEJ/pCTVOidg8BT+u
         Pnu/7v4kR0tS6qVEGp5o8KZClD4gFEYpX3LGCxXB26aYgRgpCEa7l7dR4fzsC771Yd
         pGec0IqMjIaruObPNJnDlWodsm9Rd5PTYnrPUdrRMWaiujjmzVG58c4PotGQNV5uAD
         Q7ormNSQw4TqvlGPQwQDK6PyYbXEvoVJ9lDvNRlLLU5ZWTf6XQkN7LZf8krBObUEdB
         O1bquEXSGhJ4aXtp1X/26LoJl9tA5GRCYoGLA8AMD+nd2fynB0YC+R6mPA/51ZpGws
         FX1owtw7oSTrg==
Received: by mail-il1-f178.google.com with SMTP id d10so5956902ils.5;
        Fri, 02 Apr 2021 19:31:14 -0700 (PDT)
X-Gm-Message-State: AOAM531VHIaFFrQ5bJpx7fiX/imzVHEWXvGyJxPHQ3yGx9c+4Dlac4YQ
        39XWcwMBnwtJWfO2BvIsF6gdinuLbpCsNSXdpvI=
X-Google-Smtp-Source: ABdhPJy2ADQFhS9NB91pKq1uVyDp6/sll9F1r3brNbXEot9QIeEPwfe7EyC9daUyCB+HqAW67V7KFqt/+SUu/rzFwm4=
X-Received: by 2002:a05:6e02:1b85:: with SMTP id h5mr12930572ili.134.1617417074235;
 Fri, 02 Apr 2021 19:31:14 -0700 (PDT)
MIME-Version: 1.0
References: <20210402155807.49976-1-pbonzini@redhat.com> <20210402155807.49976-3-pbonzini@redhat.com>
In-Reply-To: <20210402155807.49976-3-pbonzini@redhat.com>
From:   Huacai Chen <chenhuacai@kernel.org>
Date:   Sat, 3 Apr 2021 10:31:02 +0800
X-Gmail-Original-Message-ID: <CAAhV-H4wskLvGD1hhuS2ZDOBNenCcTd_K8GkYn1GOzwnEvTDXQ@mail.gmail.com>
Message-ID: <CAAhV-H4wskLvGD1hhuS2ZDOBNenCcTd_K8GkYn1GOzwnEvTDXQ@mail.gmail.com>
Subject: Re: [PATCH 2/4] KVM: MIPS: rework flush_shadow_* callbacks into one
 that prepares the flush
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        seanjc@google.com, "open list:MIPS" <linux-mips@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi, Paolo,

TE mode has been removed in the MIPS tree, can we also remove it in
KVM tree before this rework?

Huacai

On Fri, Apr 2, 2021 at 11:58 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> Both trap-and-emulate and VZ have a single implementation that covers
> both .flush_shadow_all and .flush_shadow_memslot, and both of them end
> with a call to kvm_flush_remote_tlbs.
>
> Unify the callbacks into one and extract the call to kvm_flush_remote_tlbs.
> The next patches will pull it further out of the the architecture-specific
> MMU notifier functions kvm_unmap_hva_range and kvm_set_spte_hva.
>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/mips/include/asm/kvm_host.h |  9 +--------
>  arch/mips/kvm/mips.c             | 12 ++++++------
>  arch/mips/kvm/mmu.c              |  9 ++++++---
>  arch/mips/kvm/trap_emul.c        | 13 ++-----------
>  arch/mips/kvm/vz.c               | 19 ++++---------------
>  5 files changed, 19 insertions(+), 43 deletions(-)
>
> diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm/kvm_host.h
> index feaa77036b67..6c8c0ab53be2 100644
> --- a/arch/mips/include/asm/kvm_host.h
> +++ b/arch/mips/include/asm/kvm_host.h
> @@ -815,14 +815,7 @@ struct kvm_mips_callbacks {
>         int (*vcpu_init)(struct kvm_vcpu *vcpu);
>         void (*vcpu_uninit)(struct kvm_vcpu *vcpu);
>         int (*vcpu_setup)(struct kvm_vcpu *vcpu);
> -       void (*flush_shadow_all)(struct kvm *kvm);
> -       /*
> -        * Must take care of flushing any cached GPA PTEs (e.g. guest entries in
> -        * VZ root TLB, or T&E GVA page tables and corresponding root TLB
> -        * mappings).
> -        */
> -       void (*flush_shadow_memslot)(struct kvm *kvm,
> -                                    const struct kvm_memory_slot *slot);
> +       void (*prepare_flush_shadow)(struct kvm *kvm);
>         gpa_t (*gva_to_gpa)(gva_t gva);
>         void (*queue_timer_int)(struct kvm_vcpu *vcpu);
>         void (*dequeue_timer_int)(struct kvm_vcpu *vcpu);
> diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
> index 7db8234a4407..867b8de0fc07 100644
> --- a/arch/mips/kvm/mips.c
> +++ b/arch/mips/kvm/mips.c
> @@ -206,7 +206,8 @@ void kvm_arch_flush_shadow_all(struct kvm *kvm)
>         kvm_mips_flush_gpa_pt(kvm, 0, ~0);
>
>         /* Let implementation do the rest */
> -       kvm_mips_callbacks->flush_shadow_all(kvm);
> +       kvm_mips_callbacks->prepare_flush_shadow(kvm);
> +       kvm_flush_remote_tlbs(kvm);
>  }
>
>  void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
> @@ -221,8 +222,7 @@ void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
>         /* Flush slot from GPA */
>         kvm_mips_flush_gpa_pt(kvm, slot->base_gfn,
>                               slot->base_gfn + slot->npages - 1);
> -       /* Let implementation do the rest */
> -       kvm_mips_callbacks->flush_shadow_memslot(kvm, slot);
> +       kvm_arch_flush_remote_tlbs_memslot(kvm, slot);
>         spin_unlock(&kvm->mmu_lock);
>  }
>
> @@ -262,9 +262,8 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
>                 /* Write protect GPA page table entries */
>                 needs_flush = kvm_mips_mkclean_gpa_pt(kvm, new->base_gfn,
>                                         new->base_gfn + new->npages - 1);
> -               /* Let implementation do the rest */
>                 if (needs_flush)
> -                       kvm_mips_callbacks->flush_shadow_memslot(kvm, new);
> +                       kvm_arch_flush_remote_tlbs_memslot(kvm, new);
>                 spin_unlock(&kvm->mmu_lock);
>         }
>  }
> @@ -1000,7 +999,8 @@ void kvm_arch_flush_remote_tlbs_memslot(struct kvm *kvm,
>                                         const struct kvm_memory_slot *memslot)
>  {
>         /* Let implementation handle TLB/GVA invalidation */
> -       kvm_mips_callbacks->flush_shadow_memslot(kvm, memslot);
> +       kvm_mips_callbacks->prepare_flush_shadow(kvm);
> +       kvm_flush_remote_tlbs(kvm);
>  }
>
>  long kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
> diff --git a/arch/mips/kvm/mmu.c b/arch/mips/kvm/mmu.c
> index 3dabeda82458..7e055e5dfd3c 100644
> --- a/arch/mips/kvm/mmu.c
> +++ b/arch/mips/kvm/mmu.c
> @@ -491,7 +491,8 @@ int kvm_unmap_hva_range(struct kvm *kvm, unsigned long start, unsigned long end,
>  {
>         handle_hva_to_gpa(kvm, start, end, &kvm_unmap_hva_handler, NULL);
>
> -       kvm_mips_callbacks->flush_shadow_all(kvm);
> +       kvm_mips_callbacks->prepare_flush_shadow(kvm);
> +       kvm_flush_remote_tlbs(kvm);
>         return 0;
>  }
>
> @@ -532,8 +533,10 @@ int kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte)
>         int ret;
>
>         ret = handle_hva_to_gpa(kvm, hva, end, &kvm_set_spte_handler, &pte);
> -       if (ret)
> -               kvm_mips_callbacks->flush_shadow_all(kvm);
> +       if (ret) {
> +               kvm_mips_callbacks->prepare_flush_shadow(kvm);
> +               kvm_flush_remote_tlbs(kvm);
> +       }
>         return 0;
>  }
>
> diff --git a/arch/mips/kvm/trap_emul.c b/arch/mips/kvm/trap_emul.c
> index 0788c00d7e94..5f2df497599c 100644
> --- a/arch/mips/kvm/trap_emul.c
> +++ b/arch/mips/kvm/trap_emul.c
> @@ -687,16 +687,8 @@ static int kvm_trap_emul_vcpu_setup(struct kvm_vcpu *vcpu)
>         return 0;
>  }
>
> -static void kvm_trap_emul_flush_shadow_all(struct kvm *kvm)
> +static void kvm_trap_emul_prepare_flush_shadow(struct kvm *kvm)
>  {
> -       /* Flush GVA page tables and invalidate GVA ASIDs on all VCPUs */
> -       kvm_flush_remote_tlbs(kvm);
> -}
> -
> -static void kvm_trap_emul_flush_shadow_memslot(struct kvm *kvm,
> -                                       const struct kvm_memory_slot *slot)
> -{
> -       kvm_trap_emul_flush_shadow_all(kvm);
>  }
>
>  static u64 kvm_trap_emul_get_one_regs[] = {
> @@ -1280,8 +1272,7 @@ static struct kvm_mips_callbacks kvm_trap_emul_callbacks = {
>         .vcpu_init = kvm_trap_emul_vcpu_init,
>         .vcpu_uninit = kvm_trap_emul_vcpu_uninit,
>         .vcpu_setup = kvm_trap_emul_vcpu_setup,
> -       .flush_shadow_all = kvm_trap_emul_flush_shadow_all,
> -       .flush_shadow_memslot = kvm_trap_emul_flush_shadow_memslot,
> +       .prepare_flush_shadow = kvm_trap_emul_prepare_flush_shadow,
>         .gva_to_gpa = kvm_trap_emul_gva_to_gpa_cb,
>         .queue_timer_int = kvm_mips_queue_timer_int_cb,
>         .dequeue_timer_int = kvm_mips_dequeue_timer_int_cb,
> diff --git a/arch/mips/kvm/vz.c b/arch/mips/kvm/vz.c
> index 2ffbe9264a31..2c75571dc4a2 100644
> --- a/arch/mips/kvm/vz.c
> +++ b/arch/mips/kvm/vz.c
> @@ -3211,32 +3211,22 @@ static int kvm_vz_vcpu_setup(struct kvm_vcpu *vcpu)
>         return 0;
>  }
>
> -static void kvm_vz_flush_shadow_all(struct kvm *kvm)
> +static void kvm_vz_prepare_flush_shadow(struct kvm *kvm)
>  {
> -       if (cpu_has_guestid) {
> -               /* Flush GuestID for each VCPU individually */
> -               kvm_flush_remote_tlbs(kvm);
> -       } else {
> +       if (!cpu_has_guestid) {
>                 /*
>                  * For each CPU there is a single GPA ASID used by all VCPUs in
>                  * the VM, so it doesn't make sense for the VCPUs to handle
>                  * invalidation of these ASIDs individually.
>                  *
>                  * Instead mark all CPUs as needing ASID invalidation in
> -                * asid_flush_mask, and just use kvm_flush_remote_tlbs(kvm) to
> +                * asid_flush_mask, and kvm_flush_remote_tlbs(kvm) will
>                  * kick any running VCPUs so they check asid_flush_mask.
>                  */
>                 cpumask_setall(&kvm->arch.asid_flush_mask);
> -               kvm_flush_remote_tlbs(kvm);
>         }
>  }
>
> -static void kvm_vz_flush_shadow_memslot(struct kvm *kvm,
> -                                       const struct kvm_memory_slot *slot)
> -{
> -       kvm_vz_flush_shadow_all(kvm);
> -}
> -
>  static void kvm_vz_vcpu_reenter(struct kvm_vcpu *vcpu)
>  {
>         int cpu = smp_processor_id();
> @@ -3292,8 +3282,7 @@ static struct kvm_mips_callbacks kvm_vz_callbacks = {
>         .vcpu_init = kvm_vz_vcpu_init,
>         .vcpu_uninit = kvm_vz_vcpu_uninit,
>         .vcpu_setup = kvm_vz_vcpu_setup,
> -       .flush_shadow_all = kvm_vz_flush_shadow_all,
> -       .flush_shadow_memslot = kvm_vz_flush_shadow_memslot,
> +       .prepare_flush_shadow = kvm_vz_prepare_flush_shadow,
>         .gva_to_gpa = kvm_vz_gva_to_gpa_cb,
>         .queue_timer_int = kvm_vz_queue_timer_int_cb,
>         .dequeue_timer_int = kvm_vz_dequeue_timer_int_cb,
> --
> 2.30.1
>
>
