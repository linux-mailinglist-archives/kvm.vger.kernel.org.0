Return-Path: <kvm+bounces-25038-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 33AC495EDFD
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 12:03:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E3A01283777
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 10:03:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 747EB146A73;
	Mon, 26 Aug 2024 10:03:16 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E415E804;
	Mon, 26 Aug 2024 10:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724666596; cv=none; b=Nvlyn+0hC2w1MPoTZ5qXf5cFe0yvErqSsJBP4lJmWxDMx/FAG7rj5P6p3LZEgPA3x4Kjj3ffjoUYbG0H+799n/MpMFb8Sa/pdSKKt+1p5VHcuThpeulXdDFyxlPsv5BS8uNUO+hUNNe42MYRONtfB7hp8Fs8tBnnP5Y5hnN+ys4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724666596; c=relaxed/simple;
	bh=kYffuWLIPP8kK+2UdQqvt2hDHMmOIxHdbuL0p71T9/k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PY2IYCiaxzrQZD2v8ITPml51H3Lwstyqnj1ksBQnhuxKfRnSxVh7sgJEhXW08WRZmsdN7JWtD3nZQGDSpDIXeCLwlx4RGMcVpc+jHLN573V0sxYRGkX37h454g2F2KHmiij1hqdtDmLi4ND++nX++D8AIAM3vrzAFUJEOkLxxJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10508C51407;
	Mon, 26 Aug 2024 10:03:10 +0000 (UTC)
Date: Mon, 26 Aug 2024 13:03:19 +0300
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
	Alper Gun <alpergun@google.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: Re: [PATCH v5 04/19] firmware/psci: Add psci_early_test_conduit()
Message-ID: <ZsxS52IBVVLKrTEX@arm.com>
References: <20240819131924.372366-1-steven.price@arm.com>
 <20240819131924.372366-5-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240819131924.372366-5-steven.price@arm.com>

On Mon, Aug 19, 2024 at 02:19:09PM +0100, Steven Price wrote:
> From: Jean-Philippe Brucker <jean-philippe@linaro.org>
> 
> Add a function to test early if PSCI is present and what conduit it
> uses. Because the PSCI conduit corresponds to the SMCCC one, this will
> let the kernel know whether it can use SMC instructions to discuss with
> the Realm Management Monitor (RMM), early enough to enable RAM and
> serial access when running in a Realm.
> 
> Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
> Signed-off-by: Steven Price <steven.price@arm.com>

On the code itself:

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>

However, Will has a point and it would be good if we can avoid this
early setup as much as possible. If it's just the early console used for
debugging, maybe just pass the full IPA address on the command line and
allow those high addresses in fixmap. Not sure about the EFI map.

-- 
Catalin

