Return-Path: <kvm+bounces-41052-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A1523A61061
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 12:48:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 66B063AE72D
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 11:47:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81BBD1FE444;
	Fri, 14 Mar 2025 11:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="lxgR6E9g"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE1AB1F3D56
	for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 11:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741952848; cv=none; b=o2ERR1cqkstqewWpSdpSE4/l7i5ZeFlLthhwWYtB/uaIT23SbQJSDkNeMLvaEA0Xa8d/Wv8NyMuWewOyhKwqzbrI50dRPZ0/C3u91BIPevUStxkvAROgx8cMvPWQ20gvi5rxUH/SHudAa3LYRm2V3aebqWTNQQ3u/5tf6a7r7tA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741952848; c=relaxed/simple;
	bh=9S08aj6cuSDTLfzLSRyiaJKUipi4ZUDEq0jVrExy7QY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lYWGEKWbeVxgrQ1V68ZjIcGIBOzynjjGlCT2VvJy7OAmYsQb/VMYqUvBWTQwq9aVIlyBnNCtn1VRg497zFDzliz0pORMeY3fRyw+uid1k5u5dGyp6dOqq8VTcMboH1hWb7FF16FsR7NnCHmVo96SW4m0ENIUQ8UJEJXkY5p5s3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=lxgR6E9g; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-3913d129c1aso1592249f8f.0
        for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 04:47:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1741952844; x=1742557644; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RzikXcMBGZjkkMXY0vzLgpXOZlJlOHrf1lUiKHrI63E=;
        b=lxgR6E9gEPI2VQ/wcCjV0KIp7cMr4bfJFjWk/5GOeuVJ5qhF6/UAbFYuad33lThEP6
         RZEHmyL9PpkGCDT3TCjogJ9o6q9Be16fVfq/cyYI0dFdSx6U0OIoRkwmmLRCvrhdv0DH
         8g4+Ximy1DW0f5gMs3+o/rbX7PKwSotv+AkBRZosfBD3gCrgaBiqeT4Z8nVTMEqlIx8n
         tw4Me7/t/jSIkmOMAc4ko40U/e5wwEbDsJ4vlluHdnrWSxOQ7kK1Z3Fm2VcfDdXww6bt
         pQHgjR2QWB+IFf36S2R0Ce0djPsuLKnFZ3MwEqtO5s2jegYQqmUlV04lMBTKO4TlEyXD
         HQPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741952844; x=1742557644;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RzikXcMBGZjkkMXY0vzLgpXOZlJlOHrf1lUiKHrI63E=;
        b=XZSeTpA7dijdj58g0wHPkEToihkBN0t2vytTRNOI+lrsVvnVzjSSFdT1CwPzhBuygm
         od7NCEjDfZmjE/vWXY7BlIBvjpojspvGGO2SnW3SphR1NC5UXicaQJ6kuLiMrf8wzo+n
         OvsLaIt0USjBpjI73lI8N9v/Pa9h9oO1az8n72+K20c6wHPK5yLCpFwbRsrPUZJu+igg
         Duv8QPEyEofIbztZ+KsZkhmBFWkL4g32aEFNh9Oh9HZwfQEBS4X2kKuixokHn2nFZJdA
         Qkl1tQFfP/amIXYLVZAKM4iEQn5nL/wgpW5N2pGOhJ+q+43AUatok8cOaX8d6hsH/ztu
         UY5w==
X-Forwarded-Encrypted: i=1; AJvYcCXTDpplQVeSizUd22NQ8vNeRzwxZE9Ttag4Rfi+AR/gz7M7OwXimdDH/yxpJrEDdPagoAY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw3151caRMvdlkbWAFyc7yxw719fZ8qvrkfo0XcWwo+mp6jgJfe
	h1EWeHPLj9guQ49smeWpBfi42Y1t9ZV7Pkivnz008Geua4/yli7afvJNqIsWueY=
X-Gm-Gg: ASbGncs1wotx3UOsTHuxsGeh3uypjB/nZbdES8+bUn95+OqP1CgUG/9V4fCut+Y7vaI
	HJuaecUWyYw0BBqKo85AUmN7/XddKIJtMTx3l2DJU6RqoL7oL54fFW+VqajKT7apLbWD64kWWm+
	zgSsHagSUAtCyizzZHXZODO0JdB7pDYsWEbleuaVGjtRNn4t1FizGCclKqqpHyFqetz2bypQvhG
	V4rvVT3Y90URBeet/Oqig+dBctN1bJjYmSYLCWVF8KtcSwIuc5BXUjHqswv2aeqYKOJNYnW0VKF
	OTgtyip6Yo7RAJ3CLmRV8ExpcJutcvSsj6J+m8Dse66d8qLkeCGxyYgcknwyhOnkM1GRbJLBQU/
	pclUU1gPIrPhD7w==
X-Google-Smtp-Source: AGHT+IGtfAcAmGZVPhIyucY33egMDOBZySQ+8fr8l7lHLk072SvheDgQHi3fAYh9SVsSUmw9CF0urA==
X-Received: by 2002:a05:6000:2cf:b0:390:f116:d220 with SMTP id ffacd0b85a97d-3971c97ba0cmr2373277f8f.17.1741952844036;
        Fri, 14 Mar 2025 04:47:24 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:e17:9700:16d2:7456:6634:9626? ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-395cb7eb9ccsm5371909f8f.96.2025.03.14.04.47.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Mar 2025 04:47:23 -0700 (PDT)
Message-ID: <f0945e93-7ac0-4217-8095-93fff303bdf2@rivosinc.com>
Date: Fri, 14 Mar 2025 12:47:22 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 06/17] riscv: misaligned: use correct CONFIG_ ifdef for
 misaligned_access_speed
To: Andrew Jones <ajones@ventanamicro.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Anup Patel <anup@brainfault.org>,
 Atish Patra <atishp@atishpatra.org>, Shuah Khan <shuah@kernel.org>,
 Jonathan Corbet <corbet@lwn.net>, linux-riscv@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
 linux-kselftest@vger.kernel.org, Samuel Holland <samuel.holland@sifive.com>
References: <20250310151229.2365992-1-cleger@rivosinc.com>
 <20250310151229.2365992-7-cleger@rivosinc.com>
 <20250313-a437330d8e1c638a9aa61e0a@orel>
Content-Language: en-US
From: =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
In-Reply-To: <20250313-a437330d8e1c638a9aa61e0a@orel>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 13/03/2025 14:06, Andrew Jones wrote:
> On Mon, Mar 10, 2025 at 04:12:13PM +0100, Clément Léger wrote:
>> misaligned_access_speed is defined under CONFIG_RISCV_SCALAR_MISALIGNED
>> but was used under CONFIG_RISCV_PROBE_UNALIGNED_ACCESS. Fix that by
>> using the correct config option.
>>
>> Signed-off-by: Clément Léger <cleger@rivosinc.com>
>> ---
>>  arch/riscv/kernel/traps_misaligned.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/riscv/kernel/traps_misaligned.c b/arch/riscv/kernel/traps_misaligned.c
>> index ffac424faa88..7fe25adf2539 100644
>> --- a/arch/riscv/kernel/traps_misaligned.c
>> +++ b/arch/riscv/kernel/traps_misaligned.c
>> @@ -362,7 +362,7 @@ static int handle_scalar_misaligned_load(struct pt_regs *regs)
>>  
>>  	perf_sw_event(PERF_COUNT_SW_ALIGNMENT_FAULTS, 1, regs, addr);
>>  
>> -#ifdef CONFIG_RISCV_PROBE_UNALIGNED_ACCESS
>> +#ifdef CONFIG_RISCV_SCALAR_MISALIGNED
>>  	*this_cpu_ptr(&misaligned_access_speed) = RISCV_HWPROBE_MISALIGNED_SCALAR_EMULATED;
>>  #endif
> 
> Sure, but CONFIG_RISCV_PROBE_UNALIGNED_ACCESS selects
> CONFIG_RISCV_SCALAR_MISALIGNED, so this isn't fixing anything. 

Indeed, that is not fixing anything (hence no Fixes tag), it compiles as
a side effect of Kconfig dependencies.

> Changing it
> does make sense though since this line in handle_scalar_misaligned_load()
> "belongs" to check_unaligned_access_emulated() which is also under
> CONFIG_RISCV_SCALAR_MISALIGNED. Anyway, all this unaligned configs need a
> major cleanup.

Yes, as I said, I'd be advocating to remove all that ifdefery mess.

Thanks,

Clément

> 
> 
> Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
> 
> Thanks,
> drew
> 
>>  
>> -- 
>> 2.47.2
>>
>>
>> -- 
>> kvm-riscv mailing list
>> kvm-riscv@lists.infradead.org
>> http://lists.infradead.org/mailman/listinfo/kvm-riscv


