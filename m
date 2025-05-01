Return-Path: <kvm+bounces-45136-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EBFC1AA616A
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 18:30:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B89919C2920
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 16:30:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 221CE20C472;
	Thu,  1 May 2025 16:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="PEJS2PkA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD1DC81ACA
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 16:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746117037; cv=none; b=O8wUJorJ/5fEM9bGh6x2Nu+Z7slwA+T0DyuiyflTH1gJiRZy/LYXKBtUox6QrfJ3ZacJ08aGpYMG288XimuPDTHEuNtGOBC9T46eIBbiIPnBD7Cdqb2wVjN7Eka0j99Vc6GQi8tKjIkroo9rzo1AqdtBhKMqADthD12aLdixmPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746117037; c=relaxed/simple;
	bh=JaOQxBVtBcgB8Ra+xEgcor9xVTq9FRy3gac8yAlYVrk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VBX/i4ghQfFnz3yEX3BTu3PG+IP7F6pHbKgJdRYazfVgYqIcIYeVqUCfJjEIvIy7v7V7REV2Iwc6NX9AXvJ2S4I6Wua0MMdOSb2yC0AO3yLMiNvjfllalq+XWST7eBlc0ZAo+JjSKCuOYz/3ldRACKGqv1f6sjTFrpPSDjNVbz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=PEJS2PkA; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-301cda78d48so1630357a91.0
        for <kvm@vger.kernel.org>; Thu, 01 May 2025 09:30:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746117034; x=1746721834; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/b9sR/a1jkRMuRGB1+qsGBSWC0mmzSLV2+K1kJwm2vo=;
        b=PEJS2PkAcXM584jap7poCYrzCownYCjdgQOD0pyM8AfsR8glagQ4UjbjuYZvf5qrsF
         YogDvyNKSHYIf0xh4WGwA53NUGto9bS3J68pHAGNcISvMzTk8U+dKwVN4iLJlxLZE4BI
         ZwRQKc53H9rU6MzDHKxQAeQ3IqGpD4UO75Ps3yWxud7NDPSxeih+04WTdFd2rxLUaaO+
         af1NAmiJ94+wWdBuT0IHyrIQRFqI4zX9aKe9T317KvRtjM1BBh7XFScgrajNsTW0WvIv
         sWsK/+9xJv28+qPudfMw7rr7tD5ytbmszmfaliQoq/Z6nC/Hf0o0v3u2iowVlne5OsJn
         ZZbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746117034; x=1746721834;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/b9sR/a1jkRMuRGB1+qsGBSWC0mmzSLV2+K1kJwm2vo=;
        b=fL5cO0jUih/uotTY6Y7RqeEoHsyZ42fi8XH3LJeG5fay6GEqRpsqtdJsPQizzVkBT8
         /4Pp/89HtIR9eWPsQ5axoZyxjkLXiv7nfHsTL+p7UirudabtX1yKd2fzx+65/njbsa8c
         mv2uHECaDs1bNwawZawmbpCqWbhBxRS8CuIxKelzvOwWvagKdtruOjAphxGmFIogQ3pk
         D8uaCoplNbBzhplXJnbzuY/Mxu5hZiQ+fVPPci/ZLvpn9wnUZD745OB0FGwTPASMzeMn
         Sov57rPke0apLn+4N7jo0jufGt4cCsriRoS0nI2hbCUDfBZv5GJBU7mF5G16t4hMFVgF
         OKBw==
X-Forwarded-Encrypted: i=1; AJvYcCVFHBqDnPySPIeHdCD/C7SWsKoYsfKVry1mkWFqBSxGN/d9eFPmIJ+hs51AEwUOFv8wgIE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwjT38VM+05pPl6zl3K6E0m/Nm0bEKsm6e4pUV/hFai+NTGVcxb
	R5fnq0Ssvrd1/lnt2ydgFWAgwxY8g8U15E+SBIGwCQqPnihZXndAWy9GVR2jna0=
X-Gm-Gg: ASbGncv74OcmJlmn4F4jAClzzlAUCPOEw4pzrFEtIqVmXAk9F209KvbQDlUIoz210AP
	pSI3cdgPhQP4SNa2RPJEkUtvc4Ip49HEs4M+cDi8RQmm6I/iknGcbd4+eUkkTqPUKKVEoWmlX1X
	WhGALpqUPYlDCq3g/arQ9/9C6RTjmFfy5UAVpjFquhtnWNwJEaFx6N6v1c78+Pm75ubk1pihIln
	mu/zy842W+h+O6kT1L+PwHjPusOK6/HYHMp5SqBNTDsBOI75NpGTCTB3AbYb2fVfki0TvB9MxpK
	wricc9qCdzvRVG9zliTSUhiemVRigX3WTmSSZulNWducIdAuURo3gUH7QYkJrKcuehwMXaY+HUo
	NLI6YvZ8=
X-Google-Smtp-Source: AGHT+IGiCAh52t7LH0a8SvFCCkcE0hYgB+oEHY1fvkQO27qj56jGPcQbgqGDJEMwfRNN4croOPIk3w==
X-Received: by 2002:a17:90b:3d44:b0:2ff:64c3:3bd4 with SMTP id 98e67ed59e1d1-30a41eeaed1mr4379678a91.31.1746117034107;
        Thu, 01 May 2025 09:30:34 -0700 (PDT)
Received: from [192.168.0.4] (71-212-47-143.tukw.qwest.net. [71.212.47.143])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e0bc7bca9sm8693335ad.180.2025.05.01.09.30.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 May 2025 09:30:33 -0700 (PDT)
Message-ID: <1844146d-18cd-42c7-a095-6d1b64ad6293@linaro.org>
Date: Thu, 1 May 2025 09:30:32 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 13/33] target/arm/helper: use i64 for
 exception_pc_alignment
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>, qemu-arm@nongnu.org,
 alex.bennee@linaro.org, Paolo Bonzini <pbonzini@redhat.com>, anjo@rev.ng,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 kvm@vger.kernel.org
References: <20250501062344.2526061-1-pierrick.bouvier@linaro.org>
 <20250501062344.2526061-14-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250501062344.2526061-14-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/30/25 23:23, Pierrick Bouvier wrote:
> --- a/target/arm/helper.h
> +++ b/target/arm/helper.h
> @@ -49,7 +49,7 @@ DEF_HELPER_3(exception_with_syndrome, noreturn, env, i32, i32)
>   DEF_HELPER_4(exception_with_syndrome_el, noreturn, env, i32, i32, i32)
>   DEF_HELPER_2(exception_bkpt_insn, noreturn, env, i32)
>   DEF_HELPER_2(exception_swstep, noreturn, env, i32)
> -DEF_HELPER_2(exception_pc_alignment, noreturn, env, tl)
> +DEF_HELPER_2(exception_pc_alignment, noreturn, env, i64)
>   DEF_HELPER_1(setend, void, env)
>   DEF_HELPER_2(wfi, void, env, i32)
>   DEF_HELPER_1(wfe, void, env)
> diff --git a/target/arm/tcg/tlb_helper.c b/target/arm/tcg/tlb_helper.c
> index 8841f039bc6..943b8438fc7 100644
> --- a/target/arm/tcg/tlb_helper.c
> +++ b/target/arm/tcg/tlb_helper.c
> @@ -277,7 +277,7 @@ void arm_cpu_do_unaligned_access(CPUState *cs, vaddr vaddr,
>       arm_deliver_fault(cpu, vaddr, access_type, mmu_idx, &fi);
>   }
>   
> -void helper_exception_pc_alignment(CPUARMState *env, target_ulong pc)
> +void helper_exception_pc_alignment(CPUARMState *env, uint64_t pc)
>   {
>       ARMMMUFaultInfo fi = { .type = ARMFault_Alignment };
>       int target_el = exception_target_el(env);

I think for this and the next patch, it would be worth extending
include/exec/helper-head.h.inc and include/tcg/ to allow vaddr.


r~

