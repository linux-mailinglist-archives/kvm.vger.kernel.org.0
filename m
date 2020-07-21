Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C001B2287DF
	for <lists+kvm@lfdr.de>; Tue, 21 Jul 2020 20:00:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728268AbgGUSAW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 14:00:22 -0400
Received: from mga09.intel.com ([134.134.136.24]:29365 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726763AbgGUSAV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jul 2020 14:00:21 -0400
IronPort-SDR: 5QY5WCdYiNtGtkyg7Bg6gOqyPONksVYq+b4ioetY1Lte4vd3AxLDw/Ajq5IpXdbVIo9NuxjNL9
 qGuDMTdzRXjA==
X-IronPort-AV: E=McAfee;i="6000,8403,9689"; a="151532424"
X-IronPort-AV: E=Sophos;i="5.75,379,1589266800"; 
   d="scan'208";a="151532424"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2020 11:00:19 -0700
IronPort-SDR: kSghhxgbuS19smyd22Tdxc6QQIG/3ciu7LvWnX5tU04uP38AfAGEXrM+cEVHdz5BGfz4qnkf2L
 RLvhd5Smg1Jg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,379,1589266800"; 
   d="scan'208";a="326447027"
Received: from djiang5-mobl1.amr.corp.intel.com (HELO [10.213.181.166]) ([10.213.181.166])
  by FMSMGA003.fm.intel.com with ESMTP; 21 Jul 2020 11:00:17 -0700
Subject: Re: [PATCH RFC v2 00/18] Add VFIO mediated device support and DEV-MSI
 support for the idxd driver
To:     Jason Gunthorpe <jgg@mellanox.com>
Cc:     vkoul@kernel.org, megha.dey@intel.com, maz@kernel.org,
        bhelgaas@google.com, rafael@kernel.org, gregkh@linuxfoundation.org,
        tglx@linutronix.de, hpa@zytor.com, alex.williamson@redhat.com,
        jacob.jun.pan@intel.com, ashok.raj@intel.com, yi.l.liu@intel.com,
        baolu.lu@intel.com, kevin.tian@intel.com, sanjay.k.kumar@intel.com,
        tony.luck@intel.com, jing.lin@intel.com, dan.j.williams@intel.com,
        kwankhede@nvidia.com, eric.auger@redhat.com, parav@mellanox.com,
        dave.hansen@intel.com, netanelg@mellanox.com, shahafs@mellanox.com,
        yan.y.zhao@linux.intel.com, pbonzini@redhat.com,
        samuel.ortiz@intel.com, mona.hossain@intel.com,
        dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-pci@vger.kernel.org, kvm@vger.kernel.org
References: <159534667974.28840.2045034360240786644.stgit@djiang5-desk3.ch.intel.com>
 <20200721164527.GD2021248@mellanox.com>
From:   Dave Jiang <dave.jiang@intel.com>
Message-ID: <d0ab496e-8eb1-3365-8b2c-533cf95d6556@intel.com>
Date:   Tue, 21 Jul 2020 11:00:16 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200721164527.GD2021248@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7/21/2020 9:45 AM, Jason Gunthorpe wrote:
> On Tue, Jul 21, 2020 at 09:02:15AM -0700, Dave Jiang wrote:
>> v2:
>> IMS (now dev-msi):
>> With recommendations from Jason/Thomas/Dan on making IMS more generic:
>> Pass a non-pci generic device(struct device) for IMS management instead of mdev
>> Remove all references to mdev and symbol_get/put
>> Remove all references to IMS in common code and replace with dev-msi
>> remove dynamic allocation of platform-msi interrupts: no groups,no new msi list or list helpers
>> Create a generic dev-msi domain with and without interrupt remapping enabled.
>> Introduce dev_msi_domain_alloc_irqs and dev_msi_domain_free_irqs apis
> 
> I didn't dig into the details of irq handling to really check this,
> but the big picture of this is much more in line with what I would
> expect for this kind of ability.
> 
>> Link to previous discussions with Jason:
>> https://lore.kernel.org/lkml/57296ad1-20fe-caf2-b83f-46d823ca0b5f@intel.com/
>> The emulation part that can be moved to user space is very small due to the majority of the
>> emulations being control bits and need to reside in the kernel. We can revisit the necessity of
>> moving the small emulation part to userspace and required architectural changes at a later time.
> 
> The point here is that you already have a user space interface for
> these queues that already has kernel support to twiddle the control
> bits. Generally I'd expect extending that existing kernel code to do
> the small bit more needed for mapping the queue through to PCI
> emulation to be smaller than the 2kloc of new code here to put all the
> emulation and support framework in the kernel, and exposes a lower
> attack surface of kernel code to the guest.
> 
>> The kernel can specify the requirements for these callback functions
>> (e.g., the driver is not expected to block, or not expected to take
>> a lock in the callback function).
> 
> I didn't notice any of this in the patch series? What is the calling
> context for the platform_msi_ops ? I think I already mentioned that
> ideally we'd need blocking/sleeping. The big selling point is that IMS
> allows this data to move off-chip, which means accessing it is no
> longer just an atomic write to some on-chip memory.
> 
> These details should be documented in the comment on top of
> platform_msi_ops
> 
> I'm actually a little confused how idxd_ims_irq_mask() manages this -
> I thought IRQ masking should be synchronous, shouldn't there at least be a
> flushing read to ensure that new MSI's are stopped and any in flight
> are flushed to the APIC?

You are right Jason. It's missing a flushing read.

> 
> Jason
> 
