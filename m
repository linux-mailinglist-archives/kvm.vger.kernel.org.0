Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D0E34B4CDE
	for <lists+kvm@lfdr.de>; Mon, 14 Feb 2022 12:11:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349252AbiBNKt6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 05:49:58 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349291AbiBNKtS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 05:49:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12A37BF963;
        Mon, 14 Feb 2022 02:12:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A2EE660FF2;
        Mon, 14 Feb 2022 10:12:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DDDFC340E9;
        Mon, 14 Feb 2022 10:12:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644833547;
        bh=M0BF1S8k6P4/h+amgHnnMxnmmzIHRn78qIWiqCZMTt8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UptKleNcc93DXh/8y4no+0p/Hl1XMjhGS2P6HwvH72Ql1NOdZNhK9XngXZl8Yka7F
         VtmDV+JhrV/j6jL06nHWv0qvL3jHnPEvB9jfc+o2GYj/i76xty+/rY6wLh03YjI1KQ
         IiTVtb8hFbVl3YncHAyB2BfGYzLSu8S3+nPbDfhk=
Date:   Mon, 14 Feb 2022 11:02:28 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Lu Baolu <baolu.lu@linux.intel.com>
Cc:     Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
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
Subject: Re: [PATCH v5 02/14] driver core: Add dma_cleanup callback in
 bus_type
Message-ID: <YgootGL4aL+XRE/J@kroah.com>
References: <20220104015644.2294354-1-baolu.lu@linux.intel.com>
 <20220104015644.2294354-3-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220104015644.2294354-3-baolu.lu@linux.intel.com>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 04, 2022 at 09:56:32AM +0800, Lu Baolu wrote:
> The bus_type structure defines dma_configure() callback for bus drivers
> to configure DMA on the devices. This adds the paired dma_cleanup()
> callback and calls it during driver unbinding so that bus drivers can do
> some cleanup work.
> 
> One use case for this paired DMA callbacks is for the bus driver to check
> for DMA ownership conflicts during driver binding, where multiple devices
> belonging to a same IOMMU group (the minimum granularity of isolation and
> protection) may be assigned to kernel drivers or user space respectively.
> 
> Without this change, for example, the vfio driver has to listen to a bus
> BOUND_DRIVER event and then BUG_ON() in case of dma ownership conflict.
> This leads to bad user experience since careless driver binding operation
> may crash the system if the admin overlooks the group restriction. Aside
> from bad design, this leads to a security problem as a root user, even with
> lockdown=integrity, can force the kernel to BUG.
> 
> With this change, the bus driver could check and set the DMA ownership in
> driver binding process and fail on ownership conflicts. The DMA ownership
> should be released during driver unbinding.
> 
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
