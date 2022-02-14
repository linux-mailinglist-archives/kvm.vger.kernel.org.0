Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 937C34B537D
	for <lists+kvm@lfdr.de>; Mon, 14 Feb 2022 15:40:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355241AbiBNOkF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 09:40:05 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237294AbiBNOkF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 09:40:05 -0500
X-Greylist: delayed 11567 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 14 Feb 2022 06:39:56 PST
Received: from theia.8bytes.org (8bytes.org [81.169.241.247])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FC20488AB;
        Mon, 14 Feb 2022 06:39:56 -0800 (PST)
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 2F194374; Mon, 14 Feb 2022 15:39:54 +0100 (CET)
Date:   Mon, 14 Feb 2022 15:39:53 +0100
From:   Joerg Roedel <joro@8bytes.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Lu Baolu <baolu.lu@linux.intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Christoph Hellwig <hch@infradead.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Will Deacon <will@kernel.org>,
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
Subject: Re: [PATCH v1 3/8] iommu: Extend iommu_at[de]tach_device() for
 multi-device groups
Message-ID: <Ygppub+Wjq6mQEAX@8bytes.org>
References: <20220106022053.2406748-1-baolu.lu@linux.intel.com>
 <20220106022053.2406748-4-baolu.lu@linux.intel.com>
 <Ygo/eCRFnraY01WA@8bytes.org>
 <20220214130313.GV4160@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220214130313.GV4160@nvidia.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 14, 2022 at 09:03:13AM -0400, Jason Gunthorpe wrote:
> Groups should disappear into an internal implementation detail, not be
> so prominent in the API.

Not going to happen, IOMMU groups are ABI and todays device assignment
code, including user-space, relies on them.

Groups implement and important aspect of hardware IOMMUs that the API
can not abstract away: That there are devices which share the same
request-id. 

This is not an issue for devices concerned by iommufd, but for legacy
device assignment it is. The IOMMU-API needs to handle both in a clean
API, even if it means that drivers need to lookup the sub-group of a
device first.

And I don't see how a per-device API can handle both in a device-centric
way. For sure it is not making it 'device centric but operate on groups
under the hood'.

Regards,

	Joerg
