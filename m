Return-Path: <kvm+bounces-54213-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F0B93B1D16E
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 06:14:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9F1CE18832CC
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 04:14:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AE451E51F6;
	Thu,  7 Aug 2025 04:14:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="YYALg6m6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 178B31E0E1F
	for <kvm@vger.kernel.org>; Thu,  7 Aug 2025 04:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754540069; cv=none; b=WWvRbwiwa+GL2AVZ1Nt+6o5O18CueST54Knxqk7W4TQ9M1LdLi8wVx+TW0CNS3tkRUOeIBXfhBHCRauD4Hw7xszJ7xTHD43yUycl+rHCkTAcllDqOl2/CO1B20yErZMdbJei2qychoepUoCIxj34TBpD+BM9HtQ+rd3TmyYFI4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754540069; c=relaxed/simple;
	bh=Y5+Mvi+AJU0f7D2eXhXKQuL1Hmv+LIBIZqZILeC0OP4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MIbF8vyfLfBJ5J1/if2tAHaJLLPMGCL4isDylFNtVZAbYBcTUiGNxMYWbWFeiv7sA0aaP/kzANiLmuV2O4aYo6hvGxwiapeQkhaPwdIFDg+YIVqpaCSNteTr/eRk8rkivZOSLZhh6hEEdTunYNR/3Xl8IRr2XrjLT3jdhw2ft6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=YYALg6m6; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-24014cd385bso6550505ad.0
        for <kvm@vger.kernel.org>; Wed, 06 Aug 2025 21:14:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1754540065; x=1755144865; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0VU3AKO6j5KfnLMAEJONOoY/9qsJBV34SqKAsMo6B9U=;
        b=YYALg6m6TX0d2ZLUMoEQKL7H3fCR4qf7h6qoRFTxPVf0LUWKGVbh6oE1zBzgnvTrx9
         8GIDFx6a1FMCRMsSr8inVf76QjwIXVVEEx6o0rmziSlaWOscaEupMTk2C7mQMCfWSRnk
         9F2gXWlEukM9Yvjt95PlrvWuW7yQKfu4qzrZCc3fu9yID7VaVwWRjgjVC+wtAoevUt2J
         mtbfbVnfxGMs2gkWhy/1YA/Rp5JuG8Ju7f7e0umQc2MXKt0Gb/EUB4mArYQXqvDBYo5h
         ntyHaUP1mfooPIg15ZbnyjFVRO3SbjEABzI7CW8q0mlkCyQclOxZsfzTI3gp5QyDGnIG
         OCFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754540065; x=1755144865;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0VU3AKO6j5KfnLMAEJONOoY/9qsJBV34SqKAsMo6B9U=;
        b=jIpJU6Om5pWge0PgAdJd01hXqhtuJXtxGPc+0ibKncl2hVLQxkbrVI35tcJiYp+snE
         bsXYiIXD5SOj9fT5taOul8ZbFrwB/GtNu7ff5slT0sK+XBj2UncTgq3TfYLWYX2QJaKv
         uf1qS+JYrK8qqFYxiHRZotKl495q3uyfx0/wHta2d75ws4HsUIqXkMpEykmGc4urtnFN
         N0XNtzGmZdnkZJogaZyUJd1GvEuWuWgGUh+FfwY8RSIbcxa9tdcEKVBqVcKUTFq8YWw7
         vAPgrdcwLVBO0LSMcjSK4KRrZzI241G7VkfdK+uPcOZDgjUaCu1Y8avBpYjW3SIcY3Ra
         88pQ==
X-Forwarded-Encrypted: i=1; AJvYcCVw65ValqHrHaPjGGUY1PVrzOpAl5QBrKeKi5z46T+PoBzc4onKnQSlvkFtIaGKrXIYRDM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxLt5FzwiYnmLZDbFOROHQ85GdeFS8y8uTiJEugWYzeb+sWFcOX
	pFk2nu1CV6hexFNwGTZh5cDQY4M5y6DbgokfgoEESQQ02BYs5p0MsEykBrIqzA0XvsU=
X-Gm-Gg: ASbGncvfOWSdw4ZSPS7qzRGf7G29tDb8iVr1tkOhl5GXEbT0xgNVS42O4sG77N5doTE
	nTz6W4lEDWmC274jPL5pfRjwYGLf7fQf11h7CkYK7tLVTir38AhpPs7PqMC5nKytImYjLZd55Eo
	S/EbbnnWI5Hqg9JUgroB73H7cRxcYBOyoff4AiX2leefBqVk90dTt+8s+KlbbHmry2szuXHkbIo
	clJqHEcbpTY5KBbmeWYb74p+/+KoWmCrdjEXkmoyaUgFORNwSYqWVP6Byumzy2WTMU/imn/uMNi
	NLLyQkYNKgZaRSB+HTQ+PrDo6LSHExvdC6eHNXxRvKoD9aAff+nueP8lFp7FupN031rFRjMAFjx
	FBKmL0ZrJE0w1tzAOO/1nqsOQbdOCueuN2Szfxrbt37r/Kdu6
X-Google-Smtp-Source: AGHT+IH1gOrbNmZ6rfDsJEvsF+Fa6LJjjIGjAn/+SrJB2ItGpvNK7orQ3j4y8U9lO0P786LJff6GXw==
X-Received: by 2002:a17:903:987:b0:240:2a0:c449 with SMTP id d9443c01a7336-242a0a90e6fmr65804285ad.8.1754540065244;
        Wed, 06 Aug 2025 21:14:25 -0700 (PDT)
Received: from localhost.localdomain ([203.208.189.9])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b422b7bb0c0sm14384575a12.20.2025.08.06.21.14.22
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 06 Aug 2025 21:14:24 -0700 (PDT)
From: lizhe.67@bytedance.com
To: david@redhat.com,
	alex.williamson@redhat.com
Cc: jgg@nvidia.com,
	kvm@vger.kernel.org,
	lizhe.67@bytedance.com,
	torvalds@linux-foundation.org
Subject: Re: [PATCH] vfio/type1: Absorb num_pages_contiguous()
Date: Thu,  7 Aug 2025 12:14:19 +0800
Message-ID: <20250807041419.54591-1-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <f4c464d0-2a98-4c17-8b56-abf86fd15215@redhat.com>
References: <f4c464d0-2a98-4c17-8b56-abf86fd15215@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, 6 Aug 2025 14:35:15 +0200, david@redhat.com wrote:
 
> On 05.08.25 03:24, Alex Williamson wrote:
> > Objections were raised to adding this helper to common code with only a
> > single user and dubious generalism.  Pull it back into subsystem code.
> > 
> > Link: https://lore.kernel.org/all/CAHk-=whhYRMS7Xc9k_JBdrGvp++JLmU0T2xXEgn046hWrj7q8Q@mail.gmail.com/
> > Cc: David Hildenbrand <david@redhat.com>
> > Cc: Jason Gunthorpe <jgg@nvidia.com>
> > Cc: Li Zhe <lizhe.67@bytedance.com>
> > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > ---
> 
> So, I took the original patch and
> * moved the code to mm_inline.h (sounds like a better fit)
> * Tweaked the patch description
> * Tweaked the documentation and turned it into proper kerneldoc
> * Made the function return "size_t" as well
> * Use the page_to_section() trick to avoid nth_page().
> 
> Only compile-tested so far. Still running it through some cross compiles.
> 
> 
>  From 36d67849bfdbc184990f21464c53585d35648616 Mon Sep 17 00:00:00 2001
> From: Li Zhe <lizhe.67@bytedance.com>
> Date: Thu, 10 Jul 2025 16:53:51 +0800
> Subject: [PATCH] mm: introduce num_pages_contiguous()
> 
> Let's add a simple helper for determining the number of contiguous pages
> that represent contiguous PFNs.
> 
> In an ideal world, this helper would be simpler or not even required.
> Unfortunately, on some configs we still have to maintain (SPARSEMEM
> without VMEMMAP), the memmap is allocated per memory section, and we might
> run into weird corner cases of false positives when blindly testing for
> contiguous pages only.
> 
> One example of such false positives would be a memory section-sized hole
> that does not have a memmap. The surrounding memory sections might get
> "struct pages" that are contiguous, but the PFNs are actually not.
> 
> This helper will, for example, be useful for determining contiguous PFNs
> in a GUP result, to batch further operations across returned "struct
> page"s. VFIO will utilize this interface to accelerate the VFIO DMA map
> process.
> 
> Implementation based on Linus' suggestions to avoid new usage of
> nth_page() where avoidable.
> 
> Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
> Suggested-by: Jason Gunthorpe <jgg@ziepe.ca>
> Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
> Co-developed-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>   include/linux/mm.h        |  7 ++++++-
>   include/linux/mm_inline.h | 35 +++++++++++++++++++++++++++++++++++
>   2 files changed, 41 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index fa538feaa8d95..2852bcd792745 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -1759,7 +1759,12 @@ static inline unsigned long page_to_section(const struct page *page)
>   {
>   	return (page->flags >> SECTIONS_PGSHIFT) & SECTIONS_MASK;
>   }
> -#endif
> +#else /* !SECTION_IN_PAGE_FLAGS */
> +static inline unsigned long page_to_section(const struct page *page)
> +{
> +	return 0;
> +}
> +#endif /* SECTION_IN_PAGE_FLAGS */
>   
>   /**
>    * folio_pfn - Return the Page Frame Number of a folio.
> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> index 89b518ff097e6..58cb99b69f432 100644
> --- a/include/linux/mm_inline.h
> +++ b/include/linux/mm_inline.h
> @@ -616,4 +616,39 @@ static inline bool vma_has_recency(struct vm_area_struct *vma)
>   	return true;
>   }
>   
> +/**
> + * num_pages_contiguous() - determine the number of contiguous pages
> + *                          that represent contiguous PFNs
> + * @pages: an array of page pointers
> + * @nr_pages: length of the array, at least 1
> + *
> + * Determine the number of contiguous pages that represent contiguous PFNs
> + * in @pages, starting from the first page.
> + *
> + * In kernel configs where contiguous pages might not imply contiguous PFNs
> + * over memory section boundaries, this function will stop at the memory
> + * section boundary.
> + *
> + * Returns the number of contiguous pages.
> + */
> +static inline size_t num_pages_contiguous(struct page **pages, size_t nr_pages)
> +{
> +	struct page *cur_page = pages[0];
> +	unsigned long section = page_to_section(cur_page);
> +	size_t i;
> +
> +	for (i = 1; i < nr_pages; i++) {
> +		if (++cur_page != pages[i])
> +			break;
> +		/*
> +		 * In unproblematic kernel configs, page_to_section() == 0 and
> +		 * the whole check will get optimized out.
> +		 */
> +		if (page_to_section(cur_page) != section)
> +			break;
> +	}
> +
> +	return i;
> +}
> +
>   #endif

I sincerely appreciate your thoughtful revisions to this patch. The
code looks great.

Based on this patch, I reran the performance tests for the VFIO
optimizations. The results show no significant change from the
previous data.

Since num_pages_contiguous() is now defined in mm_inline.h, the
second patch "vfio/type1: optimize vfio_pin_pages_remote()" in this
series needs to include that header to resolve the build error.

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 1136d7ac6b59..af98cb94153c 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -37,6 +37,7 @@
 #include <linux/vfio.h>
 #include <linux/workqueue.h>
 #include <linux/notifier.h>
+#include <linux/mm_inline.h>
 #include "vfio.h"
 
 #define DRIVER_VERSION  "0.2"

Thanks,
Zhe

