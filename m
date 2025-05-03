Return-Path: <kvm+bounces-45283-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E119AA82EC
	for <lists+kvm@lfdr.de>; Sat,  3 May 2025 23:13:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 84EFD178EE4
	for <lists+kvm@lfdr.de>; Sat,  3 May 2025 21:13:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F9132797BE;
	Sat,  3 May 2025 21:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="rKLi1jBU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B605C1B3F3D
	for <kvm@vger.kernel.org>; Sat,  3 May 2025 21:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746306781; cv=none; b=EO+W8R3RZ6qnGQFUw/SqRAixwrX+KRvNac6kU7N5HyBctkItrVGNHca5EUROVTi3s5HQrSmNqa8tqJyVVIGJE9sm6BUFq1l4JEJsbb+1KsLELhNcbMlVrgUFO2gtoxgoPVJgKJ3FvROkEy/d2Cfd9ijon6GL4dRE3J8S1CfDINo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746306781; c=relaxed/simple;
	bh=KpXbOOlTW9tYVzYtMBQJrIUVMLuQZWFiIRCVvb6JeKY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VSqMp6ny8Xr0dYkzjUAqqZrOK2KlxVwb2qIayGxeJbk9IDZMNFhMyidkKhaS5JqQsFGjR1DQA5lEm7CkzMBvdHu8k4tarLIFedHPf5rllNxbeN0UnaFx1FBvMxX9S25rcY042yS+GPtSzDb0v9Ct1dOUjomi7CgAaWEnQDk3etE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=rKLi1jBU; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-b061a775ac3so3156382a12.0
        for <kvm@vger.kernel.org>; Sat, 03 May 2025 14:12:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746306779; x=1746911579; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FxSfhsCEDNJtIfclTFmU04xWQhYR9A6GsTGzarhRRY0=;
        b=rKLi1jBUXVCdoP6OsH8ptchv1dKrcUEkuRuBDQtY6/67ilhDQsKUMABJ7f2h29eKZq
         PUjUtnzZa7VY7MOdf+gQDPe62ENy7n/8VpDV3Rb8K96SyzWrcDng2jZKxJ1lq0wYtjNg
         kKHzKzhuhsNEF1bIFUtK1m1YIJjXOARVLa5FDyf3dGhjmAvt6oshYSA1t+Z4TnaAnwYR
         RB2WmqjgpuJpJmgE7RPyVIuDmLPdhBvsZJBp0XC3bYagL30HZ+NqkIxlDbOR59DRvfNQ
         AR+Ljnclnx9aDFftX0/BKJR+OJ2pB1/bsMWytYE9Nx+Blexve1PLn3gbHSMSpbiJOVaU
         6Lqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746306779; x=1746911579;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FxSfhsCEDNJtIfclTFmU04xWQhYR9A6GsTGzarhRRY0=;
        b=XSkGad0UIt/rkprSLR0b+Xsrl19X/MZMG6F0SSXXDwoUfVEz5sv+SiC5/PlAcU/UkN
         dn5evqBDEAdSnZzKmJvDC09SlR4bX/Zmgv/a/nqtnl8ak25ZyE2ZZxUkwjHiqbhgz+ST
         ZVnx0rW8urrCi/Jg5UMnf6f6bcalp1mFILFCICgWqzgmreYJDJf6VEoEty2lNGhihHYZ
         jPfv3JvIoF/ggNQFl94wHl1rW6jmacHquSp12HRNOzsj666J7C9A4jZtkzHpaIKbZCkA
         kd6gY4D8MAcaoCwkkD/Kk/x2qua0JJuoTqrqTM9FkeVaaC6Qmy/BG/EQkLErOVQqnUeS
         rBZQ==
X-Forwarded-Encrypted: i=1; AJvYcCVLd55fudLxgQY0YFB/1grAMGntjFLZ3a+zvGX9C7hcJiNW6EF12NkOLOz+zxOfhBmy63g=@vger.kernel.org
X-Gm-Message-State: AOJu0YzlSU7KarVIFv1OM7RJtOVmt5X3qAaB+rQDy4wgyiU9AbWNdnkm
	2BRtehksA0krRyrXuNBI1JXRSPRPEo1+719dd6ZkMK4WerIxIEfhQLjB+j1nJ68=
X-Gm-Gg: ASbGnct0sS9wQa5gT4kFNeUNyKsIQfO8/07t8mQ1F0yrWE2l0GzwWwMpsJAUIEX/2/x
	gOiRm+QL8h8xpmPcf3bCMd9evYz5m/WqzAibNyFNbe5BIISEnj3RNgQ+UEgqsnIhYgDSSxzPfbB
	nZ9sXrClCE8o4ttybI3Pbpfl2l8NwZd6GbMQUcoWwDKZo0kExQGaH0Mq8l0BnJmVQqDTodJyv6l
	EGbqomMsYG9v2BShm6otfQ/3xqMC2N+3qQFPCTLz/BOMChIqtfIaNsSBKCObIujFDsw/oZHKuGH
	SZuI9Z6ALZYE8hC4Xq09T9fiKLgwY1E5t0FVwK7vkdtUv0xJM++Lyg==
X-Google-Smtp-Source: AGHT+IHHbxgpklJE0pRyZPQFcgtWhZTRnAvHKQ0lglf6LsP44nmUvYmM78Y0ePXBX3qPyZfyfd04cw==
X-Received: by 2002:a17:902:e5c7:b0:22c:36d1:7a49 with SMTP id d9443c01a7336-22e1eaeff29mr35613615ad.53.1746306778976;
        Sat, 03 May 2025 14:12:58 -0700 (PDT)
Received: from [192.168.1.87] ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74058d7a225sm3775538b3a.23.2025.05.03.14.12.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 03 May 2025 14:12:58 -0700 (PDT)
Message-ID: <20fd4d83-4026-4cee-9d41-9f0ffb8ac75f@linaro.org>
Date: Sat, 3 May 2025 14:12:57 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 06/33] target/arm/cpu: move arm_cpu_kvm_set_irq to
 kvm.c
Content-Language: en-US
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>, qemu-arm@nongnu.org,
 richard.henderson@linaro.org, alex.bennee@linaro.org,
 Paolo Bonzini <pbonzini@redhat.com>, anjo@rev.ng, kvm@vger.kernel.org
References: <20250501062344.2526061-1-pierrick.bouvier@linaro.org>
 <20250501062344.2526061-7-pierrick.bouvier@linaro.org>
 <e8976a2f-b050-415b-912d-3f2231f20fa8@linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <e8976a2f-b050-415b-912d-3f2231f20fa8@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 5/1/25 12:04 PM, Philippe Mathieu-Daudé wrote:
> (why?)
> 

Allow to get rid of CONFIG_KVM in target/arm/cpu.c.

I'll update description with it.

> On 1/5/25 08:23, Pierrick Bouvier wrote:
>> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
>> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
>> ---
>>    target/arm/kvm_arm.h  |  2 ++
>>    target/arm/cpu.c      | 31 -------------------------------
>>    target/arm/kvm-stub.c |  5 +++++
>>    target/arm/kvm.c      | 29 +++++++++++++++++++++++++++++
>>    4 files changed, 36 insertions(+), 31 deletions(-)
> 
> Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> 


