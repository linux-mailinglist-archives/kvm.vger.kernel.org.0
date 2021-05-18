Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F461388018
	for <lists+kvm@lfdr.de>; Tue, 18 May 2021 20:59:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351724AbhERTAW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 May 2021 15:00:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24180 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239247AbhERTAV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 May 2021 15:00:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621364342;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=62kI6pIOIPdtKW8CJ7bGGrK3d5OmdLNd14MdZWiAWKk=;
        b=C9lLPZb7fSNJFwVARtTVQxTl6hlvqvNys02zevgAh8FfkDzCGmpWHC+cgvFl7vqf1tDuBZ
        zrS/Muwwi7wtYP+TZcofUGKA7PP6qMI8g82nIFvHra7nEBhETsCjpl/bViGDSKBtaNSjCi
        dZvuTiT/z/QhOarn6Gk0B9U2MDS8JN4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-463-yWhZ7rJ4PVKo-CwT45TI7Q-1; Tue, 18 May 2021 14:58:58 -0400
X-MC-Unique: yWhZ7rJ4PVKo-CwT45TI7Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 95E3B801106;
        Tue, 18 May 2021 18:58:55 +0000 (UTC)
Received: from redhat.com (ovpn-113-225.phx2.redhat.com [10.3.113.225])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 730F61037E81;
        Tue, 18 May 2021 18:58:49 +0000 (UTC)
Date:   Tue, 18 May 2021 12:58:13 -0600
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
Subject: Re: [RFC PATCH v3 7/8] vfio/type1: Add selective DMA faulting
 support
Message-ID: <20210518125813.7b8a78f1.alex.williamson@redhat.com>
In-Reply-To: <20210409034420.1799-8-lushenming@huawei.com>
References: <20210409034420.1799-1-lushenming@huawei.com>
        <20210409034420.1799-8-lushenming@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 9 Apr 2021 11:44:19 +0800
Shenming Lu <lushenming@huawei.com> wrote:

> Some devices only allow selective DMA faulting. Similar to the selective
> dirty page tracking, the vendor driver can call vfio_pin_pages() to
> indicate the non-faultable scope, we add a new struct vfio_range to
> record it, then when the IOPF handler receives any page request out
> of the scope, we can directly return with an invalid response.

Seems like this highlights a deficiency in the design, that the user
can't specify mappings as iopf enabled or disabled.  Also, if the
vendor driver has pinned pages within the range, shouldn't that prevent
them from faulting in the first place?  Why do we need yet more
tracking structures?  Pages pinned by the vendor driver need to count
against the user's locked memory limits regardless of iopf.  Thanks,

Alex

