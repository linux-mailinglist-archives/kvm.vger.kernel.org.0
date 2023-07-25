Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AD87760A2B
	for <lists+kvm@lfdr.de>; Tue, 25 Jul 2023 08:17:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232047AbjGYGR0 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 25 Jul 2023 02:17:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231640AbjGYGRT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 02:17:19 -0400
Received: from gate.crashing.org (gate.crashing.org [63.228.1.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EBC7A1BE6;
        Mon, 24 Jul 2023 23:17:07 -0700 (PDT)
Received: from [IPv6:::1] (localhost.localdomain [127.0.0.1])
        by gate.crashing.org (8.14.1/8.14.1) with ESMTP id 36P6Fdmn023967;
        Tue, 25 Jul 2023 01:15:40 -0500
Message-ID: <bc6c3a08e3d0a343fe8317218106609ba159dfe2.camel@kernel.crashing.org>
Subject: Re: VFIO (PCI) and write combine mapping of BARs
From:   Benjamin Herrenschmidt <benh@kernel.crashing.org>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Lorenzo Pieralisi <lpieralisi@kernel.org>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        alex.williamson@redhat.com, osamaabb@amazon.com,
        linux-pci@vger.kernel.org, Clint Sbisa <csbisa@amazon.com>,
        catalin.marinas@arm.com, maz@kernel.org
Date:   Tue, 25 Jul 2023 16:15:39 +1000
In-Reply-To: <ZLFBnACjoTbDmKuU@nvidia.com>
References: <2838d716b08c78ed24fdd3fe392e21222ee70067.camel@kernel.crashing.org>
         <ZLD1l1274hQQ54RT@lpieralisi> <ZLFBnACjoTbDmKuU@nvidia.com>
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

On Fri, 2023-07-14 at 09:37 -0300, Jason Gunthorpe wrote:
> 
> There are two topics here
> 
> 1) Make ARM KVM allow the VM to select WC for its MMIO. This has
>    evolved in a way that is not related to VFIO
> 
> 2) Allow VFIO to create mmaps with WC for non-VM use cases like DPDK.
> 
> We have a draft patch for #1, and I think a general understanding with
> ARM folks that this is the right direction.
> 
> 2 is more like what this email talks about - providing mmaps with
> specific flags.
> 
> Benjamin, which are you interested in?

Sorry for the delay, got caught up.... The customer request we have
(and what I was indeed talking about) is 2. That said, when running in
a VM, 2 won't do much without 1.

> > > The problem isn't so much the low level implementation, we just have to
> > > play with the pgprot, the question is more around what API to present
> > > to control this.
> 
> Assuming this is for #2, I think VFIO has fallen into a bit of a trap
> by allowing userspace to form the mmap offset. I've seen this happen
> in other subsystems too. It seems like a good idea then you realize
> you need more stuff in the mmap space and become sad.
> 
> Typically the way out is to covert the mmap offset into a cookie where
> userspace issues some ioctl and then the ioctl returns an opaque mmap
> offset to use.
> 
> eg in the vfio context you'd do some 'prepare region for mmap' ioctl
> where you could specify flags. The kernel would encode the flags in
> the cookie and then mmap would do the right thing. Adding more stuff
> is done by enhancing the prepare ioctl.
> 
> Legacy mmap offsets are kept working.

This indeed what I have in mind. IE. VFIO has legacy regions and add-on
regions though the latter is currently only exploited by some drivers
that create their own add-on regions. My proposal is to add an ioctl to
create them from userspace as "children" of an existing driver-provided
region, allowing to set different attributes for mmap.

> > > This is still quite specific to PCI, but so is the entire regions
> > > mechanism, so I don't see an easy path to something more generic at
> > > this stage.
> 
> Regions are general, but the encoding of the mmap cookie has various
> PCI semantics when used with the PCI interface..
> 
> We'd want the same ability with platform devices too, for instance.

In the current VFIO the implementation is *entirely* in vfio_pci_core
for PCI and entirely in vfio_platform_common.c for platform, so while
the same ioctls could be imagined to create sub-regions, it would have
to be completely implemented twice unless we do a lot of heavy lifting
to move some of that region stuff into common code.

But yes, appart from that, no objection :-)

Cheers,
Ben.
