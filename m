Return-Path: <kvm+bounces-52202-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E4373B025DD
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 22:41:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 93EAA3AE854
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 20:40:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DC16220F4F;
	Fri, 11 Jul 2025 20:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WPAQLNl+"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3746C1FCFE7
	for <kvm@vger.kernel.org>; Fri, 11 Jul 2025 20:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752266455; cv=none; b=EKY+jn/e6S7IjQHBSAH4I3Hb9CRNETfj6QBlFZQgj6mou1ra5ud4GwZKfYPpzoE7rI70FAmqNBS+qpLzJkzNi1Zac33nxqB3GbEf6yVFkiiyYhgbcG0ICrnL5lazk5aS/Z3JB6SOkUccXg3TR+c2qpTc7gmnMbBTy6xtRg+YpKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752266455; c=relaxed/simple;
	bh=B1NJSvtRJVWvSCrv5F+e7omsrU/ozckq1tMexadQEq8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HTTxCrPRC9v/kLE94eq1n8z3Hzz6vxVle/C1pKq2VNwNJLl8p5RvWeh2nM8tmBgpdyEm7K1mGEK5+LZuv4iFLE74q9hzA2Yb8qn7afUYArDa3B8XVEXsXmIFVh5p4eZIqsMxuFEzKAECG8zdiKHVvEeccEWe5g4anazO6NIMk7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WPAQLNl+; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F22FC4CEED;
	Fri, 11 Jul 2025 20:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752266454;
	bh=B1NJSvtRJVWvSCrv5F+e7omsrU/ozckq1tMexadQEq8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WPAQLNl+VlSPPYayrSS+Sy98kAkqGJnw0lVb6vIMYwrf4JiETYfmh63ivqTeDuNWx
	 Sy2tJPH1RPmwbgfODxNZjX27x+iv5zx+E83abJBcWUJarqMJPGrycIxO+Jti6YRQpR
	 KQlctUdnrFKegOaEhh5y126zAoQ5MA6a6K5QYWl0pkn6C7DINRmheGpKlR3SpZeZVl
	 ucs+2sBdMZBHPXOKOeNzYwE+LfL2WH4k2xg8o7amsjyW0Z0Cd2cb6Z2tJPG29vDs5y
	 30MGNCB+IWMi8+c8mYPo7mIcQQWwq5OwETfdmgWL2t5ZPzCeE4AdTa3vq2ip+aAvU4
	 BO3e92bh+Cvog==
Date: Fri, 11 Jul 2025 14:40:52 -0600
From: Keith Busch <kbusch@kernel.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Keith Busch <kbusch@meta.com>, kvm@vger.kernel.org
Subject: Re: [PATCH] vfio/type1: conditional rescheduling while pinning
Message-ID: <aHF21JIasR_sTq_g@kbusch-mbp>
References: <20250312225255.617869-1-kbusch@meta.com>
 <20250317154417.7503c094.alex.williamson@redhat.com>
 <Z9iilzUTwLKzcVfK@kbusch-mbp.dhcp.thefacebook.com>
 <20250317165347.269621e5.alex.williamson@redhat.com>
 <Z9rm-Y-B2et9uvKc@kbusch-mbp>
 <20250319121704.7744c73e.alex.williamson@redhat.com>
 <aG7OspdCPAK2oILR@kbusch-mbp>
 <20250711141657.16dd6a20.alex.williamson@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250711141657.16dd6a20.alex.williamson@redhat.com>

On Fri, Jul 11, 2025 at 02:16:57PM -0600, Alex Williamson wrote:
> On Wed, 9 Jul 2025 14:18:58 -0600
> Keith Busch <kbusch@kernel.org> wrote:
> > I think I'm back to needing a cond_resched(). I'm finding too many user
> > space programs, including qemu, for various reasons do not utilize
> > hugepage faults, and we're ultimately locking up a cpu for long enough
> > to cause other nasty side effects, like OOM due to blocked rcu free
> > callbacks. As preferable as it is to get everything aligned to use the
> > faster faults, I don't think the kernel should depend on that to prevent
> > prolonged cpu lockups. What do you think?
> 
> I'm not opposed to adding a cond_resched, but I'll also note that Peter
> Xu has been working on a series that tries to get the right mapping
> alignment automatically.  It's still a WIP, but it'd be good to know if
> that resolves the remaining userspace issues you've seen or we're still
> susceptible to apps that aren't even trying to use THP:
> 
> https://lore.kernel.org/all/20250613134111.469884-1-peterx@redhat.com/

Yes, I saw that series and included that for testing as well.

But I'm finding many machines have a transparent_hugepage enabled policy
set to "never" due to some problems THP usage caused with other hardware
(CXL, I think). I'm trying to get these to use "madvise" instead, but
that's causing other performance regressions for some tests.

