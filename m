Return-Path: <kvm+bounces-25042-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6926B95EE08
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 12:06:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 25544283D35
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 10:06:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1AAE146A97;
	Mon, 26 Aug 2024 10:05:52 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41967142E67;
	Mon, 26 Aug 2024 10:05:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724666752; cv=none; b=opp6sbUuUu7uap2uKZSupjeD06IhySJaF060iBtLFoe2EnjAXm3jcMzVqhMgJ06kPRPj/DYsQqWbrVDeX4VWLhuV4YAYCb4ZjTupcI1iqUKXyTL56VMfxX7i1+pEhqr6oPBPNOn36dgeOpwYFv+zxC8GbH92bFFcUyXxy/Lul/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724666752; c=relaxed/simple;
	bh=3zkM/JN53O8YZgyIzrLXt0aiDFnoumM41eh3ReDcN7U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BkB+qgHLC/m0mvqRgJp8fglJ1en97S/Er0+yELLQ6hLJKtnLQ2kqIi9h8IEZp7uHN8czZ1Ub7vNeDee3MCKx30KUD/KMNS3Vppg/57gHm2ZBgi5KzdxDHkPpFgimq9ci32Ebam1v0fl+GqjOiIUAkQ5S+2mfSTKSFF/4YlA0TLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5BDEC51407;
	Mon, 26 Aug 2024 10:05:47 +0000 (UTC)
Date: Mon, 26 Aug 2024 13:05:56 +0300
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
Subject: Re: [PATCH v5 09/19] fixmap: Pass down the full phys address for
 set_fixmap_io
Message-ID: <ZsxThLaRK3omola1@arm.com>
References: <20240819131924.372366-1-steven.price@arm.com>
 <20240819131924.372366-10-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240819131924.372366-10-steven.price@arm.com>

On Mon, Aug 19, 2024 at 02:19:14PM +0100, Steven Price wrote:
> From: Suzuki K Poulose <suzuki.poulose@arm.com>
> 
> For early I/O mapping using fixmap, we mask the address by PAGE_MASK
> base and then map it to the FIXMAP slot. However, with confidential
> computing, the granularity at which "protections" (encrypted vs
> decrypted) are applied may be finer than the PAGE_SIZE. e.g., for Arm
> CCA it is 4K while an arm64 kernel could be using 64K pagesize. However
> we need to know the exact address being mapped in.
> 
> Thus in-order to calculate the accurate protection, pass down the exact
> phys address to the helpers. This would be later used by arm64 to detect
> if the MMIO address is shared vs protected. The users of such drivers
> already cope with running the same code with "4K" page size, thus
> mapping a PAGE_SIZE covering the address range is considered acceptable.
> 
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Steven Price <steven.price@arm.com>

Will was keen (and I'd prefer it as well) to get rid of the early fixmap
code, at least for the time being. Have you tried without these and the
early RSI probing?

Apart from the earlycon I recall you mentioned EFI early maps. These
would be more problematic.

-- 
Catalin

