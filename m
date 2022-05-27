Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72F39536054
	for <lists+kvm@lfdr.de>; Fri, 27 May 2022 13:49:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351885AbiE0LsC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 May 2022 07:48:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351888AbiE0Lrt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 May 2022 07:47:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6992E14AF54
        for <kvm@vger.kernel.org>; Fri, 27 May 2022 04:43:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653651793;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cwtSE0b0Kap2XlkQ7keZo11av4qenVk73lRytgMZ82Q=;
        b=WUv7wGLfTl2gBdmnyu6IHnkFP15FbKIw1p6sytzcdaE9iJVK0qUqHyrwLvoQ+nr0M/srUz
        YZs2dNahBmeuHcvf5PfKU36yk6vlgQQWUtrg2PeeUDcFDs6nmOeZKXK95hXJjhEcRX4gPv
        KNqxj2wDtixjAwImIVaaPnNWlZ3oNVg=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-177-_jaHNwmmNy2RZ7vHhMeskQ-1; Fri, 27 May 2022 07:43:12 -0400
X-MC-Unique: _jaHNwmmNy2RZ7vHhMeskQ-1
Received: by mail-ed1-f72.google.com with SMTP id a20-20020aa7d754000000b0042d52bce846so446916eds.16
        for <kvm@vger.kernel.org>; Fri, 27 May 2022 04:43:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=cwtSE0b0Kap2XlkQ7keZo11av4qenVk73lRytgMZ82Q=;
        b=dLObt3V+sXK5YKiOGZnTDzk6chjwpcQxzwVKwOanQIgB7xP5sxbAzCo0xJ9Mo0iZJA
         nzBHDAOm8yFmQa0qPXk+nrgdj+xBK4FRDhczMhZd2H5im9pXVsyipJTxNlKHtatdGE0X
         10f8URFC4jTwpNik303hdmA3R1xru+VOUWVHsCxEZ+Kxb1ESutznPtvnDPj68uZbnFMz
         S9QL7b1bxewSJnDatY9SV0DekuibDqfE6RcpXaCr+IgbjG/7R7fB96X1PRNSZnN6HDI8
         xxBZnuWZzOZsPlqLssxytQcvJknYilIdYjeRB9fqaaQesdwss4VfKoCh9HyUrLugZcpp
         zR3w==
X-Gm-Message-State: AOAM530TjmoJzHZ5eriZhsnc7mUFK8iasRm2oilmphA2BI+5B7fXSFbT
        CNyEodbUlwHShhZfT5CPWpD6tW6TIb5NRJZFUZR/4UKrwxYzKEFa9mwQ4YZw79MqcXYqlF7gitM
        ujpL25MksWFVp
X-Received: by 2002:a17:906:7217:b0:6fe:9448:6142 with SMTP id m23-20020a170906721700b006fe94486142mr37290928ejk.241.1653651790902;
        Fri, 27 May 2022 04:43:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyTxyZvA1ixqnVSaX2I+ibcHZfYsvQCjJQOryDC4sHU4QD8REMvk4JBt16Gg4/MiScG2dgpvw==
X-Received: by 2002:a17:906:7217:b0:6fe:9448:6142 with SMTP id m23-20020a170906721700b006fe94486142mr37290901ejk.241.1653651790624;
        Fri, 27 May 2022 04:43:10 -0700 (PDT)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id bq8-20020a170906d0c800b006feb71acbb3sm1386134ejb.105.2022.05.27.04.43.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 May 2022 04:43:10 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Yuan Yao <yuan.yao@linux.intel.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 05/37] KVM: x86: hyper-v: Handle
 HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST{,EX} calls gently
In-Reply-To: <20220527083930.okdenkvxephom5wq@yy-desk-7060>
References: <20220525090133.1264239-1-vkuznets@redhat.com>
 <20220525090133.1264239-6-vkuznets@redhat.com>
 <20220527083930.okdenkvxephom5wq@yy-desk-7060>
Date:   Fri, 27 May 2022 13:43:09 +0200
Message-ID: <87ilprqjzm.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Yuan Yao <yuan.yao@linux.intel.com> writes:

> On Wed, May 25, 2022 at 11:01:01AM +0200, Vitaly Kuznetsov wrote:
>> Currently, HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST{,EX} calls are handled
>> the exact same way as HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE{,EX}: by
>> flushing the whole VPID and this is sub-optimal. Switch to handling
>> these requests with 'flush_tlb_gva()' hooks instead. Use the newly
>> introduced TLB flush fifo to queue the requests.
>>
>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> ---
>>  arch/x86/kvm/hyperv.c | 102 +++++++++++++++++++++++++++++++++++++-----
>>  1 file changed, 90 insertions(+), 12 deletions(-)
>>
>> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
>> index 762b0b699fdf..576749973727 100644
>> --- a/arch/x86/kvm/hyperv.c
>> +++ b/arch/x86/kvm/hyperv.c
>> @@ -1806,32 +1806,84 @@ static u64 kvm_get_sparse_vp_set(struct kvm *kvm, struct kvm_hv_hcall *hc,
>>  				  sparse_banks, consumed_xmm_halves, offset);
>>  }
>>
>> -static void hv_tlb_flush_enqueue(struct kvm_vcpu *vcpu)
>> +static int kvm_hv_get_tlb_flush_entries(struct kvm *kvm, struct kvm_hv_hcall *hc, u64 entries[],
>> +					int consumed_xmm_halves, gpa_t offset)
>> +{
>> +	return kvm_hv_get_hc_data(kvm, hc, hc->rep_cnt, hc->rep_cnt,
>> +				  entries, consumed_xmm_halves, offset);
>> +}
>> +
>> +static void hv_tlb_flush_enqueue(struct kvm_vcpu *vcpu, u64 *entries, int count)
>>  {
>>  	struct kvm_vcpu_hv_tlb_flush_fifo *tlb_flush_fifo;
>>  	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
>>  	u64 entry = KVM_HV_TLB_FLUSHALL_ENTRY;
>> +	unsigned long flags;
>>
>>  	if (!hv_vcpu)
>>  		return;
>>
>>  	tlb_flush_fifo = &hv_vcpu->tlb_flush_fifo;
>>
>> -	kfifo_in_spinlocked(&tlb_flush_fifo->entries, &entry, 1, &tlb_flush_fifo->write_lock);
>> +	spin_lock_irqsave(&tlb_flush_fifo->write_lock, flags);
>> +
>> +	/*
>> +	 * All entries should fit on the fifo leaving one free for 'flush all'
>> +	 * entry in case another request comes in. In case there's not enough
>> +	 * space, just put 'flush all' entry there.
>> +	 */
>> +	if (count && entries && count < kfifo_avail(&tlb_flush_fifo->entries)) {
>> +		WARN_ON(kfifo_in(&tlb_flush_fifo->entries, entries, count) != count);
>> +		goto out_unlock;
>> +	}
>> +
>> +	/*
>> +	 * Note: full fifo always contains 'flush all' entry, no need to check the
>> +	 * return value.
>> +	 */
>> +	kfifo_in(&tlb_flush_fifo->entries, &entry, 1);
>> +
>> +out_unlock:
>> +	spin_unlock_irqrestore(&tlb_flush_fifo->write_lock, flags);
>>  }
>>
>>  void kvm_hv_vcpu_flush_tlb(struct kvm_vcpu *vcpu)
>
> Where's the caller to this kvm_hv_vcpu_flush_tlb() ?
> I didn't see th caller in patch 1-22 and remains are
> self-testing patches, any thing I missed ?

No, I screwed up. It was present in
kvm_service_local_tlb_flush_requests() in previous versions but somehow
disappeared. This also means that I haven't tested this properly.

Thanks for catching this! v5 is coming to rescue!


>
>>  {
>>  	struct kvm_vcpu_hv_tlb_flush_fifo *tlb_flush_fifo;
>>  	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
>> +	u64 entries[KVM_HV_TLB_FLUSH_FIFO_SIZE];
>> +	int i, j, count;
>> +	gva_t gva;
>>
>> -	kvm_vcpu_flush_tlb_guest(vcpu);
>> -
>> -	if (!hv_vcpu)
>> +	if (!tdp_enabled || !hv_vcpu) {
>> +		kvm_vcpu_flush_tlb_guest(vcpu);
>>  		return;
>> +	}
>>
>>  	tlb_flush_fifo = &hv_vcpu->tlb_flush_fifo;
>>
>> +	count = kfifo_out(&tlb_flush_fifo->entries, entries, KVM_HV_TLB_FLUSH_FIFO_SIZE);
>> +
>> +	for (i = 0; i < count; i++) {
>> +		if (entries[i] == KVM_HV_TLB_FLUSHALL_ENTRY)
>> +			goto out_flush_all;
>> +
>> +		/*
>> +		 * Lower 12 bits of 'address' encode the number of additional
>> +		 * pages to flush.
>> +		 */
>> +		gva = entries[i] & PAGE_MASK;
>> +		for (j = 0; j < (entries[i] & ~PAGE_MASK) + 1; j++)
>> +			static_call(kvm_x86_flush_tlb_gva)(vcpu, gva + j * PAGE_SIZE);
>> +
>> +		++vcpu->stat.tlb_flush;
>> +	}
>> +	goto out_empty_ring;
>> +
>> +out_flush_all:
>> +	kvm_vcpu_flush_tlb_guest(vcpu);
>> +
>> +out_empty_ring:
>>  	kfifo_reset_out(&tlb_flush_fifo->entries);
>>  }
>>
>> @@ -1841,11 +1893,21 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
>>  	struct hv_tlb_flush_ex flush_ex;
>>  	struct hv_tlb_flush flush;
>>  	DECLARE_BITMAP(vcpu_mask, KVM_MAX_VCPUS);
>> +	/*
>> +	 * Normally, there can be no more than 'KVM_HV_TLB_FLUSH_FIFO_SIZE'
>> +	 * entries on the TLB flush fifo. The last entry, however, needs to be
>> +	 * always left free for 'flush all' entry which gets placed when
>> +	 * there is not enough space to put all the requested entries.
>> +	 */
>> +	u64 __tlb_flush_entries[KVM_HV_TLB_FLUSH_FIFO_SIZE - 1];
>> +	u64 *tlb_flush_entries;
>>  	u64 valid_bank_mask;
>>  	u64 sparse_banks[KVM_HV_MAX_SPARSE_VCPU_SET_BITS];
>>  	struct kvm_vcpu *v;
>>  	unsigned long i;
>>  	bool all_cpus;
>> +	int consumed_xmm_halves = 0;
>> +	gpa_t data_offset;
>>
>>  	/*
>>  	 * The Hyper-V TLFS doesn't allow more than 64 sparse banks, e.g. the
>> @@ -1861,10 +1923,12 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
>>  			flush.address_space = hc->ingpa;
>>  			flush.flags = hc->outgpa;
>>  			flush.processor_mask = sse128_lo(hc->xmm[0]);
>> +			consumed_xmm_halves = 1;
>>  		} else {
>>  			if (unlikely(kvm_read_guest(kvm, hc->ingpa,
>>  						    &flush, sizeof(flush))))
>>  				return HV_STATUS_INVALID_HYPERCALL_INPUT;
>> +			data_offset = sizeof(flush);
>>  		}
>>
>>  		trace_kvm_hv_flush_tlb(flush.processor_mask,
>> @@ -1888,10 +1952,12 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
>>  			flush_ex.flags = hc->outgpa;
>>  			memcpy(&flush_ex.hv_vp_set,
>>  			       &hc->xmm[0], sizeof(hc->xmm[0]));
>> +			consumed_xmm_halves = 2;
>>  		} else {
>>  			if (unlikely(kvm_read_guest(kvm, hc->ingpa, &flush_ex,
>>  						    sizeof(flush_ex))))
>>  				return HV_STATUS_INVALID_HYPERCALL_INPUT;
>> +			data_offset = sizeof(flush_ex);
>>  		}
>>
>>  		trace_kvm_hv_flush_tlb_ex(flush_ex.hv_vp_set.valid_bank_mask,
>> @@ -1907,25 +1973,37 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
>>  			return HV_STATUS_INVALID_HYPERCALL_INPUT;
>>
>>  		if (all_cpus)
>> -			goto do_flush;
>> +			goto read_flush_entries;
>>
>>  		if (!hc->var_cnt)
>>  			goto ret_success;
>>
>> -		if (kvm_get_sparse_vp_set(kvm, hc, sparse_banks, 2,
>> -					  offsetof(struct hv_tlb_flush_ex,
>> -						   hv_vp_set.bank_contents)))
>> +		if (kvm_get_sparse_vp_set(kvm, hc, sparse_banks, consumed_xmm_halves,
>> +					  data_offset))
>> +			return HV_STATUS_INVALID_HYPERCALL_INPUT;
>> +		data_offset += hc->var_cnt * sizeof(sparse_banks[0]);
>> +		consumed_xmm_halves += hc->var_cnt;
>> +	}
>> +
>> +read_flush_entries:
>> +	if (hc->code == HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE ||
>> +	    hc->code == HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE_EX ||
>> +	    hc->rep_cnt > ARRAY_SIZE(__tlb_flush_entries)) {
>> +		tlb_flush_entries = NULL;
>> +	} else {
>> +		if (kvm_hv_get_tlb_flush_entries(kvm, hc, __tlb_flush_entries,
>> +						consumed_xmm_halves, data_offset))
>>  			return HV_STATUS_INVALID_HYPERCALL_INPUT;
>> +		tlb_flush_entries = __tlb_flush_entries;
>>  	}
>>
>> -do_flush:
>>  	/*
>>  	 * vcpu->arch.cr3 may not be up-to-date for running vCPUs so we can't
>>  	 * analyze it here, flush TLB regardless of the specified address space.
>>  	 */
>>  	if (all_cpus) {
>>  		kvm_for_each_vcpu(i, v, kvm)
>> -			hv_tlb_flush_enqueue(v);
>> +			hv_tlb_flush_enqueue(v, tlb_flush_entries, hc->rep_cnt);
>>
>>  		kvm_make_all_cpus_request(kvm, KVM_REQ_HV_TLB_FLUSH);
>>  	} else {
>> @@ -1935,7 +2013,7 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
>>  			v = kvm_get_vcpu(kvm, i);
>>  			if (!v)
>>  				continue;
>> -			hv_tlb_flush_enqueue(v);
>> +			hv_tlb_flush_enqueue(v, tlb_flush_entries, hc->rep_cnt);
>>  		}
>>
>>  		kvm_make_vcpus_request_mask(kvm, KVM_REQ_HV_TLB_FLUSH, vcpu_mask);
>> --
>> 2.35.3
>>
>

-- 
Vitaly

