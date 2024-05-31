Return-Path: <kvm+bounces-18509-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 666FD8D5D5F
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 10:59:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7F3741C2141C
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 08:59:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BFE812F582;
	Fri, 31 May 2024 08:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="G3qJbjGY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8064F182B9
	for <kvm@vger.kernel.org>; Fri, 31 May 2024 08:59:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717145978; cv=none; b=Pjnpxx3cuXg9lkcMUZMT/ZBrxcptJBy6skmD7IOx9fCkC5ARVp40Xcdd9Q2jxRyYq6TH8jN1If3zat3PBgmcj082WG2iomNPvIJsAhOPZ/l0YeZXwwmueag5nC4QMP87Hgg+VUB2SQXJ+g9zXHHzgCjCAoGuWzbcQ6L9C40tbhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717145978; c=relaxed/simple;
	bh=GH9pkTwEfwVLbKhBYBbGg0dPt1XT2dOCugabZ7c2Ftw=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=JL7kdKWYgaHxaWyQUloRaE3ygPrpABs+HbSUWst2GDzX3gImHdCe5uYdSIevLpaXvP9mKmSRsw1+HHcytbbFQOYWog8926EMhdBNnHl79oo5QNzgTM6EQiJW06X2PkdnhRdrBGfigOur5Dt9uQt1F8ltvtBoDrv2CPwZpPfQgMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=G3qJbjGY; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-354b722fe81so695726f8f.3
        for <kvm@vger.kernel.org>; Fri, 31 May 2024 01:59:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1717145975; x=1717750775; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HFU9KKTRbDofEDS8aJAnWea9GBFWQtUAah9gN/YYUmE=;
        b=G3qJbjGY2xwCJsP86C24gZ8CKqznrh3sKCjYaRX1tZWdnvx2k7bZsl9VxdGZWkvM2+
         tS5k45Wb3jFnRvSdE7sORQrQgPjxMOBQdJxF9pEUQ/sYDTZE09FmzYjO0+dvQIVStI/Z
         kfB88MCznUp11RJO8H3c9rYEqcclZj7tUOqpXtBnAdd4khXEO/GX7EOUsBx5wLBBjSlw
         7F9wH6hqlGzH4VAZAVVT81sbNt2g/xl7BE+qdVDP3Pp5S1xNoccgXaH2p8U7k/kmU2tH
         dUZRHq0vvViRwfJrPqGpJM3fC+yFD2Xoe9sVd79LEYMBsUlucf75rye57E9OLJxUEf55
         qhWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717145975; x=1717750775;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HFU9KKTRbDofEDS8aJAnWea9GBFWQtUAah9gN/YYUmE=;
        b=wcZFwP3eGSRpDBp98HJypbjSyjOzKrOu3DHQplDE/zvBa2fXhYjp5nZdUnVPmyZ3fI
         4YVoJOdX8M7044nhJ6sZDAuqLNNAvRddP7ICSlgQjm5kcD0TsdZckC9Fqo1xokX1li9r
         QIAXtesUIl9wUMU5dtr6kVMaM+xSLO7eK1u4BbhQhFprbnnX8V4NLWOR3kGVh6/DKnWx
         SrU9P94tjtF6PRr4Cws/Lg2dMNGAyyM+GR8ByShzhOKwy/WLrX/owOmzzfBECFkuy0BL
         5/4KAVX82e84Pko3Gjcsr51Gh5H8F7Xx8baXqg1IuvpIvo8FTVMCLksVMEqAM803t88E
         7bJg==
X-Forwarded-Encrypted: i=1; AJvYcCUbI4ETycfjTTYLQHbsHP+hteH7a7vO+s6ZmJWOBkYR2IGb0Qkf+G9hmB8NKnAW8eAt9u2krIRArEhxlqvebQA2+iXS
X-Gm-Message-State: AOJu0Yzgf2flT7skYIg7hhQhArGERH2gFh4n0wNhcfVmDLL69ouiuY/l
	AHWOrr+k3yIe0M8ECzP2op/Wqu/fe3o9KOuQi8YG+zZhU/zqJiSK11hEoxTySb4=
X-Google-Smtp-Source: AGHT+IHlD6Au5junwHiGk/7tjJB3tOTkAx0owjoRjG4EL0CHBDXbT6nfB1PVCFuLMHfgLYlU0cdvsg==
X-Received: by 2002:a5d:46d2:0:b0:355:148:ea23 with SMTP id ffacd0b85a97d-35e0f316ab9mr843678f8f.56.1717145974622;
        Fri, 31 May 2024 01:59:34 -0700 (PDT)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-35dd04c0f1fsm1390309f8f.15.2024.05.31.01.59.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 May 2024 01:59:34 -0700 (PDT)
Received: from draig (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id B3F325F747;
	Fri, 31 May 2024 09:59:33 +0100 (BST)
From: =?utf-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Cc: qemu-devel@nongnu.org,  Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
  Cameron Esfahani <dirty@apple.com>,  Alexandre Iooss <erdnaxe@crans.org>,
  Yanan Wang <wangyanan55@huawei.com>,  Paolo Bonzini
 <pbonzini@redhat.com>,  Eduardo Habkost <eduardo@habkost.net>,  Sunil
 Muthuswamy <sunilmut@microsoft.com>,  Richard Henderson
 <richard.henderson@linaro.org>,  Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>,  Mahmoud Mandour <ma.mandourr@gmail.com>,  Reinoud
 Zandijk <reinoud@netbsd.org>,  kvm@vger.kernel.org,  Roman Bolshakov
 <rbolshakov@ddn.com>
Subject: Re: [PATCH 5/5] core/cpu-common: initialise plugin state before
 thread creation
In-Reply-To: <23926d03-b55f-448f-82b1-99e4bc9d76dd@linaro.org> (Pierrick
	Bouvier's message of "Thu, 30 May 2024 15:31:53 -0700")
References: <20240530194250.1801701-1-alex.bennee@linaro.org>
	<20240530194250.1801701-6-alex.bennee@linaro.org>
	<23926d03-b55f-448f-82b1-99e4bc9d76dd@linaro.org>
Date: Fri, 31 May 2024 09:59:33 +0100
Message-ID: <871q5icq6i.fsf@draig.linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Pierrick Bouvier <pierrick.bouvier@linaro.org> writes:

> On 5/30/24 12:42, Alex Benn=C3=A9e wrote:
>> Originally I tried to move where vCPU thread initialisation to later
>> in realize. However pulling that thread (sic) got gnarly really
>> quickly. It turns out some steps of CPU realization need values that
>> can only be determined from the running vCPU thread.
>> However having moved enough out of the thread creation we can now
>> queue work before the thread starts (at least for TCG guests) and
>> avoid the race between vcpu_init and other vcpu states a plugin might
>> subscribe to.
>> Signed-off-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
>> ---
>>   hw/core/cpu-common.c | 20 ++++++++++++--------
>>   1 file changed, 12 insertions(+), 8 deletions(-)
>> diff --git a/hw/core/cpu-common.c b/hw/core/cpu-common.c
>> index 6cfc01593a..bf1a7b8892 100644
>> --- a/hw/core/cpu-common.c
>> +++ b/hw/core/cpu-common.c
>> @@ -222,14 +222,6 @@ static void cpu_common_realizefn(DeviceState *dev, =
Error **errp)
>>           cpu_resume(cpu);
>>       }
>>   -    /* Plugin initialization must wait until the cpu start
>> executing code */
>> -#ifdef CONFIG_PLUGIN
>> -    if (tcg_enabled()) {
>> -        cpu->plugin_state =3D qemu_plugin_create_vcpu_state();
>> -        async_run_on_cpu(cpu, qemu_plugin_vcpu_init__async, RUN_ON_CPU_=
NULL);
>> -    }
>> -#endif
>> -
>>       /* NOTE: latest generic point where the cpu is fully realized */
>>   }
>>   @@ -273,6 +265,18 @@ static void cpu_common_initfn(Object *obj)
>>       QTAILQ_INIT(&cpu->watchpoints);
>>         cpu_exec_initfn(cpu);
>> +
>> +    /*
>> +     * Plugin initialization must wait until the cpu start executing
>> +     * code, but we must queue this work before the threads are
>> +     * created to ensure we don't race.
>> +     */
>> +#ifdef CONFIG_PLUGIN
>> +    if (tcg_enabled()) {
>> +        cpu->plugin_state =3D qemu_plugin_create_vcpu_state();
>> +        async_run_on_cpu(cpu, qemu_plugin_vcpu_init__async, RUN_ON_CPU_=
NULL);
>> +    }
>> +#endif
>>   }
>>     static void cpu_common_finalize(Object *obj)
>
> Could you check it works for all combination?
> - user-mode
> - system-mode tcg
> - system-mode mttcg

I was hand testing against the record replay tests in avocado (rr single
thread tcg) and general system and user mode stuff. I haven't run a full
pipeline yet, although I did apply your IPS patches ontop and run that:

  https://gitlab.com/stsquad/qemu/-/pipelines/1312869352

but all those failures are user-mode build failures due to the missing
time stubs AFAICT.

>
> When I tried to move this code around, one of them didn't work correctly.
>
> Else,
> Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>

--=20
Alex Benn=C3=A9e
Virtualisation Tech Lead @ Linaro

