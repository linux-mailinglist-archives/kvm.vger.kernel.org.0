Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95C884B66BC
	for <lists+kvm@lfdr.de>; Tue, 15 Feb 2022 09:58:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234133AbiBOI6b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Feb 2022 03:58:31 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229997AbiBOI6a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Feb 2022 03:58:30 -0500
Received: from theia.8bytes.org (8bytes.org [IPv6:2a01:238:4383:600:38bc:a715:4b6d:a889])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 586B41133F5;
        Tue, 15 Feb 2022 00:58:20 -0800 (PST)
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 8935936D; Tue, 15 Feb 2022 09:58:18 +0100 (CET)
Date:   Tue, 15 Feb 2022 09:58:13 +0100
From:   Joerg Roedel <joro@8bytes.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Robin Murphy <robin.murphy@arm.com>,
        Stuart Yoder <stuyoder@gmail.com>, rafael@kernel.org,
        David Airlie <airlied@linux.ie>, linux-pci@vger.kernel.org,
        Thierry Reding <thierry.reding@gmail.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        Will Deacon <will@kernel.org>, Ashok Raj <ashok.raj@intel.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Cornelia Huck <cohuck@redhat.com>,
        linux-kernel@vger.kernel.org, Li Yang <leoyang.li@nxp.com>,
        iommu@lists.linux-foundation.org,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>
Subject: Re: [PATCH v1 3/8] iommu: Extend iommu_at[de]tach_device() for
 multi-device groups
Message-ID: <YgtrJVI9wGMFdPWk@8bytes.org>
References: <20220106022053.2406748-1-baolu.lu@linux.intel.com>
 <20220106022053.2406748-4-baolu.lu@linux.intel.com>
 <Ygo/eCRFnraY01WA@8bytes.org>
 <20220214130313.GV4160@nvidia.com>
 <Ygppub+Wjq6mQEAX@8bytes.org>
 <08e90a61-8491-acf1-ab0f-f93f97366d24@arm.com>
 <20220214154626.GF4160@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220214154626.GF4160@nvidia.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 14, 2022 at 11:46:26AM -0400, Jason Gunthorpe wrote:
> On Mon, Feb 14, 2022 at 03:18:31PM +0000, Robin Murphy wrote:
> 
> > Arguably, iommu_attach_device() could be renamed something like
> > iommu_attach_group_for_dev(), since that's effectively the semantic that all
> > the existing API users want anyway (even VFIO at the high level - the group
> > is the means for the user to assign their GPU/NIC/whatever device to their
> > process, not the end in itself). That's just a lot more churn.
> 
> Right

Okay, good point. I can live with an iommu_attach_group_for_dev()
interface, it is still better than making iommu_attach_device() silently
operate on whole groups.

> VFIO needs them because its uAPI is tied, but even so we keep talking
> about ways to narrow the amount of group API it consumes.
> 
> We should not set the recommended/good kAPI based on VFIOs uAPI
> design.

Agree here too. The current way groups are implemented can be turned
into a VFIO specific interface to keep its semantics and kABI. But the
IOMMU core code still needs the concept of alias groups.

Regards,

	Joerg
