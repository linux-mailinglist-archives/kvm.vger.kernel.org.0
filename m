Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BF4F754F35
	for <lists+kvm@lfdr.de>; Sun, 16 Jul 2023 17:09:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230051AbjGPPJH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 16 Jul 2023 11:09:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjGPPJG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 16 Jul 2023 11:09:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A84D5C9;
        Sun, 16 Jul 2023 08:09:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 381F860D29;
        Sun, 16 Jul 2023 15:09:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93F9CC433C7;
        Sun, 16 Jul 2023 15:09:03 +0000 (UTC)
Date:   Sun, 16 Jul 2023 08:09:02 -0700
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, Marc Zyngier <maz@kernel.org>,
        ankita@nvidia.com, alex.williamson@redhat.com,
        naoya.horiguchi@nec.com, oliver.upton@linux.dev,
        aniketa@nvidia.com, cjia@nvidia.com, kwankhede@nvidia.com,
        targupta@nvidia.com, vsethi@nvidia.com, acurrid@nvidia.com,
        apopple@nvidia.com, jhubbard@nvidia.com, danw@nvidia.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
        Lorenzo Pieralisi <lpieralisi@kernel.org>,
        Clint Sbisa <csbisa@amazon.com>, osamaabb@amazon.com
Subject: Re: [PATCH v3 1/6] kvm: determine memory type from VMA
Message-ID: <ZLQIDkFysVJ8kzkQ@arm.com>
References: <20230405180134.16932-1-ankita@nvidia.com>
 <20230405180134.16932-2-ankita@nvidia.com>
 <86r0spl18x.wl-maz@kernel.org>
 <ZDarrZmLWlA+BHQG@nvidia.com>
 <ZHcxHbCb439I1Uk2@arm.com>
 <67a7374a72053107661ecc2b2f36fdb3ff6cc6ae.camel@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <67a7374a72053107661ecc2b2f36fdb3ff6cc6ae.camel@kernel.crashing.org>
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Ben,

On Fri, Jul 14, 2023 at 06:10:39PM +1000, Benjamin Herrenschmidt wrote:
> On Wed, 2023-05-31 at 12:35 +0100, Catalin Marinas wrote:
> > There were several off-list discussions, I'm trying to summarise my
> > understanding here. This series aims to relax the VFIO mapping to
> > cacheable and have KVM map it into the guest with the same attributes.
> > Somewhat related past threads also tried to relax the KVM device
> > pass-through mapping from Device_nGnRnE (pgprot_noncached) to Normal_NC
> > (pgprot_writecombine). Those were initially using the PCIe prefetchable
> > BAR attribute but that's not a reliable means to infer whether Normal vs
> > Device is safe. Anyway, I think we'd need to unify these threads and
> > come up with some common handling that can cater for various attributes
> > required by devices/drivers. Therefore replying in this thread.
> 
> So picking up on this as I was just trying to start a separate
> discussion on the subject for write combine :-)

Basically this thread started as a fix/improvement for KVM by mimicking
the VFIO user mapping attributes at the guest but the conclusion we came
to is that the VFIO PCIe driver cannot reliably tell when WC is
possible.

> In this case, not so much for KVM as much as for VFIO to userspace
> though.
> 
> The rough idea is that the "userspace driver" (ie DPDK or equivalent)
> for the device is the one to "know" wether a BAR or portion of a BAR
> can/should be mapped write-combine, and is expected to also "know"
> what to do to enforce ordering when necessary.

I agree in principle. On the KVM side we concluded that it's the guest
driver that knows the attributes, so the hypervisor should not restrict
them. In the DPDK case, it would be the user driver that knows the
device it is mapping and the required attributes.

In terms of security for arm64 at least, Device vs Normal NC (or nc vs
wc in Linux terminology) doesn't make much difference with the former
occasionally being worse. The kernel would probably trust the DPDK code
if it allows direct device access.

> So the userspace component needs to be responsible for selecting the
> mapping, the same way using the PCI sysfs resource files today allows
> to do that by selecting the _wc variant.

I guess the sysfs interface is just trying to work around the VFIO
limitations.

> I don't know how much of this makes sense for KVM, but I think what we
> really want is for userspace to be able to specify some "attributes"
> (which we can initially limit to writecombine, full cachability
> probably requires a device specific kernel driver providing adequate
> authority, separate discussion in any case), for all or a portion of a
> BAR mapping.

For KVM, at least the WC case, user-space doesn't need to be involved as
it normally should not access the same BAR concurrently with the guest.
But at some point, for CXL-attached memory for example, it may need to
be able to map it as cacheable so that it has the same attributes as the
guest.

> The easy way is an ioctl to affect the attributes of the next mmap but
> it's a rather gross interface.
> 
> A better approach (still requires some coordination but not nearly as
> bad) would be to have an ioctl to create "subregions", ie, dynamically
> add new "struct vfio_pci_region" (using the existing dynamic index
> API), which are children of existing regions (including real BARs) and
> provide different attributes, which mmap can then honor.
> 
> This is particularly suited for the case (which used to exist, I don't
> know if it still does) where the buffer that wants write combining
> reside in the same BAR as registers that otherwise don't.

IIUC that's still the case for some devices (I think Jason mentioned
some Mellanox cards).

> A simpler compromise if that latter case is deemed irrelevant would be
> an ioctl to selectively set a region index (including BARs) to be WC
> prior to mmap.
> 
> I don't know if that fits in the ideas you have for KVM, I think it
> could by having the userspace component require mappings using a
> "special" attribute which we could define as being the most relaxed
> allowed to pass to a VM, which can then be architecture defined. The
> guest can then enforce specifics. Does this make sense ?

I think this interface would help KVM when we'll need a cacheable
mapping. For WC, we are ok without any VFIO changes.

-- 
Catalin
