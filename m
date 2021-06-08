Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 792C239FB60
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 17:58:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233478AbhFHP7k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 11:59:40 -0400
Received: from mga18.intel.com ([134.134.136.126]:40698 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233422AbhFHP7k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Jun 2021 11:59:40 -0400
IronPort-SDR: Cj/FlPd1rboPVofX1fN9Sb8tLQ5gHnJW3XJYqMatgdptyBY2OR0fN6afFeFq/COlZ1oNwVzyJA
 k19NLGAZg47Q==
X-IronPort-AV: E=McAfee;i="6200,9189,10009"; a="192195678"
X-IronPort-AV: E=Sophos;i="5.83,258,1616482800"; 
   d="scan'208";a="192195678"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2021 08:57:45 -0700
IronPort-SDR: uQl7NUazWWvfSJTbk5kSFv6XG4/DDAa9vkYKEG8E849iK003nV9Bk/pIjdITxmxpnL58fi7QM/
 aucvz1og+XPg==
X-IronPort-AV: E=Sophos;i="5.83,258,1616482800"; 
   d="scan'208";a="449572202"
Received: from djiang5-mobl1.amr.corp.intel.com (HELO [10.254.189.206]) ([10.254.189.206])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2021 08:57:36 -0700
Subject: Re: [PATCH v6 05/20] vfio: mdev: common lib code for setting up
 Interrupt Message Store
To:     Thomas Gleixner <tglx@linutronix.de>, alex.williamson@redhat.com,
        kwankhede@nvidia.com, vkoul@kernel.org, jgg@mellanox.com
Cc:     Jason Gunthorpe <jgg@nvidia.com>, megha.dey@intel.com,
        jacob.jun.pan@intel.com, ashok.raj@intel.com, yi.l.liu@intel.com,
        baolu.lu@intel.com, kevin.tian@intel.com, sanjay.k.kumar@intel.com,
        tony.luck@intel.com, dan.j.williams@intel.com,
        eric.auger@redhat.com, pbonzini@redhat.com,
        dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
References: <162164243591.261970.3439987543338120797.stgit@djiang5-desk3.ch.intel.com>
 <162164277624.261970.7989190254803052804.stgit@djiang5-desk3.ch.intel.com>
 <87pmx73tfw.ffs@nanos.tec.linutronix.de>
From:   Dave Jiang <dave.jiang@intel.com>
Message-ID: <febc19ac-4105-fb83-709a-5d1fa5871b7e@intel.com>
Date:   Tue, 8 Jun 2021 08:57:35 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <87pmx73tfw.ffs@nanos.tec.linutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 5/31/2021 6:48 AM, Thomas Gleixner wrote:
> On Fri, May 21 2021 at 17:19, Dave Jiang wrote:
>> Add common helper code to setup IMS once the MSI domain has been
>> setup by the device driver. The main helper function is
>> mdev_ims_set_msix_trigger() that is called by the VFIO ioctl
>> VFIO_DEVICE_SET_IRQS. The function deals with the setup and
>> teardown of emulated and IMS backed eventfd that gets exported
>> to the guest kernel via VFIO as MSIX vectors.
> So this talks about IMS, but the functionality is all named mdev_msix*
> and mdev_irqs*. Confused.

Jason mentioned this as well. Will move to vfio_ims* common code.


>> +/*
>> + * Mediate device IMS library code
> Mediated?
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
> I have no idea what this does. Comments are overrated...
>
> Aside of that dev_msi_irq_vector() seems to be a gross misnomer. AFAICT
> it retrieves the Linux interrupt number and not some vector.

Will change function name to dev_msi_irq().


>
>> +	pasid_en = mdev_irq->pasid != INVALID_IOASID ? true : false;
>> +
>> +	/* IMS and invalid pasid is not a valid configuration */
>> +	if (entry->ims && !pasid_en)
>> +		return -EINVAL;
> Why is this not validated already?

Will remove.

>
>> +	if (entry->trigger) {
>> +		if (irq) {
>> +			irq_bypass_unregister_producer(&entry->producer);
>> +			free_irq(irq, entry->trigger);
>> +			if (pasid_en) {
>> +				auxval = ims_ctrl_pasid_aux(0, false);
>> +				irq_set_auxdata(irq, IMS_AUXDATA_CONTROL_WORD, auxval);
> Why can't this be done in the irq chip when the interrupt is torn down?
> Just because the irq chip driver, which is thankfully not merged yet,
> has been implemented that way?
>
> I did this aux dance because someone explained to me that this has to be
> handled seperately and has to be changed independent of all the
> interrupt setup and whatever. But looking at the actual usage now that's
> clearly not the case.
>
> What's the exact order of all this? I assume so:
>
>      1) mdev_irqs_init()
>      2) mdev_irqs_set_pasid()
>      3) mdev_set_msix_trigger()
>
> Right? See below.

I'll provide more info below. But yes we can add pasid to 'struct 
device'. The work on auxdata is appreciated and is still needed.


>
>> +}
>> +EXPORT_SYMBOL_GPL(mdev_irqs_set_pasid);
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
> These exit conditions are completely confusing.

I will add more comments. For the IMS path, some vectors are emulated 
and some are backed by IMS. Thus the early exit.


>
>> +	if (pasid_en) {
>> +		auxval = ims_ctrl_pasid_aux(mdev_irq->pasid, true);
>> +		rc = irq_set_auxdata(irq, IMS_AUXDATA_CONTROL_WORD, auxval);
>> +		if (rc < 0)
>> +			goto err;
> Again. This can be handled in the interrupt chip when the interrupt is
> set up through request_irq().
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
> The allocation of the interrupts happens _after_ PASID has been
> set and PASID is per device, right?
>
> So the obvious place to store PASID is in struct device because the
> device pointer is for one stored in the msi entry descriptor and it is
> also handed down to the irq domain allocation function. So this can be
> checked at allocation time already.
>
> What's unclear to me is under which circumstances does the IMS interrupt
> require a PASID.
>
>     1) Always
>     2) Use case dependent
>
Thomas, thank you for the review. I'll try to provide a summary below with what's going on with IMS after taking in yours and Jason's comments.

Interrupt Message Store (IMS) was designed to provide a more scalable means of interrupt storage compared to industry standard PCI-MSIx.
These can be defined in a device specific way per the SIOV spec.
* Not limited to 2048 vectors as specified by PCIe spec.
* Not limited how different parts of the interrupt, such as masking, pending bit array are located so facilitate different hardware configurations
   that allows devices to layout in a more device friendly way.
https://software.intel.com/content/www/us/en/develop/download/intel-scalable-io-virtualization-technical-specification.html

Two variants were created by your code:
https://lore.kernel.org/linux-hyperv/20200826112335.202234502@linutronix.de/
* IMS array – Mimics how DSA lays its IMS layout in hardware.
* IMS queue – free format memory based, devices such as graphics for e.g. could locate the IMS store in context maintained by system memory for interrupt
               message and data.

Devices such as Intel DSA provides ability for unprivileged software, host user space, or guests to submit work. The intent to notify when work is complete
is part of the work descriptor submitted to the DSA hardware.

                         Generic Descriptor Format
     +----------------------------------------------------------------+
     |                                                |    PASID      |
     +----------------------------------------------------------------+
     |                                                                |
     +----------------------------------------------------------------+
     |                                                                |
     +----------------------------------------------------------------+
     |            | Interrupt handle |                                |
     +----------------------------------------------------------------+
     |                                                                |
     +----------------------------------------------------------------+
     |                                                                |
     +----------------------------------------------------------------+
     |                                                                |
     +----------------------------------------------------------------+
     |                                                                |
     +----------------------------------------------------------------+
     |                                                                |
     +----------------------------------------------------------------+

DSA provides ability to allocate interrupt handles that are internally tied to HW irq. For IMS, the interrupt handle is the index for the IMS entries table.
This handle is submitted via work descriptors from unprivileged software. Either from host user space, or from other Virtual Machines. This allows ultimate
flexibility to software submitting the work, so hardware can notify completion via one of the interrupt handles. In order to ensure unprivileged software
doesn’t use a handle that doesn’t belong to it, DSA provides a facility for system software to associate a PASID with an interrupt handle, and DSA will ensure
the entity submitting the work is authorized to generate interrupt via this interrupt handle (PASID stored in IMS array should match PASID in descriptor).
The fact that the interrupt handle is tied to a PASID is implementation specific. The consumer of this interface doesn’t have any need to allocate a PASID
explicitly and is managed by privileged software.

DSA provides a way to skip PASID validation for IMS handles. This can be used if host kernel is the *only* agent generating work. Host usages without IOMMU
scalable mode are not currently implemented.

The PASID field in IMS entry is used to verify against the PASID that is associated with the submitted descriptor. The combination of the interrupt handle
(device IMS index) and the PASID verifies if the descriptor can generate the interrupt. On mismatch, invalid interrupt handle error (0x19) is generated by
the device in the software error register.
  
For a dedicated wq (dwq), the PASID is programmed into the WQ config register. When the descriptor is submitted to the WQ portal, the PASID from WQCFG is
compared the IMS entry as well as the interrupt handle that is programmed in the descriptor.

For a shared wq (swq), the PASID is either programmed in the descriptor for ENQCMDS or retrieved from the MSR in the case of ENQCMD. That PASID and the
interrupt handle is compared with the what is in the IMS entry.

With a match, the IMS interrupt is generated.

The following is the call flow for mdev without vSVM support:
1.    idxd host driver sets PASID from iommu_aux_get_pasid() to ‘struct device’
2.    idxd guest driver calls request_irq()
3.    VFIO calls VFIO_DEVICE_SET_IRQS ioctl
4.    idxd host driver calls vfio_set_ims_trigger() (newly created common helper function)
	a.    VFIO calls msi_domain_alloc_irqs() and programs valid 'struct device' PASID as auxdata to IMS entry
	b.    Host driver calls request_irq() for IMS interrupts

With a default pasid programmed to 'struct device', for this use case above we shouldn't have the need of programming pasid outside of irqchip.

For the use case of mdev with vSVM enabled, the code is staged for upstream submission after the current "mdev" series. When the guest idxd driver binds a
supervisor PASID, this guest PASID maps to a different host PASID and is not the default host PASID that is programmed to be programmed to the ‘struct device’.
The guest PASID is passed to the host driver through vendor specific means. The host driver needs to retrieve the host PASID that is mapped to this guest PASID
and program the that host PASID to the IMS entry. This is where the auxdata helper is needed and the PASID cannot be set via the common code path. The idxd
driver does this by having the guest driver fill the virtual MSIX permission table (device specific), which contains a PASID entry for each of the MSIX vectors
when SVA is turned on. The MMIO write to the guest vMSIXPERM table allows the host driver MMIO emulation code to retrieve the guest PASID and attempt to match
that with the host PASID. That host PASID is programmed to the IMS entry that is backing the guest MSIX vector. This cannot be done via the common path and
therefore requires the auxdata helper function to program the IMS PASID fields.

The following is the call flow for mdev with vSVM support:
1.    idxd host driver sets PASID to mdev ‘struct device’ via iommu_aux_get_PASID()
2.    idxd guest driver binds supervisor pasid
3.    idxd guest driver calls request_irq()
4.    VFIO calls VFIO_DEVICE_SET_IRQS ioctl
5.    idxd host driver calls vfio_set_ims_trigger()
	a.    VFIO calls msi_domain_alloc_irqs() and programs PASID as auxdata to IMS entry
	b.    Host driver calls request_irq() for IMS interrupts
6.    idxd guest driver programs virtual device MSIX permission table with guest PASID.
7.    Host driver mdev MMIO emulation retrieves guest PASID from vdev MSIXPERM table and matches to host PASID via ioasid_find_by_spid().
	a.    Host driver calls irq_set_auxdata() to change to the new PASID for IMS entry.

