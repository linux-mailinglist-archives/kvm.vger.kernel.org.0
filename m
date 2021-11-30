Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A604463516
	for <lists+kvm@lfdr.de>; Tue, 30 Nov 2021 14:06:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236313AbhK3NJb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Nov 2021 08:09:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236183AbhK3NJa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Nov 2021 08:09:30 -0500
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77F9DC061746
        for <kvm@vger.kernel.org>; Tue, 30 Nov 2021 05:06:11 -0800 (PST)
Received: by mail-io1-xd2c.google.com with SMTP id w22so25953458ioa.1
        for <kvm@vger.kernel.org>; Tue, 30 Nov 2021 05:06:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=ybfeDMenyXZ8KVSOyw+elPKhdpvWAlXbcAd9cwBz0e0=;
        b=rG88AuieJkNWJJTx63X3oXa8ePCmuwC9utBX5jleohx9hb2U3X2cvgYnpgG4Z825i4
         Ppf78d6ARl7bHieoMRdQKG/SuS3ig/V+bUkAbEwVMpnbdzVaHMwW07xz1r6W9iGEzx5V
         vxOGrl0rEb9BZm2HHz05KAFY9EakNRdKyOvqo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=ybfeDMenyXZ8KVSOyw+elPKhdpvWAlXbcAd9cwBz0e0=;
        b=64IsQkh/gTT7TEMBJjIJfa7bSlp4xNAVhM/IWcNVUEN4/qrzNAp401NA6Xqahle2EM
         0PBD8wFdIogR1SpZzUMKZQQlAU7B3c31XbA6/GOuu/4jnJJrjHMSrgcPCZ3HwOkeASSU
         Vm+EzbLqT05eVAcAYtDSvPIwlF/wCu7m2h9k9BO1DUs8rtpHpZCQUK1rkE1/OQFkG2HA
         L6ijtCPWLslhc1ZVr9PUXs8Dq3Rmj0fQMAS50yuTTn1XKxNWqF4uNBG2C/8+UV8WIuDH
         NkmCspxeSLJ1IlIcTP5FG8+hliz10mV+oonTNH3pMnX6Fy4xgEIWEhGjly/2ddy70lIp
         LU2g==
X-Gm-Message-State: AOAM531l+Tw9SBYUTnBnOtj01lueN/eUWC8/Mtqt5t+jNUPC49wgLtIg
        e4rbInJRVQygzKOlBs6FGbHDR3m5CaJFs0jOPsEIGY2zph1zmg==
X-Google-Smtp-Source: ABdhPJzkE65UtGxLS903M4ORucpU2DrpB/BHbEz4zh94Nex6IPPoAYddokWIYf/UFEf37UnAEim0+lzk2fB5CSPa1V0=
X-Received: by 2002:a05:6602:2d84:: with SMTP id k4mr63023644iow.168.1638277570657;
 Tue, 30 Nov 2021 05:06:10 -0800 (PST)
MIME-Version: 1.0
References: <20211130123746.293379-1-pbonzini@redhat.com>
In-Reply-To: <20211130123746.293379-1-pbonzini@redhat.com>
From:   Ignat Korchagin <ignat@cloudflare.com>
Date:   Tue, 30 Nov 2021 13:05:59 +0000
Message-ID: <CALrw=nHs-3vm7jxsLvNYxU8XqHqDbJp+vy+AULqTEwdPu0razg@mail.gmail.com>
Subject: Re: [PATCH] KVM: ensure APICv is considered inactive if there is no APIC
To:     Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 30, 2021 at 12:37 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
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

Tested-by: Ignat Korchagin <ignat@cloudflare.com>
