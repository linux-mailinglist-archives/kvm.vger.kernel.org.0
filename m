Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF5E57B6D13
	for <lists+kvm@lfdr.de>; Tue,  3 Oct 2023 17:28:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232315AbjJCP2l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Oct 2023 11:28:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231559AbjJCP2k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Oct 2023 11:28:40 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88DF6AB;
        Tue,  3 Oct 2023 08:28:36 -0700 (PDT)
Received: from lhrpeml500005.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4S0MCr5zS7z67Nc8;
        Tue,  3 Oct 2023 23:28:24 +0800 (CST)
Received: from localhost (10.202.227.76) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.31; Tue, 3 Oct
 2023 16:28:33 +0100
Date:   Tue, 3 Oct 2023 16:28:32 +0100
From:   Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To:     Lukas Wunner <lukas@wunner.de>
CC:     Bjorn Helgaas <helgaas@kernel.org>,
        David Howells <dhowells@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Alex Williamson <alex.williamson@redhat.com>,
        <linux-pci@vger.kernel.org>, <linux-cxl@vger.kernel.org>,
        <linux-coco@lists.linux.dev>, <keyrings@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>, <kvm@vger.kernel.org>,
        <linuxarm@huawei.com>, David Box <david.e.box@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        "Li, Ming" <ming4.li@intel.com>, Zhi Wang <zhi.a.wang@intel.com>,
        Alistair Francis <alistair.francis@wdc.com>,
        Wilfred Mallawa <wilfred.mallawa@wdc.com>,
        Alexey Kardashevskiy <aik@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Sean Christopherson <seanjc@google.com>,
        Alexander Graf <graf@amazon.com>
Subject: Re: [PATCH 11/12] PCI/CMA: Expose in sysfs whether devices are
 authenticated
Message-ID: <20231003162832.0000317c@Huawei.com>
In-Reply-To: <821682573e57e0384162f365652171e5ee1e6611.1695921657.git.lukas@wunner.de>
References: <cover.1695921656.git.lukas@wunner.de>
        <821682573e57e0384162f365652171e5ee1e6611.1695921657.git.lukas@wunner.de>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.227.76]
X-ClientProxiedBy: lhrpeml100003.china.huawei.com (7.191.160.210) To
 lhrpeml500005.china.huawei.com (7.191.163.240)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 28 Sep 2023 19:32:41 +0200
Lukas Wunner <lukas@wunner.de> wrote:

> The PCI core has just been amended to authenticate CMA-capable devices
> on enumeration and store the result in an "authenticated" bit in struct
> pci_dev->spdm_state.
> 
> Expose the bit to user space through an eponymous sysfs attribute.
> 
> Allow user space to trigger reauthentication (e.g. after it has updated
> the CMA keyring) by writing to the sysfs attribute.

Ah.  That answers the question I asked in previous patch review ;)
Maybe add a comment to the cma_init code to say that's why it fails with
side effects (leaves the spdm_state around).

> 
> Subject to further discussion, a future commit might add a user-defined
> policy to forbid driver binding to devices which failed authentication,
> similar to the "authorized" attribute for USB.
> 
> Alternatively, authentication success might be signaled to user space
> through a uevent, whereupon it may bind a (blacklisted) driver.
> A uevent signaling authentication failure might similarly cause user
> space to unbind or outright remove the potentially malicious device.
> 
> Traffic from devices which failed authentication could also be filtered
> through ACS I/O Request Blocking Enable (PCIe r6.1 sec 7.7.11.3) or
> through Link Disable (PCIe r6.1 sec 7.5.3.7).  Unlike an IOMMU, that
> will not only protect the host, but also prevent malicious peer-to-peer
> traffic to other devices.
> 
> Signed-off-by: Lukas Wunner <lukas@wunner.de>
Seems good to me, though I agree with Ilpo that it would be good to mention
the DOE init fail in the patch description as that's a bit subtle.

One trivial comment inline.

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
 
> ---
>  Documentation/ABI/testing/sysfs-bus-pci | 27 +++++++++
>  drivers/pci/Kconfig                     |  3 +
>  drivers/pci/Makefile                    |  1 +
>  drivers/pci/cma-sysfs.c                 | 73 +++++++++++++++++++++++++
>  drivers/pci/cma.c                       |  2 +
>  drivers/pci/doe.c                       |  2 +
>  drivers/pci/pci-sysfs.c                 |  3 +
>  drivers/pci/pci.h                       |  1 +
>  include/linux/pci.h                     |  2 +
>  9 files changed, 114 insertions(+)
>  create mode 100644 drivers/pci/cma-sysfs.c
> 
> diff --git a/Documentation/ABI/testing/sysfs-bus-pci b/Documentation/ABI/testing/sysfs-bus-pci
> index ecf47559f495..2ea9b8deffcc 100644
> --- a/Documentation/ABI/testing/sysfs-bus-pci
> +++ b/Documentation/ABI/testing/sysfs-bus-pci
> @@ -500,3 +500,30 @@ Description:
>  		console drivers from the device.  Raw users of pci-sysfs
>  		resourceN attributes must be terminated prior to resizing.
>  		Success of the resizing operation is not guaranteed.
> +
> +What:		/sys/bus/pci/devices/.../authenticated
> +Date:		September 2023
> +Contact:	Lukas Wunner <lukas@wunner.de>
> +Description:
> +		This file contains 1 if the device authenticated successfully
> +		with CMA-SPDM (PCIe r6.1 sec 6.31).  It contains 0 if the
> +		device failed authentication (and may thus be malicious).
> +
> +		Writing anything to this file causes reauthentication.
> +		That may be opportune after updating the .cma keyring.
> +
> +		The file is not visible if authentication is unsupported
> +		by the device.
> +
> +		If the kernel could not determine whether authentication is
> +		supported because memory was low or DOE communication with
> +		the device was not working, the file is visible but accessing
> +		it fails with error code ENOTTY.
> +
> +		This prevents downgrade attacks where an attacker consumes
> +		memory or disturbs DOE communication in order to create the
> +		appearance that a device does not support authentication.
> +
> +		The reason why authentication support could not be determined
> +		is apparent from "dmesg".  To probe for authentication support
> +		again, exercise the "remove" and "rescan" attributes.
> diff --git a/drivers/pci/Kconfig b/drivers/pci/Kconfig
> index c9aa5253ac1f..51df3be3438e 100644
> --- a/drivers/pci/Kconfig
> +++ b/drivers/pci/Kconfig
> @@ -129,6 +129,9 @@ config PCI_CMA
>  	  A PCI DOE mailbox is used as transport for DMTF SPDM based
>  	  attestation, measurement and secure channel establishment.
>  
> +config PCI_CMA_SYSFS
> +	def_bool PCI_CMA && SYSFS
> +
>  config PCI_DOE
>  	bool
>  
> diff --git a/drivers/pci/Makefile b/drivers/pci/Makefile
> index a18812b8832b..612ae724cd2d 100644
> --- a/drivers/pci/Makefile
> +++ b/drivers/pci/Makefile
> @@ -35,6 +35,7 @@ obj-$(CONFIG_PCI_DOE)		+= doe.o
>  obj-$(CONFIG_PCI_DYNAMIC_OF_NODES) += of_property.o
>  
>  obj-$(CONFIG_PCI_CMA)		+= cma.o cma-x509.o cma.asn1.o
> +obj-$(CONFIG_PCI_CMA_SYSFS)	+= cma-sysfs.o
>  $(obj)/cma-x509.o:		$(obj)/cma.asn1.h
>  $(obj)/cma.asn1.o:		$(obj)/cma.asn1.c $(obj)/cma.asn1.h
>  
> diff --git a/drivers/pci/cma-sysfs.c b/drivers/pci/cma-sysfs.c
> new file mode 100644
> index 000000000000..b2d45f96601a
> --- /dev/null
> +++ b/drivers/pci/cma-sysfs.c
> @@ -0,0 +1,73 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Component Measurement and Authentication (CMA-SPDM, PCIe r6.1 sec 6.31)
> + *
> + * Copyright (C) 2023 Intel Corporation
> + */
> +
> +#include <linux/pci.h>
> +#include <linux/spdm.h>
> +#include <linux/sysfs.h>
> +
> +#include "pci.h"
> +
> +static ssize_t authenticated_store(struct device *dev,
> +				   struct device_attribute *attr,
> +				   const char *buf, size_t count)
> +{
> +	struct pci_dev *pdev = to_pci_dev(dev);
> +	ssize_t rc;
> +
> +	if (!pdev->cma_capable &&
> +	    (pdev->cma_init_failed || pdev->doe_init_failed))
> +		return -ENOTTY;
> +
> +	rc = pci_cma_reauthenticate(pdev);
> +	if (rc)
> +		return rc;

> +
> +	return count;
> +}
> +
> +static ssize_t authenticated_show(struct device *dev,
> +				  struct device_attribute *attr, char *buf)
> +{
> +	struct pci_dev *pdev = to_pci_dev(dev);
> +
> +	if (!pdev->cma_capable &&
> +	    (pdev->cma_init_failed || pdev->doe_init_failed))
> +		return -ENOTTY;
> +
> +	return sysfs_emit(buf, "%u\n", spdm_authenticated(pdev->spdm_state));
> +}
> +static DEVICE_ATTR_RW(authenticated);
> +
> +static struct attribute *pci_cma_attrs[] = {
> +	&dev_attr_authenticated.attr,
> +	NULL
> +};
> +
> +static umode_t pci_cma_attrs_are_visible(struct kobject *kobj,
> +					 struct attribute *a, int n)
> +{
> +	struct device *dev = kobj_to_dev(kobj);
> +	struct pci_dev *pdev = to_pci_dev(dev);
> +
> +	/*
> +	 * If CMA or DOE initialization failed, CMA attributes must be visible
> +	 * and return an error on access.  This prevents downgrade attacks
> +	 * where an attacker disturbs memory allocation or DOE communication
> +	 * in order to create the appearance that CMA is unsupported.
> +	 * The attacker may achieve that by simply hogging memory.
> +	 */
> +	if (!pdev->cma_capable &&
> +	    !pdev->cma_init_failed && !pdev->doe_init_failed)
> +		return 0;
> +
> +	return a->mode;
> +}
> +
> +const struct attribute_group pci_cma_attr_group = {
> +	.attrs  = pci_cma_attrs,

I'd go with a single space here as the double doesn't make
it any more readable.


> +	.is_visible = pci_cma_attrs_are_visible,
> +};


