Return-Path: <kvm+bounces-35682-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 683E7A1416F
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 19:06:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 83B53167FDE
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 18:05:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E32222D4E2;
	Thu, 16 Jan 2025 18:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="JMKGJTWV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEDE614EC4E
	for <kvm@vger.kernel.org>; Thu, 16 Jan 2025 18:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737050753; cv=none; b=BDQdf8IJZWIYThRo6Tce44zaM2m9PKjhRpULaR6sN2rZZuPxqC33eFDwA3WMAKxC5BKDJGeYojbyNB3jRG+YcbQJiClFfOwE50TF/U52f2YwViHw9IqCstmBq+CENFeH4mmsjT78NhncE+o6gIaq6Y5ZD7mmYylFFvqWhCDQCB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737050753; c=relaxed/simple;
	bh=ijoVL96Gv6iHqICRsMMtm9LOhroNIMwVmR0QHQThSj8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LQviQP6ZF1YZcmL9hHFh8cE2dW8HwHXG6tW/vwIsmmKyMlTAWqHI2YwP9Q+5ptYUitYEcXhh1zSljf/bEBuv+y91yMImjqIliF407+CpvlEe3x/VJ2RbIXEKwWSd5zcH3I11Ir0bNlD9vKnKE9fFzAnvzmF1RrPBtxEz372Vwm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=JMKGJTWV; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-436a03197b2so8025875e9.2
        for <kvm@vger.kernel.org>; Thu, 16 Jan 2025 10:05:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1737050750; x=1737655550; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Rhp05gJbQRlTNfvgsZGYVcl1Q/y5Mvv1WzUV/6aq+RQ=;
        b=JMKGJTWVO9o4WPGZVoM00nU5K5egAqsGQ10NUJNEM7pJup+T2sGIFRUuYbGd8RwbH0
         6p8Im8XF1ie9fb6VeyDuSQOZg72eC489ZatRNDAGI2z7xGDWNJG4Mf5izm9u7Bn9bW+k
         SIt2cLyCdf1bKiy2mJiyLGMTQPvhsanEpvqIBC3hbsP7lfcczI4W/aVHWP+NHZnc0Erz
         oq3KbMLvcS59FWeKo+hphRcO1xwLhx7DEHB8sfU6Ujz8ULtjobIjY28iUeFvY/r5fsAH
         IHpwW/ZQB12IzHXFDelqqVH+ueBtfiMzKC2XyWIXuvP/PYIVsQz/vzeK1sA/BFN1c5bg
         TlqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737050750; x=1737655550;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Rhp05gJbQRlTNfvgsZGYVcl1Q/y5Mvv1WzUV/6aq+RQ=;
        b=pFYMUOt+ZkyBYCo/nrWtp2N9KkSd7xDq2F5XEmp5G8g0Rs5T6GzN0tciEvqklOqnCX
         B70pk8HdxPNHb3kVetBv12+kWNTslrFSnoyQ7F9qaGeW2nm8dSUIHxCTsrWdUpuTsFXm
         4nK+9b0YhRUnZ5bE5tzrri+R3ZHWrcMLfS4W1fWRXp8tAitdbzrsCQj7O4ip2q0Qs9o5
         CW6PjpG+pkLMu0zlXziw421GXotpiL7+ZD6R6m+4SSzY/ctRBauei5W4Vo1JRm+PRb5L
         Tpcg9+53WcnsBby1q6BB72uD6oE+nj9JPDVqR0DJkQOwROLMwul4T6J8sp13s4NtH2FZ
         adhA==
X-Forwarded-Encrypted: i=1; AJvYcCV8pdu6g/xlSIA94h8ohL7j1sAfdSMfXJwIktltzDmsDFZAumx0qnijFC7HuJMUxbt1DAo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx/V6pz4MsnQ9q5a/6E4symy0AvRrIxCkG3F6FNeVpnQfWuk75M
	S60lXcUeS10OYgbN/tjNQWiqzyrTl4VwB2G5S0iaR+bj5DJl7mjxfC1X000sdgE=
X-Gm-Gg: ASbGncvzWFwVZu73orlaXLrz7Q3Uu3xDP3rnyipGm0aOxTpEZA7AjWRNi9pE2f2h8C5
	tRo/hu4NIGc9jvSRUkSpmFnOzkK2MgIUmLcbI5gCqPVynfPIdKilmxt8PR0DWBY4fwJ9ef6f1KM
	pepJmoU4mQaUGT1JxU6k1IdfGki3biuBaBWyy0RXIEe1rRlQSaNKYOmC+oI1rFLU1MY9Ymw6b8x
	yBMz9fNNcnkjuKxv/u3GbxmX2e9bbpuwNE3SH5g36TE/DCp6jX+55/n/uWoCtcCxA4sL1NSvNM3
	UBzU0WA39eDjEkjdAILvtFSt
X-Google-Smtp-Source: AGHT+IE7PicfAMlxA+nlONgB6VhOPYA3/3n8nOIee+iKmvhp7eYMFXXEQKotYDBpJUtL/z/v/0EW/g==
X-Received: by 2002:a05:600c:314b:b0:434:f270:a513 with SMTP id 5b1f17b1804b1-436e26ff288mr247488285e9.29.1737050749887;
        Thu, 16 Jan 2025 10:05:49 -0800 (PST)
Received: from [192.168.69.151] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43890367b48sm6925895e9.0.2025.01.16.10.05.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jan 2025 10:05:48 -0800 (PST)
Message-ID: <5f25576c-598f-4fd7-8238-61edcff2c411@linaro.org>
Date: Thu, 16 Jan 2025 19:05:46 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 06/22] exec/cpu: Call cpu_remove_sync() once in
 cpu_common_unrealize()
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
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20231128174215.32d2a350@imammedo.users.ipa.redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 28/11/23 17:42, Igor Mammedov wrote:
> On Mon, 18 Sep 2023 18:02:39 +0200
> Philippe Mathieu-Daudé <philmd@linaro.org> wrote:
> 
>> While create_vcpu_thread() creates a vCPU thread, its counterpart
>> is cpu_remove_sync(), which join and destroy the thread.
>>
>> create_vcpu_thread() is called in qemu_init_vcpu(), itself called
>> in cpu_common_realizefn(). Since we don't have qemu_deinit_vcpu()
>> helper (we probably don't need any), simply destroy the thread in
>> cpu_common_unrealizefn().
>>
>> Note: only the PPC and X86 targets were calling cpu_remove_sync(),
>> meaning all other targets were leaking the thread when the vCPU
>> was unrealized (mostly when vCPU are hot-unplugged).
>>
>> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
>> ---
>>   hw/core/cpu-common.c  | 3 +++
>>   target/i386/cpu.c     | 1 -
>>   target/ppc/cpu_init.c | 2 --
>>   3 files changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/hw/core/cpu-common.c b/hw/core/cpu-common.c
>> index a3b8de7054..e5841c59df 100644
>> --- a/hw/core/cpu-common.c
>> +++ b/hw/core/cpu-common.c
>> @@ -221,6 +221,9 @@ static void cpu_common_unrealizefn(DeviceState *dev)
>>   
>>       /* NOTE: latest generic point before the cpu is fully unrealized */
>>       cpu_exec_unrealizefn(cpu);
>> +
>> +    /* Destroy vCPU thread */
>> +    cpu_remove_sync(cpu);
>>   }
>>   
>>   static void cpu_common_initfn(Object *obj)
>> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
>> index cb41d30aab..d79797d963 100644
>> --- a/target/i386/cpu.c
>> +++ b/target/i386/cpu.c
>> @@ -7470,7 +7470,6 @@ static void x86_cpu_unrealizefn(DeviceState *dev)
>>       X86CPUClass *xcc = X86_CPU_GET_CLASS(dev);
>>   
>>   #ifndef CONFIG_USER_ONLY
>> -    cpu_remove_sync(CPU(dev));
>>       qemu_unregister_reset(x86_cpu_machine_reset_cb, dev);
>>   #endif
> 
> missing  followup context:
>      ...
>      xcc->parent_unrealize(dev);
> 
> Before the patch, vcpu thread is stopped and onnly then
> clean up happens.
> 
> After the patch we have cleanup while vcpu thread is still running.
> 
> Even if it doesn't explode, such ordering still seems to be wrong.

OK.

>> diff --git a/target/ppc/cpu_init.c b/target/ppc/cpu_init.c
>> index e2c06c1f32..24d4e8fa7e 100644
>> --- a/target/ppc/cpu_init.c
>> +++ b/target/ppc/cpu_init.c
>> @@ -6853,8 +6853,6 @@ static void ppc_cpu_unrealize(DeviceState *dev)
>>   
>>       pcc->parent_unrealize(dev);
>>   
>> -    cpu_remove_sync(CPU(cpu));
> 
> bug in current code?

Plausibly. See:

commit f1023d21e81b7bf523ddf2ac91a48117f20ef9d7
Author: Greg Kurz <groug@kaod.org>
Date:   Thu Oct 15 23:18:32 2020 +0200

     spapr: Unrealize vCPUs with qdev_unrealize()

     Since we introduced CPU hot-unplug in sPAPR, we don't unrealize the
     vCPU objects explicitly. Instead, we let QOM handle that for us
     under object_property_del_all() when the CPU core object is
     finalized. The only thing we do is calling cpu_remove_sync() to
     tear the vCPU thread down.

     This happens to work but it is ugly because:
     - we call qdev_realize() but the corresponding qdev_unrealize() is
       buried deep in the QOM code
     - we call cpu_remove_sync() to undo qemu_init_vcpu() called by
       ppc_cpu_realize() in target/ppc/translate_init.c.inc
     - the CPU init and teardown paths aren't really symmetrical

     The latter didn't bite us so far but a future patch that greatly
     simplifies the CPU core realize path needs it to avoid a crash
     in QOM.

     For all these reasons, have ppc_cpu_unrealize() to undo the changes
     of ppc_cpu_realize() by calling cpu_remove_sync() at the right
     place, and have the sPAPR CPU core code to call qdev_unrealize().

     This requires to add a missing stub because translate_init.c.inc is
     also compiled for user mode.

> 
>> -
>>       destroy_ppc_opcodes(cpu);
>>   }
>>   


