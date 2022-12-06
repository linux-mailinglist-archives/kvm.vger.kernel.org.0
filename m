Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E059644827
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 16:38:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235164AbiLFPiW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 10:38:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235053AbiLFPiT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 10:38:19 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF33A29C89;
        Tue,  6 Dec 2022 07:38:16 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 832A468B05; Tue,  6 Dec 2022 16:38:11 +0100 (CET)
Date:   Tue, 6 Dec 2022 16:38:11 +0100
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
Message-ID: <20221206153811.GB2266@lst.de>
References: <20221206055816.292304-1-lei.rao@intel.com> <20221206055816.292304-2-lei.rao@intel.com> <20221206061940.GA6595@lst.de> <Y49HKHP9NrId39iH@ziepe.ca> <20221206135810.GA27689@lst.de> <Y49eObpI7QoSnugu@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y49eObpI7QoSnugu@ziepe.ca>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 06, 2022 at 11:22:33AM -0400, Jason Gunthorpe wrote:
> > controlled functions (which could very well be, and in some designs
> > are, additional PFs and not VFs) by controlling function.  
> 
> In principle PF vs VF doesn't matter much - the question is really TLP
> labeling. If the spec says RID A is the controlling RID and RID B is
> the guest RID, then it doesn't matter if they have a PF/VF
> relationship or PF/PF relationship.

Yes.  Or in fact if you use PASIDs inside a single function.

> We have locking issues in Linux SW connecting different SW drivers for
> things that are not a PF/VF relationship, but perhaps that can be
> solved.

And I think the only reasonable answer is that the entire workflow
must be 100% managed from the controlling function, and the controlled
function is just around for a ride, with the controlling function
enabling/disabling it as needed without ever interacting with software
that directly deals with the controlled function.
