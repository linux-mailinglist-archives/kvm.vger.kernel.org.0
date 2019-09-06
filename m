Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 539D4AAFCD
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2019 02:22:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390250AbfIFAWk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Sep 2019 20:22:40 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:42006 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733029AbfIFAWj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Sep 2019 20:22:39 -0400
Received: by mail-ot1-f66.google.com with SMTP id c10so4083728otd.9;
        Thu, 05 Sep 2019 17:22:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=F3KgxZCE6wGfvBP5oQ0LRpaf5srELgoiLv08h1VYngU=;
        b=RWyzr011WHchg8QDqqcyyG+FLCXDP1Z+h5I++aBHB1NGSbFPXlGrqiO4fbykMTFIKJ
         Ssy1jwn1j0z0AdhpLhaKgyGO77L4x8wHJWt2Yo8mJj8RwnLN70swmBFfs1XqqllZMb5a
         DWlONHhW3PBO/qR2nuTiM5VFm+jWt/allCHOWrNLOFEYAMwhKYDALbpRzIDPSCcOfFn2
         Kh5GRFcvYsj5n2qXr6Ayd43UFYXrihNsY66wmxDXTB8UETm4P9Bgp0JUiJSBW4/Q8qHC
         4asB+wk80RxvbJT9E9XuFB0Bv8O+yw8xi/75LNoBRVnT+frbKq3MNxlN/gOQ2XhmyGEI
         0Cgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=F3KgxZCE6wGfvBP5oQ0LRpaf5srELgoiLv08h1VYngU=;
        b=bjvkoT1sxtlebfhygdoP7VG7zwmjjl2QMAbzumoVJWscIR8jGvGc0bpgTr6dzDshxs
         Tjz4qz0YDUQhsj1r0UswFPjJZ9w9zH6BJS7xLvTy1xHtWCn0OuLDQwDYaywIyTKXNtBt
         dBQwXIgG6wFJImsAsPTGqvj4CpjFbuLqcJ2zzlrkfSqKCA1eaY/zY/EzttfDqQbDS41M
         2NretthfR4q/D8RKCkXn0e9Ps/xw0WXyWglIcq+thPF0kNXmChex9q8wnTy9EqH8KSbF
         SkYpScaad91bt0ejegO4ICSQBxrSZFboTjbg7cU5kHnkac8ySpV4X4gesxRKZqG+l5Vj
         6LRw==
X-Gm-Message-State: APjAAAXjRRjDVYYni1eVPKjiWcHlqZREoN5Y2XklM1OshfBoiBheR3VS
        C1xNi8h9w3uc/oft1A3AlxHqjnAuRmS/QF3UNkI=
X-Google-Smtp-Source: APXvYqzSeuicgTsdlkgjbJ7p0pM1nUj95yiRm3MH9E3XVyaqYqNQrhO1FdH26XxjqNebqAci4sW5NTeNvJnAqkUe1UQ=
X-Received: by 2002:a9d:3a63:: with SMTP id j90mr5093105otc.185.1567729358504;
 Thu, 05 Sep 2019 17:22:38 -0700 (PDT)
MIME-Version: 1.0
References: <20190905125818.22395-1-graf@amazon.com>
In-Reply-To: <20190905125818.22395-1-graf@amazon.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Fri, 6 Sep 2019 08:22:25 +0800
Message-ID: <CANRm+Cy9+AUeoCZRr6shZjaMT07=t6BJsOR8CHhy-RuZvMP+WA@mail.gmail.com>
Subject: Re: [PATCH v3] KVM: x86: Disable posted interrupts for odd IRQs
To:     Alexander Graf <graf@amazon.com>
Cc:     kvm <kvm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Liran Alon <liran.alon@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 5 Sep 2019 at 21:46, Alexander Graf <graf@amazon.com> wrote:
>
> We can easily route hardware interrupts directly into VM context when
> they target the "Fixed" or "LowPriority" delivery modes.
>
> However, on modes such as "SMI" or "Init", we need to go via KVM code
> to actually put the vCPU into a different mode of operation, so we can
> not post the interrupt
>
> Add code in the VMX and SVM PI logic to explicitly refuse to establish
> posted mappings for advanced IRQ deliver modes. This reflects the logic
> in __apic_accept_irq() which also only ever passes Fixed and LowPriority
> interrupts as posted interrupts into the guest.
>
> This fixes a bug I have with code which configures real hardware to
> inject virtual SMIs into my guest.
>
> Signed-off-by: Alexander Graf <graf@amazon.com>

Reviewed-by: Wanpeng Li <wanpengli@tencent.com>

>
> ---
>
> v1 -> v2:
>
>   - Make error message more unique
>   - Update commit message to point to __apic_accept_irq()
>
> v2 -> v3:
>
>   - Use if() rather than switch()
>   - Move abort logic into existing if() branch for broadcast irqs
>   -> remove the updated error message again (thus remove R-B tag from Liran)
>   - Fold VMX and SVM changes into single commit
>   - Combine postability check into helper function kvm_irq_is_postable()
> ---
>  arch/x86/include/asm/kvm_host.h | 7 +++++++
>  arch/x86/kvm/svm.c              | 4 +++-
>  arch/x86/kvm/vmx/vmx.c          | 6 +++++-
>  3 files changed, 15 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 44a5ce57a905..5b14aa1fbeeb 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1581,6 +1581,13 @@ bool kvm_intr_is_single_vcpu(struct kvm *kvm, struct kvm_lapic_irq *irq,
>  void kvm_set_msi_irq(struct kvm *kvm, struct kvm_kernel_irq_routing_entry *e,
>                      struct kvm_lapic_irq *irq);
>
> +static inline bool kvm_irq_is_postable(struct kvm_lapic_irq *irq)
> +{
> +       /* We can only post Fixed and LowPrio IRQs */
> +       return (irq->delivery_mode == dest_Fixed ||
> +               irq->delivery_mode == dest_LowestPrio);
> +}
> +
>  static inline void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu)
>  {
>         if (kvm_x86_ops->vcpu_blocking)
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index 1f220a85514f..f5b03d0c9bc6 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -5260,7 +5260,8 @@ get_pi_vcpu_info(struct kvm *kvm, struct kvm_kernel_irq_routing_entry *e,
>
>         kvm_set_msi_irq(kvm, e, &irq);
>
> -       if (!kvm_intr_is_single_vcpu(kvm, &irq, &vcpu)) {
> +       if (!kvm_intr_is_single_vcpu(kvm, &irq, &vcpu) ||
> +           !kvm_irq_is_postable(&irq)) {
>                 pr_debug("SVM: %s: use legacy intr remap mode for irq %u\n",
>                          __func__, irq.vector);
>                 return -1;
> @@ -5314,6 +5315,7 @@ static int svm_update_pi_irte(struct kvm *kvm, unsigned int host_irq,
>                  * 1. When cannot target interrupt to a specific vcpu.
>                  * 2. Unsetting posted interrupt.
>                  * 3. APIC virtialization is disabled for the vcpu.
> +                * 4. IRQ has incompatible delivery mode (SMI, INIT, etc)
>                  */
>                 if (!get_pi_vcpu_info(kvm, e, &vcpu_info, &svm) && set &&
>                     kvm_vcpu_apicv_active(&svm->vcpu)) {
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 570a233e272b..63f3d88b36cc 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7382,10 +7382,14 @@ static int vmx_update_pi_irte(struct kvm *kvm, unsigned int host_irq,
>                  * irqbalance to make the interrupts single-CPU.
>                  *
>                  * We will support full lowest-priority interrupt later.
> +                *
> +                * In addition, we can only inject generic interrupts using
> +                * the PI mechanism, refuse to route others through it.
>                  */
>
>                 kvm_set_msi_irq(kvm, e, &irq);
> -               if (!kvm_intr_is_single_vcpu(kvm, &irq, &vcpu)) {
> +               if (!kvm_intr_is_single_vcpu(kvm, &irq, &vcpu) ||
> +                   !kvm_irq_is_postable(&irq)) {
>                         /*
>                          * Make sure the IRTE is in remapped mode if
>                          * we don't handle it in posted mode.
> --
> 2.17.1
>
>
>
>
> Amazon Development Center Germany GmbH
> Krausenstr. 38
> 10117 Berlin
> Geschaeftsfuehrung: Christian Schlaeger, Ralf Herbrich
> Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
> Sitz: Berlin
> Ust-ID: DE 289 237 879
>
>
>
