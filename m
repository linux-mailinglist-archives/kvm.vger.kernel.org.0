Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A1EE11D33A
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2019 18:11:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730040AbfLLRL0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Dec 2019 12:11:26 -0500
Received: from mail-qv1-f65.google.com ([209.85.219.65]:44900 "EHLO
        mail-qv1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729546AbfLLRL0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Dec 2019 12:11:26 -0500
Received: by mail-qv1-f65.google.com with SMTP id n8so1225196qvg.11
        for <kvm@vger.kernel.org>; Thu, 12 Dec 2019 09:11:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=O8i/P7PW2Hmf7if5w9WzMo01jNRINdPJBRjB9gK59EQ=;
        b=KwSUHEkKFnQJl6ziISrvsigGagqLvOmVERDG6DUYWMqZR+pR+SlGTc4CfEoM4oKLga
         5znnUebLqUXbHjT5ebLhMIGPf5Rq4o1M2fI9H1eLh0llknAWtN2bOGIfcD9HkfGQTw/K
         It0FKvAouyzEKkl6ZmqP+ELrCB69SXBTK+T5sYtzPxGwIBPt9EH71nss5ZPd7+UwtSNG
         1IpNsZnrk4f1B2KtLPOKkILRTAVLpOdV8vs8pYsGYJQ3aR1nHpiYppyu45qEfGZ83hxW
         M5QI2jQ3BhnLPS8nbx/NTKSKXakHPBAzSXWBqdjrhlW581Rdw0rvowt/bvyC7HHQz9zA
         BFKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=O8i/P7PW2Hmf7if5w9WzMo01jNRINdPJBRjB9gK59EQ=;
        b=CIGSnmolAPazFYN8Z3tdFVPJGGMVojxX/LbpSpivAU/VTWJUlkLNxekfNctgUZftzR
         B3yMuRN23q2zfSUeHa3lPsqUY5EiOS1gWvLb8+vYb68XjNJUxMn/HYCW3muu0Y8JRi6A
         wJd8gBITb/mBe0Ifw85LrCwXeGA45Szyp6TOum4yWmKsAoEtzPD6svxRAsulv1I0IiXr
         mJox+XV9g23WVciNIZIOA0qGmPcICbkhUbwMNC1TbsahsCZh7W9WehzTgp/AsAkBdfB2
         Ia09rNtlNUzkNW6FhbdBDhUhoY0N2JUCbmjIadZKGpzTGW5fopln59EUxqy+foogcK4/
         MhOA==
X-Gm-Message-State: APjAAAUNu31GW+Nb9mnu9BcKzj19ZLK9wFlxPuhSY7rrLI9qihWzHYS8
        WoXMblxJs27ofMry66PrusstIDqLrAH6C5yOwKYK1w==
X-Google-Smtp-Source: APXvYqzQk46Y6eeg2hH2s6F7jP6tW8AHVwnJZaLYT6r1Wf5ecobjIj6/5wKC5s9XcEf0+8Tie52rAjaWCUQE/ZryatY=
X-Received: by 2002:ad4:4b08:: with SMTP id r8mr9321668qvw.250.1576170684921;
 Thu, 12 Dec 2019 09:11:24 -0800 (PST)
MIME-Version: 1.0
References: <20191211204753.242298-1-pomonis@google.com> <20191211204753.242298-3-pomonis@google.com>
 <87eex9c20c.fsf@vitty.brq.redhat.com>
In-Reply-To: <87eex9c20c.fsf@vitty.brq.redhat.com>
From:   Marios Pomonis <pomonis@google.com>
Date:   Thu, 12 Dec 2019 09:11:14 -0800
Message-ID: <CAKXAmdjmYzY=eQUpt2f7J6OLBozAjg=pgEgkFXEVDudH4-EydQ@mail.gmail.com>
Subject: Re: [PATCH v2 02/13] KVM: x86: Protect kvm_hv_msr_[get|set]_crash_data()
 from Spectre-v1/L1TF attacks
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nick Finco <nifi@google.com>, Andrew Honig <ahonig@google.com>,
        stable@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        rkrcmar@redhat.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 12, 2019 at 1:43 AM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>
> Marios Pomonis <pomonis@google.com> writes:
>
> > This fixes Spectre-v1/L1TF vulnerabilities in kvm_hv_msr_get_crash_data()
> > and kvm_hv_msr_set_crash_data().
> > These functions contain index computations that use the
> > (attacker-controlled) MSR number.
>
> Just to educate myself,
>
> in both cases 'index' is equal to 'msr - HV_X64_MSR_CRASH_P0' where
> 'msr' is constrained:
>   case HV_X64_MSR_CRASH_P0 ... HV_X64_MSR_CRASH_P4:
>          ....
>
> and moreover, kvm_hv_{get,set}_msr_common() is only being called for a
> narrow set of MSRs. How can an atacker overcome these limitations?
>
This attack scenario relies on speculative execution. Practically, one
could train the branch predictors involved to speculatively execute
this path even if the adversary-supplied MSR number does not fall into
the legitimate range. The adversary-supplied MSR number however is
going to be used when -speculatively- computing the index of the array
thus allowing an attacker to load normally illegitimate memory values
in the L1 cache.
> >
> > Fixes: commit e7d9513b60e8 ("kvm/x86: added hyper-v crash msrs into kvm hyperv context")
> >
> > Signed-off-by: Nick Finco <nifi@google.com>
> > Signed-off-by: Marios Pomonis <pomonis@google.com>
> > Reviewed-by: Andrew Honig <ahonig@google.com>
> > Cc: stable@vger.kernel.org
> > ---
> >  arch/x86/kvm/hyperv.c | 10 ++++++----
> >  1 file changed, 6 insertions(+), 4 deletions(-)
> >
> > diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> > index 23ff65504d7e..26408434b9bc 100644
> > --- a/arch/x86/kvm/hyperv.c
> > +++ b/arch/x86/kvm/hyperv.c
> > @@ -809,11 +809,12 @@ static int kvm_hv_msr_get_crash_data(struct kvm_vcpu *vcpu,
> >                                    u32 index, u64 *pdata)
> >  {
> >       struct kvm_hv *hv = &vcpu->kvm->arch.hyperv;
> > +     size_t size = ARRAY_SIZE(hv->hv_crash_param);
> >
> > -     if (WARN_ON_ONCE(index >= ARRAY_SIZE(hv->hv_crash_param)))
> > +     if (WARN_ON_ONCE(index >= size))
> >               return -EINVAL;
> >
> > -     *pdata = hv->hv_crash_param[index];
> > +     *pdata = hv->hv_crash_param[array_index_nospec(index, size)];
> >       return 0;
> >  }
> >
> > @@ -852,11 +853,12 @@ static int kvm_hv_msr_set_crash_data(struct kvm_vcpu *vcpu,
> >                                    u32 index, u64 data)
> >  {
> >       struct kvm_hv *hv = &vcpu->kvm->arch.hyperv;
> > +     size_t size = ARRAY_SIZE(hv->hv_crash_param);
> >
> > -     if (WARN_ON_ONCE(index >= ARRAY_SIZE(hv->hv_crash_param)))
> > +     if (WARN_ON_ONCE(index >= size))
> >               return -EINVAL;
> >
> > -     hv->hv_crash_param[index] = data;
> > +     hv->hv_crash_param[array_index_nospec(index, size)] = data;
> >       return 0;
> >  }
>
> --
> Vitaly
>


-- 
Marios Pomonis
Software Engineer, Security
GCP Platform Security
US-KIR-6THC
