Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B18B717E26
	for <lists+kvm@lfdr.de>; Wed, 31 May 2023 13:36:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234902AbjEaLgG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 May 2023 07:36:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230341AbjEaLgF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 May 2023 07:36:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D2C5B2;
        Wed, 31 May 2023 04:36:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CE54E639EB;
        Wed, 31 May 2023 11:36:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEED4C433EF;
        Wed, 31 May 2023 11:35:59 +0000 (UTC)
Date:   Wed, 31 May 2023 12:35:57 +0100
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Marc Zyngier <maz@kernel.org>, ankita@nvidia.com,
        alex.williamson@redhat.com, naoya.horiguchi@nec.com,
        oliver.upton@linux.dev, aniketa@nvidia.com, cjia@nvidia.com,
        kwankhede@nvidia.com, targupta@nvidia.com, vsethi@nvidia.com,
        acurrid@nvidia.com, apopple@nvidia.com, jhubbard@nvidia.com,
        danw@nvidia.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
        Lorenzo Pieralisi <lpieralisi@kernel.org>
Subject: Re: [PATCH v3 1/6] kvm: determine memory type from VMA
Message-ID: <ZHcxHbCb439I1Uk2@arm.com>
References: <20230405180134.16932-1-ankita@nvidia.com>
 <20230405180134.16932-2-ankita@nvidia.com>
 <86r0spl18x.wl-maz@kernel.org>
 <ZDarrZmLWlA+BHQG@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZDarrZmLWlA+BHQG@nvidia.com>
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 12, 2023 at 10:01:33AM -0300, Jason Gunthorpe wrote:
> On Wed, Apr 12, 2023 at 01:43:26PM +0100, Marc Zyngier wrote:
> > What makes it safe? How does VFIO ensures that the memory type used is
> > correct in all circumstances? This has to hold for *ANY* device, not
> > just your favourite toy of the day. Nothing in this patch is horribly
> > wrong, but the above question must be answered before we can consider
> > any of this.
> 
> In VFIO we now have the concept of "variant drivers" which work with
> specific PCI IDs. The variant drivers can inject device specific
> knowledge into VFIO. In this series the driver injects the cachable
> pgprot when it creates some of the VMAs because it knows the PCI IDs
> it supports, parses the ACPI description, and knows for sure that the
> memory it puts in the cachable VMA is linked with a cache coherent
> interconnect.
> 
> The generic vfio-pci path is not changed, so 'any device' is not
> relevant here.

There were several off-list discussions, I'm trying to summarise my
understanding here. This series aims to relax the VFIO mapping to
cacheable and have KVM map it into the guest with the same attributes.
Somewhat related past threads also tried to relax the KVM device
pass-through mapping from Device_nGnRnE (pgprot_noncached) to Normal_NC
(pgprot_writecombine). Those were initially using the PCIe prefetchable
BAR attribute but that's not a reliable means to infer whether Normal vs
Device is safe. Anyway, I think we'd need to unify these threads and
come up with some common handling that can cater for various attributes
required by devices/drivers. Therefore replying in this thread.

Current status on arm64: vfio-pci user mapping (Qemu) of PCIe BARs is
Device_nGnRnE. KVM also maps it at Stage 2 with the same attributes. The
user mapping is fine since the VMM may not have detailed knowledge about
how to safely map the BAR. KVM doesn't have such detailed knowledge
either in the device pass-through case but for safety reasons it follows
the same attributes as the user mapping.

From a safety perspective, relaxing the KVM stage 2 mapping has some
implications:

1. It creates multiple memory aliases with different attributes.

2. Speculative loads, unaligned accesses.

3. Potentially new uncontained errors introduced by Normal NC vs Device
   mappings.

From the private discussions I had regarding point (3), Device doesn't
really make any difference and it can be even worse. For example, Normal
mappings would allow a contained error while Device would trigger an
uncontained SError. So the only safe bet here is for the platform, root
complex to behave properly when device pass-through is involved (e.g.
PCIe to ignore writes, return 0xff on reads if there are errors). That's
something Arm is working on to require in the BSA specs (base system
architecture). Presumably cloud vendors allowing device pass-through
already know their system well enough, no need for further policing in
KVM (which it can't do properly anyway).

As long as the errors are contained, point (2) becomes the
responsibility of the guest, given its detailed knowledge of the device,
using the appropriate attributes (whether x86 WC maps exactly onto arm64
Normal NC is the subject of a separate discussion; so far that's the
assumption we took in the arm64 kernel). Regarding vfio-pci, the user
mapping must remain Device_nGnRnE on arm64 to avoid unexpected
speculative loads.

This leaves us with (1) and since the vfio-pci user mapping must remain
Device, there's a potential mismatched alias if the guest maps the
corresponding BAR as Normal NC. Luckily the Arm ARM constrains the
hardware behaviour here to basically allowing the Device mapping in the
VMM to behave somewhat the Normal NC mapping in the guest. IOW, the VMM
loses the Device guarantees (non-speculation, ordering). That's not a
problem for the device since the guest already deemed such mapping to be
safe.

While I think it's less likely for the VMM to access the same BAR that
was mapped into the guest, if we want to be on the safe side from an ABI
perspective (the returned mmap() now has different memory guarantees),
we could make this an opt-in. That's pretty much the VMM stating that it
is ok with losing some of the Device guarantees for the vfio-pci
mapping. A question here is whether we want to this to be done at the
vfio-pci level, the KVM memory slot or a big knob per VMM. Or whether we
need to bother with this at all (if it's just theoretical, maybe we can
have a global opt-out).

Going back to this series, allowing Cacheable mapping in KVM has similar
implications as above. (2) and (3) would be assumed safe by the platform
vendors. Regarding (1), to avoid confusion, I would only allow it if FWB
(force write-back) is present so that KVM can enforce a cacheable
mapping at Stage 2 if the vfio variant driver also maps it as cacheable
in user space.

There were some other thoughts on only allowing different attributes in
KVM if the user counterpart does not have any mapping (e.g. fd-based
KVM memory slots). However, this won't work well with CXL-attached
memory for example where the VMM may want access to it (e.g. virtio). So
I wouldn't spend more thoughts on this.


The TL;DR summary of what I think we should do:

a) Relax the KVM Stage 2 mapping for vfio-pci to Normal NC
   (pgprot_writecombine). TBD whether we need a VMM opt-in is at the
   vfio-pci level, KVM slot or per-VMM level. Another option is to do
   this by default and have a global opt-out (cmdline). I don't think
   the latter is such a bad idea since I find it unlikely for the VMM to
   also touch the same PCIe BAR _and_ expect different memory ordering
   guarantees than the guest device driver.

b) Map the KVM stage 2 mapping as cacheable+FWB iff the VMM has a
   corresponding cacheable mapping.

Thoughts?

-- 
Catalin
