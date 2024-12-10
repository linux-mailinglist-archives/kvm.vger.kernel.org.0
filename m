Return-Path: <kvm+bounces-33427-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1609B9EB3C4
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 15:45:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8FBC828387A
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 14:45:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A512E4A04;
	Tue, 10 Dec 2024 14:45:10 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AE291A08C5;
	Tue, 10 Dec 2024 14:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733841910; cv=none; b=nIugwsT2FIWdCZow8sR7NFkYdcTNHI9g1tyRa+xnT8lWlVKRupcJgnOOi/ECrO6HVbUfRqnlnCWY2Ql0vuukhkXZt8/DIANWLH1hzRm/Zis4RECHrO1KeqPx9m8/rC5kXaFr/QVTa0tvcNY1bILlo2ECfAFMvXfIJQxihM2P3A8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733841910; c=relaxed/simple;
	bh=AH/pCnpbozjvR0gxiFQyIf+LtIXL5IUei0afkSAEeHk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=phkU3ZUVUfox/7pNlsaTdpm+87WtTx+W2RrF8Cyaq88YhHlea2ZNw1cUSdn4GIsUMFpTkBoNYzd4doKo2v+WZztjz+W5QYvgUNnpR8DnTnvRSOF5BMWD33lONf9O5yAVjlBZFpyerAArrbzS6s1fUYDIXST9dhMBR4IgpccCwlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B804BC4CED6;
	Tue, 10 Dec 2024 14:45:03 +0000 (UTC)
Date: Tue, 10 Dec 2024 14:45:01 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Will Deacon <will@kernel.org>, ankita@nvidia.com, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, ryan.roberts@arm.com, shahuang@redhat.com,
	lpieralisi@kernel.org, aniketa@nvidia.com, cjia@nvidia.com,
	kwankhede@nvidia.com, targupta@nvidia.com, vsethi@nvidia.com,
	acurrid@nvidia.com, apopple@nvidia.com, jhubbard@nvidia.com,
	danw@nvidia.com, zhiw@nvidia.com, mochs@nvidia.com,
	udhoke@nvidia.com, dnigam@nvidia.com, alex.williamson@redhat.com,
	sebastianene@google.com, coltonlewis@google.com,
	kevin.tian@intel.com, yi.l.liu@intel.com, ardb@kernel.org,
	akpm@linux-foundation.org, gshan@redhat.com, linux-mm@kvack.org,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 0/1] KVM: arm64: Map GPU memory with no struct pages
Message-ID: <Z1hT7Z1sp_6Qv6Me@arm.com>
References: <20241118131958.4609-1-ankita@nvidia.com>
 <20241210140739.GC15607@willie-the-truck>
 <20241210141806.GI2347147@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241210141806.GI2347147@nvidia.com>

On Tue, Dec 10, 2024 at 10:18:06AM -0400, Jason Gunthorpe wrote:
> On Tue, Dec 10, 2024 at 02:07:40PM +0000, Will Deacon wrote:
> > On Mon, Nov 18, 2024 at 01:19:57PM +0000, ankita@nvidia.com wrote:
> > > The changes are heavily influenced by the insightful discussions between
> > > Catalin Marinas and Jason Gunthorpe [1] on v1. Many thanks for their
> > > valuable suggestions.
> > > 
> > > Link: https://lore.kernel.org/lkml/20230907181459.18145-2-ankita@nvidia.com [1]
> > 
> > That's a different series, no? It got merged at v9:
> 
> I was confused by this too. v1 of that series included this patch, as
> that series went along it became focused only on enabling WC
> (Normal-NC) in a VM for device MMIO and this patch for device cachable
> memory was dropped off.
> 
> There are two related things:
>  1) Device MMIO memory should be able to be Normal-NC in a VM. Already
>     merged
>  2) Device Cachable memory (ie CXL and pre-CXL coherently attached
>     memory) should be Normal Cachable in a VM, even if it doesn't have
>     struct page/etc. (this patch)
> 
> IIRC this part was dropped off because of the MTE complexity that
> Catalin raised.

Indeed, we only merged the Normal NC part at the time. I asked Ankit to
drop the cacheable attributes and only focus on getting the other part
merged.

-- 
Catalin

