Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E63A7B1AA6
	for <lists+kvm@lfdr.de>; Thu, 28 Sep 2023 13:21:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231905AbjI1LVa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Sep 2023 07:21:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232215AbjI1LVP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Sep 2023 07:21:15 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8790119B1
        for <kvm@vger.kernel.org>; Thu, 28 Sep 2023 04:08:53 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAD93C433C7;
        Thu, 28 Sep 2023 11:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695899293;
        bh=zhiOLfJ0JfjTtUCV6Hrzae3FSoWZJkYgnCXqiKK7JR8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cLWXulnI5czMfaumpqZWI+eUFdOlXpPAuHG0uktDdCpvvZrSm4TgrGr/jmfn1EkK3
         R6OEMsqDmfN1f+F558cH/7at/dFmLNsdSFGHuSGW/LiMpYG2W23CJu4fYEkrzjkOw/
         JEOLcda2Lt7VfyyvL5HW6dpphmmv1fKva7BIVPiNTv6QjHf8GZXhvCe9FlSChEEQMp
         unysT3j4UKWS6w10FajruE3brygmGriP0iilfJurNuC2cD1V6/dB6zc0U4+vev52k4
         y08IsGqmW2aJFuzT/LZljA6Jvdb0EGXCxzRYtEGEEX0Ah/D6aCFUAQwy663KYN21Pz
         Jq17ZyqdMPReA==
Date:   Thu, 28 Sep 2023 14:08:08 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>, kvm@vger.kernel.org,
        kevin.tian@intel.com, joao.m.martins@oracle.com, maorg@nvidia.com
Subject: Re: [PATCH vfio 0/9] Add chunk mode support for mlx5 driver
Message-ID: <20230928110808.GT1642130@unreal>
References: <20230911093856.81910-1-yishaih@nvidia.com>
 <20230920183123.GJ13733@nvidia.com>
 <78298eea-b264-1739-9ded-7d8fa9c7208e@nvidia.com>
 <20230927161023.7e13c06f.alex.williamson@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230927161023.7e13c06f.alex.williamson@redhat.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 27, 2023 at 04:10:23PM -0600, Alex Williamson wrote:
> On Wed, 27 Sep 2023 13:59:06 +0300
> Yishai Hadas <yishaih@nvidia.com> wrote:
> 
> > On 20/09/2023 21:31, Jason Gunthorpe wrote:
> > > On Mon, Sep 11, 2023 at 12:38:47PM +0300, Yishai Hadas wrote:  
> > >> This series adds 'chunk mode' support for mlx5 driver upon the migration
> > >> flow.
> > >>
> > >> Before this series, we were limited to 4GB state size, as of the 4 bytes
> > >> max value based on the device specification for the query/save/load
> > >> commands.
> > >>
> > >> Once the device supports 'chunk mode' the driver can support state size
> > >> which is larger than 4GB.
> > >>
> > >> In that case, the device has the capability to split a single image to
> > >> multiple chunks as long as the software provides a buffer in the minimum
> > >> size reported by the device.
> > >>
> > >> The driver should query for the minimum buffer size required using
> > >> QUERY_VHCA_MIGRATION_STATE command with the 'chunk' bit set in its
> > >> input, in that case, the output will include both the minimum buffer
> > >> size and also the remaining total size to be reported/used where it will
> > >> be applicable.
> > >>
> > >> Upon chunk mode, there may be multiple images that will be read from the
> > >> device upon STOP_COPY. The driver will read ahead from the firmware the
> > >> full state in small/optimized chunks while letting QEMU/user space read
> > >> in parallel the available data.
> > >>
> > >> The chunk buffer size is picked up based on the minimum size that
> > >> firmware requires, the total full size and some max value in the driver
> > >> code which was set to 8MB to achieve some optimized downtime in the
> > >> general case.
> > >>
> > >> With that series in place, we could migrate successfully a device state
> > >> with a larger size than 4GB, while even improving the downtime in some
> > >> scenarios.
> > >>
> > >> Note:
> > >> As the first patch should go to net/mlx5 we may need to send it as a
> > >> pull request format to VFIO to avoid conflicts before acceptance.
> > >>
> > >> Yishai
> > >>
> > >> Yishai Hadas (9):
> > >>    net/mlx5: Introduce ifc bits for migration in a chunk mode
> > >>    vfio/mlx5: Wake up the reader post of disabling the SAVING migration
> > >>      file
> > >>    vfio/mlx5: Refactor the SAVE callback to activate a work only upon an
> > >>      error
> > >>    vfio/mlx5: Enable querying state size which is > 4GB
> > >>    vfio/mlx5: Rename some stuff to match chunk mode
> > >>    vfio/mlx5: Pre-allocate chunks for the STOP_COPY phase
> > >>    vfio/mlx5: Add support for SAVING in chunk mode
> > >>    vfio/mlx5: Add support for READING in chunk mode
> > >>    vfio/mlx5: Activate the chunk mode functionality  
> > > I didn't check in great depth but this looks OK to me
> > >
> > > Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>  
> > 
> > Thanks Jason
> > 
> > >
> > > I think this is a good design to start motivating more qmeu
> > > improvements, eg using io_uring as we could go further in the driver
> > > to optimize with that kind of support.
> > >
> > > Jason  
> > 
> > Alex,
> > 
> > Can we move forward with the series and send a PR for the first patch 
> > that needs to go also to net/mlx5 ?
> 
> Yeah, I don't spot any issues with it either.  Thanks,

Hi Alex,

I uploaded the first patch to shared branch, can you please pull it?
https://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux.git/log/?h=mlx5-vfio

Thanks

> 
> Alex
> 
> 
