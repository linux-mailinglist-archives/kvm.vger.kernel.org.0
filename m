Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60EDB2C3620
	for <lists+kvm@lfdr.de>; Wed, 25 Nov 2020 02:17:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727721AbgKYBOW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Nov 2020 20:14:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725320AbgKYBOV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Nov 2020 20:14:21 -0500
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80839C0613D4
        for <kvm@vger.kernel.org>; Tue, 24 Nov 2020 17:14:21 -0800 (PST)
Received: by mail-pl1-x641.google.com with SMTP id x15so263697pll.2
        for <kvm@vger.kernel.org>; Tue, 24 Nov 2020 17:14:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZwIPyTZNylEoqHQK8hJaFHjDFhsT644VaPLB931mjFI=;
        b=kKI8Jz5FkR5iL62jdMR5oxzvD3aKOLtYjE5OpOk/C5eTpa3WvvR2KKFpj7juQEnP7H
         6pV9N8jo1dl5scnGu50iV522P6YeKe7u+T6EqwBgqmnRFiyM7lM96JBoOKaEX6pXaCPw
         FUTfzX3kBt10BK8Fl/LkMjRQKUx/XtQRjABp4RDNgmEC7YOrIQVHCGzO88UHxsEm6SKd
         didz9vy/hau4eKfpNCMxUqZpEoNipqr6DsFzO9kfGkwlwLTYjPlzcUB0NfelYKim/Xut
         sHKHY6qXBe9JAxj+H81OswOYNb3nIwoyt5KkfTdK64JEq60QemVNf7uw+102Hz7SMLIu
         Yymw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZwIPyTZNylEoqHQK8hJaFHjDFhsT644VaPLB931mjFI=;
        b=LI/lZITUB4OVZpb0LstNOFa9D0Jn0P6cjfROrIcuXiZdvo+u8hU5znoShQ21kP/3WK
         IZIEGeuHXZlzb3eByoz3w50nLuTv6xvxvIgSL1Ty6LRN2XuFoa7uheC6YxHP4wfuFoy3
         SD6LwVFsI4qIWBRna5Tx0/AmaFvs4ZYIqFYZMRFV3Ln0BP9Ug8uABXntWj9DnK3OLk5a
         F8iy99mTDbE8Dr4HyL+OB23lNL12BHlNv/8Igd2MJSDdq+qpj35WihT9qD8zHmhXPPMR
         3RbwjHI03X2Vs4ekRMliX/xo1B7cI93R99S9oevPOzD9sNdLnx1ebQEUhau4NZMysPOE
         vGnQ==
X-Gm-Message-State: AOAM532iXmFU/zkFpoqlVjg7xpNqEwpyuGrQ9l8c86oXUj8SU+y83qFk
        dhYP2MccM4QD9PIaP1A7t6f31w==
X-Google-Smtp-Source: ABdhPJzLIZOs/2ibSvu1xGHWSi95dP7Ut5eWkn/ALUk3qnHVgPJJo1Cfmt164Wbi7jaQyoor9g4CuA==
X-Received: by 2002:a17:902:bf0b:b029:d8:f677:30f2 with SMTP id bi11-20020a170902bf0bb02900d8f67730f2mr366123plb.25.1606266860881;
        Tue, 24 Nov 2020 17:14:20 -0800 (PST)
Received: from google.com (242.67.247.35.bc.googleusercontent.com. [35.247.67.242])
        by smtp.gmail.com with ESMTPSA id y81sm223239pfc.25.2020.11.24.17.14.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2020 17:14:20 -0800 (PST)
Date:   Wed, 25 Nov 2020 01:14:16 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Oliver Upton <oupton@google.com>, idan.brown@oracle.com,
        Jim Mattson <jmattson@google.com>,
        kvm list <kvm@vger.kernel.org>, liam.merwick@oracle.com,
        wanpeng.li@hotmail.com
Subject: Re: [PATCH v3 11/11] KVM: nVMX: Wake L2 from HLT when nested
 posted-interrupt pending
Message-ID: <20201125011416.GA282994@google.com>
References: <95b9b017-ccde-97a0-f407-fd5f35f1157d@redhat.com>
 <20201123192223.3177490-1-oupton@google.com>
 <4788d64f-1831-9eb9-2c78-c5d9934fb47b@redhat.com>
 <CAOQ_QsiUAVob+3hnAURJF-1+GdRF9HMtuxpKWCB-3m-abRGqxw@mail.gmail.com>
 <CAOQ_QshMoc9W9g6XRuGM4hCtMdvUxSDpGAhp3vNxhxhWTK-5CQ@mail.gmail.com>
 <20201124015515.GA75780@google.com>
 <e140ed23-df91-5da2-965a-e92b4a54e54e@redhat.com>
 <20201124212215.GA246319@google.com>
 <d5f4153b-975d-e61d-79e8-ed86df346953@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d5f4153b-975d-e61d-79e8-ed86df346953@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 25, 2020, Paolo Bonzini wrote:
> On 24/11/20 22:22, Sean Christopherson wrote:
> > > What if IN_GUEST_MODE/OUTSIDE_GUEST_MODE was replaced by a
> > > generation count?  Then you reread vcpu->mode after sending the IPI, and
> > > retry if it does not match.
> > The sender will have seen IN_GUEST_MODE and so won't retry the IPI,
> > but hardware didn't process the PINV as a posted-interrupt.
> Uff, of course.
> 
> That said, it may still be a good idea to keep pi_pending only as a very
> short-lived flag only to handle this case, and maybe not even need the
> generation count (late here so put up with me if it's wrong :)).  The flag
> would not have to live past vmx_vcpu_run even, the vIRR[PINV] bit would be
> the primary marker that a nested posted interrupt is pending.

I 100% agree that would be ideal for nested state migration, as it would avoid
polluting the ABI with nested.pi_pending, but the downside is that it would mean
KVM could deliver a physical interrupt twice; once to L2 and once to L1.  E.g.

	while (READ_ONCE(vmx->nested.pi_pending) && PID.ON) {
		vmx->nested.pi_pending = false;
		vIRR.PINV = 1;
	}

would incorrectly set vIRR.PINV in the case where hardware handled the PI, and
that could result in L1 seeing the interrupt if a nested exit occured before KVM
processed vIRR.PINV for L2.  Note, without PID.ON, the behavior would be really
bad as KVM would set vIRR.PINV *every* time hardware handled the PINV.

The current behavior just means KVM is more greedy with respect to processing
PID.PIR than it technically should be.  Not sure if that distinction is worth
carrying nested.pi_pending.

> > > > if we're ok with KVM
> > > > processing virtual interrupts that technically shouldn't happen, yet.  E.g. if
> > > > the L0 PINV handler consumes vIRR bits that were set after the last PI from L1.
> > > 
> > > I actually find it curious that the spec promises posted interrupt
> > > processing to be triggered only by the arrival of the posted interrupt IPI.
> > > Why couldn't the processor in principle snoop for the address of the ON bit
> > > instead, similar to an MWAIT?
> > 
> > It would lead to false positives and missed IRQs.
> 
> Not to missed IRQs---false positives on the monitor would be possible, but
> you would still have to send a posted interrupt IPI.  The weird promise is
> that the PINV interrupt is the _only_ trigger for posted interrupts.

Ah, I misunderstood the original "only".  I suspect the primary reason is that
it would cost uops to do the snoop thing and would be inefficient in practice.
The entire PID is guaranteed to be in a single cache line, and most (all?) flows
will write PIR before ON.  So snooping the PID will detect the PIR write, bounce
the cache line by reading it, burn some uops checking that ON isn't set[*], and
then do ???

[*] The pseudocode in the SDM doesn't actually state that the CPU checks PID.ON,
    it only says it clears PID.ON, i.e. assumes that PID.ON is set.  That seems
    like an SDM bug.

> > > But even without that, I don't think the spec promises that kind of strict
> > > ordering with respect to what goes on in the source.  Even though posted
> > > interrupt processing is atomic with the acknowledgement of the posted
> > > interrupt IPI, the spec only promises that the PINV triggers an _eventual_
> > > scan of PID.PIR when the interrupt controller delivers an unmasked external
> > > interrupt to the destination CPU.  You can still have something like
> > > 
> > > 	set PID.PIR[100]
> > > 	set PID.ON
> > > 					processor starts executing a
> > > 					 very slow instruction...
> > > 	send PINV
> > > 	set PID.PIR[200]
> > > 					acknowledge PINV
> > > 
> > > and then vector 200 would be delivered before vector 100.  Of course with
> > > nested PI the effect would be amplified, but it's possible even on bare
> > > metal.
> > 
> > Jim was concerned that L1 could poll the PID to determine whether or not
> > PID.PIR[200] should be seen in L2.  The whole PIR is copied to the vIRR after
> > PID.ON is cleared the auto-EOI is done, and the read->clear is atomic.  So the
> > above sequence where PINV is acknowledge after PID.PIR[200] is legal, but
> > processing PIR bits that are set after the PIR is observed to be cleared would
> > be illegal.
> 
> That would be another case of the unnecessarily specific promise above.
> 
> > E.g. if L1 did this
> > 
> > 	set PID.PIR[100]
> > 	set PID.ON
> > 	send PINV
> > 	while (PID.PIR)
> > 	set PID.PIR[200]
> > 	set PID.ON
> > 
> > This is the part that is likely impossible to
> > solve without shadowing the PID (which, for the record, I have zero desire to do).
> 
> Neither do I. :)  But technically the SDM doesn't promise reading the whole
> 256 bits at the same time.

Hrm, the wording is poor, but my interpretation of this blurb is that the CPU
somehow has a death grip on the PID cache line while it's reading and clearing
the PIR.

  5. The logical processor performs a logical-OR of PIR into VIRR and clears PIR.
     No other agent can read or write a PIR bit (or group of bits) between the
     time it is read (to determine what to OR into VIRR) and when it is cleared.

> Perhaps that's the only way it can work in
> practice due to the cache coherency protocols, but the SDM only promises
> atomicity of the read and clear of "a single PIR bit (or group of bits)".
> So there's in principle no reason why the target CPU couldn't clear
> PID.PIR[100], and then L1 would sneak in and set PID.PIR[200].
> 
> Paolo
> 
> > It seems extremely unlikely any guest will puke on the above, I can't imagine
> > there's for setting a PID.PIR + PID.ON without triggering PINV, but it's
> > technically bad behavior in KVM.
> > 
> 
