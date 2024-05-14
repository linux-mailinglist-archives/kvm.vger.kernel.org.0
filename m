Return-Path: <kvm+bounces-17369-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3CEAE8C4D72
	for <lists+kvm@lfdr.de>; Tue, 14 May 2024 10:06:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E4042283BA1
	for <lists+kvm@lfdr.de>; Tue, 14 May 2024 08:06:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 904CB1862A;
	Tue, 14 May 2024 08:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="EW+TjDsH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D8C317996
	for <kvm@vger.kernel.org>; Tue, 14 May 2024 08:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715673995; cv=none; b=TVFchwSOQDoE1FY5jArCp84MzOzz8FPm1qVjIT3SNKemGvTWzdup5ywCulpCqZ6QFhWL+/V1joSnOlr6LjQ15ZYv2U5JAVVOR78+ohYKdyXzpqMVr8HgG6Az7grDIoQV8kM1c5W33isLUk5hRDOw2R+4AY3YVq/fG6/Ed/7JWw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715673995; c=relaxed/simple;
	bh=wa4C6Ee4ECOYeCIj8wjhLw3SuJWijNKeWZClb1WFn2U=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=djfIQf6g/euKLbyNT9A+NeHOqiP2eDKHy8UqqmqPGyWadXEeM1xP4uJJvn05aTQTQjpT9vAzeBFzRvLO0NIm1mHn/Wyz2+YhAnL0DtzZO6XtqFrUQNGDE6pS24DgcJ2kSIOLm7I6+LIHJz2CdC9dsOBsNUUXa2gy41yRXZ7VmME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=EW+TjDsH; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-420197fba0eso2035885e9.1
        for <kvm@vger.kernel.org>; Tue, 14 May 2024 01:06:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1715673992; x=1716278792; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=pjopg8Hd6ezoM2VPeWMeiUlmhpM5PP4esFYOJITTIpM=;
        b=EW+TjDsHm2Pxm+1mvV9BATFejR590jZ9rWX5XYDjndrAu6rrUUgl+M+nGys1t37I57
         IyrRyBL1Jkn46bIWrPdDhJKIs2EH8Se+/BEs26amQxTZJnAuvyEgwZ3B3NgyP/OmdI/V
         WO0lAWP74Qd4tPq7B3DP6fUVIJdcxJz5xtjSUKV77YVrHN57TkTsqfSI2kfPCbb1xNhE
         z96FgnoePIEwmB480adOdnnNii6OqgNr7wbqtfXGvhbE9bhNJWHmkOpxR8mn8R6yOkex
         QXc30dy2J/8i3ppfBKIuw5s2nSGpQvnJLdC+v5ybk3bM/botPQjtgKmvWDTJ5TcBIQtC
         AjWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715673992; x=1716278792;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pjopg8Hd6ezoM2VPeWMeiUlmhpM5PP4esFYOJITTIpM=;
        b=MBw0X3J4CJD6LQ/5vUF7o63/9aMf8Dy1iX1WMydZRUSQycBxAKSfriSaQDY/bfw1CI
         KJy+BM1Ed2GSm4HpGfi0Y7We5fIMp8gWkS3OFZfy2lvk7w+2D/mM8aaxfr/ZPmRBh6Vu
         RD24Cd7W3/oasXuyyd3NFEhYDuXqVD2dQytnUEnDAkWPJQ0In/bwzLdhM4Q43w0Nmm+P
         L9Gws/ncJrXLOZ60W/MqAREcuhcPp2CqmIuDX6m9MQAjqCbqcxsID+1FDBXhpVsdj5OU
         iKKgY9U7KmbH+NBourcAHiS8v1wt0cg2iVgMd4ziXoHFc5HpvnQC6UPUiH2uZxkVsw5P
         WTrg==
X-Forwarded-Encrypted: i=1; AJvYcCUguqjS0bg1Esl8z72/JhxGhWBTl9QUw/dd+8O5PGy8ZOcJIdYBnJw2GmLevZRbDvPS57TGFmEHB0cYzJnDmR98cVbz
X-Gm-Message-State: AOJu0YxdFgN+lEhecnHKVWn5UKRMLBytKNMAaYUHrguU2dhYCPg8FGXg
	ThniSMwOPpzWD3cKejB3PE70pDfm+EZLpejKIZFXqAuhT1VjwKzLHpbGNnlj45I=
X-Google-Smtp-Source: AGHT+IHrTYyJeDAN6oeeNkuklJ3k4rzrTPEj0NJCPsHETslMiuk4YMPVJXS8JcMds7tACAEYtoHs+w==
X-Received: by 2002:adf:ff92:0:b0:34d:8ccf:c9ce with SMTP id ffacd0b85a97d-3504a967162mr8354223f8f.5.1715673992206;
        Tue, 14 May 2024 01:06:32 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:999:a3a0:1660:5f6e:2f9c:91b9? ([2a01:e0a:999:a3a0:1660:5f6e:2f9c:91b9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3502b896b0bsm13038230f8f.46.2024.05.14.01.06.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 May 2024 01:06:31 -0700 (PDT)
Message-ID: <e33b8eba-85f0-44b7-8a6f-802a6979f6c8@rivosinc.com>
Date: Tue, 14 May 2024 10:06:31 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
Subject: Re: [RFC PATCH 5/7] riscv: add double trap driver
To: Deepak Gupta <debug@rivosinc.com>
Cc: Conor Dooley <conor@kernel.org>, Rob Herring <robh+dt@kernel.org>,
 Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>,
 linux-riscv@lists.infradead.org, devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 kvm-riscv@lists.infradead.org, Ved Shanbhogue <ved@rivosinc.com>
References: <20240418142701.1493091-1-cleger@rivosinc.com>
 <20240418142701.1493091-6-cleger@rivosinc.com>
 <Ziw//90J0WfOY/tl@debug.ba.rivosinc.com>
Content-Language: en-US
In-Reply-To: <Ziw//90J0WfOY/tl@debug.ba.rivosinc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 27/04/2024 01:59, Deepak Gupta wrote:
> On Thu, Apr 18, 2024 at 04:26:44PM +0200, Clément Léger wrote:
>> Add a small driver to request double trap enabling as well as
>> registering a SSE handler for double trap. This will also be used by KVM
>> SBI FWFT extension support to detect if it is possible to enable double
>> trap in VS-mode.
>>
>> Signed-off-by: Clément Léger <cleger@rivosinc.com>
>> ---
>> arch/riscv/include/asm/sbi.h    |  1 +
>> drivers/firmware/Kconfig        |  7 +++
>> drivers/firmware/Makefile       |  1 +
>> drivers/firmware/riscv_dbltrp.c | 95 +++++++++++++++++++++++++++++++++
>> include/linux/riscv_dbltrp.h    | 19 +++++++
>> 5 files changed, 123 insertions(+)
>> create mode 100644 drivers/firmware/riscv_dbltrp.c
>> create mode 100644 include/linux/riscv_dbltrp.h
>>
>> diff --git a/arch/riscv/include/asm/sbi.h b/arch/riscv/include/asm/sbi.h
>> index 744aa1796c92..9cd4ca66487c 100644
>> --- a/arch/riscv/include/asm/sbi.h
>> +++ b/arch/riscv/include/asm/sbi.h
>> @@ -314,6 +314,7 @@ enum sbi_sse_attr_id {
>> #define SBI_SSE_ATTR_INTERRUPTED_FLAGS_SPIE    (1 << 2)
>>
>> #define SBI_SSE_EVENT_LOCAL_RAS        0x00000000
>> +#define SBI_SSE_EVENT_LOCAL_DOUBLE_TRAP    0x00000001
>> #define SBI_SSE_EVENT_GLOBAL_RAS    0x00008000
>> #define SBI_SSE_EVENT_LOCAL_PMU        0x00010000
>> #define SBI_SSE_EVENT_LOCAL_SOFTWARE    0xffff0000
>> diff --git a/drivers/firmware/Kconfig b/drivers/firmware/Kconfig
>> index 59f611288807..a037f6e89942 100644
>> --- a/drivers/firmware/Kconfig
>> +++ b/drivers/firmware/Kconfig
>> @@ -197,6 +197,13 @@ config RISCV_SSE_TEST
>>       Select if you want to enable SSE extension testing at boot time.
>>       This will run a series of test which verifies SSE sanity.
>>
>> +config RISCV_DBLTRP
>> +    bool "Enable Double trap handling"
>> +    depends on RISCV_SSE && RISCV_SBI
>> +    default n
>> +    help
>> +      Select if you want to enable SSE double trap handler.
>> +
>> config SYSFB
>>     bool
>>     select BOOT_VESA_SUPPORT
>> diff --git a/drivers/firmware/Makefile b/drivers/firmware/Makefile
>> index fb7b0c08c56d..ad67a1738c0f 100644
>> --- a/drivers/firmware/Makefile
>> +++ b/drivers/firmware/Makefile
>> @@ -18,6 +18,7 @@ obj-$(CONFIG_RASPBERRYPI_FIRMWARE) += raspberrypi.o
>> obj-$(CONFIG_FW_CFG_SYSFS)    += qemu_fw_cfg.o
>> obj-$(CONFIG_RISCV_SSE)        += riscv_sse.o
>> obj-$(CONFIG_RISCV_SSE_TEST)    += riscv_sse_test.o
>> +obj-$(CONFIG_RISCV_DBLTRP)    += riscv_dbltrp.o
>> obj-$(CONFIG_SYSFB)        += sysfb.o
>> obj-$(CONFIG_SYSFB_SIMPLEFB)    += sysfb_simplefb.o
>> obj-$(CONFIG_TI_SCI_PROTOCOL)    += ti_sci.o
>> diff --git a/drivers/firmware/riscv_dbltrp.c
>> b/drivers/firmware/riscv_dbltrp.c
>> new file mode 100644
>> index 000000000000..72f9a067e87a
>> --- /dev/null
>> +++ b/drivers/firmware/riscv_dbltrp.c
>> @@ -0,0 +1,95 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +/*
>> + * Copyright (C) 2023 Rivos Inc.
>> + */
> 
> nit: fix copyright year
>> +
>> +#define pr_fmt(fmt) "riscv-dbltrp: " fmt
>> +
>> +#include <linux/cpu.h>
>> +#include <linux/init.h>
>> +#include <linux/riscv_dbltrp.h>
>> +#include <linux/riscv_sse.h>
>> +
>> +#include <asm/sbi.h>
>> +
>> +static bool double_trap_enabled;
>> +
>> +static int riscv_sse_dbltrp_handle(uint32_t evt, void *arg,
>> +                   struct pt_regs *regs)
>> +{
>> +    __show_regs(regs);
>> +    panic("Double trap !\n");
>> +
>> +    return 0;
> Curious:
> Does panic return?
> What's the point of returning from here?

Hi Deepak,

No, panic() does not return and indeed, the "return 0" is useless. It's
a leftover of a previous implementation without panic in order to keep
GCC mouth shut ;).

> 
>> +}
>> +
>> +struct cpu_dbltrp_data {
>> +    int error;
>> +};
>> +
>> +static void
>> +sbi_cpu_enable_double_trap(void *data)
>> +{
>> +    struct sbiret ret;
>> +    struct cpu_dbltrp_data *cdd = data;
>> +
>> +    ret = sbi_ecall(SBI_EXT_FWFT, SBI_EXT_FWFT_SET,
>> +            SBI_FWFT_DOUBLE_TRAP_ENABLE, 1, 0, 0, 0, 0);
>> +
>> +    if (ret.error) {
>> +        cdd->error = 1;
>> +        pr_err("Failed to enable double trap on cpu %d\n",
>> smp_processor_id());
>> +    }
>> +}
>> +
>> +static int sbi_enable_double_trap(void)
>> +{
>> +    struct cpu_dbltrp_data cdd = {0};
>> +
>> +    on_each_cpu(sbi_cpu_enable_double_trap, &cdd, 1);
>> +    if (cdd.error)
>> +        return -1;
> 
> There is a bug here. If `sbi_cpu_enable_double_trap` failed on all cpus
> but last cpu.
> Then cdd.error would not record error and will be reflect as if double
> trap was enabled.

cdd.error is only written in case of error by the per-cpu callbacks, so
it is only set if enabled failed. Is there something I'm missing ?

Thanks,

Clément

> 
> Its less likely to happen that FW would return success for one cpu and
> fail for others.
> But there is non-zero probablity here.
> 


