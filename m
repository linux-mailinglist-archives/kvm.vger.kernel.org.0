Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87FF838F572
	for <lists+kvm@lfdr.de>; Tue, 25 May 2021 00:12:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234004AbhEXWN0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 18:13:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23328 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233969AbhEXWNV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 May 2021 18:13:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621894312;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bUla4T9MuJZxERVs6XqEyftaAb31ccR2xj+puFqVVW8=;
        b=HGEwMEp+0DkAXQFsCujkhtLz7YFitTSidWRDm+65XtKv2Xh08wZ6t2j/kfeTxR6fjrgEXy
        JBX+e5fI9jt6ZuFZ13Du7S8DBXYsdnoexvMCI9jCQ078f1tyIUxSVO03/f16mrMuF/sLjC
        8MeaUroHez2HBx0JHV66QgnOi+gMBCg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-469-fIDzMO5AMui_CYToRjykfw-1; Mon, 24 May 2021 18:11:48 -0400
X-MC-Unique: fIDzMO5AMui_CYToRjykfw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F3220803622;
        Mon, 24 May 2021 22:11:45 +0000 (UTC)
Received: from x1.home.shazbot.org (ovpn-113-225.phx2.redhat.com [10.3.113.225])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 366BD5C6AB;
        Mon, 24 May 2021 22:11:45 +0000 (UTC)
Date:   Mon, 24 May 2021 16:11:36 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Shenming Lu <lushenming@huawei.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, Will Deacon <will@kernel.org>,
        "Robin Murphy" <robin.murphy@arm.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Jean-Philippe Brucker" <jean-philippe@linaro.org>,
        Eric Auger <eric.auger@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <iommu@lists.linux-foundation.org>, <linux-api@vger.kernel.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Lu Baolu <baolu.lu@linux.intel.com>, <yi.l.liu@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        "Barry Song" <song.bao.hua@hisilicon.com>,
        <wanghaibin.wang@huawei.com>, <yuzenghui@huawei.com>
Subject: Re: [RFC PATCH v3 0/8] Add IOPF support for VFIO passthrough
Message-ID: <20210524161136.03e9323d@x1.home.shazbot.org>
In-Reply-To: <accfb404-1d7b-8d73-6fb7-50011a3e546f@huawei.com>
References: <20210409034420.1799-1-lushenming@huawei.com>
        <20210518125756.4c075300.alex.williamson@redhat.com>
        <accfb404-1d7b-8d73-6fb7-50011a3e546f@huawei.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 21 May 2021 14:37:21 +0800
Shenming Lu <lushenming@huawei.com> wrote:

> Hi Alex,
> 
> On 2021/5/19 2:57, Alex Williamson wrote:
> > On Fri, 9 Apr 2021 11:44:12 +0800
> > Shenming Lu <lushenming@huawei.com> wrote:
> >   
> >> Hi,
> >>
> >> Requesting for your comments and suggestions. :-)
> >>
> >> The static pinning and mapping problem in VFIO and possible solutions
> >> have been discussed a lot [1, 2]. One of the solutions is to add I/O
> >> Page Fault support for VFIO devices. Different from those relatively
> >> complicated software approaches such as presenting a vIOMMU that provides
> >> the DMA buffer information (might include para-virtualized optimizations),
> >> IOPF mainly depends on the hardware faulting capability, such as the PCIe
> >> PRI extension or Arm SMMU stall model. What's more, the IOPF support in
> >> the IOMMU driver has already been implemented in SVA [3]. So we add IOPF
> >> support for VFIO passthrough based on the IOPF part of SVA in this series.  
> > 
> > The SVA proposals are being reworked to make use of a new IOASID
> > object, it's not clear to me that this shouldn't also make use of that
> > work as it does a significant expansion of the type1 IOMMU with fault
> > handlers that would duplicate new work using that new model.  
> 
> It seems that the IOASID extension for guest SVA would not affect this series,
> will we do any host-guest IOASID translation in the VFIO fault handler?

Surely it will, we don't currently have any IOMMU fault handling or
forwarding of IOMMU faults through to the vfio bus driver, both of
those would be included in an IOASID implementation.  I think Jason's
vision is to use IOASID to deprecate type1 for all use cases, so even
if we were to choose to implement IOPF in type1 we should agree on
common interfaces with IOASID.
 
> >> We have measured its performance with UADK [4] (passthrough an accelerator
> >> to a VM(1U16G)) on Hisilicon Kunpeng920 board (and compared with host SVA):
> >>
> >> Run hisi_sec_test...
> >>  - with varying sending times and message lengths
> >>  - with/without IOPF enabled (speed slowdown)
> >>
> >> when msg_len = 1MB (and PREMAP_LEN (in Patch 4) = 1):
> >>             slowdown (num of faults)
> >>  times      VFIO IOPF      host SVA
> >>  1          63.4% (518)    82.8% (512)
> >>  100        22.9% (1058)   47.9% (1024)
> >>  1000       2.6% (1071)    8.5% (1024)
> >>
> >> when msg_len = 10MB (and PREMAP_LEN = 512):
> >>             slowdown (num of faults)
> >>  times      VFIO IOPF
> >>  1          32.6% (13)
> >>  100        3.5% (26)
> >>  1000       1.6% (26)  
> > 
> > It seems like this is only an example that you can make a benchmark
> > show anything you want.  The best results would be to pre-map
> > everything, which is what we have without this series.  What is an
> > acceptable overhead to incur to avoid page pinning?  What if userspace
> > had more fine grained control over which mappings were available for
> > faulting and which were statically mapped?  I don't really see what
> > sense the pre-mapping range makes.  If I assume the user is QEMU in a
> > non-vIOMMU configuration, pre-mapping the beginning of each RAM section
> > doesn't make any logical sense relative to device DMA.  
> 
> As you said in Patch 4, we can introduce full end-to-end functionality
> before trying to improve performance, and I will drop the pre-mapping patch
> in the current stage...
> 
> Is there a need that userspace wants more fine grained control over which
> mappings are available for faulting? If so, we may evolve the MAP ioctl
> to support for specifying the faulting range.

You're essentially enabling this for a vfio bus driver via patch 7/8,
pinning for selective DMA faulting.  How would a driver in userspace
make equivalent requests?  In the case of performance, the user could
mlock the page but they have no mechanism here to pre-fault it.  Should
they?

> As for the overhead of IOPF, it is unavoidable if enabling on-demand paging
> (and page faults occur almost only when first accessing), and it seems that
> there is a large optimization space compared to CPU page faulting.

Yes, there's of course going to be overhead in terms of latency for the
page faults.  My point was more that when a host is not under memory
pressure we should trend towards the performance of pinned, static
mappings and we should be able to create arbitrarily large pre-fault
behavior to show that.  But I think what we really want to enable via
IOPF is density, right?  Therefore how many more assigned device guests
can you run on a host with IOPF?  How does the slope, plateau, and
inflection point of their aggregate throughput compare to static
pinning?  VM startup time is probably also a useful metric, ie. trading
device latency for startup latency.  Thanks,

Alex

