Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04130352034
	for <lists+kvm@lfdr.de>; Thu,  1 Apr 2021 21:57:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235548AbhDAT46 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 15:56:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39723 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235136AbhDAT45 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 1 Apr 2021 15:56:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617307017;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4B8rrR2ZlPDVkEWIjOjrV74gMnzPRF/GWjn8bfBWXkA=;
        b=BJiF6RErYoRYl693n9FXnibwr4HLUboeKDPtKTep+DOtkHTDEmB8S2knKcvedrRDlbTY21
        4yyM4FVIyCTiSu+eUJgND1bTYt9hBeZhIIpQ+YODZiwhwlpWw+1usLgkABKeOGExq1XISx
        h2sMbIxiS4yRajwlh+m9CFeLQVBMCGQ=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-265-pepbjSyCPJCDMNQ_ebwt4Q-1; Thu, 01 Apr 2021 15:56:55 -0400
X-MC-Unique: pepbjSyCPJCDMNQ_ebwt4Q-1
Received: by mail-wm1-f71.google.com with SMTP id b20-20020a7bc2540000b029010f7732a35fso3484006wmj.1
        for <kvm@vger.kernel.org>; Thu, 01 Apr 2021 12:56:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4B8rrR2ZlPDVkEWIjOjrV74gMnzPRF/GWjn8bfBWXkA=;
        b=qY9TmOAeoF3dSLVfv+VJTMCZ5LHBfo56D9EkOoPLB6QwVkoii7e2KQ69vnijISX1/1
         5txMLcZDdmjCrX9h0grI6JBL5h9J0YsUmLlfehdO5pe30/mPGUHP3jAz1XoevH4Uxv/n
         x2WH/T+dyo3KftJoiBNfi1YDCXpZw50Bl7651g56u8SXeuJc/gzxR4s3ravymk/VmNrq
         y8IXsTjrwpjMQd4uljLRgWaMuOm+d/FqhPFyKH0+o3PHrpV/DlrNsKnaBlKYMn4vKZkK
         2bWhQsFSf1ZKLCDIW3n5Vw6ybOY2cvtWYFd4Gb18jbHtuv1SYwf4SHRv376MI2IE38k7
         bEqw==
X-Gm-Message-State: AOAM5317sypkO6ztrudgxuHLvWe9qpiYH9JS0xRYrDWEKQypHJpDzSg3
        voUIsvTHQEZDQ58JTskT4IyOJCQiMRMa4F+UeUPAte/UHq5FGJturJA7pnBF6z0q6jMNYH69jgj
        zrAWrj+sEvygt
X-Received: by 2002:a05:6000:221:: with SMTP id l1mr11561495wrz.370.1617307014543;
        Thu, 01 Apr 2021 12:56:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyiZ2uzEHFPKu2AQ2TtBFKkRmD/mD6mhiDw22xCxwVoWlYuBzyOZfFCCd4sEmt6QQkM2FUR/g==
X-Received: by 2002:a05:6000:221:: with SMTP id l1mr11561454wrz.370.1617307014001;
        Thu, 01 Apr 2021 12:56:54 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id b12sm11950894wrf.39.2021.04.01.12.56.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Apr 2021 12:56:53 -0700 (PDT)
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>,
        Jim Mattson <jmattson@google.com>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        Ingo Molnar <mingo@redhat.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Sean Christopherson <seanjc@google.com>
References: <20210401143817.1030695-1-mlevitsk@redhat.com>
 <20210401143817.1030695-4-mlevitsk@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 3/4] KVM: x86: correctly merge pending and injected
 exception
Message-ID: <c4f06a75-412c-d546-9ce7-4bf4cc49d102@redhat.com>
Date:   Thu, 1 Apr 2021 21:56:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210401143817.1030695-4-mlevitsk@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/04/21 16:38, Maxim Levitsky wrote:
> +static int kvm_do_deliver_pending_exception(struct kvm_vcpu *vcpu)
> +{
> +	int class1, class2, ret;
> +
> +	/* try to deliver current pending exception as VM exit */
> +	if (is_guest_mode(vcpu)) {
> +		ret = kvm_x86_ops.nested_ops->deliver_exception_as_vmexit(vcpu);
> +		if (ret || !vcpu->arch.pending_exception.valid)
> +			return ret;
> +	}
> +
> +	/* No injected exception, so just deliver the payload and inject it */
> +	if (!vcpu->arch.injected_exception.valid) {
> +		trace_kvm_inj_exception(vcpu->arch.pending_exception.nr,
> +					vcpu->arch.pending_exception.has_error_code,
> +					vcpu->arch.pending_exception.error_code);
> +queue:

If you move the queue label to the top of the function, you can "goto queue" for #DF as well and you don't need to call kvm_do_deliver_pending_exception again.  In fact you can merge this function and kvm_deliver_pending_exception completely:


static int kvm_deliver_pending_exception_as_vmexit(struct kvm_vcpu *vcpu)
{
	WARN_ON(!vcpu->arch.pending_exception.valid);
	if (is_guest_mode(vcpu))
		return kvm_x86_ops.nested_ops->deliver_exception_as_vmexit(vcpu);
	else
		return 0;
}

static int kvm_merge_injected_exception(struct kvm_vcpu *vcpu)
{
	/*
	 * First check if the pending exception takes precedence
	 * over the injected one, which will be reported in the
	 * vmexit info.
	 */
	ret = kvm_deliver_pending_exception_as_vmexit(vcpu);
	if (ret || !vcpu->arch.pending_exception.valid)
		return ret;

	if (vcpu->arch.injected_exception.nr == DF_VECTOR) {
		...
		return 0;
	}
	...
	if ((class1 == EXCPT_CONTRIBUTORY && class2 == EXCPT_CONTRIBUTORY)
	    || (class1 == EXCPT_PF && class2 != EXCPT_BENIGN)) {
		...
	}
	vcpu->arch.injected_exception.valid = false;
}

static int kvm_deliver_pending_exception(struct kvm_vcpu *vcpu)
{
	if (!vcpu->arch.pending_exception.valid)
		return 0;

	if (vcpu->arch.injected_exception.valid)
		kvm_merge_injected_exception(vcpu);

	ret = kvm_deliver_pending_exception_as_vmexit(vcpu));
	if (ret || !vcpu->arch.pending_exception.valid)
		return ret;

	trace_kvm_inj_exception(vcpu->arch.pending_exception.nr,
				vcpu->arch.pending_exception.has_error_code,
				vcpu->arch.pending_exception.error_code);
	...
}

Note that if the pending exception is a page fault, its payload
must be delivered to CR2 before converting it to a double fault.

Going forward to vmx.c:

> 
>  	if (mtf_pending) {
>  		if (block_nested_events)
>  			return -EBUSY;
> +
>  		nested_vmx_update_pending_dbg(vcpu);

Should this instead "WARN_ON(vmx_pending_dbg_trap(vcpu));" since
the pending-#DB-plus-MTF combination is handled in
vmx_deliver_exception_as_vmexit?...

> 
> +
> +	if (vmx->nested.mtf_pending && vmx_pending_dbg_trap(vcpu)) {
> +		/*
> +		 * A pending monitor trap takes precedence over pending
> +		 * debug exception which is 'stashed' into
> +		 * 'GUEST_PENDING_DBG_EXCEPTIONS'
> +		 */
> +
> +		nested_vmx_update_pending_dbg(vcpu);
> +		vmx->nested.mtf_pending = false;
> +		nested_vmx_vmexit(vcpu, EXIT_REASON_MONITOR_TRAP_FLAG, 0, 0);
> +		return 0;
> +	}

... though this is quite ugly, even more so if you add the case of an
INIT with a pending #DB.  The problem is that INIT and MTF have higher
priority than debug exceptions.

The good thing is that an INIT or MTF plus #DB cannot happen with
nested_run_pending == 1, so it will always be inject right away.

There is precedent with KVM_GET_* modifying the CPU state; in
particular, KVM_GET_MPSTATE can modify CS and RIP and even cause a
vmexit via kvm_apic_accept_events.  And in fact, because
kvm_apic_accept_events calls kvm_check_nested_events, calling it
from KVM_GET_VCPU_EVENTS would fix the problem: the injected exception
would go into the IDT-vectored exit field, while the pending exception
would go into GUEST_PENDING_DBG_EXCEPTION and disappear.

However, you cannot do kvm_apic_accept_events twice because there would
be a race with INIT: a #DB exception could be first stored by
KVM_GET_VCPU_EVENTS, then disappear when kvm_apic_accept_events
KVM_GET_MPSTATE is called.

Fortunately, the correct order for KVM_GET_* events is first
KVM_GET_VCPU_EVENTS and then KVM_GET_MPSTATE.  So perhaps
instead of calling kvm_deliver_pending_exception on vmexit,
KVM_GET_VCPU_EVENTS could call kvm_apic_accept_events (and thus
kvm_check_nested_events) instead of KVM_GET_MPSTATE.  In addition:
nested_ops.check_events would be split in two, with high-priority
events (triple fault, now in kvm_check_nested_events; INIT; MTF)
remaining in the first and interrupts in the second, tentatively
named check_interrupts).

I'll take a look at cleaning up the current mess we have around
kvm_apic_accept_events, where most of the calls do not have to
handle guest mode at all.

Thanks for this work and for showing that it's possible to fix the
underlying mess with exception vmexit.  It may be a bit more
complicated than this, but it's a great start.

Paolo

