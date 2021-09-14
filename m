Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5F6640A52D
	for <lists+kvm@lfdr.de>; Tue, 14 Sep 2021 06:19:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231634AbhINEUN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Sep 2021 00:20:13 -0400
Received: from mga07.intel.com ([134.134.136.100]:19828 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230041AbhINEUL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Sep 2021 00:20:11 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10106"; a="285562383"
X-IronPort-AV: E=Sophos;i="5.85,291,1624345200"; 
   d="scan'208";a="285562383"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2021 21:18:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,291,1624345200"; 
   d="scan'208";a="697379063"
Received: from unknown (HELO coxu-arch-shz) ([10.239.160.21])
  by fmsmga006.fm.intel.com with ESMTP; 13 Sep 2021 21:18:51 -0700
Date:   Tue, 14 Sep 2021 12:18:50 +0800 (CST)
From:   Colin Xu <colin.xu@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
cc:     Colin Xu <colin.xu@intel.com>, kvm@vger.kernel.org,
        zhenyuw@linux.intel.com, hang.yuan@linux.intel.com,
        swee.yee.fonn@intel.com, fred.gao@intel.com
Subject: Re: [PATCH v4] vfio/pci: Add OpRegion 2.0+ Extended VBT support.
In-Reply-To: <20210913091408.4ceae061.alex.williamson@redhat.com>
Message-ID: <a89d4682-7bc3-721c-b594-e235e73e4ec9@outlook.office365.com>
References: <8a444890-63ba-e96a-63ab-7e6993ea1b4b@outlook.office365.com> <20210913124158.68775-1-colin.xu@intel.com> <20210913091408.4ceae061.alex.williamson@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 13 Sep 2021, Alex Williamson wrote:

> On Mon, 13 Sep 2021 20:41:58 +0800
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
>> V4: (Alex)
>> No need support write op.
>> Direct copy to user buffer with several shift instead of shadow.
>> Copy helper to copy to user buffer and shift offset.
>>
>> Cc: Zhenyu Wang <zhenyuw@linux.intel.com>
>> Cc: Hang Yuan <hang.yuan@linux.intel.com>
>> Cc: Swee Yee Fonn <swee.yee.fonn@intel.com>
>> Cc: Fred Gao <fred.gao@intel.com>
>> Signed-off-by: Colin Xu <colin.xu@intel.com>
>> ---
>>  drivers/vfio/pci/vfio_pci_igd.c | 229 ++++++++++++++++++++++++--------
>>  1 file changed, 174 insertions(+), 55 deletions(-)
>>
>> diff --git a/drivers/vfio/pci/vfio_pci_igd.c b/drivers/vfio/pci/vfio_pci_igd.c
>> index 228df565e9bc..14e958893be6 100644
>> --- a/drivers/vfio/pci/vfio_pci_igd.c
>> +++ b/drivers/vfio/pci/vfio_pci_igd.c
>> @@ -25,20 +25,119 @@
>>  #define OPREGION_RVDS		0x3c2
>>  #define OPREGION_VERSION	0x16
>>
>> +struct igd_opregion_vbt {
>> +	void *opregion;
>> +	void *vbt_ex;
>> +	__le16 version;
>> +	__le64 rvda;
>
> I thought storing version here was questionable because we're really
> only saving ourselves a read from the opregion, test against 0x0200,
> and conversion to 0x0201.  Storing rvda here feel gratuitous since it
> can be calculated from readily available data in the rw function.
>
Let me move both to patch on copy.
>> +};
>> +
>> +/**
>> + * igd_opregion_shift_copy() - Copy OpRegion to user buffer and shift position.
>> + * @dst: User buffer ptr to copy to.
>> + * @off: Offset to user buffer ptr. Increased by bytes_adv on return.
>> + * @src: Source buffer to copy from.
>> + * @pos: Increased by bytes_adv on return.
>> + * @remaining: Decreased by bytes_adv on return.
>> + * @bytes_cp: Bytes to copy.
>> + * @bytes_adv: Bytes to adjust off, pos and remaining.
>> + *
>> + * Copy OpRegion to offset from specific source ptr and shift the offset.
>> + *
>> + * Return: 0 on success, -EFAULT otherwise.
>> + *
>> + */
>> +static inline unsigned long igd_opregion_shift_copy(char __user *dst,
>> +						    loff_t *off,
>> +						    void *src,
>> +						    loff_t *pos,
>> +						    loff_t *remaining,
>> +						    loff_t bytes_cp,
>> +						    loff_t bytes_adv)
>> +{
>> +	if (copy_to_user(dst + (*off), src, bytes_cp))
>> +		return -EFAULT;
>> +
>> +	*off += bytes_adv;
>> +	*pos += bytes_adv;
>> +	*remaining -= bytes_adv;
>
> @bytes_cp always equals @bytes_adv except for the last case, it's not
> worth the special handling imo.
>
Understood. I'll remove the adv and directly use copy_to_user() for that.
>> +
>> +	return 0;
>> +}
>> +
>>  static size_t vfio_pci_igd_rw(struct vfio_pci_device *vdev, char __user *buf,
>>  			      size_t count, loff_t *ppos, bool iswrite)
>>  {
>>  	unsigned int i = VFIO_PCI_OFFSET_TO_INDEX(*ppos) - VFIO_PCI_NUM_REGIONS;
>> -	void *base = vdev->region[i].data;
>> +	struct igd_opregion_vbt *opregionvbt = vdev->region[i].data;
>>  	loff_t pos = *ppos & VFIO_PCI_OFFSET_MASK;
>> +	loff_t remaining = count;
>> +	loff_t off = 0;
>>
>>  	if (pos >= vdev->region[i].size || iswrite)
>>  		return -EINVAL;
>>
>>  	count = min(count, (size_t)(vdev->region[i].size - pos));
>
> We set @remaining before we bounds check @count here.  Thanks,
>
Oops. How careless I am. Fixed.
> Alex
>
>>
>> -	if (copy_to_user(buf, base + pos, count))
>> -		return -EFAULT;
>> +	/* Copy until OpRegion version */
>> +	if (remaining && pos < OPREGION_VERSION) {
>> +		loff_t bytes = min(remaining, OPREGION_VERSION - pos);
>> +
>> +		if (igd_opregion_shift_copy(buf, &off,
>> +					    opregionvbt->opregion + pos, &pos,
>> +					    &remaining, bytes, bytes))
>> +			return -EFAULT;
>> +	}
>> +
>> +	/* Copy patched (if necessary) OpRegion version */
>> +	if (remaining && pos < OPREGION_VERSION + sizeof(__le16)) {
>> +		loff_t bytes = min(remaining,
>> +				   OPREGION_VERSION + (loff_t)sizeof(__le16) - pos);
>> +
>> +		if (igd_opregion_shift_copy(buf, &off,
>> +					    &opregionvbt->version, &pos,
>> +					    &remaining, bytes, bytes))
>> +			return -EFAULT;
>> +	}
>> +
>> +	/* Copy until RVDA */
>> +	if (remaining && pos < OPREGION_RVDA) {
>> +		loff_t bytes = min((loff_t)remaining, OPREGION_RVDA - pos);
>> +
>> +		if (igd_opregion_shift_copy(buf, &off,
>> +					    opregionvbt->opregion + pos, &pos,
>> +					    &remaining, bytes, bytes))
>> +			return -EFAULT;
>> +	}
>> +
>> +	/* Copy modified (if necessary) RVDA */
>> +	if (remaining && pos < OPREGION_RVDA + sizeof(__le64)) {
>> +		loff_t bytes = min(remaining, OPREGION_RVDA +
>> +					      (loff_t)sizeof(__le64) - pos);
>> +
>> +		if (igd_opregion_shift_copy(buf, &off,
>> +					    &opregionvbt->rvda, &pos,
>> +					    &remaining, bytes, bytes))
>> +			return -EFAULT;
>> +	}
>> +
>> +	/* Copy the rest of OpRegion */
>> +	if (remaining && pos < OPREGION_SIZE) {
>> +		loff_t bytes = min(remaining, OPREGION_SIZE - pos);
>> +
>> +		if (igd_opregion_shift_copy(buf, &off,
>> +					    opregionvbt->opregion + pos, &pos,
>> +					    &remaining, bytes, bytes))
>> +			return -EFAULT;
>> +	}
>> +
>> +	/* Copy extended VBT if exists */
>> +	if (remaining) {
>> +		if (igd_opregion_shift_copy(buf, &off,
>> +					    opregionvbt->vbt_ex, &pos,
>> +					    &remaining, remaining, 0))
>> +			return -EFAULT;
>> +	}
>>
>>  	*ppos += count;
>>
>> @@ -48,7 +147,13 @@ static size_t vfio_pci_igd_rw(struct vfio_pci_device *vdev, char __user *buf,
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
>> @@ -60,7 +165,7 @@ static int vfio_pci_igd_opregion_init(struct vfio_pci_device *vdev)
>>  {
>>  	__le32 *dwordp = (__le32 *)(vdev->vconfig + OPREGION_PCI_ADDR);
>>  	u32 addr, size;
>> -	void *base;
>> +	struct igd_opregion_vbt *opregionvbt;
>>  	int ret;
>>  	u16 version;
>>
>> @@ -71,84 +176,98 @@ static int vfio_pci_igd_opregion_init(struct vfio_pci_device *vdev)
>>  	if (!addr || !(~addr))
>>  		return -ENODEV;
>>
>> -	base = memremap(addr, OPREGION_SIZE, MEMREMAP_WB);
>> -	if (!base)
>> +	opregionvbt = kzalloc(sizeof(*opregionvbt), GFP_KERNEL);
>> +	if (!opregionvbt)
>> +		return -ENOMEM;
>> +
>> +	opregionvbt->opregion = memremap(addr, OPREGION_SIZE, MEMREMAP_WB);
>> +	if (!opregionvbt->opregion) {
>> +		kfree(opregionvbt);
>>  		return -ENOMEM;
>> +	}
>>
>> -	if (memcmp(base, OPREGION_SIGNATURE, 16)) {
>> -		memunmap(base);
>> +	if (memcmp(opregionvbt->opregion, OPREGION_SIGNATURE, 16)) {
>> +		memunmap(opregionvbt->opregion);
>> +		kfree(opregionvbt);
>>  		return -EINVAL;
>>  	}
>>
>> -	size = le32_to_cpu(*(__le32 *)(base + 16));
>> +	size = le32_to_cpu(*(__le32 *)(opregionvbt->opregion + 16));
>>  	if (!size) {
>> -		memunmap(base);
>> +		memunmap(opregionvbt->opregion);
>> +		kfree(opregionvbt);
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
>> +	opregionvbt->version = *(__le16 *)(opregionvbt->opregion +
>> +					   OPREGION_VERSION);
>> +	version = le16_to_cpu(opregionvbt->version);
>> +
>>  	if (version >= 0x0200) {
>> -		u64 rvda;
>> -		u32 rvds;
>> +		u64 rvda = le64_to_cpu(*(__le64 *)(opregionvbt->opregion +
>> +						   OPREGION_RVDA));
>> +		u32 rvds = le32_to_cpu(*(__le32 *)(opregionvbt->opregion +
>> +						   OPREGION_RVDS));
>>
>> -		rvda = le64_to_cpu(*(__le64 *)(base + OPREGION_RVDA));
>> -		rvds = le32_to_cpu(*(__le32 *)(base + OPREGION_RVDS));
>> +		/* The extended VBT is valid only when RVDA/RVDS are non-zero */
>>  		if (rvda && rvds) {
>> -			/* no support for opregion v2.0 with physical VBT address */
>> +			size += rvds;
>> +
>>  			if (version == 0x0200) {
>> -				memunmap(base);
>> -				pci_err(vdev->pdev,
>> -					"IGD assignment does not support opregion v2.0 with an extended VBT region\n");
>> -				return -EINVAL;
>> +				/* Patch to version 2.0 in read ops */
>> +				opregionvbt->version = cpu_to_le16(0x0201);
>> +				/* Absolute physical addr for 2.0 */
>> +				addr = rvda;
>> +			} else {
>> +				/* Relative addr to OpRegion header for 2.1+ */
>> +				addr += rvda;
>>  			}
>>
>> -			if (rvda != size) {
>> -				memunmap(base);
>> -				pci_err(vdev->pdev,
>> -					"Extended VBT does not follow opregion on version 0x%04x\n",
>> -					version);
>> -				return -EINVAL;
>> +			opregionvbt->vbt_ex = memremap(addr, rvds, MEMREMAP_WB);
>> +			if (!opregionvbt->vbt_ex) {
>> +				memunmap(opregionvbt->opregion);
>> +				kfree(opregionvbt);
>> +				return -ENOMEM;
>>  			}
>>
>> -			/* region size for opregion v2.0+: opregion and VBT size. */
>> -			size += rvds;
>> +			/* Always set RVDA to make exVBT follows OpRegion */
>> +			opregionvbt->rvda = cpu_to_le64(OPREGION_SIZE);
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
>> -		VFIO_REGION_SUBTYPE_INTEL_IGD_OPREGION,
>> -		&vfio_pci_igd_regops, size, VFIO_REGION_INFO_FLAG_READ, base);
>> +		VFIO_REGION_SUBTYPE_INTEL_IGD_OPREGION, &vfio_pci_igd_regops,
>> +		size, VFIO_REGION_INFO_FLAG_READ, opregionvbt);
>>  	if (ret) {
>> -		memunmap(base);
>> +		if (opregionvbt->vbt_ex)
>> +			memunmap(opregionvbt->vbt_ex);
>> +
>> +		memunmap(opregionvbt->opregion);
>> +		kfree(opregionvbt);
>>  		return ret;
>>  	}
>>
>
>

--
Best Regards,
Colin Xu
