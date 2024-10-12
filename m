Return-Path: <kvm+bounces-28668-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A0BAE99B129
	for <lists+kvm@lfdr.de>; Sat, 12 Oct 2024 08:06:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 681A61C216E3
	for <lists+kvm@lfdr.de>; Sat, 12 Oct 2024 06:06:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09A0313777F;
	Sat, 12 Oct 2024 06:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="evTA9iNK"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A3F94A1E
	for <kvm@vger.kernel.org>; Sat, 12 Oct 2024 06:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728713185; cv=none; b=M8w+T9GxUAkLNO2MIJfGG29Xo//SAE7i9kDpdQmjS//SdTweL5TK1SoBfbVhb4a0x4S0UiDIPGeri23iBXuuH1pDEORoyHimF3HPI1/bnTRlQbRJ7Z5Ey2iBOU/KzFneM9THA7IK0Tw1XoQOo4WfoH6f24CDyEq+60B6KAYuekU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728713185; c=relaxed/simple;
	bh=p3bhdSIz97AK70PkPUevDFL5eUaWsHkk+ULKNm4YWU4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PftOireYLZuLEcXbwYbIWuL/o186W022umkhNu5H0oyNv1r+1us6qZW0cHo8AhpVWOalhrpAlXgsAysWEft4yIAiGo62DpcTq35UxuuqHxjDazswYQRrh7osVSl0PoTmSwj6K2SA0D/L81S8IAsyZkgU+qmEvb8Q85fcgv8xXSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=evTA9iNK; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728713182;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4un6uSmnhR3waOcDWroNwGLqZDQwtwFJTENyZm7BpXg=;
	b=evTA9iNKObsfu6nqfgec4ogiGn9uF4qRvS+kgNUeMpRLMgEezRg9CA5Gzs0MJTgTFK5tFW
	wnrwp4wvdVKkDUa/gMBTxZHHMSvZsHb7I+P/XfTA8XARl/Mcm6cQVg7Yb1o1Yd1xPLApxj
	ZcQQEE5ws6nV2kirTIusaPfL8gfQNfA=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-144-TqI9Brk5PGGzZvnkklhgfg-1; Sat, 12 Oct 2024 02:06:21 -0400
X-MC-Unique: TqI9Brk5PGGzZvnkklhgfg-1
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-6c8f99fef10so3544431a12.3
        for <kvm@vger.kernel.org>; Fri, 11 Oct 2024 23:06:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728713179; x=1729317979;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4un6uSmnhR3waOcDWroNwGLqZDQwtwFJTENyZm7BpXg=;
        b=TP/ui2pBA2PbW+RGluVhEUCJjH+zK3pPL8+AyzyReWHC3X41LFeZ+TnBGVvdVoB340
         baOM3lpa+MoOikbFBSFrxpVYt08BbseqbBNX9++bh37jTduMwKEdIA8OqJoIdxiYghkW
         B7VYS3LvE/VrfAIsn40qCuCXhVwXF7PCs/P8yVglHlK8CJX5DnNsd16H20ArnRaPQhXQ
         h7CuA74mGqtmr++FNKP94yump60SQZgvJJZe1Sh7LdM20XXZ0TUHEoM/jNH01jd6weyy
         lvHXUGA1t15IJxlE5kdyb/uGzmbMlhz547WwSdUU9UusgmOHGHorCV7D88eoHmgHYQaX
         OJwQ==
X-Forwarded-Encrypted: i=1; AJvYcCUzCRODM6grxM4StPIW54LUrqfB8TrCgpGLWJwuufRQoUZZQkEsVeP6IVZPgmabIlDA/Js=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy/1A4ULDMFZP5+z624weai0A5d1nMn82gbj9mCEWs6/AAzgNrE
	sX+bvokimAQjRouSAWxEKlSB3N0i7tnYnFCPP/YDjy4+bRn/s8Jo4HozEiTx60rOHQjkk0YAK/J
	pCqI6/aDwO8ZTa+2SqaRUlUh9hxV7u6clVQ5SQtTtCBZ5omTOnmKbMf3hsw==
X-Received: by 2002:a05:6a21:31c8:b0:1cf:31b6:18d1 with SMTP id adf61e73a8af0-1d8c96c2ce5mr2259092637.48.1728713179234;
        Fri, 11 Oct 2024 23:06:19 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG1eYiTG3wr0KgnhwPFbo8d8nOIzZ9nhtHL32SxmP6Jl4bro0T4stNrN6bmkVU9ob7oecwkzg==
X-Received: by 2002:a05:6a21:31c8:b0:1cf:31b6:18d1 with SMTP id adf61e73a8af0-1d8c96c2ce5mr2258777637.48.1728713172412;
        Fri, 11 Oct 2024 23:06:12 -0700 (PDT)
Received: from [192.168.68.54] ([180.233.125.129])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7ea6e9a5244sm383767a12.69.2024.10.11.23.06.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Oct 2024 23:06:11 -0700 (PDT)
Message-ID: <5999b021-0ae3-4d90-ae29-f18f187fd115@redhat.com>
Date: Sat, 12 Oct 2024 16:06:02 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 10/11] virt: arm-cca-guest: TSM_REPORT support for
 realms
To: Suzuki K Poulose <suzuki.poulose@arm.com>,
 Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Sami Mujawar <sami.mujawar@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, Dan Williams <dan.j.williams@intel.com>,
 "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
References: <20241004144307.66199-1-steven.price@arm.com>
 <20241004144307.66199-11-steven.price@arm.com>
 <5a3432d1-6a79-434c-bc93-6317c8c6435c@redhat.com>
 <6c306817-fbd7-402c-8425-a4523ed43114@arm.com>
 <7a83461d-40fd-4e61-8833-5dae2abaf82b@arm.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <7a83461d-40fd-4e61-8833-5dae2abaf82b@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 10/12/24 2:22 AM, Suzuki K Poulose wrote:
> On 11/10/2024 15:14, Steven Price wrote:
>> On 08/10/2024 05:12, Gavin Shan wrote:
>>> On 10/5/24 12:43 AM, Steven Price wrote:
>>>> From: Sami Mujawar <sami.mujawar@arm.com>
>>>>
>>>> Introduce an arm-cca-guest driver that registers with
>>>> the configfs-tsm module to provide user interfaces for
>>>> retrieving an attestation token.
>>>>
>>>> When a new report is requested the arm-cca-guest driver
>>>> invokes the appropriate RSI interfaces to query an
>>>> attestation token.
>>>>
>>>> The steps to retrieve an attestation token are as follows:
>>>>     1. Mount the configfs filesystem if not already mounted
>>>>        mount -t configfs none /sys/kernel/config
>>>>     2. Generate an attestation token
>>>>        report=/sys/kernel/config/tsm/report/report0
>>>>        mkdir $report
>>>>        dd if=/dev/urandom bs=64 count=1 > $report/inblob
>>>>        hexdump -C $report/outblob
>>>>        rmdir $report
>>>>
>>>> Signed-off-by: Sami Mujawar <sami.mujawar@arm.com>
>>>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>>>> Signed-off-by: Steven Price <steven.price@arm.com>
>>>> ---
>>>> v3: Minor improvements to comments and adapt to the renaming of
>>>> GRANULE_SIZE to RSI_GRANULE_SIZE.
>>>> ---
>>>>    drivers/virt/coco/Kconfig                     |   2 +
>>>>    drivers/virt/coco/Makefile                    |   1 +
>>>>    drivers/virt/coco/arm-cca-guest/Kconfig       |  11 +
>>>>    drivers/virt/coco/arm-cca-guest/Makefile      |   2 +
>>>>    .../virt/coco/arm-cca-guest/arm-cca-guest.c   | 211 ++++++++++++++++++
>>>>    5 files changed, 227 insertions(+)
>>>>    create mode 100644 drivers/virt/coco/arm-cca-guest/Kconfig
>>>>    create mode 100644 drivers/virt/coco/arm-cca-guest/Makefile
>>>>    create mode 100644 drivers/virt/coco/arm-cca-guest/arm-cca-guest.c

[...]

>>>> +/**
>>>> + * arm_cca_report_new - Generate a new attestation token.
>>>> + *
>>>> + * @report: pointer to the TSM report context information.
>>>> + * @data:  pointer to the context specific data for this module.
>>>> + *
>>>> + * Initialise the attestation token generation using the challenge data
>>>> + * passed in the TSM descriptor. Allocate memory for the attestation
>>>> token
>>>> + * and schedule calls to retrieve the attestation token on the same CPU
>>>> + * on which the attestation token generation was initialised.
>>>> + *
>>>> + * The challenge data must be at least 32 bytes and no more than 64
>>>> bytes. If
>>>> + * less than 64 bytes are provided it will be zero padded to 64 bytes.
>>>> + *
>>>> + * Return:
>>>> + * * %0        - Attestation token generated successfully.
>>>> + * * %-EINVAL  - A parameter was not valid.
>>>> + * * %-ENOMEM  - Out of memory.
>>>> + * * %-EFAULT  - Failed to get IPA for memory page(s).
>>>> + * * A negative status code as returned by smp_call_function_single().
>>>> + */
>>>> +static int arm_cca_report_new(struct tsm_report *report, void *data)
>>>> +{
>>>> +    int ret;
>>>> +    int cpu;
>>>> +    long max_size;
>>>> +    unsigned long token_size;
>>>> +    struct arm_cca_token_info info;
>>>> +    void *buf;
>>>> +    u8 *token __free(kvfree) = NULL;
>>>> +    struct tsm_desc *desc = &report->desc;
>>>> +
>>>> +    if (!report)
>>>> +        return -EINVAL;
>>>> +
>>>
>>> This check seems unnecessary and can be dropped.
>>
>> Ack
>>
>>>> +    if (desc->inblob_len < 32 || desc->inblob_len > 64)
>>>> +        return -EINVAL;
>>>> +
>>>> +    /*
>>>> +     * Get a CPU on which the attestation token generation will be
>>>> +     * scheduled and initialise the attestation token generation.
>>>> +     */
>>>> +    cpu = get_cpu();
>>>> +    max_size = rsi_attestation_token_init(desc->inblob,
>>>> desc->inblob_len);
>>>> +    put_cpu();
>>>> +
>>>
>>> It seems that put_cpu() is called early, meaning the CPU can go away before
>>> the subsequent call to arm_cca_attestation_continue() ?
>>
>> Indeed, good spot. I'll move it to the end of the function and update
>> the error paths below.
> 
> Actually this was on purpose, not to block the CPU hotplug. The
> attestation must be completed on the same CPU.
> 
> We can detect the failure from "smp_call" further down and make sure
> we can safely complete the operation or restart it.
> 

Yes, It's fine to call put_cpu() early since we're tolerant to error introduced
by CPU unplug. It's a bit confused that rsi_attestation_token_init() is called
on the local CPU while arm_cca_attestation_continue() is called on same CPU
with help of smp_call_function_single(). Does it make sense to unify so that
both will be invoked with the help of smp_call_function_single() ?

     int cpu = smp_processor_id();

     /*
      * The calling and target CPU can be different after the calling process
      * is migrated to another different CPU. It's guaranteed the attestatation
      * always happen on the target CPU with smp_call_function_single().
      */
     ret = smp_call_function_single(cpu, rsi_attestation_token_init_wrapper,
                                    (void *)&info, true);
     if (ret) {
         ...
     }

     
Thanks,
Gavin


