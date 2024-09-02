Return-Path: <kvm+bounces-25647-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E507F967E50
	for <lists+kvm@lfdr.de>; Mon,  2 Sep 2024 05:54:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A1262281E40
	for <lists+kvm@lfdr.de>; Mon,  2 Sep 2024 03:54:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A02E014A611;
	Mon,  2 Sep 2024 03:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LJql3XKZ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1E6E13AD05;
	Mon,  2 Sep 2024 03:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725249240; cv=none; b=EY8yVhFGKMJy+su4IgR3V+4qbUBB3KN+4EaAksCc7ddg70kpHn9okJ6IRN3GxXEB5KQGRK5AKTo/w2PIPNTxc/nLRAIYLrfVMm4vwH4RRnHa3nh4/TkwZ8Uon+v7ekm84xnzoi+VcCkV9XMdEdgW21ybT0yagUlGIs1Gojcwi3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725249240; c=relaxed/simple;
	bh=Z2ELWNCkGX3hzs4HPgsi9vE8uXzdpWzO9MtIN3QEEds=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=FsUaEpQklln6snnns/fjWfrgK2HEbLQqhZrkLQphx1L8wdjVs/TrxCBFnf0mjek2caWWB4G7svKnixXJyHGEqbv1ZHQD2pyRXfFD5MgkEcBdqgWd7GH13FhQs0YQkqbzut4DeuDyqs7k97N8JDdlT31Rx4YMHRf++RUw4CU1V1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LJql3XKZ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6C30C4CEC2;
	Mon,  2 Sep 2024 03:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725249240;
	bh=Z2ELWNCkGX3hzs4HPgsi9vE8uXzdpWzO9MtIN3QEEds=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=LJql3XKZ8ETVLWL6Og53CNSY7XP3ko+0vDScfLV4pxcKvDx6HEh6ulc7kBBORiw/l
	 1LVKME+UWXr0K+t4JWQDnH6ywqUS7mwUvxhRyrVaoo7L8p22hs3rU1venIg3ERmnFF
	 yEKEl3Jx/J7QcyG3jO1t3ZfQGFgCSg4BjfP8l53zvcUM4K9P659dZuI/xt3RHBHJUL
	 6TYNhIQS68nsQcSg4X0mH/flEPTR30b5OqI0gJohLXzOJWYm/BEj6BORSUBS3goSL9
	 jKsXl4NChIiCSKTicSdgQHFgmRONiMrc85TDuZ8EKHjcS4b+TqLRzhtop3vG9S0V6B
	 xD0RPZZqy1Zqw==
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
	Alper Gun <alpergun@google.com>,
	Sami Mujawar <sami.mujawar@arm.com>
Subject: Re: [PATCH v5 19/19] virt: arm-cca-guest: TSM_REPORT support for
 realms
In-Reply-To: <20240819131924.372366-20-steven.price@arm.com>
References: <20240819131924.372366-1-steven.price@arm.com>
 <20240819131924.372366-20-steven.price@arm.com>
Date: Mon, 02 Sep 2024 09:23:51 +0530
Message-ID: <yq5aikveemnk.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Steven Price <steven.price@arm.com> writes:

> From: Sami Mujawar <sami.mujawar@arm.com>
 
...
 
> --- /dev/null
> +++ b/drivers/virt/coco/arm-cca-guest/Kconfig
> @@ -0,0 +1,11 @@
> +config ARM_CCA_GUEST
> +	tristate "Arm CCA Guest driver"
> +	depends on ARM64
> +	default m
> +	select TSM_REPORTS
> +	help
> +	  The driver provides userspace interface to request and
> +	  attestation report from the Realm Management Monitor(RMM).
> +
> +	  If you choose 'M' here, this module will be called
> +	  arm-cca-guest.
>

Can we rename the generic Kconfig variable to ARM_CCA_TSM_REPORT?. Also
should the directory be arm64-cca-guest?


-aneesh

