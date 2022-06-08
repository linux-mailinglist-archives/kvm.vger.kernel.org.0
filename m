Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8488F542DC1
	for <lists+kvm@lfdr.de>; Wed,  8 Jun 2022 12:31:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236778AbiFHKaY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jun 2022 06:30:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237793AbiFHK3Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jun 2022 06:29:25 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A12A01124EF;
        Wed,  8 Jun 2022 03:18:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654683531; x=1686219531;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=t2q+I3pDJULoFU8AFqNT7du+oxRO3aTwmN+fPHX/1To=;
  b=D06QJIqC4TnTbBR5LH2LK+lHva9ilw6YNUWQ/0NXhtuqtCK08UPXzxzg
   8GmXVXIqU7MpzkqYIAQNe2d2jEYdxopQ6mABTOquN5w2qyUk//YQRDI4p
   Q7jD3guIntPYarAQpSz4DN/cZM89OvEqPsgwlVAwpcmf4x+DbjsPVSol0
   YQS8LBOnZc0LqAyFQTWtlSgC005Y0AqUrvdC0d/WcgCWQ+prIrKaz9K8E
   +pd71M/VYQxl3Z1KrCpnh3+3p7mZAYF/mNtG4B2GoDjRFsdm/1R4oB/im
   D45RqcSp2LUbIBwZMiVHBRwmgBn9UylLlXTiMzX/iSLvQimOvnn9Xs8cJ
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10371"; a="338637617"
X-IronPort-AV: E=Sophos;i="5.91,286,1647327600"; 
   d="scan'208";a="338637617"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2022 03:18:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,286,1647327600"; 
   d="scan'208";a="636733628"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by fmsmga008.fm.intel.com with ESMTP; 08 Jun 2022 03:18:47 -0700
Date:   Wed, 8 Jun 2022 18:18:47 +0800
From:   Yuan Yao <yuan.yao@linux.intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 05/38] KVM: x86: hyper-v: Handle
 HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST{,EX} calls gently
Message-ID: <20220608101847.63xavwsgfdprpaes@yy-desk-7060>
References: <20220606083655.2014609-1-vkuznets@redhat.com>
 <20220606083655.2014609-6-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220606083655.2014609-6-vkuznets@redhat.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 06, 2022 at 10:36:22AM +0200, Vitaly Kuznetsov wrote:
> Currently, HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST{,EX} calls are handled
> the exact same way as HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE{,EX}: by
> flushing the whole VPID and this is sub-optimal. Switch to handling
> these requests with 'flush_tlb_gva()' hooks instead. Use the newly
> introduced TLB flush fifo to queue the requests.
>
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/kvm/hyperv.c | 100 +++++++++++++++++++++++++++++++++++++-----
>  1 file changed, 88 insertions(+), 12 deletions(-)
>
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index 762b0b699fdf..956072592e2f 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -1806,32 +1806,82 @@ static u64 kvm_get_sparse_vp_set(struct kvm *kvm, struct kvm_hv_hcall *hc,
>  				  sparse_banks, consumed_xmm_halves, offset);
>  }
>
> -static void hv_tlb_flush_enqueue(struct kvm_vcpu *vcpu)
> +static int kvm_hv_get_tlb_flush_entries(struct kvm *kvm, struct kvm_hv_hcall *hc, u64 entries[],
> +					int consumed_xmm_halves, gpa_t offset)
> +{
> +	return kvm_hv_get_hc_data(kvm, hc, hc->rep_cnt, hc->rep_cnt,
> +				  entries, consumed_xmm_halves, offset);
> +}
> +
> +static void hv_tlb_flush_enqueue(struct kvm_vcpu *vcpu, u64 *entries, int count)
>  {
>  	struct kvm_vcpu_hv_tlb_flush_fifo *tlb_flush_fifo;
>  	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
>  	u64 entry = KVM_HV_TLB_FLUSHALL_ENTRY;
> +	unsigned long flags;
>
>  	if (!hv_vcpu)
>  		return;
>
>  	tlb_flush_fifo = &hv_vcpu->tlb_flush_fifo;
>
> -	kfifo_in_spinlocked(&tlb_flush_fifo->entries, &entry, 1, &tlb_flush_fifo->write_lock);
> +	spin_lock_irqsave(&tlb_flush_fifo->write_lock, flags);
> +
> +	/*
> +	 * All entries should fit on the fifo leaving one free for 'flush all'
> +	 * entry in case another request comes in. In case there's not enough
> +	 * space, just put 'flush all' entry there.
> +	 */
> +	if (count && entries && count < kfifo_avail(&tlb_flush_fifo->entries)) {
> +		WARN_ON(kfifo_in(&tlb_flush_fifo->entries, entries, count) != count);
> +		goto out_unlock;
> +	}
> +
> +	/*
> +	 * Note: full fifo always contains 'flush all' entry, no need to check the
> +	 * return value.
> +	 */
> +	kfifo_in(&tlb_flush_fifo->entries, &entry, 1);
> +
> +out_unlock:
> +	spin_unlock_irqrestore(&tlb_flush_fifo->write_lock, flags);
>  }
>
>  void kvm_hv_vcpu_flush_tlb(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_vcpu_hv_tlb_flush_fifo *tlb_flush_fifo;
>  	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
> +	u64 entries[KVM_HV_TLB_FLUSH_FIFO_SIZE];
> +	int i, j, count;
> +	gva_t gva;
>
> -	kvm_vcpu_flush_tlb_guest(vcpu);
> -
> -	if (!hv_vcpu)
> +	if (!tdp_enabled || !hv_vcpu) {
> +		kvm_vcpu_flush_tlb_guest(vcpu);
>  		return;
> +	}
>
>  	tlb_flush_fifo = &hv_vcpu->tlb_flush_fifo;
>
> +	count = kfifo_out(&tlb_flush_fifo->entries, entries, KVM_HV_TLB_FLUSH_FIFO_SIZE);

Writers are protected by the fifo lock so only 1 writer VS 1 reader on
this kfifo (at least so far), it shuold be safe but I'm not sure
whether some unexpected cases there, e.g. KVM flushs another VCPU's
kfifo while that VCPU is doing same thing for itself yet.

> +
> +	for (i = 0; i < count; i++) {
> +		if (entries[i] == KVM_HV_TLB_FLUSHALL_ENTRY)
> +			goto out_flush_all;
> +
> +		/*
> +		 * Lower 12 bits of 'address' encode the number of additional
> +		 * pages to flush.
> +		 */
> +		gva = entries[i] & PAGE_MASK;
> +		for (j = 0; j < (entries[i] & ~PAGE_MASK) + 1; j++)
> +			static_call(kvm_x86_flush_tlb_gva)(vcpu, gva + j * PAGE_SIZE);
> +
> +		++vcpu->stat.tlb_flush;
> +	}
> +	return;
> +
> +out_flush_all:
> +	kvm_vcpu_flush_tlb_guest(vcpu);
>  	kfifo_reset_out(&tlb_flush_fifo->entries);
>  }
>
> @@ -1841,11 +1891,21 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
>  	struct hv_tlb_flush_ex flush_ex;
>  	struct hv_tlb_flush flush;
>  	DECLARE_BITMAP(vcpu_mask, KVM_MAX_VCPUS);
> +	/*
> +	 * Normally, there can be no more than 'KVM_HV_TLB_FLUSH_FIFO_SIZE'
> +	 * entries on the TLB flush fifo. The last entry, however, needs to be
> +	 * always left free for 'flush all' entry which gets placed when
> +	 * there is not enough space to put all the requested entries.
> +	 */
> +	u64 __tlb_flush_entries[KVM_HV_TLB_FLUSH_FIFO_SIZE - 1];
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
> @@ -1861,10 +1921,12 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
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
> @@ -1888,10 +1950,12 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
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
> @@ -1907,25 +1971,37 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
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
> -			hv_tlb_flush_enqueue(v);
> +			hv_tlb_flush_enqueue(v, tlb_flush_entries, hc->rep_cnt);
>
>  		kvm_make_all_cpus_request(kvm, KVM_REQ_HV_TLB_FLUSH);
>  	} else {
> @@ -1935,7 +2011,7 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
>  			v = kvm_get_vcpu(kvm, i);
>  			if (!v)
>  				continue;
> -			hv_tlb_flush_enqueue(v);
> +			hv_tlb_flush_enqueue(v, tlb_flush_entries, hc->rep_cnt);
>  		}
>
>  		kvm_make_vcpus_request_mask(kvm, KVM_REQ_HV_TLB_FLUSH, vcpu_mask);
> --
> 2.35.3
>
