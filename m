Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ABBA2C1B15
	for <lists+kvm@lfdr.de>; Tue, 24 Nov 2020 02:55:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726676AbgKXBzV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Nov 2020 20:55:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726260AbgKXBzV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Nov 2020 20:55:21 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A722C0613CF
        for <kvm@vger.kernel.org>; Mon, 23 Nov 2020 17:55:20 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id v12so16836099pfm.13
        for <kvm@vger.kernel.org>; Mon, 23 Nov 2020 17:55:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=72ZyMT7kx57XiIZ/zDGMiddfA3XAk3OElfzcoKA9byY=;
        b=crFdODq4AEIJbVdXVB3886wwFfja0DeEAt7kHB+gqi4pALnXB94h1wrg1Kl0grZW8O
         WALsqayoUrtd65AhnDnYKa6fpqJXzM63XmCPV2mv0QMryTX28dbAkS1mXWCxsfEfSA+H
         os3VHR16ViQ1tKu1hUeDSWWPSLSzghi0u7rvlX1ozCpuaSyjEPxuOWVqtLmxOnuJFMzI
         UPLojo/AYQdMQo8LGxxyXR19wanSNhRGiCG0kS++OMx3dqxof18gwR8C8uNeTJswJtWb
         Y2Lk3MO/OFBWIy+0SOAbhkieNxrnhtI2pdqfwc2GSGQUVblTUdE8KXEPbR695euKV6fj
         lTtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=72ZyMT7kx57XiIZ/zDGMiddfA3XAk3OElfzcoKA9byY=;
        b=gc3BoMBzOLOjSMQkvuvjix+FMXs8GJxJGjgUP52TtjWIkpkm10kOZjOlzddyEaLfQm
         Ow8NYq3scyLrHcUAvC1zB/poH/CCn5tTVEwuy+dKY/1MEoGEl6IohR5/xAVk+VB0y+Mk
         IxPCL04QoXYKKJS93Bu7N38EtAdySoBPQUH5WSOAyRkiMqnwYjiNvLlrbUStekXDIESD
         hODyhLFSDmpqdonYILrQCFAmOmgDOkvW6hRUGIgo+C1sK3KiiTTTM9ih1WBaEq++u/Df
         v3H4XG0CYz1F9HpP8EqEDQAjpIiJ6Nmc0uTQjp9oXpz+OGYTh8uLeUFetJO0+ShPnXou
         r2uA==
X-Gm-Message-State: AOAM531Tc7CmWiI5mWuRlZqZu30Rmi9jRfcA0b7WGb9lHqKjtftVoi1H
        vQIXmX159d8QIz2vVNDtQVN9mA==
X-Google-Smtp-Source: ABdhPJzSLufnByDx0TLrSFfiJJ5W3BhgT+BjJ71YttX3pugM+MqFG626d6PXp9hFNRQ4i7IcWEfYSQ==
X-Received: by 2002:a17:90a:aa13:: with SMTP id k19mr2095783pjq.145.1606182919429;
        Mon, 23 Nov 2020 17:55:19 -0800 (PST)
Received: from google.com (242.67.247.35.bc.googleusercontent.com. [35.247.67.242])
        by smtp.gmail.com with ESMTPSA id t9sm656750pjo.4.2020.11.23.17.55.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2020 17:55:18 -0800 (PST)
Date:   Tue, 24 Nov 2020 01:55:15 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Oliver Upton <oupton@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, idan.brown@oracle.com,
        Jim Mattson <jmattson@google.com>,
        kvm list <kvm@vger.kernel.org>, liam.merwick@oracle.com,
        wanpeng.li@hotmail.com
Subject: Re: [PATCH v3 11/11] KVM: nVMX: Wake L2 from HLT when nested
 posted-interrupt pending
Message-ID: <20201124015515.GA75780@google.com>
References: <95b9b017-ccde-97a0-f407-fd5f35f1157d@redhat.com>
 <20201123192223.3177490-1-oupton@google.com>
 <4788d64f-1831-9eb9-2c78-c5d9934fb47b@redhat.com>
 <CAOQ_QsiUAVob+3hnAURJF-1+GdRF9HMtuxpKWCB-3m-abRGqxw@mail.gmail.com>
 <CAOQ_QshMoc9W9g6XRuGM4hCtMdvUxSDpGAhp3vNxhxhWTK-5CQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ_QshMoc9W9g6XRuGM4hCtMdvUxSDpGAhp3vNxhxhWTK-5CQ@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 23, 2020 at 04:13:49PM -0800, Oliver Upton wrote:
> On Mon, Nov 23, 2020 at 4:10 PM Oliver Upton <oupton@google.com> wrote:
> >
> > On Mon, Nov 23, 2020 at 2:42 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
> > >
> > > On 23/11/20 20:22, Oliver Upton wrote:
> > > > The pi_pending bit works rather well as it is only a hint to KVM that it
> > > > may owe the guest a posted-interrupt completion. However, if we were to
> > > > set the guest's nested PINV as pending in the L1 IRR it'd be challenging
> > > > to infer whether or not it should actually be injected in L1 or result
> > > > in posted-interrupt processing for L2.
> > >
> > > Stupid question: why does it matter?  The behavior when the PINV is
> > > delivered does not depend on the time it enters the IRR, only on the
> > > time that it enters ISR.  If that happens while the vCPU while in L2, it
> > > would trigger posted interrupt processing; if PINV moves to ISR while in
> > > L1, it would be delivered normally as an interrupt.
> > >
> > > There are various special cases but they should fall in place.  For
> > > example, if PINV is delivered during L1 vmentry (with IF=0), it would be
> > > delivered at the next inject_pending_event when the VMRUN vmexit is
> > > processed and interrupts are unmasked.
> > >
> > > The tricky case is when L0 tries to deliver the PINV to L1 as a posted
> > > interrupt, i.e. in vmx_deliver_nested_posted_interrupt.  Then the
> > >
> > >                  if (!kvm_vcpu_trigger_posted_interrupt(vcpu, true))
> > >                          kvm_vcpu_kick(vcpu);
> > >
> > > needs a tweak to fall back to setting the PINV in L1's IRR:
> > >
> > >                  if (!kvm_vcpu_trigger_posted_interrupt(vcpu, true)) {
> > >                          /* set PINV in L1's IRR */
> > >                         kvm_vcpu_kick(vcpu);
> > >                 }
> >
> > Yeah, I think that's fair. Regardless, the pi_pending bit should've
> > only been set if the IPI was actually sent. Though I suppose
> 
> Didn't finish my thought :-/
> 
> Though I suppose pi_pending was set unconditionally (and skipped the
> IRR) since until recently KVM completely bungled handling the PINV
> correctly when in the L1 IRR.
> 
> >
> > > but you also have to do the same *in the PINV handler*
> > > sysvec_kvm_posted_intr_nested_ipi too, to handle the case where the
> > > L2->L0 vmexit races against sending the IPI.
> >
> > Indeed, there is a race but are we assured that the target vCPU thread
> > is scheduled on the target CPU when that IPI arrives?
> >
> > I believe there is a 1-to-many relationship here, which is why I said
> > each CPU would need to maintain a linked list of possible vCPUs to
> > iterate and find the intended recipient.

Ya, the concern is that it's theoretically possible for the PINV to arrive in L0
after a different vCPU has been loaded (or even multiple different vCPUs).      
E.g. if the sending pCPU is hit with an NMI after checking vcpu->mode, and the  
NMI runs for some absurd amount of time.  If that happens, the PINV handler     
won't know which vCPU(s) should get an IRQ injected into L1 without additional  
tracking.  KVM would need to set something like nested.pi_pending before doing  
kvm_vcpu_trigger_posted_interrupt(), i.e. nothing really changes, it just gets  
more complex.

> > The process of removing vCPUs from the list where we caught the IPI
> > in L0 is quite clear, but it doesn't seem like we could ever know to
> > remove vCPUs from the list when hardware catches that IPI.

It's probably possible by shadowing the PI descriptor, but doing so would likely
wipe out the perf benefits of nested PI.

That being said, if we don't care about strictly adhering to the spec (sorry in
advance Jim), I think we could avoid nested.pi_pending if we're ok with KVM
processing virtual interrupts that technically shouldn't happen, yet.  E.g. if
the L0 PINV handler consumes vIRR bits that were set after the last PI from L1.
KVM already does that with nested.pi_pending, so it might not be the worst idea
in the world since the existing nested PI implementation mostly works.
