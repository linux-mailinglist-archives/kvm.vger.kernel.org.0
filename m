Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2D0D52B6C3
	for <lists+kvm@lfdr.de>; Wed, 18 May 2022 12:12:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234531AbiERJkn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 May 2022 05:40:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234623AbiERJkf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 May 2022 05:40:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A1FF212B014
        for <kvm@vger.kernel.org>; Wed, 18 May 2022 02:40:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652866803;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=c34pXnvrLBTdu53YSF6eBsxL++Hmtq6hDZGLgHJNwTE=;
        b=hG62/kZF4BOGNTsT1C0dF+pXD0P8b6ZpTLcV3++BtqvlqNvfR3ztUNiiX2X4HzJkwa9yyo
        XgIupBc1FnbjecqDrWk1JmSzH1zXBuHuyG5BqkSqXlgrpCZk2qvt/ouLEJiOlZz/gPODWp
        /oRESvyRRHBGpt3jEVAja41ocvyWQEI=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-614-K4KfYwaFOvWrlnXJtVMhUw-1; Wed, 18 May 2022 05:40:02 -0400
X-MC-Unique: K4KfYwaFOvWrlnXJtVMhUw-1
Received: by mail-wr1-f70.google.com with SMTP id p10-20020adfaa0a000000b0020c4829af5fso411609wrd.16
        for <kvm@vger.kernel.org>; Wed, 18 May 2022 02:40:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=c34pXnvrLBTdu53YSF6eBsxL++Hmtq6hDZGLgHJNwTE=;
        b=5iHKIIXRA2ubxOPvLXDbRSRJ282Zim40sKA3OnlVm0FzdIBk4Ro4jc0C19LVCamRK6
         CQM+FAdZsGhMlD58ytGDbqRRdV/uUwbnLEhrrtSWeyFXq4rLAL+MBkRdisJrWWMZbVva
         l6jIYGcbk80y+VhAPF0S/e8vLS5M5RqopzOldVy5y2+6QDDSDEN/3tbdkM5sHkmS75Gd
         TRFfskvcmsM8k9aFRI6+cfLP0qCFM6OfQH2lJ8bSqJ5BE1gDYhx+W3w6MsViMZ/dqOCO
         mj66+pYyqw5KU37q3ypIGDxGQILHGfdGqCyCPagDGeBdwsgw+UgY1/kKwyAQYDqO4N99
         zYmA==
X-Gm-Message-State: AOAM531wYelfSgW69QmhG7dMiK7Ks9rE7RPNXHhOMr3vYuBYHlZMi234
        4/1N+TVIOB39CXmW9pXDQTsmY7cm8Rtdofrmal5V7Hq278jPnjFN67tuCdHRE1mzCn7HyGAB9At
        YPoi+G9pC6zW1
X-Received: by 2002:a5d:64a6:0:b0:20c:64ef:c9cc with SMTP id m6-20020a5d64a6000000b0020c64efc9ccmr23442642wrp.190.1652866800905;
        Wed, 18 May 2022 02:40:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwiEqoSrZOrLmPBvvdAYGRFeiSuRih5wH0v7Lk5FK0WcUjZB2gyXHtFOvFf599ep2NMC2DTDQ==
X-Received: by 2002:a5d:64a6:0:b0:20c:64ef:c9cc with SMTP id m6-20020a5d64a6000000b0020c64efc9ccmr23442620wrp.190.1652866800658;
        Wed, 18 May 2022 02:40:00 -0700 (PDT)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id h8-20020adf9cc8000000b0020c5253d8dbsm1475137wre.39.2022.05.18.02.39.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 May 2022 02:39:59 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v3 04/34] KVM: x86: hyper-v: Handle
 HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST{,EX} calls gently
In-Reply-To: <165aea185dfef1eba9ba0f4fd1c3a95361c41396.camel@redhat.com>
References: <20220414132013.1588929-1-vkuznets@redhat.com>
 <20220414132013.1588929-5-vkuznets@redhat.com>
 <165aea185dfef1eba9ba0f4fd1c3a95361c41396.camel@redhat.com>
Date:   Wed, 18 May 2022 11:39:59 +0200
Message-ID: <877d6juqkw.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Maxim Levitsky <mlevitsk@redhat.com> writes:

> On Thu, 2022-04-14 at 15:19 +0200, Vitaly Kuznetsov wrote:
>> Currently, HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST{,EX} calls are handled
>> the exact same way as HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE{,EX}: by
>> flushing the whole VPID and this is sub-optimal. Switch to handling
>> these requests with 'flush_tlb_gva()' hooks instead. Use the newly
>> introduced TLB flush ring to queue the requests.
>> 
>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> ---
>>  arch/x86/kvm/hyperv.c | 132 ++++++++++++++++++++++++++++++++++++------
>>  1 file changed, 115 insertions(+), 17 deletions(-)
>> 
>> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
>> index d66c27fd1e8a..759e1a16e5c3 100644
>> --- a/arch/x86/kvm/hyperv.c
>> +++ b/arch/x86/kvm/hyperv.c
>> @@ -1805,6 +1805,13 @@ static u64 kvm_get_sparse_vp_set(struct kvm *kvm, struct kvm_hv_hcall *hc,
>>  				  sparse_banks, consumed_xmm_halves, offset);
>>  }
>>  
>> +static int kvm_hv_get_tlb_flush_entries(struct kvm *kvm, struct kvm_hv_hcall *hc, u64 entries[],
>> +				       int consumed_xmm_halves, gpa_t offset)
>> +{
>> +	return kvm_hv_get_hc_data(kvm, hc, hc->rep_cnt, hc->rep_cnt,
>> +				  entries, consumed_xmm_halves, offset);
>> +}
>> +
>>  static inline int hv_tlb_flush_ring_free(struct kvm_vcpu_hv *hv_vcpu,
>>  					 int read_idx, int write_idx)
>>  {
>> @@ -1814,12 +1821,13 @@ static inline int hv_tlb_flush_ring_free(struct kvm_vcpu_hv *hv_vcpu,
>>  	return read_idx - write_idx - 1;
>>  }
>>  
>> -static void hv_tlb_flush_ring_enqueue(struct kvm_vcpu *vcpu)
>> +static void hv_tlb_flush_ring_enqueue(struct kvm_vcpu *vcpu, u64 *entries, int count)
>>  {
>>  	struct kvm_vcpu_hv_tlb_flush_ring *tlb_flush_ring;
>>  	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
>>  	int ring_free, write_idx, read_idx;
>>  	unsigned long flags;
>> +	int i;
>>  
>>  	if (!hv_vcpu)
>>  		return;
>> @@ -1845,14 +1853,34 @@ static void hv_tlb_flush_ring_enqueue(struct kvm_vcpu *vcpu)
>>  	if (!ring_free)
>>  		goto out_unlock;
>>  
>> -	tlb_flush_ring->entries[write_idx].addr = 0;
>> -	tlb_flush_ring->entries[write_idx].flush_all = 1;
>>  	/*
>> -	 * Advance write index only after filling in the entry to
>> -	 * synchronize with lockless reader.
>> +	 * All entries should fit on the ring leaving one free for 'flush all'
>> +	 * entry in case another request comes in. In case there's not enough
>> +	 * space, just put 'flush all' entry there.
>> +	 */
>> +	if (!count || count >= ring_free - 1 || !entries) {
>> +		tlb_flush_ring->entries[write_idx].addr = 0;
>> +		tlb_flush_ring->entries[write_idx].flush_all = 1;
>> +		/*
>> +		 * Advance write index only after filling in the entry to
>> +		 * synchronize with lockless reader.
>> +		 */
>> +		smp_wmb();
>> +		tlb_flush_ring->write_idx = (write_idx + 1) % KVM_HV_TLB_FLUSH_RING_SIZE;
>> +		goto out_unlock;
>> +	}
>> +
>> +	for (i = 0; i < count; i++) {
>> +		tlb_flush_ring->entries[write_idx].addr = entries[i];
>> +		tlb_flush_ring->entries[write_idx].flush_all = 0;
>> +		write_idx = (write_idx + 1) % KVM_HV_TLB_FLUSH_RING_SIZE;
>> +	}
>> +	/*
>> +	 * Advance write index only after filling in the entry to synchronize
>> +	 * with lockless reader.
>>  	 */
>>  	smp_wmb();
>> -	tlb_flush_ring->write_idx = (write_idx + 1) % KVM_HV_TLB_FLUSH_RING_SIZE;
>> +	tlb_flush_ring->write_idx = write_idx;
>>  
>>  out_unlock:
>>  	spin_unlock_irqrestore(&tlb_flush_ring->write_lock, flags);
>> @@ -1862,15 +1890,58 @@ void kvm_hv_vcpu_flush_tlb(struct kvm_vcpu *vcpu)
>>  {
>>  	struct kvm_vcpu_hv_tlb_flush_ring *tlb_flush_ring;
>>  	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
>> +	struct kvm_vcpu_hv_tlb_flush_entry *entry;
>> +	int read_idx, write_idx;
>> +	u64 address;
>> +	u32 count;
>> +	int i, j;
>>  
>> -	kvm_vcpu_flush_tlb_guest(vcpu);
>> -
>> -	if (!hv_vcpu)
>> +	if (!tdp_enabled || !hv_vcpu) {
>> +		kvm_vcpu_flush_tlb_guest(vcpu);
>>  		return;
>> +	}
>>  
>>  	tlb_flush_ring = &hv_vcpu->tlb_flush_ring;
>>  
>> -	tlb_flush_ring->read_idx = tlb_flush_ring->write_idx;
>> +	/*
>> +	 * TLB flush must be performed on the target vCPU so 'read_idx'
>> +	 * (AKA 'tail') cannot change underneath, the compiler is free
>> +	 * to re-read it.
>> +	 */
>> +	read_idx = tlb_flush_ring->read_idx;
>> +
>> +	/*
>> +	 * 'write_idx' (AKA 'head') can be concurently updated by a different
>> +	 * vCPU so we must be sure it's read once.
>> +	 */
>> +	write_idx = READ_ONCE(tlb_flush_ring->write_idx);
>> +
>> +	/* Pairs with smp_wmb() in hv_tlb_flush_ring_enqueue() */
>> +	smp_rmb();
>> +
>> +	for (i = read_idx; i != write_idx; i = (i + 1) % KVM_HV_TLB_FLUSH_RING_SIZE) {
>> +		entry = &tlb_flush_ring->entries[i];
>> +
>> +		if (entry->flush_all)
>> +			goto out_flush_all;
>
> I have an idea: instead of special 'flush all entry' in the ring,
> just have a boolean in parallel to the ring.
>
> Also the ring buffer entries will be 2x smaller since they won't need
> to have the 'flush all' boolean.
>
> This would allow to just flush the whole thing and discard the ring if that boolean is set,
> allow to not enqueue anything to the ring also if the boolean is already set,
> also we won't need to have extra space in the ring for that entry, etc, etc.
>
> Or if using kfifo, then it can contain plain u64 items, which is even more natural.
>

In the next version I switch to fifo and get rid of 'flush_all' entries
but instead of a boolean I use a 'magic' value of '-1' in GVA. This way
we don't need to synchronize with the reader and add any special
handling for the flag.

Note, in the future we may get back to having flags as part of entries
as it is now possible to analize guest's CR3. We'll likely add
'AddressSpace' to each entry. The 'flush all' entry, however, will
always remain 'special' to handle ring overflow case.

-- 
Vitaly

