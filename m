Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3C4842986C
	for <lists+kvm@lfdr.de>; Mon, 11 Oct 2021 22:51:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235087AbhJKUxd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Oct 2021 16:53:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234728AbhJKUxc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Oct 2021 16:53:32 -0400
Received: from mail-oo1-xc31.google.com (mail-oo1-xc31.google.com [IPv6:2607:f8b0:4864:20::c31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5361CC06161C
        for <kvm@vger.kernel.org>; Mon, 11 Oct 2021 13:51:32 -0700 (PDT)
Received: by mail-oo1-xc31.google.com with SMTP id w9-20020a4adec9000000b002b696945457so5259569oou.10
        for <kvm@vger.kernel.org>; Mon, 11 Oct 2021 13:51:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Rn09d7caDfoCbeJ1oRsOFnGTsCgujh7Av70+yx/v1WI=;
        b=IhgME2s1Lw/QYpkgDbnn0nQRygV74w2OrP3PH3TYuBCg5K7lDyq+RPZFd5OHiv1V7V
         8AA/50E48T7mbhSgUMuJJoS0KhXDLPE25pT7MaZa0XrNES4VnIrnJkm1PBnZoqN5c5oN
         y7KQsN/gc8JMyXx1PfrSnVTOojAy/Sj8mDvNWSCBYszrVFy51N0aC06AldZ+sp7Z5DyE
         AihXd3C9TVowWnZIZgFSAYYwhxeP9BCj1LkhPnScdFS++vXtYNzuym4C2zCr0ofa6+M9
         yRz2bHqAzt+9hpTvtXU9ZmDntB20zhqFBhfbllc6GgUOSv0qPIKJ9ymCZXuMbiqBxxfv
         FrOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Rn09d7caDfoCbeJ1oRsOFnGTsCgujh7Av70+yx/v1WI=;
        b=hspkgaZMccm8Lwv+0CLzTpjgBShaHXqPGTUzGz3QxJ9KoHl8B+3TtRILl2qPG7eZK8
         fAvVqpk4Jnsq9AFJVwYH4BAQRUBfqi5jAfP3YSBFo0O7AXcrJFtkYCbNkdYKSvVGicWL
         deW6gQbOs8QWPPe9TQjCZP+TmwzSfPP6r/MO4w6ja6sDMLkLHJoKsWHRniCUkQh08yZ4
         LS/b4z5jgcV3lQGYmXJA4f2UH+VwoTAmfPs+9fdKGi0d9IRi4pow8g/VmKwqkeNLULcU
         F/jr78EWztQskK4pDEtAQ/zlQVzvutOWPgJKWk/BKbMpkKJ/fqmpeSKuy62wkQyIQLDU
         6VtA==
X-Gm-Message-State: AOAM5315K1ail/AkviUA9Uilwn5xvX/W3q3ILI2BcFRV9Ugi6AZwHJ3v
        EPlmvV5ja47gCfT9nfVQfVyC0qp00+RiFeKyN0FQYA==
X-Google-Smtp-Source: ABdhPJw1SEPgrTzAzcFlHjeqFH5OMD09k/R0xvA4RipgQ0bJP5ZZLoKzkZzlFuqKK6OL8cCzwu0pdBUZIQ7SHYC9q+I=
X-Received: by 2002:a4a:c993:: with SMTP id u19mr2904192ooq.31.1633985491354;
 Mon, 11 Oct 2021 13:51:31 -0700 (PDT)
MIME-Version: 1.0
References: <20211011194615.2955791-1-vipinsh@google.com> <YWSdTpkzNt3nppBc@google.com>
In-Reply-To: <YWSdTpkzNt3nppBc@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 11 Oct 2021 13:51:20 -0700
Message-ID: <CALMp9eRzPXg2WS6-Yy6U90+B8wXm=zhVSkmAym4Y924m7FM-7g@mail.gmail.com>
Subject: Re: [PATCH] KVM: VMX: Add a wrapper for reading INVPCID/INVEPT/INVVPID
 type
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vipin Sharma <vipinsh@google.com>, pbonzini@redhat.com,
        dmatlack@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 11, 2021 at 1:23 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Mon, Oct 11, 2021, Vipin Sharma wrote:
> > Add a common helper function to read invalidation type specified by a
> > trapped INVPCID/INVEPT/INVVPID instruction.
> >
> > Add a symbol constant for max INVPCID type.
> >
> > No functional change intended.
> >
> > Signed-off-by: Vipin Sharma <vipinsh@google.com>
> > ---
> >  arch/x86/include/asm/invpcid.h |  1 +
> >  arch/x86/kvm/vmx/nested.c      |  4 ++--
> >  arch/x86/kvm/vmx/vmx.c         |  4 ++--
> >  arch/x86/kvm/vmx/vmx.h         | 12 ++++++++++++
> >  4 files changed, 17 insertions(+), 4 deletions(-)
> >
> > diff --git a/arch/x86/include/asm/invpcid.h b/arch/x86/include/asm/invpcid.h
> > index 734482afbf81..b5ac26784c1b 100644
> > --- a/arch/x86/include/asm/invpcid.h
> > +++ b/arch/x86/include/asm/invpcid.h
> > @@ -21,6 +21,7 @@ static inline void __invpcid(unsigned long pcid, unsigned long addr,
> >  #define INVPCID_TYPE_SINGLE_CTXT     1
> >  #define INVPCID_TYPE_ALL_INCL_GLOBAL 2
> >  #define INVPCID_TYPE_ALL_NON_GLOBAL  3
> > +#define INVPCID_TYPE_MAX             3
>
> ...
>
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index 1c8b2b6e7ed9..77f72a41dde3 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -5502,9 +5502,9 @@ static int handle_invpcid(struct kvm_vcpu *vcpu)
> >       }
> >
> >       vmx_instruction_info = vmcs_read32(VMX_INSTRUCTION_INFO);
> > -     type = kvm_register_read(vcpu, (vmx_instruction_info >> 28) & 0xf);
> > +     type = vmx_read_invalidation_type(vcpu, vmx_instruction_info);
>
> I would prefer to keep the register read visibile in this code so that it's
> obvious what exactly is being read.  With this approach, it's not clear that KVM
> is reading a GPR vs. VMCS vs. simply extracting "type" from "vmx_instruction_info".
>
> And it's not just the INV* instruction, VMREAD and VMWRITE use the same encoding.
>
> The hardest part is coming up with a name :-)  Maybe do the usually-ill-advised
> approach of following the SDM verbatim?  Reg2 is common to all flavors, so this?
>
>         gpr_index = vmx_get_instr_info_reg2(vmx_instruction_info);
>         type = kvm_register_read(vcpu, gpr_index);
>
> >
> > -     if (type > 3) {
> > +     if (type > INVPCID_TYPE_MAX) {
>
> Hrm, I don't love this because it's not auto-updating in the unlikely chance that
> a new type is added.  I definitely don't like open coding '3' either.  What about
> going with a verbose option of
>
>         if (type != INVPCID_TYPE_INDIV_ADDR &&
>             type != INVPCID_TYPE_SINGLE_CTXT &&
>             type != INVPCID_TYPE_ALL_INCL_GLOBAL &&
>             type != INVPCID_TYPE_ALL_NON_GLOBAL) {
>                 kvm_inject_gp(vcpu, 0);
>                 return 1;
>         }

Better, perhaps, to introduce a new function, valid_invpcid_type(),
and squirrel away the ugliness there?

> It's kind of gross, but gcc10 is smart enought to coalesce those all into a single
> CMP <reg>, 3; JA <#GP>, i.e. the resulting binary is identical.
>
> >               kvm_inject_gp(vcpu, 0);
> >               return 1;
> >       }
> > diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> > index 592217fd7d92..eeafcce57df7 100644
> > --- a/arch/x86/kvm/vmx/vmx.h
> > +++ b/arch/x86/kvm/vmx/vmx.h
> > @@ -522,4 +522,16 @@ static inline bool vmx_guest_state_valid(struct kvm_vcpu *vcpu)
> >
> >  void dump_vmcs(struct kvm_vcpu *vcpu);
> >
> > +/*
> > + * When handling a VM-exit for one of INVPCID, INVEPT or INVVPID, read the type
> > + * of invalidation specified by the instruction.
> > + */
> > +static inline unsigned long vmx_read_invalidation_type(struct kvm_vcpu *vcpu,
> > +                                                    u32 vmx_instr_info)
> > +{
> > +     u32 vmx_instr_reg2 = (vmx_instr_info >> 28) & 0xf;
> > +
> > +     return kvm_register_read(vcpu, vmx_instr_reg2);
> > +}
> > +
> >  #endif /* __KVM_X86_VMX_H */
> > --
> > 2.33.0.882.g93a45727a2-goog
> >
