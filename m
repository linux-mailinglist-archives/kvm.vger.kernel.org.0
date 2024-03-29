Return-Path: <kvm+bounces-13091-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FFAA891892
	for <lists+kvm@lfdr.de>; Fri, 29 Mar 2024 13:21:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B95A91F23C03
	for <lists+kvm@lfdr.de>; Fri, 29 Mar 2024 12:21:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3903585927;
	Fri, 29 Mar 2024 12:21:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EU+TObV2"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 620B169E1E;
	Fri, 29 Mar 2024 12:21:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711714885; cv=none; b=ZeKLwTkhvPJBEapEseSOa6axjmN7qljyfbAbSGEoIjbV/Rgtl3ChjOqcgLgOOOY8e7sWq8tSTrCB0TIX8pU0ewfSzXjePFKOp5pl9sRdIg07A/bRSiuvstn/WsWHYNUaJ/bI1gi1/9XD6DRwvHP2K76l+PWDdZ+h67paGeoxn9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711714885; c=relaxed/simple;
	bh=KV8MAW0WMd10XKbpiyQdNKyGugobmHYXrd9fx5ETW1w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PyjGh1NUnVnMcB/fj10fD2+UMXpdGsbdc9+AxvwDcckW+gvn7MbME7SpotgCHDl/JN389nyyaTTLNBtf1i3BxMjQrqeEzCVa4P29i8Fj9NhSr2UH4QQNxWQy31nozPH5bPoDP4WZRr/MM0Ej5XGtsBUk9rKCa8DWveovgRQJYqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EU+TObV2; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56AAAC433C7;
	Fri, 29 Mar 2024 12:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711714884;
	bh=KV8MAW0WMd10XKbpiyQdNKyGugobmHYXrd9fx5ETW1w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EU+TObV27sH3T1plQcMKQCAMobCr39kitiKz2UNFsknh5jVOovWZmZRYESJoMaHBQ
	 9gQgJ2daodiXNx4nEyBjd6fpjrJ2c8NK3M0AXpnWFT8opMjvf2rnP4vMFpXIcqfYTH
	 YdcAdUIZWnCBB25uLSu/vIiVceFap4eqANvApsGk=
Date: Fri, 29 Mar 2024 13:21:20 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Marc Zyngier <maz@kernel.org>
Cc: Krister Johansen <kjlx@templeofstupid.com>, stable@vger.kernel.org,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	David Matlack <dmatlack@google.com>, kvm@vger.kernel.org
Subject: Re: [PATCH 5.15.y v2 0/2] fix softlockups in stage2_apply_range()
Message-ID: <2024032913-felt-tip-fasting-5fab@gregkh>
References: <cover.1709665227.git.kjlx@templeofstupid.com>
 <cover.1709685364.git.kjlx@templeofstupid.com>
 <878r2vr7tj.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878r2vr7tj.wl-maz@kernel.org>

On Wed, Mar 06, 2024 at 10:08:40AM +0000, Marc Zyngier wrote:
> On Wed, 06 Mar 2024 00:49:34 +0000,
> Krister Johansen <kjlx@templeofstupid.com> wrote:
> > 
> > Hi Stable Team,
> > In 5.15, unmapping large kvm vms on arm64 can generate softlockups.  My team has
> > been hitting this when tearing down VMs > 100Gb in size.
> > 
> > Oliver fixed this with the attached patches.  They've been in mainline since
> > 6.1.
> > 
> > I tested on 5.15.150 with these patches applied. When they're present,
> > both the dirty_log_perf_test detailed in the second patch, and
> > kvm_page_table_test no longer generate softlockups when unmapping VMs
> > with large memory configurations.
> > 
> > Would you please consider these patches for inclusion in an upcoming 5.15
> > release?
> > 
> > Change in v2:  I ran format-patch without the --from option which incorrectly
> > generated the first series without leaving Oliver in place as the author.  The
> > v2 should retain the correct authorship.  Apologies for the mistake.
> 
> Thanks for this.
> 
> FWIW,
> 
> Acked-by: Marc Zyngier <maz@kernel.org>

Now queued up,t hanks.

greg k-h

