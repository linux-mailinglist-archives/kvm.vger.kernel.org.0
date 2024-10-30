Return-Path: <kvm+bounces-29998-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D8299B5D3F
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 08:56:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 913D7B21780
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 07:56:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E7451E0B70;
	Wed, 30 Oct 2024 07:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BUH71srC"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 836AA33E1;
	Wed, 30 Oct 2024 07:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730274960; cv=none; b=jit7hMEE9QsDd0PUQMKt+pkVK0QgfEmbncryQt7tYAIzITywamkB7OFgZZ3jO/ykex9fC9EhXJiH3s8s45vXmhnkRdUestNnAkFsgqPv9CUv3xut51WTA8l754cL5Kko6QoklDVrG0ZPKh3tLlH2k++SUIdxr1pzJ1Cq159x8P0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730274960; c=relaxed/simple;
	bh=gpPN7Q2sLWKjzaffkRwxaK7OnuNJs9eevr8SCuMuL/8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=SDHHPxoeuNqn3mTU/Rb7yUVTyBNWDes6FHBoasKaF1/WNBv/MhO6KiUbxrrEInhPeG5uYI1IhOvbXMNd6T+iSi9tBoVPkmuOduWzpAQy0ReB7Ztoy9kKvH76wRWlKPW5uFMssoz0TSvfx86Ke/6/miv11J5QqnwV1Qc5+WE5S4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BUH71srC; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AA6BC4CEE4;
	Wed, 30 Oct 2024 07:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730274959;
	bh=gpPN7Q2sLWKjzaffkRwxaK7OnuNJs9eevr8SCuMuL/8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=BUH71srCUmo6Yo5Zj5v596dWnv7WddJErBNA1I9FhssSS3QmxttSW4zKqVxPJmmzM
	 FwaX85B7dxMEdrbjste6ixaE+mBcmzK97oIdEFOrElhG6c7/EN9j8Lh+1JQQ8kmQgJ
	 rBc3jNaZyMfZFMxx/G7mTbs0kN+OX+cDz83YUE5FzMWOfzSDlIfGVx3nGq9PDDbgSi
	 zV1/f5lKWlWY9W0oL1Gx9oRnU13wp86sP84dOlyL2AImYWFxN9bfk3ZyITpo7gVvHG
	 V+uoeeNT289LOwVjjzCmOxhocS2ox3c0CjGFJ8/xXTQTa8/FAl5kcMOkqnpbkZLDAF
	 T2qz6FxH2EucA==
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
Subject: Re: [PATCH v5 09/43] arm64: RME: ioctls to create and configure realms
In-Reply-To: <20241004152804.72508-10-steven.price@arm.com>
References: <20241004152804.72508-1-steven.price@arm.com>
 <20241004152804.72508-10-steven.price@arm.com>
Date: Wed, 30 Oct 2024 13:25:49 +0530
Message-ID: <yq5acyjic9dm.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Steven Price <steven.price@arm.com> writes:

> +
> +out_undelegate_tables:
> +	while (--i >= 0) {
> +		phys_addr_t pgd_phys = kvm->arch.mmu.pgd_phys + i * PAGE_SIZE;
> +
> +		WARN_ON(rmi_granule_undelegate(pgd_phys));
> +	}
> +	WARN_ON(rmi_granule_undelegate(rd_phys));
> +free_rd:
> +	free_page((unsigned long)rd);
> +	return r;
> +}
> +

we should avoid that free_page on an undelegate failure? rd_phys we can
handle here. Not sure how to handle the pgd_phys.

-aneesh

