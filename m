Return-Path: <kvm+bounces-12475-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 229C5886803
	for <lists+kvm@lfdr.de>; Fri, 22 Mar 2024 09:13:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CC8CA287495
	for <lists+kvm@lfdr.de>; Fri, 22 Mar 2024 08:13:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 440EE171C7;
	Fri, 22 Mar 2024 08:13:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="N3imLe0Z"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7265510A19
	for <kvm@vger.kernel.org>; Fri, 22 Mar 2024 08:13:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711095191; cv=none; b=GabDxzBBf+MWxCLC/3uQ3Bt7EBcVIphbq6JW0n3R5Wu33t643buty81R64BiF+eBlsRkiwP+0vo/wUsFFTaAEvQZSIXvBUxChnXq3KUiNmlUcGuURcShGiGLrs+qYFXZrweVBJpPF/op0NrTwaUtaS9Uk4i9OnZ9x0n7wx3cXL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711095191; c=relaxed/simple;
	bh=ncfiTI7ran5GaKmZX0N1CXbIpkzQPf3m7yQLpgMjchE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SsdGqiRLgW9Ot+z2I/s2NHmC2t680ieT7D2rBV6OdfMZTn35oOvr3LaEjC/L7YFZErRldyrTmzp71vjg1CkxIAvisZ3jkvKFK/Pspm8UunK+Y0KKAJB86qB/djqorYiM0JoiWiT9ETIjeXOxfVZ1wUxvwjL0iHccFPD2x+9042w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=N3imLe0Z; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711095187;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=rpmxjaTCjxoIsCCXMbq2+up7JOpfzh0860bsclMJ83s=;
	b=N3imLe0ZiWRe6WALhoth2GgGl3zGxEdGpMCc5sxa5LX/Gc/cRydOI7h9bDsLqcDk+T7VeS
	BRYBTo4H80PCIP2LQ1rG+bHtHdRiNiqEoiDTFSGkaMGbYcNmqVRznTpPWmFqqi3NrGi254
	W9lRX8TIRJNEjG7MYYhms5sGLi55bN8=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-251-jMdh_sSqOyyxt6fYtihxZw-1; Fri, 22 Mar 2024 04:13:05 -0400
X-MC-Unique: jMdh_sSqOyyxt6fYtihxZw-1
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-513ec050f5cso1599914e87.1
        for <kvm@vger.kernel.org>; Fri, 22 Mar 2024 01:13:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711095184; x=1711699984;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rpmxjaTCjxoIsCCXMbq2+up7JOpfzh0860bsclMJ83s=;
        b=NwLXivkPUijhx8Lt1MyUZbogqkS2u0WM8/tGOJBrzGOJH3hTlTFzEsfXYSxzo5fiXT
         rlNhc9mb7JASJGOrVlU1CSmvpYh83JJEad/Og/JvKxu3GOqRsRGuNLO9hvFOAivraBQi
         JeNcRzHMPJZdnEKK1hrkZHWJGTi4HcWneUMQa1cATOFCoQrAx5L9h4/E7VpFfh/Q/k9q
         Uz4uoknhqrVCoNNhL8xfIs0nH/q9Nr43SuUqVXSLSre9/zzZkA1b0i2A+HxXGX3jDQws
         +sgUd92eWcXyGFCSElfoyoslIl53e935oiDt70rnlWLhLayg4H80vXyiyMKtN5Q7cP/G
         1Ucg==
X-Forwarded-Encrypted: i=1; AJvYcCV7h7ACXlTK52xMub9Xe23z1IqTKlBYA/HY2XddxCbOUkEjIBGmRABvM7mFIlcevboQH6nwtIDlELz4/U5lDRaUrvbY
X-Gm-Message-State: AOJu0YzD37n0Tmn2dBuGC4kgyLnc3yyez+n+9nUWtoOkLZa/5tGKwsN+
	vjKBrHoiI2FX0CEh6D1Pz6xjqiKXC5wnFAiIPRUzl8YJw8xfksY9mH+PqYsSsjQbN5AmOH/EUe7
	8V3Nun4Oac7L6nyQeOS6eZVV4CXLZ0d0DRn2GT2sRNEYUxA8gug==
X-Received: by 2002:a19:e015:0:b0:513:30fb:d64 with SMTP id x21-20020a19e015000000b0051330fb0d64mr1053469lfg.44.1711095184063;
        Fri, 22 Mar 2024 01:13:04 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEaC+Bgi2nO0/hb3M3dhIuH0sCkVl1vCfRGEuRY1W2Q3S1u2GOFD03sT3zoQopamY//RALkSw==
X-Received: by 2002:a19:e015:0:b0:513:30fb:d64 with SMTP id x21-20020a19e015000000b0051330fb0d64mr1053456lfg.44.1711095183583;
        Fri, 22 Mar 2024 01:13:03 -0700 (PDT)
Received: from [192.168.3.108] (p5b0c6e7f.dip0.t-ipconnect.de. [91.12.110.127])
        by smtp.gmail.com with ESMTPSA id dn1-20020a0560000c0100b0033ec7182673sm1481745wrb.52.2024.03.22.01.13.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Mar 2024 01:13:03 -0700 (PDT)
Message-ID: <17c1f86e-e6bf-4be0-88cd-c4afecb02310@redhat.com>
Date: Fri, 22 Mar 2024 09:13:02 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 1/2] mm/userfaultfd: don't place zeropages when
 zeropages are disallowed
To: Peter Xu <peterx@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, Heiko Carstens
 <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Andrea Arcangeli <aarcange@redhat.com>, kvm@vger.kernel.org,
 linux-s390@vger.kernel.org
References: <20240321215954.177730-1-david@redhat.com>
 <20240321215954.177730-2-david@redhat.com> <ZfyyodKYWtGki7MO@x1n>
 <48d1282c-e4db-4b55-ab3f-3344af2440c4@redhat.com> <Zfy4zhzWtyrHenlp@x1n>
Content-Language: en-US
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <Zfy4zhzWtyrHenlp@x1n>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 21.03.24 23:46, Peter Xu wrote:
> On Thu, Mar 21, 2024 at 11:29:45PM +0100, David Hildenbrand wrote:
>> On 21.03.24 23:20, Peter Xu wrote:
>>> On Thu, Mar 21, 2024 at 10:59:53PM +0100, David Hildenbrand wrote:
>>>> s390x must disable shared zeropages for processes running VMs, because
>>>> the VMs could end up making use of "storage keys" or protected
>>>> virtualization, which are incompatible with shared zeropages.
>>>>
>>>> Yet, with userfaultfd it is possible to insert shared zeropages into
>>>> such processes. Let's fallback to simply allocating a fresh zeroed
>>>> anonymous folio and insert that instead.
>>>>
>>>> mm_forbids_zeropage() was introduced in commit 593befa6ab74 ("mm: introduce
>>>> mm_forbids_zeropage function"), briefly before userfaultfd went
>>>> upstream.
>>>>
>>>> Note that we don't want to fail the UFFDIO_ZEROPAGE request like we do
>>>> for hugetlb, it would be rather unexpected. Further, we also
>>>> cannot really indicated "not supported" to user space ahead of time: it
>>>> could be that the MM disallows zeropages after userfaultfd was already
>>>> registered.
>>>>
>>>> Fixes: c1a4de99fada ("userfaultfd: mcopy_atomic|mfill_zeropage: UFFDIO_COPY|UFFDIO_ZEROPAGE preparation")
>>>> Signed-off-by: David Hildenbrand <david@redhat.com>
>>>
>>> Reviewed-by: Peter Xu <peterx@redhat.com>
>>>
>>> Still, a few comments below.
>>>
>>>> ---
>>>>    mm/userfaultfd.c | 35 +++++++++++++++++++++++++++++++++++
>>>>    1 file changed, 35 insertions(+)
>>>>
>>>> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
>>>> index 712160cd41eca..1d1061ccd1dea 100644
>>>> --- a/mm/userfaultfd.c
>>>> +++ b/mm/userfaultfd.c
>>>> @@ -316,6 +316,38 @@ static int mfill_atomic_pte_copy(pmd_t *dst_pmd,
>>>>    	goto out;
>>>>    }
>>>> +static int mfill_atomic_pte_zeroed_folio(pmd_t *dst_pmd,
>>>> +		 struct vm_area_struct *dst_vma, unsigned long dst_addr)
>>>> +{
>>>> +	struct folio *folio;
>>>> +	int ret;
>>>
>>> nitpick: we can set -ENOMEM here, then
>>>
>>>> +
>>>> +	folio = vma_alloc_zeroed_movable_folio(dst_vma, dst_addr);
>>>> +	if (!folio)
>>>> +		return -ENOMEM;
>>>
>>> return ret;
>>>
>>>> +
>>>> +	ret = -ENOMEM;
>>>
>>> drop.
>>
>> Sure!
>>
>>>
>>>> +	if (mem_cgroup_charge(folio, dst_vma->vm_mm, GFP_KERNEL))
>>>> +		goto out_put;
>>>> +
>>>> +	/*
>>>> +	 * The memory barrier inside __folio_mark_uptodate makes sure that
>>>> +	 * preceding stores to the page contents become visible before
>>>> +	 * the set_pte_at() write.
>>>> +	 */
>>>
>>> This comment doesn't apply.  We can drop it.
>>>
>>
>> I thought the same until I spotted that comment (where uffd originally
>> copied this from I strongly assume) in do_anonymous_page().
>>
>> "Preceding stores" here are: zeroing out the memory.
> 
> Ah.. that's okay then.
> 
> Considering that userfault used to be pretty cautious on such ordering, as
> its specialty to involve many user updates on the page, would you mind we
> mention those details out?
> 
> 	/*
> 	 * __folio_mark_uptodate contains the memory barrier to make sure
>           * the page updates to the zero page will be visible before
> 	 * installing the pgtable entries.  See do_anonymous_page().
> 	 */
> 
> Or anything better than my wordings.

Sure, I'd slightly reword it. The following on top:

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 1d1061ccd1dea..9d385696fb891 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -320,20 +320,19 @@ static int mfill_atomic_pte_zeroed_folio(pmd_t *dst_pmd,
  		 struct vm_area_struct *dst_vma, unsigned long dst_addr)
  {
  	struct folio *folio;
-	int ret;
+	int ret = -ENOMEM;
  
  	folio = vma_alloc_zeroed_movable_folio(dst_vma, dst_addr);
  	if (!folio)
-		return -ENOMEM;
+		return ret;
  
-	ret = -ENOMEM;
  	if (mem_cgroup_charge(folio, dst_vma->vm_mm, GFP_KERNEL))
  		goto out_put;
  
  	/*
  	 * The memory barrier inside __folio_mark_uptodate makes sure that
-	 * preceding stores to the page contents become visible before
-	 * the set_pte_at() write.
+	 * zeroing out the folio become visible before mapping the page
+	 * using set_pte_at(). See do_anonymous_page().
  	 */
  	__folio_mark_uptodate(folio);
  

Thanks!

-- 
Cheers,

David / dhildenb


