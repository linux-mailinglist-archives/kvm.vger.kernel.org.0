Return-Path: <kvm+bounces-54109-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DC05B1C5EF
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 14:35:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 77881174220
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 12:35:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77EC5221F1A;
	Wed,  6 Aug 2025 12:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QKyZl9Nl"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70B0425A343
	for <kvm@vger.kernel.org>; Wed,  6 Aug 2025 12:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754483724; cv=none; b=Hp9L/mDDsN9POtjamaPd1BmhHefxxRePm680amhHsjcadaOdkycNaHn3fM6cGBsT8L+hlEs65MjlDNoDlNmw8O64wdN3/m8V3hC1MVuT+AUYQ99IRyCOD1rMc99mFbQfXbfjFicYfOBlAoBEHIJRQhJeh+ueANDZbXAZHUkhfgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754483724; c=relaxed/simple;
	bh=ENhbweQymxJDox7D9deCLc4j/i4nT5fmTKJJUjeyWGk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TMCYHaLbMzTZw4OJJb3N6aZHrU2/C5Ns/xioMc8mSIrjcZBBe9b+WhLxpaxZnO9PiFID2fdSGtgseyxYqiMFlA+Id9XxOvj3XQC9xSiF6BdRVI5DFGRjMZf4a/a0BTzwrL/hEiYi7ob8LptbVe5MIS+l4I/VGwkdaqeOyGSkGMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QKyZl9Nl; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754483720;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=s08E3tSdjNKq9O/UJ8z8+/56vyGqZo8p6vY1ZTOtZis=;
	b=QKyZl9Nl2cbbr7zQiOdZj2SEkl4Py0Rf5ZT+kHowGygF1gHqSpsfoK6A1/DOO61lz8QlDW
	io4jz/e6d7OaRaavMkTPGQIB5P9I4F+H8Wgm705shXfMOAEt9A6LBc4O3uZFTurwMs4StZ
	47RrP9MdNKRmK/vava1CJ3SwSEgUXjk=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-208-MrI_2kvrPUSWAVlbf0hPrw-1; Wed, 06 Aug 2025 08:35:18 -0400
X-MC-Unique: MrI_2kvrPUSWAVlbf0hPrw-1
X-Mimecast-MFC-AGG-ID: MrI_2kvrPUSWAVlbf0hPrw_1754483718
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3a54a8a0122so2737320f8f.2
        for <kvm@vger.kernel.org>; Wed, 06 Aug 2025 05:35:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754483717; x=1755088517;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=s08E3tSdjNKq9O/UJ8z8+/56vyGqZo8p6vY1ZTOtZis=;
        b=TFhpKguDs8uzS5LEF7ywP4NE08EsBw3hHZOm55vxmJkDIKeJ2DDtupWlT/sTbMN4fz
         jx+m8jzD0Ay2dKFzy44XoA8S3lJ35BKvEZtZFY530Nso+zqKxRJx9E+u6wlw0OOlhESM
         rlDdCLh/QuHHKVKHBYUxE/+S2wCM1xzW+C4ua9bUEhdNM6nfgPUEFdD++dthQz1IrW8J
         nuSE0fgI0dLfY6C9o4UxgwIUbdjEVAbu+gSgju76VQqYhAOfMKqb4w6qwlEj3MsAO5Fk
         d2CFT9aaDuiiHgQPBwcB04MdjIB/SJyzx6txI4ee+HDQmU3q6wwYbBlr0PSCCUjUGosI
         vn+g==
X-Forwarded-Encrypted: i=1; AJvYcCUXSQW59mLIL32/6H9L6CJ0YaepPksAQiWNqlZ5su9kjE7DWtqcfxs0lR9H64kQBGdoPr0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyBEKM7Tr3SpYGMJZOKw6j2HpnKURIpa1DgH7fSyoSmnMrrJX2x
	EBLZomQwcxBD9wXv5bWsA3TuBpsL5wJFwQkU0t/w+sqpNK8s0/BiCyVODAY6BC5WtHnlAf8dyQP
	AgmrcAdi2Pr22xuIv78UxiIySXWdoyWalT+w3BZySkjjAgxzzqSRuww==
X-Gm-Gg: ASbGncsb77k4XvzsynkXOmWhavoszTUPWKQ+duR5FUi6GImHbNszFVx7UdwGRtb9/rq
	2qZsb2fqJZQEfkUx8Kk3a/w4TDXfwjhOMYVySFvY9BPnVBg5VU/W30e7BVhIYAVL73vfmW14by7
	0B0SRz2CTWYHBxPvg03IZ4f88MhMh3UX+g3ZZSJDWNTixx8iZn8o0Qq7rb4bb49pBoqNYWyDMV5
	g+uZ0wyf+1+YN8z/AHz+1H4dpVu2yOFuWMm4k3g4JWpBPwMGAp5FJNvs/+T+wWQX7K5XO62Udpt
	JUyVmczH3LFZxjtF4BNpYtT33ZdzxY6CbVHxFO8scg7rt7YAiK8XV0EGGqxK8LNaxq9Hbd6UiSh
	F3nrnsYQwM3Rb+i58uvtTcB6B1aKSXANyj21+culfDh4Ng+TEAtEveq03//DTdpIHbxA=
X-Received: by 2002:a05:6000:4282:b0:3b7:9a3f:29a9 with SMTP id ffacd0b85a97d-3b8f41c7e52mr2058588f8f.31.1754483717463;
        Wed, 06 Aug 2025 05:35:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEN/wTStMrxvrQ60WFTVQE6TttxeZ9kfKdsSQOEzfAh/sMuQyPvQDwKS/tG62xppA050r9bBA==
X-Received: by 2002:a05:6000:4282:b0:3b7:9a3f:29a9 with SMTP id ffacd0b85a97d-3b8f41c7e52mr2058557f8f.31.1754483716937;
        Wed, 06 Aug 2025 05:35:16 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f35:8a00:42f7:2657:34cc:a51f? (p200300d82f358a0042f7265734cca51f.dip0.t-ipconnect.de. [2003:d8:2f35:8a00:42f7:2657:34cc:a51f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-458bd5a11d3sm93405215e9.0.2025.08.06.05.35.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Aug 2025 05:35:16 -0700 (PDT)
Message-ID: <f4c464d0-2a98-4c17-8b56-abf86fd15215@redhat.com>
Date: Wed, 6 Aug 2025 14:35:15 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] vfio/type1: Absorb num_pages_contiguous()
To: Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org
Cc: Jason Gunthorpe <jgg@nvidia.com>, Li Zhe <lizhe.67@bytedance.com>,
 Linus Torvalds <torvalds@linux-foundation.org>
References: <20250805012442.3285276-1-alex.williamson@redhat.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <20250805012442.3285276-1-alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 05.08.25 03:24, Alex Williamson wrote:
> Objections were raised to adding this helper to common code with only a
> single user and dubious generalism.  Pull it back into subsystem code.
> 
> Link: https://lore.kernel.org/all/CAHk-=whhYRMS7Xc9k_JBdrGvp++JLmU0T2xXEgn046hWrj7q8Q@mail.gmail.com/
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Jason Gunthorpe <jgg@nvidia.com>
> Cc: Li Zhe <lizhe.67@bytedance.com>
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---

So, I took the original patch and
* moved the code to mm_inline.h (sounds like a better fit)
* Tweaked the patch description
* Tweaked the documentation and turned it into proper kerneldoc
* Made the function return "size_t" as well
* Use the page_to_section() trick to avoid nth_page().

Only compile-tested so far. Still running it through some cross compiles.


 From 36d67849bfdbc184990f21464c53585d35648616 Mon Sep 17 00:00:00 2001
From: Li Zhe <lizhe.67@bytedance.com>
Date: Thu, 10 Jul 2025 16:53:51 +0800
Subject: [PATCH] mm: introduce num_pages_contiguous()

Let's add a simple helper for determining the number of contiguous pages
that represent contiguous PFNs.

In an ideal world, this helper would be simpler or not even required.
Unfortunately, on some configs we still have to maintain (SPARSEMEM
without VMEMMAP), the memmap is allocated per memory section, and we might
run into weird corner cases of false positives when blindly testing for
contiguous pages only.

One example of such false positives would be a memory section-sized hole
that does not have a memmap. The surrounding memory sections might get
"struct pages" that are contiguous, but the PFNs are actually not.

This helper will, for example, be useful for determining contiguous PFNs
in a GUP result, to batch further operations across returned "struct
page"s. VFIO will utilize this interface to accelerate the VFIO DMA map
process.

Implementation based on Linus' suggestions to avoid new usage of
nth_page() where avoidable.

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Suggested-by: Jason Gunthorpe <jgg@ziepe.ca>
Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
Co-developed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
  include/linux/mm.h        |  7 ++++++-
  include/linux/mm_inline.h | 35 +++++++++++++++++++++++++++++++++++
  2 files changed, 41 insertions(+), 1 deletion(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index fa538feaa8d95..2852bcd792745 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1759,7 +1759,12 @@ static inline unsigned long page_to_section(const struct page *page)
  {
  	return (page->flags >> SECTIONS_PGSHIFT) & SECTIONS_MASK;
  }
-#endif
+#else /* !SECTION_IN_PAGE_FLAGS */
+static inline unsigned long page_to_section(const struct page *page)
+{
+	return 0;
+}
+#endif /* SECTION_IN_PAGE_FLAGS */
  
  /**
   * folio_pfn - Return the Page Frame Number of a folio.
diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index 89b518ff097e6..58cb99b69f432 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -616,4 +616,39 @@ static inline bool vma_has_recency(struct vm_area_struct *vma)
  	return true;
  }
  
+/**
+ * num_pages_contiguous() - determine the number of contiguous pages
+ *                          that represent contiguous PFNs
+ * @pages: an array of page pointers
+ * @nr_pages: length of the array, at least 1
+ *
+ * Determine the number of contiguous pages that represent contiguous PFNs
+ * in @pages, starting from the first page.
+ *
+ * In kernel configs where contiguous pages might not imply contiguous PFNs
+ * over memory section boundaries, this function will stop at the memory
+ * section boundary.
+ *
+ * Returns the number of contiguous pages.
+ */
+static inline size_t num_pages_contiguous(struct page **pages, size_t nr_pages)
+{
+	struct page *cur_page = pages[0];
+	unsigned long section = page_to_section(cur_page);
+	size_t i;
+
+	for (i = 1; i < nr_pages; i++) {
+		if (++cur_page != pages[i])
+			break;
+		/*
+		 * In unproblematic kernel configs, page_to_section() == 0 and
+		 * the whole check will get optimized out.
+		 */
+		if (page_to_section(cur_page) != section)
+			break;
+	}
+
+	return i;
+}
+
  #endif
-- 
2.50.1


-- 
Cheers,

David / dhildenb


