Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD412286A8C
	for <lists+kvm@lfdr.de>; Wed,  7 Oct 2020 23:54:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728802AbgJGVyt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Oct 2020 17:54:49 -0400
Received: from mga09.intel.com ([134.134.136.24]:37023 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728707AbgJGVyt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Oct 2020 17:54:49 -0400
IronPort-SDR: ATO7u6xTVJmak99nNDBAlisrVn4SN51RpeRAkc63m6bltuWiUoyS8YLWZJVvpfog8dXnDidLSo
 VNRc46nAznsg==
X-IronPort-AV: E=McAfee;i="6000,8403,9767"; a="165273717"
X-IronPort-AV: E=Sophos;i="5.77,348,1596524400"; 
   d="scan'208";a="165273717"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2020 14:54:48 -0700
IronPort-SDR: 4qfMTZo4u5Fv8wibns12ZIoRmV3MLV1iH96g1M1EcAG5Lxb3/GxNyeVD/JEo9YANCtarMT2JER
 z5DhGfCrwOgA==
X-IronPort-AV: E=Sophos;i="5.77,348,1596524400"; 
   d="scan'208";a="311949651"
Received: from djiang5-mobl1.amr.corp.intel.com (HELO [10.212.241.84]) ([10.212.241.84])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2020 14:54:45 -0700
Subject: Re: [PATCH v3 11/18] dmaengine: idxd: ims setup for the vdcm
To:     Thomas Gleixner <tglx@linutronix.de>, vkoul@kernel.org,
        megha.dey@intel.com, maz@kernel.org, bhelgaas@google.com,
        alex.williamson@redhat.com, jacob.jun.pan@intel.com,
        ashok.raj@intel.com, jgg@mellanox.com, yi.l.liu@intel.com,
        baolu.lu@intel.com, kevin.tian@intel.com, sanjay.k.kumar@intel.com,
        tony.luck@intel.com, jing.lin@intel.com, dan.j.williams@intel.com,
        kwankhede@nvidia.com, eric.auger@redhat.com, parav@mellanox.com,
        rafael@kernel.org, netanelg@mellanox.com, shahafs@mellanox.com,
        yan.y.zhao@linux.intel.com, pbonzini@redhat.com,
        samuel.ortiz@intel.com, mona.hossain@intel.com
Cc:     dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-pci@vger.kernel.org, kvm@vger.kernel.org
References: <160021207013.67751.8220471499908137671.stgit@djiang5-desk3.ch.intel.com>
 <160021253189.67751.12686144284999931703.stgit@djiang5-desk3.ch.intel.com>
 <87mu17ghr1.fsf@nanos.tec.linutronix.de>
From:   Dave Jiang <dave.jiang@intel.com>
Message-ID: <0f9bdae0-73d7-1b4e-b478-3cbd05c095f4@intel.com>
Date:   Wed, 7 Oct 2020 14:54:40 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <87mu17ghr1.fsf@nanos.tec.linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 9/30/2020 12:57 PM, Thomas Gleixner wrote:
> On Tue, Sep 15 2020 at 16:28, Dave Jiang wrote:
>> diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
>> index a39392157dc2..115a8f49aab3 100644
>> --- a/drivers/dma/Kconfig
>> +++ b/drivers/dma/Kconfig
>> @@ -301,6 +301,7 @@ config INTEL_IDXD_MDEV
>>   	depends on INTEL_IDXD
>>   	depends on VFIO_MDEV
>>   	depends on VFIO_MDEV_DEVICE
>> +	depends on IMS_MSI_ARRAY
> 
> select?

Will fix

> 
>> int idxd_mdev_host_init(struct idxd_device *idxd)
>> {
>> 	struct device *dev = &idxd->pdev->dev;
> 
>> +	ims_info.max_slots = idxd->ims_size;
>> +	ims_info.slots = idxd->reg_base + idxd->ims_offset;
>> +	dev->msi_domain =
>> pci_ims_array_create_msi_irq_domain(idxd->pdev, &ims_info);
> 
> 1) creating the domain can fail and checking the return code is overrated
> 
> 2) dev_set_msi_domain() exists for a reason. If we change any of this in
>     struct device then we can chase all the open coded mess in drivers
>     like this.
> 
> Also can you please explain how this is supposed to work?
> 
> idxd->pdev is the host PCI device. So why are you overwriting the MSI
> domain of the underlying host device? This works by chance because you
> allocate the regular MSIX interrupts for the host device _before_
> invoking this.
> 
> IIRC, I provided you ASCII art to show how all of this is supposed to be
> structured...

Yes. I see now that the implementation is wrong. In the updated code for next rev, I'm saving the domain to the idxd driver context. 

	ims_info.max_slots = idxd->ims_size;
	ims_info.slots = idxd->reg_base + idxd->ims_offset;
	idxd->ims_domain = pci_ims_array_create_msi_irq_domain(idxd->pdev, &ims_info);

dev_set_msi_domain() will be called with mdev later on when mdevs are being created. 

	struct device *dev = mdev_dev(mdev);

        irq_domain = idxd->ims_domain;
        dev_set_msi_domain(dev, irq_domain);
        rc = msi_domain_alloc_irqs(irq_domain, dev, vecs);
        if (rc < 0)
                return rc;

        for_each_msi_entry(entry, dev) {
                irq_entry = &vidxd->irq_entries[i];
                irq_entry->vidxd = vidxd;
                irq_entry->entry = entry;
                irq_entry->id = i;
                i++;
        }


> 
>>   int vidxd_send_interrupt(struct vdcm_idxd *vidxd, int msix_idx)
>>   {
>>   	int rc = -1;
>> @@ -44,15 +46,63 @@ int vidxd_send_interrupt(struct vdcm_idxd *vidxd, int msix_idx)
>>   	return rc;
>>   }
>>   
>> +#define IMS_PASID_ENABLE	0x8
>>   int vidxd_disable_host_ims_pasid(struct vdcm_idxd *vidxd, int ims_idx)
> 
> Yet more unreadable glue. The coding style of this stuff is horrible.
> 
>>   {
>> -	/* PLACEHOLDER */
>> +	struct mdev_device *mdev = vidxd->vdev.mdev;
>> +	struct device *dev = mdev_dev(mdev);
>> +	unsigned int ims_offset;
>> +	struct idxd_device *idxd = vidxd->idxd;
>> +	u32 val;
>> +
>> +	/*
>> +	 * Current implementation limits to 1 WQ for the vdev and therefore
>> +	 * also only 1 IMS interrupt for that vdev.
>> +	 */
>> +	if (ims_idx >= VIDXD_MAX_WQS) {
>> +		dev_warn(dev, "ims_idx greater than vidxd allowed: %d\n", ims_idx);
> 
> This warning text makes no sense whatsoever.
> 
>> +		return -EINVAL;
>> +	}
>> +
>> +	ims_offset = idxd->ims_offset + vidxd->ims_index[ims_idx] * 0x10;
>> +	val = ioread32(idxd->reg_base + ims_offset + 12);
>> +	val &= ~IMS_PASID_ENABLE;
>> +	iowrite32(val, idxd->reg_base + ims_offset + 12);
> 
> *0x10 + 12 !?!?
> 
> Reusing struct ims_slot from the irq chip driver would not be convoluted
> enough, right?

Yes. Fixing that.

> 
> Aside of that this is fiddling in the IMS storage array behind the irq
> chips back without any comment here and a big fat comment about the
> shared usage of ims_slot::ctrl in the irq chip driver.
> 

This is to program the pasid fields in the IMS table entry. Was thinking the pasid fields may be considered device specific so didn't attempt to add the support to the core code. 

> This is kernel programming, not the obfuscated C code contest.
> 
>> +	/* Setup the PASID filtering */
>> +	pasid = idxd_get_mdev_pasid(mdev);
>> +
>> +	if (pasid >= 0) {
>> +		ims_offset = idxd->ims_offset + vidxd->ims_index[ims_idx] * 0x10;
>> +		val = ioread32(idxd->reg_base + ims_offset + 12);
>> +		val |= IMS_PASID_ENABLE | (pasid << 12) | (val & 0x7);
>> +		iowrite32(val, idxd->reg_base + ims_offset + 12);
> 
> More magic numbers and more fiddling in the IMS slot.
> 
>> +	} else {
>> +		dev_warn(dev, "pasid setup failed for ims entry %lld\n", vidxd->ims_index[ims_idx]);
>> +		return -ENXIO;
>> +	}
>> +
>>   	return 0;
>>   }
>>   
>> @@ -839,12 +889,43 @@ static void vidxd_wq_disable(struct vdcm_idxd *vidxd, int wq_id_mask)
>>   
>>   void vidxd_free_ims_entries(struct vdcm_idxd *vidxd)
>>   {
>> -	/* PLACEHOLDER */
>> +	struct irq_domain *irq_domain;
>> +	struct mdev_device *mdev = vidxd->vdev.mdev;
>> +	struct device *dev = mdev_dev(mdev);
>> +	int i;
>> +
>> +	for (i = 0; i < VIDXD_MAX_MSIX_VECS - 1; i++)
>> +		vidxd->ims_index[i] = -1;
>> +
>> +	irq_domain = vidxd->idxd->pdev->dev.msi_domain;
> 
> See above.

struct device *dev = mdev_dev(mdev);

irq_domain = dev_get_msi_domain(dev);

> 
>> +	msi_domain_free_irqs(irq_domain, dev);
> 
>>   int vidxd_setup_ims_entries(struct vdcm_idxd *vidxd)
>>   {
>> -	/* PLACEHOLDER */
>> +	struct irq_domain *irq_domain;
>> +	struct idxd_device *idxd = vidxd->idxd;
>> +	struct mdev_device *mdev = vidxd->vdev.mdev;
>> +	struct device *dev = mdev_dev(mdev);
>> +	int vecs = VIDXD_MAX_MSIX_VECS - 1;
>> +	struct msi_desc *entry;
>> +	struct ims_irq_entry *irq_entry;
>> +	int rc, i = 0;
>> +
>> +	irq_domain = idxd->pdev->dev.msi_domain;
> 
> Ditto.
> 
>> +	rc = msi_domain_alloc_irqs(irq_domain, dev, vecs);
>> +	if (rc < 0)
>> +		return rc;
>> +
>> +	for_each_msi_entry(entry, dev) {
>> +		irq_entry = &vidxd->irq_entries[i];
>> +		irq_entry->vidxd = vidxd;
>> +		irq_entry->int_src = i;
> 
> Redundant information because it's the index in the array. What for?

Yes. I'm setting a ptr to the entry in order to retrieve the needed info. No more duplication.

> 
>> +		irq_entry->irq = entry->irq;
>> +		vidxd->ims_index[i] = entry->device_msi.hwirq;
> 
> The point of having two arrays to store related information is?
> 
> It's at least orders of magnitudes better than the previous trainwreck,
> but oh well...
> 
> Thanks,
> 
>          tglx
> 
