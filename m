Return-Path: <kvm+bounces-29052-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 006AA9A1CFB
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2024 10:19:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 246CF1C2191F
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2024 08:19:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 090BB1D0BAE;
	Thu, 17 Oct 2024 08:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="N3PPXrHJ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7A891C2447
	for <kvm@vger.kernel.org>; Thu, 17 Oct 2024 08:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729153185; cv=none; b=ar/uyutTQ24wFJ+XIqL5kjQQNdK+CfwakbLPck8OccZeN3xRFr2XU/6chxqDMQGK3WkEfhqIHko4o/tg2hXPZtC0G5ll2l6XNAU3ug6Q2TTjCzPGu/MopPyoNuaicHxKjLdKLMx8WZ6nDOrEJbWwSHzUtdAGgUrCYEdqidY99jA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729153185; c=relaxed/simple;
	bh=drap6yRTWUV8zY03UQ8GuuoRsDJoBiyKbOtSKJ+Ypww=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=B3yGgtSv7lalFIySJcTWaUCeSQpUicwDxmxY8IPi4SQ2Zef1i1a1nubcSg5e02tnjVFkzbMxDEZJQETVanYZVuRqyzkxfS/B0WpxD6pByRLmxa3+fddpukiLMo5TgL7ydmUySAQuWJjYNBJiLDM353671v3AW/KpZ3x69TdgtPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=N3PPXrHJ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729153182;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=yucW1PH2OPYsrEpldE45jW5xNoecHxa8NdyxGrQqNKM=;
	b=N3PPXrHJhRgl5DbnsYsLe+oIVe/pDmcVgczn4oQbq+AdQuyYTY9KjOCo4eNgVtVVuhfvrD
	CWkzxB6KkhH2DQ2jK2iKWgUZm4AcD8loGZqT/+4SEpHEzFb4lIyM1dLeTV3z6iV8tUFBML
	hLaZSFEpmvBf3dJkKrn2UHY0Rnk7sns=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-197-zM8n_bi4PCu4FXpchyeyug-1; Thu, 17 Oct 2024 04:19:41 -0400
X-MC-Unique: zM8n_bi4PCu4FXpchyeyug-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-37d5ca5bfc8so340608f8f.0
        for <kvm@vger.kernel.org>; Thu, 17 Oct 2024 01:19:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729153180; x=1729757980;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=yucW1PH2OPYsrEpldE45jW5xNoecHxa8NdyxGrQqNKM=;
        b=FvwGNKmsiWHvNbury0VvoLhuO8iheAO0SfhWuLhlZolAfUwn/2jBnv19gfjikDdYdf
         5jfPX1cn7IufDOvCypNwvsaNDRA8A0WhU4vTHuTixpODw5nM2wrFoKn/KctQfuwVQeV2
         wvuyqSTAtyE+pb2MKuZFXbmBSY1Yxwtllg3+/EE+wV+sbz6nKXQohXmrOSIFa2OFsVKZ
         HtozKJQh5eQu4iRb85A92MqwiDIx7h8Qo+XgQUYGGjDmnJ6K3uHNzDPAhKpG8N2OUBDB
         uuMT5SavpRyN24WRb4hPZZmhXAWMy4b084/PP3C0QyKdjRh1BvuZHk1fooHLDCUCVkjL
         X43w==
X-Forwarded-Encrypted: i=1; AJvYcCWyR1XWXbTb9iwtOE/pmP1JAyJq65KL69GY6hiF9oay/eG+85oFX6QCZ7iXNhs1N2JE2uA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzqoM8VSHb2ZqWiRAm79jC3oRVfuNMC8cbAoPMt2j5VXRVEs/Nx
	5i4/fDjAaxtl8hKLhw5I8M4y7Xw9svUr+R5YIBuxGlPR074RbTO4SfkZv4swmkA30GhpTAayy6e
	uekbkY2A1kaNb2YFrKVb12QIhLk3d3WQQ1fE+Fa5t40062Y6acQ==
X-Received: by 2002:adf:e908:0:b0:37c:cd0d:3437 with SMTP id ffacd0b85a97d-37d5530438bmr15476776f8f.58.1729153179985;
        Thu, 17 Oct 2024 01:19:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEHvGRV7gRI9scIXVqygnO0gFFWAgggOmNSlEaAKQ5e7/aADl4rIuAo+u5BaUehhaRDGGy2LQ==
X-Received: by 2002:adf:e908:0:b0:37c:cd0d:3437 with SMTP id ffacd0b85a97d-37d5530438bmr15476747f8f.58.1729153179553;
        Thu, 17 Oct 2024 01:19:39 -0700 (PDT)
Received: from ?IPV6:2003:cb:c705:7600:62cc:24c1:9dbe:a2f5? (p200300cbc705760062cc24c19dbea2f5.dip0.t-ipconnect.de. [2003:cb:c705:7600:62cc:24c1:9dbe:a2f5])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43158c3dedfsm18012235e9.26.2024.10.17.01.19.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Oct 2024 01:19:39 -0700 (PDT)
Message-ID: <04d5169f-3289-4aac-abca-90b20ad4e9c9@redhat.com>
Date: Thu, 17 Oct 2024 10:19:36 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/7] s390/physmem_info: query diag500(STORAGE LIMIT) to
 support QEMU/KVM memory devices
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
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <ZxC+mr5PcGv4fBcY@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 17.10.24 09:36, Alexander Gordeev wrote:
> On Mon, Oct 14, 2024 at 04:46:16PM +0200, David Hildenbrand wrote:
> 
> Hi David!

Hi Alexander!

> 
>> @@ -157,7 +189,9 @@ unsigned long detect_max_physmem_end(void)
>>   {
>>   	unsigned long max_physmem_end = 0;
>>   
>> -	if (!sclp_early_get_memsize(&max_physmem_end)) {
>> +	if (!diag500_storage_limit(&max_physmem_end)) {
>> +		physmem_info.info_source = MEM_DETECT_DIAG500_STOR_LIMIT;
>> +	} else if (!sclp_early_get_memsize(&max_physmem_end)) {
>>   		physmem_info.info_source = MEM_DETECT_SCLP_READ_INFO;
>>   	} else {
>>   		max_physmem_end = search_mem_end();
>> @@ -170,11 +204,17 @@ void detect_physmem_online_ranges(unsigned long max_physmem_end)
>>   {
>>   	if (!sclp_early_read_storage_info()) {
>>   		physmem_info.info_source = MEM_DETECT_SCLP_STOR_INFO;
>> +		return;
>>   	} else if (!diag260()) {
>>   		physmem_info.info_source = MEM_DETECT_DIAG260;
>> -	} else if (max_physmem_end) {
>> -		add_physmem_online_range(0, max_physmem_end);
>> +		return;
>> +	} else if (physmem_info.info_source == MEM_DETECT_DIAG500_STOR_LIMIT) {
>> +		max_physmem_end = 0;
>> +		if (!sclp_early_get_memsize(&max_physmem_end))
>> +			physmem_info.info_source = MEM_DETECT_SCLP_READ_INFO;
> 
> Why search_mem_end() is not tried in case sclp_early_get_memsize() failed?

Patch #3 documents that:

+    The storage limit does not indicate currently usable storage, it may
+    include holes, standby storage and areas reserved for other means, such
+    as memory hotplug or virtio-mem devices. Other interfaces for detecting
+    actually usable storage, such as SCLP, must be used in conjunction with
+    this subfunction.

If SCLP would fail, something would be seriously wrong and we should just crash
instead of trying to fallback to the legacy way of scanning.

> 
>>   	}
>> +	if (max_physmem_end)
>> +		add_physmem_online_range(0, max_physmem_end);
>>   }
>>   
>>   void physmem_set_usable_limit(unsigned long limit)
>> diff --git a/arch/s390/include/asm/physmem_info.h b/arch/s390/include/asm/physmem_info.h
>> index f45cfc8bc233..51b68a43e195 100644
>> --- a/arch/s390/include/asm/physmem_info.h
>> +++ b/arch/s390/include/asm/physmem_info.h
>> @@ -9,6 +9,7 @@ enum physmem_info_source {
>>   	MEM_DETECT_NONE = 0,
>>   	MEM_DETECT_SCLP_STOR_INFO,
>>   	MEM_DETECT_DIAG260,
>> +	MEM_DETECT_DIAG500_STOR_LIMIT,
>>   	MEM_DETECT_SCLP_READ_INFO,
>>   	MEM_DETECT_BIN_SEARCH
>>   };
>> @@ -107,6 +108,8 @@ static inline const char *get_physmem_info_source(void)
>>   		return "sclp storage info";
>>   	case MEM_DETECT_DIAG260:
>>   		return "diag260";
>> +	case MEM_DETECT_DIAG500_STOR_LIMIT:
>> +		return "diag500 storage limit";
> 
> AFAIU you want to always override MEM_DETECT_DIAG500_STOR_LIMIT method
> with an online memory detection method. In that case this code is dead.

Not in the above case, pathological case above where something went wrong
during sclp_early_get_memsize(). In that scenario, die_oom() would indicate
that there are no memory ranges but that "diag500 storage limit" worked.

Does that make sense?

Thanks for the review!

-- 
Cheers,

David / dhildenb


