Return-Path: <kvm+bounces-65880-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id BCEAECB937F
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 17:04:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7F9943048D47
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 16:03:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE0E123AB90;
	Fri, 12 Dec 2025 16:03:49 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BA461B81D3
	for <kvm@vger.kernel.org>; Fri, 12 Dec 2025 16:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765555429; cv=none; b=DCc+WqG00IxkrwACQNdmw5XOrJ1lZiHRY6s4mUZA48/wVgVttTOnpAVcm2ltlDGiaiWiPQTH6VxxKjrRYODpVfu2g2nS0p2Zfk8AL19GvCpyczeec7Yz6fSgv4RErMrzTuruZqhJtEq+v5HpdopkOmMwL0MCSt+ACb9hYZbXz/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765555429; c=relaxed/simple;
	bh=jAG6A7MU2Z/a421RMls9L1+fU9pciFIy+oqVfVXYQh0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SFtK8/Zye+kzlDhuT6ezSiZbOCjnNSOHlEg3cg82W7eLLMabaSU0wTGdGtt63Oof81OfH4OF0owvap88s9q+rqumzUrM0EcK8wpHuOwY0EF1BEvX/4/Eff5yD9knKHrb4qXkPKdC2w86KDUBcGDqNUPZv6hcLM3+vCC2iOnAAA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7CA9A1575;
	Fri, 12 Dec 2025 08:03:39 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 665643F762;
	Fri, 12 Dec 2025 08:03:45 -0800 (PST)
Date: Fri, 12 Dec 2025 16:03:40 +0000
From: Joey Gouly <joey.gouly@arm.com>
To: Andrew Jones <andrew.jones@linux.dev>
Cc: kvm@vger.kernel.org, alexandru.elisei@arm.com, eric.auger@redhat.com,
	maz@kernel.org, kvmarm@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [kvm-unit-tests PATCH v4 11/11] arm64: add EL2 environment
 variable
Message-ID: <20251212160340.GA978993@e124191.cambridge.arm.com>
References: <20251204142338.132483-1-joey.gouly@arm.com>
 <20251204142338.132483-12-joey.gouly@arm.com>
 <20251204-203dfc57adef00b4f6fdf910@orel>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251204-203dfc57adef00b4f6fdf910@orel>

On Thu, Dec 04, 2025 at 11:17:24AM -0600, Andrew Jones wrote:
> On Thu, Dec 04, 2025 at 02:23:38PM +0000, Joey Gouly wrote:
> > This variable when set to y/Y will cause QEMU/kvmtool to start at EL2.
> > 
> > Signed-off-by: Joey Gouly <joey.gouly@arm.com>
> > Acked-by: Marc Zyngier <maz@kernel.org>
> > Reviewed-by: Eric Auger <eric.auger@redhat.com>
> > ---
> >  arm/run | 7 +++++++
> >  1 file changed, 7 insertions(+)
> > 
> > diff --git a/arm/run b/arm/run
> > index 858333fc..dd641772 100755
> > --- a/arm/run
> > +++ b/arm/run
> > @@ -59,6 +59,10 @@ function arch_run_qemu()
> >  		M+=",highmem=off"
> >  	fi
> >  
> > +	if [ "$EL2" = "Y" ] || [ "$EL2" = "y" ]; then
> 
> I wanted to keep '1' and also add 'y' and 'Y'. We already allow those
> three (and only those three) in other places, see errata().

Couldn't find the errata() part, but I changed it to:

	if [ "$EL2" == "1" ] || [ "$EL2" = "Y" ] || [ "$EL2" = "y" ];


I also used test_exception_prep() like suggested in the other e-mail.

I will send out a next version next week, although I am aware it's very close
to holiday/vacation season!

Thanks,
Joey
> 
> Thanks,
> drew
> 
> > +		M+=",virtualization=on"
> > +	fi
> > +
> >  	if ! $qemu $M -device '?' | grep -q virtconsole; then
> >  		echo "$qemu doesn't support virtio-console for chr-testdev. Exiting."
> >  		exit 2
> > @@ -116,6 +120,9 @@ function arch_run_kvmtool()
> >  	fi
> >  
> >  	command="$(timeout_cmd) $kvmtool run"
> > +	if [ "$EL2" = "Y" ] || [ "$EL2" = "y" ]; then
> > +		command+=" --nested"
> > +	fi
> >  	if [ "$HOST" = "aarch64" ] && [ "$ARCH" = "arm" ]; then
> >  		run_test_status $command --kernel "$@" --aarch32
> >  	else
> > -- 
> > 2.25.1
> > 

