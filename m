Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 500511ED741
	for <lists+kvm@lfdr.de>; Wed,  3 Jun 2020 22:18:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726114AbgFCUSp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Jun 2020 16:18:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725821AbgFCUSo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Jun 2020 16:18:44 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F8B9C08C5C0
        for <kvm@vger.kernel.org>; Wed,  3 Jun 2020 13:18:44 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id m81so3815243ioa.1
        for <kvm@vger.kernel.org>; Wed, 03 Jun 2020 13:18:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mtaBAsOJtlYn8GTqNog6LKZ4Bl08LQASuLTc/dEs4Mw=;
        b=iPrDqLBE0xoG+nFo6Op7+LVh3VtmrDrTkdFCDvEBAZ9mPsDMB/vHi/I4gDP52fdjAz
         s/pP1hsbhLYuuVb9fCum3+jVjCTPcU6o58y9w9jmJsNqdd11jFtNHs5e5m0zULr3mvOA
         bwwdnyMlZ5x4XxHZJodTAvgwIHVdp/5cInk3xlGjyKtN15GpEoAkGY6hDBJPavmDPcA9
         YTEzUa0wIdEztsehZrulxMVjFlFuyY3vM+2uBit6ptB59PBaH1bW0lI8ZTe5Knlt31Vq
         gaa9BTUHOL/qzl2vUx9cFBz9gSZ7S4/caBSaAJkvQlydv92NJAG9R8TUf1pabc6Mqygo
         vC1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mtaBAsOJtlYn8GTqNog6LKZ4Bl08LQASuLTc/dEs4Mw=;
        b=jYoV3NnTentfD/cVxTEkc8Z2Rwb2aFlOSYplAp99VQ0j7Ay4qPH5p3BD2Vu2fw9bvF
         wikHjuICSsPG8UeC/WQhBlKimxhya/E2UHaKDnXS+sHzYHe068hVdanu0Y7zbPW48rzp
         McwjUTyegXwek8q90tD0Mmmr4ywx9biRzVoGu8DaV1KX4+23x29mI5GU5ioybkxBwr8q
         Nn6tMfR1r7f9cwjPzeCJDM9TSvnjd2kKNyqiBMMjgxsQGmhJppZfwgVf6sXvQw/5HIO0
         xN7sHNCxIUL/kdGLj0MLV2It7Cpa3J91IEk6xMgwaQfPkZxLSku6JaG+ckDPuduD0z7B
         Q9Gw==
X-Gm-Message-State: AOAM532Z8UB/DgPdlsAFcQcNHwBQs/i5E/EPGYFzD/Yr2P3XWdZ7oPS5
        QQxdj1a3GWawitmNZ6uO5QPedkul3fhpfvUpPJR8HDen
X-Google-Smtp-Source: ABdhPJx/ovvN30+mmL562sf+RrSRA3ZTsp+WaXRewwynbhoy2IshEqAMYPzExxwMloaZ0K+3XylGpmrO6JbFWPNH5Lc=
X-Received: by 2002:a5e:a705:: with SMTP id b5mr1359567iod.12.1591215522864;
 Wed, 03 Jun 2020 13:18:42 -0700 (PDT)
MIME-Version: 1.0
References: <20200601222416.71303-1-jmattson@google.com> <20200601222416.71303-4-jmattson@google.com>
 <20200602012139.GF21661@linux.intel.com> <CALMp9eS3XEVdZ-_pRsevOiKRBSbCr96saicxC+stPfUqsM1u1A@mail.gmail.com>
 <20200603022414.GA24364@linux.intel.com>
In-Reply-To: <20200603022414.GA24364@linux.intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 3 Jun 2020 13:18:31 -0700
Message-ID: <CALMp9eSth924epmxS8-mMXopGMFfR_JK7Hm8tQXyeqGF3ebxcg@mail.gmail.com>
Subject: Re: [PATCH v3 3/4] kvm: vmx: Add last_cpu to struct vcpu_vmx
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Liran Alon <liran.alon@oracle.com>,
        Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 2, 2020 at 7:24 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Tue, Jun 02, 2020 at 10:33:51AM -0700, Jim Mattson wrote:
> > On Mon, Jun 1, 2020 at 6:21 PM Sean Christopherson
> > <sean.j.christopherson@intel.com> wrote:
> > >
> > > On Mon, Jun 01, 2020 at 03:24:15PM -0700, Jim Mattson wrote:
> > > > As we already do in svm, record the last logical processor on which a
> > > > vCPU has run, so that it can be communicated to userspace for
> > > > potential hardware errors.
> > > >
> > > > Signed-off-by: Jim Mattson <jmattson@google.com>
> > > > Reviewed-by: Oliver Upton <oupton@google.com>
> > > > Reviewed-by: Peter Shier <pshier@google.com>
> > > > ---
> > > >  arch/x86/kvm/vmx/vmx.c | 1 +
> > > >  arch/x86/kvm/vmx/vmx.h | 3 +++
> > > >  2 files changed, 4 insertions(+)
> > > >
> > > > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > > > index 170cc76a581f..42856970d3b8 100644
> > > > --- a/arch/x86/kvm/vmx/vmx.c
> > > > +++ b/arch/x86/kvm/vmx/vmx.c
> > > > @@ -6730,6 +6730,7 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
> > > >       if (vcpu->arch.cr2 != read_cr2())
> > > >               write_cr2(vcpu->arch.cr2);
> > > >
> > > > +     vmx->last_cpu = vcpu->cpu;
> > >
> > > This is redundant in the EXIT_FASTPATH_REENTER_GUEST case.  Setting it
> > > before reenter_guest is technically wrong if emulation_required is true, but
> > > that doesn't seem like it'd be an issue in practice.
> >
> > I really would like to capture the last logical processor to execute
> > VMLAUNCH/VMRESUME (or VMRUN on the AMD side) on behalf of this vCPU.
>
> Does it matter though?  The flows that consume the variable are all directly
> in the VM-Exit path.
>
> > > >       vmx->fail = __vmx_vcpu_run(vmx, (unsigned long *)&vcpu->arch.regs,
> > > >                                  vmx->loaded_vmcs->launched);
> > > >
> > > > diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> > > > index 672c28f17e49..8a1e833cf4fb 100644
> > > > --- a/arch/x86/kvm/vmx/vmx.h
> > > > +++ b/arch/x86/kvm/vmx/vmx.h
> > > > @@ -302,6 +302,9 @@ struct vcpu_vmx {
> > > >       u64 ept_pointer;
> > > >
> > > >       struct pt_desc pt_desc;
> > > > +
> > > > +     /* which host CPU was used for running this vcpu */
> > > > +     unsigned int last_cpu;
> > >
> > > Why not put this in struct kvm_vcpu_arch?  I'd also vote to name it
> > > last_run_cpu, as last_cpu is super misleading.
> >
> > I think last_run_cpu may also be misleading, since in the cases of
> > interest, nothing actually 'ran.' Maybe last_attempted_vmentry_cpu?
>
> Ya, that thought crossed my mind as well.
>
> > > And if it's in arch, what about setting it vcpu_enter_guest?
> >
> > As you point out above, this isn't entirely accurate. (But that's the
> > way we roll in kvm, isn't it? :-)
>
> As an alternative to storing the last run/attempted CPU, what about moving
> the "bad VM-Exit" detection into handle_exit_irqoff, or maybe a new hook
> that is called after IRQs are enabled but before preemption is enabled, e.g.
> detect_bad_exit or something?  All of the paths in patch 4/4 can easily be
> moved out of handle_exit.  VMX would require a little bit of refacotring for
> it's "no handler" check, but that should be minor.

Given the alternatives, I'm willing to compromise my principles wrt
emulation_required. :-) I'll send out v4 soon.
