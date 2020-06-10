Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6435B1F552F
	for <lists+kvm@lfdr.de>; Wed, 10 Jun 2020 14:51:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729025AbgFJMvq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jun 2020 08:51:46 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:31057 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728540AbgFJMvp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 10 Jun 2020 08:51:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591793502;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=N3I4oGuxEPTyNsPj6w713UH4LRBydd4acB6ALuwor4Y=;
        b=hY3TlnVKkw4qokoTMKtuangkWbM9ccl4Nki7vuFY9KOQaO1mUHO4lTJ09xCkA+r9ghftxb
        WcKSKzY5xJCqslgatrLtZbAN/nGkxLeVWR7TJNMSn3V3JWT1XtTyVvO8P0segxVmIdHSXi
        GMVP6kdAEE0MwWsEpd8J79dA3xAFZuA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-485-wVvNgFC-NCiq0rgkKz_zKA-1; Wed, 10 Jun 2020 08:51:41 -0400
X-MC-Unique: wVvNgFC-NCiq0rgkKz_zKA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1F00919057A0;
        Wed, 10 Jun 2020 12:51:38 +0000 (UTC)
Received: from horse.redhat.com (ovpn-115-64.rdu2.redhat.com [10.10.115.64])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BAB4C1A7CD;
        Wed, 10 Jun 2020 12:51:37 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id 29C6C2205BD; Wed, 10 Jun 2020 08:51:37 -0400 (EDT)
Date:   Wed, 10 Jun 2020 08:51:37 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        x86@kernel.org, Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>,
        Gavin Shan <gshan@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 05/10] KVM: x86: interrupt based APF 'page ready'
 event delivery
Message-ID: <20200610125137.GA243520@redhat.com>
References: <20200525144125.143875-1-vkuznets@redhat.com>
 <20200525144125.143875-6-vkuznets@redhat.com>
 <20200609191035.GA223235@redhat.com>
 <dcdda87c-cf2f-da6f-3166-e2d0bfefce06@redhat.com>
 <873673b8gc.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <873673b8gc.fsf@vitty.brq.redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 10, 2020 at 11:01:39AM +0200, Vitaly Kuznetsov wrote:
> Paolo Bonzini <pbonzini@redhat.com> writes:
> 
> > On 09/06/20 21:10, Vivek Goyal wrote:
> >> Hi Vitaly,
> >> 
> >> Have a question about page ready events. 
> >> 
> >> Now we deliver PAGE_NOT_PRESENT page faults only if guest is not in
> >> kernel mode. So say kernel tried to access a page and we halted cpu.
> >> When page is available, we will inject page_ready interrupt. At
> >> that time we don't seem to check whether page_not_present was injected
> >> or not. 
> >> 
> >> IOW, we seem to deliver page_ready irrespective of the fact whether
> >> PAGE_NOT_PRESENT was delivered or not. And that means we will be
> >> sending page present tokens to guest. Guest will not have a state
> >> associated with that token and think that page_not_present has
> >> not been delivered yet and allocate an element in hash table for
> >> future page_not_present event. And that will lead to memory leak
> >> and token conflict etc.
> >
> > Yes, and this is https://bugzilla.kernel.org/show_bug.cgi?id=208081
> > which I was looking at right today.
> >
> 
> The issue isn't related to the interrupt based APF mechanism, right?
> 'Page ready' events are always injected (sooner or later). I'll take a
> look.
> 
> >> While setting up async pf, should we keep track whether associated
> >> page_not_present was delivered to guest or not and deliver page_ready
> >> accordingly.
> >
> > Yes, I think so.
> >
> 
> Something like this? (not even compile tested yet):
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 8e8fea13b6c7..68178d29d35c 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1661,7 +1661,7 @@ void kvm_make_scan_ioapic_request(struct kvm *kvm);
>  void kvm_make_scan_ioapic_request_mask(struct kvm *kvm,
>  				       unsigned long *vcpu_bitmap);
>  
> -void kvm_arch_async_page_not_present(struct kvm_vcpu *vcpu,
> +bool kvm_arch_async_page_not_present(struct kvm_vcpu *vcpu,
>  				     struct kvm_async_pf *work);
>  void kvm_arch_async_page_present(struct kvm_vcpu *vcpu,
>  				 struct kvm_async_pf *work);
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index c26dd1363151..e1e840df6b69 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10515,7 +10515,7 @@ bool kvm_can_do_async_pf(struct kvm_vcpu *vcpu)
>  	return kvm_arch_interrupt_allowed(vcpu);
>  }
>  
> -void kvm_arch_async_page_not_present(struct kvm_vcpu *vcpu,
> +bool kvm_arch_async_page_not_present(struct kvm_vcpu *vcpu,
>  				     struct kvm_async_pf *work)
>  {
>  	struct x86_exception fault;
> @@ -10532,17 +10532,19 @@ void kvm_arch_async_page_not_present(struct kvm_vcpu *vcpu,
>  		fault.address = work->arch.token;
>  		fault.async_page_fault = true;
>  		kvm_inject_page_fault(vcpu, &fault);
> -	} else {
> -		/*
> -		 * It is not possible to deliver a paravirtualized asynchronous
> -		 * page fault, but putting the guest in an artificial halt state
> -		 * can be beneficial nevertheless: if an interrupt arrives, we
> -		 * can deliver it timely and perhaps the guest will schedule
> -		 * another process.  When the instruction that triggered a page
> -		 * fault is retried, hopefully the page will be ready in the host.
> -		 */
> -		kvm_make_request(KVM_REQ_APF_HALT, vcpu);
> +		return true;
>  	}
> +
> +	/*
> +	 * It is not possible to deliver a paravirtualized asynchronous
> +	 * page fault, but putting the guest in an artificial halt state
> +	 * can be beneficial nevertheless: if an interrupt arrives, we
> +	 * can deliver it timely and perhaps the guest will schedule
> +	 * another process.  When the instruction that triggered a page
> +	 * fault is retried, hopefully the page will be ready in the host.
> +	 */
> +	kvm_make_request(KVM_REQ_APF_HALT, vcpu);
> +	return false;
>  }
>  
>  void kvm_arch_async_page_present(struct kvm_vcpu *vcpu,
> @@ -10559,7 +10561,8 @@ void kvm_arch_async_page_present(struct kvm_vcpu *vcpu,
>  		kvm_del_async_pf_gfn(vcpu, work->arch.gfn);
>  	trace_kvm_async_pf_ready(work->arch.token, work->cr2_or_gpa);
>  
> -	if (kvm_pv_async_pf_enabled(vcpu) &&
> +	if (work->notpresent_injected &&
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
> index f1e07fae84e9..de28413abefd 100644
> --- a/virt/kvm/async_pf.c
> +++ b/virt/kvm/async_pf.c
> @@ -189,12 +189,14 @@ int kvm_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>  		goto retry_sync;
>  
>  	INIT_WORK(&work->work, async_pf_execute);
> -	if (!schedule_work(&work->work))
> -		goto retry_sync;
>  
>  	list_add_tail(&work->queue, &vcpu->async_pf.queue);
>  	vcpu->async_pf.queued++;
> -	kvm_arch_async_page_not_present(vcpu, work);
> +	work->notpresent_injected = kvm_arch_async_page_not_present(vcpu, work);
> +
> +	/* schedule_work() only fails for already queued works */
> +	schedule_work(&work->work);
> +
>  	return 1;
>  retry_sync:

This label and associated logic can go away as we are not expecting
error from schedule_work().

>  	kvm_put_kvm(work->vcpu->kvm);
> @@ -216,6 +218,7 @@ int kvm_async_pf_wakeup_all(struct kvm_vcpu *vcpu)
>  		return -ENOMEM;
>  
>  	work->wakeup_all = true;
> +	work->notpresent_injected = true;

This probably is not needed. We already have work->wakeup_all set and
this has to be always injected. There is no associated page_not_present
event. IMHO, it probably is cleaner to not set it for  wake up all
events and check work->wakeup_all instead and always inject it.

Once you have final patch, I will test it. I have now configured nvdimm
device with a file backing the device. I drop the page cache on host
and that means any page accessed in guest triggers async pf on host. So
I can easily test it.

Thanks
Vivek

