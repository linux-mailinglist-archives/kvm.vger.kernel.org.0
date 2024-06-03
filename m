Return-Path: <kvm+bounces-18649-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BFCAF8D82B5
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 14:47:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 578251F26B63
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 12:47:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CE8112C48F;
	Mon,  3 Jun 2024 12:47:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="y4yUZalk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4000126F1A
	for <kvm@vger.kernel.org>; Mon,  3 Jun 2024 12:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717418860; cv=none; b=Nl7vsSfokrCdchRvR4IGcUYTTSEHRDqyqsm1AltfgcQmbemiyoF+0UEw9Q1rPhoDrnpMtr8MIx5Q0Hw2rRpcxZ8z7spUgSDs9VHYKqWl9yZ5R4Vb9n65o8LOTEWG5SdLk75CI/qbMDBV7H3EG13kn8fRpfQidtEIe6T311cVw/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717418860; c=relaxed/simple;
	bh=M8yDTr3m8K0h0UWYDvOqEEINKGHymCkvcjTLh2XNSUc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=W6oaDzUghVACO+mdWrTxYgqo1ZjRcAL8ugwrKJaOjZxl8v7WiAZvlmJgTa1j0IXN5JXJ3+sPEnaX/yuadVPNeR7yuqLa3pY+2Wsy7aPc2VkzrAJKhA41S3E+6hKcvtJ76XyL7tSclSpAMLpxuTvn09BX/LSsAhTNKxekpHxrkNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=y4yUZalk; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4214053918aso3904135e9.2
        for <kvm@vger.kernel.org>; Mon, 03 Jun 2024 05:47:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1717418857; x=1718023657; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2nm0+/6xX/ZOx6oKob8AyaKy3xj3w2769d0XEcDzBLE=;
        b=y4yUZalkMYHnmP3pXQJ6j/ZCLhjt3UBFrEDPf0bhpUZmYx4qK1LPjlQGkPShtHzcYr
         VyHehFXlvd67ESdudqFqvGxyw/DMccVG4uZicc897EiZ0UjiOIcREjHQ5IbKL1HkujHf
         sPZKVyTbGsyyemLOw0iuwCEZEgZOK6OWYHLl08VDZuz1OhsuyL4+7XFMZ1SB0QL7uFBp
         NO3dO/RHVtLLvosseszv22FA/7ChPPSOcrkVZUZ8FsULGUDoxPaxlHmRxfZYpTh/bmMe
         b1TyR768FGZNc+slzehydD/RhLQFOGsh99HgeWk5XucwuG8s0255tOhENgAAYjwlXtDd
         BOkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717418857; x=1718023657;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2nm0+/6xX/ZOx6oKob8AyaKy3xj3w2769d0XEcDzBLE=;
        b=G8e1yUGHtmzLQ702xg4NQ//AQKLFcTJmVK0WJBi9SdKTMt7Zuoi2S28ZpXGMopAzii
         YC27bnRB84qY5ih9OEidrtYKigZSSSSqk6Xxo4za43lZpqwb7ghXiAjIzHNQhZx45iS6
         q+ZxMISkzeP0MZQo61Uz5muu0QuvhdXv4bwH+IRkYsbREu7Eghv27IJsuowiN6zhzL0e
         +WwIQtRhK25x7txTYailqtIH+3/gybbeIdJvlZd5h3s1Nj7jil8l+SHDCFF9lqhc3HYw
         YkxyRxHOhpfhJYAyEpqLQ+VZXsNDE0XJ6g2VAoZu882xMhWadcrHwrB1wFKN5AttIR+p
         fq6Q==
X-Forwarded-Encrypted: i=1; AJvYcCUr+97uZa5PGLrNPd49Pd3QIVPy1qx9RsiuOdhnFuw88oiWIUY/fvdxhpBA+OHndFqYSTuKAYgbibFC5bkWkMwfsTUi
X-Gm-Message-State: AOJu0YwPK1Dp8s0h+aQ16geSlS6PcY0MtZ17iLXGABKfyq97LlUAFtao
	ZaNKgK4o1p/1TBAAzGX+LOE9WyepdKnH/KiGoGjuQGH/GpceQnmBwZTo78RlArk=
X-Google-Smtp-Source: AGHT+IHv/LN4GCaL0Zj9xEm6MRRaFOZbRvvE1y5ltu596ORAUKuBOhyxYFt61tLgNZ8w3I5NFg4rsw==
X-Received: by 2002:a05:600c:19c9:b0:420:2cbe:7ee8 with SMTP id 5b1f17b1804b1-4212e0443b7mr61224275e9.6.1717418857035;
        Mon, 03 Jun 2024 05:47:37 -0700 (PDT)
Received: from [192.168.69.100] ([176.176.177.241])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42138c41becsm64480035e9.30.2024.06.03.05.47.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Jun 2024 05:47:36 -0700 (PDT)
Message-ID: <988e580d-6121-4f7f-b7b8-d12cee39be35@linaro.org>
Date: Mon, 3 Jun 2024 14:47:34 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/5] cpus: a few tweaks to CPU realization
To: =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 qemu-devel@nongnu.org
Cc: Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
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
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20240530194250.1801701-1-alex.bennee@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 30/5/24 21:42, Alex Bennée wrote:
> The recent IPS plugin exposed a race condition between vcpu_init
> callbacks and the other vcpu state callbacks. I originally thought
> there was some wider re-factoring to be done to clean this up but it
> turns out things are broadly where they should be. However some of the
> stuff allocated in the vCPU threads can clearly be done earlier so
> I've moved enough from cpu_common_realizefn to cpu_common_initfn to
> allow plugins to queue work before the threads start solving the race.
> 
> Please review.
> 
> Alex Bennée (5):
>    hw/core: expand on the alignment of CPUState
>    cpu: move Qemu[Thread|Cond] setup into common code
>    cpu-target: don't set cpu->thread_id to bogus value
>    plugins: remove special casing for cpu->realized

Thanks, patches 1-4 queued so far.

