Return-Path: <kvm+bounces-60491-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 21B9FBF000F
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 10:41:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 91F4934A667
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 08:41:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21C6D2ECE86;
	Mon, 20 Oct 2025 08:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DqB4ZAUz"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A75632EA753
	for <kvm@vger.kernel.org>; Mon, 20 Oct 2025 08:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760949697; cv=none; b=uH0UrSon5i4UaoGOJhgDzl1akEpEhOGGfAcqhmeka8f45k9KLMPSN2+KGUjjhXN/lAlgA+W/8gnYUhu5VM4WwzPbvp0CYliBCsFU6hdkPIDIaHlaPwmZkHn2sSGieuDcMNCvDohxGVmCA+hPLR9tUjqe87/Z5/tXmGXYD3sKvhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760949697; c=relaxed/simple;
	bh=KbLQf/uHDeEXSEWt2j3Ytlw5GBbCU0nBFFcJGs3sOFM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DAEn0o4q+b0iSwpBZng+AqYoDvcK8Lx5/p+bgnJ2qIpt4MtQv+vSs7xr3f+9SnUWDHCS2zg8/XV6qLf6mzZ5EugBYaiswtCnfWI/YLWZ++dFlVm/vFAFgrigAn+Kp1Ry9AcmC+E8oqxLWH5ydFXLlIEEYDZtc0zIm94Oi3hFl2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DqB4ZAUz; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760949694;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=3U5rH6VCQJeyIqlNEvg4+9+sRmixO07jGft8Tq1QypM=;
	b=DqB4ZAUzzfe97S2voLjy1yuSsrZYNOeGk+/yw8t4o3zVRW5E1d124xjIwB3mIMz2b8PUTm
	ktu+vJBauKudo4au/KxfgsAYfoybXwwL9CHWPZ36+jrnnh9otY9q6IwcTn86AOjolUa8Vr
	88SIbtTYWe60x8X6ATw6VYJLtlHnv30=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-321-sxmBdhbCO_yKHyySxXWxgw-1; Mon, 20 Oct 2025 04:41:32 -0400
X-MC-Unique: sxmBdhbCO_yKHyySxXWxgw-1
X-Mimecast-MFC-AGG-ID: sxmBdhbCO_yKHyySxXWxgw_1760949692
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-46e4cb3e4deso14337175e9.1
        for <kvm@vger.kernel.org>; Mon, 20 Oct 2025 01:41:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760949692; x=1761554492;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3U5rH6VCQJeyIqlNEvg4+9+sRmixO07jGft8Tq1QypM=;
        b=swE3VTB96iJbpdWAolV4NPjExNn657d0cQRwltM+64xBCSPXIgPVcrsb1Vf9GxOV9g
         4cTevcEV+IZlWjwtHbl0+4X4Ory860nvafA2m52TrXWInTbRM91uhN4FKx1QSsZuOWGU
         8mnVeva7wb9fuXpt4P1PNTUVwrpaC4Ne5Kb7xoSBkpaQIzobRhMj/bgW3Xxz0vBcWRdA
         uSQsrb9YLUO4xNZF9moPg+ExbLBs2vw5OBi9tNLMK+Qe7VspDj3NiFEuCA7M5w9RHUwK
         D0H6ISQalP2HMDFoYe/D7LPKaFZaEzRX+eCvrXqinheNvgJZ89uvbnbKs9m7QOeOmE1H
         np3g==
X-Forwarded-Encrypted: i=1; AJvYcCUDxBNXgug0Jq9ZWnS3weHy/xThSjlIlzsbtb4TL7bHDONhZ8q9y0xDxyuamfOTtsNF8Lk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzc9mmfdD9nF07/nB/DcrqX0eI7EUgM2SNALJQ3v9Y4nUIn6j6w
	YC1yvz1flKyHwsWE52+wSMFwOZXZKQKmgKPv75dwbRTxg7nBxGnIqTA0R1hZrufZMJ1C+d/NC72
	WIYB4k6a2eSwpOFRDexOfzKmloQnxoY6mlH4nCaRzg8MNSJ8HFu61+g==
X-Gm-Gg: ASbGncuhdFauAJLYCXc+AnxixjwAV7cS0Bwcfb70sgcSfXh0B4CmO9t5eaGVAJ9A0pz
	YDPlB4TtKvlejdxXx/drcRxVWJ0JSoqPTXz1Sd0nXPMtyzR0wD78jBXzTevRnCpPRBhW736SpN2
	jwx+eSTk3EVtdNKuy+1/sjcxworZeguMSomsMtOkciKShEz0NUUOHLQFQA3stPDB8VWh6h3Z0G/
	s3MwlfCvMtkfkwW+84H5v7xNhc1Jzg5eXxvZimFhT5PRjmusR5CkYTmbzKupdO0XZOlCDjPEJJl
	tfuft5fisIYyT5GiBrFza32wm774OIH4M6981vXQ8N0xllccSLPIJeD3mtsD5cbPHeC1c9H2TMg
	qBT9mPJw2nDwqCScDwlhalZU7n1otDNbHFTKPk7g+rOFOM16fRbfa65fv7gaT1BHmOmNGRR5+XM
	sMFZyUWrWKhyAXj59+bXe+m+D2JEQ=
X-Received: by 2002:a05:6000:41f7:b0:427:548:6e3b with SMTP id ffacd0b85a97d-42705486e44mr9085837f8f.13.1760949691740;
        Mon, 20 Oct 2025 01:41:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGGtvbw0Lrl9i4z+HwCLH5RJB7pExiJlS7u8wTdbjX445/94A4mdOgKmXGH4NxxYxpJbuMvIw==
X-Received: by 2002:a05:6000:41f7:b0:427:548:6e3b with SMTP id ffacd0b85a97d-42705486e44mr9085800f8f.13.1760949691255;
        Mon, 20 Oct 2025 01:41:31 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce? (p200300d82f0cc200fa4ac4ff1b3221ce.dip0.t-ipconnect.de. [2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-427f00b985esm14635943f8f.34.2025.10.20.01.41.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Oct 2025 01:41:30 -0700 (PDT)
Message-ID: <748cdc18-e32d-41bd-90d1-a102b1c51e06@redhat.com>
Date: Mon, 20 Oct 2025 10:41:28 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: linux-next: KVM/s390x regression
To: Christian Borntraeger <borntraeger@linux.ibm.com>,
 Balbir Singh <balbirs@nvidia.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Liam.Howlett@oracle.com, airlied@gmail.com, akpm@linux-foundation.org,
 apopple@nvidia.com, baohua@kernel.org, baolin.wang@linux.alibaba.com,
 byungchul@sk.com, dakr@kernel.org, dev.jain@arm.com,
 dri-devel@lists.freedesktop.org, francois.dugast@intel.com,
 gourry@gourry.net, joshua.hahnjy@gmail.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, lorenzo.stoakes@oracle.com, lyude@redhat.com,
 matthew.brost@intel.com, mpenttil@redhat.com, npache@redhat.com,
 osalvador@suse.de, rakie.kim@sk.com, rcampbell@nvidia.com,
 ryan.roberts@arm.com, simona@ffwll.ch, ying.huang@linux.alibaba.com,
 ziy@nvidia.com, kvm@vger.kernel.org, linux-s390@vger.kernel.org,
 linux-next@vger.kernel.org
References: <20251001065707.920170-4-balbirs@nvidia.com>
 <20251017144924.10034-1-borntraeger@linux.ibm.com>
 <9beff9d6-47c7-4a65-b320-43efd1e12687@redhat.com>
 <c67386be-5278-411d-97e7-43fc34bf7c98@linux.ibm.com>
 <8c778cd0-5608-4852-9840-4d98828d7b33@redhat.com>
 <74272098-cfb7-424b-a55e-55e94f04524e@linux.ibm.com>
 <84349344-b127-41f6-99f1-10f907c2bd07@redhat.com>
 <c9f28d0c-6b06-47a2-884d-7533f7b49c45@nvidia.com>
 <f5debf87-0477-4d6a-8280-0cd95cd09412@linux.ibm.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <f5debf87-0477-4d6a-8280-0cd95cd09412@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 20.10.25 09:00, Christian Borntraeger wrote:
> Am 17.10.25 um 23:56 schrieb Balbir Singh:
> 
>> In the meanwhile, does this fix/workaround work?
>>
>> diff --git a/mm/pgtable-generic.c b/mm/pgtable-generic.c
>> index 0c847cdf4fd3..31c1754d5bd4 100644
>> --- a/mm/pgtable-generic.c
>> +++ b/mm/pgtable-generic.c
>> @@ -290,7 +290,7 @@ pte_t *___pte_offset_map(pmd_t *pmd, unsigned long addr, pmd_t *pmdvalp)
>>    
>>    	if (pmdvalp)
>>    		*pmdvalp = pmdval;
>> -	if (unlikely(pmd_none(pmdval) || !pmd_present(pmdval)))
>> +	if (unlikely(pmd_none(pmdval) || is_pmd_non_present_folio_entry(pmdval)))
>>    		goto nomap;
>>    	if (unlikely(pmd_trans_huge(pmdval)))
>>    		goto nomap;
>>
> 
> Yes, this seems to work.

Right, but that's not what we will want here. We'll have to adjust s390x 
gmap code (which is getting redesigned either way) to only take the page 
lock.

In the end, we'll want here later a single

if (!pmd_present(pmdval))
	goto nomap;

-- 
Cheers

David / dhildenb


