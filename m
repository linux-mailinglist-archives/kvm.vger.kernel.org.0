Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6EE21BD086
	for <lists+kvm@lfdr.de>; Wed, 29 Apr 2020 01:16:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726412AbgD1XQ3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Apr 2020 19:16:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726312AbgD1XQ3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 28 Apr 2020 19:16:29 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E886AC03C1AD
        for <kvm@vger.kernel.org>; Tue, 28 Apr 2020 16:16:28 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id m5so606320ilj.10
        for <kvm@vger.kernel.org>; Tue, 28 Apr 2020 16:16:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=r4RxKLheQFWjLght4V80HIUjV5cwhunpMukZ0Rx77a0=;
        b=a3/ZV658yISvrO9+1UU27T1GAwKxt14HXqvoXKFBaCbW3Lp5mY7UffdoYOa95wNEf3
         U+grmPC6Pf8E1N9kq2HAsoeLDAt+iMAyNDZKvehqIc6NcWOBIhIjh5XB0ZJoGK023wA4
         mar6i3VfAxK6wgli1oe4eJa4AK2wnngnNaHmCDFzAKTG+jNUNK1djtgDXV34yiEIxk8D
         z/TwGO99pgXFch32y5rw9GZ87Fbonh62nDyONUFchBOMD4ps/qBzc4TmyHKcOZ3anD8j
         VHtd+tp8KEE1sF1675bCwZfrpPrs/HV+dDRUMpGbdy2vTWxhynJ8yOA5zbcjBRlm+Ijb
         fwGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=r4RxKLheQFWjLght4V80HIUjV5cwhunpMukZ0Rx77a0=;
        b=o+FIlNWNL0qMHOye5phXmBgqEqKLdiYFtWjPJpU2IRxIU5H7f3W4lrYwMomhLGyjjF
         2OIpLH9tjJOD2QEz7OQfhoBI0/Hoc1fBv6kylh9wJN1p329+nOEXl4Pf8WOGoL8SN0JT
         yRO8UON+ws4H5a16FXc1V8JwvFiv/sETOZoD2Z08cGxV70l5+6/oNjdF2VscPifKoc77
         Pu5gqdZUTiUfr3+HXobU+PodJcMxYSJVk+TxCMp9wkUjYx9JKFsga0SV5XPwgDf9olGY
         OZIGzaZyDV/FnyTD7ZBZ3UTUr0OCZI0jDZMFR1lavcYt19onR/TEbMTsVAiBk2g0HwLY
         pHXg==
X-Gm-Message-State: AGi0PuaileM3rNautaPoanBNl6YH+eisyQJsGvRXTnCEL9Sw/W4c8bdD
        3zTEfGHLERODTjYzO8nhob5JQns3AEWQnG7IN4pctQ==
X-Google-Smtp-Source: APiQypIfCxto0N8rPspMKdAExAKXIzoJjLZtwgxTLaVVXOic/XF6uX4ejcBrMul0Kw5QIrfPRlN2jEuMxt7uLL1VpWc=
X-Received: by 2002:a92:3d85:: with SMTP id k5mr29689400ilf.26.1588115787754;
 Tue, 28 Apr 2020 16:16:27 -0700 (PDT)
MIME-Version: 1.0
References: <20200423022550.15113-1-sean.j.christopherson@intel.com>
 <20200423022550.15113-10-sean.j.christopherson@intel.com> <CALMp9eSuYqeVmWhb6q7T5DAW_Npbuin_N1+sbWjvcu0zTqiwsQ@mail.gmail.com>
 <20200428225949.GP12735@linux.intel.com>
In-Reply-To: <20200428225949.GP12735@linux.intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 28 Apr 2020 16:16:16 -0700
Message-ID: <CALMp9eRFfEB1avbQv0O0V=EGrJdSNTxg8Z-BONmQ--dV66CuAg@mail.gmail.com>
Subject: Re: [PATCH 09/13] KVM: nVMX: Prioritize SMI over nested IRQ/NMI
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 28, 2020 at 3:59 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Tue, Apr 28, 2020 at 03:04:02PM -0700, Jim Mattson wrote:
> > On Wed, Apr 22, 2020 at 7:26 PM Sean Christopherson
> > <sean.j.christopherson@intel.com> wrote:
> > >
> > > Check for an unblocked SMI in vmx_check_nested_events() so that pendi=
ng
> > > SMIs are correctly prioritized over IRQs and NMIs when the latter eve=
nts
> > > will trigger VM-Exit.  This also fixes an issue where an SMI that was
> > > marked pending while processing a nested VM-Enter wouldn't trigger an
> > > immediate exit, i.e. would be incorrectly delayed until L2 happened t=
o
> > > take a VM-Exit.
> > >
> > > Fixes: 64d6067057d96 ("KVM: x86: stubs for SMM support")
> > > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > > ---
> > >  arch/x86/kvm/vmx/nested.c | 6 ++++++
> > >  1 file changed, 6 insertions(+)
> > >
> > > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > > index 1fdaca5fd93d..8c16b190816b 100644
> > > --- a/arch/x86/kvm/vmx/nested.c
> > > +++ b/arch/x86/kvm/vmx/nested.c
> > > @@ -3750,6 +3750,12 @@ static int vmx_check_nested_events(struct kvm_=
vcpu *vcpu)
> > >                 return 0;
> > >         }
> > >
> > > +       if (vcpu->arch.smi_pending && !is_smm(vcpu)) {
> > > +               if (block_nested_events)
> > > +                       return -EBUSY;
> > > +               goto no_vmexit;
> > > +       }
> > > +
> >
> > From the SDM, volume 3:
> >
> > =E2=80=A2 System-management interrupts (SMIs), INIT signals, and higher
> > priority events take priority over MTF VM exits.
> >
> > I think this block needs to be moved up.
>
> Hrm.  It definitely needs to be moved above the preemption timer, though =
I
> can't find any public documentation about the preemption timer's priority=
.
> Preemption timer is lower priority than MTF, ergo it's not in the same
> class as SMI.
>
> Regarding SMI vs. MTF and #DB trap, to actually prioritize SMIs above MTF
> and #DBs, we'd need to save/restore MTF and pending #DBs via SMRAM.  I
> think it makes sense to take the easy road and keep SMI after the traps,
> with a comment to say it's technically wrong but not worth fixing.

Pending debug exceptions should just go in the pending debug
exceptions field. End of story and end of complications. I don't
understand why kvm is so averse to using this field the way it was
intended.

As for the MTF, section 34.14.1 of the SDM, volume 3, clearly states:

The pseudocode above makes reference to the saving of VMX-critical
state. This state consists of the following:
(1) SS.DPL (the current privilege level); (2) RFLAGS.VM; (3) the state
of blocking by STI and by MOV SS (see
Table 24-3 in Section 24.4.2); (4) the state of virtual-NMI blocking
(only if the processor is in VMX non-root oper-
ation and the =E2=80=9Cvirtual NMIs=E2=80=9D VM-execution control is 1); an=
d (5) an
indication of whether an MTF VM exit is pending
(see Section 25.5.2). These data may be saved internal to the
processor or in the VMCS region of the current
VMCS. Processors that do not support SMI recognition while there is
blocking by STI or by MOV SS need not save
the state of such blocking.

I haven't really looked at kvm's implementation of SMM (because Google
doesn't support it), but it seems that the "MTF VM exit is pending"
bit should be trivial to deal with. I assume we save the other
VMX-critical state somewhere!
