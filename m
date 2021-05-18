Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB82D38801E
	for <lists+kvm@lfdr.de>; Tue, 18 May 2021 20:59:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351738AbhERTAZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 May 2021 15:00:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52647 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S245447AbhERTAW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 May 2021 15:00:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621364343;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EmvqAF/tGZxnpJT45xMDZ2Iz1NsXhbJqP8uJhgy88+E=;
        b=e8E9uxQlyBwfTCyl/wNowmTI3LZESH5h39x4YndMDGKzfh2TQ+dUkQV5hsF6Cjy7tocF/U
        g/ZR9OXQvX2hZsTRphBeJmWOZyI3QKGWNU58yyfRs1L7Z1s4Xcdf1UvBefG7P+DcQ9RPn/
        0BhIa7KXyhveaF8LKEbQEuyJtP0gCzg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-501-msU198vYOKCHIds7qVJYZw-1; Tue, 18 May 2021 14:58:59 -0400
X-MC-Unique: msU198vYOKCHIds7qVJYZw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ED0AF80006E;
        Tue, 18 May 2021 18:58:56 +0000 (UTC)
Received: from redhat.com (ovpn-113-225.phx2.redhat.com [10.3.113.225])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E08931037E88;
        Tue, 18 May 2021 18:58:55 +0000 (UTC)
Date:   Tue, 18 May 2021 12:58:43 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Shenming Lu <lushenming@huawei.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Eric Auger <eric.auger@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <iommu@lists.linux-foundation.org>, <linux-api@vger.kernel.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Lu Baolu <baolu.lu@linux.intel.com>, <yi.l.liu@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Barry Song <song.bao.hua@hisilicon.com>,
        <wanghaibin.wang@huawei.com>, <yuzenghui@huawei.com>
Subject: Re: [RFC PATCH v3 1/8] iommu: Evolve the device fault reporting
 framework
Message-ID: <20210518125843.68552b67.alex.williamson@redhat.com>
In-Reply-To: <20210409034420.1799-2-lushenming@huawei.com>
References: <20210409034420.1799-1-lushenming@huawei.com>
        <20210409034420.1799-2-lushenming@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 9 Apr 2021 11:44:13 +0800
Shenming Lu <lushenming@huawei.com> wrote:

> This patch follows the discussion here:
> 
> https://lore.kernel.org/linux-acpi/YAaxjmJW+ZMvrhac@myrica/
> 
> Besides SVA/vSVA, such as VFIO may also enable (2nd level) IOPF to remove
> pinning restriction. In order to better support more scenarios of using
> device faults, we extend iommu_register_fault_handler() with flags and
> introduce FAULT_REPORT_ to describe the device fault reporting capability
> under a specific configuration.
> 
> Note that we don't further distinguish recoverable and unrecoverable faults
> by flags in the fault reporting cap, having PAGE_FAULT_REPORT_ +
> UNRECOV_FAULT_REPORT_ seems not a clean way.
> 
> In addition, still take VFIO as an example, in nested mode, the 1st level
> and 2nd level fault reporting may be configured separately and currently
> each device can only register one iommu dev fault handler, so we add a
> handler update interface for this.


IIUC, you're introducing flags for the fault handler callout, which
essentially allows the IOMMU layer to filter which types of faults the
handler can receive.  You then need an update function to modify those
flags.  Why can't the handler itself perform this filtering?  For
instance in your vfio example, the handler registered by the type1
backend could itself return fault until the fault transfer path to the
device driver is established.  Thanks,

Alex

