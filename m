Return-Path: <kvm+bounces-65683-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C33E8CB3FCD
	for <lists+kvm@lfdr.de>; Wed, 10 Dec 2025 21:45:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 1BA85301BC9D
	for <lists+kvm@lfdr.de>; Wed, 10 Dec 2025 20:45:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A92693019B2;
	Wed, 10 Dec 2025 20:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Op3lmwBJ";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Zhr1JmDt"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 852911E492D
	for <kvm@vger.kernel.org>; Wed, 10 Dec 2025 20:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765399525; cv=none; b=fNOM0Luv8Zg3s6V6COLIayjfGw8sKC3WREony5azDBcvCz6qfbZuXvagDYiXNtieetoPwO1Q12SxJkjjcRmoR4OBpPeKuOoBS0jDNY85C4DrxbkfVGbeB7js3wP+g1Q6BuK/s/egL89hjnaP7kefPtsYV0uUboPsMffLtZhz3Xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765399525; c=relaxed/simple;
	bh=erN3LFsrewv9M2WhBDnOEPbfNdtL2RO7z/u4FW6ywvc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KUDOhxpsl8U26c0guATHyjjb/pyAPPAruzeYy8q+Bo4QgU89RpFb2y9vnjpCXjUnWDWTHgnJh8QM4d7DfbmwIZhYhKyla/+44UbR92tCuDXXNg4vdMqYvHAeyNcQO4gHqsbVW6zgQ0xZK//GR+vFFJQKQDfbfI0P+SDj/5r+jMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Op3lmwBJ; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Zhr1JmDt; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765399522;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MdaxxiCV8H2eHhp9NcagGoogiR+1MMFcEmWlgLwt4lY=;
	b=Op3lmwBJ8ExNOnAaEWGKVboEGOuoLIBoQEcPXSB1xQBm166dXb+nYyJGmIJq+kVmJXUON4
	Iu1qBkDxrNq82GMk4rZqsKlpLmlrjolf2QK9SyrOqiIQuaHD4bS0Lnb88GsdQXfqbtzEMu
	9hUCPYE1suwc6FXYksx2Rx1LsS/kcvk=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-527-j_YzGKfwOMmIIqn6an0rjw-1; Wed, 10 Dec 2025 15:43:46 -0500
X-MC-Unique: j_YzGKfwOMmIIqn6an0rjw-1
X-Mimecast-MFC-AGG-ID: j_YzGKfwOMmIIqn6an0rjw_1765399426
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-880441e0f93so6782226d6.1
        for <kvm@vger.kernel.org>; Wed, 10 Dec 2025 12:43:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1765399426; x=1766004226; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MdaxxiCV8H2eHhp9NcagGoogiR+1MMFcEmWlgLwt4lY=;
        b=Zhr1JmDtXXxa1wzkd9qt+4YquyhKEy79vPyO5KLiOS8c29a8IxNAYYaGgCvM65w/LB
         ukRBv+ACK/nfJq4CgB4qYXfe353Irasw8qyU4uY8k+Tqa4hMd269DnHgh0bDx4JLx6YA
         LXEEpKMkpPN8KSyPRCkOA4tjb+hiI8les8Ac67lZeJhtoVbr/9REzg4UJa0WTYFfgX8g
         kjArwSNcOMU9SGlK8AOlaD0HUBx2AkXeGaUmOU5NLa7Pudg7BBte61OFWW/u6cTCHy36
         M493DrzSaVcBb4tM21fWR/tihGwsJlXgLUFW2n6YVACud2XWHsBfZiAAmTtMuO9UOUXG
         rGKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765399426; x=1766004226;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MdaxxiCV8H2eHhp9NcagGoogiR+1MMFcEmWlgLwt4lY=;
        b=LtNX7J4C//390mIkAu1wcz1L8+ul/K1iVyGuzXAkCn0qUx7SabpV3EbEaYJgsyeyXy
         VLIIg3GbFdY2ZUnd5E8UTu7IH1GrMSo2SKM8scHcSYFvh+I/ZdjiLOdUHh3lCwRHAU2d
         f5F+T3vs8oEVRSUWq7/cF/4u4ZR/5vHAut5MIggOYLS8TWVHEwr77iOpjTgE/3ybGlqH
         /F+kMIbck4ZMY4I9uHlT6R8uu8bo40pmo4lDV2TEyFdJzGctUk08RRntMoTdnHVE+J/m
         JohQpPuBLKce1LtAZ1dUaVJL3qQzXwlgwaSNpIUHTxbT04aks9TKWMPJbCgpXR3vzhpD
         Q/zg==
X-Gm-Message-State: AOJu0Yy7YEbSwUSEIhB0MS7NUKs0p0FuBiUz8WUJeqnESfnUd5pmvcq6
	lo0KS1FgCCjwnPHJCGDu4SRZ6B9RzQwYaPgEOldyt/FP51e69T5wuUPeu3PLkJFrUltwPZ4ckbR
	4pKYt9VUW4lbbQSxtuYhPWjDRvvN0tVGAsJZk5DEib5miqCHJ0AnUBA==
X-Gm-Gg: AY/fxX4yqD9FC8JVULjT3MqkgI7KPuwHxmfd5cClt8RaRvKd4VMC5PvUCrh3QWNJJMo
	VJb5MRXaFZpTsmz/IPph2GaHS+VADbvF8bls4p/lABtHDsxzWIdAPTgh9L2CIbENHrawrgUrGaf
	d9+k1DYkSwot9tcQWx8inKoS++Nmbg4FngxBMHZCE4APJU/HUnIlivkO7/rB8rCfFGCpy1VPot+
	BZpxx7QC80A0lg3fiuBPC1BzTYni0rmlJYYii/KiUNaka0JD/sRKFd40c1BfGbLia+jbya+FRoQ
	lWXQHf42BMGXSprzO+ScykGzKGHNecksbKvJf2M6xKgLAzJ1jq+dFhlP5BpbMwGe+zTiLyNXJ98
	MYj8=
X-Received: by 2002:a05:6214:21e1:b0:880:51f0:5ba0 with SMTP id 6a1803df08f44-8886f2c85efmr12874416d6.26.1765399425702;
        Wed, 10 Dec 2025 12:43:45 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEMlXnfPx1nwXlxZMeogmX6e8U0uMByKwt0vnr5JltJxNMWxHqIgAvaalVCu7oIuo0OaauRzQ==
X-Received: by 2002:a05:6214:21e1:b0:880:51f0:5ba0 with SMTP id 6a1803df08f44-8886f2c85efmr12873866d6.26.1765399425121;
        Wed, 10 Dec 2025 12:43:45 -0800 (PST)
Received: from x1.local ([142.188.210.156])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8886ef30441sm6054106d6.56.2025.12.10.12.43.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Dec 2025 12:43:44 -0800 (PST)
Date: Wed, 10 Dec 2025 15:43:43 -0500
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
Subject: Re: [PATCH v2 4/4] vfio-pci: Best-effort huge pfnmaps with
 !MAP_FIXED mappings
Message-ID: <aTnbf_dtwOo_gaVM@x1.local>
References: <20251204151003.171039-1-peterx@redhat.com>
 <20251204151003.171039-5-peterx@redhat.com>
 <aTWqvfYHWWMgKHPQ@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aTWqvfYHWWMgKHPQ@nvidia.com>

On Sun, Dec 07, 2025 at 12:26:37PM -0400, Jason Gunthorpe wrote:
> On Thu, Dec 04, 2025 at 10:10:03AM -0500, Peter Xu wrote:
> 
> > +/*
> > + * Hint function for mmap() about the size of mapping to be carried out.
> > + * This helps to enable huge pfnmaps as much as possible on BAR mappings.
> > + *
> > + * This function does the minimum check on mmap() parameters to make the
> > + * hint valid only. The majority of mmap() sanity check will be done later
> > + * in mmap().
> > + */
> > +int vfio_pci_core_get_mapping_order(struct vfio_device *device,
> > +				    unsigned long pgoff, size_t len)
> > +{
> > +	struct vfio_pci_core_device *vdev =
> > +	    container_of(device, struct vfio_pci_core_device, vdev);
> > +	struct pci_dev *pdev = vdev->pdev;
> > +	unsigned int index = pgoff >> (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT);
> > +	unsigned long req_start;
> > +	size_t phys_len;
> > +
> > +	/* Currently, only bars 0-5 supports huge pfnmap */
> > +	if (index >= VFIO_PCI_ROM_REGION_INDEX)
> > +		return 0;
> > +
> > +	/*
> > +	 * NOTE: we're keeping things simple as of now, assuming the
> > +	 * physical address of BARs (aka, pci_resource_start(pdev, index))
> > +	 * should always be aligned with pgoff in vfio-pci's address space.
> > +	 */
> > +	req_start = (pgoff << PAGE_SHIFT) & ((1UL << VFIO_PCI_OFFSET_SHIFT) - 1);
> > +	phys_len = PAGE_ALIGN(pci_resource_len(pdev, index));
> > +
> > +	/*
> > +	 * If this happens, it will probably fail mmap() later.. mapping
> > +	 * hint isn't important anymore.
> > +	 */
> > +	if (req_start >= phys_len)
> > +		return 0;
> > +
> > +	phys_len = MIN(phys_len - req_start, len);
> > +
> > +	if (IS_ENABLED(CONFIG_ARCH_SUPPORTS_PUD_PFNMAP) && phys_len >= PUD_SIZE)
> > +		return PUD_ORDER;
> > +
> > +	if (IS_ENABLED(CONFIG_ARCH_SUPPORTS_PMD_PFNMAP) && phys_len >= PMD_SIZE)
> > +		return PMD_ORDER;
> > +
> 
> This seems a bit weird, the vma length is already known, it is len,
> why do we go to all this trouble to recalculate len in terms of phys?
> 
> If the length is wrong the mmap will fail, so there is no issue with
> returning a larger order here.
> 
> I feel this should just return the order based on pci_resource_len()?

IIUC there's a trivial difference when partial of a huge bar is mapped.

Example: 1G bar, map range (pgoff=2M, size=1G-2M).

If we return bar size order, we'd say 1G, however then it means we'll do
the alignment with 1G. __thp_get_unmapped_area() will think it's not
proper, because:

	loff_t off_end = off + len;
	loff_t off_align = round_up(off, size);

	if (off_end <= off_align || (off_end - off_align) < size)
		return 0;

Here what we really want is to map (2M, 1G-2M) with 2M huge, not 1G, nor
4K.

> 
> And shouldn't the mm be the one aligning it to what the arch can do
> not drives?

Note that here checking CONFIG_ARCH_SUPPORTS_P*D_PFNMAP is a vfio behavior,
pairing with the huge_fault() of vfio-pci driver.  It implies if vfio-pci's
huge pfnmap is enabled or not.  If it's not enabled, we don't need to
report larger orders here.

Said that, this is still a valid point, that core mm should likely also
check against the configs when the kernel was built, though it should not
check against CONFIG_ARCH_SUPPORTS_PMD_PFNMAP.. Instead, it should check
HAVE_ARCH_TRANSPARENT_HUGEPAGE*.

But then... I really want to avoid adding more dependencies to THPs in core
mm on pfnmaps.  I used to decouple THP and huge mappings, that series
wasn't going anywhere, but adding these checks will add more dependencies..

Shall I keep it simple to leave it to drivers, until we have something more
solid (I think we need HAVE_ARCH_HUGE_P*D_LEAVES here)?

Even with that config ready, drivers should always still do proper check on
its own (drivers need to support huge pfnmaps here first before reporting
high orders).  So what I can add into core mm to check arch support would
only be an extra layer of safety net, not much real help but burn some cpu
cycles, IMHO...

Thanks,

-- 
Peter Xu


