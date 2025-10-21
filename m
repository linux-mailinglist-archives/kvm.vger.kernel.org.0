Return-Path: <kvm+bounces-60637-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 193AABF54ED
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 10:41:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 7551F4EFBD0
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 08:41:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36AA9313287;
	Tue, 21 Oct 2025 08:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="i5Lymd6h"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E505D30EF96
	for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 08:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761036087; cv=none; b=r/jfyQgfatXN6C40Zk88KuqojT4AURe5q+06dess8fnW8/1C+OFa7PKfCWY2Vsy83Y3cBez+EmhFYXVcgZ6vo72SkSAwhW4/DJvwkltRf1U1UF0BGS+iMjkoDE+E4m4ANesPm5yBBwJ+GM2IfxSnzHcpJCh18B2rJIMExeRUBHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761036087; c=relaxed/simple;
	bh=LBADrxNxKjw6LUjhAVUYXg0fBU7nfzEQZnQ9xOPY0jI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=M4GJ22O0QSbfU0Zgj8YdwBg5fcbtWKj53G15eaH3x/3u7nofbTtT6YGdEroH41MS6XnQeRuf+RzOsvbv0Ek+PbfT/K20bmieRRSwvbEM3wRs6eV7yqGsJUuBK3CFLPTYCabqeZfQP9+lbfU+OJML9RSwnn8+6QKF7+DasFHC2Qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=i5Lymd6h; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-4270a3464caso2278087f8f.1
        for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 01:41:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1761036084; x=1761640884; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9pdjAhGPOKbiWGXRfMs4/Rv2ViRZ+hqcx69OXv2qTHA=;
        b=i5Lymd6hVCw1UZewfia+NjcIvV5bzhvQW/yIFKieGGJf84U1UDBuB+wHvVvn7Emj5v
         /B5lMbAHVVvavpbTC+sOWlHZ0nFnMBoazpsH2xahn1n5EHdkxXEGtW4r/xSfBGIdV7P4
         C3t3zdsO5e+xQSDzgytOfaGOKI95wM6Y8tGWzbcOwrItnfDXFHyed80jqWGH2O6CQ1sy
         3kHaiwaegce8sce0htXMpD/IN7nOBJ4G05EfdXIW/kAp5YBaH2kJomKsF1ezvLp034Mo
         Sc+TEDjT6OrDHwDSaBj9mI5t3jXYfqYLbEoQ296qa8kVSaqbTr9oouaCfBvfHhBWUfz1
         0JhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761036084; x=1761640884;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9pdjAhGPOKbiWGXRfMs4/Rv2ViRZ+hqcx69OXv2qTHA=;
        b=l1EsakDe9QwVi9JFQQAUJG75t0dlwYmrna1wI7uSFrTpErqhO2YxPeE3Nezvpp+Cpn
         FLN6CVLi8KzY77smgL4VnoR3FsHJvIxwKWJgLu62jEOz2sG5KbZykXBdhCRMwZogfz7C
         RLO0FIS5c7IP0h17A9R06a44yc22iqxM0RMe/pQCh3KvfY4uYUhvPcqhVYoRj77tMzZC
         rcI80iW/QUxdsk/4hZpJhywt3kvjI7E3DX2LFdC4dr0jYoxZRU6vJUiz+N4uDqWGhoBN
         FcmrIbXW8F2xFDi36hRapkV4D9WYBOjlBpLpb0I2YnuBcBqDeM3YbZtvrt5m2fBVYpr5
         189g==
X-Forwarded-Encrypted: i=1; AJvYcCV0yxnNEB6lWuireJQAk45+VoTaTShyqNccE0oQEaUWDZ3Gq7D3Zc/2nkQ4Ww7EFNgEnDk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwYV5zThmq6qwjCEgkJxFWeHxT/ZiEzQOw/9sWJUm/CHVxmM4NF
	ic4vYvVpyd5t6sY4lc10w/vQBA3ujI7K8mMBfdbLlL/8/EX+8TFKnrReQqDOK1RO0VU=
X-Gm-Gg: ASbGncvrCszF/HEGltDYC8kI10TeZgety9LX6tB4nmdkC98egnNxGN87A8+rPBcf22+
	SnDAYD/2Fc3gbzblWVh1B895F6xShs5pnpx71Wf4ZLANHcCgPbRC7fP01xtK/g/YCJ58H7xkVcq
	9fCJsYL5D5WxUVi1hvGIR5cxiWsA/lc6ZdlQRg1AROmR1LlPBo3BE4rleHSVUQyIvZYj1y3yOfC
	HucTJp4su44g82YHeBNFCCLBLw2FGlPBfeufnvo9hAYlIO10RFkbyublTVRJf/5J/yQKfY+TqHn
	JIkjO6XmjIkgPmfwXWcwZgNx/al5vgN3+FxKbyA4Z1ruBteD/93KOLGysDpsrwDb5fQHQQJe+1l
	3hkbuhigTYR3EPEFJxBdnPPh8h957dTztk/x/sX9rCsddutVffv6gpR2CiRMAGFqLuQA9z9XQfo
	rYP0tW9qFKU/juaVaDJgbNohX8eCsk6yOd0XYnsjoryp5fYSxZaFD1Bg==
X-Google-Smtp-Source: AGHT+IHLb2hhls7CmzdC5uuJ3k8uDyLGIIrHJLKfQUIGVoKZG6uX7C3odt0aWNSChx6y9ZBdugjjtw==
X-Received: by 2002:a05:6000:40e0:b0:428:3c4f:2c4b with SMTP id ffacd0b85a97d-4283c4f2dbcmr7502853f8f.46.1761036084042;
        Tue, 21 Oct 2025 01:41:24 -0700 (PDT)
Received: from [192.168.69.221] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-427f00b9fdfsm19074155f8f.40.2025.10.21.01.41.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Oct 2025 01:41:23 -0700 (PDT)
Message-ID: <6308d43b-32d0-47fb-a103-9105d56ab31c@linaro.org>
Date: Tue, 21 Oct 2025 10:41:22 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/18] hw/ppc/spapr: Remove deprecated pseries-3.0 ->
 pseries-4.2 machines
Content-Language: en-US
To: Harsh Prateek Bora <harshpb@linux.ibm.com>,
 =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@redhat.com>, qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Nicholas Piggin <npiggin@gmail.com>,
 qemu-ppc@nongnu.org, kvm@vger.kernel.org, Chinmay Rath <rathc@linux.ibm.com>
References: <20251020103815.78415-1-philmd@linaro.org>
 <fdb7e249-b801-4f57-943d-71e620df2fb3@linux.ibm.com>
 <8993a80c-6cb5-4c5b-a0ef-db9257c212be@redhat.com>
 <6dcf7f38-5d1d-47a0-b647-b63b9151b4b6@linaro.org>
 <6c1c6488-679b-4bb8-8fb2-569a9f705ba7@linux.ibm.com>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <6c1c6488-679b-4bb8-8fb2-569a9f705ba7@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 21/10/25 10:34, Harsh Prateek Bora wrote:
> 
> 
> On 10/21/25 13:16, Philippe Mathieu-Daudé wrote:
>> On 21/10/25 08:31, Cédric Le Goater wrote:
>>> Hi
>>>
>>> On 10/21/25 06:54, Harsh Prateek Bora wrote:
>>>> +Cedric
>>>>
>>>> Hi Phillipe,
>>>>
>>>> It had been done and the patches were reviewed already here (you 
>>>> were in CC too):
>>>>
>>>> https://lore.kernel.org/qemu-devel/20251009184057.19973-1- 
>>>> harshpb@linux.ibm.com/
>>>
>>> I would take the already reviewed patches, as that work is done. This 
>>> series
>>> is fine, but it is extra effort for removing dead code, which isn't 
>>> worth
>>> the time.
>>
>> My bad for missing a series reviewed 2 weeks ago (and not yet merged).
>>
>> Please consider cherry-picking the patches doing these cleanups then,
>> which were missed because "too many things changed in a single patch"
>> IMHO:
>>
>> -- >8 --
> 
> Thanks for highlighting the delta cleanups, we can take care.

I'll do the job and repost, don't do it.

