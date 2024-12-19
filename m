Return-Path: <kvm+bounces-34113-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5EE419F7401
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 06:38:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 891D21697D5
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 05:38:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D42A216E23;
	Thu, 19 Dec 2024 05:37:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ialAkShi"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BF2C1F76D3;
	Thu, 19 Dec 2024 05:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734586668; cv=none; b=H1Na5GxwYUj0Rg5rQDWF0qu9DMbyj606oXwWwP/I0vTDJyNN2mBK96bUNFWtnuT7uKAHuCZCSiNVvSEVewhoJZNjNKBygThglwp/1QGsR1yMThNjbAF/TSXLXSVvrYcH8NyZMym0mLI4AxG9SAw7T+yzSEhO45R1NGsZYCJt3bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734586668; c=relaxed/simple;
	bh=f1ssCOL5WoAFhkE7v38y7Xu2e53FiZUAYFBGnEjCpZ0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=emYalXpsgELIl4JNv00a1vcNfNPowWhRpqrD6e+Od6KO4enRn3V0nRM2loOGirb+mlqizrYfpxoPrOOJkaFnc1J6j5iOfTREQBUGl9Sv9ZRXFl86SIPulmAK+IujiV0zNv4hNUOnYtFeqRJZ96G6ThhREQ+bcnn1blGAmNPkVIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ialAkShi; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 411AFC4CED0;
	Thu, 19 Dec 2024 05:37:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734586668;
	bh=f1ssCOL5WoAFhkE7v38y7Xu2e53FiZUAYFBGnEjCpZ0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=ialAkShidwlJwrlWfPoJnFpY0idSboazhqgfcvsMXJ4WZ10TEkwwaukZOvjp1u9kt
	 u3hH5jq9vP1fMuychVCt6eJSWQR/bvHOH0Sd4QBD83X+3/P3SxKTevMjhHIlz6iKy2
	 uo5tjyk50uEf0LbeIylxsmL6KBvKi1gTzZxli23s90z1ilTnwa9+2ovQ3Nxof7121B
	 kSqD9OY+pdi/8dwkUkPnn0h5b7tbyYlI2hycHVqAKgqCESNVjDoR/5tdCBdqjj2aLb
	 K7jF0+7AETgI2iKjB50StOBX6IbCSwNVx7ItYL7i9U4wbTIdZi9Ev+7zINcUdVkNn8
	 naAuwTRmpNLYg==
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
Subject: Re: [PATCH v6 12/43] arm64: RME: Allocate/free RECs to match vCPUs
In-Reply-To: <20241212155610.76522-13-steven.price@arm.com>
References: <20241212155610.76522-1-steven.price@arm.com>
 <20241212155610.76522-13-steven.price@arm.com>
Date: Thu, 19 Dec 2024 11:07:22 +0530
Message-ID: <yq5apllos06l.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Steven Price <steven.price@arm.com> writes:

> +static int alloc_rec_aux(struct page **aux_pages,
> +			 u64 *aux_phys_pages,
> +			 unsigned int num_aux)
> +{
> +	int ret;
> +	unsigned int i;
> +
> +	for (i = 0; i < num_aux; i++) {
> +		struct page *aux_page;
> +		phys_addr_t aux_page_phys;
> +
> +		aux_page = alloc_page(GFP_KERNEL);
> +		if (!aux_page) {
> +			ret = -ENOMEM;
> +			goto out_err;
> +		}
> +		aux_page_phys = page_to_phys(aux_page);
> +		if (rmi_granule_delegate(aux_page_phys)) {
> +			__free_page(aux_page);
> +			ret = -ENXIO;
> +			goto out_err;
> +		}
> +		aux_pages[i] = aux_page;
> +		aux_phys_pages[i] = aux_page_phys;
> +	}
> +
> +	return 0;
> +out_err:
> +	free_rec_aux(aux_pages, i);
> +	return ret;
> +}
>

We can possibly switch the above to the alloc/free helper so that all
granule allocation is done by alloc_delegated_granule() ?

static int alloc_rec_aux(struct realm *realm, u64 *aux_phys_pages, unsigned int num_aux)
{
	int ret;
	unsigned int i;

	for (i = 0; i < num_aux; i++) {
		phys_addr_t aux_page_phys;

		aux_page_phys = alloc_delegated_granule(realm, NULL, GFP_KERNEL);
		if (aux_page_phys == PHYS_ADDR_MAX) {
			ret = -ENOMEM;
			goto out_err;
		}
		aux_phys_pages[i] = aux_page_phys;
	}

	return 0;
out_err:
	free_rec_aux(realm, aux_phys_pages, i);
	return ret;
}





