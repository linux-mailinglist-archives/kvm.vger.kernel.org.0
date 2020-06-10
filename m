Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB8B51F5BFA
	for <lists+kvm@lfdr.de>; Wed, 10 Jun 2020 21:32:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730178AbgFJTcW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jun 2020 15:32:22 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:37917 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726806AbgFJTcW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Jun 2020 15:32:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591817540;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TXEO0NMuFamvlSFmJYPE6uLqbht0lTepf382LStAP+k=;
        b=Exn7GRPaMLh6Mi3j0QwtjgO2xOu0/BE+bG5Hf6IWp06ccsiJFnd6nM+1+u6soT5RRZLflb
        tKPIzmssHZ5rogwpdC9fiwFRBQo0SuP0dZ9Zop6/ZRrF14WFi36S8OHgY8NaBVuFtZj/Kd
        EslBfwJ5LIQcqbP0DwRZgdE/TkKWC+c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-421--wPs3G4uPouBF9N71rymCw-1; Wed, 10 Jun 2020 15:32:15 -0400
X-MC-Unique: -wPs3G4uPouBF9N71rymCw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8E45C8018AB;
        Wed, 10 Jun 2020 19:32:13 +0000 (UTC)
Received: from horse.redhat.com (ovpn-115-64.rdu2.redhat.com [10.10.115.64])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 492365D9D7;
        Wed, 10 Jun 2020 19:32:12 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id C5A582205BD; Wed, 10 Jun 2020 15:32:11 -0400 (EDT)
Date:   Wed, 10 Jun 2020 15:32:11 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] KVM: async_pf: Inject 'page ready' event only if
 'page not present' was previously injected
Message-ID: <20200610193211.GB243520@redhat.com>
References: <20200610175532.779793-1-vkuznets@redhat.com>
 <20200610175532.779793-2-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200610175532.779793-2-vkuznets@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 10, 2020 at 07:55:32PM +0200, Vitaly Kuznetsov wrote:
> 'Page not present' event may or may not get injected depending on
> guest's state. If the event wasn't injected, there is no need to
> inject the corresponding 'page ready' event as the guest may get
> confused. E.g. Linux thinks that the corresponding 'page not present'
> event wasn't delivered *yet* and allocates a 'dummy entry' for it.
> This entry is never freed.
> 
> Note, 'wakeup all' events have no corresponding 'page not present'
> event and always get injected.
> 
> s390 seems to always be able to inject 'page not present', the
> change is effectively a nop.
> 
> Suggested-by: Vivek Goyal <vgoyal@redhat.com>
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/s390/include/asm/kvm_host.h | 2 +-
>  arch/s390/kvm/kvm-s390.c         | 4 +++-
>  arch/x86/include/asm/kvm_host.h  | 2 +-
>  arch/x86/kvm/x86.c               | 7 +++++--
>  include/linux/kvm_host.h         | 1 +
>  virt/kvm/async_pf.c              | 2 +-
>  6 files changed, 12 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
> index 3d554887794e..cee3cb6455a2 100644
> --- a/arch/s390/include/asm/kvm_host.h
> +++ b/arch/s390/include/asm/kvm_host.h
> @@ -978,7 +978,7 @@ bool kvm_arch_can_dequeue_async_page_present(struct kvm_vcpu *vcpu);
>  void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu,
>  			       struct kvm_async_pf *work);
>  
> -void kvm_arch_async_page_not_present(struct kvm_vcpu *vcpu,
> +bool kvm_arch_async_page_not_present(struct kvm_vcpu *vcpu,
>  				     struct kvm_async_pf *work);

Hi Vitaly,

A minor nit. Using return code to figure out if exception was injected
or not is little odd. How about we pass a pointer instead as parameter
and kvm_arch_async_page_not_present() sets it to true if page not
present exception was injected. This probably will be easier to
read.

If for some reason you don't like above, atleats it warrants a comment
explaining what do 0 and 1 mean.

Otherwise both the patches look good to me. I tested and I can confirm
that now page ready events are not being delivered to guest if page
not present was not injected.

Thanks
Vivek

>  
>  void kvm_arch_async_page_present(struct kvm_vcpu *vcpu,
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 06bde4bad205..33fea4488ef3 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -3923,11 +3923,13 @@ static void __kvm_inject_pfault_token(struct kvm_vcpu *vcpu, bool start_token,
>  	}
>  }
>  
> -void kvm_arch_async_page_not_present(struct kvm_vcpu *vcpu,
> +bool kvm_arch_async_page_not_present(struct kvm_vcpu *vcpu,
>  				     struct kvm_async_pf *work)
>  {
>  	trace_kvm_s390_pfault_init(vcpu, work->arch.pfault_token);
>  	__kvm_inject_pfault_token(vcpu, true, work->arch.pfault_token);
> +
> +	return true;
>  }
>  
>  void kvm_arch_async_page_present(struct kvm_vcpu *vcpu,
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 6e03c021956a..f54e7499fc6a 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1660,7 +1660,7 @@ void kvm_make_scan_ioapic_request(struct kvm *kvm);
>  void kvm_make_scan_ioapic_request_mask(struct kvm *kvm,
>  				       unsigned long *vcpu_bitmap);
>  
> -void kvm_arch_async_page_not_present(struct kvm_vcpu *vcpu,
> +bool kvm_arch_async_page_not_present(struct kvm_vcpu *vcpu,
>  				     struct kvm_async_pf *work);
>  void kvm_arch_async_page_present(struct kvm_vcpu *vcpu,
>  				 struct kvm_async_pf *work);
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 13d0b0fa1a7c..75e4c68e9586 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10513,7 +10513,7 @@ bool kvm_can_do_async_pf(struct kvm_vcpu *vcpu)
>  	return kvm_arch_interrupt_allowed(vcpu);
>  }
>  
> -void kvm_arch_async_page_not_present(struct kvm_vcpu *vcpu,
> +bool kvm_arch_async_page_not_present(struct kvm_vcpu *vcpu,
>  				     struct kvm_async_pf *work)
>  {
>  	struct x86_exception fault;
> @@ -10530,6 +10530,7 @@ void kvm_arch_async_page_not_present(struct kvm_vcpu *vcpu,
>  		fault.address = work->arch.token;
>  		fault.async_page_fault = true;
>  		kvm_inject_page_fault(vcpu, &fault);
> +		return true;
>  	} else {
>  		/*
>  		 * It is not possible to deliver a paravirtualized asynchronous
> @@ -10540,6 +10541,7 @@ void kvm_arch_async_page_not_present(struct kvm_vcpu *vcpu,
>  		 * fault is retried, hopefully the page will be ready in the host.
>  		 */
>  		kvm_make_request(KVM_REQ_APF_HALT, vcpu);
> +		return false;
>  	}
>  }
>  
> @@ -10557,7 +10559,8 @@ void kvm_arch_async_page_present(struct kvm_vcpu *vcpu,
>  		kvm_del_async_pf_gfn(vcpu, work->arch.gfn);
>  	trace_kvm_async_pf_ready(work->arch.token, work->cr2_or_gpa);
>  
> -	if (kvm_pv_async_pf_enabled(vcpu) &&
> +	if ((work->wakeup_all || work->notpresent_injected) &&
> +	    kvm_pv_async_pf_enabled(vcpu) &&
>  	    !apf_put_user_ready(vcpu, work->arch.token)) {
>  		vcpu->arch.apf.pageready_pending = true;
>  		kvm_apic_set_irq(vcpu, &irq, NULL);
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 802b9e2306f0..2456dc5338f8 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -206,6 +206,7 @@ struct kvm_async_pf {
>  	unsigned long addr;
>  	struct kvm_arch_async_pf arch;
>  	bool   wakeup_all;
> +	bool notpresent_injected;
>  };
>  
>  void kvm_clear_async_pf_completion_queue(struct kvm_vcpu *vcpu);
> diff --git a/virt/kvm/async_pf.c b/virt/kvm/async_pf.c
> index ba080088da76..a36828fbf40a 100644
> --- a/virt/kvm/async_pf.c
> +++ b/virt/kvm/async_pf.c
> @@ -189,7 +189,7 @@ int kvm_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>  
>  	list_add_tail(&work->queue, &vcpu->async_pf.queue);
>  	vcpu->async_pf.queued++;
> -	kvm_arch_async_page_not_present(vcpu, work);
> +	work->notpresent_injected = kvm_arch_async_page_not_present(vcpu, work);
>  
>  	schedule_work(&work->work);
>  
> -- 
> 2.25.4
> 

