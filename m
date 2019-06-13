Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C99DD448F0
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2019 19:12:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728909AbfFMRMZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jun 2019 13:12:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41596 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730193AbfFMRMY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jun 2019 13:12:24 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id EF879C1EB1ED;
        Thu, 13 Jun 2019 17:12:23 +0000 (UTC)
Received: from flask (unknown [10.40.205.10])
        by smtp.corp.redhat.com (Postfix) with SMTP id 439BC5D9C6;
        Thu, 13 Jun 2019 17:12:21 +0000 (UTC)
Received: by flask (sSMTP sendmail emulation); Thu, 13 Jun 2019 19:12:20 +0200
Date:   Thu, 13 Jun 2019 19:12:20 +0200
From:   Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Wanpeng Li <wanpengli@tencent.com>
Subject: Re: [PATCH] KVM: x86: clean up conditions for asynchronous page
 fault handling
Message-ID: <20190613171220.GA24873@flask>
References: <1560423812-51166-1-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1560423812-51166-1-git-send-email-pbonzini@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Thu, 13 Jun 2019 17:12:24 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

2019-06-13 13:03+0200, Paolo Bonzini:
> Even when asynchronous page fault is disabled, KVM does not want to pause
> the host if a guest triggers a page fault; instead it will put it into
> an artificial HLT state that allows running other host processes while
> allowing interrupt delivery into the guest.
> 
> However, the way this feature is triggered is a bit confusing.
> First, it is not used for page faults while a nested guest is
> running: but this is not an issue since the artificial halt
> is completely invisible to the guest, either L1 or L2.  Second,
> it is used even if kvm_halt_in_guest() returns true; in this case,
> the guest probably should not pay the additional latency cost of the
> artificial halt, and thus we should handle the page fault in a
> completely synchronous way.

The same reasoning would apply to kvm_mwait_in_guest(), so I would
disable APF with it as well.

> By introducing a new function kvm_can_deliver_async_pf, this patch
> commonizes the code that chooses whether to deliver an async page fault
> (kvm_arch_async_page_not_present) and the code that chooses whether a
> page fault should be handled synchronously (kvm_can_do_async_pf).
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> @@ -9775,6 +9775,36 @@ static int apf_get_user(struct kvm_vcpu *vcpu, u32 *val)
> +bool kvm_can_do_async_pf(struct kvm_vcpu *vcpu)
> +{
> +	if (unlikely(!lapic_in_kernel(vcpu) ||
> +		     kvm_event_needs_reinjection(vcpu) ||
> +		     vcpu->arch.exception.pending))
> +		return false;
> +
> +	if (kvm_hlt_in_guest(vcpu->kvm) && !kvm_can_deliver_async_pf(vcpu))
> +		return false;
> +
> +	/*
> +	 * If interrupts are off we cannot even use an artificial
> +	 * halt state.

Can't we?  The artificial halt state would be canceled by the host page
fault handler.

> +	 */
> +	return kvm_x86_ops->interrupt_allowed(vcpu);
> @@ -9783,19 +9813,26 @@ void kvm_arch_async_page_not_present(struct kvm_vcpu *vcpu,
>  	trace_kvm_async_pf_not_present(work->arch.token, work->gva);
>  	kvm_add_async_pf_gfn(vcpu, work->arch.gfn);
>  
> -	if (!(vcpu->arch.apf.msr_val & KVM_ASYNC_PF_ENABLED) ||
> -	    (vcpu->arch.apf.send_user_only &&
> -	     kvm_x86_ops->get_cpl(vcpu) == 0))
> +	if (!kvm_can_deliver_async_pf(vcpu) ||
> +	    apf_put_user(vcpu, KVM_PV_REASON_PAGE_NOT_PRESENT)) {
> +		/*
> +		 * It is not possible to deliver a paravirtualized asynchronous
> +		 * page fault, but putting the guest in an artificial halt state
> +		 * can be beneficial nevertheless: if an interrupt arrives, we
> +		 * can deliver it timely and perhaps the guest will schedule
> +		 * another process.  When the instruction that triggered a page
> +		 * fault is retried, hopefully the page will be ready in the host.
> +		 */
>  		kvm_make_request(KVM_REQ_APF_HALT, vcpu);

A return is missing here, to prevent the delivery of PV APF.
(I'd probably keep the if/else.)

Thanks.

> -	else if (!apf_put_user(vcpu, KVM_PV_REASON_PAGE_NOT_PRESENT)) {
> -		fault.vector = PF_VECTOR;
> -		fault.error_code_valid = true;
> -		fault.error_code = 0;
> -		fault.nested_page_fault = false;
> -		fault.address = work->arch.token;
> -		fault.async_page_fault = true;
> -		kvm_inject_page_fault(vcpu, &fault);

>  	}
> +
> +	fault.vector = PF_VECTOR;
> +	fault.error_code_valid = true;
> +	fault.error_code = 0;
> +	fault.nested_page_fault = false;
> +	fault.address = work->arch.token;
> +	fault.async_page_fault = true;
> +	kvm_inject_page_fault(vcpu, &fault);
>  }
>  
>  void kvm_arch_async_page_present(struct kvm_vcpu *vcpu,
> -- 
> 1.8.3.1
> 
