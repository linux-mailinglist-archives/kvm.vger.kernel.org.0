Return-Path: <kvm+bounces-40259-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 84858A55190
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 17:43:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 696893B62AE
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 16:40:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3BEE233721;
	Thu,  6 Mar 2025 16:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="VHLuIBES"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37C102139B1
	for <kvm@vger.kernel.org>; Thu,  6 Mar 2025 16:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741278916; cv=none; b=j8iX4dEi5ZCkzVq7IGAySzQBIOGjRaNminvkG1FfFRqxkx0qjp223yGGOFWFYrcYYjCe0ipLNEiSNiSOXxsGtYShq55LnPAdbodzyOQOYe1rm7KhJV50Ce74ujsMUFCoyeCMsyEP3ZzAeTsbK6QA1qJMuBIXncG+Wqv2DOe35VE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741278916; c=relaxed/simple;
	bh=SzXu68XidFKmUWSScwil/WhCxIASGl9WLj7OPIkOOYM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iDV5N/kIUSx43oocS5/qXxdAeV6MVmYabajHPT8QexiVYMvTU/JT36b1/NkuiRx3H72KsdOGD2yV437AiPYDqiPQOy2N5fvyHwwuycThqfaIDiml4aSdYTyyDtutdPBu0qE86qVbM4GzxSI5mZvVNl3PpWcGiv3who9s3C4xQrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=VHLuIBES; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-2ff799d99dcso469877a91.1
        for <kvm@vger.kernel.org>; Thu, 06 Mar 2025 08:35:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741278914; x=1741883714; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=omg6AjvLFckyUHlNxe3aevARZ7znM3QKeiz1AMsa4Ew=;
        b=VHLuIBESEFPPuh651C0IHtSDoe8Mr0fIdi+k2clzOqjG9qP60m14eJvege+koaEI+J
         3CJdknAg2bc1Rc4Pfq6+DDpSFo7/oZaQ8GlRspImpETjeOMfudFFWsQFq9BbmqifGCyt
         tFrkotMij9bQkOXp5RhQmu/UQfWeNUkO1/g2pD584wff9dBzU2Sz48mOKQQ6i8kKCnCC
         yNVKF30xGZojFhjuL4jFEfbukhTzULqRqBleKxlCg0L+ezdhhImNW4scaBsil3bD5zFR
         kGMzfit9tCawRkZ//p2F+4l3h20KKlXIBS6Y8QSNBJh2odX/Mg28Wz7wOtBygnJQfOEV
         dKSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741278914; x=1741883714;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=omg6AjvLFckyUHlNxe3aevARZ7znM3QKeiz1AMsa4Ew=;
        b=mp0KRS8Soqk4fGLrfVBgQgIHbyAvm3SXxheh3lZIMPzTe3A9jI9D8ZoOf4zShDjrOh
         NQkU3tYJ/FyNKdhPPvvXp1nWNi6jWm89qJwgX8oMAN4x8uKVhmYaVOLdzbQuf5a4FBGO
         IC9AlKoMAhfATC6SO7+1WpPJKYrPmSfrsIYzhBL5b+fOkA6Otlp8V2IOAkEW5KbpmzxK
         DAnvPzx32hM3iNDRpf7aMwOU3M+UEQ1+WYNSC1GZqtulcU+efmo4Bc2Gn5TNh1kW/0p7
         DfJ91Sq07v+dZ39rT2Z9zVM8n8403Exi61emjBrPL0mrlCUr4H/IuYBY7doWDHExibD8
         CAuQ==
X-Gm-Message-State: AOJu0YzhqGgSO79lpJ+OpJNmfjRq2aDudD4GZzxY8XPSkGQy+mBWyrcU
	6xSIyG/0jU5UrdrZLHO3f7te7kFDyjnkhkiA6GgTuM9oQ/Ze1PtdSVDQtvx4UxI=
X-Gm-Gg: ASbGncve8dBZeaGliRbh+VUVwci1as4VOKP+/bwCmbe0EvQ8FYpUaN9uhG62as8He3W
	h3Y2tl8dvBXmTXb2Ctmy3KJJT0mCjysgc5oMtQq9PdVNvUxDIQ6lZlCBa1xOYkeRyFwOadmfUXF
	vJ4yvkTFYDdUl3BKaWNPpqu/DGT3Z4VGEQyE8CV+OjMFQBSt4uucc+QiP/L1qnqSQ0fix4/cJTP
	QLZgHWEEcwWVdXb6Gjn5I2DYb/bHWR90PkDpQmtSgA0ECYpBC5GpZAI1sXYnhgFOgNLZCjTCrWY
	OjzogQfJliCRmI3HmKLLj4SjkqgHqtO5I35TsDC1BI1qqGI1VPruV3sF7g==
X-Google-Smtp-Source: AGHT+IGqgyU+nSbO9JD5HQMa4r81ruZjtNfVLorH/amNd+rJA/+OgMQY5I7W07lDvlJwLRGOFlF02A==
X-Received: by 2002:a05:6a20:7f93:b0:1f0:e84c:866f with SMTP id adf61e73a8af0-1f544b16311mr264503637.21.1741278914529;
        Thu, 06 Mar 2025 08:35:14 -0800 (PST)
Received: from [192.168.1.67] ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-af2810768a8sm1275071a12.4.2025.03.06.08.35.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Mar 2025 08:35:13 -0800 (PST)
Message-ID: <badcb867-64db-4b45-93b0-fd4ff203c35a@linaro.org>
Date: Thu, 6 Mar 2025 08:35:13 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/7] hw/hyperv: remove duplication compilation units
Content-Language: en-US
To: Richard Henderson <richard.henderson@linaro.org>, qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, philmd@linaro.org,
 Paolo Bonzini <pbonzini@redhat.com>, manos.pitsidianakis@linaro.org,
 "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
 Marcelo Tosatti <mtosatti@redhat.com>, alex.bennee@linaro.org
References: <20250306064118.3879213-1-pierrick.bouvier@linaro.org>
 <0226e9d5-edbc-417a-8cf0-8c752f52b7ed@linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <0226e9d5-edbc-417a-8cf0-8c752f52b7ed@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/6/25 08:26, Richard Henderson wrote:
> On 3/5/25 22:41, Pierrick Bouvier wrote:
>> Work towards having a single binary, by removing duplicated object files.
>>
>> hw/hyperv/hyperv.c was excluded at this time, because it depends on target
>> dependent symbols:
>> - from system/kvm.h
>>       - kvm_check_extension
>>       - kvm_vm_ioctl
>> - from exec/cpu-all.h | memory_ldst_phys.h.inc
>>       - ldq_phys
>>
>> Pierrick Bouvier (7):
>>     hw/hyperv/hv-balloon-stub: common compilation unit
>>     hw/hyperv/hyperv.h: header cleanup
>>     hw/hyperv/vmbus: common compilation unit
>>     hw/hyperv/hyperv-proto: move SYNDBG definition from target/i386
>>     hw/hyperv/syndbg: common compilation unit
>>     hw/hyperv/balloon: common balloon compilation units
>>     hw/hyperv/hyperv_testdev: common compilation unit
>>
>>    include/hw/hyperv/hyperv-proto.h | 12 ++++++++
>>    include/hw/hyperv/hyperv.h       |  4 ++-
>>    target/i386/kvm/hyperv-proto.h   | 12 --------
>>    hw/hyperv/syndbg.c               |  7 +++--
>>    hw/hyperv/vmbus.c                | 50 ++++++++++++++++----------------
>>    hw/hyperv/meson.build            |  9 +++---
>>    6 files changed, 49 insertions(+), 45 deletions(-)
>>
> 
> I'm reasonably certain that hyperv is specific to x86.

That's correct.

> Are these only "duplicated" because of qemu-system-{i386,x86_64}?
> 

Yes. A lot of duplications in hw/ is related to 32/64bits variants.

> 
> r~


