Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65A2524228D
	for <lists+kvm@lfdr.de>; Wed, 12 Aug 2020 00:39:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726412AbgHKWjP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Aug 2020 18:39:15 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:48250 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726143AbgHKWjO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Aug 2020 18:39:14 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1597185551;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=b/XIyCsraF0XDGxNSIkgMuCOFCu+n+fIBiRqibux3Wc=;
        b=oUCmqHFSzGzni1o6gpYc6yml07aT0CEIi015tYdVAgMTHwNDT5PN7prv4h7APKms8DJiEF
        Qn1l16O5xvmJNDeiGSWNbc2Av++opG9Ipda2xxueEgI1aa9ZO3qGMJnlS8Y71aplCnGJXr
        apfXKVatTYXxYTZXa6N7knbFbs4BT+y2tZi4G81tq1kQdHiBX1qkbnZ2iVhGxwTuit5HJ3
        kcJIdbxbmJF4kMVC1Z4qWf2qoPEtF0N7poTP5OsmmRLzaY2uvNtrBREkR3Ki2fvF4V0X9o
        SwEB6l5/MJ6Be6+Q0IjRyq4r4jtSkHdVWpF1FAfwDETSckytOOeUZ0vtA/zHTQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1597185551;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=b/XIyCsraF0XDGxNSIkgMuCOFCu+n+fIBiRqibux3Wc=;
        b=bwYqv+uHfJFpFgqEXz6cu4pwyFOjfsGUOz0wb8CCBhky4vKUVECRl8RVLFpMaQsOMJOfUk
        4a+Py/p+A2duoBBw==
To:     "Dey\, Megha" <megha.dey@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "gregkh\@linuxfoundation.org" <gregkh@linuxfoundation.org>
Cc:     Marc Zyngier <maz@kernel.org>,
        "Jiang\, Dave" <dave.jiang@intel.com>,
        "vkoul\@kernel.org" <vkoul@kernel.org>,
        "bhelgaas\@google.com" <bhelgaas@google.com>,
        "rafael\@kernel.org" <rafael@kernel.org>,
        "hpa\@zytor.com" <hpa@zytor.com>,
        "alex.williamson\@redhat.com" <alex.williamson@redhat.com>,
        "Pan\, Jacob jun" <jacob.jun.pan@intel.com>,
        "Raj\, Ashok" <ashok.raj@intel.com>,
        "Liu\, Yi L" <yi.l.liu@intel.com>,
        "Lu\, Baolu" <baolu.lu@intel.com>,
        "Tian\, Kevin" <kevin.tian@intel.com>,
        "Kumar\, Sanjay K" <sanjay.k.kumar@intel.com>,
        "Luck\, Tony" <tony.luck@intel.com>,
        "Lin\, Jing" <jing.lin@intel.com>,
        "Williams\, Dan J" <dan.j.williams@intel.com>,
        "kwankhede\@nvidia.com" <kwankhede@nvidia.com>,
        "eric.auger\@redhat.com" <eric.auger@redhat.com>,
        "parav\@mellanox.com" <parav@mellanox.com>,
        "Hansen\, Dave" <dave.hansen@intel.com>,
        "netanelg\@mellanox.com" <netanelg@mellanox.com>,
        "shahafs\@mellanox.com" <shahafs@mellanox.com>,
        "yan.y.zhao\@linux.intel.com" <yan.y.zhao@linux.intel.com>,
        "pbonzini\@redhat.com" <pbonzini@redhat.com>,
        "Ortiz\, Samuel" <samuel.ortiz@intel.com>,
        "Hossain\, Mona" <mona.hossain@intel.com>,
        "dmaengine\@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86\@kernel.org" <x86@kernel.org>,
        "linux-pci\@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "kvm\@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH RFC v2 02/18] irq/dev-msi: Add support for a new DEV_MSI irq domain
In-Reply-To: <996854e7-ab11-b76b-64dc-b760b3ad2365@intel.com>
References: <87h7tcgbs2.fsf@nanos.tec.linutronix.de> <996854e7-ab11-b76b-64dc-b760b3ad2365@intel.com>
Date:   Wed, 12 Aug 2020 00:39:10 +0200
Message-ID: <878sek7qpd.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Megha.

"Dey, Megha" <megha.dey@intel.com> writes:
> On 8/8/2020 12:47 PM, Thomas Gleixner wrote:
>>> 3. Come up with a ground up approach which adheres to the layering
>>> constraints of the IRQ subsystem
>> Yes. It's something which can be used by all devices which have:
>>
>>     1) A device specific irq chip implementation including a msi write function
>>     2) Device specific resource management (slots in the IMS case)
>>
>> The infrastructure you need is basically a wrapper around the core MSI
>> domain (similar to PCI, platform-MSI etc,) which provides the specific
>> functionality to handle the above.
>
> ok, i will create a per device irq chip which will directly have the 
> device specific callbacks instead of another layer of redirection.
>
> This way i will get rid of the 'platform_msi_ops' data structure.
>
> I am not sure what you mean by device specific resource management, are 
> you referring to dev_msi_alloc/free_irqs?

I think I gave you a hint:

>>     2) Device specific resource management (slots in the IMS case)

The IMS storage is an array with slots in the IDXD case and these slots
are assigned at interrupt allocation time, right? In other cases where
the IMS storage is in some other place, e.g. queue memory, then this
still needs to associated to the interrupt at allocation time.

But of course because you create some disconnected irqdomain you have to
do that assignment seperately on the side and then stick this
information into msi_desc after the fact.

And as this is device specific every device driver which utilizes IMS
has to do that which is bonkers at best.

>>    2) A slot allocation or association function and their 'free'
>>       counterpart (irq_domain_ops)
>
> This is one part I didn't understand.
>
> Currently my dev_msi_alloc_irqs is simply a wrapper over 
> platform_msi_domain_alloc_irqs which again mostly calls 
> msi_domain_alloc_irqs.
>
> When you say add a .alloc, .free, does this mean we should add a device 
> specific alloc/free and not use the default 
> msi_domain_alloc/msi_domain_free?
>
> I don't see anything device specific to be done for IDXD atleast, can 
> you please let me know?

Each and every time I mentioned this, I explicitely mentioned "slot
allocation (array) or slot association (IMS store is not in an
array)".

But you keep asking what's device specific over and over and where
resource management is?

The storage slot array is a resoruce which needs to be managed and it is
device specific by specification. And it's part of the interrupt
allocation obviously because without a place to store the MSI message
the whole thing would not work. This slot does not come out of thin air,
right?

https://github.com/intel/idxd-driver/commit/fb9a2f4e36525a1f18d9e654d472aa87a9adcb30

int vidxd_setup_ims_entries(struct vdcm_idxd *vidxd)
{
	struct idxd_device *idxd = vidxd->idxd;
	struct ims_irq_entry *irq_entry;
	struct mdev_device *mdev = vidxd->vdev.mdev;
	struct device *dev = mdev_dev(mdev);
	struct msi_desc *desc;
	int err, i = 0;
	int index;

	/*
	 * MSIX vec 0 is emulated by the vdcm and does not take up an IMS. The total MSIX vecs used
	 * by the mdev will be total IMS + 1. vec 0 is used for misc interrupts such as command
	 * completion, error notification, PMU, etc. The other vectors are used for descriptor
	 * completion. Thus only the number of IMS vectors need to be allocated, which is
	 * VIDXD_MAX_MSIX_VECS - 1.
	 */
	err = dev_msi_domain_alloc_irqs(dev, VIDXD_MAX_MSIX_VECS - 1, &idxd_ims_ops);
	if (err < 0) {
		dev_dbg(dev, "Enabling IMS entry! %d\n", err);
		return err;
	}

	i = 0;
	for_each_msi_entry(desc, dev) {
		index = idxd_alloc_ims_index(idxd);
		if (index < 0) {
			err = index;
			break;
		}
		vidxd->ims_index[i] = index;

		irq_entry = &vidxd->irq_entries[i];
		irq_entry->vidxd = vidxd;
		irq_entry->int_src = i;
		irq_entry->irq = desc->irq;
		i++;
	}

	if (err)
		vidxd_free_ims_entries(vidxd);

	return 0;
}

idxd_alloc_ims_index() is an allocation, right? And the above aside of
having 3 redundant levels of storage for exactly the same information is
just a violation of all layering concepts at once.

I just wish I've never seen that code.

>> Again. Look at the layering. What you created now is a pseudo shared
>> domain which needs
>>
>>     1) An indirection layer for providing device specific functions
>>
>>     2) An extra allocation layer in the device specific driver to assign
>>        IMS slots completely outside of the domain allocation mechanism.
> hmmm, again I am not sure of which extra allocation layer you are 
> referring to..

See above.

>> The infrastructure itself is not more than a thin wrapper around the
>> existing msi domain infrastructure and might even share code with
>> platform-msi.
>
>  From your explanation:
>
> In the device driver:
>
> static const struct irq_domain_ops idxd_irq_domain_ops = {
>
> .alloc= idxd_domain_alloc, //not sure what this should do

You might know by now. Also it's not necessarily the .alloc callback
which needs to be implemented. As I said we can add ops if necessary and
if it makes sense. This needs some thoughts to provide proper layering
and for sharing as much code as possible.

> except the alloc/free irq_domain_ops, does this look fine to you?

It's at least heading into the right direction.

But before we talk about the details at this level the
device::msi_domain pointer issue wants to be resolved. It's part of the
solution to share code at various levels and to make utilization of this
technology as simple as possible for driver writers.

We need to think about infrastructure which can be used by various types
of IMS devices, e.g. those with storage arrays and this with storage in
random places, like the network card Jason was talking about. And to get
there we need to do the house cleaning first.

Also if you do a proper infrastructure then you need exactly ONE
implementation of an irqdomain and an irqchip for devices which have a
IMS slot storage array. Every driver for a device which has this kind of
storage can reuse that even with different array sizes.

If done right then your IDXD driver needs:

   idxd->domain = create_ims_array_domain(...., basepointer, max_slots);

in the init function of the control block. create_ims_array_domain() is
not part of IDXD, it's a common irq domain/irq chip implementation which
deals with IMS slot storage arrays of arbitrary size. 

And then when creating a subdevice you do:

    subdevice->msi_domain = idxd->domain;

and to allocate the interrupts you just do:

    device_msi_alloc_irqs(subdevice, nrirqs);

and device_msi_alloc_irqs() is shared infrastructure which has nothing
to do with idxd or the ims array domain.

The same can be done for devices which have their storage embedded into
whatever other data structure on the device, e.g. queue memory, and
share the same message storage layout.

And we need to put thoughts into the shared infrastructure upfront
because all of this can also be used on bare metal.

The next thing you completely missed is to think about the ability to
support managed interrupts which we have in PCI/MSIX today. Its just a
matter of time that a IMS device comes along which want's it's subdevice
interrupts managed properly when running on bare metal.

Can we please just go back to proper engineering and figure out how to
create something which is not just yet another half baken works for IDXD
"solution"? 

This means we need a proper decription of possible IMS usage scenarios
and the foreseeable storage scenarios (arrays, queue data, ....). Along
with requirement like managed interrupts etc. I'm sure quite some of
this information is scattered over a wide range of mail threads, but
it's not my job to hunt it down.

Without consistent information at least to the point which is available
today this is going to end up in a major tinkering trainwreck. I have
zero interest in dealing with those especially if the major pain can be
avoided by doing proper analysis and design upfront.

Thanks,

        tglx
