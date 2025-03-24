Return-Path: <kvm+bounces-41793-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 94DAEA6D880
	for <lists+kvm@lfdr.de>; Mon, 24 Mar 2025 11:43:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1B9E81892D1E
	for <lists+kvm@lfdr.de>; Mon, 24 Mar 2025 10:43:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2229225E442;
	Mon, 24 Mar 2025 10:41:10 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF29425DD19
	for <kvm@vger.kernel.org>; Mon, 24 Mar 2025 10:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742812869; cv=none; b=ktHqbqSmwKZolzyUzVYLl7LJ69/1n1EZI++Pwi6atfjSBsD783l8DRhaYS2LPSqAdxSokkXYRIhXlHYkPvexc5Gfye51x66eHLxjaf4Cd+FtBpRXJxGz8xokd3OJnhp09jKU81zMDyvuouZbYgSIO3Tdelt6ODe6DLEFm1pFwLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742812869; c=relaxed/simple;
	bh=/MFeqRbqXL6Mtpk9Gu9vEDBTbz5bwSMdZbaYMuOk/qo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XVXOMVtAsFADaVnlMbKcN4v91UPSLHEKPRXBQpxGbvt+EeiNwlxPK7nM0ucVlozMJ9tR3w5xkCqlcmwnpmbDIJbruplG0wb/RRXyWEaNv/n67C+m+psrPB2eVFEmbBl2EZdB7/npUnFYBSYVeOQD61YsHWt/hw1ptHPDuG5j/K4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 72C5F1A2D;
	Mon, 24 Mar 2025 03:41:13 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DEBAA3F63F;
	Mon, 24 Mar 2025 03:41:05 -0700 (PDT)
Date: Mon, 24 Mar 2025 10:41:03 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Andrew Jones <andrew.jones@linux.dev>
Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>, eric.auger@redhat.com,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org, vladimir.murzin@arm.com
Subject: Re: [kvm-unit-tests PATCH v2 4/5] configure: Add --qemu-cpu option
Message-ID: <Z-E2v1sKiPG_pt9x@raptor>
References: <20250314154904.3946484-2-jean-philippe@linaro.org>
 <20250314154904.3946484-6-jean-philippe@linaro.org>
 <20250322-91a8125ad8651b24246e5799@orel>
 <Z9_tg6WhKvIJtBai@raptor>
 <20250324-5d22d8ad79a9db37b1cf6961@orel>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250324-5d22d8ad79a9db37b1cf6961@orel>

Hi Drew,

On Mon, Mar 24, 2025 at 09:19:27AM +0100, Andrew Jones wrote:
> On Sun, Mar 23, 2025 at 11:16:19AM +0000, Alexandru Elisei wrote:
> ...
> > > > +if [ -z "$qemu_cpu" ]; then
> > > > +	if ( [ "$ACCEL" = "kvm" ] || [ "$ACCEL" = "hvf" ] ) &&
> > > > +	   ( [ "$HOST" = "aarch64" ] || [ "$HOST" = "arm" ] ); then
> > > > +		qemu_cpu="host"
> > > >  		if [ "$ARCH" = "arm" ] && [ "$HOST" = "aarch64" ]; then
> > > > -			processor+=",aarch64=off"
> > > > +			qemu_cpu+=",aarch64=off"
> > > >  		fi
> > > > +	elif [ "$ARCH" = "arm64" ]; then
> > > > +		qemu_cpu="cortex-a57"
> > > > +	else
> > > > +		qemu_cpu="cortex-a15"
> > > 
> > > configure could set this in config.mak as DEFAULT_PROCESSOR, avoiding the
> > > need to duplicate it here.
> > 
> > That was my first instinct too, having the default value in config.mak seemed
> > like the correct solution.
> > 
> > But the problem with this is that the default -cpu type depends on -accel (set
> > via unittests.cfg or as an environment variable), host and test architecture
> > combination. All of these variables are known only at runtime.
> > 
> > Let's say we have DEFAULT_QEMU_CPU=cortex-a57 in config.mak. If we keep the
> > above heuristic, arm/run will override it with host,aarch64=off. IMO, having it
> > in config.mak, but arm/run using it only under certain conditions is worse than
> > not having it at all. arm/run choosing the default value **all the time** is at
> > least consistent.
> 
> I think having 'DEFAULT' in the name implies that it will only be used if
> there's nothing better, and we don't require everything in config.mak to
> be used (there's even some s390x-specific stuff in there for all
> architectures...)

I'm still leaning towards having the default value and the heuristics for
when to pick it in one place ($ARCH/run) as being more convenient, but I
can certainly see your point of view.

So yeah, up to you :)

> 
> > 
> > We could modify the help text for --qemu-cpu to say something like "If left
> > unset, the $ARCH/run script will choose a best value based on the host system
> > and test configuration."
> 
> This is helpful, so we should add it regardless.

Thanks,
Alex

