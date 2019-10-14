Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE9F1D6A40
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2019 21:37:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388923AbfJNThx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Oct 2019 15:37:53 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:44489 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730288AbfJNThx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Oct 2019 15:37:53 -0400
Received: by mail-io1-f67.google.com with SMTP id w12so40413851iol.11
        for <kvm@vger.kernel.org>; Mon, 14 Oct 2019 12:37:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vEpCOAVzngUdsFa9lIxJhX4XGppfZTQCefn2ngBz/k4=;
        b=ejd3GOQuu+arUwTkQ6H3tHXnYrMbe35e4GdmjfvtWkAg8hA3qezd7IR4U+P6N6/iNU
         yuoRKZmHjuQYomnG2bDxx8pL6ZkvjtUWuNAI+xIjkq755ERjRmwJuITCaUSCxIj/sTkj
         MFK9kkJeYzceqkvDQ/cKXcqesX+aroqPdCNv1AzdYUakGyqareg+lBfe5ynKFDksdsi4
         7kM4gn+ZuwVgn6J150cRsGoygUUEnJDleg9ns5hqO+1HSfxeMK6RGFFNhkYvrepV5LoD
         hjExPwYRMjGqn4hpGdLJsBi5baPSLN5v7Gqx9f9pIKU7B/hYpepD1W5Yrp0JAstGWjoG
         V72Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vEpCOAVzngUdsFa9lIxJhX4XGppfZTQCefn2ngBz/k4=;
        b=Eu3p7aoFEvzOel5GtJ8McxN5LDU+Vwo3V2HRAiZUnRBxgYaVzMg1azPmg8Zv+8rccz
         zU7UFBbcOFAK3G5XZVbi1tWI9NNIiphImNF6I2qvo34S3RboO3ou1CBdudmlhLhVB184
         mT1pcgBa/Wt+s3++3NomGj6DMczbkSfcvDtXvOC9/2SCKpbTmLpXQ7X3QjKWRHRoaonB
         OcLInKkF3MuZLmpDvRbIW8MZu476JVz667LqreQ4uroT2z1ugx2vaGRUJwp1ZSPYU1G9
         dU1Tr/IdVACrkgUmhWLLXJkE+vobTYeH4WEABaUY3NOWnwuIftWlCU8mVwZffnww1jBe
         W7JA==
X-Gm-Message-State: APjAAAWZ9mr21STOrVy4LMOSrHcjSGIMROrCM9BOeJpLlTEi4deiNKEk
        KckSXbN/vf+3/NwXsmarJcDEVUE9hILelPU7OMmLvw==
X-Google-Smtp-Source: APXvYqz3I4jmJTU1v++RwJ1hN4WOTpsAVtmI8UxKG+uTXLRvjTJM/iqiU1OQx6VbicSS9I1cusyFgPIfI6Vl+2p7Vws=
X-Received: by 2002:a92:ccd0:: with SMTP id u16mr2296503ilq.296.1571081871615;
 Mon, 14 Oct 2019 12:37:51 -0700 (PDT)
MIME-Version: 1.0
References: <20191010232819.135894-1-jmattson@google.com> <20191014175936.GD22962@linux.intel.com>
 <CALMp9eS_fYjyTDG75316cdyCp6NRHAHmN2J+sTf9uxvUfiEsQA@mail.gmail.com> <20191014191522.GG22962@linux.intel.com>
In-Reply-To: <20191014191522.GG22962@linux.intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 14 Oct 2019 12:37:39 -0700
Message-ID: <CALMp9eS-xPS2DYK10L_QYkEufUUoTAJU0++rqMEQkSRgu-4KpA@mail.gmail.com>
Subject: Re: [PATCH v3] KVM: nVMX: Don't leak L1 MMIO regions to L2
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm list <kvm@vger.kernel.org>, Liran Alon <liran.alon@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dan Cross <dcross@google.com>, Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 14, 2019 at 12:15 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Mon, Oct 14, 2019 at 11:50:37AM -0700, Jim Mattson wrote:
> > On Mon, Oct 14, 2019 at 10:59 AM Sean Christopherson
> > <sean.j.christopherson@intel.com> wrote:
> > > > @@ -2947,19 +2947,18 @@ static void nested_get_vmcs12_pages(struct kvm_vcpu *vcpu)
> > > >                       vmx->nested.apic_access_page = NULL;
> > > >               }
> > > >               page = kvm_vcpu_gpa_to_page(vcpu, vmcs12->apic_access_addr);
> > > > -             /*
> > > > -              * If translation failed, no matter: This feature asks
> > > > -              * to exit when accessing the given address, and if it
> > > > -              * can never be accessed, this feature won't do
> > > > -              * anything anyway.
> > > > -              */
> > > >               if (!is_error_page(page)) {
> > > >                       vmx->nested.apic_access_page = page;
> > > >                       hpa = page_to_phys(vmx->nested.apic_access_page);
> > > >                       vmcs_write64(APIC_ACCESS_ADDR, hpa);
> > > >               } else {
> > > > -                     secondary_exec_controls_clearbit(vmx,
> > > > -                             SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES);
> > > > +                     pr_debug_ratelimited("%s: non-cacheable APIC-access address in vmcs12\n",
> > > > +                                          __func__);
> > >
> > > Hmm, "non-cacheable" is confusing, especially in the context of the APIC,
> > > which needs to be mapped "uncacheable".  Maybe just "invalid"?
> >
> > "Invalid" is not correct. L1 MMIO addresses are valid; they're just
> > not cacheable. Perhaps:
> >
> > "vmcs12 APIC-access address references a page not backed by a memslot in L1"?
>
> Hmm, technically is_error_page() isn't limited to a non-existent memslot,
> any GFN that doesn't lead to a 'struct page' will trigger is_error_page().
>
> Maybe just spit out what literally went wrong?  E.g something like
>
>         pr_debug_ratelimited("%s: no backing 'struct page' for APIC-access address in vmcs12\n"

Perfect!

> > > > +                     vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
> > > > +                     vcpu->run->internal.suberror =
> > > > +                             KVM_INTERNAL_ERROR_EMULATION;
> > > > +                     vcpu->run->internal.ndata = 0;
> > > > +                     return false;
> > > >               }
> > > >       }
> > > >
> > > > @@ -3004,6 +3003,7 @@ static void nested_get_vmcs12_pages(struct kvm_vcpu *vcpu)
> > > >               exec_controls_setbit(vmx, CPU_BASED_USE_MSR_BITMAPS);
> > > >       else
> > > >               exec_controls_clearbit(vmx, CPU_BASED_USE_MSR_BITMAPS);
> > > > +     return true;
> > > >  }
> > > >
> > > >  /*
> > > > @@ -3042,13 +3042,15 @@ static void load_vmcs12_host_state(struct kvm_vcpu *vcpu,
> > > >  /*
> > > >   * If from_vmentry is false, this is being called from state restore (either RSM
> > > >   * or KVM_SET_NESTED_STATE).  Otherwise it's called from vmlaunch/vmresume.
> > > > -+ *
> > > > -+ * Returns:
> > > > -+ *   0 - success, i.e. proceed with actual VMEnter
> > > > -+ *   1 - consistency check VMExit
> > > > -+ *  -1 - consistency check VMFail
> > > > + *
> > > > + * Returns:
> > > > + *   ENTER_VMX_SUCCESS: Successfully entered VMX non-root mode
> > >
> > > "Enter VMX" usually refers to VMXON, e.g. the title of VMXON in the SDM is
> > > "Enter VMX Operation".
> > >
> > > Maybe NVMX_ENTER_NON_ROOT_?
> >
> > How about NESTED_VMX_ENTER_NON_ROOT_MODE_STATUS_?
> >
> > > > + *   ENTER_VMX_VMFAIL:  Consistency check VMFail
> > > > + *   ENTER_VMX_VMEXIT:  Consistency check VMExit
> > > > + *   ENTER_VMX_ERROR:   KVM internal error
> > >
> > > Probably need to more explicit than VMX_ERROR, e.g. all of the VM-Fail
> > > defines are prefixed with VMXERR_##.
> > >
> > > May ENTER_VMX_KVM_ERROR?  (Or NVMX_ENTER_NON_ROOT_KVM_ERROR).
> >
> > NESTED_VMX_ENTER_NON_ROOT_MODE_STATUS_KVM_INTERNAL_ERROR?
>
> I can't tell if you're making fun of me for being pedantic about "Enter VMX",
> or if you really want to have a 57 character enum.  :-)
>
> NESTED_VMENTER_?

It's difficult to balance brevity and clarity. I have no problem with
57 character enums, but I understand that Linux line-wrapping
conventions are designed for the VT100, so long enums present a
challenge. :-)

How about:

NVMX_VMENTRY_SUCCESS
NVMX_VMENTRY_VMFAIL
NVMX_VMENTRY_VMEXIT
NVMX_VMENTRY_INTERNAL_ERROR
