Return-Path: <kvm+bounces-19708-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 67C26909299
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 20:53:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 80D9F1C23879
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 18:53:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A192919FA96;
	Fri, 14 Jun 2024 18:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="b0CKSyBc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCD491A2FAB
	for <kvm@vger.kernel.org>; Fri, 14 Jun 2024 18:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718391202; cv=none; b=UfPlgwhcr81I4YoyojqpCGGLrjmtp3QiIBSUdtbSqH2zrcP0dt69gExGfBI2s/ArRKIZQ6npIWSxgm0r9Sfp00HkuQzKaTGj6bAocFBnsoIwHwi5B1Oe/Vvz9eFjk6LcrjewUb4nUfjZl9OH7M4OARPAdUS89Ha1bmRrzyiZyR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718391202; c=relaxed/simple;
	bh=1FvBfjrMbKVDdTiq5I7NMTQPujS2nIVHIT1SZLzKrAg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GturGniwXlnfqoGBc+/cC4+H1EvCZYSLZVq4DLUysXoXtXcd0g8q+NXB/Xe02qNu25Qrmhc2PtNAhy6fagfaBZU/VN2Eq1Ou3ZniZhPyggsNRCrE0ue4vH1DGPwf9oSF99X9+bu43tdkD5T9RzjAEMDIWtFsod3lRmuCeR1hGAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=b0CKSyBc; arc=none smtp.client-ip=209.85.208.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-2eaae2a6dc1so46092551fa.0
        for <kvm@vger.kernel.org>; Fri, 14 Jun 2024 11:53:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1718391199; x=1718995999; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=lzLH5w7+nQtEk7U++EhMP9CCUyo8/fOpXcdB6SCEdDk=;
        b=b0CKSyBcbkebCPLnJG4QvSIo3dU2iIjNbpW6TMVBvgJdMF2xz2EBXh6t1sW/h8hoer
         6rVAy3/pJIFRcHfKMtQlkLH93cui260Gq5HmFKkR4eBv3NcM2v1nRZ5rbZIy32jcsWIH
         9GLJlbL8xxS8A3I7Ali5hZJxfZBFosbdUpxs7ISiHCJKpDs6NPGLmVbeNtmPjvMERP4L
         mORCfK+pTw9M+sPhsG8Ubg0a62GVAdpIP8jVHwc5DFZ3G6TfG+mo0uQ1iEL7vTwF0S4D
         pUA4XXzQ7DaZvGa45DJMHkOILN2vKUl6KVF5SJqZhVVWf3VA7MQmnSCClDO/ZhrAxutM
         1ADA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718391199; x=1718995999;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lzLH5w7+nQtEk7U++EhMP9CCUyo8/fOpXcdB6SCEdDk=;
        b=U23NifPRnxS/ImwEJ5XMjdeZ6pLqI6BDi+p63WJb3r5sN1ExGc7PDENYGJxV75t6xX
         7IoHH9UrZIliSyLXAoxfjT3n4EnOJOrNWVXzW38qfnq8FS6NV7sNnvUB3ahyctID+D0S
         D+CS0cZpdy40wfTtAgNWGAhLOufBBKVLM0nTCdLnhSKMylxpA9o+N81gWIR3VoGHzt5q
         7iyJsSrjyWCPg2ohHziBif0dJIkVJXJeBWtt1NCGYGm+2ko7MVfLzjfWgIn/CV2miTgu
         I2AaZevavITZ+Dneo0Lz6Gp220JgHh2pLr+RTfLDbqN/L0c8GAlrr0oZI5VlO532O2SL
         IqoQ==
X-Forwarded-Encrypted: i=1; AJvYcCUZmT0ElHJKXKhbSsDFmDoZUofKOTX67NsrvcSZbbUTcgpQkRK3MLLgAX8BKUu78SV9BJAU2nK16bwHxrNOMNsuPnbC
X-Gm-Message-State: AOJu0YwcCVt2Zu0xeQDNivmbfg9amPkj67wp/O7Ks1QHkferupuJffNP
	Okt9g8lI2yQkcmClyZcGkireNeRvuWSYGFEep3MtyeOp5hKyLsexET2LVZvc0WqxxHEy00RFEaq
	L
X-Google-Smtp-Source: AGHT+IGzn3PUa7KdFYsZqfu7krfYElusp5m/fwIYb0ENb2LyLjJuHS6vaJ4iE6XJFdJBHQgpPiq7EA==
X-Received: by 2002:a2e:9085:0:b0:2eb:fe6a:7b8e with SMTP id 38308e7fff4ca-2ec0e4826f7mr26979051fa.18.1718391198794;
        Fri, 14 Jun 2024 11:53:18 -0700 (PDT)
Received: from ?IPV6:2003:f6:af33:2a00:214d:f270:25e5:a49? (p200300f6af332a00214df27025e50a49.dip0.t-ipconnect.de. [2003:f6:af33:2a00:214d:f270:25e5:a49])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a6f56f42ddfsm213390266b.171.2024.06.14.11.53.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Jun 2024 11:53:18 -0700 (PDT)
Message-ID: <e45bffb8-d67c-4f95-a2ea-4097d03348f3@grsecurity.net>
Date: Fri, 14 Jun 2024 20:53:17 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/4] KVM: Limit check IDs for KVM_SET_BOOT_CPU_ID
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
References: <20240612215415.3450952-1-minipli@grsecurity.net>
 <20240612215415.3450952-4-minipli@grsecurity.net>
 <ZmxxZo0Y-UBb9Ztq@google.com>
Content-Language: en-US, de-DE
From: Mathias Krause <minipli@grsecurity.net>
Autocrypt: addr=minipli@grsecurity.net; keydata=
 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
 RzDVkdgPJkL/NFTKZHo5foFXNi89kA==
In-Reply-To: <ZmxxZo0Y-UBb9Ztq@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 14.06.24 18:35, Sean Christopherson wrote:
> On Wed, Jun 12, 2024, Mathias Krause wrote:
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 082ac6d95a3a..8bc7b8b2dfc5 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -7220,10 +7220,16 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
>>  	case KVM_SET_BOOT_CPU_ID:
>>  		r = 0;
>>  		mutex_lock(&kvm->lock);
>> -		if (kvm->created_vcpus)
>> +		if (kvm->created_vcpus) {
>>  			r = -EBUSY;
>> -		else
>> -			kvm->arch.bsp_vcpu_id = arg;
>> +			goto set_boot_cpu_id_out;
>> +		}
>> +		if (arg > KVM_MAX_VCPU_IDS) {
>> +			r = -EINVAL;
>> +			goto set_boot_cpu_id_out;
>> +		}
>> +		kvm->arch.bsp_vcpu_id = arg;
>> +set_boot_cpu_id_out:
> 
> Any reason not to check kvm->arch.max_vcpu_ids?  It's not super pretty, but it's
> also not super hard.

I explicitly excluded it as there's no strict requirement for calling
KVM_ENABLE_CAP(KVM_CAP_MAX_VCPU_ID) before KVM_SET_BOOT_CPU_ID, so
kvm->arch.max_vcpu_ids would not yet be set. But yeah, checking if it
was already set prior to narrowing the compare to it is a neat way to
solve that. Good idea!

> And rather than use gotos, this can be done with if-elif-else, e.g. with the
> below delta get to:
> 
> 		r = 0;
> 		mutex_lock(&kvm->lock);
> 		if (kvm->created_vcpus)
> 			r = -EBUSY;
> 		else if (arg > KVM_MAX_VCPU_IDS ||
> 			 (kvm->arch.max_vcpu_ids && arg > kvm->arch.max_vcpu_ids))
> 			r = -EINVAL;
> 		else
> 			kvm->arch.bsp_vcpu_id = arg;
> 		mutex_unlock(&kvm->lock);
> 		break;

Heh, I had the if-else ladder before but went for the goto version after
looking around, attempting not to deviate from the "style" used for all
the other cases . :|

> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 6e6f3d31cff0..994aa281b07d 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -6707,7 +6707,9 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>                         break;
>  
>                 mutex_lock(&kvm->lock);
> -               if (kvm->arch.max_vcpu_ids == cap->args[0]) {
> +               if (kvm->arch.bsp_vcpu_id > cap->args[0]) {
> +                       ;
> +               } else if (kvm->arch.max_vcpu_ids == cap->args[0]) {
>                         r = 0;
>                 } else if (!kvm->arch.max_vcpu_ids) {
>                         kvm->arch.max_vcpu_ids = cap->args[0];

This is a separate fix, imho -- not allowing to set
kvm->arch.max_vcpu_ids to a value that would exclude
kvm->arch.bsp_vcpu_id. So I'll put that a separate commit.

However, this still doesn't prevent creating VMs that have no BSP as the
actual vCPU ID assignment only happens later, when vCPUs are created.

But, I guess, that's no real issue. If userland insists on not having a
BSP, so be it.

> @@ -7226,16 +7228,13 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
>         case KVM_SET_BOOT_CPU_ID:
>                 r = 0;
>                 mutex_lock(&kvm->lock);
> -               if (kvm->created_vcpus) {
> +               if (kvm->created_vcpus)
>                         r = -EBUSY;
> -                       goto set_boot_cpu_id_out;
> -               }
> -               if (arg > KVM_MAX_VCPU_IDS) {
> +               else if (arg > KVM_MAX_VCPU_IDS ||
> +                        (kvm->arch.max_vcpu_ids && arg > kvm->arch.max_vcpu_ids))
>                         r = -EINVAL;
> -                       goto set_boot_cpu_id_out;
> -               }
> -               kvm->arch.bsp_vcpu_id = arg;
> -set_boot_cpu_id_out:
> +               else
> +                       kvm->arch.bsp_vcpu_id = arg;
>                 mutex_unlock(&kvm->lock);
>                 break;
>  #ifdef CONFIG_KVM_XEN

Thanks, looking good!

Will prepare a v3.

Mathias

