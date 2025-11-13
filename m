Return-Path: <kvm+bounces-63054-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 713F4C5A461
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 23:06:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CFDAF3AD778
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 21:59:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCA3C3254A9;
	Thu, 13 Nov 2025 21:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Bt1HFehq"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF463324B3C;
	Thu, 13 Nov 2025 21:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763071177; cv=none; b=ZLiNTMMwdw03Gza5LtngwXv3t5n3ICZCW6bK9dREYxqmiRYvhGYqGCfurxah6f/04CiRvJxxZ0Bk789ciJE5p7mwnuUPYcp1cIda9FeEDvbJdzTu6U50cwzO6rl6fzLrTzOtafhClKJGi8gpVNJbq9Ika48/U1bGYUM+jMRD5Og=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763071177; c=relaxed/simple;
	bh=UnZOEY9cSyoxchmU4I4ZbyI1+seIbFOun8eX8HryMlQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=phq/41zF3MkQw7TVnOPfDax7YbbCAcqLWTrBKyhxZ8Y77jYf0gw1Uk9Uu9LvwibFyU81SkdYnH3OAdSkLVnZ2qxGAdI/oe4pJLbPaeRaP0X5YPS/IHMyh3NARFGOn3RhqEYWnzY83P/mUL9mtda2LnQDJMfBvY/0siypvK/EanM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Bt1HFehq; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EA6AC4CEF8;
	Thu, 13 Nov 2025 21:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763071177;
	bh=UnZOEY9cSyoxchmU4I4ZbyI1+seIbFOun8eX8HryMlQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Bt1HFehqN+Es/5TQWa0IXHbiptw4nRqIqt1PyD4C47kF5v281LoeHwiC2xMoJ12eY
	 06DSzN8q/p0QvuBNE3kPhjI7C4lppN71hEQLXNyP35bt575ilt3trvdavSArqM1gVf
	 uXRM73grYNc+ws/jr0I51YEbl2+3jqEfqbsOWcBow6c1Zz61FGe1GTfVQ6U5aQbidc
	 xOgA7tPNdFcyjIhdXFhhQ66vmJ/c8DLpAJHVeLvjiiiQ5H1EwpxOaBEoAPw2nFWL3Y
	 YfitVFLlTu3eggDBs/TuK3BomDp86SiyQq8XpmGz3rL80g8T2jTfB3TokcFXRmcsCl
	 4T4iotV2r/+hw==
Date: Thu, 13 Nov 2025 13:59:35 -0800
From: Oliver Upton <oupton@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: Mark Brown <broonie@kernel.org>, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Volodymyr Babchuk <Volodymyr_Babchuk@epam.com>,
	Yao Yuan <yaoyuan@linux.alibaba.com>, Aishwarya.TCV@arm.com,
	Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH v2 05/45] KVM: arm64: GICv3: Detect and work around the
 lack of ICV_DIR_EL1 trapping
Message-ID: <aRZUx1WkyKdFQgYy@kernel.org>
References: <20251109171619.1507205-1-maz@kernel.org>
 <20251109171619.1507205-6-maz@kernel.org>
 <7ae5874e-366f-4abd-9142-ffbe21fed3a8@sirena.org.uk>
 <86ikfdu7cu.wl-maz@kernel.org>
 <7ea5c49d-b093-475e-9f27-ad92dcc4b560@sirena.org.uk>
 <86frahu21h.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86frahu21h.wl-maz@kernel.org>

On Thu, Nov 13, 2025 at 08:10:18PM +0000, Marc Zyngier wrote:
> +Fuad
> 
> On Thu, 13 Nov 2025 19:06:31 +0000,
> Mark Brown <broonie@kernel.org> wrote:
> > 
> > [1  <text/plain; us-ascii (7bit)>]
> > On Thu, Nov 13, 2025 at 06:15:29PM +0000, Marc Zyngier wrote:
> > > Mark Brown <broonie@kernel.org> wrote:
> > 
> > > > The arch_timer case bisects to this patch in -next, regular nVHE mode
> > > > runs this test happily.
> > 
> > > My hunch is that we're missing something like the hack below, but I
> > > haven't tried it yet.
> > 
> > > I'll probably get to it tomorrow.
> > 
> > That still fails FWIW.
> 
> Yup, this has uncovered yet another pKVM bug, which doesn't preserve
> the vgic_model in its private kvm structure. I'm able to make it work
> with this:

Thanks for debugging this Marc. I've added a patch on top of kvmarm/next
with this. I don't have any A53 machines around but I was able to repro
using kvm-arm.vgic_v3_common_trap=1 on QEMU.

Thanks,
Oliver

