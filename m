Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CEB91C4FE1
	for <lists+kvm@lfdr.de>; Tue,  5 May 2020 10:08:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726575AbgEEIIS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 May 2020 04:08:18 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:36831 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725766AbgEEIIR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 May 2020 04:08:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588666096;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=47lMT6kLVt1KyFlpgunpLpY9wxuv5GbgX9JkN70Ja9o=;
        b=O3eFJEX1FohfI9y3TgLD+APUYT5JYfV7vbFUtRomW8LuGlv9W5nE8a0DMnzbQs7pKqOf1H
        xHQCQq3uzm1FBZe8zlcCd7/YOxVu2CHBLAVdmU+yu6yR72o3kbRnxqU7v5toF02cGC6lnD
        h6Mk2ptUwd8rTM4XO5ZHgQ7le6qKLTg=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-473-ThCwLg2QPHmPd7h0_znV3g-1; Tue, 05 May 2020 04:08:13 -0400
X-MC-Unique: ThCwLg2QPHmPd7h0_znV3g-1
Received: by mail-wr1-f70.google.com with SMTP id e5so809558wrs.23
        for <kvm@vger.kernel.org>; Tue, 05 May 2020 01:08:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=47lMT6kLVt1KyFlpgunpLpY9wxuv5GbgX9JkN70Ja9o=;
        b=KyILajWfDZEVPU5VKLVX9ZgZUYNuQM7gXCa0P52MVPZUsaZUsxFJnwdzsmLIhiSF1/
         6c4FSKrcZGDYIC2yCW3Cb4cx5ozYt80l98nsxcnToEK7EOnyq80P1IgvLAnmDzfaQfSt
         zNOjIwDh7Ii5OH3vI9qGgcs3ZJnKmQ+mznAnls8+V8NF02DdksWMu1HXCDcjpyz64Yq4
         duxFcM3oq9DJAMCl+HaLzheomSUdSjIGdWNvCacKuF6nLoU0JlOh9y52lNd+aRj+qYd5
         3JqJWAbHKxSZkmDsLkb+5SzCDT80LEFi4GMwde4fyofHkHC3DpGWmQSAAgjMZZBnw5iW
         zZjQ==
X-Gm-Message-State: AGi0PuZ1Dwx7C+xeifodNvW1GR5H2DjUX018QQqcWJNl8smg4QwmdA1z
        64mlVJgahMAS7mdOomcIPkbKcLShMbUrZMElQZLvw9uatKHfbaggni/MyruVN+8JGxbXHri2q9W
        BCK7XH59lFbhk
X-Received: by 2002:adf:fcc6:: with SMTP id f6mr1990856wrs.388.1588666092159;
        Tue, 05 May 2020 01:08:12 -0700 (PDT)
X-Google-Smtp-Source: APiQypJXLB0CZpg9ZBJB9HEiNOemJV+reID+sLNqwbwJIMFth2tEFPjtycRqGqog0JhAopNBJApfJA==
X-Received: by 2002:adf:fcc6:: with SMTP id f6mr1990842wrs.388.1588666091942;
        Tue, 05 May 2020 01:08:11 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id i17sm2584491wml.23.2020.05.05.01.08.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2020 01:08:11 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Gavin Shan <gshan@redhat.com>, x86@kernel.org, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH RFC 2/6] KVM: x86: extend struct kvm_vcpu_pv_apf_data with token info
In-Reply-To: <409b802c-0abe-0cb4-92fe-925733bfd612@redhat.com>
References: <20200429093634.1514902-1-vkuznets@redhat.com> <20200429093634.1514902-3-vkuznets@redhat.com> <409b802c-0abe-0cb4-92fe-925733bfd612@redhat.com>
Date:   Tue, 05 May 2020 10:08:09 +0200
Message-ID: <871rnyerdi.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Gavin Shan <gshan@redhat.com> writes:

> Hi Vitaly,
>
> On 4/29/20 7:36 PM, Vitaly Kuznetsov wrote:
>> Currently, APF mechanism relies on the #PF abuse where the token is being
>> passed through CR2. If we switch to using interrupts to deliver page-ready
>> notifications we need a different way to pass the data. Extent the existing
>> 'struct kvm_vcpu_pv_apf_data' with token information.
>> 
>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> ---
>>   arch/x86/include/uapi/asm/kvm_para.h |  3 ++-
>>   arch/x86/kvm/x86.c                   | 10 ++++++----
>>   2 files changed, 8 insertions(+), 5 deletions(-)
>> 
>> diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
>> index 2a8e0b6b9805..df2ba34037a2 100644
>> --- a/arch/x86/include/uapi/asm/kvm_para.h
>> +++ b/arch/x86/include/uapi/asm/kvm_para.h
>> @@ -113,7 +113,8 @@ struct kvm_mmu_op_release_pt {
>>   
>>   struct kvm_vcpu_pv_apf_data {
>>   	__u32 reason;
>> -	__u8 pad[60];
>> +	__u32 token;
>> +	__u8 pad[56];
>>   	__u32 enabled;
>>   };
>>   
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index b93133ee07ba..7c21c0cf0a33 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -2662,7 +2662,7 @@ static int kvm_pv_enable_async_pf(struct kvm_vcpu *vcpu, u64 data)
>>   	}
>>   
>>   	if (kvm_gfn_to_hva_cache_init(vcpu->kvm, &vcpu->arch.apf.data, gpa,
>> -					sizeof(u32)))
>> +					sizeof(u64)))
>>   		return 1;
>>   
>>   	vcpu->arch.apf.send_user_only = !(data & KVM_ASYNC_PF_SEND_ALWAYS);
>> @@ -10352,8 +10352,9 @@ static void kvm_del_async_pf_gfn(struct kvm_vcpu *vcpu, gfn_t gfn)
>>   	}
>>   }
>>   
>> -static int apf_put_user(struct kvm_vcpu *vcpu, u32 val)
>> +static int apf_put_user(struct kvm_vcpu *vcpu, u32 reason, u32 token)
>>   {
>> +	u64 val = (u64)token << 32 | reason;
>>   
>>   	return kvm_write_guest_cached(vcpu->kvm, &vcpu->arch.apf.data, &val,
>>   				      sizeof(val));
>> @@ -10405,7 +10406,8 @@ void kvm_arch_async_page_not_present(struct kvm_vcpu *vcpu,
>>   	kvm_add_async_pf_gfn(vcpu, work->arch.gfn);
>>   
>>   	if (kvm_can_deliver_async_pf(vcpu) &&
>> -	    !apf_put_user(vcpu, KVM_PV_REASON_PAGE_NOT_PRESENT)) {
>> +	    !apf_put_user(vcpu, KVM_PV_REASON_PAGE_NOT_PRESENT,
>> +			  work->arch.token)) {
>>   		fault.vector = PF_VECTOR;
>>   		fault.error_code_valid = true;
>>   		fault.error_code = 0;
>> @@ -10438,7 +10440,7 @@ void kvm_arch_async_page_present(struct kvm_vcpu *vcpu,
>>   	trace_kvm_async_pf_ready(work->arch.token, work->cr2_or_gpa);
>>   
>>   	if (vcpu->arch.apf.msr_val & KVM_ASYNC_PF_ENABLED &&
>> -	    !apf_put_user(vcpu, KVM_PV_REASON_PAGE_READY)) {
>> +	    !apf_put_user(vcpu, KVM_PV_REASON_PAGE_READY, work->arch.token)) {
>>   			fault.vector = PF_VECTOR;
>>   			fault.error_code_valid = true;
>>   			fault.error_code = 0;
>> 
>
> It would be as below based on two facts: (1) token is more important than reason;
> (2) token will be put into high word of @val. I think apf_{get,put}_user() might
> be worthy to be inline. However, it's not a big deal.

This is to be changed in v1 as we agreed to drop page-ready delivery via
#PF completely.

>     static inline int apf_put_user(struct kvm_vcpu *vcpu, u32 token, u32 reason)
>

Yes, it makes sense to inline these. Thanks!

-- 
Vitaly

