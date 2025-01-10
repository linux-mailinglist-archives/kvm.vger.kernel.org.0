Return-Path: <kvm+bounces-35018-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F9A6A08C83
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 10:43:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 44B11188032D
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 09:43:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15E7420DD79;
	Fri, 10 Jan 2025 09:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=126.com header.i=@126.com header.b="pXc/RFwY"
X-Original-To: kvm@vger.kernel.org
Received: from m16.mail.126.com (m16.mail.126.com [220.197.31.6])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1A2320C00C;
	Fri, 10 Jan 2025 09:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736502051; cv=none; b=knIHj6c+YTjygq6VwhzdW5h834rnRE3TEcfEehmtNYUEeZcns4OVsnPVMHJ5ojcPg7rCdxvhump+/BiqGR+2103McKDEPTGiiefvrIqiKjOWImqkCn2jfsxhjwKNbWvuoX4jD/EfrM71dqDUTH2ZlWDwqHVFWvdrgs1NJKbMHUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736502051; c=relaxed/simple;
	bh=AZQkqZjo2aHOCqNuTIMgOPGgshbnuLXhLXqWV1ydBU0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SilJn0hIFY6rvM27/mSYY5kgMv+gyyFqJ7qkficZzpQBrJrtQpx0OPJGGMJbOmgUf4x8zcMPH4abxOMNskANNVF7UEE1mMcofpM+0+GxvUUXHdadrwnHVUmAHm/cG8urcslC7I31GdGE03fcBfT2sZINQI2YOOdcaLmdobOuBPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=126.com; spf=pass smtp.mailfrom=126.com; dkim=pass (1024-bit key) header.d=126.com header.i=@126.com header.b=pXc/RFwY; arc=none smtp.client-ip=220.197.31.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=126.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=126.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
	s=s110527; h=Message-ID:Date:MIME-Version:Subject:From:
	Content-Type; bh=mLYs0Cy9Bn99zF/IYKxGzsZB06t+E2Q+LzFi4KHI8zM=;
	b=pXc/RFwYycT+Xef+7jTAbIE39Kq49VFLuhVzrKZr6NPkPop7gVHFlQemLobMZI
	WfectbIaead5x3OYedkr5nFqpZPXx7QCZY9bGftpmaMz2voxtZxyMD7/gyv8mMQN
	ptQhSum3svDrFqb7foHdGLZ4dIdViRAP6Ay4mK/S6StWo=
Received: from [172.19.20.199] (unknown [])
	by gzga-smtp-mtada-g0-3 (Coremail) with SMTP id _____wD3H7wH64BnSXjpAw--.48236S2;
	Fri, 10 Jan 2025 17:40:24 +0800 (CST)
Message-ID: <abfd37b9-335d-4af9-b593-7dcf4db98a26@126.com>
Date: Fri, 10 Jan 2025 17:40:23 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: SEV: Pin SEV guest memory out of CMA area
To: David Hildenbrand <david@redhat.com>, pbonzini@redhat.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, michael.roth@amd.com,
 21cnbao@gmail.com, baolin.wang@linux.alibaba.com, liuzixing@hygon.cn
References: <1736498887-28180-1-git-send-email-yangge1116@126.com>
 <26fe43db-b122-40e0-a05a-81b11b89ef46@redhat.com>
From: Ge Yang <yangge1116@126.com>
In-Reply-To: <26fe43db-b122-40e0-a05a-81b11b89ef46@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3H7wH64BnSXjpAw--.48236S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7CF1fKw1ruF47tryUZF1DKFg_yoW8KFW7pF
	4xGa1akFZ8Xr9FvF92van5ur1xua4vgr48Cr1avryru3Z0qFyftr4I9w40q3ykZryUuF1F
	vr4rWwnxZr4DZaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jYpB-UUUUU=
X-CM-SenderInfo: 51dqwwjhrrila6rslhhfrp/1tbiig3QG2eA2sDigAAAsT



在 2025/1/10 16:58, David Hildenbrand 写道:
> On 10.01.25 09:48, yangge1116@126.com wrote:
>> From: yangge <yangge1116@126.com>
> 
> I would suggest the title to be something like
> 
> "KVM: SEV: fix wrong pinning of pages"
> 
> Then you can describe that without FOLL_LONGTERM, the pages will not get 
> migrated out of MIGRATE_CMA/ZONE_MOVABLE, violating these mechanisms to 
> avoid fragmentation with unmovable pages, for example making CMA 
> allocations fail.
> 
> (CMA allocations failing is only one symptom of the missed usage of 
> FOLL_LONGTERM)
> 
>>
>> When pin_user_pages_fast() pins SEV guest memory without the
>> FOLL_LONGTERM flag, the pinned pages may inadvertently end up in the
>> CMA (Contiguous Memory Allocator) area. This can subsequently cause
>> cma_alloc() to fail in allocating these pages, due to the fact that
>> the pinned pages are not migratable.
>>
>> To address the aforementioned problem, we propose adding the
>> FOLL_LONGTERM flag to the pin_user_pages_fast() function. By doing
>> so, we ensure that the pages allocated will not occupy space within
>> the CMA area, thereby preventing potential allocation failures.
>>
>> Signed-off-by: yangge <yangge1116@126.com>
>> ---
>>   arch/x86/kvm/svm/sev.c | 5 ++++-
>>   1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>> index 943bd07..35d0714 100644
>> --- a/arch/x86/kvm/svm/sev.c
>> +++ b/arch/x86/kvm/svm/sev.c
>> @@ -630,6 +630,7 @@ static struct page **sev_pin_memory(struct kvm 
>> *kvm, unsigned long uaddr,
>>       unsigned long locked, lock_limit;
>>       struct page **pages;
>>       unsigned long first, last;
>> +    unsigned int flags = 0;
> 
> Why not set
> 
> unsigned int flags = FOLL_LONGTERM;
> 
>>       int ret;
>>       lockdep_assert_held(&kvm->lock);
>> @@ -662,8 +663,10 @@ static struct page **sev_pin_memory(struct kvm 
>> *kvm, unsigned long uaddr,
>>       if (!pages)
>>           return ERR_PTR(-ENOMEM);
>> +    flags = write ? FOLL_WRITE : 0;
> 
> 
> and here do
> 
> flags |= write ? FOLL_WRITE : 0;
> 
>> +
>>       /* Pin the user virtual address. */
>> -    npinned = pin_user_pages_fast(uaddr, npages, write ? FOLL_WRITE : 
>> 0, pages);
>> +    npinned = pin_user_pages_fast(uaddr, npages, flags | 
>> FOLL_LONGTERM, pages);
>>       if (npinned != npages) {
>>           pr_err("SEV: Failure locking %lu pages.\n", npages);
>>           ret = -ENOMEM;
> 
> 
Ok, thanks.


