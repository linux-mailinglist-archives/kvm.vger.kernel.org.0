Return-Path: <kvm+bounces-36284-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 42233A19767
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 18:19:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E2683188C39D
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 17:19:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 316E6215174;
	Wed, 22 Jan 2025 17:19:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JKzl+ULD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E19B16F8F5;
	Wed, 22 Jan 2025 17:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737566381; cv=none; b=M+9/TxTE0XVDSTNZpq+xvJdb+R9Vi90G8Q7MmsLRXUGQi6Zb9xvROm/pq8O1BPkveX/YiXsehUNxgpkXEjfUz+9WdsxMMoi9tHVllPg/nbftXKcshR/6gErC/wql4KoCQF7C3zJzI2EHzRyWGaojXoUUIY4gFBWKeQZOKe3iGiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737566381; c=relaxed/simple;
	bh=7dbdXpImeQ0tM6k9O3awzZtfIcmjoVPebl6YUBYGiHc=;
	h=From:Message-ID:Date:MIME-Version:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=K6NHZJBHEZhvNDSr+PsnatEJ82MbsrdJ7AQEqHk3dbaK83pumcEaR6Ftix1fnQl30aSJOwX2BtrfYfPEYwxVDOjn0ugG5zqB0m3jdInrGI251nd0mUKC9KtXiz9ylexG3YTb+2wZJlTZtaB6aWBatpvLQrWgwBAxEuvDKmTrOcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JKzl+ULD; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4361815b96cso50756165e9.1;
        Wed, 22 Jan 2025 09:19:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737566378; x=1738171178; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=qHBsY/KT5vsvI7tk1hJokWw+P0wLfaemcx49WrtSUjE=;
        b=JKzl+ULDT3qse89iVW/vY2AxcTm/raGrfCjUtbNw9yAWNs1/JvKICXiLLKhOUecOgJ
         wkHlAtrTjutQYbQd5yke55w/Hd8BDBxsm30qM8fcn81phq5hopEWyP3XDG19Kax0nPSE
         OQGiAyophbsS20QeQVmqotc2Qj6ITA9b1AL94t8Ru+jFuSOinFXV1Gyjy0UkI94dxshJ
         4wQ8u28hjL95nSHI7spvN6kpP8kYNZ9ombyXGvD3RSAtlTXoZGOKpe63hAlJCl09bzOR
         klhSFbx996w/jkq8wuvJ+aZmfEQSH+Cf6aFuyWapAWotNnNKup366ka2/fpbb4606reC
         YQQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737566378; x=1738171178;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qHBsY/KT5vsvI7tk1hJokWw+P0wLfaemcx49WrtSUjE=;
        b=UQVxJjTQ20ay04F/0SiePZJwU3lLNWAzXf6AvqRM0+l6o9Y3cnd+ByPk6Dk8P88/p0
         qVn2qx+Y2fiXC5A0J2xhB9e9jtJFVPYSUsxhE/4AHVq1nexyA6ITgAE6M2ZYQ0xymekT
         nH7YAJBirpBVabRgLBI7CwqEtWWTeZG9ZyWGDR3TZt44e7siNTcxauMXjenjiPRnWvxg
         s6a5CAN1NkR9GpKlnkzkLdVX8sy8ixLtHa651dcxZeg3Zrt5xqXV1SJYkVY7wh47tzY7
         FI0pn6FQ+AHW/9EYdaDnIrHZEInyqMXwWUXHKGk/teTBB8GCN/1ROBNUL1jcF0sd2XiF
         HTDQ==
X-Forwarded-Encrypted: i=1; AJvYcCV9vJGYQKq0IiEglfFDfciQt1wQnh/Sbho+U1ZZA/FZPIFeNY2JJ/bvQz+MR0S/NPhCq4Bp4fGqI20E0t50@vger.kernel.org, AJvYcCXTGf1Rgz1FQeDYa/ncMm4bTO3t7M51RSkOifs57+kTletUEYd1gZ1VeQ+abzbHrf2PCLw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwoTdU31y0OMym8IaiPhjuW7ul6blDO24FzKzb+kpk7uo1nl7pE
	E3yeNRkmzU/0GALHJhtebyRof4K0DsmZZCzZgugwp/JJoExP9KzH
X-Gm-Gg: ASbGnct6MDLWMixh+GNOZyAQrnnfW2S9yHq80eflBXrjcy6fvpeMHbYA3tHTO3XMdip
	WtIAmm4xz+PwdciYLjegq9+W5GmFfne5kCyAdjA6JSi6D2zcLqVjfalR5u35LRjvKyQGn9ShWmF
	jaV4AQFOgcYgW0knVFJx8RsOf4siLKEg+h4PD/y3VAwolBkO9gQOlo6LBWxYfOHsdER5zAaeCRO
	dp0BhJVF+3aOMQxjGWxHnHffVGEUCv0E2h5vzolLPZDJFtHE5Yx/KilcGqLOR+8ynwyJ1TKEkhb
	0mMNJjhbRs0vMbV8TKToSbEjCQ==
X-Google-Smtp-Source: AGHT+IG7BcROatzdJWqeusf4bUWwWu9jO10RPU8bu9Nfu2TaV+nrCIQy1CL+rdXwvY0bQjDV73EzQQ==
X-Received: by 2002:a05:600c:310a:b0:434:e9ee:c1e with SMTP id 5b1f17b1804b1-4389144ee14mr225690285e9.31.1737566377365;
        Wed, 22 Jan 2025 09:19:37 -0800 (PST)
Received: from [192.168.19.91] (54-240-197-233.amazon.com. [54.240.197.233])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38bf3221dc7sm16667530f8f.24.2025.01.22.09.19.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jan 2025 09:19:37 -0800 (PST)
From: Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <a5d69c3b-5b9f-4ecf-bae2-2110e52eac64@xen.org>
Date: Wed, 22 Jan 2025 17:19:35 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [PATCH] KVM: x86: Update Xen-specific CPUID leaves during
 mangling
To: Vitaly Kuznetsov <vkuznets@redhat.com>,
 Fred Griffoul <fgriffo@amazon.co.uk>, kvm@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, David Woodhouse <dwmw2@infradead.org>,
 linux-kernel@vger.kernel.org
References: <20250122161612.20981-1-fgriffo@amazon.co.uk>
 <87tt9q7orq.fsf@redhat.com>
Content-Language: en-US
Organization: Xen Project
In-Reply-To: <87tt9q7orq.fsf@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 22/01/2025 17:16, Vitaly Kuznetsov wrote:
> Fred Griffoul <fgriffo@amazon.co.uk> writes:
> 
>> Previous commit ee3a5f9e3d9b ("KVM: x86: Do runtime CPUID update before
>> updating vcpu->arch.cpuid_entries") implemented CPUID data mangling in
>> KVM_SET_CPUID2 support before verifying that no changes occur on running
>> vCPUs. However, it overlooked the CPUID leaves that are modified by
>> KVM's Xen emulation.
>>
>> Fix this by calling a Xen update function when mangling CPUID data.
>>
>> Fixes: ee3a5f9e3d9b ("KVM: x86: Do runtime CPUID update before
>> updating vcpu->arch.cpuid_entries")
> 
> Well, kvm_xen_update_tsc_info() was added with
> 
> commit f422f853af0369be27d2a9f1b20079f2bc3d1ca2
> Author: Paul Durrant <pdurrant@amazon.com>
> Date:   Fri Jan 6 10:36:00 2023 +0000
> 
>      KVM: x86/xen: update Xen CPUID Leaf 4 (tsc info) sub-leaves, if present
> 
> and the commit you mention in 'Fixes' is older:
> 
> commit ee3a5f9e3d9bf94159f3cc80da542fbe83502dd8
> Author: Vitaly Kuznetsov <vkuznets@redhat.com>
> Date:   Mon Jan 17 16:05:39 2022 +0100
> 
>      KVM: x86: Do runtime CPUID update before updating vcpu->arch.cpuid_entries
> 
> so I guess we should be 'Fixing' f422f853af03 instead :-)
> 
>> Signed-off-by: Fred Griffoul <fgriffo@amazon.co.uk>
>> ---
>>   arch/x86/kvm/cpuid.c | 1 +
>>   arch/x86/kvm/xen.c   | 5 +++++
>>   arch/x86/kvm/xen.h   | 5 +++++
>>   3 files changed, 11 insertions(+)
>>
>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>> index edef30359c19..432d8e9e1bab 100644
>> --- a/arch/x86/kvm/cpuid.c
>> +++ b/arch/x86/kvm/cpuid.c
>> @@ -212,6 +212,7 @@ static int kvm_cpuid_check_equal(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2
>>   	 */
>>   	kvm_update_cpuid_runtime(vcpu);
>>   	kvm_apply_cpuid_pv_features_quirk(vcpu);
>> +	kvm_xen_update_cpuid_runtime(vcpu);
> 
> This one is weird as we update it in runtime (kvm_guest_time_update())
> and values may change when we e.g. migrate the guest. First, I do not
> understand how the guest is supposed to notice the change as CPUID data
> is normally considered static. Second, I do not see how the VMM is
> supposed to track it as if it tries to supply some different data for
> these Xen leaves, kvm_cpuid_check_equal() will still fail.
> 
> Would it make more sense to just ignore these Xen CPUID leaves with TSC
> information when we do the comparison?
> 

What is the purpose of the comparison anyway? IIUC we want to ensure 
that a VMM does not change its mind after KVM_RUN so should we not be 
stashing what was set by the VMM and comparing against that *before* 
mangling any values?

>>   
>>   	if (nent != vcpu->arch.cpuid_nent)
>>   		return -EINVAL;
>> diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
>> index a909b817b9c0..219f9a9a92be 100644
>> --- a/arch/x86/kvm/xen.c
>> +++ b/arch/x86/kvm/xen.c
>> @@ -2270,6 +2270,11 @@ void kvm_xen_update_tsc_info(struct kvm_vcpu *vcpu)
>>   		entry->eax = vcpu->arch.hw_tsc_khz;
>>   }
>>   
>> +void kvm_xen_update_cpuid_runtime(struct kvm_vcpu *vcpu)
>> +{
>> +	kvm_xen_update_tsc_info(vcpu);
>> +}
>> +
>>   void kvm_xen_init_vm(struct kvm *kvm)
>>   {
>>   	mutex_init(&kvm->arch.xen.xen_lock);
>> diff --git a/arch/x86/kvm/xen.h b/arch/x86/kvm/xen.h
>> index f5841d9000ae..d3182b0ab7e3 100644
>> --- a/arch/x86/kvm/xen.h
>> +++ b/arch/x86/kvm/xen.h
>> @@ -36,6 +36,7 @@ int kvm_xen_setup_evtchn(struct kvm *kvm,
>>   			 struct kvm_kernel_irq_routing_entry *e,
>>   			 const struct kvm_irq_routing_entry *ue);
>>   void kvm_xen_update_tsc_info(struct kvm_vcpu *vcpu);
>> +void kvm_xen_update_cpuid_runtime(struct kvm_vcpu *vcpu);
>>   
>>   static inline void kvm_xen_sw_enable_lapic(struct kvm_vcpu *vcpu)
>>   {
>> @@ -160,6 +161,10 @@ static inline bool kvm_xen_timer_enabled(struct kvm_vcpu *vcpu)
>>   static inline void kvm_xen_update_tsc_info(struct kvm_vcpu *vcpu)
>>   {
>>   }
>> +
>> +static inline void kvm_xen_update_cpuid_runtime(struct kvm_vcpu *vcpu)
>> +{
>> +}
>>   #endif
>>   
>>   int kvm_xen_hypercall(struct kvm_vcpu *vcpu);
> 


