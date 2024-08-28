Return-Path: <kvm+bounces-25256-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 409D8962A18
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 16:25:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BDF111F242D7
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 14:25:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3FE119E7E0;
	Wed, 28 Aug 2024 14:24:39 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A550F17332A;
	Wed, 28 Aug 2024 14:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724855079; cv=none; b=Gx1ycUqpTTm7tbkABgOumAkZJX1WozWqJ7NqAGvuilkE43udugoynssUF29G+miI/PYJwlBB/9/iGmALziAbBx2P5sUPqC1O0eCOqIkVK1kV4vUQ7wjXjz7SgGv40nLyNIb9IGHkxBdOY+GPuYggwzn5lCv5MiLCRfQnb5sA/6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724855079; c=relaxed/simple;
	bh=1p+bsXM240MMumUDN4hoBzo4pYJ0dk/sHWGaICaCFGE=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LbKtbd2GyU1HQL4l/n15sUnBuo+XkD1SNGrliWFFF5z4eybMsnC8lly28axOXshHbscK6I2nqQCeGZPOArionN7+0sONcj+k1pnHUD8z8DG+fSUtIaDMJc+PikNsQoVKWzw6tHg7yah8pnD/myCihlLbv/ERJ2gZnO/tTWNfgPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Wv65D1QwGz6FGWn;
	Wed, 28 Aug 2024 22:20:32 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (unknown [7.191.163.240])
	by mail.maildlp.com (Postfix) with ESMTPS id C4CBC1400D4;
	Wed, 28 Aug 2024 22:24:33 +0800 (CST)
Received: from localhost (10.203.177.66) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Wed, 28 Aug
 2024 15:24:33 +0100
Date: Wed, 28 Aug 2024 15:24:32 +0100
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Alexey Kardashevskiy <aik@amd.com>
CC: <kvm@vger.kernel.org>, <iommu@lists.linux.dev>,
	<linux-coco@lists.linux.dev>, <linux-pci@vger.kernel.org>, "Suravee
 Suthikulpanit" <suravee.suthikulpanit@amd.com>, Alex Williamson
	<alex.williamson@redhat.com>, Dan Williams <dan.j.williams@intel.com>,
	<pratikrajesh.sampat@amd.com>, <michael.day@amd.com>, <david.kaplan@amd.com>,
	<dhaval.giani@amd.com>, Santosh Shukla <santosh.shukla@amd.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, "Michael Roth" <michael.roth@amd.com>, Alexander
 Graf <agraf@suse.de>, "Nikunj A Dadhania" <nikunj@amd.com>, Vasant Hegde
	<vasant.hegde@amd.com>, "Lukas Wunner" <lukas@wunner.de>
Subject: Re: [RFC PATCH 04/21] PCI/IDE: Define Integrity and Data Encryption
 (IDE) extended capability
Message-ID: <20240828152432.00000208@Huawei.com>
In-Reply-To: <20240823132137.336874-5-aik@amd.com>
References: <20240823132137.336874-1-aik@amd.com>
	<20240823132137.336874-5-aik@amd.com>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml100004.china.huawei.com (7.191.162.219) To
 lhrpeml500005.china.huawei.com (7.191.163.240)

On Fri, 23 Aug 2024 23:21:18 +1000
Alexey Kardashevskiy <aik@amd.com> wrote:

> PCIe 6.0 introduces the "Integrity & Data Encryption (IDE)" feature which
> adds a new capability with id=0x30.
> 
> Add the new id to the list of capabilities. Add new flags from pciutils.
> Add a module with a helper to control selective IDE capability.
> 
> TODO: get rid of lots of magic numbers. It is one annoying flexible
> capability to deal with.

Ah. I should read the patch description before reviewing.
It is indeed horrible.

> 
> Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
Hi Alexey,

Some comments inline.

> ---
>  drivers/pci/Makefile          |   1 +
>  include/linux/pci-ide.h       |  18 ++
>  include/uapi/linux/pci_regs.h |  76 +++++++-
>  drivers/pci/ide.c             | 186 ++++++++++++++++++++
>  drivers/pci/Kconfig           |   4 +
>  5 files changed, 284 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/pci/Makefile b/drivers/pci/Makefile
> index 1452e4ba7f00..034f17f9297a 100644
> --- a/drivers/pci/Makefile
> +++ b/drivers/pci/Makefile
> @@ -34,6 +34,7 @@ obj-$(CONFIG_PCI_P2PDMA)	+= p2pdma.o
>  obj-$(CONFIG_XEN_PCIDEV_FRONTEND) += xen-pcifront.o
>  obj-$(CONFIG_VGA_ARB)		+= vgaarb.o
>  obj-$(CONFIG_PCI_DOE)		+= doe.o
> +obj-$(CONFIG_PCI_IDE)		+= ide.o
>  obj-$(CONFIG_PCI_DYNAMIC_OF_NODES) += of_property.o
>  
>  obj-$(CONFIG_PCI_CMA)		+= cma.o cma.asn1.o
> diff --git a/include/linux/pci-ide.h b/include/linux/pci-ide.h
> new file mode 100644
> index 000000000000..983a8daf1199
> --- /dev/null
> +++ b/include/linux/pci-ide.h
> @@ -0,0 +1,18 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Integrity & Data Encryption (IDE)
> + *	PCIe r6.0, sec 6.33 DOE
> + */
> +
> +#ifndef LINUX_PCI_IDE_H
> +#define LINUX_PCI_IDE_H
> +
> +int pci_ide_set_sel(struct pci_dev *pdev, unsigned int sel_index, unsigned int streamid,
> +		    bool enable, bool def, bool tee_limited, bool ide_cfg);
> +int pci_ide_set_sel_rid_assoc(struct pci_dev *pdev, unsigned int sel_index,
> +			      bool valid, u8 seg_base, u16 rid_base, u16 rid_limit);
> +int pci_ide_set_sel_addr_assoc(struct pci_dev *pdev, unsigned int sel_index, unsigned int blocknum,
> +			       bool valid, u64 base, u64 limit);
> +int pci_ide_get_sel_sta(struct pci_dev *pdev, unsigned int sel_index, u32 *status);
> +
> +#endif
> diff --git a/include/uapi/linux/pci_regs.h b/include/uapi/linux/pci_regs.h
> index 0011a301b8c5..80962b07719a 100644
> --- a/include/uapi/linux/pci_regs.h
> +++ b/include/uapi/linux/pci_regs.h
> @@ -743,7 +743,8 @@
>  #define PCI_EXT_CAP_ID_PL_16GT	0x26	/* Physical Layer 16.0 GT/s */
>  #define PCI_EXT_CAP_ID_PL_32GT  0x2A    /* Physical Layer 32.0 GT/s */
>  #define PCI_EXT_CAP_ID_DOE	0x2E	/* Data Object Exchange */
> -#define PCI_EXT_CAP_ID_MAX	PCI_EXT_CAP_ID_DOE
> +#define PCI_EXT_CAP_ID_IDE	0x30	/* Integrity and Data Encryption (IDE) */
> +#define PCI_EXT_CAP_ID_MAX	PCI_EXT_CAP_ID_IDE
>  
>  #define PCI_EXT_CAP_DSN_SIZEOF	12
>  #define PCI_EXT_CAP_MCAST_ENDPOINT_SIZEOF 40
> @@ -1150,9 +1151,82 @@
>  #define PCI_DOE_DATA_OBJECT_DISC_RSP_3_PROTOCOL		0x00ff0000
>  #define PCI_DOE_DATA_OBJECT_DISC_RSP_3_NEXT_INDEX	0xff000000
>  
> +
Check for accidental white space changes. They distract from real content
so get rid of them before posting - even for an RFC.

>  /* Compute Express Link (CXL r3.1, sec 8.1.5) */
>  #define PCI_DVSEC_CXL_PORT				3
>  #define PCI_DVSEC_CXL_PORT_CTL				0x0c
>  #define PCI_DVSEC_CXL_PORT_CTL_UNMASK_SBR		0x00000001
>  
> +/* Integrity and Data Encryption Extended Capability */
> +#define PCI_IDE_CAP		0x4
> +#define  PCI_IDE_CAP_LINK_IDE_SUPP	0x1	/* Link IDE Stream Supported */
> +#define  PCI_IDE_CAP_SELECTIVE_IDE_SUPP 0x2	/* Selective IDE Streams Supported */
> +#define  PCI_IDE_CAP_FLOWTHROUGH_IDE_SUPP 0x4	/* Flow-Through IDE Stream Supported */
> +#define  PCI_IDE_CAP_PARTIAL_HEADER_ENC_SUPP 0x8 /* Partial Header Encryption Supported */
> +#define  PCI_IDE_CAP_AGGREGATION_SUPP	0x10	/* Aggregation Supported */
> +#define  PCI_IDE_CAP_PCRC_SUPP		0x20	/* PCRC Supported */
> +#define  PCI_IDE_CAP_IDE_KM_SUPP	0x40	/* IDE_KM Protocol Supported */
> +#define  PCI_IDE_CAP_ALG(x)	(((x) >> 8) & 0x1f) /* Supported Algorithms */
> +#define  PCI_IDE_CAP_ALG_AES_GCM_256	0	/* AES-GCM 256 key size, 96b MAC */
> +#define  PCI_IDE_CAP_LINK_TC_NUM(x)		(((x) >> 13) & 0x7) /* Link IDE TCs */
> +#define  PCI_IDE_CAP_SELECTIVE_STREAMS_NUM(x)	(((x) >> 16) & 0xff) /* Selective IDE Streams */
> +#define  PCI_IDE_CAP_TEE_LIMITED_SUPP   0x1000000 /* TEE-Limited Stream Supported */
> +#define PCI_IDE_CTL		0x8
> +#define  PCI_IDE_CTL_FLOWTHROUGH_IDE	0x4	/* Flow-Through IDE Stream Enabled */
> +#define PCI_IDE_LINK_STREAM		0xC

> +/* Link IDE Stream block, up to PCI_IDE_CAP_LINK_TC_NUM */
These are in a fixed location, so you can define an offset macro to get to each
register.

> +/* Link IDE Stream Control Register */
...

> +/* Link IDE Stream Status Register */


> +/* Selective IDE Stream block, up to PCI_IDE_CAP_SELECTIVE_STREAMS_NUM */
> +/* Selective IDE Stream Capability Register */
> +#define  PCI_IDE_SEL_CAP_BLOCKS_NUM(x)	((x) & 0xf) /*Address Association Register Blocks Number */
Space after /*


>  #endif /* LINUX_PCI_REGS_H */
> diff --git a/drivers/pci/ide.c b/drivers/pci/ide.c
> new file mode 100644
> index 000000000000..dc0632e836e7
> --- /dev/null
> +++ b/drivers/pci/ide.c
> @@ -0,0 +1,186 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Integrity & Data Encryption (IDE)
> + *	PCIe r6.0, sec 6.33 DOE
> + */
> +
> +#define dev_fmt(fmt) "IDE: " fmt
> +
> +#include <linux/pci.h>
> +#include <linux/pci-ide.h>
> +#include <linux/bitfield.h>
> +#include <linux/module.h>
> +
> +#define DRIVER_VERSION	"0.1"
> +#define DRIVER_AUTHOR	"aik@amd.com"
> +#define DRIVER_DESC	"Integrity and Data Encryption driver"
> +
> +/* Returns an offset of the specific IDE stream block */
> +static u16 sel_off(struct pci_dev *pdev, unsigned int sel_index)
Prefix functions with something to indicate they are local.

ide_ or something like that.

Not obvious what sel_index parameter is. So documentation probably
needed for this function.

Also return an error, not 0 to mean error as it will be easier to read.



> +{
> +	u16 offset = pci_find_next_ext_capability(pdev, 0, PCI_EXT_CAP_ID_IDE);
> +	unsigned int linknum = 0, selnum = 0, i;

I'd avoid mixing cases where the value is set and where it isn't.
Better to have
	unsigned int linknum = 0, selnum = 0;
	unsigned int i;

Though i might as well be int.


> +	u16 seloff;
> +	u32 cap = 0;
> +
> +	if (!offset)
> +		return 0;
Not an error? That probably needs a comment.
> +
> +	pci_read_config_dword(pdev, offset + PCI_IDE_CAP, &cap);
> +	if (cap & PCI_IDE_CAP_SELECTIVE_IDE_SUPP)
> +		selnum = PCI_IDE_CAP_SELECTIVE_STREAMS_NUM(cap) + 1;
	if (!(cap & PCI_IDE_CAP_SELECTIVE_IDE_SUPP))
		return -EINVAL; or whatever makes more sense.

	sel_num = PCI_IDE_CAP_SELECTIVE_STREAMS_NUM(cap) + 1;
	if (selnum < sel_index)
		return -E...


> +
> +	if (!selnum || sel_index >= selnum)
> +		return 0;
> +
> +	if (cap & PCI_IDE_CAP_LINK_IDE_SUPP)
> +		linknum = PCI_IDE_CAP_LINK_TC_NUM(cap) + 1;
> +
> +	seloff = offset + PCI_IDE_LINK_STREAM + linknum * 2 * 4;

2 and 4 have meaning. What are they? Use differences in addresses
of registers defined in header.


> +	for (i = 0; i < sel_index; ++i) {
> +		u32 selcap = 0;
> +
> +		pci_read_config_dword(pdev, seloff, &selcap);
> +
> +		/* Selective Cap+Ctrl+Sta + Addr#*8 */
> +		seloff += 3 * 4 + PCI_IDE_SEL_CAP_BLOCKS_NUM(selcap) * 2 * 4;

Same here. All these offsets are in terms of real register differences,
use those and you won't need comments to explain.

> +	}
> +
> +	return seloff;
> +}
> +
> +static u16 sel_off_addr_block(struct pci_dev *pdev, u16 offset, unsigned int blocknum)
> +{
> +	unsigned int blocks;
> +	u32 selcap = 0;
> +
> +	pci_read_config_dword(pdev, offset, &selcap);
> +
> +	blocks = PCI_IDE_SEL_CAP_BLOCKS_NUM(selcap);
> +	if (!blocks)
> +		return 0;
> +
> +	return offset + 3 * 4 + // Skip Cap, Ctl, Sta
> +		2 * 4 + // RID Association Register 1 and 2
Defines should exist for the registers, use the differences between them to
get these offsets.
It gets a little trickier for these as there is a variable size
field before them, but still good to do if possible.

> +		blocknum * 3 * 4; // Each block is Address Association Register 1, 2, 3
> +}
> +
> +static int set_sel(struct pci_dev *pdev, unsigned int sel_index, u32 value)
> +{
> +	u16 offset = sel_off(pdev, sel_index);
	int offset = ide_sel_off(pdev, sel_inxed);
> +	u32 status = 0;
> +
> +	if (!offset)
> +		return -EINVAL;
Return an error for sel_off not 0 on failure. Then pass that error on here.
	if (offset < 0)
		return -EINVAL;	
> +
> +	pci_read_config_dword(pdev, offset + 8, &status);
> +	if (status & PCI_IDE_SEL_STS_RECVD_INTEGRITY_CHECK) {
> +		pci_warn(pdev, "[%x] Clearing \"Received integrity check\"\n", offset + 4);
> +		pci_write_config_dword(pdev, offset + 8,
> +				       status & ~PCI_IDE_SEL_STS_RECVD_INTEGRITY_CHECK);
> +	}
> +
> +	/* Selective IDE Stream Control Register */
> +	pci_write_config_dword(pdev, offset + 4, value);
> +	return 0;
> +}

> +
> +int pci_ide_set_sel_addr_assoc(struct pci_dev *pdev, unsigned int sel_index, unsigned int blocknum,
> +			       bool valid, u64 base, u64 limit)
> +{
> +	u16 offset = sel_off(pdev, sel_index), offset_ab;
> +	u32 a1 = PCI_IDE_SEL_ADDR_1(1, base, limit);
> +	u32 a2 = PCI_IDE_SEL_ADDR_2(limit);
> +	u32 a3 = PCI_IDE_SEL_ADDR_3(base);
> +
> +	if (!offset)
> +		return -EINVAL;
> +
> +	offset_ab = sel_off_addr_block(pdev, offset, blocknum);
> +	if (!offset_ab || offset_ab <= offset)

How would you get the second condition?   Also, better to return
errors from these than 0 to indicate a problem.


> +		return -EINVAL;
> +
> +	/* IDE Address Association Register 1 */
> +	pci_write_config_dword(pdev, offset_ab, a1);

Check for error error returns consistently.


> +	/* IDE Address Association Register 2 */
> +	pci_write_config_dword(pdev, offset_ab + 4, a2);
> +	/* IDE Address Association Register 1 */
> +	pci_write_config_dword(pdev, offset_ab + 8, a3);
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(pci_ide_set_sel_addr_assoc);
> +
> +int pci_ide_get_sel_sta(struct pci_dev *pdev, unsigned int sel_index, u32 *status)
> +{
> +	u16 offset = sel_off(pdev, sel_index);
> +	u32 s = 0;
> +	int ret;
> +
> +	if (!offset)
> +		return -EINVAL;
With changes suggested above return the error code form sel_off.

> +
> +
> +	ret = pci_read_config_dword(pdev, offset + 8, &s);
> +	if (ret)
> +		return ret;
> +
> +	*status = s;
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(pci_ide_get_sel_sta);
> +
> +static int __init ide_init(void)
> +{
> +	int ret = 0;
> +
> +	pr_info(DRIVER_DESC " version: " DRIVER_VERSION "\n");

Linux hasn't cared about driver versions for a long time
which is why relatively few drivers bother with them.
Why do we care here?

Also too noisy.

> +	return ret;
> +}
> +
> +static void __exit ide_cleanup(void)
> +{

You don't have to have this until it has something in it.

> +}
> +
> +module_init(ide_init);
> +module_exit(ide_cleanup);
> +
> +MODULE_VERSION(DRIVER_VERSION);
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR(DRIVER_AUTHOR);
> +MODULE_DESCRIPTION(DRIVER_DESC);

With the print above gone away, just use strings here.

> diff --git a/drivers/pci/Kconfig b/drivers/pci/Kconfig
> index b0b14468ba5d..8e908d684c77 100644
> --- a/drivers/pci/Kconfig
> +++ b/drivers/pci/Kconfig
> @@ -137,6 +137,10 @@ config PCI_CMA
>  config PCI_DOE
>  	bool
>  
> +config PCI_IDE
> +	tristate
> +	default m
Don't set default.  Everything defaults to off and distro's
get to turn them on.

> +
>  config PCI_ECAM
>  	bool
>  


