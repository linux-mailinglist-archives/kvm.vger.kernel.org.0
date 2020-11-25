Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C82E2C49CD
	for <lists+kvm@lfdr.de>; Wed, 25 Nov 2020 22:20:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731796AbgKYVUB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Nov 2020 16:20:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730963AbgKYVUA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Nov 2020 16:20:00 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A18DFC0613D4
        for <kvm@vger.kernel.org>; Wed, 25 Nov 2020 13:20:00 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id f17so3521797pge.6
        for <kvm@vger.kernel.org>; Wed, 25 Nov 2020 13:20:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wcfES9Su8JUauLU/h9NFhB1fFwIuNdSZoQlbixlbGoE=;
        b=lL1SIvjT+CJoYJfkl4HF5owbUtHjhzYnI5AHicIr5DPURtRLgqB8xRcZQpiHG/eZa6
         Gq73xcI/0TlTeTHs/O39S4iQxun6twys5cOGDphgMOalq104LuMphN9jflgymWOxV4pn
         fQJiAodtRZTL11mEdSbvuH7zKdr0Gf5/ts0dHsWbPE7cjZerElFiNbybPmwkIFsyLUjl
         1pOzAGlqhxA6kVm+x9/TN47bYKKOo2FTc3bjB8h/XUzpCGPEDRWlwo7oYBAJPJ85aogA
         LS1/AflUGlN2T1tLntn/xIsXhP/NHSzWqYbapmdGNyZwH51gdcSGYtHcAOKmnFIUfje6
         w4zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wcfES9Su8JUauLU/h9NFhB1fFwIuNdSZoQlbixlbGoE=;
        b=ghWNcki4SKCWkUmd8YR7nVFe9NC+WWpXponYfsN1cbBqva7nv7I9xV5j+pSTqOJhrw
         amfR4f7JIktl5cG0+2+/Zxxhh4nYE1ZrfKp1W3fOYI7RQKsaaTs5HAzA+DhVgM+alX6a
         83GhnuuwKKcowlSXhXQS7T1yPBBFj0uijuwIYigsoPxmLl01HinUsaWHnqz58Lmh2Ns9
         r9ILtKK5zSHO584XmmHmAQ4vzlYJNlwb8JDY0QRUV3NPfpFEqnn8M5NeLZu1M9SlMiZD
         hnTloLU/Q9iIintNj2y9ZWCaVw0AkdWgtnAaDIPmZ3B9hhFyqFfWNXEc9epxnPotaBYy
         NA9Q==
X-Gm-Message-State: AOAM532fqBvhSjc0bVtD08iVOmXXAxbkAi7st0GYNAhxUKEubMJUp8Jg
        0rGEfo/QXppla8qQBmpXAAxQNA==
X-Google-Smtp-Source: ABdhPJwkc/3c5wXC+GiwQYPCkaDDkKn3t/C/48YgnfYR0WdRMCrBQJiXy4ZrDlg075b3N+Wrr7oyxQ==
X-Received: by 2002:a17:90b:a54:: with SMTP id gw20mr6630941pjb.68.1606339200048;
        Wed, 25 Nov 2020 13:20:00 -0800 (PST)
Received: from google.com (242.67.247.35.bc.googleusercontent.com. [35.247.67.242])
        by smtp.gmail.com with ESMTPSA id z22sm2831867pfa.220.2020.11.25.13.19.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2020 13:19:59 -0800 (PST)
Date:   Wed, 25 Nov 2020 21:19:55 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     kvm <kvm@vger.kernel.org>, "Sironi, Filippo" <sironi@amazon.de>,
        "Raslan, KarimAllah" <karahmed@amazon.de>,
        Matt Gingell <gingell@google.com>,
        Steve Rutherford <srutherford@google.com>, liran@amazon.com
Subject: Re: [RFC PATCH] Fix split-irqchip vs interrupt injection window
 request.
Message-ID: <20201125211955.GA450871@google.com>
References: <62918f65ec78f8990278a6a0db0567968fa23e49.camel@infradead.org>
 <017de9019136b5d2ec34132b96b9f0273c21d6f1.camel@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <017de9019136b5d2ec34132b96b9f0273c21d6f1.camel@infradead.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 25, 2020, David Woodhouse wrote:
> On Thu, 2020-11-12 at 13:03 +0000, David Woodhouse wrote:
> > I'm using nested VMX for testing, while I add split-irqchip support to
> > my VMM. I see the vCPU lock up when attempting to deliver an interrupt.
> 
> Turns out I don't need nesting or my own VMM to reproduce this; all I
> need to do is boot a guest in qemu with split-irqchip and 'noapic' on
> the guest command line. It locks up before getting to a login prompt,
> every time.
> 
> qemu-system-x86_64 -serial mon:stdio -machine q35,accel=kvm,kernel-irqchip=split -m 2G -display none -drive file=foo.qcow2,if=virtio
> 
> Commit 782d422bc ("KVM: x86: split kvm_vcpu_ready_for_interrupt_injection
> out of dm_request_for_irq_injection") made dm_request_for_irq_injection()
> return true even when kvm_cpu_has_interrupt() is true.
> 
> So we enable the vmexit on interrupt window because userspace asked for
> it, but then kvm_vcpu_ready_for_interrupt_injection() returns false,
> causing us *not* to exit all the way to userspace but just to loop in
> vcpu_run() instead.
> 
> But we *didn't* have an injectable interrupt from the kernel, so we
> just go straight back into the guest, vmexit again, loop again, ad
> infinitum.
> 
> This appears to fix it:
> 
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4028,7 +4028,7 @@ static int kvm_cpu_accept_dm_intr(struct kvm_vcpu *vcpu)
>  static int kvm_vcpu_ready_for_interrupt_injection(struct kvm_vcpu *vcpu)
>  {
>         return kvm_arch_interrupt_allowed(vcpu) &&
> -               !kvm_cpu_has_interrupt(vcpu) &&
> +               !kvm_cpu_has_injectable_intr(vcpu) &&

Interrupt window exiting explicitly has priority over virtual interrupt delivery,
so this is correct from that perspective.

But I wonder if would make sense to be more precise so that KVM behavior is
consistent for APICv and legacy IRQ injection.  If the LAPIC is in-kernel,
KVM_INTERRUPT can only be used for EXTINT; whether or not there's an IRQ in the
LAPIC should be irrelevant when deciding to exit to userspace.  Note, the
reinjection check covers vcpu->arch.interrupt.injected for the case where LAPIC
is in userspace.

	return kvm_arch_interrupt_allowed(vcpu) &&
	       (!lapic_in_kernel(vcpu) || !kvm_cpu_has_extint(vcpu)) &&
	       !kvm_event_needs_reinjection(vcpu) &&
	       kvm_cpu_accept_dm_intr(vcpu);
}

>                 !kvm_event_needs_reinjection(vcpu) &&
>                 kvm_cpu_accept_dm_intr(vcpu);
>  }
> 


