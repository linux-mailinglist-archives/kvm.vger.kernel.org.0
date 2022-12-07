Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 161A66454F2
	for <lists+kvm@lfdr.de>; Wed,  7 Dec 2022 08:54:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229780AbiLGHyY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Dec 2022 02:54:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbiLGHyW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Dec 2022 02:54:22 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4FDE303E9;
        Tue,  6 Dec 2022 23:54:20 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 2111768AA6; Wed,  7 Dec 2022 08:54:15 +0100 (CET)
Date:   Wed, 7 Dec 2022 08:54:15 +0100
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
Message-ID: <20221207075415.GB2283@lst.de>
References: <20221206055816.292304-1-lei.rao@intel.com> <20221206055816.292304-2-lei.rao@intel.com> <20221206061940.GA6595@lst.de> <Y49HKHP9NrId39iH@ziepe.ca> <20221206135810.GA27689@lst.de> <Y49eObpI7QoSnugu@ziepe.ca> <20221206153811.GB2266@lst.de> <Y49k++D3i8DfLOLL@ziepe.ca> <20221206165503.GA8677@lst.de> <Y4+U3VR2LeEh2S7B@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y4+U3VR2LeEh2S7B@ziepe.ca>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 06, 2022 at 03:15:41PM -0400, Jason Gunthorpe wrote:
> What the kernel is doing is providing the abstraction to link the
> controlling function to the VFIO device in a general way.
> 
> We don't want to just punt this problem to user space and say 'good
> luck finding the right cdev for migration control'. If the kernel
> struggles to link them then userspace will not fare better on its own.

Yes.  But the right interface for that is to issue the userspace
commands for anything that is not normal PCIe function level
to the controlling funtion, and to discover the controlled functions
based on the controlling functions.

In other words:  there should be absolutely no need to have any
special kernel support for the controlled function.  Instead the
controlling function enumerates all the function it controls exports
that to userspace and exposes the functionality to save state from
and restore state to the controlled functions.

> Especially, we do not want every VFIO device to have its own crazy way
> for userspace to link the controlling/controlled functions
> together. This is something the kernel has to abstract away.

Yes.  But the direction must go controlling to controlled, not the
other way around. 
