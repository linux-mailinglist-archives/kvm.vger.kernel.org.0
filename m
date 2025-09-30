Return-Path: <kvm+bounces-59079-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4825DBAB6BC
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 06:52:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CBFA41920AAD
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 04:52:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 794D7257452;
	Tue, 30 Sep 2025 04:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="I5Vw2k/K"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84E21288DB
	for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 04:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759207919; cv=none; b=McPCa1ExnsEkY2Cy9XEWfQoyrx8759LHUMs6RLAfZn2PThMuHDnyV/AOifbYReRJnKBP9KBDBZiq0R7PxULyjqZ19Ljv5s8N1Glk43yiV9k/tIifo5kEJTyCoj1JQp0DeXP+lXRRuQj1MEM3860hB3mnup2B5cxBofPT+b8tLhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759207919; c=relaxed/simple;
	bh=/ovqerkFdbDwqxLfXhYGldA6HL8RjFG3Tmm1PFTQTDc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mIrwO/lGyLGNJlLJvKjYQHyyJjqFACI58Kmpl9rGb5FwMnIJrrF7D0cTJokMFXiZ0VCk9mR8R4mi5zpOXm0/sn7IDlRvoWy/bK874PDljuWkBHK3gRiuoaaVkodl36yuacEvKqnsMiYbRmiR1i6FLDMtsCqsLBdjcs5nlxj3Yq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=I5Vw2k/K; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759207916;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=+Ec7IP8RaNea+ekLtnS8GreYVm0zDgRXajLAUnWqjpM=;
	b=I5Vw2k/KpSsfsff6NUNZXqrzwS+1/uL3FFGxIqOLY3SugyF7Vlj/LneuCS2QdTsIc0Azl4
	2lL8XN+K9aLZTJLFNiCynKFGhpMcyA+lhQDZPQMx/rE+DdqkjKeNBDVtajveg58a/k3N8z
	VMHgogsb6BvGGmzyNHcwnEQthyIeiy0=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-249-qAqzAyFmONCCEs9lV3oiYg-1; Tue, 30 Sep 2025 00:51:51 -0400
X-MC-Unique: qAqzAyFmONCCEs9lV3oiYg-1
X-Mimecast-MFC-AGG-ID: qAqzAyFmONCCEs9lV3oiYg_1759207910
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-634a73b5966so3801032a12.3
        for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 21:51:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759207910; x=1759812710;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+Ec7IP8RaNea+ekLtnS8GreYVm0zDgRXajLAUnWqjpM=;
        b=cDYxGoGyrZ/cMOZmMuifyEIGSo4Ays2TXvPuzbvc91Lv9opC6US2/HXx/Ur3xaQEsX
         PdXwB+E9osZ6Z8hRTL5qPwTRGYWCX5UAQTNxyrH99dyaMQP7pYZtCcWZu+wfw3bIChvH
         fAowwvapeN5y/lsnbtNR8QcY3Vv56Hnc3PpoY4a/xzu5ZtpOlQYZ86Z3rSI2CGUoW9Cm
         7UurkjTHjCOyruKh+SP/GqYie4BfNnZeBHvbnftvee1JvcVFw6wqzjYoTtRmGYEhW9tI
         Pn1VsQ5u4K498LiQk0EBbkWVc8E9WUqdZdb1c4XJRZIIMdKcYJrFGu8zuKeahEmpFrIh
         M48g==
X-Forwarded-Encrypted: i=1; AJvYcCUDNSxvJGj/wWogOWHNctjowb4eSi3/RxToYlpJQ3wp88PLKuGSLICy4jJ8mvFXbkET5UY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxmZtdlAQo/AlIXKUzcBAU7lRuAw/ABRgpEyu9972suh8bWnpVq
	zEzSfJww4XJ+ysJTL39rVGpWWFVUHjvsI60oQtEcBg25Dk/7CZP6GLsmY7I1rgEqpGWqzjYOJk1
	uRRO1VgZxxniHXu1sxALNUhHZnWvKzYaa85TzsYoFXawER2T9/BufhA==
X-Gm-Gg: ASbGncu/NduEGqwasfoqi311XvRy36w95W/4qgRrKwQ4uAZw/R+NSNb67aNSHYY+NeH
	kwBN/uOqS6K6fKZl/Rhg0hHR2OECAd9MHtcFeJkEW/SK9du/JtV3he5h9hEIr1JJL//ajAQ+vDF
	Hcqxb1KidfTdsBis/QPSy7CEImFDp+DI5q0+vExD36dVCpVFNCbkeaJU1zYaA52fkkeiAcoAiKZ
	aHLKMvGPEgcSp/2fLhUqc+7y5oDcRRUE/Lk7Vsz4iEaDGHpLJVwdVloXN7HY6oxG9farMoX5d3N
	vj1qcbFaD7lLcjoJWYiH77ki+vaO1Ky1nPVC6vHPEejCZF1/+qTEGzw3yWaH4d2BqbKY/gwepnX
	Ov4pJ0aXlhA==
X-Received: by 2002:a05:6402:26d3:b0:634:bff3:25d8 with SMTP id 4fb4d7f45d1cf-634bff32630mr11890008a12.30.1759207910158;
        Mon, 29 Sep 2025 21:51:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEiKyEPXuUeN9dycrzKBPNvTY+be/FSVas+XL6RlQgrJhdSMc3jVU2nKqcyK2u2Vo+ShPjxzw==
X-Received: by 2002:a05:6402:26d3:b0:634:bff3:25d8 with SMTP id 4fb4d7f45d1cf-634bff32630mr11889951a12.30.1759207909548;
        Mon, 29 Sep 2025 21:51:49 -0700 (PDT)
Received: from [192.168.0.7] (ltea-047-064-114-056.pools.arcor-ip.net. [47.64.114.56])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-634a3b02ccbsm8861868a12.45.2025.09.29.21.51.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Sep 2025 21:51:48 -0700 (PDT)
Message-ID: <22ff756a-51a2-43f4-8fe1-05f17ff4a371@redhat.com>
Date: Tue, 30 Sep 2025 06:51:46 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 02/17] system/memory: Better describe @plen argument of
 flatview_translate()
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org, Peter Maydell <peter.maydell@linaro.org>
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
 <20250930041326.6448-3-philmd@linaro.org>
From: Thomas Huth <thuth@redhat.com>
Content-Language: en-US
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20250930041326.6448-3-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 30/09/2025 06.13, Philippe Mathieu-Daudé wrote:
> flatview_translate()'s @plen argument is output-only and can be NULL.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>   include/system/memory.h | 5 +++--
>   system/physmem.c        | 6 +++---
>   2 files changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/include/system/memory.h b/include/system/memory.h
> index aa85fc27a10..3e5bf3ef05e 100644
> --- a/include/system/memory.h
> +++ b/include/system/memory.h
> @@ -2992,13 +2992,14 @@ IOMMUTLBEntry address_space_get_iotlb_entry(AddressSpace *as, hwaddr addr,
>    * @addr: address within that address space
>    * @xlat: pointer to address within the returned memory region section's
>    * #MemoryRegion.
> - * @len: pointer to length
> + * @plen_out: pointer to valid read/write length of the translated address.
> + *            It can be @NULL when we don't care about it.
>    * @is_write: indicates the transfer direction
>    * @attrs: memory attributes
>    */
>   MemoryRegion *flatview_translate(FlatView *fv,
>                                    hwaddr addr, hwaddr *xlat,
> -                                 hwaddr *len, bool is_write,
> +                                 hwaddr *plen_out, bool is_write,
>                                    MemTxAttrs attrs);
>   
>   static inline MemoryRegion *address_space_translate(AddressSpace *as,
> diff --git a/system/physmem.c b/system/physmem.c
> index 8a8be3a80e2..2d1697fce4c 100644
> --- a/system/physmem.c
> +++ b/system/physmem.c
> @@ -566,7 +566,7 @@ iotlb_fail:
>   
>   /* Called from RCU critical section */
>   MemoryRegion *flatview_translate(FlatView *fv, hwaddr addr, hwaddr *xlat,
> -                                 hwaddr *plen, bool is_write,
> +                                 hwaddr *plen_out, bool is_write,
>                                    MemTxAttrs attrs)
>   {
>       MemoryRegion *mr;
> @@ -574,13 +574,13 @@ MemoryRegion *flatview_translate(FlatView *fv, hwaddr addr, hwaddr *xlat,
>       AddressSpace *as = NULL;
>   
>       /* This can be MMIO, so setup MMIO bit. */
> -    section = flatview_do_translate(fv, addr, xlat, plen, NULL,
> +    section = flatview_do_translate(fv, addr, xlat, plen_out, NULL,
>                                       is_write, true, &as, attrs);
>       mr = section.mr;
>   
>       if (xen_enabled() && memory_access_is_direct(mr, is_write, attrs)) {
>           hwaddr page = ((addr & TARGET_PAGE_MASK) + TARGET_PAGE_SIZE) - addr;
> -        *plen = MIN(page, *plen);
> +        *plen_out = MIN(page, *plen_out);

There is no check for a NULL pointer here, so plen_out must *not* be NULL?
Or did I miss something?

  Thomas


>       }
>   
>       return mr;


