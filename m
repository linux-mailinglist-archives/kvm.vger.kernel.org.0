Return-Path: <kvm+bounces-54309-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 703D6B1E0D4
	for <lists+kvm@lfdr.de>; Fri,  8 Aug 2025 05:11:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 34687627D3C
	for <lists+kvm@lfdr.de>; Fri,  8 Aug 2025 03:11:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D07C9199FAB;
	Fri,  8 Aug 2025 03:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="N+q42R1Z"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4D8C17AE11
	for <kvm@vger.kernel.org>; Fri,  8 Aug 2025 03:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754622673; cv=none; b=VoIKlbo9yQLq9NdntPKKUEyWWGP1tcL4H/pciVwXkID8I+TnyGOQit9v8Jy8/0pEKbLEe9eLNdBn2aQbtwMsL3mSj5IxaF9MxuYCYgA7i69GM3Kl8Ol1tHB9Jerh3Tstd4en6VPbDbiS810ekvnnCwhbwug8VFXJEiNvCNfEUrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754622673; c=relaxed/simple;
	bh=ftdoo9n84giM10YMfk41vn5HMp7vzsV213yRZzMBAIg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lubgt/b8M7yRO3b2aTLsZBXAL6mPRPk0fAYcPIbWQZ180P5AhaEuZpNZrzT5k87sEYxnv007eu0qOSDGp8WQhK+q5Go9wp+b6Tl3L642qxXsF8Zn4Ig0pGILgXLIIegBNspK5X7FHfWYCGb5GQO8wlLWd6D8NzVJ5lkk90aIsKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=N+q42R1Z; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-3190fbe8536so1703585a91.3
        for <kvm@vger.kernel.org>; Thu, 07 Aug 2025 20:11:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1754622671; x=1755227471; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L+hnXF88Mhf9j9oZAe6zTo2Uimcte4f1YNcGXy00fUo=;
        b=N+q42R1Zqn5cdJcXL7PdiMIXupg+uw97SXzmvAFyWofX5DcnWbSc6Iz6x1X+R3eWHo
         WgLjpD/iaAnZDfEHbRAxtt862Dc6ncudzIaDyrUgmzHz5eJVYt7ToKhZ2Kh7Fw0CqP3n
         u6EdCZ44g7qusIMYscJdO/AzbwP3S8dXPFxkHE5M1CFra6zzAUX8rD3ihIUT89IZdX2W
         o0h8zu7Iq5Q6W9xaESYXcr6FGmkEV5IKdlgeX2GMybMHrasY38X1fpWUJ2FbeomTs0t5
         Emgy1qD+0FKf+wb+mDg6xqTMy39M6ubZEDgH2jqsWH8fPntHqNTceQwR3PNfwIMbp6uU
         OElw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754622671; x=1755227471;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=L+hnXF88Mhf9j9oZAe6zTo2Uimcte4f1YNcGXy00fUo=;
        b=LHXMYC6DkxUozZ8DK+ntOK0JE63cf1TIwoGriZOMEw8DRJeKHYcxrXmONtBYTSWueB
         98u8mWu5J863LppfDP72txNVGngVgUTzP66UFEZLUZU6JRQkOR/hbUuRRaDo1vVxwe95
         0JyQNmTdcCdThe4P69TnqtMjhX7bxCRQoNTxMxCPT/WPAcJyejEoo/axttkeW2q57wqn
         6HOUSkXs/OSs0pcQZvnCAOlNucTRTiXCjJTClD8zKkIgqAST5v4WfRkLPGKqQWqbKQAl
         uH2OQSgIsKh4hRhRg+OJonA/m6DicC5BC+tbzzzFUJIHjis5KLgVeu9R2NsHVdOfbvGK
         habQ==
X-Forwarded-Encrypted: i=1; AJvYcCWPyePCuZo/Q2iV1WpTGnDGq+RBm/PBntxqXJS9WYv0X7kl02rYiWSkBvLPeftWmfh+KS4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwLN+6+M44UZV57fSVyylVrN2b8P+pdLqZBa9HYmP/Unsvb6+UJ
	7WMmCtXjTeduqvG65uJr3xi/qTPG9gipvto9DDaZT+QyiAXWQl/iYi7BzC1uisQv7UCDuZQethz
	fLnhj
X-Gm-Gg: ASbGncurkbyesZ2KSjADz7YmnLedqLAf7itnDH8IHF9nl3hH9E/vqZVZySx2ji3sHKn
	0h6+Mgp8BsfEnwszxO7kgLilCtdDxlQ/9G/2kEIJWSQbCgN9/iV9OkNf+h7cb17pbKu/zEVwzcT
	Jag2UdQMJZIrdmDCcrar4fIb/U5HSqzYbpn9Ac+gfa8//xPH8rsJOfAiZ5UPVlVMo1U55qtWTdK
	gVR0bv7NBoC9GPT2FrkeVLuaKTR0fBMscM6DtPxS7ypJhbRiRKWL6K5ddc+4WRKEZaovLq0Xsv2
	sOPI2D+Vv2eIcNxoDs92DWMt8iAoVOTC4IgEBe9meGfcKp3dYAi6Jw+mfBZSTKYlRez72Wi0GBB
	sV8XnsxPwAUJytjuTlZ9JsboblJcNBXGgtr56y6WpZv9JCcSu+dTwQDmlZEA=
X-Google-Smtp-Source: AGHT+IEqVn6pbfRoKKePOSXvswyQoo+sgYKFf+kxkxwx1BQjQKLbwHCPG+WcdrEERmzIeHQpD/CgEg==
X-Received: by 2002:a17:90b:288c:b0:31c:3872:9411 with SMTP id 98e67ed59e1d1-32183e80805mr2289814a91.33.1754622670643;
        Thu, 07 Aug 2025 20:11:10 -0700 (PDT)
Received: from localhost.localdomain ([203.208.189.9])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-31f63dc167dsm23745583a91.11.2025.08.07.20.11.07
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 07 Aug 2025 20:11:10 -0700 (PDT)
From: lizhe.67@bytedance.com
To: alex.williamson@redhat.com
Cc: david@redhat.com,
	jgg@nvidia.com,
	kvm@vger.kernel.org,
	lizhe.67@bytedance.com,
	torvalds@linux-foundation.org
Subject: Re: [PATCH] vfio/type1: Absorb num_pages_contiguous()
Date: Fri,  8 Aug 2025 11:11:04 +0800
Message-ID: <20250808031104.34763-1-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250807135420.0168a781.alex.williamson@redhat.com>
References: <20250807135420.0168a781.alex.williamson@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, 7 Aug 2025 13:54:20 -0600, alex.williamson@redhat.com wrote:

> On Thu,  7 Aug 2025 12:14:19 +0800
> lizhe.67@bytedance.com wrote:
> 
> > On Wed, 6 Aug 2025 14:35:15 +0200, david@redhat.com wrote:
> >  
> > > On 05.08.25 03:24, Alex Williamson wrote:  
> > > > Objections were raised to adding this helper to common code with only a
> > > > single user and dubious generalism.  Pull it back into subsystem code.
> > > > 
> > > > Link: https://lore.kernel.org/all/CAHk-=whhYRMS7Xc9k_JBdrGvp++JLmU0T2xXEgn046hWrj7q8Q@mail.gmail.com/
> > > > Cc: David Hildenbrand <david@redhat.com>
> > > > Cc: Jason Gunthorpe <jgg@nvidia.com>
> > > > Cc: Li Zhe <lizhe.67@bytedance.com>
> > > > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > > > ---  
> > > 
> > > So, I took the original patch and
> > > * moved the code to mm_inline.h (sounds like a better fit)
> > > * Tweaked the patch description
> > > * Tweaked the documentation and turned it into proper kerneldoc
> > > * Made the function return "size_t" as well
> > > * Use the page_to_section() trick to avoid nth_page().
> > > 
> > > Only compile-tested so far. Still running it through some cross compiles.
> > > 
> > > 
> > >  From 36d67849bfdbc184990f21464c53585d35648616 Mon Sep 17 00:00:00 2001
> > > From: Li Zhe <lizhe.67@bytedance.com>
> > > Date: Thu, 10 Jul 2025 16:53:51 +0800
> > > Subject: [PATCH] mm: introduce num_pages_contiguous()
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
> > >   include/linux/mm.h        |  7 ++++++-
> > >   include/linux/mm_inline.h | 35 +++++++++++++++++++++++++++++++++++
> > >   2 files changed, 41 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > > index fa538feaa8d95..2852bcd792745 100644
> > > --- a/include/linux/mm.h
> > > +++ b/include/linux/mm.h
> > > @@ -1759,7 +1759,12 @@ static inline unsigned long page_to_section(const struct page *page)
> > >   {
> > >   	return (page->flags >> SECTIONS_PGSHIFT) & SECTIONS_MASK;
> > >   }
> > > -#endif
> > > +#else /* !SECTION_IN_PAGE_FLAGS */
> > > +static inline unsigned long page_to_section(const struct page *page)
> > > +{
> > > +	return 0;
> > > +}
> > > +#endif /* SECTION_IN_PAGE_FLAGS */
> > >   
> > >   /**
> > >    * folio_pfn - Return the Page Frame Number of a folio.
> > > diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> > > index 89b518ff097e6..58cb99b69f432 100644
> > > --- a/include/linux/mm_inline.h
> > > +++ b/include/linux/mm_inline.h
> > > @@ -616,4 +616,39 @@ static inline bool vma_has_recency(struct vm_area_struct *vma)
> > >   	return true;
> > >   }
> > >   
> > > +/**
> > > + * num_pages_contiguous() - determine the number of contiguous pages
> > > + *                          that represent contiguous PFNs
> > > + * @pages: an array of page pointers
> > > + * @nr_pages: length of the array, at least 1
> > > + *
> > > + * Determine the number of contiguous pages that represent contiguous PFNs
> > > + * in @pages, starting from the first page.
> > > + *
> > > + * In kernel configs where contiguous pages might not imply contiguous PFNs
> > > + * over memory section boundaries, this function will stop at the memory
> > > + * section boundary.
> > > + *
> > > + * Returns the number of contiguous pages.
> > > + */
> > > +static inline size_t num_pages_contiguous(struct page **pages, size_t nr_pages)
> > > +{
> > > +	struct page *cur_page = pages[0];
> > > +	unsigned long section = page_to_section(cur_page);
> > > +	size_t i;
> > > +
> > > +	for (i = 1; i < nr_pages; i++) {
> > > +		if (++cur_page != pages[i])
> > > +			break;
> > > +		/*
> > > +		 * In unproblematic kernel configs, page_to_section() == 0 and
> > > +		 * the whole check will get optimized out.
> > > +		 */
> > > +		if (page_to_section(cur_page) != section)
> > > +			break;
> > > +	}
> > > +
> > > +	return i;
> > > +}
> > > +
> > >   #endif  
> > 
> > I sincerely appreciate your thoughtful revisions to this patch. The
> > code looks great.
> > 
> > Based on this patch, I reran the performance tests for the VFIO
> > optimizations. The results show no significant change from the
> > previous data.
> > 
> > Since num_pages_contiguous() is now defined in mm_inline.h, the
> > second patch "vfio/type1: optimize vfio_pin_pages_remote()" in this
> > series needs to include that header to resolve the build error.
> > 
> > diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> > index 1136d7ac6b59..af98cb94153c 100644
> > --- a/drivers/vfio/vfio_iommu_type1.c
> > +++ b/drivers/vfio/vfio_iommu_type1.c
> > @@ -37,6 +37,7 @@
> >  #include <linux/vfio.h>
> >  #include <linux/workqueue.h>
> >  #include <linux/notifier.h>
> > +#include <linux/mm_inline.h>
> >  #include "vfio.h"
> >  
> >  #define DRIVER_VERSION  "0.2"
> 
> Hi Zhe,
> 
> Once we're all satisfied with the update, please post a full new
> series.  Since we're restarting with fresh commits, please include the
> fixes directly in the original patches.  Thanks,

Got it. If no more comments come in over the next few days, I'll
send out a fresh patchset.

Thanks,
Zhe

