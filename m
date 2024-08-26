Return-Path: <kvm+bounces-25045-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 16AB695EE7B
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 12:31:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B4D071F2304F
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 10:31:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A21EB14A4E1;
	Mon, 26 Aug 2024 10:31:28 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F1AD149018;
	Mon, 26 Aug 2024 10:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724668288; cv=none; b=I0OgXlJXl5NIZEeUCLMRBPQ0df4v8gRyu0vJULnaPOFoMfJVatzWJ97hPJTJatKMzOLU1i3xc0xbIcV8Ze57Odp31ts/QAryv0QQY70x9bVc9zp2iTo9jOzvyh8Q/2+0yl+fJwQf23ZseAb4Us1E/Lpwfjx7E1NLL840QUPBvS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724668288; c=relaxed/simple;
	bh=3N0wmJTWWJWzhI/fYCg7j7QgcOE1eOVBAs9mrYXApk4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SobBCNSUCJKVF5kkOW7pH2QgSbEWP8Eq/pozpglmBizaXKU46tR9gpTqkE+Pp+ReZxrYAFH/yjdFPYD8VzGJmJwX0YVH+yx7fJPnssVmJXTUoZv60eG4nxgcSxlky1uivxFQeNk5PJBkIXL2zp29OqdAeLKpqCIT9bvd3K3xZpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51794C51403;
	Mon, 26 Aug 2024 10:31:23 +0000 (UTC)
Date: Mon, 26 Aug 2024 13:31:31 +0300
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
Subject: Re: [PATCH v5 13/19] arm64: Make the PHYS_MASK_SHIFT dynamic
Message-ID: <ZsxZgzXGbwqxrk6g@arm.com>
References: <20240819131924.372366-1-steven.price@arm.com>
 <20240819131924.372366-14-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240819131924.372366-14-steven.price@arm.com>

On Mon, Aug 19, 2024 at 02:19:18PM +0100, Steven Price wrote:
> Make the PHYS_MASK_SHIFT dynamic for Realms. This is only is required
> for masking the PFN from a pte entry.

Unless my grep failed, pte_pfn() hasn't used PHYS_MASK for many years,
since commit 75387b92635e ("arm64: handle 52-bit physical addresses in
page table entries").

Can you check what pte_pfn() returns on a shared page?

Unless we need this macro for other things, I'm more tempted to clear
the bit in __pte_to_phys().

-- 
Catalin

