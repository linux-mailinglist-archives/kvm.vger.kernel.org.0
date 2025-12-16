Return-Path: <kvm+bounces-66088-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 929F0CC5079
	for <lists+kvm@lfdr.de>; Tue, 16 Dec 2025 20:44:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 6ECBF302E968
	for <lists+kvm@lfdr.de>; Tue, 16 Dec 2025 19:44:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0694336ED1;
	Tue, 16 Dec 2025 19:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bcZSVlso";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="MRDNHF16"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 252B63358C0
	for <kvm@vger.kernel.org>; Tue, 16 Dec 2025 19:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765914278; cv=none; b=tXiBTuoYx/84jW0m62ODSQ3esZQfWM1KzKPNTIW2bIBjocz9rcecDXuooRxP1njzaFVMcFPlvPZZFYHlKhpXiey/+1MYEROZWlIhTPqtZl7T6+3u0is2pSuMJMxiaJA/8wTPSAQ38RIE62E/Ol8ayvLcE/5qZR3p9zlHNmpRbZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765914278; c=relaxed/simple;
	bh=6ifwb4jD2Yvr22/ylYYmmJ7+tU8lVupBVEbgDsUoIjM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TJTRAH0ws8EHSONQ54naSy48t3bkmdnZc6IxK09LsFVCPH9v0Ys6Ys4OXbGUWod7Pz9i1X2HMh3AWXK9a6xph0Weo6pfqxT5Zi8F6aCRVhiCGEyXcbzd49rT6x4bPxM7ZSgk3S7sjt6NgKOCFVowDTYl2wShbXEYVsPxVfCc2sI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bcZSVlso; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=MRDNHF16; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765914276;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OWZMfsrJ1GHpp0Gacc8vZFboQMCus5dZjsnuyY0r3Lc=;
	b=bcZSVlsoZpn0OPVHaOaPSrjCaaz7LiV6/tgHQGLhpT+bMNxKD+8xE88gPxHrF/bVyfTYsN
	1EhIOdmUsqT3n0I7MFmrQvfCNDkpglYGDMFItvBSMh6Kc4g7ziIxe0eAIFAyMs2q92aQzH
	taCThUWY2hTpxZNiBLGopXKUHc53Vl8=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-591-Ec99qpNXPjeqAMk8OvIg2w-1; Tue, 16 Dec 2025 14:44:32 -0500
X-MC-Unique: Ec99qpNXPjeqAMk8OvIg2w-1
X-Mimecast-MFC-AGG-ID: Ec99qpNXPjeqAMk8OvIg2w_1765914272
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-88883a2cabbso158006156d6.0
        for <kvm@vger.kernel.org>; Tue, 16 Dec 2025 11:44:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1765914272; x=1766519072; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OWZMfsrJ1GHpp0Gacc8vZFboQMCus5dZjsnuyY0r3Lc=;
        b=MRDNHF16pfU16aj2dNI5YNBzdZc3u50lYBLRQgXCF2EROCNVcVaH80PIeXYvQv1797
         c7xhnxFj40v9HPlssmSrm84dTZFWPiX7FgUDoeCRpoTnOuS6a4xlSQbVXNajXyJrFfQJ
         Z+jqMs/sOxx02bXGz60lVcUKW/1TYh6Voq57AETueEJWGIxzS++VhHuwlxvvzj6ugOHz
         D/xNRVIHPutU9kbawlZSGeoHXTMTDZ04XwgGWIm4ehIBt6ZUzpEVrGU/32xo46hFMqIf
         b4UL6BPjqKl9LWk5P2pq33u5eoh1SjQ1XlqInzE69RZ14ToztVgxMlJQRrETui4FxEXB
         VtgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765914272; x=1766519072;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OWZMfsrJ1GHpp0Gacc8vZFboQMCus5dZjsnuyY0r3Lc=;
        b=BA6WcM+JXCytN/JK0nx4lsBEE+6wELMZ/u/bL5angmYPsoqv1KcCPRHMl6jxuGAjbK
         c32JGFKIuP9Y0PDFlWqw6HbhH1wwRzrFbhQpJTPX17i8fIWLUGWUAwFdwVs6pmojoZqk
         0r0SwBGeU6fPIPPdWidJJI9ScwDh+SAcLp7Q3fl3EGqB3Vty3wCqg9lOlkWLRcYcEIIo
         Hhp9N/wd+FPJ7ZmKpUlcNSdN+3cOHMnFZlIzoED8vUsK/2yfYLV9gCVxCyAh+GPOT7JH
         wndeHS3w+Yh/ztrfnEDbV1LFvM1D1AvtwDrg3A1KXHb12aSPtw/oDeXvUenKmEDJM49h
         T8Wg==
X-Gm-Message-State: AOJu0Yy/ZRI6IljTqdYXothL2Jch3UZY4nQ8cP/6RBf1+imCJij9bVgM
	J6yOMTDtGmK/t7PFtgbkpfTdyK6gWE7zD3UXCPgnalSuPwY6LtpwXUXRtTwipCLTDPw9j63njde
	xSv5sGE/NLKAjKgVvYWGTIyKwkYa+enUjTgbjlvDf1ONhRLs1JGOU5A==
X-Gm-Gg: AY/fxX57DSx4NqHXL0ewRNEfyr0t3uWHVE30D35MCOnUICCTj29fseFEfjX6t/xdLWd
	HiyY3vOVx9IGHbwkxHbTQdgCq9pgeS+38k79V2wrrRpzc6fxiDMV5Ne6BO2fjMfgMbpI7/3Rn8W
	6NgOfxDOGYCPafqzewa/CNy68BhwHnvLnXNHNY5YWaj+3PoJKL9iBWXYq6CHWQ/FbdQiSFfd4e/
	HvpOKChspK9Io2dfRNRoeD8P5nIoENtOBO0XP3EpnFln0V10kIBIIQEtF25zb+FsuzR0RFBOCv7
	qM3sYvFH14cpyk/RwM7yUkwSmfa1Dirdg25Hhav2IEHbqXLX34SSVMCxL3SzE/gF5XS4ThfXIdz
	s1sc=
X-Received: by 2002:a05:622a:5911:b0:4ed:b4ae:f5bb with SMTP id d75a77b69052e-4f1d05fda57mr230282291cf.65.1765914272124;
        Tue, 16 Dec 2025 11:44:32 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGrrpjRFCD1x1zKDvh6gBnxEwhK0Ukm+SrqYrMtn8W42xybAzgzISZS5MGyj4ryNBGs0WxcZA==
X-Received: by 2002:a05:622a:5911:b0:4ed:b4ae:f5bb with SMTP id d75a77b69052e-4f1d05fda57mr230281951cf.65.1765914271709;
        Tue, 16 Dec 2025 11:44:31 -0800 (PST)
Received: from x1.local ([142.188.210.156])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4f345902748sm23150411cf.0.2025.12.16.11.44.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Dec 2025 11:44:31 -0800 (PST)
Date: Tue, 16 Dec 2025 14:44:29 -0500
From: Peter Xu <peterx@redhat.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Nico Pache <npache@redhat.com>, Zi Yan <ziy@nvidia.com>,
	Alex Mastro <amastro@fb.com>, David Hildenbrand <david@redhat.com>,
	Alex Williamson <alex@shazbot.org>, Zhi Wang <zhiw@nvidia.com>,
	David Laight <david.laight.linux@gmail.com>,
	Yi Liu <yi.l.liu@intel.com>, Ankit Agrawal <ankita@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 2/4] mm: Add file_operations.get_mapping_order()
Message-ID: <aUG2ne_zMyR0eCLX@x1.local>
References: <20251204151003.171039-1-peterx@redhat.com>
 <20251204151003.171039-3-peterx@redhat.com>
 <aTWpjOhLOMOB2e74@nvidia.com>
 <aTnWphMGVwWl12FX@x1.local>
 <20251216144427.GF6079@nvidia.com>
 <aUF97-BQ8X45IDqE@x1.local>
 <20251216171944.GG6079@nvidia.com>
 <aUGYjfE7mlSUfL_3@x1.local>
 <20251216185850.GH6079@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20251216185850.GH6079@nvidia.com>

On Tue, Dec 16, 2025 at 02:58:50PM -0400, Jason Gunthorpe wrote:
> On Tue, Dec 16, 2025 at 12:36:13PM -0500, Peter Xu wrote:
> > On Tue, Dec 16, 2025 at 01:19:44PM -0400, Jason Gunthorpe wrote:
> > > On Tue, Dec 16, 2025 at 10:42:39AM -0500, Peter Xu wrote:
> > > > Also see __thp_get_unmapped_area() processed such pgoff, it allocates VA
> > > > with len_pad (not len), and pad the retval at last.
> > > > 
> > > > Please let me know if it didn't work like it, then it might be a bug.
> > > 
> > > It should all be documented then in the kdoc for the new ops, in this
> > > kind of language that the resulting VA flows from pgoff
> > 
> > IMHO that's one of the major benefits of this API, so that there's no need
> > to mention impl details like this.
> 
> It needs to be clearly explained exactly how pgoff and the returned
> order are related because it impacts how the drivers need to manage
> their pgoff space.

Here "pgoff" plays two roles:

  (1) as a range, (pgoff, len) on top of the fd, decides which device blob
      to be mapped.  This is relevant to the driver, for sure..

  (2) as an offset, pgoff is relevant when we want to make sure mmap()
      request's VA will be aligned in a way so that we can maximize huge
      mappings.  This has, IMHO, nothing to do with the driver, and that's
      what I want to make the new API transparent of.

I agree drivers need to know pgoff for (1) in terms of get_mapping_order(),
not (2).

> 
> > Here the point is, the driver should only care about the size of mapping,
> > nothing else like how exactly the alignments will be calculated, and how
> > that interacts with pgoff.  The kernel mm manages that. It's done exactly
> > like what anon thp does already when len is pmd aligned.
> 
> The driver owns the pgoff number space, it has to care about how that
> relates to the PTEs.
> 
> > Or maybe I misunderstood what you're suggesting to document?  If so, please
> > let me know; some example would be greatly helpful.
> 
> Just document the 'VA % order = pgoff % order' equation in the kdoc
> for the new op.

When it's "related to PTEs", it's talking about (2) above, so that's really
what I want to avoid mentioning.

Docuemnt anything about VA is just confusing on its own especially when
"int get_mapping_order(fd, pgoff, len)" doesn't even have anything in param
or retval that is relevant to the virtual address space..

If you think missing such info is harder for reviews, I can definitely add
a rich comment when repost explaining how __thp_get_unmapped_area() works
here.

We can also pause this a bit and wait for Matthew's review on the API,
where he showed concerns.  If there's major reason this API is rejected, we
don't need to bother this part of detail either.

Thanks,

-- 
Peter Xu


