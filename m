Return-Path: <kvm+bounces-45285-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F273AA830D
	for <lists+kvm@lfdr.de>; Sat,  3 May 2025 23:54:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8F0223BDDD9
	for <lists+kvm@lfdr.de>; Sat,  3 May 2025 21:54:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDDCA266574;
	Sat,  3 May 2025 21:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="zIIkoU8l"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 795E423CE
	for <kvm@vger.kernel.org>; Sat,  3 May 2025 21:54:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746309289; cv=none; b=rUmA7+zimBPFRmoUI7lzsBpRbaf8hGC+ldF3lZIe5sDUB8yFWFGmKcdx5LUdJMazN6Y81B/wSh+H0NUqSuVhJP6S3MnHtGAPzGB1j4a3BLQd/1ilhTQsrcp07r2gKQU6P001WneF/PuM9Iq6+CC+qt7MpqVwmEyx2iUtuX/kFCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746309289; c=relaxed/simple;
	bh=gRuye4gpR3NvQTQ+hwu0tGytygkXZo1odL3S5I+5Mdw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WM9zkZAtw5deVPFnc07VZXLbffjjn00SjKCpazU3qk7SX7b0RgYVOKhW30EtHVZBRzRO8W33hecoVrOnbsILdcOT1u53tLn2+Mqb3bO4FuhNSmkXtyeuwtuoiWxi4HQ3zi6TzVEE8xmkzJhwRFMJkyNuYdhY9yAfEnsY39QWbFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=zIIkoU8l; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-22423adf751so38671975ad.2
        for <kvm@vger.kernel.org>; Sat, 03 May 2025 14:54:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746309286; x=1746914086; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8egesxN17cqZ0dc6fp9Kc2LxbU+ZhDHFMjM3QWxIJTo=;
        b=zIIkoU8lxu/6mCuQW4Yo64xsD7ZVhi13OBVWezVNQKto1dcAowApPYgtzCjM6TLVy6
         vXJmgAoiqNhfuU6xJgm4AA9sLwIA7SgoyN/W7rscgezneuNDvJ+de0vj3yF3kmaO0lpt
         vSRm8EzfdsaalG9Ogwu12VG6zMXOGGAijbQLaf8fHZMLidR0r+h9G4bsklTviESlGoHk
         xjVqhaBTIaQYNz5DqYMb1gU4RGpnmJVXOQzqbX/JXFEqk9mxAcHe/KG5pt/VsOGfidyX
         tgw+vi17Vrt1BOTMYmHZ/iMawjSMoCQDMeZy9M0Jc5atyaNQrPVBOn+cXSZtqhJUC4Xp
         F61Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746309286; x=1746914086;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8egesxN17cqZ0dc6fp9Kc2LxbU+ZhDHFMjM3QWxIJTo=;
        b=RTZI/OVCn+H+fdqdT0EC8c2xrfhuJB1vr3nA8ToNL9ef6KtnZ42VB/Pj0heJc+3jPK
         /bMnBwpT8V902YJl6R0QWreo33Zpynd64QuJUy85R4CWZgaKS0NP9tvjsz1jLb96Q0Hi
         8PiDyggZ32FgutikZx7FTuRD7fJp99ZWtOidNhkXTgYll/v+wUG6hWd+plVoVN7QPD3w
         EVlIPKd0Cbz/rcfmqTCpIuvy6P8jTH0NFpFrhFFtkhCDTVY26wpZs1XPmFN8RA+Oma7/
         VOCiO679onkeuTB5wcAiz9For1H9OvBlK+PA4BImKQmgNbO3oVXq16HFJQrg7zxmt6Xd
         4rTA==
X-Forwarded-Encrypted: i=1; AJvYcCVLQZ13JaxMHPQRXSugpuc4gkM1F7stYpFO2L/7/HEV9tGJwlULhNo7XmZjguIb/s1E8nU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyER2WOmVpiTpoCaqbqh+5xrPXh1BVwSlqhX3vv+i8VQ24eyYeA
	1LfYHzYIYBY8pjiteSkSaaNd7six3LbtBDtYmilKUKqSGmhvfuMc/3jssbQHzHE=
X-Gm-Gg: ASbGnctv8ckbKSRBFPHeeAdNSYwKER8ukdoiCUdJuyk5QYUN+MEjNIRsz3+foZfsHqJ
	kQsdrQH1+B5i12N8w15ivHJstXPRIo3os11IqQ+ZY5+Y3v9qZQnkUFCcVzKJllMDM3PmzRep88D
	3e4UayyR5hdU6FP3wwn9ETizkAnYCTH7dNO2Qwt5y2zyT3wrMZAmgA6XgYVl41zxyegYgJP+C8c
	SK02X3botiEjfflLKCo4sTCMrimTF08SP1wRE7YqHiqDSTxXoa1gK+xCF/r11GP307bv+La9CUu
	pQHiSeo6yGU1uuO45i/wZ9CjFFjxqVEw2sSGob02nSgi0y44i0DQmQ==
X-Google-Smtp-Source: AGHT+IHqUyTV2oPY7FFs0inwI6ot7R54RcFhDq+LlJmRZ42OcG4Hr0D1+iatFhY+CtsMiQhL5RHdqg==
X-Received: by 2002:a17:902:f70e:b0:226:3781:379d with SMTP id d9443c01a7336-22e10353e7cmr118719275ad.33.1746309286678;
        Sat, 03 May 2025 14:54:46 -0700 (PDT)
Received: from [192.168.1.87] ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e1521fc49sm28331845ad.134.2025.05.03.14.54.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 03 May 2025 14:54:46 -0700 (PDT)
Message-ID: <561ee7fc-a288-4fae-93ef-086af8857fd5@linaro.org>
Date: Sat, 3 May 2025 14:54:45 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 13/33] target/arm/helper: use i64 for
 exception_pc_alignment
Content-Language: en-US
To: Richard Henderson <richard.henderson@linaro.org>, qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>, qemu-arm@nongnu.org,
 alex.bennee@linaro.org, Paolo Bonzini <pbonzini@redhat.com>, anjo@rev.ng,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 kvm@vger.kernel.org
References: <20250501062344.2526061-1-pierrick.bouvier@linaro.org>
 <20250501062344.2526061-14-pierrick.bouvier@linaro.org>
 <1844146d-18cd-42c7-a095-6d1b64ad6293@linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <1844146d-18cd-42c7-a095-6d1b64ad6293@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/1/25 9:30 AM, Richard Henderson wrote:
> On 4/30/25 23:23, Pierrick Bouvier wrote:
>> --- a/target/arm/helper.h
>> +++ b/target/arm/helper.h
>> @@ -49,7 +49,7 @@ DEF_HELPER_3(exception_with_syndrome, noreturn, env, i32, i32)
>>    DEF_HELPER_4(exception_with_syndrome_el, noreturn, env, i32, i32, i32)
>>    DEF_HELPER_2(exception_bkpt_insn, noreturn, env, i32)
>>    DEF_HELPER_2(exception_swstep, noreturn, env, i32)
>> -DEF_HELPER_2(exception_pc_alignment, noreturn, env, tl)
>> +DEF_HELPER_2(exception_pc_alignment, noreturn, env, i64)
>>    DEF_HELPER_1(setend, void, env)
>>    DEF_HELPER_2(wfi, void, env, i32)
>>    DEF_HELPER_1(wfe, void, env)
>> diff --git a/target/arm/tcg/tlb_helper.c b/target/arm/tcg/tlb_helper.c
>> index 8841f039bc6..943b8438fc7 100644
>> --- a/target/arm/tcg/tlb_helper.c
>> +++ b/target/arm/tcg/tlb_helper.c
>> @@ -277,7 +277,7 @@ void arm_cpu_do_unaligned_access(CPUState *cs, vaddr vaddr,
>>        arm_deliver_fault(cpu, vaddr, access_type, mmu_idx, &fi);
>>    }
>>    
>> -void helper_exception_pc_alignment(CPUARMState *env, target_ulong pc)
>> +void helper_exception_pc_alignment(CPUARMState *env, uint64_t pc)
>>    {
>>        ARMMMUFaultInfo fi = { .type = ARMFault_Alignment };
>>        int target_el = exception_target_el(env);
> 
> I think for this and the next patch, it would be worth extending
> include/exec/helper-head.h.inc and include/tcg/ to allow vaddr.
>

Ok, I'll add it.

> 
> r~


