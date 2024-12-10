Return-Path: <kvm+bounces-33422-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9209C9EB2E4
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 15:14:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A29301886E8B
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 14:13:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21E3B1AAE30;
	Tue, 10 Dec 2024 14:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ScFZexYJ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4172923DE87;
	Tue, 10 Dec 2024 14:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733840025; cv=none; b=qhrKaJ0gCFeH44cfltnPZcb2+Q6vBCG+cwFeUuMGCQRL5Ka7IJmLDF5Urz1gsL4HbAxq+vZDxC+vDIwoEvJwr0HuP9AXrcTy1T02ZZMr9Xpl8t/J7S0zJCpsZlNCwrjzAelOS8dnddRmiUZXjRQ9aF/WhYCJ2Sm0yuhajfUPXGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733840025; c=relaxed/simple;
	bh=p1a7HwVIsBUxDg8oRarlZACVtkKI+wv6CArQotlXVmo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OB22NABlcVl4RDRM++EwsUfSaqEuCs4KDz/uST85OCIMJojKOhcUNVVzlIwMPrr7rnnNfEJ1r6mLy04ZEPHK3rUvjkFtcVqXQAvisZJajNFwH0d+aaBrtG4URqhAVD1B+t/+EO9Uo4PhYXC3Q4N0j3GWvRIcSFuzwUtlOQBeTSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ScFZexYJ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F2D2C4CED6;
	Tue, 10 Dec 2024 14:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733840024;
	bh=p1a7HwVIsBUxDg8oRarlZACVtkKI+wv6CArQotlXVmo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ScFZexYJCgt6WvxjNXGB3iIshv5MbK12VwWs0RNL583DU7niUDPigVOfY7yoa3/j7
	 jGKzBvbGaWkSU7EFm2X0qPfbstIi4iKBDga7bJC0k9DWU3BazppUxr0LWaPMk+xnV+
	 rlYMQcmCO5VeCUkgLgxianbVXCIVXl65tIL1OWREDwLJpFaM5Stz0HxofjGwGB5X+o
	 yT3RQcemmJywxVjQ8F3OLIiwuAl2qtVRprlycljaqADLvtxXjgH3GeHsbNYgTmVzhb
	 IbJUmrWsLgl+k+bglmuJTHdPdx0mlfARHOzohz16FYOvVOYcmimzSppaIV4dfgGZNK
	 xIaVtrdVHGb7Q==
Date: Tue, 10 Dec 2024 14:13:35 +0000
From: Will Deacon <will@kernel.org>
To: ankita@nvidia.com
Cc: jgg@nvidia.com, maz@kernel.org, oliver.upton@linux.dev,
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, ryan.roberts@arm.com, shahuang@redhat.com,
	lpieralisi@kernel.org, aniketa@nvidia.com, cjia@nvidia.com,
	kwankhede@nvidia.com, targupta@nvidia.com, vsethi@nvidia.com,
	acurrid@nvidia.com, apopple@nvidia.com, jhubbard@nvidia.com,
	danw@nvidia.com, zhiw@nvidia.com, mochs@nvidia.com,
	udhoke@nvidia.com, dnigam@nvidia.com, alex.williamson@redhat.com,
	sebastianene@google.com, coltonlewis@google.com,
	kevin.tian@intel.com, yi.l.liu@intel.com, ardb@kernel.org,
	akpm@linux-foundation.org, gshan@redhat.com, linux-mm@kvack.org,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 1/1] KVM: arm64: Allow cacheable stage 2 mapping using
 VMA flags
Message-ID: <20241210141334.GD15607@willie-the-truck>
References: <20241118131958.4609-1-ankita@nvidia.com>
 <20241118131958.4609-2-ankita@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241118131958.4609-2-ankita@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Mon, Nov 18, 2024 at 01:19:58PM +0000, ankita@nvidia.com wrote:
> From: Ankit Agrawal <ankita@nvidia.com>
> 
> Currently KVM determines if a VMA is pointing at IO memory by checking
> pfn_is_map_memory(). However, the MM already gives us a way to tell what
> kind of memory it is by inspecting the VMA.
> 
> This patch solves the problems where it is possible for the kernel to
> have VMAs pointing at cachable memory without causing
> pfn_is_map_memory() to be true, eg DAX memremap cases and CXL/pre-CXL
> devices. This memory is now properly marked as cachable in KVM.
> 
> The pfn_is_map_memory() is restrictive and allows only for the memory
> that is added to the kernel to be marked as cacheable. In most cases
> the code needs to know if there is a struct page, or if the memory is
> in the kernel map and pfn_valid() is an appropriate API for this.
> Extend the umbrella with pfn_valid() to include memory with no struct
> pages for consideration to be mapped cacheable in stage 2. A !pfn_valid()
> implies that the memory is unsafe to be mapped as cacheable.
> 
> Moreover take account of the mapping type in the VMA to make a decision
> on the mapping. The VMA's pgprot is tested to determine the memory type
> with the following mapping:
>  pgprot_noncached    MT_DEVICE_nGnRnE   device (or Normal_NC)
>  pgprot_writecombine MT_NORMAL_NC       device (or Normal_NC)
>  pgprot_device       MT_DEVICE_nGnRE    device (or Normal_NC)
>  pgprot_tagged       MT_NORMAL_TAGGED   RAM / Normal
>  -                   MT_NORMAL          RAM / Normal
> 
> Also take care of the following two cases that prevents the memory to
> be safely mapped as cacheable:
> 1. The VMA pgprot have VM_IO set alongwith MT_NORMAL or
>    MT_NORMAL_TAGGED. Although unexpected and wrong, presence of such
>    configuration cannot be ruled out.
> 2. Configurations where VM_MTE_ALLOWED is not set and KVM_CAP_ARM_MTE
>    is enabled. Otherwise a malicious guest can enable MTE at stage 1
>    without the hypervisor being able to tell. This could cause external
>    aborts.
> 
> Introduce a new variable noncacheable to represent whether the memory
> should not be mapped as cacheable. The noncacheable as false implies
> the memory is safe to be mapped cacheable. Use this to handle the
> aforementioned potentially unsafe cases for cacheable mapping.
> 
> Note when FWB is not enabled, the kernel expects to trivially do
> cache management by flushing the memory by linearly converting a
> kvm_pte to phys_addr to a KVA, see kvm_flush_dcache_to_poc(). This is
> only possibile for struct page backed memory. Do not allow non-struct
> page memory to be cachable without FWB.
> 
> The device memory such as on the Grace Hopper systems is interchangeable
> with DDR memory and retains its properties. Allow executable faults
> on the memory determined as Normal cacheable.

Sorry, but a change this subtle to the arch code is going to need a _much_
better explanation than the rambling text above.

I also suspect that you're trying to do too many things in one patch.
In particular, the changes to execute permission handling absolutely
need to be discussed as a single patch in the series.

Please can you split this up in to a set of changes with useful commit
messages so that we can review them?

Jason knows how to do this so you could ask him for help if you're stuck.
Otherwise, there are plenty of examples of well-written commit messages
on the mailing list and in the git history.

Thanks,

Will

