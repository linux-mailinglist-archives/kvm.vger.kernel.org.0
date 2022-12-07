Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B707646127
	for <lists+kvm@lfdr.de>; Wed,  7 Dec 2022 19:34:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229910AbiLGSe1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Dec 2022 13:34:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229908AbiLGSd4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Dec 2022 13:33:56 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DBDE22E;
        Wed,  7 Dec 2022 10:33:40 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id D192568AFE; Wed,  7 Dec 2022 19:33:33 +0100 (CET)
Date:   Wed, 7 Dec 2022 19:33:33 +0100
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
Message-ID: <20221207183333.GA7049@lst.de>
References: <20221206153811.GB2266@lst.de> <Y49k++D3i8DfLOLL@ziepe.ca> <20221206165503.GA8677@lst.de> <Y4+U3VR2LeEh2S7B@ziepe.ca> <20221207075415.GB2283@lst.de> <Y5CWVu08abcOuEQH@ziepe.ca> <20221207135203.GA22803@lst.de> <Y5CsH5PqMYAWYatw@ziepe.ca> <20221207163857.GB2010@lst.de> <Y5DOAKArjyfb6Mcz@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y5DOAKArjyfb6Mcz@ziepe.ca>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 07, 2022 at 01:31:44PM -0400, Jason Gunthorpe wrote:
> > Sorry, I meant VF.  Your continued using of SR-IOV teminology now keeps
> > confusing my mind so much that I start mistyping things.
> 
> Well, what words do you want to use?

The same I've used through this whole thread:  controlling and
controlled function.

> So I don't think I've learned anything more about your objection.
> 
> "fundamentally broken" doesn't help

The objection is that:

 - in hardware fundamentally only the controlling funtion can
   control live migration features on the controlled function,
   because the controlled function is assigned to a VM which has
   control over it.
 - for the same reason there is no portable way to even find
   the controlling function from a controlled function, unless
   you want to equate PF = controlling and VF = controlled,
   and even that breaks down in some corner cases
 - if you want to control live migration from the controlled
   VM you need a new vfio subdriver for a function that has
   absolutely no new functionality itself related to live
   migration (quirks for bugs excepted).

So by this architecture you build a convoluted mess where you
need tons of vfio subdrivers that mostly just talk to the
driver for the controlling function, which they can't even
sanely discover.  That's what I keep calling fundamentally
broken.
