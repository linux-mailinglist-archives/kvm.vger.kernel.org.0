Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36B6364A3FC
	for <lists+kvm@lfdr.de>; Mon, 12 Dec 2022 16:18:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232187AbiLLPSF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Dec 2022 10:18:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231721AbiLLPSD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Dec 2022 10:18:03 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D0BF2736;
        Mon, 12 Dec 2022 07:18:01 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1670858279;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IhelkcQX+S/XH33QhHGqpWajt8PRo+qMzWym0sZ9oIk=;
        b=tMtjyN6fS+uVLeC57wLEJ14wP3w0rgmgl2GyIszSEv1TrJFxYJcCBytLXN7BhAj0SCoRGm
        6obyn4j+xRn+pwkXZ7We8pWyVkxV4Y3PCt9giBJutfbAnAI/mNKi7bjQHY+sDRgTaIfTLN
        gVe7yiRC+Q4mZ5egz/Lx6XcromKMrF6yTZ7Xclwz+/EZbs5ZxOyQoE5PiYPfXiBRmAOgwL
        eaIfmXRd1hac+i7+NRRUkQjuABd8LYOZjvZu16ST+t+wPlfMM29g7I3WohbdTxLMKpGiVH
        /8sHOY4sYYfGezFVIHv7b2res4mndg9bdambMFqgVreNf0DvuH90ZA3GSmfm7A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1670858279;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IhelkcQX+S/XH33QhHGqpWajt8PRo+qMzWym0sZ9oIk=;
        b=8l42tLh8Uatvm73gI/8BEcK9ij+5LbTfWWo9qUncK3SFWiOFCWkM0VPRfv2znnO79GXdwm
        vovfhPRgtqeXFPAA==
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
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
In-Reply-To: <Y5NyeFyMhlDxHkCW@nvidia.com>
References: <0-v1-9e466539c244+47b5-secure_msi_jgg@nvidia.com>
 <4-v1-9e466539c244+47b5-secure_msi_jgg@nvidia.com>
 <BN9PR11MB5276522F9FA4D4A486C5F60A8C1C9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <Y5NKlf4btF9xUXXZ@nvidia.com>
 <5e7dbc83-a853-dc45-5016-c53f1be8aaf8@arm.com>
 <Y5NyeFyMhlDxHkCW@nvidia.com>
Date:   Mon, 12 Dec 2022 16:17:58 +0100
Message-ID: <87edt4bqhl.ffs@tglx>
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

On Fri, Dec 09 2022 at 13:38, Jason Gunthorpe wrote:
> On Fri, Dec 09, 2022 at 04:44:06PM +0000, Robin Murphy wrote:
>
>> Isn't the problem with this that it's super-early, and a device's MSI domain
>> may not actually be resolved until someone starts requesting MSIs for it?
>> Maybe Thomas' ongoing per-device stuff changes that, but I'm not
>> sure :/
>
> Yes, this looks correct, OK, so I will do Kevin's thought

The device MSI domain has to be valid before a device can be probed, at
least that's the case for PCI/MSI devices. The pointer is established
during PCI discovery.

The per device MSI domains do not change that requirement. The only
difference is that device->msi.domain now points to the MSI parent
domain.

In the "global" PCI/MSI domain case the hierarchy walk will (on x86)
start at the PCI/MSI domain and end up either at the remapping unit,
which has the protection property, or at the vector (root) domain, which
does not.

For the per device domain case the walk will start at the parent domain,
which is (on x86) either the remapping unit or the vector (root) domain.

The same is true for ARM(64) and other hierarchy users, just the naming
conventions and possible scenarios are different.

So for both scenarios (global and per-device) searching for that
protection property down the hierarchy starting from device->msi.domain
is correct.

Obvioulsy unless it's done somewhere early in the PCI discovery,
i.e. before the discovery associated the domain pointer.

Thanks,

        tglx
