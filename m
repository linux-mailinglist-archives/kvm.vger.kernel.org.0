Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5175F1FCE03
	for <lists+kvm@lfdr.de>; Wed, 17 Jun 2020 15:02:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726282AbgFQNCT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Jun 2020 09:02:19 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:35003 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725894AbgFQNCS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Jun 2020 09:02:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592398936;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8KAV8NOtjoZ+wKjKI6yhRPJd1MRZuvEvqiX5LCrw/jg=;
        b=HqTHNkk9NmWP3igP+I2nx01hIxv6YV6cg/H+eKAbO1asES5C7F5G2emt584M1dFNFglK4H
        1dzjAcuu6BS++AbgBj7ngkC5qUHrFP9aeahCciHWy3CDFVx2JYQBV05ngndt05bZrwdOFo
        Ho7NyHoXhnf0dOmfZDa5J6l0SKmrEBk=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-509-9lckKRZWM5iO83u7blh02Q-1; Wed, 17 Jun 2020 09:02:13 -0400
X-MC-Unique: 9lckKRZWM5iO83u7blh02Q-1
Received: by mail-ed1-f71.google.com with SMTP id x3so822760eds.14
        for <kvm@vger.kernel.org>; Wed, 17 Jun 2020 06:02:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=8KAV8NOtjoZ+wKjKI6yhRPJd1MRZuvEvqiX5LCrw/jg=;
        b=DGzkyJ6uUd+55LTEarX5TqPIxS6Hbvp3pj5Rk+rVUh29gvFLICPtXKtalgp5sR0E+H
         thjnYqKoqnvxqba2A47hqwIE09Pn+41axsgq8qoOV8b/ovkPH7XG4qA9dmqpghrZvYc7
         YI134lVo1Fq/7UOiNcomFf/ANVKSNj+eOidEzSD/u0XLx55W+W3rfdomKM3emTjpBUxy
         egsI2oqNfajkHEKTvFMkFbzIX0jyEkNtLmUgLCmoIJZ/5rKz8Pju4HRU4tMdyxNjQi63
         K1k0yr9MM+rU1UK2DLmgdhUwyA0RBCT/61T+sl9AeSHHWPPmHnfJpCCfSyS94jhLkS6c
         jjLQ==
X-Gm-Message-State: AOAM5311yS/yxBdAvbotGWR6iEhrhl0xc4M8I75INszUwTswPG4YQ2mH
        QQvHaZ1lq9JeMYfPvp2HF87yjxGlhO0BrTKbaKcVFjl1XLHkdhAp3iaUv0OHRV89fV8N5ZMKs3h
        1M/OQwEKZSpsW
X-Received: by 2002:aa7:dace:: with SMTP id x14mr7263264eds.343.1592398932532;
        Wed, 17 Jun 2020 06:02:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJykw/ci6WDrE7yGkW0MVNZRkO31IBAOfNr2cMkRWf1XrsFz79lBQbqZdoAeHf5XLHj7/X5Ahw==
X-Received: by 2002:aa7:dace:: with SMTP id x14mr7263222eds.343.1592398932224;
        Wed, 17 Jun 2020 06:02:12 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id k22sm12002146edr.93.2020.06.17.06.02.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Jun 2020 06:02:11 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Vivek Goyal <vgoyal@redhat.com>
Cc:     virtio-fs@redhat.com, miklos@szeredi.hu, stefanha@redhat.com,
        dgilbert@redhat.com, pbonzini@redhat.com, wanpengli@tencent.com,
        sean.j.christopherson@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] kvm,x86: Force sync fault if previous attempts failed
In-Reply-To: <20200616214847.24482-2-vgoyal@redhat.com>
References: <20200616214847.24482-1-vgoyal@redhat.com> <20200616214847.24482-2-vgoyal@redhat.com>
Date:   Wed, 17 Jun 2020 15:02:10 +0200
Message-ID: <87o8phhmlp.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> writes:

> Page fault error handling behavior in kvm seems little inconsistent when
> page fault reports error. If we are doing fault synchronously
> then we capture error (-EFAULT) returned by __gfn_to_pfn_memslot() and
> exit to user space and qemu reports error, "error: kvm run failed Bad address".
>
> But if we are doing async page fault, then async_pf_execute() will simply
> ignore the error reported by get_user_pages_remote(). It is assumed that
> page fault was successful and either a page ready event is injected in
> guest or guest is brought out of artificial halt state and run again.
> In both the cases when guest retries the instruction, it takes exit
> again as page fault was not successful in previous attempt. And then
> this infinite loop continues forever.
>

Indeed, we always assume get_user_pages_remote() will fetch the page we
need. 

> This patch tries to make this behavior consistent. That is instead of
> getting into infinite loop of retrying page fault, exit to user space
> and stop VM if page fault error happens. This can be improved by
> injecting errors in guest when it is allowed. Later patches can
> inject error when a process in guest triggered page fault and
> in that case guest process will receive SIGBUS. Currently we don't
> have a way to inject errors when guest is in kernel mode. Once we
> have race free method to do so, we should be able to inject errors
> and guest can do fixup_exception() if caller set it up so (virtio-fs).
>
> When async pf encounters error then save that pfn and when next time
> guest retries, do a sync fault instead of async fault. So that if error
> is encountered, we exit to qemu and avoid infinite loop.
>
> As of now only one error pfn is stored and that means it could be
> overwritten before next a retry from guest happens. But this is
> just a hint and if we miss it, some other time we will catch it.
> If this becomes an issue, we could maintain an array of error
> gfn later to help ease the issue.

With a single GFN stored we can probably get in the same infinite loop
you describe when several processes try to access different unavailable
GFNs. Also, is the condition "GFN is unavailable" temporary or
permanent? I guess it's the former but 'error_gfn' is set permanently
(assuming no other GFN will overwrite it).

What if we do the following instead: add one more field to APF data
indicating an error. The guest will kill the corresponding process
instead of resuming it then.

Also, with KVM_ASYNC_PF_SEND_ALWAYS being deprecated and assuming we
switch to #VE, under which curcumstances we'll be unable to handle page
fault asyncronously? Apart from overflowing the async PF queue, are
there any other scenarios when it still makes sense to keep the guest
alive? 

>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  1 +
>  arch/x86/kvm/mmu.h              |  2 +-
>  arch/x86/kvm/mmu/mmu.c          |  2 +-
>  arch/x86/kvm/x86.c              | 19 +++++++++++++++++--
>  include/linux/kvm_host.h        |  1 +
>  virt/kvm/async_pf.c             |  8 ++++++--
>  6 files changed, 27 insertions(+), 6 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 938497a6ebd7..348a73106556 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -778,6 +778,7 @@ struct kvm_vcpu_arch {
>  		unsigned long nested_apf_token;
>  		bool delivery_as_pf_vmexit;
>  		bool pageready_pending;
> +		gfn_t error_gfn;
>  	} apf;
>  
>  	/* OSVW MSRs (AMD only) */
> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> index 0ad06bfe2c2c..6fa085ff07a3 100644
> --- a/arch/x86/kvm/mmu.h
> +++ b/arch/x86/kvm/mmu.h
> @@ -60,7 +60,7 @@ void kvm_init_mmu(struct kvm_vcpu *vcpu, bool reset_roots);
>  void kvm_init_shadow_mmu(struct kvm_vcpu *vcpu, u32 cr0, u32 cr4, u32 efer);
>  void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly,
>  			     bool accessed_dirty, gpa_t new_eptp);
> -bool kvm_can_do_async_pf(struct kvm_vcpu *vcpu);
> +bool kvm_can_do_async_pf(struct kvm_vcpu *vcpu, gfn_t gfn);
>  int kvm_handle_page_fault(struct kvm_vcpu *vcpu, u64 error_code,
>  				u64 fault_address, char *insn, int insn_len);
>  
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 15984dfde427..e207900ab303 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4078,7 +4078,7 @@ static bool try_async_pf(struct kvm_vcpu *vcpu, bool prefault, gfn_t gfn,
>  	if (!async)
>  		return false; /* *pfn has correct page already */
>  
> -	if (!prefault && kvm_can_do_async_pf(vcpu)) {
> +	if (!prefault && kvm_can_do_async_pf(vcpu, cr2_or_gpa >> PAGE_SHIFT)) {
>  		trace_kvm_try_async_get_page(cr2_or_gpa, gfn);
>  		if (kvm_find_async_pf_gfn(vcpu, gfn)) {
>  			trace_kvm_async_pf_doublefault(cr2_or_gpa, gfn);
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 697d1b273a2f..4c5205434b9c 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10513,7 +10513,7 @@ static bool kvm_can_deliver_async_pf(struct kvm_vcpu *vcpu)
>  	return true;
>  }
>  
> -bool kvm_can_do_async_pf(struct kvm_vcpu *vcpu)
> +bool kvm_can_do_async_pf(struct kvm_vcpu *vcpu, gfn_t gfn)
>  {
>  	if (unlikely(!lapic_in_kernel(vcpu) ||
>  		     kvm_event_needs_reinjection(vcpu) ||
> @@ -10527,7 +10527,13 @@ bool kvm_can_do_async_pf(struct kvm_vcpu *vcpu)
>  	 * If interrupts are off we cannot even use an artificial
>  	 * halt state.
>  	 */
> -	return kvm_arch_interrupt_allowed(vcpu);
> +	if (!kvm_arch_interrupt_allowed(vcpu))
> +		return false;
> +
> +	if (vcpu->arch.apf.error_gfn == gfn)
> +		return false;
> +
> +	return true;
>  }
>  
>  bool kvm_arch_async_page_not_present(struct kvm_vcpu *vcpu,
> @@ -10583,6 +10589,15 @@ void kvm_arch_async_page_present(struct kvm_vcpu *vcpu,
>  		kvm_apic_set_irq(vcpu, &irq, NULL);
>  	}
>  
> +	if (work->error_code) {
> +		/*
> +		 * Page fault failed and we don't have a way to report
> +		 * errors back to guest yet. So save this pfn and force
> +		 * sync page fault next time.
> +		 */
> +		vcpu->arch.apf.error_gfn = work->cr2_or_gpa >> PAGE_SHIFT;
> +	}
> +
>  	vcpu->arch.apf.halted = false;
>  	vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
>  }
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 216cdb6581e2..b8558334b184 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -207,6 +207,7 @@ struct kvm_async_pf {
>  	struct kvm_arch_async_pf arch;
>  	bool   wakeup_all;
>  	bool notpresent_injected;
> +	int error_code;
>  };
>  
>  void kvm_clear_async_pf_completion_queue(struct kvm_vcpu *vcpu);
> diff --git a/virt/kvm/async_pf.c b/virt/kvm/async_pf.c
> index a36828fbf40a..6b30374a4de1 100644
> --- a/virt/kvm/async_pf.c
> +++ b/virt/kvm/async_pf.c
> @@ -52,6 +52,7 @@ static void async_pf_execute(struct work_struct *work)
>  	gpa_t cr2_or_gpa = apf->cr2_or_gpa;
>  	int locked = 1;
>  	bool first;
> +	long ret;
>  
>  	might_sleep();
>  
> @@ -61,11 +62,14 @@ static void async_pf_execute(struct work_struct *work)
>  	 * access remotely.
>  	 */
>  	down_read(&mm->mmap_sem);
> -	get_user_pages_remote(NULL, mm, addr, 1, FOLL_WRITE, NULL, NULL,
> -			&locked);
> +	ret = get_user_pages_remote(NULL, mm, addr, 1, FOLL_WRITE, NULL, NULL,
> +				    &locked);
>  	if (locked)
>  		up_read(&mm->mmap_sem);
>  
> +	if (ret < 0)
> +		apf->error_code = ret;
> +
>  	if (IS_ENABLED(CONFIG_KVM_ASYNC_PF_SYNC))
>  		kvm_arch_async_page_present(vcpu, apf);

-- 
Vitaly

