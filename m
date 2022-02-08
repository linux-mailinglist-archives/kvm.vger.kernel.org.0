Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82B974AD7CD
	for <lists+kvm@lfdr.de>; Tue,  8 Feb 2022 12:49:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356888AbiBHLsU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Feb 2022 06:48:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356765AbiBHLsG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Feb 2022 06:48:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE1B6C02B65B;
        Tue,  8 Feb 2022 03:36:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 10810B81852;
        Tue,  8 Feb 2022 11:35:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 177FAC004E1;
        Tue,  8 Feb 2022 11:35:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644320146;
        bh=oqAwa4TvaCnMLZq3Jlv14O8K41LAi+3ZANEnne9fz0M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=siGXsPr/vwToRWq39wEjRkdcljn1K5to7skGnrPV2dBflTsJ4s04w+5MYNHH2MLgU
         exW8whDq9BB9MMZ9ZIuzeY4a4eV6YdYNMOUqiMg/11sTiO20Zd6MjjU3BQbvTdVQFl
         OjZmXIupAGk46BOjC51jeLuv05KctkrjlzLJdQTE=
Date:   Tue, 8 Feb 2022 12:35:43 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Lu Baolu <baolu.lu@linux.intel.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Dan Williams <dan.j.williams@intel.com>, rafael@kernel.org,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Stuart Yoder <stuyoder@gmail.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Li Yang <leoyang.li@nxp.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 02/14] driver core: Add dma_cleanup callback in
 bus_type
Message-ID: <YgJVj/EmzjtR2SKk@kroah.com>
References: <20220104015644.2294354-1-baolu.lu@linux.intel.com>
 <20220104015644.2294354-3-baolu.lu@linux.intel.com>
 <YdQcpHrV7NwUv+qc@infradead.org>
 <20220104123911.GE2328285@nvidia.com>
 <YdRFyXWay/bdSSem@kroah.com>
 <608192e0-136a-57fc-cb2c-3ebb42874788@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <608192e0-136a-57fc-cb2c-3ebb42874788@linux.intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 08, 2022 at 01:55:29PM +0800, Lu Baolu wrote:
> Hi Greg,
> 
> On 1/4/22 9:04 PM, Greg Kroah-Hartman wrote:
> > On Tue, Jan 04, 2022 at 08:39:11AM -0400, Jason Gunthorpe wrote:
> > > On Tue, Jan 04, 2022 at 02:08:36AM -0800, Christoph Hellwig wrote:
> > > > All these bus callouts still looks horrible and just create tons of
> > > > boilerplate code.
> > > 
> > > Yes, Lu - Greg asked questions then didn't respond to their answers
> > > meaning he accepts them, you should stick with the v4 version.
> > 
> > Trying to catch up on emails from the break, that was way down my list
> > of things to get back to as it's messy and non-obvious.  I'll revisit it
> > again after 5.17-rc1 is out, this is too late for that merge window
> > anyway.
> 
> In this series we want to add calls into the iommu subsystem during
> device driver binding/unbinding, so that the device DMA ownership
> conflict (kernel driver vs. user-space) could be detected and avoided
> before calling into device driver's .probe().
> 
> In this v5 series, we implemented this in the affected buses (amba/
> platform/fsl-mc/pci) which are known to support assigning devices to
> user space through the vfio framework currently. And more buses are
> possible to be affected in the future if they also want to support
> device assignment. Christoph commented that this will create boilerplate
> code in various bus drivers.
> 
> Back to v4 of this series (please refer to below link [1]), we added
> this call in the driver core if buses have provided the dma_configure()
> callback (please refer to below link [2]).
> 
> Which would you prefer, or any other suggestions? We need your guide to
> move this series ahead. Please help to suggest.
> 
> [1] https://lore.kernel.org/linux-iommu/20211217063708.1740334-1-baolu.lu@linux.intel.com/
> [2] https://lore.kernel.org/linux-iommu/20211217063708.1740334-3-baolu.lu@linux.intel.com/

Let me look over the series again this afternooon.

thanks,

greg k-h
