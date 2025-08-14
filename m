Return-Path: <kvm+bounces-54651-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 56585B25E2B
	for <lists+kvm@lfdr.de>; Thu, 14 Aug 2025 09:58:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6D956166805
	for <lists+kvm@lfdr.de>; Thu, 14 Aug 2025 07:58:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEBD8288C18;
	Thu, 14 Aug 2025 07:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="aeHXN553"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31FEC83CD1
	for <kvm@vger.kernel.org>; Thu, 14 Aug 2025 07:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755158317; cv=none; b=dBo4ko0jHa+F0aCKZzsZSbz03n/H48W8Q8SK8CG1kKQdPJDFS7tXNk2VOZgyinABx9xzgKbnNw/wYQKVTqA+nc0tCkeVW40Nun5uqZQVx71o3AeQxHLlYb8hJkCuzuYrY76WlqKr6/eJOYYUWOQklyp6zb0akaftjvhyH39m00M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755158317; c=relaxed/simple;
	bh=3BDmUgtrVusdJGLwxOoJa6D7wnau21bU1i5YqRJ32Kw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BfeNIBQZblMKLNFrPKLc4Wl+vM0BmZNBNrb3NY5X2TvIGh2mYTF56JzMB2DX8gZ+lXRtQGtnWPM/fbHexjKAmdnOgX6X+PR4qWpo3TDDJl1ONFmh5HSH8Ajy+jMMC1OhPulDOV28d2tvQI909P6Kael5FLh4LyQq+qoO6ywo0gA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=aeHXN553; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-76e2e8bb2e5so943482b3a.1
        for <kvm@vger.kernel.org>; Thu, 14 Aug 2025 00:58:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1755158314; x=1755763114; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4s2oDqQ9Axxr0LU8mruMwn41CcHNr/5Tx31AQ1BHTKY=;
        b=aeHXN553klkcklS7wGFqtnl5r0esI7rq+hiGW6ijSqCSjFiUbIksUQajSqNZbCtFGp
         TV/l3YHW+T2MHhovq2mfVNYE+/lcU35UgtvVNU9ZSdRcGb2o1+uCgdJbx0erDwSgU1Cg
         8V0fhagLwWZlIONNQSdcacymEt7VYCJ38rJLPTxDUtQvv8AU/GhMWkrlrBZBMVRN3vuJ
         rP3gED6foscFX+x3Zr7G6KdNsB1z+g/nf/F011yDESFd28jci/I7pWWNb2czE03XIhdK
         wkBM6P4aNswPXO280u/1XaPP0lvt0QHnpE3sE4TknmjKkGfOBC633ssfRCNbgjWisrRf
         3Cgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755158314; x=1755763114;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4s2oDqQ9Axxr0LU8mruMwn41CcHNr/5Tx31AQ1BHTKY=;
        b=kN8OfH9lRFFHZ4zVOwkPsRyu7iIMHs5fYMysdpKypYero9KVlOj1HoVWmt0hwGM+x/
         KSoTBNPAg38qYuVKcDKznay4ZWeP5mgWx/2FeqKig3n6PfNWa/9DQI7459SPq6ATvO7U
         cd0RY4ka19of8A0Q8k4OhnMEjbmxa1tH7SGOOSxbHga84JIgRk/7Uzv0ajQAC8hvuojz
         B04wKmRlVFYsIz72pc7KbbbmbYKcDwC/N5iISfMeamG3o5AWRbOxDsZdKK1Om70nn1TH
         46WQX7E1MTZx7kJb0CV6vFa6djYDkxSJlfKwSjYdr7z/DxTZ5+XQx+skRPw+n1z+yOe1
         rliw==
X-Forwarded-Encrypted: i=1; AJvYcCW8rssJdl9KGDDKP7N3jfojQDdpfYW9bcZcTO2zYrBW7r3QXeduZ/wUomVDGA8G4aKAoo8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyADoSqMoVlrCtcAogryl9FwfE7v6yf4E2amp5cGf728EGFTWEp
	5QgTnfmO7PmQwxZlRtutBTXRDWQvUCtFnysgFcKIL3Nw2ogpRta20PyFNef/Joe4+p8=
X-Gm-Gg: ASbGncvYdeNjsEgnEHuHqPSZ9QYA+CnykFf2PjQXTQCSklzzmKV6i/+GTGKTLDcuPlk
	RwcVXHKz+M1HZ4OF7qHgpxq6TPq9MqXdWNnAHFa06RWcAZnkgnn+9+ScQxSTnFty76shcErUpTC
	C/kHuL0Ehes+IWgXtYs5ZNjV90ym3b3qxzgiKUq7UXRjLQ+XC5wF3ILaKgPwlOx5whhfQS4F59b
	ViF3kEZm6TKeLctyHpxTQXsC/uXrF3d4UBnoeJjsoBrRNiGO/4SrJ++5A9U8n5ORo1f+YotcIfZ
	7cpCoIwKX2keRO8DKkzFaTJPqm/SXhd3VTUDSi7rQxXtL/u8SdoFs7sX5wnew0rPv7y9xCxrkZF
	Woz+5Ao7usSebXGGOv8bJsIAokfeFdJLawKP8vOTmF+SKKvMb
X-Google-Smtp-Source: AGHT+IGQFCOid1xU/kTL2mXM8U4CeNYlG9RrTgm/Ucs/YfzENunJyjCSeSACd8ELwR+xBvztlldT5w==
X-Received: by 2002:a05:6a21:998c:b0:240:211e:8e0 with SMTP id adf61e73a8af0-240bd286e8bmr3253974637.35.1755158314373;
        Thu, 14 Aug 2025 00:58:34 -0700 (PDT)
Received: from localhost.localdomain ([203.208.189.8])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b4263836324sm21721780a12.10.2025.08.14.00.58.30
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 14 Aug 2025 00:58:34 -0700 (PDT)
From: lizhe.67@bytedance.com
To: david@redhat.com
Cc: alex.williamson@redhat.com,
	farman@linux.ibm.com,
	jgg@nvidia.com,
	jgg@ziepe.ca,
	kvm@vger.kernel.org,
	linux-mm@kvack.org,
	lizhe.67@bytedance.com,
	torvalds@linux-foundation.org
Subject: Re: [PATCH v5 1/5] mm: introduce num_pages_contiguous()
Date: Thu, 14 Aug 2025 15:58:27 +0800
Message-ID: <20250814075827.62858-1-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <b426d3b9-c674-436e-95c3-fcc7647a044b@redhat.com>
References: <b426d3b9-c674-436e-95c3-fcc7647a044b@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, 14 Aug 2025 08:54:44 +0200, david@redhat.com wrote:

> On 14.08.25 08:47, lizhe.67@bytedance.com wrote:
> > From: Li Zhe <lizhe.67@bytedance.com>
> > 
> > Let's add a simple helper for determining the number of contiguous pages
> > that represent contiguous PFNs.
> > 
> > In an ideal world, this helper would be simpler or not even required.
> > Unfortunately, on some configs we still have to maintain (SPARSEMEM
> > without VMEMMAP), the memmap is allocated per memory section, and we might
> > run into weird corner cases of false positives when blindly testing for
> > contiguous pages only.
> > 
> > One example of such false positives would be a memory section-sized hole
> > that does not have a memmap. The surrounding memory sections might get
> > "struct pages" that are contiguous, but the PFNs are actually not.
> > 
> > This helper will, for example, be useful for determining contiguous PFNs
> > in a GUP result, to batch further operations across returned "struct
> > page"s. VFIO will utilize this interface to accelerate the VFIO DMA map
> > process.
> > 
> > Implementation based on Linus' suggestions to avoid new usage of
> > nth_page() where avoidable.
> > 
> > Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
> > Suggested-by: Jason Gunthorpe <jgg@ziepe.ca>
> > Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
> > Co-developed-by: David Hildenbrand <david@redhat.com>
> > Signed-off-by: David Hildenbrand <david@redhat.com>
> > ---
> >   include/linux/mm.h        |  7 ++++++-
> >   include/linux/mm_inline.h | 35 +++++++++++++++++++++++++++++++++++
> >   2 files changed, 41 insertions(+), 1 deletion(-)
> > 
> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index 1ae97a0b8ec7..ead6724972cf 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -1763,7 +1763,12 @@ static inline unsigned long page_to_section(const struct page *page)
> >   {
> >   	return (page->flags >> SECTIONS_PGSHIFT) & SECTIONS_MASK;
> >   }
> > -#endif
> > +#else /* !SECTION_IN_PAGE_FLAGS */
> > +static inline unsigned long page_to_section(const struct page *page)
> > +{
> > +	return 0;
> > +}
> > +#endif /* SECTION_IN_PAGE_FLAGS */
> >   
> >   /**
> >    * folio_pfn - Return the Page Frame Number of a folio.
> > diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> > index 89b518ff097e..5ea23891fe4c 100644
> > --- a/include/linux/mm_inline.h
> > +++ b/include/linux/mm_inline.h
> > @@ -616,4 +616,39 @@ static inline bool vma_has_recency(struct vm_area_struct *vma)
> >   	return true;
> >   }
> >   
> > +/**
> > + * num_pages_contiguous() - determine the number of contiguous pages
> > + *			    that represent contiguous PFNs
> > + * @pages: an array of page pointers
> > + * @nr_pages: length of the array, at least 1
> > + *
> > + * Determine the number of contiguous pages that represent contiguous PFNs
> > + * in @pages, starting from the first page.
> > + *
> > + * In kernel configs where contiguous pages might not imply contiguous PFNs
> > + * over memory section boundaries, this function will stop at the memory
>  > + * section boundary.
> 
> Jason suggested here instead:
> 
> "
> In some kernel configs contiguous PFNs will not have contiguous struct
> pages. In these configurations num_pages_contiguous() will return a
> smaller than ideal number. The caller should continue to check for pfn
> contiguity after each call to num_pages_contiguous().
> "

Thank you for the reminder! The comment here should be revised as
follows:

/**
 * num_pages_contiguous() - determine the number of contiguous pages
 *			    that represent contiguous PFNs
 * @pages: an array of page pointers
 * @nr_pages: length of the array, at least 1
 *
 * Determine the number of contiguous pages that represent contiguous PFNs
 * in @pages, starting from the first page.
 *
 * In some kernel configs contiguous PFNs will not have contiguous struct
 * pages. In these configurations num_pages_contiguous() will return a num
 * smaller than ideal number. The caller should continue to check for pfn
 * contiguity after each call to num_pages_contiguous().
 *
 * Returns the number of contiguous pages.
 */

Thanks,
Zhe

