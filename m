Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C59BC248D10
	for <lists+kvm@lfdr.de>; Tue, 18 Aug 2020 19:35:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728651AbgHRRfQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Aug 2020 13:35:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728597AbgHRRfF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Aug 2020 13:35:05 -0400
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com [IPv6:2607:f8b0:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D4B8C061389
        for <kvm@vger.kernel.org>; Tue, 18 Aug 2020 10:35:05 -0700 (PDT)
Received: by mail-oi1-x242.google.com with SMTP id k4so18631647oik.2
        for <kvm@vger.kernel.org>; Tue, 18 Aug 2020 10:35:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SHV3gJ4B9l2e20rJtpBBFovAnrk+c2E/9qTPLdrzing=;
        b=Q61VjhAkrgHOmaCg/adWRG/x5H0IPd+QBP3FuKjksqDKTVaR7pjVaUSFHrpzq0YyGn
         FMctmn7iklqyxZ7Rc/3rJEyi08g8clYujWgIKclHNOFCPr09W6+PvQ46NHyA8/M7/mRm
         /KVXs9YrAAbWtkLhkWWEsVAF4XQVnULuRkh8WHVI4+l6/J8PwAvo1gm8IHS9cItYPTmS
         sR6Xd3oGsZPAm3je9sltcpA0iEuARsEwZ6M0v0LRo0Z6mbg5w9pYZ6VhvKYTKxfFpZ/A
         C2DxLJS4LIF6E4Hc4JqyQb5hTlqrdaYK8Dt0Pd7uF7QbgmnT6vzBc2APiDB36J6z10pV
         1C0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SHV3gJ4B9l2e20rJtpBBFovAnrk+c2E/9qTPLdrzing=;
        b=Se70NVOIIR/IHAHuqiThAZqLMLefLesZtUaX9CpOGprRzoeW2ZP3+0wMu4umLpMYzD
         IhpaxQaA2JI1Tpw2agUhFNVLqcoKqVeIq8PRmdTrZWNdpJ8P+CkJBRd7q6nfxjHg8lwX
         qq+IvWCvOIUTM0Brvc3d02DJyPgwI4+KIRG1ZD7jDymDC8SIjRM+LyMTD0/MzQkOxD7J
         oKQR7Fg9RIgJ0tysI10yH4nMJD+gfBG1a0kqHoAM2kLohXUqw5ysoSeMVWgaMtSORw0u
         Qxv/Af2riYVBo7xe9tt2pg3NtDRqCvo0tNlX3aKbwrL/V5fKnoDMqjbzloD0MFWx78mu
         7QVg==
X-Gm-Message-State: AOAM531ZDhJ1x3Drrnr9haUF9XaNjJ3hKhUoHRdKmlVJxNdRLUooBqSV
        Pwenl4C6q7eDpXFc22QTE3x5TY3xl2sFO9XblRi+Lg==
X-Google-Smtp-Source: ABdhPJyh1eXzddDOCmCvH72cPy2lJXyIJyuJT7KdE3cC/ZggviprMXOz+EdI2UHR87EAU3mdNxvvE003NmW63D1ZXBw=
X-Received: by 2002:aca:b942:: with SMTP id j63mr817408oif.28.1597772104039;
 Tue, 18 Aug 2020 10:35:04 -0700 (PDT)
MIME-Version: 1.0
References: <20200818004314.216856-1-pshier@google.com> <20200818152048.GA15390@linux.intel.com>
 <CALMp9eS5UOPGF0v2vt9aMPEZT7_a6ruJx9n_DLKkjiEb_kCWag@mail.gmail.com> <20200818172429.GG15390@linux.intel.com>
In-Reply-To: <20200818172429.GG15390@linux.intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 18 Aug 2020 10:34:52 -0700
Message-ID: <CALMp9eTz7=37gqBNShkQGQN_LVkbDvMUg5CdNX89WknZjmF_nQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: nVMX: Update VMCS02 when L2 PAE PDPTE updates detected
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Peter Shier <pshier@google.com>, kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 18, 2020 at 10:24 AM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Tue, Aug 18, 2020 at 10:14:39AM -0700, Jim Mattson wrote:
> > On Tue, Aug 18, 2020 at 8:20 AM Sean Christopherson
> > <sean.j.christopherson@intel.com> wrote:
> >
> > > I'd prefer to handle this on the switch from L2->L1.  It avoids adding a
> > > kvm_x86_ops and yet another sequence of four VMWRITEs, e.g. I think this
> > > will do the trick.
> > >
> > > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > > index 9c74a732b08d..67465f0ca1b9 100644
> > > --- a/arch/x86/kvm/vmx/nested.c
> > > +++ b/arch/x86/kvm/vmx/nested.c
> > > @@ -4356,6 +4356,9 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
> > >         if (kvm_check_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu))
> > >                 kvm_vcpu_flush_tlb_current(vcpu);
> > >
> > > +       if (enable_ept && is_pae_paging(vcpu))
> > > +               ept_load_pdptrs(vcpu);
> > > +
> >
> > Are the mmu->pdptrs[] guaranteed to be valid at this point? If L2 has
> > PAE paging enabled, and it has modified CR3 without a VM-exit, where
> > are the current PDPTE values read from the vmcs02 into mmu->pdptrs[]?
>
> ept_load_pdptrs() checks kvm_register_is_dirty(vcpu, VCPU_EXREG_PDPTR).  The
> idea is basically the same as the above TLB_FLUSH_CURRENT; process pending
> requests and/or dirty state for L2 before switching to L1.

Thanks. Is it right to conclude that if we get to the end of
nested_vmx_vmexit, and vcpu->arch.regs_dirty is non-zero, then
something is amiss?
