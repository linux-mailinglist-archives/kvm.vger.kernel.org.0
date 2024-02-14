Return-Path: <kvm+bounces-8712-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B54785547E
	for <lists+kvm@lfdr.de>; Wed, 14 Feb 2024 22:06:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9D98D1F2386F
	for <lists+kvm@lfdr.de>; Wed, 14 Feb 2024 21:06:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76B6E13EFFB;
	Wed, 14 Feb 2024 21:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Qfvu4z1g"
X-Original-To: kvm@vger.kernel.org
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7882A13DBB1
	for <kvm@vger.kernel.org>; Wed, 14 Feb 2024 21:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707944784; cv=none; b=tcNQtSuZc/HY+1oZAbW8pRN7xjonG5O7fTsLCedICxsB88p5cb0nU7qsezIGBkDynv1Zj/jkFiVAlxEHz6TVT0lSTE4saMU6nAIy4sIH7m6huCIftyhpmi48Q0YxtQLTK5WutbZlp+pA/QOwcH2kbmlha1yXAHyhoRCWM47EG/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707944784; c=relaxed/simple;
	bh=c+0UADNx4KkHHaeDm/qEDcDyoYmLg07y339g5RmUM14=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZRWhS7CROKdwmBZM9TTcKGAZMuLmV0prm/hSKXtzF5NJmwQvW3ddsyE5Lx75oOCnObRxGEoX7PVFatCL5AWvnExS4tAXoUw0gxGP7ci860824frg13tEQpOsYqsD/bMh+Kr1JE/0fSHJqtIGv2ldP2TMMnxdz7GKUot76+kcnFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Qfvu4z1g; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 14 Feb 2024 13:06:12 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1707944780;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uO6O9l/7u1FoWCDVNDPi12vidxMFWsbJFIEI+vbkcWI=;
	b=Qfvu4z1ghH0eYQfo4WtcCs4NQnZnhnvCd/kiESIbOVEsb4Pk2KCeGoA7CpjxaUK3cNiCp/
	N2IyDNCKrNA+pQoYJQOq+41kBXGMbfNasmhZgR/nS1tiefS9VwosW55GVWHiB7mKM1HoQQ
	xT6DRaSpb0uF7ELaP9CtEQsQKIUfdHc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 19/23] KVM: selftests: Add a minimal library for
 interacting with an ITS
Message-ID: <Zc0rRFLRhLfLshpm@linux.dev>
References: <20240213093250.3960069-1-oliver.upton@linux.dev>
 <20240213094114.3961683-1-oliver.upton@linux.dev>
 <86zfw33qae.wl-maz@kernel.org>
 <Zc0NsFm40nIqTmRf@linux.dev>
 <86v86q4xkf.wl-maz@kernel.org>
 <Zc0orzU-CeKEyx3j@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zc0orzU-CeKEyx3j@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Wed, Feb 14, 2024 at 12:55:11PM -0800, Oliver Upton wrote:
> On Wed, Feb 14, 2024 at 08:09:52PM +0000, Marc Zyngier wrote:
> > > If the order of restore from userspace is CBASER, CWRITER, CREADR then
> > > we **wind up replaying the entire command queue**. While insane, I'm
> > > pretty sure it is legal for the guest to write garbage after the read
> > > pointer has moved past a particular command index.
> > > 
> > > Fsck!!!
> > 
> > This is documented Documentation/virt/kvm/devices/arm-vgic-its.rst to
> > some extent, and it is allowed for the guest to crap itself on behalf
> > of userspace if the ordering isn't respected.
> 
> Ah, fair, I missed the documentation here. If we require userspace to
> write CTLR last then we _should_ be fine, but damn is this a tricky set
> of expectations.
> 
> > > So, how about we do this:
> > > 
> > >  - Provide a uaccess hook for CWRITER that changes the write-pointer
> > >    without processing any commands
> > > 
> > >  - Assert an invariant that at any time CWRITER or CREADR are read from
> > >    userspace that CREADR == CWRITER. Fail the ioctl and scream if that
> > >    isn't the case, so that way we never need to worry about processing
> > >    'in-flight' commands at the destination.
> > 
> > Are we guaranteed that we cannot ever see CWRITER != CREADR at VM
> > dumping time? I'm not convinced that we cannot preempt the vcpu thread
> > at the right spot, specially given that you can have an arbitrary
> > large batch of commands to execute.
> > 
> > Just add a page-fault to the mix, and a signal pending. Pronto, you
> > see a guest exit and you should be able to start dumping things
> > without the ITS having processed much. I haven't tried, but that
> > doesn't seem totally unlikely.
> 
> Well, we would need to run all userspace reads and writes through the
> cmd_lock in this case, which is what we already do for the CREADR
> uaccess hook. To me the 'racy' queue accessors only make sense for guest
> accesses, since the driver is expecting to poll for completion in that
> case.

My proposed invariant cannot be maintained, of course, since userspace
can do whatever it pleases on the cmdq pointers.

> Otherwise we decide the existing rules for restoring the ITS are fine
> and I get to keep my funky driver :)
> 
> -- 
> Thanks,
> Oliver
> 

