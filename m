Return-Path: <kvm+bounces-25404-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B1BBC96502B
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 21:54:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 63A8528A07E
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 19:54:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0B4E1BAEFA;
	Thu, 29 Aug 2024 19:44:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FZ5A9q+i"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AD121BAED3
	for <kvm@vger.kernel.org>; Thu, 29 Aug 2024 19:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724960649; cv=none; b=oBAog3xN89+3R8lwER59KCb6Er80aZ93R8QpI/Ps7uNm6lj1PSHsIUof+tRJ4umnymRKs3lFibvrLHivLDk85O1+o76OMCLp+/MvC1KCaOa+bou9LgiCmK9yMIwEeuc9oesgvfQ8tkGckT9GDLht0T9lncPyb4NP+30jhGszcBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724960649; c=relaxed/simple;
	bh=bXjJdHgoJ/gf8p/nQ0iqm1gd55gvbLyJ9mhQp0JSHqs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Z2RV/0xtc6xGmq6vToL4JNDIGu8Sr0cqv2G5QYaEx+0gyuH322+yEs5qXFkrAaDCuo9F/0FRf5L+7fRIonIvZ3Mud/D6Ha+8a11+0ahX+Pnj5tzM1fGdaPozdehFK1JcjJM4GcyYTOhfeH20gFAX49qoLHVkoihIfXyxe9qOEfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FZ5A9q+i; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724960647;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=7gxUzp50O1mInc9XDA/L9eFmSo7JrCc7dhrGNNIpXkg=;
	b=FZ5A9q+iDz13t+hE9XaYcrxGAdYIVKCkM81I2ds4FW8r4TSoQ5Km8mC+Qymn5cC3yEpvKc
	sjdxU2aHC6eCryENHW6R9Zz1fRCb8he4h656QHRJZNTcyCYxKbEjWVTzb2cLgrGjTU9bhI
	0E8zjWA3G3SsZUApEAwNpgLIgg+U5YQ=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-639-uAOqpLMROl-in11c9XeptQ-1; Thu, 29 Aug 2024 15:44:05 -0400
X-MC-Unique: uAOqpLMROl-in11c9XeptQ-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-37187b43662so670925f8f.0
        for <kvm@vger.kernel.org>; Thu, 29 Aug 2024 12:44:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724960644; x=1725565444;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=7gxUzp50O1mInc9XDA/L9eFmSo7JrCc7dhrGNNIpXkg=;
        b=xCR6HSy+4Af68Uq01/5nLGzfiztmfFWgmZblsmWtLA44OuP/VW9RtmvZLKz9pursYs
         fBKTWGRUElRx5OlEmaRXuUSSIxRjgpBETlCu8BxU96FIBj6ofgmfPM9JT3DDBPln+i/7
         AIiUGClASDCe35Eh2qmMBSpRRXU4fLeXxSiTWTbGrf0QK3TFeIJWUvSppq1JGwGmNup8
         MtbdqUE0ESjYHyQRVFiwbbQKgv7bf4sFHE1MtKsUcMBfN6UGyIncsR6MmhgHoapta0KB
         00OYqULKYY0eNRjBxjzdYGDiNlz0l0oUlJItdl6z4Umeeucmuj6jnkCGQjnubcAdNISl
         tMSw==
X-Forwarded-Encrypted: i=1; AJvYcCXBdQ2bNwLTNtVblvd75kIxB+tVbn48vyVE/4ihXU12PC0Fx9TVWhkbvtcZgi8CtQyyFRw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxVRvpJ4pc0dBDNzxSyi57GNnrnRvENXpk6yZXbA/1/Dza7yj4+
	Qd2H0kakZKAIUD4ct5VuCEvDsLU6oASjzRKPSFC9Ho0588FUgWs9gTKU+zXWL2gvIO9PRXe6hFc
	bSNk5w3X5LiVusB7ybsI3UpvUqgXQRAAiskYLURcEIC8RL3Dang==
X-Received: by 2002:a5d:5848:0:b0:371:7db6:89df with SMTP id ffacd0b85a97d-3749b54d0d3mr3240256f8f.31.1724960644323;
        Thu, 29 Aug 2024 12:44:04 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHj7wSmf+BALvcj9Vavd2cBipEI9aWDfaheAlF4lOQP8quj0z4TYnx8DzRdYpBH8QjiC7U7iA==
X-Received: by 2002:a5d:5848:0:b0:371:7db6:89df with SMTP id ffacd0b85a97d-3749b54d0d3mr3240226f8f.31.1724960643488;
        Thu, 29 Aug 2024 12:44:03 -0700 (PDT)
Received: from ?IPV6:2003:cb:c711:c600:c1d6:7158:f946:f083? (p200300cbc711c600c1d67158f946f083.dip0.t-ipconnect.de. [2003:cb:c711:c600:c1d6:7158:f946:f083])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42bacaac810sm44098825e9.33.2024.08.29.12.44.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Aug 2024 12:44:02 -0700 (PDT)
Message-ID: <32a451ee-6836-4d4d-814c-752c15415aae@redhat.com>
Date: Thu, 29 Aug 2024 21:44:01 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 07/19] mm/fork: Accept huge pfnmap entries
To: Peter Xu <peterx@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Gavin Shan <gshan@redhat.com>, Catalin Marinas <catalin.marinas@arm.com>,
 x86@kernel.org, Ingo Molnar <mingo@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Thomas Gleixner <tglx@linutronix.de>, Alistair Popple <apopple@nvidia.com>,
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Sean Christopherson <seanjc@google.com>, Oscar Salvador <osalvador@suse.de>,
 Jason Gunthorpe <jgg@nvidia.com>, Borislav Petkov <bp@alien8.de>,
 Zi Yan <ziy@nvidia.com>, Axel Rasmussen <axelrasmussen@google.com>,
 Yan Zhao <yan.y.zhao@intel.com>, Will Deacon <will@kernel.org>,
 Kefeng Wang <wangkefeng.wang@huawei.com>,
 Alex Williamson <alex.williamson@redhat.com>
References: <20240826204353.2228736-1-peterx@redhat.com>
 <20240826204353.2228736-8-peterx@redhat.com>
 <78d77162-11df-4437-b70b-fa04f868a494@redhat.com> <ZtC9ThIs7aSK7gdK@x1n>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <ZtC9ThIs7aSK7gdK@x1n>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 29.08.24 20:26, Peter Xu wrote:
> On Thu, Aug 29, 2024 at 05:10:42PM +0200, David Hildenbrand wrote:
>> On 26.08.24 22:43, Peter Xu wrote:
>>> Teach the fork code to properly copy pfnmaps for pmd/pud levels.  Pud is
>>> much easier, the write bit needs to be persisted though for writable and
>>> shared pud mappings like PFNMAP ones, otherwise a follow up write in either
>>> parent or child process will trigger a write fault.
>>>
>>> Do the same for pmd level.
>>>
>>> Signed-off-by: Peter Xu <peterx@redhat.com>
>>> ---
>>>    mm/huge_memory.c | 29 ++++++++++++++++++++++++++---
>>>    1 file changed, 26 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>> index e2c314f631f3..15418ffdd377 100644
>>> --- a/mm/huge_memory.c
>>> +++ b/mm/huge_memory.c
>>> @@ -1559,6 +1559,24 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
>>>    	pgtable_t pgtable = NULL;
>>>    	int ret = -ENOMEM;
>>> +	pmd = pmdp_get_lockless(src_pmd);
>>> +	if (unlikely(pmd_special(pmd))) {
>>
>> I assume I have to clean up your mess here as well?
> 
> Can you leave meaningful and explicit comment?  I'll try to address.

Sorry Peter, but I raised all that as reply to v1. For example, I 
stated that vm_normal_page_pmd() already *exist* and why these 
pmd_special() checks should be kept there.

I hear you, you're not interested in cleaning that up. So at this point 
it's easier for me to clean it up myself.

-- 
Cheers,

David / dhildenb


