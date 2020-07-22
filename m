Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D49E229DCE
	for <lists+kvm@lfdr.de>; Wed, 22 Jul 2020 19:06:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731652AbgGVRF5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jul 2020 13:05:57 -0400
Received: from mga07.intel.com ([134.134.136.100]:13822 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726157AbgGVRF5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jul 2020 13:05:57 -0400
IronPort-SDR: /oCfT+a9GmLu2AXGt3FjF+8zo4mNtJiSqKHdPDGK41mGHd4DmO2Ob4CP7hSRNKzkhyogXEXBi1
 Nq4nrUShJmkw==
X-IronPort-AV: E=McAfee;i="6000,8403,9690"; a="215008550"
X-IronPort-AV: E=Sophos;i="5.75,383,1589266800"; 
   d="scan'208";a="215008550"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2020 10:05:56 -0700
IronPort-SDR: LzRvidCjs/m9a564knoOx4ZyoubMuvJUXEs5TAVSzPayEV+nJ1bEljsUkzKx5PKhBUpJ5lZR9x
 GVzVn7GWImyg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,383,1589266800"; 
   d="scan'208";a="328276703"
Received: from orsmsx101.amr.corp.intel.com ([10.22.225.128])
  by orsmga007.jf.intel.com with ESMTP; 22 Jul 2020 10:05:56 -0700
Received: from [10.254.181.38] (10.254.181.38) by ORSMSX101.amr.corp.intel.com
 (10.22.225.128) with Microsoft SMTP Server (TLS) id 14.3.439.0; Wed, 22 Jul
 2020 10:05:55 -0700
Subject: Re: [PATCH RFC v2 04/18] irq/dev-msi: Introduce APIs to allocate/free
 dev-msi interrupts
To:     Jason Gunthorpe <jgg@mellanox.com>,
        Dave Jiang <dave.jiang@intel.com>
CC:     <vkoul@kernel.org>, <maz@kernel.org>, <bhelgaas@google.com>,
        <rafael@kernel.org>, <gregkh@linuxfoundation.org>,
        <tglx@linutronix.de>, <hpa@zytor.com>,
        <alex.williamson@redhat.com>, <jacob.jun.pan@intel.com>,
        <ashok.raj@intel.com>, <yi.l.liu@intel.com>, <baolu.lu@intel.com>,
        <kevin.tian@intel.com>, <sanjay.k.kumar@intel.com>,
        <tony.luck@intel.com>, <jing.lin@intel.com>,
        <dan.j.williams@intel.com>, <kwankhede@nvidia.com>,
        <eric.auger@redhat.com>, <parav@mellanox.com>,
        <dave.hansen@intel.com>, <netanelg@mellanox.com>,
        <shahafs@mellanox.com>, <yan.y.zhao@linux.intel.com>,
        <pbonzini@redhat.com>, <samuel.ortiz@intel.com>,
        <mona.hossain@intel.com>, <dmaengine@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
        <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>
References: <159534667974.28840.2045034360240786644.stgit@djiang5-desk3.ch.intel.com>
 <159534736176.28840.5547007059232964457.stgit@djiang5-desk3.ch.intel.com>
 <20200721162501.GC2021248@mellanox.com>
From:   "Dey, Megha" <megha.dey@intel.com>
Message-ID: <b3bc68b3-937e-4b64-e1c7-84942d7ba60c@intel.com>
Date:   Wed, 22 Jul 2020 10:05:52 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200721162501.GC2021248@mellanox.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.254.181.38]
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7/21/2020 9:25 AM, Jason Gunthorpe wrote:
> On Tue, Jul 21, 2020 at 09:02:41AM -0700, Dave Jiang wrote:
>> From: Megha Dey <megha.dey@intel.com>
>>
>> The dev-msi interrupts are to be allocated/freed only for custom devices,
>> not standard PCI-MSIX devices.
>>
>> These interrupts are device-defined and they are distinct from the already
>> existing msi interrupts:
>> pci-msi: Standard PCI MSI/MSI-X setup format
>> platform-msi: Platform custom, but device-driver opaque MSI setup/control
>> arch-msi: fallback for devices not assigned to the generic PCI domain
>> dev-msi: device defined IRQ domain for ancillary devices. For e.g. DSA
>> portal devices use device specific IMS(Interrupt message store) interrupts.
>>
>> dev-msi interrupts are represented by their own device-type. That means
>> dev->msi_list is never contended for different interrupt types. It
>> will either be all PCI-MSI or all device-defined.
> 
> Not sure I follow this, where is the enforcement that only dev-msi or
> normal MSI is being used at one time on a single struct device?
> 

So, in the dev_msi_alloc_irqs, I first check if the dev_is_pci..
If it is a pci device, it is forbidden to use dev-msi and must use the 
pci subsystem calls. dev-msi is to be used for all other custom devices, 
mdev or otherwise.

> Jason
> 
