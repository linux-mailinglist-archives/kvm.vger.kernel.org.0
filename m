Return-Path: <kvm+bounces-54414-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D2D6DB20D51
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 17:17:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6DB76170BFD
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 15:16:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE208242D78;
	Mon, 11 Aug 2025 15:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fnYNFtzu"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0FDF12CDBE
	for <kvm@vger.kernel.org>; Mon, 11 Aug 2025 15:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754925398; cv=none; b=Th61BLD687KpGMw5th7Twad58zTwcqytZmdlhPP3tsbW44uX6Fa0Tnh2Wqs9fyhjr6G9Dp33PmsajQQ0KnWjOm6fw2ZUFpXojGv4gpStKh8o3pEw9bfUPQx94LLV/CLeidX+v/B5ofBZqq2EAAYNVMl7Kw2g4iPdy6vQLUhsjB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754925398; c=relaxed/simple;
	bh=w3w5TxpBTh0UVQg7aNJ0VBqh0zhw9kH6F/5Ku1J2I0c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i2luZj5L1+35yniNCSQtk/fxI4P67ccHYDPPtt9+q05R3Dh/kJKI7VKTHyi/yH5LfRPiBTMO/x/xiom/i6ICdMxw9diB8+XJVtLXuqKU6RV+rLDuMCKE6R/91UnhrcS7pv5dlWB5qRtrV+ye+sjP8yf8C0HrzChWKTT6UschVF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fnYNFtzu; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A587AC4CEED;
	Mon, 11 Aug 2025 15:16:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1754925398;
	bh=w3w5TxpBTh0UVQg7aNJ0VBqh0zhw9kH6F/5Ku1J2I0c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fnYNFtzuZ8BFTiO7L3Q0K83DO945k/IRU5q0PITOUe4QNA4Q+PWH6l+xMk1pft42J
	 BWUVq/MSSbJfHIzOvNQqp2aJH3En2gob0j589iMz48t6WsuLxvsLlHMoLwkcXw21r3
	 qclyzWtiS+Di79tCt0qpVsxEGXXx7f2O9j81u/Ko=
Date: Mon, 11 Aug 2025 17:16:34 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Thijs Raymakers <thijs@raymakers.nl>, kvm@vger.kernel.org,
	stable <stable@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2] KVM: x86: use array_index_nospec with indices that
 come from guest
Message-ID: <2025081131-mural-crane-6ab1@gregkh>
References: <aII3WuhvJb3sY8HG@google.com>
 <20250724142227.61337-1-thijs@raymakers.nl>
 <2025072441-degrease-skipping-bbc8@gregkh>
 <aIKDr_kVpUjC8924@google.com>
 <2025081151-defiling-badass-c926@gregkh>
 <aJn_xYSweEauucGv@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aJn_xYSweEauucGv@google.com>

On Mon, Aug 11, 2025 at 07:35:49AM -0700, Sean Christopherson wrote:
> On Mon, Aug 11, 2025, Greg Kroah-Hartman wrote:
> > On Thu, Jul 24, 2025 at 12:04:15PM -0700, Sean Christopherson wrote:
> > > On Thu, Jul 24, 2025, Greg Kroah-Hartman wrote:
> > > > On Thu, Jul 24, 2025 at 04:22:27PM +0200, Thijs Raymakers wrote:
> > > > > min and dest_id are guest-controlled indices. Using array_index_nospec()
> > > > > after the bounds checks clamps these values to mitigate speculative execution
> > > > > side-channels.
> > > > > 
> > > > > Signed-off-by: Thijs Raymakers <thijs@raymakers.nl>
> > > > > Cc: stable <stable@kernel.org>
> > > > > Cc: Sean Christopherson <seanjc@google.com>
> > > > > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > > > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > > 
> > > > Nit, you shouldn't have added my signed off on a new version, but that's
> > > > ok, I'm fine with it.
> > > 
> > > Want me to keep your SoB when applying, or drop it?
> > > 
> > > > > ---
> > > > >  arch/x86/kvm/lapic.c | 2 ++
> > > > >  arch/x86/kvm/x86.c   | 7 +++++--
> > > > >  2 files changed, 7 insertions(+), 2 deletions(-)
> > > > 
> > > > You also forgot to say what changed down here.
> > > > 
> > > > Don't know how strict the KVM maintainers are, I know I require these
> > > > things fixed up...
> > > 
> > > I require the same things, but I also don't mind doing fixup when applying if
> > > that's the path of least resistance (and it's not a recurring problem).
> > > 
> > > I also strongly dislike using In-Reply-To for new versions, as it tends to confuse
> > > b4, and often confuses me as well.
> > > 
> > > But for this, I don't see any reason to send a v3.
> > 
> > Any status on this?  I don't see it in linux-next at all, nor in
> > 6.17-rc1
> 
> I'll get it applied and sent along to Paolo/Linus this week.

Thanks!

