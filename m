Return-Path: <kvm+bounces-18196-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id CCE848D148C
	for <lists+kvm@lfdr.de>; Tue, 28 May 2024 08:37:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 531BCB21485
	for <lists+kvm@lfdr.de>; Tue, 28 May 2024 06:37:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47A516A33F;
	Tue, 28 May 2024 06:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Fv+XcrYn"
X-Original-To: kvm@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28EF061FD7;
	Tue, 28 May 2024 06:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716878258; cv=none; b=mDlT6VEp8Z1+rF4zz3iHehqUhRmLsRbmYgtOZgG8gW/pq4Yug1u1rm4azfgCKUX+G9kMJG07uQARh6Z1yrJ3yx02S8jPov5OBOx1kFfbxaMQa1rp/PDoFwxqjal9WeoY34kJTpo5PNRbjzv32MpoIpEtYu2jgNrqBv6i3Z/emD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716878258; c=relaxed/simple;
	bh=jyDL4zz5q8jj+/c7ouLHGKNSvOKvSPQog+4PVAaGQ/w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IKnKst110mU1GhX3YoOdzzYBAYkAHxMUTQ/UmLd3rgn9o2gF5UmeZ6o5udukJoyX+U8qj7xe5kpEpx5TyFNQ7DQbmK35LLYJmnizfXdgPPYFxmLUx/1IVey+wtjtgmajp7oc4WLPFaY4nYVw/WHQG/Kf1F/ydkMbOg4gUvSbTgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Fv+XcrYn; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=87n+7vGposB3DHFhm3eVtYVHQH6pkIsF9l1YK27pW5Q=; b=Fv+XcrYnhndpCI1RvGWvylRtyZ
	CPYNqlFqK4cynFTdXwsuIGbcxDBee8vCmtDj0T6/jph2iCLI5YrLVEshUfmXIPsDrALT5llwbDnJc
	lO8+SOb64g4LEHowumn8D2W4mbS+A8trU2NHZ/IAhh38UWUkVs4mq+BRWNzIRxHA+Khxb15Q78c6A
	M7k6SLsoC5LtvheJJ5jVqi5IGT7y/unfSZy0qQ/36qLYHkxv3ctNov0kV8J+nXsp4HmrCn0Ohsyeg
	uHa2Myzb1RuK9nmV5e8MkBtVEHRMuIohHuNaqazKXsS6Y8XA/q7TtwbOoDF8daCPd//Q4s9ZjtqeT
	y6zWMqXw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sBqSk-0000000HDpm-1ovw;
	Tue, 28 May 2024 06:37:34 +0000
Date: Mon, 27 May 2024 23:37:34 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Christoph Hellwig <hch@infradead.org>, Yan Zhao <yan.y.zhao@intel.com>,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
	alex.williamson@redhat.com, kevin.tian@intel.com,
	iommu@lists.linux.dev, pbonzini@redhat.com, seanjc@google.com,
	dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
	corbet@lwn.net, joro@8bytes.org, will@kernel.org,
	robin.murphy@arm.com, baolu.lu@linux.intel.com, yi.l.liu@intel.com,
	Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH 3/5] x86/mm: Introduce and export interface
 arch_clean_nonsnoop_dma()
Message-ID: <ZlV7rlmWdU7dJZKo@infradead.org>
References: <20240507061802.20184-1-yan.y.zhao@intel.com>
 <20240507062044.20399-1-yan.y.zhao@intel.com>
 <ZktZDmcNnsHhp4Tm@infradead.org>
 <20240521154939.GH20229@nvidia.com>
 <20240521160016.GA2513156@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240521160016.GA2513156@nvidia.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, May 21, 2024 at 01:00:16PM -0300, Jason Gunthorpe wrote:
> > > Err, no.  There should really be no exported cache manipulation macros,
> > > as drivers are almost guaranteed to get this wrong.  I've added
> > > Russell to the Cc list who has been extremtly vocal about this at least
> > > for arm.
> > 
> > We could possibly move this under some IOMMU core API (ie flush and
> > map, unmap and flush), the iommu APIs are non-modular so this could
> > avoid the exported symbol.
> 
> Though this would be pretty difficult for unmap as we don't have the
> pfns in the core code to flush. I don't think we have alot of good
> options but to make iommufd & VFIO handle this directly as they have
> the list of pages to flush on the unmap side. Use a namespace?

Just have a unmap version that also takes a list of PFNs that you'd
need for non-coherent mappings?


