Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FC2642784B
	for <lists+kvm@lfdr.de>; Sat,  9 Oct 2021 11:09:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244330AbhJIJLt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 9 Oct 2021 05:11:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244391AbhJIJLs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 9 Oct 2021 05:11:48 -0400
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2742EC061570;
        Sat,  9 Oct 2021 02:09:52 -0700 (PDT)
Received: by mail-oi1-x233.google.com with SMTP id o4so16923978oia.10;
        Sat, 09 Oct 2021 02:09:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AWlcECk9c8kTLFlOaur0Gv/up7C1gqtDcFwTvhK0BeA=;
        b=KwAoNEoTFSpQKQOOFUHUWTkAupifyh7qUracxaMSYWXDUXSqYgPWEoQPBQX8tZAxQs
         esUitSL1AtnlTcDoIDAb02RgcJz7R87UvUoaJsQi4Rq01BxC0/5bSahrc/Cpt0RPzD1H
         eg+G1ixQI/sfJNPbt7dIK7F0EygOCPKY+NOgJ7KwJpJtxf6p0d6zvXELxlBRNiEqDLqP
         4MjsTXbnaR+LNOO3c7/EX/pHYvWmbIcZ04+/c0yqLABZcFEycUoK6G2t8e/9HrhkqOO7
         iilKGZtMlcN3Q7SXv2s6vLQRYmiWGLAP+ovj+D07FmiTULjIzxCR/fhGilxfYtsPOFB5
         Gwvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AWlcECk9c8kTLFlOaur0Gv/up7C1gqtDcFwTvhK0BeA=;
        b=xQnt4bypdIIOn088nchFHqM8oH7a1dowK4Puzb7b/uaa6LJd44eQ8X5G+YC/J6l6H2
         Dgjc5pyyNMtjVrFdP9qcQcbcBeueSn2qY6PC3+lPtN1Kw39PhVv/GnDfskurnC0Ascjr
         UZJY4SRDzkQ8/dEyTdM00J+W93k71yuqJLkTsXOq7P4EgMjNbva1R4NrJgYCcYoWDYxY
         3ZWrgguWUSLQqXUC3Yqrgu+Um1nJ5k1fyc3Xhk3d3UDW8oOG2DTlVGjBbH7toasQ7nMO
         q5VvRysO6afFv18GloIXmBcDzoSYOnX2ylktDP9/DPhjpTEYqSt9BQdsvXnKtBrJzBCl
         9XwQ==
X-Gm-Message-State: AOAM530IM+J5/7Bj0IryDbkO4TSKP/ESGgBv7AuQF+pl3V39vlJrEZ4L
        b30QUJHGvg4C/3GwbnTHO37+uUvZBMZW8xQGuPPR/Sbd3p0=
X-Google-Smtp-Source: ABdhPJy1cTcnxG2cj5lcXuYwRgsCHfdXC2i41qpIW+3g0k40YSdGg/dGvGGn+nl+zoKwgPaPfPK43olDv5Q/kLfitDo=
X-Received: by 2002:a05:6808:1148:: with SMTP id u8mr11082381oiu.33.1633770591589;
 Sat, 09 Oct 2021 02:09:51 -0700 (PDT)
MIME-Version: 1.0
References: <1633687054-18865-1-git-send-email-wanpengli@tencent.com> <YWBhpzsBxe16z+L1@google.com>
In-Reply-To: <YWBhpzsBxe16z+L1@google.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Sat, 9 Oct 2021 17:09:40 +0800
Message-ID: <CANRm+CxCLjts0EPORmQvkiggujN_bRf_rL0LvVq8homLoVS6Og@mail.gmail.com>
Subject: Re: [PATCH 1/3] KVM: emulate: #GP when emulating rdpmc if CR0.PE is 1
To:     Sean Christopherson <seanjc@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 8 Oct 2021 at 23:20, Sean Christopherson <seanjc@google.com> wrote:
>
> The shortlog makes it sound like "inject a #GP if CR0.PE=1", i.e. unconditionally
> inject #GP for RDMPC in protected mode.  Maybe "Don't inject #GP when emulating
> RDMPC if CR0.PE=0"?
>

Agreed.

> On Fri, Oct 08, 2021, Wanpeng Li wrote:
> > From: Wanpeng Li <wanpengli@tencent.com>
> >
> > SDM mentioned that, RDPMC:
> >
> >   IF (((CR4.PCE = 1) or (CPL = 0) or (CR0.PE = 0)) and (ECX indicates a supported counter))
> >       THEN
> >           EAX := counter[31:0];
> >           EDX := ZeroExtend(counter[MSCB:32]);
> >       ELSE (* ECX is not valid or CR4.PCE is 0 and CPL is 1, 2, or 3 and CR0.PE is 1 *)
> >           #GP(0);
> >   FI;
> >
> > Let's add the CR0.PE is 1 checking to rdpmc emulate.
> >
> > Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> > ---
> >  arch/x86/kvm/emulate.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> > index 9a144ca8e146..ab7ec569e8c9 100644
> > --- a/arch/x86/kvm/emulate.c
> > +++ b/arch/x86/kvm/emulate.c
> > @@ -4213,6 +4213,7 @@ static int check_rdtsc(struct x86_emulate_ctxt *ctxt)
> >  static int check_rdpmc(struct x86_emulate_ctxt *ctxt)
> >  {
> >       u64 cr4 = ctxt->ops->get_cr(ctxt, 4);
> > +     u64 cr0 = ctxt->ops->get_cr(ctxt, 0);
> >       u64 rcx = reg_read(ctxt, VCPU_REGS_RCX);
> >
> >       /*
> > @@ -4222,7 +4223,7 @@ static int check_rdpmc(struct x86_emulate_ctxt *ctxt)
> >       if (enable_vmware_backdoor && is_vmware_backdoor_pmc(rcx))
> >               return X86EMUL_CONTINUE;
> >
> > -     if ((!(cr4 & X86_CR4_PCE) && ctxt->ops->cpl(ctxt)) ||
> > +     if ((!(cr4 & X86_CR4_PCE) && ctxt->ops->cpl(ctxt) && (cr0 & X86_CR0_PE)) ||
>
> I don't think it's possible for CPL to be >0 if CR0.PE=0, e.g. we could probably
> WARN in the #GP path.  Realistically it doesn't add value though, so maybe just
> add a blurb in the changelog saying this isn't strictly necessary?

Do it in v2.

    Wanpeng
