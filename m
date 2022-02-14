Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 138134B51BD
	for <lists+kvm@lfdr.de>; Mon, 14 Feb 2022 14:37:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351329AbiBNNh3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 08:37:29 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348560AbiBNNh1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 08:37:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AA3A4E39C;
        Mon, 14 Feb 2022 05:37:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 16921614EC;
        Mon, 14 Feb 2022 13:37:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C20AFC340E9;
        Mon, 14 Feb 2022 13:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644845838;
        bh=Oxsn32h7Ub8qAbBy4j6/5jsGWbDXxu1IwJ0TFbQG4Mc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ONb88kmbVsCjwLYnVQN7fyimKn4PW5jYGIgQp9B3El5czr7hq89ykSx0/9NkQmjT9
         y3ZEr/oKkODfMeAHtHkbRHpArLA0nGtK1BtK1bQSnLR4gDFaKfXtZmPOAozVZpPWX4
         gUu9W97fmAjB6K0PHkAlblLuyNeoM4eTHDmQXe20=
Date:   Mon, 14 Feb 2022 14:37:15 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Christoph Hellwig <hch@infradead.org>,
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
Subject: Re: [PATCH v5 04/14] driver core: platform: Add driver dma ownership
 management
Message-ID: <YgpbC1u6YFN4GefB@kroah.com>
References: <20220104015644.2294354-1-baolu.lu@linux.intel.com>
 <20220104015644.2294354-5-baolu.lu@linux.intel.com>
 <YgooFjSWLTSapuIs@kroah.com>
 <20220214131853.GY4160@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220214131853.GY4160@nvidia.com>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 14, 2022 at 09:18:53AM -0400, Jason Gunthorpe wrote:
> On Mon, Feb 14, 2022 at 10:59:50AM +0100, Greg Kroah-Hartman wrote:
> 
> > > +	if (ret && !drv->no_kernel_api_dma)
> > > +		iommu_device_unuse_dma_api(dev);
> > 
> > So you are now going to call this for every platform driver _unless_
> > they set this flag?
> 
> Yes, it is necessary because VFIO supports platform devices as well
> and needs to ensure security. Conflicting kernel driver attachements
> must be blocked, just like for PCI.

A platform device shouldn't be using VFIO, but ugh, oh well, that ship
has sailed :(

And stop it with the "security" mess, do not give people a false sense
of it here please.

thanks,

greg k-h
