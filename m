Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0C5A52A372
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 15:32:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347035AbiEQNcL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 09:32:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231514AbiEQNcI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 09:32:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2E3DF419B2
        for <kvm@vger.kernel.org>; Tue, 17 May 2022 06:32:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652794323;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YPrrrGrtPJ0UPVeEiIe+RRjxIITOoG2J++Tlpsjpjrg=;
        b=g5r46tvsZXWdNp4do3RFAegcdk4kMXqHVve2KcdE1cB01qUv/rW8LLPuTZdW8p+KxtF/Mh
        RM/s86RhfpMBQpxsypV/+RRU9PjXbx2Fy/Wdv+KKEqo9Z5Gr4vuJiknnCktC4zJ/wDCEM1
        4qcziH5w9Z5vrf0nxJB8Oo/mpYylS8M=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-9-SKStzi6lOuC_Mi4AX8wYxA-1; Tue, 17 May 2022 09:32:02 -0400
X-MC-Unique: SKStzi6lOuC_Mi4AX8wYxA-1
Received: by mail-wr1-f72.google.com with SMTP id u17-20020a056000161100b0020cda98f292so4670639wrb.21
        for <kvm@vger.kernel.org>; Tue, 17 May 2022 06:32:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=YPrrrGrtPJ0UPVeEiIe+RRjxIITOoG2J++Tlpsjpjrg=;
        b=swNowISN8qWqmQ/bTlMVOOT+VSxnQo2uFKPIZXYP45R3qfoi9ioQBBcBsVV0ihUCfs
         qpW7ggGCiIXwPhVmGdTnf1Znr92dqupKzTTUDhRTchLzmBEbAq+eps7EpMtc/34G/KMD
         Q3aZbvioLILhrHnizcD10Lu83unRXIiltkrjWEGHyOyUgDzWXi45oaxkywHXvQ1GmN6Q
         kzDC5YG4svP+vOeHidhdN5T2yT9Sy4OqQ5nSngbkhQ+Gjj7g9H550G6SCFGI2OGVXpFd
         fu2L+L5jJBK9Gax2ohQzrdyBdC3hrwNzEDJta7doL48GsyfHXFHpVA4XaMs7Xdy9DRfE
         DVBg==
X-Gm-Message-State: AOAM533yKK2cSCfclyB6CDh/2tdIx+lgQ2tMnohdI6DpX3V+ZBGA8xQp
        TrCPc1ZptQX7WbHSwsKGjmlFjp1DlNc8+4h48AqdOyuK05wwcJboMbNRj926aybtETdSE5LVg1X
        oMwrIsP4Fy6Lz
X-Received: by 2002:adf:ebc7:0:b0:20c:d65d:3f19 with SMTP id v7-20020adfebc7000000b0020cd65d3f19mr18628882wrn.613.1652794320339;
        Tue, 17 May 2022 06:32:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzVmQD/MUnZFDRT5bU85jS2BMM9lXxe1L7hniFLhaNb6tRdo5rfdhJyWG2PMCMsIvPkjWmDVQ==
X-Received: by 2002:adf:ebc7:0:b0:20c:d65d:3f19 with SMTP id v7-20020adfebc7000000b0020cd65d3f19mr18628856wrn.613.1652794319991;
        Tue, 17 May 2022 06:31:59 -0700 (PDT)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id x16-20020adfbb50000000b0020d11ee1bcesm3432180wrg.82.2022.05.17.06.31.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 May 2022 06:31:59 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 02/34] KVM: x86: hyper-v: Introduce TLB flush ring
In-Reply-To: <YoKnOqR68SaaPCdT@google.com>
References: <20220414132013.1588929-1-vkuznets@redhat.com>
 <20220414132013.1588929-3-vkuznets@redhat.com>
 <YoKnOqR68SaaPCdT@google.com>
Date:   Tue, 17 May 2022 15:31:58 +0200
Message-ID: <87pmkcuvxt.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> On Thu, Apr 14, 2022, Vitaly Kuznetsov wrote:
>> To allow flushing individual GVAs instead of always flushing the whole
>> VPID a per-vCPU structure to pass the requests is needed. Introduce a
>> simple ring write-locked structure to hold two types of entries:
>> individual GVA (GFN + up to 4095 following GFNs in the lower 12 bits)
>> and 'flush all'.
>> 
>> The queuing rule is: if there's not enough space on the ring to put
>> the request and leave at least 1 entry for 'flush all' - put 'flush
>> all' entry.
>> 
>> The size of the ring is arbitrary set to '16'.
>> 
>> Note, kvm_hv_flush_tlb() only queues 'flush all' entries for now so
>> there's very small functional change but the infrastructure is
>> prepared to handle individual GVA flush requests.
>> 
>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> ---
>>  arch/x86/include/asm/kvm_host.h | 16 +++++++
>>  arch/x86/kvm/hyperv.c           | 83 +++++++++++++++++++++++++++++++++
>>  arch/x86/kvm/hyperv.h           | 13 ++++++
>>  arch/x86/kvm/x86.c              |  5 +-
>>  arch/x86/kvm/x86.h              |  1 +
>>  5 files changed, 116 insertions(+), 2 deletions(-)
>> 
>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>> index 1de3ad9308d8..b4dd2ff61658 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -578,6 +578,20 @@ struct kvm_vcpu_hv_synic {
>>  	bool dont_zero_synic_pages;
>>  };
>>  
>> +#define KVM_HV_TLB_FLUSH_RING_SIZE (16)
>> +
>> +struct kvm_vcpu_hv_tlb_flush_entry {
>> +	u64 addr;
>
> "addr" misleading, this is overloaded to be both the virtual address and the count.
> I think we make it a moot point, but it led me astray in thinkin we could use the
> lower 12 bits for flags... until I realized those bits are already in use.
>
>> +	u64 flush_all:1;
>> +	u64 pad:63;
>
> This is rather odd, why not just use a bool?  

My initial plan was to eventually put more flags here, i.e. there are
two additional flags which we don't currently handle:

HV_FLUSH_ALL_VIRTUAL_ADDRESS_SPACES (as we don't actually look at
 HV_ADDRESS_SPACE_ID)
HV_FLUSH_NON_GLOBAL_MAPPINGS_ONLY

> But why even have a "flush_all" field, can't we just use a magic value
> for write_idx to indicate "flush_all"? E.g. either an explicit #define
> or -1.

Sure, a magic value would do too and will allow us to make 'struct
kvm_vcpu_hv_tlb_flush_entry' 8 bytes instead of 16 (for the time being
as if we are to add HV_ADDRESS_SPACE_ID/additional flags the net win is
going to be zero).

>
> Writers set write_idx to -1 to indicate "flush all", vCPU/reader goes straight
> to "flush all" if write_idx is -1/invalid.  That way, future writes can simply do
> nothing until read_idx == write_idx, and the vCPU/reader avoids unnecessary flushes
> if there's a "flush all" pending and other valid entries in the ring.
>
> And it allows deferring the "flush all" until the ring is truly full (unless there's
> an off-by-one / wraparound edge case I'm missing, which is likely...).

Thanks for the patch! I am, however, going to look at Maxim's suggestion
to use 'kfifo' to avoid all these uncertainties, funky locking etc. At
first glance it has everything I need here.

>
> ---
>  arch/x86/include/asm/kvm_host.h |  8 +-----
>  arch/x86/kvm/hyperv.c           | 47 +++++++++++++--------------------
>  2 files changed, 19 insertions(+), 36 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index b6b9a71a4591..bb45cc383ce4 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -605,16 +605,10 @@ enum hv_tlb_flush_rings {
>  	HV_NR_TLB_FLUSH_RINGS,
>  };
>
> -struct kvm_vcpu_hv_tlb_flush_entry {
> -	u64 addr;
> -	u64 flush_all:1;
> -	u64 pad:63;
> -};
> -
>  struct kvm_vcpu_hv_tlb_flush_ring {
>  	int read_idx, write_idx;
>  	spinlock_t write_lock;
> -	struct kvm_vcpu_hv_tlb_flush_entry entries[KVM_HV_TLB_FLUSH_RING_SIZE];
> +	u64 entries[KVM_HV_TLB_FLUSH_RING_SIZE];
>  };
>
>  /* Hyper-V per vcpu emulation context */
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index 1d6927538bc7..56f06cf85282 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -1837,10 +1837,13 @@ static int kvm_hv_get_tlb_flush_entries(struct kvm *kvm, struct kvm_hv_hcall *hc
>  static inline int hv_tlb_flush_ring_free(struct kvm_vcpu_hv *hv_vcpu,
>  					 int read_idx, int write_idx)
>  {
> +	if (write_idx < 0)
> +		return 0;
> +
>  	if (write_idx >= read_idx)
> -		return KVM_HV_TLB_FLUSH_RING_SIZE - (write_idx - read_idx) - 1;
> +		return KVM_HV_TLB_FLUSH_RING_SIZE - (write_idx - read_idx);
>
> -	return read_idx - write_idx - 1;
> +	return read_idx - write_idx;
>  }
>
>  static void hv_tlb_flush_ring_enqueue(struct kvm_vcpu *vcpu,
> @@ -1869,6 +1872,9 @@ static void hv_tlb_flush_ring_enqueue(struct kvm_vcpu *vcpu,
>  	 */
>  	write_idx = tlb_flush_ring->write_idx;
>
> +	if (write_idx < 0 && read_idx == write_idx)
> +		read_idx = write_idx = 0;
> +
>  	ring_free = hv_tlb_flush_ring_free(hv_vcpu, read_idx, write_idx);
>  	/* Full ring always contains 'flush all' entry */
>  	if (!ring_free)
> @@ -1879,21 +1885,13 @@ static void hv_tlb_flush_ring_enqueue(struct kvm_vcpu *vcpu,
>  	 * entry in case another request comes in. In case there's not enough
>  	 * space, just put 'flush all' entry there.
>  	 */
> -	if (!count || count >= ring_free - 1 || !entries) {
> -		tlb_flush_ring->entries[write_idx].addr = 0;
> -		tlb_flush_ring->entries[write_idx].flush_all = 1;
> -		/*
> -		 * Advance write index only after filling in the entry to
> -		 * synchronize with lockless reader.
> -		 */
> -		smp_wmb();
> -		tlb_flush_ring->write_idx = (write_idx + 1) % KVM_HV_TLB_FLUSH_RING_SIZE;
> +	if (!count || count > ring_free - 1 || !entries) {
> +		tlb_flush_ring->write_idx = -1;
>  		goto out_unlock;
>  	}
>
>  	for (i = 0; i < count; i++) {
> -		tlb_flush_ring->entries[write_idx].addr = entries[i];
> -		tlb_flush_ring->entries[write_idx].flush_all = 0;
> +		tlb_flush_ring->entries[write_idx] = entries[i];
>  		write_idx = (write_idx + 1) % KVM_HV_TLB_FLUSH_RING_SIZE;
>  	}
>  	/*
> @@ -1911,7 +1909,6 @@ void kvm_hv_vcpu_flush_tlb(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_vcpu_hv_tlb_flush_ring *tlb_flush_ring;
>  	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
> -	struct kvm_vcpu_hv_tlb_flush_entry *entry;
>  	int read_idx, write_idx;
>  	u64 address;
>  	u32 count;
> @@ -1940,26 +1937,18 @@ void kvm_hv_vcpu_flush_tlb(struct kvm_vcpu *vcpu)
>  	/* Pairs with smp_wmb() in hv_tlb_flush_ring_enqueue() */
>  	smp_rmb();
>
> +	if (write_idx < 0) {
> +		kvm_vcpu_flush_tlb_guest(vcpu);
> +		goto out_empty_ring;
> +	}
> +
>  	for (i = read_idx; i != write_idx; i = (i + 1) % KVM_HV_TLB_FLUSH_RING_SIZE) {
> -		entry = &tlb_flush_ring->entries[i];
> -
> -		if (entry->flush_all)
> -			goto out_flush_all;
> -
> -		/*
> -		 * Lower 12 bits of 'address' encode the number of additional
> -		 * pages to flush.
> -		 */
> -		address = entry->addr & PAGE_MASK;
> -		count = (entry->addr & ~PAGE_MASK) + 1;
> +		address = tlb_flush_ring->entries[i] & PAGE_MASK;
> +		count = (tlb_flush_ring->entries[i] & ~PAGE_MASK) + 1;
>  		for (j = 0; j < count; j++)
>  			static_call(kvm_x86_flush_tlb_gva)(vcpu, address + j * PAGE_SIZE);
>  	}
>  	++vcpu->stat.tlb_flush;
> -	goto out_empty_ring;
> -
> -out_flush_all:
> -	kvm_vcpu_flush_tlb_guest(vcpu);
>
>  out_empty_ring:
>  	tlb_flush_ring->read_idx = write_idx;
>
> base-commit: 62592c7c742ae78eb1f1005a63965ece19e6effe
> --
>

-- 
Vitaly

