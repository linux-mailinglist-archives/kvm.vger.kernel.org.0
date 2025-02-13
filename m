Return-Path: <kvm+bounces-38019-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9CB04A33BEC
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2025 11:03:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D021D188C712
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2025 10:03:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0216C211A07;
	Thu, 13 Feb 2025 10:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hdgzMYQs"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3140206F31
	for <kvm@vger.kernel.org>; Thu, 13 Feb 2025 10:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739440980; cv=none; b=Lm2gsYQtrJCq6EdvbkZ5kZU66T5qL7i8BhMcLoKYVTZ1vA1tyEVmw0Rl8JOHU7cz7qiN6O2kImLBO1k3MDCSbHCAv1Y/MS7kqGQsQOy29FB+Gico4N/x1k8VHzCK84ftlHq8PNscP65LLssJHMX3E+1MN/JXV+I9V/YDV4BANMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739440980; c=relaxed/simple;
	bh=tX7AozPP6E5+MLf8cJoQS9mb5qbZJa5QwLF58GQEG44=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=paB01ixPws5NlXD2wNZdqiJ1+uSz7ZcDiqZ6R0reiDQK0LjY5p1+KmdZ9ek0nUzL81ZT9oecHGt7dCcymrDkNZ5HCOrNDSR3Kuw4uWkPV0o9N9IRqR35o1IC11o5Jg5+hgcYR80Bx5vRMNIfLqX9kc6thoFwyBMEIG3K2foVJps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hdgzMYQs; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739440976;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=3V20fc6va6aAlUHwEWCfoyPaQHzn8E4DTrNUGz56JdM=;
	b=hdgzMYQs3LucJFDrAxXZrXNbCBMdbEPaBmSoGhhpAtV4fUqcish6znjzgO2Ej7pbB7jnSb
	FAZm8x5Kc23P73teKdP4TRVhjsp4zAp4wK3W060+t0h5FE0VzHtBRxOac+KG8Q0utrVc6j
	lIu/9Jq/2mtmKQ/mK4F2XFm7tSGU87A=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-259-1iAMhkY6PhaKyJfazFmMxA-1; Thu, 13 Feb 2025 05:02:54 -0500
X-MC-Unique: 1iAMhkY6PhaKyJfazFmMxA-1
X-Mimecast-MFC-AGG-ID: 1iAMhkY6PhaKyJfazFmMxA_1739440973
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4393e89e910so3632555e9.0
        for <kvm@vger.kernel.org>; Thu, 13 Feb 2025 02:02:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739440973; x=1740045773;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:references:cc:to:from:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=3V20fc6va6aAlUHwEWCfoyPaQHzn8E4DTrNUGz56JdM=;
        b=LJmNhTkBYS1nKAGfLfaFU89gnkTQi8M9g/Zib86r0qvfYqHdl3LIZs4m/9DtmiB51F
         qWDRZlwt12a5wZWlU4k5Pr/JrEJ8XWzPl41qXDv6m7+qyA6HQ9BDVGrpJcJn9feJb0oP
         YfI9aTuYSSOxnn/sGoWHPknJwBb3Fdx7x/AcSZLSnsXWbLPFUOfhAXMOuJhthptZn640
         eHu75saaVjlDvu2+hhyKgtu1/OG9X1gL8AjfzuCNXfceEbBTYwvut35j78yRzjT4Z48G
         XL8ugqfNOfiuYJu+IO17wGEg+F+5sNUqzjVVd5jmMrlYTqwV+eVOnZBvw6nU1o42UW3B
         hfyA==
X-Forwarded-Encrypted: i=1; AJvYcCUxK92is8mMHztMSTmee0dqF/YwqN95r3Y40oeGaOX1nEs6wv0e4mRWBHf5LzPBorJLyTU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzb2TOnQDqiyGSwYnrMMGRBjW1r5ewNowhXZY2X2xx1E6Cm9FRD
	NZGjHxvUAcdPAWulVpcxg/wxymGKdgLUssg0p0Y6tX5Eae7FXHSpwgrsR6vmkwGFGbwnM/3LbFK
	U2Fq1sNqkuMNl4sxDSGPTvUL1yjhD+06qWj/Viu3ISnWKheig5Q==
X-Gm-Gg: ASbGncuqAJ7Ygcf8UHmXGbxzpRG/ZTXRlXXLGFxftdADSOPsGC0ps02U97/Up5alyog
	Uj+TngPUCgMrKeo/KAFLoeLteXaafFL9i7ctKJOU30uDYhtfAAGtWKCRaIPb0g/OGv7Ypf6qPzS
	f2ELdgxK7umD0NRgrV4CZFSmtPHWBo2lJoaK1PxqWX1JfYD49bZSoZWOazbnwIHDcMHCoH0NgIm
	gyg9vyKWuaZgWS5icoTDrcLJ42Bs4++GtcVuzmqXc7XpN3AWbxGCyOHZWsaq0myBEhU13KHtnlM
	POVuOy9musZZ/khkSBL0zaqw8VMAOtcd4/A/gNWRhIYUuETTNPUmgKe+NMLuVIBCQh2bbH8yb+C
	9kWlYhY+oiVop7Fk02rDi42XEKO1Feg==
X-Received: by 2002:a05:600c:444f:b0:434:feb1:adcf with SMTP id 5b1f17b1804b1-439601ae212mr25394205e9.25.1739440972671;
        Thu, 13 Feb 2025 02:02:52 -0800 (PST)
X-Google-Smtp-Source: AGHT+IELEHASa1QH5FtD/ayjVuaAGldYnBlLGmpEmax0pKtSHomSJebxcqI8HhgHajVqv2/9dpsvjw==
X-Received: by 2002:a05:600c:444f:b0:434:feb1:adcf with SMTP id 5b1f17b1804b1-439601ae212mr25393615e9.25.1739440972064;
        Thu, 13 Feb 2025 02:02:52 -0800 (PST)
Received: from ?IPV6:2003:cb:c718:100:347d:db94:161d:398f? (p200300cbc7180100347ddb94161d398f.dip0.t-ipconnect.de. [2003:cb:c718:100:347d:db94:161d:398f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43961884251sm12557855e9.31.2025.02.13.02.02.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Feb 2025 02:02:50 -0800 (PST)
Message-ID: <7c0b5675-a070-4248-bd29-5c27d07a4c5b@redhat.com>
Date: Thu, 13 Feb 2025 11:02:49 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL v2 09/20] KVM: s390: move pv gmap functions into kvm
From: David Hildenbrand <david@redhat.com>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, linux-s390@vger.kernel.org,
 frankja@linux.ibm.com, borntraeger@de.ibm.com
References: <20250131112510.48531-1-imbrenda@linux.ibm.com>
 <20250131112510.48531-10-imbrenda@linux.ibm.com>
 <d5ef124a-d353-4074-925e-a2721be3ce5d@redhat.com>
 <20250212184538.3c79d608@p-imbrenda>
 <f9a6c330-2721-40ed-a8f4-95192e8312a8@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <f9a6c330-2721-40ed-a8f4-95192e8312a8@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12.02.25 19:14, David Hildenbrand wrote:
> On 12.02.25 18:45, Claudio Imbrenda wrote:
>> On Wed, 12 Feb 2025 17:55:18 +0100
>> David Hildenbrand <david@redhat.com> wrote:
>>
>>> On 31.01.25 12:24, Claudio Imbrenda wrote:
>>>> Move gmap related functions from kernel/uv into kvm.
>>>>
>>>> Create a new file to collect gmap-related functions.
>>>>
>>>> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
>>>> Reviewed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
>>>> [fixed unpack_one(), thanks mhartmay@linux.ibm.com]
>>>> Link: https://lore.kernel.org/r/20250123144627.312456-6-imbrenda@linux.ibm.com
>>>> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
>>>> Message-ID: <20250123144627.312456-6-imbrenda@linux.ibm.com>
>>>> ---
>>>
>>> This patch breaks large folio splitting because you end up un-refing
>>> the wrong folios after a split; I tried to make it work, but either
>>> because of other changes in this patch (or in others), I
>>> cannot get it to work and have to give up for today.
>>
>> yes, I had also noticed that and I already have a fix ready. In fact my
>> fix was exactly like yours, except that I did not pass the struct folio
>> anymore to kvm_s390_wiggle_split_folio(), but instead I only pass a
>> page and use page_folio() at the beginning, and I use
>> split_huge_page_to_list_to_order() directly instead of split_folio()
>>    
>> unfortunately the fix does not fix the issue I'm seeing....
>>
>> but putting printks everywhere seems to solve the issue, so it seems to
>> be a race somewhere
> 
> It also doesn't work with a single vCPU for me. The VM is stuck in
> 
> With a two vCPUs (so one can report the lockup), I get:
> 
> [   62.645168] rcu: INFO: rcu_sched self-detected stall on CPU
> [   62.645181] rcu:     0-....: (5999 ticks this GP) idle=0104/1/0x4000000000000002 softirq=2/2 fqs=2997
> [   62.645186] rcu:     (t=6000 jiffies g=-1199 q=62 ncpus=2)
> [   62.645191] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.14.0-427.33.1.el9_4.s390x #1
> [   62.645194] Hardware name: IBM 3931 LA1 400 (KVM/Linux)
> [   62.645195] Krnl PSW : 0704c00180000000 0000000024b3e776 (set_memory_decrypted+0x66/0xa0)
> [   62.645206]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:0 PM:0 RI:0 EA:3
> [   62.645208] Krnl GPRS: 00000000ca004000 0000037f00000001 000000008092f000 0000000000000000
> [   62.645210]            0000037fffb1bbc0 0000000000000001 0000000025e75208 000000008092f000
> [   62.645211]            0000000080873808 0000037fffb1bcd8 0000000000001000 0000000025e75220
> [   62.645213]            0000000080281500 00000000258aa480 0000000024c0b17a 0000037fffb1bb20
> [   62.645220] Krnl Code: 0000000024b3e76a: a784000f            brc     8,0000000024b3e788
> [   62.645220]            0000000024b3e76e: a7210fff            tmll    %r2,4095
> [   62.645220]           #0000000024b3e772: a7740017            brc     7,0000000024b3e7a0
> [   62.645220]           >0000000024b3e776: b9a40034            uvc     %r3,%r4,0
> [   62.645220]            0000000024b3e77a: b2220010            ipm     %r1
> [   62.645220]            0000000024b3e77e: 8810001c            srl     %r1,28
> [   62.645220]            0000000024b3e782: ec12fffa017e        cij     %r1,1,2,0000000024b3e776
> [   62.645220]            0000000024b3e788: a72b1000            aghi    %r2,4096
> [   62.645232] Call Trace:
> [   62.645234]  [<0000000024b3e776>] set_memory_decrypted+0x66/0xa0
> [   62.645238]  [<0000000024c0b17a>] dma_direct_alloc+0x16a/0x2d0
> [   62.645242]  [<0000000024c09b92>] dma_alloc_attrs+0x62/0x80
> [   62.645243]  [<000000002546c950>] cio_gp_dma_create+0x60/0xa0
> [   62.645248]  [<0000000025ebb712>] css_bus_init+0x102/0x1b8
> [   62.645252]  [<0000000025ebb7ea>] channel_subsystem_init+0x22/0xf8
> [   62.645254]  [<0000000024b149ac>] do_one_initcall+0x3c/0x200
> [   62.645256]  [<0000000025e777be>] do_initcalls+0x11e/0x148
> [   62.645260]  [<0000000025e77a34>] kernel_init_freeable+0x1cc/0x208
> [   62.645262]  [<00000000254ad01e>] kernel_init+0x2e/0x170
> [   62.645264]  [<0000000024b16fdc>] __ret_from_fork+0x3c/0x60
> [   62.645266]  [<00000000254bb07a>] ret_from_fork+0xa/0x40
> 

I can only suspect that it is related to the following: if we split a non-anon
folio, we unmap it from the page tables, and don't remap it again -- the next
fault will do that. Maybe, for some reason that behavior is incompatible with your changes.

I don't quit see how, because we should just trigger another fault to look up
the page in gmap_make_secure()->gfn_to_page() when we re-enter gmap_make_secure() after a split.

> 
> The removed PTE lock would only explain it if we would have a concurrent GUP etc.
> from QEMU I/O ? Not sure.
> 
> To fix the wrong refcount freezing, doing exactly what folio splitting does
> (migration PTEs, locking the pagecache etc., freezing->converting,
> removing migration ptes) should work, but requires a bit of work.

I played with the following abomination to see if I could fix the refcount freezing somehow.

It doesn't work, because the UVC keeps failing: I assume because it actually
needs the page to be mapped into that particular page table for the UVC to complete.


To fix refcount freezing with that (folio still mapped), we'd have to make sure that
folio_mapcount()==1 while we hold the PTL, and doing something similar to below,
except that the rmap/anon locking and unmap/remap handling would not apply. The
pagecache most likely would have to be locked to prevent new references from that while
we freeze the refcount.

In case we would have folio_mapcount() != 1 on an anon page, we would have to give up:
impossible if it is mapped writable -- so no problem.

In case we would have folio_mapcount() != 1 on a pagecache page, we would have to
force an unmap of the all page table mappings using e.g., try_to_unmap(), to then retry
again.

But the PTL seems unavoidable in that case to prevent concurrent GUP-slow etc, so we
can safely freeze the refcount.


 From c2555fc34801ca9ba49f93ee1249ecd25248377a Mon Sep 17 00:00:00 2001
From: David Hildenbrand <david@redhat.com>
Date: Thu, 13 Feb 2025 09:49:54 +0100
Subject: [PATCH] tmp

Signed-off-by: David Hildenbrand <david@redhat.com>
---
  arch/s390/kernel/uv.c | 139 +++++++++++++++++++++++++++++++++++-------
  include/linux/rmap.h  |  17 ++++++
  mm/internal.h         |  16 -----
  3 files changed, 133 insertions(+), 39 deletions(-)

diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
index 9f05df2da2f73..d6ea8951fa53b 100644
--- a/arch/s390/kernel/uv.c
+++ b/arch/s390/kernel/uv.c
@@ -15,6 +15,7 @@
  #include <linux/pagemap.h>
  #include <linux/swap.h>
  #include <linux/pagewalk.h>
+#include <linux/rmap.h>
  #include <asm/facility.h>
  #include <asm/sections.h>
  #include <asm/uv.h>
@@ -227,6 +228,45 @@ static int expected_folio_refs(struct folio *folio)
  	return res;
  }
  
+static void unmap_folio(struct folio *folio)
+{
+	enum ttu_flags ttu_flags = TTU_RMAP_LOCKED | TTU_SYNC |
+		TTU_BATCH_FLUSH;
+
+	VM_BUG_ON_FOLIO(!folio_test_large(folio), folio);
+
+	if (folio_test_pmd_mappable(folio))
+		ttu_flags |= TTU_SPLIT_HUGE_PMD;
+
+	/*
+	 * Anon pages need migration entries to preserve them, but file
+	 * pages can simply be left unmapped, then faulted back on demand.
+	 * If that is ever changed (perhaps for mlock), update remap_page().
+	 */
+	if (folio_test_anon(folio))
+		try_to_migrate(folio, ttu_flags);
+	else
+		try_to_unmap(folio, ttu_flags | TTU_IGNORE_MLOCK);
+
+	try_to_unmap_flush();
+}
+
+static void remap_page(struct folio *folio, unsigned long nr, int flags)
+{
+	int i = 0;
+
+	/* If unmap_folio() uses try_to_migrate() on file, remove this check */
+	if (!folio_test_anon(folio))
+		return;
+	for (;;) {
+		remove_migration_ptes(folio, folio, RMP_LOCKED | flags);
+		i += folio_nr_pages(folio);
+		if (i >= nr)
+			break;
+		folio = folio_next(folio);
+	}
+}
+
  /**
   * make_folio_secure() - make a folio secure
   * @folio: the folio to make secure
@@ -247,35 +287,88 @@ static int expected_folio_refs(struct folio *folio)
   */
  int make_folio_secure(struct folio *folio, struct uv_cb_header *uvcb)
  {
-	int expected, cc = 0;
+	XA_STATE(xas, &folio->mapping->i_pages, folio->index);
+	struct address_space *mapping = NULL;
+	struct anon_vma *anon_vma = NULL;
+	int ret, cc = 0;
+	int expected;
  
  	if (folio_test_large(folio))
  		return -E2BIG;
  	if (folio_test_writeback(folio))
  		return -EBUSY;
-	expected = expected_folio_refs(folio) + 1;
-	if (!folio_ref_freeze(folio, expected))
+
+	/* Does it make sense to try at all? */
+	if (folio_ref_count(folio) != expected_folio_refs(folio) + 1)
  		return -EBUSY;
-	set_bit(PG_arch_1, &folio->flags);
-	/*
-	 * If the UVC does not succeed or fail immediately, we don't want to
-	 * loop for long, or we might get stall notifications.
-	 * On the other hand, this is a complex scenario and we are holding a lot of
-	 * locks, so we can't easily sleep and reschedule. We try only once,
-	 * and if the UVC returned busy or partial completion, we return
-	 * -EAGAIN and we let the callers deal with it.
-	 */
-	cc = __uv_call(0, (u64)uvcb);
-	folio_ref_unfreeze(folio, expected);
-	/*
-	 * Return -ENXIO if the folio was not mapped, -EINVAL for other errors.
-	 * If busy or partially completed, return -EAGAIN.
-	 */
-	if (cc == UVC_CC_OK)
-		return 0;
-	else if (cc == UVC_CC_BUSY || cc == UVC_CC_PARTIAL)
-		return -EAGAIN;
-	return uvcb->rc == 0x10a ? -ENXIO : -EINVAL;
+
+	/* See split_huge_page_to_list_to_order() on the nasty details. */
+	if (folio_test_anon(folio)) {
+		anon_vma = folio_get_anon_vma(folio);
+		if (!anon_vma)
+			return -EBUSY;
+		anon_vma_lock_write(anon_vma);
+	} else {
+		mapping = folio->mapping;
+		if (!mapping)
+			return -EBUSY;
+		/* Hmmm, do we need filemap_release_folio()? */
+		i_mmap_lock_read(mapping);
+	}
+
+	unmap_folio(folio);
+
+	local_irq_disable();
+	if (mapping) {
+		xas_lock(&xas);
+		xas_reset(&xas);
+		if (xas_load(&xas) != folio) {
+			ret = -EBUSY;
+			goto fail;
+		}
+	}
+
+	expected = expected_folio_refs(folio) + 1;
+	if (!folio_mapped(folio) &&
+	    folio_ref_freeze(folio, expected)) {
+		set_bit(PG_arch_1, &folio->flags);
+		/*
+		 * If the UVC does not succeed or fail immediately, we don't want to
+		 * loop for long, or we might get stall notifications.
+		 * On the other hand, this is a complex scenario and we are holding a lot of
+		 * locks, so we can't easily sleep and reschedule. We try only once,
+		 * and if the UVC returned busy or partial completion, we return
+		 * -EAGAIN and we let the callers deal with it.
+		 */
+		cc = __uv_call(0, (u64)uvcb);
+		folio_ref_unfreeze(folio, expected);
+		/*
+		 * Return -ENXIO if the folio was not mapped, -EINVAL for other errors.
+		 * If busy or partially completed, return -EAGAIN.
+		 */
+		if (cc == UVC_CC_OK)
+			ret = 0;
+		else if (cc == UVC_CC_BUSY || cc == UVC_CC_PARTIAL)
+			ret = -EAGAIN;
+		else
+			ret = uvcb->rc == 0x10a ? -ENXIO : -EINVAL;
+	} else {
+		ret = -EBUSY;
+	}
+
+	if (mapping)
+		xas_unlock(&xas);
+fail:
+	local_irq_enable();
+	remap_page(folio, 1, 0);
+	if (anon_vma) {
+		anon_vma_unlock_write(anon_vma);
+		put_anon_vma(anon_vma);
+	}
+	if (mapping)
+		i_mmap_unlock_read(mapping);
+	xas_destroy(&xas);
+	return ret;
  }
  EXPORT_SYMBOL_GPL(make_folio_secure);
  
diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index 683a04088f3f2..2d241ab48bf08 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -663,6 +663,23 @@ int folio_referenced(struct folio *, int is_locked,
  void try_to_migrate(struct folio *folio, enum ttu_flags flags);
  void try_to_unmap(struct folio *, enum ttu_flags flags);
  
+#ifdef CONFIG_ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH
+void try_to_unmap_flush(void);
+void try_to_unmap_flush_dirty(void);
+void flush_tlb_batched_pending(struct mm_struct *mm);
+#else
+static inline void try_to_unmap_flush(void)
+{
+}
+static inline void try_to_unmap_flush_dirty(void)
+{
+}
+static inline void flush_tlb_batched_pending(struct mm_struct *mm)
+{
+}
+#endif /* CONFIG_ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH */
+
+
  int make_device_exclusive_range(struct mm_struct *mm, unsigned long start,
  				unsigned long end, struct page **pages,
  				void *arg);
diff --git a/mm/internal.h b/mm/internal.h
index 109ef30fee11f..5338906163ca7 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1202,22 +1202,6 @@ struct tlbflush_unmap_batch;
   */
  extern struct workqueue_struct *mm_percpu_wq;
  
-#ifdef CONFIG_ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH
-void try_to_unmap_flush(void);
-void try_to_unmap_flush_dirty(void);
-void flush_tlb_batched_pending(struct mm_struct *mm);
-#else
-static inline void try_to_unmap_flush(void)
-{
-}
-static inline void try_to_unmap_flush_dirty(void)
-{
-}
-static inline void flush_tlb_batched_pending(struct mm_struct *mm)
-{
-}
-#endif /* CONFIG_ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH */
-
  extern const struct trace_print_flags pageflag_names[];
  extern const struct trace_print_flags vmaflag_names[];
  extern const struct trace_print_flags gfpflag_names[];
-- 
2.48.1



-- 
Cheers,

David / dhildenb


