Return-Path: <kvm+bounces-49864-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 348A3ADEA9D
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 13:46:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C3139160BEA
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 11:46:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DFAD284B27;
	Wed, 18 Jun 2025 11:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="QGUzTAdI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0383E2F5328
	for <kvm@vger.kernel.org>; Wed, 18 Jun 2025 11:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750247193; cv=none; b=kyqy+Ynwn2WQD5I6Wz6Dlcai7WXZ/DbFaFdhQkFjpeWD6SMm/lkcZJqG9OZgFY1FhfFnlLE4aJVxwBO7hjMOF6hR9DXtrrRFPWcIwqC+RAd+l4W0O+/HA2jDiStq4kyWREtfRiaKp8ijmxY2D40crpxdYQ6C2KhN19LQ7oSrmEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750247193; c=relaxed/simple;
	bh=BQPuT5fv8iLkb6eIPg3WGtds6HKhuEhOQB+fBvWc7VM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L9Evvy9MHplE1glAnku9MD6VkJUxek5jkyIzXJ6UVhHv+p5DD3ZEp19XFl/0KUcYBmK+Q6iiv1CG4lG30CdPF0xk1KAyGZX3df4nopB2BNPtB7pf3X/xfWBIvZcC/p92R7xuKrRnV29acCF4OEfRY6gR7qH5C98Z4U6WZJWYxF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=QGUzTAdI; arc=none smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-4a58d95ea53so6470401cf.0
        for <kvm@vger.kernel.org>; Wed, 18 Jun 2025 04:46:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1750247191; x=1750851991; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+wxDAXtg4Qo50atD2TXEt4R3fx9+/jlU++z8cat2peU=;
        b=QGUzTAdI694LBdh1Ms/xu3bgW4MI3f7zx6lpx09zu5EcDpyR3HZdQvGe8E1W5Q5or+
         IrIrH8Q8C6llD4p+LeNNmm3iDa74WtKHwNq1hFNo/EL1Z+gH7EiZn9mTsWtjcBgtFhl7
         5MTdrD+WQ1nczjRs2CzRxM6CIG3w3xZ+igJHuRkYFgSlZsqnzTOGUSLZ0fTy8KiWQzdM
         81SLxaha1fYT9i2Fz95sO/EK2oYncpT4mqKiRzWeI6RiItHq7+0T9XDA0HsBVG8VPZ/d
         Fb9UjrwAJ1WwNF8ypcfLFfgld7sf53s3MEldKOtk+qziOeOxk+xkMHUWd4144FrRR74b
         C1VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750247191; x=1750851991;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+wxDAXtg4Qo50atD2TXEt4R3fx9+/jlU++z8cat2peU=;
        b=BfSCPyTmbGvoixTWSwoARE1p3co019ALDX/3eoUHH1Q8IiQypWrBxIICTjRY0xRXWl
         Poj2fLqsWbANHfNRLQWnFQQFDkip/1e/CHRtJftK/3ZSSbC4YkjkDHGbzKqtgda31NGo
         kEOs4w3oeErkS0ZfB7hhSQnCiqsQ4YDMHxxbVseupX3eS9Bg94WUnGLgmri6UseyJiae
         0s6ZD0cWfdwg83FDXXwwhK1g9cEOocfgGVWKN1s9Bh5Fx9K/b599ENaovnCDpzDB9cZX
         wPWqelk0FWMcxmGc/YftvpD9HTTMhKUNDLjre97ClVfPyqSRbQ/w8yl/qEAdMwDrgVG8
         tlQw==
X-Forwarded-Encrypted: i=1; AJvYcCU/+t4RUZ9zLyanfzNtCziwzlND7MojlMBwCao5w2pCUpu3oC0J0wmTzyT9vFRoHF8nqh8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwgQSuO7meOK7RpqQpasaYWFxD4EeTwWqpvpL8ZwnwtW5OQco0V
	Ojm2VIIySMvbXSbFI/c++nqD9+M8DZWzPNic8Uie6jJ2Wr7F9rIcVE2Cao8uvWRhCzc=
X-Gm-Gg: ASbGncstcmrzLU2MnQOkbjqjvDRy7c3aE8yDko2VAXAxFwKoz16DlMO4yg2quX5DBui
	lDmVLemQWL5NzrHsUi1AMBlYm4m/C0muhdhUdRK521IH4PLxecX64qD6ti0eu/ySze7NqRALfGY
	5vYa/PslXOomOW99sT4iXR1fAwKhU38rRtx/4eXuJwPGB9ySrhzMRmR2PvGsso6gqlnOaIczdzQ
	XqRLNMX8QhUAruDcqB+Q8+qiuzppTUZPjWRmAZE0JwKHzImd6RLcEN4/PV+aNQHILKKUm5DbNN0
	I/oxMWEKvvmiYFXKcYhWXizZ7SrzfOniXiSItPtOHt0JO466tj5wNORK3hmL7mE7gzqbpPIgB8U
	tQ7uqskXlPvUZbBhtV8r0OYQseMW86MBkLj0GRA==
X-Google-Smtp-Source: AGHT+IH9ampaEvML5kl4q5XP1ejBHxic8pQJ9EplcrH4aE8+2qiZ3Q+h0D+ADETOd0AZ5S0xxE/VJQ==
X-Received: by 2002:ac8:7d4f:0:b0:4a6:f6e6:7696 with SMTP id d75a77b69052e-4a7645dd6bamr37752941cf.26.1750247190820;
        Wed, 18 Jun 2025 04:46:30 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-167-56-70.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.167.56.70])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4a72a4b148esm72211971cf.40.2025.06.18.04.46.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jun 2025 04:46:30 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1uRrFN-00000006l9d-25JO;
	Wed, 18 Jun 2025 08:46:29 -0300
Date: Wed, 18 Jun 2025 08:46:29 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: David Hildenbrand <david@redhat.com>
Cc: lizhe.67@bytedance.com, akpm@linux-foundation.org,
	alex.williamson@redhat.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, peterx@redhat.com
Subject: Re: [PATCH v4 2/3] gup: introduce unpin_user_folio_dirty_locked()
Message-ID: <20250618114629.GL1376515@ziepe.ca>
References: <20250617152210.GA1552699@ziepe.ca>
 <20250618062820.8477-1-lizhe.67@bytedance.com>
 <20250618113626.GK1376515@ziepe.ca>
 <9c31da33-8579-414a-9b2a-21d7d8049050@redhat.com>
 <a1d62bf1-59e5-4dd5-926a-d6cdddf3deb5@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a1d62bf1-59e5-4dd5-926a-d6cdddf3deb5@redhat.com>

On Wed, Jun 18, 2025 at 01:42:09PM +0200, David Hildenbrand wrote:
> On 18.06.25 13:40, David Hildenbrand wrote:
> > On 18.06.25 13:36, Jason Gunthorpe wrote:
> > > On Wed, Jun 18, 2025 at 02:28:20PM +0800, lizhe.67@bytedance.com wrote:
> > > > On Tue, 17 Jun 2025 12:22:10 -0300, jgg@ziepe.ca wrote:
> > > > > +	while (npage) {
> > > > > +		long nr_pages = 1;
> > > > > +
> > > > > +		if (!is_invalid_reserved_pfn(pfn)) {
> > > > > +			struct page *page = pfn_to_page(pfn);
> > > > > +			struct folio *folio = page_folio(page);
> > > > > +			long folio_pages_num = folio_nr_pages(folio);
> > > > > +
> > > > > +			/*
> > > > > +			 * For a folio, it represents a physically
> > > > > +			 * contiguous set of bytes, and all of its pages
> > > > > +			 * share the same invalid/reserved state.
> > > > > +			 *
> > > > > +			 * Here, our PFNs are contiguous. Therefore, if we
> > > > > +			 * detect that the current PFN belongs to a large
> > > > > +			 * folio, we can batch the operations for the next
> > > > > +			 * nr_pages PFNs.
> > > > > +			 */
> > > > > +			if (folio_pages_num > 1)
> > > > > +				nr_pages = min_t(long, npage,
> > > > > +					folio_pages_num -
> > > > > +					folio_page_idx(folio, page));
> > > > > +
> > > > > +			unpin_user_folio_dirty_locked(folio, nr_pages,
> > > > > +					dma->prot & IOMMU_WRITE);
> > > > 
> > > > Are you suggesting that we should directly call
> > > > unpin_user_page_range_dirty_lock() here (patch 3/3) instead?
> > > 
> > > I'm saying you should not have the word 'folio' inside the VFIO. You
> > > accumulate a contiguous range of pfns, by only checking the pfn, and
> > > then call
> > > 
> > > unpin_user_page_range_dirty_lock(pfn_to_page(first_pfn)...);
> > > 
> > > No need for any of this. vfio should never look at the struct page
> > > except as the last moment to pass the range.
> > 
> > Hah, agreed, that's actually simpler and there is no need to factor
> > anything out.
> 
> Ah, no, wait, the problem is that we don't know how many pages we can
> supply, because there might be is_invalid_reserved_pfn() in the range ...

You stop batching when you hit any invalid_reserved_pfn and flush it.

It still has to check read back and check every PFN to make sure it is
contiguous, checking reserved too is not a problemm.

Jason 


