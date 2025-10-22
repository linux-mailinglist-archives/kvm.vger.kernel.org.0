Return-Path: <kvm+bounces-60816-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6984DBFBA68
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 13:34:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1C55F480C2E
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 11:34:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66F4133C534;
	Wed, 22 Oct 2025 11:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="Be+Bb8Fr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5EB2CA6B
	for <kvm@vger.kernel.org>; Wed, 22 Oct 2025 11:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761132839; cv=none; b=F55omolKqluQVaToDMuYgAEN03VIAI4cfVNLIEpju06uUbj/+sURbSGJtHc/0fZ56vjZoh1T2DDjDEB0pYtzCrmZe5NdPItmn4n2LMi6CwBYtSrCcqbLl+BfeM+H7hxUwTyH4hFMw4C6S5pQJfX7KDjV3GnUMm8TadTqQiTWbFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761132839; c=relaxed/simple;
	bh=5D2S8gFfpVrKc3T92fAN4H9FX1Y9Iry3sLfgM0BoAU4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gQz3Ki5iu8kz8NGFUgitWA1Idy/ChCKxVhXg68K+a4HllpRQ7/Ocm++CilMLV31YOY03gYDmfkzQOiHDLlSBSzdnofH5N6U8GBV05pDHjd9jtrtpRcIGp0XNhC1mAPXtjhrS0Lttb4Qpl++ExWygM+GpL4kNqiJIEE0MAu1d4DA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=Be+Bb8Fr; arc=none smtp.client-ip=209.85.222.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-890521c116fso780439785a.3
        for <kvm@vger.kernel.org>; Wed, 22 Oct 2025 04:33:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1761132837; x=1761737637; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=YzMuyf16b+hUTaqBectyipp8bmob3UCKigy6YT4wr2s=;
        b=Be+Bb8FrzKfRQBTJRLU5n0CXEUTu+Y9sZjOyhB8el5VRPfWtkZbZRhj58YGLhm3yYO
         RwoACf43B0phf7SUdYK/gyYUaupxgKl2zb2Ela5lkrYHrPY6BJCJBrt1ub2NQ6lnugNO
         8/Ei3NwJBj+UBF4RzGYDZpAet7qEIDdSLvIZe8TAvsvCv+KjObamm/Tv1cIrjLoDF2wt
         et3tuAdibQ+H6nAABYIaVhvQ/i1Soikh4Ob+8+zywMNnBopoz3bJT3p5zRfwnuiW+Xfn
         nzKC58OAmeECN64Lw/ZdJmP5XQMCw7zh3UG2KpNzNdJanUolt5W2JUNeLdgKrU+X00WC
         eV1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761132837; x=1761737637;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YzMuyf16b+hUTaqBectyipp8bmob3UCKigy6YT4wr2s=;
        b=pCcFdtrqIO9DLWUO3dhGgRtgZJ24ildQWXM1RgEpmz+8snr61T+j1OF89Woduf1y2O
         PsplDmTXPqnLE/R9+DSN2bqsbt8YPW9rK8PzZlVU/BrSFDAhcLIZv9RJTMc2TYMJa41q
         fa9Wlz4CDhRdpYkRfMhvRmAGb1vmdSPFniFycdZ6lbxwypdm+yCE1kcp9+V4+pnyNMzK
         ljkaF6UDhEdpFcXFr5jY36cDqP1OMO3zqua9Tum8yvfjPJZStdAxVKB0zu2UGpuOSG77
         Y7IpwuxdmXjqTlz2Gu4kaPuWZ8HL3rj6fh+o3rOD4s8McyFwZAkKWEvZd40dvm2ByHof
         UABQ==
X-Forwarded-Encrypted: i=1; AJvYcCWqIzrJdvcsf8vdxv90TBHYFwSMnK9bMiH5+iqrbyVMpSmnK0qL7i3gCu/Reaznn/dgZVw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwQxrz2JLBGg59nFy7hZLDBMpyPkYRZ7yM5j+fRvq9SEnynxzyG
	i5YdtJa9MiWGpllUDXa3UYDkoV85uij6W7y2uOLmOo3Bu4D/1RwEsru4U2UE6xfRWVE=
X-Gm-Gg: ASbGncvt9aEZeEHfQS6pO071L6Vmj78ZvTu1b+GtuktI+NdJz+fCowZg6liZegguU7e
	V1fcGRdWScUnI+4dlbAdd3dFNYLP6yDv1ZajoESDUvT2y9zC5xo2imYZ/Xo7LgwauuTVSMjHrjs
	fKlAeDKWCPDC3yTdE+ckaQqBUlG+bQEJGm5WwEn2lXZBwyn63zcb0pLwjIacA9menTgJM+p5eGB
	uUzGqagG6WsdXLx89V1MbFKqc4YvYf4PvV8XW1SVJySoLrjtGUMaF6BhXSHV1LQzYlG0SAZ5AhS
	pe55lYn3UA7ihYhWK3fMDCTHAD6OvfrT2hpFfPXI6w8oeddqo3qMvZF2zMVM/k+RRX13YNAYsJA
	P/LFgNvkyfUl1V6vwy7LhzHTXLPbWa23RsIDCnnH3XBBdCLRukR7tqmftPe0wxPzJ+ZxZhL1H3O
	c2uUiKHWyyEiYIrsDF9IN/lgEznoNdI3M07OLm6WLlNkPebA==
X-Google-Smtp-Source: AGHT+IGcoJwXXqdtQtkm+G14JGdvXbaacdM5SDyQ7Xv4vGpp8puPf7A40E+xXVk1VpdF6uCqgx+zZQ==
X-Received: by 2002:a05:620a:4694:b0:891:ef6d:5231 with SMTP id af79cd13be357-891ef6d5476mr1901298585a.49.1761132836585;
        Wed, 22 Oct 2025 04:33:56 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-891cf0af3afsm962961585a.36.2025.10.22.04.33.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Oct 2025 04:33:55 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vBX6J-000000011YP-0ehF;
	Wed, 22 Oct 2025 08:33:55 -0300
Date: Wed, 22 Oct 2025 08:33:55 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: =?utf-8?Q?Micha=C5=82?= Winiarski <michal.winiarski@intel.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Thomas =?utf-8?Q?Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>, intel-xe@lists.freedesktop.org,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	Matthew Brost <matthew.brost@intel.com>,
	Michal Wajdeczko <michal.wajdeczko@intel.com>,
	dri-devel@lists.freedesktop.org,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Lukasz Laguna <lukasz.laguna@intel.com>
Subject: Re: [PATCH v2 26/26] vfio/xe: Add vendor-specific vfio_pci driver
 for Intel graphics
Message-ID: <20251022113355.GC21554@ziepe.ca>
References: <20251021224133.577765-1-michal.winiarski@intel.com>
 <20251021224133.577765-27-michal.winiarski@intel.com>
 <aPiDwUn-D2_oyx2T@infradead.org>
 <ilv4dmjtei7llmoamwdjb3eb32rowzg6lwpjhdtilouoi6hyop@xnpkhbezzbcv>
 <aPib0tHn1yK9qx2x@infradead.org>
 <4e6ctwhyax2v65mgj3pud5z3vz75yputis6oufju45iptzaypq@zaxo42l23o2r>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4e6ctwhyax2v65mgj3pud5z3vz75yputis6oufju45iptzaypq@zaxo42l23o2r>

On Wed, Oct 22, 2025 at 11:12:05AM +0200, Michał Winiarski wrote:
> On Wed, Oct 22, 2025 at 01:54:42AM -0700, Christoph Hellwig wrote:
> > On Wed, Oct 22, 2025 at 10:52:34AM +0200, Michał Winiarski wrote:
> > > On Wed, Oct 22, 2025 at 12:12:01AM -0700, Christoph Hellwig wrote:
> > > > There is absolutely nothing vendor-specific here, it is a device variant
> > > > driver.  In fact in Linux basically nothing is ever vendor specific,
> > > > because vendor is not a concept that does matter in any practical sense
> > > > except for tiny details like the vendor ID as one of the IDs to match
> > > > on in device probing.
> > > > 
> > > > I have no idea why people keep trying to inject this term again and
> > > > again.
> > > 
> > > Hi,
> > > 
> > > The reasoning was that in this case we're matching vendor ID + class
> > > combination to match all Intel GPUs, and not just selected device ID,
> > > but I get your point.
> > 
> > Which sounds like a really bad idea.  Is this going to work on i810
> > devices?  Or the odd parts povervr based parts?
> 
> It's using .override_only = PCI_ID_F_VFIO_DRIVER_OVERRIDE, so it only
> matters if the user was already planning to override the regular driver
> with VFIO one (using driver_override sysfs).
> So if it worked on i810 or other odd parts using regular vfio-pci, it
> would work with xe-vfio-pci, as both are using the same underlying
> functions provided by vfio-pci-core.

I also would rather see you list the actual working PCI IDs :|

Claiming all class devices for a vendor_id is something only DRM
does..

Jason

