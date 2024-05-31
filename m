Return-Path: <kvm+bounces-18508-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 96DAE8D5D16
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 10:48:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B88761C25084
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 08:48:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5734D155CBD;
	Fri, 31 May 2024 08:48:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="PuD++xIu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 812C5155A23
	for <kvm@vger.kernel.org>; Fri, 31 May 2024 08:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717145284; cv=none; b=emxM8nJmSmgO+4lqGegLwU6oUIUtRFi8zl0zxbROtcABPExG+TxhxS8b7qo3pU7mYcKawhpAH/izRZ+UxixMhwdc9+Eyux8ea++rajfMSnDkwQB9En6AquRLRKb+p2qZK+lQRQOolWUAKqpf6DccUzN/516jUjYSuCDOliIXBT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717145284; c=relaxed/simple;
	bh=yi9Z4stgRr2LWyvVky/06j0qHurXubRicyf0BLLFJNM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=DVt1Q1bltG3KPIT0w6BwqU7k0vy5+GKETxlrRLQ0HenlzODgmDZkaMwXQIG2MyIgJveJEPd5e1FAHF2P0skwYoCuWTbui/D3b8CwN0HONl+UKblZCmGuG4OyjoMVTHtxpG3afqKaspPdSfLZAi++CKklK8Z81sVAaqvdtRuV76o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=PuD++xIu; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-42125bfa28fso23275915e9.1
        for <kvm@vger.kernel.org>; Fri, 31 May 2024 01:48:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1717145281; x=1717750081; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=meoL7WfK42ojhKeIQHmQAYOy8DiET5LFPofSDuIY/tE=;
        b=PuD++xIulKvYinOokXfYREDn16UpVdy5UyXvhI5WwS4jBSkMfogMMJSjsc7ID8MVts
         q5Zu56b3eYNpq69zhZs19eW/kIxigYPtUew5UW66nx8oJoSAUTTLI0iXpW9hTB9cGqxf
         JHW2Mgx2rVe+aY8M1LYkJaTCZOA/ION23F0WB9rrn6RFDKHt/tddDanlm2TlrTd2PBg8
         mFbgpoDvw84YLPYCRWH5nmTHKaT9I+gYVVV9CQI0vGfKQOOg3AvAlBR7S1Bw0ra+TCa3
         NgVd/XHwfuOy+LUcUlOp/+1p2ylbJpJrIukaWNiCXUnHw6fYNmmgte2HpS5sy/qZsZuK
         ZaMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717145281; x=1717750081;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=meoL7WfK42ojhKeIQHmQAYOy8DiET5LFPofSDuIY/tE=;
        b=vFwgqbyiFVuYyfETXigjHdishxCrqNy0doPYq093kz3uMRjddhhqAqszD6j8ddo9W7
         RDdGURh+NHBUf6afASU2XMUFgALhAHRng5hv9J7VsocePVkGycWHI2at1RUMujpxEIRG
         MPqQKzQUi6gnumqUcQlaotnJ0Zf0ehYmhUXi5cg/GS33EN4DALCxEf0zxaSQi9U+VbQn
         Ikf+FRzF7RXZ0igZPe0FKtjHNi2Uidw06nIbjXoFMDgmRK5Z60ipgWhNj2AoQ+uppASq
         VCLRFN8IuSYadkGS2GRKkNrnv8267lRQSzZCTxWkxkABpPB0YtlE+6cRySuo3XFA65wH
         FJKw==
X-Forwarded-Encrypted: i=1; AJvYcCXi0HSiqhs7zklb5eYT0ft8EPE8EE9/G5rzUcV/37l3hQO2fcvgUgdG+Rq0i/eolc8dOBt62l2lxVvDiUyZK9HVAZ3J
X-Gm-Message-State: AOJu0YznfnmkzIj70I/0N9NDgROreBcM+cgyCT+D6IEFy0579B4m4JjC
	4J+M3sU51iUQdmZm4I+Qq+OfO9fzB9gwUTY/uZKj9Een5XStocPk1vIxjaMnNf8=
X-Google-Smtp-Source: AGHT+IEV4VB90Yp5BlcabsTwRd4BgRHuw3uHX/14npi+yUJEgcNk6X77K92oI3w52Eu/2/hHdMqhmg==
X-Received: by 2002:a05:600c:4f46:b0:421:212c:c963 with SMTP id 5b1f17b1804b1-4212e075949mr12173695e9.20.1717145280676;
        Fri, 31 May 2024 01:48:00 -0700 (PDT)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4212b84ae09sm18355335e9.18.2024.05.31.01.48.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 May 2024 01:48:00 -0700 (PDT)
Received: from draig (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id BB0EE5F747;
	Fri, 31 May 2024 09:47:59 +0100 (BST)
From: =?utf-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
To: Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Cc: qemu-devel@nongnu.org,  Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
  Cameron Esfahani <dirty@apple.com>,  Alexandre Iooss <erdnaxe@crans.org>,
  Yanan Wang <wangyanan55@huawei.com>,  Paolo Bonzini
 <pbonzini@redhat.com>,  Eduardo Habkost <eduardo@habkost.net>,  Sunil
 Muthuswamy <sunilmut@microsoft.com>,  Richard Henderson
 <richard.henderson@linaro.org>,  Pierrick Bouvier
 <pierrick.bouvier@linaro.org>,  Mahmoud Mandour <ma.mandourr@gmail.com>,
  Reinoud Zandijk <reinoud@netbsd.org>,  kvm@vger.kernel.org,  Roman
 Bolshakov <rbolshakov@ddn.com>
Subject: Re: [PATCH 5/5] core/cpu-common: initialise plugin state before
 thread creation
In-Reply-To: <1c950cd6-9ee0-4b40-b9d6-3cc422046d65@linaro.org> ("Philippe
	=?utf-8?Q?Mathieu-Daud=C3=A9=22's?= message of "Fri, 31 May 2024 09:26:55
 +0200")
References: <20240530194250.1801701-1-alex.bennee@linaro.org>
	<20240530194250.1801701-6-alex.bennee@linaro.org>
	<1c950cd6-9ee0-4b40-b9d6-3cc422046d65@linaro.org>
Date: Fri, 31 May 2024 09:47:59 +0100
Message-ID: <87a5k6cqps.fsf@draig.linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org> writes:

> On 30/5/24 21:42, Alex Benn=C3=A9e wrote:
>> Originally I tried to move where vCPU thread initialisation to later
>> in realize. However pulling that thread (sic) got gnarly really
>> quickly. It turns out some steps of CPU realization need values that
>> can only be determined from the running vCPU thread.
>
> FYI:
> https://lore.kernel.org/qemu-devel/20240528145953.65398-6-philmd@linaro.o=
rg/

But this still has it in realize which would still race as the threads
are started before we call the common realize functions.

>
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
>
> Per https://etherpad.opendev.org/p/QEMU_vCPU_life, plugin_state could
> be initialized in AccelCPUClass::cpu_instance_init (although this
> callback is called at CPUClass::instance_post_init which I haven't
> yet figured why).

Why are x86 and RiscV special in terms of calling this function?

>
>> +        async_run_on_cpu(cpu, qemu_plugin_vcpu_init__async, RUN_ON_CPU_=
NULL);
>> +    }
>> +#endif
>>   }
>>     static void cpu_common_finalize(Object *obj)

--=20
Alex Benn=C3=A9e
Virtualisation Tech Lead @ Linaro

