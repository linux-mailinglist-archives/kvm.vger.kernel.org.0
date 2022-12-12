Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44DBC64A4BA
	for <lists+kvm@lfdr.de>; Mon, 12 Dec 2022 17:25:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232735AbiLLQZU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Dec 2022 11:25:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232744AbiLLQZR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Dec 2022 11:25:17 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9297AB7E1;
        Mon, 12 Dec 2022 08:25:15 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1670862314;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ivyFygzV7sPjgzBQhDl4hwzJVxNr9ahM7vvr/Xv9/M4=;
        b=fpaJhsNCAjzy9bu37SF5hvEZ4MTIux/RwQAZncd7L4CxSp5i4OeHEJ4rhwqGWOe+MmycQr
        CuVzU2AwfLFStkU6R4uFeqyNN7LMQ1uZdG1I1me7zWkkQjYB1VG7B61OBwq13pOlCpZgjs
        /sb+WX4O+L70CtvZOCyZw5JGGhMO3atCRj9xu/Om534xS3DwFdbBZC1HQ7cSm3+A9V2zb5
        kDs6c+3L74no06NdkihIkql86GqYfLhHGv0dGByYK0eqLCcLef3JcjR7tvrYBEOLYhfwQ1
        +xpmqedrYxhOraFDWeOdxxPlTgXvMDHvblIc+nLj+0fwXhUw2YarSw+hxQPj0w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1670862314;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ivyFygzV7sPjgzBQhDl4hwzJVxNr9ahM7vvr/Xv9/M4=;
        b=n8cBxybNlqWqQdWXyQ2/e3iZPfJkvjkZZU/hOxSz4jDkeBp1tvCJYQQvMI80Hwz1Eess/X
        9vpzSvpl60d16TBA==
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Robin Murphy <robin.murphy@arm.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        Joerg Roedel <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        Marc Zyngier <maz@kernel.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Will Deacon <will@kernel.org>,
        Bharat Bhushan <bharat.bhushan@nxp.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Tomasz Nowicki <tomasz.nowicki@caviumnetworks.com>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH iommufd 4/9] iommufd: Convert to
 msi_device_has_secure_msi()
In-Reply-To: <Y5dM+VnqRjTefGH1@nvidia.com>
References: <0-v1-9e466539c244+47b5-secure_msi_jgg@nvidia.com>
 <4-v1-9e466539c244+47b5-secure_msi_jgg@nvidia.com>
 <BN9PR11MB5276522F9FA4D4A486C5F60A8C1C9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <Y5NKlf4btF9xUXXZ@nvidia.com>
 <5e7dbc83-a853-dc45-5016-c53f1be8aaf8@arm.com>
 <Y5NyeFyMhlDxHkCW@nvidia.com> <87edt4bqhl.ffs@tglx>
 <Y5dM+VnqRjTefGH1@nvidia.com>
Date:   Mon, 12 Dec 2022 17:25:13 +0100
Message-ID: <875yegbndi.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 12 2022 at 11:47, Jason Gunthorpe wrote:
> On Mon, Dec 12, 2022 at 04:17:58PM +0100, Thomas Gleixner wrote:
>> Obvioulsy unless it's done somewhere early in the PCI discovery,
>> i.e. before the discovery associated the domain pointer.
>
> I thought the problem is more that the iommu drivers change the
> assigned irq_domain:

Yes they do.

> void intel_irq_remap_add_device(struct dmar_pci_notify_info *info)
> {
> 	if (!irq_remapping_enabled || pci_dev_has_special_msi_domain(info->dev))
> 		return;
>
> 	dev_set_msi_domain(&info->dev->dev, map_dev_to_ir(info->dev));
> }
>
> Which is ultimately called by 
>
> 	bus_register_notifier(&pci_bus_type, &dmar_pci_bus_nb);
>
> And that compares with the iommu setup which is also done from a
> bus notifier:
>
> 		nb[i].notifier_call = iommu_bus_notifier;
> 		bus_register_notifier(iommu_buses[i], &nb[i]);
>
> So, I think, there is not reliable ordering between these two things.

Bah. Notifiers are a complete disaster vs. ordering. This really wants
reliable ordering IMO.

Thanks,

        tglx
