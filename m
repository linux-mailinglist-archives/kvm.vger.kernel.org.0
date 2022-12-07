Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B6D9645B6A
	for <lists+kvm@lfdr.de>; Wed,  7 Dec 2022 14:52:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230151AbiLGNwL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Dec 2022 08:52:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229746AbiLGNwJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Dec 2022 08:52:09 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB7E55B580;
        Wed,  7 Dec 2022 05:52:08 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id E599267373; Wed,  7 Dec 2022 14:52:03 +0100 (CET)
Date:   Wed, 7 Dec 2022 14:52:03 +0100
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
Message-ID: <20221207135203.GA22803@lst.de>
References: <20221206061940.GA6595@lst.de> <Y49HKHP9NrId39iH@ziepe.ca> <20221206135810.GA27689@lst.de> <Y49eObpI7QoSnugu@ziepe.ca> <20221206153811.GB2266@lst.de> <Y49k++D3i8DfLOLL@ziepe.ca> <20221206165503.GA8677@lst.de> <Y4+U3VR2LeEh2S7B@ziepe.ca> <20221207075415.GB2283@lst.de> <Y5CWVu08abcOuEQH@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y5CWVu08abcOuEQH@ziepe.ca>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 07, 2022 at 09:34:14AM -0400, Jason Gunthorpe wrote:
> The VFIO design assumes that the "vfio migration driver" will talk to
> both functions under the hood, and I don't see a fundamental problem
> with this beyond it being awkward with the driver core.

And while that is a fine concept per see, the current incarnation of
that is fundamentally broken is it centered around the controlled
VM.  Which really can't work.

> Even the basic assumption that there would be a controlling/controlled
> relationship is not universally true. The mdev type drivers, and 
> SIOV-like devices are unlikely to have that. Once you can use PASID
> the reasons to split things at the HW level go away, and a VF could
> certainly self-migrate.

Even then you need a controlling and a controlled entity.  The
controlling entity even in SIOV remains a PCIe function.  The
controlled entity might just be a bunch of hardware resoures and
a PASID.  Making it important again that all migration is driven
by the controlling entity.

Also the whole concept that only VFIO can do live migration is
a little bogus.  With checkpoint and restart it absolutely
does make sense to live migrate a container, and with that
the hardware interface (e.g. nvme controller) assigned to it.

> So, when you see both Intel and Pensando proposing this kind of
> layered model for NVMe where migration is subsystem-local to VFIO, I
> think this is where the inspiration is coming from. Their native DPU
> drivers already work this way.

Maybe they should have talked to someone not high on their own
supply before designing this.
