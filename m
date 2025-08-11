Return-Path: <kvm+bounces-54408-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 47905B207F5
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 13:34:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3D36D163668
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 11:34:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A8DB2D0C85;
	Mon, 11 Aug 2025 11:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yl11xkx3"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 204231F3BBB
	for <kvm@vger.kernel.org>; Mon, 11 Aug 2025 11:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754912061; cv=none; b=cWfDGoNtHnw53iTqu6R1KsfTayloTbWTPlO+aPVyRfoJOgnud0pOZPRXfkkqSs7eR5G2reZ8nCjGfebA2aC/p4qh3BTis1RTn8jnATlbkmugHzOCEQVFWwKo/0xQ7x1LMQCGhD/k7GBbqB1aCci3k0unOk6DMlfBFE2vQfX97yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754912061; c=relaxed/simple;
	bh=fwxKkSYPLlxR8gHFZ82A6e0sHrcMQeBtly1JdhN5MCg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nEJzyqVzmbeTYzjI+CI7RK8rnjxGANJ6FqyHt+pr6yJprjHTMbanmYmz0c2QfHl0G67tO8GnXPVNYnL9KMDI6EXRL9I4nIjpY0JofJIJQG/EdOwaNSiRuYaWLoNVN9WaIgwEEtUHtgVGmePt5Ntp9XHQ35Sgt7SdW3ui31KE4Qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yl11xkx3; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35688C4CEED;
	Mon, 11 Aug 2025 11:34:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1754912060;
	bh=fwxKkSYPLlxR8gHFZ82A6e0sHrcMQeBtly1JdhN5MCg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=yl11xkx3zcPOEiliUUxQ5kxBv0rNoHcGDcY96zoyFHb2gRvMXmJYeLTuI9qU2ARzk
	 AdpJB2hbM00d28ObUJpB2AX2dqb0zaBwEZOUQKd5WT6CjJ3k3Lhvj1OO8Dj+3GcHvw
	 cHXV1zr98OypWVjtcu75ZSzipdWASFcihPA0kn6U=
Date: Mon, 11 Aug 2025 13:34:17 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Thijs Raymakers <thijs@raymakers.nl>, kvm@vger.kernel.org,
	stable <stable@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2] KVM: x86: use array_index_nospec with indices that
 come from guest
Message-ID: <2025081151-defiling-badass-c926@gregkh>
References: <aII3WuhvJb3sY8HG@google.com>
 <20250724142227.61337-1-thijs@raymakers.nl>
 <2025072441-degrease-skipping-bbc8@gregkh>
 <aIKDr_kVpUjC8924@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aIKDr_kVpUjC8924@google.com>

On Thu, Jul 24, 2025 at 12:04:15PM -0700, Sean Christopherson wrote:
> On Thu, Jul 24, 2025, Greg Kroah-Hartman wrote:
> > On Thu, Jul 24, 2025 at 04:22:27PM +0200, Thijs Raymakers wrote:
> > > min and dest_id are guest-controlled indices. Using array_index_nospec()
> > > after the bounds checks clamps these values to mitigate speculative execution
> > > side-channels.
> > > 
> > > Signed-off-by: Thijs Raymakers <thijs@raymakers.nl>
> > > Cc: stable <stable@kernel.org>
> > > Cc: Sean Christopherson <seanjc@google.com>
> > > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > 
> > Nit, you shouldn't have added my signed off on a new version, but that's
> > ok, I'm fine with it.
> 
> Want me to keep your SoB when applying, or drop it?
> 
> > > ---
> > >  arch/x86/kvm/lapic.c | 2 ++
> > >  arch/x86/kvm/x86.c   | 7 +++++--
> > >  2 files changed, 7 insertions(+), 2 deletions(-)
> > 
> > You also forgot to say what changed down here.
> > 
> > Don't know how strict the KVM maintainers are, I know I require these
> > things fixed up...
> 
> I require the same things, but I also don't mind doing fixup when applying if
> that's the path of least resistance (and it's not a recurring problem).
> 
> I also strongly dislike using In-Reply-To for new versions, as it tends to confuse
> b4, and often confuses me as well.
> 
> But for this, I don't see any reason to send a v3.

Any status on this?  I don't see it in linux-next at all, nor in
6.17-rc1

thanks,

greg k-h

