Return-Path: <kvm+bounces-18658-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 036778D84A5
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 16:12:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A8A0B1F23A34
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 14:12:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C509D12E1CA;
	Mon,  3 Jun 2024 14:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="NGoGh6EE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54CC05664
	for <kvm@vger.kernel.org>; Mon,  3 Jun 2024 14:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717423921; cv=none; b=r+hPTiKB13vTncVv1S57Fk/fHALGBSm0sHNj3SmJRbu+1HEW26Boz19bP0qkgaGQZ+VJvbByTn6BSz9TmJlZ6DU/lFPcMew2t0t9c0vzdZfHtZDW2FVFNnS54bp48lo8tH1AW6Hf4/uoW9ogsUkFop7DahlmhsZMQGz9BjbXJEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717423921; c=relaxed/simple;
	bh=9+jJQeLxtbwh3GVN0JWN6czUwWGprSlkF9d/8DKi/FQ=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=WQHIWVC3+qp5mAFK+JNy2nlopgkJZaVa9Q/Xe204qE+hKf5UI4d4tIcIWElfGic25CxJzdYKg0RslLAhlspM7AG/pF8Uuub8ynuS1toKlLqNNtcVTgjWvgarT5SOUP2Yat0RNmPVQoM18z1rq8hMFDcLv1XuWNmVGfdtyidWj5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=NGoGh6EE; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-57a32b0211aso3895063a12.2
        for <kvm@vger.kernel.org>; Mon, 03 Jun 2024 07:11:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1717423918; x=1718028718; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=DlSUWfEVLvtJdjyRCcCPS1n94AQWY9Us2l2aMVIJj7Y=;
        b=NGoGh6EEZAF5ay8ZEwtz+na4dbf62xS7X8FnuRRQOzGAYawOkHsyF9CdcefiSDbFbx
         BCZxWqk8KZ7e13/Q0gYbJNhZ2y952qjwn7pc4Tcshsno5jvdZVH2F7Wy4eUxx4CZgyv3
         KjmWVqNGWxFqdKeOB6XSP9IejHtRohlm/3gMdQLLzXVFtTyYoTXFgG1WiUzC8SPWJC8q
         GCMJSIb++JURyS9EVTyz6xjFbbzPlK9mEdE1GhptFaLt2vlIQ48KdOvgavfkHe53y3rU
         AM88uAZsMLdPtiKt+p/haW9qe3wpT7ohd0EL+cGqb6zIqpx2UvydHUiZ8EAXj4J/aq0B
         OrEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717423918; x=1718028718;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DlSUWfEVLvtJdjyRCcCPS1n94AQWY9Us2l2aMVIJj7Y=;
        b=LlbDofzmDToQekSSgB0uL5CL58dMKyvRJJ6zMJcz8SACqPAprE/vT61COleS6EIfpn
         UKwpEivT6gDSSqlQEjzu5zx+MRpiUgf/D0bG9KlFt7fIAJDVK7NOjX3Pc2xMP3vjO9zx
         Aqqol+oVN0r6sEIIF8KAUPngET2T8x0pdDdDOcjdqzQh3pvjl8tfWi5S55o0W5hqob+A
         /cNi9mdu2eOKYHkA4WWYr68WbA8AluPVdBHMLdcDFmPomtnC3EHZP6a888eKJKpdpWGb
         8CqyqfMkMhUdtRyeQ4cjt2YR21lpTn5HDurWj5o23YjJ90D58mZRqbdeoHF3WCCUMtCz
         uGZA==
X-Forwarded-Encrypted: i=1; AJvYcCXKaSdKa294Us28iPyvpAOMBP8R9sT2j1PxUGhg7MI9fMGipOeUWIWYBsVLr2FoHTSfjxtE5tfLdXXz98b5AFxoaPPy
X-Gm-Message-State: AOJu0Yy/qvKRULxfY1sKXWSledmoIa7pvjX0U0VUfZlox54SAH6K6CgA
	+yKbZANIPJpBd3bvGXi0Wij5lrGyUj5WwEP3Hnwkls8ExKjCYDcWxQVaqqeuLlc=
X-Google-Smtp-Source: AGHT+IGdr5CBYOZFF6Lat26v/7tlPWLGgyXS6UBb1RiZVlrTdk8rnBJQ5k0EYqfvZ4PIW3CG1qkc9A==
X-Received: by 2002:a50:bac6:0:b0:572:6846:b899 with SMTP id 4fb4d7f45d1cf-57a3658b28fmr5068095a12.41.1717423917639;
        Mon, 03 Jun 2024 07:11:57 -0700 (PDT)
Received: from [192.168.69.100] ([176.176.177.241])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-57a61b4e36dsm1653858a12.75.2024.06.03.07.11.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Jun 2024 07:11:57 -0700 (PDT)
Message-ID: <750b1cd7-6b16-464d-8229-46a4b5f4e022@linaro.org>
Date: Mon, 3 Jun 2024 16:11:54 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/5] plugins: remove special casing for cpu->realized
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
 <20240530194250.1801701-5-alex.bennee@linaro.org>
 <0a76250f-db5b-4c94-941a-cbec1f2e1db6@linaro.org>
Content-Language: en-US
In-Reply-To: <0a76250f-db5b-4c94-941a-cbec1f2e1db6@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/6/24 13:31, Philippe Mathieu-Daudé wrote:
> On 30/5/24 21:42, Alex Bennée wrote:
>> Now the condition variable is initialised early on we don't need to go
>> through hoops to avoid calling async_run_on_cpu.
>>
>> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
>> ---
>>   plugins/core.c | 6 +-----
>>   1 file changed, 1 insertion(+), 5 deletions(-)
>>
>> diff --git a/plugins/core.c b/plugins/core.c
>> index 0726bc7f25..badede28cf 100644
>> --- a/plugins/core.c
>> +++ b/plugins/core.c
>> @@ -65,11 +65,7 @@ static void plugin_cpu_update__locked(gpointer k, 
>> gpointer v, gpointer udata)
>>       CPUState *cpu = container_of(k, CPUState, cpu_index);
>>       run_on_cpu_data mask = RUN_ON_CPU_HOST_ULONG(*plugin.mask);
>> -    if (DEVICE(cpu)->realized) {
> 
> We could assert() this to protect future refactors.

(No we can't because vCPU can still be unrealized at this point).

> Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> 
>> -        async_run_on_cpu(cpu, plugin_cpu_update__async, mask);
>> -    } else {
>> -        plugin_cpu_update__async(cpu, mask);
>> -    }
>> +    async_run_on_cpu(cpu, plugin_cpu_update__async, mask);
>>   }
>>   void plugin_unregister_cb__locked(struct qemu_plugin_ctx *ctx,
> 


