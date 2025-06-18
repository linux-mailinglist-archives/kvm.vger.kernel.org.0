Return-Path: <kvm+bounces-49857-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1EE43ADEA71
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 13:40:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 796134015CE
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 11:38:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58A432E92B0;
	Wed, 18 Jun 2025 11:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="BxnDea7R"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7390B2E8DFF
	for <kvm@vger.kernel.org>; Wed, 18 Jun 2025 11:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750246592; cv=none; b=jH8vCw8fVVpgey7bHDqsUTLyxG27hlJpxUvKEYG1nlT3Gagati5reNq3G0brtLwyTrs9FUR5Sf6brT0q+5HvQ78CZkGjsRloac81zgx03RwqqC4jpXZ3Oq7gXk4ffvk/Oufc7bByNTVERYXw4IT/pef0C2WdaURMA+ecPOn3W0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750246592; c=relaxed/simple;
	bh=LmzNlGu33bNvUvS1lMtzXBfA59WCOHBjyR8h3AOZEfM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KPdAJE/cSfu/5cR3YPpkQHUnpJ3vF/O/DRxraWM0rycN8zbnsV9XEx4d6Vwl1t3Sdip2ggeOG92uigF0prTxOCnbLfHU7XZhqNltwV+1U+iDzRTSUPGQF44Acl8Vfm3SCdQPHtJXxlUuR+4HWfBsG1T+TX2Y7BRZcX1OqL4EhkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=BxnDea7R; arc=none smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-4a58d95ea53so6392641cf.0
        for <kvm@vger.kernel.org>; Wed, 18 Jun 2025 04:36:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1750246589; x=1750851389; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hyfMiE8uuz+y/z3NeyrsTyIcYJmihmEztguDbit+cGo=;
        b=BxnDea7Rgq4GnG37EHz65hjhQ13D4C8Ljb5jahM3HO/PSYiCuezjje71Gff2uP2p8z
         jhKQt81KcCxORwf0FWgFEvBZvQKoZpLOx82m5WlP8SKT+XeiDJJWJzOBRS41st4f0ZS6
         WBo0EeQRhDzguqg8voA1m1JlrQCZL0CI5ngCIehLpHdfk+Ge+Lh/WFo++1gX20u0MtJ9
         yWnhWEfYmjWJTiksqISLNsknpQRsrR30/OTSdT2awUCDLCNvb0gWTI5oFdUIYOKud01P
         qHiHx37KcN1bwYm9CHk/EyZiwUpaFpG0TuCAn6+GNhPfR25LL7D85t+Ztr9eK8AQL3oq
         SvVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750246589; x=1750851389;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hyfMiE8uuz+y/z3NeyrsTyIcYJmihmEztguDbit+cGo=;
        b=ikX/p2B0yKehlowod6Rgirc4WurNZ+pul9v3Ur93WWzNLQ6s/IodMv18ML0jewbXGY
         paykfXzKuOOVyvO8KJxHXWdbgSNig5evmaD3SNWMOB7bRC9yWWJxJOaqucDzjqD+DIGV
         lYGsQLhD79n7qzd5wZnj6eRyGI33RZQptBjc8yehlbT0vgC/kv06ae+IqYzGu7byvP8b
         JhQ6uN3hRYCdqZ3qnPp1gqDVm1fC+v1HlxBZ9CUtbxpyPy86MxkFcYQzpQt0XZ+Z7bz/
         oix8IDYhPLkMGRVcHupYrSDEUZWzBqAx3b/uevcGv/ffs5t4EW0VkAdJS2fnVNMlqXuj
         sC2g==
X-Forwarded-Encrypted: i=1; AJvYcCXRJnTPzvvYc/gGPGObCWjrd+vezl1y2FH9LPpMH43QoNHy7hTbr1SwZkzWYUjw11RBqck=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy88/sxMZ/qvdO7mcc8zWb/7vqM/u7j/Jvo7Jzkygu4PBawS1eY
	kYqibRf1UhHNL5HfNtCUczB0ldYYKGXNMBC/5mCzblhV3y04MRGIyAUOz5AjqYIrEZw=
X-Gm-Gg: ASbGncteg7/31g4XkzZY/0oLZLjUCS0Q74CqjhIm6Rj0zPLGwXqUBRR0174LcWo3tL/
	eus3Wg1iUceLHxV7CubiN6m5nGrZQe3W2i7BioXAUSTol9Ld+Sl1Q2JaNiuxaWCK1AvVLZep10+
	04QuEFv9m3jnyYworH6ibpTwXFFG/UaWhjZc/wz4444BiJqGbmjPPExRwTuHhsLAVns9kWRVMIP
	2CZ6+2dLgLQhELwZHJG8kafc12jlQz39k1YxRO+EhtGxrV5/AGwrttVnIZkeNtYiGzD24Zy7TnD
	s4A8XeGIkhHDEazXnDy0RypuWQmDJUO+3azYKrlbadkP/afLnHx0ckEvIThTYFj6NuWH6t+R6wr
	OQNRkf94ME0rgI2VdGFztGPfBjfyPi5GZ0BdbhA==
X-Google-Smtp-Source: AGHT+IHq1OscbF4KPU5hFbTgPYNzkYK0Dn5e3x8Z/FwfkjMj5kOX5Qmi2rHItfOgV2BwPSbzTJ1zqQ==
X-Received: by 2002:a05:622a:1b8d:b0:4a5:9993:ede8 with SMTP id d75a77b69052e-4a7645b600bmr34414011cf.15.1750246589268;
        Wed, 18 Jun 2025 04:36:29 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-167-56-70.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.167.56.70])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4a72a315c58sm70481041cf.36.2025.06.18.04.36.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jun 2025 04:36:27 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1uRr5e-00000006kyd-3HZk;
	Wed, 18 Jun 2025 08:36:26 -0300
Date: Wed, 18 Jun 2025 08:36:26 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: lizhe.67@bytedance.com
Cc: david@redhat.com, akpm@linux-foundation.org, alex.williamson@redhat.com,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, peterx@redhat.com
Subject: Re: [PATCH v4 2/3] gup: introduce unpin_user_folio_dirty_locked()
Message-ID: <20250618113626.GK1376515@ziepe.ca>
References: <20250617152210.GA1552699@ziepe.ca>
 <20250618062820.8477-1-lizhe.67@bytedance.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250618062820.8477-1-lizhe.67@bytedance.com>

On Wed, Jun 18, 2025 at 02:28:20PM +0800, lizhe.67@bytedance.com wrote:
> On Tue, 17 Jun 2025 12:22:10 -0300, jgg@ziepe.ca wrote:
> > +	while (npage) {
> > +		long nr_pages = 1;
> > +
> > +		if (!is_invalid_reserved_pfn(pfn)) {
> > +			struct page *page = pfn_to_page(pfn);
> > +			struct folio *folio = page_folio(page);
> > +			long folio_pages_num = folio_nr_pages(folio);
> > +
> > +			/*
> > +			 * For a folio, it represents a physically
> > +			 * contiguous set of bytes, and all of its pages
> > +			 * share the same invalid/reserved state.
> > +			 *
> > +			 * Here, our PFNs are contiguous. Therefore, if we
> > +			 * detect that the current PFN belongs to a large
> > +			 * folio, we can batch the operations for the next
> > +			 * nr_pages PFNs.
> > +			 */
> > +			if (folio_pages_num > 1)
> > +				nr_pages = min_t(long, npage,
> > +					folio_pages_num -
> > +					folio_page_idx(folio, page));
> > +
> > +			unpin_user_folio_dirty_locked(folio, nr_pages,
> > +					dma->prot & IOMMU_WRITE);
> 
> Are you suggesting that we should directly call
> unpin_user_page_range_dirty_lock() here (patch 3/3) instead?

I'm saying you should not have the word 'folio' inside the VFIO. You
accumulate a contiguous range of pfns, by only checking the pfn, and
then call 

unpin_user_page_range_dirty_lock(pfn_to_page(first_pfn)...);

No need for any of this. vfio should never look at the struct page
except as the last moment to pass the range.

Jason

