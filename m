Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3F8C2DB8AD
	for <lists+kvm@lfdr.de>; Wed, 16 Dec 2020 02:57:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725783AbgLPB5g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Dec 2020 20:57:36 -0500
Received: from mga04.intel.com ([192.55.52.120]:46638 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725320AbgLPB5f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Dec 2020 20:57:35 -0500
IronPort-SDR: tj621VfwVxWq66F8R1TQGLpLx0p7wX8Ucs3yf9zL+F+F9rRGAv8ihiSOvH2yzRClxi+icnkDRw
 5aB50NXOa9fQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9836"; a="172415834"
X-IronPort-AV: E=Sophos;i="5.78,423,1599548400"; 
   d="scan'208";a="172415834"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2020 17:55:45 -0800
IronPort-SDR: Pg1VhJNtwxPPaY6JBu/qH0cJlUEndiFXtRPXSpkyQkH98HZkG9xQXfqVaR4ONNp2qL0sy0mhJx
 X6f+e4d/50wQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,423,1599548400"; 
   d="scan'208";a="384064484"
Received: from allen-box.sh.intel.com (HELO [10.239.159.28]) ([10.239.159.28])
  by fmsmga004.fm.intel.com with ESMTP; 15 Dec 2020 17:55:39 -0800
Cc:     baolu.lu@linux.intel.com, tglx@linutronix.de, ashok.raj@intel.com,
        kevin.tian@intel.com, dave.jiang@intel.com, megha.dey@intel.com,
        alex.williamson@redhat.com, bhelgaas@google.com,
        dan.j.williams@intel.com, dmaengine@vger.kernel.org,
        eric.auger@redhat.com, jacob.jun.pan@intel.com, jgg@mellanox.com,
        jing.lin@intel.com, kvm@vger.kernel.org, kwankhede@nvidia.com,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        maz@kernel.org, mona.hossain@intel.com, netanelg@mellanox.com,
        parav@mellanox.com, pbonzini@redhat.com, rafael@kernel.org,
        samuel.ortiz@intel.com, sanjay.k.kumar@intel.com,
        shahafs@mellanox.com, tony.luck@intel.com, vkoul@kernel.org,
        yan.y.zhao@linux.intel.com, yi.l.liu@intel.com
Subject: Re: [RFC PATCH 1/1] platform-msi: Add platform check for subdevice
 irq domain
To:     Bjorn Helgaas <helgaas@kernel.org>
References: <20201210185738.GA49060@bjorn-Precision-5520>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <f473fce5-2751-c103-4195-4d7858ac6b47@linux.intel.com>
Date:   Wed, 16 Dec 2020 09:48:03 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201210185738.GA49060@bjorn-Precision-5520>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Bjorn,

On 12/11/20 2:57 AM, Bjorn Helgaas wrote:
> On Thu, Dec 10, 2020 at 08:46:24AM +0800, Lu Baolu wrote:
>> The pci_subdevice_msi_create_irq_domain() should fail if the underlying
>> platform is not able to support IMS (Interrupt Message Storage). Otherwise,
>> the isolation of interrupt is not guaranteed.
>>
>> For x86, IMS is only supported on bare metal for now. We could enable it
>> in the virtualization environments in the future if interrupt HYPERCALL
>> domain is supported or the hardware has the capability of interrupt
>> isolation for subdevices.
> 
>> + * We want to figure out which context we are running in. But the hardware
>> + * does not introduce a reliable way (instruction, CPUID leaf, MSR, whatever)
>> + * which can be manipulated by the VMM to let the OS figure out where it runs.
>> + * So we go with the below probably_on_bare_metal() function as a replacement
>> + * for definitely_on_bare_metal() to go forward only for the very simple reason
>> + * that this is the only option we have.
>> + */
>> +static const char * const possible_vmm_vendor_name[] = {
>> +	"QEMU", "Bochs", "KVM", "Xen", "VMware", "VMW", "VMware Inc.",
>> +	"innotek GmbH", "Oracle Corporation", "Parallels", "BHYVE",
>> +	"Microsoft Corporation"
>> +};
>> +
>> +static bool probably_on_bare_metal(void)
> 
> What is the point of a function called probably_on_bare_metal()?
> *Probably*?  The caller can't really do anything with the fact that
> we're not 100% sure this gives the correct answer.  Just call it
> "on_bare_metal()" or something and accept the fact that it might be
> wrong sometimes.

Agreed. we can use on_bare_metal() and add comments and kernel messages
to let users and developers know that we're not 100% sure. People should
help to make it more accurate by reporting exceptions.

> 
> This patch goes with IMS support, which somebody else is handling, so
> I assume you don't need anything from the PCI side.

Yes. This is a followup of previous discussion.

Best regards,
baolu
