Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CED0913721A
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2020 17:04:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728554AbgAJQDR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jan 2020 11:03:17 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:49412 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728441AbgAJQDR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jan 2020 11:03:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578672196;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OPSR2mIQIOiig6JFjS6VbfWRplkUrgJKyJfU2ImkazE=;
        b=NUv03NeJ7YjhoxqNHSPIPrPpY1ewGEiryiR9U3bWW73oMSkrln/qmVnJ0y07Q8KYGv0dIN
        FmDD3RljOlt9Utw8274VObXoJmqnSXn2Ea2hZpaw869KNhSolW1E7ufy2ZQWUC1YW66+Ql
        iTeclSrYTkHyEq9zGFN5FMqwSMzAa7k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-12-4Ow0hfPtPAC5kkXJwz8rsQ-1; Fri, 10 Jan 2020 11:03:13 -0500
X-MC-Unique: 4Ow0hfPtPAC5kkXJwz8rsQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5EB75107ACC5;
        Fri, 10 Jan 2020 16:03:11 +0000 (UTC)
Received: from x1.home (ovpn-116-128.phx2.redhat.com [10.3.116.128])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 70B1280680;
        Fri, 10 Jan 2020 16:03:10 +0000 (UTC)
Date:   Fri, 10 Jan 2020 09:03:06 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Alexey Kardashevskiy <aik@ozlabs.ru>
Cc:     linuxppc-dev@lists.ozlabs.org,
        David Gibson <david@gibson.dropbear.id.au>,
        kvm-ppc@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH kernel] vfio/spapr/nvlink2: Skip unpinning pages on
 error exit
Message-ID: <20200110090306.04683f3c@x1.home>
In-Reply-To: <20191223010927.79843-1-aik@ozlabs.ru>
References: <20191223010927.79843-1-aik@ozlabs.ru>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 23 Dec 2019 12:09:27 +1100
Alexey Kardashevskiy <aik@ozlabs.ru> wrote:

> The nvlink2 subdriver for IBM Witherspoon machines preregisters
> GPU memory in the IOMMI API so KVM TCE code can map this memory
> for DMA as well. This is done by mm_iommu_newdev() called from
> vfio_pci_nvgpu_regops::mmap.
> 
> In an unlikely event of failure the data->mem remains NULL and
> since mm_iommu_put() (which unregisters the region and unpins memory
> if that was regular memory) does not expect mem==NULL, it should not be
> called.
> 
> This adds a check to only call mm_iommu_put() for a valid data->mem.
> 
> Fixes: 7f92891778df ("vfio_pci: Add NVIDIA GV100GL [Tesla V100 SXM2] subdriver")
> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
> ---
>  drivers/vfio/pci/vfio_pci_nvlink2.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_nvlink2.c b/drivers/vfio/pci/vfio_pci_nvlink2.c
> index f2983f0f84be..3f5f8198a6bb 100644
> --- a/drivers/vfio/pci/vfio_pci_nvlink2.c
> +++ b/drivers/vfio/pci/vfio_pci_nvlink2.c
> @@ -97,8 +97,10 @@ static void vfio_pci_nvgpu_release(struct vfio_pci_device *vdev,
>  
>  	/* If there were any mappings at all... */
>  	if (data->mm) {
> -		ret = mm_iommu_put(data->mm, data->mem);
> -		WARN_ON(ret);
> +		if (data->mem) {
> +			ret = mm_iommu_put(data->mm, data->mem);
> +			WARN_ON(ret);
> +		}
>  
>  		mmdrop(data->mm);
>  	}

Applied to vfio next branch for v5.6.  Thanks,

Alex

