Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FECBA297A
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2019 00:12:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728111AbfH2WMk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Aug 2019 18:12:40 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:44012 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727912AbfH2WMk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Aug 2019 18:12:40 -0400
Received: by mail-io1-f66.google.com with SMTP id u185so6289234iod.10
        for <kvm@vger.kernel.org>; Thu, 29 Aug 2019 15:12:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WyWTZZE15eNGDWqBkk/5f4Cfmq9Ki2j4rnCXGvtmM8U=;
        b=ZRboPr1eUFCaZm83/wUqxHUDDgktG5rQpL3UTXk21hjfzxrWXwlsgDvdLxLvXErFRg
         DNDHUNkW5AYxiLFiSuXg6fAIsu2TlPRLDw2QjMfjLIb4MUTGKkBmpzX5BhO/lGA2T3+6
         sOeFkHCNlHxNm4qu9gWkAdcG2qaMUb/ex+w/9n8TT7MQkdvfuXSDRwHHrmsQ1oOSecym
         3obwIIrJMuxd0sDeGGTI6G0toEZKYppfRQC39oHzsbbMGDaPzJcr0sZmUT8YIY/uRPi9
         dLadYEv+k0qO1uqADa9sLNDtvmz9WbDts2aIIRZFamjtuwvW3fCHABo8pw0fw9IvVzaJ
         glIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WyWTZZE15eNGDWqBkk/5f4Cfmq9Ki2j4rnCXGvtmM8U=;
        b=atY4zQMas12WYEiqW1CRIkFPdlRFcGKoGzb7GiN8e1ZCpp07uATUjPJABQX/ngH8fE
         CNgL/K1Ho+cmBt/65CDciyakiHoNwtyN4AvLgGP87x1AG8NmFkUAK7NSaKAGAZ0QBHNP
         ewxjyVsNWyWoJxBL8HSMjJIf/HEokeetV4o5hWD8tHToNAJ5QS8hERbnsq3eUXkV3kG3
         jDt4TGTfruGk1phrbcIuZx0KZgk+NPO8e+cIVI5zN0LmDF0mnnre8XfDb5JTw68H5ZSP
         FxkPsYhUaKXgos/Bmpu2FMwsbexqORxYjyOkLDxuklgf5epRImRl01NB6zSyVb49mqLW
         UjMA==
X-Gm-Message-State: APjAAAW7luJhovi85HVmp2mC4IPtjRobOBfD0N9wQxBQ3SVgcIbzhmX9
        XA8gVjTybS4tbWD7ZdkEJt9J8T+qve4C0q6Y57q3Ig==
X-Google-Smtp-Source: APXvYqwy3qtzt5kxgWa7fJam8wdRYBhjeO9wa/ZcPlrbRwnLpar2Y4JjJhxyBK5CAtitdvdw+3TrWj4uZfTZP+x7gxk=
X-Received: by 2002:a6b:5116:: with SMTP id f22mr1950807iob.108.1567116759043;
 Thu, 29 Aug 2019 15:12:39 -0700 (PDT)
MIME-Version: 1.0
References: <20190829205635.20189-1-krish.sadhukhan@oracle.com> <20190829205635.20189-2-krish.sadhukhan@oracle.com>
In-Reply-To: <20190829205635.20189-2-krish.sadhukhan@oracle.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 29 Aug 2019 15:12:28 -0700
Message-ID: <CALMp9eQxdF5tJLWaWu+0t0NjhSiJfowo1U6MDkjB_zYNRKiyKw@mail.gmail.com>
Subject: Re: [PATCH 1/4] KVM: nVMX: Check GUEST_DEBUGCTL on vmentry of nested guests
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
>     If the "load debug controls" VM-entry control is 1, bits reserved in the
>     IA32_DEBUGCTL MSR must be 0 in the field for that register. The first
>     processors to support the virtual-machine extensions supported only the
>     1-setting of this control and thus performed this check unconditionally.
>
> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> Reviewed-by: Karl Heubaum <karl.heubaum@oracle.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 4 ++++
>  arch/x86/kvm/x86.h        | 6 ++++++
>  2 files changed, 10 insertions(+)
>
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 46af3a5e9209..0b234e95e0ed 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -2677,6 +2677,10 @@ static int nested_vmx_check_guest_state(struct kvm_vcpu *vcpu,
>             !nested_guest_cr4_valid(vcpu, vmcs12->guest_cr4))
>                 return -EINVAL;
>
> +       if ((vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CONTROLS) &&
> +           !kvm_debugctl_valid(vmcs12->guest_ia32_debugctl))
> +               return -EINVAL;
> +
>         if ((vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_PAT) &&
>             !kvm_pat_valid(vmcs12->guest_ia32_pat))
>                 return -EINVAL;
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index a470ff0868c5..28ba6d0c359f 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -354,6 +354,12 @@ static inline bool kvm_pat_valid(u64 data)
>         return (data | ((data & 0x0202020202020202ull) << 1)) == data;
>  }
>
> +static inline bool kvm_debugctl_valid(u64 data)
> +{
> +       /* Bits 2, 3, 4, 5, 13 and [31:16] are reserved */
> +       return ((data & 0xFFFFFFFFFFFF203Cull) ? false : true);
> +}

This should actually be consistent with the constraints in kvm_set_msr_common:

case MSR_IA32_DEBUGCTLMSR:
        if (!data) {
                /* We support the non-activated case already */
                break;
        } else if (data & ~(DEBUGCTLMSR_LBR | DEBUGCTLMSR_BTF)) {
                /* Values other than LBR and BTF are vendor-specific,
                   thus reserved and should throw a #GP */
                return 1;
        }

Also, as I said earlier...

I'd rather see this built on an interface like:

bool kvm_valid_msr_value(u32 msr_index, u64 value);

Strange that we allow IA32_DEBUGCTL.BTF, since kvm_vcpu_do_singlestep
ignores it. And vLBR still isn't a thing, is it?

It's a bit scary to me that we allow any architecturally legal
IA32_DEBUGCTL bits to be set today. There's probably a CVE in there
somewhere.
