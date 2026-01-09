Return-Path: <kvm+bounces-67495-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 480FAD06A2B
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 01:44:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6E739303E666
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 00:43:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AC5B1E633C;
	Fri,  9 Jan 2026 00:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RpwsC0xk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ADA2199949
	for <kvm@vger.kernel.org>; Fri,  9 Jan 2026 00:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767919420; cv=none; b=fvZR/TrIEHpgX6T2tnqlZuWGpy+o8uxWKWnhGQpZtI98Y247CULQZwZIW/1PTbFUP+xbl/KjFxPq8hFXU0KN0nnPPsyqIvSX9wVRByI6jGP52vtTmBD+lkHt1+q0ZDZHg3r0s7M9Kl2XMBg7VebamEsBJyegtW4+A7GQ66at4sQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767919420; c=relaxed/simple;
	bh=ImDAJpc9ddBxn/RspOb1AGWqX/jNoxkwypOF+YVbFcs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WdlDIZongCosn0gQil5K9u70oKM66HtMyWYJ4TWznVMJV0RFomOt+Cnl9FWdt9me21gtJ5yjJgJGSwCOdau0qOCKPzl9KNs8rfQcwUuZ15TaO7nGf9EPdEpDWSF6CswukzH5WgM0oV/vFRZOpABBrcDECdstOtYl8EOYyJ1KeWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RpwsC0xk; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-bcfd82f55ebso1154215a12.1
        for <kvm@vger.kernel.org>; Thu, 08 Jan 2026 16:43:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767919418; x=1768524218; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=51Qhk2QpnbWrPEp1VkKAc+tmXRgpBzJvdiLMKXqgx5g=;
        b=RpwsC0xkp9rLpmsg2bvNE/bSM6iEBV+x+zCWw3i5omEksd/vTmnE7JskK3S8K8yMOc
         is2ST26zXU08oVq5wL2bK5nNPuw4i9JV8VKFA8a4yKVoj88XnLKMc5rAhiklkFrK0DKy
         w4eFGgAuMPO8s5bnGIRseh2mSzgl0j9PZLsgj7+QfvqFJjUkX8aBbujy+J5VC046LCz2
         bFN7WYBO6PqjO0JldjCqejOjpR8e5hpvlTN3lXRv7rxv0fLCrQ2Y7nRcEe5kPvaITcDg
         pozq7u72ZxWNspFh8pFYH9o3qICzvQ2JvFD1KeDiYjZna7nV3feFyA/Ppn58GMcptqX+
         xlKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767919418; x=1768524218;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=51Qhk2QpnbWrPEp1VkKAc+tmXRgpBzJvdiLMKXqgx5g=;
        b=byQsLQeDK8pGJLRxhvAb8aQRvnTErq6Vhp0G5RamrMPnxidqYjG26gcgX1xP/+lx5h
         EQuGb2Dgq+dmkfjIbAelTFUHIaP6S+2UgxODk5mUffqhBXfha+4xcLQm/d1ZU1RRgIu/
         byhmVybANzn7IncUlz4VPvFD7mQg4bX0Qp0scX47jggjccKbRIlu7vhMEJk/ATsIAI3E
         a9ZdWB2NuDqLCP+Bq1arucbuzt0Py98RwVaa1OG+B4bKuUCLOkAMX6Zf/gJ24PPWYDgP
         e5/nhVeYKfVSY6C9lPtqslm2CQJ36iLBmJ/no7gIoVjJW2D1mzI0PQgR1tdxHNCBu88A
         n65w==
X-Forwarded-Encrypted: i=1; AJvYcCXEgclFXC5sRsFDwDw+O/VNuP+rh4lIGxDM2CVpUBj8y6h5KfwI2QOJ8Tx96dw6/0z2LNo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw1xNNoSymcQSNs9V2V9EGyNMbdMSqeIl8fFKdIcVGJvzQ88hiU
	JEaNOHdoFYzbhw+D0c5Rg0PbYt6xCYxi32hCvcMyh7/9IJrjeAQicazsXRBts9pShg==
X-Gm-Gg: AY/fxX7n5jjLaHGNuk+kdep9NYjwTgSLzYELd+OGyLm6yyuiAT8hynwdNioR/0CG97q
	VVaVxiFXZi4mROSsKJ9kJoZ9uqN02h9vAKKAu5eQB89xesQ0FIsPBfdnLyBhoyG0y3VixmpXlwp
	xv9O7tHg4BisHec/6c7Lzv8M4KJvp+Iu+M4shr4j7/4656QaMLcFOtjZPNtjdUdpR/NQX4AcgxT
	uFiVXHY+wYgiz2sAqh+zCjjen3kDcNFqPo9cGS1rHKhQYJTgXH8fSO8t5HHb5+bbBCM/JqyV3aM
	BIN67Jtq0Ei3/GRvE01e0A9hN3YP7H2xIf6KLYU2Wky42ZCmaaYYXm1QNXdU7GvnxUTJzedhYNy
	Y3UevvNQv9ibK9DE1IzTykIW47oLavjNFUyKpT6fx6zJ3dzJFqMwIxnh+oP0CIhPHuF6+dtLh0+
	tDGni3h8YElvfBvrr88Y+hIDl9Wm5FeP3gKnusQWdaabt6
X-Google-Smtp-Source: AGHT+IFY3AzA/hqaVzD+wKEUy1ckpWYyBi6bM8hjoLRfJLC75Sr8twLClEK01ALzwBO0jLOSqxhH8g==
X-Received: by 2002:a17:90b:568d:b0:343:e692:f8d7 with SMTP id 98e67ed59e1d1-34f68c01825mr7895194a91.11.1767919418342;
        Thu, 08 Jan 2026 16:43:38 -0800 (PST)
Received: from google.com (76.9.127.34.bc.googleusercontent.com. [34.127.9.76])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34f6b88d984sm2604341a91.3.2026.01.08.16.43.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jan 2026 16:43:37 -0800 (PST)
Date: Fri, 9 Jan 2026 00:43:32 +0000
From: David Matlack <dmatlack@google.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Alex Williamson <alex@shazbot.org>, Alex Mastro <amastro@fb.com>,
	Shuah Khan <shuah@kernel.org>, Peter Xu <peterx@redhat.com>,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH] vfio: selftests: Add vfio_dma_mapping_mmio_test
Message-ID: <aWBPNHOsaP1sNvze@google.com>
References: <20260107-scratch-amastro-vfio-dma-mapping-mmio-test-v1-1-0cec5e9ec89b@fb.com>
 <aV7yIchrL3mzNyFO@google.com>
 <20260108005406.GA545276@ziepe.ca>
 <aV8ZRoDjKzjZaw5r@devgpu015.cco6.facebook.com>
 <20260108141044.GC545276@ziepe.ca>
 <20260108084514.1d5e3ee3@shazbot.org>
 <CALzav=eRa49+2wSqrDL1gSw8MpMwXVxb9bx4hvGU0x_bOXypuw@mail.gmail.com>
 <20260108183339.GF545276@ziepe.ca>
 <aWAhuSgEQzr_hzv9@google.com>
 <20260109003621.GG545276@ziepe.ca>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260109003621.GG545276@ziepe.ca>

On 2026-01-08 08:36 PM, Jason Gunthorpe wrote:
> On Thu, Jan 08, 2026 at 09:29:29PM +0000, David Matlack wrote:
> > On 2026-01-08 02:33 PM, Jason Gunthorpe wrote:
> > > On Thu, Jan 08, 2026 at 10:24:19AM -0800, David Matlack wrote:
> > > > > > Oh, I was thinking about a compatability only flow only in the type 1
> > > > > > emulation that internally magically converts a VMA to a dmabuf, but I
> > > > > > haven't written anything.. It is a bit tricky and the type 1 emulation
> > > > > > has not been as popular as I expected??
> > > > >
> > > > > In part because of this gap, I'd guess.  Thanks,
> > > > 
> > > > Lack of huge mappings in the IOMMU when using VFIO_TYPE1_IOMMU is
> > > > another gap I'm aware of.
> > > > vfio_dma_mapping_test.vfio_type1_iommu_anonymous_hugetlb_1gb.dma_map_unmap
> > > > fails when IOMMUFD_VFIO_CONTAINER is enabled.
> > > 
> > > What is this? I'm not aware of it..
> > 
> > It's one of the test cases within
> > tools/testing/selftests/vfio/vfio_dma_mapping_test.c.
> > 
> > Here's the output when running with CONFIG_IOMMUFD_VFIO_CONTAINER=y:
> > 
> >   #  RUN           vfio_dma_mapping_test.vfio_type1_iommu_anonymous_hugetlb_1gb.dma_map_unmap ...
> >   Mapped HVA 0x7f0480000000 (size 0x40000000) at IOVA 0x0
> >   Searching for IOVA 0x0 in /sys/kernel/debug/iommu/intel/0000:6a:01.0/domain_translation_struct
> >   Found IOMMU mappings for IOVA 0x0:
> >   PGD: 0x0000000203475027
> >   P4D: 0x0000000203476027
> >   PUD: 0x0000000203477027
> >   PMD: 0x00000001e7562027
> >   PTE: 0x00000041c0000067
> >   # tools/testing/selftests/vfio/vfio_dma_mapping_test.c:188:dma_map_unmap:Expected 0 (0) == mapping.pte (282394099815)
> >   # dma_map_unmap: Test terminated by assertion
> >   #          FAIL  vfio_dma_mapping_test.vfio_type1_iommu_anonymous_hugetlb_1gb.dma_map_unmap
> 
> I can't think of any reason this would fail, I think your tests have
> found a real bug?? Can you check into it, what kernel call fails and
> where does the kernel code come from?

Oh I thought it was by design. This code in iommufd_vfio_set_iommu():

	/*
	 * The difference between TYPE1 and TYPE1v2 is the ability to unmap in
	 * the middle of mapped ranges. This is complicated by huge page support
	 * which creates single large IOPTEs that cannot be split by the iommu
	 * driver. TYPE1 is very old at this point and likely nothing uses it,
	 * however it is simple enough to emulate by simply disabling the
	 * problematic large IOPTEs. Then we can safely unmap within any range.
	 */
	if (type == VFIO_TYPE1_IOMMU)
		rc = iopt_disable_large_pages(&ioas->iopt);

git-blame says some guy named Jason Gunthorpe wrote it :P

> 
> I don't think I can run these tests with the HW I have??

FWIW all you need any PCI device that can be bound to vfio-pci and
mapped by VT-d. This test does not rely on any of the VFIO selftests
drivers to trigger DMA.

