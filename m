Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99AC222AB14
	for <lists+kvm@lfdr.de>; Thu, 23 Jul 2020 10:53:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727118AbgGWIv4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jul 2020 04:51:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:46020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725858AbgGWIvz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jul 2020 04:51:55 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B3B72071A;
        Thu, 23 Jul 2020 08:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595494314;
        bh=IRF2/hQ81/fJN2jLe+emwgKLQGhbq9l8YIf8OxkkSik=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JoLsejGOUeUv83nQAMznfUoFwoaNSxjbwr27sVlLosQjoq8SM2k7dgTUgxUvKR+8r
         zYhfXQFkgR18bjjIH+98j5xi2EK4WyKJq63OkADl9v+HxRRQj9Pgwx7OxMUDW18eS2
         5B4NMpR85PDvoLQsxH3EtQR8ml/ZXD0/LjkdFNnk=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jyWxE-00EDOw-Q3; Thu, 23 Jul 2020 09:51:52 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 23 Jul 2020 09:51:52 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Jason Gunthorpe <jgg@mellanox.com>
Cc:     Dave Jiang <dave.jiang@intel.com>, vkoul@kernel.org,
        megha.dey@intel.com, bhelgaas@google.com, rafael@kernel.org,
        gregkh@linuxfoundation.org, tglx@linutronix.de, hpa@zytor.com,
        alex.williamson@redhat.com, jacob.jun.pan@intel.com,
        ashok.raj@intel.com, yi.l.liu@intel.com, baolu.lu@intel.com,
        kevin.tian@intel.com, sanjay.k.kumar@intel.com,
        tony.luck@intel.com, jing.lin@intel.com, dan.j.williams@intel.com,
        kwankhede@nvidia.com, eric.auger@redhat.com, parav@mellanox.com,
        dave.hansen@intel.com, netanelg@mellanox.com, shahafs@mellanox.com,
        yan.y.zhao@linux.intel.com, pbonzini@redhat.com,
        samuel.ortiz@intel.com, mona.hossain@intel.com,
        dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-pci@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH RFC v2 02/18] irq/dev-msi: Add support for a new DEV_MSI
 irq domain
In-Reply-To: <20200722195928.GN2021248@mellanox.com>
References: <159534667974.28840.2045034360240786644.stgit@djiang5-desk3.ch.intel.com>
 <159534734833.28840.10067945890695808535.stgit@djiang5-desk3.ch.intel.com>
 <878sfbxtzi.wl-maz@kernel.org> <20200722195928.GN2021248@mellanox.com>
User-Agent: Roundcube Webmail/1.4.5
Message-ID: <cfb8191e364e77f352b1483c415a83a5@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: jgg@mellanox.com, dave.jiang@intel.com, vkoul@kernel.org, megha.dey@intel.com, bhelgaas@google.com, rafael@kernel.org, gregkh@linuxfoundation.org, tglx@linutronix.de, hpa@zytor.com, alex.williamson@redhat.com, jacob.jun.pan@intel.com, ashok.raj@intel.com, yi.l.liu@intel.com, baolu.lu@intel.com, kevin.tian@intel.com, sanjay.k.kumar@intel.com, tony.luck@intel.com, jing.lin@intel.com, dan.j.williams@intel.com, kwankhede@nvidia.com, eric.auger@redhat.com, parav@mellanox.com, dave.hansen@intel.com, netanelg@mellanox.com, shahafs@mellanox.com, yan.y.zhao@linux.intel.com, pbonzini@redhat.com, samuel.ortiz@intel.com, mona.hossain@intel.com, dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org, linux-pci@vger.kernel.org, kvm@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-07-22 20:59, Jason Gunthorpe wrote:
> On Wed, Jul 22, 2020 at 07:52:33PM +0100, Marc Zyngier wrote:
> 
>> Which is exactly what platform-MSI already does. Why do we need
>> something else?
> 
> It looks to me like all the code is around managing the
> dev->msi_domain of the devices.
> 
> The intended use would have PCI drivers create children devices using
> mdev or virtbus and those devices wouldn't have a msi_domain from the
> platform. Looks like platform_msi_alloc_priv_data() fails immediately
> because dev->msi_domain will be NULL for these kinds of devices.
> 
> Maybe that issue should be handled directly instead of wrappering
> platform_msi_*?
> 
> For instance a trivial addition to the platform_msi API:
> 
>   platform_msi_assign_domain(struct_device 
> *newly_created_virtual_device,
>                              struct device *physical_device);
> 
> Which could set the msi_domain of new device using the topology of
> physical_device to deduce the correct domain?

That would seem like a sensible course of action, as losing
the topology information will likely result in problems down
the line.

> Then the question is how to properly create a domain within the
> hardware topology of physical_device with the correct parameters for
> the platform.
> 
> Why do we need a dummy msi_domain anyhow? Can this just use
> physical_device->msi_domain directly? (I'm at my limit here of how
> much of this I remember, sorry)

The parent device would be a PCI device, if I follow you correctly.
It would thus expect to be able to program the MSI the PCI way,
which wouldn't work. So we end-up with this custom MSI domain
that knows about *this* particular family of devices.

> If you solve that it should solve the remapping problem too, as the
> physical_device is already assigned by the platform to a remapping irq
> domain if that is what the platform wants.
> 
>>> +	parent = irq_get_default_host();
>> Really? How is it going to work once you have devices sending their
>> MSIs to two different downstream blocks? This looks rather
>> short-sighted.
> 
> .. and fix this too, the parent domain should be derived from the
> topology of the physical_device which is originating the interrupt
> messages.
> 
>> On the other hand, masking an interrupt is an irqchip operation, and
>> only concerns the irqchip level. Here, you seem to be making it an
>> end-point operation, which doesn't really make sense to me. Or is this
>> device its own interrupt controller as well? That would be extremely
>> surprising, and I'd expect some block downstream of the device to be
>> able to control the masking of the interrupt.
> 
> These are message interrupts so they originate directly from the
> device and generally travel directly to the CPU APIC. On the wire
> there is no difference between a MSI, MSI-X and a device using the
> dev-msi approach.

I understand that.

> IIRC on Intel/AMD at least once a MSI is launched it is not maskable.

Really? So you can't shut a device with a screaming interrupt,
for example, should it become otherwise unresponsive?

> So the model for MSI is always "mask at source". The closest mapping
> to the Linux IRQ model is to say the end device has a irqchip that
> encapsulates the ability of the device to generate the MSI in the
> first place.

This is an x86'ism, I'm afraid. Systems I deal with can mask any
interrupt at the interrupt controller level, MSI or not.

> It looks like existing platform_msi drivers deal with "masking"
> implicitly by halting the device interrupt generation before releasing
> the interrupt and have no way for the generic irqchip layer to mask
> the interrupt.

No. As I said above, the interrupt controller is perfectly capable
of masking interrupts on its own, without touching the device.

> I suppose the motivation to make it explicit is related to vfio using
> the generic mask/unmask functionality?
> 
> Explicit seems better, IMHO.

If masking at the source is the only way to shut the device up,
and assuming that the device provides the expected semantics
(a MSI raised by the device while the interrupt is masked
isn't lost and gets sent when unmasked), that's fair enough.
It's just ugly.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
