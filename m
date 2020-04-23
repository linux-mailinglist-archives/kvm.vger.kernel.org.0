Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E29531B59D0
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 13:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727890AbgDWLAX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Apr 2020 07:00:23 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:43651 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727814AbgDWLAW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Apr 2020 07:00:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587639620;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=20mD5b4K8EOsmpKpysEvWUMgHRYlVlD/chD77TRrBwA=;
        b=fDk/E5ZCG34p7hXbkQ5Dp6InsLFg3nted2Vmx7nyfb01P+pt5hhj6zLpfFhzxp/whk0NSL
        CPTNaHxq/LzFzNxGogNyGbLIozjih8/TrSZG2Six9b25kcjnMT3Fj57nM9K+IlSj3Ox7td
        nCJe0nOvvTzeMSdihXHUbO7rvAnl0+8=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-22-AX58lXq6OJKUhq67lHeDMg-1; Thu, 23 Apr 2020 07:00:13 -0400
X-MC-Unique: AX58lXq6OJKUhq67lHeDMg-1
Received: by mail-wr1-f69.google.com with SMTP id m5so2658879wru.15
        for <kvm@vger.kernel.org>; Thu, 23 Apr 2020 04:00:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=20mD5b4K8EOsmpKpysEvWUMgHRYlVlD/chD77TRrBwA=;
        b=ajgdC5BqDiVMmOJ3+wbynWavOexcG+lAr6rRGu3604Pxosf/Z97uCWZeo1P+8QR4IO
         5CpTXqhZQ1N25GjLBaKpLkiGV+KLJ6RS6rJGbscBSNQMDXavLMiRfNXrfEQ2mmosdGnp
         iy54DmWN7MazANC78e5Kpd9IPwYc7jRaxdg+YZogXRcnijMogTPyjLU9Le0zVegHDNg5
         4+0gd15mpg6dZC7SN2BSCxROw9ikv3BOH8rTFrrq9/z+hiyN3ds2lLWwwJ4EfIyNMXyA
         aujd1XCWpuUPN06DDuBm1Nong6xJvv4Pq5JUuMOXPDGdbm4x5poARpuopnQiUiW612pD
         gByA==
X-Gm-Message-State: AGi0PubE6aLaBVjKVnfnejeZsb0mY8NmDvvVU++fP5sf/woXb7r8Xc75
        nFdvpI2gO8Dv6g5eUWmGXu2+MPstsQqC43GVnWq+2GvN3fMjo/8K79ydbUvnOjTz6lmoO6veHiR
        EH5JhFEPxjzH8
X-Received: by 2002:adf:97d0:: with SMTP id t16mr4055795wrb.138.1587639611836;
        Thu, 23 Apr 2020 04:00:11 -0700 (PDT)
X-Google-Smtp-Source: APiQypJ8SqSh9o6yckWbzkNCOCPSjoQm/m/ViZdLrbvlLCIMHDoLGQ8GJlTCvLpolt8yzkBiY2WRuQ==
X-Received: by 2002:adf:97d0:: with SMTP id t16mr4055767wrb.138.1587639611556;
        Thu, 23 Apr 2020 04:00:11 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:d0a0:f143:e9e4:2926? ([2001:b07:6468:f312:d0a0:f143:e9e4:2926])
        by smtp.gmail.com with ESMTPSA id l19sm3348599wmj.14.2020.04.23.04.00.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Apr 2020 04:00:11 -0700 (PDT)
Subject: Re: [PATCH 12/13] KVM: x86: Replace late check_nested_events() hack
 with more precise fix
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
References: <20200423022550.15113-1-sean.j.christopherson@intel.com>
 <20200423022550.15113-13-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f766789e-7444-ab0d-4364-0c14ec7154b1@redhat.com>
Date:   Thu, 23 Apr 2020 13:00:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200423022550.15113-13-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/04/20 04:25, Sean Christopherson wrote:
> Add a separate hook for checking if interrupt injection is blocked and
> use the hook to handle the case where an interrupt arrives between
> check_nested_events() and the injection logic.  Drop the retry of
> check_nested_events() that hack-a-fixed the same condition.
> 
> Blocking injection is also a bit of a hack, e.g. KVM should do exiting
> and non-exiting interrupt processing in a single pass, but it's a more
> precise hack.  The old comment is also misleading, e.g. KVM_REQ_EVENT is
> purely an optimization, setting it on every run loop (which KVM doesn't
> do) should not affect functionality, only performance.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  1 +
>  arch/x86/kvm/svm/svm.c          |  1 +
>  arch/x86/kvm/vmx/vmx.c          | 13 +++++++++++++
>  arch/x86/kvm/x86.c              | 22 ++++------------------
>  4 files changed, 19 insertions(+), 18 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 787636acd648..16fdeddb4a65 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1140,6 +1140,7 @@ struct kvm_x86_ops {
>  	void (*queue_exception)(struct kvm_vcpu *vcpu);
>  	void (*cancel_injection)(struct kvm_vcpu *vcpu);
>  	bool (*interrupt_allowed)(struct kvm_vcpu *vcpu);
> +	bool (*interrupt_injection_allowed)(struct kvm_vcpu *vcpu);
>  	bool (*nmi_allowed)(struct kvm_vcpu *vcpu);
>  	bool (*get_nmi_mask)(struct kvm_vcpu *vcpu);
>  	void (*set_nmi_mask)(struct kvm_vcpu *vcpu, bool masked);
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index f21f734861dd..6d3ccbfc9e6a 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3993,6 +3993,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
>  	.queue_exception = svm_queue_exception,
>  	.cancel_injection = svm_cancel_injection,
>  	.interrupt_allowed = svm_interrupt_allowed,
> +	.interrupt_injection_allowed = svm_interrupt_allowed,
>  	.nmi_allowed = svm_nmi_allowed,
>  	.get_nmi_mask = svm_get_nmi_mask,
>  	.set_nmi_mask = svm_set_nmi_mask,
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 2f8cacb3aa9b..68b3748b5383 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -4550,6 +4550,18 @@ static bool vmx_interrupt_allowed(struct kvm_vcpu *vcpu)
>  	return !vmx_interrupt_blocked(vcpu);
>  }
>  
> +static bool vmx_interrupt_injection_allowed(struct kvm_vcpu *vcpu)
> +{
> +	/*
> +	 * An IRQ must not be injected into L2 if it's supposed to VM-Exit,
> +	 * e.g. if the IRQ arrived asynchronously after checking nested events.
> +	 */
> +	if (is_guest_mode(vcpu) && nested_exit_on_intr(vcpu))
> +		return false;
> +
> +	return vmx_interrupt_allowed(vcpu);
> +}
> +
>  static int vmx_set_tss_addr(struct kvm *kvm, unsigned int addr)
>  {
>  	int ret;
> @@ -7823,6 +7835,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
>  	.queue_exception = vmx_queue_exception,
>  	.cancel_injection = vmx_cancel_injection,
>  	.interrupt_allowed = vmx_interrupt_allowed,
> +	.interrupt_injection_allowed = vmx_interrupt_injection_allowed,
>  	.nmi_allowed = vmx_nmi_allowed,
>  	.get_nmi_mask = vmx_get_nmi_mask,
>  	.set_nmi_mask = vmx_set_nmi_mask,
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 7c49a7dc601f..d9d6028a77e0 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -7755,24 +7755,10 @@ static int inject_pending_event(struct kvm_vcpu *vcpu)
>  		--vcpu->arch.nmi_pending;
>  		vcpu->arch.nmi_injected = true;
>  		kvm_x86_ops.set_nmi(vcpu);
> -	} else if (kvm_cpu_has_injectable_intr(vcpu)) {
> -		/*
> -		 * Because interrupts can be injected asynchronously, we are
> -		 * calling check_nested_events again here to avoid a race condition.
> -		 * See https://lkml.org/lkml/2014/7/2/60 for discussion about this
> -		 * proposal and current concerns.  Perhaps we should be setting
> -		 * KVM_REQ_EVENT only on certain events and not unconditionally?
> -		 */
> -		if (is_guest_mode(vcpu) && kvm_x86_ops.check_nested_events) {
> -			r = kvm_x86_ops.check_nested_events(vcpu);
> -			if (r != 0)
> -				return r;
> -		}
> -		if (kvm_x86_ops.interrupt_allowed(vcpu)) {
> -			kvm_queue_interrupt(vcpu, kvm_cpu_get_interrupt(vcpu),
> -					    false);
> -			kvm_x86_ops.set_irq(vcpu);
> -		}
> +	} else if (kvm_cpu_has_injectable_intr(vcpu) &&
> +		   kvm_x86_ops.interrupt_injection_allowed(vcpu)) {
> +		kvm_queue_interrupt(vcpu, kvm_cpu_get_interrupt(vcpu), false);
> +		kvm_x86_ops.set_irq(vcpu);

Hmm I'm interested in how this can help with AMD introducing another
instance of the late random check_nested_events.  I'll play with it.

Paolo

