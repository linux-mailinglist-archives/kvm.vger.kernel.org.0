Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFA363B7D9B
	for <lists+kvm@lfdr.de>; Wed, 30 Jun 2021 08:49:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232487AbhF3GwO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Jun 2021 02:52:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232018AbhF3GwO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Jun 2021 02:52:14 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF4BCC061766;
        Tue, 29 Jun 2021 23:49:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=b+svzs78j/62UsetKE/X8fy/L/Rti/5BS8qNFSo3AdY=; b=YvWJ06tpNI/PQXlniltz4HwA3w
        qvb35mtIRc7zoasrxSW0mwsdp8zrl4IJSUR7/UExaPp/G8HsbZqhmZlr4ASbIIp59RN4JH3VQh7fp
        xHEDUrkCCy2uCHpgfbSjVyKOkg4PTOCvVF4Enjph0VlxcF4zTLWkTlRaISyXvZB/VwmOM3y+FpBoV
        6qZoJl6WMlxndz8lCibcQIqcC5UECay58H2CbwSkj9LoPW1VLcWhEzsZrRfGx/73bje+xZPfyhKNH
        lVnlsQnRDYwDqRdQZanFGZ7dwRrA4fkXGgnVrpwNPbUCu1xejZSK9SK+jWBqCRn8QlyeNiYye6v4P
        Swb3eHsA==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1lyU1x-0050Oj-1M; Wed, 30 Jun 2021 06:49:09 +0000
Date:   Wed, 30 Jun 2021 07:49:05 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        David Woodhouse <dwmw2@infradead.org>,
        Jason Wang <jasowang@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Robin Murphy <robin.murphy@arm.com>,
        David Gibson <david@gibson.dropbear.id.au>
Subject: Re: [RFC] /dev/ioasid uAPI proposal
Message-ID: <YNwT4eO2LCIEXyiq@infradead.org>
References: <30e5c597-b31c-56de-c75e-950c91947d8f@redhat.com>
 <20210604160336.GA414156@nvidia.com>
 <2c62b5c7-582a-c710-0436-4ac5e8fd8b39@redhat.com>
 <20210604172207.GT1002214@nvidia.com>
 <20210604152918.57d0d369.alex.williamson@redhat.com>
 <20210604230108.GB1002214@nvidia.com>
 <20210607094148.7e2341fc.alex.williamson@redhat.com>
 <20210607181858.GM1002214@nvidia.com>
 <20210607125946.056aafa2.alex.williamson@redhat.com>
 <20210607190802.GO1002214@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210607190802.GO1002214@nvidia.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 07, 2021 at 04:08:02PM -0300, Jason Gunthorpe wrote:
> Compatibility is important, but when I look in the kernel code I see
> very few places that call wbinvd(). Basically all DRM for something
> relavent to qemu.
> 
> That tells me that the vast majority of PCI devices do not generate
> no-snoop traffic.

Part of it is that we have no general API for it, because the DRM folks
as usual just tarted piling up local hacks instead of introducing
a proper API..
