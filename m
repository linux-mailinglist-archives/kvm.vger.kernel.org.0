Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A54C246BF68
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 16:34:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238835AbhLGPhg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 10:37:36 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:38263 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238824AbhLGPhf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 7 Dec 2021 10:37:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638891244;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=b0UWgvnnbXrOYFB6OxthiAZR1bLhse5mBfGx/oIY7kQ=;
        b=hk1Qxyt35eJKm/D1gFM31m2xvfphx8ixs3dGGAHqSPYSI/Mg8METrMwlL2Z9S8Hz2Nq7x0
        5ih2/Vz6onpD/qcCetmWMtp52AiPYTDs5IhPle8VkeaE5V+abeYOlfNIpFNrJvcY66gS6D
        hVUmJYiu3F21biVzFRJlw7ZZ+NP4PKs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-191-9lIRq_tdNEieWF4ssYH3NA-1; Tue, 07 Dec 2021 10:34:01 -0500
X-MC-Unique: 9lIRq_tdNEieWF4ssYH3NA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 53E5281EE62;
        Tue,  7 Dec 2021 15:33:58 +0000 (UTC)
Received: from starship (unknown [10.40.192.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 27CEF7095E;
        Tue,  7 Dec 2021 15:33:52 +0000 (UTC)
Message-ID: <0a6933a1679668e1da81f0bfbb850636d4a5ebb5.camel@redhat.com>
Subject: Re: [PATCH] KVM: x86: Always set kvm_run->if_flag
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Marc Orr <marcorr@google.com>,
        Tom Lendacky <Thomas.Lendacky@amd.com>
Cc:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Tue, 07 Dec 2021 17:33:51 +0200
In-Reply-To: <CAA03e5E7-ns7w9B9Tu7pSWzCo0Nh7Ba5jwQXcn_XYPf_reRq9Q@mail.gmail.com>
References: <20211207043100.3357474-1-marcorr@google.com>
         <c8889028-9c4e-cade-31b6-ea92a32e4f66@amd.com>
         <CAA03e5E7-ns7w9B9Tu7pSWzCo0Nh7Ba5jwQXcn_XYPf_reRq9Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2021-12-07 at 07:14 -0800, Marc Orr wrote:
> On Tue, Dec 7, 2021 at 6:43 AM Tom Lendacky <thomas.lendacky@amd.com> wrote:
> > On 12/6/21 10:31 PM, Marc Orr wrote:
> > > The kvm_run struct's if_flag is apart of the userspace/kernel API. The
> > > SEV-ES patches failed to set this flag because it's no longer needed by
> > > QEMU (according to the comment in the source code). However, other
> > > hypervisors may make use of this flag. Therefore, set the flag for
> > > guests with encrypted regiesters (i.e., with guest_state_protected set).
> > > 
> > > Fixes: f1c6366e3043 ("KVM: SVM: Add required changes to support intercepts under SEV-ES")
> > > Signed-off-by: Marc Orr <marcorr@google.com>
> > > ---
> > >   arch/x86/include/asm/kvm-x86-ops.h | 1 +
> > >   arch/x86/include/asm/kvm_host.h    | 1 +
> > >   arch/x86/kvm/svm/svm.c             | 8 ++++++++
> > >   arch/x86/kvm/vmx/vmx.c             | 6 ++++++
> > >   arch/x86/kvm/x86.c                 | 9 +--------
> > >   5 files changed, 17 insertions(+), 8 deletions(-)
> > > 
> > > diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> > > index cefe1d81e2e8..9e50da3ed01a 100644
> > > --- a/arch/x86/include/asm/kvm-x86-ops.h
> > > +++ b/arch/x86/include/asm/kvm-x86-ops.h
> > > @@ -47,6 +47,7 @@ KVM_X86_OP(set_dr7)
> > >   KVM_X86_OP(cache_reg)
> > >   KVM_X86_OP(get_rflags)
> > >   KVM_X86_OP(set_rflags)
> > > +KVM_X86_OP(get_if_flag)
> > >   KVM_X86_OP(tlb_flush_all)
> > >   KVM_X86_OP(tlb_flush_current)
> > >   KVM_X86_OP_NULL(tlb_remote_flush)
> > > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > > index 860ed500580c..a7f868ff23e7 100644
> > > --- a/arch/x86/include/asm/kvm_host.h
> > > +++ b/arch/x86/include/asm/kvm_host.h
> > > @@ -1349,6 +1349,7 @@ struct kvm_x86_ops {
> > >       void (*cache_reg)(struct kvm_vcpu *vcpu, enum kvm_reg reg);
> > >       unsigned long (*get_rflags)(struct kvm_vcpu *vcpu);
> > >       void (*set_rflags)(struct kvm_vcpu *vcpu, unsigned long rflags);
> > > +     bool (*get_if_flag)(struct kvm_vcpu *vcpu);
> > > 
> > >       void (*tlb_flush_all)(struct kvm_vcpu *vcpu);
> > >       void (*tlb_flush_current)(struct kvm_vcpu *vcpu);
> > > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > > index d0f68d11ec70..91608f8c0cde 100644
> > > --- a/arch/x86/kvm/svm/svm.c
> > > +++ b/arch/x86/kvm/svm/svm.c
> > > @@ -1585,6 +1585,13 @@ static void svm_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags)
> > >       to_svm(vcpu)->vmcb->save.rflags = rflags;
> > >   }
> > > 
> > > +static bool svm_get_if_flag(struct kvm_vcpu *vcpu)
> > > +{
> > > +     struct vmcb *vmcb = to_svm(vcpu)->vmcb;
> > > +
> > > +     return !!(vmcb->control.int_state & SVM_GUEST_INTERRUPT_MASK);
> > 
> > I'm not sure if this is always valid to use for non SEV-ES guests. Maybe
> > the better thing would be:

I also noticed long ago that SVM_GUEST_INTERRUPT_MASK seems to duplicate the EFLAGS.IF value,
it seems to have no other purpose.

Best regards,
	Maxim Levitsky

> > 
> >         return sev_es_guest(vcpu->kvm) ? vmcb->control.int_state & SVM_GUEST_INTERRUPT_MASK
> >                                        : kvm_get_rflags(vcpu) & X86_EFLAGS_IF;
> > 
> > (Since this function returns a bool, I don't think you need the !!)
> 
> I had the same reservations when writing the patch. (Why fix what's
> not broken.) The reason I wrote the patch this way is based on what I
> read in APM vol2: Appendix B Layout of VMCB: "GUEST_INTERRUPT_MASK -
> Value of the RFLAGS.IF bit for the guest."
> 
> Also, I had _thought_ that `svm_interrupt_allowed()` -- the
> AMD-specific function used to populate `ready_for_interrupt_injection`
> -- was relying on `GUEST_INTERRUPT_MASK`. But now I'm reading the code
> again, and I realized I was overly focused on the SEV-ES handling.
> That code is actually extracting the IF bit from the RFLAGS register
> in the same way you've proposed here.
> 
> Changing the patch as you've suggested SGTM. I can send out a v2. I'll
> wait a day or two to see if there are any other comments first. I
> guess the alternative would be to change `svm_interrupt_blocked()` to
> solely use the `SVM_GUEST_INTERRUPT_MASK`. If we were confident that
> it was sufficient, it would be a nice little cleanup. But regardless,
> I think we should keep the code introduced by this patch consistent
> with `svm_interrupt_blocked()`.
> 
> Also, noted on the `!!` not being needed when returning from a bool
> function. I'll keep this in mind in the future. Thanks!
> 


