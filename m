Return-Path: <kvm+bounces-39357-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 78388A46A90
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 20:03:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CD5C616D689
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 19:03:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4355237A3C;
	Wed, 26 Feb 2025 19:03:08 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F1A1183CCA;
	Wed, 26 Feb 2025 19:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740596588; cv=none; b=lkPNoINELxJBmEks0mg/W+8SY6bDxiBMNr6WuXg+mgh1GHCTAuTvFhhNre3B8i6RuvZ8nWY7G4ikP0yrb7KunOL5Pd/M82AWKlmiZViUcC2bleFSyl52wgTkwINiuHul/QnnoETWKZgj623bUbdQA4mddUpntSswjjdMlFLTvJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740596588; c=relaxed/simple;
	bh=0PqRmrErNpl4Jtg6yBGuNZ5C5vDip9QFb3/+TQ9Hbns=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EHugK4h00dVZhLUzgc8Vj60i9Bn6kdrIEDXWR+kOz2rrPYIASKcdmH6SWSLO55s3jtW13mEvh07xEPcVTAWGTYq3ceulOw1lZtOjLsHBPpDSa36lroEeF5d3pM9X9wPpYlQhqZ4BatvJFZVjXWqc6/zl+ixJx7bsH+pbbf2pkFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D290C4CED6;
	Wed, 26 Feb 2025 19:03:04 +0000 (UTC)
Date: Wed, 26 Feb 2025 19:03:01 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Steven Price <steven.price@arm.com>
Cc: "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
	Will Deacon <will@kernel.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Gavin Shan <gshan@redhat.com>,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Alper Gun <alpergun@google.com>, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org
Subject: Re: [PATCH v7 09/11] arm64: Enable memory encrypt for Realms
Message-ID: <Z79lZdYqWINaHfrp@arm.com>
References: <20241017131434.40935-1-steven.price@arm.com>
 <20241017131434.40935-10-steven.price@arm.com>
 <5aeb6f47-12be-40d5-be6f-847bb8ddc605@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5aeb6f47-12be-40d5-be6f-847bb8ddc605@arm.com>

On Wed, Feb 19, 2025 at 02:30:28PM +0000, Steven Price wrote:
> On 17/10/2024 14:14, Steven Price wrote:
> > From: Suzuki K Poulose <suzuki.poulose@arm.com>
> > 
> > Use the memory encryption APIs to trigger a RSI call to request a
> > transition between protected memory and shared memory (or vice versa)
> > and updating the kernel's linear map of modified pages to flip the top
> > bit of the IPA. This requires that block mappings are not used in the
> > direct map for realm guests.
> > 
> > Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
> > Reviewed-by: Gavin Shan <gshan@redhat.com>
> > Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> > Co-developed-by: Steven Price <steven.price@arm.com>
> > Signed-off-by: Steven Price <steven.price@arm.com>
> > ---
> [...]
> > diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
> > index 547a9e0b46c2..6ae6ae806454 100644
> > --- a/arch/arm64/mm/pageattr.c
> > +++ b/arch/arm64/mm/pageattr.c
> > @@ -5,10 +5,12 @@
> >  #include <linux/kernel.h>
> >  #include <linux/mm.h>
> >  #include <linux/module.h>
> > +#include <linux/mem_encrypt.h>
> >  #include <linux/sched.h>
> >  #include <linux/vmalloc.h>
> >  
> >  #include <asm/cacheflush.h>
> > +#include <asm/pgtable-prot.h>
> >  #include <asm/set_memory.h>
> >  #include <asm/tlbflush.h>
> >  #include <asm/kfence.h>
> > @@ -23,14 +25,16 @@ bool rodata_full __ro_after_init = IS_ENABLED(CONFIG_RODATA_FULL_DEFAULT_ENABLED
> >  bool can_set_direct_map(void)
> >  {
> >  	/*
> > -	 * rodata_full and DEBUG_PAGEALLOC require linear map to be
> > -	 * mapped at page granularity, so that it is possible to
> > +	 * rodata_full, DEBUG_PAGEALLOC and a Realm guest all require linear
> > +	 * map to be mapped at page granularity, so that it is possible to
> >  	 * protect/unprotect single pages.
> >  	 *
> >  	 * KFENCE pool requires page-granular mapping if initialized late.
> > +	 *
> > +	 * Realms need to make pages shared/protected at page granularity.
> >  	 */
> >  	return rodata_full || debug_pagealloc_enabled() ||
> > -	       arm64_kfence_can_set_direct_map();
> > +		arm64_kfence_can_set_direct_map() || is_realm_world();
> >  }
> 
> Aneesh pointed out that this call to is_realm_world() is now too early 
> since the decision to delay the RSI detection. The upshot is that a 
> realm guest which doesn't have page granularity forced for other reasons 
> will fail to share pages with the host.
> 
> At the moment I can think of a couple of options:
> 
> (1) Make rodata_full a requirement for realm guests. 
>     CONFIG_RODATA_FULL_DEFAULT_ENABLED is already "default y" so this 
>     isn't a big ask.
> 
> (2) Revisit the idea of detecting when running as a realm guest early. 
>     This has the advantage of also "fixing" earlycon (no need to 
>     manually specify the shared-alias of an unprotected UART).
> 
> I'm currently leaning towards (1) because it's the default anyway. But 
> if we're going to need to fix earlycon (or indeed find other similar 
> issues) then (2) would obviously make sense.

I'd go with (1) since the end result is the same even if we implemented
(2) - i.e. we still avoid block mappings in realms.

> diff --git a/arch/arm64/kernel/rsi.c b/arch/arm64/kernel/rsi.c
> index ce4778141ec7..48a6ef0f401c 100644
> --- a/arch/arm64/kernel/rsi.c
> +++ b/arch/arm64/kernel/rsi.c
> @@ -126,6 +126,10 @@ void __init arm64_rsi_init(void)
>  		return;
>  	if (!rsi_version_matches())
>  		return;
> +	if (!can_set_direct_map()) {
> +		pr_err("rodata_full disabled, unable to run as a realm guest. Please enable CONFIG_RODATA_FULL_DEFAULT_ENABLED\n");

It's a bit strange to complain about rodata since, in principle, it
doesn't have anything to do with realms. Its only side-effect is that we
avoid block kernel mappings. Maybe "cannot set the kernel direct map,
consider rodata=full" or something like that.

-- 
Catalin

