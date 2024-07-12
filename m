Return-Path: <kvm+bounces-21493-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AE81F92F755
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 10:55:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C3BFA1C21E78
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 08:55:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E359414D6F1;
	Fri, 12 Jul 2024 08:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KY3Tam2V"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D9901487CC
	for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 08:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720774486; cv=none; b=ocRMkpBMgl9iZIX6UUBWa8MPlqLGGElyni6yQSOqlFBJBxW5WfCClXKu3yBMLm0EboRvCF7N4sQCXQ/+5GaueU1tEQflzYCoGrSX3FT+ij92gf0FCdjdDAkyrllx+kbMAtT8qy4UPeITwPCjrqwn68IwACM0fRM2DqlUUH4aloc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720774486; c=relaxed/simple;
	bh=xCYPR3PI6bxPO/fQptRxI7tJvEMtvWLt8trPp7HUf7k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a90hSAsEK2MR/VxGzN9fLalmlqObwQzkW3ZrYYHSQV7xBP7ViwNcxOJrbUTLPkdqwFXiEJhwHOlCLVGDepYuG9EDRwOTD6Vv55MUyUQv8lijJ0s1TjhdDnxmOcsHCFor8lrZ1SB5Fhp+t6LjOh34NIXhSaKeZpNkRC+GJ6TCT0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KY3Tam2V; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720774483;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YGUwzKz1FC7XKNssvzh/Aj+HVOd49bkbQ0nivkkXFmg=;
	b=KY3Tam2VrLSJbdqSma3qGEFROVHCKJkB3Nxztti/Hjv5isxlrD+o4XUYR3RmWSyL5+Hdvn
	QQvQANmWhCPt3RscLp3AClQeAhXCJLLRYJKvxSIZwoTFJV9auMlCoTsecFo1yriVGy5urJ
	nLlvRKPowPmpKPPAae5uCSaTqo1Mfkc=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-382--seDLuzaN_SMIKptcaJxwg-1; Fri, 12 Jul 2024 04:54:41 -0400
X-MC-Unique: -seDLuzaN_SMIKptcaJxwg-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-426724679f0so14459535e9.0
        for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 01:54:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720774480; x=1721379280;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YGUwzKz1FC7XKNssvzh/Aj+HVOd49bkbQ0nivkkXFmg=;
        b=jE81QlW9T9bNQaVoVd3eAZKdxFVrCoimmtBtCO0xL+iWi445mIrSw7VU7nU63N7rVu
         OZWPj1nXf/TZwFCClAMrv9V3OVwSGQAOASqa23v5DF9JI2dLNv/Nwlg9aE5Osm2rUeGg
         ne8C6MiNDfGobUXDAQ0gSQ5EgZ7GfzrkdW+oCwbO6nWJzgTfAeCv5/4POAGSn8Gqsw61
         Mqwx48pLts+S4Dw8V4oVF4nigsxiG+SJaVTsadv1v2/COMU+aw0tRK/aEJmy5SVSdpL3
         i9bDLqp9alYVHCM2w6jxoeGpGFMkhRoSC5brrCjBfU4qmNi+zLKrKjJWO9pUVYp07S/Y
         GWzw==
X-Gm-Message-State: AOJu0YzuUzsHkAns89Niviab3QIC2dGJJ1wrvAADhxJq5Y/wXaGwSUHV
	ESs0jAF8jBZVhrded31um7Fa+okfp+O28j/+kTz9diDyqIl9N31Nrsv0mI8zP6YrjOp2WVmgmhR
	AGcl8dmFyhEa1tWq2Zb8tcp4kqkUafWI2QRZkT0CzepS2CD7GGA==
X-Received: by 2002:a05:600c:1c1c:b0:424:8be4:f2c with SMTP id 5b1f17b1804b1-4279dabdfa1mr19063735e9.2.1720774480480;
        Fri, 12 Jul 2024 01:54:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFkkoUJWogIxc8aAVkgm7MgPD/u3veQ1A4xDoDJJYafBVdLp0C0nWIxuogLeydo1P5/GhsYSA==
X-Received: by 2002:a05:600c:1c1c:b0:424:8be4:f2c with SMTP id 5b1f17b1804b1-4279dabdfa1mr19063395e9.2.1720774480104;
        Fri, 12 Jul 2024 01:54:40 -0700 (PDT)
Received: from fedora ([2a01:e0a:257:8c60:80f1:cdf8:48d0:b0a1])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-367cde8476dsm9631003f8f.36.2024.07.12.01.54.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jul 2024 01:54:39 -0700 (PDT)
Date: Fri, 12 Jul 2024 10:54:37 +0200
From: Matias Ezequiel Vara Larsen <mvaralar@redhat.com>
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
Subject: Re: [PATCH v4 00/15] arm64: Support for running as a guest in Arm CCA
Message-ID: <ZpDvTXMDq6i+4O0m@fedora>
References: <20240701095505.165383-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240701095505.165383-1-steven.price@arm.com>

On Mon, Jul 01, 2024 at 10:54:50AM +0100, Steven Price wrote:
> This series adds support for running Linux in a protected VM under the
> Arm Confidential Compute Architecture (CCA). This has been updated
> following the feedback from the v3 posting[1]. Thanks for the feedback!
> Individual patches have a change log. But things to highlight:
> 
>  * a new patch ("firmware/psci: Add psci_early_test_conduit()") to
>    prevent SMC calls being made on systems which don't support them -
>    i.e. systems without EL2/EL3 - thanks Jean-Philippe!
> 
>  * two patches dropped (overriding set_fixmap_io). Instead
>    FIXMAP_PAGE_IO is modified to include PROT_NS_SHARED. When support
>    for assigning hardware devices to a realm guest is added this will
>    need to be brought back in some form. But for now it's just adding
>    complixity and confusion for no gain.
> 
>  * a new patch ("arm64: mm: Avoid TLBI when marking pages as valid")
>    which avoids doing an extra TLBI when doing the break-before-make.
>    Note that this changes the behaviour in other cases when making
>    memory valid. This should be safe (and saves a TLBI for those cases),
>    but it's a separate patch in case of regressions.
> 
>  * GIC ITT allocation now uses a custom genpool-based allocator. I
>    expect this will be replaced with a generic way of allocating
>    decrypted memory (see [4]), but for now this gets things working
>    without wasting too much memory.
> 
> The ABI to the RMM from a realm (the RSI) is based on the final RMM v1.0
> (EAC 5) specification[2]. Future RMM specifications will be backwards
> compatible so a guest using the v1.0 specification (i.e. this series)
> will be able to run on future versions of the RMM without modification.
> 
> This series is based on v6.10-rc1. It is also available as a git
> repository:
> 
> https://gitlab.arm.com/linux-arm/linux-cca cca-guest/v4
> 
> This series (the guest side) should be in a good state so please review
> with the intention that this could be merged soon. The host side will
> require more iteration so the versioning of the series will diverge -
> so for now continue to use v3 for the host support.
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
> [1] https://lore.kernel.org/lkml/20240605093006.145492-1-steven.price%40arm.com
> [2] https://developer.arm.com/documentation/den0137/1-0eac5/
> [3] https://www.arm.com/architecture/security-features/arm-confidential-compute-architecture
> [4] https://lore.kernel.org/lkml/ZmNJdSxSz-sYpVgI%40arm.com
> 
> Jean-Philippe Brucker (1):
>   firmware/psci: Add psci_early_test_conduit()
> 
> Sami Mujawar (2):
>   arm64: rsi: Interfaces to query attestation token
>   virt: arm-cca-guest: TSM_REPORT support for realms
> 
> Steven Price (7):
>   arm64: realm: Query IPA size from the RMM
>   arm64: Mark all I/O as non-secure shared
>   arm64: Make the PHYS_MASK_SHIFT dynamic
>   arm64: Enforce bounce buffers for realm DMA
>   arm64: mm: Avoid TLBI when marking pages as valid
>   irqchip/gic-v3-its: Share ITS tables with a non-trusted hypervisor
>   irqchip/gic-v3-its: Rely on genpool alignment
> 
> Suzuki K Poulose (5):
>   arm64: rsi: Add RSI definitions
>   arm64: Detect if in a realm and set RIPAS RAM
>   arm64: Enable memory encrypt for Realms
>   arm64: Force device mappings to be non-secure shared
>   efi: arm64: Map Device with Prot Shared
> 
>  arch/arm64/Kconfig                            |   3 +
>  arch/arm64/include/asm/fixmap.h               |   2 +-
>  arch/arm64/include/asm/io.h                   |   8 +-
>  arch/arm64/include/asm/mem_encrypt.h          |  17 ++
>  arch/arm64/include/asm/pgtable-hwdef.h        |   6 -
>  arch/arm64/include/asm/pgtable-prot.h         |   3 +
>  arch/arm64/include/asm/pgtable.h              |  13 +-
>  arch/arm64/include/asm/rsi.h                  |  64 ++++++
>  arch/arm64/include/asm/rsi_cmds.h             | 134 +++++++++++
>  arch/arm64/include/asm/rsi_smc.h              | 142 ++++++++++++
>  arch/arm64/include/asm/set_memory.h           |   3 +
>  arch/arm64/kernel/Makefile                    |   3 +-
>  arch/arm64/kernel/efi.c                       |   2 +-
>  arch/arm64/kernel/rsi.c                       | 104 +++++++++
>  arch/arm64/kernel/setup.c                     |   8 +
>  arch/arm64/mm/init.c                          |  10 +-
>  arch/arm64/mm/pageattr.c                      |  76 ++++++-
>  drivers/firmware/psci/psci.c                  |  25 +++
>  drivers/irqchip/irq-gic-v3-its.c              | 142 +++++++++---
>  drivers/virt/coco/Kconfig                     |   2 +
>  drivers/virt/coco/Makefile                    |   1 +
>  drivers/virt/coco/arm-cca-guest/Kconfig       |  11 +
>  drivers/virt/coco/arm-cca-guest/Makefile      |   2 +
>  .../virt/coco/arm-cca-guest/arm-cca-guest.c   | 211 ++++++++++++++++++
>  include/linux/psci.h                          |   5 +
>  25 files changed, 953 insertions(+), 44 deletions(-)
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
> 

Hello,

I tested this series on QEMU/KVM with the CCA patches(v2) and the FVP
model. I could not find any evident issue.

Tested-by: Matias Ezequiel Vara Larsen <mvaralar@redhat.com>


