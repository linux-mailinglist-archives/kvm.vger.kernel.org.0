Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2906930905B
	for <lists+kvm@lfdr.de>; Fri, 29 Jan 2021 23:59:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232691AbhA2W7V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Jan 2021 17:59:21 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:58650 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231765AbhA2W7H (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 29 Jan 2021 17:59:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611961061;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ilYqj/Eqs+vVKGKJYdOb2prTlGtcpyRbpfhc8JZqkwA=;
        b=h53oFEYW29j7ZEhRA5dEV7Y1vPjnKIbqxXxc7GAkf9mbeGjL7gG5Cci9puMID/7tx4qMHq
        IwrUsg380lM9eyVDr28Jz6H0QNmee9ragky7rhUAjBvroT25QfW1tx1HQmURmvw/Fmpzri
        1sqSYwCOGKnHkJ18U4WPDZr4DI43piQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-470-2QwcduAzPomEcd3KLlM_PA-1; Fri, 29 Jan 2021 17:57:36 -0500
X-MC-Unique: 2QwcduAzPomEcd3KLlM_PA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 42D041842164;
        Fri, 29 Jan 2021 22:57:35 +0000 (UTC)
Received: from omen.home.shazbot.org (ovpn-112-255.phx2.redhat.com [10.3.112.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6F9AB5D741;
        Fri, 29 Jan 2021 22:57:31 +0000 (UTC)
Date:   Fri, 29 Jan 2021 15:57:30 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Shenming Lu <lushenming@huawei.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Eric Auger <eric.auger@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Kevin Tian <kevin.tian@intel.com>,
        <wanghaibin.wang@huawei.com>, <yuzenghui@huawei.com>
Subject: Re: [RFC PATCH v1 0/4] vfio: Add IOPF support for VFIO passthrough
Message-ID: <20210129155730.3a1d49c5@omen.home.shazbot.org>
In-Reply-To: <20210125090402.1429-1-lushenming@huawei.com>
References: <20210125090402.1429-1-lushenming@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 25 Jan 2021 17:03:58 +0800
Shenming Lu <lushenming@huawei.com> wrote:

> Hi,
> 
> The static pinning and mapping problem in VFIO and possible solutions
> have been discussed a lot [1, 2]. One of the solutions is to add I/O
> page fault support for VFIO devices. Different from those relatively
> complicated software approaches such as presenting a vIOMMU that provides
> the DMA buffer information (might include para-virtualized optimizations),
> IOPF mainly depends on the hardware faulting capability, such as the PCIe
> PRI extension or Arm SMMU stall model. What's more, the IOPF support in
> the IOMMU driver is being implemented in SVA [3]. So do we consider to
> add IOPF support for VFIO passthrough based on the IOPF part of SVA at
> present?
> 
> We have implemented a basic demo only for one stage of translation (GPA
> -> HPA in virtualization, note that it can be configured at either stage),  
> and tested on Hisilicon Kunpeng920 board. The nested mode is more complicated
> since VFIO only handles the second stage page faults (same as the non-nested
> case), while the first stage page faults need to be further delivered to
> the guest, which is being implemented in [4] on ARM. My thought on this
> is to report the page faults to VFIO regardless of the occured stage (try
> to carry the stage information), and handle respectively according to the
> configured mode in VFIO. Or the IOMMU driver might evolve to support more...
> 
> Might TODO:
>  - Optimize the faulting path, and measure the performance (it might still
>    be a big issue).
>  - Add support for PRI.
>  - Add a MMU notifier to avoid pinning.
>  - Add support for the nested mode.
> ...
> 
> Any comments and suggestions are very welcome. :-)

I expect performance to be pretty bad here, the lookup involved per
fault is excessive.  There are cases where a user is not going to be
willing to have a slow ramp up of performance for their devices as they
fault in pages, so we might need to considering making this
configurable through the vfio interface.  Our page mapping also only
grows here, should mappings expire or do we need a least recently
mapped tracker to avoid exceeding the user's locked memory limit?  How
does a user know what to set for a locked memory limit?  The behavior
here would lead to cases where an idle system might be ok, but as soon
as load increases with more inflight DMA, we start seeing
"unpredictable" I/O faults from the user perspective.  Seems like there
are lots of outstanding considerations and I'd also like to hear from
the SVA folks about how this meshes with their work.  Thanks,

Alex

