Return-Path: <kvm+bounces-38671-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7424FA3D8CB
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 12:35:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 747ED3BD0BC
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 11:32:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53EA71F3D31;
	Thu, 20 Feb 2025 11:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jNq/H8qQ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4CEE1EC016
	for <kvm@vger.kernel.org>; Thu, 20 Feb 2025 11:32:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740051145; cv=none; b=nQTS5W/uDfAC0DEgTRAlvEy48uIgk46k45aGKFplF65P/5i3QzGA3lbX/HFHFSYnTNHdx8HS7Ov2BnUDbbYqcA8TxYCY0MV+tJi8WU/DJiMNw7Ez5oblq69FxOMu0x8XHCDAS/1V9XL5ebHp5/a0ShFE+S0WqG0zxa9oWRuj1RY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740051145; c=relaxed/simple;
	bh=pZ4bpSKEcwgSUFmHA2jLKYfeqeem7hzqJvyeEI0zvZ8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tCUks+FOX6ZiqAdIH0DjGWkx7/oYxQEa2NtUJ2W81ejWwI/mSmDdRpYGW0jyMwZXdxHyu2v/z22Pjp00yjPI8BS9tiL2/p63HN7Twcg1mAVfbTFUr+OTBR6fYTVhix6qrQq+fTCxPsEelRB+QOCVr/UUgHGnNN2sERkOKZSjNKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jNq/H8qQ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740051142;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=8mRY+So1WivUpFbib9B31uZ25A0wN1i6jJh5GjV5nEA=;
	b=jNq/H8qQrlRurjpAgi0hEOomqUBwkHXZ0o78nPY+Km1czKqcrldngJe02Mi+IQbPAMr1Id
	79aeFNmVKueR96pmP1dU6/VwtKjo7pPs/c2OcWMz0t8htmTNEx8BVkGPxgKZSl4kO1qYAT
	iAlhfItHRUrH5GKOShSyXZhghRhub4g=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-541-3EiZ_4YHMZKSItafXZxO1w-1; Thu, 20 Feb 2025 06:32:21 -0500
X-MC-Unique: 3EiZ_4YHMZKSItafXZxO1w-1
X-Mimecast-MFC-AGG-ID: 3EiZ_4YHMZKSItafXZxO1w_1740051140
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-38f628ff78eso378465f8f.1
        for <kvm@vger.kernel.org>; Thu, 20 Feb 2025 03:32:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740051140; x=1740655940;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=8mRY+So1WivUpFbib9B31uZ25A0wN1i6jJh5GjV5nEA=;
        b=IYG8n08ntrJaioNk5lTQw5QFtrnZg0HVJoieefoxTfJrFlZh3b/EjqrpqUIy9XP3LM
         4q/v41ETuogYLEyaOUyurjEHQQzG+mNIYIcOw6DxBH14WFfr7HrvogDz8v/R0HGQDdeX
         fLghOb1jL591EUbHh/mmJY1wuoo3doPof94ZenltkHTYgloTUhiIfXL68tRAtrIUEcF0
         ewdZF3OKfVxGV02htEmd0TnOXIcVlFhomtJWeHYhgDvA5LT14r5SyqQtXZQP3YVoOxrm
         MpamkJYiyH71JHcUyNnywKy2YYCG8juGWuhBVysUACv0r0pU6hArcRBd7XGmqChq4szY
         vpBA==
X-Forwarded-Encrypted: i=1; AJvYcCXXHvOGbPEkhn/UkmmoT2zk5wjNUMstbukIIsgEQCCkXDxxDIimaOLU/VmY57OdRiSkCRI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzkyJttNezkkX92I9zK/VX7XpewB1ozgHu9u/tJFanNCkNDgCLK
	K+ArAO5dBjGJ9Xbt1TWu4ujA75B9kmoO+Q4nwxzvFbUfQgi+3SEQomocZKBNosOkNSC/Pe7OE2w
	w/w7IHKsNWgnR+lyIJ+hjSNJi+NyFk0/tj5mkaz/D9RtsVWp/Gg==
X-Gm-Gg: ASbGncvpcCq9zMVcsLfAA0/GkVZKOkNSPSA4gExdTkCch2X0NnoDNkr5jB73NLSNy+L
	a/PTRpv+XJ8rkRd9Db1VGgVS+0VG+DkHyxhK0PySAhbcEoHkD9P9oRiQXXLCUuugXxCqm49hlj6
	iJ2B8til+gkSYQWpONgJIi1K/+Rz62owEsPLBp/d3ANYrpgAu1x29QHZco/bwMEBDLNa43e+F5e
	jFi68yYtYet8cwbT5JsLXjJvdMlLZmXLaFXKmQMVxlBtVkobZkDRMmCVy5FaAXjooOMoVoIbQhK
	kHI6fqc81WeM3wYjbmO8mv1kW/wA4IAb9fEI6YGZGy5btwSZzrp7Xjo6bkaaEJYu5IEi82N8iox
	i4yBjd4HBzGsF9KzMXtDGRdnepsbpYw==
X-Received: by 2002:a5d:42c7:0:b0:38d:ae4e:2267 with SMTP id ffacd0b85a97d-38f615b890cmr2127886f8f.11.1740051140406;
        Thu, 20 Feb 2025 03:32:20 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGOguLsURugLcUQPNyBziBSpfOAZiEb1o2YCCXBm2R48OoTq5r3QtDqKrDP7mjqjzclTzg1Lw==
X-Received: by 2002:a5d:42c7:0:b0:38d:ae4e:2267 with SMTP id ffacd0b85a97d-38f615b890cmr2127862f8f.11.1740051139991;
        Thu, 20 Feb 2025 03:32:19 -0800 (PST)
Received: from ?IPV6:2003:cb:c706:2000:e44c:bc46:d8d3:be5? (p200300cbc7062000e44cbc46d8d30be5.dip0.t-ipconnect.de. [2003:cb:c706:2000:e44c:bc46:d8d3:be5])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38f259d5b40sm20619360f8f.68.2025.02.20.03.32.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Feb 2025 03:32:18 -0800 (PST)
Message-ID: <6dbe4547-2271-4db9-9cf6-2c497c45eff6@redhat.com>
Date: Thu, 20 Feb 2025 12:32:15 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 02/11] KVM: guest_memfd: Handle final folio_put() of
 guest_memfd pages
To: Vlastimil Babka <vbabka@suse.cz>, Fuad Tabba <tabba@google.com>,
 kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
 anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk,
 brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org,
 xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com,
 jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com,
 yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com, mic@digikod.net,
 vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name,
 michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com,
 isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com,
 suzuki.poulose@arm.com, steven.price@arm.com, quic_eberman@quicinc.com,
 quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com,
 quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com,
 quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com,
 james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev,
 maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com,
 roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com,
 rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com,
 jthoughton@google.com
References: <20250211121128.703390-1-tabba@google.com>
 <20250211121128.703390-3-tabba@google.com>
 <8ddab670-8416-47f2-a5a6-94fb3444f328@redhat.com>
 <5746ef9f-92da-4f83-bdf8-96169b090cff@suse.cz>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <5746ef9f-92da-4f83-bdf8-96169b090cff@suse.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 20.02.25 12:28, Vlastimil Babka wrote:
> On 2/20/25 12:25, David Hildenbrand wrote:
>> On 11.02.25 13:11, Fuad Tabba wrote:
>>> Before transitioning a guest_memfd folio to unshared, thereby
>>> disallowing access by the host and allowing the hypervisor to
>>> transition its view of the guest page as private, we need to be
>>> sure that the host doesn't have any references to the folio.
>>>
>>> This patch introduces a new type for guest_memfd folios, which
>>> isn't activated in this series but is here as a placeholder and
>>> to facilitate the code in the next patch. This will be used in
>>> the future to register a callback that informs the guest_memfd
>>> subsystem when the last reference is dropped, therefore knowing
>>> that the host doesn't have any remaining references.
>>>
>>> Signed-off-by: Fuad Tabba <tabba@google.com>
>>> ---
>>
>> [...]
>>
>>>    static const char *page_type_name(unsigned int page_type)
>>> diff --git a/mm/swap.c b/mm/swap.c
>>> index 47bc1bb919cc..241880a46358 100644
>>> --- a/mm/swap.c
>>> +++ b/mm/swap.c
>>> @@ -38,6 +38,10 @@
>>>    #include <linux/local_lock.h>
>>>    #include <linux/buffer_head.h>
>>>    
>>> +#ifdef CONFIG_KVM_GMEM_SHARED_MEM
>>> +#include <linux/kvm_host.h>
>>> +#endif
>>> +
>>>    #include "internal.h"
>>>    
>>>    #define CREATE_TRACE_POINTS
>>> @@ -101,6 +105,11 @@ static void free_typed_folio(struct folio *folio)
>>>    	case PGTY_hugetlb:
>>>    		free_huge_folio(folio);
>>>    		return;
>>> +#endif
>>> +#ifdef CONFIG_KVM_GMEM_SHARED_MEM
>>> +	case PGTY_guestmem:
>>> +		kvm_gmem_handle_folio_put(folio);
>>> +		return;
>>
>> Hm, if KVM is built as a module, will that work? Or would we need the
> 
> Good catch, I guess not?
> 
>> core-mm guest_memfd shim that would always be compiled into the core and
>> decouple KVM from guest_memfd ("library")?
> 
> That could also help avoid exporting the mpol symbols in the NUMA mempolicy
> series?

Yes [1]! :)

[1] 
https://lore.kernel.org/linux-mm/9392618e-32de-4a86-9e1e-bcfeefe39181@redhat.com/

-- 
Cheers,

David / dhildenb


