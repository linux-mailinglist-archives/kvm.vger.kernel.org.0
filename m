Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FDF3393B32
	for <lists+kvm@lfdr.de>; Fri, 28 May 2021 03:50:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235305AbhE1Bvh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 May 2021 21:51:37 -0400
Received: from mga04.intel.com ([192.55.52.120]:39392 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229749AbhE1Bvg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 May 2021 21:51:36 -0400
IronPort-SDR: tc2jgbkSga8ADZf9QjQzAGndxcwaHOYLUZsxsvqs+0J1DBpAVTRVSq8BJ1KQEuOTYxdgDWY7da
 ZrikEfyXmpaA==
X-IronPort-AV: E=McAfee;i="6200,9189,9997"; a="200984711"
X-IronPort-AV: E=Sophos;i="5.83,228,1616482800"; 
   d="scan'208";a="200984711"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2021 18:50:00 -0700
IronPort-SDR: cqzfkh8Ja8aZVzK2amhZWKbPkE2ICqfjSx+ieb40hAr76ifKYSjc3lGQyUvG1P+6v7IVHqtPre
 /0iBt9PI5Keg==
X-IronPort-AV: E=Sophos;i="5.83,228,1616482800"; 
   d="scan'208";a="465625144"
Received: from djiang5-mobl1.amr.corp.intel.com (HELO [10.255.70.31]) ([10.255.70.31])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2021 18:49:59 -0700
Subject: Re: [PATCH v6 05/20] vfio: mdev: common lib code for setting up
 Interrupt Message Store
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     alex.williamson@redhat.com, kwankhede@nvidia.com,
        tglx@linutronix.de, vkoul@kernel.org, megha.dey@intel.com,
        jacob.jun.pan@intel.com, ashok.raj@intel.com, yi.l.liu@intel.com,
        baolu.lu@intel.com, kevin.tian@intel.com, sanjay.k.kumar@intel.com,
        tony.luck@intel.com, dan.j.williams@intel.com,
        eric.auger@redhat.com, pbonzini@redhat.com,
        dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
References: <162164243591.261970.3439987543338120797.stgit@djiang5-desk3.ch.intel.com>
 <162164277624.261970.7989190254803052804.stgit@djiang5-desk3.ch.intel.com>
 <20210524000257.GN1002214@nvidia.com>
From:   Dave Jiang <dave.jiang@intel.com>
Message-ID: <44ba4c5f-aa40-3149-85a5-3e382f9c2eae@intel.com>
Date:   Thu, 27 May 2021 18:49:59 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210524000257.GN1002214@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 5/23/2021 5:02 PM, Jason Gunthorpe wrote:
> On Fri, May 21, 2021 at 05:19:36PM -0700, Dave Jiang wrote:
>> Add common helper code to setup IMS once the MSI domain has been
>> setup by the device driver. The main helper function is
>> mdev_ims_set_msix_trigger() that is called by the VFIO ioctl
>> VFIO_DEVICE_SET_IRQS. The function deals with the setup and
>> teardown of emulated and IMS backed eventfd that gets exported
>> to the guest kernel via VFIO as MSIX vectors.
>>
>> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
>> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
>> ---
>>   drivers/vfio/mdev/Kconfig     |   12 ++
>>   drivers/vfio/mdev/Makefile    |    3
>>   drivers/vfio/mdev/mdev_irqs.c |  318 +++++++++++++++++++++++++++++++++++++++++
>>   include/linux/mdev.h          |   51 +++++++
>>   4 files changed, 384 insertions(+)
>>   create mode 100644 drivers/vfio/mdev/mdev_irqs.c
> IMS is not mdev specific, do not entangle it with mdev code. This
> should be generic VFIO stuff.
>
>> +static int mdev_msix_set_vector_signal(struct mdev_irq *mdev_irq, int vector, int fd)
>> +{
>> +	int rc, irq;
>> +	struct mdev_device *mdev = irq_to_mdev(mdev_irq);
>> +	struct mdev_irq_entry *entry;
>> +	struct device *dev = &mdev->dev;
>> +	struct eventfd_ctx *trigger;
>> +	char *name;
>> +	bool pasid_en;
>> +	u32 auxval;
>> +
>> +	if (vector < 0 || vector >= mdev_irq->num)
>> +		return -EINVAL;
>> +
>> +	entry = &mdev_irq->irq_entries[vector];
>> +
>> +	if (entry->ims)
>> +		irq = dev_msi_irq_vector(dev, entry->ims_id);
>> +	else
>> +		irq = 0;
>> +
>> +	pasid_en = mdev_irq->pasid != INVALID_IOASID ? true : false;
>> +
>> +	/* IMS and invalid pasid is not a valid configuration */
>> +	if (entry->ims && !pasid_en)
>> +		return -EINVAL;
>> +
>> +	if (entry->trigger) {
>> +		if (irq) {
>> +			irq_bypass_unregister_producer(&entry->producer);
>> +			free_irq(irq, entry->trigger);
>> +			if (pasid_en) {
>> +				auxval = ims_ctrl_pasid_aux(0, false);
>> +				irq_set_auxdata(irq, IMS_AUXDATA_CONTROL_WORD, auxval);
>> +			}
>> +		}
>> +		kfree(entry->name);
>> +		eventfd_ctx_put(entry->trigger);
>> +		entry->trigger = NULL;
>> +	}
>> +
>> +	if (fd < 0)
>> +		return 0;
>> +
>> +	name = kasprintf(GFP_KERNEL, "vfio-mdev-irq[%d](%s)", vector, dev_name(dev));
>> +	if (!name)
>> +		return -ENOMEM;
>> +
>> +	trigger = eventfd_ctx_fdget(fd);
>> +	if (IS_ERR(trigger)) {
>> +		kfree(name);
>> +		return PTR_ERR(trigger);
>> +	}
>> +
>> +	entry->name = name;
>> +	entry->trigger = trigger;
>> +
>> +	if (!irq)
>> +		return 0;
>> +
>> +	if (pasid_en) {
>> +		auxval = ims_ctrl_pasid_aux(mdev_irq->pasid, true);
>> +		rc = irq_set_auxdata(irq, IMS_AUXDATA_CONTROL_WORD, auxval);
>> +		if (rc < 0)
>> +			goto err;
> Why is anything to do with PASID here? Something has gone wrong with
> the layers I suspect..
>
> Oh yes. drivers/irqchip/irq-ims-msi.c is dxd specific and shouldn't be
> pretending to be common code.
>
> The protocol to stuff the pasid and other stuff into the auxdata is
> also compeltely idxd specific and is just a hacky way to communicate
> from this code to the IDXD irq-chip.
>
> So this doesn't belong here either. Pass in the auxdata from the idxd
> code and I'd rename the irq-ims-msi to irq-ims-idxd
>
>> +static int mdev_msix_enable(struct mdev_irq *mdev_irq, int nvec)
>> +{
>> +	struct mdev_device *mdev = irq_to_mdev(mdev_irq);
>> +	struct device *dev;
>> +	int rc;
>> +
>> +	if (nvec != mdev_irq->num)
>> +		return -EINVAL;
>> +
>> +	if (mdev_irq->ims_num) {
>> +		dev = &mdev->dev;
>> +		rc = msi_domain_alloc_irqs(dev_get_msi_domain(dev), dev, mdev_irq->ims_num);
> Huh? The PCI device should be the only device touching IRQ stuff. I'm
> nervous to see you mix in the mdev struct device into this function.

As we talked about in the other thread. We have a single IMS domain per 
device. The domain is set to the mdev 'struct device' and we allocate 
the vectors to each mdev 'struct device' so we can manage those IMS 
vectors specifically for that mdev.

>
> Isn't the msi_domain just idxd->ims_domain?

Yes


>
> Jason
