Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50FE62EBC2C
	for <lists+kvm@lfdr.de>; Wed,  6 Jan 2021 11:12:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726695AbhAFKMG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jan 2021 05:12:06 -0500
Received: from mga03.intel.com ([134.134.136.65]:16400 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725941AbhAFKMG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jan 2021 05:12:06 -0500
IronPort-SDR: I7Qt2+AcbC1AMAKHLOSCbx0GAvvvBBybYL/p6OHCRt/xLXxjSnqLLrlNWDz3cYBLbUIedIxWpz
 F+RZR8/vvuDw==
X-IronPort-AV: E=McAfee;i="6000,8403,9855"; a="177357367"
X-IronPort-AV: E=Sophos;i="5.78,479,1599548400"; 
   d="scan'208";a="177357367"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2021 02:10:19 -0800
IronPort-SDR: d08z5hl0XnBjFC605NW3Hlw0yXQdq+NUzEy5P5L4DpQIY0tLy8DeV7WHHXWC+t/VS4vT0Em7qx
 t3sOQngMY85Q==
X-IronPort-AV: E=Sophos;i="5.78,479,1599548400"; 
   d="scan'208";a="379231175"
Received: from blu2-mobl3.ccr.corp.intel.com (HELO [10.255.29.66]) ([10.255.29.66])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2021 02:10:12 -0800
Cc:     baolu.lu@linux.intel.com, tglx@linutronix.de, ashok.raj@intel.com,
        kevin.tian@intel.com, dave.jiang@intel.com, megha.dey@intel.com,
        dwmw2@infradead.org, alex.williamson@redhat.com,
        bhelgaas@google.com, dan.j.williams@intel.com,
        dmaengine@vger.kernel.org, eric.auger@redhat.com,
        jacob.jun.pan@intel.com, jgg@mellanox.com, kvm@vger.kernel.org,
        kwankhede@nvidia.com, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, maz@kernel.org, mona.hossain@intel.com,
        netanelg@mellanox.com, parav@mellanox.com, pbonzini@redhat.com,
        rafael@kernel.org, samuel.ortiz@intel.com,
        sanjay.k.kumar@intel.com, shahafs@mellanox.com,
        tony.luck@intel.com, vkoul@kernel.org, yan.y.zhao@linux.intel.com,
        yi.l.liu@intel.com
To:     Leon Romanovsky <leon@kernel.org>
References: <20210106022749.2769057-1-baolu.lu@linux.intel.com>
 <20210106060613.GU31158@unreal>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Subject: Re: [RFC PATCH v2 1/1] platform-msi: Add platform check for subdevice
 irq domain
Message-ID: <3d2620f9-bbd4-3dd0-8e29-0cfe492a109f@linux.intel.com>
Date:   Wed, 6 Jan 2021 18:10:09 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210106060613.GU31158@unreal>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Leon,

On 2021/1/6 14:06, Leon Romanovsky wrote:
> On Wed, Jan 06, 2021 at 10:27:49AM +0800, Lu Baolu wrote:
>> The pci_subdevice_msi_create_irq_domain() should fail if the underlying
>> platform is not able to support IMS (Interrupt Message Storage). Otherwise,
>> the isolation of interrupt is not guaranteed.
>>
>> For x86, IMS is only supported on bare metal for now. We could enable it
>> in the virtualization environments in the future if interrupt HYPERCALL
>> domain is supported or the hardware has the capability of interrupt
>> isolation for subdevices.
>>
>> Suggested-by: Thomas Gleixner <tglx@linutronix.de>
>> Link: https://lore.kernel.org/linux-pci/87pn4nk7nn.fsf@nanos.tec.linutronix.de/
>> Link: https://lore.kernel.org/linux-pci/877dqrnzr3.fsf@nanos.tec.linutronix.de/
>> Link: https://lore.kernel.org/linux-pci/877dqqmc2h.fsf@nanos.tec.linutronix.de/
>> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
>> ---
>>   arch/x86/pci/common.c       | 47 +++++++++++++++++++++++++++++++++++++
>>   drivers/base/platform-msi.c |  8 +++++++
>>   include/linux/msi.h         |  1 +
>>   3 files changed, 56 insertions(+)
>>
>>
>> Background:
>> Learnt from the discussions in this thread:
>>
>> https://lore.kernel.org/linux-pci/160408357912.912050.17005584526266191420.stgit@djiang5-desk3.ch.intel.com/
>>
>> The device IMS (Interrupt Message Storage) should not be enabled in any
>> virtualization environments unless there is a HYPERCALL domain which
>> makes the changes in the message store managed by the hypervisor.
>>
>> As the initial step, we allow the IMS to be enabled only if we are
>> running on the bare metal. It's easy to enable IMS in the virtualization
>> environments if above preconditions are met in the future.
>>
>> We ever thought about moving on_bare_metal() to a generic file so that
>> it could be well maintained and used. But we need some suggestions about
>> where to put it. Your comments are very appreciated.
>>
>> This patch is only for comments purpose. Please don't merge it. We will
>> include it in the Intel IMS implementation later once we reach a
>> consensus.
>>
>> Change log:
>> v1->v2:
>>   - v1:
>>     https://lore.kernel.org/linux-pci/20201210004624.345282-1-baolu.lu@linux.intel.com/
>>   - Rename probably_on_bare_metal() with on_bare_metal();
>>   - Some vendors might use the same name for both bare metal and virtual
>>     environment. Before we add vendor specific code to distinguish
>>     between them, let's return false in on_bare_metal(). This won't
>>     introduce any regression. The only impact is that the coming new
>>     platform msi feature won't be supported until the vendor specific code
>>     is provided.
>>
>> Best regards,
>> baolu
>>
>> diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c
>> index 3507f456fcd0..963e0401f2b2 100644
>> --- a/arch/x86/pci/common.c
>> +++ b/arch/x86/pci/common.c
>> @@ -724,3 +724,50 @@ struct pci_dev *pci_real_dma_dev(struct pci_dev *dev)
>>   	return dev;
>>   }
>>   #endif
>> +
>> +/*
>> + * We want to figure out which context we are running in. But the hardware
>> + * does not introduce a reliable way (instruction, CPUID leaf, MSR, whatever)
>> + * which can be manipulated by the VMM to let the OS figure out where it runs.
>> + * So we go with the below probably on_bare_metal() function as a replacement
>> + * for definitely on_bare_metal() to go forward only for the very simple reason
>> + * that this is the only option we have.
>> + *
>> + * People might use the same vendor name for both bare metal and virtual
>> + * environment. We can remove those names once we have vendor specific code to
>> + * distinguish between them.
>> + */
>> +static const char * const vmm_vendor_name[] = {
>> +	"QEMU", "Bochs", "KVM", "Xen", "VMware", "VMW", "VMware Inc.",
>> +	"innotek GmbH", "Oracle Corporation", "Parallels", "BHYVE",
>> +	"Microsoft Corporation", "Amazon EC2"
>> +};
> 
> Maybe it is not concern at all, but this approach will make
> forward/backward compatibility without kernel upgrade impossible.
> 
> Once QEMU (example) will have needed support, someone will need to remove
> the QEMU from this array, rewrite on_bare_metal() because it is not bare
> vs. virtual anymore and require kernel upgrade/downgrade every time QEMU
> version is switched.
> 
> Plus need to update stable@ and distros.
> 
> I'm already feeling pain from the fields while they debug such code.
> 
> Am I missing it completely?

The basic need here is that we want to disallow a brand new feature
(device ims) to be enabled in any VMM environment.

The cpuid (X86_FEATURE_HYPERVISOR) is a good choice, but it's optional
and even not documented. So besides it, we maintain a block list
(vmm_vendor_name) which lists all possible VMM vendor names. If
dmi_match(DMI_SYS_VENDOR) hits, the new feature is not allowed to be
enabled.

This block list is a bit overkill since some vendor names could also be
used on bare metal. We will delay enabling the new feature for those
cases until we have a vendor-specific way to distinguish between bare
metal and VMM environments.

Honestly speaking, I can't see any compatible issue as it's common that
a new feature is supported in a new kernel but not in an old one.

Best regards,
baolu
