Return-Path: <kvm+bounces-35684-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 38247A141EB
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 20:02:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 524F516A892
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 19:02:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFA0C22D4C3;
	Thu, 16 Jan 2025 19:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="K6QG6fsf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC6C11547E2
	for <kvm@vger.kernel.org>; Thu, 16 Jan 2025 19:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737054147; cv=none; b=SFJnnaS5aebwZO/mBwwWmokGqc0rf8cjEbMhqgpTE+Rxj56SeDW8PO3MZfFB6zAYbU91gEHMEqqv2EP9SXrSdOT8oIAJix1oJMvGT7hs5EYESvSxwHRngsIGleZJj+0b/C7cUyBRuoGR7dCgEalfakQE8TFer2qBzDBi6FIsxHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737054147; c=relaxed/simple;
	bh=w7S+OkrPRN7S4G/rcZSDLEZ1iuNJGLBjlSA9rWT39ss=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=MWx6fEvqHu/dZX2+tHvB5D3ts/Z/fBzU2lRxD256w+lA9Rhjn2eizCF1scgYVnfxKbv1IWpgb4QqssAtyueIW50Ti2FUT4k3QAdh45NvmA4mFlCu/SWoPQBtVdcVGFkIDwXVeHA/RFK51qZxjWViUkxD6lLwafhN5yPTToxnM1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=K6QG6fsf; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-385eed29d17so761465f8f.0
        for <kvm@vger.kernel.org>; Thu, 16 Jan 2025 11:02:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1737054143; x=1737658943; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=fuRyw5EWWx6Yp+3IBCpdAz3q5PYO8xyuKBCIsOMef9E=;
        b=K6QG6fsfU+bHivXRHQw1GOWhXPCV2UHXXS4SWgqmoTX+AnCEdiDarWDwXQp1sUTksp
         xBwgo3D+PFLJXjnr7QA+E/vrPnFE1PzFnqPN/y529rMPm2xz/gLgDUwR304AoZE3GdPd
         eV+084qPJV9lswjNz1yfTV94FMpjL+fs32v1c1KoKPWvwomftWVTYaGBiohRHMsyV/3c
         5kdHdoTLDVhnKdu9tV0lm6jP3GzUByrBYIneWQb/o6PkyvXBNVDjPFhAnlq3c/ZI2b4c
         AFOb4S/8oZ+Sck8D23MNbBZaOyBbOjOrH2x5pBhQes543PFdRL2YXweLYyCjcfeV7dah
         OTRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737054143; x=1737658943;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fuRyw5EWWx6Yp+3IBCpdAz3q5PYO8xyuKBCIsOMef9E=;
        b=tKelZ4TABueeuEol58b+w9uAuD9zg+LHlA+aTe0CkyUV7QFa2n954t2WTdN/f39fU/
         7lPOYD9GgpRgnBWAtpclPFg2ilGrHP+nMXxC3xex94tEZdOYbqsd2htg34hhxgTsuDui
         sbvbBEJobZh/3BLcGhfr2oAGbxR649x39KJdLoki7hBF1imFnu9Otct0C2bjrkN8ec91
         GgHrUmPNUf5IeyCqt2HjUKQKvQeMTyDWti3bW1QigcuOoVn8Pr1CCP/EE9VtVBUDLePH
         I19dd56Vg5/AQH3mL1f460xXeldvZXnGiy6psOxOmtFd5BBFGLBoFu57K5ixh/i/Ou2O
         JDeg==
X-Forwarded-Encrypted: i=1; AJvYcCWhaDw8jqgeYlXo2+b1OVyrNlOTlpdHlh451KDNXF8KYqoZAftKXxXeX+XF80iys2a92kw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy3oFcu0SbbAI4QGvPcLXm4CP079gUBfm6sMbRSdcwAAGb6n2Yv
	EXvEIttAWQo/cSTrYSepjQeItAUDg7w4GmFREtMr+6fVwozxxQ9C5WTOfYqKd1U=
X-Gm-Gg: ASbGncvnO6sZxy648qqeqy0vLffifE1rW73AzdCl2OS3lTcGNgnGjjJS8YpzRKiz7DM
	jnBNbXm5Li6zdraMm4X9HdA8xZVkbG5d5PJZls6k/X4aluP2Hz4P0pHKyz4HjjFQ0zT2Dlfds+0
	+QNVFwn6iMmih9GdeXDyeYMUTVR6GgiIOEw4AG2jGADRuNpB9TVUrtypiL/AN17m5zz83vXohdx
	onfriFB/FvfMGh5FLLIPWOQ9OGJeC9B2pc248j25NnFnGn5oqtawQJQ/Mfyg9pldpdctCnNO5W6
	QUjtfUghDriSIbqFBPkK2Zvl
X-Google-Smtp-Source: AGHT+IEcSQubzWb3CBuT1dMQ1/yjGUHi79uHcxM8wbngetpI0P1jFH07ZTZYoEfZXlXddWqceC+h5Q==
X-Received: by 2002:a5d:64a8:0:b0:385:e429:e591 with SMTP id ffacd0b85a97d-38a8730a6bdmr34444859f8f.23.1737054142828;
        Thu, 16 Jan 2025 11:02:22 -0800 (PST)
Received: from [192.168.69.151] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43890421fabsm7885525e9.24.2025.01.16.11.02.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jan 2025 11:02:22 -0800 (PST)
Message-ID: <b55ea724-cdc7-4e8c-a954-b10a1cde9bdd@linaro.org>
Date: Thu, 16 Jan 2025 20:02:18 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 06/22] exec/cpu: Call cpu_remove_sync() once in
 cpu_common_unrealize()
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: Igor Mammedov <imammedo@redhat.com>
Cc: qemu-devel@nongnu.org, Laurent Vivier <laurent@vivier.eu>,
 Paolo Bonzini <pbonzini@redhat.com>, Max Filippov <jcmvbkbc@gmail.com>,
 David Hildenbrand <david@redhat.com>, Peter Xu <peterx@redhat.com>,
 Anton Johansson <anjo@rev.ng>, Peter Maydell <peter.maydell@linaro.org>,
 kvm@vger.kernel.org, Marek Vasut <marex@denx.de>,
 David Gibson <david@gibson.dropbear.id.au>, Brian Cain <bcain@quicinc.com>,
 Yoshinori Sato <ysato@users.sourceforge.jp>,
 "Edgar E . Iglesias" <edgar.iglesias@gmail.com>,
 Claudio Fontana <cfontana@suse.de>,
 Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
 Artyom Tarasenko <atar4qemu@gmail.com>, Marcelo Tosatti
 <mtosatti@redhat.com>, qemu-ppc@nongnu.org,
 Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
 Aurelien Jarno <aurelien@aurel32.net>, Ilya Leoshkevich <iii@linux.ibm.com>,
 Daniel Henrique Barboza <danielhb413@gmail.com>,
 Bastian Koppelmann <kbastian@mail.uni-paderborn.de>,
 =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@kaod.org>,
 Alistair Francis <alistair.francis@wdc.com>,
 Alessandro Di Federico <ale@rev.ng>, Song Gao <gaosong@loongson.cn>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Chris Wulff <crwulff@gmail.com>, "Michael S. Tsirkin" <mst@redhat.com>,
 Alistair Francis <alistair@alistair23.me>, Fabiano Rosas <farosas@suse.de>,
 qemu-s390x@nongnu.org, Yanan Wang <wangyanan55@huawei.com>,
 Luc Michel <luc@lmichel.fr>, Weiwei Li <liweiwei@iscas.ac.cn>,
 Bin Meng <bin.meng@windriver.com>, Stafford Horne <shorne@gmail.com>,
 Xiaojuan Yang <yangxiaojuan@loongson.cn>,
 "Daniel P . Berrange" <berrange@redhat.com>, Thomas Huth <thuth@redhat.com>,
 qemu-arm@nongnu.org, Jiaxun Yang <jiaxun.yang@flygoat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
 Bernhard Beschow <shentey@gmail.com>,
 Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>, qemu-riscv@nongnu.org,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 Nicholas Piggin <npiggin@gmail.com>, Greg Kurz <groug@kaod.org>,
 Michael Rolnik <mrolnik@gmail.com>, Eduardo Habkost <eduardo@habkost.net>,
 Markus Armbruster <armbru@redhat.com>, Palmer Dabbelt <palmer@dabbelt.com>
References: <20230918160257.30127-1-philmd@linaro.org>
 <20230918160257.30127-7-philmd@linaro.org>
 <20231128174215.32d2a350@imammedo.users.ipa.redhat.com>
 <5f25576c-598f-4fd7-8238-61edcff2c411@linaro.org>
Content-Language: en-US
In-Reply-To: <5f25576c-598f-4fd7-8238-61edcff2c411@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 16/1/25 19:05, Philippe Mathieu-Daudé wrote:
> On 28/11/23 17:42, Igor Mammedov wrote:
>> On Mon, 18 Sep 2023 18:02:39 +0200
>> Philippe Mathieu-Daudé <philmd@linaro.org> wrote:
>>
>>> While create_vcpu_thread() creates a vCPU thread, its counterpart
>>> is cpu_remove_sync(), which join and destroy the thread.
>>>
>>> create_vcpu_thread() is called in qemu_init_vcpu(), itself called
>>> in cpu_common_realizefn(). Since we don't have qemu_deinit_vcpu()
>>> helper (we probably don't need any), simply destroy the thread in
>>> cpu_common_unrealizefn().
>>>
>>> Note: only the PPC and X86 targets were calling cpu_remove_sync(),
>>> meaning all other targets were leaking the thread when the vCPU
>>> was unrealized (mostly when vCPU are hot-unplugged).
>>>
>>> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
>>> ---
>>>   hw/core/cpu-common.c  | 3 +++
>>>   target/i386/cpu.c     | 1 -
>>>   target/ppc/cpu_init.c | 2 --
>>>   3 files changed, 3 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/hw/core/cpu-common.c b/hw/core/cpu-common.c
>>> index a3b8de7054..e5841c59df 100644
>>> --- a/hw/core/cpu-common.c
>>> +++ b/hw/core/cpu-common.c
>>> @@ -221,6 +221,9 @@ static void cpu_common_unrealizefn(DeviceState *dev)
>>>       /* NOTE: latest generic point before the cpu is fully 
>>> unrealized */
>>>       cpu_exec_unrealizefn(cpu);
>>> +
>>> +    /* Destroy vCPU thread */
>>> +    cpu_remove_sync(cpu);
>>>   }
>>>   static void cpu_common_initfn(Object *obj)
>>> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
>>> index cb41d30aab..d79797d963 100644
>>> --- a/target/i386/cpu.c
>>> +++ b/target/i386/cpu.c
>>> @@ -7470,7 +7470,6 @@ static void x86_cpu_unrealizefn(DeviceState *dev)
>>>       X86CPUClass *xcc = X86_CPU_GET_CLASS(dev);
>>>   #ifndef CONFIG_USER_ONLY
>>> -    cpu_remove_sync(CPU(dev));
>>>       qemu_unregister_reset(x86_cpu_machine_reset_cb, dev);
>>>   #endif
>>
>> missing  followup context:
>>      ...
>>      xcc->parent_unrealize(dev);
>>
>> Before the patch, vcpu thread is stopped and onnly then
>> clean up happens.
>>
>> After the patch we have cleanup while vcpu thread is still running.
>>
>> Even if it doesn't explode, such ordering still seems to be wrong.
> 
> OK.
> 
>>> diff --git a/target/ppc/cpu_init.c b/target/ppc/cpu_init.c
>>> index e2c06c1f32..24d4e8fa7e 100644
>>> --- a/target/ppc/cpu_init.c
>>> +++ b/target/ppc/cpu_init.c
>>> @@ -6853,8 +6853,6 @@ static void ppc_cpu_unrealize(DeviceState *dev)
>>>       pcc->parent_unrealize(dev);
>>> -    cpu_remove_sync(CPU(cpu));
>>
>> bug in current code?
> 
> Plausibly. See:
> 
> commit f1023d21e81b7bf523ddf2ac91a48117f20ef9d7
> Author: Greg Kurz <groug@kaod.org>
> Date:   Thu Oct 15 23:18:32 2020 +0200
> 
>      spapr: Unrealize vCPUs with qdev_unrealize()
> 
>      Since we introduced CPU hot-unplug in sPAPR, we don't unrealize the
>      vCPU objects explicitly. Instead, we let QOM handle that for us
>      under object_property_del_all() when the CPU core object is
>      finalized. The only thing we do is calling cpu_remove_sync() to
>      tear the vCPU thread down.
> 
>      This happens to work but it is ugly because:
>      - we call qdev_realize() but the corresponding qdev_unrealize() is
>        buried deep in the QOM code
>      - we call cpu_remove_sync() to undo qemu_init_vcpu() called by
>        ppc_cpu_realize() in target/ppc/translate_init.c.inc
>      - the CPU init and teardown paths aren't really symmetrical
> 
>      The latter didn't bite us so far but a future patch that greatly
>      simplifies the CPU core realize path needs it to avoid a crash
>      in QOM.
> 
>      For all these reasons, have ppc_cpu_unrealize() to undo the changes
>      of ppc_cpu_realize() by calling cpu_remove_sync() at the right
>      place, and have the sPAPR CPU core code to call qdev_unrealize().
> 
>      This requires to add a missing stub because translate_init.c.inc is
>      also compiled for user mode.

See also:

commit 5e22e29201d80124bca0124f2034e72b698cbb6f
Author: David Gibson <david@gibson.dropbear.id.au>
Date:   Wed Jun 13 12:08:42 2018 +1000

     pnv: Add cpu unrealize path

     Currently we don't have any unrealize path for pnv cpu cores.
     We get away with this because we don't yet support cpu hotplug
     for pnv.

     However, we're going to want it eventually, and in the meantime,
     it makes it non-obvious why there are a bunch of allocations on
     the realize() path that don't have matching frees.

     So, implement the missing unrealize path.

diff --git a/hw/ppc/pnv_core.c b/hw/ppc/pnv_core.c
index f4c41d89d6d..f7cf33f547a 100644
--- a/hw/ppc/pnv_core.c
+++ b/hw/ppc/pnv_core.c
@@ -186,6 +186,26 @@ err:
      error_propagate(errp, local_err);
  }

+static void pnv_unrealize_vcpu(PowerPCCPU *cpu)
+{
+    qemu_unregister_reset(pnv_cpu_reset, cpu);
+    object_unparent(cpu->intc);
+    cpu_remove_sync(CPU(cpu));
+    object_unparent(OBJECT(cpu));
+}


