Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EDA21C20A9
	for <lists+kvm@lfdr.de>; Sat,  2 May 2020 00:32:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726846AbgEAWc1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 May 2020 18:32:27 -0400
Received: from mga06.intel.com ([134.134.136.31]:10094 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726336AbgEAWc1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 May 2020 18:32:27 -0400
IronPort-SDR: f0+u7+J9+hGKItx22SsSHepKs4Tv2+fOwSgLss2UBrIiRb7EQmwESb2ELtLkBv23hu0mJVa/eP
 wI5fRsemTxEw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 May 2020 15:32:24 -0700
IronPort-SDR: MA0b7OEXeXwHqAlyPyIiO8/pS0/oOGBfwQy8vXXbGf81nV/laxLuuh4wXsWSEqTQK53owHKE7E
 PGc6R+IUW5tQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,341,1583222400"; 
   d="scan'208";a="248657118"
Received: from meghadey-mobl1.amr.corp.intel.com (HELO [10.251.135.85]) ([10.251.135.85])
  by fmsmga007.fm.intel.com with ESMTP; 01 May 2020 15:32:23 -0700
Subject: Re: [PATCH RFC 07/15] Documentation: Interrupt Message store
To:     Jason Gunthorpe <jgg@ziepe.ca>, Dave Jiang <dave.jiang@intel.com>
Cc:     vkoul@kernel.org, maz@kernel.org, bhelgaas@google.com,
        rafael@kernel.org, gregkh@linuxfoundation.org, tglx@linutronix.de,
        hpa@zytor.com, alex.williamson@redhat.com, jacob.jun.pan@intel.com,
        ashok.raj@intel.com, yi.l.liu@intel.com, baolu.lu@intel.com,
        kevin.tian@intel.com, sanjay.k.kumar@intel.com,
        tony.luck@intel.com, jing.lin@intel.com, dan.j.williams@intel.com,
        kwankhede@nvidia.com, eric.auger@redhat.com, parav@mellanox.com,
        dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-pci@vger.kernel.org, kvm@vger.kernel.org
References: <158751095889.36773.6009825070990637468.stgit@djiang5-desk3.ch.intel.com>
 <158751207000.36773.18208950543781892.stgit@djiang5-desk3.ch.intel.com>
 <20200423200436.GA29181@ziepe.ca>
From:   "Dey, Megha" <megha.dey@linux.intel.com>
Message-ID: <afd2ae49-ed65-5cde-c867-a923ac9bf8ac@linux.intel.com>
Date:   Fri, 1 May 2020 15:32:22 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200423200436.GA29181@ziepe.ca>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jason,

On 4/23/2020 1:04 PM, Jason Gunthorpe wrote:
> On Tue, Apr 21, 2020 at 04:34:30PM -0700, Dave Jiang wrote:
> 
>> diff --git a/Documentation/ims-howto.rst b/Documentation/ims-howto.rst
>> new file mode 100644
>> index 000000000000..a18de152b393
>> +++ b/Documentation/ims-howto.rst
>> @@ -0,0 +1,210 @@
>> +.. SPDX-License-Identifier: GPL-2.0
>> +.. include:: <isonum.txt>
>> +
>> +==========================
>> +The IMS Driver Guide HOWTO
>> +==========================
>> +
>> +:Authors: Megha Dey
>> +
>> +:Copyright: 2020 Intel Corporation
>> +
>> +About this guide
>> +================
>> +
>> +This guide describes the basics of Interrupt Message Store (IMS), the
>> +need to introduce a new interrupt mechanism, implementation details of
>> +IMS in the kernel, driver changes required to support IMS and the general
>> +misconceptions and FAQs associated with IMS.
> 
> I'm not sure why we need to call this IMS in kernel documentat? I know
> Intel is using this term, but this document is really only talking
> about extending the existing platform_msi stuff, which looks pretty
> good actually.

hmmm, so maybe we call it something else or just say dynamic platform-msi?

> 
> A lot of this is good for the cover letter..

Well, I got a lot of comments internally and externally about how the 
cover page needs to have just the basics and all the ugly details can go 
in the Documentation. So well, I am confused here.
> 
>> +Implementation of IMS in the kernel
>> +===================================
>> +
>> +The Linux kernel today already provides a generic mechanism to support
>> +non-PCI compliant MSI interrupts for platform devices (platform-msi.c).
>> +To support IMS interrupts, we create a new IMS IRQ domain and extend the
>> +existing infrastructure. Dynamic allocation of IMS vectors is a requirement
>> +for devices which support Scalable I/O Virtualization. A driver can allocate
>> +and free vectors not just once during probe (as was the case with MSI/MSI-X)
>> +but also in the post probe phase where actual demand is available. Thus, a
>> +new API, platform_msi_domain_alloc_irqs_group is introduced which drivers
>> +using IMS would be able to call multiple times. The vectors allocated each
>> +time this API is called are associated with a group ID. To free the vectors
>> +associated with a particular group, the platform_msi_domain_free_irqs_group
>> +API can be called. The existing drivers using platform-msi infrastructure
>> +will continue to use the existing alloc (platform_msi_domain_alloc_irqs)
>> +and free (platform_msi_domain_free_irqs) APIs and are assigned a default
>> +group ID of 0.
>> +
>> +Thus, platform-msi.c provides the generic methods which can be used by any
>> +non-pci MSI interrupt type while the newly created ims-msi.c provides IMS
>> +specific callbacks that can be used by drivers capable of generating IMS
>> +interrupts.
> 
> How exactly is an IMS interrupt is different from a platform msi?
> 
> It looks like it is just some thin wrapper around msi_domain - what is
> it for?

So I think conceptually, there is no difference between platform-msi and 
IMS. (Just thinking out loud).

 From a code stand-point, currently
1. Allocation of interrupts is static. I don't think the 
platform-msi-domain_alloc_irqs can be called multiple times.
2. only a write-msg callback is present and they use the parent IRQ 
chip's mask/unmask functions
3. IMS needs interrupt remapping support to be enabled (this is 
independent of the above 2).

If 1 and 2 is all that you are looking for, then we can split the code 
such that we have a generic platform_msi_domain_alloc_irqs_dyn, which 
will be used for the dynamic allocation of IRQs and another 
platform_msi_domain_alloc_irqs_ims (or whatever the name IMS will boil 
down to) which will use interrupt remapping support to get the IRQ 
domain etc.

> 
>> +FAQs and general misconceptions:
>> +================================
>> +
>> +** There were some concerns raised by Thomas Gleixner and Marc Zyngier
>> +during Linux plumbers conference 2019:
>> +
>> +1. Enumeration of IMS needs to be done by PCI core code and not by
>> +   individual device drivers:
>> +
>> +   Currently, if the kernel needs a generic way to discover IMS capability
>> +   without host driver dependency, the PCIE Designated Vendor specific
>> +
>> +   However, we cannot have a standard way of enumerating the IMS size
>> +   because for context based devices, the interrupt message is part of
>> +   the context itself which is managed entirely by the driver. Since
>> +   context creation is done on demand, there is no way to tell during boot
>> +   time, the maximum number of contexts (and hence the number of interrupt
>> +   messages)that the device can support.
> 
> FWIW, I agree with this
> 
> Like platform-msi, IMS should be controlled entirely by the driver.
yup!

> 
>> +2. Why is Intel designing a new interrupt mechanism rather than extending
>> +   MSI-X to address its limitations? Isn't 2048 device interrupts enough?
>> +
>> +   MSI-X has a rigid definition of one-table and on-device storage and does
>> +   not provide the full flexibility required for future multi-tile
>> +   accelerator designs.
>> +   IMS was envisioned to be used with large number of ADIs in devices where
>> +   each will need unique interrupt resources. For example, a DSA shared
>> +   work queue can support large number of clients where each client can
>> +   have its own interrupt. In future, with user interrupts, we expect the
>> +   demand for messages to increase further.
> 
> Generally agree
> 
ok!

>> +Device Driver Changes:
>> +=====================
>> +
>> +1. platform_msi_domain_alloc_irqs_group (struct device *dev, unsigned int
>> +   nvec, const struct platform_msi_ops *platform_ops, int *group_id)
>> +   to allocate IMS interrupts, where:
>> +
>> +   dev: The device for which to allocate interrupts
>> +   nvec: The number of interrupts to allocate
>> +   platform_ops: Callbacks for platform MSI ops (to be provided by driver)
>> +   group_id: returned by the call, to be used to free IRQs of a certain type
>> +
>> +   eg: static struct platform_msi_ops ims_ops  = {
>> +        .irq_mask               = ims_irq_mask,
>> +        .irq_unmask             = ims_irq_unmask,
>> +        .write_msg              = ims_write_msg,
>> +        };
>> +
>> +        int group;
>> +        platform_msi_domain_alloc_irqs_group (dev, nvec, platform_ops, &group)
>> +
>> +   where, struct platform_msi_ops:
>> +   irq_mask:   mask an interrupt source
>> +   irq_unmask: unmask an interrupt source
>> +   irq_write_msi_msg: write message content
>> +
>> +   This API can be called multiple times. Every time a new group will be
>> +   associated with the allocated vectors. Group ID starts from 0.
> 
> Need much more closer look, but this seems conceptually fine to me.
> 
> As above the API here is called platform_msi - which seems good to
> me. Again not sure why the word IMS is needed
>

well, in this case, ims_ops, ims_mask etc are just example names.

> Jason
> 
