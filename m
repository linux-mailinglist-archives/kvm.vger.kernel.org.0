Return-Path: <kvm+bounces-20569-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 93564918814
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2024 19:00:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 132B81F244FD
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2024 17:00:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 098C318FDB1;
	Wed, 26 Jun 2024 17:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="uYz11j4x"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FAAD13BC02
	for <kvm@vger.kernel.org>; Wed, 26 Jun 2024 17:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719421227; cv=none; b=Bw5KeX5h4N25dUD1/vJ+fj/VrFQmCPuz37Hw9aExChzbLmpY1LlFIVV9Gz4zIiNjVTj4Q6yTla51fQ6+Wij7wOz5RK0pDXgsEmpMR2htemiC5q9XkHZvi29jdZUbaYlwxrcPTeUGBaaG2KyCkSw0lqQjA0VMx2SaOoadFXbQQG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719421227; c=relaxed/simple;
	bh=qdX85xonqFgdnC5XdjHlts6a4TQihmAd8zEkekmA8Ug=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=esjq4K2/qh4ty5oAEq1ipXzinb3rY16c4lBkvKlVHvUnzfrCP6qrFcoXX0Z5w42qcLM2NZDsON9kz0UwonyMb7lZ5CnzGBv4OYzixtY0iI/ZpNkhtpBmb6JybdKuwYvMUCO0HL7e5kIXUJa1VQ5+bP7dUe8GfWkwgKwTpN9gO1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=uYz11j4x; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-361785bfa71so5272206f8f.2
        for <kvm@vger.kernel.org>; Wed, 26 Jun 2024 10:00:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1719421223; x=1720026023; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=x6yy8q2jpoHXlXg85ZR/IswxE+kPuXBhTZOVGyO+mIA=;
        b=uYz11j4xbxGXTcld95cJ1uvxYKvHwdrfzMDc1+XiwIPBeJ6xmZcfJ8TVjHTIJq7NMm
         IaShDBWaLJiulr636kktbw8N3mVL4A6YyRDqrRUxvHIAqVNRFuZthMFxJGtvlY5mclYt
         R0oWiP1rPI3E2/DrcPD4xJrJX48hIZ3T/IzTeCv27EZXqtzkLCZMPq8L+83svdw00DsD
         A9/0l/uVMfcZBdBAwFoZHsJOu4f9ozriu73xv04loB0b4gR55kp7yGjk2e1JCvWSyDZE
         76WP8RFuvUDLGwU1J//B2HBV/E9BOyUGCgPiYnqYDEc90ejp27td1nUGY0YFMWYwpmIF
         BMRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719421223; x=1720026023;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=x6yy8q2jpoHXlXg85ZR/IswxE+kPuXBhTZOVGyO+mIA=;
        b=t6do0c8crv+N9JqsMjgunNajg9oAlluHT3f20SIAjeJCIY1hY8QuLZvGq97rgw58wH
         EJe2cUchqzt6Sc36dBhEt30pu/S/7f1zFHn4dXhTBbEPyDm6uHU/PNHI6h9v1yW79E2p
         mHIG1kPeikYcln3WBp1EUMg6M7fFmJnOGM503h/ZeP+FRSCY+ekrz7rWBU4A4yZPgf37
         QA+buRZZt8q/+iEos68bIVFJyrZEsHuSMnsCrKSHtVEwDWCf6mEdB2Yv9l7lhwu8G2Wj
         UWBG2IM6o4YQK6Vp3bdjbY+t9QMXp5T4DZ0MjnTtLPf3oMG/Rag2+NSFZC8krLT+63P/
         gI6Q==
X-Forwarded-Encrypted: i=1; AJvYcCUEAa7HCa0B/HuvtUYgk/XoFfMQgj4K8lhnxOQOnRZrcBvHOTHb4GPQaawLSpUbaYujwW5AwNPljyCmmU9acVyeGzss
X-Gm-Message-State: AOJu0Yzaao/2nffvL5pl6mWSrl+SZD6XoHuspx5TxNdWZilfKxS+AFxH
	fTSpOcJUUQlCcBf/wJg5wURr51bu0aQfSQuWfs9apQAPPw7SkIsMY2C5Ej+Se3GVhMlJmXW6h19
	l
X-Google-Smtp-Source: AGHT+IHekq5X45p/uxBeKBBUxxp+qRbVObCTDUz7b0tXridZSYxP52Ve467QzaCptI5BxhMcyTmvdw==
X-Received: by 2002:a5d:4712:0:b0:35f:1128:2514 with SMTP id ffacd0b85a97d-366e7a0fc96mr6581641f8f.32.1719421222777;
        Wed, 26 Jun 2024 10:00:22 -0700 (PDT)
Received: from [192.168.69.100] ([176.187.212.234])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3663a8c8b27sm16258033f8f.104.2024.06.26.10.00.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Jun 2024 10:00:22 -0700 (PDT)
Message-ID: <2756549c-867d-43c0-a332-beac708da443@linaro.org>
Date: Wed, 26 Jun 2024 19:00:20 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] target/i386: restrict SEV to 64 bit host builds
To: =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
Cc: qemu-devel@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
 Marcelo Tosatti <mtosatti@redhat.com>,
 "open list:X86 KVM CPUs" <kvm@vger.kernel.org>
References: <20240626140307.1026816-1-alex.bennee@linaro.org>
 <ZnwjtOxQy1iiRoFh@redhat.com>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <ZnwjtOxQy1iiRoFh@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 26/6/24 16:20, Daniel P. Berrangé wrote:
> On Wed, Jun 26, 2024 at 03:03:07PM +0100, Alex Bennée wrote:
>> Re-enabling the 32 bit host build on i686 showed the recently merged
>> SEV code doesn't take enough care over its types. While the format
>> strings could use more portable types there isn't much we can do about
>> casting uint64_t into a pointer. The easiest solution seems to be just
>> to disable SEV for a 32 bit build. It's highly unlikely anyone would
>> want this functionality anyway.
>>
>> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
>> ---
>>   target/i386/sev.h       | 2 +-
>>   target/i386/meson.build | 4 ++--
>>   2 files changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/target/i386/sev.h b/target/i386/sev.h
>> index 858005a119..b0cb9dd7ed 100644
>> --- a/target/i386/sev.h
>> +++ b/target/i386/sev.h
>> @@ -45,7 +45,7 @@ typedef struct SevKernelLoaderContext {
>>       size_t cmdline_size;
>>   } SevKernelLoaderContext;
>>   
>> -#ifdef CONFIG_SEV
>> +#if defined(CONFIG_SEV) && defined(HOST_X86_64)
>>   bool sev_enabled(void);
>>   bool sev_es_enabled(void);
>>   bool sev_snp_enabled(void);
>> diff --git a/target/i386/meson.build b/target/i386/meson.build
>> index 075117989b..d2a008926c 100644
>> --- a/target/i386/meson.build
>> +++ b/target/i386/meson.build
>> @@ -6,7 +6,7 @@ i386_ss.add(files(
>>     'xsave_helper.c',
>>     'cpu-dump.c',
>>   ))
>> -i386_ss.add(when: 'CONFIG_SEV', if_true: files('host-cpu.c', 'confidential-guest.c'))
>> +i386_ss.add(when: ['CONFIG_SEV', 'HOST_X86_64'], if_true: files('host-cpu.c', 'confidential-guest.c'))
>>   
>>   # x86 cpu type
>>   i386_ss.add(when: 'CONFIG_KVM', if_true: files('host-cpu.c'))
>> @@ -21,7 +21,7 @@ i386_system_ss.add(files(
>>     'cpu-apic.c',
>>     'cpu-sysemu.c',
>>   ))
>> -i386_system_ss.add(when: 'CONFIG_SEV', if_true: files('sev.c'), if_false: files('sev-sysemu-stub.c'))
>> +i386_system_ss.add(when: ['CONFIG_SEV', 'HOST_X86_64'], if_true: files('sev.c'), if_false: files('sev-sysemu-stub.c'))
>>   
>>   i386_user_ss = ss.source_set()
> 
> Instead of changing each usage of CONFIG_SEV, is it better to
> prevent it getting enabled in the first place ?
> 
> eg. move
> 
>    #CONFIG_SEV=n
> 
> From
> 
>    configs/devices/i386-softmmu/default.mak
> 
> to
> 
>    configs/devices/x86_64-softmmu/default.mak
> 
> And then also change
> 
>    hw/i386/Kconfig
> 
> to say
> 
>    config SEV
>        bool
>        select X86_FW_OVMF
>        depends on KVM && X86_64

Both are *targets*, IIUC we want to disable on *hosts*.


