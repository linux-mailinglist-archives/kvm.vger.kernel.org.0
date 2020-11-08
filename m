Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 091262AAE1B
	for <lists+kvm@lfdr.de>; Sun,  8 Nov 2020 23:52:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728834AbgKHWwP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 8 Nov 2020 17:52:15 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:47660 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727929AbgKHWwP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 8 Nov 2020 17:52:15 -0500
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1604875932;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iODSmJrWhpBHFw4WVyCU6QOZq4bEiXIy+0UfEYR6iAk=;
        b=JBfoRQ7ZXE8PJjrgAD8cUuu5NTrqiIeGHV/HBgtF3AamymYJ7j/VqUWSUPIOiO5vGduk8G
        KUbE416GRSX53G3hleyg/f0LIFYqYk2Eyq5f1gQrs/E2xnPaWwvtTv8dZtffS6Ia/VFprf
        JfDaQK0PilZV3+hciX+TBkk3ruWhXFO6nDriBWc2R5cuhD8bC9a7Tal56CctTWCmb/awAC
        14b21WaZb22cEJci7Q91No7dC+zwpxwBJxm2MCHZ/Mscjc2bc4mu27DXopAt6+kvIDGB/Z
        F9iW1nIIHaJMqt7h+N55jh8o7jjiZKmWbx8K9yPnfFI9/g5PAfXVuMO1HHbx9A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1604875932;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iODSmJrWhpBHFw4WVyCU6QOZq4bEiXIy+0UfEYR6iAk=;
        b=ut+kIrWNfUTtGO1TlVz5y5sDe1bLbhRavo6A/SS0CMVmWj+4fvq5YEA8TsUOCxSrMSlIvu
        nujj4VKHNRoHLMAA==
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        "Tian\, Kevin" <kevin.tian@intel.com>,
        "Jiang\, Dave" <dave.jiang@intel.com>,
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
Subject: Re: [PATCH v4 06/17] PCI: add SIOV and IMS capability detection
In-Reply-To: <59034a932606e25c0b260540fff0b6dc.squirrel@twosheds.infradead.org>
References: <20201030224534.GN2620339@nvidia.com> <ec52cedf-3a99-5ca1-ffbb-d8f8c4f62395@intel.com> <20201102132158.GA3352700@nvidia.com> <MWHPR11MB1645675ED03E23674A705DF68C110@MWHPR11MB1645.namprd11.prod.outlook.com> <20201103124351.GM2620339@nvidia.com> <MWHPR11MB164544C9CFCC3F162C1C6FC18CEF0@MWHPR11MB1645.namprd11.prod.outlook.com> <20201104124017.GW2620339@nvidia.com> <MWHPR11MB1645862A8F7CF7FB8DD011778CEF0@MWHPR11MB1645.namprd11.prod.outlook.com> <20201104135415.GX2620339@nvidia.com> <MWHPR11MB1645524BDEDF8899914F32AE8CED0@MWHPR11MB1645.namprd11.prod.outlook.com> <20201106131415.GT2620339@nvidia.com> <87k0uvk0oc.fsf@nanos.tec.linutronix.de> <59034a932606e25c0b260540fff0b6dc.squirrel@twosheds.infradead.org>
Date:   Sun, 08 Nov 2020 23:52:11 +0100
Message-ID: <87eel3jwbo.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Nov 08 2020 at 22:09, David Woodhouse wrote:

>> On Fri, Nov 06 2020 at 09:14, Jason Gunthorpe wrote:
>>> On Fri, Nov 06, 2020 at 09:48:34AM +0000, Tian, Kevin wrote:
>>> For instance you could put a "disable IMS" flag in the ACPI tables, in
>>> the config space of the emuulated root port, or any other areas that
>>> clearly belong to the platform.
>>>
>>> The OS logic would be
>>>  - If no IMS information found then use IMS (Bare metal)
>>>  - If the IMS disable flag is found then
>>>    - If (future) hypercall available and the OS knows how to use it
>>>      then use IMS
>>>    - If no hypercall found, or no OS knowledge, fail IMS
>>
>> That does not work because an older hypervisor would not have that
>> disable flag and the guest kernel would assume to be on bare metal (if
>> no other indicators are there).
>
> In the absence of a forward-thinking design from Intel perhaps we could

Just to be fair the AMD interrupt remapping is not any better in that
regard.

Thanks,

        tglx
