Return-Path: <kvm+bounces-18657-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F1A2B8D84A3
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 16:11:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8C77F1F239B9
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 14:11:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A44712E1CE;
	Mon,  3 Jun 2024 14:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="qmI6WpFm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B66A1E504
	for <kvm@vger.kernel.org>; Mon,  3 Jun 2024 14:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717423877; cv=none; b=QligBuK4d+KgcrOzA3HLoc8y/QTTyO1kfw+1IUHRb5l+1DaNgl2leo5ONtGEARNssnXDxsixwSyMzkEJ8hcYkU4v91MZkG4h4vbd+tIqr6IFhx/MU2tNzASPELoOPX2apHbA0J0H8y6+Ljvh9YxiRnaTk8RHvuQLsubt/VGXjDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717423877; c=relaxed/simple;
	bh=FymS1W1LswR15xdUj78Z+LxnsxJf6xbG8xxHQ4EyC4o=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=oIWtkI6BWymu7K9wqmylmRAQoD0Sse0lz5UtwGbDxUsLW+OychKnNHVXjI0j7f4+Flxqi9HJzgbNmBtcel8vs3s7HOaXHs+1xtlSueBYRrlHJDNhp1zSP7JHJxznWjOW2QrKA90LKKhlpnK8PKmk8X1tkXpeDCpDJUvJ8aMpPrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=qmI6WpFm; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-a68ca4d6545so292994666b.0
        for <kvm@vger.kernel.org>; Mon, 03 Jun 2024 07:11:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1717423874; x=1718028674; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=dRaDiAL64sssMvTWiBBzGvj163oLeurAnHe5X3Opa24=;
        b=qmI6WpFmntZHLc3f/hzpoV8jQVc7CIw8pvp0MoAD+uw4AP7m/HawxnlUz9n/KIBR5a
         9CuwiRy5Dvb0toXhQABaZmI7os7axW1o3vGZNk6cN0gjOozpGIdK65nclHuqdFoQLupt
         il5Hhj8keTWtZHVBSEyN1Ju+tRVp969psQr5F1BC3FsBc7IcbOyuS2Kq99G237iU/jHm
         HK6NFDKFlBOR+ccmHb4UgzBDgNWGmoDpMKTF2pQ4+XSigdstlqEsfQfUdRUZ7Mj12sAR
         HOnRHEaf12+XNGonaTvQrtORBEoI5cqNU2fQRLY7R/Oa6o93zgYFW3DKwud6oyp/LWvP
         aTAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717423874; x=1718028674;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dRaDiAL64sssMvTWiBBzGvj163oLeurAnHe5X3Opa24=;
        b=epJGhYn4OPnNcfItsxuBgmEyB2vGTiSttAMPf8ZsfRuOiBQ5VA/qhyooauraXNgI+2
         CphH5y//sp0ENQCw1+ZX/adISwEUMhRPoF1bo6nwjU5xv0kTSFDxEN9Z7/+NoDbu/R3y
         splHIxBYr7OnK7TfZ18IFdCio9tXr920vjBm3jJIjLZAUFZMJqbBKMRP+mwNnDowTqp/
         yD/07IJ/wPCHRbPN5/ZvBkxBX1sVPVSROxeyz1Z9U+X9WiFTqoyy9U/4qu9cdlaD++fB
         5lRHkGhc1XhGrW82Ya2GDkWILTWq1raJq3wsB+TYsWbWqDZfOdHLdh07Fi384Q1JvoEh
         AOFQ==
X-Forwarded-Encrypted: i=1; AJvYcCXKJE1hsgWkfGvl+5CJsj79F8fbiUiRkSUzXa5euiMUdRxyEjRuCPEe4/EtOj7CPhncrvBr8yyNveHMrOIbWUxCSLMT
X-Gm-Message-State: AOJu0YzpyKhmJtFumXfyrrpQcooEVDh6gtWY64vTVVxEtumMt6G5JWtc
	a7RqbFtXrRBVnoM9mTn+HayFfRVUFafWPnOzE9Gud6SLst//ZE7ucdSqPQKdcR4=
X-Google-Smtp-Source: AGHT+IEoRgPQWyBF9W1moLh8VT4BX2L5l2kefHO9O6pdlrBS8/sUQ5nmxIPLbYEDqFdEuHeLaWcadw==
X-Received: by 2002:a17:906:36cf:b0:a68:5fb6:1a7f with SMTP id a640c23a62f3a-a685fb61d23mr728743066b.21.1717423874419;
        Mon, 03 Jun 2024 07:11:14 -0700 (PDT)
Received: from [192.168.69.100] ([176.176.177.241])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a67eac7a340sm489040666b.159.2024.06.03.07.11.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Jun 2024 07:11:14 -0700 (PDT)
Message-ID: <329a02e4-724a-4579-ade2-99e3ad2688de@linaro.org>
Date: Mon, 3 Jun 2024 16:11:11 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/5] cpus: a few tweaks to CPU realization
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
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
 <988e580d-6121-4f7f-b7b8-d12cee39be35@linaro.org>
Content-Language: en-US
In-Reply-To: <988e580d-6121-4f7f-b7b8-d12cee39be35@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/6/24 14:47, Philippe Mathieu-Daudé wrote:
> On 30/5/24 21:42, Alex Bennée wrote:
>> The recent IPS plugin exposed a race condition between vcpu_init
>> callbacks and the other vcpu state callbacks. I originally thought
>> there was some wider re-factoring to be done to clean this up but it
>> turns out things are broadly where they should be. However some of the
>> stuff allocated in the vCPU threads can clearly be done earlier so
>> I've moved enough from cpu_common_realizefn to cpu_common_initfn to
>> allow plugins to queue work before the threads start solving the race.
>>
>> Please review.
>>
>> Alex Bennée (5):
>>    hw/core: expand on the alignment of CPUState
>>    cpu: move Qemu[Thread|Cond] setup into common code
>>    cpu-target: don't set cpu->thread_id to bogus value
>>    plugins: remove special casing for cpu->realized
> 
> Thanks, patches 1-4 queued so far.

Now patch 5 also queued ;)

