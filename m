Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F5F23B7DD1
	for <lists+kvm@lfdr.de>; Wed, 30 Jun 2021 09:06:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232716AbhF3HJK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Jun 2021 03:09:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232598AbhF3HJJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Jun 2021 03:09:09 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 947D4C061766;
        Wed, 30 Jun 2021 00:06:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=dsmF65Hp+Uqc28Sl8LwGXWskjtwe7+DI92hwHXbQkFA=; b=GIxFrLBhO6vSrFlIovAS3oKhAk
        2Lz/EWmV4MXClGxqw8kfRDKlmi2GtdV0uLz8GInzsTYbp/j6OaWyhAKVo1eo4a9b8H2/k56EKbDvV
        y2GtJ+TR5lnwszsDINs9HafiqdqlixqmpVUDT5RFgxU2QLLv+/cho+grL+1Vc0g8+2/SlnePBKOG7
        OLho8hViHIYAx4TUPolbnmtBlBALFzfpGJ4VyBleE5rlmpssM7wYM8+dhx4YMPSsVXI8Z8G2kF82i
        JQuions/tMg957LyjA2UxTSvzyqVxDMuHCys225WIfNum1nPw/BR1E6gHvktOeYDO7jdCSD6Jd991
        piooUF5A==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1lyUI0-0051Ka-BD; Wed, 30 Jun 2021 07:05:46 +0000
Date:   Wed, 30 Jun 2021 08:05:40 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        David Woodhouse <dwmw2@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>,
        David Gibson <david@gibson.dropbear.id.au>
Subject: Re: [RFC] /dev/ioasid uAPI proposal
Message-ID: <YNwXxAEIRz5t631E@infradead.org>
References: <20210602173510.GE1002214@nvidia.com>
 <20210602120111.5e5bcf93.alex.williamson@redhat.com>
 <20210602180925.GH1002214@nvidia.com>
 <20210602130053.615db578.alex.williamson@redhat.com>
 <20210602195404.GI1002214@nvidia.com>
 <20210602143734.72fb4fa4.alex.williamson@redhat.com>
 <6a9426d7-ed55-e006-9c4c-6b7c78142e39@redhat.com>
 <20210603130927.GZ1002214@nvidia.com>
 <65614634-1db4-7119-1a90-64ba5c6e9042@redhat.com>
 <20210604115805.GG1002214@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210604115805.GG1002214@nvidia.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 04, 2021 at 08:58:05AM -0300, Jason Gunthorpe wrote:
> On Fri, Jun 04, 2021 at 09:11:03AM +0800, Jason Wang wrote:
> > > nor do any virtio drivers implement the required platform specific
> > > cache flushing to make no-snoop TLPs work.
> > 
> > I don't get why virtio drivers needs to do that. I think DMA API should hide
> > those arch/platform specific stuffs from us.
> 
> It is not arch/platform stuff. If the device uses no-snoop then a
> very platform specific recovery is required in the device driver.

Well, the proper way to support NO_SNOOP DMA would be to force the
DMA API into supporting the device as if the platform was not DMA
coherent, probably on a per-call basis.  It is just that no one bothered
to actually do the work an people just kept piling hacks over hacks.
