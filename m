Return-Path: <kvm+bounces-34270-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 474469F9DC2
	for <lists+kvm@lfdr.de>; Sat, 21 Dec 2024 02:38:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A2109168179
	for <lists+kvm@lfdr.de>; Sat, 21 Dec 2024 01:38:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 021E633CFC;
	Sat, 21 Dec 2024 01:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="sFTMWHQk"
X-Original-To: kvm@vger.kernel.org
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 493DE33FE
	for <kvm@vger.kernel.org>; Sat, 21 Dec 2024 01:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734745122; cv=none; b=PMCkOxFiJN0jbAhZrdOF7TAY8PMaZzW7+9ex55wmBaIh/wAxmq0vkyqXNf45HqQzg3rieh1yALDm/CB8clm/bd5qoQSIVzGJI6WtQdY13zHErzD/Cyx1lztFtqYveNMJligs69A6itH294nIIYdSHDXLeeJB8TgJ2Ic/fjfVNno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734745122; c=relaxed/simple;
	bh=Si+Qd6kAVLaoxJtaoFM2XNl9uaYPslnJ1INVhXz0QG4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NOP/KbBV3v5Je6GFUzvTKdX5XASVktf54x/OIIvIO0058fBT3dvTO7L3QkustATeshxJrvs3m9wb8s2TGUw+EhGfxaCmqme09dPibP3zL1vVqGZ/QZhrySmYvivz8jQHng/U3CQTQhgZ52ZO3DcdTHG1misMkHDeTNrc084mG3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=sFTMWHQk; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 20 Dec 2024 17:38:28 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1734745118;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9RyL7OQcEcJazDGmreABUEOWcdfoZAcUPUZ/ZMoqlEM=;
	b=sFTMWHQk3svhyXXcqpblS4NAqRAygfiwVk62in7jQiqKZ8RDFeqE0usaQTEXiPxGUKAwkn
	F8GVGYSSsBkJoaSOUZLB9kuQ9NEN6rZvMmtJuSkjoPS29Ugexrqm60cwlAHZW1jlIq3uvo
	JYz0WLKQfIW+gmZqo3HvHeHBiSNMmoo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Chase Conklin <chase.conklin@arm.com>,
	Eric Auger <eauger@redhat.com>
Subject: Re: [PATCH v2 01/12] KVM: arm64: nv: Add handling of EL2-specific
 timer registers
Message-ID: <Z2Yb8BWnqpt441V-@linux.dev>
References: <20241217142321.763801-1-maz@kernel.org>
 <20241217142321.763801-2-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241217142321.763801-2-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Tue, Dec 17, 2024 at 02:23:09PM +0000, Marc Zyngier wrote:
> @@ -3879,9 +4020,11 @@ static const struct sys_reg_desc cp15_64_regs[] = {
>  	{ SYS_DESC(SYS_AARCH32_CNTPCT),	      access_arch_timer },
>  	{ Op1( 1), CRn( 0), CRm( 2), Op2( 0), access_vm_reg, NULL, TTBR1_EL1 },
>  	{ Op1( 1), CRn( 0), CRm(12), Op2( 0), access_gic_sgi }, /* ICC_ASGI1R */
> +	{ SYS_DESC(SYS_AARCH32_CNTVCT),	      access_arch_timer },
>  	{ Op1( 2), CRn( 0), CRm(12), Op2( 0), access_gic_sgi }, /* ICC_SGI0R */
>  	{ SYS_DESC(SYS_AARCH32_CNTP_CVAL),    access_arch_timer },
>  	{ SYS_DESC(SYS_AARCH32_CNTPCTSS),     access_arch_timer },
> +	{ SYS_DESC(SYS_AARCH32_CNTVCTSS),     access_arch_timer },
>  };

Huh. You know, I had always thought we hid 32-bit EL0 from nested
guests, but I now realize that isn't the case. Of course, we don't have
the necessary trap reflection for exits that came out of a 32-bit EL0,
nor should we bother.

Of the 4 NV2 implementations I'm aware of (Neoverse-V1, Neoverse-V2,
AmpereOne, M2) only Neoverse-V1 supports 32-bit userspace. And even
then, a lot of deployments of V1 have a broken NV2 implementation.

What do you think about advertising a 64-bit only EL0 for nested VMs?

-- 
Thanks,
Oliver

