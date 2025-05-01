Return-Path: <kvm+bounces-45168-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 06971AA641B
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 21:30:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B0D009862A1
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 19:30:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41EDA223DFD;
	Thu,  1 May 2025 19:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="k2d7SI4z"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E34F018DB3D
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 19:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746127847; cv=none; b=FGFyINe/op1tsyMZJWauUDfDVuO8d9/zikL60TlsQkDOAx0/Bg/j8YWStCmSYjPDAcDezB4gID8nufoyB1gGN5uBKtr34+y5hxSqJBIFQAQPgBwpRedz0zJj9uUqgGfJW1mE5T7xUBud+19Ui/KION5fDn2MY4gHhBp0osna+mM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746127847; c=relaxed/simple;
	bh=3FG6wch8gdgO1x29Z5At6RrjDIRgWQf19aciVqU/woA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cgSiSErdr0DTNUtsFdgKlQcjl0ybAUWIYTmfUxpRUm6bXxCWjlmRY/X0r8RyBANVnAUyo5O5RX6PCY7qx5xpQo8w1tKBb1Q7fRKwVIhV87OJd71lXRZarAtgHdWs6QaOtY65+j829WvO5PdXHzAOWaNGP8freMD4D3JHBHNQzss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=k2d7SI4z; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-8640d43f5e0so110259339f.0
        for <kvm@vger.kernel.org>; Thu, 01 May 2025 12:30:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746127845; x=1746732645; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+Hb91IPuLXKJoQyP6cAOpZVHX8T71l5f/umHeyLbAqA=;
        b=k2d7SI4z+Sdb1vDvh/9H9f8lh7+LfFYN5JK1KZ7ooIAcnrMvs41iJTTpUEc99hEC2S
         LWYqwgd3vgSKkkY52pt4Vib6uIptTl+qGkyRyeC3QYAa3RWi9TXb5Xyk8Ak1RJszPHsA
         ycVjEDHO7xvvLf+ze+lMychZLav57Jl1/dSTzQRtAH/ZTadycLFpdQz0z1xsbiU5Cz94
         hnYRYiEJRyjGBqK1M6OJ6Fnpkp2LX/Fj15yl1s0397Du4hTEuifijp3qVUZIgQNrVzZu
         VfP7E5eNV4kHvkI/mW42Cd8H3+UHEZ0BDn9dFSXGf9ng/EqHUwp8DlMF01TSRuOmu6hF
         78AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746127845; x=1746732645;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+Hb91IPuLXKJoQyP6cAOpZVHX8T71l5f/umHeyLbAqA=;
        b=JwC4ot7jHdaeULLus8Pn6RngLvAYI4azDWbjnQs5bYmUXfvBnm4LXiENjqtS2ZxCZC
         mB0VJcId6QhSJ8XAHCG9tZoyZfwG7GwKquPaBHQJFnY0QADGR0xUpBNM985fjTFq/bQy
         xBYxhkA3NabJn5xbzbGI/EN+Hq9cdDbXc5fQh66o85e7zAofyB06QvjU3N5Fz2NcxIxz
         lqPzcD+2Nome0iVh1lebAQ/1/qqwynL4xpqTcoF6BSuOv+Iz2Ll1cyi1YLPyFR1X8tG3
         uMgUVi++6I3vGac0oVlk0WhjfuC6dokSVdjfycNJMFQVMK41gtsFXs3bQxuVMoAH6ndB
         mx0A==
X-Forwarded-Encrypted: i=1; AJvYcCUN5ake0l8kE4E4nnt+Dm3a0DazecjqVTQ8DdlMYf085EgQPT+ub1vvtcs7tVudcRpuDJQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzE2n8znglDa4XdNf8UDcmVYDFMHjLnlmiPdZbaB5BuAPxmEng1
	Ll8g0pz6Pub6CgB0HzosrI88G1wQZCLWrBvDzYat8GOSjblpKth8W9JbwZM6m+Y=
X-Gm-Gg: ASbGncvsv+nJqiHyAgYJjPkIs+BxtKNAoWeMZED5Nzs4MwXKIwc9laINqHTij6ielg7
	miobyAhSrwtGYzeMZWzU4tf/2cQ1/8r6fgs+2HG6bNzYCvqjyn9am8X/qmNXaC2fYT1YMiGl+w9
	avEGLuMALfX8iyx4ElrVLsPdYC0ALcpo+hNxlQTowJhTkYk1Any32gMsx7nWIWmWHSSjbPMNxJx
	bvgXUYI9bkFbJp/kOj1Tn241B10YqFXnbT2U8cOfIomqhvY9PqdrP3QSpRBVFLE8Qco0U8kQ65m
	+o+9Af6zuMVJAX61LyfixSIdHTXpAytOJih7wGWAEGYhJ8RnVBaGr9EUitPC38+xbHox4wU04Ne
	nhFpEgSyNcyij6FkjUWvkdSSq
X-Google-Smtp-Source: AGHT+IEGwirHslwhuIZ9+rShS20f1JaFjO5yKz5qatVFPhxgLt8HRbW4UFj1Y+LjXp1SbZ9We+Nlvg==
X-Received: by 2002:a05:6602:398b:b0:864:4a82:15ec with SMTP id ca18e2360f4ac-8669fad4facmr76490939f.6.1746127844964;
        Thu, 01 May 2025 12:30:44 -0700 (PDT)
Received: from [192.168.69.244] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f88aac7f4esm8058173.136.2025.05.01.12.30.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 May 2025 12:30:44 -0700 (PDT)
Message-ID: <91c5f1ac-105a-4567-b1c2-e1d230d8cfc9@linaro.org>
Date: Thu, 1 May 2025 21:30:41 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 25/33] target/arm/arch_dump: remove TARGET_AARCH64
 conditionals
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>, qemu-arm@nongnu.org,
 richard.henderson@linaro.org, alex.bennee@linaro.org,
 Paolo Bonzini <pbonzini@redhat.com>, anjo@rev.ng, kvm@vger.kernel.org
References: <20250501062344.2526061-1-pierrick.bouvier@linaro.org>
 <20250501062344.2526061-26-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20250501062344.2526061-26-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 1/5/25 08:23, Pierrick Bouvier wrote:
> Associated code is protected by cpu_isar_feature(aa64*)
> 
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   target/arm/arch_dump.c | 6 ------
>   1 file changed, 6 deletions(-)

Should we assert() in the callees? Anyway,

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>


