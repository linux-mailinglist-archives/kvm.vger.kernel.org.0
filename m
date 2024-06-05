Return-Path: <kvm+bounces-18997-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B21778FE02D
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 09:52:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2FCE028573C
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 07:51:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3125A13A868;
	Thu,  6 Jun 2024 07:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="MQz3vXwu"
X-Original-To: kvm@vger.kernel.org
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 165C5DF44
	for <kvm@vger.kernel.org>; Thu,  6 Jun 2024 07:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717660313; cv=none; b=Edkb/UEpYdEv9fW1T9K4OMJ6jxgVLCqb1SF0oCyPWgaPRQlu8BCNg6bgEa6ORMWU9uV4K3rJDWl6OrouPPq5urVO3GPZSc53NUtADmJnJP0lVY2S5/XVi/wUaDMvJOZslFudRGjyDA9aJDijbqa+1D2onJqRyRUY5GUWp+A90wc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717660313; c=relaxed/simple;
	bh=IXeA9mTQqzTGvO6nth/z/YosWguaFfgkzGa6IgGTyc0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nOwEk4WzSdkGlYn6ASq2X4CqkbVEsV3yd3HaJ4invtKl3DzgwG2sgnW95AH1ZY1DnU2oqXxn/miQVF0IxEHC7cKLc5uNHbfnHkBHJOYAkBHffkJqz+aC6Jc8SyGdLq6i+uqHGulm7F6n2mLKaXmwIf01pa3hPX98Uz96XNHxnDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=MQz3vXwu; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: steven.price@arm.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1717660309;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=q5MnzBhRt83czhiBsE56x5oa3t51F17Nq3iiqEm8Rvg=;
	b=MQz3vXwumQqGMpoSiyk9KIE0swZUOSOwPweqIPE+i45+fk8VSssenimI/5Oboe3OeCbSY5
	bKZXZztWGztje50/YljxQFxMDicHVkt1C8OPngsmdQeHFVKq+aj7fssJq0/18PIf7V1F1M
	BIhoU7WFyvjwD86NX2KEPkON6XQmz5M=
X-Envelope-To: kvm@vger.kernel.org
X-Envelope-To: kvmarm@lists.linux.dev
X-Envelope-To: catalin.marinas@arm.com
X-Envelope-To: maz@kernel.org
X-Envelope-To: will@kernel.org
X-Envelope-To: james.morse@arm.com
X-Envelope-To: oliver.upton@linux.dev
X-Envelope-To: suzuki.poulose@arm.com
X-Envelope-To: yuzenghui@huawei.com
X-Envelope-To: linux-arm-kernel@lists.infradead.org
X-Envelope-To: linux-kernel@vger.kernel.org
X-Envelope-To: joey.gouly@arm.com
X-Envelope-To: alexandru.elisei@arm.com
X-Envelope-To: christoffer.dall@arm.com
X-Envelope-To: tabba@google.com
X-Envelope-To: linux-coco@lists.linux.dev
X-Envelope-To: gankulkarni@os.amperecomputing.com
Date: Wed, 5 Jun 2024 17:37:47 +0900
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Itaru Kitayama <itaru.kitayama@linux.dev>
To: Steven Price <steven.price@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
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
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Subject: Re: [PATCH v3 00/14] arm64: Support for running as a guest in Arm CCA
Message-ID: <ZmAj26Q2aHj-U9hw@vm3>
References: <20240605093006.145492-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240605093006.145492-1-steven.price@arm.com>
X-Migadu-Flow: FLOW_OUT

Hi Steven,
On Wed, Jun 05, 2024 at 10:29:52AM +0100, Steven Price wrote:
> This series adds support for running Linux in a protected VM under the
> Arm Confidential Compute Architecture (CCA). This has been updated
> following the feedback from the v2 posting[1]. Thanks for the feedback!
> Individual patches have a change log for v3.
> 
> The biggest change from v2 is fixing set_memory_{en,de}crypted() to
> perform a break-before-make sequence. Note that only the virtual address
> supplied is flipped between shared and protected, so if e.g. a vmalloc()
> address is passed the linear map will still point to the (now invalid)
> previous IPA. Attempts to access the wrong address may trigger a
> Synchronous External Abort. However any code which attempts to access
> the 'encrypted' alias after set_memory_decrypted() is already likely to
> be broken on platforms that implement memory encryption, so I don't
> expect problems.
> 
> The ABI to the RMM from a realm (the RSI) is based on the final RMM v1.0
> (EAC 5) specification[2]. Future RMM specifications will be backwards
> compatible so a guest using the v1.0 specification (i.e. this series)
> will be able to run on future versions of the RMM without modification.
> 
> Arm plans to set up a CI system to perform at a minimum boot testing of
> Linux as a guest within a realm.
> 
> This series is based on v6.10-rc1. It is also available as a git
> repository:
> 
> https://gitlab.arm.com/linux-arm/linux-cca cca-guest/v3
> 
> This series (the guest side) should be in a good state so please review
> with the intention that this could be merged soon. The host side (KVM
> changes) is likely to require some more iteration and I'll post that as
> a separate series shortly - note that there is no tie between the series
> (i.e. you can mix and match v2 and v3 postings of the host and guest).
> 
> Introduction (unchanged from v2 posting)
> ============
> A more general introduction to Arm CCA is available on the Arm
> website[3], and links to the other components involved are available in
> the overall cover letter.
> 
> Arm Confidential Compute Architecture adds two new 'worlds' to the
> architecture: Root and Realm. A new software component known as the RMM
> (Realm Management Monitor) runs in Realm EL2 and is trusted by both the
> Normal World and VMs running within Realms. This enables mutual
> distrust between the Realm VMs and the Normal World.
> 
> Virtual machines running within a Realm can decide on a (4k)
> page-by-page granularity whether to share a page with the (Normal World)
> host or to keep it private (protected). This protection is provided by
> the hardware and attempts to access a page which isn't shared by the
> Normal World will trigger a Granule Protection Fault.
> 
> Realm VMs can communicate with the RMM via another SMC interface known
> as RSI (Realm Services Interface). This series adds wrappers for the
> full set of RSI commands and uses them to manage the Realm IPA State
> (RIPAS) and to discover the configuration of the realm.
> 
> The VM running within the Realm needs to ensure that memory that is
> going to use is marked as 'RIPAS_RAM' (i.e. protected memory accessible
> only to the guest). This could be provided by the VMM (and subject to
> measurement to ensure it is setup correctly) or the VM can set it
> itself.  This series includes a patch which will iterate over all
> described RAM and set the RIPAS. This is a relatively cheap operation,
> and doesn't require memory donation from the host. Instead, memory can
> be dynamically provided by the host on fault. An alternative would be to
> update booting.rst and state this as a requirement, but this would
> reduce the flexibility of the VMM to manage the available memory to the
> guest (as the initial RIPAS state is part of the guest's measurement).
> 
> Within the Realm the most-significant active bit of the IPA is used to
> select whether the access is to protected memory or to memory shared
> with the host. This series treats this bit as if it is attribute bit in
> the page tables and will modify it when sharing/unsharing memory with
> the host.
> 
> This top bit usage also necessitates that the IPA width is made more
> dynamic in the guest. The VMM will choose a width (and therefore which
> bit controls the shared flag) and the guest must be able to identify
> this bit to mask it out when necessary. PHYS_MASK_SHIFT/PHYS_MASK are
> therefore made dynamic.
> 
> To allow virtio to communicate with the host the shared buffers must be
> placed in memory which has this top IPA bit set. This is achieved by
> implementing the set_memory_{encrypted,decrypted} APIs for arm64 and
> forcing the use of bounce buffers. For now all device access is
> considered to required the memory to be shared, at this stage there is
> no support for real devices to be assigned to a realm guest - obviously
> if device assignment is added this will have to change.
> 
> Finally the GIC is (largely) emulated by the (untrusted) host. The RMM
> provides some management (including register save/restore) but the
> ITS buffers must be placed into shared memory for the host to emulate.
> There is likely to be future work to harden the GIC driver against a
> malicious host (along with any other drivers used within a Realm guest).
> 
> [1] https://lore.kernel.org/r/20240412084213.1733764-1-steven.price%40arm.com
> [2] https://developer.arm.com/documentation/den0137/1-0eac5/
> [3] https://www.arm.com/architecture/security-features/arm-confidential-compute-architecture
> 

The v3 guest built with clang booted fine on FVP backed by v2 host kernel.

Tested-by: Itaru Kitayama <itaru.kitayama@fujitsu.com>

Thanks,
Itaru.

> Sami Mujawar (2):
>   arm64: rsi: Interfaces to query attestation token
>   virt: arm-cca-guest: TSM_REPORT support for realms
> 
> Steven Price (5):
>   arm64: realm: Query IPA size from the RMM
>   arm64: Mark all I/O as non-secure shared
>   arm64: Make the PHYS_MASK_SHIFT dynamic
>   arm64: Enforce bounce buffers for realm DMA
>   arm64: realm: Support nonsecure ITS emulation shared
> 
> Suzuki K Poulose (7):
>   arm64: rsi: Add RSI definitions
>   arm64: Detect if in a realm and set RIPAS RAM
>   fixmap: Allow architecture overriding set_fixmap_io
>   arm64: Override set_fixmap_io
>   arm64: Enable memory encrypt for Realms
>   arm64: Force device mappings to be non-secure shared
>   efi: arm64: Map Device with Prot Shared
> 
>  arch/arm64/Kconfig                            |   3 +
>  arch/arm64/include/asm/fixmap.h               |   4 +-
>  arch/arm64/include/asm/io.h                   |   6 +-
>  arch/arm64/include/asm/mem_encrypt.h          |  17 ++
>  arch/arm64/include/asm/pgtable-hwdef.h        |   6 -
>  arch/arm64/include/asm/pgtable-prot.h         |   3 +
>  arch/arm64/include/asm/pgtable.h              |   7 +-
>  arch/arm64/include/asm/rsi.h                  |  48 ++++
>  arch/arm64/include/asm/rsi_cmds.h             | 143 ++++++++++++
>  arch/arm64/include/asm/rsi_smc.h              | 142 ++++++++++++
>  arch/arm64/include/asm/set_memory.h           |   3 +
>  arch/arm64/kernel/Makefile                    |   3 +-
>  arch/arm64/kernel/efi.c                       |   2 +-
>  arch/arm64/kernel/rsi.c                       |  96 ++++++++
>  arch/arm64/kernel/setup.c                     |   8 +
>  arch/arm64/mm/init.c                          |  10 +-
>  arch/arm64/mm/mmu.c                           |  13 ++
>  arch/arm64/mm/pageattr.c                      |  65 +++++-
>  drivers/irqchip/irq-gic-v3-its.c              |  90 ++++++--
>  drivers/virt/coco/Kconfig                     |   2 +
>  drivers/virt/coco/Makefile                    |   1 +
>  drivers/virt/coco/arm-cca-guest/Kconfig       |  11 +
>  drivers/virt/coco/arm-cca-guest/Makefile      |   2 +
>  .../virt/coco/arm-cca-guest/arm-cca-guest.c   | 211 ++++++++++++++++++
>  include/asm-generic/fixmap.h                  |   2 +
>  25 files changed, 858 insertions(+), 40 deletions(-)
>  create mode 100644 arch/arm64/include/asm/mem_encrypt.h
>  create mode 100644 arch/arm64/include/asm/rsi.h
>  create mode 100644 arch/arm64/include/asm/rsi_cmds.h
>  create mode 100644 arch/arm64/include/asm/rsi_smc.h
>  create mode 100644 arch/arm64/kernel/rsi.c
>  create mode 100644 drivers/virt/coco/arm-cca-guest/Kconfig
>  create mode 100644 drivers/virt/coco/arm-cca-guest/Makefile
>  create mode 100644 drivers/virt/coco/arm-cca-guest/arm-cca-guest.c
> 
> -- 
> 2.34.1
> 

