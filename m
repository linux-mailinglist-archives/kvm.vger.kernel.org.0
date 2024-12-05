Return-Path: <kvm+bounces-33166-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B7CE59E5C8D
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2024 18:08:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 93E541687D5
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2024 17:08:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A6E7224AFA;
	Thu,  5 Dec 2024 17:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="adWPkEPi"
X-Original-To: kvm@vger.kernel.org
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 999E9218AD3
	for <kvm@vger.kernel.org>; Thu,  5 Dec 2024 17:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733418490; cv=none; b=ZdDOCdjXdjk2HzKQBr3WTDPuid1sdFfYJid/07X2Q+DZBJViQVFW6UEWBn6V7XCbUh5L9L53W+LEzsu1sAQRTf4kmckQubfZ9sRNu03k26xnh1MBjHfn4QZOImCKN364OYUWwPegiKebP9lbw6hITj5S2kZXBVDMemfHnwfZmHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733418490; c=relaxed/simple;
	bh=cZFuu/7e/p5o1jdPq0Tkt2vCOlKJBvcgmbYlWt1lCm0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NTAcQ2r1G61QlRfjdeGQ64ry7E4MpYsxaCYMMevKj9CjLoo/hpvoxHGWMK07BjzBAaHM/qCDM9gSNR7df1jRHAgd3q1sy9WRpo8P8G1rGGckzta68H0S5vMbuGI9gTxIEq66qrVfGRMnkxvFjcLdzE+rGJtuhNspV4en9tOKWss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=adWPkEPi; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 5 Dec 2024 09:07:57 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1733418486;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tuMoj6FBrwthfD/QXRKn0T8MpcQJVZC+PuFcPiXv5lw=;
	b=adWPkEPi2AC+ur++cKuiZ1fjoy0tQUoKvZM6OprL6MZ0iM2PyikJZTy/F2dkkAXLU1STaq
	PJw1ITPcXqab8mPBYjn+JKlnE8SOzi2nu0FMgrqZfnHwOvDW/STL0hrmp77WVQzU7GytO9
	AfPV3XNLHObDPRwnZpFLGyipmGr+D2o=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [PATCH 06/11] KVM: arm64: nv: Acceletate EL0 counter accesses
 from hypervisor context
Message-ID: <Z1Hd7U5gZS1RDxop@linux.dev>
References: <20241202172134.384923-1-maz@kernel.org>
 <20241202172134.384923-7-maz@kernel.org>
 <Z1D1zus18KCpCqjD@linux.dev>
 <86ikrytmr6.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86ikrytmr6.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Thu, Dec 05, 2024 at 11:03:41AM +0000, Marc Zyngier wrote:
> On Thu, 05 Dec 2024 00:37:34 +0000,
> Oliver Upton <oliver.upton@linux.dev> wrote:
> > 
> > typo: accelerate
> 
> Huh, thanks!
> 
> > 
> > On Mon, Dec 02, 2024 at 05:21:29PM +0000, Marc Zyngier wrote:
> 
> [...]
> 
> > > +	case SYS_CNTVCT_EL0:
> > > +	case SYS_CNTVCTSS_EL0:
> > > +		/* If !ELIsInHost(EL2), the guest's CNTVOFF_EL2 applies */
> > 
> > !ELIsInHost(EL0)
> 
> No, and that's the whole point. CNTVOFF_EL2 applies at all times when
> HCR_EL2==0 and that we're at EL2. From the pseudocode for CNTVCT_EL0:

Dammit, I don't know how many times I misread "CNTPCT" here rather than
CNTVCT. Sorry for the noise.

-- 
Thanks,
Oliver

