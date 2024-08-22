Return-Path: <kvm+bounces-24825-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 879BC95B8AF
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2024 16:39:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B7BA91C202F9
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2024 14:39:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 528BB1CC153;
	Thu, 22 Aug 2024 14:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vGxVkLqd"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F3DA1CBEB5
	for <kvm@vger.kernel.org>; Thu, 22 Aug 2024 14:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724337562; cv=none; b=ot+wP0PcBI7DvlMU2lHbs+HlOLdhFgEXZBs1//cXZLJEnZhrd9sFWAHARFeP9eGq6dGpBLmR0De3Gh/TXpBCUwLWq0Y+lufMjIsGM5Nuidyqk8Cd+VBWm6WRYkW8qy3TmFl6vaGrq0AL+cRl93Mi3XQWKMuM8rhTsqpFM5SC6+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724337562; c=relaxed/simple;
	bh=X8KSExe0JVjcfIOQiQemA3j9+WycDlheDhru+uxRmKE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JzXb69qoBfN7RgGIsvYMcMsAZBV+ghpEzQTT4mCJ3VGEt/bC7VSoQE0d55IVbnhC/tBCml6sqoa0g3/sTkag1X3BdSP5QcH3sLjKogos/qrjrtkz9GWgY4fThdsmBIAbXVZuhrkENlDy29G3u1Fh0/cBkMdoADlLb6sYqXHb8uA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vGxVkLqd; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3FBCC32782;
	Thu, 22 Aug 2024 14:39:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724337562;
	bh=X8KSExe0JVjcfIOQiQemA3j9+WycDlheDhru+uxRmKE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vGxVkLqd5D67VB73eVX0juEB/LJJoRao2+DOlHljlCrmwVRXDg0njq9LyoDJbAxFg
	 FxaguYnEP7+G1loo/FICsAYslU7MtHiHIGmTlVit7B3qVKnG2yzDGoKiONfr0CqlM/
	 1G8tGNCxmpt8oBTlhdBoEFfOs6vrG9N9DWeCFGU/2B1rUcZhahi6k1UbApmpEyBaQN
	 dfzFJEnIKVW/jzbmp71ICt1O+NSAFqoWSobDvQ12gWlIWA/6tdzSHfOtOATaPFuZlh
	 jJo6BlPo7KHc4Tio+k6m86k117eseUkSji/fypxk4ZZ3iAEw6JWHTwYN5zSRf+/TtO
	 pQqQHFs5roJGw==
Date: Thu, 22 Aug 2024 08:39:19 -0600
From: Keith Busch <kbusch@kernel.org>
To: Tao Su <tao1.su@linux.intel.com>
Cc: Keith Busch <kbusch@meta.com>, kvm@vger.kernel.org, x86@kernel.org,
	Alex Williamson <alex.williamson@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Xu Liu <liuxu@meta.com>
Subject: Re: [PATCH RFC] kvm: emulate avx vmovdq
Message-ID: <ZsdNl_Adm6FC6ejG@kbusch-mbp.mynextlight.net>
References: <20240820230431.3850991-1-kbusch@meta.com>
 <ZsbnO17DWqpKHkmU@linux.bj.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZsbnO17DWqpKHkmU@linux.bj.intel.com>

On Thu, Aug 22, 2024 at 03:22:35PM +0800, Tao Su wrote:
> On Tue, Aug 20, 2024 at 04:04:31PM -0700, Keith Busch wrote:
> > +	if (map == 1 && !v)
> > +		return avx_0f_table[ctxt->b];
> > +	return (struct opcode){.flags = NotImpl};
> 
> Can we check whether the host supports AVX? I.e. if the host does not support
> AVX, set NotImpl. I am thinking that if the host does not support AVX, perhaps
> the guest executing AVX instructions will cause the host to panic, because the
> host will execute AVX instructions during the simulation.
> 
> Yeah if the host does not support AVX, it may not report AVX to the guest, but
> the guest can always ignore the AVX check, such as the code in the commit.

That's a good thought. Here is how I rationalized not adding additional
checks for it:

If the guest cpu doesn't support AVX, I think it should fail then and
there rather than trap to the hypervisor running on the host, so this
new code wouldn't get a chance to attempt emulating it. 

In the case where the host doesn't support AVX, but the guest does
support it, then I assume the VM is running on an emulated CPU and not
using kvm acceleration anymore.

Anyway, I haven't tried it, so not entirely confident that's how this
all works. I was mainly following the existing SSE emulations, which
don't have CPU support checks either. I don't think it's a problem to
add such checks though, so happy to do it if needed.

