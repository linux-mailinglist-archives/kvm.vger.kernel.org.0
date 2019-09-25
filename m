Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A1D8BE2C2
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2019 18:47:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392055AbfIYQrS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Sep 2019 12:47:18 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:46987 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732903AbfIYQrR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Sep 2019 12:47:17 -0400
Received: by mail-io1-f67.google.com with SMTP id c6so382234ioo.13
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2019 09:47:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=98pgIm93kXtpiVnPdQGl6qYx3mDeiyiIIkaZo8B0nYw=;
        b=WvgZ/tV+qz4PYThIjrZ62TklAy0Nk05OkM+Vs8mBky+mCDHKn5Q/ZucHDd4zO+3dIZ
         eBUQoXg37LJOhxhC4UjoxsVO6yQffKbKEyk3BnEILbf13f/ogVpcNTTw7f6pNGRSMlEy
         1wEaLrRPMEjkGgblfRCKEzlpYD0Y/yCcrb8au+B1hdjjcX6Ze7Bi0kbkXI7nbwEYyqYc
         K63QGHh+/ko2XSFNZl8hmUxgaHkPdh0zAkGs5u2xO+r6JoceDJFy4zLPu5yStHVZcByj
         ISD23aAxzowf3CpOvB2pXbDJ4ZrJD6zsVkrI7V4yjuwpzgTv5LeveW2S9XGiX85/iw8u
         OutQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=98pgIm93kXtpiVnPdQGl6qYx3mDeiyiIIkaZo8B0nYw=;
        b=P48cEiC3ABbuF2q3VHzy1z7F8ac6HWPQCQaqguI145aK+f0bLOWXN5x9xJIBpFJs2S
         re8LJ5Bv9m6QiQ0iKH69H7UKU3EB4qxjvzKXS5tLiRe3DFYoYqE7hM2bQi2IJ35W4Y9N
         OLSZgnRjnG3ndy+lO5DDWzbPLe97AFZhkk0LQoNuZ7SArtNiSBEq8IICjxspAZsR1KC0
         6wlt4+3s36h4HM5QTq+yIGtY12ZXzbWNYxfu8po/AP3qGKVTFuqNJdObPp0XaoYDNZgu
         B6oqe4Ks8nNlPDuLAnE1jMsjAMhUGllpEPOsVFG5gtlKgZJpZ1lEzi+fibufHCxPkBr4
         xXyw==
X-Gm-Message-State: APjAAAXcYjOe3VSt2R8gilPhSMlXxZRUyoAUuGJmG8QckM2gLWKq5IeR
        2usqbHKL22gBmGRetIcEgV0j2acuu4FK6woLdicQgw==
X-Google-Smtp-Source: APXvYqzgqoO4yNpM6KKRUPIwFWPS2tgkT3U1hiQzPm9HsQ1SWUWqLYv+twNVVs76Tlmo5v+6nFST3fkvTU0jUl+S5XQ=
X-Received: by 2002:a6b:6a01:: with SMTP id x1mr273843iog.119.1569430036059;
 Wed, 25 Sep 2019 09:47:16 -0700 (PDT)
MIME-Version: 1.0
References: <1569429286-35157-1-git-send-email-pbonzini@redhat.com>
In-Reply-To: <1569429286-35157-1-git-send-email-pbonzini@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 25 Sep 2019 09:47:05 -0700
Message-ID: <CALMp9eTBPTnsRDipdGDgmugWgfFEjQ2wd_9-JY0ZeM9YG2fBjg@mail.gmail.com>
Subject: Re: [PATCH] KVM: nVMX: cleanup and fix host 64-bit mode checks
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 25, 2019 at 9:34 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> KVM was incorrectly checking vmcs12->host_ia32_efer even if the "load
> IA32_EFER" exit control was reset.  Also, some checks were not using
> the new CC macro for tracing.
>
> Cleanup everything so that the vCPU's 64-bit mode is determined
> directly from EFER_LMA and the VMCS checks are based on that, which
> matches section 26.2.4 of the SDM.
>
> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> Cc: Jim Mattson <jmattson@google.com>
> Cc: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> Fixes: 5845038c111db27902bc220a4f70070fe945871c
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 53 ++++++++++++++++++++---------------------------
>  1 file changed, 22 insertions(+), 31 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 70d59d9304f2..e108847f6cf8 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -2664,8 +2664,26 @@ static int nested_vmx_check_host_state(struct kvm_vcpu *vcpu,
>             CC(!kvm_pat_valid(vmcs12->host_ia32_pat)))
>                 return -EINVAL;
>
> -       ia32e = (vmcs12->vm_exit_controls &
> -                VM_EXIT_HOST_ADDR_SPACE_SIZE) != 0;
> +#ifdef CONFIG_X86_64
> +       ia32e = !!(vcpu->arch.efer & EFER_LMA);
> +#else
> +       if (CC(vmcs12->vm_entry_controls & VM_ENTRY_IA32E_MODE))
> +               return -EINVAL;

This check is redundant, since it is checked in the else block below.

> +
> +       ia32e = false;
> +#endif
> +
> +       if (ia32e) {
> +               if (CC(!(vmcs12->vm_exit_controls & VM_EXIT_HOST_ADDR_SPACE_SIZE)) ||
> +                   CC(!(vmcs12->host_cr4 & X86_CR4_PAE)))
> +                       return -EINVAL;
> +       } else {
> +               if (CC(vmcs12->vm_exit_controls & VM_EXIT_HOST_ADDR_SPACE_SIZE) ||
> +                   CC(vmcs12->vm_entry_controls & VM_ENTRY_IA32E_MODE) ||
> +                   CC(vmcs12->host_cr4 & X86_CR4_PCIDE) ||
> +                   CC(((vmcs12->host_rip) >> 32) & 0xffffffff))

The mask shouldn't be necessary.

> +                       return -EINVAL;
> +       }
>
>         if (CC(vmcs12->host_cs_selector & (SEGMENT_RPL_MASK | SEGMENT_TI_MASK)) ||
>             CC(vmcs12->host_ss_selector & (SEGMENT_RPL_MASK | SEGMENT_TI_MASK)) ||
> @@ -2684,35 +2702,8 @@ static int nested_vmx_check_host_state(struct kvm_vcpu *vcpu,
>             CC(is_noncanonical_address(vmcs12->host_gs_base, vcpu)) ||
>             CC(is_noncanonical_address(vmcs12->host_gdtr_base, vcpu)) ||
>             CC(is_noncanonical_address(vmcs12->host_idtr_base, vcpu)) ||
> -           CC(is_noncanonical_address(vmcs12->host_tr_base, vcpu)))
> -               return -EINVAL;
> -
> -       if (!(vmcs12->host_ia32_efer & EFER_LMA) &&
> -           ((vmcs12->vm_entry_controls & VM_ENTRY_IA32E_MODE) ||
> -           (vmcs12->vm_exit_controls & VM_EXIT_HOST_ADDR_SPACE_SIZE))) {
> -               return -EINVAL;
> -       }
> -
> -       if ((vmcs12->host_ia32_efer & EFER_LMA) &&
> -           !(vmcs12->vm_exit_controls & VM_EXIT_HOST_ADDR_SPACE_SIZE)) {
> -               return -EINVAL;
> -       }
> -
> -       if (!(vmcs12->vm_exit_controls & VM_EXIT_HOST_ADDR_SPACE_SIZE) &&
> -           ((vmcs12->vm_entry_controls & VM_ENTRY_IA32E_MODE) ||
> -           (vmcs12->host_cr4 & X86_CR4_PCIDE) ||
> -           (((vmcs12->host_rip) >> 32) & 0xffffffff))) {
> -               return -EINVAL;
> -       }
> -
> -       if ((vmcs12->vm_exit_controls & VM_EXIT_HOST_ADDR_SPACE_SIZE) &&
> -           ((!(vmcs12->host_cr4 & X86_CR4_PAE)) ||
> -           (is_noncanonical_address(vmcs12->host_rip, vcpu)))) {
> -               return -EINVAL;
> -       }
> -#else
> -       if (vmcs12->vm_entry_controls & VM_ENTRY_IA32E_MODE ||
> -           vmcs12->vm_exit_controls & VM_EXIT_HOST_ADDR_SPACE_SIZE)
> +           CC(is_noncanonical_address(vmcs12->host_tr_base, vcpu)) ||
> +           CC(is_noncanonical_address(vmcs12->host_rip, vcpu)))
>                 return -EINVAL;
>  #endif
>
> --
> 1.8.3.1
>
Reviewed-by: Jim Mattson <jmattson@google.com>
