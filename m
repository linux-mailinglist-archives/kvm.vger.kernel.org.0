Return-Path: <kvm+bounces-49777-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A3772ADDFA2
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 01:26:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4641917BDD9
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 23:26:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FDA929C33D;
	Tue, 17 Jun 2025 23:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Cr9zbx/z"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15AD81DF75B
	for <kvm@vger.kernel.org>; Tue, 17 Jun 2025 23:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750202794; cv=none; b=L/zLXp0aK3VphkaFNJymnz3kVR3sSY+tDUI+R8glfGN66R/D4eq/idlyV3Lv4LYWEC6lLT/8JqbuakmnpqjtxEfqqWMiSvUOLSz3BIxRd6W+X+pM83atmk0llc4j03n3YxzwAk6HK6rijVFhlWnLc47DqOhw/tGDc5ym5vMw8wc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750202794; c=relaxed/simple;
	bh=a3Bkx9998Qy+wrgZpWrw+TgJZmcL4kioGkDitnYrc1s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Pd0Wy9LgNO9ibWS1WPGIN6c49dyeXHEstLLQORyMCuSx4rar+YHWGzVzRh36AHpwMYxiiyow4l1/Fsa4jTTR9Kj/Vinv2V3WH3kG6Pdc11AeF/QiG3T5VWeMpvaWsmbcy239b3nQs6yMjTZTTH/cLZbblrctdcqrOJfJ60cXBI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Cr9zbx/z; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750202792;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bEsBD5Y/shPQUCHjJaNwvlMTpenqDbmzETQpk04GETY=;
	b=Cr9zbx/zmeorc/VOroDyW4bybh9Q2gnTA6ORRfqFVDvzwemqcC9E9Fw8waGRJ3lGf2i0WZ
	oaV3b/+CtN1jClUunjmvFct/Pj/l/mH0X4OMmBhtEM/pSp0KQbfwKfT8gJ99rt8KBCGh/r
	pWkJUp9LbNIjI/mFGhGokT+Rsi67Rq0=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-124-HE1cMX-MPoaHWHvD3anVjg-1; Tue, 17 Jun 2025 19:26:28 -0400
X-MC-Unique: HE1cMX-MPoaHWHvD3anVjg-1
X-Mimecast-MFC-AGG-ID: HE1cMX-MPoaHWHvD3anVjg_1750202788
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-7d3e90c3a81so15520685a.1
        for <kvm@vger.kernel.org>; Tue, 17 Jun 2025 16:26:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750202788; x=1750807588;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bEsBD5Y/shPQUCHjJaNwvlMTpenqDbmzETQpk04GETY=;
        b=IrMhHEyN7e2QDX+8NO8oDw4HnWjXL465i7F+0IwjyLeV8APv9OWT6HwomrtO7nmzJ2
         XHihxOYpVNPjiQFibLmuaTgPbKScQialYtzlvhGkK+6sDyryrEF2l1OuYhUNrO/60lxd
         arA/AzNuf4RT9pnH08lFMacL7j2xCRTYOM6mZXVStjEE6dvlXAHF5yGc3pVrdNBXw6ez
         3EwQXPzF5Ep8D8J6YjXT01cnkkBNaOTVGfu4cnPE/xXRxIkhTMez60zDt2KiFm/odAeF
         tLdHPz9AKELLkNZAFeutkEBcaH/I5wlnw2w/ZV+0NFwyOrOVIwgMD1s60SoDWWs+H0WX
         0i0Q==
X-Forwarded-Encrypted: i=1; AJvYcCWw5i4tqa7mqggVp6jcM7CDkm3TQSehXg/CGljyraYNnhN+RQOMLHnWL0qrkuzq4z3wEMA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxK5CKJJuwfw+JvHfO1IH+Paxs3DTodRrflX4Evqa1BNWuz0xQG
	lMsh9a1wv82RXUkcPxuK3L7fRRgZIWy7rvedenZjyTqzsD2iz+JLYr917mF/TTA8g18BWkewWop
	S0wA1Odg7/abaENvZ4F7MgAEFKXRnDzQJnkNwMGbaaLkC5faW6iF4sQ==
X-Gm-Gg: ASbGncs6225hgYlAiEfUS9WEnDY0V4fDVpO4uqq6H8PsnZpPSpyYILSPzTnK3fsLE8l
	FMkyLdrs3PIm/tVG1Dod3l37xUerDrMu4TKYw96d4UzuB0EaDAG+ynEcsh1uvmtNVKRxGHZmTK8
	7xFhBD5UIpBIBejJYFutsHn42SN/zzv4X3yAlXO27FPYo2rOIFehv5T4cB26Ais/u0Fg2tFugsw
	cUhjprlvgUxtdA+ttBCqvIN0dYViTqLz0YSA8Nngg+Ada5VhHl1d9qTKqMWNgA8yRGuQDWY72Df
	17NqChgj95GM0w==
X-Received: by 2002:a05:620a:454e:b0:7d3:c4cb:1b76 with SMTP id af79cd13be357-7d3c6cf0880mr2064454385a.41.1750202788281;
        Tue, 17 Jun 2025 16:26:28 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGi3MMf4tNBUwb4DWR6Icb7TRcNxnrJ4m6pAGFQDw3d9WUhT0y7JRmDmGn7yEga4dgomvUXJw==
X-Received: by 2002:a05:620a:454e:b0:7d3:c4cb:1b76 with SMTP id af79cd13be357-7d3c6cf0880mr2064451585a.41.1750202787919;
        Tue, 17 Jun 2025 16:26:27 -0700 (PDT)
Received: from x1.local ([85.131.185.92])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7d3b8dce685sm703341185a.10.2025.06.17.16.26.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jun 2025 16:26:27 -0700 (PDT)
Date: Tue, 17 Jun 2025 19:26:24 -0400
From: Peter Xu <peterx@redhat.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: kernel test robot <lkp@intel.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, kvm@vger.kernel.org,
	oe-kbuild-all@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Zi Yan <ziy@nvidia.com>, Alex Mastro <amastro@fb.com>,
	David Hildenbrand <david@redhat.com>,
	Nico Pache <npache@redhat.com>
Subject: Re: [PATCH 4/5] vfio: Introduce vfio_device_ops.get_unmapped_area
 hook
Message-ID: <aFH5oO1M1_TZz4NF@x1.local>
References: <20250613134111.469884-5-peterx@redhat.com>
 <202506142215.koMEU2rT-lkp@intel.com>
 <aFGMG3763eSv9l8b@x1.local>
 <20250617154157.GY1174925@nvidia.com>
 <aFGcJ-mjhZ1yT7Je@x1.local>
 <aFHEZw1ag6o0BkrS@x1.local>
 <20250617194621.GA1575786@nvidia.com>
 <aFHJh7sKO9CBaLHV@x1.local>
 <20250617230030.GB1575786@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250617230030.GB1575786@nvidia.com>

On Tue, Jun 17, 2025 at 08:00:30PM -0300, Jason Gunthorpe wrote:
> On Tue, Jun 17, 2025 at 04:01:11PM -0400, Peter Xu wrote:
> 
> > > So what is VFIO doing that requires CONFIG_ARCH_SUPPORTS_HUGE_PFNMAP?
> > 
> > It's the fallback part for vfio device, not vfio_pci device.  vfio_pci
> > device doesn't need this special treatment after moving to the new helper
> > because that hides everything.  vfio_device still needs it.
> > 
> > So, we have two ops that need to be touched to support this:
> > 
> >         vfio_device_fops
> >         vfio_pci_ops 
> > 
> > For the 1st one's vfio_device_fops.get_unmapped_area(), it'll need its own
> > fallback which must be mm_get_unmapped_area() to keep the old behavior, and
> > that was defined only if CONFIG_MMU.
> 
> OK, CONFIG_MMU makes a little bit of sense
> 
> > IOW, if one day file_operations.get_unmapped_area() would allow some other
> > retval to be able to fallback to the default (mm_get_unmapped_area()), then
> > we don't need this special ifdef.  But now it's not ready for that..
> 
> That can't be fixed with a config, the logic in vfio_device_fops has
> to be 
> 
> if (!device->ops->get_unmapped_area()
>    return .. do_default thing..
> 
> return device->ops->get_unmapped()
> 
> Has nothing to do with CONFIG_ARCH_SUPPORTS_HUGE_PFNMAP, there are
> more device->ops that just PCI.

IMHO CONFIG_ARCH_SUPPORTS_HUGE_PFNMAP doesn't imply anything PCI specific
either, it only says an arch supports PFNMAP in larger than PAGE_SIZE.
IIUC it doesn't necessarily need to be PCI.

So here in this case, get_unmapped_area() will only be customized if the
kernel is compiled with any possible huge mapping on pfnmaps.  Otherwise
the customized hook isn't needed.

> 
> If you do the API with an align/order argument then the default
> behavior should happen when passing PAGE_SIZE.

This should indeed also work.

I'll wait for comments in the other threads.  So far I didn't yet add the
"order" parameter or anything like it.  If we would like to have the
parameter, I can use it here to avoid the ifdef with PAGE_SIZE / PAGE_SHIFT
/ .... when repost.

Said that, I don't think I understand at all the use of get_unmapped_area()
for !MMU use case.

Thanks,

-- 
Peter Xu


