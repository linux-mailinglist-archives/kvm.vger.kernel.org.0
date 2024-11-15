Return-Path: <kvm+bounces-31907-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EBAF19CD4FA
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2024 02:20:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B3A30281797
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2024 01:20:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC30C13541B;
	Fri, 15 Nov 2024 01:19:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W2lHmIDj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EDCF77F1B;
	Fri, 15 Nov 2024 01:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731633587; cv=none; b=cmdbcqyCJ0q+rMYxtBWPQPffyrcEmo5L5i0Xk9NtIKcMOfkD/j3fV6eFwTbf13BaEuAkYATPxkaXrOxOFarsX0LNLqZCJyKX+I2oeBPVjZmkT62hL3rJQ5OZaTEahFLFlxQP62v70FNSTIBOTzg8czW1kWupM5Jsyh0vqe67Y6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731633587; c=relaxed/simple;
	bh=h7oRV1nbfjsFc00eUaw9KaflULdd94NiX150E/lhGig=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AhZoB4wz1v14a8/3E2WHxsGSm0iRkWodnR+yMgv806mP7cqu/GBtfV65kIyrjig/V2TPRgBP65/BC0AUjG4CsS5fCX+cQ9XSZqmmeiQ/UW1KyXZL2B6w7cOPMnnONSIo7RUHnJR2D9FYngDsTpLMSmYvoI0jNGId2xE1rRqnf9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=W2lHmIDj; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-5c95a962c2bso350718a12.2;
        Thu, 14 Nov 2024 17:19:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731633583; x=1732238383; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=OTJiLj8Cl/gid6IIoC6CA3YIEMl5qRRB8q0gUg2Qs+w=;
        b=W2lHmIDjyUqglGGgfaMAYDQZ6bpE2T746VG19dns/YZu9JGZm9mobHocFVvqAywBwT
         ZlPxWdKlV1V0jwknJRAl86pHhkJI3hnPGdwtmk1mLieXM62oCmJfNKac0zZ9modgrW0R
         0AreC0LyvxfjklM30dlzhOf7SPxllnjcRRtfxnT9pLxa9XAL01Jlr6UmhuiVtTKaQm69
         1X4Jo6rbwaJ9CkcxEuvQccRAn8QJsmlSCwXJ5ujRPcdn+9rZrhPpi3nO/m6RL72C1iwE
         Yr23djfzEs5/TJeMjxllm/RnG0Lrlu+nbfGAoOIybyXphnSklUnhmC+qvE9AMDGgZStR
         /Ntg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731633583; x=1732238383;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OTJiLj8Cl/gid6IIoC6CA3YIEMl5qRRB8q0gUg2Qs+w=;
        b=ShY/thZ0lzxkDfzjrJIQr0BXii5w9/OX3C4EkzKZQwsmmcbW4m3LOKYEEv0oHf408O
         ljROXXJBD1FGxj/6htS2z5Umw/vvg1Zmpmr95tVhxoqeY5KeVYwhAKc+L/FuNew5DsDm
         4RSkMgrEGE/pClFMjv3RG62e42OLDnEC2kU9LHvNL1ImaEsKkEHbt0NK40aCzRr393+j
         nNdFYSE751xw8DvYRUv7icod01Cd8Gkm8VMTQxKr+myZusBcW4QMGDd0QA1QJNVpH0I5
         9hE/0B3jrC9ZKfNKkpCfwDiGQAy+dzgLsbXelSKe1kaDKBoSU7MtAfyYecmy3qRYp7w6
         goRQ==
X-Forwarded-Encrypted: i=1; AJvYcCU8Yle7Pz4tIObXx0HPbmskgpOIuQCuUn07jI/tx/FdGtCR5iVEPt1L7L6yXUyWqmys1xo=@vger.kernel.org, AJvYcCUIG2KmewvUQhNM/UjxQDp3/8qUcroKTpDS2FU97Hjs+Tjt1WBBJvPYsLQdnr1OZhlh3B712L5g6wkhc7qn@vger.kernel.org, AJvYcCXUFsUnyX12++WSMsuW4Bt7IYvfM6hicB/tB81FYAZ5O0mV0kGOdalu0EbxK+tEqYw++2H7ibd9lU35@vger.kernel.org
X-Gm-Message-State: AOJu0YzkYGDeelDlv3W/L2ngD5NX24AOEVrunEmyLxYgucihNNdXVhVH
	yt3D1yH2l0A6Q2cp5FOHeJiKA0xjmCm8Qup4+kHVvV3PYNl21RNz
X-Google-Smtp-Source: AGHT+IGtW9iSQmpcrn6weGm5G253EH2j+gzOxZzvx687F8weem2GgXEiQKu5n+yi+N9etxW9vKM2UA==
X-Received: by 2002:aa7:c3c9:0:b0:5cf:9004:bd4c with SMTP id 4fb4d7f45d1cf-5cf9004be90mr278753a12.29.1731633583291;
        Thu, 14 Nov 2024 17:19:43 -0800 (PST)
Received: from ?IPV6:2a01:e11:5400:7400:dc78:53a0:d8e6:28cd? ([2a01:e11:5400:7400:dc78:53a0:d8e6:28cd])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5cf79bb3b04sm1065585a12.42.2024.11.14.17.19.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Nov 2024 17:19:42 -0800 (PST)
Message-ID: <d824d93d-8724-4e71-acb9-215010d8c3fb@gmail.com>
Date: Fri, 15 Nov 2024 02:19:41 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Documentation: kvm: fix tipo in api.rst
To: Sean Christopherson <seanjc@google.com>
Cc: corbet@lwn.net, pbonzini@redhat.com, kvm@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20241114223738.290924-3-gianf.trad@gmail.com>
 <ZzaE9dYmSqg3U33y@google.com>
From: Gianfranco Trad <gianf.trad@gmail.com>
Content-Language: en-US, it
Autocrypt: addr=gianf.trad@gmail.com; keydata=
 xjMEZyAY2RYJKwYBBAHaRw8BAQdA3W2zVEPRi03dmb95c7NkmFyBZi+VAplZZX9YVcsduG3N
 JkdpYW5mcmFuY28gVHJhZCA8Z2lhbmYudHJhZEBnbWFpbC5jb20+wo8EExYIADcWIQRJFQhW
 JFLZFapGQPDIleIjeBnIywUCZyAY2QUJA8JnAAIbAwQLCQgHBRUICQoLBRYCAwEAAAoJEMiV
 4iN4GcjL+JkA/RWGFWAqY06TH+ZZKuhNhvJhj2+dqgPF0QRjILpGSVJyAQCsvpKVS6H9ykYP
 Qyi/UyxIKxa8tcdSP1oUj9YIAHUcC844BGcgGNkSCisGAQQBl1UBBQEBB0BlosN6xF2pP/d7
 RVTlTFktASXfYhN0cghGG6dk5r47NgMBCAfCfgQYFggAJhYhBEkVCFYkUtkVqkZA8MiV4iN4
 GcjLBQJnIBjZBQkDwmcAAhsMAAoJEMiV4iN4GcjLuIIBAJBEkfB4sVF7T46JBpJBP5jBHm4B
 nmn274Qd7agQUZR4AQDfkC/p4qApuqZvZ3H0qOkexpf9swGV1UtmmzYQdmjyAw==
In-Reply-To: <ZzaE9dYmSqg3U33y@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 15/11/24 00:17, Sean Christopherson wrote:
> I must know.  Is the "tipo" in the shortlog intentional? :-)
> 
> On Thu, Nov 14, 2024, Gianfranco Trad wrote:
>> Fix minor typo in api.rst where the word physical was misspelled
>> as physcial.
>>
>> Signed-off-by: Gianfranco Trad <gianf.trad@gmail.com>
>> ---
>>   Documentation/virt/kvm/api.rst | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
>> index edc070c6e19b..4ed8f222478a 100644
>> --- a/Documentation/virt/kvm/api.rst
>> +++ b/Documentation/virt/kvm/api.rst
>> @@ -5574,7 +5574,7 @@ KVM_XEN_ATTR_TYPE_SHARED_INFO_HVA
>>     in guest physical address space. This attribute should be used in
>>     preference to KVM_XEN_ATTR_TYPE_SHARED_INFO as it avoids
>>     unnecessary invalidation of an internal cache when the page is
>> -  re-mapped in guest physcial address space.
>> +  re-mapped in guest physical address space.
>>   
>>     Setting the hva to zero will disable the shared_info page.
>>   
>> -- 
>> 2.43.0
>>
Ouch... I wish it was, that would have been a hell of a story :,-).
I might think of it for future patches *jokes*. But no, probably my 
brain's italian side subconsciously kicked in (tipo is an existent word 
in italian), in that moment...

Thanks for noticing Sean, I'll send a v2 asap.

--Gian

