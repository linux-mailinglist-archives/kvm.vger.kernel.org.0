Return-Path: <kvm+bounces-43816-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9AEA3A965B5
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 12:20:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6777D7A486F
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 10:19:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B13D620DD7D;
	Tue, 22 Apr 2025 10:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="B3UNRDiL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20C4D204689
	for <kvm@vger.kernel.org>; Tue, 22 Apr 2025 10:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745317227; cv=none; b=Cfgk+obzgc0m16ChuSHt76pLH5OpA9Ml4Wjk9UJQn3TMJpFJ/14FGlK6sX3QlUEq2BQ+6aX3NhqHJN4Hf6hPYW8QQiFNbbGr66xrnZW16npB/TBY37e47M/84hs9HYVedItI4XlUEBPOH1JC+sFF0a6bvgGUu73QdfPaJUg2z7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745317227; c=relaxed/simple;
	bh=YdbfQlGUGOXyKhbsXVQD8RS/6LOk2JpRZ6NF2vcjmBo=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=AW+QasMqKwLJbRwqCbvfrQ1X8GexhtPlTl5ly2ER2ycGedj0M6IBTHXenn28bd31BNKBj6b6yN8xQWn0q0/kB1X15XVZB2yL4vKZ1IWbeOo7QAfCxZoy1sBCbmgm5gKUfkUoAj+Sdnhui18Y4eR+mYomnTvI9NrPolN/RMr9fYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=B3UNRDiL; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-43ce70f9afbso42608555e9.0
        for <kvm@vger.kernel.org>; Tue, 22 Apr 2025 03:20:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1745317224; x=1745922024; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bj+0Q+EB1V2pPyRxQBEmN/DJlQu1UVnuS3zStM7Ud70=;
        b=B3UNRDiL/vCQHPLqFZZQGksG8JMLq/5huJH9aKhaXZk47+BYBRo29l7XmERCF/cZak
         nAZ6SDurrDgzqxirMEkoa3n2j0QIZ9WMBJmZrD1NoHZ/NDPxb4Un6H6IPN8M3mIgfX8Q
         pTW3rU0YQ8AQZUG0V6RnwOAB8zcWmNJJEvY7luhINwQO0D1O1fqMj/YnO+THyl72875d
         jhZvGTNQJ46h/hjHP/YyU/w3b2eziKMs34yzEUpzovYRxsIbVXHFRQ0APMh6anfJ5kh2
         Nj8ORoQMDyocM8Q6Fuo0znL3qushiAOpqUfEFrbd6u7p3Z1SeB91ATeh5s1OPtPdAhnu
         ZBbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745317224; x=1745922024;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bj+0Q+EB1V2pPyRxQBEmN/DJlQu1UVnuS3zStM7Ud70=;
        b=uF1HG7viTUVtLnhh6gD5iN9kC1bf3GOyPuJS88Rn/x2ExB+NBoL26VQIqmgcTcmKTM
         dYmqihkQBcLZCV9nvfSesNX2gG23731zFryp+jf/tLr7d1dtMBxGZkcXq5vhfpwnTEtt
         peXIA0WOxp5Cb/Z4twzEEULqvVlwK0Fmn8T3GMNLbDZJEdp6nEBR1EXHsvV+y3IKQTy/
         XyZSUUfPxvBy8RLBZlbkdWFpsyzVdxqBoCORb8TVcCyauVhM1AMlLNqln/xcOEO3zOl2
         hOhsOZOMOzsM2yqZ4jazuFQrcu7u/qV0g+Q5SB68TmQZ0LjLrYvGNvwnkP4nKVviyQfV
         EMnw==
X-Forwarded-Encrypted: i=1; AJvYcCUHbwnjEbqmhwHbKzDGRr7+HVk4vj9T4CSpZI/5ogdG5MVjdGyLSc6Llymg2t7l97sjotc=@vger.kernel.org
X-Gm-Message-State: AOJu0YzPcuJr1LISJxO1sXfjq0rL6E7hQx/9ZnNfyw5hpXwXvh68wYXU
	+XGSoNCadSZ7X5p1nrX/CKeMnWUpHBCREuCJlJ5hWWJIFyUKCXWIa9kUNFJru/E=
X-Gm-Gg: ASbGncudwHu3JMM4tWhfygo1ToZpyF8l72UUHFGBbt1dX0gUZPiY8SoafYApJB3V7VF
	HmSPpH8wWk6fkwUzYJY/A6Vk9FGcT/CsJLkNJxKzvToB+UjXggL+/EYLkmTrbhV/34zzRA5Ybsl
	IFazpyyyfS/N8g/WtA+MfCaBEVCmr+2Ufh/hIHRY5IlBl+NTv0vBXjddLgfNqddDhnmdWeflxTW
	sAK8oM+sZnHC/Eq+now2VsUq/gN8f4T8UyxYwWILYWdNFeQyWClSzMJrF8/CxKnWCHMDirsbYHU
	uD+uWLB0pdbvcgmaR+RIGxPxPlPPHpPieZSmg2QU7pZTj2wsq9TDEC4OSN2Sd71JvCe+BZC5X+u
	S46hmsejZ
X-Google-Smtp-Source: AGHT+IExxiC1/7BEDxlUOLO/mtxEuxbqvG4oZX6ER4Jw2XdzzKvzbDTjBvuvcHjBv9h1dlP2oFw8qQ==
X-Received: by 2002:a5d:6d88:0:b0:39a:d20b:5c14 with SMTP id ffacd0b85a97d-39efbad3217mr11799503f8f.36.1745317224351;
        Tue, 22 Apr 2025 03:20:24 -0700 (PDT)
Received: from [192.168.69.169] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4406d5acc5dsm171044195e9.9.2025.04.22.03.20.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Apr 2025 03:20:23 -0700 (PDT)
Message-ID: <fff7f6f1-8fb6-4ff9-8f13-cf0e2a9ecb1a@linaro.org>
Date: Tue, 22 Apr 2025 12:20:22 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] riscv: Fix typo EXRACT -> EXTRACT
To: Alexandre Ghiti <alexghiti@rivosinc.com>,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Alexandre Ghiti <alex@ghiti.fr>,
 Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>,
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
References: <20250422082545.450453-1-alexghiti@rivosinc.com>
 <20250422082545.450453-2-alexghiti@rivosinc.com>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20250422082545.450453-2-alexghiti@rivosinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 22/4/25 10:25, Alexandre Ghiti wrote:
> Simply fix a typo.
> 
> Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
> ---
>   arch/riscv/include/asm/insn.h | 2 +-
>   arch/riscv/kernel/vector.c    | 2 +-
>   2 files changed, 2 insertions(+), 2 deletions(-)

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>


