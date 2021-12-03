Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8991466FAB
	for <lists+kvm@lfdr.de>; Fri,  3 Dec 2021 03:18:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378055AbhLCCVf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Dec 2021 21:21:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244477AbhLCCVe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Dec 2021 21:21:34 -0500
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6C6CC06174A;
        Thu,  2 Dec 2021 18:18:10 -0800 (PST)
Received: by mail-oi1-x233.google.com with SMTP id n66so2929613oia.9;
        Thu, 02 Dec 2021 18:18:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ID68FmgYdJ08/2DpLeu3xV7W5csGpDe7raph8daXNiE=;
        b=O+hkwaxiNwrVXImb3meYbf/Te3Ad3ClwDv8bCxeXzYNuyzlZ00bwQoXxZLg/AyKhFS
         1+IUWTZm8jR1cyxShU8Nd3TYGxDbKoBkqK1zJaWib/JLhjBgVN+/P5YRMa2p9LSmQ87Y
         43fAHmvaoIUOQP6ivE4g2Vu0V6jtP8DfYwxO6IKPLSNsqC9L4RsGKWVJU4mCnL1Ho5i3
         73E1fwJI94xt9aVyEW07QNhFdyV144s2JVR/u4MDgCQ7ZSoflBIwUZMdE8eKktRGKk+R
         vwi564IffPKHiQg7Y1A1YbCcl9I8+mWgp4VQ1hDIgkpZMut726hFhYQHj2yCeQO4U+d6
         y5hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ID68FmgYdJ08/2DpLeu3xV7W5csGpDe7raph8daXNiE=;
        b=H7VcNxuLKu6GL++vqczMJzOefbUDjN39lV5vVlEtUGaFocwOX8qTCx+/zQ+Uvf6pPf
         hzN2qjeuwIOBCJVfzxUm8UeVz/J3wgCN2U1MDoR3U3Bxe5tXYQ03P8UwhPb54HXOtnql
         vymTNxVGEkK36zL79QC9JvZJARSItxLdji04Np2RCHWbu4rtC5K62y+Uto2WpvYfqomf
         zoGUcfPbFv6wJycYNd2YpnUBpahY8C7kjq0Gr3/Uws//aDAQV35AY5f/z1FzAHqcI0r9
         WqZP/46oDe2Ioc9S3OAB6XQq3p1dj2szae5sHF+A3xdWDNDOvQA46Yg3PqAHH61TchCC
         aMpA==
X-Gm-Message-State: AOAM533YwO8cds5O2qahJvMK6ROAUmuX+9pbkGhk/R9sDNhzDvb7K63d
        o9YBZ2H4HAKFedTDdxH07FoaM3OKTjWMus9seik=
X-Google-Smtp-Source: ABdhPJzu9pqRgJ91mqDl0i7dnrkE9ql0LMNO0UQNBe+FHfN2MO85arM5tMuCpB4zY4i3O0UWT7ba3c+TUg+DDTCEYFs=
X-Received: by 2002:a05:6808:1919:: with SMTP id bf25mr7691558oib.33.1638497890165;
 Thu, 02 Dec 2021 18:18:10 -0800 (PST)
MIME-Version: 1.0
References: <20211130123746.293379-1-pbonzini@redhat.com>
In-Reply-To: <20211130123746.293379-1-pbonzini@redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Fri, 3 Dec 2021 10:17:59 +0800
Message-ID: <CANRm+Cz8aKsoLpiuiL0qkgQ7HW9Ao2zS=WAUoYpM=CX5yh_8OA@mail.gmail.com>
Subject: Re: [PATCH] KVM: ensure APICv is considered inactive if there is no APIC
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Ignat Korchagin <ignat@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 1 Dec 2021 at 12:14, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> kvm_vcpu_apicv_active() returns false if a virtual machine has no in-kernel
> local APIC, however kvm_apicv_activated might still be true if there are
> no reasons to disable APICv; in fact it is quite likely that there is none
> because APICv is inhibited by specific configurations of the local APIC
> and those configurations cannot be programmed.  This triggers a WARN:
>
>    WARN_ON_ONCE(kvm_apicv_activated(vcpu->kvm) != kvm_vcpu_apicv_active(vcpu));
>
> To avoid this, introduce another cause for APICv inhibition, namely the
> absence of an in-kernel local APIC.  This cause is enabled by default,
> and is dropped by either KVM_CREATE_IRQCHIP or the enabling of
> KVM_CAP_IRQCHIP_SPLIT.
>
> Reported-by: Ignat Korchagin <ignat@cloudflare.com>
> Fixes: ee49a8932971 ("KVM: x86: Move SVM's APICv sanity check to common x86", 2021-10-22)
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Reviewed-by: Wanpeng Li <wanpengli@tencent.com>

> ---
>  arch/x86/include/asm/kvm_host.h | 1 +
>  arch/x86/kvm/svm/avic.c         | 1 +
>  arch/x86/kvm/vmx/vmx.c          | 1 +
>  arch/x86/kvm/x86.c              | 9 +++++----
>  4 files changed, 8 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 6ac61f85e07b..860ed500580c 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1036,6 +1036,7 @@ struct kvm_x86_msr_filter {
>  #define APICV_INHIBIT_REASON_PIT_REINJ  4
>  #define APICV_INHIBIT_REASON_X2APIC    5
>  #define APICV_INHIBIT_REASON_BLOCKIRQ  6
> +#define APICV_INHIBIT_REASON_ABSENT    7
>
>  struct kvm_arch {
>         unsigned long n_used_mmu_pages;
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index affc0ea98d30..5a55a78e2f50 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -900,6 +900,7 @@ int svm_update_pi_irte(struct kvm *kvm, unsigned int host_irq,
>  bool svm_check_apicv_inhibit_reasons(ulong bit)
>  {
>         ulong supported = BIT(APICV_INHIBIT_REASON_DISABLE) |
> +                         BIT(APICV_INHIBIT_REASON_ABSENT) |
>                           BIT(APICV_INHIBIT_REASON_HYPERV) |
>                           BIT(APICV_INHIBIT_REASON_NESTED) |
>                           BIT(APICV_INHIBIT_REASON_IRQWIN) |
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 1fadec8cbf96..ca1fd93c1dc9 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7525,6 +7525,7 @@ static void hardware_unsetup(void)
>  static bool vmx_check_apicv_inhibit_reasons(ulong bit)
>  {
>         ulong supported = BIT(APICV_INHIBIT_REASON_DISABLE) |
> +                         BIT(APICV_INHIBIT_REASON_ABSENT) |
>                           BIT(APICV_INHIBIT_REASON_HYPERV) |
>                           BIT(APICV_INHIBIT_REASON_BLOCKIRQ);
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 0ee1a039b490..e0aa4dd53c7f 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -5740,6 +5740,7 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>                 smp_wmb();
>                 kvm->arch.irqchip_mode = KVM_IRQCHIP_SPLIT;
>                 kvm->arch.nr_reserved_ioapic_pins = cap->args[0];
> +               kvm_request_apicv_update(kvm, true, APICV_INHIBIT_REASON_ABSENT);
>                 r = 0;
>  split_irqchip_unlock:
>                 mutex_unlock(&kvm->lock);
> @@ -6120,6 +6121,7 @@ long kvm_arch_vm_ioctl(struct file *filp,
>                 /* Write kvm->irq_routing before enabling irqchip_in_kernel. */
>                 smp_wmb();
>                 kvm->arch.irqchip_mode = KVM_IRQCHIP_KERNEL;
> +               kvm_request_apicv_update(kvm, true, APICV_INHIBIT_REASON_ABSENT);
>         create_irqchip_unlock:
>                 mutex_unlock(&kvm->lock);
>                 break;
> @@ -8818,10 +8820,9 @@ static void kvm_apicv_init(struct kvm *kvm)
>  {
>         init_rwsem(&kvm->arch.apicv_update_lock);
>
> -       if (enable_apicv)
> -               clear_bit(APICV_INHIBIT_REASON_DISABLE,
> -                         &kvm->arch.apicv_inhibit_reasons);
> -       else
> +       set_bit(APICV_INHIBIT_REASON_ABSENT,
> +               &kvm->arch.apicv_inhibit_reasons);
> +       if (!enable_apicv)
>                 set_bit(APICV_INHIBIT_REASON_DISABLE,
>                         &kvm->arch.apicv_inhibit_reasons);
>  }
> --
> 2.31.1
>
