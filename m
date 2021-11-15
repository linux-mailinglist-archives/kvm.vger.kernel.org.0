Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35E83451084
	for <lists+kvm@lfdr.de>; Mon, 15 Nov 2021 19:47:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242782AbhKOStw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Nov 2021 13:49:52 -0500
Received: from foss.arm.com ([217.140.110.172]:59746 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242924AbhKOSrd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Nov 2021 13:47:33 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 158CF1FB;
        Mon, 15 Nov 2021 10:44:37 -0800 (PST)
Received: from [10.57.82.45] (unknown [10.57.82.45])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 930603F70D;
        Mon, 15 Nov 2021 10:44:34 -0800 (PST)
Message-ID: <055c0ccb-7676-8e04-9d8f-a49dc3e8fc0a@arm.com>
Date:   Mon, 15 Nov 2021 18:44:27 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH 03/11] PCI: pci_stub: Suppress kernel DMA ownership
 auto-claiming
Content-Language: en-GB
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Ashok Raj <ashok.raj@intel.com>, kvm@vger.kernel.org,
        rafael@kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Will Deacon <will@kernel.org>, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        linux-pci@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>
References: <20211115020552.2378167-1-baolu.lu@linux.intel.com>
 <20211115020552.2378167-4-baolu.lu@linux.intel.com>
 <YZJe1jquP+osF+Wn@infradead.org> <20211115133107.GB2379906@nvidia.com>
 <495c65e4-bd97-5f29-d39b-43671acfec78@arm.com>
 <20211115161756.GP2105516@nvidia.com>
 <e9db18d3-dea3-187a-d58a-31a913d95211@arm.com>
 <YZKkl/1GN+KgjYs6@infradead.org>
From:   Robin Murphy <robin.murphy@arm.com>
In-Reply-To: <YZKkl/1GN+KgjYs6@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021-11-15 18:19, Christoph Hellwig wrote:
> On Mon, Nov 15, 2021 at 05:54:42PM +0000, Robin Murphy wrote:
>>> s/PIO/MMIO, but yes basically. And not just data trasnfer but
>>> userspace can interfere with the device state as well.
>>
>> Sure, but unexpected changes in device state could happen for any number of
>> reasons - uncorrected ECC error, surprise removal, etc. - so if that can
>> affect "kernel integrity" I'm considering it an independent problem.
> 
> Well, most DMA is triggered by the host requesting it through MMIO.
> So having access to the BAR can turn many devices into somewhat
> arbitrary DMA engines.

Yup, but as far as I understand we're talking about the situation where 
the overall group is already attached to the VFIO domain by virtue of 
device A, so any unsolicited DMA by device B could only be to 
userspace's own memory.

>> I can see the argument from that angle, but you can equally look at it
>> another way and say that a device with kernel ownership is incompatible with
>> a kernel driver, if userspace can call write() on "/sys/devices/B/resource0"
>> such that device A's kernel driver DMAs all over it. Maybe that particular
>> example lands firmly under "just don't do that", but I'd like to figure out
>> where exactly we should draw the line between "DMA" and "ability to mess
>> with a device".
> 
> Userspace writing to the resourceN files with a bound driver is a mive
> receipe for trouble.  Do we really allow this currently?

No idea - I just want to make sure we don't get blinkered on VFIO at 
this point and consider the potential problem space fully :)

Robin.
