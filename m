Return-Path: <kvm+bounces-13695-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C38A8899992
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 11:35:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 62F591F22B1B
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 09:35:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 176D0160796;
	Fri,  5 Apr 2024 09:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gHGQHhNq"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C2E115FA98;
	Fri,  5 Apr 2024 09:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712309712; cv=none; b=Ri9oKfDg56TOnXubfDPt1HGPO16qYV/Sq6NKcOnxWn3pBmAkm+7uPYAFZU6IS0iOnCWi7vM9GsOmOB4219lwMk5PDzlBP+/P0e+PFm3g5waopxuExpRJiDg7/rHIjXHvKo8f7vE2wnvB61uKYHuwfZ9aWmPa5NbJfWmZrVxl6Uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712309712; c=relaxed/simple;
	bh=t25EdVn2baDqfSExewkTFHaoFIFKw2W79/3xkAD8PZU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aBQOSIVM7T3i6n6OObFpx48BoyUWfUd752y/lqrLrQfsOUiUVpP5YxShnRh7WypsP8q1/eStxoacmxE0sOjLJ3HI3KFPxEc88GX1nK9OxJ7D2lFAZpc/TSnZfPgLL1AA8ujoGB8U11pCKuE7h4HIkvwvsHJuLxxCP2k3ZyKog+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gHGQHhNq; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51D21C433C7;
	Fri,  5 Apr 2024 09:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712309711;
	bh=t25EdVn2baDqfSExewkTFHaoFIFKw2W79/3xkAD8PZU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gHGQHhNqq5pxOvq/iCpHR7oxtqe3gBlZgBC6eqcEcA5JAo7anIlye2bko26HvuRIo
	 AIQOTeI9QFagbMbarHi/IEOGEpH/Kr2yTCEjj9AmrZQYmwTtpyZL/q30aDwZ2PCF5X
	 D4Nv+Rg+w7+qHyXkyMRDlnd0p1yTRutNoV1bA9uc=
Date: Fri, 5 Apr 2024 11:35:08 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sean Christopherson <seanjc@google.com>
Cc: stable@vger.kernel.org, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
	David Matlack <dmatlack@google.com>,
	Pasha Tatashin <tatashin@google.com>,
	Michael Krebs <mkrebs@google.com>,
	Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH 5.15 0/2] KVM: x86: Fix for dirty logging emulated atomics
Message-ID: <2024040500-rally-each-3b44@gregkh>
References: <20240404234004.911293-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240404234004.911293-1-seanjc@google.com>

On Thu, Apr 04, 2024 at 04:40:02PM -0700, Sean Christopherson wrote:
> Two KVM x86 backports for 5.15.  Patch 2 is the primary motivation (fix
> for potential guest data corruption after live migration).
> 
> Patch 1 is a (very) soft dependency to resolve a conflict.  It's not strictly
> necessary (manually resolving the conflict wouldn't be difficult), but it
> is a fix that has been in upstream for a long time.  The only reason I didn't
> tag it for stable from the get-go is that the bug it fixes is very
> theoretical.  At this point, the odds of the patch causing problems are
> lower than the odds of me botching a manual backport.
> 
> Sean Christopherson (2):
>   KVM: x86: Bail to userspace if emulation of atomic user access faults
>   KVM: x86: Mark target gfn of emulated atomic instruction as dirty
> 
>  arch/x86/kvm/x86.c | 12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
> 
> 
> base-commit: 9465fef4ae351749f7068da8c78af4ca27e61928
> -- 
> 2.44.0.478.gd926399ef9-goog

All now queued up, thanks.

greg k-h

