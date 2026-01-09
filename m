Return-Path: <kvm+bounces-67496-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id CF01ED06A8F
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 01:56:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 739AE303F0D2
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 00:54:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4475C1E32A2;
	Fri,  9 Jan 2026 00:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="ggX30qBi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E73031EF0B0
	for <kvm@vger.kernel.org>; Fri,  9 Jan 2026 00:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767920084; cv=none; b=Bn9r6RcB5mRbp+hvA0MsgHoimCj8HgBM5lxFIzQHwgPVDHGSZHcGOH3JiSQLg8QCdeBMcp+aYutwBJwZ2iACASap+BG/IHtZ2DP5UU+1EV0xuMHbChn0rf+djT6q9Kq3pzYjC3nG4GVTo9UcEdyj5KOjuhPuLgjtt/mE7z7fMRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767920084; c=relaxed/simple;
	bh=U+ERXgUfSRxYcQMpnmJcQtwAEw2tC+IRhF/3sM+ULAA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O/eXHs/hmLwQ+Gz5c0S5VpSVc9++6sp7V9aTQHHGq+6ZsqTAbyFxOY9rSEIsssqDaOvl6YNKEzyjgiRkqUZkqSDyuDYBNohpB+r9yapOPnHEC5FO4Jm2F6JrPgGshcxjXYzty3w8OlLljuGQLOtcJPYaepUneyLWhPHVPFxL1yA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=ggX30qBi; arc=none smtp.client-ip=209.85.219.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-88a2f2e5445so43739186d6.1
        for <kvm@vger.kernel.org>; Thu, 08 Jan 2026 16:54:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1767920082; x=1768524882; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UAZE/20dBWNTVWUx21XoEWWGeB11q9XckqXbeOgh60E=;
        b=ggX30qBiAA8FaTfWYEYTd5EVPvdmBPZZ6h4Fzhli80Hv/xquejjv4DN09tgGqAvd1y
         yAec770oyGkerbMoZxppKuWLybqrpqz3eU4ml/98fCnvuKO36Za7g4bdnyXAM247sZor
         qSUPOtjBCkrxaXONgBm5oZBIvj4McFWA62b6PeasVvYNnG1QTKH5Gw8uOCMlAyVYNWTU
         xC/ld2DlyymkCDkMBf4KZ1KzJWmHWTMvTe1xeZujFsL1AASI3zXTwp/PncVOgIeToS9s
         1Ei8ETUnTti6nu9Gs281fX3h6wmnHZtyIixVcYSbES5jyy+XBepBS5atgox2y4tDn+HD
         KQNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767920082; x=1768524882;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UAZE/20dBWNTVWUx21XoEWWGeB11q9XckqXbeOgh60E=;
        b=Uukqo+Pth0bHT/lvmeIMTfRQ+TYV/FlE7ZGNchy28vp+zUhoGxkeVa1K9dBY5N/ACR
         wNQEXPL3p7SKXX/7JOM/LPgfL4nxQAmwJ87NGRFwzgrC+HuX/bqJtLwp+eg33GfkPkqm
         iKXjMFK+lj6oDf92dSdXnMoRptqZbSea16X5chx/oudn1zkqXtrG00AKzjcd4ZxO8b2v
         I34cIVDHCl6Mozvutk1HsTQ8tRpZfFig4biO8wwhIo9ETMHRxoJQyW5rhXrylj2kMgrc
         DwDqAbYC2eJyJ8CRHM2xWEdKooEAXnznXIa6WHY4Y5BeBygJefqXtYOM5crpUO2s1ESj
         Kj3g==
X-Forwarded-Encrypted: i=1; AJvYcCVvozhSLtlXVTWFVHSnjH9eEsBx4Ui5YOVItA0vU6HXHzNsz5v4IslLpdbTxQzXITffBKc=@vger.kernel.org
X-Gm-Message-State: AOJu0YzlnBNyjUoFVJW+sYqhY96Hh5L4GOWvQxE0ca2n0Q0gi9XBWKtk
	G6+WjZZW5CcGOMFdO+nBsUpVB3koVrIGaOlX9P7nKWGZDiUVFQ/vc41DznjAbiLr3bk=
X-Gm-Gg: AY/fxX5xx2oO+8zmv/QkG8SJK5hS8u09DBHOD3FByLliLiFaq+wANpxULYaGvSdd4Ug
	m4sg8Pc2mrPJPqx84mcc8bqncOOvfuszQQEic7oc3xQ5bEZ1BybIcYZM01rr46SWVGTrSn8qhVd
	TIrgBtAhENMN/Ht9LwCK9gEzxWdic2jueKNTswehKXHMUa5p+cqaBDEQDAI96UeeZriF7uqAURY
	ravyhlxDYwqPS0mBoFER2IUsxVMyj5s6/XjhQ3ygMx1rNRMIqOMTUFObTtQqMvN8kFFbxUJrvwT
	NxLYEKd2j8iU/SRm7AUdCirZTZSZu0MJPJmaxVnCLiYjIEqh92DfIuT/yZlU+Pmi/+pdsSMV7Sp
	t5t77cuj68s4NcB0Xlm1xlpvib86ll7xOLj9Ta3NA6l13j0bsleBJbszD+ADtnu8cTKJOB1lBge
	7OOl7kyeYGNDkeJCGg+H2c1fv5xLFHXsZuH0sTAmGt/SOd2Qm3p+/dk9iHyLfu+yZEBuk=
X-Google-Smtp-Source: AGHT+IEZs++vifxK2irZp/20XefsAkmL6blTJ2OewTq/V0KD+K9JOYPvZ0wrg4AeAg9Aq7isQibh6Q==
X-Received: by 2002:a05:6214:4509:b0:88a:3c0e:3251 with SMTP id 6a1803df08f44-8908425445emr106914126d6.32.1767920081945;
        Thu, 08 Jan 2026 16:54:41 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-112-119.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.112.119])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8907726041fsm67934866d6.45.2026.01.08.16.54.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jan 2026 16:54:41 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1ve0m0-00000002vlZ-3hDX;
	Thu, 08 Jan 2026 20:54:40 -0400
Date: Thu, 8 Jan 2026 20:54:40 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: David Matlack <dmatlack@google.com>
Cc: Alex Williamson <alex@shazbot.org>, Alex Mastro <amastro@fb.com>,
	Shuah Khan <shuah@kernel.org>, Peter Xu <peterx@redhat.com>,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH] vfio: selftests: Add vfio_dma_mapping_mmio_test
Message-ID: <20260109005440.GH545276@ziepe.ca>
References: <aV7yIchrL3mzNyFO@google.com>
 <20260108005406.GA545276@ziepe.ca>
 <aV8ZRoDjKzjZaw5r@devgpu015.cco6.facebook.com>
 <20260108141044.GC545276@ziepe.ca>
 <20260108084514.1d5e3ee3@shazbot.org>
 <CALzav=eRa49+2wSqrDL1gSw8MpMwXVxb9bx4hvGU0x_bOXypuw@mail.gmail.com>
 <20260108183339.GF545276@ziepe.ca>
 <aWAhuSgEQzr_hzv9@google.com>
 <20260109003621.GG545276@ziepe.ca>
 <aWBPNHOsaP1sNvze@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aWBPNHOsaP1sNvze@google.com>

On Fri, Jan 09, 2026 at 12:43:32AM +0000, David Matlack wrote:
> On 2026-01-08 08:36 PM, Jason Gunthorpe wrote:
> > On Thu, Jan 08, 2026 at 09:29:29PM +0000, David Matlack wrote:
> > > On 2026-01-08 02:33 PM, Jason Gunthorpe wrote:
> > > > On Thu, Jan 08, 2026 at 10:24:19AM -0800, David Matlack wrote:
> > > > > > > Oh, I was thinking about a compatability only flow only in the type 1
> > > > > > > emulation that internally magically converts a VMA to a dmabuf, but I
> > > > > > > haven't written anything.. It is a bit tricky and the type 1 emulation
> > > > > > > has not been as popular as I expected??
> > > > > >
> > > > > > In part because of this gap, I'd guess.  Thanks,
> > > > > 
> > > > > Lack of huge mappings in the IOMMU when using VFIO_TYPE1_IOMMU is
> > > > > another gap I'm aware of.
> > > > > vfio_dma_mapping_test.vfio_type1_iommu_anonymous_hugetlb_1gb.dma_map_unmap
> > > > > fails when IOMMUFD_VFIO_CONTAINER is enabled.
> > > > 
> > > > What is this? I'm not aware of it..
> > > 
> > > It's one of the test cases within
> > > tools/testing/selftests/vfio/vfio_dma_mapping_test.c.
> > > 
> > > Here's the output when running with CONFIG_IOMMUFD_VFIO_CONTAINER=y:
> > > 
> > >   #  RUN           vfio_dma_mapping_test.vfio_type1_iommu_anonymous_hugetlb_1gb.dma_map_unmap ...
> > >   Mapped HVA 0x7f0480000000 (size 0x40000000) at IOVA 0x0
> > >   Searching for IOVA 0x0 in /sys/kernel/debug/iommu/intel/0000:6a:01.0/domain_translation_struct
> > >   Found IOMMU mappings for IOVA 0x0:
> > >   PGD: 0x0000000203475027
> > >   P4D: 0x0000000203476027
> > >   PUD: 0x0000000203477027
> > >   PMD: 0x00000001e7562027
> > >   PTE: 0x00000041c0000067
> > >   # tools/testing/selftests/vfio/vfio_dma_mapping_test.c:188:dma_map_unmap:Expected 0 (0) == mapping.pte (282394099815)
> > >   # dma_map_unmap: Test terminated by assertion
> > >   #          FAIL  vfio_dma_mapping_test.vfio_type1_iommu_anonymous_hugetlb_1gb.dma_map_unmap
> > 
> > I can't think of any reason this would fail, I think your tests have
> > found a real bug?? Can you check into it, what kernel call fails and
> > where does the kernel code come from?
> 
> Oh I thought it was by design. This code in iommufd_vfio_set_iommu():
> 
> 	/*
> 	 * The difference between TYPE1 and TYPE1v2 is the ability to unmap in
> 	 * the middle of mapped ranges. This is complicated by huge page support
> 	 * which creates single large IOPTEs that cannot be split by the iommu
> 	 * driver. TYPE1 is very old at this point and likely nothing uses it,
> 	 * however it is simple enough to emulate by simply disabling the
> 	 * problematic large IOPTEs. Then we can safely unmap within any range.
> 	 */
> 	if (type == VFIO_TYPE1_IOMMU)
> 		rc = iopt_disable_large_pages(&ioas->iopt);
> 
> git-blame says some guy named Jason Gunthorpe wrote it :P

Er, maybe I mis understood the output then?

This is not a "failure" though, the map succeeded and gave a small
page mapping.

This is not reflecting a bug in iommufd but a bug in the TYPE1 support
in VFIO itself because it definitely cannot maintain the required
unmap anywhere semantic if it mapped in a 1G huge page like this.

Basically, if you are mapping with TYPE1 mode then this should be triggered:

        if (!strcmp(variant->iommu_mode, "iommufd_compat_type1"))
                mapping_size = SZ_4K;

And VFIO should be the one to fail, not iommufd.

If you really want to test TYPE1 you need to test what makes it
unique, which is that you can map any VMA and then unmap any slice of
it. Including within what should otherwise be a 1G page.

But I doubt anyone cares enough to fix this, so just exclude
VFIO_TYPE1_IOMMU from this test?

Jason

