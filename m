Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16F6D1EEA1A
	for <lists+kvm@lfdr.de>; Thu,  4 Jun 2020 20:10:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730303AbgFDSK2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jun 2020 14:10:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730008AbgFDSK1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Jun 2020 14:10:27 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC2E1C08C5C0
        for <kvm@vger.kernel.org>; Thu,  4 Jun 2020 11:10:27 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id r2so7411467ioo.4
        for <kvm@vger.kernel.org>; Thu, 04 Jun 2020 11:10:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=L5HJjZvVskCO9kjKNvkZcNLT/6V6HfacHAsQohM4o8A=;
        b=g4O8Y8vWSLLBwTDYrBoatp7v+icluogTw4q4TO+nSRvJZal3PlouWWR8NY953h6SjS
         622XeB+/+4f+ZnlL+fg0NCAuV8WL9rMblXyECv2f9rnzIkpOez/T6M/ulGFN/MyjU1JM
         o8rtPeT8x5IorIM7c56kH1koFAvJyL3pFCnu89Ap+FoOJuwcYhBNgahhX1oGfQYuuezI
         V7Z0emze4MTyBj1/hrvqcah19ooLE17X7Yi4bwAYLgRRVMpTYBx6RhS1g/07YQLPA2/s
         Ynxeo/+3wtBzyLlBxEIPhRfO5GAWwGaADxRQJ9ePEGGipKF8r5obBWoU31uhh9+exowc
         Nzmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=L5HJjZvVskCO9kjKNvkZcNLT/6V6HfacHAsQohM4o8A=;
        b=Q7YCCBDy5EwRlWAy609iCfrvsK30lWJtr/UEeoE8icA4v8bROlg6WjB0bxgTvuWmAt
         c8PYzN2Tcx7ReGKMKnRZGbjbNVzX/W0VixWZvqkXBLTH9xVd/wpg/fiGOXceGj7XQcDj
         C6TopMtFxQwrGS/46r++eQ+JIapMmSxXg4uXnLNrF45SdEoC6nQLjJ2BjdkKipWmqsSR
         p1JxbklkdHcO5AWILPTwerB8JWD9sFHVqpK6415e4f0AlwtGMg8boWP+yTv7Ri+ff3/r
         EhEpvCTF/tgdIuCsYMuivIhg+CGaoptnqv1FPKAknXRCkRcSpa0kB+XxHKTft1RIYa2/
         LywQ==
X-Gm-Message-State: AOAM5308gVZFuFSdWfRMTwnaNzWnEdqL9mOXAcj9b3Aad0jyJkANmo/y
        TCdf511KZRqKm8+kU0K0AvB7S0NKOnzbwGuwu6CLSere
X-Google-Smtp-Source: ABdhPJxZzhqyu7uAkbTXoK2fFclP6AQCk/C+V3OFQvfBf4LcIqUi+O7qB9Tv8XJWdc144vdHqMsG0NyKryfzt5uA79k=
X-Received: by 2002:a6b:5c01:: with SMTP id z1mr5119461ioh.177.1591294225755;
 Thu, 04 Jun 2020 11:10:25 -0700 (PDT)
MIME-Version: 1.0
References: <20200604143158.484651-1-vkuznets@redhat.com> <da7acd6f-204d-70e2-52aa-915a4d9163ef@redhat.com>
 <20200604145357.GA30223@linux.intel.com> <87k10meth6.fsf@vitty.brq.redhat.com>
 <20200604160253.GF30223@linux.intel.com> <87h7vqeq8o.fsf@vitty.brq.redhat.com>
In-Reply-To: <87h7vqeq8o.fsf@vitty.brq.redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 4 Jun 2020 11:10:14 -0700
Message-ID: <CALMp9eRO_hf78LP_SdKLmEGhVP7jsKotkTBPvLpexHO_of-=yw@mail.gmail.com>
Subject: Re: [PATCH] KVM: nVMX: Inject #GP when nested_vmx_get_vmptr() fails
 to read guest memory
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        Wanpeng Li <wanpengli@tencent.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 4, 2020 at 9:43 AM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>
> Sean Christopherson <sean.j.christopherson@intel.com> writes:
>
> > On Thu, Jun 04, 2020 at 05:33:25PM +0200, Vitaly Kuznetsov wrote:
> >> Sean Christopherson <sean.j.christopherson@intel.com> writes:
> >>
> >> > On Thu, Jun 04, 2020 at 04:40:52PM +0200, Paolo Bonzini wrote:
> >> >> On 04/06/20 16:31, Vitaly Kuznetsov wrote:
> >> >
> >> > ...
> >> >
> >> >> > KVM could've handled the request correctly by going to userspace and
> >> >> > performing I/O but there doesn't seem to be a good need for such requests
> >> >> > in the first place. Sane guests should not call VMXON/VMPTRLD/VMCLEAR with
> >> >> > anything but normal memory. Just inject #GP to find insane ones.
> >> >> >
> >>
> >> ...
> >>
> >> >>
> >> >> looks good but we need to do the same in handle_vmread, handle_vmwrite,
> >> >> handle_invept and handle_invvpid.  Which probably means adding something
> >> >> like nested_inject_emulation_fault to commonize the inner "if".
> >> >
> >> > Can we just kill the guest already instead of throwing more hacks at this
> >> > and hoping something sticks?  We already have one in
> >> > kvm_write_guest_virt_system...
> >> >
> >> >   commit 541ab2aeb28251bf7135c7961f3a6080eebcc705
> >> >   Author: Fuqian Huang <huangfq.daxian@gmail.com>
> >> >   Date:   Thu Sep 12 12:18:17 2019 +0800
> >> >
> >> >     KVM: x86: work around leak of uninitialized stack contents
> >> >
> >>
> >> Oh I see...
> >>
> >> [...]
> >>
> >> Let's get back to 'vm_bugged' idea then?
> >>
> >> https://lore.kernel.org/kvm/87muadnn1t.fsf@vitty.brq.redhat.com/
> >
> > Hmm, I don't think we need to go that far.  The 'vm_bugged' idea was more
> > to handle cases where KVM itself (or hardware) screwed something up and
> > detects an issue deep in a call stack with no recourse for reporting the
> > error up the stack.
> >
> > That isn't the case here.  Unless I'm mistaken, the end result is simliar
> > to this patch, except that KVM would exit to userspace with
> > KVM_INTERNAL_ERROR_EMULATION instead of injecting a #GP.  E.g.
>
> I just wanted to resurrect that 'vm_bugged' idea but was waiting for a
> good opportunity :-)
>
> The advantage of KVM_EXIT_INTERNAL_ERROR is that we're not trying to
> invent some behavior which is not in SDM and making it a bit more likely
> that we get a bug report from an angry user.

If KVM can't handle the emulation, KVM_EXIT_INTERNAL_ERROR is far
better than cooking up fictional faults to deliver to the guest.

> >
> > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > index 9c74a732b08d..e13d2c0014e2 100644
> > --- a/arch/x86/kvm/vmx/nested.c
> > +++ b/arch/x86/kvm/vmx/nested.c
> > @@ -4624,6 +4624,20 @@ void nested_vmx_pmu_entry_exit_ctls_update(struct kvm_vcpu *vcpu)
> >         }
> >  }
> >
> > +static int nested_vmx_handle_memory_failure(struct kvm_vcpu *vcpu, int ret,
> > +                                           struct x86_exception *e)
> > +{
> > +       if (r == X86EMUL_PROPAGATE_FAULT) {
> > +               kvm_inject_emulated_page_fault(vcpu, &e);
> > +               return 1;
> > +       }
> > +
> > +       vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
> > +       vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_EMULATION;
> > +       vcpu->run->internal.ndata = 0;
> > +       return 0;
> > +}
> > +
> >  static int nested_vmx_get_vmptr(struct kvm_vcpu *vcpu, gpa_t *vmpointer)
> >  {
> >         gva_t gva;
> > @@ -4634,11 +4648,9 @@ static int nested_vmx_get_vmptr(struct kvm_vcpu *vcpu, gpa_t *vmpointer)
> >                                 sizeof(*vmpointer), &gva))
> >                 return 1;
> >
> > -       if (kvm_read_guest_virt(vcpu, gva, vmpointer, sizeof(*vmpointer), &e)) {
> > -               kvm_inject_emulated_page_fault(vcpu, &e);
> > -               return 1;
> > -       }
> > -
> > +       r kvm_read_guest_virt(vcpu, gva, vmpointer, sizeof(*vmpointer), &e);
> > +       if (r)
> > +               return nested_vmx_handle_memory_failure(r, &e);
> >         return 0;
> >  }
> >
>
> ... and the same for handle_vmread, handle_vmwrite, handle_invept and
> handle_invvpid as suggested by Paolo. I'll be sending this as v2 with
> your Suggested-by: shortly.
>
> >
> >
> > Side topic, I have some preliminary patches for the 'vm_bugged' idea.  I'll
> > try to whip them into something that can be posted upstream in the next few
> > weeks.
> >
>
> Sounds great!
>
> --
> Vitaly
>
