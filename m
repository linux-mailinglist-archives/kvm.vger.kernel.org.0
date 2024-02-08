Return-Path: <kvm+bounces-8343-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 60F0D84E1F7
	for <lists+kvm@lfdr.de>; Thu,  8 Feb 2024 14:27:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 924FF1C21F86
	for <lists+kvm@lfdr.de>; Thu,  8 Feb 2024 13:27:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 642FC76414;
	Thu,  8 Feb 2024 13:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="VBGy007K"
X-Original-To: kvm@vger.kernel.org
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3BE1763E1
	for <kvm@vger.kernel.org>; Thu,  8 Feb 2024 13:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707398820; cv=none; b=nEHjvNvqhUB3ocrHJWJn/kMs2w5pguPnravDfTL+dLs3COiV359FrgzNjxk5rY+WfLzRDzJCZ4UaB79TYmxPyim9N4e5j1AAnGmWtE6+45thyxlOElDMpKYfuEvWdkfOtugBAggu4QoJQUAkTvjOiw7jRTs5xIDlFroeqruSftw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707398820; c=relaxed/simple;
	bh=5fxbUGZah/XsMcnEnBfdysHvy+J7i//kpOs0yPAueaA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GaJITaIG+scqYr5U8DZkhDrGvNTMblccF5WEwklOAcsZwHiP1X9v7fMcRk/wnK20vL/pk3I3j8X7ffF+K7bDhb6ur7SfpuqBAdYcXR/4dRnJwjrP/ihE7Zp46+26aN4zKBlQPOX8Pf88yxhx3hjx5JkOr7bZuFz1x2b0aOIxjhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=VBGy007K; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 8 Feb 2024 13:26:52 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1707398815;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ms5mFNmc1YMSRaq/hZ06PJ/xdlihfdaV0iwPXV9EUh0=;
	b=VBGy007K7zBFgwgCxeFZ4SXk6PdZiZTc0tqb3bI2yQMJ7Z2A+kGk90xpqHkE9gimClA3RS
	X/7EJvUS9J4SRcNS+Bx+l/1gh/zZBcvKHb6xnQ5dItLai7Ke9fS5K/4LrgY6EDqAD5tMVm
	U6G4BKNaFadn1bI1zuZfy9erbnfSf28=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: ankita@nvidia.com
Cc: jgg@nvidia.com, maz@kernel.org, james.morse@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	reinette.chatre@intel.com, surenb@google.com, stefanha@redhat.com,
	brauner@kernel.org, catalin.marinas@arm.com, will@kernel.org,
	mark.rutland@arm.com, alex.williamson@redhat.com,
	kevin.tian@intel.com, yi.l.liu@intel.com, ardb@kernel.org,
	akpm@linux-foundation.org, andreyknvl@gmail.com,
	wangjinchao@xfusion.com, gshan@redhat.com, ricarkol@google.com,
	linux-mm@kvack.org, lpieralisi@kernel.org, rananta@google.com,
	ryan.roberts@arm.com, aniketa@nvidia.com, cjia@nvidia.com,
	kwankhede@nvidia.com, targupta@nvidia.com, vsethi@nvidia.com,
	acurrid@nvidia.com, apopple@nvidia.com, jhubbard@nvidia.com,
	danw@nvidia.com, kvmarm@lists.linux.dev, mochs@nvidia.com,
	zhiw@nvidia.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v6 3/4] kvm: arm64: set io memory s2 pte as normalnc for
 vfio pci device
Message-ID: <ZcTWnDBfAtMriXqp@linux.dev>
References: <20240207204652.22954-1-ankita@nvidia.com>
 <20240207204652.22954-4-ankita@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240207204652.22954-4-ankita@nvidia.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Feb 08, 2024 at 02:16:51AM +0530, ankita@nvidia.com wrote:
> @@ -1557,10 +1559,18 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  	if (exec_fault)
>  		prot |= KVM_PGTABLE_PROT_X;
>  
> -	if (device)
> -		prot |= KVM_PGTABLE_PROT_DEVICE;
> -	else if (cpus_have_final_cap(ARM64_HAS_CACHE_DIC))
> +	if (device) {
> +		/*
> +		 * To provide VM with the ability to get device IO memory
> +		 * with NormalNC property, map device MMIO as NormalNC in S2.
> +		 */

nit: the comment doesn't provide anything of value, the logic is rather
straightforward here.

> +		if (vfio_allow_wc)
> +			prot |= KVM_PGTABLE_PROT_NORMAL_NC;
> +		else
> +			prot |= KVM_PGTABLE_PROT_DEVICE;
> +	} else if (cpus_have_final_cap(ARM64_HAS_CACHE_DIC)) {
>  		prot |= KVM_PGTABLE_PROT_X;
> +	}
>  
>  	/*
>  	 * Under the premise of getting a FSC_PERM fault, we just need to relax
> -- 
> 2.34.1
>

-- 
Thanks,
Oliver

