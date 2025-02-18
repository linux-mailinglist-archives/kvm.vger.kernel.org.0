Return-Path: <kvm+bounces-38484-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 03709A3AA04
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 21:53:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2ECD018972E1
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 20:51:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02CEA1D6DC5;
	Tue, 18 Feb 2025 20:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=tenstorrent.com header.i=@tenstorrent.com header.b="dSd5j0Di"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCA641C5486
	for <kvm@vger.kernel.org>; Tue, 18 Feb 2025 20:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739910736; cv=none; b=NBxM9wbO6LUgasTbW6rthN7YGriCKZzZojTJtXTnV28C1Bnp4ewRQnsgSuxdaV7jiVsla1KBnifigBCm5IEPxUO3iqMc8WCj3D/l4cu06KkpWzb/rr7SQ6Wi4HahMTfH10+T0CMon9x1/VmAwNdJW5fpt79E0cGPHtz8sIk8l44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739910736; c=relaxed/simple;
	bh=oESRZenwTOGW9qZ9updFmYmbHEflgSLMu5B+hxAVNyU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PHAlq0LX9pmgn2rFal6zQyzSHWv1IKevSDWHGv1gyedHzpixSm46eJX6sTHestrUuI9YwMlPtaE0uZNGAmCxqbS15nzrTMIQm7q+FhskVCd63ul3EhdegFx5epaGOGgfq+D1cbNR4VPy80yQ9PoZ2Ttb0L/tmSdMKqij/SPH2qE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=tenstorrent.com; spf=pass smtp.mailfrom=tenstorrent.com; dkim=pass (2048-bit key) header.d=tenstorrent.com header.i=@tenstorrent.com header.b=dSd5j0Di; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=tenstorrent.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tenstorrent.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-22104c4de96so59015075ad.3
        for <kvm@vger.kernel.org>; Tue, 18 Feb 2025 12:32:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tenstorrent.com; s=google; t=1739910733; x=1740515533; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pnal5c9hX3EPKzjjLBszTSN7EE8YsdPowo3tKHbbohg=;
        b=dSd5j0DiFZSmV+eBBEPtNSURbds8whEvLhTgNYuBhaM+8WYbeBBPo89ZYx3ooHI45E
         o9MXI6JGAejvQEN5GFGzWI0AhYdLeOy0aTOSItwVM1MQQqVXzQx+ORHLJN+FJxQ1iLxo
         UPgpnysiiM0sf4rtP0ShDU+lrF01owRLcuzp62zE6H3BEEx+ZztxxJBmcFAfYYLvvBBP
         UpQDVP4UtMuhsYXwvfZpBUNouAvSQ2Fp5RI/TakeTWVhxPnCTvEwaWdYcXpADzCmcWJ+
         Xpn9qXpsw2hv1qFnlgHb/wCsRXfhBgGYTi9Lm/lMLeUlqvwpIq4pUNquJd93J5pm+WVb
         vtuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739910733; x=1740515533;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pnal5c9hX3EPKzjjLBszTSN7EE8YsdPowo3tKHbbohg=;
        b=J31rRDNbVbTUXSzD+/wBVtakbaBSM01jKxgIFoSPyGzn8reLgSYhRLokUYBCNIOBN5
         vJhu+alQ9vkOFBlqECTY2McOuMXWQAf8Qa913TIqeFhnzmO9uranxJqaxYCsSZghcRgA
         bmA/PjMw3RqeUR9xO8a5H68It2ca1kSYwCBEtUct3kyaI4Oiuv9xKfS4AKx0fIn5smYY
         aDPbUyR66HtVi6SMygiX967sri2pHjaDjtltRItwXAKOVHeaP9+LiLo6nP25KKGm9Q1V
         EYJ/e/DI44B0oeIjSByL+ogVSVD+DmLAtuYxkigGwaVe8PsuytkEEoWjKk0ApD7t/0RL
         oCPg==
X-Forwarded-Encrypted: i=1; AJvYcCUsI2vK+iS5XFdPMsb5hD/giRUGWvf5LjuH3RxOVMbhxkIKxZ+BLWgLMZAyjTMqz6AkNZY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwZI/+D4DraILj0FRQmDkFT7MBfkCyzvBN/CZksb5V2YpSq/QvO
	Sm94RP/r++5tf9Wp5sI40pcHqIGqcYpEgudH0CHYwSW4Yo8bZS98ZKRya2bxbJ5JLzIjXbqXRm8
	BOg==
X-Gm-Gg: ASbGncvN7jFyyhSQQvGbTwcmF2raWOKT2TBwdEccoZhcuvkaF8frgag4AGTRbnKr7C3
	E4Wdbytb74Fjd6d3bsEGHw8VifCm9XBFefVvGUSu7Q8vy78wHZxtQNTBCzojTp4F6MrKdQxlhsP
	TecRqwpnAAipEHZm/KEoDhhidt/QmtVC6rs2xynY20oyiLMorC40Av9kMGXSgdEWiN7Wc0veLw5
	8k5d5E/pJjvvxbH7SekODs6MmDgfQl7OO4vuKC71z7lXBJmpzSv0VvT1c5S7X9KscnMkctbQvAa
	SohzAHk1tggoxrkNdsNvjvdwV2D7VkUezTE=
X-Google-Smtp-Source: AGHT+IF1doa1DuD/RvFMUzmaNj6txow75f4Cssay/y45zRLY5Mb7WcnY0AWaHvfTLoelHVPKpsuCLw==
X-Received: by 2002:a05:6a00:2351:b0:730:9946:5973 with SMTP id d2e1a72fcca58-7326177e31emr20859489b3a.5.1739910732992;
        Tue, 18 Feb 2025 12:32:12 -0800 (PST)
Received: from [10.140.24.106] ([38.104.138.51])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7326b5ef448sm6398139b3a.173.2025.02.18.12.32.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Feb 2025 12:32:12 -0800 (PST)
Message-ID: <b4f301c7-9d10-4bbf-9fa5-16f356fc1e16@tenstorrent.com>
Date: Tue, 18 Feb 2025 12:32:11 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH kvmtool v2] riscv: Use the count parameter of term_putc in
 SBI_EXT_DBCN_CONSOLE_WRITE
To: Joel Stanley <joel@jms.id.au>
Cc: Anup Patel <apatel@ventanamicro.com>, kvm@vger.kernel.org
References: <20241129045926.2961198-1-cyrilbur@tenstorrent.com>
 <CACPK8Xehfy_12FmCd6fVcr5_-cpe2g-ADa9cwR+AjgDLJNuqTw@mail.gmail.com>
Content-Language: en-US
From: Cyril Bur <cyrilbur@tenstorrent.com>
In-Reply-To: <CACPK8Xehfy_12FmCd6fVcr5_-cpe2g-ADa9cwR+AjgDLJNuqTw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 5/2/2025 11:40 am, Joel Stanley wrote:
> On Fri, 29 Nov 2024 at 15:29, Cyril Bur <cyrilbur@tenstorrent.com> wrote:
>> --- a/riscv/kvm-cpu.c
>> +++ b/riscv/kvm-cpu.c
>> @@ -178,15 +178,16 @@ static bool kvm_cpu_riscv_sbi(struct kvm_cpu *vcpu)
>>                                  break;
>>                          }
>>                          vcpu->kvm_run->riscv_sbi.ret[1] = 0;
>> -                       while (str_start <= str_end) {
>> -                               if (vcpu->kvm_run->riscv_sbi.function_id ==
>> -                                   SBI_EXT_DBCN_CONSOLE_WRITE) {
>> -                                       term_putc(str_start, 1, 0);
>> -                               } else {
>> -                                       if (!term_readable(0))
>> -                                               break;
>> -                                       *str_start = term_getc(vcpu->kvm, 0);
>> -                               }
>> +                       if (vcpu->kvm_run->riscv_sbi.function_id ==
>> +                           SBI_EXT_DBCN_CONSOLE_WRITE) {
>> +                               int length = (str_end - str_start) + 1;
> 
> Much more readable than v1!
> 
> You could add a check that str_end > str_start where the if
> (!str_start || !str_end) test is to avoid shenanigans.
> 

Probably wise.

>> +
>> +                               term_putc(str_start, length, 0);
>> +                               vcpu->kvm_run->riscv_sbi.ret[1] += length;
> 
> term_putc returns the actual length written, should you be putting
> that in ret[1] instead?

Yes I think this is a good idea.

> 
>> +                               break;
>> +                       }
>> +                       while (str_start <= str_end && term_readable(0)) {
> 
> Previously this would have only happened for function_id ==
> SBI_EXT_DBCN_CONSOLE_READ. Should you add an else?

An else block would be redundant since the switch statement only lets 
SBI_EXT_DBCN_CONSOLE_WRITE and SBI_EXT_DBCN_CONSOLE_READ in here. For 
clarity a comment couldn't hurt though.

I will send a v3

Thanks for the review,
Cyril
> 
>> +                               *str_start = term_getc(vcpu->kvm, 0);
>>                                  vcpu->kvm_run->riscv_sbi.ret[1]++;
>>                                  str_start++;
>>                          }
>> --
>> 2.34.1
>>


