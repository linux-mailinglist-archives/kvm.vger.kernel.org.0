Return-Path: <kvm+bounces-41880-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E3307A6E7F0
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 02:24:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 54688169EE6
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 01:24:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B5A813AA3C;
	Tue, 25 Mar 2025 01:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="NKVdeJuy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8983125D6
	for <kvm@vger.kernel.org>; Tue, 25 Mar 2025 01:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742865845; cv=none; b=BJuaL1jluvx1QKejJvHToGEeU+0Qt40XYuD3NUz32EIq1wxs1q7Ezg8Nx3xqRpaZlI/e888k+cYCljuhBeVkGfGK1ekbCKrHhlo9EJIdsChcZbrEQkYLAtvCmaBrdM6YSNteClWS71wXYM6KtFS71m6o42DR+S2QU8cR67Ubels=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742865845; c=relaxed/simple;
	bh=zL2NmOtRWk32CN0+o8lonFwku9IgU7WCaRQSNyq7luk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=l8ODwevksvsNlsnQKngblJ4veokjIrcCbOBJ0efsNRt2a8rB4B8sp8tiVfJha0/oZFDle5ITB/aE8wTYzGdGaqKdLuRcCD37M/ldUgY8epXtp2XBrW3spGoRbPQ60jp212k+0DBDYR1ynzF/w6xN/YRHrh5J6e/sDb54wxWxl+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=NKVdeJuy; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2241053582dso23620025ad.1
        for <kvm@vger.kernel.org>; Mon, 24 Mar 2025 18:24:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742865843; x=1743470643; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3f/aamhcaq65N5QVWFb7BojgdxkqrG6VyY1uYeOMdAE=;
        b=NKVdeJuyzA2nWgHAX2K51hjcoNhw7rdsavksGZquu6/O5TiU2SVOWiBNCk0JePP37O
         V9CzB57jN6poUn0tfLg5gUbNM3g4A7Ni5myPQ57CrJI4YC9DwADQkGbiz5SitU99t429
         9A4bAtLau+2Pgrn6MKVxaLcCTpzsPDL4wJuXPpJ+oa5C7OiyGXIr4d5WIwaxY/x7Pomb
         4sFBzIl16p/nhTLoN1ZrjD3HeJ6PgvlDBn0aQhxXDy8JT8AidvikXwcXcGE+ZjLOF39Q
         r3jF9vWrm/FftBmkDcvukCDSxyXhyx8uyDfEWDfW84NOaQBqU/5jxWomcTihBfSNE0lL
         9HWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742865843; x=1743470643;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3f/aamhcaq65N5QVWFb7BojgdxkqrG6VyY1uYeOMdAE=;
        b=epRtDISw4oVl+WQLzRK7MQ7qsJuYEybMA3pD5UlkpAIKh/mGf1x/DFVRbtqpIKtp80
         R7ZCGaoSu1RLgO5IenLJ5EaAJ0C75XDDoBnERxLxvKs2pyGCTV6zKVOruBNUqLSivHz2
         DlOicO2PqZUIIAH0Wkir/u2uZ/EojOuRQJKXlwQOfEER0FiDg0n0K2l5Yg/uwiZfNJ3s
         qcA7g8axy35UHoLJqOmw6hytTluKCFiyGxlidO8iZZqHapjfxEzqbg2u+y/EnSm5p0hr
         jGTk+JosHxgiQu99+EJUTk/mz/IMzjDtYKXt+bnHtfMyf8bCDsK0+O6m2+fV/lwzD+9J
         kMaQ==
X-Gm-Message-State: AOJu0YyE8QfWgdmkbxOc8MZDgEDKINTvnS2DZFVmmG2+leQU5weo16wD
	di9NEmg/IB/DJ855deWcvzxGZ4dEQMCz6kPtv4u6Amk5WRVrBSTHIOsJYMCiQQw=
X-Gm-Gg: ASbGnctX0Ixqk0kWKxyZK/rP4uBF/aVOvDn2HsvvQjmpZN6ofrysQufbX1mNIP+UY5t
	zWyk6VWdTYe9OIiXZfsTW+mwSdqv5fq3p5IItSZ5YDjoCCvXl3Tj/LQDgaMi4Bu24I8Vuqjii1P
	xkV9ZpFdqpJfxiAAcO0i+ntMJZgYldxSjtab5gdKQXjUqg8JAWOjbI7HaVFwJ0mIP3M3EDTEbgb
	/POQdHwp6Hp5I+ipPdOFz0W1VZSX4eJHAo6ym8TvLkOKUTW/wg3mMNUsePioZk5xR6lyr93G8A4
	09BK5OBCYaIVKkoW+NOsJ30e9EuxUkb7n0DPVjR+cW50Z/R4F5PGIfjxnlVt/7ixqUrxiQvKbZv
	j14SEWh9t
X-Google-Smtp-Source: AGHT+IHtYFXPUcyvhT6u7EcdDtjGqWUVYlhcNricl/EtL0dR+OXt6ZmrKRY5nBmdo5X4L15+2ngQQA==
X-Received: by 2002:a05:6a20:258a:b0:1f5:7280:1cdb with SMTP id adf61e73a8af0-1fe42f2c9d0mr25068794637.16.1742865842846;
        Mon, 24 Mar 2025 18:24:02 -0700 (PDT)
Received: from [192.168.0.4] (174-21-74-48.tukw.qwest.net. [174.21.74.48])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-af8a28467e9sm6648568a12.37.2025.03.24.18.24.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Mar 2025 18:24:02 -0700 (PDT)
Message-ID: <428e6fdb-24b9-47a2-9d3f-4ef5c2e1a0ae@linaro.org>
Date: Mon, 24 Mar 2025 18:24:00 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 20/30] target/arm/cpu: always define kvm related
 registers
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, qemu-arm@nongnu.org,
 Peter Maydell <peter.maydell@linaro.org>, Paolo Bonzini
 <pbonzini@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
References: <20250320223002.2915728-1-pierrick.bouvier@linaro.org>
 <20250320223002.2915728-21-pierrick.bouvier@linaro.org>
 <1109fe22-9008-47c6-b14d-7323f9888822@linaro.org>
 <11b5441f-c7c0-4b4c-8061-471a49e8465a@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <11b5441f-c7c0-4b4c-8061-471a49e8465a@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/24/25 14:11, Pierrick Bouvier wrote:
> On 3/23/25 12:37, Richard Henderson wrote:
>> On 3/20/25 15:29, Pierrick Bouvier wrote:
>>> This does not hurt, even if they are not used.
>>>
>>> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
>>> ---
>>>    target/arm/cpu.h | 2 --
>>>    1 file changed, 2 deletions(-)
>>>
>>> diff --git a/target/arm/cpu.h b/target/arm/cpu.h
>>> index a8a1a8faf6b..ab7412772bc 100644
>>> --- a/target/arm/cpu.h
>>> +++ b/target/arm/cpu.h
>>> @@ -971,7 +971,6 @@ struct ArchCPU {
>>>         */
>>>        uint32_t kvm_target;
>>> -#ifdef CONFIG_KVM
>>>        /* KVM init features for this CPU */
>>>        uint32_t kvm_init_features[7];
>>> @@ -984,7 +983,6 @@ struct ArchCPU {
>>>        /* KVM steal time */
>>>        OnOffAuto kvm_steal_time;
>>> -#endif /* CONFIG_KVM */
>>>        /* Uniprocessor system with MP extensions */
>>>        bool mp_is_up;
>>
>> I'm not sure what this achieves?   CONFIG_KVM is a configure-time selection.
>>
> 
> CONFIG_KVM is a poisoned identifier.
> It's included via config-target.h, and not config-host.h.

Whoops, yes.

r~

