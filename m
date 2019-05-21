Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19DF824DAC
	for <lists+kvm@lfdr.de>; Tue, 21 May 2019 13:11:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727910AbfEULLe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 May 2019 07:11:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47576 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726042AbfEULLd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 May 2019 07:11:33 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 52E3B85A03;
        Tue, 21 May 2019 11:11:30 +0000 (UTC)
Received: from gondolin (ovpn-204-120.brq.redhat.com [10.40.204.120])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EF68260F8D;
        Tue, 21 May 2019 11:11:23 +0000 (UTC)
Date:   Tue, 21 May 2019 13:11:20 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        sebott@linux.vnet.ibm.com, gerald.schaefer@de.ibm.com,
        pasic@linux.vnet.ibm.com, borntraeger@de.ibm.com,
        walling@linux.ibm.com, linux-s390@vger.kernel.org,
        iommu@lists.linux-foundation.org, joro@8bytes.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        robin.murphy@arm.com
Subject: Re: [PATCH v2 4/4] vfio: vfio_iommu_type1: implement
 VFIO_IOMMU_INFO_CAPABILITIES
Message-ID: <20190521131120.0b2afb37.cohuck@redhat.com>
In-Reply-To: <9dc0a8de-b850-df21-e3b7-21b7c2a373a3@linux.ibm.com>
References: <1558109810-18683-1-git-send-email-pmorel@linux.ibm.com>
        <1558109810-18683-5-git-send-email-pmorel@linux.ibm.com>
        <20190517104143.240082b5@x1.home>
        <92b6ad4e-9a49-636b-9225-acca0bec4bb7@linux.ibm.com>
        <ed193353-56f0-14b5-f1fb-1835d0a6c603@linux.ibm.com>
        <20190520162737.7560ad7c.cohuck@redhat.com>
        <23f6a739-be4f-7eda-2227-2994fdc2325a@linux.ibm.com>
        <20190520122352.73082e52@x1.home>
        <9dc0a8de-b850-df21-e3b7-21b7c2a373a3@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Tue, 21 May 2019 11:11:33 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 21 May 2019 11:14:38 +0200
Pierre Morel <pmorel@linux.ibm.com> wrote:

> 1) A short description, of zPCI functions and groups
> 
> IN Z, PCI cards, leave behind an adapter between subchannels and PCI.
> We access PCI cards through 2 ways:
> - dedicated PCI instructions (pci_load/pci_store/pci/store_block)
> - DMA

Quick question: What about the new pci instructions? Anything that
needs to be considered there?

> We receive events through
> - Adapter interrupts

Note for the non-s390 folks: These are (I/O) interrupts that are not
tied to a specific device. MSI-X is mapped to this.

> - CHSC events

Another note for the non-s390 folks: This is a notification mechanism
that is using machine check interrupts; more information is retrieved
via a special instruction (chsc).

> 
> The adapter propose an IOMMU to protect the DMA
> and the interrupt handling goes through a MSIX like interface handled by 
> the adapter.
> 
> The architecture specific PCI do the interface between the standard PCI 
> level and the zPCI function (PCI + DMA/IOMMU/Interrupt)
> 
> To handle the communication through the "zPCI way" the CLP interface 
> provides instructions to retrieve informations from the adapters.
> 
> There are different group of functions having same functionalities.
> 
> clp_list give us a list from zPCI functions
> clp_query_pci_function returns informations specific to a function
> clp_query_group returns information on a function group
> 
> 
> 2) Why do we need it in the guest
> 
> We need to provide the guest with information on the adapters and zPCI 
> functions returned by the clp_query instruction so that the guest's 
> driver gets the right information on how the way to the zPCI function 
> has been built in the host.
> 
> 
> When a guest issues the CLP instructions we intercept the clp command in 
> QEMU and we need to feed the response with the right values for the guest.
> The "right" values are not the raw CLP response values:
> 
> - some identifier must be virtualized, like UID and FID,
> 
> - some values must match what the host received from the CLP response, 
> like the size of the transmited blocks, the DMA Address Space Mask, 
> number of interrupt, MSIA
> 
> - some other must match what the host handled with the adapter and 
> function, the start and end of DMA,
> 
> - some what the host IOMMU driver supports (frame size),
> 
> 
> 
> 3) We have three different way to get This information:
> 
> The PCI Linux interface is a standard PCI interface and some Z specific 
> information is available in sysfs.
> Not all the information needed to be returned inside the CLP response is 
> available.
> So we can not use the sysfs interface to get all the information.
> 
> There is a CLP ioctl interface but this interface is not secure in that 
> it returns the information for all adapters in the system.
> 
> The VFIO interface offers the advantage to point to a single PCI 
> function, so more secure than the clp ioctl interface.
> Coupled with the s390_iommu we get access to the zPCI CLP instruction 
> and to the values handled by the zPCI driver.
> 
> 
> 4) Until now we used to fill the CLP response to the guest inside QEMU 
> with fixed values corresponding to the only PCI card we supported.
> To support new cards we need to get the right values from the kernel out.

IIRC, the current code fills in values that make sense for one specific
type of card only, right? We also use the same values for emulated
cards (virtio); I assume that they are not completely weird for that
case...
