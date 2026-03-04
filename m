Return-Path: <kvm+bounces-72717-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mKUDAD13qGkLuwAAu9opvQ
	(envelope-from <kvm+bounces-72717-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 19:17:33 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B325020622E
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 19:17:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id ED4C03078F0C
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2026 18:10:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8815E3D3D12;
	Wed,  4 Mar 2026 18:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="W2u/vM5b";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="2W+epVkR"
X-Original-To: kvm@vger.kernel.org
Received: from fout-b5-smtp.messagingengine.com (fout-b5-smtp.messagingengine.com [202.12.124.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A636A345CCD;
	Wed,  4 Mar 2026 18:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772647746; cv=none; b=bJAQwbV1EZ1gPvbxr/NWW8Ezzzq9UnkvooFBeTyM9r44chhQwApgsETkgd/DDAPO4eexHo6c7zSmKp8c5rdcWwleqTmzXlebByu1PXUaNKdiOwXJWP///0/KvBbTKg9OHnT0RTkkgtGeVQDgDhkXkyG2MKX1uwbUPbRqKfXBnDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772647746; c=relaxed/simple;
	bh=OGC+EenJ845Wlw134ixacvcp63TuPzlu5ztD9r3t6XY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UotfEe8HohfDY0/LZnute0V/qLrhfqFP/99ZkBjF0MWoIpLtJ90tqcAFwXs4+oZzu9KilyeKoc4BAcF+Bed2cOEUJ2HRmr8svsrSzra/Lt8yBeJUVpkVoNM7OL0dm1J3R6Xf8+ytH3/Ry0e4q5Ghxf8oabiHNmAdiWkWBp2oZTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=W2u/vM5b; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=2W+epVkR; arc=none smtp.client-ip=202.12.124.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-11.internal (phl-compute-11.internal [10.202.2.51])
	by mailfout.stl.internal (Postfix) with ESMTP id 309171D00173;
	Wed,  4 Mar 2026 13:09:03 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-11.internal (MEProxy); Wed, 04 Mar 2026 13:09:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1772647742;
	 x=1772734142; bh=HWf9FeNm6sIENyq4ht0InEdflnyGyn1wn6KJliPEu9g=; b=
	W2u/vM5blxDvie5F0MHnfEnPIo1VLZa+3XM1cTGP1WulKSDsMGUeDpcgijOUvjBP
	TY4piTTytj7L2Po8rRm4I31kSJ8X9DcYx8cwf/WADK0nK9zvizri8veXWK/ziMKe
	LEukOINZOuXIBiB1DxuKNbfmnpxJLhcN7sCs3ykpwtKCYEmwyrxradvMKksXoTkL
	LxD9N9nMxVO8Q5A3aBE6S+kQERLVun64O8UpXP6wWh1qNebDgdrsoh6W9JNdqn82
	pV2CJX70Il/Pgzl+PKdYR4VMkDzomY2pQQF17KPMbsPaEHfeBjIpKP7aUd0C5D99
	XsNDjnL031gAv6igkz3RPQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1772647742; x=
	1772734142; bh=HWf9FeNm6sIENyq4ht0InEdflnyGyn1wn6KJliPEu9g=; b=2
	W+epVkRCxikeYclVLwIHWQFsTDo0MjujhnEC62/0InFlIQpeh2KZBKORXOsDpUAh
	l8z0zrG4jTIZz6T4IbsalxjLNNw5t/34MMRtTJObFZQp1NohytcWs1af5CmpkQ85
	a4Mb/boNOJpDBKt0YhQXgKIHbGJd3F0u0n6ggraWTgmsrrusjLIqfZLfG+PRp3j4
	WH2CfwbHLLQGBY+lc5U7NfzQvQC6AmUdqcx6AF9LlYXxJe42oQwuytlQe7U3IGZ4
	LcKtJaTcTg2ZuAMLod0fbcuD+2GTtFiV5YuQzLWqQqKDBNToTkmllMonFVwe6jid
	BXCXTFZaQpO+JvWK2QFZQ==
X-ME-Sender: <xms:PnWoaWdrME59lLPgYEYoz-Zq9oZcizByU9RqaSZXu6OVlPopO0Kdtw>
    <xme:PnWoaVaMkFDV3eDum_C1x0IQdmEoA0-vGdGeH1iCvLHN3QSHJGd0prUm3cJbFMZcs
    sGJ_D_a8MyXxuKGhLzfADSIo88PIlLyjr8CjslzRHiqkY4O3Yg>
X-ME-Received: <xmr:PnWoaa6MUz6FJiXwIremDY2LybzS5tUW9mySrDw4iMGb5EJ8zVbNZhD0N5k>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvieegudekucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucenucfjughrpeffhffvvefukfgjfhfogggtgfesthejre
    dtredtvdenucfhrhhomheptehlvgigucghihhllhhirghmshhonhcuoegrlhgvgiesshhh
    rgiisghothdrohhrgheqnecuggftrfgrthhtvghrnhepvdekfeejkedvudfhudfhteekud
    fgudeiteetvdeukedvheetvdekgfdugeevueeunecuvehluhhsthgvrhfuihiivgeptden
    ucfrrghrrghmpehmrghilhhfrhhomheprghlvgigsehshhgriigsohhtrdhorhhgpdhnsg
    gprhgtphhtthhopedugedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtoheprghnkhhi
    thgrsehnvhhiughirgdrtghomhdprhgtphhtthhopehvshgvthhhihesnhhvihguihgrrd
    gtohhmpdhrtghpthhtohepjhhgghesnhhvihguihgrrdgtohhmpdhrtghpthhtohepmhho
    tghhshesnhhvihguihgrrdgtohhmpdhrtghpthhtohepjhhgghesiihivghpvgdrtggrpd
    hrtghpthhtohepshhkohhlohhthhhumhhthhhosehnvhhiughirgdrtghomhdprhgtphht
    thhopegtjhhirgesnhhvihguihgrrdgtohhmpdhrtghpthhtohepiihhihifsehnvhhiug
    hirgdrtghomhdprhgtphhtthhopehkjhgrjhhusehnvhhiughirgdrtghomh
X-ME-Proxy: <xmx:PnWoaTd5fczA4teZ7YFuPh40NUXM_AxSbm0WIM8eRztxGufV38_fyA>
    <xmx:PnWoadyZgx_kT1XNeaXmHfjDilJcCX3cA8g0fauQn8eed11Rv4Rzug>
    <xmx:PnWoaZqq9IaP3FCo4wVUXLWQcNtMh5n7J9OmQRemWnM3SF5VyZwvAg>
    <xmx:PnWoabyQJlxy3NkRuHbuVW2MM4n8Lnq4jEL50-W_RGzhgh_jHeOZ4w>
    <xmx:PnWoaUpU1hFbNI2w5gkt0aulrCvGxn9gdBWXreLV4JxW7dy3F8L1EMex>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 4 Mar 2026 13:09:01 -0500 (EST)
Date: Wed, 4 Mar 2026 11:09:00 -0700
From: Alex Williamson <alex@shazbot.org>
To: <ankita@nvidia.com>
Cc: <vsethi@nvidia.com>, <jgg@nvidia.com>, <mochs@nvidia.com>,
 <jgg@ziepe.ca>, <skolothumtho@nvidia.com>, <cjia@nvidia.com>,
 <zhiw@nvidia.com>, <kjaju@nvidia.com>, <yishaih@nvidia.com>,
 <kevin.tian@intel.com>, <kvm@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, alex@shazbot.org
Subject: Re: [PATCH RFC v2 05/15] vfio/nvgrace-egm: Introduce module to
 manage EGM
Message-ID: <20260304110900.47151cc8@shazbot.org>
In-Reply-To: <20260223155514.152435-6-ankita@nvidia.com>
References: <20260223155514.152435-1-ankita@nvidia.com>
	<20260223155514.152435-6-ankita@nvidia.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: B325020622E
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[shazbot.org,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[shazbot.org:s=fm3,messagingengine.com:s=fm1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[shazbot.org:+,messagingengine.com:+];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72717-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[alex@shazbot.org,kvm@vger.kernel.org];
	RCPT_COUNT_TWELVE(0.00)[14];
	RCVD_COUNT_FIVE(0.00)[6];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_NONE(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo,shazbot.org:dkim,shazbot.org:mid,nvidia.com:email,messagingengine.com:dkim]
X-Rspamd-Action: no action

On Mon, 23 Feb 2026 15:55:04 +0000
<ankita@nvidia.com> wrote:

> From: Ankit Agrawal <ankita@nvidia.com>
> 
> The Extended GPU Memory (EGM) feature that enables the GPU to access
> the system memory allocations within and across nodes through high
> bandwidth path on Grace Based systems. The GPU can utilize the
> system memory located on the same socket or from a different socket
> or even on a different node in a multi-node system [1].
> 
> When the EGM mode is enabled through SBIOS, the host system memory is
> partitioned into 2 parts: One partition for the Host OS usage
> called Hypervisor region, and a second Hypervisor-Invisible (HI) region
> for the VM. Only the hypervisor region is part of the host EFI map
> and is thus visible to the host OS on bootup. Since the entire VM
> sysmem is eligible for EGM allocations within the VM, the HI partition
> is interchangeably called as EGM region in the series. This HI/EGM region
> range base SPA and size is exposed through the ACPI DSDT properties.
> 
> Whilst the EGM region is accessible on the host, it is not added to
> the kernel. The HI region is assigned to a VM by mapping the QEMU VMA
> to the SPA using remap_pfn_range().
> 
> The following figure shows the memory map in the virtualization
> environment.
> 
> |---- Sysmem ----|                  |--- GPU mem ---|  VM Memory
> |                |                  |               |
> |IPA <-> SPA map |                  |IPA <-> SPA map|
> |                |                  |               |
> |--- HI / EGM ---|-- Host Mem --|   |--- GPU mem ---|  Host Memory
> 
> Introduce a new nvgrace-egm auxiliary driver module to manage and
> map the HI/EGM region in the Grace Blackwell systems. This binds to
> the auxiliary device created by the parent nvgrace-gpu (in-tree
> module for device assignment) / nvidia-vgpu-vfio (out-of-tree open
> source module for SRIOV vGPU) to manage the EGM region for the VM.
> Note that there is a unique EGM region per socket and the auxiliary
> device gets created for every region. The parent module fetches the
> EGM region information from the ACPI tables and populate to the data
> structures shared with the auxiliary nvgrace-egm module.
> 
> nvgrace-egm module handles the following:

Or it will eventually, not in this commit.

> 1. Fetch the EGM memory properties (base HPA, length, proximity domain)
> from the parent device shared EGM region structure.
> 2. Create a char device that can be used as memory-backend-file by Qemu
> for the VM and implement file operations. The char device is /dev/egmX,
> where X is the PXM node ID of the EGM being mapped fetched in 1.
> 3. Zero the EGM memory on first device open().
> 4. Map the QEMU VMA to the EGM region using remap_pfn_range.
> 5. Cleaning up state and destroying the chardev on device unbind.
> 6. Handle presence of retired ECC pages on the EGM region.
> 
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
> ---
>  MAINTAINERS                           |  6 ++++++
>  drivers/vfio/pci/nvgrace-gpu/Kconfig  | 12 ++++++++++++
>  drivers/vfio/pci/nvgrace-gpu/Makefile |  3 +++
>  drivers/vfio/pci/nvgrace-gpu/egm.c    | 22 ++++++++++++++++++++++
>  drivers/vfio/pci/nvgrace-gpu/main.c   |  1 +
>  5 files changed, 44 insertions(+)
>  create mode 100644 drivers/vfio/pci/nvgrace-gpu/egm.c
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 5b3d86de9ec0..1fc551d7d667 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -27384,6 +27384,12 @@ F:	drivers/vfio/pci/nvgrace-gpu/egm_dev.h
>  F:	drivers/vfio/pci/nvgrace-gpu/main.c
>  F:	include/linux/nvgrace-egm.h
>  
> +VFIO NVIDIA GRACE EGM DRIVER
> +M:	Ankit Agrawal <ankita@nvidia.com>
> +L:	kvm@vger.kernel.org
> +S:	Supported
> +F:	drivers/vfio/pci/nvgrace-gpu/egm.c

I'm not sure a separate MAINTAINERS entry is warranted here, these are
intertwined, even if constructed to allow this EGM driver to be used by
an out-of-tree driver.  It's also an unclean split, with Makefile and
Kconfig dependencies under the nvgrace-gpu heading.  It should probably
be self contained in a separate sub-dir to justify a new MAINTAINERS
entry.

> +
>  VFIO PCI DEVICE SPECIFIC DRIVERS
>  R:	Jason Gunthorpe <jgg@nvidia.com>
>  R:	Yishai Hadas <yishaih@nvidia.com>
> diff --git a/drivers/vfio/pci/nvgrace-gpu/Kconfig b/drivers/vfio/pci/nvgrace-gpu/Kconfig
> index a7f624b37e41..7989d8d1c377 100644
> --- a/drivers/vfio/pci/nvgrace-gpu/Kconfig
> +++ b/drivers/vfio/pci/nvgrace-gpu/Kconfig
> @@ -1,8 +1,20 @@
>  # SPDX-License-Identifier: GPL-2.0-only
> +config NVGRACE_EGM
> +	tristate "EGM driver for NVIDIA Grace Hopper and Blackwell Superchip"
> +	depends on ARM64 || (COMPILE_TEST && 64BIT)
> +	depends on NVGRACE_GPU_VFIO_PCI
> +	help
> +	  Extended GPU Memory (EGM) support for the GPU in the NVIDIA Grace
> +	  based chips required to avail the CPU memory as additional
> +	  cross-node/cross-socket memory for GPU using KVM/qemu.
> +
> +	  If you don't know what to do here, say N.
> +
>  config NVGRACE_GPU_VFIO_PCI
>  	tristate "VFIO support for the GPU in the NVIDIA Grace Hopper Superchip"
>  	depends on ARM64 || (COMPILE_TEST && 64BIT)
>  	select VFIO_PCI_CORE
> +	select NVGRACE_EGM

This should be dropped, it creates a circular dependency where we
cannot actually unselect NVGRACE_EGM with NVGRACE_GPU_VFIO_PCI
selected.

>  	help
>  	  VFIO support for the GPU in the NVIDIA Grace Hopper Superchip is
>  	  required to assign the GPU device to userspace using KVM/qemu/etc.
> diff --git a/drivers/vfio/pci/nvgrace-gpu/Makefile b/drivers/vfio/pci/nvgrace-gpu/Makefile
> index e72cc6739ef8..d0d191be56b9 100644
> --- a/drivers/vfio/pci/nvgrace-gpu/Makefile
> +++ b/drivers/vfio/pci/nvgrace-gpu/Makefile
> @@ -1,3 +1,6 @@
>  # SPDX-License-Identifier: GPL-2.0-only
>  obj-$(CONFIG_NVGRACE_GPU_VFIO_PCI) += nvgrace-gpu-vfio-pci.o
>  nvgrace-gpu-vfio-pci-y := main.o egm_dev.o
> +
> +obj-$(CONFIG_NVGRACE_EGM) += nvgrace-egm.o
> +nvgrace-egm-y := egm.o
> diff --git a/drivers/vfio/pci/nvgrace-gpu/egm.c b/drivers/vfio/pci/nvgrace-gpu/egm.c
> new file mode 100644
> index 000000000000..999808807019
> --- /dev/null
> +++ b/drivers/vfio/pci/nvgrace-gpu/egm.c
> @@ -0,0 +1,22 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (c) 2025, NVIDIA CORPORATION & AFFILIATES. All rights reserved

2026

> + */
> +
> +#include <linux/vfio_pci_core.h>

Premature?

> +
> +static int __init nvgrace_egm_init(void)
> +{
> +	return 0;
> +}
> +
> +static void __exit nvgrace_egm_cleanup(void)
> +{
> +}
> +
> +module_init(nvgrace_egm_init);
> +module_exit(nvgrace_egm_cleanup);
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Ankit Agrawal <ankita@nvidia.com>");
> +MODULE_DESCRIPTION("NVGRACE EGM - Module to support Extended GPU Memory on NVIDIA Grace Based systems");
> diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
> index b356e941340a..0bb427cca31f 100644
> --- a/drivers/vfio/pci/nvgrace-gpu/main.c
> +++ b/drivers/vfio/pci/nvgrace-gpu/main.c
> @@ -1410,3 +1410,4 @@ MODULE_LICENSE("GPL");
>  MODULE_AUTHOR("Ankit Agrawal <ankita@nvidia.com>");
>  MODULE_AUTHOR("Aniket Agashe <aniketa@nvidia.com>");
>  MODULE_DESCRIPTION("VFIO NVGRACE GPU PF - User Level driver for NVIDIA devices with CPU coherently accessible device memory");
> +MODULE_SOFTDEP("pre: nvgrace-egm");

Premature and wrong if necessary.  AIUI the aux device created should
generate uevents and modules loaded automatically via device tables.
Thanks,

Alex

