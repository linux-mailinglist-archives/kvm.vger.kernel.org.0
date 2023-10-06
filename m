Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 683367BB8A0
	for <lists+kvm@lfdr.de>; Fri,  6 Oct 2023 15:09:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232172AbjJFNJV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Oct 2023 09:09:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232288AbjJFNJU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Oct 2023 09:09:20 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80B6EA6
        for <kvm@vger.kernel.org>; Fri,  6 Oct 2023 06:09:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=nQuVCtW6i+MOZrhvdH0VD4e/PHzoa/qwLMLD+xBePTg=; b=hfHda9fMner1U01YZgxu0tFTff
        ++34fcfWnKoqgalYk58hQhlCfc8FpRY//5ef6Yp/vwUQubJntGepMQ4ytZqVUzoz6hUYrsg/1FafW
        tZp4ymOuCY5DoAvkVnMFV4TmG8aueT02whS7Lppl72ZzX9XTkq5b20j8aheR28nUVhT3DpY4b3iYx
        de7NKsStt/BUliMsMWiQGm7DvPTe2sUY/oA+2SXXYfTQiI8rOE4lkXrKqCnxggBRiHTAiyB+7PNzx
        FKmKHRhlaI8ACi/nv1GcUJbfYsNuaiJY9XvmkY2kJSCEsOriHSsDNk6xLhg8PQtw0FNt+jYCTsqSP
        wWA+QmxQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qokZp-005rGD-2R;
        Fri, 06 Oct 2023 13:09:09 +0000
Date:   Fri, 6 Oct 2023 06:09:09 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>, alex.williamson@redhat.com,
        jasowang@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, parav@nvidia.com,
        feliu@nvidia.com, jiri@nvidia.com, kevin.tian@intel.com,
        joao.m.martins@oracle.com, leonro@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH vfio 10/11] vfio/virtio: Expose admin commands over
 virtio device
Message-ID: <ZSAG9cedvh+B0c0E@infradead.org>
References: <20230921124040.145386-1-yishaih@nvidia.com>
 <20230921124040.145386-11-yishaih@nvidia.com>
 <20230922055336-mutt-send-email-mst@kernel.org>
 <c3724e2f-7938-abf7-6aea-02bfb3881151@nvidia.com>
 <20230926072538-mutt-send-email-mst@kernel.org>
 <ZRpjClKM5mwY2NI0@infradead.org>
 <20231002151320.GA650762@nvidia.com>
 <ZR54shUxqgfIjg/p@infradead.org>
 <20231005111004.GK682044@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231005111004.GK682044@nvidia.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 05, 2023 at 08:10:04AM -0300, Jason Gunthorpe wrote:
> > But for all the augmented vfio use cases it doesn't, for them the
> > augmented vfio functionality is an integral part of the core driver.
> > That is true for nvme, virtio and I'd argue mlx5 as well.
> 
> I don't agree with this. I see the extra functionality as being an
> integral part of the VF and VFIO. The PF driver is only providing a
> proxied communication channel.
> 
> It is a limitation of PCI that the PF must act as a proxy.

For anything live migration it very fundamentally is not, as a function
that is visible to a guest by definition can't drive the migration
itself.  That isn't really a limitation in PCI, but follows form the
fact that something else must control a live migration that is
transparent to the guest.

> 
> > So we need to stop registering separate pci_drivers for this kind
> > of functionality, and instead have an interface to the driver to
> > switch to certain functionalities.
> 
> ?? We must bind something to the VF's pci_driver, what do you imagine
> that is?

The driver that knows this hardware.  In this case the virtio subsystem,
in case of nvme the nvme driver, and in case of mlx5 the mlx5 driver.

> > E.g. for this case there should be no new vfio-virtio device, but
> > instead you should be able to switch the virtio device to an
> > fake-legacy vfio mode.
> 
> Are you aruging about how we reach to vfio_register_XX() and what
> directory the file lives?

No.  That layout logically follows from what codebase the functionality
is part of, though.

> I don't know what "fake-legacy" even means, VFIO is not legacy.

The driver we're talking about in this thread fakes up a virtio_pci
legacy devie to the guest on top of a "modern" virtio_pci device.

> There is alot of code in VFIO and the VMM side to take a VF and turn
> it into a vPCI function. You can't just trivially duplicate VFIO in a
> dozen drivers without creating a giant mess.

I do not advocate for duplicating it.  But the code that calls this
functionality belongs into the driver that deals with the compound
device that we're doing this work for.

> Further, userspace wants consistent ways to operate this stuff. If we
> need a dozen ways to activate VFIO for every kind of driver that is
> not a positive direction.

We don't need a dozen ways.  We just need a single attribute on the
pci (or $OTHERBUS) devide that switches it to vfio mode.
