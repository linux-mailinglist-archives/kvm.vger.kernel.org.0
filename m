Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DFB46449C4
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 17:55:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235453AbiLFQzM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 11:55:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231990AbiLFQzK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 11:55:10 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B9991FCC5;
        Tue,  6 Dec 2022 08:55:09 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id B56DF68B05; Tue,  6 Dec 2022 17:55:03 +0100 (CET)
Date:   Tue, 6 Dec 2022 17:55:03 +0100
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
Message-ID: <20221206165503.GA8677@lst.de>
References: <20221206055816.292304-1-lei.rao@intel.com> <20221206055816.292304-2-lei.rao@intel.com> <20221206061940.GA6595@lst.de> <Y49HKHP9NrId39iH@ziepe.ca> <20221206135810.GA27689@lst.de> <Y49eObpI7QoSnugu@ziepe.ca> <20221206153811.GB2266@lst.de> <Y49k++D3i8DfLOLL@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y49k++D3i8DfLOLL@ziepe.ca>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 06, 2022 at 11:51:23AM -0400, Jason Gunthorpe wrote:
> That is a big deviation from where VFIO is right now, the controlled
> function is the one with the VFIO driver, it should be the one that
> drives the migration uAPI components.

Well, that is one way to see it, but I think the more natural
way to deal with it is to drive everyting from the controlling
function, because that is by definition much more in control.

More importantly any sane design will have easy ways to list and
manipulate all the controlled functions from the controlling
functions, while getting from the controlled function to the
controlling one is extremely awkward, as anything that can be
used for that is by definition and information leak.  It seems
mlx5 just gets away with that by saying controlled functions are
always VFs, and the controlling function is a PF, but that will
break down very easily, especially once you want to nest the
controlling scheme (and yes, I'm not making this up, as the
nesting scheme is being proposed for nvme privately).
