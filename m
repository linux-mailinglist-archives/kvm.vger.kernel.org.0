Return-Path: <kvm+bounces-24904-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BF17995CDCE
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 15:29:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6ABA3281E69
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 13:29:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1941186E50;
	Fri, 23 Aug 2024 13:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kA2hmdVM"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC6A41865EE;
	Fri, 23 Aug 2024 13:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724419767; cv=none; b=iutWbxEwRbtVpIzUq0n0itIvO7hOUd79UI+XtcA36ozmxrS23iOWgwfN7IA+lZTaIF3PEY7cA+3d3AaHIts0yuqmdjDEUor7J9D8Ky1BL7ieavdkXdcaj/B+EqIfowDAK3xnHnn2V8WBynBT/aXoUy7OgEQUTwA/ow50uNBb4sM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724419767; c=relaxed/simple;
	bh=+svFskNShy8sFNlgF5SEtQoxYaXCquZxrHdULTV+fok=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p4SWHdD2HTzrkZAvOmFoP7I/kiFWST4SsH+buWxtLQ7XOWyCh1poQUdr9aWnCjW6rzurnXJhYjwSOZ6yTEGKF9W9KDVJgjmFFYWkNivkaymah+ROeBdRCV3gEhv5VYoNn7eOiKiKQNRZaprI58OpLHX39P5i1kYgBapCARMMgvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kA2hmdVM; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B61F5C32786;
	Fri, 23 Aug 2024 13:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724419766;
	bh=+svFskNShy8sFNlgF5SEtQoxYaXCquZxrHdULTV+fok=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kA2hmdVMxSzV++kcXzN5YAi4vhW52MP9h1Irc+MVotOBEDpZnz6kAn04R8y+fa2EF
	 R48RlaAC5cpGoHQt/DoFm5WqecBHpzWt/HbecCgUTteh4E59IRzzoKAPo6pR9A9XtP
	 qYpnuYXYh17u7bcp2kfKxRRPavwiaGOYBc2bROrAvckD5Kos+nD8aUX0cTn89sasI3
	 ELnJRe8S52ONTGIovzE5KISphun/cFd4oPdgKqgu/hnFIXm23Yr2Z0o6a7STGjVFNQ
	 y7wx5hOeJB1Jl2hW6eze3Qky+3x4Y0IoCnQtLeqzoKmY7yQqd2cAaFHNWq5wk2RVTI
	 4noYVh1UmE6Og==
Date: Fri, 23 Aug 2024 14:29:19 +0100
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
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Gavin Shan <gshan@redhat.com>,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Alper Gun <alpergun@google.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: Re: [PATCH v5 04/19] firmware/psci: Add psci_early_test_conduit()
Message-ID: <20240823132918.GD32156@willie-the-truck>
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
User-Agent: Mutt/1.10.1 (2018-07-13)

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
> ---
> v4: New patch
> ---
>  drivers/firmware/psci/psci.c | 25 +++++++++++++++++++++++++
>  include/linux/psci.h         |  5 +++++
>  2 files changed, 30 insertions(+)
> 
> diff --git a/drivers/firmware/psci/psci.c b/drivers/firmware/psci/psci.c
> index 2328ca58bba6..2b308f97ef2c 100644
> --- a/drivers/firmware/psci/psci.c
> +++ b/drivers/firmware/psci/psci.c
> @@ -13,6 +13,7 @@
>  #include <linux/errno.h>
>  #include <linux/linkage.h>
>  #include <linux/of.h>
> +#include <linux/of_fdt.h>
>  #include <linux/pm.h>
>  #include <linux/printk.h>
>  #include <linux/psci.h>
> @@ -769,6 +770,30 @@ int __init psci_dt_init(void)
>  	return ret;
>  }
>  
> +/*
> + * Test early if PSCI is supported, and if its conduit matches @conduit
> + */
> +bool __init psci_early_test_conduit(enum arm_smccc_conduit conduit)
> +{
> +	int len;
> +	int psci_node;
> +	const char *method;
> +	unsigned long dt_root;
> +
> +	/* DT hasn't been unflattened yet, we have to work with the flat blob */
> +	dt_root = of_get_flat_dt_root();
> +	psci_node = of_get_flat_dt_subnode_by_name(dt_root, "psci");
> +	if (psci_node <= 0)
> +		return false;
> +
> +	method = of_get_flat_dt_prop(psci_node, "method", &len);
> +	if (!method)
> +		return false;
> +
> +	return  (conduit == SMCCC_CONDUIT_SMC && strncmp(method, "smc", len) == 0) ||
> +		(conduit == SMCCC_CONDUIT_HVC && strncmp(method, "hvc", len) == 0);
> +}

This still looks incomplete to me as per my earlier comments:

https://lore.kernel.org/all/20240709104851.GE12978@willie-the-truck/

For the first implementation, can we punt the RIPAS_RAM to the bootloader
and drop support for earlycon? Even if we manage to shoe-horn enough code
into the early boot path, I think we'll regret it later on because there's
always something that wants to be first and it inevitably ends up being
a nightmare to maintain.

Will

