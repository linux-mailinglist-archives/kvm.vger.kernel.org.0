Return-Path: <kvm+bounces-24295-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BCA25953778
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 17:42:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5FACA285374
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 15:42:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 365AB1AE843;
	Thu, 15 Aug 2024 15:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Zu7vCDH+"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95F3B1AD3F7
	for <kvm@vger.kernel.org>; Thu, 15 Aug 2024 15:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723736508; cv=none; b=g5G/+E+NNQrELOQ7QF95LX3IQMR56OtD7O+WLxf9qiUbGgB5IH0GAxbWEj8lHBCpBAwKwrvKH7jzI7PqVZOk69jY8nj5hgXFMoUn8HUvAzgiZBO8h8krGO/EjdIajgjd+V/iN4Jk75MeTqfHQp4y8gDk2ErDhucg2c7s67IA3RM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723736508; c=relaxed/simple;
	bh=iKftnuoXv++1YtyaUGQI++5wooIkfj0lQ2g4x1O0WsE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q+GKz/VoXf+rxIVe/srxL863TaTb+RnAHly09d9z5fa3vhpHSgYIFP1un+jmx8iAsfRrVVuEoviNE5a4XiJhoRNuD9yLY3g9c5clh0+HFL2U/zk6owYVERZ9mFJtaSMG4hvtHZcEC1Vihg0uh84B/plHTi58Pgay6Wb17fQxFEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Zu7vCDH+; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723736505;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JsmHuSZ/h+8byKlDVdTBZriKwwSluzVcisJkUaNyJWc=;
	b=Zu7vCDH+RhQJl/oY8gdqpxTiBRo1ijAm+Ng6P0oRWlHaDcD0Xx3h/vrBtCJ+j85GDQmDps
	brxNAtZVAes+03hq4qZK8knzFe3bf34tQ7EwNLsZU7KB9784O+7mH6dFo9lMvjLDf/z904
	rYynrUtjlwf3/MZCJIQdhbwEsaFz14c=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-628-m5a_n6QSOuOY6KOP_D64Aw-1; Thu, 15 Aug 2024 11:41:44 -0400
X-MC-Unique: m5a_n6QSOuOY6KOP_D64Aw-1
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-6bf6f1ad75cso1989036d6.3
        for <kvm@vger.kernel.org>; Thu, 15 Aug 2024 08:41:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723736503; x=1724341303;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JsmHuSZ/h+8byKlDVdTBZriKwwSluzVcisJkUaNyJWc=;
        b=YW+AVb+SLhB/skdMYaPStBnjCN005pdWy7vMOZk7p191AHRXt9fratd6AXLsC4xeXw
         L1G+Far+8l1kWIaSMACX+R173HBkuQ/Jus5Cj4Zh23KHkYjSWZzQ8HjffY0jh0nRa/fj
         6tid2PkQDxFdhuv0nY1yQ93RoLK9KOCzkZ518MxVZCsJoWrfpdmN5Sr4KtKrR/XiChWp
         5z2tZhDH1IC2Zp+3xXb22WaWYVDEcWWh6wsUrAvGEboaQJ6Z18edBG982SJnIbUotE42
         hJEb3OL05b5BdBQCCVVLuvTayl+RnfHrEw/Y8b/oGIgokUHFd0vFO0rn6/zGsDDF2So3
         Expw==
X-Forwarded-Encrypted: i=1; AJvYcCXNjvLr+F4BB9Q/uTsPCCQgTlZmYMx9wmY5pEzjNLZKgw648BUwqOBbr0PnBVnlC/9Spug=@vger.kernel.org
X-Gm-Message-State: AOJu0YwUqvtoamzAMYLm925nmPT+cO2qoJ2wD1O3c2MatAEQEn87vehh
	h/MdO9nswhkPiEKM+mLDUULEWTtAEZrXWFKRRklFWLSKHTo8GyCWTrRUYm6ZV/fk1tQA2Jx6PJA
	3oFY2FnxHcI4tsp3dsr/ym3UbTwng9RfQfOgou/bK9mE683wZeg==
X-Received: by 2002:a05:6214:c2a:b0:6b9:9417:c103 with SMTP id 6a1803df08f44-6bf5d15e1c2mr43262766d6.1.1723736503620;
        Thu, 15 Aug 2024 08:41:43 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFzOO1MXixhWkJJiUpcPb8vsKcxQhlblFzoLUtxY92DYm0+isa557XEa9BsKNxw5lcKbfHR8g==
X-Received: by 2002:a05:6214:c2a:b0:6b9:9417:c103 with SMTP id 6a1803df08f44-6bf5d15e1c2mr43262466d6.1.1723736503043;
        Thu, 15 Aug 2024 08:41:43 -0700 (PDT)
Received: from x1n (pool-99-254-121-117.cpe.net.cable.rogers.com. [99.254.121.117])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6bf6ff0c354sm7266716d6.135.2024.08.15.08.41.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Aug 2024 08:41:42 -0700 (PDT)
Date: Thu, 15 Aug 2024 11:41:39 -0400
From: Peter Xu <peterx@redhat.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Sean Christopherson <seanjc@google.com>,
	Oscar Salvador <osalvador@suse.de>,
	Axel Rasmussen <axelrasmussen@google.com>,
	linux-arm-kernel@lists.infradead.org, x86@kernel.org,
	Will Deacon <will@kernel.org>, Gavin Shan <gshan@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Alistair Popple <apopple@nvidia.com>,
	Borislav Petkov <bp@alien8.de>,
	David Hildenbrand <david@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>, kvm@vger.kernel.org,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: Re: [PATCH 09/19] mm: New follow_pfnmap API
Message-ID: <Zr4hs8AGbPRlieY4@x1n>
References: <20240809160909.1023470-1-peterx@redhat.com>
 <20240809160909.1023470-10-peterx@redhat.com>
 <20240814131954.GK2032816@nvidia.com>
 <Zrz2b82-Z31h4Suy@x1n>
 <20240814221441.GB2032816@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240814221441.GB2032816@nvidia.com>

On Wed, Aug 14, 2024 at 07:14:41PM -0300, Jason Gunthorpe wrote:
> On Wed, Aug 14, 2024 at 02:24:47PM -0400, Peter Xu wrote:
> > On Wed, Aug 14, 2024 at 10:19:54AM -0300, Jason Gunthorpe wrote:
> > > On Fri, Aug 09, 2024 at 12:08:59PM -0400, Peter Xu wrote:
> > > 
> > > > +/**
> > > > + * follow_pfnmap_start() - Look up a pfn mapping at a user virtual address
> > > > + * @args: Pointer to struct @follow_pfnmap_args
> > > > + *
> > > > + * The caller needs to setup args->vma and args->address to point to the
> > > > + * virtual address as the target of such lookup.  On a successful return,
> > > > + * the results will be put into other output fields.
> > > > + *
> > > > + * After the caller finished using the fields, the caller must invoke
> > > > + * another follow_pfnmap_end() to proper releases the locks and resources
> > > > + * of such look up request.
> > > > + *
> > > > + * During the start() and end() calls, the results in @args will be valid
> > > > + * as proper locks will be held.  After the end() is called, all the fields
> > > > + * in @follow_pfnmap_args will be invalid to be further accessed.
> > > > + *
> > > > + * If the PTE maps a refcounted page, callers are responsible to protect
> > > > + * against invalidation with MMU notifiers; otherwise access to the PFN at
> > > > + * a later point in time can trigger use-after-free.
> > > > + *
> > > > + * Only IO mappings and raw PFN mappings are allowed.  
> > > 
> > > What does this mean? The paragraph before said this can return a
> > > refcounted page?
> > 
> > This came from the old follow_pte(), I kept that as I suppose we should
> > allow VM_IO | VM_PFNMAP just like before, even if in this case I suppose
> > only the pfnmap matters where huge mappings can start to appear.
> 
> If that is the intention it should actively block returning anything
> that is vm_normal_page() not check the VM flags, see the other
> discussion..

The restriction should only be applied to the vma attributes, not a
specific pte mapping, IMHO.

I mean, the comment was describing "which VMA is allowed to use this
function", reflecting that we'll fail at anything !PFNMAP && !IO.

It seems legal to have private mappings of them, where vm_normal_page() can
return true here for some of the mappings under PFNMAP|IO. IIUC either the
old follow_pte() or follow_pfnmap*() API cared much on this part yet so
far.

> 
> It makes sense as a restriction if you call the API follow pfnmap.

I'm open to any better suggestion to names.  Again, I think here it's more
about the vma attribute, not "every mapping under the memory range".

> 
> > > > + * The mmap semaphore
> > > > + * should be taken for read, and the mmap semaphore cannot be released
> > > > + * before the end() is invoked.
> > > 
> > > This function is not safe for IO mappings and PFNs either, VFIO has a
> > > known security issue to call it. That should be emphasised in the
> > > comment.
> > 
> > Any elaboration on this?  I could have missed that..
> 
> Just because the memory is a PFN or IO doesn't mean it is safe to
> access it without a refcount. There are many driver scenarios where
> revoking a PFN from mmap needs to be a hard fence that nothing else
> has access to that PFN. Otherwise it is a security problem for that
> driver.

Oh ok, I suppose you meant the VFIO whole thing on "zapping mapping when
MMIO disabled"?  If so I get it.  More below.

> 
> > I suppose so?  As the pgtable is stable, I thought it means it's safe, but
> > I'm not sure now when you mentioned there's a VFIO known issue, so I could
> > have overlooked something.  There's no address returned, but pfn, pgprot,
> > write, etc.
> 
> zap/etc will wait on the PTL, I think, so it should be safe for at
> least the issues I am thinking of.
> 
> > The user needs to do proper mapping if they need an usable address,
> > e.g. generic_access_phys() does ioremap_prot() and recheck the pfn didn't
> > change.
> 
> No, you can't take the phys_addr_t outside the start/end region that
> explicitly holds the lock protecting it. This is what the comment must
> warn against doing.

I think the comment has that part covered more or less:

 * During the start() and end() calls, the results in @args will be valid
 * as proper locks will be held.  After the end() is called, all the fields
 * in @follow_pfnmap_args will be invalid to be further accessed.

Feel free to suggest anything that will make it better.

For generic_access_phys() as a specific example: I think it is safe to map
the pfn even after end().  I meant here the "map" operation is benign with
ioremap_prot(), afaiu: it doesn't include an access on top of the mapping
yet.

After the map, it rewalks the pgtable, making sure PFN is still there and
valid, and it'll only access it this time before end():

	if (write)
		memcpy_toio(maddr + offset, buf, len);
	else
		memcpy_fromio(buf, maddr + offset, len);
	ret = len;
	follow_pfnmap_end(&args);

If PFN changed, it properly releases the mapping:

	if ((prot != pgprot_val(args.pgprot)) ||
	    (phys_addr != (args.pfn << PAGE_SHIFT)) ||
	    (writable != args.writable)) {
		follow_pfnmap_end(&args);
		iounmap(maddr);
		goto retry;
	}

Then taking the example of VFIO: there's no risk of racing with a
concurrent zapping as far as I can see, because otherwise it'll see pfn
changed.

Thanks,

-- 
Peter Xu


