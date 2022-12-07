Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78563645F17
	for <lists+kvm@lfdr.de>; Wed,  7 Dec 2022 17:39:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbiLGQjE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Dec 2022 11:39:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiLGQjD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Dec 2022 11:39:03 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA9A0164A7;
        Wed,  7 Dec 2022 08:39:02 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 83FB967373; Wed,  7 Dec 2022 17:38:57 +0100 (CET)
Date:   Wed, 7 Dec 2022 17:38:57 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Christoph Hellwig <hch@lst.de>, Lei Rao <lei.rao@intel.com>,
        kbusch@kernel.org, axboe@fb.com, kch@nvidia.com, sagi@grimberg.me,
        alex.williamson@redhat.com, cohuck@redhat.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        mjrosato@linux.ibm.com, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org, kvm@vger.kernel.org,
        eddie.dong@intel.com, yadong.li@intel.com, yi.l.liu@intel.com,
        Konrad.wilk@oracle.com, stephen@eideticom.com, hang.yuan@intel.com
Subject: Re: [RFC PATCH 1/5] nvme-pci: add function nvme_submit_vf_cmd to
 issue admin commands for VF driver.
Message-ID: <20221207163857.GB2010@lst.de>
References: <20221206135810.GA27689@lst.de> <Y49eObpI7QoSnugu@ziepe.ca> <20221206153811.GB2266@lst.de> <Y49k++D3i8DfLOLL@ziepe.ca> <20221206165503.GA8677@lst.de> <Y4+U3VR2LeEh2S7B@ziepe.ca> <20221207075415.GB2283@lst.de> <Y5CWVu08abcOuEQH@ziepe.ca> <20221207135203.GA22803@lst.de> <Y5CsH5PqMYAWYatw@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y5CsH5PqMYAWYatw@ziepe.ca>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 07, 2022 at 11:07:11AM -0400, Jason Gunthorpe wrote:
> > And while that is a fine concept per see, the current incarnation of
> > that is fundamentally broken is it centered around the controlled
> > VM.  Which really can't work.
> 
> I don't see why you keep saying this. It is centered around the struct
> vfio_device object in the kernel, which is definately NOT the VM.

Sorry, I meant VF.  Your continued using of SR-IOV teminology now keeps
confusing my mind so much that I start mistyping things.

> > Even then you need a controlling and a controlled entity.  The
> > controlling entity even in SIOV remains a PCIe function.  The
> > controlled entity might just be a bunch of hardware resoures and
> > a PASID.  Making it important again that all migration is driven
> > by the controlling entity.
> 
> If they are the same driver implementing vfio_device you may be able
> to claim they conceptually exist, but it is pretty artificial to draw
> this kind of distinction inside a single driver.

How are they in this reply?  I can't parse how this even relates to
what I wrote.

> > Also the whole concept that only VFIO can do live migration is
> > a little bogus.  With checkpoint and restart it absolutely
> > does make sense to live migrate a container, and with that
> > the hardware interface (e.g. nvme controller) assigned to it.
> 
> I agree people may want to do this, but it is very unclear how SRIOV
> live migration can help do this.

SRIOV live migration doesn't, because honestly there is no such
thing as "SRIOV" live migration to start with.

> Let alone how to solve the security problems of allow userspace to
> load arbitary FW blobs into a device with potentially insecure DMA
> access..

Any time you assign a PCI device to userspace you might get into that.
