Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDD6552319F
	for <lists+kvm@lfdr.de>; Wed, 11 May 2022 13:31:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237019AbiEKL3v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 May 2022 07:29:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231186AbiEKL3j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 May 2022 07:29:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3893721E20
        for <kvm@vger.kernel.org>; Wed, 11 May 2022 04:29:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652268577;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RfFVtWrguQUq5m+0EioS7ITOQ+/4JKsc3d9RLIfqY9A=;
        b=Wrbo4AW6cKBf18FNEC386KuiiIl6RmvmAxaQ9xCZUuQ/EWncJu83dAZQ7KSeAhDPMg/sVl
        eR1srvIFEHtLmaO76gDveaOh5Oe6O1l+kFg8Z9IVkJXV4bgk6yqDbtc98r5sh16wIrvWsu
        PxiCzQQTNyZicd9Y63OySSxIrzn4PIA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-259-QgjKKuFLNCKfHcoqALwGCg-1; Wed, 11 May 2022 07:29:36 -0400
X-MC-Unique: QgjKKuFLNCKfHcoqALwGCg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B7F493C10227;
        Wed, 11 May 2022 11:29:35 +0000 (UTC)
Received: from starship (unknown [10.40.192.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2D8B7146938F;
        Wed, 11 May 2022 11:29:32 +0000 (UTC)
Message-ID: <5fd97722d15ef6a38622adceb65295afa72a9a8f.camel@redhat.com>
Subject: Re: [PATCH v3 16/34] KVM: x86: hyper-v: L2 TLB flush
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Wed, 11 May 2022 14:29:32 +0300
In-Reply-To: <20220414132013.1588929-17-vkuznets@redhat.com>
References: <20220414132013.1588929-1-vkuznets@redhat.com>
         <20220414132013.1588929-17-vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-04-14 at 15:19 +0200, Vitaly Kuznetsov wrote:
> Handle L2 TLB flush requests by going through all vCPUs and checking
> whether there are vCPUs running the same VM_ID with a VP_ID specified
> in the requests. Perform synthetic exit to L2 upon finish.
> 
> Note, while checking VM_ID/VP_ID of running vCPUs seem to be a bit
> racy, we count on the fact that KVM flushes the whole L2 VPID upon
> transition. Also, KVM_REQ_HV_TLB_FLUSH request needs to be done upon
> transition between L1 and L2 to make sure all pending requests are
> always processed.
> 
> For the reference, Hyper-V TLFS refers to the feature as "Direct
> Virtual Flush".
> 
> Note, nVMX/nSVM code does not handle VMCALL/VMMCALL from L2 yet.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/kvm/hyperv.c | 73 ++++++++++++++++++++++++++++++++++++-------
>  arch/x86/kvm/hyperv.h |  3 --
>  arch/x86/kvm/trace.h  | 21 ++++++++-----
>  3 files changed, 74 insertions(+), 23 deletions(-)
> 
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index e9793d36acca..79aabe0c33ec 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -34,6 +34,7 @@
>  #include <linux/eventfd.h>
>  
>  #include <asm/apicdef.h>
> +#include <asm/mshyperv.h>
>  #include <trace/events/kvm.h>
>  
>  #include "trace.h"
> @@ -1842,9 +1843,10 @@ static inline int hv_tlb_flush_ring_free(struct kvm_vcpu_hv *hv_vcpu,
>  	return read_idx - write_idx - 1;
>  }
>  
> -static void hv_tlb_flush_ring_enqueue(struct kvm_vcpu *vcpu, u64 *entries, int count)
> +static void hv_tlb_flush_ring_enqueue(struct kvm_vcpu *vcpu,
> +				      struct kvm_vcpu_hv_tlb_flush_ring *tlb_flush_ring,
> +				      u64 *entries, int count)
>  {
> -	struct kvm_vcpu_hv_tlb_flush_ring *tlb_flush_ring;
>  	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
>  	int ring_free, write_idx, read_idx;
>  	unsigned long flags;
> @@ -1853,9 +1855,6 @@ static void hv_tlb_flush_ring_enqueue(struct kvm_vcpu *vcpu, u64 *entries, int c
>  	if (!hv_vcpu)
>  		return;
>  
> -	/* kvm_hv_flush_tlb() is not ready to handle requests for L2s yet */
> -	tlb_flush_ring = &hv_vcpu->tlb_flush_ring[HV_L1_TLB_FLUSH_RING];
> -
>  	spin_lock_irqsave(&tlb_flush_ring->write_lock, flags);
>  
>  	/*
> @@ -1974,6 +1973,7 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
>  	struct hv_tlb_flush_ex flush_ex;
>  	struct hv_tlb_flush flush;
>  	DECLARE_BITMAP(vcpu_mask, KVM_MAX_VCPUS);
> +	struct kvm_vcpu_hv_tlb_flush_ring *tlb_flush_ring;
>  	/*
>  	 * Normally, there can be no more than 'KVM_HV_TLB_FLUSH_RING_SIZE - 1'
>  	 * entries on the TLB Flush ring as when 'read_idx == write_idx' the
> @@ -2018,7 +2018,8 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
>  		}
>  
>  		trace_kvm_hv_flush_tlb(flush.processor_mask,
> -				       flush.address_space, flush.flags);
> +				       flush.address_space, flush.flags,
> +				       is_guest_mode(vcpu));
>  
>  		valid_bank_mask = BIT_ULL(0);
>  		sparse_banks[0] = flush.processor_mask;
> @@ -2049,7 +2050,7 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
>  		trace_kvm_hv_flush_tlb_ex(flush_ex.hv_vp_set.valid_bank_mask,
>  					  flush_ex.hv_vp_set.format,
>  					  flush_ex.address_space,
> -					  flush_ex.flags);
> +					  flush_ex.flags, is_guest_mode(vcpu));
>  
>  		valid_bank_mask = flush_ex.hv_vp_set.valid_bank_mask;
>  		all_cpus = flush_ex.hv_vp_set.format !=
> @@ -2083,23 +2084,54 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
>  		tlb_flush_entries = __tlb_flush_entries;
>  	}
>  
> +	tlb_flush_ring = kvm_hv_get_tlb_flush_ring(vcpu);
> +
>  	/*
>  	 * vcpu->arch.cr3 may not be up-to-date for running vCPUs so we can't
>  	 * analyze it here, flush TLB regardless of the specified address space.
>  	 */
> -	if (all_cpus) {
> +	if (all_cpus && !is_guest_mode(vcpu)) {
>  		kvm_for_each_vcpu(i, v, kvm)
> -			hv_tlb_flush_ring_enqueue(v, tlb_flush_entries, hc->rep_cnt);
> +			hv_tlb_flush_ring_enqueue(v, tlb_flush_ring,
> +						  tlb_flush_entries, hc->rep_cnt);
>  
>  		kvm_make_all_cpus_request(kvm, KVM_REQ_HV_TLB_FLUSH);
> -	} else {
> +	} else if (!is_guest_mode(vcpu)) {
>  		sparse_set_to_vcpu_mask(kvm, sparse_banks, valid_bank_mask, vcpu_mask);
>  
>  		for_each_set_bit(i, vcpu_mask, KVM_MAX_VCPUS) {
>  			v = kvm_get_vcpu(kvm, i);
>  			if (!v)
>  				continue;
> -			hv_tlb_flush_ring_enqueue(v, tlb_flush_entries, hc->rep_cnt);
> +			hv_tlb_flush_ring_enqueue(v, tlb_flush_ring,
> +						  tlb_flush_entries, hc->rep_cnt);
> +		}
> +
> +		kvm_make_vcpus_request_mask(kvm, KVM_REQ_HV_TLB_FLUSH, vcpu_mask);
> +	} else {
> +		struct kvm_vcpu_hv *hv_v;
> +
> +		bitmap_zero(vcpu_mask, KVM_MAX_VCPUS);
> +
> +		kvm_for_each_vcpu(i, v, kvm) {
> +			hv_v = to_hv_vcpu(v);
> +
> +			/*
> +			 * TLB is fully flushed on L2 VM change: either by KVM
> +			 * (on a eVMPTR switch) or by L1 hypervisor (in case it
> +			 * re-purposes the active eVMCS for a different VM/VP).
> +			 */
> +			if (!hv_v || hv_v->nested.vm_id != hv_vcpu->nested.vm_id)
> +				continue;

This is indeed racy, but I think it is OK.

Nitpick:

I think that this does need a better comment on why the race is OK.
The current comment explains that we flush the TLB but doesn't explain
why that is sufficient.

I would probably write something like that:


"This races with nested vCPUs entering/exiting and/or migrating between
the L1's vCPUs.

However the only case when we want to actually flush the TLB
of the target nested vCPU is when it was running non-stop on same L1 vCPU
since the moment the flush request was created and till now.

Otherwise either the target nested vCPU is not running and it will flush
its TLB, once it runs again, or it already flushed its TLB by exiting
to L1 and entring itself again (possibly on a different L1 vCPU)"



> +
> +			if (!all_cpus &&
> +			    !hv_is_vp_in_sparse_set(hv_v->nested.vp_id, valid_bank_mask,
> +						    sparse_banks))
> +				continue;
> +
> +			__set_bit(i, vcpu_mask);
> +			hv_tlb_flush_ring_enqueue(v, tlb_flush_ring,
> +						  tlb_flush_entries, hc->rep_cnt);



>  		}
>  
>  		kvm_make_vcpus_request_mask(kvm, KVM_REQ_HV_TLB_FLUSH, vcpu_mask);
> @@ -2287,10 +2319,27 @@ static void kvm_hv_hypercall_set_result(struct kvm_vcpu *vcpu, u64 result)
>  
>  static int kvm_hv_hypercall_complete(struct kvm_vcpu *vcpu, u64 result)
>  {
> +	int ret;
> +
>  	trace_kvm_hv_hypercall_done(result);
>  	kvm_hv_hypercall_set_result(vcpu, result);
>  	++vcpu->stat.hypercalls;
> -	return kvm_skip_emulated_instruction(vcpu);
> +	ret = kvm_skip_emulated_instruction(vcpu);
> +
> +	if (unlikely(hv_result_success(result) && is_guest_mode(vcpu)
> +		     && kvm_hv_is_tlb_flush_hcall(vcpu))) {
> +		struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
> +		u32 tlb_lock_count;
> +
> +		if (unlikely(kvm_read_guest(vcpu->kvm, hv_vcpu->nested.pa_page_gpa,
> +					    &tlb_lock_count, sizeof(tlb_lock_count))))
> +			kvm_inject_gp(vcpu, 0);
> +
> +		if (tlb_lock_count)
> +			kvm_x86_ops.nested_ops->post_hv_l2_tlb_flush(vcpu);
> +	}
> +
> +	return ret;
>  }
>  
>  static int kvm_hv_hypercall_complete_userspace(struct kvm_vcpu *vcpu)
> diff --git a/arch/x86/kvm/hyperv.h b/arch/x86/kvm/hyperv.h
> index ca67c18cef2c..f593c9fd1dee 100644
> --- a/arch/x86/kvm/hyperv.h
> +++ b/arch/x86/kvm/hyperv.h
> @@ -154,9 +154,6 @@ static inline struct kvm_vcpu_hv_tlb_flush_ring *kvm_hv_get_tlb_flush_ring(struc
>  	int i = !is_guest_mode(vcpu) ? HV_L1_TLB_FLUSH_RING :
>  		HV_L2_TLB_FLUSH_RING;
>  
> -	/* KVM does not handle L2 TLB flush requests yet */
> -	WARN_ON_ONCE(i != HV_L1_TLB_FLUSH_RING);
> -
>  	return &hv_vcpu->tlb_flush_ring[i];
>  }
>  
> diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
> index e3a24b8f04be..af7896182935 100644
> --- a/arch/x86/kvm/trace.h
> +++ b/arch/x86/kvm/trace.h
> @@ -1479,38 +1479,41 @@ TRACE_EVENT(kvm_hv_timer_state,
>   * Tracepoint for kvm_hv_flush_tlb.
>   */
>  TRACE_EVENT(kvm_hv_flush_tlb,
> -	TP_PROTO(u64 processor_mask, u64 address_space, u64 flags),
> -	TP_ARGS(processor_mask, address_space, flags),
> +	TP_PROTO(u64 processor_mask, u64 address_space, u64 flags, bool guest_mode),
> +	TP_ARGS(processor_mask, address_space, flags, guest_mode),
>  
>  	TP_STRUCT__entry(
>  		__field(u64, processor_mask)
>  		__field(u64, address_space)
>  		__field(u64, flags)
> +		__field(bool, guest_mode)
>  	),
>  
>  	TP_fast_assign(
>  		__entry->processor_mask = processor_mask;
>  		__entry->address_space = address_space;
>  		__entry->flags = flags;
> +		__entry->guest_mode = guest_mode;
>  	),
>  
> -	TP_printk("processor_mask 0x%llx address_space 0x%llx flags 0x%llx",
> +	TP_printk("processor_mask 0x%llx address_space 0x%llx flags 0x%llx %s",
>  		  __entry->processor_mask, __entry->address_space,
> -		  __entry->flags)
> +		  __entry->flags, __entry->guest_mode ? "(L2)" : "")
>  );
>  
>  /*
>   * Tracepoint for kvm_hv_flush_tlb_ex.
>   */
>  TRACE_EVENT(kvm_hv_flush_tlb_ex,
> -	TP_PROTO(u64 valid_bank_mask, u64 format, u64 address_space, u64 flags),
> -	TP_ARGS(valid_bank_mask, format, address_space, flags),
> +	TP_PROTO(u64 valid_bank_mask, u64 format, u64 address_space, u64 flags, bool guest_mode),
> +	TP_ARGS(valid_bank_mask, format, address_space, flags, guest_mode),
>  
>  	TP_STRUCT__entry(
>  		__field(u64, valid_bank_mask)
>  		__field(u64, format)
>  		__field(u64, address_space)
>  		__field(u64, flags)
> +		__field(bool, guest_mode)
>  	),
>  
>  	TP_fast_assign(
> @@ -1518,12 +1521,14 @@ TRACE_EVENT(kvm_hv_flush_tlb_ex,
>  		__entry->format = format;
>  		__entry->address_space = address_space;
>  		__entry->flags = flags;
> +		__entry->guest_mode = guest_mode;
>  	),
>  
>  	TP_printk("valid_bank_mask 0x%llx format 0x%llx "
> -		  "address_space 0x%llx flags 0x%llx",
> +		  "address_space 0x%llx flags 0x%llx %s",
>  		  __entry->valid_bank_mask, __entry->format,
> -		  __entry->address_space, __entry->flags)
> +		  __entry->address_space, __entry->flags,
> +		  __entry->guest_mode ? "(L2)" : "")
>  );
>  
>  /*


Looks OK, I might have missed something.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky



