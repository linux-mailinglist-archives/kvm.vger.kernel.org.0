Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E97B2AB69C
	for <lists+kvm@lfdr.de>; Mon,  9 Nov 2020 12:21:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729519AbgKILV0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Nov 2020 06:21:26 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:50614 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726410AbgKILV0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Nov 2020 06:21:26 -0500
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1604920883;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hxcVhqjKdQHN16Wn3gUojFzP/H3f36IpHuQYN7w2nQI=;
        b=1B0+YQRFrSFk5OrFMiUeH3HdISYFobPGE4d3D+BkpzyRy38zuyERt09Rkm9uO2ZY3CY1NB
        kyFSlEvTB2+DF9n0XWsfu2ElNP9IjzyWj/tyWlp4zJ6ButCB261QzJlXHR4xgSZf/wrvcs
        yyFFG4OUniWs/03B4OJmQ/eZ4ORncR9qd361IVTMibsC4vk4A07EwQfQTZh7Yeqxhl3hWN
        rR1Y+mVdRaaeGHSc+rTyvnKws59f/YKosQZedImPymYrHGwGMJkqpV0NWckzueLRGQUjwR
        VdRpkPzgm1pv9i6uwL+G/uzLZmRZo350nTDrVDDqOtoWTMxWma7VoMgEqCSKdQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1604920883;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hxcVhqjKdQHN16Wn3gUojFzP/H3f36IpHuQYN7w2nQI=;
        b=5Dsc74gZMaZXEqZt6OB04kg/o9ah6ktGvPF95Gk3AcboYZaDk6iZ/dHqSAWwoSdn1uFjk1
        KN1GqptgfM4mZDDA==
To:     "Raj\, Ashok" <ashok.raj@intel.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Dan Williams <dan.j.williams@intel.com>,
        "Tian\, Kevin" <kevin.tian@intel.com>,
        "Jiang\, Dave" <dave.jiang@intel.com>,
        Bjorn Helgaas <helgaas@kernel.org>,
        "vkoul\@kernel.org" <vkoul@kernel.org>,
        "Dey\, Megha" <megha.dey@intel.com>,
        "maz\@kernel.org" <maz@kernel.org>,
        "bhelgaas\@google.com" <bhelgaas@google.com>,
        "alex.williamson\@redhat.com" <alex.williamson@redhat.com>,
        "Pan\, Jacob jun" <jacob.jun.pan@intel.com>,
        "Liu\, Yi L" <yi.l.liu@intel.com>,
        "Lu\, Baolu" <baolu.lu@intel.com>,
        "Kumar\, Sanjay K" <sanjay.k.kumar@intel.com>,
        "Luck\, Tony" <tony.luck@intel.com>,
        "kwankhede\@nvidia.com" <kwankhede@nvidia.com>,
        "eric.auger\@redhat.com" <eric.auger@redhat.com>,
        "parav\@mellanox.com" <parav@mellanox.com>,
        "rafael\@kernel.org" <rafael@kernel.org>,
        "netanelg\@mellanox.com" <netanelg@mellanox.com>,
        "shahafs\@mellanox.com" <shahafs@mellanox.com>,
        "yan.y.zhao\@linux.intel.com" <yan.y.zhao@linux.intel.com>,
        "pbonzini\@redhat.com" <pbonzini@redhat.com>,
        "Ortiz\, Samuel" <samuel.ortiz@intel.com>,
        "Hossain\, Mona" <mona.hossain@intel.com>,
        "dmaengine\@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci\@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "kvm\@vger.kernel.org" <kvm@vger.kernel.org>,
        Ashok Raj <ashok.raj@intel.com>
Subject: Re: [PATCH v4 06/17] PCI: add SIOV and IMS capability detection
In-Reply-To: <20201108235852.GC32074@araj-mobl1.jf.intel.com>
References: <20201104124017.GW2620339@nvidia.com> <MWHPR11MB1645862A8F7CF7FB8DD011778CEF0@MWHPR11MB1645.namprd11.prod.outlook.com> <20201104135415.GX2620339@nvidia.com> <MWHPR11MB1645524BDEDF8899914F32AE8CED0@MWHPR11MB1645.namprd11.prod.outlook.com> <20201106131415.GT2620339@nvidia.com> <20201106164850.GA85879@otc-nc-03> <20201106175131.GW2620339@nvidia.com> <CAPcyv4iYHA1acfo=+fTk+U_TrLbSWJjA6v4oeTXgVYDTrnCoGw@mail.gmail.com> <20201107001207.GA2620339@nvidia.com> <87pn4nk7nn.fsf@nanos.tec.linutronix.de> <20201108235852.GC32074@araj-mobl1.jf.intel.com>
Date:   Mon, 09 Nov 2020 12:21:22 +0100
Message-ID: <874klykc7h.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Nov 08 2020 at 15:58, Ashok Raj wrote:
> On Sun, Nov 08, 2020 at 07:47:24PM +0100, Thomas Gleixner wrote:
>> 
>> 
>> Now if we look at the virtualization scenario and device hand through
>> then the structure in the guest view is not any different from the basic
>> case. This works with PCI-MSI[X] and the IDXD IMS variant because the
>> hypervisor can trap the access to the storage and translate the message:
>> 
>>                    |
>>                    |
>>   [CPU]    -- [Bri | dge] -- Bus -- [Device]
>>                    |
>>   Alloc +
>>   Compose                   Store     Use
>>                              |
>>                              | Trap
>>                              v
>>                              Hypervisor translates and stores
>> 
>
> The above case, VMM is responsible for writing to the message
> store. In both cases if its IMS or Legacy MSI/MSIx. VMM handles
> the writes to the device interrupt region and to the IRTE tables.

Yes, but that's just how it's done today and there is no real need to do
so.

>> Now the question which I can't answer is whether this can work correctly
>> in terms of isolation. If the IMS storage is in guest memory (queue
>> storage) then the guest driver can obviously write random crap into it
>> which the device will happily send. (For MSI and IDXD style IMS it
>> still can trap the store).
>
> The isolation problem is not just the guest memory being used as interrrupt
> store right? If the Store to device region is not trapped and controlled by 
> VMM, there is no gaurantee the guest OS has done the right thing?
>
> Thinking about it, guest memory might be more problematic since its not
> trappable and VMM can't enforce what is written. This is something that
> needs more attension. But for now the devices supporting memory on device
> the trap and store by VMM seems to satisfy the security properties you
> highlight here.

That's not the problem at all. The VMM is not responsible for the
correctness of the guest OS at all. All the VMM cares about is that the
guest cannot access anything which does not belong to the guest.

If the guest OS screws up the message (by stupidity or malice), then the
MSI sent from the passed through device has to be caught by the
IOMMU/remap unit if an _only_ if it writes to something which it is not
allowed to.

If it overwrites the guests memory then so be it. The VMM cannot prevent
the guest OS doing so by a stray pointer either. So why would it worry
about the MSI going into guest owned lala land?

>> Is the IOMMU/Interrupt remapping unit able to catch such messages which
>> go outside the space to which the guest is allowed to signal to? If yes,
>> problem solved. If no, then IMS storage in guest memory can't ever work.
>
> This can probably work for SRIOV devices where guest owns the entire device.
> interrupt remap does have RID checks if interrupt arrives at an Interrupt handle
> not allocated for that BDF.
>
> But for SIOV devices there is no PASID filtering at the remap level since
> interrupt messages don't carry PASID in the TLP.

PASID is irrelevant here.

If the device sends a message then the remap unit will see the requester
ID of the device and if the message it sends is not matching the remap
tables then it's caught and the guest is terminated. At least that's how
it should be.

>> But there's a catch:
>> 
>> This only works when the guest OS actually knows that it runs in a
>> VM. If the guest can't figure that out, i.e. via CPUID, this cannot be
>
> Precicely!. It might work if the OS is new, but for legacy the trap-emulate
> seems both safe and works for legacy as well?

Again, trap emulate does not work for IMS when the IMS store is software
managed guest memory and not part of the device. And that's the whole
reason why we are discussing this.

Thanks,

        tglx
