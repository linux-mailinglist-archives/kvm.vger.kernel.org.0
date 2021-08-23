Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0849A3F464F
	for <lists+kvm@lfdr.de>; Mon, 23 Aug 2021 10:03:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235333AbhHWIEd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Aug 2021 04:04:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:31654 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235283AbhHWIEc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 23 Aug 2021 04:04:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629705830;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dTMfPpQqjZQiYMrYYp033IPKIxD26bSlEd0LMb0weFA=;
        b=bYNXlbhCJFAYyv9RttB7RWIef97I5dZ2XnJ6jueBLOZctn5pVc3r97z+D8ZpVrojR08mk6
        KZD+XYQwGQXyimXxfAJIE236TKK082ufnqAShD9q6lGY9jJreqJRMg82zyHw8veH1aJ0S5
        NXDFaHZuXCPzLHvixlPq8S4LaK9w05U=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-518-4jTZuUoTM06wkrCdSn5LUA-1; Mon, 23 Aug 2021 04:03:49 -0400
X-MC-Unique: 4jTZuUoTM06wkrCdSn5LUA-1
Received: by mail-wm1-f70.google.com with SMTP id n20-20020a05600c4f9400b002e6dc6a99b9so4168110wmq.1
        for <kvm@vger.kernel.org>; Mon, 23 Aug 2021 01:03:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=dTMfPpQqjZQiYMrYYp033IPKIxD26bSlEd0LMb0weFA=;
        b=QdiFuGeJIKjA7jqM9gHjcoN6ZA6j8P+uGNoi4GLgOYJ2K1dWLmm0qBXhDFgii3K0I8
         Pz3sqMfVT/3iHiawU/C/HORyJA5WW5eQ9l4Ebz88mfrgCvmZTHBhVXEaTlW42xIKEIaA
         FTIiKD6s8Lm979y63+b/gqbjM6dHKO8WRZ7P7G++a2um0KQl0GvLXgS1TUliV/APXGuu
         TCyc+OFmguPTRFqef3GOPHf6qpcYF569lVUU1yh7FupnGdQsyEtxu1pTGXv38r4M9476
         GQj3/yQIb5q8NgUV2Nqb7BZQq+OlT5M0JL0SCCypE7ltFQr4PSgZaK+HNhlFgsMBzWwP
         qUxg==
X-Gm-Message-State: AOAM530CY9Q5DwIgMeM3HEA3SE5h1+7idFPdFb3k15iqtTj0D5q2wg51
        ZXvBHCd+605XGqcdQUECCQAFelcXOligTcQ1LC4uHGAJIuE9IMAkQAWTYGiMjvuma8TmnHztUhf
        9JIseNuj+gyn9
X-Received: by 2002:a5d:634a:: with SMTP id b10mr12272258wrw.305.1629705827811;
        Mon, 23 Aug 2021 01:03:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw5mj9o85vzLKDv/dE+d6q08OLBetdjvyabjQOZBSMkO8G4Lmd4Gwz4AlnoIiveUcZ9yGg9iw==
X-Received: by 2002:a5d:634a:: with SMTP id b10mr12272242wrw.305.1629705827602;
        Mon, 23 Aug 2021 01:03:47 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id n15sm3003543wrv.48.2021.08.23.01.03.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Aug 2021 01:03:47 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Nitesh Narayan Lal <nitesh@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] KVM: Optimize kvm_make_vcpus_request_mask() a bit
In-Reply-To: <YR/yTDZR29AhKw6M@google.com>
References: <20210820124354.582222-1-vkuznets@redhat.com>
 <YR/yTDZR29AhKw6M@google.com>
Date:   Mon, 23 Aug 2021 10:03:46 +0200
Message-ID: <87y28sk2ot.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> On Fri, Aug 20, 2021, Vitaly Kuznetsov wrote:
>> Iterating over set bits in 'vcpu_bitmap' should be faster than going
>> through all vCPUs, especially when just a few bits are set.
>> 
>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> ---
>>  virt/kvm/kvm_main.c | 49 +++++++++++++++++++++++++++++----------------
>>  1 file changed, 32 insertions(+), 17 deletions(-)
>> 
>> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
>> index 3e67c93ca403..0f873c5ed538 100644
>> --- a/virt/kvm/kvm_main.c
>> +++ b/virt/kvm/kvm_main.c
>> @@ -257,34 +257,49 @@ static inline bool kvm_kick_many_cpus(const struct cpumask *cpus, bool wait)
>>  	return true;
>>  }
>>  
>> +static void kvm_make_vcpu_request(struct kvm *kvm, struct kvm_vcpu *vcpu,
>> +				  unsigned int req, cpumask_var_t tmp)
>> +{
>> +	int cpu = vcpu->cpu;
>
> This reminds me, syzbot found a data race a while back[*] in kvm_vcpu_kick()
> related to reading vcpu->cpu.  That race is benign, but legitimate.  I believe
> this code has a similar race, and I'm not as confident that it's benign.
>
> If the target vCPU changes vcpu->cpu after it's read by this code, then the IPI
> can sent to the wrong pCPU, e.g. this pCPU gets waylaid by an IRQ and the target
> vCPU is migrated to a new pCPU.
>
> The TL;DR is that the race is benign because the target vCPU is still guaranteed
> to see the request before entering the guest, even if the IPI goes to the wrong
> pCPU.  I believe the same holds true for KVM_REQUEST_WAIT, e.g. if the lockless
> shadow PTE walk gets migrated to a new pCPU just before setting vcpu->mode to
> READING_SHADOW_PAGE_TABLES, this code can use a stale "cpu" for __cpumask_set_cpu().
> The race is benign because the vCPU would have to enter READING_SHADOW_PAGE_TABLES
> _after_ the SPTE modifications were made, as vcpu->cpu can't change while the vCPU
> is reading SPTEs.  The same logic holds true for the case where the vCPU is migrated
> after the call to __cpumask_set_cpu(); the goal is to wait for the vCPU to return to
> OUTSIDE_GUEST_MODE, which is guaranteed if the vCPU is migrated even if this path
> doesn't wait for an ack from the _new_ pCPU.
>
> I'll send patches to fix the races later today, maybe they can be folded into
> v2?  Even though the races are benign, I think they're worth fixing, if only to
> provide an opportunity to document why it's ok to send IPIs to the
> wrong pCPU.

You're blazingly fast as usual :-) I'll do v2 on top of your patches.

>
> [*] On an upstream kernel, but I don't think the bug report was posted to LKML.
>
>> +
>> +	kvm_make_request(req, vcpu);
>> +
>> +	if (!(req & KVM_REQUEST_NO_WAKEUP) && kvm_vcpu_wake_up(vcpu))
>> +		return;
>> +
>> +	if (tmp != NULL && cpu != -1 && cpu != raw_smp_processor_id() &&
>
> For large VMs, might be worth keeping get_cpu() in the caller in passing in @me?

The only reason against was that I've tried keeping the newly introduced
kvm_make_vcpu_request()'s interface nicer, like it can be reused some
day. Will get back to get_cpu() in v2.

>
>> +	    kvm_request_needs_ipi(vcpu, req))
>> +		__cpumask_set_cpu(cpu, tmp);
>> +}
>> +
>>  bool kvm_make_vcpus_request_mask(struct kvm *kvm, unsigned int req,
>>  				 struct kvm_vcpu *except,
>>  				 unsigned long *vcpu_bitmap, cpumask_var_t tmp)
>>  {
>> -	int i, cpu, me;
>> +	int i;
>>  	struct kvm_vcpu *vcpu;
>>  	bool called;
>>  
>> -	me = get_cpu();
>> -
>> -	kvm_for_each_vcpu(i, vcpu, kvm) {
>> -		if ((vcpu_bitmap && !test_bit(i, vcpu_bitmap)) ||
>> -		    vcpu == except)
>> -			continue;
>> -
>> -		kvm_make_request(req, vcpu);
>> -		cpu = vcpu->cpu;
>> -
>> -		if (!(req & KVM_REQUEST_NO_WAKEUP) && kvm_vcpu_wake_up(vcpu))
>> -			continue;
>> +	preempt_disable();
>>  
>> -		if (tmp != NULL && cpu != -1 && cpu != me &&
>> -		    kvm_request_needs_ipi(vcpu, req))
>> -			__cpumask_set_cpu(cpu, tmp);
>> +	if (likely(vcpu_bitmap)) {
>
> I don't think this is actually "likely".  kvm_make_all_cpus_request() is by far
> the most common caller and does not pass in a vcpu_bitmap.  Practically speaking
> I highly don't the code organization will matter, but from a documentation
> perspective it's wrong.

Right, I was thinking more about two other users: IOAPIC and Hyper-V who
call kvm_make_vcpus_request_mask() directly but I agree that
kvm_make_all_cpus_request() is probably much more common.

>
>> +		for_each_set_bit(i, vcpu_bitmap, KVM_MAX_VCPUS) {
>> +			vcpu = kvm_get_vcpu(kvm, i);
>> +			if (!vcpu || vcpu == except)
>> +				continue;
>> +			kvm_make_vcpu_request(kvm, vcpu, req, tmp);
>> +		}
>> +	} else {
>> +		kvm_for_each_vcpu(i, vcpu, kvm) {
>> +			if (vcpu == except)
>> +				continue;
>> +			kvm_make_vcpu_request(kvm, vcpu, req, tmp);
>> +		}
>>  	}
>>  
>>  	called = kvm_kick_many_cpus(tmp, !!(req & KVM_REQUEST_WAIT));
>> -	put_cpu();
>> +
>> +	preempt_enable();
>>  
>>  	return called;
>>  }
>> -- 
>> 2.31.1
>> 
>

-- 
Vitaly

