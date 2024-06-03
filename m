Return-Path: <kvm+bounces-18656-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5513B8D84A2
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 16:11:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1144A28D34D
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 14:11:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDED912E1CA;
	Mon,  3 Jun 2024 14:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="EvHe7B8h"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 648BB1E504
	for <kvm@vger.kernel.org>; Mon,  3 Jun 2024 14:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717423855; cv=none; b=TWc/qbYeSI905oR4OMtqhJAXwVFF7xJjKeIQzS7rd2zYFWF5K51NK6/wHcaKFqJ9WTFSN+0AKXoAxBMHtrW8YGk3C1wCJXfVjL3PNjufKjr8QC5mtQQSXS/eB19K85KINefszBTHJ5zxz5H6o9e+f+MM0F+EV4V71VAnZmKc6pQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717423855; c=relaxed/simple;
	bh=AM83xGUPXhgGrWlyuXlMUQ0RgnIOrgPbRB+kx03SxvI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XDRtuJmUrVvTPTWCwL3UCi7DPhRRxyHLjGwggnJWbkeXCyMhIahiwIz4+nOa1jqwRDSIK2nEPpFRxjoqn+FS8jXZOoMRGM/yv74g0+XO8cNQmAcvU0Snlagl9p0EXspOSDnMHqw2if8OzBreDmDRrF814mCPY1+eOHO5d+bY2JA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=EvHe7B8h; arc=none smtp.client-ip=209.85.167.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-52b98fb5c32so1603631e87.1
        for <kvm@vger.kernel.org>; Mon, 03 Jun 2024 07:10:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1717423851; x=1718028651; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=C9wFY8wAGo7wIkGTxwt2dSj/9aPkgjqVMzXQSzjbvFM=;
        b=EvHe7B8hUm6qfRqs2t0i1dfTo4D0UonN4kSSqT9sgqmiU9V66ZBz4t6QALVymx0bmj
         vUEZUq7p3WVS4xcQpnkJyaZQj4ZbSiCwlAMUMFP0B8BN2oztO2xPK9Pujz+ZkQ9m5Jxp
         nVZ6jg+7w9qFCyZTIdIVipOs8tfV9SjZ9gaJ9+MkdCGCGsL8TyoIjvsTu1s/Xk0dstUA
         E9oKtLhaSSuhD0RsKMslYEyNIid0btGdmtCKjO2bPwL94dhasaQbifnklKiK3dNvXWHl
         97AWVKGjXgDgdeyio1i1b4dqEn4zXfb0QokqR8Jk+95KmDCv7mVEHX1IoYmKaM1Ykdri
         E04w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717423851; x=1718028651;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=C9wFY8wAGo7wIkGTxwt2dSj/9aPkgjqVMzXQSzjbvFM=;
        b=T0LCGnBO7+XemgKncLlzE27GJhuwPTDpdIZESsg0i5StBzZqeG/is2ao0WxYQ5/lIV
         mc+vmBe27RipiBLQpFyKTpUsVhoJiulGhIobMTOcUko4YVgMwUHntUI6jsFcUOBGg9s5
         G/Hm4CLifc0RrTfL73zJmkZSa44srbSX/9M07HyvZSXK0QAzEJwzQx1qLLrA47Z2es++
         lQBjL6zRm8NvhVtNgDQeUGhyO12ndCg/hBwbCt7yAKwAGXq7RjBhb3vFyzkTTODQ2vJt
         8cBPqSi/vW1lacXcIeOwGsl6F1NbT5K1yqKmdKJ3TuqeUhQ0w9He0ojOt3PFcmI/PdqR
         GBqA==
X-Forwarded-Encrypted: i=1; AJvYcCWb355g6glOu/0UEL9UVtob7SnU+W8jLQ5kOH4V2blyD6t4cwbF657kNRK1WmHdd+mvDLC1NtPWHKIql7QhsY80bmbn
X-Gm-Message-State: AOJu0Yy6Hudd2wxM4oyoMf/uxXQ8lWqXQ/Z0dL76BQa6TOVZD+ZLrdwD
	T01YZ5JeMl/2h58ht5V4frQG+j4iuhBhkD5zYrjRnxc1SnDwaXyme4oXQl0f2kw=
X-Google-Smtp-Source: AGHT+IG6FLaHU1FmWa9jBBItRKFhE4J9xvwY+NVSV0OPx0aVujX+O++BJxFCuH/n71GMMXd6PGtISw==
X-Received: by 2002:a19:f603:0:b0:52a:e7c7:4ce6 with SMTP id 2adb3069b0e04-52b895633dbmr7294067e87.39.1717423851458;
        Mon, 03 Jun 2024 07:10:51 -0700 (PDT)
Received: from [192.168.69.100] ([176.176.177.241])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a690b2703d9sm163919966b.150.2024.06.03.07.10.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Jun 2024 07:10:50 -0700 (PDT)
Message-ID: <3b4d3646-ea0e-46c3-b7e4-7efb22d53d3e@linaro.org>
Date: Mon, 3 Jun 2024 16:10:48 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/5] core/cpu-common: initialise plugin state before
 thread creation
To: =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
Cc: qemu-devel@nongnu.org, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Cameron Esfahani <dirty@apple.com>, Alexandre Iooss <erdnaxe@crans.org>,
 Yanan Wang <wangyanan55@huawei.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Eduardo Habkost <eduardo@habkost.net>,
 Sunil Muthuswamy <sunilmut@microsoft.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Pierrick Bouvier <pierrick.bouvier@linaro.org>,
 Mahmoud Mandour <ma.mandourr@gmail.com>, Reinoud Zandijk
 <reinoud@netbsd.org>, kvm@vger.kernel.org,
 Roman Bolshakov <rbolshakov@ddn.com>
References: <20240530194250.1801701-1-alex.bennee@linaro.org>
 <20240530194250.1801701-6-alex.bennee@linaro.org>
 <1c950cd6-9ee0-4b40-b9d6-3cc422046d65@linaro.org>
 <87a5k6cqps.fsf@draig.linaro.org>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <87a5k6cqps.fsf@draig.linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 31/5/24 10:47, Alex Bennée wrote:
> Philippe Mathieu-Daudé <philmd@linaro.org> writes:
> 
>> On 30/5/24 21:42, Alex Bennée wrote:
>>> Originally I tried to move where vCPU thread initialisation to later
>>> in realize. However pulling that thread (sic) got gnarly really
>>> quickly. It turns out some steps of CPU realization need values that
>>> can only be determined from the running vCPU thread.
>>
>> FYI:
>> https://lore.kernel.org/qemu-devel/20240528145953.65398-6-philmd@linaro.org/
> 
> But this still has it in realize which would still race as the threads
> are started before we call the common realize functions.
> 
>>
>>> However having moved enough out of the thread creation we can now
>>> queue work before the thread starts (at least for TCG guests) and
>>> avoid the race between vcpu_init and other vcpu states a plugin might
>>> subscribe to.
>>> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
>>> ---
>>>    hw/core/cpu-common.c | 20 ++++++++++++--------
>>>    1 file changed, 12 insertions(+), 8 deletions(-)

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>


