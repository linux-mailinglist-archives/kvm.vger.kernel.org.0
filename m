Return-Path: <kvm+bounces-11211-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A9D58742FE
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 23:50:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5A100B215E6
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 22:50:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 238FE1C294;
	Wed,  6 Mar 2024 22:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IWseiZzj"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C713F1B7E4
	for <kvm@vger.kernel.org>; Wed,  6 Mar 2024 22:50:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709765432; cv=none; b=ETP56+pbyPmc7pjQweLDQNTbVOB1PtdSb7MijfHxsf0wqBjNT5ftMP298G6Rum5Ndkl4dEibPiP8IIVW9nLoxc0ExpsoWz9Ztr83oXBdVne0Iy8cf82aVLtq73EJXEz2m30iKqjv3O1+IkcMwKGlVaqCQ4v3/b2e5gKexiawfac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709765432; c=relaxed/simple;
	bh=MJ3LTg0OpimmT8LKwjutihAnsXVwZ2IPArLjxwmQWX8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OaHqN9Oa9cRZK4CXiynheKVU5pJcytfvIkiVOAspObI7hkwOMSjSYiY4jmD8jhdADpEd6BASG+W2y0amUrYO+y0j4B+JKN3pJZVRdrHLxSublV4zQXoGrhvI3Jk/93HMygAQFhCKxtCeT3v+Q1XAPdxCjyfKcIiZ2ZHq6p4Lp8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IWseiZzj; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709765429;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=6/xvQU8rXItkULsiiSVQuN/RKusV0WKlNtmQo2+vXZs=;
	b=IWseiZzjFna4/VV3Ev3xyUuBX47w0i2JJFXnIG+eVikftoZIPB6JU/6HLXXZpgQwiRm3cX
	UGK+XuMqcfoPfZoYCPLa0UJxb6xqU2AuEU95YOW8nh02GXsPQsFeetZJUF1iu91ssefmVG
	EZI169QE1LgH9+7Q1qfFcBy2rDZp/Fg=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-617-vYGeYflOO5K48dTCO0D1FA-1; Wed, 06 Mar 2024 17:50:28 -0500
X-MC-Unique: vYGeYflOO5K48dTCO0D1FA-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4129b426bdaso1903915e9.0
        for <kvm@vger.kernel.org>; Wed, 06 Mar 2024 14:50:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709765427; x=1710370227;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6/xvQU8rXItkULsiiSVQuN/RKusV0WKlNtmQo2+vXZs=;
        b=nnsRXD2UECHenLJp0Aj9wZbMickVLFr3zybsJact4R9KPPFaA1RndtW8qd2iCKXZcW
         SZWnfl5tMECDg+cGHGe9IfNsqYZ31M80cW9AFAi2R+oHy5XRfV0tMROIwt8Nfwewu1fQ
         owllKrxfZVJFOTY+/BV1QyZApdQXdKFv2cAN4N0pXs3p8WMSQEwKsw08HxZw4iSz1EG0
         VTLhhWv2J/jeGVVyHIGKvoBY3JjwfghwDS2MdGkQw0TXGtZobts76k68Pph5Np3nVIXh
         nWSzoftN/7mGa58nYT+jnNy1aKqdWxk1humZQlUd4RwVZekwK8Nqp6uDhE0Dd4ZfG5y4
         TlsQ==
X-Forwarded-Encrypted: i=1; AJvYcCXez7cJ/Ouq87/CJ0cXqm5mUBVN6evWDObnDLIUssp5Ff5dDcxEMJYc3bHgZjAKMSegtEM4Bb+t5MTjczg+HfdMX5/a
X-Gm-Message-State: AOJu0YwAoEru1cqtgUDWGM0PJbApdGoJ5SWGm7JXfae7zeANf3M/EEtK
	gTPzNQeoaK9EalB+aGLqE4O7Twf0ZYsA80AxrvASglThPqD7PcElim/YRPJW/cIFR0YYIJn8ni2
	x4jekDHVXjhDUvUlgfv9zzsTLY5DMM3mDn+85kvyWnMbgI/rhHA==
X-Received: by 2002:a5d:50cf:0:b0:33d:755c:6f17 with SMTP id f15-20020a5d50cf000000b0033d755c6f17mr12255936wrt.67.1709765427017;
        Wed, 06 Mar 2024 14:50:27 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEA7uXWB+3Z9PeOzXCeOgVR0ragsJl4ePwSQczk4y4RIdzayCU1MC2m6/dfsN0RVOTm2yTaYQ==
X-Received: by 2002:a5d:50cf:0:b0:33d:755c:6f17 with SMTP id f15-20020a5d50cf000000b0033d755c6f17mr12255927wrt.67.1709765426618;
        Wed, 06 Mar 2024 14:50:26 -0800 (PST)
Received: from [192.168.10.118] ([151.49.77.21])
        by smtp.googlemail.com with ESMTPSA id b29-20020a05600c4a9d00b00412f4afab4csm1203055wmp.1.2024.03.06.14.50.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Mar 2024 14:50:26 -0800 (PST)
Message-ID: <71f2c072-b25b-4980-938e-d832740cbefa@redhat.com>
Date: Wed, 6 Mar 2024 23:50:24 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] kvm: add support for guest physical bits
To: Xiaoyao Li <xiaoyao.li@intel.com>, Gerd Hoffmann <kraxel@redhat.com>,
 qemu-devel@nongnu.org
Cc: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org
References: <20240301101713.356759-1-kraxel@redhat.com>
 <20240301101713.356759-2-kraxel@redhat.com>
 <3ab64c0f-7387-4738-b78c-cf798528d5f4@intel.com>
Content-Language: en-US
From: Paolo Bonzini <pbonzini@redhat.com>
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <3ab64c0f-7387-4738-b78c-cf798528d5f4@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/4/24 02:54, Xiaoyao Li wrote:
> On 3/1/2024 6:17 PM, Gerd Hoffmann wrote:
>> query kvm for supported guest physical address bits using
>> KVM_CAP_VM_GPA_BITS.  Expose the value to the guest via cpuid
>> (leaf 0x80000008, eax, bits 16-23).
>>
>> Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
>> ---
>>   target/i386/cpu.h     | 1 +
>>   target/i386/cpu.c     | 1 +
>>   target/i386/kvm/kvm.c | 8 ++++++++
>>   3 files changed, 10 insertions(+)
>>
>> diff --git a/target/i386/cpu.h b/target/i386/cpu.h
>> index 952174bb6f52..d427218827f6 100644
>> --- a/target/i386/cpu.h
>> +++ b/target/i386/cpu.h
>> @@ -2026,6 +2026,7 @@ struct ArchCPU {
>>       /* Number of physical address bits supported */
>>       uint32_t phys_bits;
>> +    uint32_t guest_phys_bits;
>>       /* in order to simplify APIC support, we leave this pointer to the
>>          user */
>> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
>> index 2666ef380891..1a6cfc75951e 100644
>> --- a/target/i386/cpu.c
>> +++ b/target/i386/cpu.c
>> @@ -6570,6 +6570,7 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t 
>> index, uint32_t count,
>>           if (env->features[FEAT_8000_0001_EDX] & CPUID_EXT2_LM) {
>>               /* 64 bit processor */
>>                *eax |= (cpu_x86_virtual_addr_width(env) << 8);
>> +             *eax |= (cpu->guest_phys_bits << 16);
> 
> I think you misunderstand this field.
> 
> If you expose this field to guest, it's the information for nested 
> guest. i.e., the guest itself runs as a hypervisor will know its nested 
> guest can have guest_phys_bits for physical addr.

It's one possible interpretation of AMD's definition. However there's no 
processor that has different MAXPHYADDR with/without nested paging, so 
there's no real benefit in adopting that interpretation.

The only architectural case in which you have two conflicting values for 
the guest MAXPHYADDR is hCR4.LA57=0 (and likewise for Intel 4-level EPT) 
with MAXPHYADDR=52, so it's useful to treat GuestPhysAddrSize as a way 
to communicate this situation to the guest.

Paolo


