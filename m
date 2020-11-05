Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A41142A8696
	for <lists+kvm@lfdr.de>; Thu,  5 Nov 2020 19:58:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729783AbgKES6o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Nov 2020 13:58:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726996AbgKES6n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Nov 2020 13:58:43 -0500
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD7D3C0613CF
        for <kvm@vger.kernel.org>; Thu,  5 Nov 2020 10:58:43 -0800 (PST)
Received: by mail-io1-xd43.google.com with SMTP id p7so2875365ioo.6
        for <kvm@vger.kernel.org>; Thu, 05 Nov 2020 10:58:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sUpNCmLEocsd06ea6TUgBYF5Lti0y6kySFHe+L+lO2M=;
        b=ocZ0o2bW/2g+lKR2aAj2qtLyojA9TDvBTA1wO0qu1HGrLT39SlqtLSPOdR4hVOzrpm
         n0RNxB2eejpk2X9jAkNJWHrob0aJbxw33RrZ21z+29/1w/x9wGDq8Bw7NGRaGVQm4xKT
         0qH1D0O+JGiomKFvQ31i9FvsSjFPhG3OQnT6z4s1nk7GJ24wi+Tp6QmZdCq8YFIIyyhW
         a9vWeo/AnwVwB29PJX9zs4CymQiNlAWXQOG0PNEoFThRNvl0lFDQuA7S9HNqtqh/2JEc
         g6bRg7GFjDCrU2dG5ri1uBYwqTCTVb0eaRWVbnE9fETx+QH5sZO8DEsHJE8HvacWRvXY
         vbMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sUpNCmLEocsd06ea6TUgBYF5Lti0y6kySFHe+L+lO2M=;
        b=ZUIP3JUnWm5wLh5Qs1/67eboy6XDFErfGWqMtJ62jIs4Cdx7XF8wWdAtzzpBt0YFSi
         Lrjwr45P8VdxTQPTxODYMHilU66vvHIPgoXC+w6ibMrtHvWx8xWUwFXUymPrjhfuBiFb
         HQ2BFZdLaKVmQr7x33owSpP5s8gecO4ioey04x7/WrV/EmwPCMQwH2eA1T5vCutF1AoD
         qbQed6+azHkW2dr5zIQ1hvWqyIeemmSJNAUhlmlJn8C6ItL3MDGCteATru8lxotzFC+z
         SEnrMlMfFqUoEmcsJPYJVFCdiy1h0qNHd9c1uRFx1tD+jzIGoR3AP+uz4JZQftCqRngj
         Aliw==
X-Gm-Message-State: AOAM531n4RjLUyVJe6uCiXUY6mDpxjtAkOXSPNN+hsT5UiI1rElqvShk
        IbuoYv+65wn4nibHlTs1+1KKtIj12oZA8lXBnFo=
X-Google-Smtp-Source: ABdhPJxCQ3jDAXdKn+XUT4VT9AOWKCxitIeJyRADvNle5a6uYrdM11Gx+rCzpmjvsZE79tgS0pusSQU3vVuWGdpy5as=
X-Received: by 2002:a6b:5f05:: with SMTP id t5mr2892929iob.67.1604602723137;
 Thu, 05 Nov 2020 10:58:43 -0800 (PST)
MIME-Version: 1.0
References: <20201105153932.24316-1-pankaj.gupta.linux@gmail.com> <36be2860-9ef9-db0f-ad8b-1089bd258dbc@redhat.com>
In-Reply-To: <36be2860-9ef9-db0f-ad8b-1089bd258dbc@redhat.com>
From:   Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Date:   Thu, 5 Nov 2020 19:58:31 +0100
Message-ID: <CAM9Jb+igM6Pp=Mx3WAqQJBsVqmVhfaYmkspFvDq1Y93Dihdp8w@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: handle MSR_IA32_DEBUGCTLMSR with report_ignored_msrs
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, oro@8bytes.org,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Pankaj Gupta <pankaj.gupta@cloud.ionos.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> >   Guest tries to enable LBR (last branch/interrupt/exception) repeatedly,
> >   thus spamming the host kernel logs. As MSR_IA32_DEBUGCTLMSR is not emulated by
> >   KVM, its better to add the error log only with "report_ignored_msrs".
> >
> > Signed-off-by: Pankaj Gupta <pankaj.gupta@cloud.ionos.com>
> > ---
> >   arch/x86/kvm/x86.c | 6 +++---
> >   1 file changed, 3 insertions(+), 3 deletions(-)
> >
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index f5ede41bf9e6..99c69ae43c69 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -3063,9 +3063,9 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> >                       /* Values other than LBR and BTF are vendor-specific,
> >                          thus reserved and should throw a #GP */
> >                       return 1;
> > -             }
> > -             vcpu_unimpl(vcpu, "%s: MSR_IA32_DEBUGCTLMSR 0x%llx, nop\n",
> > -                         __func__, data);
> > +             } else if (report_ignored_msrs)
> > +                     vcpu_unimpl(vcpu, "%s: MSR_IA32_DEBUGCTLMSR 0x%llx, nop\n",
> > +                                 __func__, data);
> >               break;
> >       case 0x200 ... 0x2ff:
> >               return kvm_mtrr_set_msr(vcpu, msr, data);
> >
>
> Which guest it is?  (Patch queued, but I'd like to have a better
> description).

How about this?

Windows2016 guest tries to enable LBR (last
branch/interrupt/exception) by setting
MSR_IA32_DEBUGCTLMSR. KVM does not emulate MSR_IA32_DEBUGCTLMSR and
spams the host kernel logs with the below error messages.This patch
fixes this by enabling
error logging only with 'report_ignored_msrs'.

"kvm []: vcpu1, guest rIP: 0xfffff800a8b687d3 kvm_set_msr_common:
MSR_IA32_DEBUGCTLMSR 0x1, nop"

Thanks,
Pankaj






>
> Paolo
>
