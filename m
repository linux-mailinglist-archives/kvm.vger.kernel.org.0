Return-Path: <kvm+bounces-48278-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 34A0BACC218
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 10:22:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 594D8188EC40
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 08:22:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE42A280323;
	Tue,  3 Jun 2025 08:22:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="E3klzwW4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE53D18E1F
	for <kvm@vger.kernel.org>; Tue,  3 Jun 2025 08:22:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748938933; cv=none; b=fjXXMm9TS+gy3wlmHZC6HIPGHXx8nhW0VXpS8DdVN6Q2Q8Em29FI9+QtugZ/vWxs84URlfJY0xsdfN1KaBNvpD8okoX7J6j5ATntvbXY39bu40HfiZtLnezqbTf98fLChOkPQZcO2GAAQlyeGmglkktmZGRb7TuWJNyIXKNgmKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748938933; c=relaxed/simple;
	bh=RE8iwq1XWZo1IpQIwEWbh0xx+rGbhhU90MtUgLFjbHY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uLma9LytlM0Unyp+wAcveGH24qrXw7OT1vB9XqcZ2TzKqtdad1bhtz8f7lhtBiSxvgZMaDJcr3vuk+SpSgz0TjnCyMGEs2VAmQCPyIGwwf7fTQ+RJQgMNe8Z4G/l9FbpoR2J7Yi2y20YUC6WKLhvblYYtjo/0GGWw/eGaW4xLbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=E3klzwW4; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-451d6ade159so18992715e9.1
        for <kvm@vger.kernel.org>; Tue, 03 Jun 2025 01:22:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1748938929; x=1749543729; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=K2XTvhxjYdBUQTznG5NYPYGKHAJcGp6Opc492M0PGhM=;
        b=E3klzwW42WYNwepLiYgSHoWKOncmgxfTP767zAo4KGxumFGozfaPLRJ53BVqT3TIIR
         BTP5XKN3R9Zme7+kIijO5cweh8iabJM/a92v2b3lV/0jh/nymAt8SBATkXmZxxdgfxLX
         IeIL0YHAgoJvoQEEV6veeING1rfVmCyS0uxcuWq8ADYIfISLny6kL7bCd6jqgJnKGbbp
         Rpesr+ThMC+ugfAoMGa7VW7iTbZVVg8gqaXResq3HIurDiOsy45B9o+xWhEAdHkRhicH
         HX+oN3YHg3asZOJmdtG7d0zuALAX2lDTOzTjtq+kWZHrkfbZQppWec1P8SWxcRKqWAym
         j3Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748938929; x=1749543729;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=K2XTvhxjYdBUQTznG5NYPYGKHAJcGp6Opc492M0PGhM=;
        b=W9g7RXTKFpuiHfyAeZPm67XKf5IbmIStItgrM5C8EWzuoPDLBOykOYm5PRRxfe+zRC
         hoDiCKpqZ2sHdg9mynQngshTnzgeyYS5rZsG9ZTUNQdmzPwFA+qFMwAyWczHaaHlkMo5
         +5n1W4mmuyiajLTBfyrsfkHoPXypHRGOVOIA6vZbINcEFSMKyKjRYgtzDrEHX9ras5eK
         114lDU7ySa8cjQRmzGDerFCMJcGkX6I47c5lLINRyZUgTqyvQUc+ZYl6JgZKXRN8JQ8r
         dcSzoGQkS7PsPbr4FJce5nR2AJO3E/V1/7MkxDsaqFFcPVJfXjNvrfqMESXcSqgMYuzo
         mrRA==
X-Gm-Message-State: AOJu0YxWSd5whAzcZatW29kfO8y5UI0u7Y2WsgCnb5qpPh/z8xWWJ4s/
	7dYPo5ivWyscTviaIxHrypfv8BzU2R7K4gULvAa8Suxk66CbOkbnqq49K+ji7jT58psX8vN5ut2
	MfqoJOpY=
X-Gm-Gg: ASbGncsD5Hz2G4gc3crhhBBTKF54rpLjsIzeW1HiYQLdRz3Ov3gWEQeGveUSMYh2nLH
	6zTF6pppxOpXPxFZVFQBLtidc4lzjErXxy1M1E1k8IS/mXtFaGhnPrqESRTWRFXQP2/X+l2Q+Nj
	Eo80az7YGqWzfSxc3/kbMSDAjDk7tbTnONC0xzgr4rxZpnANeEIEvA9vIcYbbTGqZkFaCeI8slo
	sCP4vrqusu6Ag3KUc+ejkaFcPdCoAAmUzoqIZUuBxBuC/Trn/4SJSD6aPxZA9/wDWDRiBIN5lUv
	0o3G8qKipJ1ZYhtDm4rFRJJ3FxHghjj+jd+ZEEgglCQ6RUU62aecjrXEwhcO3Trletggp4uJEFu
	5F8TylcuL+eUde3o/HivB
X-Google-Smtp-Source: AGHT+IH6bSE/uSlwylASDQl8d49pwO7PohjcuR9xazY2IRh+dA9DL0f7PpSdjTGS8b2Znt9Rspe7bw==
X-Received: by 2002:a05:600c:8b8a:b0:43c:fffc:786c with SMTP id 5b1f17b1804b1-4511edd3dadmr94180225e9.19.1748938929076;
        Tue, 03 Jun 2025 01:22:09 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:e17:9700:16d2:7456:6634:9626? ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-450d7f8edf9sm151056295e9.3.2025.06.03.01.22.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Jun 2025 01:22:08 -0700 (PDT)
Message-ID: <bcb3cffe-5fca-45fc-aa30-c167f6cf3c5c@rivosinc.com>
Date: Tue, 3 Jun 2025 10:22:07 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] lib/riscv: clear SDT when entering exception handling
To: Andrew Jones <andrew.jones@linux.dev>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
 Andrew Jones <ajones@ventanamicro.com>, Ved Shanbhogue <ved@rivosinc.com>
References: <20250523075341.1355755-1-cleger@rivosinc.com>
 <20250523075341.1355755-3-cleger@rivosinc.com>
 <20250603-8e4c2aa217e6be3b3ee43972@orel>
Content-Language: en-US
From: =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
In-Reply-To: <20250603-8e4c2aa217e6be3b3ee43972@orel>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 03/06/2025 10:16, Andrew Jones wrote:
> On Fri, May 23, 2025 at 09:53:09AM +0200, Clément Léger wrote:
>> In order to avoid taking double trap once we have entered a trap and
>> saved everything, clear SDT at the end of entry. This is not exactly
>> required when double trap is disabled (probably most of the time), but
>> that's not harmful.
> 
> Hmm... I wonder if this shouldn't be left to the handlers. Maybe
> we should just provide a couple helpers in processor.h, such as
> 
> local_dlbtrp_enable()
> local_dlbtrp_disable()

Hi Drew,

Yeah indeed, that makes sense, some of them might have to save more info
before re-enabling trap in a near future.

I'll drop this patch and use that proposal.

> 
> If we do need to manage this at save_context time, then I have
> a couple comments below
> 
>>
>> Signed-off-by: Clément Léger <cleger@rivosinc.com>
>> ---
>>  riscv/cstart.S | 9 +++++----
>>  1 file changed, 5 insertions(+), 4 deletions(-)
>>
>> diff --git a/riscv/cstart.S b/riscv/cstart.S
>> index 575f929b..a86f97f0 100644
>> --- a/riscv/cstart.S
>> +++ b/riscv/cstart.S
>> @@ -212,14 +212,15 @@ secondary_entry:
>>  	REG_S	t6, PT_T6(a0)			// x31
>>  	csrr	a1, CSR_SEPC
>>  	REG_S	a1, PT_EPC(a0)
>> -	csrr	a1, CSR_SSTATUS
>> -	REG_S	a1, PT_STATUS(a0)
>>  	csrr	a1, CSR_STVAL
>>  	REG_S	a1, PT_BADADDR(a0)
>>  	csrr	a1, CSR_SCAUSE
>>  	REG_S	a1, PT_CAUSE(a0)
>>  	REG_L	a1, PT_ORIG_A0(a0)
>>  	REG_S	a1, PT_A0(a0)
>> +	li t0, 	SR_SDT
>           ^    ^ should not be a tab
>           ^ should be tabs
> 
> SR_SDT isn't defined until the next patch so this breaks compiling at this
> point, which could break bisection. You can do a quick check of a series
> for this with
> 
>  git rebase -i -x 'make' <base>

Missed that, sorry, I'll check next time.

Thanks,

Clément

> 
>> +	csrrc 	a1, CSR_SSTATUS, t0
>> +	REG_S	a1, PT_STATUS(a0)
>>  .endm
>>  
>>  /*
>> @@ -227,6 +228,8 @@ secondary_entry:
>>   * Also restores a0.
>>   */
>>  .macro restore_context
>> +	REG_L	a1, PT_STATUS(a0)
>> +	csrw	CSR_SSTATUS, a1
>>  	REG_L	ra, PT_RA(a0)			// x1
>>  	REG_L	sp, PT_SP(a0)			// x2
>>  	REG_L	gp, PT_GP(a0)			// x3
>> @@ -260,8 +263,6 @@ secondary_entry:
>>  	REG_L	t6, PT_T6(a0)			// x31
>>  	REG_L	a1, PT_EPC(a0)
>>  	csrw	CSR_SEPC, a1
>> -	REG_L	a1, PT_STATUS(a0)
>> -	csrw	CSR_SSTATUS, a1
>>  	REG_L	a1, PT_BADADDR(a0)
>>  	csrw	CSR_STVAL, a1
>>  	REG_L	a1, PT_CAUSE(a0)
>> -- 
>> 2.49.0
>>
> 
> Thanks,
> drew


