Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5755E2AA1D0
	for <lists+kvm@lfdr.de>; Sat,  7 Nov 2020 01:32:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728317AbgKGAc1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Nov 2020 19:32:27 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:38882 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726447AbgKGAc1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Nov 2020 19:32:27 -0500
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1604709144;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4ezhNTBs+WBApggKiVHp4hAcpNfoQYkvzB7tR6XhKr0=;
        b=rkqby1zPNsirxlaigafN6XGyM5UA1C7B0lNj6MWG0awGOfCBXMSQPqMGqwSjC69vDDidWc
        4kK3bTXLz+dAuX/XMmrbhSrLq54Fap68dtU+XkdInV4B4OK5cGLjtwkubryZsquSe82gre
        dk3MEZvSedIOIRza0QgFZmAydK2hnkaq/slKTjPC0dNHGkvuqN8qWgu7RoRG7RNRYaH+Uf
        Q88DcsKu0m//Jg+F9cBKkdqmEkHRcS6YijwX9F07fg5MqPOE5Ey6yqRjYC1XEBgP2+7kTp
        9buZsC6d3F/aDSyQrE1zbDASgmv6TcRaGwj4si7Igr1XqPnWsxHGNpMWAUsrNQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1604709144;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4ezhNTBs+WBApggKiVHp4hAcpNfoQYkvzB7tR6XhKr0=;
        b=ZHpWJfa1YPflTYTKk64pbTfgPs37n5w9mN3c+7UIcuqNnpvtOD3Rnzc9+TNOc4biyZp6tK
        FyIpzTXGEg1r/DCg==
To:     "Tian\, Kevin" <kevin.tian@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     "Jiang\, Dave" <dave.jiang@intel.com>,
        Bjorn Helgaas <helgaas@kernel.org>,
        "vkoul\@kernel.org" <vkoul@kernel.org>,
        "Dey\, Megha" <megha.dey@intel.com>,
        "maz\@kernel.org" <maz@kernel.org>,
        "bhelgaas\@google.com" <bhelgaas@google.com>,
        "alex.williamson\@redhat.com" <alex.williamson@redhat.com>,
        "Pan\, Jacob jun" <jacob.jun.pan@intel.com>,
        "Raj\, Ashok" <ashok.raj@intel.com>,
        "Liu\, Yi L" <yi.l.liu@intel.com>,
        "Lu\, Baolu" <baolu.lu@intel.com>,
        "Kumar\, Sanjay K" <sanjay.k.kumar@intel.com>,
        "Luck\, Tony" <tony.luck@intel.com>,
        "jing.lin\@intel.com" <jing.lin@intel.com>,
        "Williams\, Dan J" <dan.j.williams@intel.com>,
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
        "kvm\@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH v4 06/17] PCI: add SIOV and IMS capability detection
In-Reply-To: <MWHPR11MB1645524BDEDF8899914F32AE8CED0@MWHPR11MB1645.namprd11.prod.outlook.com>
References: <20201030195159.GA589138@bjorn-Precision-5520> <71da5f66-e929-bab1-a1c6-a9ac9627a141@intel.com> <20201030224534.GN2620339@nvidia.com> <ec52cedf-3a99-5ca1-ffbb-d8f8c4f62395@intel.com> <20201102132158.GA3352700@nvidia.com> <MWHPR11MB1645675ED03E23674A705DF68C110@MWHPR11MB1645.namprd11.prod.outlook.com> <20201103124351.GM2620339@nvidia.com> <MWHPR11MB164544C9CFCC3F162C1C6FC18CEF0@MWHPR11MB1645.namprd11.prod.outlook.com> <20201104124017.GW2620339@nvidia.com> <MWHPR11MB1645862A8F7CF7FB8DD011778CEF0@MWHPR11MB1645.namprd11.prod.outlook.com> <20201104135415.GX2620339@nvidia.com> <MWHPR11MB1645524BDEDF8899914F32AE8CED0@MWHPR11MB1645.namprd11.prod.outlook.com>
Date:   Sat, 07 Nov 2020 01:32:23 +0100
Message-ID: <871rh6knvs.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 06 2020 at 09:48, Kevin Tian wrote:
>> From: Jason Gunthorpe <jgg@nvidia.com>
>> On Wed, Nov 04, 2020 at 01:34:08PM +0000, Tian, Kevin wrote:
>> The interrupt controller is responsible to create an addr/data pair
>> for an interrupt message. It sets the message format and ensures it
>> routes to the proper CPU interrupt handler. Everything about the
>> addr/data pair is owned by the platform interrupt controller.
>> 
>> Devices do not create interrupts. They only trigger the addr/data pair
>> the platform gives them.
>
> I guess that we may just view it from different angles. On x86 platform,
> a MSI/IMS capable device directly composes interrupt messages, with 
> addr/data pair filled by OS. If there is no IOMMU remapping enabled in 
> the middle, the message just hits the CPU. Your description possibly
> is from software side, e.g. describing the hierarchical IRQ domain
> concept?

No. The device composes nothing. If the interrupt is raised in the
device then the MSI block sends the message which was composed by the OS
and stored in the device's message store. For PCI/MSI that's the MSI or
MSIX table and for IMS that's either on device memory (as IDXD uses) or
some completely different location which Jason described.

This has absolutely nothing to do with the X86 platform. MSI is a
architecture independent mechanism: Send whatever the OS put into the
storage to raise an interrupt in the CPU. The device does neither know
whether that message is going to be intercepted by an interrupt
remapping unit or not.

Stop claiming that any of this has anything to do with x86. It has
absolutely nothing to do with x86 and looking at MSI from an x86
perspective instead of looking at it from the architecture agnostic
technical reality of MSI is the reason why we have this discussion at
all.

We had a similar discussion vs. the way how IMS interrupts have to be
dealt with in terms of irq domains. Can you finally stop looking at
everything as a big x86/intel/platform lump and understand that things
are very well structured and seperated both at the hardware and at the
software level? 

> Do you mind providing the link? There were lots of discussions between
> you and Thomas. I failed to locate the exact mail when searching above
> keywords. 

In this thread: 20200821002424.119492231@linutronix.de and you were on
Cc

Thanks,

        tglx


