Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0A3C6499CC
	for <lists+kvm@lfdr.de>; Mon, 12 Dec 2022 08:55:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231409AbiLLHzt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Dec 2022 02:55:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231213AbiLLHzr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Dec 2022 02:55:47 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C283B84D;
        Sun, 11 Dec 2022 23:55:46 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id A7EC668AA6; Mon, 12 Dec 2022 08:55:41 +0100 (CET)
Date:   Mon, 12 Dec 2022 08:55:41 +0100
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
        Konrad.wilk@oracle.com, stephen@eideticom.com, hang.yuan@intel.com,
        Oren Duer <oren@nvidia.com>
Subject: Re: [RFC PATCH 1/5] nvme-pci: add function nvme_submit_vf_cmd to
 issue admin commands for VF driver.
Message-ID: <20221212075541.GC11162@lst.de>
References: <Y4+U3VR2LeEh2S7B@ziepe.ca> <20221207075415.GB2283@lst.de> <Y5CWVu08abcOuEQH@ziepe.ca> <20221207135203.GA22803@lst.de> <Y5CsH5PqMYAWYatw@ziepe.ca> <20221207163857.GB2010@lst.de> <Y5DOAKArjyfb6Mcz@ziepe.ca> <20221207183333.GA7049@lst.de> <Y5DyorZJPdtN5WcX@ziepe.ca> <b2ade627-0abb-08a0-c28b-2bf8eb8e4973@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b2ade627-0abb-08a0-c28b-2bf8eb8e4973@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Dec 11, 2022 at 01:39:37PM +0200, Max Gurtovoy wrote:
> 1. Need to define a concept of a "virtual subsystem". A primary controller 
> will be able to create a virtual subsystem. Inside this subsystem the 
> primary controller will be the master ("the controlling") of the migration 
> process. It will also be able to add secondary controllers to this virtual 
> subsystem and assign "virtual controller ID" to it.
> something like:
> - nvme virtual_subsys_create --dev=/dev/nvme1 --virtual_nqn="my_v_nqn_1" 
> --dev_vcid = 1
> - nvme virtual_subsys_add --dev=/dev/nvme1 --virtual_nqn="my_v_nqn_1" 
> --secondary_dev=/dev/nvme2 --secondary_dev_vcid=20

Yes. Note that there is a bit more state than just the NQN.  You also
need at least a serial number, and also probably a different vendor
ID (the PCI vendor ID that is also mirror in Identify Controller and
the IEEE OUI), and new unique namespace identifier.
