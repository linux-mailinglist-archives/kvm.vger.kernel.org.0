Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E0003EE16D
	for <lists+kvm@lfdr.de>; Tue, 17 Aug 2021 02:40:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235365AbhHQAlY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Aug 2021 20:41:24 -0400
Received: from mga06.intel.com ([134.134.136.31]:32785 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232973AbhHQAlY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Aug 2021 20:41:24 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10078"; a="276997838"
X-IronPort-AV: E=Sophos;i="5.84,327,1620716400"; 
   d="scan'208";a="276997838"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2021 17:40:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,327,1620716400"; 
   d="scan'208";a="520149985"
Received: from unknown (HELO coxu-arch-shz) ([10.239.160.21])
  by FMSMGA003.fm.intel.com with ESMTP; 16 Aug 2021 17:40:49 -0700
Date:   Tue, 17 Aug 2021 08:40:48 +0800 (CST)
From:   Colin Xu <colin.xu@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
cc:     Colin Xu <colin.xu@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, zhenyuw@linux.intel.com,
        hang.yuan@linux.intel.com, swee.yee.fonn@intel.com,
        fred.gao@intel.com
Subject: Re: [PATCH] vfio/pci: Add OpRegion 2.0 Extended VBT support.
In-Reply-To: <20210816163958.04ab019c.alex.williamson@redhat.com>
Message-ID: <9dc7eba-2c49-8d40-46b-5f4382a25c1e@outlook.office365.com>
References: <20210813021329.128543-1-colin.xu@intel.com> <20210816163958.04ab019c.alex.williamson@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 16 Aug 2021, Alex Williamson wrote:

> On Fri, 13 Aug 2021 10:13:29 +0800
> Colin Xu <colin.xu@intel.com> wrote:
>
>> Due to historical reason, some legacy shipped system doesn't follow
>> OpRegion 2.1 spec but still stick to OpRegion 2.0, in which the extended
>> VBT is not contigious after OpRegion in physical address, but any
>> location pointed by RVDA via absolute address. Thus it's impossible
>> to map a contigious range to hold both OpRegion and extended VBT as 2.1.
>>
>> Since the only difference between OpRegion 2.0 and 2.1 is where extended
>> VBT is stored: For 2.0, RVDA is the absolute address of extended VBT
>> while for 2.1, RVDA is the relative address of extended VBT to OpRegion
>> baes, and there is no other difference between OpRegion 2.0 and 2.1,
>> it's feasible to amend OpRegion support for these legacy system (before
>> upgrading the system firmware), by kazlloc a range to shadown OpRegion
>> from the beginning and stitch VBT after closely, patch the shadow
>> OpRegion version from 2.0 to 2.1, and patch the shadow RVDA to relative
>> address. So that from the vfio igd OpRegion r/w ops view, only OpRegion
>> 2.1 is exposed regardless the underneath host OpRegion is 2.0 or 2.1
>> if the extended VBT exists. vfio igd OpRegion r/w ops will return either
>> shadowed data (OpRegion 2.0) or directly from physical address
>> (OpRegion 2.1+) based on host OpRegion version and RVDA/RVDS. The shadow
>> mechanism makes it possible to support legacy systems on the market.
>
> Which systems does this enable?  There's a suggestion above that these
> systems could update firmware to get OpRegion v2.1 support, why
> shouldn't we ask users to do that instead?  When we added OpRegion v2.1
> support we were told that v2.0 support was essentially non-existent,
> why should we add code to support and old spec with few users for such
> a niche use case?
Hi Alex, there was some mis-alignment with the BIOS owner that we were 
told the 2.0 system doesn't for retail but only for internal development. 
However in other projects we DO see the retail market has such systems, 
including NUC NUC6CAYB, some APL industrial PC used in RT system, and some 
customized APL motherboard by commercial virtualization solution. We 
immediately contact the BIOS owner to ask for a clarification and they 
admit it. These system won't get updated BIOS for OpRegion update but 
still under warranty. That's why the OpRegion 2.0 support is still needed.

>
>> Cc: Zhenyu Wang <zhenyuw@linux.intel.com>
>> Cc: Hang Yuan <hang.yuan@linux.intel.com>
>> Cc: Swee Yee Fonn <swee.yee.fonn@intel.com>
>> Cc: Fred Gao <fred.gao@intel.com>
>> Signed-off-by: Colin Xu <colin.xu@intel.com>
>> ---
>>  drivers/vfio/pci/vfio_pci_igd.c | 117 ++++++++++++++++++++------------
>>  1 file changed, 75 insertions(+), 42 deletions(-)
>>
>> diff --git a/drivers/vfio/pci/vfio_pci_igd.c b/drivers/vfio/pci/vfio_pci_igd.c
>> index 228df565e9bc..22b9436a3044 100644
>> --- a/drivers/vfio/pci/vfio_pci_igd.c
>> +++ b/drivers/vfio/pci/vfio_pci_igd.c
>> @@ -48,7 +48,10 @@ static size_t vfio_pci_igd_rw(struct vfio_pci_device *vdev, char __user *buf,
>>  static void vfio_pci_igd_release(struct vfio_pci_device *vdev,
>>  				 struct vfio_pci_region *region)
>>  {
>> -	memunmap(region->data);
>> +	if (is_ioremap_addr(region->data))
>> +		memunmap(region->data);
>> +	else
>> +		kfree(region->data);
>>  }
>>
>>  static const struct vfio_pci_regops vfio_pci_igd_regops = {
>> @@ -59,10 +62,11 @@ static const struct vfio_pci_regops vfio_pci_igd_regops = {
>>  static int vfio_pci_igd_opregion_init(struct vfio_pci_device *vdev)
>>  {
>>  	__le32 *dwordp = (__le32 *)(vdev->vconfig + OPREGION_PCI_ADDR);
>> -	u32 addr, size;
>> -	void *base;
>> +	u32 addr, size, rvds = 0;
>> +	void *base, *opregionvbt;
>>  	int ret;
>>  	u16 version;
>> +	u64 rvda = 0;
>>
>>  	ret = pci_read_config_dword(vdev->pdev, OPREGION_PCI_ADDR, &addr);
>>  	if (ret)
>> @@ -89,66 +93,95 @@ static int vfio_pci_igd_opregion_init(struct vfio_pci_device *vdev)
>>  	size *= 1024; /* In KB */
>>
>>  	/*
>> -	 * Support opregion v2.1+
>> -	 * When VBT data exceeds 6KB size and cannot be within mailbox #4, then
>> -	 * the Extended VBT region next to opregion is used to hold the VBT data.
>> -	 * RVDA (Relative Address of VBT Data from Opregion Base) and RVDS
>> -	 * (Raw VBT Data Size) from opregion structure member are used to hold the
>> -	 * address from region base and size of VBT data. RVDA/RVDS are not
>> -	 * defined before opregion 2.0.
>> +	 * OpRegion and VBT:
>> +	 * When VBT data doesn't exceed 6KB, it's stored in Mailbox #4.
>> +	 * When VBT data exceeds 6KB size, Mailbox #4 is no longer large enough
>> +	 * to hold the VBT data, the Extended VBT region is introduced since
>> +	 * OpRegion 2.0 to hold the VBT data. Since OpRegion 2.0, RVDA/RVDS are
>> +	 * introduced to define the extended VBT data location and size.
>> +	 * OpRegion 2.0: RVDA defines the absolute physical address of the
>> +	 *   extended VBT data, RVDS defines the VBT data size.
>> +	 * OpRegion 2.1 and above: RVDA defines the relative address of the
>> +	 *   extended VBT data to OpRegion base, RVDS defines the VBT data size.
>>  	 *
>> -	 * opregion 2.1+: RVDA is unsigned, relative offset from
>> -	 * opregion base, and should point to the end of opregion.
>> -	 * otherwise, exposing to userspace to allow read access to everything between
>> -	 * the OpRegion and VBT is not safe.
>> -	 * RVDS is defined as size in bytes.
>> -	 *
>> -	 * opregion 2.0: rvda is the physical VBT address.
>> -	 * Since rvda is HPA it cannot be directly used in guest.
>> -	 * And it should not be practically available for end user,so it is not supported.
>> +	 * Due to the RVDA difference in OpRegion VBT (also the only diff between
>> +	 * 2.0 and 2.1), while for OpRegion 2.1 and above it's possible to map
>> +	 * a contigious memory to expose OpRegion and VBT r/w via the vfio
>> +	 * region, for OpRegion 2.0 shadow and amendment mechanism is used to
>> +	 * expose OpRegion and VBT r/w properly. So that from r/w ops view, only
>> +	 * OpRegion 2.1 is exposed regardless underneath Region is 2.0 or 2.1.
>>  	 */
>>  	version = le16_to_cpu(*(__le16 *)(base + OPREGION_VERSION));
>> -	if (version >= 0x0200) {
>> -		u64 rvda;
>> -		u32 rvds;
>>
>> +	if (version >= 0x0200) {
>>  		rvda = le64_to_cpu(*(__le64 *)(base + OPREGION_RVDA));
>>  		rvds = le32_to_cpu(*(__le32 *)(base + OPREGION_RVDS));
>> +
>> +		/* The extended VBT is valid only when RVDA/RVDS are non-zero. */
>>  		if (rvda && rvds) {
>> -			/* no support for opregion v2.0 with physical VBT address */
>> -			if (version == 0x0200) {
>> +			size += rvds;
>> +		}
>> +
>> +		/* The extended VBT must follows OpRegion for OpRegion 2.1+ */
>> +		if (rvda != size && version > 0x0200) {
>
> But we already added rvds to size, this is not compatible with the
> previous code that required rvda == size BEFORE adding rvds.
>
>> +			memunmap(base);
>> +			pci_err(vdev->pdev,
>> +				"Extended VBT does not follow opregion on version 0x%04x\n",
>> +				version);
>> +			return -EINVAL;
>> +		}
>> +	}
>> +
>> +	if (size != OPREGION_SIZE) {
>> +		/* Allocate memory for OpRegion and extended VBT for 2.0 */
>> +		if (rvda && rvds && version == 0x0200) {
>> +			void *vbt_base;
>> +
>> +			vbt_base = memremap(rvda, rvds, MEMREMAP_WB);
>> +			if (!vbt_base) {
>>  				memunmap(base);
>> -				pci_err(vdev->pdev,
>> -					"IGD assignment does not support opregion v2.0 with an extended VBT region\n");
>> -				return -EINVAL;
>> +				return -ENOMEM;
>>  			}
>>
>> -			if (rvda != size) {
>> +			opregionvbt = kzalloc(size, GFP_KERNEL);
>> +			if (!opregionvbt) {
>>  				memunmap(base);
>> -				pci_err(vdev->pdev,
>> -					"Extended VBT does not follow opregion on version 0x%04x\n",
>> -					version);
>> -				return -EINVAL;
>> +				memunmap(vbt_base);
>> +				return -ENOMEM;
>>  			}
>>
>> -			/* region size for opregion v2.0+: opregion and VBT size. */
>> -			size += rvds;
>> +			/* Stitch VBT after OpRegion noncontigious */
>> +			memcpy(opregionvbt, base, OPREGION_SIZE);
>> +			memcpy(opregionvbt + OPREGION_SIZE, vbt_base, rvds);
>> +
>> +			/* Patch OpRegion 2.0 to 2.1 */
>> +			*(__le16 *)(opregionvbt + OPREGION_VERSION) = 0x0201;
>> +			/* Patch RVDA to relative address after OpRegion */
>> +			*(__le64 *)(opregionvbt + OPREGION_RVDA) = OPREGION_SIZE;
>
> AIUI, the OpRegion is a two-way channel between the IGD device/system
> BIOS and the driver, numerous fields are writable by the driver.  Now
> the driver writes to a shadow copy of the OpRegion table.  What
> completes the write to the real OpRegion table for consumption by the
> device/BIOS?  Likewise, what updates the fields that are written by the
> device/BIOS for consumption by the driver?
>
> If a shadow copy of the OpRegion detached from the physical table is
> sufficient here, why wouldn't we always shadow the OpRegion and prevent
> all userspace writes from touching the real version?  Thanks,
>
> Alex
>
>> +
>> +			memunmap(vbt_base);
>> +			memunmap(base);
>> +
>> +			/* Register shadow instead of map as vfio_region */
>> +			base = opregionvbt;
>> +		/* Remap OpRegion + extended VBT for 2.1+ */
>> +		} else {
>> +			memunmap(base);
>> +			base = memremap(addr, size, MEMREMAP_WB);
>> +			if (!base)
>> +				return -ENOMEM;
>>  		}
>>  	}
>>
>> -	if (size != OPREGION_SIZE) {
>> -		memunmap(base);
>> -		base = memremap(addr, size, MEMREMAP_WB);
>> -		if (!base)
>> -			return -ENOMEM;
>> -	}
>> -
>>  	ret = vfio_pci_register_dev_region(vdev,
>>  		PCI_VENDOR_ID_INTEL | VFIO_REGION_TYPE_PCI_VENDOR_TYPE,
>>  		VFIO_REGION_SUBTYPE_INTEL_IGD_OPREGION,
>>  		&vfio_pci_igd_regops, size, VFIO_REGION_INFO_FLAG_READ, base);
>>  	if (ret) {
>> -		memunmap(base);
>> +		if (is_ioremap_addr(base))
>> +			memunmap(base);
>> +		else
>> +			kfree(base);
>>  		return ret;
>>  	}
>>
>
>

--
Best Regards,
Colin Xu
