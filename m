Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17D1D3FF58C
	for <lists+kvm@lfdr.de>; Thu,  2 Sep 2021 23:19:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346631AbhIBVUh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Sep 2021 17:20:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344889AbhIBVUb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Sep 2021 17:20:31 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 172D4C061757
        for <kvm@vger.kernel.org>; Thu,  2 Sep 2021 14:19:31 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id mw10-20020a17090b4d0a00b0017b59213831so2442007pjb.0
        for <kvm@vger.kernel.org>; Thu, 02 Sep 2021 14:19:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0MoWvyBuxB6hnlX9UmpIsvYzqqn+8XE9V419opjL2bw=;
        b=Zu2Coku2+ZwBlMjajRny8atHMOyAHnXbEcL+N7yiRBORXdpdLHuR/towrWP07B8stp
         vj5rMhVt3EeAIm9/OS2nXhX6ZHhYGo+I6n7ZMYSjT8G2PKpdAgBfpdlqFpGJKnH77z0/
         20j8hM6ZU1uK6HFKIdH76zfwNTPcwcBtL1GG495lum874kXJnxOTQZ2kZBa9eEnGPMpf
         bWj14fvfNvCIRvLJcA86g6TSj9SBh/lx709Tzp6bL8tMTAG4aI0+7Sjm/FBpAdhGu4wD
         a9Kadd73F2k/ftDiiiFI15juAfz9iWtfTMJBtKvog97Cld4zFZNofL/yqI9+cpaHhBDU
         rflA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0MoWvyBuxB6hnlX9UmpIsvYzqqn+8XE9V419opjL2bw=;
        b=ZpFnKUzC6FdWnXHc3vI2AJVfNjSmzcfbWRDpRWM6OStFbvIvFHNjwsb/zAdE/XRnQ4
         U+vBnr4NlPDShZ+w0cgqSCsIEtG7+d4G1aIVbnWDvBrQvEgTfJdSswFKPGiupTFMQlsT
         o9Z62NyS+aE/LTNzoENHQSa03eXOgy+uh+nbvIN0f5YqSmjdNSAEDJnFuEJNVruX4+6j
         M7xOw955PvaaUBSe2UQeIuyjiol8Vl8yZgiQZyvXY1mvrJPzTRM0cA2Hc7oPFpNDJ4Zd
         4+CQZZl90tt0Rf6EvgCAwAwer+nEiKimRpi1bkmKhvUq1/09Bh+N9Of0xCLHLzRriyu7
         nzvw==
X-Gm-Message-State: AOAM530HLhVw1NETvuALmu/VU0wGfPIXSD9/x5ErsWy7p4ZJWWgh4SOI
        +AHgyLRj2DZlcb6wbW7x/McHuw==
X-Google-Smtp-Source: ABdhPJx4MZirR3AER4juXjw0qQOKg9JnGBvEa3T+2unkQDzxI3pB5oJdQYPmdoZKyTxBP7QXRaDivg==
X-Received: by 2002:a17:90a:b702:: with SMTP id l2mr119269pjr.71.1630617570971;
        Thu, 02 Sep 2021 14:19:30 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id n13sm3053146pff.164.2021.09.02.14.19.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Sep 2021 14:19:30 -0700 (PDT)
Date:   Thu, 2 Sep 2021 21:19:26 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Nitesh Narayan Lal <nitesh@redhat.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 8/8] KVM: Make kvm_make_vcpus_request_mask() use
 pre-allocated cpu_kick_mask
Message-ID: <YTE/3pUnUb9Ivwmk@google.com>
References: <20210827092516.1027264-1-vkuznets@redhat.com>
 <20210827092516.1027264-9-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210827092516.1027264-9-vkuznets@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 27, 2021, Vitaly Kuznetsov wrote:
> kvm_make_vcpus_request_mask() already disables preemption so just like
> kvm_make_all_cpus_request_except() it can be switched to using
> pre-allocated per-cpu cpumasks. This allows for improvements for both
> users of the function: in Hyper-V emulation code 'tlb_flush' can now be
> dropped from 'struct kvm_vcpu_hv' and kvm_make_scan_ioapic_request_mask()
> gets rid of dynamic allocation.
> 
> cpumask_available() check in kvm_make_vcpu_request() can now be dropped as
> it checks for an impossible condition: kvm_init() makes sure per-cpu masks
> are allocated.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  1 -
>  arch/x86/kvm/hyperv.c           |  5 +----
>  arch/x86/kvm/x86.c              |  8 +-------
>  include/linux/kvm_host.h        |  2 +-
>  virt/kvm/kvm_main.c             | 18 +++++++-----------
>  5 files changed, 10 insertions(+), 24 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 09b256db394a..846552fa2012 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -569,7 +569,6 @@ struct kvm_vcpu_hv {
>  	struct kvm_hyperv_exit exit;
>  	struct kvm_vcpu_hv_stimer stimer[HV_SYNIC_STIMER_COUNT];
>  	DECLARE_BITMAP(stimer_pending_bitmap, HV_SYNIC_STIMER_COUNT);
> -	cpumask_t tlb_flush;
>  	bool enforce_cpuid;
>  	struct {
>  		u32 features_eax; /* HYPERV_CPUID_FEATURES.EAX */
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index 5704bfe53ee0..f76e7228f687 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -1755,7 +1755,6 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc, bool
>  	int i;
>  	gpa_t gpa;
>  	struct kvm *kvm = vcpu->kvm;
> -	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
>  	struct hv_tlb_flush_ex flush_ex;
>  	struct hv_tlb_flush flush;
>  	u64 vp_bitmap[KVM_HV_MAX_SPARSE_VCPU_SET_BITS];
> @@ -1837,8 +1836,6 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc, bool
>  		}
>  	}
>  
> -	cpumask_clear(&hv_vcpu->tlb_flush);
> -
>  	/*
>  	 * vcpu->arch.cr3 may not be up-to-date for running vCPUs so we can't
>  	 * analyze it here, flush TLB regardless of the specified address space.
> @@ -1850,7 +1847,7 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc, bool
>  						    vp_bitmap, vcpu_bitmap);
>  
>  		kvm_make_vcpus_request_mask(kvm, KVM_REQ_TLB_FLUSH_GUEST,
> -					    vcpu_mask, &hv_vcpu->tlb_flush);
> +					    vcpu_mask);
>  	}
>  
>  ret_success:
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index a4752dcc2a75..91c1e6c98b0f 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9224,14 +9224,8 @@ static void process_smi(struct kvm_vcpu *vcpu)
>  void kvm_make_scan_ioapic_request_mask(struct kvm *kvm,
>  				       unsigned long *vcpu_bitmap)
>  {
> -	cpumask_var_t cpus;
> -
> -	zalloc_cpumask_var(&cpus, GFP_ATOMIC);
> -
>  	kvm_make_vcpus_request_mask(kvm, KVM_REQ_SCAN_IOAPIC,
> -				    vcpu_bitmap, cpus);
> -
> -	free_cpumask_var(cpus);
> +				    vcpu_bitmap);

This can opportunistically all go on a single line.

>  }
>  
>  void kvm_make_scan_ioapic_request(struct kvm *kvm)
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 2f149ed140f7..1ee85de0bf74 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -160,7 +160,7 @@ static inline bool is_error_page(struct page *page)
>  #define KVM_ARCH_REQ(nr)           KVM_ARCH_REQ_FLAGS(nr, 0)
>  
>  bool kvm_make_vcpus_request_mask(struct kvm *kvm, unsigned int req,
> -				 unsigned long *vcpu_bitmap, cpumask_var_t tmp);
> +				 unsigned long *vcpu_bitmap);
>  bool kvm_make_all_cpus_request(struct kvm *kvm, unsigned int req);
>  bool kvm_make_all_cpus_request_except(struct kvm *kvm, unsigned int req,
>  				      struct kvm_vcpu *except);
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 2f5fe4f54a51..dc52a04f0586 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -274,14 +274,6 @@ static void kvm_make_vcpu_request(struct kvm *kvm, struct kvm_vcpu *vcpu,
>  	if (!(req & KVM_REQUEST_NO_WAKEUP) && kvm_vcpu_wake_up(vcpu))
>  		return;
>  
> -	/*
> -	 * tmp can be "unavailable" if cpumasks are allocated off stack as
> -	 * allocation of the mask is deliberately not fatal and is handled by
> -	 * falling back to kicking all online CPUs.
> -	 */
> -	if (!cpumask_available(tmp))
> -		return;

Hmm, maybe convert the param to an explicit "struct cpumask *" to try and convey
that cpumask_available() doesn't need to be checked?

And I believe you can also do:

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index dc52a04f0586..bfd2ecbd97a8 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -247,15 +247,8 @@ static void ack_flush(void *_completed)
 {
 }
 
-static inline bool kvm_kick_many_cpus(cpumask_var_t tmp, bool wait)
+static inline bool kvm_kick_many_cpus(struct cpumask *cpus, bool wait)
 {
-       const struct cpumask *cpus;
-
-       if (likely(cpumask_available(tmp)))
-               cpus = tmp;
-       else
-               cpus = cpu_online_mask;
-
        if (cpumask_empty(cpus))
                return false;
 
> -
>  	/*
>  	 * Note, the vCPU could get migrated to a different pCPU at any point
>  	 * after kvm_request_needs_ipi(), which could result in sending an IPI
> @@ -300,22 +292,26 @@ static void kvm_make_vcpu_request(struct kvm *kvm, struct kvm_vcpu *vcpu,
>  }
>  
>  bool kvm_make_vcpus_request_mask(struct kvm *kvm, unsigned int req,
> -				 unsigned long *vcpu_bitmap, cpumask_var_t tmp)
> +				 unsigned long *vcpu_bitmap)
>  {
>  	struct kvm_vcpu *vcpu;
> +	struct cpumask *cpus;
>  	int i, me;
>  	bool called;
>  
>  	me = get_cpu();
>  
> +	cpus = this_cpu_cpumask_var_ptr(cpu_kick_mask);
> +	cpumask_clear(cpus);
> +
>  	for_each_set_bit(i, vcpu_bitmap, KVM_MAX_VCPUS) {
>  		vcpu = kvm_get_vcpu(kvm, i);
>  		if (!vcpu)
>  			continue;
> -		kvm_make_vcpu_request(kvm, vcpu, req, tmp, me);
> +		kvm_make_vcpu_request(kvm, vcpu, req, cpus, me);
>  	}
>  
> -	called = kvm_kick_many_cpus(tmp, !!(req & KVM_REQUEST_WAIT));
> +	called = kvm_kick_many_cpus(cpus, !!(req & KVM_REQUEST_WAIT));
>  	put_cpu();
>  
>  	return called;
> -- 
> 2.31.1
> 
