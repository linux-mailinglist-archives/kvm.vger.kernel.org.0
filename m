Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 413423B7DB4
	for <lists+kvm@lfdr.de>; Wed, 30 Jun 2021 08:54:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232621AbhF3G5U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Jun 2021 02:57:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232453AbhF3G5S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Jun 2021 02:57:18 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96221C061766;
        Tue, 29 Jun 2021 23:54:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=f/Ss2iSM2QGOE0K5ddDAmgJLDWuc6gafnUUbn6I+ywE=; b=EjtYVsIFXW62/EkGI7hOZiVxWu
        WtQ1QOiJ+kE2LqSAajX/iny/lZxgDgpw4Lqlm87T+L3KdMUw9xtCm/qbkjnNm+n9HchMjHUuhlxdz
        w2OPufXyWbuv31Dot4DIGelHWZHewJ/p/raVKncRixUUmP7uchkRq1HvqmlhbTVJgHVFLODbv/YHA
        RNDQhV6qzSdLYF0g40BOD2Ta0/YGu2gzi83bR6eLmhaerMvfLzmNz8rtyEcmJ8Yhva1wvB3sNhoIm
        1xB1suxXnDYbBmr21iG+4XFobuyQO+ec3qti7Yrj8KfMA7I5Z33WvXyyfut+u94vA1XrYQhuXZ2+W
        lhuwYjjA==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1lyU6N-0050fY-DH; Wed, 30 Jun 2021 06:53:46 +0000
Date:   Wed, 30 Jun 2021 07:53:39 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        David Woodhouse <dwmw2@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Robin Murphy <robin.murphy@arm.com>,
        David Gibson <david@gibson.dropbear.id.au>
Subject: Re: [RFC] /dev/ioasid uAPI proposal
Message-ID: <YNwU801EDIJsfTqV@infradead.org>
References: <2c62b5c7-582a-c710-0436-4ac5e8fd8b39@redhat.com>
 <20210604172207.GT1002214@nvidia.com>
 <20210604152918.57d0d369.alex.williamson@redhat.com>
 <20210604230108.GB1002214@nvidia.com>
 <20210607094148.7e2341fc.alex.williamson@redhat.com>
 <20210607181858.GM1002214@nvidia.com>
 <20210607125946.056aafa2.alex.williamson@redhat.com>
 <20210607190802.GO1002214@nvidia.com>
 <20210607134128.58c2ea31.alex.williamson@redhat.com>
 <12631cf3-4ef8-7c38-73bb-649d57c0226b@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12631cf3-4ef8-7c38-73bb-649d57c0226b@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 08, 2021 at 09:20:29AM +0800, Jason Wang wrote:
> "
> 
> 6.2.17 _CCA (Cache Coherency Attribute) The _CCA object returns whether or
> not a bus-master device supports hardware managed cache coherency. Expected
> values are 0 to indicate it is not supported, and 1 to indicate that it is
> supported. All other values are reserved.
> 
> ...
> 
> On Intel platforms, if the _CCA object is not supplied, the OSPM will assume
> the devices are hardware cache coherent.
> 
> "

_CCA is mostly used on arm/arm64 platforms to figure out if a device
needs non-coherent DMA handling in the DMA API or not.  It is not
related to the NoSnoop TLPs that override the setting for an otherwise
coherent device.
