Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0C37408B27
	for <lists+kvm@lfdr.de>; Mon, 13 Sep 2021 14:39:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236325AbhIMMlH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Sep 2021 08:41:07 -0400
Received: from mga02.intel.com ([134.134.136.20]:6544 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236160AbhIMMlD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Sep 2021 08:41:03 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10105"; a="208893240"
X-IronPort-AV: E=Sophos;i="5.85,288,1624345200"; 
   d="scan'208";a="208893240"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2021 05:39:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,288,1624345200"; 
   d="scan'208";a="507275946"
Received: from unknown (HELO coxu-arch-shz) ([10.239.160.21])
  by fmsmga008.fm.intel.com with ESMTP; 13 Sep 2021 05:39:43 -0700
Date:   Mon, 13 Sep 2021 20:39:42 +0800 (CST)
From:   Colin Xu <colin.xu@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
cc:     Colin Xu <colin.xu@intel.com>, kvm@vger.kernel.org,
        zhenyuw@linux.intel.com, hang.yuan@linux.intel.com,
        swee.yee.fonn@intel.com, fred.gao@intel.com
Subject: Re: [PATCH v3] vfio/pci: Add OpRegion 2.0+ Extended VBT support.
In-Reply-To: <20210909160052.10d29f54.alex.williamson@redhat.com>
Message-ID: <8a444890-63ba-e96a-63ab-7e6993ea1b4b@outlook.office365.com>
References: <8d18c045-7c50-e1c-99-536357f0b8ec@outlook.office365.com> <20210909050934.296027-1-colin.xu@intel.com> <20210909160052.10d29f54.alex.williamson@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

yyyyyyyyyyOn Thu, 9 Sep 2021, Alex Williamson wrote:

> On Thu,  9 Sep 2021 13:09:34 +0800
> Colin Xu <colin.xu@intel.com> wrote:
>
>> Due to historical reason, some legacy shipped system doesn't follow
>> OpRegion 2.1 spec but still stick to OpRegion 2.0, in which the extended
>> VBT is not contiguous after OpRegion in physical address, but any
>> location pointed by RVDA via absolute address. Also although current
>> OpRegion 2.1+ systems appears that the extended VBT follows OpRegion,
>> RVDA is the relative address to OpRegion head, the extended VBT location
>> may change to non-contiguous to OpRegion. In both cases, it's impossible
>> to map a contiguous range to hold both OpRegion and the extended VBT and
>> expose via one vfio region.
>>
>> The only difference between OpRegion 2.0 and 2.1 is where extended
>> VBT is stored: For 2.0, RVDA is the absolute address of extended VBT
>> while for 2.1, RVDA is the relative address of extended VBT to OpRegion
>> baes, and there is no other difference between OpRegion 2.0 and 2.1.
>> To support the non-contiguous region case as described, the updated read
>> op will patch OpRegion version and RVDA on-the-fly accordingly. So that
>> from vfio igd OpRegion view, only 2.1+ with contiguous extended VBT
>> after OpRegion is exposed, regardless the underneath host OpRegion is
>> 2.0 or 2.1+. The mechanism makes it possible to support legacy OpRegion
>> 2.0 extended VBT systems with on the market, and support OpRegion 2.1+
>> where the extended VBT isn't contiguous after OpRegion.
>> Also split the write op with read ops to leave flexibility for OpRegion
>> write op support in future.
>>
>> V2:
>> Validate RVDA for 2.1+ before increasing total size. (Alex)
>>
>> V3: (Alex)
>> Split read and write ops.
>> On-the-fly modify OpRegion version and RVDA.
>> Fix sparse error on assign value to casted pointer.
>>
>> Cc: Zhenyu Wang <zhenyuw@linux.intel.com>
>> Cc: Hang Yuan <hang.yuan@linux.intel.com>
>> Cc: Swee Yee Fonn <swee.yee.fonn@intel.com>
>> Cc: Fred Gao <fred.gao@intel.com>
>> Signed-off-by: Colin Xu <colin.xu@intel.com>
>> ---
>>  drivers/vfio/pci/vfio_pci_igd.c | 229 +++++++++++++++++++++++---------
>>  1 file changed, 169 insertions(+), 60 deletions(-)
>
>
> BTW, this does not apply on current mainline.
Let me rebase to latest kvm mainline.
>
>
>> diff --git a/drivers/vfio/pci/vfio_pci_igd.c b/drivers/vfio/pci/vfio_pci_igd.c
>> index 228df565e9bc..fd6ad80f0c5f 100644
>> --- a/drivers/vfio/pci/vfio_pci_igd.c
>> +++ b/drivers/vfio/pci/vfio_pci_igd.c
>> @@ -25,30 +25,131 @@
>>  #define OPREGION_RVDS		0x3c2
>>  #define OPREGION_VERSION	0x16
>>
>> -static size_t vfio_pci_igd_rw(struct vfio_pci_device *vdev, char __user *buf,
>> -			      size_t count, loff_t *ppos, bool iswrite)
>> +struct igd_opregion_vbt {
>> +	void *opregion;
>> +	void *vbt_ex;
>
> 	__le16 version; // see below
>
Updated. Also add rvda here which is similarly handled.
>> +};
>> +
>> +static size_t vfio_pci_igd_read(struct igd_opregion_vbt *opregionvbt,
>> +				char __user *buf, size_t count, loff_t *ppos)
>>  {
>> -	unsigned int i = VFIO_PCI_OFFSET_TO_INDEX(*ppos) - VFIO_PCI_NUM_REGIONS;
>> -	void *base = vdev->region[i].data;
>> +	u16 version = le16_to_cpu(*(__le16 *)(opregionvbt->opregion + OPREGION_VERSION));
>
> 80 column throughout please (I know we already have some violations in
> this file).
Done.
>
>>  	loff_t pos = *ppos & VFIO_PCI_OFFSET_MASK;
>> +	void *base, *shadow = NULL;
>>
>> -	if (pos >= vdev->region[i].size || iswrite)
>> -		return -EINVAL;
>> +	/* Shift into the range for reading the extended VBT only */
>> +	if (pos >= OPREGION_SIZE) {
>> +		base = opregionvbt->vbt_ex + pos - OPREGION_SIZE;
>> +		goto done;
>> +	}
>>
>> -	count = min(count, (size_t)(vdev->region[i].size - pos));
>> +	/* Simply read from OpRegion if the extended VBT doesn't exist */
>> +	if (!opregionvbt->vbt_ex) {
>> +		base = opregionvbt->opregion + pos;
>> +		goto done;
>> +	} else {
>> +		shadow = kzalloc(count, GFP_KERNEL);
>> +
>
> I don't really see any value in this shadow buffer, I don't think we
> have any requirement to fulfill the read in a single copy_to_user().
> Therefore we could do something like:
>
Thanks. Update the logic based on below thought.

> 	size_t remaining = count;
> 	loff_t off = 0;
>
> 	if (remaining && pos < OPREGION_VERSION) {
> 		size_t bytes = min(remaining, OPREGION_VERSION - pos);
>
> 		if (copy_to_user(buf + off, opregionvbt->opregion + pos, bytes))
> 			return -EFAULT;
>
> 		pos += bytes;
> 		off += bytes;
> 		remaining -= bytes;
> 	}
>
> 	if (remaining && pos < OPREGION_VERSION + sizeof(__le16)) {
> 		size_t bytes = min(remaining, OPREGION_VERSION + sizeof(__le16) - pos);
>
> 		/* reported version cached in struct igd_opregion_vbt.version */
> 		if (copy_to_user(buf + off, &opregionvbt->version + pos, bytes))
> 			return -EFAULT;
>
> 		pos += bytes;
> 		off += bytes;
> 		remaining -= bytes;
> 	}
>
> 	if (remaining && pos < OPREGION_RVDA) {
> 		size_t bytes = min(remaining, OPREGION_RVDA - pos);
>
> 		if (copy_to_user(buf + off, opregionvbt->opregion + pos, bytes))
> 			return -EFAULT;
>
> 		pos += bytes;
> 		off += bytes;
> 		remaining -= bytes;
> 	}
>
> 	if (remaining && pos < OPREGION_RVDA + sizeof(__le64)) {
> 		size_t bytes = min(remaining, OPREGION_RVDA + sizeof(__le64) - pos);
> 		__le64 rvda = cpu_to_le64(opregionvbt->vbt_ex ? OPREGION_SIZE : 0);
>
> 		if (copy_to_user(buf + off, &rvda + pos, bytes))
> 			return -EFAULT;
>
> 		pos += bytes;
> 		off += bytes;
> 		remaining -= bytes;
> 	}
>
> 	if (remaining && pos < OPREGION_SIZE) {
> 		size_t bytes = min(remaining, OPREGION_SIZE - pos);
>
> 		if (copy_to_user(buf + off, opregionvbt->opregion + pos, bytes))
> 			return -EFAULT;
>
> 		pos += bytes;
> 		off += bytes;
> 		remaining -= bytes;
> 	}
>
> 	if (remaining) {
> 		if (copy_to_user(buf + off, opregionvbt->vbt_ex + pos, remaining))
> 			return -EFAULT;
> 	}
>
> 	*ppos += count;
>
> 	return count;
>
> It's tedious, but extensible and simple (and avoids the partial read
> problem below).  Maybe there's a macro or helper function that'd make
> it less tedious.
Add a copy'n'shift helper to simplify above logic.
>
>
>> +		if (!shadow)
>> +			return -ENOMEM;
>> +	}
>>
>> -	if (copy_to_user(buf, base + pos, count))
>> +	/*
>> +	 * If the extended VBT exist, need shift for non-contiguous reading and
>> +	 * may need patch OpRegion version (for 2.0) and RVDA (for 2.0 and above)
>> +	 * Use a temporary buffer to simplify the stitch and patch
>> +	 */
>> +
>> +	/* Either crossing OpRegion and VBT or in OpRegion range only */
>> +	if (pos < OPREGION_SIZE && (pos + count) > OPREGION_SIZE) {
>> +		memcpy(shadow, opregionvbt->opregion + pos, OPREGION_SIZE - pos);
>> +		memcpy(shadow + OPREGION_SIZE - pos, opregionvbt->vbt_ex,
>> +		       pos + count - OPREGION_SIZE);
>> +	} else {
>> +		memcpy(shadow, opregionvbt->opregion + pos, count);
>> +	}
>> +
>> +	/*
>> +	 * Patch OpRegion 2.0 to 2.1 if extended VBT exist and reading the version
>> +	 */
>> +	if (opregionvbt->vbt_ex && version == 0x0200 &&
>> +	    pos <= OPREGION_VERSION && pos + count > OPREGION_VERSION) {
>> +		/* May only read 1 byte minor version */
>> +		if (pos + count == OPREGION_VERSION + 1)
>> +			*(u8 *)(shadow + OPREGION_VERSION - pos) = (u8)0x01;
>> +		else
>> +			*(__le16 *)(shadow + OPREGION_VERSION - pos) = cpu_to_le16(0x0201);
>> +	}
>> +
>> +	/*
>> +	 * Patch RVDA for OpRegion 2.0 and above to make the region contiguous.
>> +	 * For 2.0, the requestor always see 2.1 with RVDA as relative.
>> +	 * For 2.1+, RVDA is already relative, but possibly non-contiguous
>> +	 *   after OpRegion.
>> +	 * In both cases, patch RVDA to OpRegion size to make the extended
>> +	 * VBT follows OpRegion and show the requestor a contiguous region.
>> +	 * Always fail partial RVDA reading to prevent malicious reading to offset
>> +	 *   of OpRegion by construct arbitrary offset.
>> +	 */
>> +	if (opregionvbt->vbt_ex) {
>> +		/* Full RVDA reading */
>> +		if (pos <= OPREGION_RVDA && pos + count >= OPREGION_RVDA + 8) {
>> +			*(__le64 *)(shadow + OPREGION_RVDA - pos) = cpu_to_le64(OPREGION_SIZE);
>> +		/* Fail partial reading to avoid construct arbitrary RVDA */
>> +		} else {
>> +			kfree(shadow);
>> +			pr_err("%s: partial RVDA reading!\n", __func__);
>> +			return -EFAULT;
>> +		}
>> +	}
>> +
>> +	base = shadow;
>> +
>> +done:
>> +	if (copy_to_user(buf, base, count))
>>  		return -EFAULT;
>>
>> +	kfree(shadow);
>> +
>>  	*ppos += count;
>>
>>  	return count;
>>  }
>>
>> +static size_t vfio_pci_igd_write(struct igd_opregion_vbt *opregionvbt,
>> +				 char __user *buf, size_t count, loff_t *ppos)
>> +{
>> +	// Not supported yet.
>> +	return -EINVAL;
>> +}
>> +
>> +static size_t vfio_pci_igd_rw(struct vfio_pci_device *vdev, char __user *buf,
>> +			      size_t count, loff_t *ppos, bool iswrite)
>> +{
>> +	unsigned int i = VFIO_PCI_OFFSET_TO_INDEX(*ppos) - VFIO_PCI_NUM_REGIONS;
>> +	struct igd_opregion_vbt *opregionvbt = vdev->region[i].data;
>> +	loff_t pos = *ppos & VFIO_PCI_OFFSET_MASK;
>> +
>> +	if (pos >= vdev->region[i].size)
>> +		return -EINVAL;
>> +
>> +	count = min(count, (size_t)(vdev->region[i].size - pos));
>> +
>> +	return (iswrite ?
>> +		vfio_pci_igd_write(opregionvbt, buf, count, ppos) :
>> +		vfio_pci_igd_read(opregionvbt, buf, count, ppos));
>> +}
>
> I don't think we need to go this far towards enabling write support,
> I'd roll the range and iswrite check into your _read function (rename
> back to _rw()) and call it good.
Remove the write op, and re-implement _rw() as above.
>
>> +
>>  static void vfio_pci_igd_release(struct vfio_pci_device *vdev,
>>  				 struct vfio_pci_region *region)
>>  {
>> -	memunmap(region->data);
>> +	struct igd_opregion_vbt *opregionvbt = region->data;
>> +
>> +	if (opregionvbt->vbt_ex)
>> +		memunmap(opregionvbt->vbt_ex);
>> +
>> +	memunmap(opregionvbt->opregion);
>> +	kfree(opregionvbt);
>>  }
>>
>>  static const struct vfio_pci_regops vfio_pci_igd_regops = {
>> @@ -60,7 +161,7 @@ static int vfio_pci_igd_opregion_init(struct vfio_pci_device *vdev)
>>  {
>>  	__le32 *dwordp = (__le32 *)(vdev->vconfig + OPREGION_PCI_ADDR);
>>  	u32 addr, size;
>> -	void *base;
>> +	struct igd_opregion_vbt *base;
>
>
> @base doesn't seem like an appropriate name for this, it was called
> opregionvbt in the function above.
opregionvbt is a little longer to keep within 80 column so re-use base.
Now rename to opregionvbt to make it meaningful and avoid confusion.
>
>
>>  	int ret;
>>  	u16 version;
>>
>> @@ -71,84 +172,92 @@ static int vfio_pci_igd_opregion_init(struct vfio_pci_device *vdev)
>>  	if (!addr || !(~addr))
>>  		return -ENODEV;
>>
>> -	base = memremap(addr, OPREGION_SIZE, MEMREMAP_WB);
>> +	base = kzalloc(sizeof(*base), GFP_KERNEL);
>>  	if (!base)
>>  		return -ENOMEM;
>>
>> -	if (memcmp(base, OPREGION_SIGNATURE, 16)) {
>> -		memunmap(base);
>> +	base->opregion = memremap(addr, OPREGION_SIZE, MEMREMAP_WB);
>> +	if (!base->opregion) {
>> +		kfree(base);
>> +		return -ENOMEM;
>> +	}
>> +
>> +	if (memcmp(base->opregion, OPREGION_SIGNATURE, 16)) {
>> +		memunmap(base->opregion);
>> +		kfree(base);
>>  		return -EINVAL;
>>  	}
>>
>> -	size = le32_to_cpu(*(__le32 *)(base + 16));
>> +	size = le32_to_cpu(*(__le32 *)(base->opregion + 16));
>>  	if (!size) {
>> -		memunmap(base);
>> +		memunmap(base->opregion);
>> +		kfree(base);
>>  		return -EINVAL;
>>  	}
>>
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
>> -	 *
>> -	 * opregion 2.1+: RVDA is unsigned, relative offset from
>> -	 * opregion base, and should point to the end of opregion.
>> -	 * otherwise, exposing to userspace to allow read access to everything between
>> -	 * the OpRegion and VBT is not safe.
>> -	 * RVDS is defined as size in bytes.
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
>> -	 * opregion 2.0: rvda is the physical VBT address.
>> -	 * Since rvda is HPA it cannot be directly used in guest.
>> -	 * And it should not be practically available for end user,so it is not supported.
>> +	 * Due to the RVDA difference in OpRegion VBT (also the only diff between
>> +	 * 2.0 and 2.1), expose OpRegion and VBT as a contiguous range for
>> +	 * OpRegion 2.0 and above makes it possible to support the non-contiguous
>> +	 * VBT via a single vfio region. From r/w ops view, only contiguous VBT
>> +	 * after OpRegion with version 2.1+ is exposed regardless the underneath
>> +	 * host is 2.0 or non-contiguous 2.1+. The r/w ops will on-the-fly shift
>> +	 * the actural offset into VBT so that data at correct position can be
>> +	 * returned to the requester.
>>  	 */
>> -	version = le16_to_cpu(*(__le16 *)(base + OPREGION_VERSION));
>> +	version = le16_to_cpu(*(__le16 *)(base->opregion + OPREGION_VERSION));
>> +
>
> 	opregionvbt->version = *(__le16 *)(base + OPREGION_VERSION)
> 	version = le16_to_cpu(opregionvbt->version);
>
>
>>  	if (version >= 0x0200) {
>> -		u64 rvda;
>> -		u32 rvds;
>> +		u64 rvda = le64_to_cpu(*(__le64 *)(base->opregion + OPREGION_RVDA));
>> +		u32 rvds = le32_to_cpu(*(__le32 *)(base->opregion + OPREGION_RVDS));
>>
>> -		rvda = le64_to_cpu(*(__le64 *)(base + OPREGION_RVDA));
>> -		rvds = le32_to_cpu(*(__le32 *)(base + OPREGION_RVDS));
>> +		/* The extended VBT is valid only when RVDA/RVDS are non-zero. */
>>  		if (rvda && rvds) {
>> -			/* no support for opregion v2.0 with physical VBT address */
>> -			if (version == 0x0200) {
>> -				memunmap(base);
>> -				pci_err(vdev->pdev,
>> -					"IGD assignment does not support opregion v2.0 with an extended VBT region\n");
>> -				return -EINVAL;
>> -			}
>> +			size += rvds;
>>
>> -			if (rvda != size) {
>> -				memunmap(base);
>> -				pci_err(vdev->pdev,
>> -					"Extended VBT does not follow opregion on version 0x%04x\n",
>> -					version);
>> -				return -EINVAL;
>> +			if (version == 0x0200) {
>> +				/* Absolute physical address for 2.0 */
>
>
> 			if (version == 0x0200) {
> 				opregionvbt->version = cpu_to_le16(0x0201);
> 				addr = rvda;
> 			} else {
> 				addr += rvda;
> 			}
>
> 			... single memremap and error path
I add rvda here, either 0 or OPREGION_SIZE, so that the copy helper can 
directly copy from.

The updated version will be sent via v4 patch.

Thanks!
Colin
>
> Thanks,
>
> Alex
>
>> +				base->vbt_ex = memremap(rvda, rvds, MEMREMAP_WB);
>> +				if (!base->vbt_ex) {
>> +					memunmap(base->opregion);
>> +					kfree(base);
>> +					return -ENOMEM;
>> +				}
>> +			} else {
>> +				/* Relative address to OpRegion header for 2.1+ */
>> +				base->vbt_ex = memremap(addr + rvda, rvds, MEMREMAP_WB);
>> +				if (!base->vbt_ex) {
>> +					memunmap(base->opregion);
>> +					kfree(base);
>> +					return -ENOMEM;
>> +				}
>>  			}
>> -
>> -			/* region size for opregion v2.0+: opregion and VBT size. */
>> -			size += rvds;
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
>> +		if (base->vbt_ex)
>> +			memunmap(base->vbt_ex);
>> +
>> +		memunmap(base->opregion);
>> +		kfree(base);
>>  		return ret;
>>  	}
>>
>
>

--
Best Regards,
Colin Xu
