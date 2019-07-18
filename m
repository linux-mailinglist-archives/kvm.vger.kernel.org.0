Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAA236CF23
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2019 15:50:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390448AbfGRNuK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Jul 2019 09:50:10 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:37116 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390362AbfGRNuK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Jul 2019 09:50:10 -0400
Received: by mail-wr1-f67.google.com with SMTP id n9so3719841wrr.4
        for <kvm@vger.kernel.org>; Thu, 18 Jul 2019 06:50:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Bz4hXPRK29P5/tSQD68cHTBPadb5Yosu8Qu+r8c9DuM=;
        b=AJ3BgNJPLLIS67exuRRFHDTVawKPgGjPLSBkib/1iVgNS2RgtoEEHyhMW7rJV8tme+
         5FGN0IWN56koz2cbMiHCnFXTYhZ3qao3bvx1L/DMapiW2lpcDQjXD3VXh+r4yrw2Q9uU
         tpkEJ58ARpiDpui52rxs8YcBNIBCu70jVIC4qDQlHWCtgu4DugwAzzOIRpLBRHAHbUTD
         psCIlqYsK/c9Ime220F08EJqSP9X3hIU08h7JsCAGAwE+QetDqXgXGPZItULPGxFWu4z
         5X1MvC5acwF45ny6XTSom4x5QT3GUQCDt3vS+pfqAYdBL9wzuLDMhhjlQ3EFRdAMpF7f
         OQTw==
X-Gm-Message-State: APjAAAXKMFdBxjWxAToK5Zpirq0bxcx5O5MDQi3rruh+Y9AT7dwVc6d0
        vWbL0jA0JfeFqsQUhUQcSAooLQ==
X-Google-Smtp-Source: APXvYqwpwFxUVWFfPgX205bMOicWtlXBUDH5d5qy2/uaaO9L8NQkWL0kgSuznvRy5cX56Dyvvft4SA==
X-Received: by 2002:a05:6000:1043:: with SMTP id c3mr24338666wrx.236.1563457807970;
        Thu, 18 Jul 2019 06:50:07 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:e427:3beb:1110:dda2? ([2001:b07:6468:f312:e427:3beb:1110:dda2])
        by smtp.gmail.com with ESMTPSA id t13sm33212917wrr.0.2019.07.18.06.50.06
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Jul 2019 06:50:07 -0700 (PDT)
Subject: Re: [PATCH 1/2] KVM: Boost vCPUs that are delivering interrupts
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     wanpengli@tencent.com, rkrcmar@redhat.com, paulus@ozlabs.org,
        maz@kernel.org
References: <1563457031-21189-1-git-send-email-pbonzini@redhat.com>
 <1563457031-21189-2-git-send-email-pbonzini@redhat.com>
 <c28fb650-8150-4f42-4d01-8e8b2490c8b6@de.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <d935d853-fa09-f41a-637a-77b45fd611d3@redhat.com>
Date:   Thu, 18 Jul 2019 15:50:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <c28fb650-8150-4f42-4d01-8e8b2490c8b6@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/07/19 15:45, Christian Borntraeger wrote:
> 
> 
> On 18.07.19 15:37, Paolo Bonzini wrote:
>> From: Wanpeng Li <wanpengli@tencent.com>
>>
>> Inspired by commit 9cac38dd5d (KVM/s390: Set preempted flag during
>> vcpu wakeup and interrupt delivery), we want to also boost not just
>> lock holders but also vCPUs that are delivering interrupts. Most
>> smp_call_function_many calls are synchronous, so the IPI target vCPUs
>> are also good yield candidates.  This patch introduces vcpu->ready to
>> boost vCPUs during wakeup and interrupt delivery time; unlike s390 we do
>> not reuse vcpu->preempted so that voluntarily preempted vCPUs are taken
>> into account by kvm_vcpu_on_spin, but vmx_vcpu_pi_put is not affected
>> (VT-d PI handles voluntary preemption separately, in pi_pre_block).
>>
>> Testing on 80 HT 2 socket Xeon Skylake server, with 80 vCPUs VM 80GB RAM:
>> ebizzy -M
>>
>>             vanilla     boosting    improved
>> 1VM          21443       23520         9%
>> 2VM           2800        8000       180%
>> 3VM           1800        3100        72%
>>
>> Testing on my Haswell desktop 8 HT, with 8 vCPUs VM 8GB RAM, two VMs,
>> one running ebizzy -M, the other running 'stress --cpu 2':
>>
>> w/ boosting + w/o pv sched yield(vanilla)
>>
>>             vanilla     boosting   improved
>>               1570         4000      155%
>>
>> w/ boosting + w/ pv sched yield(vanilla)
>>
>>             vanilla     boosting   improved
>>               1844         5157      179%
>>
>> w/o boosting, perf top in VM:
>>
>>  72.33%  [kernel]       [k] smp_call_function_many
>>   4.22%  [kernel]       [k] call_function_i
>>   3.71%  [kernel]       [k] async_page_fault
>>
>> w/ boosting, perf top in VM:
>>
>>  38.43%  [kernel]       [k] smp_call_function_many
>>   6.31%  [kernel]       [k] async_page_fault
>>   6.13%  libc-2.23.so   [.] __memcpy_avx_unaligned
>>   4.88%  [kernel]       [k] call_function_interrupt
>>
>> Cc: Paolo Bonzini <pbonzini@redhat.com>
>> Cc: Radim Krčmář <rkrcmar@redhat.com>
>> Cc: Christian Borntraeger <borntraeger@de.ibm.com>
>> Cc: Paul Mackerras <paulus@ozlabs.org>
>> Cc: Marc Zyngier <maz@kernel.org>
>> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>> ---
>> 	v2->v3: put it in kvm_vcpu_wake_up, use WRITE_ONCE
> 
> 
> Looks good. Some more comments
> 
>>
>>  arch/s390/kvm/interrupt.c | 2 +-
>>  include/linux/kvm_host.h  | 1 +
>>  virt/kvm/kvm_main.c       | 9 +++++++--
> [...]
> 
>> @@ -4205,6 +4206,8 @@ static void kvm_sched_in(struct preempt_notifier *pn, int cpu)
>>  
>>  	if (vcpu->preempted)
>>  		vcpu->preempted = false;
>> +	if (vcpu->ready)
>> +		WRITE_ONCE(vcpu->ready, false);
> 
> What is the rationale of checking before writing. Avoiding writable cache line ping pong?

I think it can be removed.  The only case where you'd have ping pong is
when vcpu->ready is true due to kvm_vcpu_wake_up, so it's not saving
anything.

>>  	kvm_arch_sched_in(vcpu, cpu);
>>  
>> @@ -4216,8 +4219,10 @@ static void kvm_sched_out(struct preempt_notifier *pn,
>>  {
>>  	struct kvm_vcpu *vcpu = preempt_notifier_to_vcpu(pn);
>>  
>> -	if (current->state == TASK_RUNNING)
>> +	if (current->state == TASK_RUNNING) {
>>  		vcpu->preempted = true;
> 
> WOuld it make sense to also use WRITE_ONCE for vcpu->preempted ?

vcpu->preempted is not read/written anymore by other threads after this
patch.
> 
>> +		WRITE_ONCE(vcpu->ready, true);
>> +	}
>>  	kvm_arch_vcpu_put(vcpu);
>>  }
>>  
>>
> 

