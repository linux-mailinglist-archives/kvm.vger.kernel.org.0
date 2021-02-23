Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A44503230AF
	for <lists+kvm@lfdr.de>; Tue, 23 Feb 2021 19:27:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233837AbhBWS0q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Feb 2021 13:26:46 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28183 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232885AbhBWS0p (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 23 Feb 2021 13:26:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614104719;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aNQlCLzZcYzbOTIxENd+gbQNtMQVBm5Wl9PZiGh2RGw=;
        b=AqPbi7rvnplLusxNLH73L2t8NA8bD0qy9LwVBoIMfv25Q72KiM/eba+y7wzT0WJaj0Sm/n
        lLleoq7z5I2gqlDFrkCfiJ1zyKoluo98s/VP8sID4ySSLqY9CuP5GNUymRUf1mjShTn8d7
        y/k8tOPGYJ6advsE0Sl+LzNyoCyG51k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-403-_iNLiPGdPkiALx9MjROixQ-1; Tue, 23 Feb 2021 13:24:30 -0500
X-MC-Unique: _iNLiPGdPkiALx9MjROixQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AA83C80197C;
        Tue, 23 Feb 2021 18:24:28 +0000 (UTC)
Received: from omen.home.shazbot.org (ovpn-112-255.phx2.redhat.com [10.3.112.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 122F81001281;
        Tue, 23 Feb 2021 18:24:27 +0000 (UTC)
Date:   Tue, 23 Feb 2021 11:24:27 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Daniel Jordan <daniel.m.jordan@oracle.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Matthew Wilcox <willy@infradead.org>,
        Pavel Tatashin <pasha.tatashin@soleen.com>,
        Steven Sistare <steven.sistare@oracle.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/3] vfio/type1: Batch page pinning
Message-ID: <20210223112427.682b8ce9@omen.home.shazbot.org>
In-Reply-To: <20210219161305.36522-1-daniel.m.jordan@oracle.com>
References: <20210219161305.36522-1-daniel.m.jordan@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 19 Feb 2021 11:13:02 -0500
Daniel Jordan <daniel.m.jordan@oracle.com> wrote:

> v2:
>  - Fixed missing error unwind in patch 3 (Alex).  After more thought,
>    the ENODEV case is fine, so it stayed the same.
> 
>  - Rebased on linux-vfio.git/next (no conflicts).
> 
> ---
> 
> The VFIO type1 driver is calling pin_user_pages_remote() once per 4k page, so
> let's do it once per 512 4k pages to bring VFIO in line with other drivers such
> as IB and vDPA.
> 
> qemu guests with at least 2G memory start about 8% faster on a Xeon server,
> with more detailed results in the last changelog.
> 
> Thanks to Matthew, who first suggested the idea to me.
> 
> Daniel
> 
> 
> Test Cases
> ----------
> 
>  1) qemu passthrough with IOMMU-capable PCI device
> 
>  2) standalone program to hit
>         vfio_pin_map_dma() -> vfio_pin_pages_remote()
> 
>  3) standalone program to hit
>         vfio_iommu_replay() -> vfio_pin_pages_remote()
> 
> Each was run...
> 
>  - with varying sizes
>  - with/without disable_hugepages=1
>  - with/without LOCKED_VM exceeded
> 
> I didn't test vfio_pin_page_external() because there was no readily available
> hardware, but the changes there are pretty minimal.
> 
> Daniel Jordan (3):
>   vfio/type1: Change success value of vaddr_get_pfn()
>   vfio/type1: Prepare for batched pinning with struct vfio_batch
>   vfio/type1: Batch page pinning
> 
>  drivers/vfio/vfio_iommu_type1.c | 215 +++++++++++++++++++++++---------
>  1 file changed, 155 insertions(+), 60 deletions(-)
> 
> base-commit: 76adb20f924f8d27ed50d02cd29cadedb59fd88f

Applied to vfio next branch for v5.12.  Thanks,

Alex

