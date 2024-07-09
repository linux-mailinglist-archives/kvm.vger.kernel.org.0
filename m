Return-Path: <kvm+bounces-21169-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E21D92B5F9
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 12:53:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 480ED283708
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 10:53:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 821C51586C8;
	Tue,  9 Jul 2024 10:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kZ3sOT2V"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D80C157A4D;
	Tue,  9 Jul 2024 10:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720522412; cv=none; b=fJ26vVqLT9J0RGMTuaT5fiMSyIOx4SPLhQKF1EVsdX3K6jDPE0RQ/s2Mn7egJ+qbQMcEl9WbkNm1PR55Zhk7aq5DkFaqjzxd7BB7A+BbicS+ZIlGQjo104uGllhsQXg58oBgTbAwlym5HX9h+3oKL22dUkGqCcJPcSgw6Dm1mjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720522412; c=relaxed/simple;
	bh=jB14DSl2Zk4On6QHfLrBh2maI9p5JkZn/BI6ssDCVwo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EIsTeVdBDZozsKsKC1/TNvLl2HW/tEVgkzjLu3X64Ep+sZF5yHt7irVftJZjJF+em8siZPqDR5ItXCY9JlXZKaKiSEjpzIw9resovt4nfxJtdIBtSVsQ+PJ4hVUsoepAk2EFilbnuHpNhdHrKPIVnaCFg33Mlis7C0/+jPPl9ZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kZ3sOT2V; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B2CBC3277B;
	Tue,  9 Jul 2024 10:53:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720522412;
	bh=jB14DSl2Zk4On6QHfLrBh2maI9p5JkZn/BI6ssDCVwo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kZ3sOT2Vc/2HFPrIXm8vo7fe9W5xKNJCoeTHX/jYOlj7cYyMeSbi7YF8PtpyjB2j4
	 uAYPz9m3YOmhojvX8dtTqdMKZAwpQsBlyCwbPHnVy3t63jSc66PoToqUVfCnG872Wk
	 SRY/erI94F/9zj5C7NKHAVLbQkBpPgocQsGnoeZ5iKDpHGq7ITjI389yXrzdbmZY/Q
	 IDIbQMcaNBfe620F7II89RBrLQiSe7QofOe/8uVcZoC1nl4o33dJC+2SrGl8WzvLJu
	 hmQT5CMCwRPBY0OZANnfFzYxcCSu+y9tGlmdVBYpDEIaDDa/k5dodwwdlrn6HkIEn1
	 kT5RBKKFozFlA==
Date: Tue, 9 Jul 2024 11:53:25 +0100
From: Will Deacon <will@kernel.org>
To: Steven Price <steven.price@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Subject: Re: [PATCH v4 04/15] arm64: realm: Query IPA size from the RMM
Message-ID: <20240709105325.GF12978@willie-the-truck>
References: <20240701095505.165383-1-steven.price@arm.com>
 <20240701095505.165383-5-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240701095505.165383-5-steven.price@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Mon, Jul 01, 2024 at 10:54:54AM +0100, Steven Price wrote:
> The top bit of the configured IPA size is used as an attribute to
> control whether the address is protected or shared. Query the
> configuration from the RMM to assertain which bit this is.
> 
> Co-developed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes since v2:
>  * Drop unneeded extra brackets from PROT_NS_SHARED.
>  * Drop the explicit alignment from 'config' as struct realm_config now
>    specifies the alignment.
> ---
>  arch/arm64/include/asm/pgtable-prot.h | 3 +++
>  arch/arm64/kernel/rsi.c               | 8 ++++++++
>  2 files changed, 11 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/pgtable-prot.h b/arch/arm64/include/asm/pgtable-prot.h
> index b11cfb9fdd37..6c29f3b32eba 100644
> --- a/arch/arm64/include/asm/pgtable-prot.h
> +++ b/arch/arm64/include/asm/pgtable-prot.h
> @@ -70,6 +70,9 @@
>  #include <asm/pgtable-types.h>
>  
>  extern bool arm64_use_ng_mappings;
> +extern unsigned long prot_ns_shared;
> +
> +#define PROT_NS_SHARED		(prot_ns_shared)

Since the _vast_ majority of Linux systems won't be running in a realm,
can we use a static key to avoid loading a constant each time?

Will

