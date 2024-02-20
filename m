Return-Path: <kvm+bounces-9182-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3091D85BBD9
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 13:21:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DCE75281916
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 12:21:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCCAF67E8B;
	Tue, 20 Feb 2024 12:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cziAa188"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB8B567E76;
	Tue, 20 Feb 2024 12:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708431675; cv=none; b=bDxon9W+k2YKynO0/mVDlJ84IojYCc0dIvMen9UosUBh5Ppp61LEbhcfFGSisSujnW5DHPRO39XT0Wv+kkf+UYLiubdraRuzMzSR0i+9m8m1LX4XqGbWGOaCnpVQr3h0Nv0HesHSg8YMKUFn0wEz7DksCkHJr6WGxKOk0YwHuXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708431675; c=relaxed/simple;
	bh=jV03GKfaPISem9za3Whs0Xc2NpK5afZ4kewZC3epk98=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QRtLA8tcpfPAsGSKIhLxLKjsFXS1d493O3IA+/j0cbDCkBAAMuOJpXz2QvZDsLizmGO7cbVijuJoR8XQIgl0I/YPBPr6B5jEpbMcuD32TkTr0zV+TXjJhpMfjohmgTAKm+dc4NWD8NoABZWFR1s8Co8Bv4GwIUupE0ytkz5dBPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cziAa188; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C71BBC433F1;
	Tue, 20 Feb 2024 12:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708431674;
	bh=jV03GKfaPISem9za3Whs0Xc2NpK5afZ4kewZC3epk98=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cziAa1884tUKYj/oG8oWpobatz95huFTEsocTtFryUfPMNk0dBnW99+7ceeiv4P81
	 +QfVIcLde0P6FkNqbuBOcErf/6T5q72XSK6OkM7mn8kplaWIaahuAyZLqn4Pi1VoJd
	 u44VIuTCDHNbvLp6vkkYWALYzYxiOJcqqyE0FoMvv8ZFP8A03EprTOhgHVouyNbZij
	 s61RWM4gGhaLBzTkLPAK2YkwOB625VirQDb714AkZHhF854/7dos9AEyO+qPP6PgkZ
	 71emIScEs6bYH9ezmMYm15fYahRwgf3iVV/DfI66Y0bHAPOebWTndru4ZXZZjmfzMG
	 anrc9g+6GnRRQ==
Date: Tue, 20 Feb 2024 12:21:03 +0000
From: Will Deacon <will@kernel.org>
To: ankita@nvidia.com
Cc: jgg@nvidia.com, maz@kernel.org, oliver.upton@linux.dev,
	james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	reinette.chatre@intel.com, surenb@google.com, stefanha@redhat.com,
	brauner@kernel.org, catalin.marinas@arm.com, mark.rutland@arm.com,
	alex.williamson@redhat.com, kevin.tian@intel.com,
	yi.l.liu@intel.com, ardb@kernel.org, akpm@linux-foundation.org,
	andreyknvl@gmail.com, wangjinchao@xfusion.com, gshan@redhat.com,
	shahuang@redhat.com, ricarkol@google.com, linux-mm@kvack.org,
	lpieralisi@kernel.org, rananta@google.com, ryan.roberts@arm.com,
	david@redhat.com, linus.walleij@linaro.org, bhe@redhat.com,
	aniketa@nvidia.com, cjia@nvidia.com, kwankhede@nvidia.com,
	targupta@nvidia.com, vsethi@nvidia.com, acurrid@nvidia.com,
	apopple@nvidia.com, jhubbard@nvidia.com, danw@nvidia.com,
	kvmarm@lists.linux.dev, mochs@nvidia.com, zhiw@nvidia.com,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v8 1/4] kvm: arm64: introduce new flag for non-cacheable
 IO memory
Message-ID: <20240220122103.GB5613@willie-the-truck>
References: <20240220072926.6466-1-ankita@nvidia.com>
 <20240220072926.6466-2-ankita@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240220072926.6466-2-ankita@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Tue, Feb 20, 2024 at 12:59:23PM +0530, ankita@nvidia.com wrote:
> From: Ankit Agrawal <ankita@nvidia.com>
> 
> Currently, KVM for ARM64 maps at stage 2 memory that is considered device
> (i.e. it is not RAM) with DEVICE_nGnRE memory attributes; this setting
> overrides (as per the ARM architecture [1]) any device MMIO mapping
> present at stage 1, resulting in a set-up whereby a guest operating
> system cannot determine device MMIO mapping memory attributes on its
> own but it is always overridden by the KVM stage 2 default.
> 
> This set-up does not allow guest operating systems to select device
> memory attributes independently from KVM stage-2 mappings
> (refer to [1], "Combining stage 1 and stage 2 memory type attributes"),
> which turns out to be an issue in that guest operating systems
> (e.g. Linux) may request to map devices MMIO regions with memory
> attributes that guarantee better performance (e.g. gathering
> attribute - that for some devices can generate larger PCIe memory
> writes TLPs) and specific operations (e.g. unaligned transactions)
> such as the NormalNC memory type.
> 
> The default device stage 2 mapping was chosen in KVM for ARM64 since
> it was considered safer (i.e. it would not allow guests to trigger
> uncontained failures ultimately crashing the machine) but this
> turned out to be asynchronous (SError) defeating the purpose.
> 
> Failures containability is a property of the platform and is independent
> from the memory type used for MMIO device memory mappings.
> 
> Actually, DEVICE_nGnRE memory type is even more problematic than
> Normal-NC memory type in terms of faults containability in that e.g.
> aborts triggered on DEVICE_nGnRE loads cannot be made, architecturally,
> synchronous (i.e. that would imply that the processor should issue at
> most 1 load transaction at a time - it cannot pipeline them - otherwise
> the synchronous abort semantics would break the no-speculation attribute
> attached to DEVICE_XXX memory).
> 
> This means that regardless of the combined stage1+stage2 mappings a
> platform is safe if and only if device transactions cannot trigger
> uncontained failures and that in turn relies on platform capabilities
> and the device type being assigned (i.e. PCIe AER/DPC error containment
> and RAS architecture[3]); therefore the default KVM device stage 2
> memory attributes play no role in making device assignment safer
> for a given platform (if the platform design adheres to design
> guidelines outlined in [3]) and therefore can be relaxed.
> 
> For all these reasons, relax the KVM stage 2 device memory attributes
> from DEVICE_nGnRE to Normal-NC.
> 
> The NormalNC was chosen over a different Normal memory type default
> at stage-2 (e.g. Normal Write-through) to avoid cache allocation/snooping.
> 
> Relaxing S2 KVM device MMIO mappings to Normal-NC is not expected to
> trigger any issue on guest device reclaim use cases either (i.e. device
> MMIO unmap followed by a device reset) at least for PCIe devices, in that
> in PCIe a device reset is architected and carried out through PCI config
> space transactions that are naturally ordered with respect to MMIO
> transactions according to the PCI ordering rules.
> 
> Having Normal-NC S2 default puts guests in control (thanks to
> stage1+stage2 combined memory attributes rules [1]) of device MMIO
> regions memory mappings, according to the rules described in [1]
> and summarized here ([(S1) - stage1], [(S2) - stage 2]):
> 
> S1           |  S2           | Result
> NORMAL-WB    |  NORMAL-NC    | NORMAL-NC
> NORMAL-WT    |  NORMAL-NC    | NORMAL-NC
> NORMAL-NC    |  NORMAL-NC    | NORMAL-NC
> DEVICE<attr> |  NORMAL-NC    | DEVICE<attr>
> 
> It is worth noting that currently, to map devices MMIO space to user
> space in a device pass-through use case the VFIO framework applies memory
> attributes derived from pgprot_noncached() settings applied to VMAs, which
> result in device-nGnRnE memory attributes for the stage-1 VMM mappings.
> 
> This means that a userspace mapping for device MMIO space carried
> out with the current VFIO framework and a guest OS mapping for the same
> MMIO space may result in a mismatched alias as described in [2].
> 
> Defaulting KVM device stage-2 mappings to Normal-NC attributes does not
> change anything in this respect, in that the mismatched aliases would
> only affect (refer to [2] for a detailed explanation) ordering between
> the userspace and GuestOS mappings resulting stream of transactions
> (i.e. it does not cause loss of property for either stream of
> transactions on its own), which is harmless given that the userspace
> and GuestOS access to the device is carried out through independent
> transactions streams.
> 
> A Normal-NC flag is not present today. So add a new kvm_pgtable_prot
> (KVM_PGTABLE_PROT_NORMAL_NC) flag for it, along with its
> corresponding PTE value 0x5 (0b101) determined from [1].
> 
> Lastly, adapt the stage2 PTE property setter function
> (stage2_set_prot_attr) to handle the NormalNC attribute.
> 
> [1] section D8.5.5 - DDI0487J_a_a-profile_architecture_reference_manual.pdf
> [2] section B2.8 - DDI0487J_a_a-profile_architecture_reference_manual.pdf
> [3] sections 1.7.7.3/1.8.5.2/appendix C - DEN0029H_SBSA_7.1.pdf
> 
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Acked-by: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
> ---
>  arch/arm64/include/asm/kvm_pgtable.h |  2 ++
>  arch/arm64/include/asm/memory.h      |  2 ++
>  arch/arm64/kvm/hyp/pgtable.c         | 24 +++++++++++++++++++-----
>  3 files changed, 23 insertions(+), 5 deletions(-)

Acked-by: Will Deacon <will@kernel.org>

Will

