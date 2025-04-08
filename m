Return-Path: <kvm+bounces-42882-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 504CCA7F3F1
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 07:04:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CC2F33B4DD7
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 05:03:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF95033FE;
	Tue,  8 Apr 2025 05:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ROVzoRdq"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1261253B46
	for <kvm@vger.kernel.org>; Tue,  8 Apr 2025 05:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744088619; cv=none; b=BeEjqL7y0gy1PUNS1sMb79u7ZY/p/i2rSETLFqzhTbLIdByXPqB94t9F01Zg9cQXqDaZzwb2Rwg8tc2t2OIxfyWTs1t6nFck4zAxtAe/i5CC5hGZFufufTd90khqhn0x8fdWEOld8q/2EeHUOv6IweXKnfYKaO7mI48VwZL3bhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744088619; c=relaxed/simple;
	bh=kCrdhF+yR04zpDgvPaEbwrTFya3LR3Mk7SW51smtES0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Hy5Mbl65LnZy/cL0mSWCSrsLgtCfXZ+3xGcdGk7VX3RZAt3ywVtD9xAl6hah628rfJC42tzXrKOezYL73ALle+9uXyouXKGR4YPCv9bqQHHOkhEJ7JP5u6wnJZLg9oIsVh1Bgj+NoXOQ0dMpphtWUXzr8/0oc52+KS9Ov9DYt34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ROVzoRdq; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744088615;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=08d10QPRbou7mD/4AaojdjLjtx5I6e0q1cXfeY1kUxQ=;
	b=ROVzoRdqcORBflZrI0X28PWeP/1HDhDf5UAmp9ah08iW6lD+OJMY3oc7bJ3033IoISHNZX
	m4pQtufXYU9P9RU6EBXddu431M3l9TEw8czwl7QvKaWP+j6M1szSxMfk2eW6WxqOe5o+8H
	OtVf64nEKw5jC4fV8Dn4W70pmYcF1gE=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-164-S9wzNnLnO32pmOvVZAii9A-1; Tue, 08 Apr 2025 01:03:32 -0400
X-MC-Unique: S9wzNnLnO32pmOvVZAii9A-1
X-Mimecast-MFC-AGG-ID: S9wzNnLnO32pmOvVZAii9A_1744088609
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2240a7aceeaso48783705ad.0
        for <kvm@vger.kernel.org>; Mon, 07 Apr 2025 22:03:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744088608; x=1744693408;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=08d10QPRbou7mD/4AaojdjLjtx5I6e0q1cXfeY1kUxQ=;
        b=ESoo02cAAAQA24G3UhFpCk8jt1ITzYhDXBS2I9f2Ecbme0O7BJM04iJFcCFmsIm/Ag
         XRFUnbX62bxnGx55dI8nCKw3YUoRyKu/Cunv/Hm0SqIDJDAhg9bpzkxZqyAhcmJIabHb
         wZGi2JwONanCcFTWTqbowS8dB/6+IzuW44sdrfHQLqs9bkV8MqZu62QEqIGqouWgTIRc
         tibV+c+Dxjy2uO9JungHXMtmJ6fvqJcp0gWvXh6dgp0KKFEsMFeb7frMtxnxOkBEXGqK
         HJ5XVbyFhdG2S+4UwFftb5T+KLYUFQr3Kc8Xz/d52cJAH4mdZW9Ul7D4WDBfltSDmDpl
         4gSA==
X-Forwarded-Encrypted: i=1; AJvYcCW3IZzSOiAQAeNfveyBbmg0//pu7od0XG3dR0nSM8gvgjzj2GoMGIVnwjJnfZ3+g0U/NCE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwhE4NRGEy2NMFWWbYInCCowHM4o4GZHm2eAHpPMq5Ko3ILgVB7
	nlGYGaIjJlwufVFkkXrQgBi6NYShGoziaE501ThFXhNw8YWazh9ZbeP65JKAFsbvtUnCQk7rTXf
	W3JAExMzRErYSecpgEIOzuV43fJKfNsAxntAOGogGVGUCG02nCPIqFL57yg==
X-Gm-Gg: ASbGnctOkXb1HX849jG1gxUh39sNhEnDGF01eGSVRbGo5YTk/Flgnscebab81arpShV
	pqtd9Wl4vR4hZfBbX63BSicIm/Z1vDBaQbBmluRkxrX0YKGSCGgiAmDH0WuNTic/dbbpR8/CPcS
	NlBi3UMC67pSwAKCM4+s6gYkjnRoBscr9rsiMs+VLcWxAgkER2fWIegiakgJcI90AmUEMJ8CFz5
	dkI1YKjyAElQCU+Er3fnZ//+U5JGcGFUQaPZnZ3SRCBhL1hWPHNjM1JkM6zB5U9jT/nmCpQpLC7
	2k69HPQCaLr1H27x
X-Received: by 2002:a17:902:ccce:b0:215:8809:b3b7 with SMTP id d9443c01a7336-22a8a04593emr212605195ad.7.1744088608512;
        Mon, 07 Apr 2025 22:03:28 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGML8JrfPQSGP1sTXgAJbLiBC79RWpQvktKvDF6YE82nc5K0KhNIo0FYjrqKNMDpWPDe5wEjg==
X-Received: by 2002:a17:902:ccce:b0:215:8809:b3b7 with SMTP id d9443c01a7336-22a8a04593emr212604925ad.7.1744088608147;
        Mon, 07 Apr 2025 22:03:28 -0700 (PDT)
Received: from [192.168.68.55] ([180.233.125.65])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-229785c01b7sm90355785ad.96.2025.04.07.22.03.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Apr 2025 22:03:27 -0700 (PDT)
Message-ID: <005ccfb3-b616-4723-b039-b8a3d6fb10bc@redhat.com>
Date: Tue, 8 Apr 2025 15:03:19 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 17/45] arm64: RME: Handle realm enter/exit
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
References: <20250213161426.102987-1-steven.price@arm.com>
 <20250213161426.102987-18-steven.price@arm.com>
 <80983793-5df7-4828-96e8-90540e7d9183@redhat.com>
 <95c06abf-591f-4dd0-b1fd-296b0d5ae924@arm.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <95c06abf-591f-4dd0-b1fd-296b0d5ae924@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 4/8/25 2:34 AM, Steven Price wrote:
> On 04/03/2025 01:03, Gavin Shan wrote:
>> On 2/14/25 2:13 AM, Steven Price wrote:
>>> Entering a realm is done using a SMC call to the RMM. On exit the
>>> exit-codes need to be handled slightly differently to the normal KVM
>>> path so define our own functions for realm enter/exit and hook them
>>> in if the guest is a realm guest.
>>>
>>> Signed-off-by: Steven Price <steven.price@arm.com>
>>> ---
>>> Changes since v6:
>>>    * Use vcpu_err() rather than pr_err/kvm_err when there is an associated
>>>      vcpu to the error.
>>>    * Return -EFAULT for KVM_EXIT_MEMORY_FAULT as per the documentation for
>>>      this exit type.
>>>    * Split code handling a RIPAS change triggered by the guest to the
>>>      following patch.
>>> Changes since v5:
>>>    * For a RIPAS_CHANGE request from the guest perform the actual RIPAS
>>>      change on next entry rather than immediately on the exit. This allows
>>>      the VMM to 'reject' a RIPAS change by refusing to continue
>>>      scheduling.
>>> Changes since v4:
>>>    * Rename handle_rme_exit() to handle_rec_exit()
>>>    * Move the loop to copy registers into the REC enter structure from the
>>>      to rec_exit_handlers callbacks to kvm_rec_enter(). This fixes a bug
>>>      where the handler exits to user space and user space wants to modify
>>>      the GPRS.
>>>    * Some code rearrangement in rec_exit_ripas_change().
>>> Changes since v2:
>>>    * realm_set_ipa_state() now provides an output parameter for the
>>>      top_iap that was changed. Use this to signal the VMM with the correct
>>>      range that has been transitioned.
>>>    * Adapt to previous patch changes.
>>> ---
>>>    arch/arm64/include/asm/kvm_rme.h |   3 +
>>>    arch/arm64/kvm/Makefile          |   2 +-
>>>    arch/arm64/kvm/arm.c             |  19 +++-
>>>    arch/arm64/kvm/rme-exit.c        | 171 +++++++++++++++++++++++++++++++
>>>    arch/arm64/kvm/rme.c             |  19 ++++
>>>    5 files changed, 208 insertions(+), 6 deletions(-)
>>>    create mode 100644 arch/arm64/kvm/rme-exit.c
>>>
>>
>> With below nitpicks addressed:
>>
>> Reviewed-by: Gavin Shan <gshan@redhat.com>
>>
>> [...]
>>
>>> diff --git a/arch/arm64/kvm/rme-exit.c b/arch/arm64/kvm/rme-exit.c
>>> new file mode 100644
>>> index 000000000000..aae1adefe1a3
>>> --- /dev/null
>>> +++ b/arch/arm64/kvm/rme-exit.c
>>> @@ -0,0 +1,171 @@
>>> +// SPDX-License-Identifier: GPL-2.0-only
>>> +/*
>>> + * Copyright (C) 2023 ARM Ltd.
>>> + */
>>> +
>>> +#include <linux/kvm_host.h>
>>> +#include <kvm/arm_hypercalls.h>
>>> +#include <kvm/arm_psci.h>
>>> +
>>> +#include <asm/rmi_smc.h>
>>> +#include <asm/kvm_emulate.h>
>>> +#include <asm/kvm_rme.h>
>>> +#include <asm/kvm_mmu.h>
>>> +
>>> +typedef int (*exit_handler_fn)(struct kvm_vcpu *vcpu);
>>> +
>>
>> Duplicated to exit_handler_fn, defined in handle_exit.c, need move the
>> definition to header file.
> 
> While I get this is duplication, I'm a little reluctant to move it to a
> header file because this is completely internal to each C file (the
> xxx_exit_handler[] arrays are both static). If either side wants to e.g.
> add an extra argument there shouldn't be a requirement to reflect that
> change in the other.
> 
> Specifically I'm wondering if we're going to ever need to pass an RMI
> return status into the rme-exit callbacks at some point.
> 

Ok, thanks for explaining it in details. In that case, I think it's fine
to keep exit_handler_fn in rme-exit.c.

>>> +static int rec_exit_reason_notimpl(struct kvm_vcpu *vcpu)
>>> +{
>>> +    struct realm_rec *rec = &vcpu->arch.rec;
>>> +
>>> +    vcpu_err(vcpu, "Unhandled exit reason from realm (ESR: %#llx)\n",
>>> +         rec->run->exit.esr);
>>> +    return -ENXIO;
>>> +}
>>> +
>>> +static int rec_exit_sync_dabt(struct kvm_vcpu *vcpu)
>>> +{
>>> +    return kvm_handle_guest_abort(vcpu);
>>> +}
>>> +
>>> +static int rec_exit_sync_iabt(struct kvm_vcpu *vcpu)
>>> +{
>>> +    struct realm_rec *rec = &vcpu->arch.rec;
>>> +
>>> +    vcpu_err(vcpu, "Unhandled instruction abort (ESR: %#llx).\n",
>>> +         rec->run->exit.esr);
>>> +    return -ENXIO;
>>> +}
>>> +
>>> +static int rec_exit_sys_reg(struct kvm_vcpu *vcpu)
>>> +{
>>> +    struct realm_rec *rec = &vcpu->arch.rec;
>>> +    unsigned long esr = kvm_vcpu_get_esr(vcpu);
>>> +    int rt = kvm_vcpu_sys_get_rt(vcpu);
>>> +    bool is_write = !(esr & 1);
>>> +    int ret;
>>> +
>>> +    if (is_write)
>>> +        vcpu_set_reg(vcpu, rt, rec->run->exit.gprs[0]);
>>> +
>>> +    ret = kvm_handle_sys_reg(vcpu);
>>> +
>>> +    if (ret >= 0 && !is_write)
>>> +        rec->run->enter.gprs[0] = vcpu_get_reg(vcpu, rt);
>>> +
>>
>> Unncessary blank line and the conditon isn't completely correct:
>> kvm_handle_sys_reg()
>> should return 0 if the requested emulation fails, even it always returns
>> 1 for now.
> 
> It shouldn't matter, but like you say it's not technically the correct
> condition so I'll fix this up.
> 

Ok.

> Thanks,
> Steve
> 
>>      ret = kvm_handle_sys_reg(vcpu);
>>      if (ret > 0 && !is_write)
>>          rec->run->enter.gprs[0] = vcpu_get_reg(vcpu, rt);
>>
>>> +    return ret;
>>> +}
>>> +
>>

Thanks,
Gavin


