Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 212DB2C8DCC
	for <lists+kvm@lfdr.de>; Mon, 30 Nov 2020 20:16:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388210AbgK3TPu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Nov 2020 14:15:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729309AbgK3TPp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Nov 2020 14:15:45 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00282C0613D4
        for <kvm@vger.kernel.org>; Mon, 30 Nov 2020 11:15:04 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id s21so11020116pfu.13
        for <kvm@vger.kernel.org>; Mon, 30 Nov 2020 11:15:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=K6XZp2sQ8VNUzbAOEM0HgRmGllfj9pHRSlo82ijk8y4=;
        b=tPMLC2WL6lx9xX1w+XddThEet+mfR4/8ih2NGfz2XUCaq3ZEsvjZGs9cqnnj4vPZJk
         km6Q4WZP5OYH/cQmoOM93WrtBVZlzf7Q3rMROmJC6ky/X798lvIexeO2DLWE/jWBcult
         v0+YRKe5l63/RPYBXUgP5HLmZFA0ltd2rOai/DDiNn9No+3dcQWKdHeEasAqy2KLReP2
         IpcqrFle41ZbUMnWYIuRSY7/ZQhkFicFeeLE6qR4Yx41jBzJU6X1KG6DeI30rsrcCbIU
         ChHYE5In6d7g97CLg1cm4CgcWq2Y+htSY0xPq+E90pNdGQ4ETL8+wvu6lPp8Ct+fAqXG
         wN/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=K6XZp2sQ8VNUzbAOEM0HgRmGllfj9pHRSlo82ijk8y4=;
        b=XjcgjDx7nHLYcbyHPr2RzhSztDzjmgWQCicdF/gW9xDQjHviCT6C+7AhoLC6iooChP
         iPhzIpDg/lnVCMbpNvUcYQ5fiRbaM25FfGgB7zFRNoj2OMorl3NtPo7UpM4LwRPI7wBn
         wi/6q53NMDuG3/0eIl6SPxtUZT9Esr0cNtBCC3qOczUOYIsBRb9+JAadT0/m8UarG7CI
         TwymyzMqv5cMFgdfBB9jO9UjQX4uC1offZmfAcnUV6KJTYIHGETNVz2L+lQljr31oz3W
         FaprvpV9xsq8DPmrgd0+6c5luznfThZGNU3/vs/1ulZx0CrUjdcw4HThD825vbIDs6TC
         To6w==
X-Gm-Message-State: AOAM531OR7tLKXHYvyXnl6LqVL4lYDITYHp0OBdFzQHSC/9ypcMI3BFr
        B4IXhTG49yWddvStWhS1XsWL4g==
X-Google-Smtp-Source: ABdhPJxNrazF7z34bVRnYrVzop7VItyISAImK7DNZPMz2Av+UnTe9nuECwHuBvUTpbYspP42yKqQYw==
X-Received: by 2002:aa7:96ba:0:b029:197:e733:ae3c with SMTP id g26-20020aa796ba0000b0290197e733ae3cmr20132504pfk.46.1606763704331;
        Mon, 30 Nov 2020 11:15:04 -0800 (PST)
Received: from google.com (242.67.247.35.bc.googleusercontent.com. [35.247.67.242])
        by smtp.gmail.com with ESMTPSA id j10sm17415989pgc.85.2020.11.30.11.15.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Nov 2020 11:15:03 -0800 (PST)
Date:   Mon, 30 Nov 2020 19:14:59 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Oliver Upton <oupton@google.com>,
        Jim Mattson <jmattson@google.com>,
        kvm list <kvm@vger.kernel.org>, liam.merwick@oracle.com,
        wanpeng.li@hotmail.com
Subject: Re: [PATCH v3 11/11] KVM: nVMX: Wake L2 from HLT when nested
 posted-interrupt pending
Message-ID: <X8VEsw4ENJ3MH+3o@google.com>
References: <CAOQ_QsiUAVob+3hnAURJF-1+GdRF9HMtuxpKWCB-3m-abRGqxw@mail.gmail.com>
 <CAOQ_QshMoc9W9g6XRuGM4hCtMdvUxSDpGAhp3vNxhxhWTK-5CQ@mail.gmail.com>
 <20201124015515.GA75780@google.com>
 <e140ed23-df91-5da2-965a-e92b4a54e54e@redhat.com>
 <20201124212215.GA246319@google.com>
 <d5f4153b-975d-e61d-79e8-ed86df346953@redhat.com>
 <20201125011416.GA282994@google.com>
 <13e802d5-858c-df0a-d93f-ffebb444eca1@redhat.com>
 <20201125183236.GB400789@google.com>
 <89fe1772-36c7-7338-69aa-25d84a9febe8@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <89fe1772-36c7-7338-69aa-25d84a9febe8@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 26, 2020, Paolo Bonzini wrote:
> On 25/11/20 19:32, Sean Christopherson wrote:
> > I'm pretty sure the exiting vCPU needs to wait
> > for all senders to finish their sequence, otherwise pi_pending could be left
> > set, but spinning on pi_pending is wrong.
> 
> What if you set it before?

That doesn't help.  nested.pi_pending will be left set, with a valid vIRQ in the
PID, after vmx_vcpu_run() if kvm_vcpu_trigger_posted_interrupt() succeeds but
the PINV is delivered in the host.

Side topic, for the "wait" sequence to work, vmx_vcpu_run() would need to do
kvm_vcpu_exiting_guest_mode() prior to waiting for senders to completely their
sequence.

> 
> static int vmx_deliver_nested_posted_interrupt(struct kvm_vcpu *vcpu,
> 						int vector)
> {
> 	struct vcpu_vmx *vmx = to_vmx(vcpu);
> 
> 	if (is_guest_mode(vcpu) &&
> 	    vector == vmx->nested.posted_intr_nv) {
> 		/*
> 		 * Set pi_pending after ON.
> 		 */
> 		smp_store_release(&vmx->nested.pi_pending, true);
> 		if (!kvm_vcpu_trigger_posted_interrupt(vcpu, true)) {
> 			/*
> 			 * The guest was not running, let's try again
> 			 * on the next vmentry.
> 			 */
> 			<set PINV in L1 vIRR>
> 			kvm_make_request(KVM_REQ_EVENT, vcpu);
> 			kvm_vcpu_kick(vcpu);
> 			vmx->nested.pi_pending = false;
> 		}
> 		write_seqcount_end(&vmx->nested.pi_pending_sc);
> 		return 0;
> 	}
> 	return -1;
> }
> 
> On top of this:
> 
> - kvm_x86_ops.hwapic_irr_update can be deleted.  It is already done
> unconditionally by vmx_sync_pir_to_irr before every vmentry.  This gives
> more freedom in changing vmx_sync_pir_to_irr and vmx_hwapic_irr_update.

And would lower the barrier of entry for understanding this code :-)

> - VCPU entry must check if max_irr == vmx->nested.posted_intr_nv, and if so
> send a POSTED_INTR_NESTED_VECTOR self-IPI.

Hmm, there's also this snippet in vmx_sync_pir_to_irr() that needs to be dealt
with.  If the new max_irr in this case is the nested PI vector, KVM will bail
from the run loop instead of continuing on. 

	/*
	 * If we are running L2 and L1 has a new pending interrupt
	 * which can be injected, we should re-evaluate
	 * what should be done with this new L1 interrupt.
	 * If L1 intercepts external-interrupts, we should
	 * exit from L2 to L1. Otherwise, interrupt should be
	 * delivered directly to L2.
	 */
	if (is_guest_mode(vcpu) && max_irr_updated) {
		if (nested_exit_on_intr(vcpu))
			kvm_vcpu_exiting_guest_mode(vcpu);
		else
			kvm_make_request(KVM_REQ_EVENT, vcpu);
	}

> Combining both (and considering that AMD doesn't do anything interesting in
> vmx_sync_pir_to_irr), I would move the whole call to vmx_sync_pir_to_irr
> from x86.c to vmx/vmx.c, so that we know that vmx_hwapic_irr_update is
> called with interrupts disabled and right before vmentry:
> 
>  static int vmx_sync_pir_to_irr(struct kvm_vcpu *vcpu)
>  {
> 	...
> -	vmx_hwapic_irr_update(vcpu, max_irr);
>         return max_irr;
>  }
> 
> -static void vmx_hwapic_irr_update(struct kvm_vcpu *vcpu, int max_irr)
> +static void vmx_hwapic_irr_update(struct kvm_vcpu *vcpu)

I would also vote to rename this helper; not sure what to call it, but for me
the current name doesn't help understand its purpose.

>  {
> +	int max_irr;
> +
> +	WARN_ON(!irqs_disabled());
> +	max_irr = vmx_sync_pir_to_irr(vcpu);
>         if (!is_guest_mode(vcpu))
>                 vmx_set_rvi(max_irr);
> +	else if (max_irr == vmx->nested.posted_intr_nv) {
> +		...
> +	}
>  }
> 
> and in vmx_vcpu_run:
> 
> +	if (kvm_lapic_enabled(vcpu) && vcpu->arch.apicv_active)
> +		vmx_hwapic_irr_update(vcpu);

And also drop the direct call to vmx_sync_pir_to_irr() in the fastpath exit.

> If you agree, feel free to send this (without the else of course) as a
> separate cleanup patch immediately.

Without what "else"?
