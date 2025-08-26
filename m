Return-Path: <kvm+bounces-55759-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 46F72B36D56
	for <lists+kvm@lfdr.de>; Tue, 26 Aug 2025 17:13:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CB153189E45D
	for <lists+kvm@lfdr.de>; Tue, 26 Aug 2025 15:10:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80FB1269AE9;
	Tue, 26 Aug 2025 15:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="r85kfkqY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B86B111712
	for <kvm@vger.kernel.org>; Tue, 26 Aug 2025 15:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756220972; cv=none; b=H7zYUIVwFVJZt94w7CYttbXhfAkZ45l+ajUHbQRh0PwtL9gqmihboPTWzI/vmrtJIsuYEgPCBXR3RMDjSyqAQcb2uIrC+66ptAdjm3Wqh/SbMk46a9tXCenX+CjAYHccwEPPQBKWW9+bNmqpa7tZbdlRd2gHTRhhJgAZ0PT08WQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756220972; c=relaxed/simple;
	bh=pkqZ8rFfcX6IM0egb9cxOXqcPMJAsZBvnI3O3l6tQXI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cUbzkXxjlrmkXcJnQUaoNGq7++ArBosDIjaChmxBTVg+aWNwtHHvoqJphwSicVF5ry40AVAE0u3Ifmswr0NLN2r0K7O3hYIUFiXuzj/MZAFjlz2B5O0oGdC++vg44l8sJa9w7alzD4ecWNr54HYKX1n+X8KUTaoR10EjroHZSzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=r85kfkqY; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-3c854b644c1so1939691f8f.3
        for <kvm@vger.kernel.org>; Tue, 26 Aug 2025 08:09:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1756220969; x=1756825769; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3F7DoM0/fqRai79lV3YnsGXtEm0VO5nUf8bvvVOY8xQ=;
        b=r85kfkqY0MsRG1+wSYadKgWhwBk1nA4bKdX5dqikXfSbWrBAtG+5eel8Oazu87NEth
         mrnR+7Yrcfksgu0hhRABxQAil3SvgeqQANVFvLT7BW/tSzuxal3eyoaGKtuIxYKWmtdJ
         zr2t16l59Dyfm2C/7IqaZNL+ag4OpltDp+CmioLSV5J+PShDvUu9r66axWgPWTin94UZ
         VGbErBBdQ7GdzPgsw98DsnkC1HTLpvirmvADbLPP1GEBn4/8SRQ6wEziowgBwe32kD33
         7iR5undGbnVamTvrIsrm1TcYruvUTub6JC/Vjz5+0v3onAvLYQyXZsgmjVJR2GDfixoe
         +G9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756220969; x=1756825769;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3F7DoM0/fqRai79lV3YnsGXtEm0VO5nUf8bvvVOY8xQ=;
        b=mbsO5p0HkdBbKcjQ2P5w0CNVWHFDCuItATBBxNrgC4e0Bq3zNUUVpQMJ+tKbNXWkjz
         RIFxb/HtV78ViMvBq6euwUURP1eupy7m4UI3Y943QFbWSA4g8RAEGkZffY+0zEWp0UfM
         FgT18UqEQB+zGkiWTj4LKhxNrdXbAP861RrzNPMTyDNsnwuO5DbAZTLgaqQffWIwd2Fo
         scBAncetaaWJrBewMNDS12BmRMWK1lBHS7NUhj3bCCFbCjjIW/W5/W7wZONJG/gDlWqn
         3F0CaqOXX6/FxZoHK0LtPLQWaePR/mfNBp+/2nmjxtBVWxfum6L9ZxGeTzKz7lL3pwtR
         yIPg==
X-Forwarded-Encrypted: i=1; AJvYcCVH/A6hurKgt7Kbt0Vo0sv26ylYrQw6fVngaK1wjW8PJmkMXfr9XE3FUr86x73BVpMTiug=@vger.kernel.org
X-Gm-Message-State: AOJu0YzJd8ExoDVqlhWvd2qv5Su8KTkpzt1Jec7pvl6cCNtckMOrqMvY
	qBjUevS+AQOeqCLWhlGz6mTOPwffin226qJkmq+muRpMaLyvZXAKNmKLqUjRmKYHKaU=
X-Gm-Gg: ASbGnct5WYW9gmcHhMQ++py6kifbXnYcsV6EFY2A7mn90L9Jg+ueo6pLF0K6wCDosgn
	D2PDbL/ofKNW9mEjsGKG2oEEo5JpI5yudO+/IVxnDiLc09M7T/MEB4Xtx4a2yNqJfBBml+IH9o1
	JsvlIPVPtLLlvQnw4O2uZhf5NfP+F2smpf2XY1jF/O+iVCwgKf/4NArlayMMse2YeaX8TcVpHlo
	7JY3Vn95XjU+7zG4rkPu6fEEZ32Ln532mpt3tfMT1Q7XBDYID18SLssVAuCNg5GCDLlYDxLNWPW
	DRtO7FNEDGB38oAZfpzubbJlcJQfsUAtuFwsJmFP3YHM51OthOy8LMB/ONP7Fk2UrkfR+9yBKvE
	GQRQdifi3YEyMpsn+D27+HT6wuzQqICeGr/m4+d/cMewtsWNbgWjTRWvh18rOjCi3RA==
X-Google-Smtp-Source: AGHT+IGYKR71Mtn2F/27lVlxolmy51OwGQw49l2ku8pGm1iAjfhN/g7yA5mkqA2E7d9Kx4XtY1GiDA==
X-Received: by 2002:a05:6000:1881:b0:3c9:24f5:470c with SMTP id ffacd0b85a97d-3c924f54bfemr6994519f8f.42.1756220968895;
        Tue, 26 Aug 2025 08:09:28 -0700 (PDT)
Received: from [192.168.69.208] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3c70f14372fsm16510243f8f.28.2025.08.26.08.09.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Aug 2025 08:09:28 -0700 (PDT)
Message-ID: <d109215c-2b3c-46e4-9fb2-49fe70076a5c@linaro.org>
Date: Tue, 26 Aug 2025 17:09:27 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] kvm/kvm-all: make kvm_park/unpark_vcpu local to
 kvm-all.c
To: Igor Mammedov <imammedo@redhat.com>, Ani Sinha <anisinha@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, richard.henderson@linaro.org,
 kvm@vger.kernel.org, qemu-devel@nongnu.org
References: <20250815065445.8978-1-anisinha@redhat.com>
 <20250826132322.7571b918@fedora>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20250826132322.7571b918@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 26/8/25 13:23, Igor Mammedov wrote:
> On Fri, 15 Aug 2025 12:24:45 +0530
> Ani Sinha <anisinha@redhat.com> wrote:
> 
>> kvm_park_vcpu() and kvm_unpark_vcpu() is only used in kvm-all.c. Declare it
>> static, remove it from common header file and make it local to kvm-all.c
>>
>> Signed-off-by: Ani Sinha <anisinha@redhat.com>
> 
> Reviewed-by: Ani Sinha <anisinha@redhat.com>

Do you mean Igor Mammedov <imammedo@redhat.com>?

> 
>> ---
>>   accel/kvm/kvm-all.c  |  4 ++--
>>   include/system/kvm.h | 17 -----------------
>>   2 files changed, 2 insertions(+), 19 deletions(-)
>>
>> changelog:
>> unexport  kvm_unpark_vcpu() as well and remove unnecessary forward
>> declarations.
>>
>> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
>> index 890d5ea9f8..f36dfe3349 100644
>> --- a/accel/kvm/kvm-all.c
>> +++ b/accel/kvm/kvm-all.c
>> @@ -414,7 +414,7 @@ err:
>>       return ret;
>>   }
>>   
>> -void kvm_park_vcpu(CPUState *cpu)
>> +static void kvm_park_vcpu(CPUState *cpu)
>>   {
>>       struct KVMParkedVcpu *vcpu;
>>   
>> @@ -426,7 +426,7 @@ void kvm_park_vcpu(CPUState *cpu)
>>       QLIST_INSERT_HEAD(&kvm_state->kvm_parked_vcpus, vcpu, node);
>>   }
>>   
>> -int kvm_unpark_vcpu(KVMState *s, unsigned long vcpu_id)
>> +static int kvm_unpark_vcpu(KVMState *s, unsigned long vcpu_id)
>>   {
>>       struct KVMParkedVcpu *cpu;
>>       int kvm_fd = -ENOENT;
>> diff --git a/include/system/kvm.h b/include/system/kvm.h
>> index 3c7d314736..4fc09e3891 100644
>> --- a/include/system/kvm.h
>> +++ b/include/system/kvm.h
>> @@ -317,23 +317,6 @@ int kvm_create_device(KVMState *s, uint64_t type, bool test);
>>    */
>>   bool kvm_device_supported(int vmfd, uint64_t type);
>>   
>> -/**
>> - * kvm_park_vcpu - Park QEMU KVM vCPU context
>> - * @cpu: QOM CPUState object for which QEMU KVM vCPU context has to be parked.
>> - *
>> - * @returns: none
>> - */
>> -void kvm_park_vcpu(CPUState *cpu);
>> -
>> -/**
>> - * kvm_unpark_vcpu - unpark QEMU KVM vCPU context
>> - * @s: KVM State
>> - * @vcpu_id: Architecture vCPU ID of the parked vCPU
>> - *
>> - * @returns: KVM fd
>> - */
>> -int kvm_unpark_vcpu(KVMState *s, unsigned long vcpu_id);
>> -
>>   /**
>>    * kvm_create_and_park_vcpu - Create and park a KVM vCPU
>>    * @cpu: QOM CPUState object for which KVM vCPU has to be created and parked.
> 
> 


