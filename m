Return-Path: <kvm+bounces-28625-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B0BBD99A4A2
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 15:13:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C29A61C23231
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 13:13:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8AA8218D72;
	Fri, 11 Oct 2024 13:12:33 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DCA720C473;
	Fri, 11 Oct 2024 13:12:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728652353; cv=none; b=NQw+PmZFWPi/eBDygGSPGOasaCrFte8wbVR0hoS6EOmfB9FfaXkJHYdBktlde/FCPhjtNrXrWfv1/ogouvneyKxQHfBnumZl4JoRsnj5yhfuIb2ZhM4pr77Dw5VmPEe8dMTNuf25lE5byxLGgdfAnNjqEc5pBX2kDyuDI6pm9bc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728652353; c=relaxed/simple;
	bh=AmHqZRlKZ/BVZ/RbHk6PXKUpwD5Cqq2FONbMchH6INA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S5Vq2/dbQfDIiy60v/tHqNnki6x9trgGTWfnpZPd78bERJ0vm96L5ZM6O5IbiayiycrvXKBAht+67ohQeLtv0mchbVoLl/Is+d4ihcEFwqWqi+0eLM632nrunUXALrMYixey9ZrDu02V0wIzY5i0krBnL/rhxROUdY64v3DP0oU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81B56C4CEC3;
	Fri, 11 Oct 2024 13:12:29 +0000 (UTC)
Date: Fri, 11 Oct 2024 14:12:27 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Steven Price <steven.price@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
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
	Alper Gun <alpergun@google.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
Subject: Re: [PATCH v6 02/11] arm64: Detect if in a realm and set RIPAS RAM
Message-ID: <ZwkkOxR4vy_uPA70@arm.com>
References: <20241004144307.66199-1-steven.price@arm.com>
 <20241004144307.66199-3-steven.price@arm.com>
 <085896de-9a39-4f90-9a2d-3f8662c2e2a2@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <085896de-9a39-4f90-9a2d-3f8662c2e2a2@arm.com>

On Fri, Oct 04, 2024 at 04:05:17PM +0100, Steven Price wrote:
> I should have reworded this commit message to something like:
> 
> """
> Detect that the VM is a realm guest by the presence of the RSI
> interface. This is done after PSCI has been initialised so that we can
> check the SMCCC conduit before making any RSI calls.
> 
> If in a realm then iterate over all memory ensuring that it is marked as
> RIPAS RAM. The loader is required to do this for us, however if some
> memory is missed this will cause the guest to receive a hard to debug
> external abort at some random point in the future. So for a
> belt-and-braces approach set all memory to RIPAS RAM. Any failure here
> implies that the RAM regions passed to Linux are incorrect so panic()
> promptly to make the situation clear.
> """

With the updated commit description, the patch looks fine to me.

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>

