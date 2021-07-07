Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94A003BE872
	for <lists+kvm@lfdr.de>; Wed,  7 Jul 2021 14:57:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231628AbhGGNAT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jul 2021 09:00:19 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:31465 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229757AbhGGNAR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 7 Jul 2021 09:00:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625662656;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ALMkTNzVIKS8ylZBsEmRyoWdrxlImatVmWR/ImZJHQg=;
        b=aSyS9RQmjkluj4gk2nlNM+bGTr/hUpuDpFIftC8HSZuItlkAq7DxpcQfnXtdKjlgW8OycB
        2dvXNd3GY/WJ5AbgWDDVZf7Q79NRc/3MMNXCd6nDo0KTVPHIcc51pU0KCvlsfenda+jEgc
        YYjVkzcvuyrThN3KHQMBZkF3KZh2AXA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-318-g2F75RpsMIy-o3Ckn-Q7zw-1; Wed, 07 Jul 2021 08:57:33 -0400
X-MC-Unique: g2F75RpsMIy-o3Ckn-Q7zw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E3331804300;
        Wed,  7 Jul 2021 12:57:31 +0000 (UTC)
Received: from starship (unknown [10.40.192.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3F06C610AE;
        Wed,  7 Jul 2021 12:57:28 +0000 (UTC)
Message-ID: <9413056ebbd5997a35b446f2841589973484ba02.camel@redhat.com>
Subject: Re: [PATCH 02/10] KVM: x86: APICv: fix race in
 kvm_request_apicv_update on SVM
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Jim Mattson <jmattson@google.com>
Date:   Wed, 07 Jul 2021 15:57:26 +0300
In-Reply-To: <43ef1a1ea488977db11d40ec9672b524ec816112.camel@redhat.com>
References: <20210623113002.111448-1-mlevitsk@redhat.com>
         <20210623113002.111448-3-mlevitsk@redhat.com>
         <6c4a69ce-595e-d5a1-7b4e-e6ce1afe1252@redhat.com>
         <43ef1a1ea488977db11d40ec9672b524ec816112.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2021-06-24 at 11:07 +0300, Maxim Levitsky wrote:
> On Wed, 2021-06-23 at 23:50 +0200, Paolo Bonzini wrote:
> > On 23/06/21 13:29, Maxim Levitsky wrote:
> > > +	kvm_block_guest_entries(kvm);
> > > +
> > >   	trace_kvm_apicv_update_request(activate, bit);
> > >   	if (kvm_x86_ops.pre_update_apicv_exec_ctrl)
> > >   		static_call(kvm_x86_pre_update_apicv_exec_ctrl)(kvm, activate);
> > > @@ -9243,6 +9245,8 @@ void kvm_request_apicv_update(struct kvm *kvm, bool activate, ulong bit)
> > >   	except = kvm_get_running_vcpu();
> > >   	kvm_make_all_cpus_request_except(kvm, KVM_REQ_APICV_UPDATE,
> > >   					 except);
> > > +
> > > +	kvm_allow_guest_entries(kvm);
> > 
> > Doesn't this cause a busy loop during synchronize_rcu?
> 
> Hi,
> 
> If you mean busy loop on other vcpus, then the answer is sadly yes.
> Other option is to use a mutex, which is what I did in a former
> version of this patch, but at last minute I decided that this
> way it was done in this patch would be simplier. 
> AVIC updates don't happen often.
> Also with a request, the KVM_REQ_APICV_UPDATE can be handled in parallel,
> while mutex enforces unneeded mutual execution of it.
> 
> 
> >   It should be 
> > possible to request the vmexit of other CPUs from 
> > avic_update_access_page, and do a lock/unlock of kvm->slots_lock to wait 
> > for the memslot to be updated.
> 
> This would still keep the race. The other vCPUs must not enter the guest mode
> from the moment the memslot update was started and until the KVM_REQ_APICV_UPDATE
> is raised.
>  
> If I were to do any kind of synchronization in avic_update_access_page, then I will
> have to drop the lock/request there, and from this point and till the common code
> raises the KVM_REQ_APICV_UPDATE there is a possibility of a vCPU reentering the
> guest mode without updating its AVIC.
>  
>  
> Here is an older version of this patch that does use mutex instead. 
> Please let me know if you prefer it.
> 
> I copy pasted it here, thus its likely not to apply as my email client
> probably destroys whitespace.
>   
> Thanks for the review,
> 	Best regards,
> 		Maxim Levitsky
> 
> 
> --
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index fdc6b8a4348f..b7dc7fd7b63d 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9183,11 +9183,8 @@ void kvm_make_scan_ioapic_request(struct kvm *kvm)
>  	kvm_make_all_cpus_request(kvm, KVM_REQ_SCAN_IOAPIC);
>  }
>  
> -void kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu)
> +void __kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu)
>  {
> -	if (!lapic_in_kernel(vcpu))
> -		return;
> -
>  	vcpu->arch.apicv_active = kvm_apicv_activated(vcpu->kvm);
>  	kvm_apic_update_apicv(vcpu);
>  	static_call(kvm_x86_refresh_apicv_exec_ctrl)(vcpu);
> @@ -9201,6 +9198,16 @@ void kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu)
>  	if (!vcpu->arch.apicv_active)
>  		kvm_make_request(KVM_REQ_EVENT, vcpu);
>  }
> +
> +void kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu)
> +{
> +	if (!lapic_in_kernel(vcpu))
> +		return;
> +
> +	mutex_lock(&vcpu->kvm->apicv_update_lock);
> +	__kvm_vcpu_update_apicv(vcpu);
> +	mutex_unlock(&vcpu->kvm->apicv_update_lock);
> +}
>  EXPORT_SYMBOL_GPL(kvm_vcpu_update_apicv);
>  
>  /*
> @@ -9213,30 +9220,26 @@ EXPORT_SYMBOL_GPL(kvm_vcpu_update_apicv);
>  void kvm_request_apicv_update(struct kvm *kvm, bool activate, ulong bit)
>  {
>  	struct kvm_vcpu *except;
> -	unsigned long old, new, expected;
> +	unsigned long old, new;
>  
>  	if (!kvm_x86_ops.check_apicv_inhibit_reasons ||
>  	    !static_call(kvm_x86_check_apicv_inhibit_reasons)(bit))
>  		return;
>  
> -	old = READ_ONCE(kvm->arch.apicv_inhibit_reasons);
> -	do {
> -		expected = new = old;
> -		if (activate)
> -			__clear_bit(bit, &new);
> -		else
> -			__set_bit(bit, &new);
> -		if (new == old)
> -			break;
> -		old = cmpxchg(&kvm->arch.apicv_inhibit_reasons, expected, new);
> -	} while (old != expected);
> +	mutex_lock(&kvm->apicv_update_lock);
> +
> +	old = new = kvm->arch.apicv_inhibit_reasons;
> +	if (activate)
> +		__clear_bit(bit, &new);
> +	else
> +		__set_bit(bit, &new);
> +
> +	WRITE_ONCE(kvm->arch.apicv_inhibit_reasons, new);
>  
>  	if (!!old == !!new)
> -		return;
> +		goto out;
>  
>  	trace_kvm_apicv_update_request(activate, bit);
> -	if (kvm_x86_ops.pre_update_apicv_exec_ctrl)
> -		static_call(kvm_x86_pre_update_apicv_exec_ctrl)(kvm, activate);
>  
>  	/*
>  	 * Sending request to update APICV for all other vcpus,
> @@ -9244,10 +9247,24 @@ void kvm_request_apicv_update(struct kvm *kvm, bool activate, ulong bit)
>  	 * waiting for another #VMEXIT to handle the request.
>  	 */
>  	except = kvm_get_running_vcpu();
> +
> +	/*
> +	 * on SVM, raising the KVM_REQ_APICV_UPDATE request while holding the
> +	 *  apicv_update_lock ensures that we kick all vCPUs out of the
> +	 *  guest mode and let them wait until the AVIC memslot update
> +	 *  has completed.
> +	 */
> +
>  	kvm_make_all_cpus_request_except(kvm, KVM_REQ_APICV_UPDATE,
>  					 except);
> +
> +	if (kvm_x86_ops.pre_update_apicv_exec_ctrl)
> +		static_call(kvm_x86_pre_update_apicv_exec_ctrl)(kvm, activate);
> +
>  	if (except)
> -		kvm_vcpu_update_apicv(except);
> +		__kvm_vcpu_update_apicv(except);
> +out:
> +	mutex_unlock(&kvm->apicv_update_lock);
>  }
>  EXPORT_SYMBOL_GPL(kvm_request_apicv_update);
>  
> @@ -9454,8 +9471,11 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>  		 */
>  		if (kvm_check_request(KVM_REQ_HV_STIMER, vcpu))
>  			kvm_hv_process_stimers(vcpu);
> -		if (kvm_check_request(KVM_REQ_APICV_UPDATE, vcpu))
> +		if (kvm_check_request(KVM_REQ_APICV_UPDATE, vcpu)) {
> +			srcu_read_unlock(&vcpu->kvm->srcu, vcpu->srcu_idx);
>  			kvm_vcpu_update_apicv(vcpu);
> +			vcpu->srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
> +		}
>  		if (kvm_check_request(KVM_REQ_APF_READY, vcpu))
>  			kvm_check_async_pf_completion(vcpu);
>  		if (kvm_check_request(KVM_REQ_MSR_FILTER_CHANGED, vcpu))
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 37cbb56ccd09..0364d35d43dc 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -524,6 +524,7 @@ struct kvm {
>  #endif /* KVM_HAVE_MMU_RWLOCK */
>  
>  	struct mutex slots_lock;
> +	struct mutex apicv_update_lock;
>  
>  	/*
>  	 * Protects the arch-specific fields of struct kvm_memory_slots in
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index ed4d1581d502..ba5d5d9ebc64 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -943,6 +943,7 @@ static struct kvm *kvm_create_vm(unsigned long type)
>  	mutex_init(&kvm->irq_lock);
>  	mutex_init(&kvm->slots_lock);
>  	mutex_init(&kvm->slots_arch_lock);
> +	mutex_init(&kvm->apicv_update_lock);
>  	INIT_LIST_HEAD(&kvm->devices);
>  
>  	BUILD_BUG_ON(KVM_MEM_SLOTS_NUM > SHRT_MAX);
> 
> 
> 
> > (As an aside, I'd like to get rid of KVM_REQ_MCLOCK_IN_PROGRESS in 5.15...).
> > 
> > Paolo
> > 


Hi!
Any update? should I use a lock for this?


Best regards,
	Maxim Levitsky


