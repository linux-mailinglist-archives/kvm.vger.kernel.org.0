Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6985444198B
	for <lists+kvm@lfdr.de>; Mon,  1 Nov 2021 11:11:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231958AbhKAKNy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Nov 2021 06:13:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232033AbhKAKNq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Nov 2021 06:13:46 -0400
Received: from mail-qv1-xf2c.google.com (mail-qv1-xf2c.google.com [IPv6:2607:f8b0:4864:20::f2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E42F8C0AD966;
        Mon,  1 Nov 2021 02:59:32 -0700 (PDT)
Received: by mail-qv1-xf2c.google.com with SMTP id u16so5915579qvk.4;
        Mon, 01 Nov 2021 02:59:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VS7xJMRLEAL/z5kz7yD3xJ47ipMOu90IemHH26nIVUY=;
        b=AMnc2V3FeRvAHE1sXug/y3TVGW+ng4/ccaXU1y+d//FhTFw4R4bAg064Glq8DUXAVS
         kgnHovH7AVK0OPQWAmoo+I24C15PJ2xDJQJ+zx2G7W/kKi3/csAhAxAExB734InCWtYh
         RCBuryAbUUQAkctLty+juaqhNl0LltEdF6ZvwH4fi6R14d5lVawLG2HycPULP4G8oegd
         NbNAQMNMhy6ET0g6BtLSqfCrS3imr8KL9pl3LcbgfgYW0hhlEek8aDSC+JElDwXRshnz
         dsphikNkhPTnBYtAPn2ad8E88f8znAbAvufHY0wb3R79cJe8pK3YVe2jN09q4/K6hhYw
         bG4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VS7xJMRLEAL/z5kz7yD3xJ47ipMOu90IemHH26nIVUY=;
        b=IDIRCaAqA5dngel6jeQmwm7qw8aU0c71WpfpBdoTPhyJwTC/SBKDFNAYjYnPAUlzxM
         /w3Sad17Lw0vP6XxRFkt8tnFIBBjSULLqr0oCwNRDKtwxHGbb71P3RfwwCN6urHJGnoM
         cu2fUSHPjOom4rgjXzJxhiLbVAA9KjD9rtNmn66NFPvuU9eqbigL5mp3+LhUu0xMsUBm
         0ieLvmiz/9qWGZ4RK+A/Oazj4UAx6qEIuWGgE/ZR8gTpfym0kho7r+Ng3sdD91PXxom8
         Lw18c+24TCLHL6cvlvAIsxOwDNmdYdg8p3wK9q5RstYbmlbZMZPWWGrB2XRNKbj8rjod
         AtbA==
X-Gm-Message-State: AOAM531Sc7puLAnLcWHEzAw3iI393fhE91A1VD2dlRyJzQx5dRJauDW9
        6nHjn0wGWA8NjZPjaAwK4qFrRiLuJVWXf1iTFTSbIv+icK95OQ==
X-Google-Smtp-Source: ABdhPJz2RLiJ6mLI2Nb7FeGOZsb0DYXITQY3rtfOBL0M2GhDQGAU7koJvbix0AUEpfeTTrU9siESGfSGtOAuTGvKk3M=
X-Received: by 2002:a0c:c784:: with SMTP id k4mr27185381qvj.43.1635760772105;
 Mon, 01 Nov 2021 02:59:32 -0700 (PDT)
MIME-Version: 1.0
References: <20210917135152.5111-1-ubizjak@gmail.com> <YWcyeGk7vOSoQWW4@google.com>
In-Reply-To: <YWcyeGk7vOSoQWW4@google.com>
From:   Uros Bizjak <ubizjak@gmail.com>
Date:   Mon, 1 Nov 2021 10:59:20 +0100
Message-ID: <CAFULd4YxctGCbLFSJrr4WK1wS4c_-QwkCQ4V77=8_B0URSeFow@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: Improve exception safe wrappers in emulate.c
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 13, 2021 at 9:24 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Fri, Sep 17, 2021, Uros Bizjak wrote:
> > Improve exception safe wrappers in emulate.c by converting them to
> > ASM GOTO (and ASM GOTO OUTPUT when supported) statements.  Also, convert
> > wrappers to inline functions to avoid statement as expression
> > GNU extension and to remove weird requirement where user must know
> > where the asm argument is being expanded.
> >
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Cc: Sean Christopherson  <seanjc@google.com>
> > Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
> > ---
> >  arch/x86/kvm/emulate.c | 80 ++++++++++++++++++++++++++++++------------
> >  1 file changed, 57 insertions(+), 23 deletions(-)
> >
> > diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> > index 2837110e66ed..2197a3ecc55b 100644
> > --- a/arch/x86/kvm/emulate.c
> > +++ b/arch/x86/kvm/emulate.c
> > @@ -464,25 +464,59 @@ FOP_FUNC(salc)
> >  FOP_RET(salc)
> >  FOP_END;
> >
> > -/*
> > - * XXX: inoutclob user must know where the argument is being expanded.
>
> I 100% agree that this is a weird requirement, but I actually like the side
> effect of forcing the caller to define a name for the input/output.
>
> > - *      Relying on CONFIG_CC_HAS_ASM_GOTO would allow us to remove _fault.
> > - */
> > -#define asm_safe(insn, inoutclob...) \
> > -({ \
> > -     int _fault = 0; \
> > - \
> > -     asm volatile("1:" insn "\n" \
> > -                  "2:\n" \
> > -                  ".pushsection .fixup, \"ax\"\n" \
> > -                  "3: movl $1, %[_fault]\n" \
> > -                  "   jmp  2b\n" \
> > -                  ".popsection\n" \
> > -                  _ASM_EXTABLE(1b, 3b) \
> > -                  : [_fault] "+qm"(_fault) inoutclob ); \
> > - \
> > -     _fault ? X86EMUL_UNHANDLEABLE : X86EMUL_CONTINUE; \
> > -})
> > +static __always_inline int safe_fwait(void)
> > +{
> > +     asm_volatile_goto("1: fwait\n\t"
> > +                       _ASM_EXTABLE(1b, %l[fault])
> > +                       : : : : fault);
> > +     return X86EMUL_CONTINUE;
> > + fault:
> > +     return X86EMUL_UNHANDLEABLE;
> > +}
>
> Rather than defining a bunch of safe_() variants, what about providing a generic
> helper/macro similar to the existing asm_safe()?  Not just for KVM, but for the
> kernel at large.  Asm with output is problematic due to the CONFIG_CC_HAS_ASM_GOTO
> dependency, but it wouldn't be the end of the world to state that simply isn't
> supported until the min compiler version is raised.
>
> __wrmsr(), native_write_msr_safe(), cpu_vmxoff(), kvm_cpu_vmxon(), and probably
> others could use a generic generic asm_safe().  I wouldn't be surprised if there
> are other places in the kernel that could take advantage of such a helper, e.g.
> kvm_load_ldt() could use a "safe" variant instead of crashing if the sel is bad.

After 5.16 x86 FPU handling rewrite, kernel_insn_err and even
fxrstor_safe are now in fpu/legacy.h. Is there a way to share these
with KVM?

Uros.
