Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D2A731450E
	for <lists+kvm@lfdr.de>; Tue,  9 Feb 2021 01:46:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbhBIAqd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Feb 2021 19:46:33 -0500
Received: from mga07.intel.com ([134.134.136.100]:34289 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229545AbhBIAqb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Feb 2021 19:46:31 -0500
IronPort-SDR: 4z8v5yUdjK0xIw9MRgmMisc9g9CNqg/rVn61bSMIncvc6mR2X+NTT4qhy4soXi3FGnpyV/7k29
 A91Pdtj9d08Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9889"; a="245876489"
X-IronPort-AV: E=Sophos;i="5.81,163,1610438400"; 
   d="scan'208";a="245876489"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2021 16:44:44 -0800
IronPort-SDR: enOuzo18U2oGng79sCChbSrbRM4bcsc9GQgCOvaOuEffFQ0NISs9JtDKtOPC8yFunfxI8n8w9g
 AsjDfiVFX3tg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,163,1610438400"; 
   d="scan'208";a="411603615"
Received: from allen-box.sh.intel.com (HELO [10.239.159.128]) ([10.239.159.128])
  by fmsmga004.fm.intel.com with ESMTP; 08 Feb 2021 16:44:39 -0800
Cc:     baolu.lu@linux.intel.com, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, dave.jiang@intel.com,
        ashok.raj@intel.com, kevin.tian@intel.com, dwmw@amazon.co.uk,
        x86@kernel.org, tony.luck@intel.com, dan.j.williams@intel.com,
        jgg@mellanox.com, kvm@vger.kernel.org,
        iommu@lists.linux-foundation.org, alex.williamson@redhat.com,
        bhelgaas@google.com, maz@kernel.org, linux-pci@vger.kernel.org,
        ravi.v.shankar@intel.com
Subject: Re: [PATCH 11/12] platform-msi: Add platform check for subdevice irq
 domain
To:     Leon Romanovsky <leon@kernel.org>, Megha Dey <megha.dey@intel.com>
References: <1612385805-3412-1-git-send-email-megha.dey@intel.com>
 <1612385805-3412-12-git-send-email-megha.dey@intel.com>
 <20210208082148.GA20265@unreal>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <b1ca6094-b561-1962-69a2-e6b678c42d3a@linux.intel.com>
Date:   Tue, 9 Feb 2021 08:36:08 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210208082148.GA20265@unreal>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Leon,

On 2/8/21 4:21 PM, Leon Romanovsky wrote:
> On Wed, Feb 03, 2021 at 12:56:44PM -0800, Megha Dey wrote:
>> From: Lu Baolu <baolu.lu@linux.intel.com>
>>
>> The pci_subdevice_msi_create_irq_domain() should fail if the underlying
>> platform is not able to support IMS (Interrupt Message Storage). Otherwise,
>> the isolation of interrupt is not guaranteed.
>>
>> For x86, IMS is only supported on bare metal for now. We could enable it
>> in the virtualization environments in the future if interrupt HYPERCALL
>> domain is supported or the hardware has the capability of interrupt
>> isolation for subdevices.
>>
>> Cc: David Woodhouse <dwmw@amazon.co.uk>
>> Cc: Leon Romanovsky <leon@kernel.org>
>> Cc: Kevin Tian <kevin.tian@intel.com>
>> Suggested-by: Thomas Gleixner <tglx@linutronix.de>
>> Link: https://lore.kernel.org/linux-pci/87pn4nk7nn.fsf@nanos.tec.linutronix.de/
>> Link: https://lore.kernel.org/linux-pci/877dqrnzr3.fsf@nanos.tec.linutronix.de/
>> Link: https://lore.kernel.org/linux-pci/877dqqmc2h.fsf@nanos.tec.linutronix.de/
>> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
>> Signed-off-by: Megha Dey <megha.dey@intel.com>
>> ---
>>   arch/x86/pci/common.c       | 74 +++++++++++++++++++++++++++++++++++++++++++++
>>   drivers/base/platform-msi.c |  8 +++++
>>   include/linux/msi.h         |  1 +
>>   3 files changed, 83 insertions(+)
>>
>> diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c
>> index 3507f45..263ccf6 100644
>> --- a/arch/x86/pci/common.c
>> +++ b/arch/x86/pci/common.c
>> @@ -12,6 +12,8 @@
>>   #include <linux/init.h>
>>   #include <linux/dmi.h>
>>   #include <linux/slab.h>
>> +#include <linux/iommu.h>
>> +#include <linux/msi.h>
>>
>>   #include <asm/acpi.h>
>>   #include <asm/segment.h>
>> @@ -724,3 +726,75 @@ struct pci_dev *pci_real_dma_dev(struct pci_dev *dev)
>>   	return dev;
>>   }
>>   #endif
>> +
>> +#ifdef CONFIG_DEVICE_MSI
> 
> Sorry for my naive question, but I see it in all your patches in this series
> and wonder why did you wrap everything with ifdefs?.

The added code is only called when DEVICE_MSI is configured.

> 
> All *.c code is wrapped with those ifdefs, which is hard to navigate and
> unlikely to give any code/size optimization benefit if kernel is compiled
> without CONFIG_DEVICE_MSI. The more common approach is to put those
> ifdef in the public header files and leave to the compiler to drop not
> called functions.

Yes. This looks better.

> 
> Thanks
> 

Best regards,
baolu
