Return-Path: <kvm+bounces-28667-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 198F499B110
	for <lists+kvm@lfdr.de>; Sat, 12 Oct 2024 07:22:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3D0B81C2176F
	for <lists+kvm@lfdr.de>; Sat, 12 Oct 2024 05:22:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56FED13213A;
	Sat, 12 Oct 2024 05:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CtTZ2jmT"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD529B67A
	for <kvm@vger.kernel.org>; Sat, 12 Oct 2024 05:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728710541; cv=none; b=bOYZ0GxoHqGRYeJzP7YwGJS5lgbrlaPsnOEzr+N3IReghF8c5+sasnFEcn4KcK22Pr+Y1FUeYcvbIdjMUptWb/S2mVvi/n+ux/DpeTeHEqCWw7vyOSx3pQvhljdEwne/wjCK2XgZE7TBYQ38Lf5d4LE2QqxXXrtpKB0+hHxicp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728710541; c=relaxed/simple;
	bh=KP48yn2zu/bvXJGE9dWPkWLMt3oDQ+5HzzzKc0IzQwg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PD1eVMrRd35HDil7jcqirZicZAFpHFfXks78RjWFKXPitwEapsGhijcUtU6foTa7XdPOR8YPLdOErSrRrM/+vAsZm1H+VCY7StJV+Yi7RiIJ+gVEIoOB+80taE2m2TJ27Hgp2vegmz93e0CcCGV18k9CwfcIAMZ5R73sdWI//8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CtTZ2jmT; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728710538;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hvDr0hBqceMPoqKr59VTJA2PMmkK0w6bfmvafMG1XxI=;
	b=CtTZ2jmT9bnRa+ffPANB0jpFn4JjDcpBQrXhDsWTYsCxqQr+pcfOgKNqjg6yKm7xYyPrhZ
	uBGZ+dfi35qby9FrLL8oh1KkAmQd4RrSX/B9OpsUbRJFst2Oa3jff9W0CyeqGIKoiBGprt
	JRgx24BKu7PSrMkcADPdUtFO1RXG+hU=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-28-Oomp0dPNPBGBNVFKneCPtg-1; Sat, 12 Oct 2024 01:22:17 -0400
X-MC-Unique: Oomp0dPNPBGBNVFKneCPtg-1
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-20b8bf5d09aso35422475ad.3
        for <kvm@vger.kernel.org>; Fri, 11 Oct 2024 22:22:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728710536; x=1729315336;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hvDr0hBqceMPoqKr59VTJA2PMmkK0w6bfmvafMG1XxI=;
        b=KUM0kUFzhly9qGejeVP9FOPvqofZr2JExRJOLMMwWPIwCj5Cy+FjBLBjdFHT4451I1
         AjWo/dwd9RrRPbljjQuSSrpkD1SeoWQV8Vx1NSbp8yTSOoGhAb1gp5UtxTE26K+ujn0c
         +5JF4yAMmDySCISeZy1m6vzVZuD/QjWhg+BS3UoOd6UvkOtbDh5LeL5dxA+hIexard4c
         96e1nGtXy/v4GD8coAsZBGtrrm4mgMM+X/zwjuJhPYw5kuj3yF8S3lOpj5/QNkLnufya
         d2ZPgBNpbOKJ2cSYy/Z5n1Q0qfUaFNNoaKhVHpTeQ6CgbFbLwo+a513PmOaGHJsQTl+V
         v6hA==
X-Forwarded-Encrypted: i=1; AJvYcCXwKWAwKQRe3lbYhxuZHOc+YYsS0KbuTgsoajqfUZIo2oVZ8Eaf26cDx4r1G0sgg7yowZY=@vger.kernel.org
X-Gm-Message-State: AOJu0YyIPvZDm/OkdWu6llOeNBp70JTX697P/egPkd97djKcpvMDYDgR
	FwsWWoZXY1OewduGh/7s5xPCMYsW7T8d4VkIBd1teY3TFwxS5EViKoIOUJZ6vTiO3ZAwTVTR/5M
	W86p8sPkrQ7YD6AyDCee8zrvmj7Cbfz+jJK1/7aDcJTNthBDh7w==
X-Received: by 2002:a17:903:2292:b0:20c:be0e:d47e with SMTP id d9443c01a7336-20cbe0ed77fmr27330095ad.56.1728710536129;
        Fri, 11 Oct 2024 22:22:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGPdfPL4sLDuZbuEZ8hOCaoZXNRre8SGr7tfbn9VtHIuESumtQnMGZco/QwYJ9wvIb8IjS+5g==
X-Received: by 2002:a17:903:2292:b0:20c:be0e:d47e with SMTP id d9443c01a7336-20cbe0ed77fmr27329915ad.56.1728710535801;
        Fri, 11 Oct 2024 22:22:15 -0700 (PDT)
Received: from [192.168.68.54] ([180.233.125.129])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20c8c33fdf9sm31443385ad.260.2024.10.11.22.22.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Oct 2024 22:22:15 -0700 (PDT)
Message-ID: <cfbd0cbb-bfff-41fc-b729-c8c49ce28215@redhat.com>
Date: Sat, 12 Oct 2024 15:22:06 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 05/11] arm64: rsi: Map unprotected MMIO as decrypted
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev, Suzuki K Poulose <suzuki.poulose@arm.com>,
 Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
 James Morse <james.morse@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
 Zenghui Yu <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
References: <20241004144307.66199-1-steven.price@arm.com>
 <20241004144307.66199-6-steven.price@arm.com>
 <e21481a9-3e36-4a5d-9428-0f5ef8083676@redhat.com> <Zwkl51C3DFEQQ0Jb@arm.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <Zwkl51C3DFEQQ0Jb@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/11/24 11:19 PM, Catalin Marinas wrote:
> On Tue, Oct 08, 2024 at 10:31:06AM +1000, Gavin Shan wrote:
>> On 10/5/24 12:43 AM, Steven Price wrote:
>>> diff --git a/arch/arm64/kernel/rsi.c b/arch/arm64/kernel/rsi.c
>>> index d7bba4cee627..f1add76f89ce 100644
>>> --- a/arch/arm64/kernel/rsi.c
>>> +++ b/arch/arm64/kernel/rsi.c
>>> @@ -6,6 +6,8 @@
>>>    #include <linux/jump_label.h>
>>>    #include <linux/memblock.h>
>>>    #include <linux/psci.h>
>>> +
>>> +#include <asm/io.h>
>>>    #include <asm/rsi.h>
>>>    struct realm_config config;
>>> @@ -92,6 +94,16 @@ bool arm64_is_protected_mmio(phys_addr_t base, size_t size)
>>>    }
>>>    EXPORT_SYMBOL(arm64_is_protected_mmio);
>>> +static int realm_ioremap_hook(phys_addr_t phys, size_t size, pgprot_t *prot)
>>> +{
>>> +	if (arm64_is_protected_mmio(phys, size))
>>> +		*prot = pgprot_encrypted(*prot);
>>> +	else
>>> +		*prot = pgprot_decrypted(*prot);
>>> +
>>> +	return 0;
>>> +}
>>> +
>>
>> We probably need arm64_is_mmio_private() here, meaning arm64_is_protected_mmio() isn't
>> sufficient to avoid invoking SMCCC call SMC_RSI_IPA_STATE_GET in a regular guest where
>> realm capability isn't present.
> 
> I think we get away with this since the hook won't be registered in a
> normal guest (done from arm64_rsi_init()). So the additional check in
> arm64_is_mmio_private() is unnecessary.
> 

Indeed. I missed the point that the hook won't be registered for a normal
guest. So we're good and safe.

Thanks,
Gavin


