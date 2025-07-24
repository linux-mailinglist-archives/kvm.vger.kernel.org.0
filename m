Return-Path: <kvm+bounces-53353-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EB321B104E7
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 10:54:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 03D631CC6EB3
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 08:53:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BE0C27603A;
	Thu, 24 Jul 2025 08:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K9wTxRyA"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 598FD27700A;
	Thu, 24 Jul 2025 08:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753346684; cv=none; b=tT5ej0lFNi9uC580xvqNLxTwGcLvK8SKyYLcELM5zu4eYd1eE3mS0z4Kx7b6zRWHlyYHS2h6+ekD0QRqEoBvF7Zv0tWxvYfcggXDhK8C3lnx1+trK98+k0P7BexVv2OGkZ26CCtCKQRXQenzr2q3IYxa5NRaY522iT6QJIa5xOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753346684; c=relaxed/simple;
	bh=W5JUrYlWpVqplvlRAQ32P5mkUBWD/SoUy8uvFQx3VPQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a8MJt5CflVIuheIFtI0UMxDDsjedPYusUZiSv3jD4L/rfvbeL1xfUnuRJOdthnGtYLsNSAmrKekSOC1IRzTZHFFmv2gviX+AyyGE4hmLDJmPCjoZUleRCkeKQuJLbA3RSq9O5M8ii6S8lhtMfFjzYPnokL1yZ0AvrpetKNtSL/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K9wTxRyA; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37A85C4CEED;
	Thu, 24 Jul 2025 08:44:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753346683;
	bh=W5JUrYlWpVqplvlRAQ32P5mkUBWD/SoUy8uvFQx3VPQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=K9wTxRyA/shMXX/Hdia/1xI1mOy/8k8PUWnxUn/UH4jXnjjnrw3kkoRmKy8ekulDA
	 1YlZCz992kQNrY4Lj7mlw+mWJAS2FAnsKYdcq/bQ6E5Shq0p/mMDuhjebYmC1H1Ird
	 G8j+kbom/uO4IJgApS/mvDZFQSWSYtSzZsfoUfzJd1ibOFjA1LdREiDe20+femGcYf
	 FII8DCa8sNH9Nyo1JOS1bxgj3at+w89oszHew+ZD+iuIWgyNyyoXaEa3OO17DWTqlR
	 CZ4xt/+s9taRnEPOT69VQti+lx1CW9tuAlZiSKSLkLEU0if8FEaJEwNdkhb48HEBGO
	 8Q+YAEXESKH6w==
Date: Thu, 24 Jul 2025 09:44:38 +0100
From: Will Deacon <will@kernel.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Stefano Garzarella <sgarzare@redhat.com>,
	Breno Leitao <leitao@debian.org>, jasowang@redhat.com,
	eperezma@redhat.com, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Stefan Hajnoczi <stefanha@redhat.com>,
	netdev@vger.kernel.org
Subject: Re: vhost: linux-next: crash at vhost_dev_cleanup()
Message-ID: <aIHydjBEnmkTt-P-@willie-the-truck>
References: <vosten2rykookljp6u6qc4hqhsqb6uhdy2iuhpl54plbq2tkr4@kphfpgst3e7c>
 <20250724034659-mutt-send-email-mst@kernel.org>
 <CAGxU2F76ueKm3H30vXL+jxMVsiQBuRkDN9NRfVU8VeTXzTVAWg@mail.gmail.com>
 <20250724042100-mutt-send-email-mst@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250724042100-mutt-send-email-mst@kernel.org>

On Thu, Jul 24, 2025 at 04:22:15AM -0400, Michael S. Tsirkin wrote:
> On Thu, Jul 24, 2025 at 10:14:36AM +0200, Stefano Garzarella wrote:
> > CCing Will

Thanks.

> > On Thu, 24 Jul 2025 at 09:48, Michael S. Tsirkin <mst@redhat.com> wrote:
> > >
> > > On Wed, Jul 23, 2025 at 08:04:42AM -0700, Breno Leitao wrote:
> > > > Hello,
> > > >
> > > > I've seen a crash in linux-next for a while on my arm64 server, and
> > > > I decided to report.
> > > >
> > > > While running stress-ng on linux-next, I see the crash below.
> > > >
> > > > This is happening in a kernel configure with some debug options (KASAN,
> > > > LOCKDEP and KMEMLEAK).
> > > >
> > > > Basically running stress-ng in a loop would crash the host in 15-20
> > > > minutes:
> > > >       # while (true); do stress-ng -r 10 -t 10; done
> > > >
> > > > >From the early warning "virt_to_phys used for non-linear address",
> > 
> > mmm, we recently added nonlinear SKBs support in vhost-vsock [1],
> > @Will can this issue be related?
> 
> Good point.
> 
> Breno, if bisecting is too much trouble, would you mind testing the commits
> c76f3c4364fe523cd2782269eab92529c86217aa
> and
> c7991b44d7b44f9270dec63acd0b2965d29aab43
> and telling us if this reproduces?

That's definitely worth doing, but we should be careful not to confuse
the "non-linear address" from the warning (which refers to virtual
addresses that lie outside of the linear mapping of memory, e.g. in the
vmalloc space) and "non-linear SKBs" which refer to SKBs with fragment
pages.

Breno -- when you say you've been seeing this "for a while", what's the
earliest kernel you know you saw it on?

> > > > I suppose corrupted data is at vq->nheads.
> > > >
> > > > Here is the decoded stack against 9798752 ("Add linux-next specific
> > > > files for 20250721")
> > > >
> > > >
> > > >       [  620.685144] [ T250731] VFIO - User Level meta-driver version: 0.3
> > > >       [  622.394448] [ T250254] ------------[ cut here ]------------
> > > >       [  622.413492] [ T250254] virt_to_phys used for non-linear address: 000000006e69fe64 (0xcfcecdcccbcac9c8)

So here's the bad (non-linear) pointer. Do you know if 0xcfcecdcccbcac9c8
correlates with the packet data that stress-ng is generating? I wonder if
we're somehow overflowing vq->iov[].

Will

