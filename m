Return-Path: <kvm+bounces-27561-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8DE4F9873E7
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2024 14:55:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4F687B24E0D
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2024 12:54:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C185B219ED;
	Thu, 26 Sep 2024 12:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="luKagWOb"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E21441B813
	for <kvm@vger.kernel.org>; Thu, 26 Sep 2024 12:54:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727355282; cv=none; b=rVcHbCG4eoiyWZl/z/5MoqVhxyXwt/bLLRtDfs5zKX22KSjTjuCBzd2mvfu4Kylk6SiRUiSXLwzLGnRfjQj4H4YElFZpZhLxxMtmItNmX72QvuSDZi2Bn6qLxcjRQx3Ze+4F6KoctEOG/7D/Q8IZDwBlTgKOvBZ9f2gu/tMo33c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727355282; c=relaxed/simple;
	bh=eVYqkFa/TJSgRppd8sTT+SVvtF73nuad4iE4uyiJFMo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g+tYDr8sCC7w9i4dqPag6NugAm0WQbdueKaBzAm2KD91/CNuu4f4ti/rbhrScVzr2j6DOI1zHKWA0Wt1etnX1lCTM+Z59DwKWP6FWHpYI/kV6j8GaRzJR7nsk07l+7rI1brng5SSwST1OzGAnej8h+M9u6BxdHJy/MM9fFAzGhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=luKagWOb; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08AAEC4CEC5;
	Thu, 26 Sep 2024 12:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727355281;
	bh=eVYqkFa/TJSgRppd8sTT+SVvtF73nuad4iE4uyiJFMo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=luKagWObdz4V4zJCU85hRnov1Olt15LpKmQSZyetU6KQAO34EP+nVaNt+WJmuARmf
	 Zg9LVFSJaO/m04LI0tRF9WfZsJZsZL41+7hxftrzjdO1TGrIMpJJBqvgOTvYdhx/vj
	 S/oanrTVGfFsh0ZpGwoCX34CMSZywH++sNTBCqNc=
Date: Thu, 26 Sep 2024 14:54:38 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Danilo Krummrich <dakr@kernel.org>, Zhi Wang <zhiw@nvidia.com>,
	kvm@vger.kernel.org, nouveau@lists.freedesktop.org,
	alex.williamson@redhat.com, kevin.tian@intel.com, airlied@gmail.com,
	daniel@ffwll.ch, acurrid@nvidia.com, cjia@nvidia.com,
	smitra@nvidia.com, ankita@nvidia.com, aniketa@nvidia.com,
	kwankhede@nvidia.com, targupta@nvidia.com, zhiwang@kernel.org
Subject: Re: [RFC 00/29] Introduce NVIDIA GPU Virtualization (vGPU) Support
Message-ID: <2024092619-unglazed-actress-0a0f@gregkh>
References: <20240922124951.1946072-1-zhiw@nvidia.com>
 <ZvErg51xH32b8iW6@pollux>
 <20240923150140.GB9417@nvidia.com>
 <2024092614-fossil-bagful-1d59@gregkh>
 <20240926124239.GX9417@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240926124239.GX9417@nvidia.com>

On Thu, Sep 26, 2024 at 09:42:39AM -0300, Jason Gunthorpe wrote:
> On Thu, Sep 26, 2024 at 11:14:27AM +0200, Greg KH wrote:
> > On Mon, Sep 23, 2024 at 12:01:40PM -0300, Jason Gunthorpe wrote:
> > > On Mon, Sep 23, 2024 at 10:49:07AM +0200, Danilo Krummrich wrote:
> > > > > 2. Proposal for upstream
> > > > > ========================
> > > > 
> > > > What is the strategy in the mid / long term with this?
> > > > 
> > > > As you know, we're trying to move to Nova and the blockers with the device /
> > > > driver infrastructure have been resolved and we're able to move forward. Besides
> > > > that, Dave made great progress on the firmware abstraction side of things.
> > > > 
> > > > Is this more of a proof of concept? Do you plan to work on Nova in general and
> > > > vGPU support for Nova?
> > > 
> > > This is intended to be a real product that customers would use, it is
> > > not a proof of concept. There is alot of demand for this kind of
> > > simplified virtualization infrastructure in the host side. The series
> > > here is the first attempt at making thin host infrastructure and
> > > Zhi/etc are doing it with an upstream-first approach.
> > > 
> > > >From the VFIO side I would like to see something like this merged in
> > > nearish future as it would bring a previously out of tree approach to
> > > be fully intree using our modern infrastructure. This is a big win for
> > > the VFIO world.
> > > 
> > > As a commercial product this will be backported extensively to many
> > > old kernels and that is harder/impossible if it isn't exclusively in
> > > C. So, I think nova needs to co-exist in some way.
> > 
> > Please never make design decisions based on old ancient commercial
> > kernels that have any relevance to upstream kernel development
> > today.
> 
> Greg, you are being too extreme. Those "ancient commercial kernels"
> have a huge relevance to alot of our community because they are the
> users that actually run the code we are building and pay for it to be
> created. Yes we usually (but not always!) push back on accommodations
> upstream, but taking hard dependencies on rust is currently a very
> different thing.

That's fine, but again, do NOT make design decisions based on what you
can, and can not, feel you can slide by one of these companies to get it
into their old kernels.  That's what I take objection to here.

Also always remember please, that the % of overall Linux kernel
installs, even counting out Android and embedded, is VERY tiny for these
companies.  The huge % overall is doing the "right thing" by using
upstream kernels.  And with the laws in place now that % is only going
to grow and those older kernels will rightfully fall away into even
smaller %.

I know those companies pay for many developers, I'm not saying that
their contributions are any less or more important than others, they all
are equal.  You wouldn't want design decisions for a patch series to be
dictated by some really old Yocto kernel restrictions that are only in
autos, right?  We are a large community, that's what I'm saying.

> Otherwise, let's slow down here. Nova is still years away from being
> finished. Nouveau is the in-tree driver for this HW. This series
> improves on Nouveau. We are definitely not at the point of refusing
> new code because it is not writte in Rust, RIGHT?

No, I do object to "we are ignoring the driver being proposed by the
developers involved for this hardware by adding to the old one instead"
which it seems like is happening here.

Anyway, let's focus on the code, there's already real issues with this
patch series as pointed out by me and others that need to be addressed
before it can go anywhere.

thanks,

greg k-h

