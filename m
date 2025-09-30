Return-Path: <kvm+bounces-59126-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F239EBAC0EE
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 10:31:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 86EEE3C30B1
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 08:31:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9F0B1A5B92;
	Tue, 30 Sep 2025 08:31:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="dToV/JMA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f65.google.com (mail-wr1-f65.google.com [209.85.221.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E4A22BB17
	for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 08:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759221100; cv=none; b=a5ia3r+18KCA+zucdqQlcEilPUsy6h7OXtKl4LVSB6AP7GDF/ZACWGUAMFKDxezomKVv+YQqL1eOlQ6vfFr2Nl6260EQjOzQ4eeH3sFGhQEEX5AehCreR0+5He1YlJpc+PxJdAds3k+JGskG0LugkoqlQ5uQASa/SihSQXLIgBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759221100; c=relaxed/simple;
	bh=hJwQ+1TnEjSuEyAWDWMOoEqLfa9xehXf84yRakrXUZ0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Nom+3wO3//+a8q/Rpo57rMNM1ay693SHIu341160D+izYAdtJKfQ2i6NWVLwixOaWvtjGrAwh12uiPkvhHzvTnKa/t12MGmOWsENRVmb1dG0hMAYH/V+y8RyaKpRINWCKRb3NwJDT5kr2ILymkwyDrTEsLdVGb7KgjAoGzJSVWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=dToV/JMA; arc=none smtp.client-ip=209.85.221.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f65.google.com with SMTP id ffacd0b85a97d-3f2cf786abeso4049809f8f.3
        for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 01:31:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759221096; x=1759825896; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EPblYzRdSvAbjbwbh03+CbSDEcFIuNHCFm6Gcm76lBw=;
        b=dToV/JMApIA46Drx6jEBfNA5UZOvQ/bpPOoBnBRLS25Zako/utco5aioICKiRoqFz5
         XRdXGnmSRTlLqy3OK8qm65pDxFZG4WUb0cQXrcXPEZnkMpW2aKaDDcOGttSCyHy3IbPb
         CDTFLCXoZFqXP88TWyn+EgrfHvTmI/D0yvIuQgOPQBlgQ8hixg3OGj6MmtZBGl8ILNyN
         AzD3jsCKWNwOyrW0/4k1ElxPnbLeF5Y3x8biVqSEMd3xvQlrw7R+aQ+GhvjAuf8rB3Gk
         Iym5H8M6kYUCa3p9xA7PKCEDcbFwjZbW+E2IywnUJx2S0XTp3Wy83O1UiSEMRHPWnl+C
         KsFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759221096; x=1759825896;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EPblYzRdSvAbjbwbh03+CbSDEcFIuNHCFm6Gcm76lBw=;
        b=WCXViv5Jv/wvpeyn8SvuQSMhcAgeX8Ysmt0bycbz1J1AAk/HYvpHDAL0S7kIAThsm+
         DrbIIvA89cn1C42wPjhT5t3Y+/1ABppVkc92GzxfoYqo4GtaFcYDu+cVY2Fh/11oJtlp
         I4hePcEC6+aJqDVxm/2uX9SDru++eSUhY1JaDh9TdPcBvEwbc4chY64epnFHH7wI5B5m
         WVLgSkBp9GSzCPEw3FvuyLkrsO661/05/FFegvrOtDvOHZeFoIHbgvCXTcCSqq5lvy1E
         gy/zaJqdCWYh3olaIG8NeIdSuFxoSgp+SNoPX1WK3MwBl+oGRK0S0X1SOs/ZvYhlkVDE
         AqiQ==
X-Forwarded-Encrypted: i=1; AJvYcCXtEQJQctVXRfvu+EtOQMhsHJ49gql5A1egyb1wUULNlym1luPDHboJWc0KBo262VRLvmc=@vger.kernel.org
X-Gm-Message-State: AOJu0YwYvHRnE22/F8JnP2fwHGWiDBkdPf1irpVfP6b2qphzAPCXE3DZ
	wn8vGHYJ0Ig7DbzKrX6n3Y5ZzZDONAyqzZ9aHkpvH4Sftf6fWC865LbXgN4QebdZZPU=
X-Gm-Gg: ASbGncuwoF2Sv04+MYaXBdvVitrX9FimskOvznJG/qqhN1TJHT4PqV4HlibdiCaTewA
	q07AJuKKDRgFSLgrXt6zVQKnGdheafSQgWZwGSw2suqp5IFWKOVpnEMmxjLS0vmsn+ii2MQJyhF
	9vtgeaOy2bRE4Zf97GKP0Dlkjlb8nU7RROB2FavcTejD2+YTE/qO15ncsB6GE1+Znt9hxJuyR1J
	OWsIeVtxsXKeGoFrgjTvIXK9FESl8wX/u1VIhS9h+B+pLlgJ0eAGDdE1cMsam/WDV1FRCNWWeyB
	8ltbZCS+Pt5b7hr8ghmgIUFR9NLuq/V4xFUiaE1bqnQchiXwfDoX5DZkCOSFB54g5f1rEuzKu+I
	biq25V/Ifm01T8CZllKJi10qQOJZ5T0N4DRiB6APef3qoGclZrVn+Ii7+pyxgRLq0meQlCJarFJ
	yrDVJwa9Sjb+CKBg==
X-Google-Smtp-Source: AGHT+IF0LgtI7pDkBA/eYAeHLSMtAuwN7D6X/YI2HPPLpuFu6atvuEp5p5mznrjKdUvD2ZsGu34EiA==
X-Received: by 2002:a05:6000:2385:b0:405:8ef9:ee6e with SMTP id ffacd0b85a97d-40e4a8f9b38mr19131448f8f.25.1759221095990;
        Tue, 30 Sep 2025 01:31:35 -0700 (PDT)
Received: from [192.168.69.221] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-40fc749b8f9sm21268471f8f.50.2025.09.30.01.31.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Sep 2025 01:31:35 -0700 (PDT)
Message-ID: <ededf937-5424-4cf7-8ea1-e07709db27f1@linaro.org>
Date: Tue, 30 Sep 2025 10:31:33 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 02/18] system/memory: Better describe @plen argument of
 flatview_translate()
Content-Language: en-US
To: Thomas Huth <thuth@redhat.com>, qemu-devel@nongnu.org,
 Peter Maydell <peter.maydell@linaro.org>, Peter Xu <peterx@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>,
 Ilya Leoshkevich <iii@linux.ibm.com>, Reinoud Zandijk <reinoud@netbsd.org>,
 Zhao Liu <zhao1.liu@intel.com>, David Hildenbrand <david@redhat.com>,
 Halil Pasic <pasic@linux.ibm.com>, kvm@vger.kernel.org,
 "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
 xen-devel@lists.xenproject.org, Stefano Garzarella <sgarzare@redhat.com>,
 David Woodhouse <dwmw2@infradead.org>,
 Sunil Muthuswamy <sunilmut@microsoft.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Matthew Rosato <mjrosato@linux.ibm.com>, qemu-s390x@nongnu.org,
 Paul Durrant <paul@xen.org>, "Michael S. Tsirkin" <mst@redhat.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Anthony PERARD <anthony@xenproject.org>, Jason Herne
 <jjherne@linux.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Eric Farman <farman@linux.ibm.com>
References: <20250930082126.28618-1-philmd@linaro.org>
 <20250930082126.28618-3-philmd@linaro.org>
 <525dd07f-ae64-4ba7-b3ec-b9fcd86aa8a5@redhat.com>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <525dd07f-ae64-4ba7-b3ec-b9fcd86aa8a5@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Thomas,

On 30/9/25 10:24, Thomas Huth wrote:
> On 30/09/2025 10.21, Philippe Mathieu-Daudé wrote:
>> flatview_translate()'s @plen argument is output-only and can be NULL.
>>
>> When Xen is enabled, only update @plen_out when non-NULL.
>>
>> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
>> ---
>>   include/system/memory.h | 5 +++--
>>   system/physmem.c        | 9 +++++----
>>   2 files changed, 8 insertions(+), 6 deletions(-)
>>
>> diff --git a/include/system/memory.h b/include/system/memory.h
>> index aa85fc27a10..3e5bf3ef05e 100644
>> --- a/include/system/memory.h
>> +++ b/include/system/memory.h
>> @@ -2992,13 +2992,14 @@ IOMMUTLBEntry 
>> address_space_get_iotlb_entry(AddressSpace *as, hwaddr addr,
>>    * @addr: address within that address space
>>    * @xlat: pointer to address within the returned memory region 
>> section's
>>    * #MemoryRegion.
>> - * @len: pointer to length
>> + * @plen_out: pointer to valid read/write length of the translated 
>> address.
>> + *            It can be @NULL when we don't care about it.
>>    * @is_write: indicates the transfer direction
>>    * @attrs: memory attributes
>>    */
>>   MemoryRegion *flatview_translate(FlatView *fv,
>>                                    hwaddr addr, hwaddr *xlat,
>> -                                 hwaddr *len, bool is_write,
>> +                                 hwaddr *plen_out, bool is_write,
>>                                    MemTxAttrs attrs);
>>   static inline MemoryRegion *address_space_translate(AddressSpace *as,
>> diff --git a/system/physmem.c b/system/physmem.c
>> index 8a8be3a80e2..86422f294e2 100644
>> --- a/system/physmem.c
>> +++ b/system/physmem.c
>> @@ -566,7 +566,7 @@ iotlb_fail:
>>   /* Called from RCU critical section */
>>   MemoryRegion *flatview_translate(FlatView *fv, hwaddr addr, hwaddr 
>> *xlat,
>> -                                 hwaddr *plen, bool is_write,
>> +                                 hwaddr *plen_out, bool is_write,
>>                                    MemTxAttrs attrs)
>>   {
>>       MemoryRegion *mr;
>> @@ -574,13 +574,14 @@ MemoryRegion *flatview_translate(FlatView *fv, 
>> hwaddr addr, hwaddr *xlat,
>>       AddressSpace *as = NULL;
>>       /* This can be MMIO, so setup MMIO bit. */
>> -    section = flatview_do_translate(fv, addr, xlat, plen, NULL,
>> +    section = flatview_do_translate(fv, addr, xlat, plen_out, NULL,
>>                                       is_write, true, &as, attrs);
>>       mr = section.mr;
>> -    if (xen_enabled() && memory_access_is_direct(mr, is_write, attrs)) {
>> +    if (xen_enabled() && plen_out && memory_access_is_direct(mr, 
>> is_write,
>> +                                                             attrs)) {
>>           hwaddr page = ((addr & TARGET_PAGE_MASK) + TARGET_PAGE_SIZE) 
>> - addr;
>> -        *plen = MIN(page, *plen);
>> +        *plen_out = MIN(page, *plen_out);
>>       }
> 
> My question from the previous version is still unanswered:
> 
> https://lore.kernel.org/qemu- 
> devel/22ff756a-51a2-43f4-8fe1-05f17ff4a371@redhat.com/

This patches
- checks for plen not being NULL
- describes it as
   "When Xen is enabled, only update @plen_out when non-NULL."
- mention that in the updated flatview_translate() documentation
   "It can be @NULL when we don't care about it." as documented for
   the flatview_do_translate() callee in commit d5e5fafd11b ("exec:
   add page_mask for flatview_do_translate")

before:

   it was not clear whether we can pass plen=NULL without having
   to look at the code.

after:

   no change when plen is not NULL, we can pass plen=NULL safely
   (it is documented).

I shouldn't be understanding your original question, do you mind
rewording it?

Thanks,

Phil.

