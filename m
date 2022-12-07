Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7FDA645500
	for <lists+kvm@lfdr.de>; Wed,  7 Dec 2022 08:58:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbiLGH6q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Dec 2022 02:58:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229915AbiLGH6l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Dec 2022 02:58:41 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 828DD2B1BB;
        Tue,  6 Dec 2022 23:58:39 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id DB37E68AA6; Wed,  7 Dec 2022 08:58:34 +0100 (CET)
Date:   Wed, 7 Dec 2022 08:58:34 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Max Gurtovoy <mgurtovoy@nvidia.com>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>, Christoph Hellwig <hch@lst.de>,
        Lei Rao <lei.rao@intel.com>, kbusch@kernel.org, axboe@fb.com,
        kch@nvidia.com, sagi@grimberg.me, alex.williamson@redhat.com,
        cohuck@redhat.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        mjrosato@linux.ibm.com, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org, kvm@vger.kernel.org,
        eddie.dong@intel.com, yadong.li@intel.com, yi.l.liu@intel.com,
        Konrad.wilk@oracle.com, stephen@eideticom.com, hang.yuan@intel.com
Subject: Re: [RFC PATCH 1/5] nvme-pci: add function nvme_submit_vf_cmd to
 issue admin commands for VF driver.
Message-ID: <20221207075834.GC2283@lst.de>
References: <20221206055816.292304-2-lei.rao@intel.com> <20221206061940.GA6595@lst.de> <Y49HKHP9NrId39iH@ziepe.ca> <20221206135810.GA27689@lst.de> <Y49eObpI7QoSnugu@ziepe.ca> <20221206153811.GB2266@lst.de> <Y49k++D3i8DfLOLL@ziepe.ca> <20221206165503.GA8677@lst.de> <Y4+U3VR2LeEh2S7B@ziepe.ca> <2975e217-749b-6929-cd2d-4b6276ef33d1@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2975e217-749b-6929-cd2d-4b6276ef33d1@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 07, 2022 at 04:30:20AM +0200, Max Gurtovoy wrote:
> I'm not sure how awkward is for migration driver to ask the controlling 
> device driver to operate a migration action.

It can't.  That's the whole point.  The controlled function that is
being migrate must be absolutely unaware of that (except for things
like quiescing access or FLRs that could happen anyway), because
otherwise your have a fundamental information leak.

> The controlling device driver can expose limited API for that matter.

No, it can't.  It must be in charge.

> Also the concept of primary controller that control it's secondary 
> controllers is already in the SPEC so we can use it. It's not introduced in 
> this RFC but we're here to fix it.

Yes, it is as I've pointed out multiple times.  But, that relationship
is only visible to the primary controller.  It also doesn't help with
the general problem where the secondary controller must be able to
completely change it's identify and thus the subsystem.

> In our case the primary controller is the PF and the secondary controllers 
> are the VFs.

Yes, that's your case, and probably a very common one.  But also far from
the only one, so there is no way Linux or the specification can rely
on that dumb fact.  Never mind that there are virtualization schemes
(look at the s390 code) where the PF to VF relationship gets lost.
