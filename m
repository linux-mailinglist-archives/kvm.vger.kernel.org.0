Return-Path: <kvm+bounces-72501-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6CtGD4l+pmnhQQAAu9opvQ
	(envelope-from <kvm+bounces-72501-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 07:24:09 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BB141E9960
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 07:24:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6CA1030A4A62
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 06:22:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E9CE37DE94;
	Tue,  3 Mar 2026 06:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="hBFbBJNe"
X-Original-To: kvm@vger.kernel.org
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3572D35CBD7
	for <kvm@vger.kernel.org>; Tue,  3 Mar 2026 06:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772518945; cv=none; b=TOyGyLm6JCX1DNQ8cS0CdREwvV4GOLzXtIBou81dpU7wWgNckXnlti7Dt6B2cdtSdCkgHdGxdqvTJpzHrqHI5+ibJd+Ac43F7QUmEeYK7w/Fd2bW3Pm9jN5v+boFLDbK2SVRqzz5ry/+tHLJaNSgOZYYPzZRRkIFIFubT1GFMI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772518945; c=relaxed/simple;
	bh=hCH6OUGqlsWIY7zC0dS5OdMmmVu4dEA8EXsuCrydg2w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XbySPUE8y1bOhpk/ynsIcxUcZkekjMzXfp9SpCI27gmvCIGM7JP9ZcjlXUY6z4SXPA74DiTMpDd4PkrPnTcEmC3iexpXncnx5KaGBGkDLiIKx83Liv3ardUjY6bk4TBhjM4DOk9LAYXG+EzHYm2F5/x2aj4JAtyKkEoSWhJvPUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=hBFbBJNe; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Message-ID: <63622051-f128-4450-8579-97f25305beb5@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772518931;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TXvC0W9BK/qCDM2luuVOjFiw+pG7WQpudbkrpHQ06Bk=;
	b=hBFbBJNeRGCjHua0QjXLgz/eHaN8IFODEb3GXPUD8UbMcTeR5gfAlvWl0O3UihX48thOvt
	iQ65ft3idSC9hFOIMyAXX0qKP2XgbVR99CJAnOOkPB00eEHxxmhlfz9pNXQ2DLDcq9edGY
	7UJwXmxf3sVgeP7+cgWF1X5/kjOz/Tk=
Date: Mon, 2 Mar 2026 22:21:55 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v2 04/22] vfio/pci: Register a file handler with Live
 Update Orchestrator
To: David Matlack <dmatlack@google.com>, Alex Williamson <alex@shazbot.org>
Cc: Adithya Jayachandran <ajayachandra@nvidia.com>,
 Alexander Graf <graf@amazon.com>, Alex Mastro <amastro@fb.com>,
 Alistair Popple <apopple@nvidia.com>,
 Andrew Morton <akpm@linux-foundation.org>, Ankit Agrawal
 <ankita@nvidia.com>, Bjorn Helgaas <bhelgaas@google.com>,
 Chris Li <chrisl@kernel.org>, David Rientjes <rientjes@google.com>,
 Jacob Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@nvidia.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>,
 Josh Hilke <jrhilke@google.com>, Kevin Tian <kevin.tian@intel.com>,
 kexec@lists.infradead.org, kvm@vger.kernel.org,
 Leon Romanovsky <leon@kernel.org>, Leon Romanovsky <leonro@nvidia.com>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
 linux-pci@vger.kernel.org, Lukas Wunner <lukas@wunner.de>,
 =?UTF-8?Q?Micha=C5=82_Winiarski?= <michal.winiarski@intel.com>,
 Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 Pranjal Shrivastava <praan@google.com>, Pratyush Yadav
 <pratyush@kernel.org>, Raghavendra Rao Ananta <rananta@google.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>, Saeed Mahameed <saeedm@nvidia.com>,
 Samiullah Khawaja <skhawaja@google.com>,
 Shuah Khan <skhan@linuxfoundation.org>,
 =?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
 Tomita Moeko <tomitamoeko@gmail.com>, Vipin Sharma <vipinsh@google.com>,
 Vivek Kasireddy <vivek.kasireddy@intel.com>, William Tu <witu@nvidia.com>,
 Yi Liu <yi.l.liu@intel.com>
References: <20260129212510.967611-1-dmatlack@google.com>
 <20260129212510.967611-5-dmatlack@google.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <20260129212510.967611-5-dmatlack@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 9BB141E9960
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[linux.dev,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[linux.dev:s=key1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72501-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[nvidia.com,amazon.com,fb.com,linux-foundation.org,google.com,kernel.org,linux.microsoft.com,ziepe.ca,lwn.net,intel.com,lists.infradead.org,vger.kernel.org,kvack.org,wunner.de,soleen.com,linuxfoundation.org,linux.intel.com,gmail.com];
	RCPT_COUNT_TWELVE(0.00)[44];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.993];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yanjun.zhu@linux.dev,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[linux.dev:+];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.dev:dkim,linux.dev:mid,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action


在 2026/1/29 13:24, David Matlack 写道:
> From: Vipin Sharma <vipinsh@google.com>
>
> Register a live update file handler for vfio-pci device files. Add stub
> implementations of all required callbacks so that registration does not
> fail (i.e. to avoid breaking git-bisect).
>
> This file handler will be extended in subsequent commits to enable a
> device bound to vfio-pci to run without interruption while the host is
> going through a kexec Live Update.
>
> Signed-off-by: Vipin Sharma <vipinsh@google.com>
> Co-developed-by: David Matlack <dmatlack@google.com>
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>   MAINTAINERS                            |  1 +
>   drivers/vfio/pci/Makefile              |  1 +
>   drivers/vfio/pci/vfio_pci.c            |  9 +++-
>   drivers/vfio/pci/vfio_pci_liveupdate.c | 69 ++++++++++++++++++++++++++
>   drivers/vfio/pci/vfio_pci_priv.h       | 14 ++++++
>   include/linux/kho/abi/vfio_pci.h       | 28 +++++++++++
>   6 files changed, 121 insertions(+), 1 deletion(-)
>   create mode 100644 drivers/vfio/pci/vfio_pci_liveupdate.c
>   create mode 100644 include/linux/kho/abi/vfio_pci.h
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index a671e3d4e8be..7d6cdecedb05 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -27520,6 +27520,7 @@ F:	Documentation/ABI/testing/debugfs-vfio
>   F:	Documentation/ABI/testing/sysfs-devices-vfio-dev
>   F:	Documentation/driver-api/vfio.rst
>   F:	drivers/vfio/
> +F:	include/linux/kho/abi/vfio_pci.h
>   F:	include/linux/vfio.h
>   F:	include/linux/vfio_pci_core.h
>   F:	include/uapi/linux/vfio.h
> diff --git a/drivers/vfio/pci/Makefile b/drivers/vfio/pci/Makefile
> index e0a0757dd1d2..23305ebc418b 100644
> --- a/drivers/vfio/pci/Makefile
> +++ b/drivers/vfio/pci/Makefile
> @@ -7,6 +7,7 @@ obj-$(CONFIG_VFIO_PCI_CORE) += vfio-pci-core.o
>   
>   vfio-pci-y := vfio_pci.o
>   vfio-pci-$(CONFIG_VFIO_PCI_IGD) += vfio_pci_igd.o
> +vfio-pci-$(CONFIG_LIVEUPDATE) += vfio_pci_liveupdate.o
>   obj-$(CONFIG_VFIO_PCI) += vfio-pci.o
>   
>   obj-$(CONFIG_MLX5_VFIO_PCI)           += mlx5/
> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> index 0c771064c0b8..19e88322af2c 100644
> --- a/drivers/vfio/pci/vfio_pci.c
> +++ b/drivers/vfio/pci/vfio_pci.c
> @@ -258,6 +258,10 @@ static int __init vfio_pci_init(void)
>   	int ret;
>   	bool is_disable_vga = true;
>   
> +	ret = vfio_pci_liveupdate_init();
> +	if (ret)
> +		return ret;
> +
>   #ifdef CONFIG_VFIO_PCI_VGA
>   	is_disable_vga = disable_vga;
>   #endif
> @@ -266,8 +270,10 @@ static int __init vfio_pci_init(void)
>   
>   	/* Register and scan for devices */
>   	ret = pci_register_driver(&vfio_pci_driver);
> -	if (ret)
> +	if (ret) {
> +		vfio_pci_liveupdate_cleanup();
>   		return ret;
> +	}
>   
>   	vfio_pci_fill_ids();
>   
> @@ -281,6 +287,7 @@ module_init(vfio_pci_init);
>   static void __exit vfio_pci_cleanup(void)
>   {
>   	pci_unregister_driver(&vfio_pci_driver);
> +	vfio_pci_liveupdate_cleanup();
>   }
>   module_exit(vfio_pci_cleanup);
>   
> diff --git a/drivers/vfio/pci/vfio_pci_liveupdate.c b/drivers/vfio/pci/vfio_pci_liveupdate.c
> new file mode 100644
> index 000000000000..b84e63c0357b
> --- /dev/null
> +++ b/drivers/vfio/pci/vfio_pci_liveupdate.c
> @@ -0,0 +1,69 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +/*
> + * Copyright (c) 2025, Google LLC.

The live update support for vfio-pci was initiated in 2025, but 
developments are into 2026. Update the copyright to 2026 or 2025 - 2026.

Zhu Yanjun

> + * Vipin Sharma <vipinsh@google.com>
> + * David Matlack <dmatlack@google.com>
> + */
> +
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
> +#include <linux/kho/abi/vfio_pci.h>
> +#include <linux/liveupdate.h>
> +#include <linux/errno.h>
> +
> +#include "vfio_pci_priv.h"
> +
> +static bool vfio_pci_liveupdate_can_preserve(struct liveupdate_file_handler *handler,
> +					     struct file *file)
> +{
> +	return false;
> +}
> +
> +static int vfio_pci_liveupdate_preserve(struct liveupdate_file_op_args *args)
> +{
> +	return -EOPNOTSUPP;
> +}
> +
> +static void vfio_pci_liveupdate_unpreserve(struct liveupdate_file_op_args *args)
> +{
> +}
> +
> +static int vfio_pci_liveupdate_retrieve(struct liveupdate_file_op_args *args)
> +{
> +	return -EOPNOTSUPP;
> +}
> +
> +static void vfio_pci_liveupdate_finish(struct liveupdate_file_op_args *args)
> +{
> +}
> +
> +static const struct liveupdate_file_ops vfio_pci_liveupdate_file_ops = {
> +	.can_preserve = vfio_pci_liveupdate_can_preserve,
> +	.preserve = vfio_pci_liveupdate_preserve,
> +	.unpreserve = vfio_pci_liveupdate_unpreserve,
> +	.retrieve = vfio_pci_liveupdate_retrieve,
> +	.finish = vfio_pci_liveupdate_finish,
> +	.owner = THIS_MODULE,
> +};
> +
> +static struct liveupdate_file_handler vfio_pci_liveupdate_fh = {
> +	.ops = &vfio_pci_liveupdate_file_ops,
> +	.compatible = VFIO_PCI_LUO_FH_COMPATIBLE,
> +};
> +
> +int __init vfio_pci_liveupdate_init(void)
> +{
> +	if (!liveupdate_enabled())
> +		return 0;
> +
> +	return liveupdate_register_file_handler(&vfio_pci_liveupdate_fh);
> +}
> +
> +void vfio_pci_liveupdate_cleanup(void)
> +{
> +	if (!liveupdate_enabled())
> +		return;
> +
> +	liveupdate_unregister_file_handler(&vfio_pci_liveupdate_fh);
> +}
> diff --git a/drivers/vfio/pci/vfio_pci_priv.h b/drivers/vfio/pci/vfio_pci_priv.h
> index 27ac280f00b9..68966ec64e51 100644
> --- a/drivers/vfio/pci/vfio_pci_priv.h
> +++ b/drivers/vfio/pci/vfio_pci_priv.h
> @@ -133,4 +133,18 @@ static inline void vfio_pci_dma_buf_move(struct vfio_pci_core_device *vdev,
>   }
>   #endif
>   
> +#ifdef CONFIG_LIVEUPDATE
> +int __init vfio_pci_liveupdate_init(void);
> +void vfio_pci_liveupdate_cleanup(void);
> +#else
> +static inline int vfio_pci_liveupdate_init(void)
> +{
> +	return 0;
> +}
> +
> +static inline void vfio_pci_liveupdate_cleanup(void)
> +{
> +}
> +#endif /* CONFIG_LIVEUPDATE */
> +
>   #endif
> diff --git a/include/linux/kho/abi/vfio_pci.h b/include/linux/kho/abi/vfio_pci.h
> new file mode 100644
> index 000000000000..37a845eed972
> --- /dev/null
> +++ b/include/linux/kho/abi/vfio_pci.h
> @@ -0,0 +1,28 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +
> +/*
> + * Copyright (c) 2025, Google LLC.
> + * Vipin Sharma <vipinsh@google.com>
> + * David Matlack <dmatlack@google.com>
> + */
> +
> +#ifndef _LINUX_LIVEUPDATE_ABI_VFIO_PCI_H
> +#define _LINUX_LIVEUPDATE_ABI_VFIO_PCI_H
> +
> +/**
> + * DOC: VFIO PCI Live Update ABI
> + *
> + * This header defines the ABI for preserving the state of a VFIO PCI device
> + * files across a kexec reboot using LUO.
> + *
> + * Device metadata is serialized into memory which is then handed to the next
> + * kernel via KHO.
> + *
> + * This interface is a contract. Any modification to any of the serialization
> + * structs defined here constitutes a breaking change. Such changes require
> + * incrementing the version number in the VFIO_PCI_LUO_FH_COMPATIBLE string.
> + */
> +
> +#define VFIO_PCI_LUO_FH_COMPATIBLE "vfio-pci-v1"
> +
> +#endif /* _LINUX_LIVEUPDATE_ABI_VFIO_PCI_H */

-- 
Best Regards,
Yanjun.Zhu


