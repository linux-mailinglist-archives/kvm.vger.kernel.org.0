Return-Path: <kvm+bounces-14689-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D6F18A5A6D
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 21:14:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5FF5B1C2110A
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 19:14:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCFED156655;
	Mon, 15 Apr 2024 19:14:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ijNU2v8W"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E232F15623A
	for <kvm@vger.kernel.org>; Mon, 15 Apr 2024 19:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713208454; cv=none; b=DhKg/TTE0ls0U26T8nU/PYYqNWYp8KcuHnIF+J7y1IpiulxXpS9g9MwkPlS7c4+F1gi2fLu39C4016nc4+59RdLfbt1FjHqLPcmdTNaJNITN1cYgiHdo8YhIVyELXabf+aps6XMGcjS5nCKLe4dVUiP3BkwQxTYjB/M65XRYQyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713208454; c=relaxed/simple;
	bh=55Pl/vF5UQBIoZhpH0JLS80dLgybZ4QhMUjXOji3+XE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DuxqWuKmnNanvJ1kpueCWUMOmgvWNMPzECKjJwAgbzpdyL1pFpt+0hnI7U84sYFLC7L+1m/4vyvLEPzWp/VTzL7uN7RQGh8kmFlgffB9ov6M2P4bzPAkX6l7ZzhdSzo0zAGKCqTCxNBPWvNSYn1bXtgHgJezwvXkFKsYPfFb0jI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ijNU2v8W; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713208448;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=bMAt0oAbaTmcnLSElf/SBdLJ4dVXqKvD9eBFf4mhfOU=;
	b=ijNU2v8WO3YNshY+4sdhmDZjvS6pdvk6vksc/ODRc9nNYrsK4LSHT+/BeDcsoEjoC7IPRd
	7Iybx1Q3XeUqgJ70DwEczPJD2jd5wmthB98d3UavxGsUqeHns0itzRLpfBKq9/yU/vYHbn
	4ntNSSeJu2L7jv6ssIVKA+OsFinDm2s=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-365-bOmijMrlO6CugW9jYMKm8w-1; Mon, 15 Apr 2024 15:14:06 -0400
X-MC-Unique: bOmijMrlO6CugW9jYMKm8w-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4187fb76386so1990975e9.3
        for <kvm@vger.kernel.org>; Mon, 15 Apr 2024 12:14:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713208445; x=1713813245;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=bMAt0oAbaTmcnLSElf/SBdLJ4dVXqKvD9eBFf4mhfOU=;
        b=KvjZ67UshMCFllGn0yj0k86yyLRX4jqZnUqAUDYmHSHFTI1lAhJfmbXD58X1RHt+qS
         ldSFq6qQS2T3R72/J/CI3yGLfZqdrOeD49KDN3imjlLIryuMY9lfYpF0pI5/S08hS/pK
         ko28zIaVwGkbDU9C/i0ZPjZC9J4OvMgv1qGYtSJwWo42n9hs4BzOcmYHS+8DFctoCzfp
         8vNLGlCIALslSd3t0l++FmzBNEB95OTPQxAAr3LTMOSVZ6d6BrJLfxB0X/EwuriDOCIe
         /KV69U9HkVeZpMLDJ/xySQDLUxskz6D3f1pGSJBHnkoXohXaXZNFSPkEvvba06LbpaW7
         QUOQ==
X-Forwarded-Encrypted: i=1; AJvYcCVyr5f9gAfCVwhLe8R2uCAScqBA1biUlxnFlAPye0BwB3Pfwl348cpurWkDLZHS8F08jd78QMMy7Jggvzoo5VEilWl6
X-Gm-Message-State: AOJu0Yw7hC9/nK8XY94sCeCY/NOYCaYenVlgkEfqVZQ8nMxRiABvkeOL
	mjgXFvqyMNRdlR93lVq/q44Y0804rO7ZSnTwtqwbm18Sm9fpRvOWzR2EjO9r8khookFd5AlXUIw
	oSGzB4Pm8AS66kQrH675xUTi/dQnm1Db3tfwMe5XJn7EcxJX76g==
X-Received: by 2002:a05:600c:4ed4:b0:417:caa8:c3f4 with SMTP id g20-20020a05600c4ed400b00417caa8c3f4mr9281074wmq.34.1713208445563;
        Mon, 15 Apr 2024 12:14:05 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHNACX+5g4v7h9bZKcNb840TnSltslTev61FDz0PyU5OepqWDJ4QOJiQHGkHdSUyQUaUBHVTw==
X-Received: by 2002:a05:600c:4ed4:b0:417:caa8:c3f4 with SMTP id g20-20020a05600c4ed400b00417caa8c3f4mr9281051wmq.34.1713208445135;
        Mon, 15 Apr 2024 12:14:05 -0700 (PDT)
Received: from ?IPV6:2003:cb:c706:d800:568a:6ea7:5272:797c? (p200300cbc706d800568a6ea75272797c.dip0.t-ipconnect.de. [2003:cb:c706:d800:568a:6ea7:5272:797c])
        by smtp.gmail.com with ESMTPSA id s12-20020a05600c45cc00b00417e8be070csm15550664wmo.9.2024.04.15.12.14.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Apr 2024 12:14:04 -0700 (PDT)
Message-ID: <8533cb18-42ff-42bc-b9e5-b0537aa51b21@redhat.com>
Date: Mon, 15 Apr 2024 21:14:03 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/2] s390/mm: re-enable the shared zeropage for !PV and
 !skeys KVM guests
To: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, Heiko Carstens
 <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Andrew Morton <akpm@linux-foundation.org>, Peter Xu <peterx@redhat.com>,
 Sven Schnelle <svens@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Andrea Arcangeli <aarcange@redhat.com>, kvm@vger.kernel.org,
 linux-s390@vger.kernel.org
References: <20240411161441.910170-1-david@redhat.com>
 <20240411161441.910170-3-david@redhat.com>
 <Zh1w1QTNSy+rrCH7@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <Zh1w1QTNSy+rrCH7@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 15.04.24 20:24, Alexander Gordeev wrote:
> On Thu, Apr 11, 2024 at 06:14:41PM +0200, David Hildenbrand wrote:
> 
> David, could you please clarify the below questions?

Sure, let me take a look if we're still missing to handle some corner cases correctly.

> 
>> +static int __s390_unshare_zeropages(struct mm_struct *mm)
>> +{
>> +	struct vm_area_struct *vma;
>> +	VMA_ITERATOR(vmi, mm, 0);
>> +	unsigned long addr;
>> +	int rc;
>> +
>> +	for_each_vma(vmi, vma) {
>> +		/*
>> +		 * We could only look at COW mappings, but it's more future
>> +		 * proof to catch unexpected zeropages in other mappings and
>> +		 * fail.
>> +		 */
>> +		if ((vma->vm_flags & VM_PFNMAP) || is_vm_hugetlb_page(vma))
>> +			continue;
>> +		addr = vma->vm_start;
>> +
>> +retry:
>> +		rc = walk_page_range_vma(vma, addr, vma->vm_end,
>> +					 &find_zeropage_ops, &addr);
>> +		if (rc <= 0)
>> +			continue;
> 
> So in case an error is returned for the last vma, __s390_unshare_zeropage()
> finishes with that error. By contrast, the error for a non-last vma would
> be ignored?

Right, it looks a bit off. walk_page_range_vma() shouldn't fail
unless find_zeropage_pte_entry() would fail -- which would also be
very unexpected.

To handle it cleanly in case we would ever get a weird zeropage where we
don't expect it, we should probably just exit early.

Something like the following (not compiled, addressing the comment below):


 From b97cd17a3697ac402b07fe8d0033f3c10fbd6829 Mon Sep 17 00:00:00 2001
From: David Hildenbrand <david@redhat.com>
Date: Mon, 15 Apr 2024 20:56:20 +0200
Subject: [PATCH] fixup

Signed-off-by: David Hildenbrand <david@redhat.com>
---
  arch/s390/mm/gmap.c | 13 ++++++++-----
  1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
index 9233b0acac89..3e3322a9cc32 100644
--- a/arch/s390/mm/gmap.c
+++ b/arch/s390/mm/gmap.c
@@ -2618,7 +2618,8 @@ static int __s390_unshare_zeropages(struct mm_struct *mm)
  	struct vm_area_struct *vma;
  	VMA_ITERATOR(vmi, mm, 0);
  	unsigned long addr;
-	int rc;
+	vm_fault_t rc;
+	int zero_page;
  
  	for_each_vma(vmi, vma) {
  		/*
@@ -2631,9 +2632,11 @@ static int __s390_unshare_zeropages(struct mm_struct *mm)
  		addr = vma->vm_start;
  
  retry:
-		rc = walk_page_range_vma(vma, addr, vma->vm_end,
-					 &find_zeropage_ops, &addr);
-		if (rc <= 0)
+		zero_page = walk_page_range_vma(vma, addr, vma->vm_end,
+						&find_zeropage_ops, &addr);
+		if (zero_page < 0)
+			return zero_page;
+		else if (!zero_page)
  			continue;
  
  		/* addr was updated by find_zeropage_pte_entry() */
@@ -2656,7 +2659,7 @@ static int __s390_unshare_zeropages(struct mm_struct *mm)
  		goto retry;
  	}
  
-	return rc;
+	return 0;
  }
  
  static int __s390_disable_cow_sharing(struct mm_struct *mm)
-- 
2.44.0



> 
>> +
>> +		/* addr was updated by find_zeropage_pte_entry() */
>> +		rc = handle_mm_fault(vma, addr,
>> +				     FAULT_FLAG_UNSHARE | FAULT_FLAG_REMOTE,
>> +				     NULL);
>> +		if (rc & VM_FAULT_OOM)
>> +			return -ENOMEM;
> 
> Heiko pointed out that rc type is inconsistent vs vm_fault_t returned by

Right, let's use another variable for that.

> handle_mm_fault(). While fixing it up, I've got concerned whether is it
> fine to continue in case any other error is met (including possible future
> VM_FAULT_xxxx)?

Such future changes would similarly break break_ksm(). Staring at it, I do wonder
if break_ksm() should be handling VM_FAULT_HWPOISON ... very likely we should
handle it and fail -- we might get an MC while copying from the source page.

VM_FAULT_HWPOISON on the shared zeropage would imply a lot of trouble, so
I'm not concerned about that for the case here, but handling it in the future
would be cleaner.

Note that we always retry the lookup, so we won't just skip a zeropage on unexpected
errors.

We could piggy-back on vm_fault_to_errno(). We could use
vm_fault_to_errno(rc, FOLL_HWPOISON), and only continue (retry) if the rc is 0 or
-EFAULT, otherwise fail with the returned error.

But I'd do that as a follow up, and also use it in break_ksm() in the same fashion.

-- 
Cheers,

David / dhildenb


