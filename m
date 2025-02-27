Return-Path: <kvm+bounces-39421-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BF6FA47028
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 01:24:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D14F116A28E
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 00:23:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C30FF4C62;
	Thu, 27 Feb 2025 00:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="r2xqihso"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB926A47;
	Thu, 27 Feb 2025 00:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740615819; cv=none; b=C8A6QN000qp6vcC3jd8GhCiqX2UbdoiUCT0VmmyQwBGe1t0oKVwHO6ko/CNyn2Bc01uYDauMdJ1JdYN+vgPdi5H/TiZ+GwR8eO/B5PQWigkfEfTyXIqqCFr1YabZFTn63oEZKZB93RFpFQmgpI5YTJFLk1GRQPhGpgMDPDx9B3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740615819; c=relaxed/simple;
	bh=arZMEBXiCeOAemtlaMD2whA3gu7IqKG3QKa02itcVOg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ct1419r43mslC0blzX6OXIPuTiXVNFfJlPURZaP9biX3RN7zSa4rhZ7ulpIT3w/9ziCd3UEBt+pTn0rKC6Q+VYgdFpdBiAoo/INEzXN7/iKeCW9yuY4wTNgxHA1LyfUM39qe/IJC0pxIW67EcYrveipfylEMZhNEduyuGpemk4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=r2xqihso; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD563C4CED6;
	Thu, 27 Feb 2025 00:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740615818;
	bh=arZMEBXiCeOAemtlaMD2whA3gu7IqKG3QKa02itcVOg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=r2xqihsoUtx0mnh8RLLIjEAjPgloTP001LONjPAwoV/xeiJy8u+h01ej7a1b68K+7
	 jUWOnoHeJxZDumCmTj/ZzoZaZG9ydutU8FnLZBzWkpQMicwuNBvJXS2zrYCAs4X0PK
	 9kteFfAcP9iTwJz0s6ulQ9jOb9Lt2ihSF97X8Vw3k+vC3npgDNha5RcKi1axciDgWl
	 bQ11PamfREIi44x+J2k4VjfstgeKYqFPYJi2np1bifjKJWgWJtGvY9/9IF2ysvlNd/
	 vbi3gA4SceTDZaht2tDFNVSpwr3sVxPgE21Im3ifhTnJ3VD2AkKkqxicmsGA5ts9Yd
	 gDhpiL5fqcsDw==
Date: Thu, 27 Feb 2025 00:23:31 +0000
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
Message-ID: <20250227002330.GA24899@willie-the-truck>
References: <20241017131434.40935-1-steven.price@arm.com>
 <20241017131434.40935-10-steven.price@arm.com>
 <5aeb6f47-12be-40d5-be6f-847bb8ddc605@arm.com>
 <Z79lZdYqWINaHfrp@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z79lZdYqWINaHfrp@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Wed, Feb 26, 2025 at 07:03:01PM +0000, Catalin Marinas wrote:
> On Wed, Feb 19, 2025 at 02:30:28PM +0000, Steven Price wrote:
> > > @@ -23,14 +25,16 @@ bool rodata_full __ro_after_init = IS_ENABLED(CONFIG_RODATA_FULL_DEFAULT_ENABLED
> > >  bool can_set_direct_map(void)
> > >  {
> > >  	/*
> > > -	 * rodata_full and DEBUG_PAGEALLOC require linear map to be
> > > -	 * mapped at page granularity, so that it is possible to
> > > +	 * rodata_full, DEBUG_PAGEALLOC and a Realm guest all require linear
> > > +	 * map to be mapped at page granularity, so that it is possible to
> > >  	 * protect/unprotect single pages.
> > >  	 *
> > >  	 * KFENCE pool requires page-granular mapping if initialized late.
> > > +	 *
> > > +	 * Realms need to make pages shared/protected at page granularity.
> > >  	 */
> > >  	return rodata_full || debug_pagealloc_enabled() ||
> > > -	       arm64_kfence_can_set_direct_map();
> > > +		arm64_kfence_can_set_direct_map() || is_realm_world();
> > >  }
> > 
> > Aneesh pointed out that this call to is_realm_world() is now too early 
> > since the decision to delay the RSI detection. The upshot is that a 
> > realm guest which doesn't have page granularity forced for other reasons 
> > will fail to share pages with the host.
> > 
> > At the moment I can think of a couple of options:
> > 
> > (1) Make rodata_full a requirement for realm guests. 
> >     CONFIG_RODATA_FULL_DEFAULT_ENABLED is already "default y" so this 
> >     isn't a big ask.
> > 
> > (2) Revisit the idea of detecting when running as a realm guest early. 
> >     This has the advantage of also "fixing" earlycon (no need to 
> >     manually specify the shared-alias of an unprotected UART).
> > 
> > I'm currently leaning towards (1) because it's the default anyway. But 
> > if we're going to need to fix earlycon (or indeed find other similar 
> > issues) then (2) would obviously make sense.
> 
> I'd go with (1) since the end result is the same even if we implemented
> (2) - i.e. we still avoid block mappings in realms.

Is it, though? The config option is about the default behaviour but there's
still an "rodata=" option on the command-line.

Will

