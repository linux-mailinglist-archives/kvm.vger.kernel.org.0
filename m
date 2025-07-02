Return-Path: <kvm+bounces-51249-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C8E7EAF0962
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 05:47:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 666D03B8623
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 03:47:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF5911DE881;
	Wed,  2 Jul 2025 03:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="O7om+5jU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CCE12629D
	for <kvm@vger.kernel.org>; Wed,  2 Jul 2025 03:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751428050; cv=none; b=sysKUuyaFz5D6pXT5IBV5bkyHxvrQSTBD7cju9hboZu/kvKIuylfk7amb6698geC/ymL6m2C6zNfOjK8CNpr20dde0et8z0EfDZuHeObdjOaffRi0VP5KDmN17q+2ontvaVJQeRddszTnwsEQL/NK/LlgJCqfL0Bzfapas3EtCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751428050; c=relaxed/simple;
	bh=UvasDVD1l8IAV6VDhCrREMXxQz6oobsXtjpYcXI2+vA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=or1/4xVm2cwDYyk70zQ5Dmwp4V8GGUXdbKs6XSfYSDKcoM67EUIJI9/3lF2bchCHZwaGubO9rm0x891UcMRcMOXjhYEFzBiOUmUqUq96Yhh+cJMsMirzw0xZRZ2Kz0K2sGqNLySRJ19w1MtueTkhjsFl9vfM8CP5Mj97HeEkfp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=O7om+5jU; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-22c33677183so54498955ad.2
        for <kvm@vger.kernel.org>; Tue, 01 Jul 2025 20:47:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1751428048; x=1752032848; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Kexqqmx3bPtand0ohHNJ0SqRsuizuyI7ooeqf8i3LGA=;
        b=O7om+5jUVAGxd9zl6qg6PtXZOulEy5xDIXkLsQnh8LUuB/15t7M12ggjwBuOYVAtRG
         kv0VKkYMiCxBTocthaZIUUcPN2ZGDc/n8htzDYCi69+JSAhjNfNA4HoZJkLn2Y+vVx/W
         mLR5RyAX8DJctpFpjyXa/mYIDxEf4iKWj6mo0klF7DQ8Zw7LgT/0A3hYAz1rGj+WI4jW
         ZT3Q2vcS+ASaHXPIFyLSWOa7F0EsbGPyrM3f0Wzugzhl/xgbCbczCcMrrTGXJ4BFKBez
         rIvy0w+vdfIj+f0kdbhJoRKSYz17SYLZkqoflRd7ipQUcgsl69XpKjhnNojcZnd9qHNF
         L3bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751428048; x=1752032848;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Kexqqmx3bPtand0ohHNJ0SqRsuizuyI7ooeqf8i3LGA=;
        b=ChoO9cqSOV0MuuJySZ2spa1Boc/Ce2Bwi3PJD6uBzDnqF8Q4TgmKdI+mzKPUAFs2ss
         BV3zwdlt5rAHreWPC5PCj63oZntDDVxrFNmVdOc5EPsd407TFBhiLb0n2JaG0PBphuFu
         JEi2c/tC8UDgp8VlZsjy+tpckGZqYW7k3gmIo6Lyl6drOthJfrZ8fQIXJCYsdgM2nRO9
         ADOid+D5wuUp/22iKdNUPLS8miNfKoSOu6eVpjiZMVVZ6FAgpNjGedIxjrBD7J5xRfux
         3dSLcDp9DbuO0A6/oO0b4DpLPPW+b8jF1CN41rTm2UYzpNoxPFXc4nTgioZZ3tI81LkI
         yHHg==
X-Forwarded-Encrypted: i=1; AJvYcCWuDrfKtVpoJENiQcBGVdOui/Jy5tSvHz27swjD5kZpmmZtQ+JAEgcFztjn8UzFeHIH2VM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzkvPBuzkv7F1Tg3iM1vWFMLqLNA5q5TZd96vQ+LD5nVVDZv+78
	LfJ0NLq5RQXfOu4yTlyvSb+5NVLXJuZZ6uiXxpGsENVmdzHN4vq0k5I4pmyOXQFmh58=
X-Gm-Gg: ASbGncu1ZdvSdYTLvAl8y/VpaLW6TgEehWWTHzYLHzgs8wlkHLjCtHNdN50A45vULkN
	/MPRAFYQ3nQgXMqGxmEj0AzuXBA9R5mzx4xclwNUNmbNZJEvpcZIorxcR4n55nMbeui3MbmKzAB
	3vCDqE/cAF8K/PZocQwFOEaQ6IKNZOREbgzb81uPWswOrYi7W39UoOtjgtY6f1KhptozgMvJ5EM
	LQB4LXzr5gu2Rw/aWz7W+RIXIKNItA48QOd/KUlUrf52E9R7/mQHbMKaZ883IZElRgcVt4V55ta
	Yyr6RlgJHRsxjYmo8H9MkTUJ8+rLXJgLYQ+31s7QEbkLRgTYmj77jzjyw3i4g0qui8kv+MecGCL
	Vk+XOf9s7Htb9nw==
X-Google-Smtp-Source: AGHT+IG5k/sGS6ZTbC1NnWIrkklDYe/239zASpSpq/5gVtSrILKpH7fBevk4fAKdNzplcIqjDd8i+g==
X-Received: by 2002:a17:902:db05:b0:235:2403:779f with SMTP id d9443c01a7336-23c6e5f4c50mr16191305ad.29.1751428048147;
        Tue, 01 Jul 2025 20:47:28 -0700 (PDT)
Received: from localhost.localdomain ([203.208.189.14])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23acb3acbf5sm117298665ad.144.2025.07.01.20.47.23
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 01 Jul 2025 20:47:27 -0700 (PDT)
From: lizhe.67@bytedance.com
To: dan.carpenter@linaro.org
Cc: alex.williamson@redhat.com,
	david@redhat.com,
	jgg@ziepe.ca,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lizhe.67@bytedance.com,
	lkp@intel.com,
	oe-kbuild-all@lists.linux.dev,
	oe-kbuild@lists.linux.dev,
	peterx@redhat.com
Subject: Re: [PATCH 3/4] vfio/type1: introduce a new member has_rsvd for struct vfio_dma
Date: Wed,  2 Jul 2025 11:47:20 +0800
Message-ID: <20250702034720.53574-1-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <c209cfd6-05b1-4491-91ce-c672414d718c@suswa.mountain>
References: <c209cfd6-05b1-4491-91ce-c672414d718c@suswa.mountain>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 1 Jul 2025 18:13:48 +0300, dan.carpenter@linaro.org wrote:

> New smatch warnings:
> drivers/vfio/vfio_iommu_type1.c:788 vfio_pin_pages_remote() error: uninitialized symbol 'rsvd'.
> 
> Old smatch warnings:
> drivers/vfio/vfio_iommu_type1.c:2376 vfio_iommu_type1_attach_group() warn: '&group->next' not removed from list
> 
> vim +/rsvd +788 drivers/vfio/vfio_iommu_type1.c
> 
> 8f0d5bb95f763c Kirti Wankhede  2016-11-17  684  static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
> 0635559233434a Alex Williamson 2025-02-18  685  				  unsigned long npage, unsigned long *pfn_base,
> 4b6c33b3229678 Daniel Jordan   2021-02-19  686  				  unsigned long limit, struct vfio_batch *batch)
> 73fa0d10d077d9 Alex Williamson 2012-07-31  687  {
> 4d83de6da265cd Daniel Jordan   2021-02-19  688  	unsigned long pfn;
> 4d83de6da265cd Daniel Jordan   2021-02-19  689  	struct mm_struct *mm = current->mm;
> 6c38c055cc4c0a Alex Williamson 2016-12-30  690  	long ret, pinned = 0, lock_acct = 0;
> 89c29def6b0101 Alex Williamson 2018-06-02  691  	bool rsvd;
> a54eb55045ae9b Kirti Wankhede  2016-11-17  692  	dma_addr_t iova = vaddr - dma->vaddr + dma->iova;
> 166fd7d94afdac Alex Williamson 2013-06-21  693  
> 6c38c055cc4c0a Alex Williamson 2016-12-30  694  	/* This code path is only user initiated */
> 4d83de6da265cd Daniel Jordan   2021-02-19  695  	if (!mm)
> 166fd7d94afdac Alex Williamson 2013-06-21  696  		return -ENODEV;
> 73fa0d10d077d9 Alex Williamson 2012-07-31  697  
> 4d83de6da265cd Daniel Jordan   2021-02-19  698  	if (batch->size) {
> 4d83de6da265cd Daniel Jordan   2021-02-19  699  		/* Leftover pages in batch from an earlier call. */
> 4d83de6da265cd Daniel Jordan   2021-02-19  700  		*pfn_base = page_to_pfn(batch->pages[batch->offset]);
> 4d83de6da265cd Daniel Jordan   2021-02-19  701  		pfn = *pfn_base;
> 89c29def6b0101 Alex Williamson 2018-06-02  702  		rsvd = is_invalid_reserved_pfn(*pfn_base);

When batch->size is not zero, we initialize rsvd here.

> 4d83de6da265cd Daniel Jordan   2021-02-19  703  	} else {
> 4d83de6da265cd Daniel Jordan   2021-02-19  704  		*pfn_base = 0;

When the value of batch->size is zero, we set the value of *pfn_base
to zero and do not initialize rsvd for the time being.

> 5c6c2b21ecc9ad Alex Williamson 2013-06-21  705  	}
> 5c6c2b21ecc9ad Alex Williamson 2013-06-21  706  
> eb996eec783c1e Alex Williamson 2025-02-18  707  	if (unlikely(disable_hugepages))
> eb996eec783c1e Alex Williamson 2025-02-18  708  		npage = 1;
> eb996eec783c1e Alex Williamson 2025-02-18  709  
> 4d83de6da265cd Daniel Jordan   2021-02-19  710  	while (npage) {
> 4d83de6da265cd Daniel Jordan   2021-02-19  711  		if (!batch->size) {
> 4d83de6da265cd Daniel Jordan   2021-02-19  712  			/* Empty batch, so refill it. */
> eb996eec783c1e Alex Williamson 2025-02-18  713  			ret = vaddr_get_pfns(mm, vaddr, npage, dma->prot,
> eb996eec783c1e Alex Williamson 2025-02-18  714  					     &pfn, batch);
> be16c1fd99f41a Daniel Jordan   2021-02-19  715  			if (ret < 0)
> 4d83de6da265cd Daniel Jordan   2021-02-19  716  				goto unpin_out;
> 166fd7d94afdac Alex Williamson 2013-06-21  717  
> 4d83de6da265cd Daniel Jordan   2021-02-19  718  			if (!*pfn_base) {
> 4d83de6da265cd Daniel Jordan   2021-02-19  719  				*pfn_base = pfn;
> 4d83de6da265cd Daniel Jordan   2021-02-19  720  				rsvd = is_invalid_reserved_pfn(*pfn_base);

Therefore, for the first loop, when batch->size is zero, *pfn_base must
be zero, which will then lead to the initialization of rsvd.

> 4d83de6da265cd Daniel Jordan   2021-02-19  721  			}
> 
> If "*pfn_base" is true then "rsvd" is uninitialized.
> 
> eb996eec783c1e Alex Williamson 2025-02-18  722  
> eb996eec783c1e Alex Williamson 2025-02-18  723  			/* Handle pfnmap */
> eb996eec783c1e Alex Williamson 2025-02-18  724  			if (!batch->size) {
> eb996eec783c1e Alex Williamson 2025-02-18  725  				if (pfn != *pfn_base + pinned || !rsvd)
> eb996eec783c1e Alex Williamson 2025-02-18  726  					goto out;
> 
> goto out;
> 
> eb996eec783c1e Alex Williamson 2025-02-18  727  
> eb996eec783c1e Alex Williamson 2025-02-18  728  				pinned += ret;
> eb996eec783c1e Alex Williamson 2025-02-18  729  				npage -= ret;
> eb996eec783c1e Alex Williamson 2025-02-18  730  				vaddr += (PAGE_SIZE * ret);
> eb996eec783c1e Alex Williamson 2025-02-18  731  				iova += (PAGE_SIZE * ret);
> eb996eec783c1e Alex Williamson 2025-02-18  732  				continue;
> eb996eec783c1e Alex Williamson 2025-02-18  733  			}
> 166fd7d94afdac Alex Williamson 2013-06-21  734  		}
> 166fd7d94afdac Alex Williamson 2013-06-21  735  
> 4d83de6da265cd Daniel Jordan   2021-02-19  736  		/*
> eb996eec783c1e Alex Williamson 2025-02-18  737  		 * pfn is preset for the first iteration of this inner loop
> eb996eec783c1e Alex Williamson 2025-02-18  738  		 * due to the fact that vaddr_get_pfns() needs to provide the
> eb996eec783c1e Alex Williamson 2025-02-18  739  		 * initial pfn for pfnmaps.  Therefore to reduce redundancy,
> eb996eec783c1e Alex Williamson 2025-02-18  740  		 * the next pfn is fetched at the end of the loop.
> eb996eec783c1e Alex Williamson 2025-02-18  741  		 * A PageReserved() page could still qualify as page backed
> eb996eec783c1e Alex Williamson 2025-02-18  742  		 * and rsvd here, and therefore continues to use the batch.
> 4d83de6da265cd Daniel Jordan   2021-02-19  743  		 */
> 4d83de6da265cd Daniel Jordan   2021-02-19  744  		while (true) {
> 6a2d9b72168041 Li Zhe          2025-06-30  745  			long nr_pages, acct_pages = 0;
> 6a2d9b72168041 Li Zhe          2025-06-30  746  
> 4d83de6da265cd Daniel Jordan   2021-02-19  747  			if (pfn != *pfn_base + pinned ||
> 4d83de6da265cd Daniel Jordan   2021-02-19  748  			    rsvd != is_invalid_reserved_pfn(pfn))
> 4d83de6da265cd Daniel Jordan   2021-02-19  749  				goto out;
> 4d83de6da265cd Daniel Jordan   2021-02-19  750  
> 6a2d9b72168041 Li Zhe          2025-06-30  751  			nr_pages = contig_pages(dma, batch, iova);
> 6a2d9b72168041 Li Zhe          2025-06-30  752  			if (!rsvd) {
> 6a2d9b72168041 Li Zhe          2025-06-30  753  				acct_pages = nr_pages;
> 6a2d9b72168041 Li Zhe          2025-06-30  754  				acct_pages -= vpfn_pages(dma, iova, nr_pages);
> 6a2d9b72168041 Li Zhe          2025-06-30  755  			}
> 6a2d9b72168041 Li Zhe          2025-06-30  756  
> 4d83de6da265cd Daniel Jordan   2021-02-19  757  			/*
> 4d83de6da265cd Daniel Jordan   2021-02-19  758  			 * Reserved pages aren't counted against the user,
> 4d83de6da265cd Daniel Jordan   2021-02-19  759  			 * externally pinned pages are already counted against
> 4d83de6da265cd Daniel Jordan   2021-02-19  760  			 * the user.
> 4d83de6da265cd Daniel Jordan   2021-02-19  761  			 */
> 6a2d9b72168041 Li Zhe          2025-06-30  762  			if (acct_pages) {
> 48d8476b41eed6 Alex Williamson 2018-05-11  763  				if (!dma->lock_cap &&
> 6a2d9b72168041 Li Zhe          2025-06-30  764  						mm->locked_vm + lock_acct + acct_pages > limit) {
> 6c38c055cc4c0a Alex Williamson 2016-12-30  765  					pr_warn("%s: RLIMIT_MEMLOCK (%ld) exceeded\n",
> 6c38c055cc4c0a Alex Williamson 2016-12-30  766  						__func__, limit << PAGE_SHIFT);
> 0cfef2b7410b64 Alex Williamson 2017-04-13  767  					ret = -ENOMEM;
> 0cfef2b7410b64 Alex Williamson 2017-04-13  768  					goto unpin_out;
> 166fd7d94afdac Alex Williamson 2013-06-21  769  				}
> 6a2d9b72168041 Li Zhe          2025-06-30  770  				lock_acct += acct_pages;
> a54eb55045ae9b Kirti Wankhede  2016-11-17  771  			}
> 4d83de6da265cd Daniel Jordan   2021-02-19  772  
> 6a2d9b72168041 Li Zhe          2025-06-30  773  			pinned += nr_pages;
> 6a2d9b72168041 Li Zhe          2025-06-30  774  			npage -= nr_pages;
> 6a2d9b72168041 Li Zhe          2025-06-30  775  			vaddr += PAGE_SIZE * nr_pages;
> 6a2d9b72168041 Li Zhe          2025-06-30  776  			iova += PAGE_SIZE * nr_pages;
> 6a2d9b72168041 Li Zhe          2025-06-30  777  			batch->offset += nr_pages;
> 6a2d9b72168041 Li Zhe          2025-06-30  778  			batch->size -= nr_pages;
> 4d83de6da265cd Daniel Jordan   2021-02-19  779  
> 4d83de6da265cd Daniel Jordan   2021-02-19  780  			if (!batch->size)
> 4d83de6da265cd Daniel Jordan   2021-02-19  781  				break;
> 4d83de6da265cd Daniel Jordan   2021-02-19  782  
> 4d83de6da265cd Daniel Jordan   2021-02-19  783  			pfn = page_to_pfn(batch->pages[batch->offset]);
> 4d83de6da265cd Daniel Jordan   2021-02-19  784  		}
> a54eb55045ae9b Kirti Wankhede  2016-11-17  785  	}
> 166fd7d94afdac Alex Williamson 2013-06-21  786  
> 6c38c055cc4c0a Alex Williamson 2016-12-30  787  out:
> 20448310d6b71d Li Zhe          2025-06-30 @788  	dma->has_rsvd |= rsvd;
>                                                                        ^^^^

In summary, it is likely to be a false alarm.
Please correct me if I am wrong.

Thanks,
Zhe

