Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E908762816
	for <lists+kvm@lfdr.de>; Wed, 26 Jul 2023 03:20:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbjGZBUj convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 25 Jul 2023 21:20:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjGZBUi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 21:20:38 -0400
Received: from gate.crashing.org (gate.crashing.org [63.228.1.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DF84AB0;
        Tue, 25 Jul 2023 18:20:36 -0700 (PDT)
Received: from [IPv6:::1] (localhost.localdomain [127.0.0.1])
        by gate.crashing.org (8.14.1/8.14.1) with ESMTP id 36Q1JIxL008573;
        Tue, 25 Jul 2023 20:19:19 -0500
Message-ID: <012cb915ae0ce3a32f1608400cf6389a03f2aa7d.camel@kernel.crashing.org>
Subject: Re: VFIO (PCI) and write combine mapping of BARs
From:   Benjamin Herrenschmidt <benh@kernel.crashing.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Lorenzo Pieralisi <lpieralisi@kernel.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, alex.williamson@redhat.com,
        osamaabb@amazon.com, linux-pci@vger.kernel.org,
        Clint Sbisa <csbisa@amazon.com>, catalin.marinas@arm.com,
        maz@kernel.org
Date:   Wed, 26 Jul 2023 11:19:18 +1000
In-Reply-To: <ZL+0h9gvJGTyWKZX@nvidia.com>
References: <2838d716b08c78ed24fdd3fe392e21222ee70067.camel@kernel.crashing.org>
         <ZLD1l1274hQQ54RT@lpieralisi> <ZLFBnACjoTbDmKuU@nvidia.com>
         <bc6c3a08e3d0a343fe8317218106609ba159dfe2.camel@kernel.crashing.org>
         <ZL+0h9gvJGTyWKZX@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
User-Agent: Evolution 3.44.4-0ubuntu1 
MIME-Version: 1.0
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2023-07-25 at 08:39 -0300, Jason Gunthorpe wrote:
> On Tue, Jul 25, 2023 at 04:15:39PM +1000, Benjamin Herrenschmidt wrote:
> > > Assuming this is for #2, I think VFIO has fallen into a bit of a trap
> > > by allowing userspace to form the mmap offset. I've seen this happen
> > > in other subsystems too. It seems like a good idea then you realize
> > > you need more stuff in the mmap space and become sad.
> > > 
> > > Typically the way out is to covert the mmap offset into a cookie where
> > > userspace issues some ioctl and then the ioctl returns an opaque mmap
> > > offset to use.
> > > 
> > > eg in the vfio context you'd do some 'prepare region for mmap' ioctl
> > > where you could specify flags. The kernel would encode the flags in
> > > the cookie and then mmap would do the right thing. Adding more stuff
> > > is done by enhancing the prepare ioctl.
> > > 
> > > Legacy mmap offsets are kept working.
> > 
> > This indeed what I have in mind. IE. VFIO has legacy regions and add-on
> > regions though the latter is currently only exploited by some drivers
> > that create their own add-on regions. My proposal is to add an ioctl to
> > create them from userspace as "children" of an existing driver-provided
> > region, allowing to set different attributes for mmap.
> 
> I wouldn't call it children, you are just getting a different mmap
> cookie for the same region object.

I though they could be subsets but that might be overkill.

> > In the current VFIO the implementation is *entirely* in vfio_pci_core
> > for PCI and entirely in vfio_platform_common.c for platform, so while
> > the same ioctls could be imagined to create sub-regions, it would have
> > to be completely implemented twice unless we do a lot of heavy lifting
> > to move some of that region stuff into common code.
> 
> The machinery for managing the mmap cookies should be in common code

Ok. I'll whip up a POC within vfio_pci only intially to test the
concept and to agree on the API, then look at how we can clean all that
up.

Cheers,
Ben.

