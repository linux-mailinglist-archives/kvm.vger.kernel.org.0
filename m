Return-Path: <kvm+bounces-40267-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 388D3A55422
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 19:08:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B7B1B174488
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 18:06:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0FBE2780FF;
	Thu,  6 Mar 2025 18:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="K3QYqisI"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF742271295
	for <kvm@vger.kernel.org>; Thu,  6 Mar 2025 18:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741284278; cv=none; b=mtpFjHwZFBA3M+ESYT2CSj37Zitpb2wuLQ3aOuM2R+rrECH06gsx5EhwfGPcKB7MmOIZCKxgpaOdHkM5i2duzb6IQ+L4ifUMuF3J7W36R/BpD+u41LOEQ0wRQ+nKdX6Ey9JHIudPd8PcEcIs2T6qfU994cB1CQTJ/imLdS89iJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741284278; c=relaxed/simple;
	bh=jsZ89rPW8SVxwb/94fTRHgQYP6dcsmlemLCLpxtFjT0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KdqLJ1YTRB8wM8GG9zkAB4SPy7u+usD4hRgfDJfK41kWxu5z06g4KBaqHSuRnIYjQHtru5EQQKuzta78L7Ot265A1+1wXVMqs/gH+IqWc4JPfHv/b/yIMhCHvCGH3X2HXnkuTi+L5s2rmHersTiUhBTMEIIxGm9bgtSyBFbLP70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=K3QYqisI; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741284274;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=pLBvLweWonzCO2qK3YJRAhjHec0mbtZh2afYe9FoHpU=;
	b=K3QYqisICBdWU4d9jGkMUhrwYlOrMZ7k+QX43rzaPsbp/JUq1DWpT5nD9xeze8rAxK0wxj
	G9ycRa91Tl2sOPtP8SzQk238xKyiocyrs+eUuPY5wmE8nOCfB0FmNq4QBGfJ9eitWbhSOY
	nN60caYPRjyokTAfK2RwgquB44cKu8M=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-688-wQ8RK7-dOe2OqU9mpteLHw-1; Thu, 06 Mar 2025 13:04:28 -0500
X-MC-Unique: wQ8RK7-dOe2OqU9mpteLHw-1
X-Mimecast-MFC-AGG-ID: wQ8RK7-dOe2OqU9mpteLHw_1741284267
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-ac21873859dso93191066b.2
        for <kvm@vger.kernel.org>; Thu, 06 Mar 2025 10:04:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741284267; x=1741889067;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pLBvLweWonzCO2qK3YJRAhjHec0mbtZh2afYe9FoHpU=;
        b=W1k1Yhkb6IZwQQZLnoZYcBXUYZ5phkcBOPEhj3HscOBXbbNRg7+uOScQCWJz7RN7Xv
         nrJCk5Rdd5QPx53YAxhJJaY4hAd2Zq6KTejzLuG9DcgHCZm1YnS8xmFPoZ/CYf6aQ7dX
         hEcu5CZQPa73dBFJ+D479azWMsNySzaVVL4a01mLN4D2ybViVSczM9YLwea/Jp4bZMJJ
         /vMqlmP6/dV57kxuyGl1hdp3Fahi08N9SKmZBOzaGACnImJww/j5HcVrtkfXjhKnKJma
         nAIKxiDylkYm9ORBXTOqJPy4o145ZHJaC8z9tyyDIk4lgUxZL5bMt/woOQNFDHeSjVzx
         6/MQ==
X-Gm-Message-State: AOJu0YwmbKVlVvVsAVleMNMLAEd2Mml4fSpVfr1yRoEkOse9bY13BqlF
	OBK6B/x14P1NLhub//ISL8O9/PXnhjZKo7NkGBsBwsAnRR2uQ09Elbr+VfXG442KSff2JcWS5Pd
	aHWIlUhyvsj2fY0uAMFaCnARWScXme29j9g7t7cE3wVjibYY8+g==
X-Gm-Gg: ASbGncs2FYJsr604UrVGxa4THCZUefR57LnaynigD4wAO6iKETRPk/OmlZFQlUZASvx
	veqHgUg+mbz581laKd0XVDFNcXaHLh4CzPTM38VJJuIqI2lVtSjp1/lPH/AMi8oVkilSr9k9DA7
	0AIFo2B3KQZmHvs8Osa2uvLvxe6AnIkAP6+6R//P/uI9jPcP7/ke4Z6c0nR42qgzbqNX1JYEKKd
	fU1oIenJJHgP2F4h+Rnknzsk07NUx/zojLpB4Xbqqd+9U15q2ixeQ8Vocw06FSQrq3pOIihx+P9
	jCJV3GmwQO96khAyMQ==
X-Received: by 2002:a17:907:788:b0:ac1:f19a:c0b8 with SMTP id a640c23a62f3a-ac252641940mr731566b.24.1741284266829;
        Thu, 06 Mar 2025 10:04:26 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE8NUefjgvE9EqIYm5RxhrQBZhigrHZsPqhDIvh2JtR2gwQ9o40dK+HVt5GaTkHWYeT0BJHqQ==
X-Received: by 2002:a17:907:788:b0:ac1:f19a:c0b8 with SMTP id a640c23a62f3a-ac252641940mr722566b.24.1741284266228;
        Thu, 06 Mar 2025 10:04:26 -0800 (PST)
Received: from [192.168.1.84] ([93.56.163.127])
        by smtp.googlemail.com with ESMTPSA id a640c23a62f3a-ac23988bd53sm131534566b.143.2025.03.06.10.04.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Mar 2025 10:04:25 -0800 (PST)
Message-ID: <0745c6ee-9d8b-4936-ab1f-cfecceb86735@redhat.com>
Date: Thu, 6 Mar 2025 19:04:23 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 02/12] KVM: x86: Allow the use of
 kvm_load_host_xsave_state() with guest_state_protected
To: Xiaoyao Li <xiaoyao.li@intel.com>, Adrian Hunter
 <adrian.hunter@intel.com>, seanjc@google.com
Cc: kvm@vger.kernel.org, rick.p.edgecombe@intel.com, kai.huang@intel.com,
 reinette.chatre@intel.com, tony.lindgren@linux.intel.com,
 binbin.wu@linux.intel.com, dmatlack@google.com, isaku.yamahata@intel.com,
 nik.borisov@suse.com, linux-kernel@vger.kernel.org, yan.y.zhao@intel.com,
 chao.gao@intel.com, weijiang.yang@intel.com
References: <20250129095902.16391-1-adrian.hunter@intel.com>
 <20250129095902.16391-3-adrian.hunter@intel.com>
 <01e85b96-db63-4de2-9f49-322919e054ec@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <01e85b96-db63-4de2-9f49-322919e054ec@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2/20/25 11:50, Xiaoyao Li wrote:
> On 1/29/2025 5:58 PM, Adrian Hunter wrote:
>> From: Sean Christopherson <seanjc@google.com>
>>
>> Allow the use of kvm_load_host_xsave_state() with
>> vcpu->arch.guest_state_protected == true. This will allow TDX to reuse
>> kvm_load_host_xsave_state() instead of creating its own version.
>>
>> For consistency, amend kvm_load_guest_xsave_state() also.
>>
>> Ensure that guest state that kvm_load_host_xsave_state() depends upon,
>> such as MSR_IA32_XSS, cannot be changed by user space, if
>> guest_state_protected.
>>
>> [Adrian: wrote commit message]
>>
>> Link: https://lore.kernel.org/r/Z2GiQS_RmYeHU09L@google.com
>> Signed-off-by: Sean Christopherson <seanjc@google.com>
>> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
>> ---
>> TD vcpu enter/exit v2:
>>   - New patch
>> ---
>>   arch/x86/kvm/svm/svm.c |  7 +++++--
>>   arch/x86/kvm/x86.c     | 18 +++++++++++-------
>>   2 files changed, 16 insertions(+), 9 deletions(-)
>>
>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>> index 7640a84e554a..b4bcfe15ad5e 100644
>> --- a/arch/x86/kvm/svm/svm.c
>> +++ b/arch/x86/kvm/svm/svm.c
>> @@ -4253,7 +4253,9 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct 
>> kvm_vcpu *vcpu,
>>           svm_set_dr6(svm, DR6_ACTIVE_LOW);
>>       clgi();
>> -    kvm_load_guest_xsave_state(vcpu);
>> +
>> +    if (!vcpu->arch.guest_state_protected)
>> +        kvm_load_guest_xsave_state(vcpu);
>>       kvm_wait_lapic_expire(vcpu);
>> @@ -4282,7 +4284,8 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct 
>> kvm_vcpu *vcpu,
>>       if (unlikely(svm->vmcb->control.exit_code == SVM_EXIT_NMI))
>>           kvm_before_interrupt(vcpu, KVM_HANDLING_NMI);
>> -    kvm_load_host_xsave_state(vcpu);
>> +    if (!vcpu->arch.guest_state_protected)
>> +        kvm_load_host_xsave_state(vcpu);
>>       stgi();
>>       /* Any pending NMI will happen here */
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index bbb6b7f40b3a..5cf9f023fd4b 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -1169,11 +1169,9 @@ EXPORT_SYMBOL_GPL(kvm_lmsw);
>>   void kvm_load_guest_xsave_state(struct kvm_vcpu *vcpu)
>>   {
>> -    if (vcpu->arch.guest_state_protected)
>> -        return;
>> +    WARN_ON_ONCE(vcpu->arch.guest_state_protected);
>>       if (kvm_is_cr4_bit_set(vcpu, X86_CR4_OSXSAVE)) {
>> -
>>           if (vcpu->arch.xcr0 != kvm_host.xcr0)
>>               xsetbv(XCR_XFEATURE_ENABLED_MASK, vcpu->arch.xcr0);
>> @@ -1192,13 +1190,11 @@ EXPORT_SYMBOL_GPL(kvm_load_guest_xsave_state);
>>   void kvm_load_host_xsave_state(struct kvm_vcpu *vcpu)
>>   {
>> -    if (vcpu->arch.guest_state_protected)
>> -        return;
>> -
>>       if (cpu_feature_enabled(X86_FEATURE_PKU) &&
>>           ((vcpu->arch.xcr0 & XFEATURE_MASK_PKRU) ||
>>            kvm_is_cr4_bit_set(vcpu, X86_CR4_PKE))) {
>> -        vcpu->arch.pkru = rdpkru();
>> +        if (!vcpu->arch.guest_state_protected)
>> +            vcpu->arch.pkru = rdpkru();
> 
> this needs justification.
> 
>>           if (vcpu->arch.pkru != vcpu->arch.host_pkru)
>>               wrpkru(vcpu->arch.host_pkru);
>>       }
> 
> 
>> @@ -3916,6 +3912,10 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, 
>> struct msr_data *msr_info)
>>           if (!msr_info->host_initiated &&
>>               !guest_cpuid_has(vcpu, X86_FEATURE_XSAVES))
>>               return 1;
>> +
>> +        if (vcpu->arch.guest_state_protected)
>> +            return 1;
>> +
> 
> this and below change need to be a separate patch. So that we can 
> discuss independently.
> 
> I see no reason to make MSR_IA32_XSS special than other MSRs. When 
> guest_state_protected, most of the MSRs that aren't emulated by KVM are 
> inaccessible by KVM.

I agree with Xiaoyao that this change is sensible but should be proposed 
separately for both SNP and TDX.

Allowing the use of kvm_load_host_xsave_state() is really ugly, 
especially since the corresponding code is so simple:

         if (cpu_feature_enabled(X86_FEATURE_PKU) && vcpu->arch.pkru != 0)
                         wrpkru(vcpu->arch.host_pkru);

	if (kvm_host.xcr0 != kvm_tdx->xfam & kvm_caps.supported_xcr0)
		xsetbv(XCR_XFEATURE_ENABLED_MASK, kvm_host.xcr0);

	/*
	 * All TDX hosts support XSS; but even if they didn't, both
	 * arms of the comparison would be 0 and the wrmsrl would be
	 * skipped.
	 */
	if (kvm_host.xss != kvm_tdx->xfam & kvm_caps.supported_xss)
		wrmsrl(MSR_IA32_XSS, kvm_host.xss);

This is really all that should be in patch 7.  I'll test it and decide 
what to do.

Paolo

>>           /*
>>            * KVM supports exposing PT to the guest, but does not support
>>            * IA32_XSS[bit 8]. Guests have to use RDMSR/WRMSR rather than
>> @@ -4375,6 +4375,10 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, 
>> struct msr_data *msr_info)
>>           if (!msr_info->host_initiated &&
>>               !guest_cpuid_has(vcpu, X86_FEATURE_XSAVES))
>>               return 1;
>> +
>> +        if (vcpu->arch.guest_state_protected)
>> +            return 1;
>> +
>>           msr_info->data = vcpu->arch.ia32_xss;
>>           break;
>>       case MSR_K7_CLK_CTL:
> 
> 


