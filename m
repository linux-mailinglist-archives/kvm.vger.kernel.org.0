Return-Path: <kvm+bounces-35025-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A3F85A08DDA
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 11:25:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9F759168302
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 10:25:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A54920B1EC;
	Fri, 10 Jan 2025 10:25:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="rPx28O8B"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F4B220ADD9
	for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 10:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736504738; cv=none; b=SWpT/R9xhJDJuD5pG3CBAVQQXRb/PqQy6CTMz6KNElsppAXbZhV6NDF9sX537aAwO5G11mLjFt1mWgKKOPGjduxipzGcVVJEj+GFlbqEDvy7fx+H1PeIPHIMCAKZTazzAXbgaHajhLyW4GgoRkDMAMabIlePlbNC6a1v/n5rC8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736504738; c=relaxed/simple;
	bh=8au50NRA9MKnrMJHspaeqOs6+2vtRBg/UI1G2kjsrFM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LOgBDfNiQyQWWHKSDVVBfAkBoGSrY0D7WfN+cK7ayU+puizv6VmxrAmML1U63qbxTeCkyXHaZ5XCNylE4OUcpQQBp+FeWnfIEq5QiwQflsDLKIUHw9VtiZPyxIrfCjzBfg5a27+d1a39gKWMwMYHLt+sG1P9IjnRT6dQpcxLqNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=pass smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=rPx28O8B; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=daynix.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-21654fdd5daso30056455ad.1
        for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 02:25:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1736504736; x=1737109536; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TpdUX+5YwuD+zGTb80IjIfkrR9ePLf07c4eG06u5O1I=;
        b=rPx28O8BA99xifr668QAkwYFvFv2g5E6Tr/OumlUk3zI3csntVeILrEf5vVW+5NSXW
         i0GT3ghmCMbbnW5MEGixVZSGoyyrmESIuRfxSrOhB1KKGApE0vO/PpOpEOnH31caLkzy
         10XNoQfuGpQA0au1ycNjqv6mAjuRS5ApFx9JaRH1nu9nPNEd0W/S4YhVTJueJpvwhTIX
         1H8zilqJh8n21AasvRHMn3mV/3xlj7M9gWaXyR5R1uF1Ir0ptadG9lvRusH5OakIz88u
         esiHsbODEFTWSNffxHCj9pZlPfHgWuW3MDKHbtmCQyp/Gr+XHHaHoFxeP+jtITiIt6UY
         rvSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736504736; x=1737109536;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TpdUX+5YwuD+zGTb80IjIfkrR9ePLf07c4eG06u5O1I=;
        b=OLBWzeuRpE0vTBxMSsI7mIELmxzZuz+Fo6DHGzAyI5ivUPL90Sy3oXoJ63z71Wffwj
         wPTupIF9N2GhM3Ao07prRKpFbLWNHt4tjtl+4kYjA7TRYld2KDuu5Zo0ALLp8Pj3pOU4
         zcq7GXQE3S7MbyGRLy3Ym6120Jo61DiikEH6++6+YvlGYa5x/jdD1ngMIdYUM/xJqMRF
         Wz0LIlm+jxMkK+F4zxPFhbFOkHJlAqsxuD/dKU/yBXW7t3GEfudrI9gi0bBVjaE53vxe
         ozj7yc50gMh3ZYKUXdM4FbPkvvqq//hEf4iQGAABIfJJpLcCer9LzrjUSYY6FDcw4LZD
         o6rw==
X-Forwarded-Encrypted: i=1; AJvYcCVzng+n1XgxPI9RcAo/cgT8dzCRGSgpp4WIXdBCQawGYJPOdrW2BVlNztwQNsq21XBqppU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzZPTL4aO0G5cWk4PWtpw80QwpAX1vkXfsNR8HWLVy7PbzWRQ8S
	/DA41Y+bTh5zqv3kZzWtK0RU3Er7mWiyT9br2WoQyd3vbWWh0m523e53RC6R0Ng=
X-Gm-Gg: ASbGncvJhpnnARltunkoQusoD3y/3bYV++NQkMA6G/1w6mR2A9gn6RlSUqT7KbEiRRj
	Q3HNu1pwux7xcnQ8CNT5ctViZCh4uT/WnIo5PzpBm3isCfVP2RPVchEudT6m8uayUMvurUMbyaq
	zJAf+TWhH4uFvtISTqEsKA3RCTyoZf7M2553Trr2eW6/os0qI5yQ2lQEes0Xdc2UQE2m0O6wNu3
	I8As0SAYq3xBXUv8ntA6DrAVW79jGsp/eJWFrZ7QzfkEXSN6N07GWA8WWBVpW8zbSs=
X-Google-Smtp-Source: AGHT+IEPk96o1z16upoqDF0UlLrtkOdu9nG1oSobpYhznvCU7YqxeKG3oXL/nadW69o0yG72TxPalw==
X-Received: by 2002:a17:902:dacf:b0:215:b5c6:9ed3 with SMTP id d9443c01a7336-21a83f43b28mr154387855ad.12.1736504735978;
        Fri, 10 Jan 2025 02:25:35 -0800 (PST)
Received: from [157.82.203.37] ([157.82.203.37])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21a9f253b6csm11183165ad.220.2025.01.10.02.25.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Jan 2025 02:25:35 -0800 (PST)
Message-ID: <4843eb55-eff2-4bc8-bed2-ba12dd46b573@daynix.com>
Date: Fri, 10 Jan 2025 19:25:29 +0900
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] tun: Pad virtio header with zero
To: Jason Wang <jasowang@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>,
 Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Xuan Zhuo
 <xuanzhuo@linux.alibaba.com>, Shuah Khan <shuah@kernel.org>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 netdev@vger.kernel.org, kvm@vger.kernel.org,
 virtualization@lists.linux-foundation.org, linux-kselftest@vger.kernel.org,
 Yuri Benditovich <yuri.benditovich@daynix.com>,
 Andrew Melnychenko <andrew@daynix.com>,
 Stephen Hemminger <stephen@networkplumber.org>, gur.stavi@huawei.com,
 devel@daynix.com
References: <20250109-tun-v2-0-388d7d5a287a@daynix.com>
 <20250109-tun-v2-2-388d7d5a287a@daynix.com>
 <CACGkMEs73Pms5FB3ouzrLsDjAsQ4OhMMDVD2LnO6kVHCsN0A0w@mail.gmail.com>
Content-Language: en-US
From: Akihiko Odaki <akihiko.odaki@daynix.com>
In-Reply-To: <CACGkMEs73Pms5FB3ouzrLsDjAsQ4OhMMDVD2LnO6kVHCsN0A0w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2025/01/10 12:27, Jason Wang wrote:
> On Thu, Jan 9, 2025 at 2:59 PM Akihiko Odaki <akihiko.odaki@daynix.com> wrote:
>>
>> tun used to simply advance iov_iter when it needs to pad virtio header,
>> which leaves the garbage in the buffer as is. This is especially
>> problematic when tun starts to allow enabling the hash reporting
>> feature; even if the feature is enabled, the packet may lack a hash
>> value and may contain a hole in the virtio header because the packet
>> arrived before the feature gets enabled or does not contain the
>> header fields to be hashed. If the hole is not filled with zero, it is
>> impossible to tell if the packet lacks a hash value.
> 
> I'm not sure I will get here, could we do this in the series of hash reporting?

I'll create another series dedicated for this and num_buffers change as 
suggested by Willem.

> 
>>
>> In theory, a user of tun can fill the buffer with zero before calling
>> read() to avoid such a problem, but leaving the garbage in the buffer is
>> awkward anyway so fill the buffer in tun.
>>
>> Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
>> ---
>>   drivers/net/tun_vnet.c | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/tun_vnet.c b/drivers/net/tun_vnet.c
>> index fe842df9e9ef..ffb2186facd3 100644
>> --- a/drivers/net/tun_vnet.c
>> +++ b/drivers/net/tun_vnet.c
>> @@ -138,7 +138,8 @@ int tun_vnet_hdr_put(int sz, struct iov_iter *iter,
>>          if (copy_to_iter(hdr, sizeof(*hdr), iter) != sizeof(*hdr))
>>                  return -EFAULT;
>>
>> -       iov_iter_advance(iter, sz - sizeof(*hdr));
>> +       if (iov_iter_zero(sz - sizeof(*hdr), iter) != sz - sizeof(*hdr))
>> +               return -EFAULT;
>>
>>          return 0;
> 
> There're various callers of iov_iter_advance(), do we need to fix them all?

No. For example, there are iov_iter_advance() calls for SOCK_ZEROCOPY in 
tun_get_user() and tap_get_user(). They are fine as they are not writing 
buffers after skipping.

The problem is that read_iter() and recvmsg() says it wrote N bytes but 
it leaves some of this N bytes uninialized. Such an implementation may 
be created even without iov_iter_advance() (for example just returning a 
too big number), and it is equally problematic with the current 
tun_get_user()/tap_get_user().

Regards,
Akihiko Odaki

> 
> Thanks
> 
>>   }
> 
>>
>> --
>> 2.47.1
>>
> 


