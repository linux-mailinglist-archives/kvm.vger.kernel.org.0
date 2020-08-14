Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B78BD244B78
	for <lists+kvm@lfdr.de>; Fri, 14 Aug 2020 16:56:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727074AbgHNO4s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Aug 2020 10:56:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726283AbgHNO4r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Aug 2020 10:56:47 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC6D5C061384
        for <kvm@vger.kernel.org>; Fri, 14 Aug 2020 07:56:46 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id g6so10193943ljn.11
        for <kvm@vger.kernel.org>; Fri, 14 Aug 2020 07:56:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OgA6SrPAUjCdolRY2JhUIZZhYF8rz+ttqIgta94WnP8=;
        b=mQYTdoPehrn+9H87tyrSXLEVW+1LEUedGw19sOGac8Oukbb5Ot79FqlCypTW0wpJN6
         lFsplqEV0m7bXoaUJIqMwivrRJr2aMmkN3HWsh//qMAT5lckRNessDPsi9XnYA204/lH
         cZZR5g/SQbDnl1oXMk0+Z2zihnv0Lc8PS7gFFiwjac34EO/0sJtJRSjUtjWKcnSlWpdB
         pc5hhjdzi3ldDJ5HAm8Y5VnjjOLZKU1E2zVeLfCZ5fi8K92t0+t/nt4/HcEa72oLbVD4
         p5poczeDrm3WqnqTfZrZpx8F2MnuEUpXP5r2EagA+iZZ/rL+F2k62tDVOc2mW5ZWpo38
         j+aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OgA6SrPAUjCdolRY2JhUIZZhYF8rz+ttqIgta94WnP8=;
        b=h9rDZgOV/A0UgCBOSMkQxZV6s+n3orjk8ZOCo8Z3TfvkcGpElokc7FbKmwECQkaL9R
         aA2jTEP7vuIChJ/UUxhU97eBb6LtZgReET8QdV+5q6+Xi2SJfS6CqqDkJ5rddv+z8Ddz
         bPzaLu0L6i6+MSmKmUgMiB8kJ18p4A6eiGBc8hRcEefGgTc6arx1/hbfSYvrxzFfPlZD
         kDcPMEp7kU8YuN5PThGlNyJlIEsKSqaDFA5oyUkUsg7NqYRx5hhwjQ2yI1sP7Dqvq3WP
         6Jqqw+ivlSl76gRtRsk9I2HDrvTaAHTgPEXSB/VV+LeSWDUceZYQRz1NEzuz78UXQiBs
         t24A==
X-Gm-Message-State: AOAM533sd5kQ5eYsquLO1/Y2IKyScvSnlzXDbs4RGZ3GOxxRtKd+14Kh
        BJ0XehFvLZLYF5llLQWCoRJpLzakSL6Ul1VMv/XgZ5j/OmY=
X-Google-Smtp-Source: ABdhPJwyK62wMUx7kfHCUx6DoBqGFw4lcayMuTkCGwVyvDDoQ+gJPoYnCWrUHUPERodp9xG4uUN9XQ/7G/ka5s8/YAc=
X-Received: by 2002:a2e:4c02:: with SMTP id z2mr1523264lja.177.1597417004725;
 Fri, 14 Aug 2020 07:56:44 -0700 (PDT)
MIME-Version: 1.0
References: <20200616224305.44242-1-oupton@google.com> <20200813170331.GI29439@linux.intel.com>
 <CAOQ_QsiVV7Btj5yJ5Dpqxf3V7OuHY3N9b1xW6rrZjyv6dOC8ig@mail.gmail.com> <20200813235940.GA4327@linux.intel.com>
In-Reply-To: <20200813235940.GA4327@linux.intel.com>
From:   Oliver Upton <oupton@google.com>
Date:   Fri, 14 Aug 2020 09:56:33 -0500
Message-ID: <CAOQ_Qsj2jw+tGkJkRdaQXPrSKhzu-b=SPneBToCz2DrMM3ZYOg@mail.gmail.com>
Subject: Re: [PATCH] kvm: nVMX: flush TLB when decoded insn != VM-exit reason
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 13, 2020 at 6:59 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Thu, Aug 13, 2020 at 03:44:08PM -0500, Oliver Upton wrote:
> > On Thu, Aug 13, 2020 at 12:03 PM Sean Christopherson
> > > > +      *
> > > > +      * Rather than synthesizing a VM-exit into L1 for every possible
> > > > +      * instruction just flush the TLB, resume L2, and let hardware generate
> > > > +      * the appropriate VM-exit.
> > > > +      */
> > > > +     vmx_flush_tlb_gva(vcpu, kvm_rip_read(vcpu));
> > >
> > > This is wrong, it should flush kvm_get_linear_rip(vcpu).
> > >
> >
> > I do not believe that the aim of this patch will work anymore, since:
> >
> > 1dbf5d68af6f ("KVM: VMX: Add guest physical address check in EPT
> > violation and misconfig")
> >
> > Since it is possible to get into the emulator on any instruction that
> > induces an EPT violation, we'd wind up looping when we believe the
> > instruction needs to exit to L1 (TLB flush, resume guest, hit the same
> > EPT violation. Rinse, wash, repeat).
>
> kvm_get_linear_rip() doesn't walk any page tables, it simply accounts for a
> non-zero CS.base when !64-bit mode.  If we really wanted to, this could use
> the emulation context's cached _eip, but I don't see any value in that since
> both GUEST_CS_* and GUEST_RIP will already be cached by KVM.
>
> unsigned long kvm_get_linear_rip(struct kvm_vcpu *vcpu)
> {
>         if (is_64_bit_mode(vcpu))
>                 return kvm_rip_read(vcpu);
>         return (u32)(get_segment_base(vcpu, VCPU_SREG_CS) +
>                      kvm_rip_read(vcpu));
> }

Sorry, I was a tad imprecise. I haven't any issues with your
suggestion. Rather, I believe that my overall patch is ineffective.

Suppose we had an EPT violation for a GPA that exceeded the guest's
MAXPHYADDR. Let's also say that the EPT violation occurred on the
memory operand of an LMSW instruction. Per the aforementioned patch,
we will dive into the emulator. Since we check intercepts before
reading the operand out of memory, we will fall through to the default
case, set intercepted = true, flush TLB and resume.

>
>
>
> >
> > > > +     return X86EMUL_RETRY_INSTR;
> > > >  }
> > > >
> > > >  #ifdef CONFIG_X86_64
> > > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > > index 00c88c2f34e4..2ab47485100f 100644
> > > > --- a/arch/x86/kvm/x86.c
> > > > +++ b/arch/x86/kvm/x86.c
> > > > @@ -6967,7 +6967,7 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
> > > >
> > > >       r = x86_emulate_insn(ctxt);
> > > >
> > > > -     if (r == EMULATION_INTERCEPTED)
> > > > +     if (r == EMULATION_INTERCEPTED || r == EMULATION_RETRY_INSTR)
> > > >               return 1;
> > > >
> > > >       if (r == EMULATION_FAILED) {
> > > > --
> > > > 2.27.0.290.gba653c62da-goog
> > > >
