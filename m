Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8222A4F8711
	for <lists+kvm@lfdr.de>; Thu,  7 Apr 2022 20:27:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346829AbiDGS3b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Apr 2022 14:29:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232594AbiDGS3a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Apr 2022 14:29:30 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B266EDF3A
        for <kvm@vger.kernel.org>; Thu,  7 Apr 2022 11:27:29 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id z128so5685026pgz.2
        for <kvm@vger.kernel.org>; Thu, 07 Apr 2022 11:27:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rsuCEqLQQ74Tb9m4GVxSd/1UpzsR3hOIhJKOGvm4xF8=;
        b=rs9AxqzBVVdC3lGFuzBP/7R1LxYiB4Uvib3hRNJ+d5jjt9vr9EDeYhS2hpm0Q6mbgP
         qNqfXEwfpR3KNqn6q4pyvcfaivhFTZUsaDMxFMP3Bm4oCsk8XM2/iiaUsJEx+HvB6kOm
         Z6LoZjT9UiOey6yHOB3E1BCFmuLi28nihoAE3Sq0ya1wAIRTYcYgy/CtBrvbWXgXgqBW
         AGYsu3X1nOasLpIpm0jIG/CvO5oWF3dMhZ0HMM90S4fGbcCS3YLSlE69z/YqZeSzlkhs
         VPV1QeGpDbtFCFwK+aGDn/0bUWHfv2UL/MXAbGWNOw1drXex98tiqEnMrBybpuw3x0zT
         bsNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rsuCEqLQQ74Tb9m4GVxSd/1UpzsR3hOIhJKOGvm4xF8=;
        b=Ew6dx7MvuUsIrGro2mgR7gXL4mDKYVIDUPa6kCsk75fJL3+1bF2Mq/ZxDOe4SN52cI
         7L6Z/GFD0tZvXegqKFzT74ulpmLqCfFRqjcoRZPZAGZSLZAqQhewSJlo0CV6D7LL3zRp
         KpeGc5Pog3teutcyMnc4SPo2GIAaVURg5b1m2YKtawhC+x9F7jjSE76jw1PO/90qFBo0
         QT7M7u6x8LdpY9aRMJUHQuvGhc+jNAyIjwENTeEHGBct6i/mKtxa+iYii4/rCwsNsXA/
         cwYl8hzMlLLqvFWIlf98rm1mbTeJPmPf0dTixoZCxruCR21mh45LTZQ2KKjzKOOX/EtK
         Oygg==
X-Gm-Message-State: AOAM532RWtfJ2bWqesHutgG969ELKUICpG3dtbv6Pqe0ibMlLtECMpo/
        R2R0dIC+H4PxsjSR8nf+8aA4VA==
X-Google-Smtp-Source: ABdhPJwn/b9IeigKLkP2Mgq8BSp99ItA2mc0j9ELaxJ/BYrAw26X+s3NSQ6cUrPRGUoM9D/II9hh3A==
X-Received: by 2002:a63:4d66:0:b0:399:14fa:2acc with SMTP id n38-20020a634d66000000b0039914fa2accmr12539023pgl.558.1649356048708;
        Thu, 07 Apr 2022 11:27:28 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id f20-20020a056a00229400b004fb16860af6sm24230189pfe.195.2022.04.07.11.27.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Apr 2022 11:27:28 -0700 (PDT)
Date:   Thu, 7 Apr 2022 18:27:24 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 13/31] KVM: x86: hyper-v: Direct TLB flush
Message-ID: <Yk8tDHc5E8SkOVqB@google.com>
References: <20220407155645.940890-1-vkuznets@redhat.com>
 <20220407155645.940890-14-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220407155645.940890-14-vkuznets@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 07, 2022, Vitaly Kuznetsov wrote:
> Handle Direct TLB flush requests from L2 by going through all vCPUs

What is a "Direct TLB flush request" in this context?  I can't tell if "direct"
refers to the MMU being direct, or if it has some other Hyper-V specific meaning.

Ewww, it looks to be Hyper-V terminology.  Now I see that @direct=true is getting
L2's ring, not L1's ring.  That's all kinds of evil.  That confusion goes away with
my suggestion below, but this shortlog and changelog (and the ones for nVMX and
nSVM enabling) absolutely need to clarify "direct" since it conflicts mightily
with KVM's "direct" terminology.

In fact, unless I'm missing a patch where "Direct" doesn't mean "From L2", I vote
to not use the "Direct TLB flush" terminology in any of the shortlogs or changelogs
and only add a footnote to this first changelog to call out that the TLFS (or
wherever this terminology came from) calls these types of flushes "Direct".

> and checking whether there are vCPUs running the same VM_ID with a
> VP_ID specified in the requests. Perform synthetic exit to L2 upon
> finish.
> 
> Note, while checking VM_ID/VP_ID of running vCPUs seem to be a bit
> racy, we count on the fact that KVM flushes the whole L2 VPID upon
> transition. Also, KVM_REQ_HV_TLB_FLUSH request needs to be done upon
> transition between L1 and L2 to make sure all pending requests are
> always processed.
> 
> Note, while nVMX/nSVM code does not handle VMCALL/VMMCALL from L2 yet.

Spurious "while"?  Or is there a missing second half of the note?

> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/kvm/hyperv.c | 65 ++++++++++++++++++++++++++++++++++++-------
>  arch/x86/kvm/trace.h  | 21 ++++++++------
>  2 files changed, 68 insertions(+), 18 deletions(-)
> 
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index 705c0b739c1b..2b12f1b5c992 100644
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
> @@ -1849,8 +1850,8 @@ static inline int hv_tlb_flush_ring_free(struct kvm_vcpu_hv *hv_vcpu,
>  	return read_idx - write_idx - 1;
>  }
>  
> -static void hv_tlb_flush_ring_enqueue(struct kvm_vcpu *vcpu, bool flush_all,
> -				      u64 *entries, int count)
> +static void hv_tlb_flush_ring_enqueue(struct kvm_vcpu *vcpu, bool direct,
> +				      bool flush_all, u64 *entries, int count)
>  {
>  	struct kvm_vcpu_hv_tlbflush_ring *tlb_flush_ring;
>  	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
> @@ -1861,7 +1862,7 @@ static void hv_tlb_flush_ring_enqueue(struct kvm_vcpu *vcpu, bool flush_all,
>  	if (!hv_vcpu)
>  		return;
>  
> -	tlb_flush_ring = &hv_vcpu->tlb_flush_ring[0];
> +	tlb_flush_ring = direct ? &hv_vcpu->tlb_flush_ring[1] : &hv_vcpu->tlb_flush_ring[0];

Rather than pass in @direct and open code indexing into the ring array, pass in
the ring, then the magic boolean goes away along with its confusing terminology.

	tlb_flush_ring = kvm_hv_get_tlb_flush_ring(vcpu);

	/*
	 * vcpu->arch.cr3 may not be up-to-date for running vCPUs so we can't
	 * analyze it here, flush TLB regardless of the specified address space.
	 */
	if (all_cpus && !is_guest_mode(vcpu)) {
		kvm_for_each_vcpu(i, v, kvm)
			hv_tlb_flush_ring_enqueue(v, tlb_flush_ring,
						  tlb_flush_entries, hc->rep_cnt);

		kvm_make_all_cpus_request(kvm, KVM_REQ_HV_TLB_FLUSH);
	} else if (!is_guest_mode(vcpu)) {
		sparse_set_to_vcpu_mask(kvm, sparse_banks, valid_bank_mask, vcpu_mask);

		for_each_set_bit(i, vcpu_mask, KVM_MAX_VCPUS) {
			v = kvm_get_vcpu(kvm, i);
			if (!v)
				continue;
			hv_tlb_flush_ring_enqueue(v, tlb_flush_ring,
						  tlb_flush_entries, hc->rep_cnt);
		}

		kvm_make_vcpus_request_mask(kvm, KVM_REQ_HV_TLB_FLUSH, vcpu_mask);
	} else {
		struct kvm_vcpu_hv *hv_v;

		bitmap_zero(vcpu_mask, KVM_MAX_VCPUS);

		kvm_for_each_vcpu(i, v, kvm) {
			hv_v = to_hv_vcpu(v);

			/*
			 * TLB is fully flushed on L2 VM change: either by KVM
			 * (on a eVMPTR switch) or by L1 hypervisor (in case it
			 * re-purposes the active eVMCS for a different VM/VP).
			 */
			if (!hv_v || hv_v->nested.vm_id != hv_vcpu->nested.vm_id)
				continue;

			if (!all_cpus &&
			    !hv_is_vp_in_sparse_set(hv_v->nested.vp_id, valid_bank_mask,
						    sparse_banks))
				continue;

			__set_bit(i, vcpu_mask);
			hv_tlb_flush_ring_enqueue(v, tlb_flush_ring, tlb_flush_entries, hc->rep_cnt);
		}

		kvm_make_vcpus_request_mask(kvm, KVM_REQ_HV_TLB_FLUSH, vcpu_mask);
	}


>  	spin_lock_irqsave(&tlb_flush_ring->write_lock, flags);
>  

...

>  static int kvm_hv_hypercall_complete_userspace(struct kvm_vcpu *vcpu)
> diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
> index e3a24b8f04be..4241b7c0245e 100644
> --- a/arch/x86/kvm/trace.h
> +++ b/arch/x86/kvm/trace.h
> @@ -1479,38 +1479,41 @@ TRACE_EVENT(kvm_hv_timer_state,
>   * Tracepoint for kvm_hv_flush_tlb.
>   */
>  TRACE_EVENT(kvm_hv_flush_tlb,
> -	TP_PROTO(u64 processor_mask, u64 address_space, u64 flags),
> -	TP_ARGS(processor_mask, address_space, flags),
> +	TP_PROTO(u64 processor_mask, u64 address_space, u64 flags, bool direct),
> +	TP_ARGS(processor_mask, address_space, flags, direct),

I very strongly prefer direct be guest_mode here, and then print out L1 vs L2 in
the tracepoint itself.  There's no reason to overload "direct". 

>  	TP_STRUCT__entry(
>  		__field(u64, processor_mask)
>  		__field(u64, address_space)
>  		__field(u64, flags)
> +		__field(bool, direct)
>  	),
>  
>  	TP_fast_assign(
>  		__entry->processor_mask = processor_mask;
>  		__entry->address_space = address_space;
>  		__entry->flags = flags;
> +		__entry->direct = direct;
>  	),
>  
> -	TP_printk("processor_mask 0x%llx address_space 0x%llx flags 0x%llx",
> +	TP_printk("processor_mask 0x%llx address_space 0x%llx flags 0x%llx %s",
>  		  __entry->processor_mask, __entry->address_space,
> -		  __entry->flags)
> +		  __entry->flags, __entry->direct ? "(direct)" : "")
>  );
>  
>  /*
>   * Tracepoint for kvm_hv_flush_tlb_ex.
>   */
>  TRACE_EVENT(kvm_hv_flush_tlb_ex,
> -	TP_PROTO(u64 valid_bank_mask, u64 format, u64 address_space, u64 flags),
> -	TP_ARGS(valid_bank_mask, format, address_space, flags),
> +	TP_PROTO(u64 valid_bank_mask, u64 format, u64 address_space, u64 flags, bool direct),
> +	TP_ARGS(valid_bank_mask, format, address_space, flags, direct),
>  
>  	TP_STRUCT__entry(
>  		__field(u64, valid_bank_mask)
>  		__field(u64, format)
>  		__field(u64, address_space)
>  		__field(u64, flags)
> +		__field(bool, direct)
>  	),
>  
>  	TP_fast_assign(
> @@ -1518,12 +1521,14 @@ TRACE_EVENT(kvm_hv_flush_tlb_ex,
>  		__entry->format = format;
>  		__entry->address_space = address_space;
>  		__entry->flags = flags;
> +		__entry->direct = direct;
>  	),
>  
>  	TP_printk("valid_bank_mask 0x%llx format 0x%llx "
> -		  "address_space 0x%llx flags 0x%llx",
> +		  "address_space 0x%llx flags 0x%llx %s",
>  		  __entry->valid_bank_mask, __entry->format,
> -		  __entry->address_space, __entry->flags)
> +		  __entry->address_space, __entry->flags,
> +		  __entry->direct ? "(direct)" : "")
>  );
>  
>  /*
> -- 
> 2.35.1
> 
