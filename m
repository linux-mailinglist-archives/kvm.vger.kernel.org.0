Return-Path: <kvm+bounces-51556-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EFE7EAF8BE5
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 10:36:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BEFA7763A30
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 08:31:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9534C328B1B;
	Fri,  4 Jul 2025 08:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ysrXepRW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06C9F328B14
	for <kvm@vger.kernel.org>; Fri,  4 Jul 2025 08:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751617284; cv=none; b=dYhVYb6ioaMOYLyBgtRl8NoSNbabVAHvxfzlzdIQAkEbE8osl19lo0ntqlzuuC7AS4vqYHyKQs97K0ayE6LeH0JIZzqVo9f/By7IzGs4zuRZ9C8DsOwXlVk9LiP/rZ9y7LOI7w6nDqmBEeHzC1azl7IvCLOZOFbt65br8viPLQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751617284; c=relaxed/simple;
	bh=gGR1x1tZv3P2WEXPRlY/O+wuOrzU4JpNao/kbg4S2No=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=G0g3zL8kQD9Rl8yFfg6Eqzy4ZpodpKL1svsjcQp0hl1kvKl8oSRMNo89Owl60W5+bAmyxzfgwd8v0cPXFO8XQm047DvFpLgK5IdS2JXOmAqhUy90/HplKsRhfNRB1GMT5rVBZixhnKERJTBpt8aa+Rr7wn0v4fytIYh2ddIes2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ysrXepRW; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-45310223677so4078195e9.0
        for <kvm@vger.kernel.org>; Fri, 04 Jul 2025 01:21:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751617281; x=1752222081; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=j3pmj4E+UUNkJ1VujNm/R+83vDV6n8W8GdGh9Qdk8y4=;
        b=ysrXepRWmDuqIe+oLgo7XywqvL/Lq93r7zLUI3xk41mC+A4ix8e0BEjcfc8xmNnHpB
         /8GWynMUlUdUsqb71CqDZEFXAihbuhTaHOOeUMJ5Bm3rKgp9uL8clsm4C8zx8fqN7HsA
         KNFTnhwiqu0Iy7bJ8Z9NqbTQVd2lLDfueO/ajqWZwtSqac8uLzxfiC8dgRpJNPeu6+OA
         VooTcsdNED/YkQ2WaS4+n/Y/Y9YYgLoISfxLxHHcSrsGLBdliCZmMd7USRN1Ojmey+Fk
         qDPOWutYTHnkrJsyEMGlAzfJRmg0zu6QFaU2+SHWSvoLnBthQ5PEbyqngU2fRUSeBRmB
         Ikuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751617281; x=1752222081;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=j3pmj4E+UUNkJ1VujNm/R+83vDV6n8W8GdGh9Qdk8y4=;
        b=WI9bar+YTr3imhO3bQe1Nv0AmN/8RnfzwY8IbftLtX1LCgHZBSmj50Typ00uydWSKA
         mn6Axkd3zXN+8psti8xF3QOyUljels571Nwy0VlrSiaCVgnHe8o9pz1O7mwflX7gEWrk
         45sWKx5qzGXL57DPynRsTuVCITckutk7sA1dusZfBlZ3kwmYPpKgglk1s19p/ayiKam8
         23buoZ5BUAwdJisyDZZs7TMKsTXk1gNweVLibYT9xjcNYOcpAvifQsH9eXWfdA9oKQg+
         p59IN481yk8uYOUEXAcyHFIcTtuL2vy2zc/29IqKc8z8Yme4eFN6ABT18PE4T4CnBjeH
         +bpg==
X-Forwarded-Encrypted: i=1; AJvYcCXVcd2qzexF5UaXL8Xgs0kgh34lx9uEWnqnvYhusPjeg9D0okmpOObrZ4Gt4dDnJ49K1tE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyq9BPEE5qT4VykNIhKZcHWi+XPiWB5HprZEz82HJe0sFd/4ApM
	N3P13fFfIwjt25CFo1jK6eDfahkLPov83/o3UN97YVFznyt/zoN3cI+s24FM2ZjULbg=
X-Gm-Gg: ASbGncunyUGq2qcAUa8GMKNxeOMvGFAdtKpo2EV4bgkFojLGDZh5M6Qe/YiReed2UEU
	aKCxn2GNmQumaITxDMzG1bQkGIsmduyOV75FSy0GQ+JAa2Nu9pdOSwIA+7cRR9Y2XZn9ZLMZyZZ
	c8H6sGf1t3Agqu/JZAMR/dfl6Nl5XuGHtMH/AXZuU1oei+0xYPv6E1CYirDynKYk1qMihx5blFn
	7sGNkIEcIbrI8wM+2PkGFVq1+6bhdZIqyysPSZAfX3yzsi4rhr40YWTbynCvCGNMRd2ztTfcUcQ
	k/N+/b5ts88KF5z51HmdTjyM5C2oKMYzUQpPVT5/Yt4/y1xjP9f1cUyn2S8dL92gMc45WOmGp/k
	cBhZb92noL2UkQd+r1AGGG6Nd3vMt8w==
X-Google-Smtp-Source: AGHT+IFvZWHBNDiai5xFq7PF+spIVJPNCfa7GkoFOOIkcg12a2z2991uw8TwcVM4nKHvVswmXYMI+Q==
X-Received: by 2002:a05:6000:4a0e:b0:3a6:f2d7:e22b with SMTP id ffacd0b85a97d-3b4970131d6mr715821f8f.18.1751617281181;
        Fri, 04 Jul 2025 01:21:21 -0700 (PDT)
Received: from [192.168.69.218] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b47285bdf8sm1817467f8f.87.2025.07.04.01.21.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Jul 2025 01:21:20 -0700 (PDT)
Message-ID: <ed12ed2f-4526-437a-a3ff-95e20dac1582@linaro.org>
Date: Fri, 4 Jul 2025 10:21:18 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 21/39] accel/kvm: Remove kvm_cpu_synchronize_state()
 stub
To: Xiaoyao Li <xiaoyao.li@intel.com>, qemu-devel@nongnu.org
Cc: Zhao Liu <zhao1.liu@intel.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Pierrick Bouvier <pierrick.bouvier@linaro.org>,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>, kvm@vger.kernel.org
References: <20250703173248.44995-1-philmd@linaro.org>
 <20250703173248.44995-22-philmd@linaro.org>
 <06dc9c3c-ccd5-43e8-82eb-3198c7f358a6@intel.com>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <06dc9c3c-ccd5-43e8-82eb-3198c7f358a6@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 4/7/25 08:02, Xiaoyao Li wrote:
> On 7/4/2025 1:32 AM, Philippe Mathieu-Daudé wrote:
>> Since commit 57038a92bb0 ("cpus: extract out kvm-specific code
>> to accel/kvm") the kvm_cpu_synchronize_state() stub is not
>> necessary.
>>
>> Fixes: e0715f6abce ("kvm: remove kvm specific functions from global 
>> includes")
>> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
>> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
> 
> Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

Thanks!

> 
> BTW, as what you do for HVF in this series that moving vcpu methods from 
> hvf-all.c to hvf-accel-ops.c, do you plan to move 
> kvm_cpu_synchronize_state() from kvm-all.c to kvm-accel-ops.c ?

While it doesn't seem obvious, I'm trying to consolidate the minimum
in order to have split-acceleration. The proof of concept is with
TCG and HVF, so I'll not do non-necessary changes in KVM.

Regards,

Phil.


