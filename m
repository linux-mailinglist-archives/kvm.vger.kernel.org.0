Return-Path: <kvm+bounces-67273-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 64312D000CE
	for <lists+kvm@lfdr.de>; Wed, 07 Jan 2026 21:47:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 87EF5304A8CB
	for <lists+kvm@lfdr.de>; Wed,  7 Jan 2026 20:46:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F668338F4A;
	Wed,  7 Jan 2026 20:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="Z41Yc77O"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f194.google.com (mail-qt1-f194.google.com [209.85.160.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91E2B318EF6
	for <kvm@vger.kernel.org>; Wed,  7 Jan 2026 20:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767818772; cv=none; b=Jm7vXoB4gb9ILBSDyTR969iL96ReeXZyL/6NGHNfAnlz0I0a4hHDvdyv2mOAOhS5lCU+jxYsGMA09qJ+HrxBlV8ijeQmkmvoYBAukehWnQoDb0xFZ/+KeLjPe+W1BQPqAZc/B31KEBp1XXUYVkL6kFhJhLRwLJsn1tDLZOe0gNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767818772; c=relaxed/simple;
	bh=V1GVCS9K1Qf//sa902zfVHBVWTNmYA6vlf7ykEXvGGI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X6l/gF8dhsrlqW3DjIK7Kqu7qH8yi7+su4pH6WA5XZMZYF4mwLFLBl7pTO27GbyQYgeDvuTtXBgTH+GygP7eVeBnlmsg1GRsN6NafUDCsv7NUqpTxlOOfALegli2efYv8TFUqCcsQaIb0+8FO0NWj+c6xvkccKts/bw/MjI6/XY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=Z41Yc77O; arc=none smtp.client-ip=209.85.160.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qt1-f194.google.com with SMTP id d75a77b69052e-4f1b1948ffaso15907511cf.2
        for <kvm@vger.kernel.org>; Wed, 07 Jan 2026 12:46:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1767818768; x=1768423568; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=DqLGiR8rj/edjA3ZmthNk/CuW8dhDUcDoy+Z3OjEZpY=;
        b=Z41Yc77O+Z2GpUMXvb8qcnyXKdrVGjhmiLyBEvN6Ro4zCT3pbNG1JTMC3wEHjqPCjv
         Tt2Pps2M/sMIIWwiazQv9AM/oWh1R4fSkEoLqa/gfBmCZTBYDlkRXEcY3je8Wa4ogHx9
         i6Q7o13i776LeHlq1VOqv60/8mtjJtBGIOf61G0UKBDP/p7bYl+wL0G7+fda7NWHKa/X
         7teF33trMHadnQcm7ftDKHTLLevO1FbjGG4FcA6dMiHWFme3G5xnkcq2M43P5d5hvz1C
         79GkQ+n4cmusVLI0my1NshDnZgBhGHIjr4sKztdUTYTwhhOR6jGtoSLNpnBIfH+mop53
         hiRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767818768; x=1768423568;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DqLGiR8rj/edjA3ZmthNk/CuW8dhDUcDoy+Z3OjEZpY=;
        b=WNiTS1Oev8WWCgxdKjoKQ+h4SswmIO7z4tHMCbwq7ssSBxa4Nh719Tu3Ei4B55G29M
         TklOD1OPNY3/KKOxwEjaVIrWX/7sp2gZHCXA0zNJF1kZhSoziYY7J2ejhiWSr8cyFuBK
         Nyfm89DS5PsFMTdkeJWLdIzHowuMQvU4uP3c7YMEAZvB+AaTbDnLcVS/MBCLfrGGXHlw
         ndW+Z7PiayhBFSDIlOGB8+GCAqY0mXK0E+cfIR73LCHI8vd7dJtlvTJH/gfO9HplvHM0
         Fwvtgcf3fNgc6VyZilhaqoFvh7dkGbDa3P1P8D1Mt14N9zMdF7FBsQbyEq7rjZBWcxm+
         PuWg==
X-Forwarded-Encrypted: i=1; AJvYcCUQIPCuEYwTB4QWCykJSwihdlnnYX+uvoLIlTledbWIjqqFzF0ywx6jOYZwwZ8P8ww1tOE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yywy/R6D1IP0Oi723z3yvx612RWEIyw2reP/adoc9vHDiFbuz00
	MBHroa2UNiKlSKc8jBhYysKMfsmtS1hb4Q2gcIcV5KjgpRy0/R2GlNpbur7b86I9TnY=
X-Gm-Gg: AY/fxX49U+vc6ELSAtHskWrbyquXJzINlB+R7lJw+mlK1UljOsOaTN2BofNZBKoslrX
	5cOAj06+njk2zdZMrJU3czphcNXgqkGjh+C+BA0iMkPEHkWAmZYtPdRzs9njj82tf+rUlTrXSZM
	Ja8RhA6/rM2TQVYShrt/LGFRwA0aqOWpODvPfeBAGTWOv5I5TN4ssi6uK3gtlJoradngl0M/8Fj
	RVhtCkrGbwuUhzlKdemUVATO+VHm/FSXx71QDPDe6J7mNrebSYMX2muw7pH2nic8lhnACec86yl
	sevCjyqSoXi8i4ZV40YPHVk1rDGsmZ2wJDgczoRA0Z6Hmd5c/nLQiPZvNYn5B0YQgd1DVZoSeR8
	Bl/jVYYtMGiVLeB1DlkRHcVu0W2m8/NvxvBYCsM+ak/qnhtp2nQRFhASxq6OgneApdkrrfklyaD
	sKozA1pN3GvzJ1KjvejsunXu+K+EZFV2kVmYqTFOqQZrDRoqqw+YPJweYBNC5BAg+tsjg=
X-Google-Smtp-Source: AGHT+IGDmyd7kjxIp/jIm0kXF9tq0fAn0CQ3sKUlFYdgvJub9VEiYkmE5sOV0MLJ1rA3hSKtj1n7+A==
X-Received: by 2002:a05:622a:155:b0:4f1:ba0b:90 with SMTP id d75a77b69052e-4ffb48bc30fmr42029251cf.8.1767818768314;
        Wed, 07 Jan 2026 12:46:08 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-112-119.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.112.119])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-89077234c96sm39240416d6.27.2026.01.07.12.46.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jan 2026 12:46:07 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vdaPv-00000002FiH-0jqm;
	Wed, 07 Jan 2026 16:46:07 -0400
Date: Wed, 7 Jan 2026 16:46:07 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Samiullah Khawaja <skhawaja@google.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
	Lu Baolu <baolu.lu@linux.intel.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	David Matlack <dmatlack@google.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex@shazbot.org>, Shuah Khan <shuah@kernel.org>,
	iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
	Adithya Jayachandran <ajayachandra@nvidia.com>,
	Parav Pandit <parav@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>, William Tu <witu@nvidia.com>
Subject: Re: [PATCH 0/3] iommu/vt-d: Add support to hitless replace IOMMU
 domain
Message-ID: <20260107204607.GE340082@ziepe.ca>
References: <20260107201800.2486137-1-skhawaja@google.com>
 <20260107202812.GD340082@ziepe.ca>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260107202812.GD340082@ziepe.ca>

On Wed, Jan 07, 2026 at 04:28:12PM -0400, Jason Gunthorpe wrote:
> On Wed, Jan 07, 2026 at 08:17:57PM +0000, Samiullah Khawaja wrote:
> > Intel IOMMU Driver already supports replacing IOMMU domain hitlessly in
> > scalable mode.
> 
> It does? We were just talking about how it doesn't work because it
> makes the PASID entry non-present while loading the new domain.

If you tried your tests in scalable mode they are probably only
working because the HW is holding the entry in cache while the CPU is
completely mangling it:

int intel_pasid_replace_first_level(struct intel_iommu *iommu,
				    struct device *dev, phys_addr_t fsptptr,
				    u32 pasid, u16 did, u16 old_did,
				    int flags)
{
[..]
	*pte = new_pte;

That just doesn't work for "replace", it isn't hitless unless the
entry stays in the cache. Since your test effectively will hold the
context entry in the cache while testing for "hitless" it doesn't
really test if it is really working without races..

All of this needs to be reworked to always use the stack to build the
entry, like the replace path does, and have a ARM-like algorithm to
update the live memory in just the right order to guarentee the HW
does not see a corrupted entry.

It is a little bit tricky, but it should start with reworking
everything to consistently use the stack to create the new entry and
calling a centralized function to set the new entry to the live
memory. This replace/not replace split should be purged completely.

Some discussion is here

https://lore.kernel.org/all/20260106142301.GS125261@ziepe.ca/

It also needs to be very careful that the invalidation is doing both
the old and new context entry concurrently while it is being replaced.

For instance the placement of cache_tag_assign_domain() looks wrong to
me, it can't be *after* the HW has been programmed to use the new tags
:\

I also didn't note where the currently active cache_tag is removed
from the linked list during attach, is that another bug?

In short, this needs alot of work to actually properly implement
hitless replace the way ARM can. Fortunately I think it is mostly
mechanical and should be fairly straightfoward. Refer to the ARM
driver and try to structure vtd to have the same essential flow..

Jason

