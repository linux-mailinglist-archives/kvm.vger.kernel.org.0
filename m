Return-Path: <kvm+bounces-38099-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D630A34F6A
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2025 21:34:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8E7C4188FF2C
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2025 20:34:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF44424BC1D;
	Thu, 13 Feb 2025 20:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RlilsrJ3"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50A82155326
	for <kvm@vger.kernel.org>; Thu, 13 Feb 2025 20:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739478847; cv=none; b=clNeY7Tf6w1C3VBoHaTCEBrj067xBvhfZrFUzW33y+6o2PFhEZIXZpBY+nsVMfKCG3eUmXC7Mr5zyrF0RD7vCqPUNVragYqBIh45iQGlKWIhZZ7QWyB3vLmHpDhZBBWDgNcBiA8vVp70LW2NK0iQittlPLNnIzGsEzFmBuNl2ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739478847; c=relaxed/simple;
	bh=+PbppRTxU+MRaSpBLpJRBAel6afWqJFUI37ki0hIVp0=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=f14/Ee1XxaIt9vyEeAsz02MJBBDjnQ9t6o5Kr0y6Yke6wKZ/fkI+DcAqnIys0iyVNLcL+5c0PHhdN++4Uy+Mxc/g0xS7JkQRFX2hgJDDejxUNWOy6mslveDWQUb/GuDhKIpwYUKL7o8e5NDJOD6NJFeG2XwAm9u7NpXyoPLY4QU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RlilsrJ3; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739478844;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Owelm3gwpVKruhUqbHcegjaA+IycUGkEQKc9gqgnzTs=;
	b=RlilsrJ3pwNXrcUuAKwQS8GW4DCMcytqAeH7wKRpWRJHsobygzYnUnVajfeUzJl02NDjKW
	p02occxmFPHZlinm4jewu6kSoNClZQFX+g6o3x1RNryAhC06njHNGTONoP/WxFMRUBvX1w
	MJhfEKGet/sANs6UamUftxrtEjHYDic=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-56-TdUyufQFP7qxHHIXEkx6cw-1; Thu, 13 Feb 2025 15:34:03 -0500
X-MC-Unique: TdUyufQFP7qxHHIXEkx6cw-1
X-Mimecast-MFC-AGG-ID: TdUyufQFP7qxHHIXEkx6cw_1739478842
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4394040fea1so7767605e9.0
        for <kvm@vger.kernel.org>; Thu, 13 Feb 2025 12:34:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739478842; x=1740083642;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:references:cc:to:from:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Owelm3gwpVKruhUqbHcegjaA+IycUGkEQKc9gqgnzTs=;
        b=tQ0gG1RBYa118nHBIcWOshFvgr+1i9d2UIMR3ln2UC575/ikahtYgBf1uTSUaWgE9t
         FWATjW+//wb4bsGJegnPuHJc/1bgK5H//MJhL2sDWE7er5nrb94lrh7EdjMQZbrx3mj6
         sSC5RDz2ZVVjZRG/WJZgsHSais3Fl7jJLoBhGOM6VGBnIGY9YYORkdM+/1y4hmI2qJsD
         E2ztgMGGrBYIH/4gVFc97ft+oD+JM7VQpHAxZq2QbS9TfRbkQ8vt6MNO8zmxhdsNfxJc
         KNqs5b2ErARqfGgXwnKhaXbcunjQDi0CZWnsYAQAJgsWAnwRZPqOEyWmDAfRfYk6CHVO
         fyEg==
X-Forwarded-Encrypted: i=1; AJvYcCXPC/2+LAY0vqC3KZRZGFSmZSG9nRXiOmX6Dto+qaf2HsrkKxMUDl+TaiElMqTDgftwAko=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw1GipVxOa/LOassICM/5WiHsRpNkQDgOS3hQ9O1KYh+L6WnDLI
	/wNefnsoldl6Hzho2noHX+XlwsP7ouuSbfrTBomHcAgKRHoQrw+ylzrwR8I51L3xTT0XtiPyJ0w
	7hg7INKrN25JfEgE1/J+eh1gLDgk3y1+G3OQSk5JUGEXjGSqjvw==
X-Gm-Gg: ASbGncuNtgzku6hKrrBLmlmFTcf7HRFFj/KDxfDnzfQYATQR8Qg5miXvTP/1jYWOi3w
	2lLRMZYfccmFgD2/r39ibCD5WZqThF6oJss10lNWIAfcF86SX7lQuMZbU0dlGiIRu14NJXq2J9C
	nTLCV0OzvOcukPQxDJYLPgySUuCbV6ktGevYyaAETjsY/eol8PuIDCTJPlAQWAATPn3UIQVSGna
	NXTaD/Mn4dZ01fi/wC7sr0eAgfn8SkRlAhi5E1Aw4lBCF4kYfgBZtZ1JJ5hn6avVKRVEXOqNy1f
	emdRUM3WXkfEPS1Ia4kfuAw6jhgZFN+AcIgi/MCs4gyRYiST6VOtToPAgJPwBqvoR+2+3njTK1o
	KEW0SdUCYN5W5/7lPJmB27ml3h1rwFw==
X-Received: by 2002:a05:600c:1d88:b0:439:5f04:4f8d with SMTP id 5b1f17b1804b1-43960eaed47mr48329715e9.12.1739478841751;
        Thu, 13 Feb 2025 12:34:01 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGFJReXEONDTrhQHonsIaBbRJxOTK06ZyxnB2XY054b28v3hwUCDeAubUJizNBjk30aJJZnSg==
X-Received: by 2002:a05:600c:1d88:b0:439:5f04:4f8d with SMTP id 5b1f17b1804b1-43960eaed47mr48329455e9.12.1739478841410;
        Thu, 13 Feb 2025 12:34:01 -0800 (PST)
Received: from ?IPV6:2003:cb:c718:100:347d:db94:161d:398f? (p200300cbc7180100347ddb94161d398f.dip0.t-ipconnect.de. [2003:cb:c718:100:347d:db94:161d:398f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4396180f199sm26455445e9.15.2025.02.13.12.33.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Feb 2025 12:34:00 -0800 (PST)
Message-ID: <570b2f04-0c46-4a40-9b59-b9db1b5b6185@redhat.com>
Date: Thu, 13 Feb 2025 21:33:58 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 2/2] KVM: s390: pv: fix race when making a page secure
From: David Hildenbrand <david@redhat.com>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
 frankja@linux.ibm.com, borntraeger@de.ibm.com, nrb@linux.ibm.com,
 seiden@linux.ibm.com, nsg@linux.ibm.com, schlameuss@linux.ibm.com,
 hca@linux.ibm.com
References: <20250213200755.196832-1-imbrenda@linux.ibm.com>
 <20250213200755.196832-3-imbrenda@linux.ibm.com>
 <6c741da9-a793-4a59-920f-8df77807bc4d@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <6c741da9-a793-4a59-920f-8df77807bc4d@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 13.02.25 21:16, David Hildenbrand wrote:
> On 13.02.25 21:07, Claudio Imbrenda wrote:
>> Holding the pte lock for the page that is being converted to secure is
>> needed to avoid races. A previous commit removed the locking, which
>> caused issues. Fix by locking the pte again.
>>
>> Fixes: 5cbe24350b7d ("KVM: s390: move pv gmap functions into kvm")
> 
> If you found this because of my report about the changed locking,
> consider adding a Suggested-by / Reported-y.
> 
>> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
>> ---
>>    arch/s390/include/asm/uv.h |  2 +-
>>    arch/s390/kernel/uv.c      | 19 +++++++++++++++++--
>>    arch/s390/kvm/gmap.c       | 12 ++++++++----
>>    3 files changed, 26 insertions(+), 7 deletions(-)
>>
>> diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
>> index b11f5b6d0bd1..46fb0ef6f984 100644
>> --- a/arch/s390/include/asm/uv.h
>> +++ b/arch/s390/include/asm/uv.h
>> @@ -631,7 +631,7 @@ int uv_pin_shared(unsigned long paddr);
>>    int uv_destroy_folio(struct folio *folio);
>>    int uv_destroy_pte(pte_t pte);
>>    int uv_convert_from_secure_pte(pte_t pte);
>> -int make_folio_secure(struct folio *folio, struct uv_cb_header *uvcb);
>> +int make_hva_secure(struct mm_struct *mm, unsigned long hva, struct uv_cb_header *uvcb);
>>    int uv_convert_from_secure(unsigned long paddr);
>>    int uv_convert_from_secure_folio(struct folio *folio);
>>    
>> diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
>> index 9f05df2da2f7..de3c092da7b9 100644
>> --- a/arch/s390/kernel/uv.c
>> +++ b/arch/s390/kernel/uv.c
>> @@ -245,7 +245,7 @@ static int expected_folio_refs(struct folio *folio)
>>     * Context: The caller must hold exactly one extra reference on the folio
>>     *          (it's the same logic as split_folio())
>>     */
>> -int make_folio_secure(struct folio *folio, struct uv_cb_header *uvcb)
>> +static int __make_folio_secure(struct folio *folio, unsigned long hva, struct uv_cb_header *uvcb)
>>    {
>>    	int expected, cc = 0;
>>    
>> @@ -277,7 +277,22 @@ int make_folio_secure(struct folio *folio, struct uv_cb_header *uvcb)
>>    		return -EAGAIN;
>>    	return uvcb->rc == 0x10a ? -ENXIO : -EINVAL;
>>    }
>> -EXPORT_SYMBOL_GPL(make_folio_secure);
>> +
>> +int make_hva_secure(struct mm_struct *mm, unsigned long hva, struct uv_cb_header *uvcb)
>> +{
>> +	spinlock_t *ptelock;
>> +	pte_t *ptep;
>> +	int rc;
>> +
>> +	ptep = get_locked_pte(mm, hva, &ptelock);
>> +	if (!ptep)
>> +		return -ENXIO;
>> +	rc = __make_folio_secure(page_folio(pte_page(*ptep)), hva, uvcb);
>> +	pte_unmap_unlock(ptep, ptelock);
>> +
>> +	return rc;
>> +}
>> +EXPORT_SYMBOL_GPL(make_hva_secure);
>>    
>>    /*
>>     * To be called with the folio locked or with an extra reference! This will
>> diff --git a/arch/s390/kvm/gmap.c b/arch/s390/kvm/gmap.c
>> index fc4d490d25a2..e56c0ab5fec7 100644
>> --- a/arch/s390/kvm/gmap.c
>> +++ b/arch/s390/kvm/gmap.c
>> @@ -55,7 +55,7 @@ static bool should_export_before_import(struct uv_cb_header *uvcb, struct mm_str
>>    	return atomic_read(&mm->context.protected_count) > 1;
>>    }
>>    
>> -static int __gmap_make_secure(struct gmap *gmap, struct page *page, void *uvcb)
>> +static int __gmap_make_secure(struct gmap *gmap, struct page *page, unsigned long hva, void *uvcb)
>>    {
>>    	struct folio *folio = page_folio(page);
>>    	int rc;
>> @@ -83,7 +83,7 @@ static int __gmap_make_secure(struct gmap *gmap, struct page *page, void *uvcb)
>>    		return -EAGAIN;
>>    	if (should_export_before_import(uvcb, gmap->mm))
>>    		uv_convert_from_secure(folio_to_phys(folio));
>> -	rc = make_folio_secure(folio, uvcb);
>> +	rc = make_hva_secure(gmap->mm, hva, uvcb);
>>    	folio_unlock(folio);
>>    
>>    	/*
>> @@ -120,6 +120,7 @@ static int __gmap_make_secure(struct gmap *gmap, struct page *page, void *uvcb)
>>    int gmap_make_secure(struct gmap *gmap, unsigned long gaddr, void *uvcb)
>>    {
>>    	struct kvm *kvm = gmap->private;
>> +	unsigned long vmaddr;
>>    	struct page *page;
>>    	int rc = 0;
>>    
>> @@ -127,8 +128,11 @@ int gmap_make_secure(struct gmap *gmap, unsigned long gaddr, void *uvcb)
>>    
>>    	page = gfn_to_page(kvm, gpa_to_gfn(gaddr));
>>    	mmap_read_lock(gmap->mm);
>> -	if (page)
>> -		rc = __gmap_make_secure(gmap, page, uvcb);
>> +	vmaddr = gfn_to_hva(gmap->private, gpa_to_gfn(gaddr));
>> +	if (kvm_is_error_hva(vmaddr))
>> +		rc = -ENXIO;
>> +	if (!rc && page)
>> +		rc = __gmap_make_secure(gmap, page, vmaddr, uvcb);
>>    	kvm_release_page_clean(page);
>>    	mmap_read_unlock(gmap->mm);
>>    
> 
> You effectively make the code more complicated and inefficient than
> before. Now you effectively walk the page table twice in the common
> small-folio case ...
> 
> Can we just go back to the old handling that we had before here?

I'll note that there is still the possibility for a different race: 
nothing guarantees that the page you looked up using gfn_to_hva() will 
still be mapped when you perform the get_locked_pte(). Not sure what 
would happen if we would have a different page mapped.

You could re-verify it is still there, but then, doing two page table 
walks is still more than required in the common case where we can just 
perform the conversion.

-- 
Cheers,

David / dhildenb


