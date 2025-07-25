Return-Path: <kvm+bounces-53430-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E2586B11780
	for <lists+kvm@lfdr.de>; Fri, 25 Jul 2025 06:42:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B8C093B4796
	for <lists+kvm@lfdr.de>; Fri, 25 Jul 2025 04:41:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DD9C23CEE5;
	Fri, 25 Jul 2025 04:42:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x1PQJA+0"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75EE63594E
	for <kvm@vger.kernel.org>; Fri, 25 Jul 2025 04:42:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753418538; cv=none; b=YPAAsuLVMdy02daRPqB9m9P69xuLe7k5ubrb8J5hwLdpptx+odwmyvIEWlXzgoboj1CYr2r4SRVqFuIr3TCdiHviyvGL6GCSmRz/jXk1+R6rySUd/Jsk5A0nlHCDcIgQ5t/dj7eD2fF/AM69mTeHfuAioBinBdTP0HEPu4QVPgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753418538; c=relaxed/simple;
	bh=VVeg4GXOjAqhlF4qtmuFfE+bZBPWgZ7TiN5VXz7r+zM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YZC3m4XaSSgi6D6FTprKJ6uBnvods0UYmqYzhi+P/3p+3vlzHtzkojR1yWDPV9gDpMVByHAHU1UqlJtmeBu+hFLVPtgUiYNYjNABFzk+r7YCK/VQ95fWFvVg0I+SHI/agczDUbJUsTmW5HaSrBhnmRCSVYo040AFiNKHqL4Jl9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x1PQJA+0; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78A41C4CEE7;
	Fri, 25 Jul 2025 04:42:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753418536;
	bh=VVeg4GXOjAqhlF4qtmuFfE+bZBPWgZ7TiN5VXz7r+zM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=x1PQJA+0PdkAXYRF0iJIg6nVw+LD+9P98h+nHPWmlgdiWK6kKfvYQ1B/Me31Siz2F
	 VcYQDXhJEDDro8dVYBr5YwdsPl4hJ11hEBiHFB3gFWgDywcTnVtKk1He4wEYpxTpAU
	 NnP+AYEh0+1Yybd0e7y0IJjFgR8nY/Xe1lZ706CI=
Date: Fri, 25 Jul 2025 06:42:12 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Thijs Raymakers <thijs@raymakers.nl>, kvm@vger.kernel.org,
	stable <stable@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2] KVM: x86: use array_index_nospec with indices that
 come from guest
Message-ID: <2025072540-eggbeater-crate-50af@gregkh>
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

Keep it please, I was just letting Thijs know.

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

That's great, thanks.

greg k-h

