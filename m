Return-Path: <kvm+bounces-18730-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 32F0A8FABB4
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 09:18:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D60AA1F211ED
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 07:18:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E73B14039D;
	Tue,  4 Jun 2024 07:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="Dyl2wM9v"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 583FD83CB4
	for <kvm@vger.kernel.org>; Tue,  4 Jun 2024 07:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717485523; cv=none; b=WID5oAiNYS5hBYNaWs6k0p/400/Ywxi124leg7jHhWCszfIbHqnCNsEiAG/uG6TKLkwUsvpYwL1SxgHbHlsVRQIfvYyyW2ntvWe0Qx2VCGWEfnsff6rqOPWqapy2VB0sR1qPdgbBtI6UQasVBdXxogXifgUVTGpkEjP8Rufgb14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717485523; c=relaxed/simple;
	bh=F95EGVVxTZzrtH/iZbq5IMEiCEI5HtwHeAy8QgjRypA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=d6ckWeI3b/qx6U/GxJhX/+mS+IZz2V/cThbmlpKjjxIXlVq0nyePher+cMqvcMTa0KDOFyfZtWTA1itrMEiadLV/ReSWxcLYhUo/+Nboi8suBsFaR+ZFG7IL1zZ/QJ4NiHTazUg9DESj1iylxwHhySwi+B1ohJ6l7zcCCKRiqLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=Dyl2wM9v; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-6c87835b8c5so176759a12.1
        for <kvm@vger.kernel.org>; Tue, 04 Jun 2024 00:18:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1717485522; x=1718090322; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IN4YotoHrJqUzJm3B5rfjHxZ9heuhTQwYjd8l3vWTCM=;
        b=Dyl2wM9vO02Yk0ZK8NErPylRnM3dv/dvxs7yZTQ0j4jvUmSeFnr4AO6+Dkg9rl7xes
         7UcmW/O7gvsOo8ZrGH3CiavUTxmxq6QoIzTBlBT/S1KIfyqS+WpbtgLOIjiHq75/Al7J
         46QKWNDkn/+5ma+2BpeeoVtjW9IHl05JlGVhmU5gjhcZRqniJsXotcw8BKEwlumApz9g
         uX95udukO788Hw39wQGuvPapteMQjs+EGw0ItrvjxPe70qxh76PXSsV+U8tafEW7zsq5
         19LXNgtYitHN4qqk0NST5ppsBN8v/m3mBB5I2/H2Hsc/r086a28YEuR2QgaenU9koxf5
         nr4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717485522; x=1718090322;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IN4YotoHrJqUzJm3B5rfjHxZ9heuhTQwYjd8l3vWTCM=;
        b=en4McbEh0qDVsxZWh6G5N/GEIVtEhRwn1gaJ8kN52QIotZ4Yz6Zm7lYxxK0x/WHgGb
         Cm9MeQpTyHSWU6HL2WjfumZ2Ke1SRMzrgVjB5jlP1kt5C0Hu8PnOBnQzFQ/uhFNfi7LH
         RW9zWRNUuLqri2IbJU9eArKAF+nIRpi/ysvJmHEpPcMgjzTu8lcrSc91cMgklda5jOZO
         qr9VAbSJAvvuZc4nPYzEpOetRDpIUoSnl7stZf0/pOq74HoXUZ3wRY6ZZAtWvhXGAL1u
         5DgY0uIktb2wv0KD2EbudOsSAtoLlZ1phn2AljGI/DqQfRYTp2cbkseIv54HL5UI2A8O
         fEvg==
X-Forwarded-Encrypted: i=1; AJvYcCXefPMiCdl9wdAUQCcagnfyjyc66eJetqalsLF23Qy5Co2fOCFrpaaUBsnROYGaD+ZtzjQYVM5Fl8CLq478ftyI4qwz
X-Gm-Message-State: AOJu0Yxn0V+7MvBPwQNqR7j/AuU1+I7wCic9+CEioVZocP3Q58DvZdga
	cAihlpUfr3pa+6fHKh91PwuGc7AH7iNmnoruoIrAP4oSsX2lDF+U4XRTFCQ96xY=
X-Google-Smtp-Source: AGHT+IFWL8L1FbR0wZ7pGG9sTqaIq8MsqqTQdkXuTxrZK9vhL+JYsZ64DIfumPIQtJaghfe3mvA/Mg==
X-Received: by 2002:a05:6a21:33a1:b0:1b2:63c3:274c with SMTP id adf61e73a8af0-1b26f35e160mr12461974637.6.1717485521635;
        Tue, 04 Jun 2024 00:18:41 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:999:a3a0:d768:c577:5bf0:47ab? ([2a01:e0a:999:a3a0:d768:c577:5bf0:47ab])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2c1aa9dce87sm8984869a91.21.2024.06.04.00.18.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Jun 2024 00:18:40 -0700 (PDT)
Message-ID: <06d8ae43-4aad-4637-a33b-9bae91b23872@rivosinc.com>
Date: Tue, 4 Jun 2024 09:18:25 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 08/16] riscv: add ISA parsing for Zca, Zcf, Zcd and Zcb
To: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Conor Dooley <conor@kernel.org>, corbet@lwn.net,
 Paul Walmsley <paul.walmsley@sifive.com>, aou@eecs.berkeley.edu,
 robh@kernel.org, krzysztof.kozlowski+dt@linaro.org, anup@brainfault.org,
 shuah@kernel.org, atishp@atishpatra.org, linux-doc@vger.kernel.org,
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
 devicetree@vger.kernel.org, kvm@vger.kernel.org,
 kvm-riscv@lists.infradead.org, linux-kselftest@vger.kernel.org
References: <mhng-d5016935-99b6-4dc6-bbd2-ed84eb834f98@palmer-ri-x1c9a>
Content-Language: en-US
From: =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
In-Reply-To: <mhng-d5016935-99b6-4dc6-bbd2-ed84eb834f98@palmer-ri-x1c9a>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 30/05/2024 23:13, Palmer Dabbelt wrote:
> On Wed, 22 May 2024 00:20:09 PDT (-0700), cleger@rivosinc.com wrote:
>>
>>
>> On 21/05/2024 21:49, Conor Dooley wrote:
>>> On Fri, May 17, 2024 at 04:52:48PM +0200, Clément Léger wrote:
>>>
>>>> +static int riscv_ext_zca_depends(const struct riscv_isa_ext_data
>>>> *data,
>>>> +                 const unsigned long *isa_bitmap)
>>>> +{
>>>> +    return __riscv_isa_extension_available(isa_bitmap,
>>>> RISCV_ISA_EXT_ZCA) ? 0 : -EPROBE_DEFER;
>>>> +}
>>>> +static int riscv_ext_zcd_validate(const struct riscv_isa_ext_data
>>>> *data,
>>>> +                  const unsigned long *isa_bitmap)
>>>> +{
>>>> +    return __riscv_isa_extension_available(isa_bitmap,
>>>> RISCV_ISA_EXT_ZCA) &&
>>>> +           __riscv_isa_extension_available(isa_bitmap,
>>>> RISCV_ISA_EXT_d) ? 0 : -EPROBE_DEFER;
>>>> +}
>>>
>>> Could you write the logic in these out normally please? I think they'd
>>> be more understandable (particular this second one) broken down and with
>>> early return.
>>
>> Yes sure. I'll probably make the same thing for zcf_validate as well as
>> removing the #ifdef and using IS_ENABLED():
>>
>> static int riscv_ext_zcf_validate(const struct riscv_isa_ext_data *data,
>>                   const unsigned long *isa_bitmap)
>> {
>>     if (IS_ENABLED(CONFIG_64BIT))
>>         return -EINVAL;
>>
>>     if (__riscv_isa_extension_available(isa_bitmap, RISCV_ISA_EXT_ZCA) &&
>>         __riscv_isa_extension_available(isa_bitmap, RISCV_ISA_EXT_f))
>>            return 0;
>>
>>     return -EPROBE_DEFER;
>> }
> 
> Are you going to send a v6 (sorry if I missed it, I'm trying to untangle
> all these ISA parsing patch sets).

Yes, I was waiting for more feedback/Rb by it seems like I now have
everything I need. I'll send that.

Thanks,

Clément

> 
>>
>>>
>>> Otherwise,
>>> Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
>>>
>>> Cheers,
>>> Conor.

