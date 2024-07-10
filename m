Return-Path: <kvm+bounces-21309-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 10ACA92D296
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 15:18:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 93956B24E5D
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 13:18:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20307193074;
	Wed, 10 Jul 2024 13:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rxR7FxJ4"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37A4B192B91;
	Wed, 10 Jul 2024 13:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720617480; cv=none; b=Y1+FVUBAikBOvKtL5GP6V+sQ9xmGtf1JbNk9pcllf7uihHFRBpcPm5S+56jO2GgPajOhPuMWIAjILQkLcdza3pf6mv1T1WZ6KOQZlbOrpj9k+QelJeOuYkMDsCTC/8Z+TkT7iVZx7m/UmfeLq0Qw1+ZKo6hn+RFkNHWoXOVEgX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720617480; c=relaxed/simple;
	bh=FmLG9ussU5FRxdr7oifUla5ahQxpdvQPzA+Zr6jz3LQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=id1j8TScQJHMWwxvbpHl4BF21ICoyQc2Bytr09ADuvgqYArJ4VilQk1roIh7bHcEm7KO894M2Al436bP3cW+OQFJD33sr7tqx9LOuVU85b1Q3Pkr7e3czqOTB4FlTnf5UlWlA9m9lxoYjlsoXPkU87WJlTHJRbiWGNwrNe6aYyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rxR7FxJ4; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC2C5C32782;
	Wed, 10 Jul 2024 13:17:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720617479;
	bh=FmLG9ussU5FRxdr7oifUla5ahQxpdvQPzA+Zr6jz3LQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rxR7FxJ4+AfkpLq1LVVuoYWlhWG4o7wcc2UQJnuNUo5vwhv0h/K3Jn6F2Fy7eYxS2
	 vXxSDi+qYjizmB1AXmGqNnuzjoAEmuOaGmagE1d6vcEjlEamQVCKTsPHjJaO6y3zyd
	 DMNSXyAUaYnfYIvoCMS1YJ3MGjYA2GtT3c4DZr+CeW7haLWFQe3y5XfKPyFmOXD3zT
	 gOSs38ytTD+K5hODyj2QOwREYLZWHmGL0lGs7YHEB/nyGKhZY5sknBVu4nag/wGnSb
	 TKJ2WGrFoakqcVV+5mmSCVO92d3Kv6tf5Cd6UQTV/wLqGdiEd72sr5dxnMNXeAi8W8
	 G5VMdvNM1QnZA==
Date: Wed, 10 Jul 2024 14:17:53 +0100
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
Subject: Re: [PATCH v4 13/15] irqchip/gic-v3-its: Rely on genpool alignment
Message-ID: <20240710131753.GB14582@willie-the-truck>
References: <20240701095505.165383-1-steven.price@arm.com>
 <20240701095505.165383-14-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240701095505.165383-14-steven.price@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Mon, Jul 01, 2024 at 10:55:03AM +0100, Steven Price wrote:
> its_create_device() over-allocated by ITS_ITT_ALIGN - 1 bytes to ensure
> that an aligned area was available within the allocation. The new
> genpool allocator has its min_alloc_order set to
> get_order(ITS_ITT_ALIGN) so all allocations from it should be
> appropriately aligned.
> 
> Remove the over-allocation from its_create_device() and alignment from
> its_build_mapd_cmd().
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
>  drivers/irqchip/irq-gic-v3-its.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
> index 7d12556bc498..ab697e4004b9 100644
> --- a/drivers/irqchip/irq-gic-v3-its.c
> +++ b/drivers/irqchip/irq-gic-v3-its.c
> @@ -699,7 +699,6 @@ static struct its_collection *its_build_mapd_cmd(struct its_node *its,
>  	u8 size = ilog2(desc->its_mapd_cmd.dev->nr_ites);
>  
>  	itt_addr = virt_to_phys(desc->its_mapd_cmd.dev->itt);
> -	itt_addr = ALIGN(itt_addr, ITS_ITT_ALIGN);
>  
>  	its_encode_cmd(cmd, GITS_CMD_MAPD);
>  	its_encode_devid(cmd, desc->its_mapd_cmd.dev->device_id);
> @@ -3520,7 +3519,7 @@ static struct its_device *its_create_device(struct its_node *its, u32 dev_id,
>  	 */
>  	nr_ites = max(2, nvecs);
>  	sz = nr_ites * (FIELD_GET(GITS_TYPER_ITT_ENTRY_SIZE, its->typer) + 1);
> -	sz = max(sz, ITS_ITT_ALIGN) + ITS_ITT_ALIGN - 1;
> +	sz = max(sz, ITS_ITT_ALIGN);
>  
>  	itt = itt_alloc_pool(its->numa_node, sz);

Tested-by: Will Deacon <will@kernel.org>

Will

