Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F8D27534DF
	for <lists+kvm@lfdr.de>; Fri, 14 Jul 2023 10:16:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235184AbjGNIQ6 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Fri, 14 Jul 2023 04:16:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235500AbjGNIQp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jul 2023 04:16:45 -0400
Received: from gate.crashing.org (gate.crashing.org [63.228.1.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AC4EE3580;
        Fri, 14 Jul 2023 01:16:23 -0700 (PDT)
Received: from [IPv6:::1] (localhost.localdomain [127.0.0.1])
        by gate.crashing.org (8.14.1/8.14.1) with ESMTP id 36E8Adte003053;
        Fri, 14 Jul 2023 03:10:40 -0500
Message-ID: <67a7374a72053107661ecc2b2f36fdb3ff6cc6ae.camel@kernel.crashing.org>
Subject: Re: [PATCH v3 1/6] kvm: determine memory type from VMA
From:   Benjamin Herrenschmidt <benh@kernel.crashing.org>
To:     Catalin Marinas <catalin.marinas@arm.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Marc Zyngier <maz@kernel.org>, ankita@nvidia.com,
        alex.williamson@redhat.com, naoya.horiguchi@nec.com,
        oliver.upton@linux.dev, aniketa@nvidia.com, cjia@nvidia.com,
        kwankhede@nvidia.com, targupta@nvidia.com, vsethi@nvidia.com,
        acurrid@nvidia.com, apopple@nvidia.com, jhubbard@nvidia.com,
        danw@nvidia.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
        Lorenzo Pieralisi <lpieralisi@kernel.org>,
        Clint Sbisa <csbisa@amazon.com>, osamaabb@amazon.com
Date:   Fri, 14 Jul 2023 18:10:39 +1000
In-Reply-To: <ZHcxHbCb439I1Uk2@arm.com>
References: <20230405180134.16932-1-ankita@nvidia.com>
         <20230405180134.16932-2-ankita@nvidia.com> <86r0spl18x.wl-maz@kernel.org>
         <ZDarrZmLWlA+BHQG@nvidia.com> <ZHcxHbCb439I1Uk2@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
User-Agent: Evolution 3.44.4-0ubuntu1 
MIME-Version: 1.0
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2023-05-31 at 12:35 +0100, Catalin Marinas wrote:
> There were several off-list discussions, I'm trying to summarise my
> understanding here. This series aims to relax the VFIO mapping to
> cacheable and have KVM map it into the guest with the same attributes.
> Somewhat related past threads also tried to relax the KVM device
> pass-through mapping from Device_nGnRnE (pgprot_noncached) to Normal_NC
> (pgprot_writecombine). Those were initially using the PCIe prefetchable
> BAR attribute but that's not a reliable means to infer whether Normal vs
> Device is safe. Anyway, I think we'd need to unify these threads and
> come up with some common handling that can cater for various attributes
> required by devices/drivers. Therefore replying in this thread.

So picking up on this as I was just trying to start a separate
discussion
on the subject for write combine :-)

In this case, not so much for KVM as much as for VFIO to userspace
though.

The rough idea is that the "userspace driver" (ie DPDK or equivalent)
for the device is the one to "know" wether a BAR or portion of a BAR
can/should be mapped write-combine, and is expected to also "know"
what to do to enforce ordering when necessary.

So the userspace component needs to be responsible for selecting the
mapping, the same way using the PCI sysfs resource files today allows
to do that by selecting the _wc variant.

I posted a separate message that Lorenzo CCed back to some of you, but
let's recap here to keep the discussion localized.

I don't know how much of this makes sense for KVM, but I think what we
really want is for userspace to be able to specify some "attributes"
(which we can initially limit to writecombine, full cachability
probably requires a device specific kernel driver providing adequate
authority, separate discussion in any case), for all or a portion of a
BAR mapping.

The easy way is an ioctl to affect the attributes of the next mmap but
it's a rather gross interface.

A better approach (still requires some coordination but not nearly as
bad) would be to have an ioctl to create "subregions", ie, dynamically
add new "struct vfio_pci_region" (using the existing dynamic index
API), which are children of existing regions (including real BARs) and
provide different attributes, which mmap can then honor.

This is particularly suited for the case (which used to exist, I don't
know if it still does) where the buffer that wants write combining
reside in the same BAR as registers that otherwise don't.

A simpler compromise if that latter case is deemed irrelevant would be
an ioctl to selectively set a region index (including BARs) to be WC
prior to mmap.

I don't know if that fits in the ideas you have for KVM, I think it
could by having the userspace component require mappings using a
"special" attribute which we could define as being the most relaxed
allowed to pass to a VM, which can then be architecture defined. The
guest can then enforce specifics. Does this make sense ?

Cheers
Ben.
