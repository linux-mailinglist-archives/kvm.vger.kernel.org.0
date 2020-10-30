Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 015462A1011
	for <lists+kvm@lfdr.de>; Fri, 30 Oct 2020 22:20:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727774AbgJ3VUI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Oct 2020 17:20:08 -0400
Received: from mga07.intel.com ([134.134.136.100]:33019 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727553AbgJ3VUI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Oct 2020 17:20:08 -0400
IronPort-SDR: Rr/6G2ZR4DNMRj+iiTdk7a7+mG71Wu9Pz1lsPM+amJ3XZhNwZ7caWsfiSbrer/BONFBI8/lNCm
 xamyT8PFEPNQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9790"; a="232845598"
X-IronPort-AV: E=Sophos;i="5.77,434,1596524400"; 
   d="scan'208";a="232845598"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2020 14:20:06 -0700
IronPort-SDR: 9QpnhJuIA3FJHuuyiiVsBkpGsSwgW37Ldc5KVjh2D7WaLeKdTKnjl4JPDiQfIVVjMrX5YMkwaQ
 OqGwU26Tpp2g==
X-IronPort-AV: E=Sophos;i="5.77,434,1596524400"; 
   d="scan'208";a="362561327"
Received: from djiang5-mobl1.amr.corp.intel.com (HELO [10.209.46.60]) ([10.209.46.60])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2020 14:20:05 -0700
Subject: Re: [PATCH v4 06/17] PCI: add SIOV and IMS capability detection
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     vkoul@kernel.org, megha.dey@intel.com, maz@kernel.org,
        bhelgaas@google.com, tglx@linutronix.de,
        alex.williamson@redhat.com, jacob.jun.pan@intel.com,
        ashok.raj@intel.com, jgg@mellanox.com, yi.l.liu@intel.com,
        baolu.lu@intel.com, kevin.tian@intel.com, sanjay.k.kumar@intel.com,
        tony.luck@intel.com, jing.lin@intel.com, dan.j.williams@intel.com,
        kwankhede@nvidia.com, eric.auger@redhat.com, parav@mellanox.com,
        rafael@kernel.org, netanelg@mellanox.com, shahafs@mellanox.com,
        yan.y.zhao@linux.intel.com, pbonzini@redhat.com,
        samuel.ortiz@intel.com, mona.hossain@intel.com,
        dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, kvm@vger.kernel.org
References: <20201030195159.GA589138@bjorn-Precision-5520>
From:   Dave Jiang <dave.jiang@intel.com>
Message-ID: <71da5f66-e929-bab1-a1c6-a9ac9627a141@intel.com>
Date:   Fri, 30 Oct 2020 14:20:03 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201030195159.GA589138@bjorn-Precision-5520>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 10/30/2020 12:51 PM, Bjorn Helgaas wrote:
> On Fri, Oct 30, 2020 at 11:51:32AM -0700, Dave Jiang wrote:
>> Intel Scalable I/O Virtualization (SIOV) enables sharing of I/O devices
>> across isolated domains through PASID based sub-device partitioning.
>> Interrupt Message Storage (IMS) enables devices to store the interrupt
>> messages in a device-specific optimized manner without the scalability
>> restrictions of the PCIe defined MSI-X capability. IMS is one of the
>> features supported under SIOV.
>>
>> Move SIOV detection code from Intel iommu driver code to common PCI. Making
>> the detection code common allows supported accelerator drivers to query the
>> PCI core for SIOV and IMS capabilities. The support code will add the
>> ability to query the PCI DVSEC capabilities for the SIOV cap.
> 
> This patch really does not include anything related to SIOV other than
> adding a little code to *find* the capability.  It doesn't add
> anything that actually *uses* it.  I think this patch should simply
> add pci_find_dvsec(), and it doesn't need any of this SIOV or IMS
> description.
> 

Thanks for the review Bjorn! I'll carve out a patch with just find_dvsec() and 
apply your comments and recommendations.

So the intel-iommu driver checks for the SIOV cap. And the idxd driver checks 
for SIOV and IMS cap. There will be other upcoming drivers that will check for 
such cap too. It is Intel vendor specific right now, but SIOV is public and 
other vendors may implement to the spec. Is there a good place to put the common 
capability check for that?

There are some other fields in the SIOV dvsec cap, but presently they are not 
being utilized. The idxd driver is only interested in making sure that SIOV and 
IMS (sub feature) support are present at this point.

- Dave

>> Suggested-by: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Baolu Lu <baolu.lu@intel.com>
>> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
>> Reviewed-by: Ashok Raj <ashok.raj@intel.com>
>> ---
>>   drivers/iommu/intel/iommu.c   |   31 ++-----------------------
>>   drivers/pci/Kconfig           |   15 ++++++++++++
>>   drivers/pci/Makefile          |    2 ++
>>   drivers/pci/dvsec.c           |   40 +++++++++++++++++++++++++++++++++
>>   drivers/pci/siov.c            |   50 +++++++++++++++++++++++++++++++++++++++++
>>   include/linux/pci-siov.h      |   18 +++++++++++++++
>>   include/linux/pci.h           |    3 ++
>>   include/uapi/linux/pci_regs.h |    4 +++
>>   8 files changed, 134 insertions(+), 29 deletions(-)
>>   create mode 100644 drivers/pci/dvsec.c
>>   create mode 100644 drivers/pci/siov.c
>>   create mode 100644 include/linux/pci-siov.h
>>
>> diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
>> index 3e77a88b236c..d9335f590b42 100644
>> --- a/drivers/iommu/intel/iommu.c
>> +++ b/drivers/iommu/intel/iommu.c
>> @@ -36,6 +36,7 @@
>>   #include <linux/tboot.h>
>>   #include <linux/dmi.h>
>>   #include <linux/pci-ats.h>
>> +#include <linux/pci-siov.h>
>>   #include <linux/memblock.h>
>>   #include <linux/dma-map-ops.h>
>>   #include <linux/dma-direct.h>
>> @@ -5883,34 +5884,6 @@ static int intel_iommu_disable_auxd(struct device *dev)
>>   	return 0;
>>   }
>>   
>> -/*
>> - * A PCI express designated vendor specific extended capability is defined
>> - * in the section 3.7 of Intel scalable I/O virtualization technical spec
>> - * for system software and tools to detect endpoint devices supporting the
>> - * Intel scalable IO virtualization without host driver dependency.
>> - *
>> - * Returns the address of the matching extended capability structure within
>> - * the device's PCI configuration space or 0 if the device does not support
>> - * it.
>> - */
>> -static int siov_find_pci_dvsec(struct pci_dev *pdev)
>> -{
>> -	int pos;
>> -	u16 vendor, id;
>> -
>> -	pos = pci_find_next_ext_capability(pdev, 0, 0x23);
>> -	while (pos) {
>> -		pci_read_config_word(pdev, pos + 4, &vendor);
>> -		pci_read_config_word(pdev, pos + 8, &id);
>> -		if (vendor == PCI_VENDOR_ID_INTEL && id == 5)
>> -			return pos;
>> -
>> -		pos = pci_find_next_ext_capability(pdev, pos, 0x23);
>> -	}
>> -
>> -	return 0;
>> -}
>> -
>>   static bool
>>   intel_iommu_dev_has_feat(struct device *dev, enum iommu_dev_features feat)
>>   {
>> @@ -5925,7 +5898,7 @@ intel_iommu_dev_has_feat(struct device *dev, enum iommu_dev_features feat)
>>   		if (ret < 0)
>>   			return false;
>>   
>> -		return !!siov_find_pci_dvsec(to_pci_dev(dev));
>> +		return pci_siov_supported(to_pci_dev(dev));
>>   	}
>>   
>>   	if (feat == IOMMU_DEV_FEAT_SVA) {
>> diff --git a/drivers/pci/Kconfig b/drivers/pci/Kconfig
>> index 0c473d75e625..cf7f4d17d8cc 100644
>> --- a/drivers/pci/Kconfig
>> +++ b/drivers/pci/Kconfig
>> @@ -161,6 +161,21 @@ config PCI_PASID
>>   
>>   	  If unsure, say N.
>>   
>> +config PCI_DVSEC
>> +	bool
>> +
>> +config PCI_SIOV
>> +	select PCI_PASID
> 
> This patch has nothing to do with PCI_PASID.  If you want to add this
> select later in a patch that *does* add something that requires
> PCI_PASID, that's OK.
> 
>> +	select PCI_DVSEC
>> +	bool "PCI SIOV support"
>> +	help
>> +	  Scalable I/O Virtualzation enables sharing of I/O devices across isolated
>> +	  domains through PASID based sub-device partitioning. One of the sub features
>> +	  supported by SIOV is Inetrrupt Message Storage (IMS). Select this option if
>> +	  you want to compile the support into your kernel.
>> +	  If unsure, say N.
>> +
>>   config PCI_P2PDMA
>>   	bool "PCI peer-to-peer transfer support"
>>   	depends on ZONE_DEVICE
>> diff --git a/drivers/pci/Makefile b/drivers/pci/Makefile
>> index 522d2b974e91..653a1d69b0fc 100644
>> --- a/drivers/pci/Makefile
>> +++ b/drivers/pci/Makefile
>> @@ -20,6 +20,8 @@ obj-$(CONFIG_PCI_QUIRKS)	+= quirks.o
>>   obj-$(CONFIG_HOTPLUG_PCI)	+= hotplug/
>>   obj-$(CONFIG_PCI_MSI)		+= msi.o
>>   obj-$(CONFIG_PCI_ATS)		+= ats.o
>> +obj-$(CONFIG_PCI_DVSEC)		+= dvsec.o
>> +obj-$(CONFIG_PCI_SIOV)		+= siov.o
>>   obj-$(CONFIG_PCI_IOV)		+= iov.o
>>   obj-$(CONFIG_PCI_BRIDGE_EMUL)	+= pci-bridge-emul.o
>>   obj-$(CONFIG_PCI_LABEL)		+= pci-label.o
>> diff --git a/drivers/pci/dvsec.c b/drivers/pci/dvsec.c
>> new file mode 100644
>> index 000000000000..e49b079f0717
>> --- /dev/null
>> +++ b/drivers/pci/dvsec.c
>> @@ -0,0 +1,40 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/*
>> + * PCI DVSEC helper functions
>> + * Copyright (C) 2020 Intel Corp.
>> + */
>> +
>> +#include <linux/export.h>
>> +#include <linux/pci.h>
>> +#include <uapi/linux/pci_regs.h>
>> +#include "pci.h"
>> +
>> +/**
>> + * pci_find_dvsec - return position of DVSEC with provided vendor and dvsec id
>> + * @dev: the PCI device
>> + * @vendor: Vendor for the DVSEC
>> + * @id: the DVSEC cap id
>> + *
>> + * Return the offset of DVSEC on success or -ENOTSUPP if not found
> 
> s/vendor/Vendor/
> s/dvsec/DVSEC/
> s/id/ID/ twice above
> 
> Please put this function in drivers/pci/pci.c next to
> pci_find_ext_capability().  I don't think it's worth making a new file
> just for this.
> 
>> + */
>> +int pci_find_dvsec(struct pci_dev *dev, u16 vendor, u16 id)
>> +{
>> +	u16 dev_vendor, dev_id;
>> +	int pos;
>> +
>> +	pos = pci_find_ext_capability(dev, PCI_EXT_CAP_ID_DVSEC);
>> +	if (!pos)
>> +		return -ENOTSUPP;
>> +
>> +	while (pos) {
>> +		pci_read_config_word(dev, pos + PCI_DVSEC_HEADER1, &dev_vendor);
>> +		pci_read_config_word(dev, pos + PCI_DVSEC_HEADER2, &dev_id);
>> +		if (dev_vendor == vendor && dev_id == id)
>> +			return pos;
>> +
>> +		pos = pci_find_next_ext_capability(dev, pos, PCI_EXT_CAP_ID_DVSEC);
>> +	}
>> +
>> +	return -ENOTSUPP;
>> +}
>> +EXPORT_SYMBOL_GPL(pci_find_dvsec);
>> diff --git a/drivers/pci/siov.c b/drivers/pci/siov.c
>> new file mode 100644
>> index 000000000000..6147e6ae5832
>> --- /dev/null
>> +++ b/drivers/pci/siov.c
>> @@ -0,0 +1,50 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/*
>> + * Intel Scalable I/O Virtualization support
>> + * Copyright (C) 2020 Intel Corp.
>> + */
>> +
>> +#include <linux/export.h>
>> +#include <linux/pci.h>
>> +#include <linux/pci-siov.h>
>> +#include <uapi/linux/pci_regs.h>
>> +#include "pci.h"
>> +
>> +/*
>> + * A PCI express designated vendor specific extended capability is defined
>> + * in the section 3.7 of Intel scalable I/O virtualization technical spec
>> + * for system software and tools to detect endpoint devices supporting the
>> + * Intel scalable IO virtualization without host driver dependency.
>> + */
>> +
>> +/**
>> + * pci_siov_supported - check if the device can use SIOV
>> + * @dev: the PCI device
>> + *
>> + * Returns true if the device supports SIOV,  false otherwise.
>> + */
>> +bool pci_siov_supported(struct pci_dev *dev)
>> +{
>> +	return pci_find_dvsec(dev, PCI_VENDOR_ID_INTEL, PCI_DVSEC_ID_INTEL_SIOV) < 0 ? false : true;
>> +}
>> +EXPORT_SYMBOL_GPL(pci_siov_supported);
>> +
>> +/**
>> + * pci_ims_supported - check if the device can use IMS
>> + * @dev: the PCI device
>> + *
>> + * Returns true if the device supports IMS, false otherwise.
>> + */
>> +bool pci_ims_supported(struct pci_dev *dev)
>> +{
>> +	int pos;
>> +	u32 caps;
>> +
>> +	pos = pci_find_dvsec(dev, PCI_VENDOR_ID_INTEL, PCI_DVSEC_ID_INTEL_SIOV);
>> +	if (pos < 0)
>> +		return false;
>> +
>> +	pci_read_config_dword(dev, pos + PCI_DVSEC_INTEL_SIOV_CAP, &caps);
>> +	return (caps & PCI_DVSEC_INTEL_SIOV_CAP_IMS) ? true : false;
>> +}
>> +EXPORT_SYMBOL_GPL(pci_ims_supported);
> 
> I don't really see the point of these *_supported() functions.  If the
> caller wants to use them, I would expect it to call
> pci_find_dvsec(PCI_DVSEC_ID_INTEL_SIOV) itself anyway.
> 
> But there *are* no calls to pci_find_dvsec(PCI_DVSEC_ID_INTEL_SIOV).
> So apparently all you care about is whether the capability *exists*,
> and you don't need any information at all from the capability
> registers except PCI_DVSEC_INTEL_SIOV_CAP_IMS?  That seems a little
> weird.
> 
> I don't think it's worth adding a whole new file just for this.  The
> only value the PCI core is adding here is a way to locate the
> PCI_DVSEC_ID_INTEL_SIOV capability.
> 
>> diff --git a/include/linux/pci-siov.h b/include/linux/pci-siov.h
>> new file mode 100644
>> index 000000000000..a8a4eb5f4634
>> --- /dev/null
>> +++ b/include/linux/pci-siov.h
>> @@ -0,0 +1,18 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +#ifndef LINUX_PCI_SIOV_H
>> +#define LINUX_PCI_SIOV_H
>> +
>> +#include <linux/pci.h>
>> +
>> +#ifdef CONFIG_PCI_SIOV
>> +/* Scalable I/O Virtualization */
>> +bool pci_siov_supported(struct pci_dev *dev);
>> +bool pci_ims_supported(struct pci_dev *dev);
>> +#else /* CONFIG_PCI_SIOV */
>> +static inline bool pci_siov_supported(struct pci_dev *d)
>> +{ return false; }
>> +static inline bool pci_ims_supported(struct pci_dev *d)
>> +{ return false; }
>> +#endif /* CONFIG_PCI_SIOV */
>> +
>> +#endif /* LINUX_PCI_SIOV_H */
> 
> What's the benefit to putting these declarations in a separate
> pci-siov.h as opposed to putting them in pci.h itself?  That's what we
> do for things like MSI, IOV, etc.
> 
>> diff --git a/include/linux/pci.h b/include/linux/pci.h
>> index 22207a79762c..4710f09b43b1 100644
>> --- a/include/linux/pci.h
>> +++ b/include/linux/pci.h
>> @@ -1070,6 +1070,7 @@ int pci_find_next_ext_capability(struct pci_dev *dev, int pos, int cap);
>>   int pci_find_ht_capability(struct pci_dev *dev, int ht_cap);
>>   int pci_find_next_ht_capability(struct pci_dev *dev, int pos, int ht_cap);
>>   struct pci_bus *pci_find_next_bus(const struct pci_bus *from);
>> +int pci_find_dvsec(struct pci_dev *dev, u16 vendor, u16 id);
>>   
>>   u64 pci_get_dsn(struct pci_dev *dev);
>>   
>> @@ -1726,6 +1727,8 @@ static inline int pci_find_next_capability(struct pci_dev *dev, u8 post,
>>   { return 0; }
>>   static inline int pci_find_ext_capability(struct pci_dev *dev, int cap)
>>   { return 0; }
>> +static inline int pci_find_dvsec(struct pci_dev *dev, u16 vendor, u16 id)
>> +{ return 0; }
>>   
>>   static inline u64 pci_get_dsn(struct pci_dev *dev)
>>   { return 0; }
>> diff --git a/include/uapi/linux/pci_regs.h b/include/uapi/linux/pci_regs.h
>> index 8f8bd2318c6c..3532528441ef 100644
>> --- a/include/uapi/linux/pci_regs.h
>> +++ b/include/uapi/linux/pci_regs.h
>> @@ -1071,6 +1071,10 @@
>>   #define PCI_DVSEC_HEADER1		0x4 /* Designated Vendor-Specific Header1 */
>>   #define PCI_DVSEC_HEADER2		0x8 /* Designated Vendor-Specific Header2 */
>>   
>> +#define PCI_DVSEC_ID_INTEL_SIOV		0x5
>> +#define PCI_DVSEC_INTEL_SIOV_CAP	0x14
>> +#define PCI_DVSEC_INTEL_SIOV_CAP_IMS	0x1
> 
> Convention in this file is to write constants in the register width,
> e.g.,
> 
>    #define PCI_DVSEC_ID_INTEL_SIOV		0x0005
>    #define PCI_DVSEC_INTEL_SIOV_CAP_IMS	0x00000001
> 
> You can learn this by looking at the surrounding definitions.
> 
>>   /* Data Link Feature */
>>   #define PCI_DLF_CAP		0x04	/* Capabilities Register */
>>   #define  PCI_DLF_EXCHANGE_ENABLE	0x80000000  /* Data Link Feature Exchange Enable */
>>
>>
