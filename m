Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51059645B3C
	for <lists+kvm@lfdr.de>; Wed,  7 Dec 2022 14:47:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230077AbiLGNrK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Dec 2022 08:47:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230107AbiLGNq5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Dec 2022 08:46:57 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 549E85B5BF;
        Wed,  7 Dec 2022 05:46:55 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 9865D68BFE; Wed,  7 Dec 2022 14:46:45 +0100 (CET)
Date:   Wed, 7 Dec 2022 14:46:44 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Max Gurtovoy <mgurtovoy@nvidia.com>
Cc:     Christoph Hellwig <hch@lst.de>, Jason Gunthorpe <jgg@ziepe.ca>,
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
Message-ID: <20221207134644.GB21691@lst.de>
References: <20221206061940.GA6595@lst.de> <Y49HKHP9NrId39iH@ziepe.ca> <20221206135810.GA27689@lst.de> <Y49eObpI7QoSnugu@ziepe.ca> <20221206153811.GB2266@lst.de> <Y49k++D3i8DfLOLL@ziepe.ca> <20221206165503.GA8677@lst.de> <Y4+U3VR2LeEh2S7B@ziepe.ca> <20221207075415.GB2283@lst.de> <4f11e0bb-e090-bf9b-4f98-578273865200@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4f11e0bb-e090-bf9b-4f98-578273865200@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 07, 2022 at 12:59:00PM +0200, Max Gurtovoy wrote:
> Why is it preferred that the migration SW will talk directly to the PF and 
> not via VFIO interface ?

It should never talk directly to any hardware, but through a kernel
interface, and that's probably vfio.  But that interface needs to
centered around the controlling function for all the reasons I've
written down multiple times now.

> It's just an implementation detail.

No, it's not.  While you could come up with awkward ways to map how
the hardware interface must work to a completely contrary kernel
interface that's just going to create the need for lots of boilerplate
code _and_ confuses users.  The function that is beeing migrated can
fundamentally not be in control of itself.  Any interface that pretends
it is broken and a long term nightmare for users and implementers.

> I feel like it's even sounds more reasonable to have a common API like we 
> have today to save_state/resume_state/quiesce_device/freeze_device and each 
> device implementation will translate this functionality to its own SPEC.

Absolutely.

> If I understand your direction is to have QEMU code to talk to 
> nvmecli/new_mlx5cli/my_device_cli to do that and I'm not sure it's needed.

No.

> The controlled device is not aware of any of the migration process. Only 
> the migration SW, system admin and controlling device.

Exactly.

> So in the source:
>
> 1. We enable SRIOV on the NVMe driver

Again.  Nothing in live migration is tied to SR-IOV at all.  SR-IOV
is just one way to get multiple functions.

> 2. We list all the secondary controllers: nvme1, nvme2, nvme3
>
> 3. We allow migrating nvme1, nvme2, nvme3 - now these VFs are migratable 
> (controlling to controlled).
>
> 4. We bind nvme1, nvme2, nvme3 to VFIO NVMe driver
>
> 5. We pass these functions to VM

And you need to pass the controlling function (or rather a handle for
it), because there is absolutely no sane way to discover that from
the controlled function as it can't have that information by the
fact that it is beeing passed to unprivilged VMs.
