Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 434BF2FD18F
	for <lists+kvm@lfdr.de>; Wed, 20 Jan 2021 14:54:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731176AbhATMwS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jan 2021 07:52:18 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:25980 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388581AbhATMRk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 Jan 2021 07:17:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611144958;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=adpiIAj4FZBD1b7jrxhLV9luEhxbVjXaDkjpdCcAiMc=;
        b=F+6+UuLMHDI6fAxpWG09oh8+eTrc5MTkT/f3ubNCvmK//2RuV/6yyWIbqpoK3FUhORYNgx
        el2/Nx2kBHm6NkxxkixQgmt74TEGyTqdJHvakIXX614J5mGn/idrQaUOfNYiUnKT3Z9Ns7
        TXBFC734A6OJo/b2zcIGyt21amXwKQk=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-438-IICxESguP9CO7am006MwFw-1; Wed, 20 Jan 2021 07:15:56 -0500
X-MC-Unique: IICxESguP9CO7am006MwFw-1
Received: by mail-ed1-f71.google.com with SMTP id n18so10957373eds.2
        for <kvm@vger.kernel.org>; Wed, 20 Jan 2021 04:15:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=adpiIAj4FZBD1b7jrxhLV9luEhxbVjXaDkjpdCcAiMc=;
        b=BNgKMEoBTBst4IMV1dxjxvdaap1ELNW4rEtxFE341POYP75nhFiM8n59Uej1uPoA8J
         1h1S9O1g86Ay8yHmqssrH6++86nDsA9jSYXk5QG6ZrussdFkNHlrz7SvBb5xT+jeyT2z
         oBqTwbs+ff+oReeCTzfp6HJOrb8+209bz58MN/F4szTZE0VpfCBXXuSGui24PxLgmMkb
         BKX3XQXktWz45qwOHeAyBxa5odRnR84o6t5MjpuPjIlOkL6HAfxg4et5hzY6CRdUHt1C
         Bpq0pDA1Q67nkBbi1i6UYKsvIumqvlD/4W38b8dOrEm8tUIoUHPAgcCVictsV4FSI+oT
         gXuA==
X-Gm-Message-State: AOAM533QH0Mcp6YzDFG0VEy+Noa5zaW1w1X6SDJJqQsXkjHPu8E9atha
        wn2Yz4iw/MWl9PZ6XK7tlY/aCcCPjwTfhmw7+k4MIJJelrSR23nwcmOcsteox79K3EJ6C6OkulL
        QiQUsbGlAXkIq
X-Received: by 2002:a17:906:eca7:: with SMTP id qh7mr6054501ejb.437.1611144954782;
        Wed, 20 Jan 2021 04:15:54 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx6O2C4+5izC5c6Lv/XRFt4exMNaBCb5Plh3SHvvpBV1yU49oVGo94/HkA54ztBBIeuLqY4ZQ==
X-Received: by 2002:a17:906:eca7:: with SMTP id qh7mr6054486ejb.437.1611144954559;
        Wed, 20 Jan 2021 04:15:54 -0800 (PST)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id r26sm1082311edc.95.2021.01.20.04.15.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 04:15:53 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH 3/7] KVM: x86: hyper-v: Always use vcpu_to_hv_vcpu()
 accessor to get to 'struct kvm_vcpu_hv'
In-Reply-To: <YAdlxE1LYz9NSdq8@google.com>
References: <20210113143721.328594-1-vkuznets@redhat.com>
 <20210113143721.328594-4-vkuznets@redhat.com>
 <YAdlxE1LYz9NSdq8@google.com>
Date:   Wed, 20 Jan 2021 13:15:53 +0100
Message-ID: <87a6t36bye.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> On Wed, Jan 13, 2021, Vitaly Kuznetsov wrote:
>> As a preparation to allocating Hyper-V context dynamically, make it clear
>> who's the user of the said context.
>> 
>> No functional change intended.
>> 
>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> ---
>>  arch/x86/kvm/hyperv.c  | 14 ++++++++------
>>  arch/x86/kvm/hyperv.h  |  4 +++-
>>  arch/x86/kvm/lapic.h   |  6 +++++-
>>  arch/x86/kvm/vmx/vmx.c |  9 ++++++---
>>  arch/x86/kvm/x86.c     |  4 +++-
>>  5 files changed, 25 insertions(+), 12 deletions(-)
>> 
>> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
>> index 922c69dcca4d..82f51346118f 100644
>> --- a/arch/x86/kvm/hyperv.c
>> +++ b/arch/x86/kvm/hyperv.c
>> @@ -190,7 +190,7 @@ static void kvm_hv_notify_acked_sint(struct kvm_vcpu *vcpu, u32 sint)
>>  static void synic_exit(struct kvm_vcpu_hv_synic *synic, u32 msr)
>>  {
>>  	struct kvm_vcpu *vcpu = synic_to_vcpu(synic);
>> -	struct kvm_vcpu_hv *hv_vcpu = &vcpu->arch.hyperv;
>> +	struct kvm_vcpu_hv *hv_vcpu = vcpu_to_hv_vcpu(vcpu);
>
> Tangentially related...
>
> What say you about aligning Hyper-V to VMX and SVM terminology?  E.g. I like
> that VMX and VXM omit the "vcpu_" part and just call it "to_vmx/svm()", and the
> VM-scoped variables have a "kvm_" prefix but the vCPU-scoped variables do not.
> I'd probably even vote to do s/vcpu_to_pi_desc/to_pi_desc, but for whatever
> reason that one doesn't annoy as much, probably because it's less pervasive than
> the Hyper-V code.

Gererally I have nothing against the idea, will try to prepare a series.

>
> It would also help if the code were more consistent with itself.  It's all a bit
> haphazard when it comes to variable names, using helpers (or not), etc...
>
> Long term, it might also be worthwhile to refactor the various flows to always
> pass @vcpu instead of constantly converting to/from various objects.  Some of
> the conversions appear to be necessary, e.g. for timer callbacks, but AFAICT a
> lot of the shenanigans are entirely self-inflicted.
>
> E.g. stimer_set_count() has one caller, which already has @vcpu, but
> stimer_set_count() takes @stimer instead of @vcpu and then does several
> conversions in as many lines.  None of the conversions are super expensive, but
> it seems like every little helper in Hyper-V is doing multiple conversions to
> and from kvm_vcpu, and half the generated code is getting the right pointer. :-)

I *think* the idea was that everything synic-related takes a 'synic',
everything stimer-related takes an 'stimer' and so on. While this looks
cleaner from 'api' perspective, it indeed makes the code longer in some
cases so I'd also agree with 'optimization'.

>
>>  	hv_vcpu->exit.type = KVM_EXIT_HYPERV_SYNIC;
>>  	hv_vcpu->exit.u.synic.msr = msr;
>> @@ -294,7 +294,7 @@ static int kvm_hv_syndbg_complete_userspace(struct kvm_vcpu *vcpu)
>>  static void syndbg_exit(struct kvm_vcpu *vcpu, u32 msr)
>>  {
>>  	struct kvm_hv_syndbg *syndbg = vcpu_to_hv_syndbg(vcpu);
>> -	struct kvm_vcpu_hv *hv_vcpu = &vcpu->arch.hyperv;
>> +	struct kvm_vcpu_hv *hv_vcpu = vcpu_to_hv_vcpu(vcpu);
>>  
>>  	hv_vcpu->exit.type = KVM_EXIT_HYPERV_SYNDBG;
>>  	hv_vcpu->exit.u.syndbg.msr = msr;
>> @@ -840,7 +840,9 @@ void kvm_hv_vcpu_uninit(struct kvm_vcpu *vcpu)
>>  
>>  bool kvm_hv_assist_page_enabled(struct kvm_vcpu *vcpu)
>>  {
>> -	if (!(vcpu->arch.hyperv.hv_vapic & HV_X64_MSR_VP_ASSIST_PAGE_ENABLE))
>> +	struct kvm_vcpu_hv *hv_vcpu = vcpu_to_hv_vcpu(vcpu);
>> +
>> +	if (!(hv_vcpu->hv_vapic & HV_X64_MSR_VP_ASSIST_PAGE_ENABLE))
>>  		return false;
>>  	return vcpu->arch.pv_eoi.msr_val & KVM_MSR_ENABLED;
>>  }
>> @@ -1216,7 +1218,7 @@ static u64 current_task_runtime_100ns(void)
>>  
>>  static int kvm_hv_set_msr(struct kvm_vcpu *vcpu, u32 msr, u64 data, bool host)
>>  {
>> -	struct kvm_vcpu_hv *hv_vcpu = &vcpu->arch.hyperv;
>> +	struct kvm_vcpu_hv *hv_vcpu = vcpu_to_hv_vcpu(vcpu);
>>  
>>  	switch (msr) {
>>  	case HV_X64_MSR_VP_INDEX: {
>> @@ -1379,7 +1381,7 @@ static int kvm_hv_get_msr(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata,
>>  			  bool host)
>>  {
>>  	u64 data = 0;
>> -	struct kvm_vcpu_hv *hv_vcpu = &vcpu->arch.hyperv;
>> +	struct kvm_vcpu_hv *hv_vcpu = vcpu_to_hv_vcpu(vcpu);
>>  
>>  	switch (msr) {
>>  	case HV_X64_MSR_VP_INDEX:
>> @@ -1494,7 +1496,7 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *current_vcpu, u64 ingpa,
>>  			    u16 rep_cnt, bool ex)
>>  {
>>  	struct kvm *kvm = current_vcpu->kvm;
>
> Ugh, "current_vcpu".  That's really, really nasty, as it's silently shadowing a
> global per-cpu variable.  E.g. this compiles without so much as a warning:
>
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index 922c69dcca4d..142fe9c12957 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -1490,7 +1490,7 @@ static __always_inline unsigned long *sparse_set_to_vcpu_mask(
>         return vcpu_bitmap;
>  }
>
> -static u64 kvm_hv_flush_tlb(struct kvm_vcpu *current_vcpu, u64 ingpa,
> +static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, u64 ingpa,
>                             u16 rep_cnt, bool ex)
>  {
>         struct kvm *kvm = current_vcpu->kvm;
> @@ -1592,7 +1592,7 @@ static void kvm_send_ipi_to_many(struct kvm *kvm, u32 vector,
>         }
>  }
>
> -static u64 kvm_hv_send_ipi(struct kvm_vcpu *current_vcpu, u64 ingpa, u64 outgpa,
> +static u64 kvm_hv_send_ipi(struct kvm_vcpu *vcpu, u64 ingpa, u64 outgpa,
>                            bool ex, bool fast)
>  {
>         struct kvm *kvm = current_vcpu->kvm;
>

My memory tells me both these functions had local 'vcpu' variable to
iterate over all vCPUs but it's not there now, I'll send a patch to drop
'current_vcpu'.

>> -	struct kvm_vcpu_hv *hv_vcpu = &current_vcpu->arch.hyperv;
>> +	struct kvm_vcpu_hv *hv_vcpu = vcpu_to_hv_vcpu(current_vcpu);
>>  	struct hv_tlb_flush_ex flush_ex;
>>  	struct hv_tlb_flush flush;
>>  	u64 vp_bitmap[KVM_HV_MAX_SPARSE_VCPU_SET_BITS];
>> diff --git a/arch/x86/kvm/hyperv.h b/arch/x86/kvm/hyperv.h
>> index 6d7def2b0aad..6300038e7a52 100644
>> --- a/arch/x86/kvm/hyperv.h
>> +++ b/arch/x86/kvm/hyperv.h
>> @@ -114,7 +114,9 @@ static inline struct kvm_vcpu *stimer_to_vcpu(struct kvm_vcpu_hv_stimer *stimer)
>>  
>>  static inline bool kvm_hv_has_stimer_pending(struct kvm_vcpu *vcpu)
>>  {
>> -	return !bitmap_empty(vcpu->arch.hyperv.stimer_pending_bitmap,
>> +	struct kvm_vcpu_hv *hv_vcpu = vcpu_to_hv_vcpu(vcpu);
>> +
>> +	return !bitmap_empty(hv_vcpu->stimer_pending_bitmap,
>>  			     HV_SYNIC_STIMER_COUNT);
>>  }
>>  
>> diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
>> index 4fb86e3a9dd3..dec7356f2fcd 100644
>> --- a/arch/x86/kvm/lapic.h
>> +++ b/arch/x86/kvm/lapic.h
>> @@ -6,6 +6,8 @@
>>  
>>  #include <linux/kvm_host.h>
>>  
>> +#include "hyperv.h"
>> +
>>  #define KVM_APIC_INIT		0
>>  #define KVM_APIC_SIPI		1
>>  #define KVM_APIC_LVT_NUM	6
>> @@ -127,7 +129,9 @@ int kvm_hv_vapic_msr_read(struct kvm_vcpu *vcpu, u32 msr, u64 *data);
>>  
>>  static inline bool kvm_hv_vapic_assist_page_enabled(struct kvm_vcpu *vcpu)
>>  {
>> -	return vcpu->arch.hyperv.hv_vapic & HV_X64_MSR_VP_ASSIST_PAGE_ENABLE;
>> +	struct kvm_vcpu_hv *hv_vcpu = vcpu_to_hv_vcpu(vcpu);
>> +
>> +	return hv_vcpu->hv_vapic & HV_X64_MSR_VP_ASSIST_PAGE_ENABLE;
>
> A short to_hyperv() would be nice here, e.g.
>
> 	return to_hyperv(vcpu)->hv_vapic & HV_X64_MSR_VP_ASSIST_PAGE_ENABLE;
>
>
> LOL, actually, kvm_hv_vapic_assist_page_enabled() doesn't have any callers and
> can be dropped.  Looks likes it's supplanted by kvm_hv_assist_page_enabled().
>

:-)

>>  }
>>  
>>  int kvm_lapic_enable_pv_eoi(struct kvm_vcpu *vcpu, u64 data, unsigned long len);
>

-- 
Vitaly

