Return-Path: <kvm+bounces-28614-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DA17D99A2D4
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 13:37:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7F6B71F23F32
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 11:37:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3185A216A36;
	Fri, 11 Oct 2024 11:36:58 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36D0D216432;
	Fri, 11 Oct 2024 11:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728646617; cv=none; b=S5PNi5NtsqcD34+uR+NNvDg35CdGb57WvE6kcd1bPhNUIAluj1wTi1wZcDRE9CAJdvX0ZBsWMALz8uO5hSxY2P/XTo8Lm/LdZ4diUWIZinAWNLfyg+g4RHI9OQ35dJHNrQFIAufxLC2X4efrIrnob7dtJ39zC0ev3ioYvQYDjZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728646617; c=relaxed/simple;
	bh=ilN4s64LOZYiaj+PdL2HcRHuyMp46DVVPlPUnaNeVvM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=p71lJEdEnD950xs26/U5Jj7Y5Xg92x14I+I85jf9UNTQyktOmk/wXcsKk4+hx6YL7g0lGd0ZTMquruXVf2SB8KcdATmX3dzFj7HelVHc9boX7elPI5U0kyX9BucBu5HWER69JImiP8mL+lbvlU5QwCvpqFDkdnrwNCz4UZ8VHqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EFA36DA7;
	Fri, 11 Oct 2024 04:37:23 -0700 (PDT)
Received: from [10.57.85.162] (unknown [10.57.85.162])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 154823F73F;
	Fri, 11 Oct 2024 04:36:51 -0700 (PDT)
Message-ID: <4fd20101-d15c-4f9b-93c1-c780734a2294@arm.com>
Date: Fri, 11 Oct 2024 12:36:50 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 2/2] mm: don't install PMD mappings when THPs are
 disabled by the hw/process/vma
Content-Language: en-GB
To: David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, kvm@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
 Thomas Huth <thuth@redhat.com>, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 Kefeng Wang <wangkefeng.wang@huawei.com>, Leo Fu <bfu@redhat.com>
References: <20241011102445.934409-1-david@redhat.com>
 <20241011102445.934409-3-david@redhat.com>
 <a4ca9422-09f5-4137-88d0-88a7ec836c1a@arm.com>
 <a552416e-fd32-4b84-b5d6-40a27530c939@redhat.com>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <a552416e-fd32-4b84-b5d6-40a27530c939@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 11/10/2024 12:33, David Hildenbrand wrote:
> On 11.10.24 13:29, Ryan Roberts wrote:
>> On 11/10/2024 11:24, David Hildenbrand wrote:
>>> We (or rather, readahead logic :) ) might be allocating a THP in the
>>> pagecache and then try mapping it into a process that explicitly disabled
>>> THP: we might end up installing PMD mappings.
>>>
>>> This is a problem for s390x KVM, which explicitly remaps all PMD-mapped
>>> THPs to be PTE-mapped in s390_enable_sie()->thp_split_mm(), before
>>> starting the VM.
>>>
>>> For example, starting a VM backed on a file system with large folios
>>> supported makes the VM crash when the VM tries accessing such a mapping
>>> using KVM.
>>>
>>> Is it also a problem when the HW disabled THP using
>>> TRANSPARENT_HUGEPAGE_UNSUPPORTED? At least on x86 this would be the case
>>> without X86_FEATURE_PSE.
>>>
>>> In the future, we might be able to do better on s390x and only disallow
>>> PMD mappings -- what s390x and likely TRANSPARENT_HUGEPAGE_UNSUPPORTED
>>> really wants. For now, fix it by essentially performing the same check as
>>> would be done in __thp_vma_allowable_orders() or in shmem code, where this
>>> works as expected, and disallow PMD mappings, making us fallback to PTE
>>> mappings.
>>>
>>> Reported-by: Leo Fu <bfu@redhat.com>
>>> Fixes: 793917d997df ("mm/readahead: Add large folio readahead")
>>
>> Will this patch be difficult to backport given it depends on the previous patch
>> and that doesn't have a Fixes tag?
> 
> "difficult" -- not really. Andrew might want to tag patch #1  with "Fixes:" as
> well, but I can also send simple stable backports that avoid patch #1.
> 
> (Thinking again, I assume we want to Cc:stable)
> 
>>
>>> Cc: Thomas Huth <thuth@redhat.com>
>>> Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
>>> Cc: Ryan Roberts <ryan.roberts@arm.com>
>>> Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
>>> Cc: Janosch Frank <frankja@linux.ibm.com>
>>> Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
>>> Signed-off-by: David Hildenbrand <david@redhat.com>
>>> ---
>>>   mm/memory.c | 9 +++++++++
>>>   1 file changed, 9 insertions(+)
>>>
>>> diff --git a/mm/memory.c b/mm/memory.c
>>> index 2366578015ad..a2e501489517 100644
>>> --- a/mm/memory.c
>>> +++ b/mm/memory.c
>>> @@ -4925,6 +4925,15 @@ vm_fault_t do_set_pmd(struct vm_fault *vmf, struct
>>> page *page)
>>>       pmd_t entry;
>>>       vm_fault_t ret = VM_FAULT_FALLBACK;
>>>   +    /*
>>> +     * It is too late to allocate a small folio, we already have a large
>>> +     * folio in the pagecache: especially s390 KVM cannot tolerate any
>>> +     * PMD mappings, but PTE-mapped THP are fine. So let's simply refuse any
>>> +     * PMD mappings if THPs are disabled.
>>> +     */
>>> +    if (thp_disabled_by_hw() || vma_thp_disabled(vma, vma->vm_flags))
>>> +        return ret;
>>
>> Why not just call thp_vma_allowable_orders()?
> 
> Why call thp_vma_allowable_orders() that does a lot more work that doesn't
> really apply here? :)

Yeah fair enough, I was just thinking it makes the code simpler to keep all the
checks in one place. But no strong opinion.

Either way:

Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>

> 
> I'd say, just like shmem, we handle this separately here.
> 


