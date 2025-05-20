Return-Path: <kvm+bounces-47071-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4ED14ABCF1C
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 08:20:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D87554A3ED7
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 06:20:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6420625C83F;
	Tue, 20 May 2025 06:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="atBvTXRq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5E8213C3CD
	for <kvm@vger.kernel.org>; Tue, 20 May 2025 06:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747722041; cv=none; b=XA2ocnvpOtOz3jbMtkqBk9AkMNoGqPU8/qDz25fMonPVl7NmnfXBmvHSERKSjk8zxF5HMrItHcAGWNlOWalrflX6Cs3QEMdwenTsUERz79UZVzsWKQN8SfXC2s9SUSud/ET1XQHtnXuMZtHcNCLM1EorJKMsVBOeKxUGj0v5R1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747722041; c=relaxed/simple;
	bh=fnO117JPO5Ovmm08Gq4uGbtkp3RU3N4PkTIM6qeBaR8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r/y0GC5Lcqg8/9C9SDfKi4flrIsmtL9tqY1jb8xvXOheadF6ws5F5mTtoxJp63pcoijIgbLJds1NUdbcfGtbBTcjMx1Kft5OrlEevJHGuWRNfVgHDVIoOWOm+ptN0qbNjzpRM9OHD2ZfOAw9kKCTxblYcdSSgruQO2rUktgOjlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=atBvTXRq; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-b1f7357b5b6so3515934a12.0
        for <kvm@vger.kernel.org>; Mon, 19 May 2025 23:20:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1747722038; x=1748326838; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MN1daik4SPrO/LXhkvtoUfhBhzWkiMoNJcsHxqO1LD8=;
        b=atBvTXRqgqCbURF28TQjbvQzwBrFqM8dK9M7P8APWh4riKF2q5JdgE5uj0pX4y/tLJ
         r99mdkGcs/Xkw1n5M8NwdUsTjwy1JU9M3uxnY299o5zAMAsxUfjidVKNZ5bXsz/QAxyb
         GI6VNhJPPYhM1WovNzl2cm5FJqPcz1z1tHmogNwtaKWDr2RM7zOzDzcfvFb06RpDFdRK
         CnF9yEUpQacZSHfNi3+AQfVt0QD+IqA+qW3YTL+aJ4fs9QXh/cnnkHFBX7+hR5a4EbCS
         kZKblKYHv1svUaDKHjCm033i0q7Unx4mCAep5dRkqT0w5PVlD6Z2FVw8OqbeyTA604HX
         awuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747722038; x=1748326838;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MN1daik4SPrO/LXhkvtoUfhBhzWkiMoNJcsHxqO1LD8=;
        b=aJ3er4hoStjm4wfDFIlpi1+uVhm6387B+/8GfHBD9lWnYrr2wf9MrfRbr9CoRMN4gN
         i7cJfunFTG3EERIvEb3jrHGYJ1wd6ogAjcxvEcBxpdWCefptmX7sBc/VgZIbOgKV2bnW
         iiEXfZpqsQQBS+H40CAgnBpoUM574cGQNxZP6tAX0MG7JwGT8B9kue2C1Otx8BREYGvB
         U0ILpEZgx1P2nYf3PWcSP8SgDuPs6SuMBaV7cHE79mabdJPlrSgVMbsvHeLYSqOWUR9N
         S1tov2+e/zT5u/1xKj9kqaNo1tmoMqeZF8VQAkz6+FE1CXiszixL19fpOAlDlI3OSyvO
         hIig==
X-Gm-Message-State: AOJu0Yz63Rae6RlJf6skwPdRHcpuHYGNRftdAjam+7aQGJCcd2kNZz+Q
	+QXmnnaWJB/VfhqScTMejPrwuXs8GipBZvKMH/lMUjQgpPgZCRRHc9fcet/p02HVD3U=
X-Gm-Gg: ASbGncsv82oQ9XodglD7BLJDd3OKPUKSuX8cLsw3duTjAQx3etlAAS5HT/9J00rKLfP
	ajVHUPrv5PVsNxK664N/lB+jqF98DAZtN44lr9Sv8daM4QuMWitP6V/YqkvrsY2AxVWngJs3Wyf
	Sd+q+bZZMXjgbljs0dzojINZ5WDhtwKOhFGtjIiZ1s433BZw9iHTHltckORjTn9iukzDvmbTwGG
	u04Xa2kOOS9myadfCfpsWWIHN2TrWMAkjXUQYusVVi8IgZkqYASkppO7ABoEliwflmx5Ro1FFbz
	pCzSuQRWSOmE5t2JKZx+Il0ShvnHv6G8o4Qo/aqWQqRiL89zYQSGBlB/kLwe6Ds5mgvfrDAYeD4
	8ypc=
X-Google-Smtp-Source: AGHT+IEt/08SvJhgzov4+pV4DqatdXF+Gh5UCHJPwmhb/xclldIzUixkeTG8fgB09jR/93ACDRKnqQ==
X-Received: by 2002:a17:903:1ace:b0:231:c90e:292d with SMTP id d9443c01a7336-231d45af19fmr245770045ad.44.1747722037924;
        Mon, 19 May 2025 23:20:37 -0700 (PDT)
Received: from localhost.localdomain ([203.208.189.11])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-231d4e98009sm69694575ad.152.2025.05.19.23.20.34
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 19 May 2025 23:20:37 -0700 (PDT)
From: lizhe.67@bytedance.com
To: alex.williamson@redhat.com
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lizhe.67@bytedance.com,
	muchun.song@linux.dev,
	peterx@redhat.com
Subject: Re: [PATCH v2] vfio/type1: optimize vfio_pin_pages_remote() for hugetlbfs folio
Date: Tue, 20 May 2025 14:20:31 +0800
Message-ID: <20250520062031.3023-1-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250519100724.7fd6cc1e.alex.williamson@redhat.com>
References: <20250519100724.7fd6cc1e.alex.williamson@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, 19 May 2025 10:07:24 -0600, alex.williamson@redhat.com wrote:

>>  /*
>> - * Helper Functions for host iova-pfn list
>> + * Find the first vfio_pfn that overlapping the range
>> + * [iova, iova + PAGE_SIZE * npage) in rb tree
>>   */
>> -static struct vfio_pfn *vfio_find_vpfn(struct vfio_dma *dma, dma_addr_t iova)
>> +static struct vfio_pfn *vfio_find_vpfn_range(struct vfio_dma *dma,
>> +		dma_addr_t iova, unsigned long npage)
>>  {
>>  	struct vfio_pfn *vpfn;
>>  	struct rb_node *node = dma->pfn_list.rb_node;
>> +	dma_addr_t end_iova = iova + PAGE_SIZE * npage;
>>  
>>  	while (node) {
>>  		vpfn = rb_entry(node, struct vfio_pfn, node);
>>  
>> -		if (iova < vpfn->iova)
>> +		if (end_iova <= vpfn->iova)
>>  			node = node->rb_left;
>>  		else if (iova > vpfn->iova)
>>  			node = node->rb_right;
>> @@ -337,6 +340,14 @@ static struct vfio_pfn *vfio_find_vpfn(struct vfio_dma *dma, dma_addr_t iova)
>>  	return NULL;
>>  }
>>  
>> +/*
>> + * Helper Functions for host iova-pfn list
>> + */
>
>This comment should still precede the renamed function above, it's in
>reference to this section of code related to searching, inserting, and
>removing entries from the pfn list.

Thanks!

I will place it in the comments before the function vfio_find_vpfn_range()
in v3 patch.

>> @@ -681,32 +692,67 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
>>  		 * and rsvd here, and therefore continues to use the batch.
>>  		 */
>>  		while (true) {
>> +			int page_step = 1;
>> +			long lock_acct_step = 1;
>> +			struct folio *folio = page_folio(batch->pages[batch->offset]);
>> +			bool found_vpfn;
>> +
>>  			if (pfn != *pfn_base + pinned ||
>>  			    rsvd != is_invalid_reserved_pfn(pfn))
>>  				goto out;
>>  
>> +			/* Handle hugetlbfs page */
>> +			if (folio_test_hugetlb(folio)) {
>
>Why do we care to specifically test for hugetlb vs
>folio_large_nr_pages(), at which point we can just use folio_nr_pages()
>directly here.
>
>> +				unsigned long start_pfn = PHYS_PFN(vaddr);
>
>Using this macro on a vaddr looks wrong.
>
>> +
>> +				/*
>> +				 * Note: The current page_step does not achieve the optimal
>> +				 * performance in scenarios where folio_nr_pages() exceeds
>> +				 * batch->capacity. It is anticipated that future enhancements
>> +				 * will address this limitation.
>> +				 */
>> +				page_step = min(batch->size,
>> +					ALIGN(start_pfn + 1, folio_nr_pages(folio)) - start_pfn);
>
>Why do we assume start_pfn is the beginning of the folio?
>
>> +				found_vpfn = !!vfio_find_vpfn_range(dma, iova, page_step);
>> +				if (rsvd || !found_vpfn) {
>> +					lock_acct_step = page_step;
>> +				} else {
>> +					dma_addr_t tmp_iova = iova;
>> +					int i;
>> +
>> +					lock_acct_step = 0;
>> +					for (i = 0; i < page_step; ++i, tmp_iova += PAGE_SIZE)
>> +						if (!vfio_find_vpfn(dma, tmp_iova))
>> +							lock_acct_step++;
>> +					if (lock_acct_step)
>> +						found_vpfn = false;
>
>Why are we making this so complicated versus falling back to iterating
>at page per page?
>
>> +				}
>> +			} else {
>> +				found_vpfn = vfio_find_vpfn(dma, iova);
>> +			}
>> +
>>  			/*
>>  			 * Reserved pages aren't counted against the user,
>>  			 * externally pinned pages are already counted against
>>  			 * the user.
>>  			 */
>> -			if (!rsvd && !vfio_find_vpfn(dma, iova)) {
>> +			if (!rsvd && !found_vpfn) {
>>  				if (!dma->lock_cap &&
>> -				    mm->locked_vm + lock_acct + 1 > limit) {
>> +				    mm->locked_vm + lock_acct + lock_acct_step > limit) {
>>  					pr_warn("%s: RLIMIT_MEMLOCK (%ld) exceeded\n",
>>  						__func__, limit << PAGE_SHIFT);
>>  					ret = -ENOMEM;
>>  					goto unpin_out;
>>  				}
>> -				lock_acct++;
>> +				lock_acct += lock_acct_step;
>>  			}
>>  
>> -			pinned++;
>> -			npage--;
>> -			vaddr += PAGE_SIZE;
>> -			iova += PAGE_SIZE;
>> -			batch->offset++;
>> -			batch->size--;
>> +			pinned += page_step;
>> +			npage -= page_step;
>> +			vaddr += PAGE_SIZE * page_step;
>> +			iova += PAGE_SIZE * page_step;
>> +			batch->offset += page_step;
>> +			batch->size -= page_step;
>>  
>>  			if (!batch->size)
>>  				break;
>
>Why is something like below (untested) not sufficient?
>
>NB. (vaddr - folio_address()) still needs some scrutiny to determine if
>it's valid.
>
>@@ -681,32 +692,40 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
> 		 * and rsvd here, and therefore continues to use the batch.
> 		 */
> 		while (true) {
>+			struct folio *folio = page_folio(batch->pages[batch->offset]);
>+			long nr_pages;
>+
> 			if (pfn != *pfn_base + pinned ||
> 			    rsvd != is_invalid_reserved_pfn(pfn))
> 				goto out;
> 
>+			nr_pages = min(batch->size, folio_nr_pages(folio) -
>+						folio_page_idx(folio, batch->pages[batch->offset]);
>+			if (nr_pages > 1 && vfio_find_vpfn_range(dma, iova, nr_pages))
>+				nr_pages = 1;
>+
> 			/*
> 			 * Reserved pages aren't counted against the user,
> 			 * externally pinned pages are already counted against
> 			 * the user.
> 			 */
>-			if (!rsvd && !vfio_find_vpfn(dma, iova)) {
>+			if (!rsvd && (nr_pages > 1 || !vfio_find_vpfn(dma, iova))) {
> 				if (!dma->lock_cap &&
>-				    mm->locked_vm + lock_acct + 1 > limit) {
>+				    mm->locked_vm + lock_acct + nr_pages > limit) {
> 					pr_warn("%s: RLIMIT_MEMLOCK (%ld) exceeded\n",
> 						__func__, limit << PAGE_SHIFT);
> 					ret = -ENOMEM;
> 					goto unpin_out;
> 				}
>-				lock_acct++;
>+				lock_acct += nr_pages;
> 			}
> 
>-			pinned++;
>-			npage--;
>-			vaddr += PAGE_SIZE;
>-			iova += PAGE_SIZE;
>-			batch->offset++;
>-			batch->size--;
>+			pinned += nr_pages;
>+			npage -= nr_pages;
>+			vaddr += PAGE_SIZE * nr_pages;
>+			iova += PAGE_SIZE * nr_pages;
>+			batch->offset += nr_pages;
>+			batch->size -= nr_pages;
> 
> 			if (!batch->size)
> 				break;

The input parameter vaddr is a user-space address, while folio_address()
returns a kernel space address. I agree that using folio_page_idx() is
the best approach.

This approach indeed simplifies things a lot. I have conducted basic
functionality tests on it and have not found any issues. Please allow me
to integrate it into the v3 patch. Thanks!

