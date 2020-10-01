Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 963422809BC
	for <lists+kvm@lfdr.de>; Thu,  1 Oct 2020 23:55:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733030AbgJAVzR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Oct 2020 17:55:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:59452 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726741AbgJAVzR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 1 Oct 2020 17:55:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601589314;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UhWBNVgG7bXJniWjsy3kSOIUqJW7e1iK+5sneLiOJ1E=;
        b=B7+zcYNijUX3Nrl2z4hdauMQ9D12Kv/8LD6tAsbs6NWv2lG8RLMYLXVAYzTMKwZh8HH/ml
        pK7ri1VoTzbrooYSS3U84FhTlt5SQ0+3lCHC9SJo9WlxYjnoE19s3c8TbyeE3cYSTL4H0/
        WVVteOCB5dtTEm7ellCcBPft48cepwE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-276-DWjzUPZTPnaiO3qv9uI01g-1; Thu, 01 Oct 2020 17:55:13 -0400
X-MC-Unique: DWjzUPZTPnaiO3qv9uI01g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 33205108E1A0;
        Thu,  1 Oct 2020 21:55:12 +0000 (UTC)
Received: from horse.redhat.com (ovpn-116-14.rdu2.redhat.com [10.10.116.14])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0AAA47366F;
        Thu,  1 Oct 2020 21:55:09 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id 7A304220641; Thu,  1 Oct 2020 17:55:08 -0400 (EDT)
Date:   Thu, 1 Oct 2020 17:55:08 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtio-fs-list <virtio-fs@redhat.com>, vkuznets@redhat.com,
        pbonzini@redhat.com
Subject: Re: [PATCH v4] kvm,x86: Exit to user space in case page fault error
Message-ID: <20201001215508.GD3522@redhat.com>
References: <20200720211359.GF502563@redhat.com>
 <20200929043700.GL31514@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200929043700.GL31514@linux.intel.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 28, 2020 at 09:37:00PM -0700, Sean Christopherson wrote:
> On Mon, Jul 20, 2020 at 05:13:59PM -0400, Vivek Goyal wrote:
> > ---
> >  arch/x86/include/asm/kvm_host.h |  2 ++
> >  arch/x86/kvm/mmu.h              |  2 +-
> >  arch/x86/kvm/mmu/mmu.c          |  2 +-
> >  arch/x86/kvm/x86.c              | 54 +++++++++++++++++++++++++++++++--
> >  include/linux/kvm_types.h       |  1 +
> >  5 files changed, 56 insertions(+), 5 deletions(-)
> > 
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index be5363b21540..e6f8d3f1a377 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -137,6 +137,7 @@ static inline gfn_t gfn_to_index(gfn_t gfn, gfn_t base_gfn, int level)
> >  #define KVM_NR_VAR_MTRR 8
> >  
> >  #define ASYNC_PF_PER_VCPU 64
> > +#define ERROR_GFN_PER_VCPU 64
> 
> Aren't these two related?  I.e. wouldn't it make sense to do:

Hi,

They are related somewhat but they don't have to be same. I think we
can accumulate many more error GFNs if this vcpu does not schedule
the same task again to retry.

>   #define ERROR_GFN_PER_VCPU ASYNC_PF_PER_VCPU
> 
> Or maybe even size error_gfns[] to ASYNC_PF_PER_VCPU?

Given these two don't have to be same, I kept it separate. And kept the
hash size same for now. If one wants, hash can be bigger or smaller
down the line.

> 
> >  
> >  enum kvm_reg {
> >  	VCPU_REGS_RAX = __VCPU_REGS_RAX,
> > @@ -778,6 +779,7 @@ struct kvm_vcpu_arch {
> >  		unsigned long nested_apf_token;
> >  		bool delivery_as_pf_vmexit;
> >  		bool pageready_pending;
> > +		gfn_t error_gfns[ERROR_GFN_PER_VCPU];
> >  	} apf;
> >  
> >  	/* OSVW MSRs (AMD only) */
> > diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> > index 444bb9c54548..d0a2a12c7bb6 100644
> > --- a/arch/x86/kvm/mmu.h
> > +++ b/arch/x86/kvm/mmu.h
> > @@ -60,7 +60,7 @@ void kvm_init_mmu(struct kvm_vcpu *vcpu, bool reset_roots);
> >  void kvm_init_shadow_mmu(struct kvm_vcpu *vcpu, u32 cr0, u32 cr4, u32 efer);
> >  void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly,
> >  			     bool accessed_dirty, gpa_t new_eptp);
> > -bool kvm_can_do_async_pf(struct kvm_vcpu *vcpu);
> > +bool kvm_can_do_async_pf(struct kvm_vcpu *vcpu, gfn_t gfn);
> >  int kvm_handle_page_fault(struct kvm_vcpu *vcpu, u64 error_code,
> >  				u64 fault_address, char *insn, int insn_len);
> >  
> 
> ...
> 
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 88c593f83b28..c1f5094d6e53 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -263,6 +263,13 @@ static inline void kvm_async_pf_hash_reset(struct kvm_vcpu *vcpu)
> >  		vcpu->arch.apf.gfns[i] = ~0;
> >  }
> >  
> > +static inline void kvm_error_gfn_hash_reset(struct kvm_vcpu *vcpu)
> > +{
> > +	int i;
> 
> Need a newline.   

Will do.

> 
> > +	for (i = 0; i < ERROR_GFN_PER_VCPU; i++)
> > +		vcpu->arch.apf.error_gfns[i] = GFN_INVALID;
> > +}
> > +
> >  static void kvm_on_user_return(struct user_return_notifier *urn)
> >  {
> >  	unsigned slot;
> > @@ -9484,6 +9491,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
> >  	vcpu->arch.pat = MSR_IA32_CR_PAT_DEFAULT;
> >  
> >  	kvm_async_pf_hash_reset(vcpu);
> > +	kvm_error_gfn_hash_reset(vcpu);
> >  	kvm_pmu_init(vcpu);
> >  
> >  	vcpu->arch.pending_external_vector = -1;
> > @@ -9608,6 +9616,7 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
> >  
> >  	kvm_clear_async_pf_completion_queue(vcpu);
> >  	kvm_async_pf_hash_reset(vcpu);
> > +	kvm_error_gfn_hash_reset(vcpu);
> >  	vcpu->arch.apf.halted = false;
> >  
> >  	if (kvm_mpx_supported()) {
> > @@ -10369,6 +10378,36 @@ void kvm_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags)
> >  }
> >  EXPORT_SYMBOL_GPL(kvm_set_rflags);
> >  
> > +static inline u32 kvm_error_gfn_hash_fn(gfn_t gfn)
> > +{
> > +	BUILD_BUG_ON(!is_power_of_2(ERROR_GFN_PER_VCPU));
> > +
> > +	return hash_32(gfn & 0xffffffff, order_base_2(ERROR_GFN_PER_VCPU));
> > +}
> > +
> > +static void kvm_add_error_gfn(struct kvm_vcpu *vcpu, gfn_t gfn)
> > +{
> > +	u32 key = kvm_error_gfn_hash_fn(gfn);
> > +
> > +	/*
> > +	 * Overwrite the previous gfn. This is just a hint to do
> > +	 * sync page fault.
> > +	 */
> > +	vcpu->arch.apf.error_gfns[key] = gfn;
> > +}
> > +
> > +/* Returns true if gfn was found in hash table, false otherwise */
> > +static bool kvm_find_and_remove_error_gfn(struct kvm_vcpu *vcpu, gfn_t gfn)
> > +{
> > +	u32 key = kvm_error_gfn_hash_fn(gfn);
> 
> Mostly out of curiosity, do we really need a hash?  E.g. could we get away
> with an array of 4 values?  2 values?  Just wondering if we can avoid 64*8
> bytes per CPU.

We are relying on returning error when guest task retries fault. Fault
will be retried on same address if same task is run by vcpu after
"page ready" event. There is no guarantee that same task will be
run. In theory, this cpu could have a large number of tasks queued
and run these tasks before the faulting task is run again. Now say
there are 128 tasks being run and 32 of them have page fault
errors. Then if we keep 4 values, newer failures will simply
overwrite older failures and we will keep spinning instead of
exiting to user space.

That's why this array of 64 gfns and add gfns based on hash. This
does not completely elimiante the above possibility but chances
of one hitting this are very very slim.

> 
> One thought would be to use the index to handle the case of no error gfns so
> that the size of the array doesn't affect lookup for the common case, e.g.

We are calculating hash of gfn (used as index in array). So lookup cost
is not driven by size of array. Its O(1) and not O(N). We just lookup
at one element in array and if it does not match, we return false.

	u32 key = kvm_error_gfn_hash_fn(gfn);

	if (vcpu->arch.apf.error_gfns[key] != gfn)
		return 0;


> 
> 	...
> 
> 		u8 error_gfn_head;
> 		gfn_t error_gfns[ERROR_GFN_PER_VCPU];
> 	} apf;	
> 
> 
> 	if (vcpu->arch.apf.error_gfn_head == 0xff)
> 		return false;
> 
> 	for (i = 0; i < vcpu->arch.apf.error_gfn_head; i++) {
> 		if (vcpu->arch.apf.error_gfns[i] == gfn) {
> 			vcpu->arch.apf.error_gfns[i] = INVALID_GFN;
> 			return true;
> 		}
> 	}
> 	return true;
> 
> Or you could even avoid INVALID_GFN altogether by compacting the array on
> removal.  The VM is probably dead anyways, burning a few cycles to clean
> things up is a non-issue.  Ditto for slow insertion.

Same for insertion. Its O(1) and not dependent on size of array. Also
insertion anyway is very infrequent event because it will not be
often that error will happen.


> 
> > +
> > +	if (vcpu->arch.apf.error_gfns[key] != gfn)
> > +		return 0;
> 
> Should be "return false".

Will fix.

Thanks
Vivek

