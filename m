Return-Path: <kvm+bounces-29462-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EF9E19ABE27
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 07:51:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 738EF1F2368E
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 05:51:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6D7C146A68;
	Wed, 23 Oct 2024 05:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mv0UjbKg"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF1547482;
	Wed, 23 Oct 2024 05:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729662665; cv=none; b=guHriZet9IvAsHMIltA8Vjr0RBsW1Gt/0lpM0p6TIlo2s8WwjUd28bwvp/VCqM9Cf1L/MS81NGQxTwVgwMxTS1Hv1RJkPzzl8v6scZ2AmQhmflPKTXdVwp8P8eGfaqSL0bdv+Q83zJaqAcGNtHnkhUFOlydN3/Z62bTrMfqo3YM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729662665; c=relaxed/simple;
	bh=M7aW7sxLx+ChIx2S9zBXQ1rM3KjHSPN+I4dTs+cdgrY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=lEFbaapk7gGGn7hTDJFZuiT5zuNRjz9J9m1ZXd5M9KGdUIIZXE6RdKXWTx3ErwG93T78hlcGJq28YT3sVA/X1LlbAQK2fYDOPM6zjXCmO81qySjcDifEDSnvm1WwtDTm5fzKudqq+eD+bA2qKhdMNgStGQtDJu0kx9+7EJmDR/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mv0UjbKg; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82E46C4CEC6;
	Wed, 23 Oct 2024 05:50:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729662665;
	bh=M7aW7sxLx+ChIx2S9zBXQ1rM3KjHSPN+I4dTs+cdgrY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=mv0UjbKggh21apRWlL3ozSbZ+z2YuV6nmp+1X23/ZCd2g35Ng9hANH6i8w3KCfxB1
	 6WHm+WeOvk8YiWrW7IREbdPz9OMqoEN6Q8LVE8z2IDkN5uM/O7QulH03FH4BK6Ppxl
	 p5Thg249BFlniB+1+sFssrzCBcK3l5MF4Mw0yiaOSi3Yl8jdnBn6LYlHbd7TvDXbeF
	 bSg7C5yql1a7KQi6rUQpsY58MXlO9TOOJlDdbcFoFGiwosWRON6kCl4dBbL/VxgiXP
	 C5/c37/WD+9knK/gcJW0CFJcvznoh6F6wnP3pLbH2dOXMW0x7QKycmGEus8Lz/C/hD
	 6pxJs8GC0lgHg==
X-Mailer: emacs 31.0.50 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: Steven Price <steven.price@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
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
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Gavin Shan <gshan@redhat.com>,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Alper Gun <alpergun@google.com>
Subject: Re: [PATCH v5 21/43] arm64: RME: Runtime faulting of memory
In-Reply-To: <20241004152804.72508-22-steven.price@arm.com>
References: <20241004152804.72508-1-steven.price@arm.com>
 <20241004152804.72508-22-steven.price@arm.com>
Date: Wed, 23 Oct 2024 11:20:54 +0530
Message-ID: <yq5abjzbmkox.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Steven Price <steven.price@arm.com> writes:

.....

> +int realm_map_protected(struct realm *realm,
> +			unsigned long base_ipa,
> +			struct page *dst_page,
> +			unsigned long map_size,
> +			struct kvm_mmu_memory_cache *memcache)
> +{
> +	phys_addr_t dst_phys = page_to_phys(dst_page);
> +	phys_addr_t rd = virt_to_phys(realm->rd);
> +	unsigned long phys = dst_phys;
> +	unsigned long ipa = base_ipa;
> +	unsigned long size;
> +	int map_level;
> +	int ret = 0;
> +
> +	if (WARN_ON(!IS_ALIGNED(ipa, map_size)))
> +		return -EINVAL;
> +
> +	switch (map_size) {
> +	case PAGE_SIZE:
> +		map_level = 3;
> +		break;
> +	case RME_L2_BLOCK_SIZE:
> +		map_level = 2;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	if (map_level < RME_RTT_MAX_LEVEL) {
> +		/*
> +		 * A temporary RTT is needed during the map, precreate it,
> +		 * however if there is an error (e.g. missing parent tables)
> +		 * this will be handled below.
> +		 */
> +		realm_create_rtt_levels(realm, ipa, map_level,
> +					RME_RTT_MAX_LEVEL, memcache);
> +	}
> +
> +	for (size = 0; size < map_size; size += PAGE_SIZE) {
> +		if (rmi_granule_delegate(phys)) {
> +			struct rtt_entry rtt;
> +
> +			/*
> +			 * It's possible we raced with another VCPU on the same
> +			 * fault. If the entry exists and matches then exit
> +			 * early and assume the other VCPU will handle the
> +			 * mapping.
> +			 */
> +			if (rmi_rtt_read_entry(rd, ipa, RME_RTT_MAX_LEVEL, &rtt))
> +				goto err;
> +
> +			/*
> +			 * FIXME: For a block mapping this could race at level
> +			 * 2 or 3... currently we don't support block mappings
> +			 */
> +			if (WARN_ON((rtt.walk_level != RME_RTT_MAX_LEVEL ||
> +				     rtt.state != RMI_ASSIGNED ||
> +				     rtt_get_phys(realm, &rtt) != phys))) {
> +				goto err;
> +			}
> +
> +			return 0;
> +		}
>

Technically we are are not mapping more than PAGE_SIZE here, but then
the code does the loop above and with that loop should that return 0 be
a 'continue'? if we find the granule delegated, then does that ensure
rest of the map_size is also delegated?


-aneesh

