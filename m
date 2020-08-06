Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E944D23E386
	for <lists+kvm@lfdr.de>; Thu,  6 Aug 2020 23:32:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726104AbgHFVcr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Aug 2020 17:32:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725947AbgHFVcq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Aug 2020 17:32:46 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 460A9C061574
        for <kvm@vger.kernel.org>; Thu,  6 Aug 2020 14:32:46 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id x24so28920otp.3
        for <kvm@vger.kernel.org>; Thu, 06 Aug 2020 14:32:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bMdUvR5cvJpWBqS4UuMvvAwpXkYNV4aiHJRiohzePLg=;
        b=igUkUtxNZ6QY8ZC0CF73xy8YqEiLjqFpG9/3LS9S27kT9ZRuFxZgQ7Gz02TrcYyeHb
         P7M3oF0HvZj84He4lV1336ZVwTZMWwbSOWdqjsdJcRz7oft8mSVSfC+UfSk+dgDi5sFX
         rpgjLVZ/+elZdeH/FimeO1H1/Zu5CLcwMgxER0IdCDHnlfHVA1z85CN84XEmUHwVTIpp
         8b8ifZ/vNnV5iNVAQvFMgEDLR4mA6j2OKYOk0PSM69IjLpWZIvLCD4Mv6BYMg8qT/S5f
         HXseBtqpzHZUONovVBLxoihOGl0jfHKRFQyuDS2KnMAv6DLy/0fwtCXFRp6I/lHlwPEX
         RhKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bMdUvR5cvJpWBqS4UuMvvAwpXkYNV4aiHJRiohzePLg=;
        b=oGiRpb1D9HzAP8SHX6BcHY3qlReQf9paaf02mNSzfuS1FTaRiYkAbB00+149ntDcSw
         D39cI3tqXSyTp2EWGHrldAiG7LLo9rd/33vHp11NUApqk1NyFB6uum7ib02u1PpfAEY9
         xmnqbTuSU60ir0eO4G2hxqDhXOIEP7dV1pI0ChyY+pnLu34tOfgn2Djt3yHzSZ283pKx
         MBvtBQYTbTsXeRAEu5j2+V26lOg6kxRIyAK4RWBFcMSIeQFYHEIHejEjnWtaHgdEOyYe
         iqn5ENVOzDdMIyEW7VQve6izvmYzLkYN1LQfc1G58l8Tvl592NKHqK2nxAfYuVcmtOWP
         8L6w==
X-Gm-Message-State: AOAM530pW2TNSoY8HqcCVwaXeYh5urfUh9rvdHYk7fr4Jc8gguUibucw
        09LSr+k0JrnnBbgWZxahiqx/z8nc5VmxrWd67GwsDA==
X-Google-Smtp-Source: ABdhPJx/Hxhcn35FYgvdCjsHnqMZ2uPaHzIqV74EY0tHiSr6yJAFi2hvz3eL78Cw58pEOzQveLpUre0/Lum6uk6Kzkk=
X-Received: by 2002:a9d:65ca:: with SMTP id z10mr9442637oth.295.1596749565185;
 Thu, 06 Aug 2020 14:32:45 -0700 (PDT)
MIME-Version: 1.0
References: <20200714015732.32426-1-sean.j.christopherson@intel.com> <084a332afc149c0c647e86f71fea49bb0665a843.camel@redhat.com>
In-Reply-To: <084a332afc149c0c647e86f71fea49bb0665a843.camel@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 6 Aug 2020 14:32:33 -0700
Message-ID: <CALMp9eR94d9Xbt7ZTiaezL3hSuTQTCNX8pxiDFE9tHCpDRjrQg@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: Don't attempt to load PDPTRs when 64-bit mode
 is enabled
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 5, 2020 at 12:04 AM Maxim Levitsky <mlevitsk@redhat.com> wrote:
>
> On Mon, 2020-07-13 at 18:57 -0700, Sean Christopherson wrote:
> > Don't attempt to load PDPTRs if EFER.LME=1, i.e. if 64-bit mode is
> > enabled.  A recent change to reload the PDTPRs when CR0.CD or CR0.NW is
> > toggled botched the EFER.LME handling and sends KVM down the PDTPR path
> > when is_paging() is true, i.e. when the guest toggles CD/NW in 64-bit
> > mode.
> >
> > Split the CR0 checks for 64-bit vs. 32-bit PAE into separate paths.  The
> > 64-bit path is specifically checking state when paging is toggled on,
> > i.e. CR0.PG transititions from 0->1.  The PDPTR path now needs to run if
> > the new CR0 state has paging enabled, irrespective of whether paging was
> > already enabled.  Trying to shave a few cycles to make the PDPTR path an
> > "else if" case is a mess.
> >
> > Fixes: d42e3fae6faed ("kvm: x86: Read PDPTEs on CR0.CD and CR0.NW changes")
> > Cc: Jim Mattson <jmattson@google.com>
> > Cc: Oliver Upton <oupton@google.com>
> > Cc: Peter Shier <pshier@google.com>
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > ---
> >
> > The other way to fix this, with a much smaller diff stat, is to simply
> > move the !is_page(vcpu) check inside (vcpu->arch.efer & EFER_LME).  But
> > that results in a ridiculous amount of nested conditionals for what is a
> > very straightforward check e.g.
> >
> >       if (cr0 & X86_CR0_PG) {
> >               if (vcpu->arch.efer & EFER_LME) }
> >                       if (!is_paging(vcpu)) {
> >                               ...
> >                       }
> >               }
> >       }
> >
> > Since this doesn't need to be backported anywhere, I didn't see any value
> > in having an intermediate step.
> >
> >  arch/x86/kvm/x86.c | 24 ++++++++++++------------
> >  1 file changed, 12 insertions(+), 12 deletions(-)
> >
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 95ef629228691..5f526d94c33f3 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -819,22 +819,22 @@ int kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
> >       if ((cr0 & X86_CR0_PG) && !(cr0 & X86_CR0_PE))
> >               return 1;
> >
> > -     if (cr0 & X86_CR0_PG) {
> >  #ifdef CONFIG_X86_64
> > -             if (!is_paging(vcpu) && (vcpu->arch.efer & EFER_LME)) {
> > -                     int cs_db, cs_l;
> > +     if ((vcpu->arch.efer & EFER_LME) && !is_paging(vcpu) &&
> > +         (cr0 & X86_CR0_PG)) {
> > +             int cs_db, cs_l;
> >
> > -                     if (!is_pae(vcpu))
> > -                             return 1;
> > -                     kvm_x86_ops.get_cs_db_l_bits(vcpu, &cs_db, &cs_l);
> > -                     if (cs_l)
> > -                             return 1;
> > -             } else
> > -#endif
> > -             if (is_pae(vcpu) && ((cr0 ^ old_cr0) & pdptr_bits) &&
> > -                 !load_pdptrs(vcpu, vcpu->arch.walk_mmu, kvm_read_cr3(vcpu)))
> > +             if (!is_pae(vcpu))
> > +                     return 1;
> > +             kvm_x86_ops.get_cs_db_l_bits(vcpu, &cs_db, &cs_l);
> > +             if (cs_l)
> >                       return 1;
> >       }
> > +#endif
> > +     if (!(vcpu->arch.efer & EFER_LME) && (cr0 & X86_CR0_PG) &&
> > +         is_pae(vcpu) && ((cr0 ^ old_cr0) & pdptr_bits) &&
> > +         !load_pdptrs(vcpu, vcpu->arch.walk_mmu, kvm_read_cr3(vcpu)))
> > +             return 1;

It might be worth commenting on the subtlety of the test below being
skipped if the PDPTEs were loaded above. I'm assuming that the PDPTEs
shouldn't be loaded if the instruction faults.

> >       if (!(cr0 & X86_CR0_PG) && kvm_read_cr4_bits(vcpu, X86_CR4_PCIDE))
> >               return 1;
>
> I also investigated this issue (also same thing, OVMF doesn't boot),
> and after looking at the intel and amd's PRM, this looks like correct solution.
> I also tested this and it works.
>
>
> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
>
> Best regards,
>         Maxim Levitsky
>
