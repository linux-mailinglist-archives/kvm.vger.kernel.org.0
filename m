Return-Path: <kvm+bounces-58953-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B963BA7DBD
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 05:21:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A88F91752D5
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 03:21:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D08A21917D0;
	Mon, 29 Sep 2025 03:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="TOQFqXoO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D725DA92E
	for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 03:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759116081; cv=none; b=X/Z9i6tbnPOLg5QGvhLm8OU+WHamkfbt20CkPlQenr5zBtieHCB/hx/f5ewks4El5u0veWHPbjUzNixlHLYL6cyx8q0uY4Pn+vg5A4YLHtrHAdUhIdxPJJyiRFSIaWIZccFZDKBBV6/DjlJxfWWaa3Y8apXScUPDkVJuNa578Mo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759116081; c=relaxed/simple;
	bh=wRhAvO3Kj+jN6sEVnHfuUVRV867RmACsoLUoH2yXRog=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dOi5YYhjki2pmHYJHsNL6dKbZETJUg14nAce7KGIO9ipY8oO17YmgeA9/mhDrnWyXKeZG7Tt1EPQKH+LrD+LkVo/v9jM2t3rf6e0AiWWbC8vkeKufAkPDXMsPdelKi2k0QYVLEs/mYgklOxoe/7sRfXNfk1H1yhpUVnqWD0+Rvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=TOQFqXoO; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-27eed7bdfeeso35517215ad.0
        for <kvm@vger.kernel.org>; Sun, 28 Sep 2025 20:21:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1759116078; x=1759720878; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+HzMeJR74NGpl3BsleICBKpNlFLh3HQZFamiJDXtI+U=;
        b=TOQFqXoOGMsGAx5x+VQK5R0Z44oQn4hbI6J7pB3tn273ybZ6U2HMHqtmj4k7Llm709
         beve20KwmBVFJUeixNQ3hwIDf+bVDLqoc+zc0eXWarkIWX0V/io0lv4hXbqOHIktyZnj
         euTRjbiVv9rlY/CQLm+GdXRgLvZbxmjzA9KguhsXa1DIj2a4BXNuvwWZNqBZQwtKhjZi
         15arwPW1B75YFhU9zCpJlCX7CKe/bZdrEayiIJIVxd3kkYo7Dlefb43zWcoCr40D3PuN
         5I7hzbvX49pRxUgx21oR6flNtw6otlFI8dDzZj7ePGQZWX3bPQCo1EKS4+21HSM3+teB
         OkDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759116078; x=1759720878;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+HzMeJR74NGpl3BsleICBKpNlFLh3HQZFamiJDXtI+U=;
        b=Ap6wgsnJo1tPsnYLQY15BY9sxKlGlNu850UcEPEFqmZqQe2u75m44kfzg/9JZkFFo8
         ecH7DhPbkxkDN2yryeC8TDKZd+2qh1uwN3Lo3THuLSZ4Zaq32K5k9EeyGMZ4/upk7yCg
         mX7jLJt1q/6rzJBagL7m+Y8e6Jb0BQRqDs7dp6jeq0oW9Kr25yWHIkq1sBzFhNFN5Osr
         Yf8k+Kbiq8mXdMvRjcYkMJWNmY7A8+8a77coFx90UwzP6t5MPIVGbEGz9rEmUXz80d3J
         fAAQpZ7VEAp6QX5YdqOBzeF77tvfTacePCFV/bBGQhkgsHFscbxaXEJ47g9r0g1Je0p4
         /Z7A==
X-Forwarded-Encrypted: i=1; AJvYcCUO1/alBgnAOGpkDxUE2vVGz0X9llzQDsgEkd8ip6Ltlki7b5kKBRJZmrsxTeMfstdNhlg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzrvBWjMw2So6C80DO3sf2X5e/lyoi0KmUtP1mjjQ7sN+LQwAYe
	9k9z0yL4h0jXzrd46tECL2s43pflf5lF0NvYZWmHL3vOnOMINR4pr+cRR0XG4S0lZZo=
X-Gm-Gg: ASbGncsb0kYNPxewuiE3fOHrHC8DfNM6yWWmgnA3rbxHpMwi1rIUTZnG1tJx11u1WAm
	1yVBJEFtfJQBGVxX1nWCRA4w83kU37bKljexJyRaVsaRxcKFtqHwu4/6wXeljE5L4WlOemqZDDK
	PHLVMnWtD6nyYiJs59LFdgMoo/fIrAW04v72DFcTqrsXw8/h2CMkEZ4xy7fL3xCDSMN4EPU1uBy
	vYoC2De29k6VFpFb+9YzLudg/fS1ykvkV4UXptsMqfHkUGOIu4RJxKf4qmZca4oCnD3N8QJr4J6
	0CCKsy+DjmfBcwE42oQ93jDKqf6EMV9MTP2fP0MBsub5bhCETpCiLXlVOMcfprhnx1XGbk+GUh/
	4Ray1laZWcAFbvD3jhpL1K4K4CnHsCjSXRIHrf+/QepIwIQmZcw==
X-Google-Smtp-Source: AGHT+IEwGDXGEzpy3mjwVkfIZcUQVw7aO7XPMjfQI6cz4sCSZ3/q3fA5nP/zt4yK6sg9Fehieoyy6Q==
X-Received: by 2002:a17:902:f78c:b0:25b:e5a2:fb29 with SMTP id d9443c01a7336-27ed6de50d9mr153957695ad.12.1759116077957;
        Sun, 28 Sep 2025 20:21:17 -0700 (PDT)
Received: from localhost.localdomain ([2001:c10:ff04:0:1000::a])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-27ed66f3820sm114012825ad.33.2025.09.28.20.21.13
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 28 Sep 2025 20:21:17 -0700 (PDT)
From: lizhe.67@bytedance.com
To: alex.williamson@redhat.com
Cc: akpm@linux-foundation.org,
	david@redhat.com,
	farman@linux.ibm.com,
	jgg@nvidia.com,
	jgg@ziepe.ca,
	kvm@vger.kernel.org,
	linux-mm@kvack.org,
	torvalds@linux-foundation.org,
	willy@infradead.org,
	lizhe.67@bytedance.com
Subject: Re: [PATCH v5 1/5] mm: introduce num_pages_contiguous()
Date: Mon, 29 Sep 2025 11:21:07 +0800
Message-ID: <20250929032107.7512-1-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250901032532.67154-1-lizhe.67@bytedance.com>
References: <20250901032532.67154-1-lizhe.67@bytedance.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, 1 Sep 2025 11:25:32 +0800, lizhe.67@bytedance.com wrote:

> On Wed, 27 Aug 2025 12:10:55 -0600, alex.williamson@redhat.com wrote:
> 
> > On Thu, 14 Aug 2025 14:47:10 +0800
> > lizhe.67@bytedance.com wrote:
> > 
> > > From: Li Zhe <lizhe.67@bytedance.com>
> > > 
> > > Let's add a simple helper for determining the number of contiguous pages
> > > that represent contiguous PFNs.
> > > 
> > > In an ideal world, this helper would be simpler or not even required.
> > > Unfortunately, on some configs we still have to maintain (SPARSEMEM
> > > without VMEMMAP), the memmap is allocated per memory section, and we might
> > > run into weird corner cases of false positives when blindly testing for
> > > contiguous pages only.
> > > 
> > > One example of such false positives would be a memory section-sized hole
> > > that does not have a memmap. The surrounding memory sections might get
> > > "struct pages" that are contiguous, but the PFNs are actually not.
> > > 
> > > This helper will, for example, be useful for determining contiguous PFNs
> > > in a GUP result, to batch further operations across returned "struct
> > > page"s. VFIO will utilize this interface to accelerate the VFIO DMA map
> > > process.
> > > 
> > > Implementation based on Linus' suggestions to avoid new usage of
> > > nth_page() where avoidable.
> > > 
> > > Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
> > > Suggested-by: Jason Gunthorpe <jgg@ziepe.ca>
> > > Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
> > > Co-developed-by: David Hildenbrand <david@redhat.com>
> > > Signed-off-by: David Hildenbrand <david@redhat.com>
> > > ---
> > >  include/linux/mm.h        |  7 ++++++-
> > >  include/linux/mm_inline.h | 35 +++++++++++++++++++++++++++++++++++
> > >  2 files changed, 41 insertions(+), 1 deletion(-)
> > 
> > 
> > Does this need any re-evaluation after Willy's series?[1]  Patch 2/
> > changes page_to_section() to memdesc_section() which takes a new
> > memdesc_flags_t, ie. page->flags.  The conversion appears trivial, but
> > mm has many subtleties.
> > 
> > Ideally we could also avoid merge-time fixups for linux-next and
> > mainline.
> 
> Thank you for your reminder.
> 
> In my view, if Willy's series is integrated, this patch will need to
> be revised as follows. Please correct me if I'm wrong.
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index ab4d979f4eec..bad0373099ad 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -1763,7 +1763,12 @@ static inline unsigned long memdesc_section(memdesc_flags_t mdf)
>  {
>  	return (mdf.f >> SECTIONS_PGSHIFT) & SECTIONS_MASK;
>  }
> -#endif
> +#else /* !SECTION_IN_PAGE_FLAGS */
> +static inline unsigned long memdesc_section(memdesc_flags_t mdf)
> +{
> +	return 0;
> +}
> +#endif /* SECTION_IN_PAGE_FLAGS */
>  
>  /**
>   * folio_pfn - Return the Page Frame Number of a folio.
> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> index 150302b4a905..bb23496d465b 100644
> --- a/include/linux/mm_inline.h
> +++ b/include/linux/mm_inline.h
> @@ -616,4 +616,40 @@ static inline bool vma_has_recency(struct vm_area_struct *vma)
>  	return true;
>  }
>  
> +/**
> + * num_pages_contiguous() - determine the number of contiguous pages
> + *			    that represent contiguous PFNs
> + * @pages: an array of page pointers
> + * @nr_pages: length of the array, at least 1
> + *
> + * Determine the number of contiguous pages that represent contiguous PFNs
> + * in @pages, starting from the first page.
> + *
> + * In some kernel configs contiguous PFNs will not have contiguous struct
> + * pages. In these configurations num_pages_contiguous() will return a num
> + * smaller than ideal number. The caller should continue to check for pfn
> + * contiguity after each call to num_pages_contiguous().
> + *
> + * Returns the number of contiguous pages.
> + */
> +static inline size_t num_pages_contiguous(struct page **pages, size_t nr_pages)
> +{
> +	struct page *cur_page = pages[0];
> +	unsigned long section = memdesc_section(cur_page->flags);
> +	size_t i;
> +
> +	for (i = 1; i < nr_pages; i++) {
> +		if (++cur_page != pages[i])
> +			break;
> +		/*
> +		 * In unproblematic kernel configs, page_to_section() == 0 and
> +		 * the whole check will get optimized out.
> +		 */
> +		if (memdesc_section(cur_page->flags) != section)
> +			break;
> +	}
> +
> +	return i;
> +}
> +
>  #endif

Hi Alex,

I noticed that Willy's series has been merged into the mm-stable
branch. Could you please let me know if this vfio optimization
series is also ready to be merged?

Thanks,
Zhe

