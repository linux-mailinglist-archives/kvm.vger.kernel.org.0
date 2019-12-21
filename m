Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31D891285F3
	for <lists+kvm@lfdr.de>; Sat, 21 Dec 2019 01:28:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726556AbfLUA1i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Dec 2019 19:27:38 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:33438 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726462AbfLUA1i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Dec 2019 19:27:38 -0500
Received: by mail-io1-f65.google.com with SMTP id z8so11147506ioh.0
        for <kvm@vger.kernel.org>; Fri, 20 Dec 2019 16:27:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OZNK1+TUcHhHbvzo/ui/RticmVqi6ywWiXT5CH9RLjg=;
        b=aJtHqMrEXe7WAcK/ciq8OO0lGBjQxSKRDwPYaZpk9iCCuF+8NbYdXOgZqxuPy2PGCh
         FVoZAtGENVOmWX0hCfoMigaZkqmqmqP0Kq4yyTD/eXza4kwlqj6dUv/Tf8OyqFz0QqYJ
         e/W7MOUf6V2Ex3MpkUMmkJwqCL+M/n1bXI+zL8XrInSYAhHmVdgN8gsjbvfXL2zHWSG9
         GaIYdLDK+52Sg1JqM8zlGBsww1DeMFXd5vhKAEDWM98blIpit/+KDnWJpQo8REtqaI1g
         XNyrGMY8rLOJ0qU5W/rG4u/B2QAzhiQEGBKNABM32i3S61KSoD4DEEQKmbWiz2y2SzaY
         KZAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OZNK1+TUcHhHbvzo/ui/RticmVqi6ywWiXT5CH9RLjg=;
        b=ZbvhXQV418nTisoKt6oFrawdAbGN2T3LKHTOrUeR0+LGfSqwIiLIf7xAqxDmvMAl2B
         EX2G6Vc56XLMn47Mg99CmcBdMdd2MXczIaoWrYBM7YPCL7U4hzpyY+4k2Y5OZpnV7w8Z
         H3uX3fcAg5CqY6XuQjEMxSyQdKsw3KECibRNraMQChGi/8VTFD7pKTWSoOtP+otAmRNk
         UKsdlduhoWS9fJIcTehYG/rrwDrM6j/dj7AiFhSjsppWbl2PA+z4vhyUAQBfjTgvb8NN
         fuJzc8Oy51duC0H2jszkXeECps3ksCUrdwkVoTntBdvw+TNMVI6p9f3tgyZsKcPSBwi+
         UzvQ==
X-Gm-Message-State: APjAAAWE+1GXRPqjVuBuevPcsjBrwbmqkKIvARBWQKFj9k5D8mduJCUH
        0RYlD7sxjQ53Qtbh6CPkYngkrHNf/ZwNJOMT6Eand0X+KF0=
X-Google-Smtp-Source: APXvYqztS9DZIg2BL0i+UU2CZjfwVBDTpKsiljJe8lyqcihGoPvU53jS+pYS+a1CmAJnpAARppC9DV5aNPDRo5FGSfQ=
X-Received: by 2002:a02:cd3b:: with SMTP id h27mr14542447jaq.18.1576888057588;
 Fri, 20 Dec 2019 16:27:37 -0800 (PST)
MIME-Version: 1.0
References: <20190829205635.20189-1-krish.sadhukhan@oracle.com> <20190829205635.20189-3-krish.sadhukhan@oracle.com>
In-Reply-To: <20190829205635.20189-3-krish.sadhukhan@oracle.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 20 Dec 2019 16:27:26 -0800
Message-ID: <CALMp9eSxdg9evNJYSifsS1jrAhKe_bVURCRckG67YWJ=YcGB4Q@mail.gmail.com>
Subject: Re: [PATCH 2/4] KVM: nVMX: Check GUEST_DR7 on vmentry of nested guests
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 29, 2019 at 2:25 PM Krish Sadhukhan
<krish.sadhukhan@oracle.com> wrote:
>
> According to section "Checks on Guest Control Registers, Debug Registers, and
> and MSRs" in Intel SDM vol 3C, the following checks are performed on vmentry
> of nested guests:
>
>     If the "load debug controls" VM-entry control is 1, bits 63:32 in the DR7
>     field must be 0.
>
> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> Reviewed-by: Karl Heubaum <karl.heubaum@oracle.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 6 ++++++
>  arch/x86/kvm/x86.c        | 2 +-
>  arch/x86/kvm/x86.h        | 6 ++++++
>  3 files changed, 13 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 0b234e95e0ed..f04619daf906 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -2681,6 +2681,12 @@ static int nested_vmx_check_guest_state(struct kvm_vcpu *vcpu,
>             !kvm_debugctl_valid(vmcs12->guest_ia32_debugctl))
>                 return -EINVAL;
>
> +#ifdef CONFIG_X86_64
> +       if ((vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CONTROLS) &&
> +           !kvm_dr7_valid(vmcs12->guest_dr7))
> +               return -EINVAL;
> +#endif
> +
>         if ((vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_PAT) &&
>             !kvm_pat_valid(vmcs12->guest_ia32_pat))
>                 return -EINVAL;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index fafd81d2c9ea..423a7a573608 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1051,7 +1051,7 @@ static int __kvm_set_dr(struct kvm_vcpu *vcpu, int dr, unsigned long val)
>         case 5:
>                 /* fall through */
>         default: /* 7 */
> -               if (val & 0xffffffff00000000ULL)
> +               if (!kvm_dr7_valid(val))
>                         return -1; /* #GP */
>                 vcpu->arch.dr7 = (val & DR7_VOLATILE) | DR7_FIXED_1;
>                 kvm_update_dr7(vcpu);
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index 28ba6d0c359f..4e55851fc3fb 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -360,6 +360,12 @@ static inline bool kvm_debugctl_valid(u64 data)
>         return ((data & 0xFFFFFFFFFFFF203Cull) ? false : true);
>  }
>
> +static inline bool kvm_dr7_valid(u64 data)

This should be 'unsigned long data.'

> +{
> +       /* Bits [63:32] are reserved */
> +       return ((data & 0xFFFFFFFF00000000ull) ? false : true);

    return !(data & 0xFFFFFFFF00000000ull);

Or, shorter:

    return (u32)data == data;

> +}
> +
>  void kvm_load_guest_xcr0(struct kvm_vcpu *vcpu);
>  void kvm_put_guest_xcr0(struct kvm_vcpu *vcpu);
>
> --
> 2.20.1
>
