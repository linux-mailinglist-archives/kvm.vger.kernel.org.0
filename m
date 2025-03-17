Return-Path: <kvm+bounces-41315-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 96359A661A8
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 23:31:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 717DB3B44ED
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 22:30:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FFAD2054F4;
	Mon, 17 Mar 2025 22:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Jj6rIzYN"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E977204F99
	for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 22:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742250650; cv=none; b=qJbE2VdjhEOsLIIJha47ctvUxsyBCmDDu+pE3Kfw61q2m+7qPsdMwatVrLkXMfPFJ+nqoOsGAjyglxRCvRKA7HTT6vOK+W+gPrmHTgPbcMgw1HMUJBQ8hQHZpDEcRD/V5qfQ9cMbCEj0dHHj5r4xNBRqZFtkdh9VlSbocj/tYAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742250650; c=relaxed/simple;
	bh=K4p6lTKS9fmul17BiC74JyQVMRCHJ4vC2WY08JWBRyE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M4cU18tZ7zt6DVFZaLRy+p6Om+AL8EyhMJsrrQUa4Pz2o7x1UubLt5Mrv48PSDqvVMXuNd/sXRB8UCHK0BKsUVXiBC/df9M0QcyR2TOpau8MBVVEz6h66ZgEgF0c+v2EedUdK9HrfuGnBUKVubVHOp4F6IYT9fi/eiVjxh00Hbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Jj6rIzYN; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96A24C4CEE9;
	Mon, 17 Mar 2025 22:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742250649;
	bh=K4p6lTKS9fmul17BiC74JyQVMRCHJ4vC2WY08JWBRyE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Jj6rIzYNlIegz/ioKdFUwonXf9Wh+UM4BVATMZK8t/9r6DA3wFaRr5aISRcdhAK4U
	 NEL+Ql13DKvc/IbWrk3dT7KaytP5/Ku6qpKg5kXipnh8yFAZWEGgnfpZSYJY98jRpu
	 6l9pF/RjfeQxPd4qH4QEcrINN6VCTmjlMG6J02JAPdXCxpaF/eyR2FR3KyItoigToP
	 n3HkrtetOjcKHfLkRfOImPlLCP3MA/P6krUOy8kXYasfWhk4UuItD2eRJraovP3hTm
	 /NAt5aq2zi/5NQ/t326Gd6eLv5sPVYIFJz0FMVb37BiOpdQmRktpfWOZvW3CLst0mp
	 +cPpi0vU3LSPw==
Date: Mon, 17 Mar 2025 16:30:47 -0600
From: Keith Busch <kbusch@kernel.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Keith Busch <kbusch@meta.com>, kvm@vger.kernel.org
Subject: Re: [PATCH] vfio/type1: conditional rescheduling while pinning
Message-ID: <Z9iilzUTwLKzcVfK@kbusch-mbp.dhcp.thefacebook.com>
References: <20250312225255.617869-1-kbusch@meta.com>
 <20250317154417.7503c094.alex.williamson@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250317154417.7503c094.alex.williamson@redhat.com>

On Mon, Mar 17, 2025 at 03:44:17PM -0600, Alex Williamson wrote:
> On Wed, 12 Mar 2025 15:52:55 -0700
> > @@ -679,6 +679,7 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
> >  
> >  		if (unlikely(disable_hugepages))
> >  			break;
> > +		cond_resched();
> >  	}
> >  
> >  out:
> 
> Hey Keith, is this still necessary with:
> 
> https://lore.kernel.org/all/20250218222209.1382449-1-alex.williamson@redhat.com/

Thank you for the suggestion. I'll try to fold this into a build, and
see what happens. But from what I can tell, I'm not sure it will help.
We're simply not getting large folios in this path and dealing with
individual pages. Though it is a large contiguous range (~60GB, not
necessarily aligned). Shoould we expect to only be dealing with PUD and
PMD levels with these kinds of mappings?
 
> This is currently in linux-next from the vfio next branch and should
> pretty much eliminate any stalls related to DMA mapping MMIO BARs.
> Also the code here has been refactored in next, so this doesn't apply
> anyway, and if there is a resched still needed, this location would
> only affect DMA mapping of memory, not device BARs.  Thanks,

Thanks for the head's up. Regardless, it doesn't look like bad place to
cond_resched(), but may not trigger any cpu stall indicator outside this
vfio fault path.

