Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FFD34C1516
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 15:06:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241372AbiBWOHK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 09:07:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240378AbiBWOHI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 09:07:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1A1BCF7;
        Wed, 23 Feb 2022 06:06:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6EDC86163C;
        Wed, 23 Feb 2022 14:06:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51924C340E7;
        Wed, 23 Feb 2022 14:06:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645625197;
        bh=kaQNLSRDBE325nfkuijY1O4okV2QY/aI8g0iNsvKP8o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mIf5t5vUzELeIt8jiwumutbtFDinp/+l80a1tHDs4R1gZYZ9RaY/ILEy2aHbcJwmv
         6ibaQTHCFb6xh+dxniBzBQtOo/+6Ne32E//8fLOeVa69dlbrkF3TkrZ10bOBNwH9zr
         rRNHpmmNgs4iMjBiLWHjtJGKVBeAniymXOagtnkU=
Date:   Wed, 23 Feb 2022 15:06:35 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Robin Murphy <robin.murphy@arm.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>, kvm@vger.kernel.org,
        rafael@kernel.org, David Airlie <airlied@linux.ie>,
        linux-pci@vger.kernel.org,
        Thierry Reding <thierry.reding@gmail.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        Will Deacon <will@kernel.org>,
        Stuart Yoder <stuyoder@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        linux-kernel@vger.kernel.org, Li Yang <leoyang.li@nxp.com>,
        iommu@lists.linux-foundation.org,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>
Subject: Re: [PATCH v6 02/11] driver core: Add dma_cleanup callback in
 bus_type
Message-ID: <YhY/a9wTjmYXsuwt@kroah.com>
References: <YhCdEmC2lYStmUSL@infradead.org>
 <1d8004d3-1887-4fc7-08d2-0e2ee6b5fdcb@arm.com>
 <20220221234837.GA10061@nvidia.com>
 <1acb8748-8d44-688d-2380-f39ec820776f@arm.com>
 <20220222151632.GB10061@nvidia.com>
 <3d4c3bf1-fed6-f640-dc20-36d667de7461@arm.com>
 <20220222235353.GF10061@nvidia.com>
 <171bec90-5ea6-b35b-f027-1b5e961f5ddf@linux.intel.com>
 <880a269d-d39d-bab3-8d19-b493e874ec99@arm.com>
 <20220223134627.GO10061@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220223134627.GO10061@nvidia.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 23, 2022 at 09:46:27AM -0400, Jason Gunthorpe wrote:
> On Wed, Feb 23, 2022 at 01:04:00PM +0000, Robin Murphy wrote:
> 
> > 1 - tmp->driver is non-NULL because tmp is already bound.
> >   1.a - If tmp->driver->driver_managed_dma == 0, the group must currently be
> > DMA-API-owned as a whole. Regardless of what driver dev has unbound from,
> > its removal does not release someone else's DMA API (co-)ownership.
> 
> This is an uncommon locking pattern, but it does work. It relies on
> the mutex being an effective synchronization barrier for an unlocked
> store:
> 
> 				      WRITE_ONCE(dev->driver, NULL)

Only the driver core should be messing with the dev->driver pointer as
when it does so, it already has the proper locks held.  Do I need to
move that to a "private" location so that nothing outside of the driver
core can mess with it?

thanks,

greg k-h
