Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D69C2C32A2
	for <lists+kvm@lfdr.de>; Tue, 24 Nov 2020 22:25:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731474AbgKXVWV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Nov 2020 16:22:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731379AbgKXVWV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Nov 2020 16:22:21 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BAEDC0613D6
        for <kvm@vger.kernel.org>; Tue, 24 Nov 2020 13:22:20 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id m9so352521pgb.4
        for <kvm@vger.kernel.org>; Tue, 24 Nov 2020 13:22:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Zmb+XqOf0mV+iQgSGpChH8I038Q55HcLGQee/abV3Vk=;
        b=ueLOeL2tlqWPZB+krVi/SSFHuAVa6cS1tUdGbuXHbbGmNhCiMJem1ahm7yhenhBsDN
         GMTTwkzjFsAXaHBAC/sC4eWzifoiBIT7V5kPesTzdGlcQ2qPu0/uWksdyWheK35+s/NO
         j7QVlR0B4P/G5bqVwg8zEPbsxOHrEe2+H1krLxb98mZYqWplhOMDzWola2tZNVWpgYVE
         0YCmvJrJYc7Gq3muHxzfWKFrLhR9LB8d+n28PO1PtpGZqhR2rPup+8eeWQAZYS/f3ZJx
         Fc47NZJcOObNoLFpagnJT4UMMgIZQuO5TXYDANNjRnQUJDnwybec4zEwXnEZvzyG2dYc
         ZLrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Zmb+XqOf0mV+iQgSGpChH8I038Q55HcLGQee/abV3Vk=;
        b=CYzVdUig0JKhRTElTu1dBijFXy4ooYn3cTmEQB8lrY5ZGv7x1ogQpTE9EF42g9Pevd
         jTT1K4+62TY9Y4X09FNRofjXXGHmThZnxdec3lSNR2pELZXU2U//8E7+aqJFTG6FiT3c
         2rtuA3JWlgmmCq61GZ82hzaKZWnYxWEKBBnRPqkclNBWuDkp4f8JooqJFDCD21Dls0Ev
         Z7Sv6zL/CVBBOq7AW9WyAtn1lSanS8lOnwCkICbP88mFeIymR1a9n7GW0wBL3qsadDcR
         41UjbGCgXL1TpAQ1aqAAX33+jF4sS2FosBnggz2ccdeu66hFqZTrHjJlrWJrwTxxrqc9
         d75w==
X-Gm-Message-State: AOAM531Jpslr/IbFEqr9AmEt6iGly83cN+jotk8ioznaNN4KwamL6Zt0
        f4zTVY8YrXMI/yZsBD3GANIsuA==
X-Google-Smtp-Source: ABdhPJxIMZW0Ad7+1PFz2FQEd5uZz/mkytlCdV7wBCi2uFLdD7svUoyMjtjPqsomGwRg5FBhZIDE3g==
X-Received: by 2002:a63:1445:: with SMTP id 5mr252742pgu.357.1606252939511;
        Tue, 24 Nov 2020 13:22:19 -0800 (PST)
Received: from google.com (242.67.247.35.bc.googleusercontent.com. [35.247.67.242])
        by smtp.gmail.com with ESMTPSA id 17sm16411144pfu.180.2020.11.24.13.22.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2020 13:22:18 -0800 (PST)
Date:   Tue, 24 Nov 2020 21:22:15 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Oliver Upton <oupton@google.com>, idan.brown@oracle.com,
        Jim Mattson <jmattson@google.com>,
        kvm list <kvm@vger.kernel.org>, liam.merwick@oracle.com,
        wanpeng.li@hotmail.com
Subject: Re: [PATCH v3 11/11] KVM: nVMX: Wake L2 from HLT when nested
 posted-interrupt pending
Message-ID: <20201124212215.GA246319@google.com>
References: <95b9b017-ccde-97a0-f407-fd5f35f1157d@redhat.com>
 <20201123192223.3177490-1-oupton@google.com>
 <4788d64f-1831-9eb9-2c78-c5d9934fb47b@redhat.com>
 <CAOQ_QsiUAVob+3hnAURJF-1+GdRF9HMtuxpKWCB-3m-abRGqxw@mail.gmail.com>
 <CAOQ_QshMoc9W9g6XRuGM4hCtMdvUxSDpGAhp3vNxhxhWTK-5CQ@mail.gmail.com>
 <20201124015515.GA75780@google.com>
 <e140ed23-df91-5da2-965a-e92b4a54e54e@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e140ed23-df91-5da2-965a-e92b4a54e54e@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 24, 2020, Paolo Bonzini wrote:
> On 24/11/20 02:55, Sean Christopherson wrote:
> > > > I believe there is a 1-to-many relationship here, which is why I said
> > > > each CPU would need to maintain a linked list of possible vCPUs to
> > > > iterate and find the intended recipient.
> > 
> > Ya, the concern is that it's theoretically possible for the PINV to arrive in L0
> > after a different vCPU has been loaded (or even multiple different vCPUs).
> > E.g. if the sending pCPU is hit with an NMI after checking vcpu->mode, and the
> > NMI runs for some absurd amount of time.  If that happens, the PINV handler
> > won't know which vCPU(s) should get an IRQ injected into L1 without additional
> > tracking.  KVM would need to set something like nested.pi_pending before doing
> > kvm_vcpu_trigger_posted_interrupt(), i.e. nothing really changes, it just gets
> > more complex.
> 
> Ah, gotcha.  What if IN_GUEST_MODE/OUTSIDE_GUEST_MODE was replaced by a
> generation count?  Then you reread vcpu->mode after sending the IPI, and
> retry if it does not match.
> 
> To guarantee atomicity, the OUTSIDE_GUEST_MODE IN_GUEST_MODE
> EXITING_GUEST_MODE READING_SHADOW_PAGE_TABLES values would remain in the
> bottom 2 bits.  That is, the vcpu->mode accesses like
> 
> 	vcpu->mode = IN_GUEST_MODE;
> 
> 	vcpu->mode = OUTSIDE_GUEST_MODE;
> 
> 	smp_store_mb(vcpu->mode, READING_SHADOW_PAGE_TABLES);
> 
> 	smp_store_release(&vcpu->mode, OUTSIDE_GUEST_MODE);
> 
> 	return cmpxchg(&vcpu->mode, IN_GUEST_MODE, EXITING_GUEST_MODE);
> 
> becoming
> 
> 	enum {
> 		OUTSIDE_GUEST_MODE,
> 		IN_GUEST_MODE,
> 		EXITING_GUEST_MODE,
> 		READING_SHADOW_PAGE_TABLES,
> 		GUEST_MODE_MASK = 3,
> 	};
> 
> 	vcpu->mode = (vcpu->mode | GUEST_MODE_MASK) + 1 + IN_GUEST_MODE;
> 
> 	vcpu->mode &= ~GUEST_MODE_MASK;
> 
> 	smp_store_mb(vcpu->mode, vcpu->mode|READING_SHADOW_PAGE_TABLES);
> 
> 	smp_store_release(&vcpu->mode, vcpu->mode & ~GUEST_MODE_MASK);
> 
> 	int x = READ_ONCE(vcpu->mode);
> 	do {
> 		if ((x & GUEST_MODE_MASK) != IN_GUEST_MODE)
> 			return x & GUEST_MODE_MASK;
> 	} while (!try_cmpxchg(&vcpu->mode, &x,
> 			      x ^ IN_GUEST_MODE ^ EXITING_GUEST_MODE))
> 	return IN_GUEST_MODE;
> 
> You could still get spurious posted interrupt IPIs, but the IPI handler need
> not do anything at all and that is much better.

This doesn't handle the case where the PINV arrives in L0 after VM-Exit but
before the vCPU clears IN_GUEST_MODE.  The sender will have seen IN_GUEST_MODE
and so won't retry the IPI, but hardware didn't process the PINV as a
posted-interrupt.  I.e. the L0 PINV handler still needs an indicator a la
nested.pi_pending to know that it should stuff an IRQ into L1's vIRR.

> > if we're ok with KVM
> > processing virtual interrupts that technically shouldn't happen, yet.  E.g. if
> > the L0 PINV handler consumes vIRR bits that were set after the last PI from L1.
> 
> I actually find it curious that the spec promises posted interrupt
> processing to be triggered only by the arrival of the posted interrupt IPI.
> Why couldn't the processor in principle snoop for the address of the ON bit
> instead, similar to an MWAIT?

It would lead to false positives and missed IRQs.  PI processing would fire on
writing the PI _cache line_, not just on writes to PI.ON.  I suspect MONITOR is
also triggered on request-for-EXLUSIVE and not just writes, i.e. on speculative
behavior, but I forget if that's actually the case.

Regardless, a write to any part of the PI would trip the monitoring, and then
all subsequent writes would be missed, e.g. other package writes PI.IRR then
PI.ON, CPU PI processing triggers on the PI.IRR write but not PI.ON write.  The
target CPU (the running vCPU) would have to constantly rearm the monitor, but
even then there would always be a window where a write would get missed.

> But even without that, I don't think the spec promises that kind of strict
> ordering with respect to what goes on in the source.  Even though posted
> interrupt processing is atomic with the acknowledgement of the posted
> interrupt IPI, the spec only promises that the PINV triggers an _eventual_
> scan of PID.PIR when the interrupt controller delivers an unmasked external
> interrupt to the destination CPU.  You can still have something like
> 
> 	set PID.PIR[100]
> 	set PID.ON
> 					processor starts executing a
> 					 very slow instruction...
> 	send PINV
> 	set PID.PIR[200]
> 					acknowledge PINV
> 
> and then vector 200 would be delivered before vector 100.  Of course with
> nested PI the effect would be amplified, but it's possible even on bare
> metal.

Jim was concerned that L1 could poll the PID to determine whether or not
PID.PIR[200] should be seen in L2.  The whole PIR is copied to the vIRR after
PID.ON is cleared the auto-EOI is done, and the read->clear is atomic.  So the
above sequence where PINV is acknowledge after PID.PIR[200] is legal, but
processing PIR bits that are set after the PIR is observed to be cleared would
be illegal.  E.g. if L1 did this

	set PID.PIR[100]
	set PID.ON
	send PINV
	while (PID.PIR)
	set PID.PIR[200]
	set PID.ON

then L2 should never observe vector 200.  KVM violates this because
nested.pi_pending is left set even if PINV is handled as a posted interrupt, and
KVM's processing of nested.pi_pending will see the second PID.ON and incorrectly
do PI processing in software.  This is the part that is likely impossible to
solve without shadowing the PID (which, for the record, I have zero desire to do).

It seems extremely unlikely any guest will puke on the above, I can't imagine
there's for setting a PID.PIR + PID.ON without triggering PINV, but it's
technically bad behavior in KVM.
