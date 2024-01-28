Return-Path: <kvm+bounces-7291-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B54783F7FB
	for <lists+kvm@lfdr.de>; Sun, 28 Jan 2024 17:46:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4EBFC1C209C9
	for <lists+kvm@lfdr.de>; Sun, 28 Jan 2024 16:46:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AF5851039;
	Sun, 28 Jan 2024 16:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="UXgaj+q+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FB6913E226
	for <kvm@vger.kernel.org>; Sun, 28 Jan 2024 16:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706458587; cv=none; b=e/cTlEWRP/Hlu1js6jNrwphw9qEN9r4JD13Qnk8ppDxHn1iLHtbzCz2mRSMhE+QOM7kncXofFJ0kon77zSyOBu7EQMR0MAszZbj4GyX5lO6tX/GsfVuigZehhHo50VvKYOCyH4PshY9iDeIDHorjwI7f6eH1EnVNJ+YICC88n7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706458587; c=relaxed/simple;
	bh=5pFLTwe0IE1a2sJXm7VwA00kVIm5lVdlEcfYGDxs1Og=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Jc9MYCcueldmw4NG7Uk6hVDM9bru4gp3dxb7Lyed2BsR5Fo0TRlOB2IN0iRtf0LxYh2m8krrTFiS39J5VnTPHeLdgolr2pAkyTm+MAsIZ99MYflC+uCuNj1OnN4zjz4A6I0rr0syb4q6ILyEsmvxzW//rP7VAPT4vQ42A22RWuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=UXgaj+q+; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-33ae38df9d2so1050511f8f.3
        for <kvm@vger.kernel.org>; Sun, 28 Jan 2024 08:16:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1706458583; x=1707063383; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nNQ1mZG/MGqiJb02NhZJ31w2Qw5Q82nN33CYLr2cWWo=;
        b=UXgaj+q+RdWg7eyURufjJAM46rzGAggMVsOf+FsURbIBk+LbM0WMgwIP/Nq1Q2aX6u
         lzXS0/y5Z6jMsxkVHrUMScJ0PH6e6v2fryVbfoEJTjZmmsI031k1YyXwsd/VrgbVMQ8U
         EzF9VUyGqBDoCgOzNRKN98p+GarJM0ckfoWiHQOMseRTk68k0o1x6kA5iP2ebeLt+uWb
         UAiKjq9GEBp4IDxcer2YgJUtcXUDzY5SpPNr6IwINR6i+m0HNk2LZEY30LO8wJ8Wm/XI
         JXV1l7rrksgHGuJP5UzWy1gsYjt2X02ODQJFHKP+FV8gmgvkWT8aNXg61g2Qxsw8MCVm
         WzJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706458583; x=1707063383;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nNQ1mZG/MGqiJb02NhZJ31w2Qw5Q82nN33CYLr2cWWo=;
        b=Mv5UE3ftS8B2lkkI5WMO/Pcm00qgx+ZZ7Ql219uEviI1AAdHLiAznkk1jX9Vc3QD0p
         0DxjwTD0H6cX4Wovb1XoKtjMWeYz+tRwjZj9RskUvlAmB6oSUR6gRTClcUYs0gOS/xEo
         qs278q1HHpeAgqByR3zKQaxISvPX3Xf4hXWYLldUeoRsLjCBpxx7iRJiy2dCZGVm08/r
         cczQCwxtS2FjN/EYgxQB8aRnwNRw9iEx2arSZySMHhttHoToztn8VMV5uTryffFaiSNL
         Ck0IAaHM+4xkvhmAYFt328KJHipF03sEP4HDLXzBtQtfuiV/AXfDPxescv2BmyUdreOK
         HVaQ==
X-Gm-Message-State: AOJu0Yx1mQE0NAXfYEDArWXDMj8dHCkVd7LvEpjdYc1OlDFSgXDwtUMo
	RkaTmP3iL4DVG/P0V1CHzlvDcScO6ftd2zjoDS97koASifx4eydYAEM0M62GP5A=
X-Google-Smtp-Source: AGHT+IEZiXHH6VkkxIr4855VrA6mlwRi5ZK5DAlf4ThQoy+yRYfRVJ2hAzogGQOYO0OnwUHdVFeDqg==
X-Received: by 2002:a5d:604c:0:b0:33a:e5e5:163c with SMTP id j12-20020a5d604c000000b0033ae5e5163cmr1763182wrt.71.1706458583105;
        Sun, 28 Jan 2024 08:16:23 -0800 (PST)
Received: from [192.168.69.100] (sev93-h02-176-184-17-196.dsl.sta.abo.bbox.fr. [176.184.17.196])
        by smtp.gmail.com with ESMTPSA id ch19-20020a5d5d13000000b00337b47ae539sm5942414wrb.42.2024.01.28.08.16.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 28 Jan 2024 08:16:22 -0800 (PST)
Message-ID: <d7c11962-07c0-4c26-83e1-8b0a3d1e43d0@linaro.org>
Date: Sun, 28 Jan 2024 17:16:19 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 10/23] target/i386: Prefer fast cpu_env() over slower
 CPU QOM cast macro
To: Zhao Liu <zhao1.liu@intel.com>
Cc: qemu-devel@nongnu.org, qemu-arm@nongnu.org, Thomas Huth
 <thuth@redhat.com>, qemu-s390x@nongnu.org, qemu-riscv@nongnu.org,
 Eduardo Habkost <eduardo@habkost.net>, kvm@vger.kernel.org,
 qemu-ppc@nongnu.org, Richard Henderson <richard.henderson@linaro.org>,
 Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>,
 Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Anthony Perard <anthony.perard@citrix.com>, Paul Durrant <paul@xen.org>,
 Cameron Esfahani <dirty@apple.com>, Roman Bolshakov <rbolshakov@ddn.com>,
 Marcelo Tosatti <mtosatti@redhat.com>, David Woodhouse
 <dwmw2@infradead.org>, xen-devel@lists.xenproject.org
References: <20240126220407.95022-1-philmd@linaro.org>
 <20240126220407.95022-11-philmd@linaro.org> <ZbT1R7impEw4whqP@intel.com>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <ZbT1R7impEw4whqP@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 27/1/24 13:21, Zhao Liu wrote:
> Hi Philippe,
> 
> On Fri, Jan 26, 2024 at 11:03:52PM +0100, Philippe Mathieu-Daudé wrote:
>> Date: Fri, 26 Jan 2024 23:03:52 +0100
>> From: Philippe Mathieu-Daudé <philmd@linaro.org>
>> Subject: [PATCH v2 10/23] target/i386: Prefer fast cpu_env() over slower
>>   CPU QOM cast macro
>> X-Mailer: git-send-email 2.41.0
>>
>> Mechanical patch produced running the command documented
>> in scripts/coccinelle/cpu_env.cocci_template header.
>>
>> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
>> ---
>>   target/i386/hvf/vmx.h               | 13 +++-------
>>   hw/i386/vmmouse.c                   |  6 ++---
>>   hw/i386/xen/xen-hvm.c               |  3 +--
>>   target/i386/arch_memory_mapping.c   |  3 +--
>>   target/i386/cpu-dump.c              |  3 +--
>>   target/i386/cpu.c                   | 37 +++++++++------------------
>>   target/i386/helper.c                | 39 ++++++++---------------------
>>   target/i386/hvf/hvf.c               |  8 ++----
>>   target/i386/hvf/x86.c               |  4 +--
>>   target/i386/hvf/x86_emu.c           |  6 ++---
>>   target/i386/hvf/x86_task.c          | 10 +++-----
>>   target/i386/hvf/x86hvf.c            |  6 ++---
>>   target/i386/kvm/kvm.c               |  6 ++---
>>   target/i386/kvm/xen-emu.c           | 32 ++++++++---------------
>>   target/i386/tcg/sysemu/bpt_helper.c |  3 +--
>>   target/i386/tcg/tcg-cpu.c           | 14 +++--------
>>   target/i386/tcg/user/excp_helper.c  |  3 +--
>>   target/i386/tcg/user/seg_helper.c   |  3 +--
>>   18 files changed, 59 insertions(+), 140 deletions(-)
>>
> 
> [snip]
> 
>> diff --git a/target/i386/hvf/x86hvf.c b/target/i386/hvf/x86hvf.c
>> index 3b1ef5f49a..1e7fd587fe 100644
>> --- a/target/i386/hvf/x86hvf.c
>> +++ b/target/i386/hvf/x86hvf.c
>> @@ -238,8 +238,7 @@ void hvf_get_msrs(CPUState *cs)
>>   
>>   int hvf_put_registers(CPUState *cs)
>>   {
>> -    X86CPU *x86cpu = X86_CPU(cs);
>> -    CPUX86State *env = &x86cpu->env;
>> +    CPUX86State *env = cpu_env(cs);
>>   
>>       wreg(cs->accel->fd, HV_X86_RAX, env->regs[R_EAX]);
>>       wreg(cs->accel->fd, HV_X86_RBX, env->regs[R_EBX]);
>> @@ -282,8 +281,7 @@ int hvf_put_registers(CPUState *cs)
>>   
>>   int hvf_get_registers(CPUState *cs)
>>   {
>> -    X86CPU *x86cpu = X86_CPU(cs);
>> -    CPUX86State *env = &x86cpu->env;
>> +    CPUX86State *env = cpu_env(cs);
>>   
>>       env->regs[R_EAX] = rreg(cs->accel->fd, HV_X86_RAX);
>>       env->regs[R_EBX] = rreg(cs->accel->fd, HV_X86_RBX);
> 
> In this file, there's another corner case:
> 
> diff --git a/target/i386/hvf/x86hvf.c b/target/i386/hvf/x86hvf.c
> index 3b1ef5f49a8a..9a145aa5aa4f 100644
> --- a/target/i386/hvf/x86hvf.c
> +++ b/target/i386/hvf/x86hvf.c
> @@ -342,8 +342,7 @@ void vmx_clear_int_window_exiting(CPUState *cs)
> 
>   bool hvf_inject_interrupts(CPUState *cs)
>   {
> -    X86CPU *x86cpu = X86_CPU(cs);
> -    CPUX86State *env = &x86cpu->env;
> +    CPUX86State *env = cpu_env(cs);
> 
>       uint8_t vector;
>       uint64_t intr_type;
> @@ -408,7 +407,7 @@ bool hvf_inject_interrupts(CPUState *cs)
>       if (!(env->hflags & HF_INHIBIT_IRQ_MASK) &&
>           (cs->interrupt_request & CPU_INTERRUPT_HARD) &&
>           (env->eflags & IF_MASK) && !(info & VMCS_INTR_VALID)) {
> -        int line = cpu_get_pic_interrupt(&x86cpu->env);
> +        int line = cpu_get_pic_interrupt(env);
>           cs->interrupt_request &= ~CPU_INTERRUPT_HARD;
>           if (line >= 0) {
>               wvmcs(cs->accel->fd, VMCS_ENTRY_INTR_INFO, line |
> 
> 
> For this special case, I'm not sure if the script can cover it as well,
> otherwise maybe it's OK to be cleaned up manually ;-).

BTW I forgot to mention I had to skip target/i386/tcg/translate.c
(7100 LoC) because it is too complex for Coccinelle.

