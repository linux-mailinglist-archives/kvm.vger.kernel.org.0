Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01A212C1BF0
	for <lists+kvm@lfdr.de>; Tue, 24 Nov 2020 04:21:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727040AbgKXDTP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Nov 2020 22:19:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726876AbgKXDTO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Nov 2020 22:19:14 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84368C0613CF
        for <kvm@vger.kernel.org>; Mon, 23 Nov 2020 19:19:14 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id w202so1254620pff.10
        for <kvm@vger.kernel.org>; Mon, 23 Nov 2020 19:19:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Zn39WbDQ+qXSvcpBYHEIUD3zA5kO0rxJETNg54llGKE=;
        b=W1b6QVL1b5DmHyFGoY7JlaWeKGGjIUwkLsS2raCuWH0QwxBkXpf6rCRyyHEyz9PDiT
         FefefJn3BBL23yQHCLiCgJ/VcJTr502+FENw5hPIBAE5ZQ29iLV5gE2uRs74Mqsba+QU
         8OrdKjG2UvELTEes+9+n09fBaO1zQNiDrlgJ4UBE0I9KOQHukAcUWV29b4SgNzTsoXQp
         fXoWT8hjxu12n9+7N9l9vghmy+22oe5gXAOFIQPZv8y28Srma9rTN6uFKm4/DGEOj8FV
         U1LlJad5GVKhXewyNHrDK5L276Ldl5y5IICFwKbsUYw+gJN6H/ZZ6P3G4Q1TD+p1ht+l
         mslQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Zn39WbDQ+qXSvcpBYHEIUD3zA5kO0rxJETNg54llGKE=;
        b=NX2Mq6w7av3XSk2pJYOI+tBXydu33OX8pP3GNjTkTRTfzhDyd5uEqqqkVR9zlamFZz
         2+7SjIZ+A3mX+Dj9mHf0m21INqoqedZm071DlnqPfUZA094FOxlr+cMNcPPbOFMw6muP
         UcOFTh7YosofZHoC6vsW/ossoWFgr0CMQUk0RSY1HW6di7IzgpL/iOZiqRoADNeousHv
         T4wyGRejIcg15Mq8qOD+Cs1igjxgf84bORXrCnBax9AGbtskylAUUVKnrEd0AuSZS+e4
         0YQmtMVczMXYUlLP/InYk2ghs2yRvmg9ncOcjhEx0hWGSGza20g5JfFBsUnXsrs9a8fs
         WmyQ==
X-Gm-Message-State: AOAM530kmLBuCsB530k8IUe2uIzy74Ol21kBbItFP/+VhAuxxt6AlCNH
        z22pwrNbhoBe8U2VNrHIVCm/ZVtmoLz2kA==
X-Google-Smtp-Source: ABdhPJzexCRcV3VMQDy6ubTSUzJvBw3z5k6iVCcwRdJme9ZFSi6PYN/oQZVzC/VHUcTSTNRbyhbWdw==
X-Received: by 2002:a17:90a:4410:: with SMTP id s16mr2453696pjg.159.1606187953944;
        Mon, 23 Nov 2020 19:19:13 -0800 (PST)
Received: from google.com (242.67.247.35.bc.googleusercontent.com. [35.247.67.242])
        by smtp.gmail.com with ESMTPSA id w66sm12976446pfb.48.2020.11.23.19.19.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2020 19:19:13 -0800 (PST)
Date:   Tue, 24 Nov 2020 03:19:09 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Oliver Upton <oupton@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, idan.brown@oracle.com,
        Jim Mattson <jmattson@google.com>,
        kvm list <kvm@vger.kernel.org>, liam.merwick@oracle.com,
        wanpeng.li@hotmail.com
Subject: Re: [PATCH v3 11/11] KVM: nVMX: Wake L2 from HLT when nested
 posted-interrupt pending
Message-ID: <20201124031909.GA103400@google.com>
References: <95b9b017-ccde-97a0-f407-fd5f35f1157d@redhat.com>
 <20201123192223.3177490-1-oupton@google.com>
 <4788d64f-1831-9eb9-2c78-c5d9934fb47b@redhat.com>
 <CAOQ_QsiUAVob+3hnAURJF-1+GdRF9HMtuxpKWCB-3m-abRGqxw@mail.gmail.com>
 <CAOQ_QshMoc9W9g6XRuGM4hCtMdvUxSDpGAhp3vNxhxhWTK-5CQ@mail.gmail.com>
 <20201124015515.GA75780@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201124015515.GA75780@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 24, 2020 at 01:55:15AM +0000, Sean Christopherson wrote:
> On Mon, Nov 23, 2020 at 04:13:49PM -0800, Oliver Upton wrote:
> > On Mon, Nov 23, 2020 at 4:10 PM Oliver Upton <oupton@google.com> wrote:
> > >
> > > On Mon, Nov 23, 2020 at 2:42 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
> > > >
> > > > On 23/11/20 20:22, Oliver Upton wrote:
> > > > > The pi_pending bit works rather well as it is only a hint to KVM that it
> > > > > may owe the guest a posted-interrupt completion. However, if we were to
> > > > > set the guest's nested PINV as pending in the L1 IRR it'd be challenging
> > > > > to infer whether or not it should actually be injected in L1 or result
> > > > > in posted-interrupt processing for L2.
> > > >
> > > > Stupid question: why does it matter?  The behavior when the PINV is
> > > > delivered does not depend on the time it enters the IRR, only on the
> > > > time that it enters ISR.  If that happens while the vCPU while in L2, it
> > > > would trigger posted interrupt processing; if PINV moves to ISR while in
> > > > L1, it would be delivered normally as an interrupt.
> > > >
> > > > There are various special cases but they should fall in place.  For
> > > > example, if PINV is delivered during L1 vmentry (with IF=0), it would be
> > > > delivered at the next inject_pending_event when the VMRUN vmexit is
> > > > processed and interrupts are unmasked.
> > > >
> > > > The tricky case is when L0 tries to deliver the PINV to L1 as a posted
> > > > interrupt, i.e. in vmx_deliver_nested_posted_interrupt.  Then the
> > > >
> > > >                  if (!kvm_vcpu_trigger_posted_interrupt(vcpu, true))
> > > >                          kvm_vcpu_kick(vcpu);
> > > >
> > > > needs a tweak to fall back to setting the PINV in L1's IRR:
> > > >
> > > >                  if (!kvm_vcpu_trigger_posted_interrupt(vcpu, true)) {
> > > >                          /* set PINV in L1's IRR */
> > > >                         kvm_vcpu_kick(vcpu);
> > > >                 }
> > >
> > > Yeah, I think that's fair. Regardless, the pi_pending bit should've
> > > only been set if the IPI was actually sent. Though I suppose
> > 
> > Didn't finish my thought :-/
> > 
> > Though I suppose pi_pending was set unconditionally (and skipped the
> > IRR) since until recently KVM completely bungled handling the PINV
> > correctly when in the L1 IRR.
> > 
> > >
> > > > but you also have to do the same *in the PINV handler*
> > > > sysvec_kvm_posted_intr_nested_ipi too, to handle the case where the
> > > > L2->L0 vmexit races against sending the IPI.
> > >
> > > Indeed, there is a race but are we assured that the target vCPU thread
> > > is scheduled on the target CPU when that IPI arrives?
> > >
> > > I believe there is a 1-to-many relationship here, which is why I said
> > > each CPU would need to maintain a linked list of possible vCPUs to
> > > iterate and find the intended recipient.
> 
> Ya, the concern is that it's theoretically possible for the PINV to arrive in L0
> after a different vCPU has been loaded (or even multiple different vCPUs).      
> E.g. if the sending pCPU is hit with an NMI after checking vcpu->mode, and the  
> NMI runs for some absurd amount of time.  If that happens, the PINV handler     
> won't know which vCPU(s) should get an IRQ injected into L1 without additional  
> tracking.  KVM would need to set something like nested.pi_pending before doing  
> kvm_vcpu_trigger_posted_interrupt(), i.e. nothing really changes, it just gets  
> more complex.

If we do want to do something fancy with the L0 PINV handler, I think we could
avoid a list by having the dest vCPU busy wait before exiting guest_mode if
there is one or more PINV IPIs that are in the process of being sent, and then
wait again in vcpu_put() for the PINV to be handled.  The latter in particular
would rarely come into play, i.e. shouldn't impact performance.  That would
prevent having a somewhat unbounded et of vCPUs that may or may not have an
oustanding PINV.
