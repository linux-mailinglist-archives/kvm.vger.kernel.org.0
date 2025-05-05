Return-Path: <kvm+bounces-45436-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4EBAAAA9ADD
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 19:41:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7B7E33BF6DB
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 17:41:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C368A26C397;
	Mon,  5 May 2025 17:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="YIjYh4fR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D09BCEEC3
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 17:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746466899; cv=none; b=J+0EfQlHQNh+Xma07IM6TCY13aQC+Lxoo9EN3Z1/UdXhy8nIxy5GCEnpFFTiC4Ay9nF9RkjWHQnWdG50X3CRElSbEgJIuFPkWO87wTMP6TfB7U/k2LuIVENoZg/ohLOwuowWtjkyEiLmK7EL4dWKmgsCCG1Z0CRHwKAKsJchz8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746466899; c=relaxed/simple;
	bh=wQl/LxwAooABVXTmZ+4I5QdhL9muJVW/L3x9iJKV1mI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nPbi7/saPFk4xs+9U1q/+DzKXWfC9jWlHZTFDQ4geX0/w5eHp9/bWYdQ6ImS5Q8QaxpMSf24JuHQ6nPdRCYkcwRaMtO4riyXy+Ln9XhSx/XtI03c3wBgIetGPrqfTQvoyHWoK+ldie2RiSfa1h5hbJGqwly1shY3gJGGi0MQtFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=YIjYh4fR; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-7370a2d1981so3918522b3a.2
        for <kvm@vger.kernel.org>; Mon, 05 May 2025 10:41:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746466897; x=1747071697; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ew70U3lTDz5hC+3m9yRbzo9z4bHliR8+n+FYQbakwuQ=;
        b=YIjYh4fRv2WkHv7FAb0vFENabqf9fMHLXgoiqWeJYVJFquV1NKPkLlT5IjNZV+GaSN
         9LFV+x1kRNrY6sMbH++FfJaKdqC4+kkXleyl4PxTclzlBeNceYpgcBUkIkY0GdB+tDx8
         Z9THau7to7qNUpAZqjww1P1fOkI7qe0nL+XEyM1F1A1pYsghBOFI7I4Ve/v4sNdVFaik
         DO4Q9/A+xWEVopxtDD/t9ZngITcUL8b7kb40SiclCXIETsRFDLTM2hlCGFH5Tiwq6ZEU
         Vxafzp9IsA3UOX+qi9Hn23X66cwbjc89ZYfiAQ/2OH05R6kUSUYvSkB3XjWhp98wcq6Z
         tnEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746466897; x=1747071697;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ew70U3lTDz5hC+3m9yRbzo9z4bHliR8+n+FYQbakwuQ=;
        b=jmzPwgb+KZ37r4ZT52jwGSmcpyviPNmSDbl+4pJ6kB5Uyy6fpAYCLgkX62wYYN76+M
         imtXDGywWxidG/7WPelBoE7oDHHDZOMEBtcVt7uw/77pnJbAwYzO40cdQ9PWNob0Cscs
         Wrym+uAnoeoPwx9mKytQxilW++0nHnXaynNc24Oac1JETrMJsAZPpQtUjkJGPYIbEkc9
         rTQjdHMLIzOnaUZMYCMaA6fsLnxLQjVlnR6niKFYwEbS9Wz2AB2nDwghJuDwo7uNiD62
         w7k0Kv2Z76O1s5c2RtnPCwd32Xnce390R1t+MhysTI1LCO5fZNgwB3lY6TRejXbRGhPc
         ChOw==
X-Forwarded-Encrypted: i=1; AJvYcCVJ4iOFFKgn/b6D7jvsiyfCAJtdLotDjB/sqm570eDN/riTCanlnnT8F+pMmvfZtxvJq/Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YxN6W9wit8AwlpGb+rqdqrsK8h9PVBk497dejSNpXM1eKd+Q9yC
	lBWLQNnwPbQCiPW4RNZW7roCXI23gquRJUTR73HMD8FrtOeXpPqqwGhwlKqiP7S5lDDkmgB0rPI
	KTKc=
X-Gm-Gg: ASbGncvkpCZn7pLW48CcBk3KTB837GyMGIadGkx6Faynt/WIPN45r5i/RQOjN1lZDDV
	ULf20Dc9n7uKJ3Xu9+AiziAU0Mezv9r3gnT/uK3zMx8RumkSsXfjHCw7KYW+NXuyRHU7ZecLot+
	gY8VPAvRXXyrY/FqysWo12J4chtxoyEAuvDpcv9XsjW7LmCjZxlaTKxbtffZWRIId5jqZoaU29k
	JPvBjGeopisdn5PF2/rCpamrLLXtsPgSHTszEA1PxO17AsatTmdc0QbQTFubFenpoWOTsAUxQsW
	tigwULFcKPJqAiznXgzsT4wJgwFFl5qyJMI+sLgeg8gJbHbY63UePQ==
X-Google-Smtp-Source: AGHT+IFXaEzxiofDDELYqsPn04eZnaz8QiBcTf59KURdaK3Y2tALU7ijUKo8RT9o0LZf1B9L0ObdVw==
X-Received: by 2002:a05:6a00:1d8f:b0:736:6ac4:d204 with SMTP id d2e1a72fcca58-7406f0d9ea2mr9996738b3a.11.1746466897088;
        Mon, 05 May 2025 10:41:37 -0700 (PDT)
Received: from [192.168.1.87] ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-740590238f5sm7100162b3a.88.2025.05.05.10.41.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 May 2025 10:41:36 -0700 (PDT)
Message-ID: <4e7c2d18-dec2-4a49-9f1c-35e057ba8874@linaro.org>
Date: Mon, 5 May 2025 10:41:35 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 04/48] meson: apply target config for picking files
 from libsystem and libuser
Content-Language: en-US
To: Richard Henderson <richard.henderson@linaro.org>, qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org,
 alex.bennee@linaro.org, kvm@vger.kernel.org,
 Peter Maydell <peter.maydell@linaro.org>, anjo@rev.ng,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
References: <20250505015223.3895275-1-pierrick.bouvier@linaro.org>
 <20250505015223.3895275-5-pierrick.bouvier@linaro.org>
 <857f0b9f-e58b-48a1-87af-49c3c52b379a@linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <857f0b9f-e58b-48a1-87af-49c3c52b379a@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/5/25 9:59 AM, Richard Henderson wrote:
> On 5/4/25 18:51, Pierrick Bouvier wrote:
>> semihosting code needs to be included only if CONFIG_SEMIHOSTING is set.
>> However, this is a target configuration, so we need to apply it to the
>> libsystem libuser source sets.
>>
>> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
>> ---
>>    meson.build | 26 ++++++++++++++------------
>>    1 file changed, 14 insertions(+), 12 deletions(-)
> 
> Acked-by: Richard Henderson <richard.henderson@linaro.org>
> 
> I'm not quite sure how this is supposed to work.  It appears this compiles everything in
> libsystem_ss, and then later selects whether the individual objects should be included in
> the link.  This is fine for internal CONFIG like SEMIHOSTING, but won't be fine for a
> CONFIG that implies external dependencies like VNC.
>

The trick used in our build system is that static libraries are never 
fully compiled (no archive is created), but everything is done by 
extracting objects matching sources available after config. It's a bit 
weird, but it works. I understand it was done this way to avoid creating 
specific static libraries per QEMU target.

Before this patch libsystem was including all object files by default 
(thus the link error with --disable-tcg in Philippe series), while now, 
it selects them based on target config, so it's a subset.

In short: Static libraries in QEMU build system are just virtual sets of 
files (sharing flags and dependencies), and only a subset is included in 
each binary based on target config.

> I guess we can think about externals later, if it becomes an issue.
> 

Most of our external dependencies are not set as required, so if no 
object files selected uses it, it should link fine without the 
dependency being present on linker command line.

> 
> r~
> 


