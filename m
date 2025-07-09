Return-Path: <kvm+bounces-51990-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DFDAAFF2D7
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 22:19:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 90F72188326F
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 20:19:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A3D723D287;
	Wed,  9 Jul 2025 20:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HPz0JvMK"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 733F5237A3B
	for <kvm@vger.kernel.org>; Wed,  9 Jul 2025 20:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752092340; cv=none; b=qewTgEwu6sizlbYAV269dCnjotvLbum2aYBw3r8JpHN5PBpsMmiVO0HN+qroUESDD5fF8CHVfQJDaGC5exHpkggSmS7wXFux0PFv6pk7mK9AMigI4nFXuG9N3CJf6XOQQjezAc1Vm2thNuwvmLUtTNCToqzHwyY5P59cGKpErtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752092340; c=relaxed/simple;
	bh=nDiArApHC0wx6SdS3wXVZXH14ciPGo4t6Q6/zk8u8GI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rngFoGeG6X5Hrvkkb1Se30cV0EmRqyUhhMuXL2g43W1PMIpUjwy7VeSfbjO5NmTxmK8JVN7GUzLK+7SQpCjaAA+V27uQja0xhnqXsVFJhfovZctdkPLxjutFEty04OrOtrA0AyeOGNa5qZ+8ZAw7SC0I7yn5ZLhVlfRB0grlIB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HPz0JvMK; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA609C4CEEF;
	Wed,  9 Jul 2025 20:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752092340;
	bh=nDiArApHC0wx6SdS3wXVZXH14ciPGo4t6Q6/zk8u8GI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HPz0JvMKIoaBZYUouD8m1mX93XyVlipzZmP6LtSoOGoxVEoaGMe2UmzPMcTYA8f1T
	 zz2I83gE+CE2XhbiaMAtdozCuJ8U4BRqSu9DfGQQNxh43JPJv1knahFhCpiQQhWFud
	 Bra/OPF1nsF9L3fltQ1Axfj2XV9ttujVOwiqPp/wfFC2gwUi3hjnFrN/+y+1Vsg+0g
	 Hp2jcPpMR9EXKB3Stm4sev6Xz/OUn8IsaFEIQMo7gs3pHMgVGRbbji71f/VrOgfOtq
	 F9AaCS8zGqg9nY5OfwORaBneWIiSfchhDT4tYBsgEmZmO8pSp1jGMIpWJHPjqH1kVT
	 plDBjHbdjjSvQ==
Date: Wed, 9 Jul 2025 14:18:58 -0600
From: Keith Busch <kbusch@kernel.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Keith Busch <kbusch@meta.com>, kvm@vger.kernel.org
Subject: Re: [PATCH] vfio/type1: conditional rescheduling while pinning
Message-ID: <aG7OspdCPAK2oILR@kbusch-mbp>
References: <20250312225255.617869-1-kbusch@meta.com>
 <20250317154417.7503c094.alex.williamson@redhat.com>
 <Z9iilzUTwLKzcVfK@kbusch-mbp.dhcp.thefacebook.com>
 <20250317165347.269621e5.alex.williamson@redhat.com>
 <Z9rm-Y-B2et9uvKc@kbusch-mbp>
 <20250319121704.7744c73e.alex.williamson@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250319121704.7744c73e.alex.williamson@redhat.com>

On Wed, Mar 19, 2025 at 12:17:04PM -0600, Alex Williamson wrote:
> On Wed, 19 Mar 2025 09:47:05 -0600
> > > 
> > > Note that we already have a cond_resched() in vfio_iommu_map(), which
> > > we'll hit any time we get a break in a contiguous mapping.  We may hit
> > > that regularly enough that it's not an issue for RAM mapping, but I've
> > > certainly seen soft lockups when we have many GiB of contiguous pfnmaps
> > > prior to the series above.  Thanks,  
> > 
> > So far adding the additional patches has not changed anything. We've
> > ensured we are using an address and length aligned to 2MB, but it sure
> > looks like vfio's fault handler is only getting order-0 faults. I'm not
> > finding anything immediately obvious about what we can change to get the
> > desired higher order behvaior, though. Any other hints or information I
> > could provide?
> 
> Since you mention folding in the changes, are you working on an upstream
> kernel or a downstream backport?  Huge pfnmap support was added in
> v6.12 via [1].  Without that you'd never see better than a order-a
> fault.  I hope that's it because with all the kernel pieces in place it
> should "Just work".  Thanks,

I think I'm back to needing a cond_resched(). I'm finding too many user
space programs, including qemu, for various reasons do not utilize
hugepage faults, and we're ultimately locking up a cpu for long enough
to cause other nasty side effects, like OOM due to blocked rcu free
callbacks. As preferable as it is to get everything aligned to use the
faster faults, I don't think the kernel should depend on that to prevent
prolonged cpu lockups. What do you think?

