Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C4BB46BEFD
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 16:15:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234204AbhLGPSf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 10:18:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229670AbhLGPSf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Dec 2021 10:18:35 -0500
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE15AC061574
        for <kvm@vger.kernel.org>; Tue,  7 Dec 2021 07:15:04 -0800 (PST)
Received: by mail-oi1-x22f.google.com with SMTP id n66so28198448oia.9
        for <kvm@vger.kernel.org>; Tue, 07 Dec 2021 07:15:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hYEsDkmgy55LBBuGxMFIWjuhjsIdsYQ2MQLWd9zZFJA=;
        b=pbSTEPN9vNs2eTDvxkECIOFuhHmgFh06GxwxUJgGN6qbNlXkIFmJYga3cRVf6uZN0C
         K9U7YNiBon4uxVOyRbV7YxqpFxc45c80lBf1qmVCVYd94/ut2bnIA6r68qCxMoTZsBUL
         kz26VXVwlVPJkUPyfuy7RNCFY5g0/JuRW3vt+M7K/APpUqK5TIfOlOXXEyJ71z8gf3yy
         D+naE5Q9+b/Vp9tf+j2QZwh0og6p72mK5laTlHcjVBjZZscgj+IZTaS32xuNLEuEuUgt
         zyYbYqLE7s6rTbE8hLU7dYPrWsW/1Kj7CTWyrfB5kkL+jp/caxHBvRM+NS0Zy6i156A1
         yilQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hYEsDkmgy55LBBuGxMFIWjuhjsIdsYQ2MQLWd9zZFJA=;
        b=Gp2Z32CU/J92sDO6lJj6WBlGtyC/t1yfxX7eKu7XUdUN+tkuDRepq/89l23ffp9r14
         UyHYvPGel13E6NzoFtEj3yW53U557vWAa6DO4RRjkdfdtNK7YBjfGvTQXuUEObARggk8
         rp62PPZQfa6Od0mbSKJhbG6/XErEZUDR0yWAWTcIB648plQkhyrt2BkYulyNInTB0crF
         prAEij5n/6njPua00jSFOkzmZ3EjAFqax5uRkGXNbZ/8W//rl7vwpa9L9HZhEgkxQT53
         9sIGF1NVTO/hO67OX8cZEgg1XlIxeN/6OOoH0j7RT6D3RV/C/j+8ht+HPrPyufrnUco5
         itpA==
X-Gm-Message-State: AOAM533Wya7mDxYA5bxq7yeGXOQ2GYIOTjVL2joiTL+jOLjOWRWmKVdC
        FQRQq6dSRjIiz6DTFXovrPLmrDhkye/B8gI5J1sF1g==
X-Google-Smtp-Source: ABdhPJwDw/sySXKjX8gXRG2Dcsl+1iyX/CEM2kTY4CKsqQ+BujquEoOqFrIjyoT0V8s/6EdwJiDxPuVZ7+FvglzmgRo=
X-Received: by 2002:a54:4515:: with SMTP id l21mr5695599oil.15.1638890103775;
 Tue, 07 Dec 2021 07:15:03 -0800 (PST)
MIME-Version: 1.0
References: <20211207043100.3357474-1-marcorr@google.com> <c8889028-9c4e-cade-31b6-ea92a32e4f66@amd.com>
In-Reply-To: <c8889028-9c4e-cade-31b6-ea92a32e4f66@amd.com>
From:   Marc Orr <marcorr@google.com>
Date:   Tue, 7 Dec 2021 07:14:52 -0800
Message-ID: <CAA03e5E7-ns7w9B9Tu7pSWzCo0Nh7Ba5jwQXcn_XYPf_reRq9Q@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: Always set kvm_run->if_flag
To:     Tom Lendacky <Thomas.Lendacky@amd.com>
Cc:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 7, 2021 at 6:43 AM Tom Lendacky <thomas.lendacky@amd.com> wrote:
>
> On 12/6/21 10:31 PM, Marc Orr wrote:
> > The kvm_run struct's if_flag is apart of the userspace/kernel API. The
> > SEV-ES patches failed to set this flag because it's no longer needed by
> > QEMU (according to the comment in the source code). However, other
> > hypervisors may make use of this flag. Therefore, set the flag for
> > guests with encrypted regiesters (i.e., with guest_state_protected set).
> >
> > Fixes: f1c6366e3043 ("KVM: SVM: Add required changes to support intercepts under SEV-ES")
> > Signed-off-by: Marc Orr <marcorr@google.com>
> > ---
> >   arch/x86/include/asm/kvm-x86-ops.h | 1 +
> >   arch/x86/include/asm/kvm_host.h    | 1 +
> >   arch/x86/kvm/svm/svm.c             | 8 ++++++++
> >   arch/x86/kvm/vmx/vmx.c             | 6 ++++++
> >   arch/x86/kvm/x86.c                 | 9 +--------
> >   5 files changed, 17 insertions(+), 8 deletions(-)
> >
> > diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> > index cefe1d81e2e8..9e50da3ed01a 100644
> > --- a/arch/x86/include/asm/kvm-x86-ops.h
> > +++ b/arch/x86/include/asm/kvm-x86-ops.h
> > @@ -47,6 +47,7 @@ KVM_X86_OP(set_dr7)
> >   KVM_X86_OP(cache_reg)
> >   KVM_X86_OP(get_rflags)
> >   KVM_X86_OP(set_rflags)
> > +KVM_X86_OP(get_if_flag)
> >   KVM_X86_OP(tlb_flush_all)
> >   KVM_X86_OP(tlb_flush_current)
> >   KVM_X86_OP_NULL(tlb_remote_flush)
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index 860ed500580c..a7f868ff23e7 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -1349,6 +1349,7 @@ struct kvm_x86_ops {
> >       void (*cache_reg)(struct kvm_vcpu *vcpu, enum kvm_reg reg);
> >       unsigned long (*get_rflags)(struct kvm_vcpu *vcpu);
> >       void (*set_rflags)(struct kvm_vcpu *vcpu, unsigned long rflags);
> > +     bool (*get_if_flag)(struct kvm_vcpu *vcpu);
> >
> >       void (*tlb_flush_all)(struct kvm_vcpu *vcpu);
> >       void (*tlb_flush_current)(struct kvm_vcpu *vcpu);
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index d0f68d11ec70..91608f8c0cde 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -1585,6 +1585,13 @@ static void svm_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags)
> >       to_svm(vcpu)->vmcb->save.rflags = rflags;
> >   }
> >
> > +static bool svm_get_if_flag(struct kvm_vcpu *vcpu)
> > +{
> > +     struct vmcb *vmcb = to_svm(vcpu)->vmcb;
> > +
> > +     return !!(vmcb->control.int_state & SVM_GUEST_INTERRUPT_MASK);
>
> I'm not sure if this is always valid to use for non SEV-ES guests. Maybe
> the better thing would be:
>
>         return sev_es_guest(vcpu->kvm) ? vmcb->control.int_state & SVM_GUEST_INTERRUPT_MASK
>                                        : kvm_get_rflags(vcpu) & X86_EFLAGS_IF;
>
> (Since this function returns a bool, I don't think you need the !!)

I had the same reservations when writing the patch. (Why fix what's
not broken.) The reason I wrote the patch this way is based on what I
read in APM vol2: Appendix B Layout of VMCB: "GUEST_INTERRUPT_MASK -
Value of the RFLAGS.IF bit for the guest."

Also, I had _thought_ that `svm_interrupt_allowed()` -- the
AMD-specific function used to populate `ready_for_interrupt_injection`
-- was relying on `GUEST_INTERRUPT_MASK`. But now I'm reading the code
again, and I realized I was overly focused on the SEV-ES handling.
That code is actually extracting the IF bit from the RFLAGS register
in the same way you've proposed here.

Changing the patch as you've suggested SGTM. I can send out a v2. I'll
wait a day or two to see if there are any other comments first. I
guess the alternative would be to change `svm_interrupt_blocked()` to
solely use the `SVM_GUEST_INTERRUPT_MASK`. If we were confident that
it was sufficient, it would be a nice little cleanup. But regardless,
I think we should keep the code introduced by this patch consistent
with `svm_interrupt_blocked()`.

Also, noted on the `!!` not being needed when returning from a bool
function. I'll keep this in mind in the future. Thanks!
