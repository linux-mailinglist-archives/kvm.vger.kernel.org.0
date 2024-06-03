Return-Path: <kvm+bounces-18632-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 18DF28D8146
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 13:31:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BD8BF1F21F53
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 11:31:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEAD084A51;
	Mon,  3 Jun 2024 11:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="KAhtftuY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7502A3BBEC
	for <kvm@vger.kernel.org>; Mon,  3 Jun 2024 11:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717414274; cv=none; b=uwIWU21eXD2mc6iFaPcvoxtLz7BIGsKVps2OwyhubrcXkfCvRnZol781j4xF/vk3VLF5PGP35oay6Bqc36NxCzc3InUVcVTYxLvUOdt3/4CVMtnxd1cM94n70ODFA8IV1C45DZKjVL+K0NBaCXKFk7Xnh2q2d0QXRj4SiX92jTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717414274; c=relaxed/simple;
	bh=W3Kx8ldeOPiSQJawbvQbLDWfOfCrINMDFbvESAKJcwE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VAWfKVnli6fIjRT+8at9kjpZAW9VuZ36fTDfLTYNryQaqL3w9kJMfR8RSwE2SBHQnvLHsviuKJABgsyark4EnIaSX+iwQIKyxOUxfrH51d43P8I8k6noepQWqCO9HMxSyf3NxuWong1lx4KC/tbPWbDbhcMe00A5+70Qa1kUReI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=KAhtftuY; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4212a3e82b6so19424985e9.0
        for <kvm@vger.kernel.org>; Mon, 03 Jun 2024 04:31:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1717414271; x=1718019071; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0pvRBBopizJ2gZQMqrLi9V1FIUD9kVaeww68E6Xk1IQ=;
        b=KAhtftuYT92lBC1VgAXhovrtrn9UUWBT6QQUvUACEt4MzRRqE8GHTkA6PPnMeLwT2D
         Gba+r55x1IhFLa+bP6zC95nuEgmcd9eVJwm8lWO+M1VlqJQKhsfybWuI2X1IRHV5RxnO
         YLVtFVuCpCoqwZQwAb1wwG0R8+Mz5F0Ez234hSeubAulXiueYFv7i0HZqaOliSSwFx6f
         5WH11lZoxjQ1nwsSEciRNx3eGg08VlB1NzS/p9wEBAkQ1mUaUlZBFJOVbWG+j6+gKqDH
         hovIFoVZPDq+ndLoqiPGEPNcQcCxOO3/L2+5YdDe61fNHsH4aWZ9Rt0PbdASOWo3EXvm
         KC1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717414271; x=1718019071;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0pvRBBopizJ2gZQMqrLi9V1FIUD9kVaeww68E6Xk1IQ=;
        b=CikzfLk6t1LM1Q7q1auD0HYmc/0gAt8ACCU/XTsGJPg7NRukCVFWx1eBtsxnOH1tCJ
         I54kI6XwjWlljYUvqaI3WHuSvjh/V0x+B5KQdsmPer0hZ5PYrh5pTZZArG/6NNObzCa9
         JkGPj9OVAI4VP2BO+kPR4mbdbXFa1wkhC6SwLINg2cXNuEToNbioLAxnoZCzFBzUfazf
         ypOL0PlOibDjjNg0soBWwb9di8ks+Ejf7MsRca4qf2Nrhj1z6c4iDA2d4XCS3J5CAgrI
         WxEV3fF5sp9Ph+41DBTuFsVCbHarEauzMp/6dvB8S8WFHndXO24j+7RNTWdQofGUN+7v
         pUUQ==
X-Forwarded-Encrypted: i=1; AJvYcCWNXCeMSspRX/idyoTRtOqnCLThU3o3qqZSAJ9aJwLp5yS7vZkewz7W3FdaL40APui+zJgxWxzQu0CXriv6XCr2FV6e
X-Gm-Message-State: AOJu0YwY++mXcJEIDlLbbClxMZMjBJp+NwW3o+M/LIxGlmx0OXGEfnGy
	t4mVuLzln2qKpDw88PzAa/5vtNmx+Y/OvAEKGsJTWqpWZU2CAAMaMnVmQjMab1Y=
X-Google-Smtp-Source: AGHT+IGmbF1h1ABbM07Oz/RX9bF3huYnvm5OdOEotdKdo4Ru8QxilyaCfoi00DaQ92UwDxx/7770Hw==
X-Received: by 2002:a05:6000:e43:b0:357:16f6:71dc with SMTP id ffacd0b85a97d-35dc7e3e560mr10103735f8f.13.1717414270789;
        Mon, 03 Jun 2024 04:31:10 -0700 (PDT)
Received: from [192.168.69.100] ([176.176.177.241])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42134f12e72sm82821425e9.34.2024.06.03.04.31.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Jun 2024 04:31:09 -0700 (PDT)
Message-ID: <0a76250f-db5b-4c94-941a-cbec1f2e1db6@linaro.org>
Date: Mon, 3 Jun 2024 13:31:07 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/5] plugins: remove special casing for cpu->realized
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
 <20240530194250.1801701-5-alex.bennee@linaro.org>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20240530194250.1801701-5-alex.bennee@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 30/5/24 21:42, Alex Bennée wrote:
> Now the condition variable is initialised early on we don't need to go
> through hoops to avoid calling async_run_on_cpu.
> 
> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
> ---
>   plugins/core.c | 6 +-----
>   1 file changed, 1 insertion(+), 5 deletions(-)
> 
> diff --git a/plugins/core.c b/plugins/core.c
> index 0726bc7f25..badede28cf 100644
> --- a/plugins/core.c
> +++ b/plugins/core.c
> @@ -65,11 +65,7 @@ static void plugin_cpu_update__locked(gpointer k, gpointer v, gpointer udata)
>       CPUState *cpu = container_of(k, CPUState, cpu_index);
>       run_on_cpu_data mask = RUN_ON_CPU_HOST_ULONG(*plugin.mask);
>   
> -    if (DEVICE(cpu)->realized) {

We could assert() this to protect future refactors.

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>

> -        async_run_on_cpu(cpu, plugin_cpu_update__async, mask);
> -    } else {
> -        plugin_cpu_update__async(cpu, mask);
> -    }
> +    async_run_on_cpu(cpu, plugin_cpu_update__async, mask);
>   }
>   
>   void plugin_unregister_cb__locked(struct qemu_plugin_ctx *ctx,


