Return-Path: <kvm+bounces-67629-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id A144AD0BC7B
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 19:03:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8A3FA304C297
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 18:01:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9614F366559;
	Fri,  9 Jan 2026 18:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="mxsaMoPN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52A86350D77
	for <kvm@vger.kernel.org>; Fri,  9 Jan 2026 18:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767981717; cv=none; b=USMTUIgJA7oKCfLGadr5728+8LFBqemcPkuFdq2fnI/rmSGKVdtC7qKKKKo/UsvDJzYG93p8ySkbnppyCIObZVFvmyRQfqsjZbwguxZuj64su4L1zODE/Z1xMeiimgAx7Y4vGfRdjkN65JQivqpbwTY11b/lq2Md4UDZCqYNVSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767981717; c=relaxed/simple;
	bh=8vvLiZ0moy0BqifglQ3lLKAx30/FN3AM0NtBADFZGLE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LG9+6c2LUufAUyyQD/IZXsHxM5dCNkxVZCGHuxBvdpm0iJZzm2D2MP4LXsjGDBbB/McQEoQm+aR/ZOBAPkluVHgRlhua61dxsMz0mltbtcLSCki2Co9ky/u/EPCp70xAAqcBWOr7wJRLzsO2Ss5N7IM7wWvQed4yY+iMPH6G2HM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=mxsaMoPN; arc=none smtp.client-ip=209.85.222.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-8b2d56eaaceso496462185a.0
        for <kvm@vger.kernel.org>; Fri, 09 Jan 2026 10:01:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1767981715; x=1768586515; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+sMzdp/YVlx1Jnjwe36wn7sNt4Xwl0SeqEmouO33xVA=;
        b=mxsaMoPNp3raQJvIVyA/ynyWqlnc2YgDtedCXXWemA1CLdcJ86UmwQxsrAvy0Ps4y/
         OtUFn2O7aYkBYXANK7KYmynhqO8mE2Uy5mTzXHDmTN3R/tuytBeakmsRrZw6GVnc8Ya2
         wpUv0B/dede8/3MQ76k5pKqiwYYkOllM245R0d4KnRH8UOEJn9c7hSCxw9/UB7zGnqfi
         AgZ+xGK9ZNb3P7EV7TZz1NZt22pp4EVSMX0ucyg+cVzJl0YqCotruJYsMNDAsWmdp0Yf
         yMQAk/nIJcUXW3//nj8f/feJl3hf3AyNvuQKx01kJhrWwW/W/llG30lnDAFdf9AkyWWw
         mIHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767981715; x=1768586515;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+sMzdp/YVlx1Jnjwe36wn7sNt4Xwl0SeqEmouO33xVA=;
        b=TpxhVUZmb51bCSbNFAczNYlw1EMorLHogFpFkJpalwpKGwc8nqnrA+tbT7wXYZ1bY9
         EPqrvQxZ2SFwc42F3/8Ls3SwaIDLdOmQ50ycUbg9MgUzsdpnajDydrkV6atLpzj49g7o
         V3gxbBuLn8TRDJYJHJbjTRVJLvxePoXnULEGiEysA+savD+uORDRvQ8oBCWbEgIMAJqW
         nzT8QsCuOqEFCrFoy295/qOOhQWqOAKUCL+kldblkWxqvLISOsuIGvor+BxFtXZ1pE8a
         FoBP5PT8y9HcC1bRKihyQhBGsvzJwJigUY/xwVF/e4eiw4lzrh2ZcJ4WyFabZ56Etetb
         59+w==
X-Forwarded-Encrypted: i=1; AJvYcCWN9/PsFtZOxpZVqugv53LXCbks6tQUJ5ZNFHlFEN50OAgG0SLuLAr1S2og/N9ckhY5V3E=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzws9fkyVDxLF7Ao1x4JNVm/OsyLgDr+FnFuisORrhfnYaDIzmd
	eAGxOHqcHgT4NdySslfN1q5OYuHr//O2v0nAFUTQpTe77KLzB5Ca7/PrTEQrxNH0cdc=
X-Gm-Gg: AY/fxX59+hgKrw0jVY1wf4WndTbU3zL1WVtQfZzx4yhAjYTVzidODZEoUwl05lXS45B
	Gd293R9pyY+iHSmMpcRHgWqxDdrSVe+dgZBs9DXUteVLSkEIek3TCYSe+h8PY4ijSdJp4T+T4tU
	acfXuksYGRKGz7i13h6zENqacl0pojRLztoDudAVs1zwqXMTnzO43flrVVumpzw52GcZkZZxXwW
	wPZ0UITyHFeGtSi89pUI65oKjwlVUAyWutA1N9K7BY316+iD/ZxJMPk/9/9W1N3or3vKyKs264S
	XW3It5eDC8ieU+iq2O7PlhyoC9rALzrl0GC7VBiluToACOZTDEUH6WFc/MYmf1clx0k4qnneWw2
	Lipf+R9Ub/jzAb5i9tz0rupca7AibELB+vBV92ZRhbPWsWeeJEthd9UDV/Uvi1I8nHhTD/314UO
	4yZDDPplWTWgkLvpSF3z+43QzZ+Y3RDQEEDTrUMumeKQ5IAad4vjVnsEyMi3v1oNTnoUI=
X-Google-Smtp-Source: AGHT+IFuH4/syXBn2Q87Uqcqto7RR7Nq5kzUWhGBRuJQqzJjaI4hMXkkvlrpm9zyJZejTp3u6kT6ZA==
X-Received: by 2002:a05:620a:371d:b0:8b2:d72d:e41b with SMTP id af79cd13be357-8c3893ef752mr1235192985a.44.1767981715100;
        Fri, 09 Jan 2026 10:01:55 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-112-119.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.112.119])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c37f51ceb5sm916868785a.35.2026.01.09.10.01.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jan 2026 10:01:54 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1veGo5-000000031Wb-3i4c;
	Fri, 09 Jan 2026 14:01:53 -0400
Date: Fri, 9 Jan 2026 14:01:53 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: David Matlack <dmatlack@google.com>
Cc: Alex Williamson <alex@shazbot.org>, Alex Mastro <amastro@fb.com>,
	Shuah Khan <shuah@kernel.org>, Peter Xu <peterx@redhat.com>,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH] vfio: selftests: Add vfio_dma_mapping_mmio_test
Message-ID: <20260109180153.GI545276@ziepe.ca>
References: <aV8ZRoDjKzjZaw5r@devgpu015.cco6.facebook.com>
 <20260108141044.GC545276@ziepe.ca>
 <20260108084514.1d5e3ee3@shazbot.org>
 <CALzav=eRa49+2wSqrDL1gSw8MpMwXVxb9bx4hvGU0x_bOXypuw@mail.gmail.com>
 <20260108183339.GF545276@ziepe.ca>
 <aWAhuSgEQzr_hzv9@google.com>
 <20260109003621.GG545276@ziepe.ca>
 <aWBPNHOsaP1sNvze@google.com>
 <20260109005440.GH545276@ziepe.ca>
 <CALzav=cBGkhbbyggkfaYh3wfqodxRHZKXTNdnmjoXOgwMouBuA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALzav=cBGkhbbyggkfaYh3wfqodxRHZKXTNdnmjoXOgwMouBuA@mail.gmail.com>

On Fri, Jan 09, 2026 at 09:04:30AM -0800, David Matlack wrote:
> > If you really want to test TYPE1 you need to test what makes it
> > unique, which is that you can map any VMA and then unmap any slice of
> > it. Including within what should otherwise be a 1G page.
> >
> > But I doubt anyone cares enough to fix this, so just exclude
> > VFIO_TYPE1_IOMMU from this test?
> 
> Ah, ok, thanks for the explanation. So VFIO_TYPE1_IOMMU should always
> use 4K mappings regardless of backend (VFIO or iommufd) so that unmap
> can work as intended.

IDK, I think you should just ignore testing TYPE1v0. The actual real
semantics that it had are quite confusing and iommufd provides an
emulation that is going to be functionally OK (indeed, functionally
more capable) but is not the exactly the same.

The old comment here is sort of enlightening:

+        * vfio-iommu-type1 (v1) - User mappings were coalesced together to
+        * avoid tracking individual mappings.  This means that the granularity
+        * of the original mapping was lost and the user was allowed to attempt
+        * to unmap any range.  Depending on the contiguousness of physical
+        * memory and page sizes supported by the IOMMU, arbitrary unmaps may
+        * or may not have worked.  We only guaranteed unmap granularity
+        * matching the original mapping; even though it was untracked here,
+        * the original mappings are reflected in IOMMU mappings.  This
+        * resulted in a couple unusual behaviors.  First, if a range is not
+        * able to be unmapped, ex. a set of 4k pages that was mapped as a
+        * 2M hugepage into the IOMMU, the unmap ioctl returns success but with
+        * a zero sized unmap.  Also, if an unmap request overlaps the first
+        * address of a hugepage, the IOMMU will unmap the entire hugepage.
+        * This also returns success and the returned unmap size reflects the
+        * actual size unmapped.

iommufd does not try to do this "returned unmap size reflects the
actual size unmapped" part, it always unmaps exactly what was
requested, because it disables huge pages.

Jason

