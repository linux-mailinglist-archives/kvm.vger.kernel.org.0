Return-Path: <kvm+bounces-41497-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EA141A693EC
	for <lists+kvm@lfdr.de>; Wed, 19 Mar 2025 16:47:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 58745172B89
	for <lists+kvm@lfdr.de>; Wed, 19 Mar 2025 15:47:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BECA41D89E9;
	Wed, 19 Mar 2025 15:47:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fNBMTYWO"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8C9D14D70E
	for <kvm@vger.kernel.org>; Wed, 19 Mar 2025 15:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742399229; cv=none; b=oosWXlx99Lco+FH/8U6uvJ0AMfwTymJykrUwO4dRwlsFDzLJM+si9enslhHM0mB/ujVFLgFosX/W/PrT7kdXanceGO810NfJMd7G1j3AWm1CaQCMn/kXR+khNJdiK62NTbBqlbX1+vc0W12q+51/tLbH4ZHlKewMcS9LDnyrf68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742399229; c=relaxed/simple;
	bh=UjABymPboGTl3xxYNAxIGMNXJ/MSp1yemvoISWQLJJo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QhiJngezBTGLdpCE3Ryr0GOXal4gVRHp7AnxOS8FJCDK93dFf8HVZi8R8rNsY/nYs93z2TOmXH+CcPYNEhkK1R3e9RA1cT49IAEKsYhWG7Xkcan/7iI8U4NNpt51XIHa+JTfSOp0fFz7XEhxxRsWLSq2YcujqKtl3y682VkqQlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fNBMTYWO; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 226E1C4CEE4;
	Wed, 19 Mar 2025 15:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742399228;
	bh=UjABymPboGTl3xxYNAxIGMNXJ/MSp1yemvoISWQLJJo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fNBMTYWO3HwT3Jv6noUOz7u07lw4b5N5aR1lmm37FCq8DHSXo8g9LMxPackZEZXIH
	 cQgelg1dbQTWOnGgyswRBcvS/9KEHZvnqNqKU/PHOJI7Ta4uEh3MIUBlw12WqKApT0
	 e1zNpcsvHXMPT0AWfb7TY7kCJMgoFFNH4Tz/ix/F+tfhS7uhv1SCSSQc4rmcJkA8rq
	 PtgMlYA2FYtDIHlBlDzz7Fi9sRiX5/Ti+WxlRrrI56lLcxuXx1pIl2r26seOpFfX/l
	 6RSJB45baTQ3BsUCCtN3V7zf9TIUbf05Xr22XrFRyFcS8AoUstMudJrEoT9G6iTKmD
	 Oakh2SZeIhtAQ==
Date: Wed, 19 Mar 2025 09:47:05 -0600
From: Keith Busch <kbusch@kernel.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Keith Busch <kbusch@meta.com>, kvm@vger.kernel.org
Subject: Re: [PATCH] vfio/type1: conditional rescheduling while pinning
Message-ID: <Z9rm-Y-B2et9uvKc@kbusch-mbp>
References: <20250312225255.617869-1-kbusch@meta.com>
 <20250317154417.7503c094.alex.williamson@redhat.com>
 <Z9iilzUTwLKzcVfK@kbusch-mbp.dhcp.thefacebook.com>
 <20250317165347.269621e5.alex.williamson@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250317165347.269621e5.alex.williamson@redhat.com>

On Mon, Mar 17, 2025 at 04:53:47PM -0600, Alex Williamson wrote:
> On Mon, 17 Mar 2025 16:30:47 -0600
> Keith Busch <kbusch@kernel.org> wrote:
> 
> > On Mon, Mar 17, 2025 at 03:44:17PM -0600, Alex Williamson wrote:
> > > On Wed, 12 Mar 2025 15:52:55 -0700  
> > > > @@ -679,6 +679,7 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
> > > >  
> > > >  		if (unlikely(disable_hugepages))
> > > >  			break;
> > > > +		cond_resched();
> > > >  	}
> > > >  
> > > >  out:  
> > > 
> > > Hey Keith, is this still necessary with:
> > > 
> > > https://lore.kernel.org/all/20250218222209.1382449-1-alex.williamson@redhat.com/  
> > 
> > Thank you for the suggestion. I'll try to fold this into a build, and
> > see what happens. But from what I can tell, I'm not sure it will help.
> > We're simply not getting large folios in this path and dealing with
> > individual pages. Though it is a large contiguous range (~60GB, not
> > necessarily aligned). Shoould we expect to only be dealing with PUD and
> > PMD levels with these kinds of mappings?
> 
> IME with QEMU, PMD alignment basically happens without any effort and
> gets 90+% of the way there, PUD alignment requires a bit of work[1].
>  
> > > This is currently in linux-next from the vfio next branch and should
> > > pretty much eliminate any stalls related to DMA mapping MMIO BARs.
> > > Also the code here has been refactored in next, so this doesn't apply
> > > anyway, and if there is a resched still needed, this location would
> > > only affect DMA mapping of memory, not device BARs.  Thanks,  
> > 
> > Thanks for the head's up. Regardless, it doesn't look like bad place to
> > cond_resched(), but may not trigger any cpu stall indicator outside this
> > vfio fault path.
> 
> Note that we already have a cond_resched() in vfio_iommu_map(), which
> we'll hit any time we get a break in a contiguous mapping.  We may hit
> that regularly enough that it's not an issue for RAM mapping, but I've
> certainly seen soft lockups when we have many GiB of contiguous pfnmaps
> prior to the series above.  Thanks,

So far adding the additional patches has not changed anything. We've
ensured we are using an address and length aligned to 2MB, but it sure
looks like vfio's fault handler is only getting order-0 faults. I'm not
finding anything immediately obvious about what we can change to get the
desired higher order behvaior, though. Any other hints or information I
could provide?

