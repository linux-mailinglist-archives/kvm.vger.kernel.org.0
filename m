Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E2C464481E
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 16:35:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234692AbiLFPfz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 10:35:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231249AbiLFPfx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 10:35:53 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E53A22B1B9;
        Tue,  6 Dec 2022 07:35:52 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id A7D6168B05; Tue,  6 Dec 2022 16:35:46 +0100 (CET)
Date:   Tue, 6 Dec 2022 16:35:46 +0100
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
Subject: Re: [RFC PATCH 5/5] nvme-vfio: Add a document for the NVMe device
Message-ID: <20221206153546.GA2266@lst.de>
References: <20221206062604.GB6595@lst.de> <Y48+AaG5rSCviIhl@ziepe.ca> <20221206130901.GB24358@lst.de> <Y49JNvdmRPNWw26q@ziepe.ca> <20221206140002.GB27689@lst.de> <Y49PqoAhZOeraLVa@ziepe.ca> <20221206143126.GB30297@lst.de> <Y49WNo7XWZ2aFfds@ziepe.ca> <20221206150131.GA32365@lst.de> <Y49fjFD6foGorhmp@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y49fjFD6foGorhmp@ziepe.ca>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 06, 2022 at 11:28:12AM -0400, Jason Gunthorpe wrote:
> I'm interested as well, my mental model goes as far as mlx5 and
> hisillicon, so if nvme prevents the VFs from being contained units, it
> is a really big deviation from VFIO's migration design..

In NVMe the controller (which maps to a PCIe physical or virtual
function) is unfortunately not very self contained.  A lot of
state is subsystem-wide, where the subsystem is, roughly speaking,
the container for all controllers that shared storage.  That is
the right thing to do for say dual ported SSDs that are used for
clustering or multi-pathing, for tentant isolation is it about
as wrong as it gets.

There is nothing in the NVMe spec that prohibits your from
implementing multiple subsystems for multiple functions of a PCIe
device, but if you do that there is absolutely no support in the
spec to manage shared resources or any other interaction between
them.
