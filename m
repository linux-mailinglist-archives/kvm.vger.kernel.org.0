Return-Path: <kvm+bounces-17321-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C0488C42CA
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 16:03:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CD7691C231A4
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 14:03:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F309153814;
	Mon, 13 May 2024 14:03:29 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ACF950279;
	Mon, 13 May 2024 14:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715609008; cv=none; b=IpbAy+saQTitQIJQl5aVxx5BImj9m7OZ0WiohZYdUyy1PxqwgYjverR8bTl0VMCOtkLoTivqST2BGLv2DQnh7uBD5ccD9QRgw95MQZn4nROJSICk+0WD5Q9nC3GI5/LCLDoPWvj5+ab63eJPP0jcruWPT5E4OZMLe5Q09cWHe1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715609008; c=relaxed/simple;
	bh=K7veTtApNyiwjmLaFO5BMobsj0TYJEd3cEVzL9mDR7w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=chahyhx/xePUlSqPPjz3XDo+WfwF4WT4o25UZL9qdId7ac17Q+Xje82Y7VOkb3y/hh7M34uSxdEIkNrH6GNYFjk3SJ8v+yyCPgm/4kqcmtGlIBLyQ4dBhi+WYyg6e4BNtWzSHfStdk+JC0PjjCK6/qqaQnSG/xf6GuuSFBiVV3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBA00C4AF17;
	Mon, 13 May 2024 14:03:24 +0000 (UTC)
Date: Mon, 13 May 2024 15:03:22 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Steven Price <steven.price@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Subject: Re: [PATCH v2 03/14] arm64: realm: Query IPA size from the RMM
Message-ID: <ZkIdqoELmQ3tUJ8M@arm.com>
References: <20240412084213.1733764-1-steven.price@arm.com>
 <20240412084213.1733764-4-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240412084213.1733764-4-steven.price@arm.com>

On Fri, Apr 12, 2024 at 09:42:02AM +0100, Steven Price wrote:
> diff --git a/arch/arm64/include/asm/pgtable-prot.h b/arch/arm64/include/asm/pgtable-prot.h
> index dd9ee67d1d87..15d8f0133af8 100644
> --- a/arch/arm64/include/asm/pgtable-prot.h
> +++ b/arch/arm64/include/asm/pgtable-prot.h
> @@ -63,6 +63,9 @@
>  #include <asm/pgtable-types.h>
>  
>  extern bool arm64_use_ng_mappings;
> +extern unsigned long prot_ns_shared;
> +
> +#define PROT_NS_SHARED		((prot_ns_shared))

Nit: what's with the double parenthesis here?

>  #define PTE_MAYBE_NG		(arm64_use_ng_mappings ? PTE_NG : 0)
>  #define PMD_MAYBE_NG		(arm64_use_ng_mappings ? PMD_SECT_NG : 0)
> diff --git a/arch/arm64/kernel/rsi.c b/arch/arm64/kernel/rsi.c
> index 1076649ac082..b93252ed6fc5 100644
> --- a/arch/arm64/kernel/rsi.c
> +++ b/arch/arm64/kernel/rsi.c
> @@ -7,6 +7,11 @@
>  #include <linux/memblock.h>
>  #include <asm/rsi.h>
>  
> +struct realm_config __attribute((aligned(PAGE_SIZE))) config;

Another nit: use __aligned(PAGE_SIZE).

However, does the spec require this to be page-size aligned? The spec
says aligned to 0x1000 and that's not necessarily the kernel page size.
It also states that the RsiRealmConfig structure is 4096 and I did not
see this in the first patch, you only have 8 bytes in this structure.
Some future spec may write more data here overriding your other
variables in the data section.

So that's the wrong place to force the alignment. Just do this when you
define the actual structure in the first patch:

struct realm_config {
	union {
		unsigned long ipa_bits; /* Width of IPA in bits */
		u8 __pad[4096];
	};
} __aligned(4096);

and maybe with a comment on why the alignment and padding. You could
also have an unnamed struct around ipa_bits in case you want to add more
fields in the future (siginfo follows this pattern).

> +
> +unsigned long prot_ns_shared;
> +EXPORT_SYMBOL(prot_ns_shared);
> +
>  DEFINE_STATIC_KEY_FALSE_RO(rsi_present);
>  EXPORT_SYMBOL(rsi_present);
>  
> @@ -53,6 +58,9 @@ void __init arm64_rsi_init(void)
>  {
>  	if (!rsi_version_matches())
>  		return;
> +	if (rsi_get_realm_config(&config))
> +		return;
> +	prot_ns_shared = BIT(config.ipa_bits - 1);
>  
>  	static_branch_enable(&rsi_present);
>  }

-- 
Catalin

