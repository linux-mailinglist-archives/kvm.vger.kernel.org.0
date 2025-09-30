Return-Path: <kvm+bounces-59092-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7176BBABCD5
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 09:23:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1D11D7A1846
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 07:22:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B7C6242D8B;
	Tue, 30 Sep 2025 07:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="vTs8gwfv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69A5723182D
	for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 07:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759217025; cv=none; b=gXt0m+EVBP6EmyEtqTDBXpYsidJ8PZtun/epgsrPRnEHD+T0Mb212hGDzb+H7C2gwE9VXse/oeGnj1ePU7jTNPbSgrFzl+nMWeEGmk1ABVOL0d1O3QolQyDEWSHsJXxl4P+j5cR8412DzpupRqPuqK0rAViPLfklgu+puNRzT7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759217025; c=relaxed/simple;
	bh=WfocPMJ6djbM57riOWqw2dhHOkBuexya4hwwR7Zxq9w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BhjgRG5f6YCrCZALJqNz69eytM9lVRJaLgcX+8X+vrdGvKnWnqd5VAvuSWExjgKr/bZETJuJkokrLxTRkYPIS9TvOi4/gzn/q7SxKuRUO4ONwc8uDRmcqTMynxbsx5TRN5Gbwd0RBY7lQyhkz98HvpJ9ThxSpvEhMek+4siSgk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=vTs8gwfv; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-46e414f90ceso6518845e9.0
        for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 00:23:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759217022; x=1759821822; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=itVX7tgCqZhn3DDR7jTxWGvfg+OOdlBPano0M6bAsBg=;
        b=vTs8gwfvoTl77R8QAVW6E9pSCyEKb/XgXSaW5FYbCErjTiDLQgd3vUCsfZ4vD3HSPu
         EFHZA95ij6IuOTzCvMNVP6ZBbzX0BtKrj4qtmHz7xnR/4mK/cFodKrOYhNembg2UGjMS
         ViHOMxzK/Q5dC9sq/akRUM+1k5z35UIpdIpke2gn+syE8KtCaMrfjfIweI7YwzWCX1ot
         +jjE98pF6C7Ly3w6RJJdYdYqLU2/XB7vgc7R12pbJo/TgRQ12SH0GsM4jxV7gdwhK1ln
         APcyENzb7lCrcDke315PNlAdI61tEdL2XSw2JW0WcxN2bh9FYozCBEncrQ0rY2lzBdf3
         QCsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759217022; x=1759821822;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=itVX7tgCqZhn3DDR7jTxWGvfg+OOdlBPano0M6bAsBg=;
        b=LVhMn9MlrS9MhyoQW/vmX2lB63kAkKQgAg/8H0UBC1CppAywtdPQIbhR9hkRpbV4X9
         BJ4JHsEHB/2aIdFR5PkOwMN+IP9NW8YnEttJy7y8VhYV6CdaJ3aQxh4TGW30FcUQOAH/
         RDcRRHk+5GcHUpfE+/WgzN19qEyfmpDwJ57Q68LNe3sAwEaYOnCcTbKZTiShQMV6bFPn
         SKsVH0uLDyzc5aEQcYUDoo5R3sA5KeAxbD94P1L0P1mL18Btk5CszqyL6Azr1eUAtW5L
         4JHc7A6Kkr0vJo/h3U5BnU24xeDC2WX8mbIJYnemZNTcTkTddVbk0P3vmKe36jDCSxg8
         uwmA==
X-Forwarded-Encrypted: i=1; AJvYcCWhoaIIQue0v8+b1j9nq20/lVzcBoQ4i+BaNaukWeYcm1rjAnBRJKbh3FiI6M7EFC7RLMs=@vger.kernel.org
X-Gm-Message-State: AOJu0YwSV1H+IMOjzrDN7YhNx7cZXDvxHbjjhR4CnalrNy5fqnQ0XWK1
	rayUJP+tkVii8lDPCu3ejTkrFPMgH1Xf0oNPY91OaWwvJInNbSIouXjKtSrKmnYSHYzTUVD+V4y
	YncJJ7LrEAg==
X-Gm-Gg: ASbGncuYSfzkp2qVwQglx5PmFqzajTeDU8NMB1OTlRHV1kixkgKp9J/qNwLiG81dDON
	mecOKX69BYU3TpsDwoBC3IdcxVU3cea770GsfDaI+hHRNKCXE0svUtpwVhacTyKww8QxtwSTXep
	SxAQf3oydL4nXzYGNTeXuCvsXnJ/xnVSRueaDpkID8132A4kyNbsQNvaXx8Y3xTqiblQ4G6rnRU
	qnqEoJjZ2PSthsJr7uEQEg2qhXabbOqwjFxDBe+W3rKyfcI5fvFHQqrHqFYPUj1ujKjiAlWYvmi
	iaHMDo4DOIEKFHJYjQGkA1tpv9uiYEKRt8iIw6XS40hQNPOL9Sf2IKgWPfadCo2dPbVUpeUQQbl
	+fzFQqZ0nEVinj1jmBju7yBH72B+TlW4tb360isPYoA/pa7QCdHbcDy2HxZZC11CMaLYyHvFT9x
	CCi+xIg6Dljjfmiw==
X-Google-Smtp-Source: AGHT+IHvY4Ey9R8Ex4kFK/h9CrX/gZMo0TkG92UrmsqICbzAXLN4hHP/QkaUH3LOu+37Fvfb480y1w==
X-Received: by 2002:a05:600c:4e4a:b0:46e:4b79:551 with SMTP id 5b1f17b1804b1-46e4b7906ecmr109670425e9.31.1759217021708;
        Tue, 30 Sep 2025 00:23:41 -0700 (PDT)
Received: from [192.168.69.221] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e56f3dbcfsm44146575e9.3.2025.09.30.00.23.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Sep 2025 00:23:41 -0700 (PDT)
Message-ID: <61c31076-5330-426a-9c28-b2400bec44f6@linaro.org>
Date: Tue, 30 Sep 2025 09:23:39 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 14/17] system/physmem: Un-inline
 cpu_physical_memory_read/write()
To: Thomas Huth <thuth@redhat.com>, qemu-devel@nongnu.org,
 Peter Maydell <peter.maydell@linaro.org>
Cc: Jason Herne <jjherne@linux.ibm.com>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Stefano Garzarella <sgarzare@redhat.com>, xen-devel@lists.xenproject.org,
 Paolo Bonzini <pbonzini@redhat.com>, Ilya Leoshkevich <iii@linux.ibm.com>,
 Anthony PERARD <anthony@xenproject.org>, Paul Durrant <paul@xen.org>,
 Eric Farman <farman@linux.ibm.com>, Marcelo Tosatti <mtosatti@redhat.com>,
 Halil Pasic <pasic@linux.ibm.com>, Matthew Rosato <mjrosato@linux.ibm.com>,
 Reinoud Zandijk <reinoud@netbsd.org>, Zhao Liu <zhao1.liu@intel.com>,
 David Woodhouse <dwmw2@infradead.org>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sunil Muthuswamy <sunilmut@microsoft.com>, kvm@vger.kernel.org,
 "Michael S. Tsirkin" <mst@redhat.com>, Peter Xu <peterx@redhat.com>,
 qemu-s390x@nongnu.org, "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 David Hildenbrand <david@redhat.com>
References: <20250930041326.6448-1-philmd@linaro.org>
 <20250930041326.6448-15-philmd@linaro.org>
 <193cd8a8-2c4c-4c2c-af22-622b74c332ee@redhat.com>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <193cd8a8-2c4c-4c2c-af22-622b74c332ee@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 30/9/25 07:02, Thomas Huth wrote:
> On 30/09/2025 06.13, Philippe Mathieu-Daudé wrote:
>> Un-inline cpu_physical_memory_read() and cpu_physical_memory_write().
> 
> What's the reasoning for this patch?

Remove cpu_physical_memory_rw() in the next patch without having
to inline the address_space_read/address_space_write() calls in
"exec/cpu-common.h".

Maybe better squashing both together?

> 
>   Thomas
> 
>> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
>> ---
>>   include/exec/cpu-common.h | 12 ++----------
>>   system/physmem.c          | 10 ++++++++++
>>   2 files changed, 12 insertions(+), 10 deletions(-)
>>
>> diff --git a/include/exec/cpu-common.h b/include/exec/cpu-common.h
>> index 6c7d84aacb4..6e8cb530f6e 100644
>> --- a/include/exec/cpu-common.h
>> +++ b/include/exec/cpu-common.h
>> @@ -133,16 +133,8 @@ void cpu_address_space_destroy(CPUState *cpu, int 
>> asidx);
>>   void cpu_physical_memory_rw(hwaddr addr, void *buf,
>>                               hwaddr len, bool is_write);
>> -static inline void cpu_physical_memory_read(hwaddr addr,
>> -                                            void *buf, hwaddr len)
>> -{
>> -    cpu_physical_memory_rw(addr, buf, len, false);
>> -}
>> -static inline void cpu_physical_memory_write(hwaddr addr,
>> -                                             const void *buf, hwaddr 
>> len)
>> -{
>> -    cpu_physical_memory_rw(addr, (void *)buf, len, true);
>> -}
>> +void cpu_physical_memory_read(hwaddr addr, void *buf, hwaddr len);
>> +void cpu_physical_memory_write(hwaddr addr, const void *buf, hwaddr 
>> len);
>>   void *cpu_physical_memory_map(hwaddr addr,
>>                                 hwaddr *plen,
>>                                 bool is_write);
>> diff --git a/system/physmem.c b/system/physmem.c
>> index 70b02675b93..6d6bc449376 100644
>> --- a/system/physmem.c
>> +++ b/system/physmem.c
>> @@ -3188,6 +3188,16 @@ void cpu_physical_memory_rw(hwaddr addr, void 
>> *buf,
>>                        buf, len, is_write);
>>   }
>> +void cpu_physical_memory_read(hwaddr addr, void *buf, hwaddr len)
>> +{
>> +    cpu_physical_memory_rw(addr, buf, len, false);
>> +}
>> +
>> +void cpu_physical_memory_write(hwaddr addr, const void *buf, hwaddr len)
>> +{
>> +    cpu_physical_memory_rw(addr, (void *)buf, len, true);
>> +}
>> +
>>   /* used for ROM loading : can write in RAM and ROM */
>>   MemTxResult address_space_write_rom(AddressSpace *as, hwaddr addr,
>>                                       MemTxAttrs attrs,
> 


