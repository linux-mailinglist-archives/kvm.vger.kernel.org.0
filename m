Return-Path: <kvm+bounces-41858-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B129A6E55B
	for <lists+kvm@lfdr.de>; Mon, 24 Mar 2025 22:16:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4BC26188EC4E
	for <lists+kvm@lfdr.de>; Mon, 24 Mar 2025 21:13:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88A861E8346;
	Mon, 24 Mar 2025 21:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="dBXc7jeP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 003E31DE8A3
	for <kvm@vger.kernel.org>; Mon, 24 Mar 2025 21:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742850721; cv=none; b=dVH6p4QrAr3imf2O8KePTaXgat7kAM+wWDE1MGyU6bF098+ckloGH9GWJ9s8To0RX1h1unjJ9kKh8OoE4iQEIxCTaVHahUXa8INqSNSypfDUJDb/qFbc7LjSLSk8O5nPp753PU5yqj5KAbCnMR7dkHKwg/u38LF9tKZiKCUBdSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742850721; c=relaxed/simple;
	bh=TuwJ3eaL0pDi2Dz/wBm40uABFpqQRakxIYQxazoNYGs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=s/HT7z+ut0IGBMtJeJP26zJ5r+TwBK7fMbAzJZOjUzpQnD1zAbmvDeb8RaoNoLGJ8/i+J0CLI4VH/7nbtRSqsI19BgLOpKCQ/sxJDIifceSWv1lkjlVuzxHx8tu4buivctDfMmVk/uFCz7+uMD+FL3xKIzOdZiRhnuRq8lhYgPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=dBXc7jeP; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2260c91576aso82575315ad.3
        for <kvm@vger.kernel.org>; Mon, 24 Mar 2025 14:11:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742850719; x=1743455519; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0QyIWcLuKy6ayyJnu5/t5A5DBKW0SwtVnX/A9OP+mX0=;
        b=dBXc7jePINvnrn80sihPGhbCt/j+rRVBo6XiJgW6QEis3EeYlsSEI93Kbp3CKTBssF
         CO5+rg/Cvtl2mXmgE63FbJo/xPiXpLZyKvUczWocU7coJR3v5722Z4JRx1ylKDkzUGQJ
         y1IUJmwYf6TdemQICHK3CjyKRDMpQLnci7p9De4FasyyUKzihQUu5ENn/rf2Q/KkeTD3
         ObfzAtqlp69pedby+0o4TuoPNQNPf6Z6UHQvWD12rhsUiSGIGuPwtNBG/O9GIefJ08FY
         nfdsovSTkIR7KLsPtAoiT2ogmTw/JDQ9X9BEj2rVYdpo1ILuyDlDsQ4m2h32bUab9WRv
         bExA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742850719; x=1743455519;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0QyIWcLuKy6ayyJnu5/t5A5DBKW0SwtVnX/A9OP+mX0=;
        b=ph4Ozk6NXRaAyRDjzipmFPlM7dabGpjw5BKJXUkqh5C0EwuqLnV+S7zIoSrLCJLZ4C
         ++RdSNdC0D6LqKQh/0EusmAkQy5qBzSpmhxreKY3K0m4s2apO7lJJs6lb6M3XbqChk+/
         3mnsLzCumRc38rixZhGu6RF+IA2zPMnxwSSnTiKzc3xn9MYSjIutD5D3ReFL6VLZambE
         cl2hsQBDQ8BmbBRC+zEFTJUDwflYjtr0rPhwQaybXKROnhqV6ABX6DOJ+NhQA+NXri04
         ScuwJJ7CUnORghlCTKQ4/IFa20x9vWu/0ma3v8mIMpzaoQ8oxCRkHpMqHcpeD2jNZasJ
         rXNA==
X-Gm-Message-State: AOJu0Yw2YRL+n8+S0RKEOR9I+cPTR0IVi4X0bCTjaEXK1XG/GMZrgb+F
	sHUEBPD/BZf3sC//50HTVifBxJk63OWqaEE6Fk9PyvJTWEv2ZuPb71cEBOfxj4A=
X-Gm-Gg: ASbGncthY4LH0xVFH3X1oeBbMftUcIZxkxLVOvaJbhslhDLrhC+RYQWKa6FDqonE4gQ
	TqSlgqy9UXppncPBvMd6HBTT0rwoDrkXowUMB7wTZ96dWGq1uboKbbEHNHxLPxTRe0xG4Nqebag
	XTsNWjUHhcwh7ONMO/s4lXmiltHdzhLZRCah3ovbiol2yFv8YpP+1yO3IYd0n1QwEhXS9/EIuKX
	l3quCJBLiseiFv7Z+K4SdhaB30c8wwNMwpWWQdM2qjcA0qlsKhhplm35hnn5u4bS18H2PFq+K6Y
	g8nHLeCzWJpQZ4zOR2XQjzw3LCQCcL3B12NuITEC+EyPYo4hxsY6GlLdMw==
X-Google-Smtp-Source: AGHT+IHhKhK1Wampe7HG5CfLYgXfzWCQTUvTf2PVOHx87p/lS/w3GjKKNRuQC3jxYB7GAzu+vy6I7g==
X-Received: by 2002:a05:6a00:1702:b0:736:3ea8:4805 with SMTP id d2e1a72fcca58-7390597f7eamr17945734b3a.7.1742850719026;
        Mon, 24 Mar 2025 14:11:59 -0700 (PDT)
Received: from [192.168.1.67] ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73939d2bdb1sm1805196b3a.144.2025.03.24.14.11.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Mar 2025 14:11:58 -0700 (PDT)
Message-ID: <11b5441f-c7c0-4b4c-8061-471a49e8465a@linaro.org>
Date: Mon, 24 Mar 2025 14:11:57 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 20/30] target/arm/cpu: always define kvm related
 registers
Content-Language: en-US
To: Richard Henderson <richard.henderson@linaro.org>, qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, qemu-arm@nongnu.org,
 Peter Maydell <peter.maydell@linaro.org>, Paolo Bonzini
 <pbonzini@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
References: <20250320223002.2915728-1-pierrick.bouvier@linaro.org>
 <20250320223002.2915728-21-pierrick.bouvier@linaro.org>
 <1109fe22-9008-47c6-b14d-7323f9888822@linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <1109fe22-9008-47c6-b14d-7323f9888822@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/23/25 12:37, Richard Henderson wrote:
> On 3/20/25 15:29, Pierrick Bouvier wrote:
>> This does not hurt, even if they are not used.
>>
>> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
>> ---
>>    target/arm/cpu.h | 2 --
>>    1 file changed, 2 deletions(-)
>>
>> diff --git a/target/arm/cpu.h b/target/arm/cpu.h
>> index a8a1a8faf6b..ab7412772bc 100644
>> --- a/target/arm/cpu.h
>> +++ b/target/arm/cpu.h
>> @@ -971,7 +971,6 @@ struct ArchCPU {
>>         */
>>        uint32_t kvm_target;
>>    
>> -#ifdef CONFIG_KVM
>>        /* KVM init features for this CPU */
>>        uint32_t kvm_init_features[7];
>>    
>> @@ -984,7 +983,6 @@ struct ArchCPU {
>>    
>>        /* KVM steal time */
>>        OnOffAuto kvm_steal_time;
>> -#endif /* CONFIG_KVM */
>>    
>>        /* Uniprocessor system with MP extensions */
>>        bool mp_is_up;
> 
> I'm not sure what this achieves?   CONFIG_KVM is a configure-time selection.
>

CONFIG_KVM is a poisoned identifier.
It's included via config-target.h, and not config-host.h. So common code 
relying on it might do the wrong thing.
As well, its presence is conditioned by target architecture (see 
meson.build), so it can't be enabled for all targets.

For this patch, it's only cpu definition, but for code based on 
CONFIG_KVM/TCG/HVF/XEN, we should probably check {accel}_enabled() 
accordingly.

However, at the moment, I'm not sure what is the best way to deal with 
it for common code, as {accel}_enabled() symbol can only be present once 
in the end.

> 
> r~


