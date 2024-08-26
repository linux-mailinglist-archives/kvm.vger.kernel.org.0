Return-Path: <kvm+bounces-25039-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D49395EDFF
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 12:04:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 09DEE2840FE
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 10:04:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5422146A79;
	Mon, 26 Aug 2024 10:03:53 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F29212DD90;
	Mon, 26 Aug 2024 10:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724666633; cv=none; b=sFs5CGwj+OQ2N3i2iwUo7ayrAsx/mGmVzgU2SnWAoNazxJRfve6XZ3ONh5zUEREHs6UemFhgOLeaMi4e+If3ZzP4mZ1X3SbbrQapPzLI/z8CQIpKNao1inTIBEcPWy8FybV3YiAoBiwsW6mE9vE2zn2t+/WkpMkzzygCcg+N3I0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724666633; c=relaxed/simple;
	bh=nfmu2IDQp/oygzQfeWafg26o4kdExldk9HNuCol3yeE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cFehPPuU2CVdQ1CVxDhb5Mk2KJ0VRywRJeobvZAcsaoYoHIQWsYhr6OEzMb+D4iW36/Km0lWEEXeeWMifKICfr8DdzH3ls00SjJvd6ElRnQrWi7e/lhJgHaKuKHmZwJqg6sK2/BDhMX0K1Tmy/KxugxD9Nc4joad1L1iE8YSFZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67943C51407;
	Mon, 26 Aug 2024 10:03:48 +0000 (UTC)
Date: Mon, 26 Aug 2024 13:03:56 +0300
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
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Gavin Shan <gshan@redhat.com>,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Alper Gun <alpergun@google.com>
Subject: Re: [PATCH v5 05/19] arm64: Detect if in a realm and set RIPAS RAM
Message-ID: <ZsxTDBm57ga6MkPu@arm.com>
References: <20240819131924.372366-1-steven.price@arm.com>
 <20240819131924.372366-6-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240819131924.372366-6-steven.price@arm.com>

On Mon, Aug 19, 2024 at 02:19:10PM +0100, Steven Price wrote:
> +static bool rsi_version_matches(void)
> +{
> +	unsigned long ver_lower, ver_higher;
> +	unsigned long ret = rsi_request_version(RSI_ABI_VERSION,
> +						&ver_lower,
> +						&ver_higher);
> +
> +	if (ret == SMCCC_RET_NOT_SUPPORTED)
> +		return false;
> +
> +	if (ret != RSI_SUCCESS) {
> +		pr_err("RME: RMM doesn't support RSI version %lu.%lu. Supported range: %lu.%lu-%lu.%lu\n",
> +		       RSI_ABI_VERSION_MAJOR, RSI_ABI_VERSION_MINOR,
> +		       RSI_ABI_VERSION_GET_MAJOR(ver_lower),
> +		       RSI_ABI_VERSION_GET_MINOR(ver_lower),
> +		       RSI_ABI_VERSION_GET_MAJOR(ver_higher),
> +		       RSI_ABI_VERSION_GET_MINOR(ver_higher));
> +		return false;
> +	}
> +
> +	pr_info("RME: Using RSI version %lu.%lu\n",
> +		RSI_ABI_VERSION_GET_MAJOR(ver_lower),
> +		RSI_ABI_VERSION_GET_MINOR(ver_lower));
> +
> +	return true;
> +}

I don't have the spec at hand now (on a plane) but given the possibility
of a 1.0 guest regressing on later RMM versions, I wonder whether we
should simply bail out if it's not an exact version match. I forgot what
the spec says about returned ranges (they were pretty confusing last
time I checked).

> +
> +void __init arm64_rsi_setup_memory(void)
> +{
> +	u64 i;
> +	phys_addr_t start, end;
> +
> +	if (!is_realm_world())
> +		return;
> +
> +	/*
> +	 * Iterate over the available memory ranges and convert the state to
> +	 * protected memory. We should take extra care to ensure that we DO NOT
> +	 * permit any "DESTROYED" pages to be converted to "RAM".
> +	 *
> +	 * BUG_ON is used because if the attempt to switch the memory to
> +	 * protected has failed here, then future accesses to the memory are
> +	 * simply going to be reflected as a SEA (Synchronous External Abort)
> +	 * which we can't handle.  Bailing out early prevents the guest limping
> +	 * on and dying later.
> +	 */
> +	for_each_mem_range(i, &start, &end) {
> +		BUG_ON(rsi_set_memory_range_protected_safe(start, end));
> +	}

Would it help debugging if we print the memory ranges as well rather
than just a BUG_ON()?

-- 
Catalin

