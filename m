Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 249A82C47AD
	for <lists+kvm@lfdr.de>; Wed, 25 Nov 2020 19:33:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732990AbgKYScm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Nov 2020 13:32:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732785AbgKYScm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Nov 2020 13:32:42 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 061B7C0613D4
        for <kvm@vger.kernel.org>; Wed, 25 Nov 2020 10:32:42 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id c66so3151293pfa.4
        for <kvm@vger.kernel.org>; Wed, 25 Nov 2020 10:32:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=63uvHe2kamjwA5G90k81jFF74Do6pDRI4Gbwa8CquV0=;
        b=RJoyTYxHuacEhVMQ3x+/kbZQWsIH5lNsJZSr6JqwzQv2Ip/CspXSfNuJNXzNHoIcKW
         hgPNIHjW/6yvtXC4IWSDgHUCMj6UFhtHRkAdGO0qCxekgj62mV1Zyl+qjLsvYgQ0CrrB
         mUVoHIecv52jePSiwWQkpVU9onGQpfyVXkWf4o+PqK4C+MAZKrZKqQLEZWbRvvHX7p3w
         Nz71fFojvAgQA/NaQ0LWlqowojRFHBXTiifvBDqi5LxKDt862aBnKJXClSRCeaPU04u9
         dOhZ4/3AFRppdld5jXiszCM5hGT35XmTbWB6csYP6ZBPGDmZnFqfqLLrcl35QYIhADhf
         aZyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=63uvHe2kamjwA5G90k81jFF74Do6pDRI4Gbwa8CquV0=;
        b=Y/C8bnFSKOMz5vWgSVFduOOurGj7hdf8regwWQyjtC+E0nwAh+4lEjg1A+ftzLTb4x
         gAk4SQ808sMPLvcjI771SykPFscRtNe4vfjavE5K0sUbcRZ6/kKczUxL8qHWEbd05Mmv
         J+LO0TTFrQBM9OigP6hNyFzaVq2NWzOQfZnA+NqWc+Zq6XIypDqPlNiyji2UD6XhuS2w
         3ShcanXcvfvq1mTGs28G6eZcEzyqxmc5bKlIO1k2btP4HunG/CDVuZIZWhTsnHJ4wr7T
         vsciAXMaIGq+CWLI+k4d1Gd6duEMkYFqk+PYJnYOnAPyj5rHriJg33KVK2470Wcm/8ZX
         0gXA==
X-Gm-Message-State: AOAM530bBdhwMcLUsEAAimKiOkyoAUjEEExoPf+wsH1MBmUd0mLeZfcr
        7ssZZ63CJO4IiH+ugQJd8kLCkg==
X-Google-Smtp-Source: ABdhPJxBsOCge7t1I0hDYz5Eyaf9WQSazGaSSBxbA+VgrDu2pGgHjHz2CojgxRYXXbP9wD/v78uRUA==
X-Received: by 2002:a17:90a:62c8:: with SMTP id k8mr5801157pjs.33.1606329161468;
        Wed, 25 Nov 2020 10:32:41 -0800 (PST)
Received: from google.com (242.67.247.35.bc.googleusercontent.com. [35.247.67.242])
        by smtp.gmail.com with ESMTPSA id 12sm4082179pjt.25.2020.11.25.10.32.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2020 10:32:40 -0800 (PST)
Date:   Wed, 25 Nov 2020 18:32:36 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Oliver Upton <oupton@google.com>,
        Jim Mattson <jmattson@google.com>,
        kvm list <kvm@vger.kernel.org>, liam.merwick@oracle.com,
        wanpeng.li@hotmail.com
Subject: Re: [PATCH v3 11/11] KVM: nVMX: Wake L2 from HLT when nested
 posted-interrupt pending
Message-ID: <20201125183236.GB400789@google.com>
References: <20201123192223.3177490-1-oupton@google.com>
 <4788d64f-1831-9eb9-2c78-c5d9934fb47b@redhat.com>
 <CAOQ_QsiUAVob+3hnAURJF-1+GdRF9HMtuxpKWCB-3m-abRGqxw@mail.gmail.com>
 <CAOQ_QshMoc9W9g6XRuGM4hCtMdvUxSDpGAhp3vNxhxhWTK-5CQ@mail.gmail.com>
 <20201124015515.GA75780@google.com>
 <e140ed23-df91-5da2-965a-e92b4a54e54e@redhat.com>
 <20201124212215.GA246319@google.com>
 <d5f4153b-975d-e61d-79e8-ed86df346953@redhat.com>
 <20201125011416.GA282994@google.com>
 <13e802d5-858c-df0a-d93f-ffebb444eca1@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <13e802d5-858c-df0a-d93f-ffebb444eca1@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

-Idan to stop getting bounces.

On Wed, Nov 25, 2020, Paolo Bonzini wrote:
> On 25/11/20 02:14, Sean Christopherson wrote:
> > > The flag
> > > would not have to live past vmx_vcpu_run even, the vIRR[PINV] bit would be
> > > the primary marker that a nested posted interrupt is pending.
> > 
> > 	while (READ_ONCE(vmx->nested.pi_pending) && PID.ON) {
> > 		vmx->nested.pi_pending = false;
> > 		vIRR.PINV = 1;
> > 	}
> > 
> > would incorrectly set vIRR.PINV in the case where hardware handled the PI, and
> > that could result in L1 seeing the interrupt if a nested exit occured before KVM
> > processed vIRR.PINV for L2.  Note, without PID.ON, the behavior would be really
> > bad as KVM would set vIRR.PINV *every* time hardware handled the PINV.
> 
> It doesn't have to be a while loop, since by the time we get here vcpu->mode
> is not IN_GUEST_MODE anymore.

Hrm, bad loop logic on my part.  I'm pretty sure the exiting vCPU needs to wait
for all senders to finish their sequence, otherwise pi_pending could be left
set, but spinning on pi_pending is wrong.  Your generation counter thing may
also work, but that made my brain hurt too much to work through the logic. :-)

Something like this?

static int vmx_deliver_nested_posted_interrupt(struct kvm_vcpu *vcpu,
						int vector)
{
	struct vcpu_vmx *vmx = to_vmx(vcpu);

	if (is_guest_mode(vcpu) &&
	    vector == vmx->nested.posted_intr_nv) {
		/* Write a comment. */
		vmx->nested.pi_sending_count++;
		smp_wmb();
		if (kvm_vcpu_trigger_posted_interrupt(vcpu, true)) {
			vmx->nested.pi_pending = true;
		} else {
			<set PINV in L1 vIRR>
			kvm_make_request(KVM_REQ_EVENT, vcpu);
			kvm_vcpu_kick(vcpu);
		}
		smp_wmb();
		vmx->nested.pi_sending_count--;
		return 0;
	}
	return -1;
}

static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
{
	...

	/* The actual VMENTER/EXIT is in the .noinstr.text section. */
	vmx_vcpu_enter_exit(vcpu, vmx);

	...

	if (is_guest_mode(vcpu) {
		while (READ_ONCE(vmx->nested.pi_sending_count));

		vmx_complete_nested_posted_interrupt(vcpu);
	}

	...
}

> To avoid the double PINV delivery, we could process the PID as in
> vmx_complete_nested_posted_interrupt in this particular case---but
> vmx_complete_nested_posted_interrupt would be moved from vmentry to vmexit,
> and the common case would use vIRR.PINV instead.  There would still be double
> processing, but it would solve the migration problem in a relatively elegant
> manner.

I like this idea, a lot.  I'm a-ok with KVM processing more PIRs than the
SDM may or may not technically allow.

Jim, any objections?
