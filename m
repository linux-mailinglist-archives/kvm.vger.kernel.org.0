Return-Path: <kvm+bounces-17573-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E4D898C807D
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 06:45:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 616191F21EF4
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 04:45:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1327210A12;
	Fri, 17 May 2024 04:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Oxo0cHVf"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75463D30B
	for <kvm@vger.kernel.org>; Fri, 17 May 2024 04:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715921096; cv=none; b=jpUwQbp2u9dLEWgDzXmfw4sXfjtAnuewK2aoglF6pagc0CL/kfFyCvva1JGjR2IYPJRovGeB1hrkH5hl/9bFrH8qyBTf1jsVqJRXHdsHsgwtQUxCN0GgfPdH8jRdCdybJJLhwwz6VGuYZnc1FWdkIfi+EYGomIm9MEEyKrypVZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715921096; c=relaxed/simple;
	bh=Hyg1w276bZZtvMX+mZmirznVDfUaMn2+t1CYZpDH00U=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hho74PJ6lKbfptnAz3RR1+0lIsJ5x7A/tDn8iAxe87JF/ZDW7jnmKGtFnGyaH6gPXe+eYk7tbMn22ZnhcI2i44jcBYM+rZfR97w5mnt85Winm75XXbUbh6O5zIWrk+GjY/KbXwdhAGc2QaEuyTj/KjdvBSyrix1wTF98ZgnahW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Oxo0cHVf; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715921092;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+Pho0BMrYFF2YDAB5tlU7tWcVNwJsnl8ML6imB+XGp8=;
	b=Oxo0cHVfA0tfktsn5sSyBk9XTA3w00rgByriVunCpfNPOolv5b4Cs6SS6YPskttwqc9INb
	8V37nSWAFg8onmzNsAMnnkrOMXRvriM2hAvCxCHUCLjmlODhXU7ztpOGDm6OOHXEbZzzhP
	13R5xp39BNleN/iMSWDrsP4SBSENSr0=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-532-kMi0aCjRMFyVskev3XSvFw-1; Fri, 17 May 2024 00:44:50 -0400
X-MC-Unique: kMi0aCjRMFyVskev3XSvFw-1
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-7e1d7031f4aso689482839f.1
        for <kvm@vger.kernel.org>; Thu, 16 May 2024 21:44:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715921090; x=1716525890;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+Pho0BMrYFF2YDAB5tlU7tWcVNwJsnl8ML6imB+XGp8=;
        b=i2IKvpV02BG2smyMs2wawr7zgdAnxSqYF5cLj4uFwmj5wLT/FCcf2OEc812CB9Z+VN
         od6/NUOgJ2OeY4FmTNEnwWEA95Y3vWLH9m2sxdwmbqZzc7IwKRVSWJ0d5iB5cBgsk8+6
         5NqXRFnJBgF3T2yXLjtqPGDtyKybAiTBS4xd4m7xgbzNGd2m8JczrD7BF2+fMqe/jxAX
         vn47DrESNUcPpYNkUAhg7/S91VqGx+1Vx9/ahqq0BhaU60JeEuP/LD1A+jXULiA8OgbJ
         sNT5dvF3xK6SXaX//+7G+Xdm+oOb/pdA1VkyU6BpRVQFKrr7K7iJgRXIcKNrKHLJ2z5m
         3iHA==
X-Gm-Message-State: AOJu0Yz4naX5wh6johUo3HB2GnijnAEIo+fe4l6LZSdarA7IRqssvDTG
	+BoKKbVf0lTGICaLfIhDdf5lcmVgzcN8eEttz4/d2PjLFWZmnFX611Jw51SmHwpQ5bAmfob/LXm
	P/ymML9nzkoOoTVEm06Wjz/pMNI2c/A6qQ6zYG7WCEgWPwUyPEw==
X-Received: by 2002:a5e:c702:0:b0:7de:dbcf:b67f with SMTP id ca18e2360f4ac-7e1b5229628mr2108277339f.21.1715921090098;
        Thu, 16 May 2024 21:44:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF8SJkDmskTL1TlkipsUfaSNL7CgupEzTaNdCDxXRpHof+4T200uekUmWGBuKMc6pRxG0+GtQ==
X-Received: by 2002:a5e:c702:0:b0:7de:dbcf:b67f with SMTP id ca18e2360f4ac-7e1b5229628mr2108275439f.21.1715921089725;
        Thu, 16 May 2024 21:44:49 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-489375c1a86sm4497757173.105.2024.05.16.21.44.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 May 2024 21:44:49 -0700 (PDT)
Date: Thu, 16 May 2024 22:44:42 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
 <jgg@nvidia.com>, <kevin.tian@intel.com>, <iommu@lists.linux.dev>,
 <pbonzini@redhat.com>, <seanjc@google.com>, <dave.hansen@linux.intel.com>,
 <luto@kernel.org>, <peterz@infradead.org>, <tglx@linutronix.de>,
 <mingo@redhat.com>, <bp@alien8.de>, <hpa@zytor.com>, <corbet@lwn.net>,
 <joro@8bytes.org>, <will@kernel.org>, <robin.murphy@arm.com>,
 <baolu.lu@linux.intel.com>, <yi.l.liu@intel.com>
Subject: Re: [PATCH 4/5] vfio/type1: Flush CPU caches on DMA pages in
 non-coherent domains
Message-ID: <20240516224442.56df5c23.alex.williamson@redhat.com>
In-Reply-To: <ZkbK9CzmcxgqhSuR@yzhao56-desk.sh.intel.com>
References: <20240507061802.20184-1-yan.y.zhao@intel.com>
	<20240507062138.20465-1-yan.y.zhao@intel.com>
	<20240509121049.58238a6f.alex.williamson@redhat.com>
	<Zj33cUe7HYOIfj5N@yzhao56-desk.sh.intel.com>
	<20240510105728.76d97bbb.alex.williamson@redhat.com>
	<ZkG9IEQwi7HG3YBk@yzhao56-desk.sh.intel.com>
	<20240516145009.3bcd3d0c.alex.williamson@redhat.com>
	<ZkbK9CzmcxgqhSuR@yzhao56-desk.sh.intel.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 17 May 2024 11:11:48 +0800
Yan Zhao <yan.y.zhao@intel.com> wrote:

> On Thu, May 16, 2024 at 02:50:09PM -0600, Alex Williamson wrote:
> > On Mon, 13 May 2024 15:11:28 +0800
> > Yan Zhao <yan.y.zhao@intel.com> wrote:
> >   
> > > On Fri, May 10, 2024 at 10:57:28AM -0600, Alex Williamson wrote:  
> > > > On Fri, 10 May 2024 18:31:13 +0800
> > > > Yan Zhao <yan.y.zhao@intel.com> wrote:
> > > >     
> > > > > On Thu, May 09, 2024 at 12:10:49PM -0600, Alex Williamson wrote:    
> > > > > > On Tue,  7 May 2024 14:21:38 +0800
> > > > > > Yan Zhao <yan.y.zhao@intel.com> wrote:      
> ...   
> > > > > > > @@ -1683,9 +1715,14 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
> > > > > > >  	for (; n; n = rb_next(n)) {
> > > > > > >  		struct vfio_dma *dma;
> > > > > > >  		dma_addr_t iova;
> > > > > > > +		bool cache_flush_required;
> > > > > > >  
> > > > > > >  		dma = rb_entry(n, struct vfio_dma, node);
> > > > > > >  		iova = dma->iova;
> > > > > > > +		cache_flush_required = !domain->enforce_cache_coherency &&
> > > > > > > +				       !dma->cache_flush_required;
> > > > > > > +		if (cache_flush_required)
> > > > > > > +			dma->cache_flush_required = true;      
> > > > > > 
> > > > > > The variable name here isn't accurate and the logic is confusing.  If
> > > > > > the domain does not enforce coherency and the mapping is not tagged as
> > > > > > requiring a cache flush, then we need to mark the mapping as requiring
> > > > > > a cache flush.  So the variable state is something more akin to
> > > > > > set_cache_flush_required.  But all we're saving with this is a
> > > > > > redundant set if the mapping is already tagged as requiring a cache
> > > > > > flush, so it could really be simplified to:
> > > > > > 
> > > > > > 		dma->cache_flush_required = !domain->enforce_cache_coherency;      
> > > > > Sorry about the confusion.
> > > > > 
> > > > > If dma->cache_flush_required is set to true by a domain not enforcing cache
> > > > > coherency, we hope it will not be reset to false by a later attaching to domain 
> > > > > enforcing cache coherency due to the lazily flushing design.    
> > > > 
> > > > Right, ok, the vfio_dma objects are shared between domains so we never
> > > > want to set 'dma->cache_flush_required = false' due to the addition of a
> > > > 'domain->enforce_cache_coherent == true'.  So this could be:
> > > > 
> > > > 	if (!dma->cache_flush_required)
> > > > 		dma->cache_flush_required = !domain->enforce_cache_coherency;    
> > > 
> > > Though this code is easier for understanding, it leads to unnecessary setting of
> > > dma->cache_flush_required to false, given domain->enforce_cache_coherency is
> > > true at the most time.  
> > 
> > I don't really see that as an issue, but the variable name originally
> > chosen above, cache_flush_required, also doesn't convey that it's only
> > attempting to set the value if it wasn't previously set and is now
> > required by a noncoherent domain.  
> Agreed, the old name is too vague.
> What about update_to_noncoherent_required?

set_noncoherent?  Thanks,

Alex

> Then in vfio_iommu_replay(), it's like
> 
> update_to_noncoherent_required = !domain->enforce_cache_coherency && !dma->is_noncoherent;
> if (update_to_noncoherent_required)
>          dma->is_noncoherent = true;
> 
> ...
> if (update_to_noncoherent_required)
> 	arch_flush_cache_phys((phys, size);
> >   
> > > > > > It might add more clarity to just name the mapping flag
> > > > > > dma->mapped_noncoherent.      
> > > > > 
> > > > > The dma->cache_flush_required is to mark whether pages in a vfio_dma requires
> > > > > cache flush in the subsequence mapping into the first non-coherent domain
> > > > > and page unpinning.    
> > > > 
> > > > How do we arrive at a sequence where we have dma->cache_flush_required
> > > > that isn't the result of being mapped into a domain with
> > > > !domain->enforce_cache_coherency?    
> > > Hmm, dma->cache_flush_required IS the result of being mapped into a domain with
> > > !domain->enforce_cache_coherency.
> > > My concern only arrives from the actual code sequence, i.e.
> > > dma->cache_flush_required is set to true before the actual mapping.
> > > 
> > > If we rename it to dma->mapped_noncoherent and only set it to true after the
> > > actual successful mapping, it would lead to more code to handle flushing for the
> > > unwind case.
> > > Currently, flush for unwind is handled centrally in vfio_unpin_pages_remote()
> > > by checking dma->cache_flush_required, which is true even before a full
> > > successful mapping, so we won't miss flush on any pages that are mapped into a
> > > non-coherent domain in a short window.  
> > 
> > I don't think we need to be so literal that "mapped_noncoherent" can
> > only be set after the vfio_dma is fully mapped to a noncoherent domain,
> > but also we can come up with other names for the flag.  Perhaps
> > "is_noncoherent".  My suggestion was more from the perspective of what
> > does the flag represent rather than what we intend to do as a result of
> > the flag being set.  Thanks,   
> Makes sense!
> I like the name "is_noncoherent" :)
> 


