Return-Path: <kvm+bounces-22096-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C18F8939D06
	for <lists+kvm@lfdr.de>; Tue, 23 Jul 2024 10:57:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7BFC3282A30
	for <lists+kvm@lfdr.de>; Tue, 23 Jul 2024 08:57:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A0D714C5B0;
	Tue, 23 Jul 2024 08:57:30 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68E38DDDC
	for <kvm@vger.kernel.org>; Tue, 23 Jul 2024 08:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721725049; cv=none; b=PcMy8meOueMQtVjrpS0FAmBBlZcAGBJzmxhKsnz+quEanhBjG/Vd/SHpCqepsC4bhjOvztZnlIstDttKbiSF0Ap/dkHoLldTGalpgrYGb4cRAc6UW4uYkQej8Z9tQGkEq2SZVjbhqTUbtMmQSGuDBYQy6QK0DlfOt9ISvcodwkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721725049; c=relaxed/simple;
	bh=gvpFIsIWSjCkgJeJVwYZD0Ypa7vJ5HnFOsuayUaovc0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O9BU3RL+eIFat5OfAvaM/vZtN11x9Fzfm+Ze+vwr2EAImbhbwZ1F9MGSaObJAJ5DTRScS9H1eG8hJ2NFwGDDwR+HvH+H8Glqgxyrv8fp9SWk5tncSYcDr2zekgLMrde3Vxfik6e7dR1lSfLCyr/eT4Terx6uOWapzGAAxoij4tI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 49D87139F;
	Tue, 23 Jul 2024 01:57:53 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2F0673F766;
	Tue, 23 Jul 2024 01:57:26 -0700 (PDT)
Date: Tue, 23 Jul 2024 09:57:23 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>, Joey Gouly <joey.gouly@arm.com>
Subject: Re: [PATCH 10/12] KVM: arm64: nv: Add SW walker for AT S1 emulation
Message-ID: <Zp9wc6PS9m6TMrHA@raptor>
References: <20240625133508.259829-1-maz@kernel.org>
 <20240708165800.1220065-1-maz@kernel.org>
 <Zp46GUJJ9xBWsJsQ@raptor>
 <874j8h5u0j.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874j8h5u0j.wl-maz@kernel.org>

Hi Marc,

On Mon, Jul 22, 2024 at 04:25:00PM +0100, Marc Zyngier wrote:
> Hi Alex,
> 
> On Mon, 22 Jul 2024 11:53:13 +0100,
> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
> > 
> > Hi Marc,
> > 
> > I would like to use the S1 walker for KVM SPE, and I was planning to move it to
> > a separate file, where it would be shared between nested KVM and SPE. I think
> > this is also good for NV, since the walker would get more testing.
> > 
> > Do you think moving it to a shared location is a good approach? Or do you have
> > something else in mind?
> 
> I'm definitely open to moving it somewhere else if that helps, though
> the location doesn't matter much, TBH, and it is the boundary of the
> interface I'm more interested in. It may need some work though, as the
> current design is solely written with AT in mind.

Looks that way to me too.

> 
> > Also, do you know where you'll be able to send an updated version of this
> > series? I'm asking because I want to decide between using this code (with fixes
> > on top) or wait for the next iteration. Please don't feel that you need to send
> > the next iteration too soon.
> 
> The current state of the branch is at [1], which I plan to send once
> -rc1 is out. Note that this isn't a stable branch, so things can
> change without any warning!
> 
> > And please CC me on the series, so I don't miss it by mistake :)
> 
> Of course!

Sounds great, thanks!

Alex

> 
> Thanks,
> 
> 	M.
> 
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=kvm-arm64/nv-at-pan-WIP
> 
> -- 
> Without deviation from the norm, progress is not possible.
> 

