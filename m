Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07AAB644520
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 14:58:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233467AbiLFN6X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 08:58:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230093AbiLFN6V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 08:58:21 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0881E203;
        Tue,  6 Dec 2022 05:58:19 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id DF0C268B05; Tue,  6 Dec 2022 14:58:10 +0100 (CET)
Date:   Tue, 6 Dec 2022 14:58:10 +0100
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
Message-ID: <20221206135810.GA27689@lst.de>
References: <20221206055816.292304-1-lei.rao@intel.com> <20221206055816.292304-2-lei.rao@intel.com> <20221206061940.GA6595@lst.de> <Y49HKHP9NrId39iH@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y49HKHP9NrId39iH@ziepe.ca>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 06, 2022 at 09:44:08AM -0400, Jason Gunthorpe wrote:
> Not speaking to NVMe - but this driver is clearly copying mlx5's live
> migration driver, almost completely - including this basic function.

Maybe that's not a good idea in an NVMe environment, and maybe that
should have talked to the standards committee before spending their
time on cargo cult engineering.

Most importantly NVMe is very quiet on the relationship between
VFs and PFs, and there is no way to guarantee that a PF is, at the
NVMe level, much in control of a VF at all.  In other words this
concept really badly breaks NVMe abstractions.

> Thus, mxl5 has the same sort of design where the VF VFIO driver
> reaches into the PF kernel driver and asks the PF driver to perform
> some commands targeting the PF's own VFs. The DMA is then done using
> the RID of the PF, and reaches the kernel owned iommu_domain of the
> PF. This way the entire operation is secure aginst meddling by the
> guest.

And the works for you because you have a clearly defined relationship.
In NVMe we do not have this.  We'd either need to define a way
to query that relationship or find another way to deal with the
problem.  But in doubt the best design would be to drive VF
live migration entirely from the PF, turn the lookup from controlled
function to controlling function upside down, that is a list of
controlled functions (which could very well be, and in some designs
are, additional PFs and not VFs) by controlling function.  In fact
NVMe already has that list in it's architecture with the
"Secondary Controller List".
