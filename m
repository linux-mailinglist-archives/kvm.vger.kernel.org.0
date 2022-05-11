Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64CDD523161
	for <lists+kvm@lfdr.de>; Wed, 11 May 2022 13:23:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231179AbiEKLXC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 May 2022 07:23:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235374AbiEKLW6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 May 2022 07:22:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7B534219C16
        for <kvm@vger.kernel.org>; Wed, 11 May 2022 04:22:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652268176;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FY6oBVbSD93hvwbeQ4xPXV7ZwbAjK5C8u04kzTjqGBM=;
        b=NIINJIU41OfEQLddGfBtX0Ihg6+kvecjZ/W8k/1cjP7bI3lHcTffeH1OE15ui7f2IQWVnY
        gEc0RbKPghUGZ0ejhqKyI1YzQecvLAkRLa0rWCdaqWyxmPro5koCl6RBIiNzluKUW/rTrb
        mKdIZZbjJNJDJZ9CMVFBozfKLpvxV/s=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-562-8rx-E8jqPPSDzaUU6cmh6g-1; Wed, 11 May 2022 07:22:50 -0400
X-MC-Unique: 8rx-E8jqPPSDzaUU6cmh6g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 394EF2932492;
        Wed, 11 May 2022 11:22:50 +0000 (UTC)
Received: from starship (unknown [10.40.192.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E73302026D64;
        Wed, 11 May 2022 11:22:47 +0000 (UTC)
Message-ID: <165aea185dfef1eba9ba0f4fd1c3a95361c41396.camel@redhat.com>
Subject: Re: [PATCH v3 04/34] KVM: x86: hyper-v: Handle
 HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST{,EX} calls gently
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Wed, 11 May 2022 14:22:46 +0300
In-Reply-To: <20220414132013.1588929-5-vkuznets@redhat.com>
References: <20220414132013.1588929-1-vkuznets@redhat.com>
         <20220414132013.1588929-5-vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-04-14 at 15:19 +0200, Vitaly Kuznetsov wrote:
> Currently, HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST{,EX} calls are handled
> the exact same way as HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE{,EX}: by
> flushing the whole VPID and this is sub-optimal. Switch to handling
> these requests with 'flush_tlb_gva()' hooks instead. Use the newly
> introduced TLB flush ring to queue the requests.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/kvm/hyperv.c | 132 ++++++++++++++++++++++++++++++++++++------
>  1 file changed, 115 insertions(+), 17 deletions(-)
> 
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index d66c27fd1e8a..759e1a16e5c3 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -1805,6 +1805,13 @@ static u64 kvm_get_sparse_vp_set(struct kvm *kvm, struct kvm_hv_hcall *hc,
>  				  sparse_banks, consumed_xmm_halves, offset);
>  }
>  
> +static int kvm_hv_get_tlb_flush_entries(struct kvm *kvm, struct kvm_hv_hcall *hc, u64 entries[],
> +				       int consumed_xmm_halves, gpa_t offset)
> +{
> +	return kvm_hv_get_hc_data(kvm, hc, hc->rep_cnt, hc->rep_cnt,
> +				  entries, consumed_xmm_halves, offset);
> +}
> +
>  static inline int hv_tlb_flush_ring_free(struct kvm_vcpu_hv *hv_vcpu,
>  					 int read_idx, int write_idx)
>  {
> @@ -1814,12 +1821,13 @@ static inline int hv_tlb_flush_ring_free(struct kvm_vcpu_hv *hv_vcpu,
>  	return read_idx - write_idx - 1;
>  }
>  
> -static void hv_tlb_flush_ring_enqueue(struct kvm_vcpu *vcpu)
> +static void hv_tlb_flush_ring_enqueue(struct kvm_vcpu *vcpu, u64 *entries, int count)
>  {
>  	struct kvm_vcpu_hv_tlb_flush_ring *tlb_flush_ring;
>  	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
>  	int ring_free, write_idx, read_idx;
>  	unsigned long flags;
> +	int i;
>  
>  	if (!hv_vcpu)
>  		return;
> @@ -1845,14 +1853,34 @@ static void hv_tlb_flush_ring_enqueue(struct kvm_vcpu *vcpu)
>  	if (!ring_free)
>  		goto out_unlock;
>  
> -	tlb_flush_ring->entries[write_idx].addr = 0;
> -	tlb_flush_ring->entries[write_idx].flush_all = 1;
>  	/*
> -	 * Advance write index only after filling in the entry to
> -	 * synchronize with lockless reader.
> +	 * All entries should fit on the ring leaving one free for 'flush all'
> +	 * entry in case another request comes in. In case there's not enough
> +	 * space, just put 'flush all' entry there.
> +	 */
> +	if (!count || count >= ring_free - 1 || !entries) {
> +		tlb_flush_ring->entries[write_idx].addr = 0;
> +		tlb_flush_ring->entries[write_idx].flush_all = 1;
> +		/*
> +		 * Advance write index only after filling in the entry to
> +		 * synchronize with lockless reader.
> +		 */
> +		smp_wmb();
> +		tlb_flush_ring->write_idx = (write_idx + 1) % KVM_HV_TLB_FLUSH_RING_SIZE;
> +		goto out_unlock;
> +	}
> +
> +	for (i = 0; i < count; i++) {
> +		tlb_flush_ring->entries[write_idx].addr = entries[i];
> +		tlb_flush_ring->entries[write_idx].flush_all = 0;
> +		write_idx = (write_idx + 1) % KVM_HV_TLB_FLUSH_RING_SIZE;
> +	}
> +	/*
> +	 * Advance write index only after filling in the entry to synchronize
> +	 * with lockless reader.
>  	 */
>  	smp_wmb();
> -	tlb_flush_ring->write_idx = (write_idx + 1) % KVM_HV_TLB_FLUSH_RING_SIZE;
> +	tlb_flush_ring->write_idx = write_idx;
>  
>  out_unlock:
>  	spin_unlock_irqrestore(&tlb_flush_ring->write_lock, flags);
> @@ -1862,15 +1890,58 @@ void kvm_hv_vcpu_flush_tlb(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_vcpu_hv_tlb_flush_ring *tlb_flush_ring;
>  	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
> +	struct kvm_vcpu_hv_tlb_flush_entry *entry;
> +	int read_idx, write_idx;
> +	u64 address;
> +	u32 count;
> +	int i, j;
>  
> -	kvm_vcpu_flush_tlb_guest(vcpu);
> -
> -	if (!hv_vcpu)
> +	if (!tdp_enabled || !hv_vcpu) {
> +		kvm_vcpu_flush_tlb_guest(vcpu);
>  		return;
> +	}
>  
>  	tlb_flush_ring = &hv_vcpu->tlb_flush_ring;
>  
> -	tlb_flush_ring->read_idx = tlb_flush_ring->write_idx;
> +	/*
> +	 * TLB flush must be performed on the target vCPU so 'read_idx'
> +	 * (AKA 'tail') cannot change underneath, the compiler is free
> +	 * to re-read it.
> +	 */
> +	read_idx = tlb_flush_ring->read_idx;
> +
> +	/*
> +	 * 'write_idx' (AKA 'head') can be concurently updated by a different
> +	 * vCPU so we must be sure it's read once.
> +	 */
> +	write_idx = READ_ONCE(tlb_flush_ring->write_idx);
> +
> +	/* Pairs with smp_wmb() in hv_tlb_flush_ring_enqueue() */
> +	smp_rmb();
> +
> +	for (i = read_idx; i != write_idx; i = (i + 1) % KVM_HV_TLB_FLUSH_RING_SIZE) {
> +		entry = &tlb_flush_ring->entries[i];
> +
> +		if (entry->flush_all)
> +			goto out_flush_all;

I have an idea: instead of special 'flush all entry' in the ring,
just have a boolean in parallel to the ring.

Also the ring buffer entries will be 2x smaller since they won't need
to have the 'flush all' boolean.

This would allow to just flush the whole thing and discard the ring if that boolean is set,
allow to not enqueue anything to the ring also if the boolean is already set,
also we won't need to have extra space in the ring for that entry, etc, etc.

Or if using kfifo, then it can contain plain u64 items, which is even more natural.


> +
> +		/*
> +		 * Lower 12 bits of 'address' encode the number of additional
> +		 * pages to flush.
> +		 */
> +		address = entry->addr & PAGE_MASK;
> +		count = (entry->addr & ~PAGE_MASK) + 1;
> +		for (j = 0; j < count; j++)
> +			static_call(kvm_x86_flush_tlb_gva)(vcpu, address + j * PAGE_SIZE);
> +	}
> +	++vcpu->stat.tlb_flush;
> +	goto out_empty_ring;
> +
> +out_flush_all:
> +	kvm_vcpu_flush_tlb_guest(vcpu);
> +
> +out_empty_ring:
> +	tlb_flush_ring->read_idx = write_idx;
>  }
>  
>  static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
> @@ -1879,11 +1950,22 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
>  	struct hv_tlb_flush_ex flush_ex;
>  	struct hv_tlb_flush flush;
>  	DECLARE_BITMAP(vcpu_mask, KVM_MAX_VCPUS);
> +	/*
> +	 * Normally, there can be no more than 'KVM_HV_TLB_FLUSH_RING_SIZE - 1'
> +	 * entries on the TLB Flush ring as when 'read_idx == write_idx' the
> +	 * ring is considered as empty. The last entry on the ring, however,
> +	 * needs to be always left free for 'flush all' entry which gets placed
> +	 * when there is not enough space to put all the requested entries.
> +	 */
> +	u64 __tlb_flush_entries[KVM_HV_TLB_FLUSH_RING_SIZE - 2];
> +	u64 *tlb_flush_entries;
>  	u64 valid_bank_mask;
>  	u64 sparse_banks[KVM_HV_MAX_SPARSE_VCPU_SET_BITS];
>  	struct kvm_vcpu *v;
>  	unsigned long i;
>  	bool all_cpus;
> +	int consumed_xmm_halves = 0;
> +	gpa_t data_offset;
>  
>  	/*
>  	 * The Hyper-V TLFS doesn't allow more than 64 sparse banks, e.g. the
> @@ -1899,10 +1981,12 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
>  			flush.address_space = hc->ingpa;
>  			flush.flags = hc->outgpa;
>  			flush.processor_mask = sse128_lo(hc->xmm[0]);
> +			consumed_xmm_halves = 1;
>  		} else {
>  			if (unlikely(kvm_read_guest(kvm, hc->ingpa,
>  						    &flush, sizeof(flush))))
>  				return HV_STATUS_INVALID_HYPERCALL_INPUT;
> +			data_offset = sizeof(flush);
>  		}
>  
>  		trace_kvm_hv_flush_tlb(flush.processor_mask,
> @@ -1926,10 +2010,12 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
>  			flush_ex.flags = hc->outgpa;
>  			memcpy(&flush_ex.hv_vp_set,
>  			       &hc->xmm[0], sizeof(hc->xmm[0]));
> +			consumed_xmm_halves = 2;
>  		} else {
>  			if (unlikely(kvm_read_guest(kvm, hc->ingpa, &flush_ex,
>  						    sizeof(flush_ex))))
>  				return HV_STATUS_INVALID_HYPERCALL_INPUT;
> +			data_offset = sizeof(flush_ex);
>  		}
>  
>  		trace_kvm_hv_flush_tlb_ex(flush_ex.hv_vp_set.valid_bank_mask,
> @@ -1945,25 +2031,37 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
>  			return HV_STATUS_INVALID_HYPERCALL_INPUT;
>  
>  		if (all_cpus)
> -			goto do_flush;
> +			goto read_flush_entries;
>  
>  		if (!hc->var_cnt)
>  			goto ret_success;
>  
> -		if (kvm_get_sparse_vp_set(kvm, hc, sparse_banks, 2,
> -					  offsetof(struct hv_tlb_flush_ex,
> -						   hv_vp_set.bank_contents)))
> +		if (kvm_get_sparse_vp_set(kvm, hc, sparse_banks, consumed_xmm_halves,
> +					  data_offset))
> +			return HV_STATUS_INVALID_HYPERCALL_INPUT;
> +		data_offset += hc->var_cnt * sizeof(sparse_banks[0]);
> +		consumed_xmm_halves += hc->var_cnt;
> +	}
> +
> +read_flush_entries:
> +	if (hc->code == HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE ||
> +	    hc->code == HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE_EX ||
> +	    hc->rep_cnt > ARRAY_SIZE(__tlb_flush_entries)) {
> +		tlb_flush_entries = NULL;
> +	} else {
> +		if (kvm_hv_get_tlb_flush_entries(kvm, hc, __tlb_flush_entries,
> +						consumed_xmm_halves, data_offset))
>  			return HV_STATUS_INVALID_HYPERCALL_INPUT;
> +		tlb_flush_entries = __tlb_flush_entries;
>  	}
>  
> -do_flush:
>  	/*
>  	 * vcpu->arch.cr3 may not be up-to-date for running vCPUs so we can't
>  	 * analyze it here, flush TLB regardless of the specified address space.
>  	 */
>  	if (all_cpus) {
>  		kvm_for_each_vcpu(i, v, kvm)
> -			hv_tlb_flush_ring_enqueue(v);
> +			hv_tlb_flush_ring_enqueue(v, tlb_flush_entries, hc->rep_cnt);
>  
>  		kvm_make_all_cpus_request(kvm, KVM_REQ_HV_TLB_FLUSH);
>  	} else {
> @@ -1973,7 +2071,7 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
>  			v = kvm_get_vcpu(kvm, i);
>  			if (!v)
>  				continue;
> -			hv_tlb_flush_ring_enqueue(v);
> +			hv_tlb_flush_ring_enqueue(v, tlb_flush_entries, hc->rep_cnt);
>  		}
>  
>  		kvm_make_vcpus_request_mask(kvm, KVM_REQ_HV_TLB_FLUSH, vcpu_mask);


Overall the code looks good to me but I haven't checked it closely, so
I might have missed some simple bugs like off by one there and there.

Best regards,
	Maxim Levitsky


