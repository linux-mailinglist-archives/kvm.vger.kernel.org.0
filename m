Return-Path: <kvm+bounces-63117-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id C74E6C5AAC8
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 00:46:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 53BD44E8932
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 23:40:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FA6832ABE1;
	Thu, 13 Nov 2025 23:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gBimbCcx";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Uebzd18m"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 228212EDD50
	for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 23:40:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763077242; cv=none; b=Fx+//px5ChLLU3yBLB9vC7vMJi6Ot65NWIadKmtsPL8INfhVCWp5NK+VnykZprQlPoomddPZr6ElrgYci63dBdYsoR4PzC+rD6JTqwbpDVRkuYGXcQwbDWnJ2gdiKL7rIqScI1CTJv6eZfU0DfmthBEXMf1zZmAFd4xuavEshWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763077242; c=relaxed/simple;
	bh=XEIGsm2hQadLqAcORmGSqQRSHEjC9+jB6gFkA6m+0+I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Zz9GQT9ekNysZoJ0Tqi8GNXi28kbrQbVGkDDHtB95Y8q8AgsfwBKk7ecrqvbEErq1AcQH8rU6w7am5gys5oD7P0t2WhTCaEN8/p1PsHGEMtsmqcAiwwfgHmGelvxbkTEMAKPJOQiFETYnWA7JqQlxsWLkZdgsoIaQjxeI8AGkGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gBimbCcx; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Uebzd18m; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763077240;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=P1zJiwXG3r+F4Xk8RD3Q4DRMyZH5mfciaHfh3QHxRYY=;
	b=gBimbCcxt6UPxLzvRiTv6YHgG3hvvy7HQDm6KJprmGVEUcuFOslxw8Hdd2ysytayZRkuZc
	M8qgSF/Omsz49pLE/Tiz4l9im17/hQstKDgl9J+rhlIMyIFA4GmFSIKoj1fGCBAZJ0woC6
	nQDY8zm+33chIXCe3MupGQc7XsY4REc=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-85-8lxR2btZPDOA_efcoz8I9g-1; Thu, 13 Nov 2025 18:40:36 -0500
X-MC-Unique: 8lxR2btZPDOA_efcoz8I9g-1
X-Mimecast-MFC-AGG-ID: 8lxR2btZPDOA_efcoz8I9g_1763077235
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-42b2ffe9335so2096050f8f.1
        for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 15:40:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1763077235; x=1763682035; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=P1zJiwXG3r+F4Xk8RD3Q4DRMyZH5mfciaHfh3QHxRYY=;
        b=Uebzd18mt/kF5bz5/pyts6BWGNJtqXgUxBzuCcV5wniDJlbAz7bNZ1PQxzirE8LZ0g
         XUJ5JWj6rPjtTBHOucxM+Ckf8d79DlyegC+e8hLBZ37v69eglZEa/AfsFnhBsloTsv0W
         xgCf0HLER1bGB8p0u6FZiSkjrRHSqhpU8edadVSaT3K1cmIDe0lzbfSyOCSBd+fxajRy
         9KVCR0JdITEdoyExWx4zx5K+k08oXJbBTbFTU2kWXBB+jK+VBoayETx+wQmTvftDGMls
         vs3F9pYcdSXNKPyhstvqNt1eTt/n4vXrntuYf+NtQcwR6OWaB/0hz2rauvPAUbt8I1X9
         ghvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763077235; x=1763682035;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P1zJiwXG3r+F4Xk8RD3Q4DRMyZH5mfciaHfh3QHxRYY=;
        b=wxfvwKug2hw6SMtjFx5bpxnK6/+AXq7QQ8nt066d4Y+mgo0aDqFvGkg6102xChGQO8
         VKamBDfZSqH++EubEMcY0+uyfGnvcEf/yLzim5E+1mkTDfj7w+dCky5xHXq24aILZK8r
         GhSbCSEixjiE3rGe+dez3nDNy8kzlpLFuLqIuq26oZ/8aRKR3UDLzVFTaVsbhY+v8zRr
         BRk1p+0WcOSMYZX9suXLBwF9hhJffeNFjvzbThrYPLbHVQpkba7DgwLZrx3OQIrraih+
         RWAeXQ7MtVDvhPX15uORqHhEHv1XjHZI/7H0iqtl1Gvkk1fSK4L6k112JolRxGwXp/Gc
         UCkw==
X-Forwarded-Encrypted: i=1; AJvYcCXX7eiJl48BavYF9oHfEMT883AUtiJddsLkUrBJRBGEbB0K/y9ZSbuQrVYX9yhE0AUqUhM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwWJLvTYfditXLPgWtCMhzLzZDGd0wrTU1eB93B+cutxPjBop2p
	yBRjzf7O6Pzsp7rew/K0+S1f7oE3hVmY4MqDLIhh/VOSmOjiarZbohro7QJt3KfV3ZAbeIy5paX
	jvqG5xaUMaMt2k7rbC/pNjBi4HYZ2cxte7GUT+SEpGDS29TYYNbBLVA==
X-Gm-Gg: ASbGncuVvENCcGPmOZ2xhUWC1Ofh2i38YsPxyVZgHqqpkd3KsQb0MchTl7WfIWFgh0x
	tUFQLH16YRwmaRPyPiUmqYqDbGvSBp/zYjky21WTpD0hMzEzA8BNYMgpYJx5Qnr2PLp6YbNMsVK
	bgOd1JmJyleVbciPsgG2J9KlJddfB3dm2PY4a2NnH6MjXrldHRcMO2DDgZJD/YE6e9BsEqRBDUN
	ElNk4sLCdey2Vpf9BphMDuAXggO4CmrUg28kAIVUVsIEILJ2KzIwndfHZnfzkm23eIRPOit34xf
	LoayVqM35e/JPmNOvhILGvz8WtOk8g9DEzL232bNRGy+Oc1ZR7GsSpHoayoU0FUmcrz5OpCQVbt
	3HqOcyo9rfaGwT19OD3fzSBBnJAXSDc54NaROLOFUE01EYb9sj2d7yF4BJ+w4JXZ2EPOjakXvac
	y+MO0r
X-Received: by 2002:a05:6000:2310:b0:42b:3131:5435 with SMTP id ffacd0b85a97d-42b5933e378mr837518f8f.2.1763077235476;
        Thu, 13 Nov 2025 15:40:35 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEBhm6MjYKjESkEVy3RbAenblPlVRGdqikxyiHXGWgzTCDClJO2On4vBU12QGvVu+C6F/ucvw==
X-Received: by 2002:a05:6000:2310:b0:42b:3131:5435 with SMTP id ffacd0b85a97d-42b5933e378mr837507f8f.2.1763077235095;
        Thu, 13 Nov 2025 15:40:35 -0800 (PST)
Received: from [192.168.10.48] ([176.206.119.13])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-42b53f0b62dsm6546075f8f.24.2025.11.13.15.40.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Nov 2025 15:40:34 -0800 (PST)
Message-ID: <670cf030-2ae7-4dd6-9324-bbfb7815e2e5@redhat.com>
Date: Fri, 14 Nov 2025 00:40:32 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v1 08/20] KVM: VMX: Support extended register index in
 exit handling
To: "Chang S. Bae" <chang.seok.bae@intel.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: seanjc@google.com, chao.gao@intel.com, zhao1.liu@intel.com
References: <20251110180131.28264-1-chang.seok.bae@intel.com>
 <20251110180131.28264-9-chang.seok.bae@intel.com>
 <7bb14722-c036-4835-8ed9-046b4e67909e@redhat.com>
 <b27f760c-e17a-4cbc-b9e7-fefff07d16d7@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <b27f760c-e17a-4cbc-b9e7-fefff07d16d7@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/14/25 00:22, Chang S. Bae wrote:
>>> @@ -415,7 +420,10 @@ static __always_inline unsigned long 
>>> vmx_get_exit_qual(struct kvm_vcpu *vcpu)
>>>   static inline int vmx_get_exit_qual_gpr(struct kvm_vcpu *vcpu)
>>>   {
>>> -    return (vmx_get_exit_qual(vcpu) >> 8) & 0xf;
>>> +    if (vmx_egpr_enabled(vcpu))
>>> +        return (vmx_get_exit_qual(vcpu) >> 8) & 0x1f;
>>> +    else
>>> +        return (vmx_get_exit_qual(vcpu) >> 8) & 0xf;
>>
>> Can this likewise mask against 0x1f, unconditionally?
> 
> It looks like the behavior of that previously-undefined bit is not
> guaranteed -- there's no architectural promise that the bit will always
> read as zero. So in this case, I think it's still safer to rely on the
> enumeration.
The manual says "VM Exit qualification is extended in-place"... This 
suggests that the wording of the SDM, "Not currently defined", really 
means "currently zero, but may not be *in the future*".

It is indeed safer, but it's a bit sad too. :)  Let's at least use 
either static_cpu_has() or a global __read_mostly variable, instead of a 
more expensive test using the vcpu.

Paolo


