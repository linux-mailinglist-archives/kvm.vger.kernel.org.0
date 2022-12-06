Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFF306444F3
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 14:51:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234594AbiLFNvo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 08:51:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231866AbiLFNvm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 08:51:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D8122A942;
        Tue,  6 Dec 2022 05:51:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 82F8961764;
        Tue,  6 Dec 2022 13:51:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1752EC433C1;
        Tue,  6 Dec 2022 13:51:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670334699;
        bh=T0tECl+xmG6w0G2M4NSz1zr6ar6ZtXwJiCFE6TbkrEE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mZi7gMbq8B+FXS/1OuUYuWdkweUmNL/lhM3MJDJshCQ6/juDh+jZcL+KhtmNXqlau
         7LIZfO4dgwQ181y4DwAUq6112FGbvoAjAqw0Tt+808kN0e+AldDa6wYaUb6RxCEDvs
         R0mCO6+70yfykLt1ZqHUvoJgDEsVt9Dkp21s75OSyURs/pdG17cv+Ly5KuoKA4Svk1
         8YZZs2TG+M7+HG1Kef00M2Kqfh0e8r3AhTD7x2w4QUMkFZMeHvHR3gm8isTHndWkcN
         5AKf100eN2p2Bem082iu/A8UIhNMrbhxE2hK9hwVZBLNdwLlMza2lhzdB3xb2PCh2O
         8KZzypuFsEaWQ==
Date:   Tue, 6 Dec 2022 13:51:32 +0000
From:   Keith Busch <kbusch@kernel.org>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Christoph Hellwig <hch@lst.de>, Lei Rao <lei.rao@intel.com>,
        axboe@fb.com, kch@nvidia.com, sagi@grimberg.me,
        alex.williamson@redhat.com, cohuck@redhat.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        mjrosato@linux.ibm.com, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org, kvm@vger.kernel.org,
        eddie.dong@intel.com, yadong.li@intel.com, yi.l.liu@intel.com,
        Konrad.wilk@oracle.com, stephen@eideticom.com, hang.yuan@intel.com
Subject: Re: [RFC PATCH 1/5] nvme-pci: add function nvme_submit_vf_cmd to
 issue admin commands for VF driver.
Message-ID: <Y49I5MRsgHdNkIff@kbusch-mbp>
References: <20221206055816.292304-1-lei.rao@intel.com>
 <20221206055816.292304-2-lei.rao@intel.com>
 <20221206061940.GA6595@lst.de>
 <Y49HKHP9NrId39iH@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y49HKHP9NrId39iH@ziepe.ca>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 06, 2022 at 09:44:08AM -0400, Jason Gunthorpe wrote:
> On Tue, Dec 06, 2022 at 07:19:40AM +0100, Christoph Hellwig wrote:
> > On Tue, Dec 06, 2022 at 01:58:12PM +0800, Lei Rao wrote:
> > > The new function nvme_submit_vf_cmd() helps the host VF driver to issue
> > > VF admin commands. It's helpful in some cases that the host NVMe driver
> > > does not control VF's admin queue. For example, in the virtualization
> > > device pass-through case, the VF controller's admin queue is governed
> > > by the Guest NVMe driver. Host VF driver relies on PF device's admin
> > > queue to control VF devices like vendor-specific live migration commands.
> > 
> > WTF are you even smoking when you think this would be acceptable?
> 
> Not speaking to NVMe - but this driver is clearly copying mlx5's live
> migration driver, almost completely - including this basic function.
> 
> So, to explain why mlx5 works this way..
> 
> The VFIO approach is to fully assign an entire VF to the guest OS. The
> entire VF assignment means every MMIO register *and all the DMA* of
> the VF is owned by the guest operating system.
> 
> mlx5 needs to transfer hundreds of megabytes to gigabytes of in-device
> state to perform a migration.

For storage, though, you can't just transfer the controller state. You have to
transfer all the namespace user data, too. So potentially many terabytes?
