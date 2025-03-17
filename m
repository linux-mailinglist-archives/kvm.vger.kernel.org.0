Return-Path: <kvm+bounces-41176-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CDF95A64559
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 09:27:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9AED13A9EC1
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 08:27:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E397821D3F1;
	Mon, 17 Mar 2025 08:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Bp7X/Jfw"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62BCD21ABD7
	for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 08:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742200062; cv=none; b=oudGOQPzxswPVnPkE8xL0Z/1ubKwTSsqIJX7iORNpPo1AfDa/Hw5ZQYJge8T8Uw5zxM/FwzHwfDOEktgN+TXnOQEiformCgxRh6vPtesmrzHYujNDvfPv70XKFiqZ3J022RD9P4sXIdg2byZccRts6VX2WqrCyMBs5oA7N/QKx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742200062; c=relaxed/simple;
	bh=tqNy6BKpM2xDaY4FPSYJUXOIvAfzzDMUG7OXLcVzG0c=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=jVLbzqIEvr/MxUEWJxGDa661J29B9jOq6Vm96y4OGBCmOdCiWg8Gj0A7LVnznqnFcr7B3tO4nDgY1iFqNffBsa1HUUDPC3GQ7ntxb96LOPBqDzwxS2qI4OK9Qu9lyvT27+wF291wJShFcv6dax3NP8AQtTyIHyPxyxk1Dx1QmRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Bp7X/Jfw; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742200059;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qaEC6lM4c8aLRLEjNI+sQ2in0w+9/2SdD4KxuUiKf1U=;
	b=Bp7X/JfwrxuuUadJyyL25Ks4s0/vGzdQUM/x2EWx+KIHWXMfGbLEj5JV1Qj32dk5fkrw6d
	phI1lUZRrRkrL64R7q8GUWVDHo51KaFhhlvWTRWFn2LaP2Y3gXuq7M/trJg+YktQutEHBP
	j5vr3ksP098iNnvtxEorgu34lN1QuMI=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-632-eO5lLlHsMAykU62DEZjQwg-1; Mon, 17 Mar 2025 04:27:37 -0400
X-MC-Unique: eO5lLlHsMAykU62DEZjQwg-1
X-Mimecast-MFC-AGG-ID: eO5lLlHsMAykU62DEZjQwg_1742200056
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3cf64584097so48345635ab.2
        for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 01:27:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742200056; x=1742804856;
        h=content-transfer-encoding:in-reply-to:references:reply-to:cc:to
         :from:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qaEC6lM4c8aLRLEjNI+sQ2in0w+9/2SdD4KxuUiKf1U=;
        b=RiZkPtrPr/9YuhR0U8EQz3eoN1xS8PXF4L8cDErLASwsDr+dnzQYACbgqHf7wwc1eN
         K+GMPdc0YvZreRxGtOlFgj9cdIDRyO1uH0FUlPVAk0Fmc/8FYptR8gKxDMZeivP1JHTE
         WiquY4ewyCXOdyVwFRL7FMPDMi0CNjiWllV2TryPi41uHPE/3UmSmezNfYtynz10DrbD
         xqunFcksl1cjr4cjOvMjRkEb8aWiZmn/ts8uXpIpc0yq6J/FCH3Hyu+gUYn590VkUBX+
         6aLAG9V+cxFzdYmJ4XI+zlPULqx5k0kEyqMBRTa7EooPUAl1FPZ/DowQmraIQ53x+NbO
         BNTA==
X-Forwarded-Encrypted: i=1; AJvYcCWeXJEfvAjAum3udV18EpE8m7xuYP6zldqsQFfrmyni7jHpzdXfAapwkfrOS4/ThG+yX8Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YzrMIZV1s7MdrKJ+8MBbfWTbUubVG8CinGId8DHmsW5KsoKVq3b
	tEhHbH+uo9ghb5OQmuWgpsuOkOF9e/i6Rib8Rvp0D4tv7uvJONIsnubwXpP/3Hcs22IudcCU3PB
	URUu6znX16oVdiDEYA8unAiaDa/r4gEyiTUj2+ZvbnYbm4r9p2Q==
X-Gm-Gg: ASbGncsgg5GmgMZ+LPR+vRtsBXvO6O4/7alTDU4LR1x6KVg2J2+2Z/pvmCQ57E8+rZR
	j4hC7Zw/vsbhf4nazAQZJxoZcJ0zDDUBQC6aCbc2uTA9w2rLiiepedZ6FqJvoDCq0ABZOoDkCEV
	gZ7x8OKg/0RwURRx6jOP+1tkNe3guhl1RydQGcMPppmQa164SjHnbDx3de1sIyT/0DqCM9S4b2a
	WxY7xqAkXlBrWnjtYQFFer6btnQfPJLCun2IKRxVDY/VA84ogCZFWNIwiqkZBiE0lSaTKhAMNVz
	p1czryr0T4PxusbBiwCrhRP6U3C8T6wl0h3GlUkYgs1plHWlcw9blqynpQAfw+8=
X-Received: by 2002:a05:6e02:b46:b0:3d4:2a4e:1272 with SMTP id e9e14a558f8ab-3d483a7517fmr123863705ab.19.1742200056615;
        Mon, 17 Mar 2025 01:27:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGd41vdtyIf466bhMfI+neQE4uPHYcdKmdVV38Hf3JbIctOMMqGI2AFDJ73sUyG0hh2b4szAQ==
X-Received: by 2002:a05:6e02:b46:b0:3d4:2a4e:1272 with SMTP id e9e14a558f8ab-3d483a7517fmr123863585ab.19.1742200056319;
        Mon, 17 Mar 2025 01:27:36 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f2637031a4sm2196881173.11.2025.03.17.01.27.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Mar 2025 01:27:35 -0700 (PDT)
Message-ID: <fcb7894d-51e5-4376-b32f-4cb9eb94b573@redhat.com>
Date: Mon, 17 Mar 2025 09:27:32 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v2 1/5] configure: arm64: Don't display
 'aarch64' as the default architecture
Content-Language: en-US
From: Eric Auger <eric.auger@redhat.com>
To: Jean-Philippe Brucker <jean-philippe@linaro.org>, andrew.jones@linux.dev,
 alexandru.elisei@arm.com
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
 kvm-riscv@lists.infradead.org, vladimir.murzin@arm.com
Reply-To: eric.auger@redhat.com, eric.auger@redhat.com
References: <20250314154904.3946484-2-jean-philippe@linaro.org>
 <20250314154904.3946484-3-jean-philippe@linaro.org>
 <1b0233dc-b303-4317-a65d-572cc3582b8a@redhat.com>
In-Reply-To: <1b0233dc-b303-4317-a65d-572cc3582b8a@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 3/17/25 9:19 AM, Eric Auger wrote:
> Hi Jean-Philippe,
> 
> 
> On 3/14/25 4:49 PM, Jean-Philippe Brucker wrote:
>> From: Alexandru Elisei <alexandru.elisei@arm.com>
>>
>> --arch=aarch64, intentional or not, has been supported since the initial
>> arm64 support, commit 39ac3f8494be ("arm64: initial drop"). However,
>> "aarch64" does not show up in the list of supported architectures, but
>> it's displayed as the default architecture if doing ./configure --help
>> on an arm64 machine.
>>
>> Keep everything consistent and make sure that the default value for
>> $arch is "arm64", but still allow --arch=aarch64, in case they are users
> there
>> that use this configuration for kvm-unit-tests.
>>
>> The help text for --arch changes from:
>>
>>    --arch=ARCH            architecture to compile for (aarch64). ARCH can be one of:
>>                            arm, arm64, i386, ppc64, riscv32, riscv64, s390x, x86_64
>>
>> to:
>>
>>     --arch=ARCH            architecture to compile for (arm64). ARCH can be one of:
>>                            arm, arm64, i386, ppc64, riscv32, riscv64, s390x, x86_64
>>
>> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
>> ---
>>  configure | 5 +++--
>>  1 file changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/configure b/configure
>> index 06532a89..dc3413fc 100755
>> --- a/configure
>> +++ b/configure
>> @@ -15,8 +15,9 @@ objdump=objdump
>>  readelf=readelf
>>  ar=ar
>>  addr2line=addr2line
>> -arch=$(uname -m | sed -e 's/i.86/i386/;s/arm64/aarch64/;s/arm.*/arm/;s/ppc64.*/ppc64/')
>> -host=$arch
>> +host=$(uname -m | sed -e 's/i.86/i386/;s/arm64/aarch64/;s/arm.*/arm/;s/ppc64.*/ppc64/')
>> +arch=$host
>> +[ "$arch" = "aarch64" ] && arch="arm64"
> Looks the same it done again below

Ignore this. This is done again after explicit arch setting :-/ Need
another coffee

So looks good to me
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric

> 
> arch_name=$arch
> [ "$arch" = "aarch64" ] && arch="arm64"
> [ "$arch_name" = "arm64" ] && arch_name="aarch64" <---
> arch_libdir=$arch
> 
> maybe we could move all arch settings at the same location so that it
> becomes clearer?
> 
> Thanks
> 
> Eric
> 
>>  cross_prefix=
>>  endian=""
>>  pretty_print_stacks=yes
> 


