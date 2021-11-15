Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B46C645208F
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 01:52:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350159AbhKPAzk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Nov 2021 19:55:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343652AbhKOTVd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Nov 2021 14:21:33 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D1D2C07DE6F;
        Mon, 15 Nov 2021 10:19:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=zVrBoirh2EF9+XPhCgtoyIlYq2wX2tx0m7p7r3K4JDE=; b=c0jPYjEJ2+8cqRIOPjmMalFRsM
        wIuGdLyprIZWo22GRu4eRakSjo+en3lVr5mXfg6fN3FoeQAO9uG73Nb7nfxGxONrnUAR+UwqISNpn
        oIGSMHGZKvoxd9uy7f4SLVMVKetQqzPSfg8jTxKb7zyRHVnOS/smfK4Hxe09WYAndcx5BqAXJMuP3
        +7iO0yXz9x/J7Hi5O4CGiXlGExg8uJ37Lc3dbw4LUbR/qiISVUuSWAqWIELHG+RSGpQfkRcY5HvJf
        sZkm4QHh4nad9xygINeOfTg3M9efb3+RI1XRq/Dwnqo7XPQxin/AvQry0RbC2Wv25PLusqyXo4a1g
        F1X0B+lw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mmgZL-00GeVC-IN; Mon, 15 Nov 2021 18:19:03 +0000
Date:   Mon, 15 Nov 2021 10:19:03 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Ashok Raj <ashok.raj@intel.com>, kvm@vger.kernel.org,
        rafael@kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Will Deacon <will@kernel.org>, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        linux-pci@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>
Subject: Re: [PATCH 03/11] PCI: pci_stub: Suppress kernel DMA ownership
 auto-claiming
Message-ID: <YZKkl/1GN+KgjYs6@infradead.org>
References: <20211115020552.2378167-1-baolu.lu@linux.intel.com>
 <20211115020552.2378167-4-baolu.lu@linux.intel.com>
 <YZJe1jquP+osF+Wn@infradead.org>
 <20211115133107.GB2379906@nvidia.com>
 <495c65e4-bd97-5f29-d39b-43671acfec78@arm.com>
 <20211115161756.GP2105516@nvidia.com>
 <e9db18d3-dea3-187a-d58a-31a913d95211@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e9db18d3-dea3-187a-d58a-31a913d95211@arm.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 15, 2021 at 05:54:42PM +0000, Robin Murphy wrote:
> > s/PIO/MMIO, but yes basically. And not just data trasnfer but
> > userspace can interfere with the device state as well.
> 
> Sure, but unexpected changes in device state could happen for any number of
> reasons - uncorrected ECC error, surprise removal, etc. - so if that can
> affect "kernel integrity" I'm considering it an independent problem.

Well, most DMA is triggered by the host requesting it through MMIO.
So having access to the BAR can turn many devices into somewhat
arbitrary DMA engines.

> I can see the argument from that angle, but you can equally look at it
> another way and say that a device with kernel ownership is incompatible with
> a kernel driver, if userspace can call write() on "/sys/devices/B/resource0"
> such that device A's kernel driver DMAs all over it. Maybe that particular
> example lands firmly under "just don't do that", but I'd like to figure out
> where exactly we should draw the line between "DMA" and "ability to mess
> with a device".

Userspace writing to the resourceN files with a bound driver is a mive
receipe for trouble.  Do we really allow this currently?
