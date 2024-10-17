Return-Path: <kvm+bounces-29061-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 02CBB9A21DC
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2024 14:07:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AD9A0283B12
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2024 12:07:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E4501DD523;
	Thu, 17 Oct 2024 12:07:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iVhBv7ix"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E53F1DCB31
	for <kvm@vger.kernel.org>; Thu, 17 Oct 2024 12:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729166840; cv=none; b=WFR3U5aTzvO2UvgqTey5zKO/h8ayO8K3AgBVidKfi8n1YPYVcVVkxMqnSIv5ClYzdd9+tEJkSUK0ig0LfdmCQHt2jb3tWMtyxwVn+kFwS3FaeyGJ+GNaysuCSTWcJUZXWnUJ/EWvlsMKK7u9YC21rVi4j340BImPLvBsG01JD48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729166840; c=relaxed/simple;
	bh=dXb6XyiXk/+aUp3Pwekw1+a/Oqt07DIe4NaNC6mAOSs=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=CjT0bozsP46GulicMKgJbLLcA2luZKzZV7TEnvGQJlGByMWzu2kqdqaqjE7famBVKKDVh2raL0Woc+DxkaOrvyLEdsW5WAtdX/kmwAbGgwcqtzmNK0nr90BWbawpN0B7pC2wiZFdH/6KZ1tHI+u3+OgnMA/RD4AlLaDaZW1ClCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iVhBv7ix; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729166838;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=2/IGRRzIJv3DLfiog8MtLmqRn3GxBRWzG+PtYfHPlzU=;
	b=iVhBv7ixOOQpRUdA6k9iB8/5iqY1a/w6E2WzWwVKNlSzjjK1E5n0vVYT7UQQZ/WgqQ+aMY
	V8LzvGXcY/BC16nFEsYreOZ7F+Sp2gdilYxEKMhWix83S4pRyKc2Hyw28KA8EnmGE48X5Z
	Lp2Xn1CnONlvrOsgTBit0hJ1TJaUnpU=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-78-dHSDdbLaOCKQjVnuVCyfVA-1; Thu, 17 Oct 2024 08:07:16 -0400
X-MC-Unique: dHSDdbLaOCKQjVnuVCyfVA-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-43151a9ea95so8389995e9.1
        for <kvm@vger.kernel.org>; Thu, 17 Oct 2024 05:07:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729166835; x=1729771635;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:references:cc:to:from:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=2/IGRRzIJv3DLfiog8MtLmqRn3GxBRWzG+PtYfHPlzU=;
        b=A8JwaCT17/S1nO+jV0PFEDgXJ4C9tH4kDTbv3h/cs2tRN9AgUggm/oaqzR62BO+csa
         C6mTN5/MXZfyr1Bbd1Sem2Nua4xaLfdwBrqajO5dpliDDNonJlI4cBWymBoU0ISGmqHV
         nSWLs9zt+RtdAd0bTjRkXtq9zA+DAKm2rHg5KaSjlBW+Lb22/Sf07JETp2PhrBThxfpS
         FhqtnqLMXS2wsu+MDcLGumyH6kWowUj4OnQVfCT9WHAYtIqergr67ZwL3b7HtBDdHKmz
         WLeqSTHHZqcAKLxeo7d2pvooiOrO1cAKALdp/PEEe/m0qoAYLk83bEOkWLY80BGokeuP
         hCGg==
X-Forwarded-Encrypted: i=1; AJvYcCWtjV89z89/jv4BBWh2VoQh0rmV65UiZK/e/jHHfwcBBaKpFeXAHjJZYm/sMwIW7rpyi9E=@vger.kernel.org
X-Gm-Message-State: AOJu0YyZ/4TZwneElkrbgPfbZSiw2jG7JUbqy7b4qqCKsEXknNgmreLU
	ncxS6+7ObK/ShBq0prE0+JeP3tjVlA8O3TdHWVPOzKFwtECgmXaEzN1VRHM3j5qqT8JCpVxs3xR
	cPhqpVIKHYZ9q6AsDuKIolKYiYuCvuN49ay5SBPCDA4zTNUXNjg==
X-Received: by 2002:a05:600c:46c7:b0:431:5475:3cd1 with SMTP id 5b1f17b1804b1-4315875fb2fmr17727495e9.17.1729166834704;
        Thu, 17 Oct 2024 05:07:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFNtzUUQ7bQ+NpQeHrbKRpg9T0l3bVeZZHrV5Z5JZeh/ysPpsYqvaaR5yenVoFBRSIOrkr5Fw==
X-Received: by 2002:a05:600c:46c7:b0:431:5475:3cd1 with SMTP id 5b1f17b1804b1-4315875fb2fmr17727205e9.17.1729166834226;
        Thu, 17 Oct 2024 05:07:14 -0700 (PDT)
Received: from ?IPV6:2003:cb:c705:7600:62cc:24c1:9dbe:a2f5? (p200300cbc705760062cc24c19dbea2f5.dip0.t-ipconnect.de. [2003:cb:c705:7600:62cc:24c1:9dbe:a2f5])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-37d7fa7a2a8sm7055378f8f.3.2024.10.17.05.07.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Oct 2024 05:07:13 -0700 (PDT)
Message-ID: <45de474c-9af3-4d71-959f-6dbc223b432b@redhat.com>
Date: Thu, 17 Oct 2024 14:07:12 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/7] s390/physmem_info: query diag500(STORAGE LIMIT) to
 support QEMU/KVM memory devices
From: David Hildenbrand <david@redhat.com>
To: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-s390@vger.kernel.org, virtualization@lists.linux.dev,
 linux-doc@vger.kernel.org, kvm@vger.kernel.org,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, Thomas Huth <thuth@redhat.com>,
 Cornelia Huck <cohuck@redhat.com>, Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?=
 <eperezma@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
 Jonathan Corbet <corbet@lwn.net>, Mario Casquero <mcasquer@redhat.com>
References: <20241014144622.876731-1-david@redhat.com>
 <20241014144622.876731-5-david@redhat.com>
 <ZxC+mr5PcGv4fBcY@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
 <04d5169f-3289-4aac-abca-90b20ad4e9c9@redhat.com>
 <ZxDetq73hETPMjln@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
 <1c7ef09e-9ba2-488e-a249-4db3f65e077d@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <1c7ef09e-9ba2-488e-a249-4db3f65e077d@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 17.10.24 12:00, David Hildenbrand wrote:
> On 17.10.24 11:53, Alexander Gordeev wrote:
>>>> Why search_mem_end() is not tried in case sclp_early_get_memsize() failed?
>>>
>>> Patch #3 documents that:
>>>
>>> +    The storage limit does not indicate currently usable storage, it may
>>> +    include holes, standby storage and areas reserved for other means, such
>>> +    as memory hotplug or virtio-mem devices. Other interfaces for detecting
>>> +    actually usable storage, such as SCLP, must be used in conjunction with
>>> +    this subfunction.
>>
>> Yes, I read this and that exactly what causes my confusion. In this wording it
>> sounds like SCLP *or* other methods are fine to use. But then you use SCLP or
>> DIAGNOSE 260, but not memory scanning. So I am still confused ;)
> 
> Well, DIAGNOSE 260 is z/VM only and DIAG 500 is KVM only. So there are
> currently not really any other reasonable ways besides SCLP.

Correction: Staring at the code again, in detect_physmem_online_ranges()
we will indeed try:

a) sclp_early_read_storage_info()
b) diag260()

But if neither works, we cannot blindly add all that memory, something is
messed up. So we'll fallback to

c) sclp_early_get_memsize()

But if none of that works, something is seriously wrong.


I will squash the following:

diff --git a/arch/s390/boot/physmem_info.c b/arch/s390/boot/physmem_info.c
index 975fc478e0e3..6ad3ac2050eb 100644
--- a/arch/s390/boot/physmem_info.c
+++ b/arch/s390/boot/physmem_info.c
@@ -214,6 +214,12 @@ void detect_physmem_online_ranges(unsigned long max_physmem_end)
                 return;
         } else if (physmem_info.info_source == MEM_DETECT_DIAG500_STOR_LIMIT) {
                 max_physmem_end = 0;
+               /*
+                * If we know the storage limit but do not find any other
+                * indication of usable initial memory, something is messed
+                * up. In that case, we'll not add any physical memory so
+                * we'll run into die_oom() later.
+                */
                 if (!sclp_early_get_memsize(&max_physmem_end))
                         physmem_info.info_source = MEM_DETECT_SCLP_READ_INFO;
         }


-- 
Cheers,

David / dhildenb


