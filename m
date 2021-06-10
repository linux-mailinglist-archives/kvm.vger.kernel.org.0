Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD9783A2C52
	for <lists+kvm@lfdr.de>; Thu, 10 Jun 2021 15:00:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230506AbhFJNCn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Jun 2021 09:02:43 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:60958 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230035AbhFJNCn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Jun 2021 09:02:43 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1623330045;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZzkRlz8+MqeOaaHBWpHKuxVmWTuasJwPOdO8ljJCk0g=;
        b=exzVZMomiEpuYg1EmWtXdGSQv+zn10DAb7E6jodHrTleeODF2amKk5FLbTEiF66yVOOJyD
        WXIL5+kq6f12dAdqv+RC4Lt52VA+efoRwdPxyvpnMirXNDrKor6UZZZHkq353eBa4e0HKV
        omX9LkNotO+gELDGRcAhxmbZrF0kkykzJl1cLiaLOOeIACuHg8lbUzqJ8zfdElGwPvnXq0
        SgMtJjRAKbjU1N4pRZeylRBysTlBBT5oZwVe6JYI0+UDGRj3yIOrhRfGOEyVAhP1kiUn+B
        cew5dblrcvOLUplFvlD6RWdeEcjfDYc2fulWZPiShNxs5SfxbwhOthzv9h5mwA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1623330045;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZzkRlz8+MqeOaaHBWpHKuxVmWTuasJwPOdO8ljJCk0g=;
        b=21A3bT6ApPeJPmtO1SMUzY3kZTuGNpEQmJEvJ7TdEoOcsMxt67F5KSMo+6LHLHexpPtbSL
        H8VM9BXRoWxeWPAA==
To:     Dave Jiang <dave.jiang@intel.com>, alex.williamson@redhat.com,
        kwankhede@nvidia.com, vkoul@kernel.org, jgg@mellanox.com
Cc:     Jason Gunthorpe <jgg@nvidia.com>, megha.dey@intel.com,
        jacob.jun.pan@intel.com, ashok.raj@intel.com, yi.l.liu@intel.com,
        baolu.lu@intel.com, kevin.tian@intel.com, sanjay.k.kumar@intel.com,
        tony.luck@intel.com, dan.j.williams@intel.com,
        eric.auger@redhat.com, pbonzini@redhat.com,
        dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v6 05/20] vfio: mdev: common lib code for setting up Interrupt Message Store
In-Reply-To: <febc19ac-4105-fb83-709a-5d1fa5871b7e@intel.com>
References: <162164243591.261970.3439987543338120797.stgit@djiang5-desk3.ch.intel.com> <162164277624.261970.7989190254803052804.stgit@djiang5-desk3.ch.intel.com> <87pmx73tfw.ffs@nanos.tec.linutronix.de> <febc19ac-4105-fb83-709a-5d1fa5871b7e@intel.com>
Date:   Thu, 10 Jun 2021 15:00:45 +0200
Message-ID: <87im2lyiv6.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 08 2021 at 08:57, Dave Jiang wrote:
> On 5/31/2021 6:48 AM, Thomas Gleixner wrote:
>> What's unclear to me is under which circumstances does the IMS interrupt
>> require a PASID.
>>
>>     1) Always
>>     2) Use case dependent
>>
> Thomas, thank you for the review. I'll try to provide a summary below
> with what's going on with IMS after taking in yours and Jason's
> comments.

<snip>

No need to paste the manuals into mail.

</snip>

> DSA provides a way to skip PASID validation for IMS handles. This can
> be used if host kernel is the *only* agent generating work. Host
> usages without IOMMU scalable mode are not currently implemented.

So the IMS irq chip driver can do:

ims_array_alloc_msi_store(domain, dev)
{
        struct msi_domain_info *info =3D domain->host_data;
        struct ims_array_data *ims =3D info->data;

        if (ims->flags & VALIDATE_PASID) {
        	if (!valid_pasid(dev))
                	return -EINVAL;
        }

or something like that.

> The following is the call flow for mdev without vSVM support:
> 1.=C2=A0=C2=A0=C2=A0 idxd host driver sets PASID from iommu_aux_get_pasid=
() to =E2=80=98struct device=E2=80=99

Why needs every driver to implement that?

That should be part of the iommu management to store that.

> 2.=C2=A0=C2=A0=C2=A0 idxd guest driver calls request_irq()
> 3.=C2=A0=C2=A0=C2=A0 VFIO calls VFIO_DEVICE_SET_IRQS ioctl

How does the guest driver request_irq() end up in the VFIO ioctl on the
host?

> 4.=C2=A0=C2=A0=C2=A0 idxd host driver calls vfio_set_ims_trigger() (newly=
 created common helper function)
> 	a.=C2=A0=C2=A0=C2=A0 VFIO calls msi_domain_alloc_irqs() and programs val=
id 'struct device' PASID as auxdata to IMS entry

VFIO does not program anything into the IMS entry.

The IMS irq chip driver retrieves PASID from struct device and does
that. That can be part of the domain allocation function, but there is
no requirement to do so. It can be done later, e.g. when the interrupt
is started up.

> 	b.=C2=A0=C2=A0=C2=A0 Host driver calls request_irq() for IMS interrupts
>
> With a default pasid programmed to 'struct device', for this use case
> above we shouldn't have the need of programming pasid outside of
> irqchip.

s/shouldn't/do not/

> The following is the call flow for mdev with vSVM support:
> 1. idxd host driver sets PASID to mdev =E2=80=98struct device=E2=80=99 vi=
a iommu_aux_get_PASID()
> 2. idxd guest driver binds supervisor pasid
> 3. idxd guest driver calls request_irq()
> 4. VFIO calls VFIO_DEVICE_SET_IRQS ioctl
> 5. idxd host driver calls vfio_set_ims_trigger()
>    a. VFIO calls msi_domain_alloc_irqs() and programs PASID as auxdata to=
 IMS entry
>    b. Host driver calls request_irq() for IMS interrupts
> 6. idxd guest driver programs virtual device MSIX permission table with g=
uest PASID.
> 7. Host driver mdev MMIO emulation retrieves guest PASID from vdev
>    MSIXPERM table and matches to host PASID via ioasid_find_by_spid().
>    a. Host driver calls irq_set_auxdata() to change to the new PASID
>       for IMS entry.

What enforces this ordering? Certainly not the hardware.

The guest driver knows the guest PASID _before_ interrupts are allocated
or requested for the device. So it can store the guest PASID _before_ it
triggers the mechanism which makes vfio/host initialize the interrupts.

So no. It's not needed at all. It's pretty much the same as the host
side driver except for the that MSIXPERM stuff.

And just for the record. Setting MSIXPERM _after_ request_irq()
completed is just wrong because if an interrupt is raised _before_ that
MSIXPERM muck is set up, then it will fire with the host PASID and not
with the guest's.

This whole IDXD stuff has been a monstrous layering violation from the
very beginning and unfortunately this hasn't changed much since then.

Thanks,

        tglx
