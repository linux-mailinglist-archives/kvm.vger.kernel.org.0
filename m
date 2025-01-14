Return-Path: <kvm+bounces-35384-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 667F9A1084C
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 15:01:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A23AE167F04
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 14:01:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8497374C08;
	Tue, 14 Jan 2025 14:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UKUb0g7w"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6855C25632
	for <kvm@vger.kernel.org>; Tue, 14 Jan 2025 14:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736863311; cv=none; b=SqE7tJssKjrbTJOEgOHvSjixDpw1muBPZsPhmwSWZC8hcDH70lsjEXHZOlKRoWmzcJ40jkIWiW86L4zsdYDdDH/RZdnjNhT5wrZdp5+IXzOMwJ9qgPtvSUS9Nn1BhUSUXkH33eP43hxknhTpafFj9nWJz1bVlwvLX/ALR3V43Yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736863311; c=relaxed/simple;
	bh=Xk3qWmPfZijoaXfRIpGNdYfV+q55Gb8GnpUndEq0uvM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JOqnPAHobZkPQlC2OcaD7c2aGEM7AzLqp7VZCMNl8UIC60ntdj+w1R9bFgnsn5lMWHH0KK/paB4QrjseXb+i8SL4WN42dbavzKSIiXIo+boCPnfdZd91yKLvXPt0Yu5VT4gkwvBY2URlNmfJzQhGdcCWT9L5LxeCVTxmcxq5Apk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UKUb0g7w; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736863308;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=5LiaySr94zDavTpMpv+RjEQ4WEDWDc58/LIfFci8ZtY=;
	b=UKUb0g7wYICr807f7pREaRKKfXDp9fgC1k4emaBhmLFDDj1S/rWouWMxfLQhB9q2RmP61L
	niNgVNaZaadZ3cWNXZH2ImDUykZsjU61HvrPoOQPFoj5mQ7nHvPMC7SX8t4tF7OCI7Iw8Y
	PAUY5RgFLEnRnVg5l/1emY+P4WkCfYs=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-167-RHtOR2U5Nl-OpPitcj5gpg-1; Tue, 14 Jan 2025 09:01:45 -0500
X-MC-Unique: RHtOR2U5Nl-OpPitcj5gpg-1
X-Mimecast-MFC-AGG-ID: RHtOR2U5Nl-OpPitcj5gpg
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-38a873178f2so2756873f8f.1
        for <kvm@vger.kernel.org>; Tue, 14 Jan 2025 06:01:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736863305; x=1737468105;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=5LiaySr94zDavTpMpv+RjEQ4WEDWDc58/LIfFci8ZtY=;
        b=YGxPdfp1O75LbPFq0eeKCGbwM6Wmfo5D6BMJ8P0nqSH2UlQ7KEYrvgKSfXReZvHxFD
         2KVzlj+GKyH27TqbCd+bTzPn75dzmN9VxbFnmzKyoQMinjwUBLG/KcRDdE/Zl+dj0sI7
         n3ujsjXwyFzuFeuj4O8vTyykwb0GcnUCMzD1Q2DBUSePuvEROejsqWsc7B+xK5jCMDFa
         grkOW0xnlj9wZ9XJ45Jda51WIiku7cu6xauCakVN9SqBRZJl6fxPlGLtzQR+MDGZzleO
         4DGUEALOtbQMf004FSPQbrW4ud+ZLSDA55WuyAIyQIWaojiu7ZG3FlFemTJiIiewQ+ay
         V+RA==
X-Forwarded-Encrypted: i=1; AJvYcCXe3ZgzJ6BkBXZwEo8dO3QibjLwDNZQVCN0A8bW3y8MuEpgGelFGpHD7Bcggx4xdrBPPus=@vger.kernel.org
X-Gm-Message-State: AOJu0YwSPwi0bANoHOKBHNfYligj7K+R4p3IutPtLqbSn2AOITamFHsM
	IoGBzaDUA3GYeA7XQ2NXM9fvWUOVS6k5OXzJgJeLJKCcNt5Hd/bCGt1YcLzVcUzM7oqC/tCaFFY
	4tGE++oi2C4vri2ULquX3nBl7xbJPB1+RGkud+tTMlrIrlG1g0Q==
X-Gm-Gg: ASbGncslCiZaWQeUYQr1+jvCfWPHpoO0q/h/UiFA7vFcaa44Axbi1oVMY2ur8Mlle26
	6PgqTvQ/mQSlPNcSDV7yj+bqQ/2hWFv8Onva7RnD4vegIN/rWHZXT2XK4s8+d5sAuC8tkY5Bxje
	gGWmCt8iLu0Pbpt2d3uNj6oxmRHlHvnk/Mu8RULt8QPnGdmiLBf9BA4vdRKbqkgPeMEw5m4CZ02
	r721rstJ4TkI18goUAIjco7WEIpZeb5sOxG9o6h9KEMiGtB6oQNr52s9zaQykLWwdkxbxzs0gfH
	nVomc5V1oRPpW3jZSY5fj20scQJdLvgWMEP6u70dXxIpKYM/m+3I4SB7QRzAJOZu46LBdhE7DqZ
	VXhvt5eGU
X-Received: by 2002:a5d:64e2:0:b0:38b:e32a:10ab with SMTP id ffacd0b85a97d-38be32a13a4mr1543611f8f.9.1736863304445;
        Tue, 14 Jan 2025 06:01:44 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF1IQu7Zm9/XDgYD1XGvNzRJ4NlPuB0JZEzpzJrrtSb6wLsy+lwUAThfh1kfVWfyLnsa4VAFQ==
X-Received: by 2002:a5d:64e2:0:b0:38b:e32a:10ab with SMTP id ffacd0b85a97d-38be32a13a4mr1543559f8f.9.1736863303910;
        Tue, 14 Jan 2025 06:01:43 -0800 (PST)
Received: from ?IPV6:2003:cb:c738:3100:8133:26cf:7877:94aa? (p200300cbc7383100813326cf787794aa.dip0.t-ipconnect.de. [2003:cb:c738:3100:8133:26cf:7877:94aa])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38a8e38332asm14738420f8f.23.2025.01.14.06.01.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jan 2025 06:01:43 -0800 (PST)
Message-ID: <120b94cd-e0c8-41a6-9afb-2e3fad477454@redhat.com>
Date: Tue, 14 Jan 2025 15:01:41 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 7/7] system/physmem: Memory settings applied on remap
 notification
To: William Roche <william.roche@oracle.com>, kvm@vger.kernel.org,
 qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc: peterx@redhat.com, pbonzini@redhat.com, richard.henderson@linaro.org,
 philmd@linaro.org, peter.maydell@linaro.org, mtosatti@redhat.com,
 imammedo@redhat.com, eduardo@habkost.net, marcel.apfelbaum@gmail.com,
 wangyanan55@huawei.com, zhao1.liu@intel.com, joao.m.martins@oracle.com
References: <cf587c8b-3894-4589-bfea-be5db70e81f3@redhat.com>
 <20241214134555.440097-1-william.roche@oracle.com>
 <20241214134555.440097-8-william.roche@oracle.com>
 <e13ddad7-77cf-489b-9e32-d336edb01c85@redhat.com>
 <fe018270-5c2f-4b13-9254-aa047fc48ccd@oracle.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <fe018270-5c2f-4b13-9254-aa047fc48ccd@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 10.01.25 21:57, William Roche wrote:
> On 1/8/25 22:53, David Hildenbrand wrote:
>> On 14.12.24 14:45, “William Roche wrote:
>>> From: William Roche <william.roche@oracle.com>
>>>
>>> Merging and dump settings are handled by the remap notification
>>> in addition to memory policy and preallocation.
>>>
>>> Signed-off-by: William Roche <william.roche@oracle.com>
>>> ---
>>>    system/physmem.c | 2 --
>>>    1 file changed, 2 deletions(-)
>>>
>>> diff --git a/system/physmem.c b/system/physmem.c
>>> index 9fc74a5699..c0bfa20efc 100644
>>> --- a/system/physmem.c
>>> +++ b/system/physmem.c
>>> @@ -2242,8 +2242,6 @@ void qemu_ram_remap(ram_addr_t addr)
>>>                        }
>>>                        qemu_ram_remap_mmap(block, vaddr, page_size,
>>> offset);
>>>                    }
>>> -                memory_try_enable_merging(vaddr, page_size);
>>> -                qemu_ram_setup_dump(vaddr, page_size);
>>>                    ram_block_notify_remap(block->host, offset, page_size);
>>>                }
>>
>> Ah yes, indeed.
> 
> I also merged this patch 7/7 [system/physmem: Memory settings applied on
> remap notification] into your patch 6/7 [hostmem: Handle remapping of
> RAM], removing also the unneeded vaddr.
> 
> So now we are down to 6 patches  (unless you want me to integrate the
> fix for ram_block_discard_range() I talked about for patch 2/7)
> 
> I'm sending my version v5 now.

Sorry for the delayed reply to v4.

-- 
Cheers,

David / dhildenb


