Return-Path: <kvm+bounces-47355-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F7A7AC0701
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 10:25:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7901D7A81FA
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 08:24:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F6D1267F53;
	Thu, 22 May 2025 08:25:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="LEmP9An7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D161211F
	for <kvm@vger.kernel.org>; Thu, 22 May 2025 08:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747902333; cv=none; b=rcdsgOazTM8lRMo6Ow/14/Cg8Vnq4NGM7acyNGkO9P+3JJqlubP8L2F6GCax+PXlfp4BkWqnsyMhdJFdRgiYwJYbLckx8MhRqR9qPLAh76a18Bo/LYXmqE4G5d5nQv/NdrvOeNBwtrsmv2Ec8SwSRWq+P2K4zpo8lhU1Kbkpn1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747902333; c=relaxed/simple;
	bh=vo2rjWtUTpmYs1KbI1Arsz3ie3i7WCRJwXfV5miYmHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j/ksPGKP1MGV6mFElB5vCrvmdpDvm0sp7Rp2g9egQsTz8HPvTRCWNViILZpmC69apV7ZGAFoISyysEeQKwjfUpTHCYDUM9E2L6M2MTUk2ASJ8vX+IBP/MIY3IPTj/0RqLvSWXk0qa8j8SkNd700awD5yWHEVYrQ+HFy6XsbhqJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=LEmP9An7; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-7425bd5a83aso7583145b3a.0
        for <kvm@vger.kernel.org>; Thu, 22 May 2025 01:25:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1747902330; x=1748507130; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XXT3T1yAeHiQt/njGr5efX24PkdGfFV5UElyW1G3TFM=;
        b=LEmP9An7D20vCW9IsSseZWTexlLAQaaxShAJJ4jVjpPSttbuBGrDJkDd9TcKeMNJRX
         cdGjt+T+iHPCAGoJziXH0VSCZp4hum4gOH0a+Ykz0dzqFAnv54fBed8hMqdvywFbNL08
         fyVetYi/nLVobnmxkKHkLHKcn0Y9t4TiYepOonxmW6Q0zrT8NiSX3ule51HqQ6lrm38B
         5p0/FI0VzfeBC58T6/8Xo6mQOaHcMabE0+BzXoP7e8HpvefBia8lF/8/vVbSOmYmnOS8
         kCl01641nMBt2ba7mMhqIAZxX2fGHLKFg84mGbw+YKB1FlztvCGS2fQf80THmVGEq/2M
         Zvjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747902330; x=1748507130;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XXT3T1yAeHiQt/njGr5efX24PkdGfFV5UElyW1G3TFM=;
        b=wiT9ZioTIyFqrjG60BhMJyTIMbanxuTZMmrlgBpfl/DQi1ISWGejYOhibCh8oRlDQj
         69oAlWt0qDiqtwSRillonu+o6vgkfYqmxt4xjJ9lvUQbrMkbDpNYMALCt6AL8fXHs94G
         K1iq2nsDGY892BrDwvdDgmnpkdS/k6stz7AIVhVHuE7eehct3nToI1pOXQuCtjBSERxr
         8L7YBgb3Saa4eDECrXbkMxTFwU9sM3/WnN73wIsAnrWeUnLnOU7GfgeWJsW3oWyatlbg
         U7mzZG1j5ZDsksIbr0z3tdTAkWr01VxvKxd7zzjJm+eaPlh/MacfmLG2axRoB7NwLMkT
         bFXg==
X-Forwarded-Encrypted: i=1; AJvYcCWYQO8qTxB7UGngJ9RiB+i8a7gPks9VbyFY/uGcBoCyJ/+owNu8rbwMhqJ+Mnsb1AA5mLk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxKskdgn3hQ8ne5ssIkjOcx+e0Jr9CEunddV8+lekjO/9cymls0
	wXgNTqcOc9mLBIpea0gIOBt5JNRmffLnd/JtEsrt7Hjm28KvyQmiSEH5rw2QCa71dlw=
X-Gm-Gg: ASbGnct2FBg7fEVxfvsj509fEbN9QsKJULZrOpdzEv3QekQ3ESJ6HzqDCVjzSQLiya9
	rnvMkUIszGWpnEW6+dL3vOYHskkliyjW3wt8liTMlsIhMEpy/pyRJS1nyocTRd7fpAz7IjQw3Bt
	A3I6tplJilW2mX91z85/x0hPLmJejmq1/cAI8te+VZZI4thvPTY3s09I5u43PL58w7o7rDN9fH9
	RTP4rrEOSc4j1ljgGL/y50O5Iyb+AgzHznr6ZZIVrQt/yGsP8bVKk74cu3/tUoNXxPM/4nOCiAI
	VJLAZpBT4zgry0EXCoYZo39eyeV1sellERgAxRIZ6SSKt78Iq2+LbqD10QSU4kHB64yj7OWgvnP
	V2A==
X-Google-Smtp-Source: AGHT+IFog76TSsUXHJmLNFDQxP4BmwEUI8rnDjgaiaHaf7T0e0+s3zpozYerKMn4OCmUxJqa3IbCdw==
X-Received: by 2002:a05:6a21:9012:b0:216:19c1:1f54 with SMTP id adf61e73a8af0-2162188b866mr34190925637.4.1747902330240;
        Thu, 22 May 2025 01:25:30 -0700 (PDT)
Received: from localhost.localdomain ([203.208.189.7])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-742a970d5f0sm11145399b3a.56.2025.05.22.01.25.27
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 22 May 2025 01:25:29 -0700 (PDT)
From: lizhe.67@bytedance.com
To: david@redhat.com
Cc: alex.williamson@redhat.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lizhe.67@bytedance.com,
	muchun.song@linux.dev,
	peterx@redhat.com
Subject: Re: [PATCH v4] vfio/type1: optimize vfio_pin_pages_remote() for large folio
Date: Thu, 22 May 2025 16:25:24 +0800
Message-ID: <20250522082524.75076-1-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <81d73c4c-28c4-4fa0-bc71-aef6429e2c31@redhat.com>
References: <81d73c4c-28c4-4fa0-bc71-aef6429e2c31@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, 22 May 2025 09:22:50 +0200, david@redhat.com wrote:

>On 22.05.25 05:49, lizhe.67@bytedance.com wrote:
>> On Wed, 21 May 2025 13:17:11 -0600, alex.williamson@redhat.com wrote:
>> 
>>>> From: Li Zhe <lizhe.67@bytedance.com>
>>>>
>>>> When vfio_pin_pages_remote() is called with a range of addresses that
>>>> includes large folios, the function currently performs individual
>>>> statistics counting operations for each page. This can lead to significant
>>>> performance overheads, especially when dealing with large ranges of pages.
>>>>
>>>> This patch optimize this process by batching the statistics counting
>>>> operations.
>>>>
>>>> The performance test results for completing the 8G VFIO IOMMU DMA mapping,
>>>> obtained through trace-cmd, are as follows. In this case, the 8G virtual
>>>> address space has been mapped to physical memory using hugetlbfs with
>>>> pagesize=2M.
>>>>
>>>> Before this patch:
>>>> funcgraph_entry:      # 33813.703 us |  vfio_pin_map_dma();
>>>>
>>>> After this patch:
>>>> funcgraph_entry:      # 16071.378 us |  vfio_pin_map_dma();
>>>>
>>>> Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
>>>> Co-developed-by: Alex Williamson <alex.williamson@redhat.com>
>>>> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
>>>> ---
>>>
>>> Given the discussion on v3, this is currently a Nak.  Follow-up in that
>>> thread if there are further ideas how to salvage this.  Thanks,
>> 
>> How about considering the solution David mentioned to check whether the
>> pages or PFNs are actually consecutive?
>> 
>> I have conducted a preliminary attempt, and the performance testing
>> revealed that the time consumption is approximately 18,000 microseconds.
>> Compared to the previous 33,000 microseconds, this also represents a
>> significant improvement.
>> 
>> The modification is quite straightforward. The code below reflects the
>> changes I have made based on this patch.
>> 
>> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
>> index bd46ed9361fe..1cc1f76d4020 100644
>> --- a/drivers/vfio/vfio_iommu_type1.c
>> +++ b/drivers/vfio/vfio_iommu_type1.c
>> @@ -627,6 +627,19 @@ static long vaddr_get_pfns(struct mm_struct *mm, unsigned long vaddr,
>>          return ret;
>>   }
>>   
>> +static inline long continuous_page_num(struct vfio_batch *batch, long npage)
>> +{
>> +       long i;
>> +       unsigned long next_pfn = page_to_pfn(batch->pages[batch->offset]) + 1;
>> +
>> +       for (i = 1; i < npage; ++i) {
>> +               if (page_to_pfn(batch->pages[batch->offset + i]) != next_pfn)
>> +                       break;
>> +               next_pfn++;
>> +       }
>> +       return i;
>> +}
>
>
>What might be faster is obtaining the folio, and then calculating the 
>next expected page pointer, comparing whether the page pointers match.
>
>Essentially, using folio_page() to calculate the expected next page.
>
>nth_page() is a simple pointer arithmetic with CONFIG_SPARSEMEM_VMEMMAP, 
>so that might be rather fast.
>
>
>So we'd obtain
>
>start_idx = folio_idx(folio, batch->pages[batch->offset]);

Do you mean using folio_page_idx()?

>and then check for
>
>batch->pages[batch->offset + i] == folio_page(folio, start_idx + i)

Thank you for your reminder. This is indeed a better solution.
The updated code might look like this:

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index bd46ed9361fe..f9a11b1d8433 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -627,6 +627,20 @@ static long vaddr_get_pfns(struct mm_struct *mm, unsigned long vaddr,
        return ret;
 }
 
+static inline long continuous_pages_num(struct folio *folio,
+               struct vfio_batch *batch, long npage)
+{
+       long i;
+       unsigned long start_idx =
+                       folio_page_idx(folio, batch->pages[batch->offset]);
+
+       for (i = 1; i < npage; ++i)
+               if (batch->pages[batch->offset + i] !=
+                               folio_page(folio, start_idx + i))
+                       break;
+       return i;
+}
+
 /*
  * Attempt to pin pages.  We really don't want to track all the pfns and
  * the iommu can only map chunks of consecutive pfns anyway, so get the
@@ -708,8 +722,12 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
                         */
                        nr_pages = min_t(long, batch->size, folio_nr_pages(folio) -
                                                folio_page_idx(folio, batch->pages[batch->offset]));
-                       if (nr_pages > 1 && vfio_find_vpfn_range(dma, iova, nr_pages))
-                               nr_pages = 1;
+                       if (nr_pages > 1) {
+                               if (vfio_find_vpfn_range(dma, iova, nr_pages))
+                                       nr_pages = 1;
+                               else
+                                       nr_pages = continuous_pages_num(folio, batch, nr_pages);
+                       }
 
                        /*
                         * Reserved pages aren't counted against the user,

Thanks,
Zhe

