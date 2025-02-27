Return-Path: <kvm+bounces-39618-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 68E83A4867A
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 18:23:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 983871884188
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 17:23:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF3F51DE3C4;
	Thu, 27 Feb 2025 17:23:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MLlli9RC"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5B121A3178;
	Thu, 27 Feb 2025 17:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740676982; cv=none; b=cQ3bcRhEzpREUbqimVkzVxfHZq2g50cGsuArlsI10KFkQ+LXic6Bzb+795nKHab95F0xG6BZG8stSnl5fhm2bANlJHGsI+0otiaJak92rkm99Cen8vYVAPH1HV5iCiLY7u1T6nETfvzHyaGnUb8rrdJPaaXCkSO7PPrDNBIrPeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740676982; c=relaxed/simple;
	bh=JkGpybMCuNUorSQNS9AQSV0Uqu4j4/+ypLnwebjcqLM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lsorA+RicvwnKAk1MCJMBq1xIzwUdjIqw1S3mN+LemtAGCwmevvRBoXIAJzoPWNqsVo3teLYBih41Ag3E3tqDbsWx49WOLjxAosTvNhbCirXW9/SHvNICCfjPsH5bjOtwfPxbD23hGVY7N1kVWew8R5CD5UzAnGTj/eBkVq4jTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MLlli9RC; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C098FC4CEDD;
	Thu, 27 Feb 2025 17:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740676982;
	bh=JkGpybMCuNUorSQNS9AQSV0Uqu4j4/+ypLnwebjcqLM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MLlli9RCpdQCuAsBdWqfHmp7qixapnVQZ/yolrYRPuNVwSLv2DoIEnneEWgeJ0nj4
	 kzslxwyRk4X5rONRKO1bqgqSt9C3pC9FU+Dw5jqRoegd3rg9l1CUAmQ1OuaG7KeJc6
	 miM13dNF1MOvnEIBQo4iLOJv/M89KGdRvYKH0JQ9WAmgtq8oVlFge2R6aLoYdrh1uc
	 ZUDwQIzQhGwRdkR9Y79KCrgmF6zl0wVlq4LvDI2EyxTmbe+bq1PXrGqbnKdO3ZjJqI
	 dQ7uWYdutGW1tJU1mc/f27f8ak/hFR6odrvuxZfzbqaEidm4f3FdDLn/LWlXP8GFbc
	 SA8lIAmdy0sxQ==
Date: Thu, 27 Feb 2025 17:22:55 +0000
From: Will Deacon <will@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Steven Price <steven.price@arm.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
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
Message-ID: <20250227172254.GB25617@willie-the-truck>
References: <20241017131434.40935-1-steven.price@arm.com>
 <20241017131434.40935-10-steven.price@arm.com>
 <5aeb6f47-12be-40d5-be6f-847bb8ddc605@arm.com>
 <Z79lZdYqWINaHfrp@arm.com>
 <20250227002330.GA24899@willie-the-truck>
 <Z8BEhK8P7FXgG11f@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z8BEhK8P7FXgG11f@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Thu, Feb 27, 2025 at 10:55:00AM +0000, Catalin Marinas wrote:
> On Thu, Feb 27, 2025 at 12:23:31AM +0000, Will Deacon wrote:
> > On Wed, Feb 26, 2025 at 07:03:01PM +0000, Catalin Marinas wrote:
> > > On Wed, Feb 19, 2025 at 02:30:28PM +0000, Steven Price wrote:
> > > > > @@ -23,14 +25,16 @@ bool rodata_full __ro_after_init = IS_ENABLED(CONFIG_RODATA_FULL_DEFAULT_ENABLED
> > > > >  bool can_set_direct_map(void)
> > > > >  {
> > > > >  	/*
> > > > > -	 * rodata_full and DEBUG_PAGEALLOC require linear map to be
> > > > > -	 * mapped at page granularity, so that it is possible to
> > > > > +	 * rodata_full, DEBUG_PAGEALLOC and a Realm guest all require linear
> > > > > +	 * map to be mapped at page granularity, so that it is possible to
> > > > >  	 * protect/unprotect single pages.
> > > > >  	 *
> > > > >  	 * KFENCE pool requires page-granular mapping if initialized late.
> > > > > +	 *
> > > > > +	 * Realms need to make pages shared/protected at page granularity.
> > > > >  	 */
> > > > >  	return rodata_full || debug_pagealloc_enabled() ||
> > > > > -	       arm64_kfence_can_set_direct_map();
> > > > > +		arm64_kfence_can_set_direct_map() || is_realm_world();
> > > > >  }
> > > > 
> > > > Aneesh pointed out that this call to is_realm_world() is now too early 
> > > > since the decision to delay the RSI detection. The upshot is that a 
> > > > realm guest which doesn't have page granularity forced for other reasons 
> > > > will fail to share pages with the host.
> > > > 
> > > > At the moment I can think of a couple of options:
> > > > 
> > > > (1) Make rodata_full a requirement for realm guests. 
> > > >     CONFIG_RODATA_FULL_DEFAULT_ENABLED is already "default y" so this 
> > > >     isn't a big ask.
> > > > 
> > > > (2) Revisit the idea of detecting when running as a realm guest early. 
> > > >     This has the advantage of also "fixing" earlycon (no need to 
> > > >     manually specify the shared-alias of an unprotected UART).
> > > > 
> > > > I'm currently leaning towards (1) because it's the default anyway. But 
> > > > if we're going to need to fix earlycon (or indeed find other similar 
> > > > issues) then (2) would obviously make sense.
> > > 
> > > I'd go with (1) since the end result is the same even if we implemented
> > > (2) - i.e. we still avoid block mappings in realms.
> > 
> > Is it, though? The config option is about the default behaviour but there's
> > still an "rodata=" option on the command-line.
> 
> Yeah, that's why I suggested the pr_err() to only state that it cannot
> set the direct map and consider rodata=full rather than a config option.
> We already force CONFIG_STRICT_KERNEL_RWX.

rodata=full has absolutely nothing to do with realms, though. It just
happens to result in the linear map being created at page granularity
and I don't think we should expose that implementation detail like this.

> But we can also revisit the decision not to probe the RSI early.

Alternatively, could we predicate realm support on BBM level-3 w/o TLB
conflicts? Then we could crack the blocks in the linear map.

Will

