Return-Path: <kvm+bounces-39560-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D5DEBA47AD5
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 11:55:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DD45E16C847
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 10:55:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B91822A7E7;
	Thu, 27 Feb 2025 10:55:07 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8E421DC997;
	Thu, 27 Feb 2025 10:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740653706; cv=none; b=W9y3VVhZ9SFeBgbbSuZ7HWMBXLWyoFJOtBEG+N4v8LwMWvkok4YQ86um2ToxtgmVW8HwxM9djj8YlGjLDYz/GMw3kPjlBq9qeNW6vyFk9pT7muRnOegWzfAgxxFI456ynS7E6nX7fIFwknZbaNV6GjnisM5bd59R8GjX0SCbfwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740653706; c=relaxed/simple;
	bh=au2uGxWas7Tjk9gJv8TRw03CCJBiNltN8pVoM9Agk/8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oWTuHc+OIty/b8Nrs0WuA4ea0coQa29T67/tmw9lb4lmVXauoUHCNVg1NooAmRzNwQFXH+0ETKh0d2ckNqhu/14xeEo/OEQR7lLoAnho6awiTL0M5P6ykRKSFE3KHDiGnoHn+K2MIXxbJaNkQopWcdHKljK83a5YzD1kvJxBxDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0075C4CEDD;
	Thu, 27 Feb 2025 10:55:02 +0000 (UTC)
Date: Thu, 27 Feb 2025 10:55:00 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Will Deacon <will@kernel.org>
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
Message-ID: <Z8BEhK8P7FXgG11f@arm.com>
References: <20241017131434.40935-1-steven.price@arm.com>
 <20241017131434.40935-10-steven.price@arm.com>
 <5aeb6f47-12be-40d5-be6f-847bb8ddc605@arm.com>
 <Z79lZdYqWINaHfrp@arm.com>
 <20250227002330.GA24899@willie-the-truck>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250227002330.GA24899@willie-the-truck>

On Thu, Feb 27, 2025 at 12:23:31AM +0000, Will Deacon wrote:
> On Wed, Feb 26, 2025 at 07:03:01PM +0000, Catalin Marinas wrote:
> > On Wed, Feb 19, 2025 at 02:30:28PM +0000, Steven Price wrote:
> > > > @@ -23,14 +25,16 @@ bool rodata_full __ro_after_init = IS_ENABLED(CONFIG_RODATA_FULL_DEFAULT_ENABLED
> > > >  bool can_set_direct_map(void)
> > > >  {
> > > >  	/*
> > > > -	 * rodata_full and DEBUG_PAGEALLOC require linear map to be
> > > > -	 * mapped at page granularity, so that it is possible to
> > > > +	 * rodata_full, DEBUG_PAGEALLOC and a Realm guest all require linear
> > > > +	 * map to be mapped at page granularity, so that it is possible to
> > > >  	 * protect/unprotect single pages.
> > > >  	 *
> > > >  	 * KFENCE pool requires page-granular mapping if initialized late.
> > > > +	 *
> > > > +	 * Realms need to make pages shared/protected at page granularity.
> > > >  	 */
> > > >  	return rodata_full || debug_pagealloc_enabled() ||
> > > > -	       arm64_kfence_can_set_direct_map();
> > > > +		arm64_kfence_can_set_direct_map() || is_realm_world();
> > > >  }
> > > 
> > > Aneesh pointed out that this call to is_realm_world() is now too early 
> > > since the decision to delay the RSI detection. The upshot is that a 
> > > realm guest which doesn't have page granularity forced for other reasons 
> > > will fail to share pages with the host.
> > > 
> > > At the moment I can think of a couple of options:
> > > 
> > > (1) Make rodata_full a requirement for realm guests. 
> > >     CONFIG_RODATA_FULL_DEFAULT_ENABLED is already "default y" so this 
> > >     isn't a big ask.
> > > 
> > > (2) Revisit the idea of detecting when running as a realm guest early. 
> > >     This has the advantage of also "fixing" earlycon (no need to 
> > >     manually specify the shared-alias of an unprotected UART).
> > > 
> > > I'm currently leaning towards (1) because it's the default anyway. But 
> > > if we're going to need to fix earlycon (or indeed find other similar 
> > > issues) then (2) would obviously make sense.
> > 
> > I'd go with (1) since the end result is the same even if we implemented
> > (2) - i.e. we still avoid block mappings in realms.
> 
> Is it, though? The config option is about the default behaviour but there's
> still an "rodata=" option on the command-line.

Yeah, that's why I suggested the pr_err() to only state that it cannot
set the direct map and consider rodata=full rather than a config option.
We already force CONFIG_STRICT_KERNEL_RWX.

But we can also revisit the decision not to probe the RSI early.

-- 
Catalin

